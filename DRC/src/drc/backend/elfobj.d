/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) ?-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/elfobj.d, backend/elfobj.d)
 */

module drc.backend.elfobj;

/****
 * Output to ELF объект files
 * http://www.sco.com/developers/gabi/2003-12-17/ch4.sheader.html
 */

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



static if (ELFOBJ)
{

import drc.backend.dwarf;
import drc.backend.melf;

extern бул symbol_iscomdat2(Symbol* s);

static if (TARGET_LINUX)
    const ELFOSABI = ELFOSABI_LINUX;
else static if (TARGET_FREEBSD)
    const ELFOSABI = ELFOSABI_FREEBSD;
else static if (TARGET_SOLARIS)
    const ELFOSABI = ELFOSABI_SYSV;
else static if (TARGET_OPENBSD)
    const ELFOSABI = ELFOSABI_OPENBSD;
else static if (TARGET_DRAGONFLYBSD)
    const ELFOSABI = ELFOSABI_SYSV;
else
    static assert(0, "No ELF OS ABI defined.  Please fix");

//#define DEBSYM 0x7E

private  Outbuffer *fobjbuf;

const MATCH_SECTION = 1;

const DEST_LEN = (IDMAX + IDOHD + 1);
сим *obj_mangle2(Symbol *s,сим *dest, т_мера *destlen);

version (Dinrus)
// C++ имя mangling is handled by front end
ткст0 cpp_mangle2(Symbol* s) { return s.Sident.ptr; }
else
ткст0 cpp_mangle2(Symbol* s) { return cpp_mangle(s); }


проц addSegmentToComdat(segidx_t seg, segidx_t comdatseg);

/**
 * If set the compiler requires full druntime support of the new
 * section registration.
 */
//version (DMDV2)
static if (1)
    const DMDV2 = да;
else
    const DMDV2 = нет;
const REQUIRE_DSO_REGISTRY = (DMDV2 && (TARGET_LINUX || TARGET_FREEBSD || TARGET_DRAGONFLYBSD));

/**
 * If set, produce .init_array/.fini_array instead of legacy .ctors/.dtors .
 * OpenBSD added the support in Aug 2016. Other supported platforms has
 * supported .init_array for years.
 */
const USE_INIT_ARRAY = !TARGET_OPENBSD;

/******
 * FreeBSD uses ELF, but the linker crashes with Elf comdats with the following message:
 *  /usr/bin/ld: BFD 2.15 [FreeBSD] 2004-05-23 internal error, aborting at
 *  /usr/src/gnu/usr.bin/binutils/libbfd/../../../../contrib/binutils/bfd/elfcode.h
 *  line 213 in bfd_elf32_swap_symbol_out
 * For the time being, just stick with Linux.
 */

const ELF_COMDAT = TARGET_LINUX;

/***************************************************
 * Correspondence of relocation types
 *      386             32 bit in 64      64 in 64
 *      R_386_32        R_X86_64_32       R_X86_64_64
 *      R_386_GOTOFF    R_X86_64_PC32     R_X86_64_
 *      R_386_GOTPC     R_X86_64_         R_X86_64_
 *      R_386_GOT32     R_X86_64_         R_X86_64_
 *      R_386_TLS_GD    R_X86_64_TLSGD    R_X86_64_
 *      R_386_TLS_IE    R_X86_64_GOTTPOFF R_X86_64_
 *      R_386_TLS_LE    R_X86_64_TPOFF32  R_X86_64_
 *      R_386_PLT32     R_X86_64_PLT32    R_X86_64_
 *      R_386_PC32      R_X86_64_PC32     R_X86_64_
 */

alias бцел reltype_t;

/******************************************
 */

private  Symbol *GOTsym; // глоб2 смещение table reference

private Symbol *Obj_getGOTsym()
{
    if (!GOTsym)
    {
        GOTsym = symbol_name("_GLOBAL_OFFSET_TABLE_",SCglobal,tspvoid);
    }
    return GOTsym;
}

проц Obj_refGOTsym()
{
    if (!GOTsym)
    {
        Symbol *s = Obj_getGOTsym();
        Obj_external(s);
    }
}

//private проц objfile_write(FILE *fd, проц *буфер, бцел len);

// The объект файл is built is several separate pieces

// Non-repeatable section types have single output buffers
//      Pre-allocated buffers are defined for:
//              Section Names ткст table
//              Section Headers table
//              Symbol table
//              String table
//              Notes section
//              Comment данные

// Section Names  - String table for section имена only
private  Outbuffer *section_names;
const SEC_NAMES_INIT = 800;
const SEC_NAMES_INC  = 400;

// Hash table for section_names
 AApair *section_names_hashtable;

 цел jmpseg;

/* ======================================================================== */

// String Table  - String table for all other имена
private  Outbuffer *symtab_strings;


// Section Headers
 Outbuffer  *SECbuf;             // Buffer to build section table in

Elf32_Shdr* SecHdrTab() { return cast(Elf32_Shdr *)SECbuf.буф; }
Elf32_Shdr* GET_SECTION(цел secidx) { return SecHdrTab() + secidx; }

ткст0 GET_SECTION_NAME(цел secidx)
{
    return cast(сим*)section_names.буф + SecHdrTab[secidx].sh_name;
}

// The relocation for text and данные seems to get lost.
// Try matching the order gcc output them
// This means defining the sections and then removing them if they are
// not используется.
private  цел section_cnt; // Number of sections in table

enum
{
    SHN_TEXT        = 1,
    SHN_RELTEXT     = 2,
    SHN_DATA        = 3,
    SHN_RELDATA     = 4,
    SHN_BSS         = 5,
    SHN_RODAT       = 6,
    SHN_STRINGS     = 7,
    SHN_SYMTAB      = 8,
    SHN_SECNAMES    = 9,
    SHN_COM         = 10,
    SHN_NOTE        = 11,
    SHN_GNUSTACK    = 12,
    SHN_CDATAREL    = 13,
}

 IDXSYM *mapsec2sym;
const S2S_INC = 20;

Elf32_Sym* SymbolTable()   { return cast(Elf32_Sym *)SYMbuf.буф; }
Elf64_Sym* SymbolTable64() { return cast(Elf64_Sym *)SYMbuf.буф; }
private  цел symbol_idx;          // Number of symbols in symbol table
private  цел local_cnt;           // Number of symbols with STB_LOCAL

enum
{
    STI_FILE     = 1,       // Where файл symbol table entry is
    STI_TEXT     = 2,
    STI_DATA     = 3,
    STI_BSS      = 4,
    STI_GCC      = 5,       // Where "gcc2_compiled" symbol is */
    STI_RODAT    = 6,       // Symbol for readonly данные
    STI_NOTE     = 7,       // Where note symbol table entry is
    STI_COM      = 8,
    STI_CDATAREL = 9,       // Symbol for readonly данные with relocations
}

// NOTE: There seems to be a requirement that the читай-only данные have the
// same symbol table index and section index. Use section NOTE as a place
// holder. When a читай-only ткст section is required, swap to NOTE.


public{

// Symbol Table
Outbuffer  *SYMbuf;             // Buffer to build symbol table in

// This should be renamed, even though it is private it conflicts with other reset_symbuf's
extern (D) private Outbuffer *reset_symbuf; // Keep pointers to сбрось symbols

// Extended section header indices
private Outbuffer *shndx_data;
private const IDXSEC secidx_shndx = SHN_HIRESERVE + 1;

// Notes данные (note currently используется)
private Outbuffer *note_data;
private IDXSEC secidx_note;      // Final table index for note данные

// Comment данные for compiler version
private Outbuffer *comment_data;

// Each compiler segment is an elf section
// Predefined compiler segments CODE,DATA,CDATA,UDATA map to indexes
//      into SegData[]
//      An additionl index is reserved for коммент данные
//      New compiler segments are added to end.
//
// There doesn't seem to be any way to get reserved данные space in the
//      same section as initialized данные or code, so section offsets should
//      be continuous when adding данные. Fix-ups anywhere withing existing данные.

const COMD = CDATAREL+1;

enum
{
    OB_SEG_SIZ      = 10,          // initial number of segments supported
    OB_SEG_INC      = 10,          // increment for additional segments

    OB_CODE_STR     = 100000,      // initial size for code
    OB_CODE_INC     = 100000,      // increment for additional code
    OB_DATA_STR     = 100000,      // initial size for данные
    OB_DATA_INC     = 100000,      // increment for additional данные
    OB_CDATA_STR    =   1024,      // initial size for данные
    OB_CDATA_INC    =   1024,      // increment for additional данные
    OB_COMD_STR     =    256,      // initial size for comments
                                   // increment as needed
    OB_XTRA_STR     =    250,      // initial size for extra segments
    OB_XTRA_INC     =  10000,      // increment size
}

IDXSEC      MAP_SEG2SECIDX(цел seg) { return SegData[seg].SDshtidx; }
extern (D)
IDXSYM      MAP_SEG2SYMIDX(цел seg) { return SegData[seg].SDsymidx; }
Elf32_Shdr* MAP_SEG2SEC(цел seg)    { return &SecHdrTab[MAP_SEG2SECIDX(seg)]; }
цел         MAP_SEG2TYP(цел seg)    { return MAP_SEG2SEC(seg).sh_flags & SHF_EXECINSTR ? CODE : DATA; }

public seg_data **SegData;
public цел seg_count;
цел seg_max;
цел seg_tlsseg = UNKNOWN;
цел seg_tlsseg_bss = UNKNOWN;

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
    //dbg_printf("Obj_addstr(strtab = x%x str = '%s')\n",strtab,str);
    IDXSTR idx = cast(IDXSTR)strtab.size();        // remember starting смещение
    strtab.writeString(str);
    //dbg_printf("\tidx %d, new size %d\n",idx,strtab.size());
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
    //printf("elf_addmangled(%s)\n", s.Sident.ptr);
    сим[DEST_LEN] dest = проц;

    IDXSTR namidx = cast(IDXSTR)symtab_strings.size();
    т_мера len;
    сим *destr = obj_mangle2(s, dest.ptr, &len);
    ткст0 имя = destr;
    if (CPP && имя[0] == '_' && имя[1] == '_')
    {
        if (strncmp(имя,"__ct__",6) == 0)
        {
            имя += 4;
            len -= 4;
        }
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
    {
        имя = s.Sfunc.Fredirect;
        len = strlen(имя);
    }
    symtab_strings.резервируй(cast(бцел)len+1);
    memcpy(cast(сим *)symtab_strings.p, имя, len + 1);
    symtab_strings.устРазм(cast(бцел)(namidx+len+1));
    if (destr != dest.ptr)                  // if we resized результат
        mem_free(destr);
    //dbg_printf("\telf_addmagled symtab_strings %s namidx %d len %d size %d\n",имя, namidx,len,symtab_strings.size());
    return namidx;
}

/*******************************
 * Output a symbol into the symbol table
 * Input:
 *      stridx  =       ткст table index for имя
 *      val     =       значение associated with symbol
 *      sz      =       symbol size
 *      typ     =       symbol тип
 *      bind    =       symbol binding
 *      sec     =       index of section where symbol is defined
 *      visibility  =   visibility of symbol (STV_xxxx)
 *
 * Возвращает the symbol table index for the symbol
 */

private IDXSYM elf_addsym(IDXSTR nam, targ_т_мера val, бцел sz,
                         бцел typ, бцел bind, IDXSEC sec,
                         ббайт visibility = STV_DEFAULT)
{
    //dbg_printf("elf_addsym(nam %d, val %d, sz %x, typ %x, bind %x, sec %d\n",
            //nam,val,sz,typ,bind,sec);

    /* We want globally defined данные symbols to have a size because
     * нуль sized symbols break копируй relocations for shared libraries.
     */
    if(sz == 0 && (bind == STB_GLOBAL || bind == STB_WEAK) &&
       (typ == STT_OBJECT || typ == STT_TLS) &&
       sec != SHN_UNDEF)
       sz = 1; // so fake it if it doesn't

    if (sec > SHN_HIRESERVE)
    {   // If the section index is too big we need to store it as
        // extended section header index.
        if (!shndx_data)
        {
            shndx_data = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
            assert(shndx_data);
            shndx_data.enlarge(50 * (Elf64_Word).sizeof);
        }
        // fill with zeros up to symbol_idx
        const т_мера shndx_idx = shndx_data.size() / Elf64_Word.sizeof;
        shndx_data.writezeros(cast(бцел)((symbol_idx - shndx_idx) * Elf64_Word.sizeof));

        shndx_data.write32(sec);
        sec = SHN_XINDEX;
    }

    if (I64)
    {
        if (!SYMbuf)
        {
            SYMbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
            assert(SYMbuf);
            SYMbuf.enlarge(50 * Elf64_Sym.sizeof);

            SYMbuf.резервируй(100 * Elf64_Sym.sizeof);
        }
        Elf64_Sym sym;
        sym.st_name = nam;
        sym.st_value = val;
        sym.st_size = sz;
        sym.st_info = cast(ббайт)ELF64_ST_INFO(cast(ббайт)bind,cast(ббайт)typ);
        sym.st_other = visibility;
        sym.st_shndx = cast(ushort)sec;
        SYMbuf.пиши((&sym)[0 .. 1]);
    }
    else
    {
        if (!SYMbuf)
        {
            SYMbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
            assert(SYMbuf);
            SYMbuf.enlarge(50 * Elf32_Sym.sizeof);

            SYMbuf.резервируй(100 * Elf32_Sym.sizeof);
        }
        Elf32_Sym sym;
        sym.st_name = nam;
        sym.st_value = cast(бцел)val;
        sym.st_size = sz;
        sym.st_info = ELF32_ST_INFO(cast(ббайт)bind,cast(ббайт)typ);
        sym.st_other = visibility;
        sym.st_shndx = cast(ushort)sec;
        SYMbuf.пиши((&sym)[0 .. 1]);
    }
    if (bind == STB_LOCAL)
        local_cnt++;
    //dbg_printf("\treturning symbol table index %d\n",symbol_idx);
    return symbol_idx++;
}

/*******************************
 * Create a new section header table entry.
 *
 * Input:
 *      имя    =       section имя
 *      suffix  =       suffix for имя or null
 *      тип    =       тип of данные in section sh_type
 *      flags   =       attribute flags sh_flags
 * Output:
 *      section_cnt = assigned number for this section
 *              Note: Sections will be reordered on output
 */

private IDXSEC elf_newsection2(
        Elf32_Word имя,
        Elf32_Word тип,
        Elf32_Word flags,
        Elf32_Addr addr,
        Elf32_Off смещение,
        Elf32_Word size,
        Elf32_Word link,
        Elf32_Word info,
        Elf32_Word addralign,
        Elf32_Word entsize)
{
    Elf32_Shdr sec;

    sec.sh_name = имя;
    sec.sh_type = тип;
    sec.sh_flags = flags;
    sec.sh_addr = addr;
    sec.sh_offset = смещение;
    sec.sh_size = size;
    sec.sh_link = link;
    sec.sh_info = info;
    sec.sh_addralign = addralign;
    sec.sh_entsize = entsize;

    if (!SECbuf)
    {
        SECbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(SECbuf);
        SECbuf.enlarge(50 * Elf32_Shdr.sizeof);

        SECbuf.резервируй(16 * Elf32_Shdr.sizeof);
    }
    if (section_cnt == SHN_LORESERVE)
    {   // вставь dummy null sections to skip reserved section indices
        section_cnt = SHN_HIRESERVE + 1;
        SECbuf.writezeros((SHN_HIRESERVE + 1 - SHN_LORESERVE) * sec.sizeof);
        // shndx itself becomes the first section with an extended index
        IDXSTR namidx = Obj_addstr(section_names, ".symtab_shndx");
        elf_newsection2(namidx,SHT_SYMTAB_SHNDX,0,0,0,0,SHN_SYMTAB,0,4,4);
    }
    SECbuf.пиши(cast(проц *)&sec, sec.sizeof);
    return section_cnt++;
}

/**
Add a new section имя or get the ткст table index of an existing entry.

Параметры:
    имя = имя of section
    suffix = приставь to имя
    padded = set to да when entry was newly added
Возвращает:
    String index of new or existing section имя.
 */
private IDXSTR elf_addsectionname(ткст0 имя, ткст0 suffix = null, бул *padded = null)
{
    IDXSTR namidx = cast(IDXSTR)section_names.size();
    section_names.writeString(имя);
    if (suffix)
    {   // Append suffix ткст
        section_names.устРазм(cast(бцел)section_names.size() - 1);  // back up over terminating 0
        section_names.writeString(suffix);
    }
    IDXSTR *pidx = section_names_hashtable.get(namidx, cast(бцел)section_names.size() - 1);
    //IDXSTR *pidx = cast(IDXSTR *)section_names_hashtable.get(&namidx);
    if (*pidx)
    {
        // this section имя already exists, удали addition
        section_names.устРазм(namidx);
        return *pidx;
    }
    if (padded)
        *padded = да;
    return *pidx = namidx;
}

private IDXSEC elf_newsection(ткст0 имя, ткст0 suffix,
        Elf32_Word тип, Elf32_Word flags)
{
    // dbg_printf("elf_newsection(%s,%s,тип %d, flags x%x)\n",
    //        имя?имя:"",suffix?suffix:"",тип,flags);
    бул added = нет;
    IDXSTR namidx = elf_addsectionname(имя, suffix, &added);
    assert(added);

    return elf_newsection2(namidx,тип,flags,0,0,0,0,0,0,0);
}

/**************************
 * Ouput читай only данные and generate a symbol for it.
 *
 */

Symbol *Obj_sym_cdata(tym_t ty,сим *p,цел len)
{
    Symbol *s;

static if (0)
{
    if (OPT_IS_SET(OPTfwritable_strings))
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
    Obj_bytes(CDATA, Offset(CDATA), len, p);
    s.Sseg = CDATA;

    s.Sfl = /*(config.flags3 & CFG3pic) ? FLgotoff :*/ FLextern;
    return s;
}

/**************************
 * Ouput читай only данные for данные.
 * Output:
 *      *pseg   segment of that данные
 * Возвращает:
 *      смещение of that данные
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

/******************************
 * Get segment for readonly ткст literals.
 * The linker will pool strings in this section.
 * Параметры:
 *    sz = number of bytes per character (1, 2, or 4)
 * Возвращает:
 *    segment index
 */
цел Obj_string_literal_segment(бцел sz)
{
    /* Elf special sections:
     * .rodata.strM.N - M is size of character
     *                  N is alignment
     * .rodata.cstN   - N fixed size readonly constants N bytes in size,
     *              aligned to the same size
     */
    static const сим[4][3] имя = [ "1.1", "2.2", "4.4" ];
    const цел i = (sz == 4) ? 2 : sz - 1;
    const IDXSEC seg =
        Obj_getsegment(".rodata.str".ptr, имя[i].ptr, SHT_PROGBITS, SHF_ALLOC | SHF_MERGE | SHF_STRINGS, sz);
    return seg;
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

    mapsec2sym = null;
    note_data = null;
    secidx_note = 0;
    comment_data = null;
    seg_tlsseg = UNKNOWN;
    seg_tlsseg_bss = UNKNOWN;
    GOTsym = null;

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

    if (SECbuf)
        SECbuf.устРазм(0);
    section_cnt = 0;

    enum NAMIDX : IDXSTR
    {
        NONE      =   0,
        SYMTAB    =   1,    // .symtab
        STRTAB    =   9,    // .strtab
        SHSTRTAB  =  17,    // .shstrtab
        TEXT      =  27,    // .text
        DATA      =  33,    // .данные
        BSS       =  39,    // .bss
        NOTE      =  44,    // .note
        COMMENT   =  50,    // .коммент
        RODATA    =  59,    // .rodata
        GNUSTACK  =  67,    // .note.GNU-stack
        CDATAREL  =  83,    // .данные.rel.ro
        RELTEXT   =  96,    // .rel.text and .rela.text
        RELDATA   = 106,    // .rel.данные
        RELDATA64 = 107,    // .rela.данные
    }

    if (I64)
    {
        static const сим[107 + 12] section_names_init64 =
          "\0.symtab\0.strtab\0.shstrtab\0.text\0.данные\0.bss\0.note" ~
          "\0.коммент\0.rodata\0.note.GNU-stack\0.данные.rel.ro\0.rela.text\0.rela.данные";

        if (section_names)
            section_names.устРазм(section_names_init64.sizeof);
        else
        {
            section_names = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
            assert(section_names);
            section_names.enlarge(512);

            section_names.резервируй(1024);
            section_names.writen(section_names_init64.ptr, section_names_init64.sizeof);
        }

        if (section_names_hashtable)
            AApair.разрушь(section_names_hashtable);
            //delete section_names_hashtable;
        section_names_hashtable = AApair.создай(&section_names.буф);
        //section_names_hashtable = new AArray(&ti_idxstr, IDXSTR.sizeof);

        // имя,тип,flags,addr,смещение,size,link,info,addralign,entsize
        elf_newsection2(0,               SHT_NULL,   0,                 0,0,0,0,0, 0,0);
        elf_newsection2(NAMIDX.TEXT,SHT_PROGBITS,SHF_ALLOC|SHF_EXECINSTR,0,0,0,0,0, 4,0);
        elf_newsection2(NAMIDX.RELTEXT,SHT_RELA, 0,0,0,0,SHN_SYMTAB,     SHN_TEXT, 8,0x18);
        elf_newsection2(NAMIDX.DATA,SHT_PROGBITS,SHF_ALLOC|SHF_WRITE,   0,0,0,0,0, 8,0);
        elf_newsection2(NAMIDX.RELDATA64,SHT_RELA, 0,0,0,0,SHN_SYMTAB,   SHN_DATA, 8,0x18);
        elf_newsection2(NAMIDX.BSS, SHT_NOBITS,SHF_ALLOC|SHF_WRITE,     0,0,0,0,0, 16,0);
        elf_newsection2(NAMIDX.RODATA,SHT_PROGBITS,SHF_ALLOC,           0,0,0,0,0, 16,0);
        elf_newsection2(NAMIDX.STRTAB,SHT_STRTAB, 0,                    0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.SYMTAB,SHT_SYMTAB, 0,                    0,0,0,0,0, 8,0);
        elf_newsection2(NAMIDX.SHSTRTAB,SHT_STRTAB, 0,                  0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.COMMENT, SHT_PROGBITS,0,                 0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.NOTE,SHT_NOTE,   0,                      0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.GNUSTACK,SHT_PROGBITS,0,                 0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.CDATAREL,SHT_PROGBITS,SHF_ALLOC|SHF_WRITE,0,0,0,0,0, 16,0);

        foreach (idxname; __traits(allMembers, NAMIDX)[1 .. $])
        {
            NAMIDX idx = mixin("NAMIDX." ~ idxname);
            *section_names_hashtable.get(idx, cast(бцел)section_names_init64.sizeof) = idx;
        }
    }
    else
    {
        static const сим[106 + 12] section_names_init =
          "\0.symtab\0.strtab\0.shstrtab\0.text\0.данные\0.bss\0.note" ~
          "\0.коммент\0.rodata\0.note.GNU-stack\0.данные.rel.ro\0.rel.text\0.rel.данные";

        if (section_names)
            section_names.устРазм(section_names_init.sizeof);
        else
        {
            section_names = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
            assert(section_names);
            section_names.enlarge(512);

            section_names.резервируй(100*1024);
            section_names.writen(section_names_init.ptr, section_names_init.sizeof);
        }

        if (section_names_hashtable)
            AApair.разрушь(section_names_hashtable);
            //delete section_names_hashtable;
        section_names_hashtable = AApair.создай(&section_names.буф);
        //section_names_hashtable = new AArray(&ti_idxstr, (IDXSTR).sizeof);

        // имя,тип,flags,addr,смещение,size,link,info,addralign,entsize
        elf_newsection2(0,               SHT_NULL,   0,                 0,0,0,0,0, 0,0);
        elf_newsection2(NAMIDX.TEXT,SHT_PROGBITS,SHF_ALLOC|SHF_EXECINSTR,0,0,0,0,0, 16,0);
        elf_newsection2(NAMIDX.RELTEXT,SHT_REL, 0,0,0,0,SHN_SYMTAB,      SHN_TEXT, 4,8);
        elf_newsection2(NAMIDX.DATA,SHT_PROGBITS,SHF_ALLOC|SHF_WRITE,   0,0,0,0,0, 4,0);
        elf_newsection2(NAMIDX.RELDATA,SHT_REL, 0,0,0,0,SHN_SYMTAB,      SHN_DATA, 4,8);
        elf_newsection2(NAMIDX.BSS, SHT_NOBITS,SHF_ALLOC|SHF_WRITE,     0,0,0,0,0, 32,0);
        elf_newsection2(NAMIDX.RODATA,SHT_PROGBITS,SHF_ALLOC,           0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.STRTAB,SHT_STRTAB, 0,                    0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.SYMTAB,SHT_SYMTAB, 0,                    0,0,0,0,0, 4,0);
        elf_newsection2(NAMIDX.SHSTRTAB,SHT_STRTAB, 0,                  0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.COMMENT, SHT_PROGBITS,0,                 0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.NOTE,SHT_NOTE,   0,                      0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.GNUSTACK,SHT_PROGBITS,0,                 0,0,0,0,0, 1,0);
        elf_newsection2(NAMIDX.CDATAREL,SHT_PROGBITS,SHF_ALLOC|SHF_WRITE,0,0,0,0,0, 1,0);

        foreach (idxname; __traits(allMembers, NAMIDX)[1 .. $])
        {
            NAMIDX idx = mixin("NAMIDX." ~ idxname);
            *section_names_hashtable.get(idx, cast(бцел)section_names_init.sizeof) = idx;
        }
    }

    if (SYMbuf)
        SYMbuf.устРазм(0);
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
        reset_symbuf = cast(Outbuffer*) calloc(1, (Outbuffer).sizeof);
        assert(reset_symbuf);
        reset_symbuf.enlarge(50 * (Symbol *).sizeof);
    }
    if (shndx_data)
        shndx_data.устРазм(0);
    symbol_idx = 0;
    local_cnt = 0;
    // The symbols that every объект файл has
    elf_addsym(0, 0, 0, STT_NOTYPE,  STB_LOCAL, 0);
    elf_addsym(0, 0, 0, STT_FILE,    STB_LOCAL, SHN_ABS);       // STI_FILE
    elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, SHN_TEXT);      // STI_TEXT
    elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, SHN_DATA);      // STI_DATA
    elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, SHN_BSS);       // STI_BSS
    elf_addsym(0, 0, 0, STT_NOTYPE,  STB_LOCAL, SHN_TEXT);      // STI_GCC
    elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, SHN_RODAT);     // STI_RODAT
    elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, SHN_NOTE);      // STI_NOTE
    elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, SHN_COM);       // STI_COM
    elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, SHN_CDATAREL);  // STI_CDATAREL

    // Initialize output buffers for CODE, DATA and COMMENTS
    //      (NOTE not supported, BSS not required)

    seg_count = 0;

    elf_addsegment2(SHN_TEXT, STI_TEXT, SHN_RELTEXT);
    assert(SegData[CODE].SDseg == CODE);

    elf_addsegment2(SHN_DATA, STI_DATA, SHN_RELDATA);
    assert(SegData[DATA].SDseg == DATA);

    elf_addsegment2(SHN_RODAT, STI_RODAT, 0);
    assert(SegData[CDATA].SDseg == CDATA);

    elf_addsegment2(SHN_BSS, STI_BSS, 0);
    assert(SegData[UDATA].SDseg == UDATA);

    elf_addsegment2(SHN_CDATAREL, STI_CDATAREL, 0);
    assert(SegData[CDATAREL].SDseg == CDATAREL);

    elf_addsegment2(SHN_COM, STI_COM, 0);
    assert(SegData[COMD].SDseg == COMD);

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

    IDXSTR имя = Obj_addstr(symtab_strings, имяф);
    if (I64)
        SymbolTable64[STI_FILE].st_name = имя;
    else
        SymbolTable[STI_FILE].st_name = имя;

static if (0)
{
    // compiler флаг for linker
    if (I64)
        SymbolTable64[STI_GCC].st_name = Obj_addstr(symtab_strings,"gcc2_compiled.");
    else
        SymbolTable[STI_GCC].st_name = Obj_addstr(symtab_strings,"gcc2_compiled.");
}

    if (csegname && *csegname && strcmp(csegname,".text"))
    {   // Define new section and make it the default for cseg segment
        // NOTE: cseg is initialized to CODE
        IDXSEC newsecidx;
        Elf32_Shdr *newtextsec;
        IDXSYM newsymidx;
        SegData[cseg].SDshtidx = newsecidx =
            elf_newsection(csegname,null,SHT_PROGBITS,SHF_ALLOC|SHF_EXECINSTR);
        newtextsec = &SecHdrTab[newsecidx];
        newtextsec.sh_addralign = 4;
        SegData[cseg].SDsymidx =
            elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, newsecidx);
    }
    if (config.fulltypes)
        dwarf_initmodule(имяф, modname);
}

/***************************
 * Renumber symbols so they are
 * ordered as locals, weak and then глоб2
 * Возвращает:
 *      sorted symbol table, caller must free with util_free()
 */

проц *elf_renumbersyms()
{   проц *symtab;
    цел nextlocal = 0;
    цел nextglobal = local_cnt;

    SYMIDX *sym_map = cast(SYMIDX *)util_malloc(SYMIDX.sizeof,symbol_idx);

    if (I64)
    {
        Elf64_Sym *oldsymtab = cast(Elf64_Sym *)SYMbuf.буф;
        Elf64_Sym *symtabend = oldsymtab+symbol_idx;

        symtab = util_malloc(Elf64_Sym.sizeof,symbol_idx);

        Elf64_Sym *sl = cast(Elf64_Sym *)symtab;
        Elf64_Sym *sg = sl + local_cnt;

        цел old_idx = 0;
        for(Elf64_Sym *s = oldsymtab; s != symtabend; s++)
        {   // reorder symbol and map new #s to old
            цел bind = ELF64_ST_BIND(s.st_info);
            if (bind == STB_LOCAL)
            {
                *sl++ = *s;
                sym_map[old_idx] = nextlocal++;
            }
            else
            {
                *sg++ = *s;
                sym_map[old_idx] = nextglobal++;
            }
            old_idx++;
        }
    }
    else
    {
        Elf32_Sym *oldsymtab = cast(Elf32_Sym *)SYMbuf.буф;
        Elf32_Sym *symtabend = oldsymtab+symbol_idx;

        symtab = util_malloc(Elf32_Sym.sizeof,symbol_idx);

        Elf32_Sym *sl = cast(Elf32_Sym *)symtab;
        Elf32_Sym *sg = sl + local_cnt;

        цел old_idx = 0;
        for(Elf32_Sym *s = oldsymtab; s != symtabend; s++)
        {   // reorder symbol and map new #s to old
            цел bind = ELF32_ST_BIND(s.st_info);
            if (bind == STB_LOCAL)
            {
                *sl++ = *s;
                sym_map[old_idx] = nextlocal++;
            }
            else
            {
                *sg++ = *s;
                sym_map[old_idx] = nextglobal++;
            }
            old_idx++;
        }
    }

    // Reorder extended section header indices
    if (shndx_data && shndx_data.size())
    {
        // fill with zeros up to symbol_idx
        const т_мера shndx_idx = shndx_data.size() / Elf64_Word.sizeof;
        shndx_data.writezeros(cast(бцел)((symbol_idx - shndx_idx) * Elf64_Word.sizeof));

        Elf64_Word *old_buf = cast(Elf64_Word *)shndx_data.буф;
        Elf64_Word *tmp_buf = cast(Elf64_Word *)util_malloc(Elf64_Word.sizeof, symbol_idx);
        for (SYMIDX old_idx = 0; old_idx < symbol_idx; ++old_idx)
        {
            const SYMIDX new_idx = sym_map[old_idx];
            tmp_buf[new_idx] = old_buf[old_idx];
        }
        memcpy(old_buf, tmp_buf, Elf64_Word.sizeof * symbol_idx);
        util_free(tmp_buf);
    }

    // Renumber the relocations
    for (цел i = 1; i <= seg_count; i++)
    {                           // Map indicies in the segment table
        seg_data *pseg = SegData[i];
        pseg.SDsymidx = sym_map[pseg.SDsymidx];

        if (SecHdrTab[pseg.SDshtidx].sh_type == SHT_GROUP)
        {   // map symbol index of group section header
            бцел oidx = SecHdrTab[pseg.SDshtidx].sh_info;
            assert(oidx < symbol_idx);
            // we only have one symbol table
            assert(SecHdrTab[pseg.SDshtidx].sh_link == SHN_SYMTAB);
            SecHdrTab[pseg.SDshtidx].sh_info = sym_map[oidx];
        }

        if (pseg.SDrel)
        {
            if (I64)
            {
                Elf64_Rela *rel = cast(Elf64_Rela *) pseg.SDrel.буф;
                for (цел r = 0; r < pseg.SDrelcnt; r++)
                {
                    бцел t = ELF64_R_TYPE(rel.r_info);
                    бцел si = ELF64_R_SYM(rel.r_info);
                    assert(si < symbol_idx);
                    rel.r_info = ELF64_R_INFO(sym_map[si],t);
                    rel++;
                }
            }
            else
            {
                Elf32_Rel *rel = cast(Elf32_Rel *) pseg.SDrel.буф;
                assert(pseg.SDrelcnt == pseg.SDrel.size() / Elf32_Rel.sizeof);
                for (цел r = 0; r < pseg.SDrelcnt; r++)
                {
                    бцел t = ELF32_R_TYPE(rel.r_info);
                    бцел si = ELF32_R_SYM(rel.r_info);
                    assert(si < symbol_idx);
                    rel.r_info = ELF32_R_INFO(sym_map[si],t);
                    rel++;
                }
            }
        }
    }

    return symtab;
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

version (Dinrus)
{
    if (config.useModuleInfo)
        obj_rtinit();
}

version (SCPP)
{
    if (errcnt)
        return;
}

    цел foffset;
    Elf32_Shdr *sechdr;
    seg_data *seg;
    проц *symtab = elf_renumbersyms();
    FILE *fd = null;

    цел hdrsize = (I64 ? Elf64_Ehdr.sizeof : Elf32_Ehdr.sizeof);

    ushort e_shnum;
    if (section_cnt < SHN_LORESERVE)
        e_shnum = cast(ushort)section_cnt;
    else
    {
        e_shnum = SHN_UNDEF;
        SecHdrTab[0].sh_size = section_cnt;
    }
    // uint16_t e_shstrndx = SHN_SECNAMES;
    fobjbuf.writezeros(hdrsize);

            // Walk through sections determining size and файл offsets
            // Sections will be output in the following order
            //  Null segment
            //  For each Code/Data Segment
            //      code/данные to load
            //      relocations without addens
            //  .bss
            //  notes
            //  comments
            //  section имена table
            //  symbol table
            //  strings table

    foffset = hdrsize;      // start after header
                                    // section header table at end

    //
    // First output individual section данные associate with program
    //  code and данные
    //
    //printf("Setup offsets and sizes foffset %d\n\tsection_cnt %d, seg_count %d\n",foffset,section_cnt,seg_count);
    for (цел i=1; i<= seg_count; i++)
    {
        seg_data *pseg = SegData[i];
        Elf32_Shdr *sechdr2 = MAP_SEG2SEC(i);        // corresponding section
        if (sechdr2.sh_addralign < pseg.SDalignment)
            sechdr2.sh_addralign = pseg.SDalignment;
        foffset = elf_align(sechdr2.sh_addralign,foffset);
        if (i == UDATA) // 0, BSS never allocated
        {   // but foffset as if it has
            sechdr2.sh_offset = foffset;
            sechdr2.sh_size = cast(бцел)pseg.SDoffset;
                                // accumulated size
            continue;
        }
        else if (sechdr2.sh_type == SHT_NOBITS) // .tbss never allocated
        {
            sechdr2.sh_offset = foffset;
            sechdr2.sh_size = cast(бцел)pseg.SDoffset;
                                // accumulated size
            continue;
        }
        else if (!pseg.SDbuf)
            continue;           // For others leave sh_offset as 0

        sechdr2.sh_offset = foffset;
        //printf("\tsection имя %d,",sechdr2.sh_name);
        if (pseg.SDbuf && pseg.SDbuf.size())
        {
            //printf(" - size %d\n",pseg.SDbuf.size());
            const т_мера size = pseg.SDbuf.size();
            fobjbuf.пиши(pseg.SDbuf.буф, cast(бцел)size);
            const цел nfoffset = elf_align(sechdr2.sh_addralign, cast(бцел)(foffset + size));
            sechdr2.sh_size = nfoffset - foffset;
            foffset = nfoffset;
        }
        //printf(" assigned смещение %d, size %d\n",foffset,sechdr2.sh_size);
    }

    //
    // Next output any notes or comments
    //
    if (note_data)
    {
        sechdr = &SecHdrTab[secidx_note];               // Notes
        sechdr.sh_size = cast(бцел)note_data.size();
        sechdr.sh_offset = foffset;
        fobjbuf.пиши(note_data.буф, sechdr.sh_size);
        foffset += sechdr.sh_size;
    }

    if (comment_data)
    {
        sechdr = &SecHdrTab[SHN_COM];           // Comments
        sechdr.sh_size = cast(бцел)comment_data.size();
        sechdr.sh_offset = foffset;
        fobjbuf.пиши(comment_data.буф, sechdr.sh_size);
        foffset += sechdr.sh_size;
    }

    //
    // Then output ткст table for section имена
    //
    sechdr = &SecHdrTab[SHN_SECNAMES];  // Section Names
    sechdr.sh_size = cast(бцел)section_names.size();
    sechdr.sh_offset = foffset;
    //dbg_printf("section имена смещение %d\n",foffset);
    fobjbuf.пиши(section_names.буф, sechdr.sh_size);
    foffset += sechdr.sh_size;

    //
    // Symbol table and ткст table for symbols следщ
    //
    //dbg_printf("output symbol table size %d\n",SYMbuf.size());
    sechdr = &SecHdrTab[SHN_SYMTAB];    // Symbol Table
    sechdr.sh_size = cast(бцел)SYMbuf.size();
    sechdr.sh_entsize = I64 ? (Elf64_Sym).sizeof : (Elf32_Sym).sizeof;
    sechdr.sh_link = SHN_STRINGS;
    sechdr.sh_info = local_cnt;
    foffset = elf_align(4,foffset);
    sechdr.sh_offset = foffset;
    fobjbuf.пиши(symtab, sechdr.sh_size);
    foffset += sechdr.sh_size;
    util_free(symtab);

    if (shndx_data && shndx_data.size())
    {
        assert(section_cnt >= secidx_shndx);
        sechdr = &SecHdrTab[secidx_shndx];
        sechdr.sh_size = cast(бцел)shndx_data.size();
        sechdr.sh_offset = foffset;
        fobjbuf.пиши(shndx_data.буф, sechdr.sh_size);
        foffset += sechdr.sh_size;
    }

    //dbg_printf("output section strings size 0x%x,смещение 0x%x\n",symtab_strings.size(),foffset);
    sechdr = &SecHdrTab[SHN_STRINGS];   // Symbol Strings
    sechdr.sh_size = cast(бцел)symtab_strings.size();
    sechdr.sh_offset = foffset;
    fobjbuf.пиши(symtab_strings.буф, sechdr.sh_size);
    foffset += sechdr.sh_size;

    //
    // Now the relocation данные for program code and данные sections
    //
    foffset = elf_align(4,foffset);
    //dbg_printf("output relocations size 0x%x, foffset 0x%x\n",section_names.size(),foffset);
    for (цел i=1; i<= seg_count; i++)
    {
        seg = SegData[i];
        if (!seg.SDbuf)
        {
//            sechdr = &SecHdrTab[seg.SDrelidx];
//          if (I64 && sechdr.sh_type == SHT_RELA)
//              sechdr.sh_offset = foffset;
            continue;           // 0, BSS never allocated
        }
        if (seg.SDrel && seg.SDrel.size())
        {
            assert(seg.SDrelidx);
            sechdr = &SecHdrTab[seg.SDrelidx];
            sechdr.sh_size = cast(бцел)seg.SDrel.size();
            sechdr.sh_offset = foffset;
            if (I64)
            {
                assert(seg.SDrelcnt == seg.SDrel.size() / Elf64_Rela.sizeof);
debug
{
                for (т_мера j = 0; j < seg.SDrelcnt; ++j)
                {   Elf64_Rela *p = (cast(Elf64_Rela *)seg.SDrel.буф) + j;
                    if (ELF64_R_TYPE(p.r_info) == R_X86_64_64)
                        assert(*cast(Elf64_Xword *)(seg.SDbuf.буф + p.r_offset) == 0);
                }
}
            }
            else
                assert(seg.SDrelcnt == seg.SDrel.size() / Elf32_Rel.sizeof);
            fobjbuf.пиши(seg.SDrel.буф, sechdr.sh_size);
            foffset += sechdr.sh_size;
        }
    }

    //
    // Finish off with the section header table
    //
    бдол e_shoff = foffset;       // remember location in elf header
    //dbg_printf("output section header table\n");

    // Output the completed Section Header Table
    if (I64)
    {   // Translate section headers to 64 bits
        цел sz = cast(цел)(section_cnt * Elf64_Shdr.sizeof);
        fobjbuf.резервируй(sz);
        for (цел i = 0; i < section_cnt; i++)
        {
            Elf32_Shdr *p = SecHdrTab + i;
            Elf64_Shdr s;
            s.sh_name      = p.sh_name;
            s.sh_type      = p.sh_type;
            s.sh_flags     = p.sh_flags;
            s.sh_addr      = p.sh_addr;
            s.sh_offset    = p.sh_offset;
            s.sh_size      = p.sh_size;
            s.sh_link      = p.sh_link;
            s.sh_info      = p.sh_info;
            s.sh_addralign = p.sh_addralign;
            s.sh_entsize   = p.sh_entsize;
            fobjbuf.пиши((&s)[0 .. 1]);
        }
        foffset += sz;
    }
    else
    {
        fobjbuf.пиши(SecHdrTab, cast(бцел)(section_cnt * Elf32_Shdr.sizeof));
        foffset += section_cnt * Elf32_Shdr.sizeof;
    }

    //
    // Now that we have correct смещение to section header table, e_shoff,
    //  go back and re-output the elf header
    //
    fobjbuf.position(0, hdrsize);
    if (I64)
    {
         Elf64_Ehdr h64 =
        {
            [
                ELFMAG0,ELFMAG1,ELFMAG2,ELFMAG3,
                ELFCLASS64,             // EI_CLASS
                ELFDATA2LSB,            // EI_DATA
                EV_CURRENT,             // EI_VERSION
                ELFOSABI,0,             // EI_OSABI,EI_ABIVERSION
                0,0,0,0,0,0,0
            ],
            ET_REL,                         // e_type
            EM_X86_64,                      // e_machine
            EV_CURRENT,                     // e_version
            0,                              // e_entry
            0,                              // e_phoff
            0,                              // e_shoff
            0,                              // e_flags
            Elf64_Ehdr.sizeof,              // e_ehsize
            Elf64_Phdr.sizeof,              // e_phentsize
            0,                              // e_phnum
            Elf64_Shdr.sizeof,              // e_shentsize
            0,                              // e_shnum
            SHN_SECNAMES                    // e_shstrndx
        };
        h64.e_shoff     = e_shoff;
        h64.e_shnum     = e_shnum;
        fobjbuf.пиши(&h64, hdrsize);
    }
    else
    {
         Elf32_Ehdr h32 =
        {
            [
                ELFMAG0,ELFMAG1,ELFMAG2,ELFMAG3,
                ELFCLASS32,             // EI_CLASS
                ELFDATA2LSB,            // EI_DATA
                EV_CURRENT,             // EI_VERSION
                ELFOSABI,0,             // EI_OSABI,EI_ABIVERSION
                0,0,0,0,0,0,0
            ],
            ET_REL,                         // e_type
            EM_386,                         // e_machine
            EV_CURRENT,                     // e_version
            0,                              // e_entry
            0,                              // e_phoff
            0,                              // e_shoff
            0,                              // e_flags
            Elf32_Ehdr.sizeof,              // e_ehsize
            Elf32_Phdr.sizeof,              // e_phentsize
            0,                              // e_phnum
            Elf32_Shdr.sizeof,              // e_shentsize
            0,                              // e_shnum
            SHN_SECNAMES                    // e_shstrndx
        };
        h32.e_shoff     = cast(бцел)e_shoff;
        h32.e_shnum     = e_shnum;
        fobjbuf.пиши(&h32, hdrsize);
    }
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
    printf("Obj_linnum(seg=%d, смещение=0x%lx) ", seg, смещение);
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
            pseg.SDlinnum_data[i].имяф = srcpos.Sfilename;

version (SCPP)
            pseg.SDlinnum_data[i].filptr = sf;

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
    //dbg_printf("Obj_startaddress(Symbol *%s)\n",s.Sident.ptr);
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
    бцел strtab_idx = Obj_addstr(symtab_strings,modname);
    elf_addsym(strtab_idx,0,0,STT_FILE,STB_LOCAL,SHN_ABS);
}

/*******************************
 * Embed compiler version in .obj файл.
 */

проц Obj_compiler()
{
    //dbg_printf("Obj_compiler\n");
    comment_data = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
    assert(comment_data);

    const maxVersionLength = 40;  // hope enough to store `git describe --dirty`
    const compilerHeader = "\0Digital Mars C/C++ ";
    const n = compilerHeader.length;
    сим[n + maxVersionLength] compiler = compilerHeader;

    assert(config._version.length < maxVersionLength);
    const newLength = n + config._version.length;
    compiler[n .. newLength] = config._version;
    comment_data.пиши(compiler[0 .. newLength]);
    //dbg_printf("Comment данные size %d\n",comment_data.size());
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
    IDXSEC seg;
    static if (USE_INIT_ARRAY)
        seg = isCtor ? Obj_getsegment(".init_array", null, SHT_INIT_ARRAY, SHF_ALLOC|SHF_WRITE, _tysize[TYnptr])
                     : Obj_getsegment(".fini_array", null, SHT_FINI_ARRAY, SHF_ALLOC|SHF_WRITE, _tysize[TYnptr]);
    else
        seg = Obj_getsegment(isCtor ? ".ctors" : ".dtors", null, SHT_PROGBITS, SHF_ALLOC|SHF_WRITE, _tysize[TYnptr]);
    const reltype_t reltype = I64 ? R_X86_64_64 : R_386_32;
    const т_мера sz = Obj_writerel(seg, cast(бцел)SegData[seg].SDoffset, reltype, sfunc.Sxtrnnum, 0);
    SegData[seg].SDoffset += sz;
}


/***************************************
 * Stuff the following данные in a separate segment:
 *      pointer to function
 *      pointer to ehsym
 *      length of function
 */

проц Obj_ehtables(Symbol *sfunc,бцел size,Symbol *ehsym)
{
    assert(0);                  // converted to Dwarf EH debug format
}

/*********************************************
 * Don't need to generate section brackets, use __start_SEC/__stop_SEC instead.
 */

проц Obj_ehsections()
{
    obj_tlssections();
}

/*********************************************
 * Put out symbols that define the beginning/end of the thread local storage sections.
 */

private проц obj_tlssections()
{
    const align_ = I64 ? 16 : 4;

    {
        const sec = Obj_getsegment(".tdata", null, SHT_PROGBITS, SHF_ALLOC|SHF_WRITE|SHF_TLS, align_);
        Obj_bytes(sec, 0, align_, null);

        const namidx = Obj_addstr(symtab_strings,"_tlsstart");
        elf_addsym(namidx, 0, align_, STT_TLS, STB_GLOBAL, MAP_SEG2SECIDX(sec));
    }

    Obj_getsegment(".tdata.", null, SHT_PROGBITS, SHF_ALLOC|SHF_WRITE|SHF_TLS, align_);

    {
        const sec = Obj_getsegment(".tcommon", null, SHT_NOBITS, SHF_ALLOC|SHF_WRITE|SHF_TLS, align_);
        const namidx = Obj_addstr(symtab_strings,"_tlsend");
        elf_addsym(namidx, 0, align_, STT_TLS, STB_GLOBAL, MAP_SEG2SECIDX(sec));
    }
}

/*********************************
 * Setup for Symbol s to go into a COMDAT segment.
 * Output (if s is a function):
 *      cseg            segment index of new current code segment
 *      Offset(cseg)         starting смещение in cseg
 * Возвращает:
 *      "segment index" of COMDAT
 * References:
 *      Section Groups http://www.sco.com/developers/gabi/2003-12-17/ch4.sheader.html#section_groups
 *      COMDAT section groups https://www.airs.com/blog/archives/52
 */

private проц setup_comdat(Symbol *s)
{
    ткст0 префикс;
    цел тип;
    цел flags;
    цел align_ = 4;

    //printf("Obj_comdat(Symbol *%s\n",s.Sident.ptr);
    //symbol_print(s);
    symbol_debug(s);
    if (tyfunc(s.ty()))
    {
static if (!ELF_COMDAT)
{
        префикс = ".text.";              // undocumented, but works
        тип = SHT_PROGBITS;
        flags = SHF_ALLOC|SHF_EXECINSTR;
}
else
{
        reset_symbuf.пиши((&s)[0 .. 1]);

        ткст0 p = cpp_mangle2(s);

        бул added = нет;
        const namidx = elf_addsectionname(".text.", p, &added);
        цел groupseg;
        if (added)
        {
            // Create a new COMDAT section group
            const IDXSTR grpnamidx = elf_addsectionname(".group");
            groupseg = elf_addsegment(grpnamidx, SHT_GROUP, 0, (IDXSYM).sizeof);
            MAP_SEG2SEC(groupseg).sh_link = SHN_SYMTAB;
            MAP_SEG2SEC(groupseg).sh_entsize = (IDXSYM).sizeof;
            // Create a new TEXT section for the comdat symbol with the SHF_GROUP bit set
            s.Sseg = elf_addsegment(namidx, SHT_PROGBITS, SHF_ALLOC|SHF_EXECINSTR|SHF_GROUP, align_);
            // add TEXT section to COMDAT section group
            SegData[groupseg].SDbuf.write32(GRP_COMDAT);
            SegData[groupseg].SDbuf.write32(MAP_SEG2SECIDX(s.Sseg));
            SegData[s.Sseg].SDassocseg = groupseg;
        }
        else
        {
            /* If the section already existed, we've hit one of the few
             * occurences of different symbols with identical mangling. This should
             * not happen, but as a workaround we just use the existing sections.
             * Also see https://issues.dlang.org/show_bug.cgi?ид=17352,
             * https://issues.dlang.org/show_bug.cgi?ид=14831, and
             * https://issues.dlang.org/show_bug.cgi?ид=17339.
             */
            s.Sseg = elf_getsegment(namidx);
            groupseg = SegData[s.Sseg].SDassocseg;
            assert(groupseg);
        }

        // Create a weak symbol for the comdat
        const namidxcd = Obj_addstr(symtab_strings, p);
        s.Sxtrnnum = elf_addsym(namidxcd, 0, 0, STT_FUNC, STB_WEAK, MAP_SEG2SECIDX(s.Sseg));

        if (added)
        {
            /* Set the weak symbol as comdat group symbol. This symbol determines
             * whether all or none of the sections in the group get linked. It's
             * also the only symbol in all group sections that might be referenced
             * from outside of the group.
             */
            MAP_SEG2SEC(groupseg).sh_info = s.Sxtrnnum;
            SegData[s.Sseg].SDsym = s;
        }
        else
        {
            // existing group symbol, and section symbol
            assert(MAP_SEG2SEC(groupseg).sh_info);
            assert(MAP_SEG2SEC(groupseg).sh_info == SegData[s.Sseg].SDsym.Sxtrnnum);
        }
        if (s.Salignment > align_)
            SegData[s.Sseg].SDalignment = s.Salignment;
        return;
}
    }
    else if ((s.ty() & mTYLINK) == mTYthread)
    {
        /* Гарант that ".tdata" precedes any other .tdata. section, as the ld
         * linker script fails to work right.
         */
        if (I64)
            align_ = 16;
        Obj_getsegment(".tdata", null, SHT_PROGBITS, SHF_ALLOC|SHF_WRITE|SHF_TLS, align_);

        s.Sfl = FLtlsdata;
        префикс = ".tdata.";
        тип = SHT_PROGBITS;
        flags = SHF_ALLOC|SHF_WRITE|SHF_TLS;
    }
    else
    {
        if (I64)
            align_ = 16;
        s.Sfl = FLdata;
        //префикс = ".gnu.linkonce.d.";
        префикс = ".данные.";
        тип = SHT_PROGBITS;
        flags = SHF_ALLOC|SHF_WRITE;
    }

    s.Sseg = Obj_getsegment(префикс, cpp_mangle2(s), тип, flags, align_);
                                // найди or создай new segment
    if (s.Salignment > align_)
        SegData[s.Sseg].SDalignment = s.Salignment;
    SegData[s.Sseg].SDsym = s;
}

цел Obj_comdat(Symbol *s)
{
    setup_comdat(s);
    if (s.Sfl == FLdata || s.Sfl == FLtlsdata)
    {
        Obj_pubdef(s.Sseg,s,0);
        searchfixlist(s);               // backpatch any refs to this symbol
    }
    return s.Sseg;
}

цел Obj_comdatsize(Symbol *s, targ_т_мера symsize)
{
    setup_comdat(s);
    if (s.Sfl == FLdata || s.Sfl == FLtlsdata)
    {
        Obj_pubdefsize(s.Sseg,s,0,symsize);
        searchfixlist(s);               // backpatch any refs to this symbol
    }
    s.Soffset = 0;
    return s.Sseg;
}

цел Obj_readonly_comdat(Symbol *s)
{
    assert(0);
}

цел Obj_jmpTableSegment(Symbol *s)
{
    segidx_t seg = jmpseg;
    if (seg)                            // memoize the jmpseg on a per-function basis
        return seg;

    if (config.flags & CFGromable)
        seg = cseg;
    else
    {
        seg_data *pseg = SegData[s.Sseg];
        if (pseg.SDassocseg)
        {
            /* `s` is in a COMDAT, so the jmp table segment must also
             * go into its own segment in the same group.
             */
            seg = Obj_getsegment(".rodata.", s.Sident.ptr, SHT_PROGBITS, SHF_ALLOC|SHF_GROUP, _tysize[TYnptr]);
            addSegmentToComdat(seg, s.Sseg);
        }
        else
            seg = CDATA;
    }
    jmpseg = seg;
    return seg;
}

/****************************************
 * If `comdatseg` has a group, add `secidx` to the group.
 * Параметры:
 *      secidx = section to add to the group
 *      comdatseg = comdat that started the group
 */

private проц addSectionToComdat(IDXSEC secidx, segidx_t comdatseg)
{
    seg_data *pseg = SegData[comdatseg];
    segidx_t groupseg = pseg.SDassocseg;
    if (groupseg)
    {
        seg_data *pgroupseg = SegData[groupseg];

        /* Don't пиши it if it is already there
         */
        Outbuffer *буф = pgroupseg.SDbuf;
        assert(цел.sizeof == 4);               // loop depends on this
        for (т_мера i = буф.size(); i > 4;)
        {
            /* A linear search, but shouldn't be more than 4 items
             * in it.
             */
            i -= 4;
            if (*cast(цел*)(буф.буф + i) == secidx)
                return;
        }
        буф.write32(secidx);
    }
}

/***********************************
 * Возвращает:
 *      jump table segment for function s
 */
проц addSegmentToComdat(segidx_t seg, segidx_t comdatseg)
{
    addSectionToComdat(SegData[seg].SDshtidx, comdatseg);
}

private цел elf_addsegment2(IDXSEC shtidx, IDXSYM symidx, IDXSEC relidx)
{
    //printf("SegData = %p\n", SegData);
    цел seg = ++seg_count;
    if (seg_count >= seg_max)
    {                           // need more room in segment table
        seg_max += OB_SEG_INC;
        SegData = cast(seg_data **)mem_realloc(SegData,seg_max * (seg_data *).sizeof);
        memset(&SegData[seg_count], 0, (seg_max - seg_count) * (seg_data *).sizeof);
    }
    assert(seg_count < seg_max);
    if (!SegData[seg])
    {
        SegData[seg] = cast(seg_data *)mem_calloc(seg_data.sizeof);
        //printf("test2: SegData[%d] = %p\n", seg, SegData[seg]);
    }
    else
        memset(SegData[seg], 0, seg_data.sizeof);

    seg_data *pseg = SegData[seg];
    pseg.SDseg = seg;
    pseg.SDshtidx = shtidx;
    pseg.SDoffset = 0;
    if (pseg.SDbuf)
        pseg.SDbuf.устРазм(0);
    else
    {   if (SecHdrTab[shtidx].sh_type != SHT_NOBITS)
        {
            pseg.SDbuf = cast(Outbuffer*) calloc(1, (Outbuffer).sizeof);
            assert(pseg.SDbuf);
            pseg.SDbuf.enlarge(OB_XTRA_STR);

            pseg.SDbuf.резервируй(1024);
        }
    }
    if (pseg.SDrel)
        pseg.SDrel.устРазм(0);
    pseg.SDsymidx = symidx;
    pseg.SDrelidx = relidx;
    pseg.SDrelmaxoff = 0;
    pseg.SDrelindex = 0;
    pseg.SDrelcnt = 0;
    pseg.SDshtidxout = 0;
    pseg.SDsym = null;
    pseg.SDaranges_offset = 0;
    pseg.SDlinnum_count = 0;
    return seg;
}

/********************************
 * Add a new section and get corresponding seg_data entry.
 *
 * Input:
 *     nameidx = ткст index of section имя
 *        тип = section header тип, e.g. SHT_PROGBITS
 *       flags = section header flags, e.g. SHF_ALLOC
 *       align_ = section alignment
 * Возвращает:
 *      SegData index of newly created section.
 */
private цел elf_addsegment(IDXSTR namidx, цел тип, цел flags, цел align_)
{
    //dbg_printf("\tNew segment - %d size %d\n", seg,SegData[seg].SDbuf);
    IDXSEC shtidx = elf_newsection2(namidx,тип,flags,0,0,0,0,0,0,0);
    SecHdrTab[shtidx].sh_addralign = align_;
    IDXSYM symidx = elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, shtidx);
    цел seg = elf_addsegment2(shtidx, symidx, 0);
    //printf("-Obj_getsegment() = %d\n", seg);
    return seg;
}

/********************************
 * Find corresponding seg_data entry for existing section.
 *
 * Input:
 *     nameidx = ткст index of section имя
 * Возвращает:
 *      SegData index of found section or 0 if none was found.
 */
private цел elf_getsegment(IDXSTR namidx)
{
    // найди existing section
    for (цел seg = CODE; seg <= seg_count; seg++)
    {                               // should be in segment table
        if (MAP_SEG2SEC(seg).sh_name == namidx)
        {
            return seg;             // found section for segment
        }
    }
    return 0;
}

/********************************
 * Get corresponding seg_data entry for an existing or newly added section.
 *
 * Input:
 *        имя = имя of section
 *      suffix = приставь to имя
 *        тип = section header тип, e.g. SHT_PROGBITS
 *       flags = section header flags, e.g. SHF_ALLOC
 *       align_ = section alignment
 * Возвращает:
 *      SegData index of found or newly created section.
 */
цел Obj_getsegment(ткст0 имя, ткст0 suffix, цел тип, цел flags,
        цел align_)
{
    //printf("Obj_getsegment(%s,%s,flags %x, align_ %d)\n",имя,suffix,flags,align_);
    бул added = нет;
    const namidx = elf_addsectionname(имя, suffix, &added);
    if (!added)
    {
        const seg = elf_getsegment(namidx);
        assert(seg);
        return seg;
    }
    return elf_addsegment(namidx, тип, flags, align_);
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
    цел seg;
    ткст0 sfx;

    //dbg_printf("Obj_codeseg(%s,%x)\n",имя,suffix);

    sfx = (suffix) ? "_TEXT".ptr : null;

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

    seg = Obj_getsegment(имя, sfx, SHT_PROGBITS, SHF_ALLOC|SHF_EXECINSTR, 4);
                                    // найди or создай code segment

    cseg = seg;                         // new code segment index
    Offset(cseg) = 0;

    return seg;
}

/*********************************
 * Define segments for Thread Local Storage.
 * Here's what the elf tls spec says:
 *      Field           .tbss                   .tdata
 *      sh_name         .tbss                   .tdata
 *      sh_type         SHT_NOBITS              SHT_PROGBITS
 *      sh_flags        SHF_ALLOC|SHF_WRITE|    SHF_ALLOC|SHF_WRITE|
 *                      SHF_TLS                 SHF_TLS
 *      sh_addr         virtual addr of section virtual addr of section
 *      sh_offset       0                       файл смещение of initialization image
 *      sh_size         size of section         size of section
 *      sh_link         SHN_UNDEF               SHN_UNDEF
 *      sh_info         0                       0
 *      sh_addralign    alignment of section    alignment of section
 *      sh_entsize      0                       0
 * We want _tlsstart and _tlsend to bracket all the D tls данные.
 * The default linker script (ld -verbose) says:
 *  .tdata      : { *(.tdata .tdata.* .gnu.linkonce.td.*) }
 *  .tbss       : { *(.tbss .tbss.* .gnu.linkonce.tb.*) *(.tcommon) }
 * so if we assign имена:
 *      _tlsstart .tdata
 *      symbols   .tdata.
 *      symbols   .tbss
 *      _tlsend   .tbss.
 * this should work.
 * Don't care about sections emitted by other languages, as we presume they
 * won't be storing D gc roots in their tls.
 * Output:
 *      seg_tlsseg      set to segment number for TLS segment.
 * Возвращает:
 *      segment for TLS segment
 */

seg_data *Obj_tlsseg()
{
    /* Гарант that ".tdata" precedes any other .tdata. section, as the ld
     * linker script fails to work right.
     */
    Obj_getsegment(".tdata", null, SHT_PROGBITS, SHF_ALLOC|SHF_WRITE|SHF_TLS, 4);

    static const сим[8] tlssegname = ".tdata.";
    //dbg_printf("Obj_tlsseg(\n");

    if (seg_tlsseg == UNKNOWN)
    {
        seg_tlsseg = Obj_getsegment(tlssegname.ptr, null, SHT_PROGBITS,
            SHF_ALLOC|SHF_WRITE|SHF_TLS, I64 ? 16 : 4);
    }
    return SegData[seg_tlsseg];
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
    static const сим[6] tlssegname = ".tbss";
    //dbg_printf("Obj_tlsseg_bss(\n");

    if (seg_tlsseg_bss == UNKNOWN)
    {
        seg_tlsseg_bss = Obj_getsegment(tlssegname.ptr, null, SHT_NOBITS,
            SHF_ALLOC|SHF_WRITE|SHF_TLS, I64 ? 16 : 4);
    }
    return SegData[seg_tlsseg_bss];
}

seg_data *Obj_tlsseg_data()
{
    // specific for Mach-O
    assert(0);
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
    сим *буфер = cast(сим *) alloca(strlen(n1) + strlen(n2) + 2 * ONS_OHD);
    бцел len = obj_namestring(буфер,n1);
    len += obj_namestring(буфер + len,n2);
    objrecord(ALIAS,буфер,len);
}
}

сим *unsstr(бцел значение)
{
     сим[64] буфер = проц;

    sprintf(буфер.ptr, "%d", значение);
    return буфер.ptr;
}

/*******************************
 * Mangle a имя.
 * Возвращает:
 *      mangled имя
 */

сим *obj_mangle2(Symbol *s,сим *dest, т_мера *destlen)
{
    сим *имя;

    //dbg_printf("Obj_mangle('%s'), mangle = x%x\n",s.Sident.ptr,type_mangle(s.Stype));
    symbol_debug(s);
    assert(dest);

version (SCPP)
    имя = CPP ? cpp_mangle2(s) : s.Sident.ptr;
else version (Dinrus)
    // C++ имя mangling is handled by front end
    имя = s.Sident.ptr;
else
    имя = s.Sident.ptr;

    т_мера len = strlen(имя);                 // # of bytes in имя
    //dbg_printf("len %d\n",len);
    switch (type_mangle(s.Stype))
    {
        case mTYman_pas:                // if upper case
        case mTYman_for:
            if (len >= DEST_LEN)
                dest = cast(сим *)mem_malloc(len + 1);
            memcpy(dest,имя,len + 1);  // копируй in имя and ending 0
            for (цел i = 0; 1; i++)
            {   сим c = dest[i];
                if (!c)
                    break;
                if (c >= 'a' && c <= 'z')
                    dest[i] = cast(сим)(c + 'A' - 'a');
            }
            break;
        case mTYman_std:
        {
static if (TARGET_LINUX || TARGET_FREEBSD || TARGET_OPENBSD || TARGET_DRAGONFLYBSD || TARGET_SOLARIS)
            бул cond = (tyfunc(s.ty()) && !variadic(s.Stype));
else
            бул cond = (!(config.flags4 & CFG4oldstdmangle) &&
                config.exe == EX_WIN32 && tyfunc(s.ty()) &&
                !variadic(s.Stype));

            if (cond)
            {
                сим *pstr = unsstr(type_paramsize(s.Stype));
                т_мера pstrlen = strlen(pstr);
                т_мера dlen = len + 1 + pstrlen;

                if (dlen >= DEST_LEN)
                    dest = cast(сим *)mem_malloc(dlen + 1);
                memcpy(dest,имя,len);
                dest[len] = '@';
                memcpy(dest + 1 + len, pstr, pstrlen + 1);
                len = dlen;
                break;
            }
        }
            goto case;

        case mTYman_cpp:
        case mTYman_c:
        case mTYman_d:
        case mTYman_sys:
        case 0:
            if (len >= DEST_LEN)
                dest = cast(сим *)mem_malloc(len + 1);
            memcpy(dest,имя,len+1);// копируй in имя and trailing 0
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
    *destlen = len;
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
    //printf("Obj_data_start(%s,size %llx,seg %d)\n",sdata.Sident.ptr,datasize,seg);
    //symbol_print(sdata);

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
    //dbg_printf("Obj_func_start(%s)\n",sfunc.Sident.ptr);
    symbol_debug(sfunc);

    if ((tybasic(sfunc.ty()) == TYmfunc) && (sfunc.Sclass == SCextern))
    {                                   // создай a new code segment
        sfunc.Sseg =
            Obj_getsegment(".gnu.linkonce.t.", cpp_mangle2(sfunc), SHT_PROGBITS, SHF_ALLOC|SHF_EXECINSTR,4);

    }
    else if (sfunc.Sseg == UNKNOWN)
        sfunc.Sseg = CODE;
    //dbg_printf("sfunc.Sseg %d CODE %d cseg %d Coffset %d\n",sfunc.Sseg,CODE,cseg,Offset(cseg));
    cseg = sfunc.Sseg;
    jmpseg = 0;                         // only 1 jmp seg per function
    assert(cseg == CODE || cseg > COMD);
static if (ELF_COMDAT)
{
    if (!symbol_iscomdat2(sfunc))
    {
        Obj_pubdef(cseg, sfunc, Offset(cseg));
    }
}
else
{
    Obj_pubdef(cseg, sfunc, Offset(cseg));
}
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

    // fill in the function size
    if (I64)
        SymbolTable64[sfunc.Sxtrnnum].st_size = Offset(cseg) - sfunc.Soffset;
    else
        SymbolTable[sfunc.Sxtrnnum].st_size = cast(бцел)(Offset(cseg) - sfunc.Soffset);
    dwarf_func_term(sfunc);
}

/********************************
 * Output a public definition.
 * Input:
 *      seg =           segment index that symbol is defined in
 *      s .            symbol
 *      смещение =        смещение of имя within segment
 */

проц Obj_pubdef(цел seg, Symbol *s, targ_т_мера смещение)
{
    const targ_т_мера symsize=
        tyfunc(s.ty()) ? Offset(s.Sseg) - смещение : type_size(s.Stype);
    Obj_pubdefsize(seg, s, смещение, symsize);
}

/********************************
 * Output a public definition.
 * Input:
 *      seg =           segment index that symbol is defined in
 *      s .            symbol
 *      смещение =        смещение of имя within segment
 *      symsize         size of symbol
 */

проц Obj_pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize)
{
    цел bind;
    ббайт visibility = STV_DEFAULT;
    switch (s.Sclass)
    {
        case SCglobal:
        case SCinline:
            bind = STB_GLOBAL;
            break;
        case SCcomdat:
        case SCcomdef:
            bind = STB_WEAK;
            break;
        case SCstatic:
            if (s.Sflags & SFLhidden)
            {
                visibility = STV_HIDDEN;
                bind = STB_GLOBAL;
                break;
            }
            goto default;

        default:
            bind = STB_LOCAL;
            break;
    }

    //printf("\nObj_pubdef(%d,%s,%d)\n",seg,s.Sident.ptr,смещение);
    //symbol_print(s);

    symbol_debug(s);
    reset_symbuf.пиши((&s)[0 .. 1]);
    const namidx = elf_addmangled(s);
    //printf("\tnamidx %d,section %d\n",namidx,MAP_SEG2SECIDX(seg));
    if (tyfunc(s.ty()))
    {
        s.Sxtrnnum = elf_addsym(namidx, смещение, cast(бцел)symsize,
            STT_FUNC, bind, MAP_SEG2SECIDX(seg), visibility);
    }
    else
    {
        const бцел typ = (s.ty() & mTYthread) ? STT_TLS : STT_OBJECT;
        s.Sxtrnnum = elf_addsym(namidx, смещение, cast(бцел)symsize,
            typ, bind, MAP_SEG2SECIDX(seg), visibility);
    }
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
    //dbg_printf("Obj_external_def('%s')\n",имя);
    assert(имя);
    const namidx = Obj_addstr(symtab_strings,имя);
    const symidx = elf_addsym(namidx, 0, 0, STT_NOTYPE, STB_GLOBAL, SHN_UNDEF);
    return symidx;
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
    цел symtype,sectype;
    бцел size;

    //dbg_printf("Obj_external('%s') %x\n",s.Sident.ptr,s.Svalue);
    symbol_debug(s);
    reset_symbuf.пиши((&s)[0 .. 1]);
    const namidx = elf_addmangled(s);

version (SCPP)
{
    if (s.Sscope && !tyfunc(s.ty()))
    {
        symtype = STT_OBJECT;
        sectype = SHN_COMMON;
        size = type_size(s.Stype);
    }
    else
    {
        symtype = STT_NOTYPE;
        sectype = SHN_UNDEF;
        size = 0;
    }
}
else
{
    symtype = STT_NOTYPE;
    sectype = SHN_UNDEF;
    size = 0;
}
    if (s.ty() & mTYthread)
    {
        //printf("Obj_external('%s') %x TLS\n",s.Sident.ptr,s.Svalue);
        symtype = STT_TLS;
    }

    s.Sxtrnnum = elf_addsym(namidx, size, size, symtype,
        /*(s.ty() & mTYweak) ? STB_WEAK : */STB_GLOBAL, sectype);
    return s.Sxtrnnum;

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
    //printf("Obj_common_block('%s',%d,%d)\n",s.Sident.ptr,size,count);
    symbol_debug(s);

    цел align_ = I64 ? 16 : 4;
    if (s.ty() & mTYthread)
    {
        s.Sseg = Obj_getsegment(".tbss.", cpp_mangle2(s),
                SHT_NOBITS, SHF_ALLOC|SHF_WRITE|SHF_TLS, align_);
        s.Sfl = FLtlsdata;
        SegData[s.Sseg].SDsym = s;
        SegData[s.Sseg].SDoffset += size * count;
        Obj_pubdefsize(s.Sseg, s, 0, size * count);
        searchfixlist(s);
        return s.Sseg;
    }
    else
    {
        s.Sseg = Obj_getsegment(".bss.", cpp_mangle2(s),
                SHT_NOBITS, SHF_ALLOC|SHF_WRITE, align_);
        s.Sfl = FLudata;
        SegData[s.Sseg].SDsym = s;
        SegData[s.Sseg].SDoffset += size * count;
        Obj_pubdefsize(s.Sseg, s, 0, size * count);
        searchfixlist(s);
        return s.Sseg;
    }
static if (0)
{
    reset_symbuf.пиши(s);
    const namidx = elf_addmangled(s);
    alignOffset(UDATA,size);
    const symidx = elf_addsym(namidx, SegData[UDATA].SDoffset, size*count,
                   (s.ty() & mTYthread) ? STT_TLS : STT_OBJECT,
                   STB_WEAK, SHN_BSS);
    //dbg_printf("\tObj_common_block returning symidx %d\n",symidx);
    s.Sseg = UDATA;
    s.Sfl = FLudata;
    SegData[UDATA].SDoffset += size * count;
    return symidx;
}
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
    if (seg == UDATA || seg == UNKNOWN)
    {   // Use SDoffset to record size of .BSS section
        SegData[UDATA].SDoffset += count;
    }
    else if (MAP_SEG2SEC(seg).sh_type == SHT_NOBITS)
    {   // Use SDoffset to record size of .TBSS section
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
        //dbg_printf("Obj_bytes(seg=%d, смещение=x%lx, члобайт=%d, p=x%x)\n", seg, смещение, члобайт, p);
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

/*******************************
 * Output a relocation entry for a segment
 * Input:
 *      seg =           where the address is going
 *      смещение =        смещение within seg
 *      тип =          ELF relocation тип R_ARCH_XXXX
 *      index =         Related symbol table index
 *      val =           addend or displacement from address
 */

 цел relcnt=0;

проц Obj_addrel(цел seg, targ_т_мера смещение, бцел тип,
                    IDXSYM symidx, targ_т_мера val)
{
    seg_data *segdata;
    Outbuffer *буф;
    IDXSEC secidx;

    //assert(val == 0);
    relcnt++;
    //dbg_printf("%d-Obj_addrel(seg %d,смещение x%x,тип x%x,symidx %d,val %d)\n",
            //relcnt,seg, смещение, тип, symidx,val);

    assert(seg >= 0 && seg <= seg_count);
    segdata = SegData[seg];
    secidx = MAP_SEG2SECIDX(seg);
    assert(secidx != 0);

    if (segdata.SDrel == null)
    {
        segdata.SDrel = cast(Outbuffer*) calloc(1, (Outbuffer).sizeof);
        assert(segdata.SDrel);
    }

    if (segdata.SDrel.size() == 0)
    {   IDXSEC relidx;

        if (secidx == SHN_TEXT)
            relidx = SHN_RELTEXT;
        else if (secidx == SHN_DATA)
            relidx = SHN_RELDATA;
        else
        {
            // Get the section имя, and make a копируй because
            // elf_newsection() may reallocate the ткст буфер.
            сим *section_name = cast(сим *)GET_SECTION_NAME(secidx);
            т_мера len = strlen(section_name) + 1;
            сим[20] buf2 = проц;
            сим *p = len <= buf2.sizeof ? &buf2[0] : cast(сим *)malloc(len);
            assert(p);
            memcpy(p, section_name, len);

            relidx = elf_newsection(I64 ? ".rela" : ".rel", p, I64 ? SHT_RELA : SHT_REL, 0);
            if (p != &buf2[0])
                free(p);
            segdata.SDrelidx = relidx;
            addSectionToComdat(relidx,seg);
        }

        if (I64)
        {
            /* Note that we're using Elf32_Shdr here instead of Elf64_Shdr. This is to make
             * the code a bit simpler. In Obj_term(), we translate the Elf32_Shdr into the proper
             * Elf64_Shdr.
             */
            Elf32_Shdr *relsec = &SecHdrTab[relidx];
            relsec.sh_link = SHN_SYMTAB;
            relsec.sh_info = secidx;
            relsec.sh_entsize = Elf64_Rela.sizeof;
            relsec.sh_addralign = 8;
        }
        else
        {
            Elf32_Shdr *relsec = &SecHdrTab[relidx];
            relsec.sh_link = SHN_SYMTAB;
            relsec.sh_info = secidx;
            relsec.sh_entsize = Elf32_Rel.sizeof;
            relsec.sh_addralign = 4;
        }
    }

    if (I64)
    {
        Elf64_Rela rel;
        rel.r_offset = смещение;          // build relocation information
        rel.r_info = ELF64_R_INFO(symidx,тип);
        rel.r_addend = val;
        буф = segdata.SDrel;
        буф.пиши(&rel,(rel).sizeof);
        segdata.SDrelcnt++;

        if (смещение >= segdata.SDrelmaxoff)
            segdata.SDrelmaxoff = смещение;
        else
        {   // вставь numerically
            Elf64_Rela *relbuf = cast(Elf64_Rela *)буф.буф;
            цел i = relbuf[segdata.SDrelindex].r_offset > смещение ? 0 : segdata.SDrelindex;
            while (i < segdata.SDrelcnt)
            {
                if (relbuf[i].r_offset > смещение)
                    break;
                i++;
            }
            assert(i != segdata.SDrelcnt);     // slide greater offsets down
            memmove(relbuf+i+1,relbuf+i,Elf64_Rela.sizeof * (segdata.SDrelcnt - i - 1));
            *(relbuf+i) = rel;          // копируй to correct location
            segdata.SDrelindex = i;    // следщ entry usually greater
        }
    }
    else
    {
        Elf32_Rel rel;
        rel.r_offset = cast(бцел)смещение;          // build relocation information
        rel.r_info = ELF32_R_INFO(symidx,тип);
        буф = segdata.SDrel;
        буф.пиши(&rel,rel.sizeof);
        segdata.SDrelcnt++;

        if (смещение >= segdata.SDrelmaxoff)
            segdata.SDrelmaxoff = смещение;
        else
        {   // вставь numerically
            Elf32_Rel *relbuf = cast(Elf32_Rel *)буф.буф;
            цел i = relbuf[segdata.SDrelindex].r_offset > смещение ? 0 : segdata.SDrelindex;
            while (i < segdata.SDrelcnt)
            {
                if (relbuf[i].r_offset > смещение)
                    break;
                i++;
            }
            assert(i != segdata.SDrelcnt);     // slide greater offsets down
            memmove(relbuf+i+1,relbuf+i,Elf32_Rel.sizeof * (segdata.SDrelcnt - i - 1));
            *(relbuf+i) = rel;          // копируй to correct location
            segdata.SDrelindex = i;    // следщ entry usually greater
        }
    }
}

private т_мера relsize64(бцел тип)
{
    assert(I64);
    switch (тип)
    {
        case R_X86_64_NONE:      return 0;
        case R_X86_64_64:        return 8;
        case R_X86_64_PC32:      return 4;
        case R_X86_64_GOT32:     return 4;
        case R_X86_64_PLT32:     return 4;
        case R_X86_64_COPY:      return 0;
        case R_X86_64_GLOB_DAT:  return 8;
        case R_X86_64_JUMP_SLOT: return 8;
        case R_X86_64_RELATIVE:  return 8;
        case R_X86_64_GOTPCREL:  return 4;
        case R_X86_64_32:        return 4;
        case R_X86_64_32S:       return 4;
        case R_X86_64_16:        return 2;
        case R_X86_64_PC16:      return 2;
        case R_X86_64_8:         return 1;
        case R_X86_64_PC8:       return 1;
        case R_X86_64_DTPMOD64:  return 8;
        case R_X86_64_DTPOFF64:  return 8;
        case R_X86_64_TPOFF64:   return 8;
        case R_X86_64_TLSGD:     return 4;
        case R_X86_64_TLSLD:     return 4;
        case R_X86_64_DTPOFF32:  return 4;
        case R_X86_64_GOTTPOFF:  return 4;
        case R_X86_64_TPOFF32:   return 4;
        case R_X86_64_PC64:      return 8;
        case R_X86_64_GOTOFF64:  return 8;
        case R_X86_64_GOTPC32:   return 4;

        default:
            assert(0);
    }
}

private т_мера relsize32(бцел тип)
{
    assert(I32);
    switch (тип)
    {
        case R_386_NONE:         return 0;
        case R_386_32:           return 4;
        case R_386_PC32:         return 4;
        case R_386_GOT32:        return 4;
        case R_386_PLT32:        return 4;
        case R_386_COPY:         return 0;
        case R_386_GLOB_DAT:     return 4;
        case R_386_JMP_SLOT:     return 4;
        case R_386_RELATIVE:     return 4;
        case R_386_GOTOFF:       return 4;
        case R_386_GOTPC:        return 4;
        case R_386_TLS_TPOFF:    return 4;
        case R_386_TLS_IE:       return 4;
        case R_386_TLS_GOTIE:    return 4;
        case R_386_TLS_LE:       return 4;
        case R_386_TLS_GD:       return 4;
        case R_386_TLS_LDM:      return 4;
        case R_386_TLS_GD_32:    return 4;
        case R_386_TLS_GD_PUSH:  return 4;
        case R_386_TLS_GD_CALL:  return 4;
        case R_386_TLS_GD_POP:   return 4;
        case R_386_TLS_LDM_32:   return 4;
        case R_386_TLS_LDM_PUSH: return 4;
        case R_386_TLS_LDM_CALL: return 4;
        case R_386_TLS_LDM_POP:  return 4;
        case R_386_TLS_LDO_32:   return 4;
        case R_386_TLS_IE_32:    return 4;
        case R_386_TLS_LE_32:    return 4;
        case R_386_TLS_DTPMOD32: return 4;
        case R_386_TLS_DTPOFF32: return 4;
        case R_386_TLS_TPOFF32:  return 4;

        default:
            assert(0);
    }
}

/*******************************
 * Write/Append a значение to the given segment and смещение.
 *      targseg =       the target segment for the relocation
 *      смещение =        смещение within target segment
 *      val =           addend or displacement from symbol
 *      size =          number of bytes to пиши
 */
private т_мера writeaddrval(цел targseg, т_мера смещение, targ_т_мера val, т_мера size)
{
    assert(targseg >= 0 && targseg <= seg_count);

    Outbuffer *буф = SegData[targseg].SDbuf;
    const save = буф.size();
    буф.устРазм(cast(бцел)смещение);
    буф.пиши(&val, cast(бцел)size);
    // restore Outbuffer position
    if (save > смещение + size)
        буф.устРазм(cast(бцел)save);
    return size;
}

/*******************************
 * Write/Append a relocatable значение to the given segment and смещение.
 * Input:
 *      targseg =       the target segment for the relocation
 *      смещение =        смещение within target segment
 *      reltype =       ELF relocation тип R_ARCH_XXXX
 *      symidx =        symbol base for relocation
 *      val =           addend or displacement from symbol
 */
т_мера Obj_writerel(цел targseg, т_мера смещение, reltype_t reltype,
                        IDXSYM symidx, targ_т_мера val)
{
    assert(reltype != R_X86_64_NONE);

    т_мера sz;
    if (I64)
    {
        // Elf64_Rela stores addend in Rela.r_addend field
        sz = relsize64(reltype);
        writeaddrval(targseg, смещение, 0, sz);
        Obj_addrel(targseg, смещение, reltype, symidx, val);
    }
    else
    {
        assert(I32);
        // Elf32_Rel stores addend in target location
        sz = relsize32(reltype);
        writeaddrval(targseg, смещение, val, sz);
        Obj_addrel(targseg, смещение, reltype, symidx, 0);
    }
    return sz;
}

/*******************************
 * Refer to address that is in the данные segment.
 * Input:
 *      seg =           where the address is going
 *      смещение =        смещение within seg
 *      val =           displacement from address
 *      targetdatum =   DATA, CDATA or UDATA, depending where the address is
 *      flags =         CFoff, CFseg, CFoffset64, CFswitch
 * Example:
 *      цел *abc = &def[3];
 *      to размести storage:
 *              Obj_reftodatseg(DATA,смещение,3 * (цел *).sizeof,UDATA);
 * Note:
 *      For I64 && (flags & CFoffset64) && (flags & CFswitch)
 *      targetdatum is a symidx rather than a segment.
 */

проц Obj_reftodatseg(цел seg,targ_т_мера смещение,targ_т_мера val,
        бцел targetdatum,цел flags)
{
static if (0)
{
    printf("Obj_reftodatseg(seg=%d, смещение=x%llx, val=x%llx,данные %x, flags %x)\n",
        seg,cast(бдол)смещение,cast(бдол)val,targetdatum,flags);
}

    reltype_t relinfo;
    IDXSYM targetsymidx = STI_RODAT;
    if (I64)
    {

        if (flags & CFoffset64)
        {
            relinfo = R_X86_64_64;
            if (flags & CFswitch) targetsymidx = targetdatum;
        }
        else if (flags & CFswitch)
        {
            relinfo = R_X86_64_PC32;
            targetsymidx = MAP_SEG2SYMIDX(targetdatum);
        }
        else if (MAP_SEG2TYP(seg) == CODE && config.flags3 & CFG3pic)
        {
            relinfo = R_X86_64_PC32;
            val -= 4;
            targetsymidx = MAP_SEG2SYMIDX(targetdatum);
        }
        else if (MAP_SEG2SEC(targetdatum).sh_flags & SHF_TLS)
        {
            if (config.flags3 & CFG3pie)
                relinfo = R_X86_64_TPOFF32;
            else
                relinfo = config.flags3 & CFG3pic ? R_X86_64_TLSGD : R_X86_64_TPOFF32;
        }
        else
        {
            relinfo = targetdatum == CDATA ? R_X86_64_32 : R_X86_64_32S;
            targetsymidx = MAP_SEG2SYMIDX(targetdatum);
        }
    }
    else
    {
        if (MAP_SEG2TYP(seg) == CODE && config.flags3 & CFG3pic)
            relinfo = R_386_GOTOFF;
        else if (MAP_SEG2SEC(targetdatum).sh_flags & SHF_TLS)
        {
            if (config.flags3 & CFG3pie)
                relinfo = R_386_TLS_LE;
            else
                relinfo = config.flags3 & CFG3pic ? R_386_TLS_GD : R_386_TLS_LE;
        }
        else
            relinfo = R_386_32;
        targetsymidx = MAP_SEG2SYMIDX(targetdatum);
    }
    Obj_writerel(seg, cast(бцел)смещение, relinfo, targetsymidx, val);
}

/*******************************
 * Refer to address that is in the code segment.
 * Only offsets are output, regardless of the memory model.
 * Used to put values in switch address tables.
 * Input:
 *      seg =           where the address is going (CODE or DATA)
 *      смещение =        смещение within seg
 *      val =           displacement from start of this module
 */

проц Obj_reftocodeseg(цел seg,targ_т_мера смещение,targ_т_мера val)
{
    //dbg_printf("Obj_reftocodeseg(seg=%d, смещение=x%lx, val=x%lx )\n",seg,смещение,val);

    reltype_t relinfo;
static if (0)
{
    if (MAP_SEG2TYP(seg) == CODE)
    {
        relinfo = RI_TYPE_PC32;
        Obj_writerel(seg, смещение, relinfo, funcsym_p.Sxtrnnum, val - funcsym_p.Soffset);
        return;
    }
}

    if (I64)
        relinfo = (config.flags3 & CFG3pic) ? R_X86_64_PC32 : R_X86_64_32;
    else
        relinfo = (config.flags3 & CFG3pic) ? R_386_GOTOFF : R_386_32;
    Obj_writerel(seg, cast(бцел)смещение, relinfo, funcsym_p.Sxtrnnum, val - funcsym_p.Soffset);
}

/*******************************
 * Refer to an идентификатор.
 * Input:
 *      segtyp =        where the address is going (CODE or DATA)
 *      смещение =        смещение within seg
 *      s =             Symbol table entry for идентификатор
 *      val =           displacement from идентификатор
 *      flags =         CFselfrel: self-relative
 *                      CFseg: get segment
 *                      CFoff: get смещение
 *                      CFoffset64: 64 bit fixup
 *                      CFpc32: I64: PC relative 32 bit fixup
 * Возвращает:
 *      number of bytes in reference (4 or 8)
 */

цел Obj_reftoident(цел seg, targ_т_мера смещение, Symbol *s, targ_т_мера val,
        цел flags)
{
    бул external = да;
    Outbuffer *буф;
    reltype_t relinfo = R_X86_64_NONE;
    цел refseg;
    const segtyp = MAP_SEG2TYP(seg);
    //assert(val == 0);
    цел retsize = (flags & CFoffset64) ? 8 : 4;

static if (0)
{
    printf("\nObj_reftoident('%s' seg %d, смещение x%llx, val x%llx, flags x%x)\n",
        s.Sident.ptr,seg,смещение,val,flags);
    printf("Sseg = %d, Sxtrnnum = %d, retsize = %d\n",s.Sseg,s.Sxtrnnum,retsize);
    symbol_print(s);
}

    const tym_t ty = s.ty();
    if (s.Sxtrnnum)
    {                           // идентификатор is defined somewhere else
        if (I64)
        {
            if (SymbolTable64[s.Sxtrnnum].st_shndx != SHN_UNDEF)
                external = нет;
        }
        else
        {
            if (SymbolTable[s.Sxtrnnum].st_shndx != SHN_UNDEF)
                external = нет;
        }
    }

    switch (s.Sclass)
    {
        case SClocstat:
            if (I64)
            {
                if (s.Sfl == FLtlsdata)
                {
                    if (config.flags3 & CFG3pie)
                        relinfo = R_X86_64_TPOFF32;
                    else
                        relinfo = config.flags3 & CFG3pic ? R_X86_64_TLSGD : R_X86_64_TPOFF32;
                }
                else
                {   relinfo = config.flags3 & CFG3pic ? R_X86_64_PC32 : R_X86_64_32;
                    if (flags & CFpc32)
                        relinfo = R_X86_64_PC32;
                }
            }
            else
            {
                if (s.Sfl == FLtlsdata)
                {
                    if (config.flags3 & CFG3pie)
                        relinfo = R_386_TLS_LE;
                    else
                        relinfo = config.flags3 & CFG3pic ? R_386_TLS_GD : R_386_TLS_LE;
                }
                else
                    relinfo = config.flags3 & CFG3pic ? R_386_GOTOFF : R_386_32;
            }
            if (flags & CFoffset64 && relinfo == R_X86_64_32)
            {
                relinfo = R_X86_64_64;
                retsize = 8;
            }
            refseg = STI_RODAT;
            val += s.Soffset;
            goto outrel;

        case SCcomdat:
        case_SCcomdat:
        case SCstatic:
static if (0)
{
            if ((s.Sflags & SFLthunk) && s.Soffset)
            {                   // A thunk symbol that has been defined
                assert(s.Sseg == seg);
                val = (s.Soffset+val) - (смещение+4);
                goto outaddrval;
            }
}
            goto case;

        case SCextern:
        case SCcomdef:
        case_extern:
        case SCglobal:
            if (!s.Sxtrnnum)
            {   // not in symbol table yet - class might change
                //printf("\tadding %s to fixlist\n",s.Sident.ptr);
                т_мера numbyteswritten = addtofixlist(s,смещение,seg,val,flags);
                assert(numbyteswritten == retsize);
                return retsize;
            }
            else
            {
                refseg = s.Sxtrnnum;       // default to имя symbol table entry

                if (flags & CFselfrel)
                {               // only for function references within code segments
                    if (!external &&            // local definition found
                         s.Sseg == seg &&      // within same code segment
                          (!(config.flags3 & CFG3pic) ||        // not position indp code
                           s.Sclass == SCstatic)) // or is pic, but declared static
                    {                   // Can use PC relative
                        //dbg_printf("\tdoing PC relative\n");
                        val = (s.Soffset+val) - (смещение+4);
                    }
                    else
                    {
                        //dbg_printf("\tadding relocation\n");
                        if (s.Sclass == SCglobal && config.flags3 & CFG3pie && tyfunc(s.ty()))
                            relinfo = I64 ? R_X86_64_PC32 : R_386_PC32;
                        else if (I64)
                            relinfo = config.flags3 & CFG3pic ?  R_X86_64_PLT32 : R_X86_64_PC32;
                        else
                            relinfo = config.flags3 & CFG3pic ?  R_386_PLT32 : R_386_PC32;
                        val = -cast(targ_т_мера)4;
                    }
                }
                else
                {       // code to code code to данные, данные to code, данные to данные refs
                    if (s.Sclass == SCstatic)
                    {                           // смещение into .данные or .bss seg
                        refseg = MAP_SEG2SYMIDX(s.Sseg);
                                                // use segment symbol table entry
                        val += s.Soffset;
                        if (!(config.flags3 & CFG3pic) ||       // all static refs from normal code
                             segtyp == DATA)    // or refs from данные from posi indp
                        {
                            if (I64)
                                relinfo = (flags & CFpc32) ? R_X86_64_PC32 : R_X86_64_32;
                            else
                                relinfo = R_386_32;
                        }
                        else
                        {
                            relinfo = I64 ? R_X86_64_PC32 : R_386_GOTOFF;
                        }
                    }
                    else if (config.flags3 & CFG3pic && s == GOTsym)
                    {                   // relocation for Gbl Offset Tab
                        relinfo =  I64 ? R_X86_64_NONE : R_386_GOTPC;
                    }
                    else if (segtyp == DATA)
                    {                   // relocation from within DATA seg
                        relinfo = I64 ? R_X86_64_32 : R_386_32;
                        if (I64 && flags & CFpc32)
                            relinfo = R_X86_64_PC32;
                    }
                    else
                    {                   // relocation from within CODE seg
                        if (I64)
                        {
                            if (config.flags3 & CFG3pie && s.Sclass == SCglobal)
                                relinfo = R_X86_64_PC32;
                            else if (config.flags3 & CFG3pic)
                                relinfo = R_X86_64_GOTPCREL;
                            else
                                relinfo = (flags & CFpc32) ? R_X86_64_PC32 : R_X86_64_32;
                        }
                        else
                        {
                            if (config.flags3 & CFG3pie && s.Sclass == SCglobal)
                                relinfo = R_386_GOTOFF;
                            else
                                relinfo = config.flags3 & CFG3pic ? R_386_GOT32 : R_386_32;
                        }
                    }
                    if ((s.ty() & mTYLINK) & mTYthread)
                    {
                        if (I64)
                        {
                            if (config.flags3 & CFG3pie)
                            {
                                if (s.Sclass == SCstatic || s.Sclass == SCglobal)
                                    relinfo = R_X86_64_TPOFF32;
                                else
                                    relinfo = R_X86_64_GOTTPOFF;
                            }
                            else if (config.flags3 & CFG3pic)
                            {
                                /+if (s.Sclass == SCstatic || s.Sclass == SClocstat)
                                    // Could use 'local dynamic (LD)' to optimize multiple local TLS reads
                                    relinfo = R_X86_64_TLSGD;
                                else+/
                                    relinfo = R_X86_64_TLSGD;
                            }
                            else
                            {
                                if (s.Sclass == SCstatic || s.Sclass == SClocstat)
                                    relinfo = R_X86_64_TPOFF32;
                                else
                                    relinfo = R_X86_64_GOTTPOFF;
                            }
                        }
                        else
                        {
                            if (config.flags3 & CFG3pie)
                            {
                                if (s.Sclass == SCstatic || s.Sclass == SCglobal)
                                    relinfo = R_386_TLS_LE;
                                else
                                    relinfo = R_386_TLS_GOTIE;
                            }
                            else if (config.flags3 & CFG3pic)
                            {
                                /+if (s.Sclass == SCstatic)
                                    // Could use 'local dynamic (LD)' to optimize multiple local TLS reads
                                    relinfo = R_386_TLS_GD;
                                else+/
                                    relinfo = R_386_TLS_GD;
                            }
                            else
                            {
                                if (s.Sclass == SCstatic)
                                    relinfo = R_386_TLS_LE;
                                else
                                    relinfo = R_386_TLS_IE;
                            }
                        }
                    }
                    if (flags & CFoffset64 && relinfo == R_X86_64_32)
                    {
                        relinfo = R_X86_64_64;
                    }
                }
                if (relinfo == R_X86_64_NONE)
                {
                outaddrval:
                    writeaddrval(seg, cast(бцел)смещение, val, retsize);
                }
                else
                {
                outrel:
                    //printf("\t\t************* adding relocation\n");
                    const т_мера члобайт = Obj_writerel(seg, cast(бцел)смещение, relinfo, refseg, val);
                    assert(члобайт == retsize);
                }
            }
            break;

        case SCsinline:
        case SCeinline:
            printf ("Undefined inline значение <<fixme>>\n");
            //warerr(WM_undefined_inline,s.Sident.ptr);
            goto  case;

        case SCinline:
            if (tyfunc(ty))
            {
                s.Sclass = SCextern;
                goto case_extern;
            }
            else if (config.flags2 & CFG2comdat)
                goto case_SCcomdat;     // treat as initialized common block
            goto default;

        default:
            //symbol_print(s);
            assert(0);
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
static if (TERMCODE)
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
}
+/

цел elf_align(targ_т_мера size,цел foffset)
{
    if (size <= 1)
        return foffset;
    цел смещение = cast(цел)((foffset + size - 1) & ~(size - 1));
    if (смещение > foffset)
        fobjbuf.writezeros(смещение - foffset);
    return смещение;
}

/***************************************
 * Stuff pointer to ModuleInfo into its own section (minfo).
 */

version (Dinrus)
{

проц Obj_moduleinfo(Symbol *scc)
{
    const CFflags = I64 ? (CFoffset64 | CFoff) : CFoff;

    // needs to be writeable for PIC code, see Bugzilla 13117
    const shf_flags = SHF_ALLOC | SHF_WRITE;
    const seg = Obj_getsegment("minfo", null, SHT_PROGBITS, shf_flags, _tysize[TYnptr]);
    SegData[seg].SDoffset +=
        Obj_reftoident(seg, SegData[seg].SDoffset, scc, 0, CFflags);
}

/***************************************
 * Create startup/shutdown code to register an executable/shared
 * library (DSO) with druntime. Create one for each объект файл and
 * put the sections into a COMDAT group. This will ensure that each
 * DSO gets registered only once.
 */

private проц obj_rtinit()
{
    // section start/stop symbols are defined by the linker (http://www.airs.com/blog/archives/56)
    // make the symbols hidden so that each DSO gets it's own brackets
    IDXSYM minfo_beg, minfo_end, dso_rec;

    {
    // needs to be writeable for PIC code, see Bugzilla 13117
    const shf_flags = SHF_ALLOC | SHF_WRITE;

    const namidx = Obj_addstr(symtab_strings,"__start_minfo");
    minfo_beg = elf_addsym(namidx, 0, 0, STT_NOTYPE, STB_GLOBAL, SHN_UNDEF, STV_HIDDEN);

    Obj_getsegment("minfo", null, SHT_PROGBITS, shf_flags, _tysize[TYnptr]);

    const namidx2 = Obj_addstr(symtab_strings,"__stop_minfo");
    minfo_end = elf_addsym(namidx2, 0, 0, STT_NOTYPE, STB_GLOBAL, SHN_UNDEF, STV_HIDDEN);
    }

    // Create a COMDAT section group
    const groupseg = Obj_getsegment(".group.d_dso", null, SHT_GROUP, 0, 0);
    SegData[groupseg].SDbuf.write32(GRP_COMDAT);

    {
        /*
         * Create an instance of DSORec as глоб2 static данные in the section .данные.d_dso_rec
         * It is writeable and allows the runtime to store information.
         * Make it a COMDAT so there's only one per DSO.
         *
         * typedef union
         * {
         *     т_мера        ид;
         *     проц       *данные;
         * } DSORec;
         */
        const seg = Obj_getsegment(".данные.d_dso_rec", null, SHT_PROGBITS,
                         SHF_ALLOC|SHF_WRITE|SHF_GROUP, _tysize[TYnptr]);
        dso_rec = MAP_SEG2SYMIDX(seg);
        Obj_bytes(seg, 0, _tysize[TYnptr], null);
        // add to section group
        SegData[groupseg].SDbuf.write32(MAP_SEG2SECIDX(seg));

        /*
         * Create an instance of DSO on the stack:
         *
         * typedef struct
         * {
         *     т_мера                version;
         *     DSORec               *dso_rec;
         *     проц   *minfo_beg, *minfo_end;
         * } DSO;
         *
         * Generate the following function as a COMDAT so there's only one per DSO:
         *  .text.d_dso_init    segment
         *      сунь    EBP
         *      mov     EBP,ESP
         *      sub     ESP,align
         *      lea     RAX,minfo_end[RIP]
         *      сунь    RAX
         *      lea     RAX,minfo_beg[RIP]
         *      сунь    RAX
         *      lea     RAX,.данные.d_dso_rec[RIP]
         *      сунь    RAX
         *      сунь    1       // version
         *      mov     RDI,RSP
         *      call      _d_dso_registry@PLT32
         *      leave
         *      ret
         * and then put a pointer to that function in .init_array and in .fini_array so it'll
         * get executed once upon loading and once upon unloading the DSO.
         */
        const codseg = Obj_getsegment(".text.d_dso_init", null, SHT_PROGBITS,
                                SHF_ALLOC|SHF_EXECINSTR|SHF_GROUP, _tysize[TYnptr]);
        // add to section group
        SegData[groupseg].SDbuf.write32(MAP_SEG2SECIDX(codseg));

        debug
        {
            // adds a local symbol (имя) to the code, useful to set a breakpoint
            const namidx = Obj_addstr(symtab_strings, "__d_dso_init");
            elf_addsym(namidx, 0, 0, STT_FUNC, STB_LOCAL, MAP_SEG2SECIDX(codseg));
        }

        Outbuffer *буф = SegData[codseg].SDbuf;
        assert(!буф.size());
        т_мера off = 0;

        // 16-byte align for call
        const т_мера sizeof_dso = 6 * _tysize[TYnptr];
        const т_мера align_ = I64 ?
            // return address, RBP, DSO
            (-(2 * _tysize[TYnptr] + sizeof_dso) & 0xF) :
            // return address, EBP, EBX, DSO, arg
            (-(3 * _tysize[TYnptr] + sizeof_dso + _tysize[TYnptr]) & 0xF);

        // сунь EBP
        буф.пишиБайт(0x50 + BP);
        off += 1;
        // mov EBP, ESP
        if (I64)
        {
            буф.пишиБайт(REX | REX_W);
            off += 1;
        }
        буф.пишиБайт(0x8B);
        буф.пишиБайт(modregrm(3,BP,SP));
        off += 2;
        // sub ESP, align_
        if (align_)
        {
            if (I64)
            {
                буф.пишиБайт(REX | REX_W);
                off += 1;
            }
            буф.пишиБайт(0x81);
            буф.пишиБайт(modregrm(3,5,SP));
            буф.пишиБайт(align_ & 0xFF);
            буф.пишиБайт(align_ >> 8 & 0xFF);
            буф.пишиБайт(0);
            буф.пишиБайт(0);
            off += 6;
        }

        if (config.flags3 & CFG3pic && I32)
        {   // see cod3_load_got() for reference
            // сунь EBX
            буф.пишиБайт(0x50 + BX);
            off += 1;
            // call L1
            буф.пишиБайт(0xE8);
            буф.write32(0);
            // L1: вынь EBX (now содержит EIP)
            буф.пишиБайт(0x58 + BX);
            off += 6;
            // add EBX,_GLOBAL_OFFSET_TABLE_+3
            буф.пишиБайт(0x81);
            буф.пишиБайт(modregrm(3,0,BX));
            off += 2;
            off += Obj_writerel(codseg, off, R_386_GOTPC, Obj_external(Obj_getGOTsym()), 3);
        }

        reltype_t reltype;
        opcode_t op;
        if (0 && config.flags3 & CFG3pie)
        {
            op = LOD;
            reltype = I64 ? R_X86_64_GOTPCREL : R_386_GOT32;
        }
        else if (config.flags3 & CFG3pic)
        {
            op = LEA;
            reltype = I64 ? R_X86_64_PC32 : R_386_GOTOFF;
        }
        else
        {
            op = LEA;
            reltype = I64 ? R_X86_64_32 : R_386_32;
        }

        const IDXSYM[3] syms = [dso_rec, minfo_beg, minfo_end];

        for (т_мера i = (syms).sizeof / (syms[0]).sizeof; i--; )
        {
            const IDXSYM sym = syms[i];

            if (config.flags3 & CFG3pic)
            {
                if (I64)
                {
                    // lea RAX, sym[RIP]
                    буф.пишиБайт(REX | REX_W);
                    буф.пишиБайт(op);
                    буф.пишиБайт(modregrm(0,AX,5));
                    off += 3;
                    off += Obj_writerel(codseg, off, reltype, syms[i], -4);
                }
                else
                {
                    // lea EAX, sym[EBX]
                    буф.пишиБайт(op);
                    буф.пишиБайт(modregrm(2,AX,BX));
                    off += 2;
                    off += Obj_writerel(codseg, off, reltype, syms[i], 0);
                }
            }
            else
            {
                // mov EAX, sym
                буф.пишиБайт(0xB8 + AX);
                off += 1;
                off += Obj_writerel(codseg, off, reltype, syms[i], 0);
            }
            // сунь RAX
            буф.пишиБайт(0x50 + AX);
            off += 1;
        }
        буф.пишиБайт(0x6A);            // PUSH 1
        буф.пишиБайт(1);               // version флаг to simplify future extensions
        off += 2;

        if (I64)
        {   // mov RDI, DSO*
            буф.пишиБайт(REX | REX_W);
            буф.пишиБайт(0x8B);
            буф.пишиБайт(modregrm(3,DI,SP));
            off += 3;
        }
        else
        {   // сунь DSO*
            буф.пишиБайт(0x50 + SP);
            off += 1;
        }

static if (REQUIRE_DSO_REGISTRY)
{

        const IDXSYM symidx = Obj_external_def("_d_dso_registry");

        // call _d_dso_registry@PLT
        буф.пишиБайт(0xE8);
        off += 1;
        off += Obj_writerel(codseg, off, I64 ? R_X86_64_PLT32 : R_386_PLT32, symidx, -4);

}
else
{

        // use a weak reference for _d_dso_registry
        const namidx = Obj_addstr(symtab_strings, "_d_dso_registry");
        const IDXSYM symidx = elf_addsym(namidx, 0, 0, STT_NOTYPE, STB_WEAK, SHN_UNDEF);

        if (config.flags3 & CFG3pic)
        {
            if (I64)
            {
                // cmp foo@GOT[RIP], 0
                буф.пишиБайт(REX | REX_W);
                буф.пишиБайт(0x83);
                буф.пишиБайт(modregrm(0,7,5));
                off += 3;
                const reltype = /*config.flags3 & CFG3pie ? R_X86_64_PC32 :*/ R_X86_64_GOTPCREL;
                off += Obj_writerel(codseg, off, reltype, symidx, -5);
                буф.пишиБайт(0);
                off += 1;
            }
            else
            {
                // cmp foo[GOT], 0
                буф.пишиБайт(0x81);
                буф.пишиБайт(modregrm(2,7,BX));
                off += 2;
                const reltype = /*config.flags3 & CFG3pie ? R_386_GOTOFF :*/ R_386_GOT32;
                off += Obj_writerel(codseg, off, reltype, symidx, 0);
                буф.write32(0);
                off += 4;
            }
            // jz +5
            буф.пишиБайт(0x74);
            буф.пишиБайт(0x05);
            off += 2;

            // call foo@PLT[RIP]
            буф.пишиБайт(0xE8);
            off += 1;
            off += Obj_writerel(codseg, off, I64 ? R_X86_64_PLT32 : R_386_PLT32, symidx, -4);
        }
        else
        {
            // mov ECX, смещение foo
            буф.пишиБайт(0xB8 + CX);
            off += 1;
            const reltype = I64 ? R_X86_64_32 : R_386_32;
            off += Obj_writerel(codseg, off, reltype, symidx, 0);

            // test ECX, ECX
            буф.пишиБайт(0x85);
            буф.пишиБайт(modregrm(3,CX,CX));

            // jz +5 (skip call)
            буф.пишиБайт(0x74);
            буф.пишиБайт(0x05);
            off += 4;

            // call _d_dso_registry[RIP]
            буф.пишиБайт(0xE8);
            off += 1;
            off += Obj_writerel(codseg, off, I64 ? R_X86_64_PC32 : R_386_PC32, symidx, -4);
        }

}

        if (config.flags3 & CFG3pic && I32)
        {   // mov EBX,[EBP-4-align_]
            буф.пишиБайт(0x8B);
            буф.пишиБайт(modregrm(1,BX,BP));
            буф.пишиБайт(cast(цел)(-4-align_));
            off += 3;
        }
        // leave
        буф.пишиБайт(0xC9);
        // ret
        буф.пишиБайт(0xC3);
        off += 2;
        Offset(codseg) = off;

        // put a reference into .init_array/.fini_array each
        // needs to be writeable for PIC code, see Bugzilla 13117
        const цел flags = SHF_ALLOC | SHF_WRITE | SHF_GROUP;
        {
            const fini_name = USE_INIT_ARRAY ? ".fini_array.d_dso_dtor" : ".dtors.d_dso_dtor";
            const fini_type = USE_INIT_ARRAY ? SHT_FINI_ARRAY : SHT_PROGBITS;
            const cdseg = Obj_getsegment(fini_name.ptr, null, fini_type, flags, _tysize[TYnptr]);
            assert(!SegData[cdseg].SDbuf.size());
            // add to section group
            SegData[groupseg].SDbuf.write32(MAP_SEG2SECIDX(cdseg));
            // relocation
            const reltype2 = I64 ? R_X86_64_64 : R_386_32;
            SegData[cdseg].SDoffset += Obj_writerel(cdseg, 0, reltype2, MAP_SEG2SYMIDX(codseg), 0);
        }
        {
            const init_name = USE_INIT_ARRAY ? ".init_array.d_dso_ctor" : ".ctors.d_dso_ctor";
            const init_type = USE_INIT_ARRAY ? SHT_INIT_ARRAY : SHT_PROGBITS;
            const cdseg = Obj_getsegment(init_name.ptr, null, init_type, flags, _tysize[TYnptr]);
            assert(!SegData[cdseg].SDbuf.size());
            // add to section group
            SegData[groupseg].SDbuf.write32(MAP_SEG2SECIDX(cdseg));
            // relocation
            const reltype2 = I64 ? R_X86_64_64 : R_386_32;
            SegData[cdseg].SDoffset += Obj_writerel(cdseg, 0, reltype2, MAP_SEG2SYMIDX(codseg), 0);
        }
    }
    // set group section infos
    Offset(groupseg) = SegData[groupseg].SDbuf.size();
    Elf32_Shdr *p = MAP_SEG2SEC(groupseg);
    p.sh_link    = SHN_SYMTAB;
    p.sh_info    = dso_rec; // set the dso_rec as group symbol
    p.sh_entsize = IDXSYM.sizeof;
    p.sh_size    = cast(бцел)Offset(groupseg);
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

Symbol *Obj_tlv_bootstrap()
{
    // specific for Mach-O
    assert(0);
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
    if (config.flags3 & CFG3pic)
    {
        /* fixup: R_X86_64_PC32 sym="DW.ref.имя"
         * symtab: .weak DW.ref.имя,@OBJECT,VALUE=.данные.DW.ref.имя+0x00,SIZE=8
         * Section 13  .данные.DW.ref.имя  PROGBITS,ALLOC,WRITE,SIZE=0x0008(8),OFFSET=0x0138,ALIGN=8
         *  0138:   0  0  0  0  0  0  0  0                           ........
         * Section 14  .rela.данные.DW.ref.имя  RELA,ENTRIES=1,OFFSET=0x0E18,ALIGN=8,LINK=22,INFO=13
         *   0 смещение=00000000 addend=0000000000000000 тип=R_X86_64_64 sym="имя"
         */
        if (!s.Sdw_ref_idx)
        {
            const dataDWref_seg = Obj_getsegment(".данные.DW.ref.", s.Sident.ptr, SHT_PROGBITS, SHF_ALLOC|SHF_WRITE, I64 ? 8 : 4);
            Outbuffer *буф = SegData[dataDWref_seg].SDbuf;
            assert(буф.size() == 0);
            Obj_reftoident(dataDWref_seg, 0, s, 0, I64 ? CFoffset64 : CFoff);

            // Add "DW.ref." ~ имя to the symtab_strings table
            const namidx = cast(IDXSTR)symtab_strings.size();
            symtab_strings.writeString("DW.ref.");
            symtab_strings.устРазм(cast(бцел)(symtab_strings.size() - 1));  // back up over terminating 0
            symtab_strings.writeString(s.Sident.ptr);

            s.Sdw_ref_idx = elf_addsym(namidx, val, 8, STT_OBJECT, STB_WEAK, MAP_SEG2SECIDX(dataDWref_seg), STV_HIDDEN);
        }
        Obj_writerel(seg, cast(бцел)смещение, I64 ? R_X86_64_PC32 : R_386_PC32, s.Sdw_ref_idx, 0);
    }
    else
    {
        Obj_reftoident(seg, смещение, s, val, CFoff);
        //dwarf_addrel(seg, смещение, s.Sseg, s.Soffset);
        //et.write32(s.Soffset);
    }
    return 4;
}

}

}
