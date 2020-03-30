/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 2009-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/mscoffobj.d, backend/mscoffobj.d)
 */

module drc.backend.mscoffobj;

version (Dinrus)
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.cv8;
import drc.backend.dlist;
import drc.backend.dvec;
import drc.backend.el;
import drc.backend.md5;
import drc.backend.mem;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.outbuf;
import drc.backend.ty;
import drc.backend.тип;

import drc.backend.mscoff;

/*extern (C++):*/



alias extern(C)  цел function( ук,  ук) _compare_fp_t;
extern(C) проц qsort(ук base, т_мера nmemb, т_мера size, _compare_fp_t compar);

static if (TARGET_WINDOS)
{

extern (C) ткст0 strupr(сим*);

private  Outbuffer *fobjbuf;

const DEST_LEN = (IDMAX + IDOHD + 1);
сим *obj_mangle2(Symbol *s,сим *dest);


цел elf_align(цел size, цел foffset);

/******************************************
 */

// The объект файл is built ib several separate pieces

 private
{

// String Table  - String table for all other имена
    Outbuffer *string_table;

// Section Headers
    public Outbuffer  *ScnhdrBuf;             // Buffer to build section table in

// The -1 is because it is 1 based indexing
IMAGE_SECTION_HEADER* ScnhdrTab() { return cast(IMAGE_SECTION_HEADER *)ScnhdrBuf.буф - 1; }

    цел scnhdr_cnt;          // Number of sections in table
    const SCNHDR_TAB_INITSIZE = 16;  // Initial number of sections in буфер
    const SCNHDR_TAB_INC = 4;        // Number of sections to increment буфер by

    const SYM_TAB_INIT = 100;        // Initial number of symbol entries in буфер
    const SYM_TAB_INC  = 50;         // Number of symbols to increment буфер by

// The symbol table
    Outbuffer *symbuf;

    Outbuffer *syment_buf;   // массив of struct syment

    segidx_t segidx_drectve = UNKNOWN;         // contents of ".drectve" section
    segidx_t segidx_debugS = UNKNOWN;
    segidx_t segidx_xdata = UNKNOWN;
    segidx_t segidx_pdata = UNKNOWN;

    цел jumpTableSeg;                // segment index for __jump_table

    Outbuffer *indirectsymbuf2;      // indirect symbol table of Symbol*'s
    цел pointersSeg;                 // segment index for __pointers

    Outbuffer *ptrref_buf;           // буфер for pointer references

    цел floatused;

/* If an MsCoffObj_external_def() happens, set this to the ткст index,
 * to be added last to the symbol table.
 * Obviously, there can be only one.
 */
    IDXSTR extdef;

// Each compiler segment is a section
// Predefined compiler segments CODE,DATA,CDATA,UDATA map to indexes
//      into SegData[]
//      New compiler segments are added to end.

/******************************
 * Возвращает !=0 if this segment is a code segment.
 */

цел seg_data_isCode(ref seg_data sd)
{
    return (ScnhdrTab[sd.SDshtidx].Characteristics & IMAGE_SCN_CNT_CODE) != 0;
}

public:

// already in cgobj.c (should be part of objmod?):
// seg_data **SegData;
extern цел seg_count;
extern цел seg_max;
segidx_t seg_tlsseg = UNKNOWN;
segidx_t seg_tlsseg_bss = UNKNOWN;

}

/*******************************************************
 * Because the mscoff relocations cannot be computed until after
 * all the segments are written out, and we need more information
 * than the mscoff relocations provide, make our own relocation
 * тип. Later, translate to mscoff relocation structure.
 */

enum
{
    RELaddr   = 0,     // straight address
    RELrel    = 1,     // relative to location to be fixed up
    RELseg    = 2,     // 2 byte section
    RELaddr32 = 3,     // 4 byte смещение
}

struct Relocation
{   // Relocations are attached to the struct seg_data they refer to
    targ_т_мера смещение; // location in segment to be fixed up
    Symbol *funcsym;    // function in which смещение lies, if any
    Symbol *targsym;    // if !=null, then location is to be fixed up
                        // to address of this symbol
    бцел targseg;   // if !=0, then location is to be fixed up
                        // to address of start of this segment
    ббайт rtype;   // RELxxxx
    short val;          // 0, -1, -2, -3, -4, -5
}


/*******************************
 * Output a ткст into a ткст table
 * Input:
 *      strtab  =       ткст table for entry
 *      str     =       ткст to add
 *
 * Возвращает смещение into the specified ткст table.
 */

IDXSTR MsCoffObj_addstr(Outbuffer *strtab, ткст0 str)
{
    //printf("MsCoffObj_addstr(strtab = %p str = '%s')\n",strtab,str);
    IDXSTR idx = cast(IDXSTR)strtab.size();        // remember starting смещение
    strtab.writeString(str);
    //printf("\tidx %d, new size %d\n",idx,strtab.size());
    return idx;
}

/**************************
 * Output читай only данные and generate a symbol for it.
 *
 */

Symbol * MsCoffObj_sym_cdata(tym_t ty,сим *p,цел len)
{
    //printf("MsCoffObj_sym_cdata(ty = %x, p = %x, len = %d, Offset(CDATA) = %x)\n", ty, p, len, Offset(CDATA));
    alignOffset(CDATA, tysize(ty));
    Symbol *s = symboldata(Offset(CDATA), ty);
    s.Sseg = CDATA;
    MsCoffObj_pubdef(CDATA, s, Offset(CDATA));
    MsCoffObj_bytes(CDATA, Offset(CDATA), len, p);

    s.Sfl = FLdata; //FLextern;
    return s;
}

/**************************
 * Ouput читай only данные for данные
 *
 */

цел MsCoffObj_data_readonly(сим *p, цел len, segidx_t *pseg)
{
    цел oldoff;
version (SCPP)
{
    oldoff = Offset(DATA);
    SegData[DATA].SDbuf.резервируй(len);
    SegData[DATA].SDbuf.writen(p,len);
    Offset(DATA) += len;
    *pseg = DATA;
}
else
{
    oldoff = cast(цел)Offset(CDATA);
    SegData[CDATA].SDbuf.резервируй(len);
    SegData[CDATA].SDbuf.writen(p,len);
    Offset(CDATA) += len;
    *pseg = CDATA;
}
    return oldoff;
}

цел MsCoffObj_data_readonly(сим *p, цел len)
{
    segidx_t pseg;

    return MsCoffObj_data_readonly(p, len, &pseg);
}

/*****************************
 * Get segment for readonly ткст literals.
 * The linker will pool strings in this section.
 * Параметры:
 *    sz = number of bytes per character (1, 2, or 4)
 * Возвращает:
 *    segment index
 */
цел MsCoffObj_string_literal_segment(бцел sz)
{
    assert(0);
}

/******************************
 * Start a .obj файл.
 * Called before any other obj_xxx routines.
 * One source файл can generate multiple .obj files.
 */

Obj MsCoffObj_init(Outbuffer *objbuf, ткст0 имяф, ткст0 csegname)
{
    //printf("MsCoffObj_init()\n");
    Obj obj = cast(Obj)mem_calloc(__traits(classInstanceSize, Obj));

    cseg = CODE;
    fobjbuf = objbuf;
    assert(objbuf.size() == 0);

    floatused = 0;

    segidx_drectve = UNKNOWN;
    seg_tlsseg = UNKNOWN;
    seg_tlsseg_bss = UNKNOWN;

    segidx_pdata = UNKNOWN;
    segidx_xdata = UNKNOWN;
    segidx_debugS = UNKNOWN;

    // Initialize buffers

    if (!string_table)
    {
        string_table = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(string_table);
        string_table.enlarge(1024);
        string_table.резервируй(2048);
    }
    string_table.устРазм(0);
    string_table.write32(4);           // first 4 bytes are length of ткст table

    if (symbuf)
    {
        Symbol **p = cast(Symbol **)symbuf.буф;
        const т_мера n = symbuf.size() / (Symbol *).sizeof;
        for (т_мера i = 0; i < n; ++i)
            symbol_reset(p[i]);
        symbuf.устРазм(0);
    }
    else
    {
        symbuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(symbuf);
        symbuf.enlarge((Symbol *).sizeof * SYM_TAB_INIT);
    }

    if (!syment_buf)
    {
        syment_buf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(syment_buf);
        syment_buf.enlarge(SymbolTable32.sizeof * SYM_TAB_INIT);
    }
    syment_buf.устРазм(0);

    extdef = 0;
    pointersSeg = 0;

    // Initialize segments for CODE, DATA, UDATA and CDATA
    if (!ScnhdrBuf)
    {
        ScnhdrBuf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(ScnhdrBuf);
        ScnhdrBuf.enlarge(SYM_TAB_INC * IMAGE_SECTION_HEADER.sizeof);

        ScnhdrBuf.резервируй(SCNHDR_TAB_INITSIZE * (IMAGE_SECTION_HEADER).sizeof);
    }
    ScnhdrBuf.устРазм(0);
    scnhdr_cnt = 0;

    /* Define sections. Although the order should not matter, we duplicate
     * the same order VC puts out just to avoid trouble.
     */

    цел alignText = I64 ? IMAGE_SCN_ALIGN_16BYTES : IMAGE_SCN_ALIGN_8BYTES;
    цел alignData = IMAGE_SCN_ALIGN_16BYTES;
    MsCoffObj_addScnhdr(".данные$B",  IMAGE_SCN_CNT_INITIALIZED_DATA |
                          alignData |
                          IMAGE_SCN_MEM_READ |
                          IMAGE_SCN_MEM_WRITE);             // DATA
    MsCoffObj_addScnhdr(".text",    IMAGE_SCN_CNT_CODE |
                          alignText |
                          IMAGE_SCN_MEM_EXECUTE |
                          IMAGE_SCN_MEM_READ);              // CODE
    MsCoffObj_addScnhdr(".bss$B",   IMAGE_SCN_CNT_UNINITIALIZED_DATA |
                          alignData |
                          IMAGE_SCN_MEM_READ |
                          IMAGE_SCN_MEM_WRITE);             // UDATA
    MsCoffObj_addScnhdr(".rdata",   IMAGE_SCN_CNT_INITIALIZED_DATA |
                          alignData |
                          IMAGE_SCN_MEM_READ);              // CONST

    seg_count = 0;

    enum
    {
        SHI_DATA       = 1,
        SHI_TEXT       = 2,
        SHI_UDATA      = 3,
        SHI_CDATA      = 4,
    }

    MsCoffObj_getsegment2(SHI_TEXT);
    assert(SegData[CODE].SDseg == CODE);

    MsCoffObj_getsegment2(SHI_DATA);
    assert(SegData[DATA].SDseg == DATA);

    MsCoffObj_getsegment2(SHI_CDATA);
    assert(SegData[CDATA].SDseg == CDATA);

    MsCoffObj_getsegment2(SHI_UDATA);
    assert(SegData[UDATA].SDseg == UDATA);

    if (config.fulltypes)
        cv8_initfile(имяф);
    assert(objbuf.size() == 0);
    return obj;
}

/**************************
 * Start a module within a .obj файл.
 * There can be multiple modules within a single .obj файл.
 *
 * Input:
 *      имяф:       Name of source файл
 *      csegname:       User specified default code segment имя
 */

проц MsCoffObj_initfile(ткст0 имяф, ткст0 csegname, ткст0 modname)
{
    //dbg_printf("MsCoffObj_initfile(имяф = %s, modname = %s)\n",имяф,modname);
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
        newtextsec = &ScnhdrTab[newsecidx];
        newtextsec.sh_addralign = 4;
        SegData[cseg].SDsymidx =
            elf_addsym(0, 0, 0, STT_SECTION, STB_LOCAL, newsecidx);
    }
}
    if (config.fulltypes)
        cv8_initmodule(имяф, modname);
}

/************************************
 * Patch pseg/смещение by adding in the vmaddr difference from
 * pseg/смещение to start of seg.
 */

int32_t *patchAddr(цел seg, targ_т_мера смещение)
{
    return cast(int32_t *)(fobjbuf.буф + ScnhdrTab[SegData[seg].SDshtidx].PointerToRawData + смещение);
}

int32_t *patchAddr64(цел seg, targ_т_мера смещение)
{
    return cast(int32_t *)(fobjbuf.буф + ScnhdrTab[SegData[seg].SDshtidx].PointerToRawData + смещение);
}

проц patch(seg_data *pseg, targ_т_мера смещение, цел seg, targ_т_мера значение)
{
    //printf("patch(смещение = x%04x, seg = %d, значение = x%llx)\n", cast(бцел)смещение, seg, значение);
    if (I64)
    {
        int32_t *p = cast(int32_t *)(fobjbuf.буф + ScnhdrTab[pseg.SDshtidx].PointerToRawData  + смещение);

static if (0)
        printf("\taddr1 = x%llx\n\taddr2 = x%llx\n\t*p = x%llx\n\tdelta = x%llx\n",
            ScnhdrTab[pseg.SDshtidx].VirtualAddress,
            ScnhdrTab[SegData[seg].SDshtidx].VirtualAddress,
            *p,
            ScnhdrTab[SegData[seg].SDshtidx].VirtualAddress -
            (ScnhdrTab[pseg.SDshtidx].VirtualAddress + смещение));

        *p += ScnhdrTab[SegData[seg].SDshtidx].VirtualAddress -
              (ScnhdrTab[pseg.SDshtidx].VirtualAddress - значение);
    }
    else
    {
        int32_t *p = cast(int32_t *)(fobjbuf.буф + ScnhdrTab[pseg.SDshtidx].PointerToRawData + смещение);

static if (0)
        printf("\taddr1 = x%x\n\taddr2 = x%x\n\t*p = x%x\n\tdelta = x%x\n",
            ScnhdrTab[pseg.SDshtidx].VirtualAddress,
            ScnhdrTab[SegData[seg].SDshtidx].VirtualAddress,
            *p,
            ScnhdrTab[SegData[seg].SDshtidx].VirtualAddress -
            (ScnhdrTab[pseg.SDshtidx].VirtualAddress + смещение));

        *p += ScnhdrTab[SegData[seg].SDshtidx].VirtualAddress -
              (ScnhdrTab[pseg.SDshtidx].VirtualAddress - значение);
    }
}


/*********************************
 * Build syment[], the массив of symbols.
 * Store them in syment_buf.
 */

private проц syment_set_name(SymbolTable32 *sym, ткст0 имя)
{
    т_мера len = strlen(имя);
    if (len > 8)
    {   // Use смещение into ткст table
        IDXSTR idx = MsCoffObj_addstr(string_table, имя);
        sym.Zeros = 0;
        sym.Offset = idx;
    }
    else
    {   memcpy(sym.Name.ptr, имя, len);
        if (len < 8)
            memset(sym.Name.ptr + len, 0, 8 - len);
    }
}

проц write_sym(SymbolTable32* sym, бул bigobj)
{
    assert((*sym).sizeof == 20);
    if (bigobj)
    {
        syment_buf.пиши(sym[0 .. 1]);
    }
    else
    {
        // the only difference between SymbolTable32 and SymbolTable
        // is that field SectionNumber is long instead of short
        бцел scoff = cast(бцел)(cast(сим*)&sym.SectionNumber - cast(сим*)sym);
        syment_buf.пиши(sym, scoff + 2);
        syment_buf.пиши(cast(сим*)sym + scoff + 4, cast(бцел)((*sym).sizeof - scoff - 4));
    }
}

проц build_syment_table(бул bigobj)
{
    /* The @comp.ид symbol appears to be the version of VC that generated the .obj файл.
     * Anything we put in there would have no relevance, so we'll not put out this symbol.
     */

    бцел symsize = bigobj ? SymbolTable32.sizeof : SymbolTable.sizeof;
    /* Now goes one symbol per section.
     */
    for (segidx_t seg = 1; seg <= seg_count; seg++)
    {
        seg_data *pseg = SegData[seg];
        IMAGE_SECTION_HEADER *psechdr = &ScnhdrTab[pseg.SDshtidx];   // corresponding section

        SymbolTable32 sym;
        memcpy(sym.Name.ptr, psechdr.Name.ptr, 8);
        sym.Значение = 0;
        sym.SectionNumber = pseg.SDshtidx;
        sym.Тип = 0;
        sym.КлассХранения = IMAGE_SYM_CLASS_STATIC;
        sym.NumberOfAuxSymbols = 1;

        write_sym(&sym, bigobj);

        auxent aux = проц;
        memset(&aux, 0, (aux).sizeof);

        // s_size is not set yet
        //aux.x_section.length = psechdr.s_size;
        if (pseg.SDbuf && pseg.SDbuf.size())
            aux.x_section.length = cast(бцел)pseg.SDbuf.size();
        else
            aux.x_section.length = cast(бцел)pseg.SDoffset;

        if (pseg.SDrel)
            aux.x_section.NumberOfRelocations = cast(ushort)(pseg.SDrel.size() / (Relocation).sizeof);

        if (psechdr.Characteristics & IMAGE_SCN_LNK_COMDAT)
        {
            aux.x_section.Selection = cast(ббайт)IMAGE_COMDAT_SELECT_ANY;
            if (pseg.SDassocseg)
            {   aux.x_section.Selection = cast(ббайт)IMAGE_COMDAT_SELECT_ASSOCIATIVE;
                aux.x_section.NumberHighPart = cast(ushort)(pseg.SDassocseg >> 16);
                aux.x_section.NumberLowPart = cast(ushort)(pseg.SDassocseg & 0x0000FFFF);
            }
        }

        memset(&aux.x_section.Zeros, 0, 2);

        syment_buf.пиши(&aux, symsize);

        assert((aux).sizeof == 20);
    }

    /* Add symbols from symbuf[]
     */

    цел n = seg_count + 1;
    т_мера dim = symbuf.size() / (Symbol *).sizeof;
    for (т_мера i = 0; i < dim; i++)
    {   Symbol *s = (cast(Symbol **)symbuf.буф)[i];
        s.Sxtrnnum = cast(бцел)(syment_buf.size() / symsize);
        n++;

        SymbolTable32 sym;

        сим[DEST_LEN+1] dest = проц;
        сим *destr = obj_mangle2(s, dest.ptr);
        syment_set_name(&sym, destr);

        sym.Значение = 0;
        switch (s.Sclass)
        {
            case SCextern:
                sym.SectionNumber = IMAGE_SYM_UNDEFINED;
                break;

            default:
                sym.SectionNumber = SegData[s.Sseg].SDshtidx;
                break;
        }
        sym.Тип = tyfunc(s.Stype.Tty) ? 0x20 : 0;
        switch (s.Sclass)
        {
            case SCstatic:
                if (s.Sflags & SFLhidden)
                    goto default;
                goto case;
            case SClocstat:
                sym.КлассХранения = IMAGE_SYM_CLASS_STATIC;
                sym.Значение = cast(бцел)s.Soffset;
                break;

            default:
                sym.КлассХранения = IMAGE_SYM_CLASS_EXTERNAL;
                if (sym.SectionNumber != IMAGE_SYM_UNDEFINED)
                    sym.Значение = cast(бцел)s.Soffset;
                break;
        }
        sym.NumberOfAuxSymbols = 0;

        write_sym(&sym, bigobj);
    }
}


/***************************
 * Fixup and terminate объект файл.
 */

проц MsCoffObj_termfile()
{
    //dbg_printf("MsCoffObj_termfile\n");
    if (configv.addlinenumbers)
    {
        cv8_termmodule();
    }
}

/*********************************
 * Terminate package.
 */

проц MsCoffObj_term(ткст0 objfilename)
{
    //printf("MsCoffObj_term()\n");
    assert(fobjbuf.size() == 0);
version (SCPP)
{
    if (!errcnt)
    {
        objflush_pointerRefs();
        outfixlist();           // backpatches
    }
}
else
{
    objflush_pointerRefs();
    outfixlist();           // backpatches
}

    if (configv.addlinenumbers)
    {
        cv8_termfile(objfilename);
    }

version (SCPP)
{
    if (errcnt)
        return;
}

    // To allow tooling support for most output files
    // switch to new объект файл format (similar to C++ with /bigobj)
    // only when exceeding the limit for 16-bit section count according to
    // https://msdn.microsoft.com/en-us/library/8578y171%28v=vs.71%29.aspx
    бул bigobj = scnhdr_cnt > 65279;
    build_syment_table(bigobj);

    /* Write out the объект файл in the following order:
     *  Header
     *  Section Headers
     *  Symbol table
     *  String table
     *  Section данные
     */

    бцел foffset;

    // Write out the bytes for the header

    BIGOBJ_HEADER header = проц;
    IMAGE_FILE_HEADER header_old = проц;

    time_t f_timedat = 0;
    time(&f_timedat);
    бцел symtable_offset;

    if (bigobj)
    {
        header.Sig1 = IMAGE_FILE_MACHINE_UNKNOWN;
        header.Sig2 = 0xFFFF;
        header.Version = 2;
        header.Machine = I64 ? IMAGE_FILE_MACHINE_AMD64 : IMAGE_FILE_MACHINE_I386;
        header.NumberOfSections = scnhdr_cnt;
        header.TimeDateStamp = cast(бцел)f_timedat;
        static const ббайт[16] uuid =
                                  [ '\xc7', '\xa1', '\xba', '\xd1', '\xee', '\xba', '\xa9', '\x4b',
                                    '\xaf', '\x20', '\xfa', '\xf6', '\x6a', '\xa4', '\xdc', '\xb8' ];
        memcpy(header.UUID.ptr, uuid.ptr, 16);
        memset(header.unused.ptr, 0, (header.unused).sizeof);
        foffset = (header).sizeof;       // start after header
        foffset += ScnhdrBuf.size();   // section headers
        header.PointerToSymbolTable = foffset;      // смещение to symbol table
        symtable_offset = foffset;
        header.NumberOfSymbols = cast(бцел)(syment_buf.size() / (SymbolTable32).sizeof);
        foffset += header.NumberOfSymbols * (SymbolTable32).sizeof;  // symbol table
    }
    else
    {
        header_old.Machine = I64 ? IMAGE_FILE_MACHINE_AMD64 : IMAGE_FILE_MACHINE_I386;
        header_old.NumberOfSections = cast(ushort)scnhdr_cnt;
        header_old.TimeDateStamp = cast(бцел)f_timedat;
        header_old.SizeOfOptionalHeader = 0;
        header_old.Characteristics = 0;
        foffset = (header_old).sizeof;   // start after header
        foffset += ScnhdrBuf.size();   // section headers
        header_old.PointerToSymbolTable = foffset;  // смещение to symbol table
        symtable_offset = foffset;
        header_old.NumberOfSymbols = cast(бцел)(syment_buf.size() / (SymbolTable).sizeof);
        foffset += header_old.NumberOfSymbols * (SymbolTable).sizeof;  // symbol table
    }

    бцел string_table_offset = foffset;
    foffset += string_table.size();            // ткст table

    // Compute файл offsets of all the section данные

    for (segidx_t seg = 1; seg <= seg_count; seg++)
    {
        seg_data *pseg = SegData[seg];
        IMAGE_SECTION_HEADER *psechdr = &ScnhdrTab[pseg.SDshtidx];   // corresponding section

        цел align_ = pseg.SDalignment;
        if (align_ > 1)
            foffset = (foffset + align_ - 1) & ~(align_ - 1);

        if (pseg.SDbuf && pseg.SDbuf.size())
        {
            psechdr.PointerToRawData = foffset;
            //printf("seg = %2d SDshtidx = %2d psechdr = %p s_scnptr = x%x\n", seg, pseg.SDshtidx, psechdr, cast(бцел)psechdr.s_scnptr);
            psechdr.SizeOfRawData = cast(бцел)pseg.SDbuf.size();
            foffset += psechdr.SizeOfRawData;
        }
        else
            psechdr.SizeOfRawData = cast(бцел)pseg.SDoffset;
    }

    // Compute файл offsets of the relocation данные
    for (segidx_t seg = 1; seg <= seg_count; seg++)
    {
        seg_data *pseg = SegData[seg];
        IMAGE_SECTION_HEADER *psechdr = &ScnhdrTab[pseg.SDshtidx];   // corresponding section
        if (pseg.SDrel)
        {
            foffset = (foffset + 3) & ~3;
            assert(psechdr.PointerToRelocations == 0);
            auto nreloc = pseg.SDrel.size() / Relocation.sizeof;
            if (nreloc > 0xffff)
            {
                // https://docs.microsoft.com/en-us/windows/win32/debug/pe-format#coff-relocations-объект-only
                psechdr.Characteristics |= IMAGE_SCN_LNK_NRELOC_OVFL;
                psechdr.PointerToRelocations = foffset;
                psechdr.NumberOfRelocations = 0xffff;
                foffset += reloc.sizeof;
            }
            else if (nreloc)
            {
                psechdr.PointerToRelocations = foffset;
                //printf("seg = %d SDshtidx = %d psechdr = %p s_relptr = x%x\n", seg, pseg.SDshtidx, psechdr, cast(бцел)psechdr.s_relptr);
                psechdr.NumberOfRelocations = cast(ushort)nreloc;
            }
            foffset += nreloc * reloc.sizeof;
        }
    }

    assert(fobjbuf.size() == 0);

    // Write the header
    if (bigobj)
    {
        fobjbuf.пиши((&header)[0 .. 1]);
        foffset = (header).sizeof;
    }
    else
    {
        fobjbuf.пиши((&header_old)[0 .. 1]);
        foffset = (header_old).sizeof;
    }

    // Write the section headers
    fobjbuf.пиши(ScnhdrBuf);
    foffset += ScnhdrBuf.size();

    // Write the symbol table
    assert(foffset == symtable_offset);
    fobjbuf.пиши(syment_buf);
    foffset += syment_buf.size();

    // Write the ткст table
    assert(foffset == string_table_offset);
    *cast(бцел *)(string_table.буф) = cast(бцел)string_table.size();
    fobjbuf.пиши(string_table);
    foffset += string_table.size();

    // Write the section данные
    for (segidx_t seg = 1; seg <= seg_count; seg++)
    {
        seg_data *pseg = SegData[seg];
        IMAGE_SECTION_HEADER *psechdr = &ScnhdrTab[pseg.SDshtidx];   // corresponding section
        foffset = elf_align(pseg.SDalignment, foffset);
        if (pseg.SDbuf && pseg.SDbuf.size())
        {
            //printf("seg = %2d SDshtidx = %2d psechdr = %p s_scnptr = x%x, foffset = x%x\n", seg, pseg.SDshtidx, psechdr, cast(бцел)psechdr.s_scnptr, cast(бцел)foffset);
            assert(pseg.SDbuf.size() == psechdr.SizeOfRawData);
            assert(foffset == psechdr.PointerToRawData);
            fobjbuf.пиши(pseg.SDbuf);
            foffset += pseg.SDbuf.size();
        }
    }

    // Compute the relocations, пиши them out
    assert((reloc).sizeof == 10);
    for (segidx_t seg = 1; seg <= seg_count; seg++)
    {
        seg_data *pseg = SegData[seg];
        IMAGE_SECTION_HEADER *psechdr = &ScnhdrTab[pseg.SDshtidx];   // corresponding section
        if (pseg.SDrel)
        {
            Relocation *r = cast(Relocation *)pseg.SDrel.буф;
            т_мера sz = pseg.SDrel.size();
            бул pdata = (strcmp(cast(ткст0 )psechdr.Name, ".pdata") == 0);
            Relocation *rend = cast(Relocation *)(pseg.SDrel.буф + sz);
            foffset = elf_align(4, foffset);

            debug
            if (sz && foffset != psechdr.PointerToRelocations)
                printf("seg = %d SDshtidx = %d psechdr = %p s_relptr = x%x, foffset = x%x\n", seg, pseg.SDshtidx, psechdr, cast(бцел)psechdr.PointerToRelocations, cast(бцел)foffset);
            assert(sz == 0 || foffset == psechdr.PointerToRelocations);

            if (psechdr.Characteristics & IMAGE_SCN_LNK_NRELOC_OVFL)
            {
                auto rel = reloc(cast(бцел)(sz / Relocation.sizeof) + 1);
                fobjbuf.пиши((&rel)[0 .. 1]);
                foffset += rel.sizeof;
            }
            for (; r != rend; r++)
            {   reloc rel;
                rel.r_vaddr = 0;
                rel.r_symndx = 0;
                rel.r_type = 0;

                Symbol *s = r.targsym;
                ткст0 rs = r.rtype == RELaddr ? "addr" : "rel";
                //printf("%d:x%04lx : tseg %d tsym %s REL%s\n", seg, cast(цел)r.смещение, r.targseg, s ? s.Sident.ptr : "0", rs);
                if (s)
                {
                    //printf("Relocation\n");
                    //symbol_print(s);
                    if (pseg.isCode())
                    {
                        if (I64)
                        {
                            rel.r_type = (r.rtype == RELrel)
                                    ? IMAGE_REL_AMD64_REL32
                                    : IMAGE_REL_AMD64_REL32;

                            if (s.Stype.Tty & mTYthread)
                                rel.r_type = IMAGE_REL_AMD64_SECREL;

                            if (r.val == -1)
                                rel.r_type = IMAGE_REL_AMD64_REL32_1;
                            else if (r.val == -2)
                                rel.r_type = IMAGE_REL_AMD64_REL32_2;
                            else if (r.val == -3)
                                rel.r_type = IMAGE_REL_AMD64_REL32_3;
                            else if (r.val == -4)
                                rel.r_type = IMAGE_REL_AMD64_REL32_4;
                            else if (r.val == -5)
                                rel.r_type = IMAGE_REL_AMD64_REL32_5;

                            /+if (s.Sclass == SCextern ||
                                s.Sclass == SCcomdef ||
                                s.Sclass == SCcomdat ||
                                s.Sclass == SCglobal)
                            {
                                rel.r_vaddr = cast(бцел)r.смещение;
                                rel.r_symndx = s.Sxtrnnum;
                            }
                            else+/
                            {
                                rel.r_vaddr = cast(бцел)r.смещение;
                                rel.r_symndx = s.Sxtrnnum;
                            }
                        }
                        else if (I32)
                        {
                            rel.r_type = (r.rtype == RELrel)
                                    ? IMAGE_REL_I386_REL32
                                    : IMAGE_REL_I386_DIR32;

                            if (s.Stype.Tty & mTYthread)
                                rel.r_type = IMAGE_REL_I386_SECREL;

                            /+if (s.Sclass == SCextern ||
                                s.Sclass == SCcomdef ||
                                s.Sclass == SCcomdat ||
                                s.Sclass == SCglobal)
                            {
                                rel.r_vaddr = cast(бцел)r.смещение;
                                rel.r_symndx = s.Sxtrnnum;
                            }
                            else+/
                            {
                                rel.r_vaddr = cast(бцел)r.смещение;
                                rel.r_symndx = s.Sxtrnnum;
                            }
                        }
                        else
                            assert(нет); // not implemented for I16
                    }
                    else
                    {
                        if (I64)
                        {
                            if (pdata)
                                rel.r_type = IMAGE_REL_AMD64_ADDR32NB;
                            else
                                rel.r_type = IMAGE_REL_AMD64_ADDR64;

                            if (r.rtype == RELseg)
                                rel.r_type = IMAGE_REL_AMD64_SECTION;
                            else if (r.rtype == RELaddr32)
                                rel.r_type = IMAGE_REL_AMD64_SECREL;
                        }
                        else if (I32)
                        {
                            if (pdata)
                                rel.r_type = IMAGE_REL_I386_DIR32NB;
                            else
                                rel.r_type = IMAGE_REL_I386_DIR32;

                            if (r.rtype == RELseg)
                                rel.r_type = IMAGE_REL_I386_SECTION;
                            else if (r.rtype == RELaddr32)
                                rel.r_type = IMAGE_REL_I386_SECREL;
                        }
                        else
                            assert(нет); // not implemented for I16

                        rel.r_vaddr = cast(бцел)r.смещение;
                        rel.r_symndx = s.Sxtrnnum;
                    }
                }
                else if (r.rtype == RELaddr && pseg.isCode())
                {
                    int32_t *p = null;
                    p = patchAddr(seg, r.смещение);

                    rel.r_vaddr = cast(бцел)r.смещение;
                    rel.r_symndx = s ? s.Sxtrnnum : 0;

                    if (I64)
                    {
                        rel.r_type = IMAGE_REL_AMD64_REL32;
                        //srel.r_value = ScnhdrTab[SegData[r.targseg].SDshtidx].s_vaddr + *p;
                        //printf("SECTDIFF: x%llx + x%llx = x%x\n", ScnhdrTab[SegData[r.targseg].SDshtidx].s_vaddr, *p, srel.r_value);
                    }
                    else
                    {
                        rel.r_type = IMAGE_REL_I386_SECREL;
                        //srel.r_value = ScnhdrTab[SegData[r.targseg].SDshtidx].s_vaddr + *p;
                        //printf("SECTDIFF: x%x + x%x = x%x\n", ScnhdrTab[SegData[r.targseg].SDshtidx].s_vaddr, *p, srel.r_value);
                    }
                }
                else
                {
                    assert(0);
                }

                /* Some programs do generate a lot of symbols.
                 * Note that MS-Link can get pretty slow with large numbers of symbols.
                 */
                //assert(rel.r_symndx <= 20000);

                assert(rel.r_type <= 0x14);
                fobjbuf.пиши((&rel)[0 .. 1]);
                foffset += (rel).sizeof;
            }
        }
    }

    fobjbuf.flush();
}

/*****************************
 * Line number support.
 */

/***************************
 * Record файл and line number at segment and смещение.
 * Параметры:
 *      srcpos = source файл position
 *      seg = segment it corresponds to
 *      смещение = смещение within seg
 */

проц MsCoffObj_linnum(Srcpos srcpos, цел seg, targ_т_мера смещение)
{
    if (srcpos.Slinnum == 0 || !srcpos.Sfilename)
        return;

    cv8_linnum(srcpos, cast(бцел)смещение);
}


/*******************************
 * Set start address
 */

проц MsCoffObj_startaddress(Symbol *s)
{
    //dbg_printf("MsCoffObj_startaddress(Symbol *%s)\n",s.Sident.ptr);
    //obj.startaddress = s;
}

/*******************************
 * Output library имя.
 */

бул MsCoffObj_includelib(ткст0 имя)
{
    цел seg = MsCoffObj_seg_drectve();
    //dbg_printf("MsCoffObj_includelib(имя *%s)\n",имя);
    SegData[seg].SDbuf.пиши(" /DEFAULTLIB:\"".ptr, 14);
    SegData[seg].SDbuf.пиши(имя, cast(бцел)strlen(имя));
    SegData[seg].SDbuf.пишиБайт('"');
    return да;
}

/*******************************
* Output linker directive имя.
*/

бул MsCoffObj_linkerdirective(ткст0 directive)
{
    цел seg = MsCoffObj_seg_drectve();
    //dbg_printf("MsCoffObj::linkerdirective(directive *%s)\n",directive);
    SegData[seg].SDbuf.пишиБайт(' ');
    SegData[seg].SDbuf.пиши(directive, cast(бцел)strlen(directive));
    return да;
}

/**********************************
 * Do we allow нуль sized objects?
 */

бул MsCoffObj_allowZeroSize()
{
    return да;
}

/**************************
 * Embed ткст in executable.
 */

проц MsCoffObj_exestr(ткст0 p)
{
    //dbg_printf("MsCoffObj_exestr(сим *%s)\n",p);
}

/**************************
 * Embed ткст in obj.
 */

проц MsCoffObj_user(ткст0 p)
{
    //dbg_printf("MsCoffObj_user(сим *%s)\n",p);
}

/*******************************
 * Output a weak extern record.
 */

проц MsCoffObj_wkext(Symbol *s1,Symbol *s2)
{
    //dbg_printf("MsCoffObj_wkext(Symbol *%s,Symbol *s2)\n",s1.Sident.ptr,s2.Sident.ptr);
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
    // Not supported by mscoff
}

/*******************************
 * Embed compiler version in .obj файл.
 */

проц MsCoffObj_compiler()
{
    //dbg_printf("MsCoffObj_compiler\n");
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

проц MsCoffObj_staticctor(Symbol *s,цел dtor,цел none)
{
    MsCoffObj_setModuleCtorDtor(s, да);
}

/**************************************
 * Symbol is the function that calls the static destructors.
 * Put a pointer to it into a special segment that the exit code
 * looks at.
 * Input:
 *      s       static destructor function
 */

проц MsCoffObj_staticdtor(Symbol *s)
{
    MsCoffObj_setModuleCtorDtor(s, нет);
}


/***************************************
 * Stuff pointer to function in its own segment.
 * Used for static ctor and dtor lists.
 */

проц MsCoffObj_setModuleCtorDtor(Symbol *sfunc, бул isCtor)
{
    // Also see https://blogs.msdn.microsoft.com/vcblog/2006/10/20/crt-initialization/
    // and http://www.codeguru.com/cpp/misc/misc/applicationcontrol/article.php/c6945/Running-Code-Before-and-After-Main.htm
    const цел align_ = I64 ? IMAGE_SCN_ALIGN_8BYTES : IMAGE_SCN_ALIGN_4BYTES;
    const цел attr = IMAGE_SCN_CNT_INITIALIZED_DATA | align_ | IMAGE_SCN_MEM_READ;
    const цел seg = MsCoffObj_getsegment(isCtor ? ".CRT$XCU" : ".CRT$XPU", attr);

    const цел relflags = I64 ? CFoff | CFoffset64 : CFoff;
    const цел sz = MsCoffObj_reftoident(seg, SegData[seg].SDoffset, sfunc, 0, relflags);
    SegData[seg].SDoffset += sz;
}


/***************************************
 * Stuff the following данные (instance of struct FuncTable) in a separate segment:
 *      pointer to function
 *      pointer to ehsym
 *      length of function
 */

проц MsCoffObj_ehtables(Symbol *sfunc,бцел size,Symbol *ehsym)
{
    //printf("MsCoffObj_ehtables(func = %s, handler table = %s) \n",sfunc.Sident.ptr, ehsym.Sident.ptr);

    /* BUG: this should go into a COMDAT if sfunc is in a COMDAT
     * otherwise the duplicates aren't removed.
     */

    цел align_ = I64 ? IMAGE_SCN_ALIGN_8BYTES : IMAGE_SCN_ALIGN_4BYTES;  // align to _tysize[TYnptr]

    // The size is (FuncTable).sizeof in deh2.d
    const цел seg =
    MsCoffObj_getsegment("._deh$B", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                      align_ |
                                      IMAGE_SCN_MEM_READ);

    Outbuffer *буф = SegData[seg].SDbuf;
    if (I64)
    {   MsCoffObj_reftoident(seg, буф.size(), sfunc, 0, CFoff | CFoffset64);
        MsCoffObj_reftoident(seg, буф.size(), ehsym, 0, CFoff | CFoffset64);
        буф.write64(sfunc.Ssize);
    }
    else
    {   MsCoffObj_reftoident(seg, буф.size(), sfunc, 0, CFoff);
        MsCoffObj_reftoident(seg, буф.size(), ehsym, 0, CFoff);
        буф.write32(cast(бцел)sfunc.Ssize);
    }
}

/*********************************************
 * Put out symbols that define the beginning/end of the .deh_eh section.
 * This gets called if this is the module with "extern (D) main()" in it.
 */

private проц emitSectionBrace(ткст0 segname, ткст0 symname, цел attr, бул coffZeroBytes)
{
    сим[16] имя = проц;
    strcat(strcpy(имя.ptr, segname), "$A");
    const цел seg_bg = MsCoffObj_getsegment(имя.ptr, attr);

    strcat(strcpy(имя.ptr, segname), "$C");
    const цел seg_en = MsCoffObj_getsegment(имя.ptr, attr);

    /* Create symbol sym_beg that sits just before the .seg$B section
     */
    strcat(strcpy(имя.ptr, symname), "_beg");
    Symbol *beg = symbol_name(имя.ptr, SCglobal, tspvoid);
    beg.Sseg = seg_bg;
    beg.Soffset = 0;
    symbuf.пиши((&beg)[0 .. 1]);
    if (coffZeroBytes) // unnecessary, but required by current runtime
        MsCoffObj_bytes(seg_bg, 0, I64 ? 8 : 4, null);

    /* Create symbol sym_end that sits just after the .seg$B section
     */
    strcat(strcpy(имя.ptr, symname), "_end");
    Symbol *end = symbol_name(имя.ptr, SCglobal, tspvoid);
    end.Sseg = seg_en;
    end.Soffset = 0;
    symbuf.пиши((&end)[0 .. 1]);
    if (coffZeroBytes) // unnecessary, but required by current runtime
        MsCoffObj_bytes(seg_en, 0, I64 ? 8 : 4, null);
}

проц MsCoffObj_ehsections()
{
    //printf("MsCoffObj_ehsections()\n");

    цел align_ = I64 ? IMAGE_SCN_ALIGN_8BYTES : IMAGE_SCN_ALIGN_4BYTES;
    цел attr = IMAGE_SCN_CNT_INITIALIZED_DATA | align_ | IMAGE_SCN_MEM_READ;
    emitSectionBrace("._deh", "_deh", attr, да);
    emitSectionBrace(".minfo", "_minfo", attr, да);

    attr = IMAGE_SCN_CNT_INITIALIZED_DATA | IMAGE_SCN_ALIGN_4BYTES | IMAGE_SCN_MEM_READ;
    emitSectionBrace(".dp", "_DP", attr, нет); // references to pointers in .данные and .bss
    emitSectionBrace(".tp", "_TP", attr, нет); // references to pointers in .tls

    attr = IMAGE_SCN_CNT_INITIALIZED_DATA | IMAGE_SCN_ALIGN_16BYTES | IMAGE_SCN_MEM_READ | IMAGE_SCN_MEM_WRITE;
    emitSectionBrace(".данные", "_data", attr, нет);

    attr = IMAGE_SCN_CNT_UNINITIALIZED_DATA | IMAGE_SCN_ALIGN_16BYTES | IMAGE_SCN_MEM_READ | IMAGE_SCN_MEM_WRITE;
    emitSectionBrace(".bss", "_bss", attr, нет);

    /*************************************************************************/
static if (0)
{
  {
    /* TLS sections
     */
    цел align_ = I64 ? IMAGE_SCN_ALIGN_16BYTES : IMAGE_SCN_ALIGN_4BYTES;

    цел segbg =
    MsCoffObj_getsegment(".tls$AAA", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                      align_ |
                                      IMAGE_SCN_MEM_READ |
                                      IMAGE_SCN_MEM_WRITE);
    цел segen =
    MsCoffObj_getsegment(".tls$AAC", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                      align_ |
                                      IMAGE_SCN_MEM_READ |
                                      IMAGE_SCN_MEM_WRITE);

    /* Create symbol _minfo_beg that sits just before the .tls$AAB section
     */
    Symbol *minfo_beg = symbol_name("_tlsstart", SCglobal, tspvoid);
    minfo_beg.Sseg = segbg;
    minfo_beg.Soffset = 0;
    symbuf.пиши((&minfo_beg)[0 .. 1]);
    MsCoffObj_bytes(segbg, 0, I64 ? 8 : 4, null);

    /* Create symbol _minfo_end that sits just after the .tls$AAB section
     */
    Symbol *minfo_end = symbol_name("_tlsend", SCglobal, tspvoid);
    minfo_end.Sseg = segen;
    minfo_end.Soffset = 0;
    symbuf.пиши((&minfo_end)[0 .. 1]);
    MsCoffObj_bytes(segen, 0, I64 ? 8 : 4, null);
  }
}
}

/*********************************
 * Setup for Symbol s to go into a COMDAT segment.
 * Output (if s is a function):
 *      cseg            segment index of new current code segment
 *      Offset(cseg)         starting смещение in cseg
 * Возвращает:
 *      "segment index" of COMDAT
 */

цел MsCoffObj_comdatsize(Symbol *s, targ_т_мера symsize)
{
    return MsCoffObj_comdat(s);
}

цел MsCoffObj_comdat(Symbol *s)
{
    бцел align_;

    //printf("MsCoffObj_comdat(Symbol* %s)\n",s.Sident.ptr);
    //symbol_print(s);
    //symbol_debug(s);

    if (tyfunc(s.ty()))
    {
        align_ = I64 ? 16 : 4;
        s.Sseg = MsCoffObj_getsegment(".text", IMAGE_SCN_CNT_CODE |
                                           IMAGE_SCN_LNK_COMDAT |
                                           (I64 ? IMAGE_SCN_ALIGN_16BYTES : IMAGE_SCN_ALIGN_4BYTES) |
                                           IMAGE_SCN_MEM_EXECUTE |
                                           IMAGE_SCN_MEM_READ);
    }
    else if ((s.ty() & mTYLINK) == mTYthread)
    {
        s.Sfl = FLtlsdata;
        align_ = 16;
        s.Sseg = MsCoffObj_getsegment(".tls$AAB", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                            IMAGE_SCN_LNK_COMDAT |
                                            IMAGE_SCN_ALIGN_16BYTES |
                                            IMAGE_SCN_MEM_READ |
                                            IMAGE_SCN_MEM_WRITE);
        MsCoffObj_data_start(s, align_, s.Sseg);
    }
    else
    {
        s.Sfl = FLdata;
        align_ = 16;
        s.Sseg = MsCoffObj_getsegment(".данные$B",  IMAGE_SCN_CNT_INITIALIZED_DATA |
                                            IMAGE_SCN_LNK_COMDAT |
                                            IMAGE_SCN_ALIGN_16BYTES |
                                            IMAGE_SCN_MEM_READ |
                                            IMAGE_SCN_MEM_WRITE);
    }
                                // найди or создай new segment
    if (s.Salignment > align_)
    {   SegData[s.Sseg].SDalignment = s.Salignment;
        assert(s.Salignment >= -1);
    }
    s.Soffset = SegData[s.Sseg].SDoffset;
    if (s.Sfl == FLdata || s.Sfl == FLtlsdata)
    {   // Code symbols are 'published' by MsCoffObj_func_start()

        MsCoffObj_pubdef(s.Sseg,s,s.Soffset);
        searchfixlist(s);               // backpatch any refs to this symbol
    }
    return s.Sseg;
}

цел MsCoffObj_readonly_comdat(Symbol *s)
{
    //printf("MsCoffObj_readonly_comdat(Symbol* %s)\n",s.Sident.ptr);
    //symbol_print(s);
    symbol_debug(s);

    s.Sfl = FLdata;
    s.Sseg = MsCoffObj_getsegment(".rdata",  IMAGE_SCN_CNT_INITIALIZED_DATA |
                                        IMAGE_SCN_LNK_COMDAT |
                                        IMAGE_SCN_ALIGN_16BYTES |
                                        IMAGE_SCN_MEM_READ);

    SegData[s.Sseg].SDalignment = s.Salignment;
    assert(s.Salignment >= -1);
    s.Soffset = SegData[s.Sseg].SDoffset;
    if (s.Sfl == FLdata || s.Sfl == FLtlsdata)
    {   // Code symbols are 'published' by MsCoffObj_func_start()

        MsCoffObj_pubdef(s.Sseg,s,s.Soffset);
        searchfixlist(s);               // backpatch any refs to this symbol
    }
    return s.Sseg;
}


/***********************************
 * Возвращает:
 *      jump table segment for function s
 */
цел MsCoffObj_jmpTableSegment(Symbol *s)
{
    return (config.flags & CFGromable) ? cseg : DATA;
}


/**********************************
 * Get segment, which may already exist.
 * Input:
 *      flags2  put out some данные for this, so the linker will keep things in order
 * Возвращает:
 *      segment index of found or newly created segment
 */

segidx_t MsCoffObj_getsegment(ткст0 sectname, бцел flags)
{
    //printf("getsegment(%s)\n", sectname);
    assert(strlen(sectname) <= 8);      // so it won't go into string_table
    if (!(flags & IMAGE_SCN_LNK_COMDAT))
    {
        for (segidx_t seg = 1; seg <= seg_count; seg++)
        {   seg_data *pseg = SegData[seg];
            if (!(ScnhdrTab[pseg.SDshtidx].Characteristics & IMAGE_SCN_LNK_COMDAT) &&
                strncmp(cast(ткст0 )ScnhdrTab[pseg.SDshtidx].Name, sectname, 8) == 0)
            {
                //printf("\t%s\n", sectname);
                return seg;         // return existing segment
            }
        }
    }

    segidx_t seg = MsCoffObj_getsegment2(MsCoffObj_addScnhdr(sectname, flags));

    //printf("\tseg_count = %d\n", seg_count);
    //printf("\tseg = %d, %d, %s\n", seg, SegData[seg].SDshtidx, ScnhdrTab[SegData[seg].SDshtidx].s_name);
    return seg;
}

/******************************************
 * Create a new segment corresponding to an existing scnhdr index shtidx
 */

segidx_t MsCoffObj_getsegment2(IDXSEC shtidx)
{
    segidx_t seg = ++seg_count;
    if (seg_count >= seg_max)
    {                           // need more room in segment table
        seg_max += 10;
        SegData = cast(seg_data **)mem_realloc(SegData,seg_max * (seg_data *).sizeof);
        memset(&SegData[seg_count], 0, (seg_max - seg_count) * (seg_data *).sizeof);
    }
    assert(seg_count < seg_max);
    if (SegData[seg])
    {
        seg_data *pseg = SegData[seg];
        Outbuffer *b1 = pseg.SDbuf;
        Outbuffer *b2 = pseg.SDrel;
        memset(pseg, 0, (seg_data).sizeof);
        if (b1)
            b1.устРазм(0);
        else
        {
            b1 = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
            assert(b1);
            b1.enlarge(4096);
            b1.резервируй(4096);
        }
        if (b2)
            b2.устРазм(0);
        pseg.SDbuf = b1;
        pseg.SDrel = b2;
    }
    else
    {
        seg_data *pseg = cast(seg_data *)mem_calloc((seg_data).sizeof);
        SegData[seg] = pseg;
        if (!(ScnhdrTab[shtidx].Characteristics & IMAGE_SCN_CNT_UNINITIALIZED_DATA))

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

    pseg.SDshtidx = shtidx;
    pseg.SDaranges_offset = 0;
    pseg.SDlinnum_count = 0;

    //printf("seg_count = %d\n", seg_count);
    return seg;
}

/********************************************
 * Add new scnhdr.
 * Возвращает:
 *      scnhdr number for added scnhdr
 */

IDXSEC MsCoffObj_addScnhdr(ткст0 scnhdr_name, бцел flags)
{
    IMAGE_SECTION_HEADER sec;
    memset(&sec, 0, (sec).sizeof);
    т_мера len = strlen(scnhdr_name);
    if (len > 8)
    {   // Use /nnnn form
        IDXSTR idx = MsCoffObj_addstr(string_table, scnhdr_name);
        sprintf(cast(сим *)sec.Name, "/%d", idx);
    }
    else
        memcpy(sec.Name.ptr, scnhdr_name, len);
    sec.Characteristics = flags;
    ScnhdrBuf.пиши(cast(проц *)&sec, (sec).sizeof);
    return ++scnhdr_cnt;
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

цел MsCoffObj_codeseg(сим *имя,цел suffix)
{
    //dbg_printf("MsCoffObj_codeseg(%s,%x)\n",имя,suffix);
    return 0;
}

/*********************************
 * Define segments for Thread Local Storage.
 * Output:
 *      seg_tlsseg      set to segment number for TLS segment.
 * Возвращает:
 *      segment for TLS segment
 */

seg_data *MsCoffObj_tlsseg()
{
    //printf("MsCoffObj_tlsseg\n");

    if (seg_tlsseg == UNKNOWN)
    {
        seg_tlsseg = MsCoffObj_getsegment(".tls$AAB", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                              IMAGE_SCN_ALIGN_16BYTES |
                                              IMAGE_SCN_MEM_READ |
                                              IMAGE_SCN_MEM_WRITE);
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

seg_data *MsCoffObj_tlsseg_bss()
{
    /* No thread local bss for MS-COFF
     */
    return MsCoffObj_tlsseg();
}

seg_data *MsCoffObj_tlsseg_data()
{
    // specific for Mach-O
    assert(0);
}

/*************************************
 * Return segment indices for .pdata and .xdata sections
 */

segidx_t MsCoffObj_seg_pdata()
{
    if (segidx_pdata == UNKNOWN)
    {
        segidx_pdata = MsCoffObj_getsegment(".pdata", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                          IMAGE_SCN_ALIGN_4BYTES |
                                          IMAGE_SCN_MEM_READ);
    }
    return segidx_pdata;
}

segidx_t MsCoffObj_seg_xdata()
{
    if (segidx_xdata == UNKNOWN)
    {
        segidx_xdata = MsCoffObj_getsegment(".xdata", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                          IMAGE_SCN_ALIGN_4BYTES |
                                          IMAGE_SCN_MEM_READ);
    }
    return segidx_xdata;
}

segidx_t MsCoffObj_seg_pdata_comdat(Symbol *sfunc)
{
    segidx_t seg = MsCoffObj_getsegment(".pdata", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                          IMAGE_SCN_ALIGN_4BYTES |
                                          IMAGE_SCN_MEM_READ |
                                          IMAGE_SCN_LNK_COMDAT);
    SegData[seg].SDassocseg = sfunc.Sseg;
    return seg;
}

segidx_t MsCoffObj_seg_xdata_comdat(Symbol *sfunc)
{
    segidx_t seg = MsCoffObj_getsegment(".xdata", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                          IMAGE_SCN_ALIGN_4BYTES |
                                          IMAGE_SCN_MEM_READ |
                                          IMAGE_SCN_LNK_COMDAT);
    SegData[seg].SDassocseg = sfunc.Sseg;
    return seg;
}

segidx_t MsCoffObj_seg_debugS()
{
    if (segidx_debugS == UNKNOWN)
    {
        segidx_debugS = MsCoffObj_getsegment(".debug$S", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                          IMAGE_SCN_ALIGN_1BYTES |
                                          IMAGE_SCN_MEM_READ |
                                          IMAGE_SCN_MEM_DISCARDABLE);
    }
    return segidx_debugS;
}


segidx_t MsCoffObj_seg_debugS_comdat(Symbol *sfunc)
{
    //printf("associated with seg %d\n", sfunc.Sseg);
    segidx_t seg = MsCoffObj_getsegment(".debug$S", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                          IMAGE_SCN_ALIGN_1BYTES |
                                          IMAGE_SCN_MEM_READ |
                                          IMAGE_SCN_LNK_COMDAT |
                                          IMAGE_SCN_MEM_DISCARDABLE);
    SegData[seg].SDassocseg = sfunc.Sseg;
    return seg;
}

segidx_t MsCoffObj_seg_debugT()
{
    segidx_t seg = MsCoffObj_getsegment(".debug$T", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                          IMAGE_SCN_ALIGN_1BYTES |
                                          IMAGE_SCN_MEM_READ |
                                          IMAGE_SCN_MEM_DISCARDABLE);
    return seg;
}

segidx_t MsCoffObj_seg_drectve()
{
    if (segidx_drectve == UNKNOWN)
    {
        segidx_drectve = MsCoffObj_getsegment(".drectve", IMAGE_SCN_LNK_INFO |
                                          IMAGE_SCN_ALIGN_1BYTES |
                                          IMAGE_SCN_LNK_REMOVE);        // linker commands
    }
    return segidx_drectve;
}


/*******************************
 * Output an alias definition record.
 */

проц MsCoffObj_alias(ткст0 n1,ткст0 n2)
{
    //printf("MsCoffObj_alias(%s,%s)\n",n1,n2);
    assert(0);
static if (0) // NOT_DONE
{
    бцел len;
    сим *буфер;

    буфер = cast(сим *) alloca(strlen(n1) + strlen(n2) + 2 * ONS_OHD);
    len = obj_namestring(буфер,n1);
    len += obj_namestring(буфер + len,n2);
    objrecord(ALIAS,буфер,len);
}
}

сим *unsstr(бцел значение)
{
     сим[64] буфер;

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

    //printf("MsCoffObj_mangle(s = %p, '%s'), mangle = x%x\n",s,s.Sident.ptr,type_mangle(s.Stype));
    symbol_debug(s);
    assert(dest);

version (SCPP)
    имя = CPP ? cpp_mangle(s) : s.Sident.ptr;
else version (Dinrus)
    // C++ имя mangling is handled by front end
    имя = s.Sident.ptr;
else
    имя = s.Sident.ptr;

    len = strlen(имя);                 // # of bytes in имя
    //dbg_printf("len %d\n",len);
    switch (type_mangle(s.Stype))
    {
        case mTYman_pas:                // if upper case
        case mTYman_for:
            if (len >= DEST_LEN)
                dest = cast(сим *)mem_malloc(len + 1);
            memcpy(dest,имя,len + 1);  // копируй in имя and ending 0
            strupr(dest);               // to upper case
            break;
        case mTYman_std:
            if (!(config.flags4 & CFG4oldstdmangle) &&
                config.exe == EX_WIN32 && tyfunc(s.ty()) &&
                !variadic(s.Stype))
            {
                сим *pstr = unsstr(type_paramsize(s.Stype));
                т_мера pstrlen = strlen(pstr);
                т_мера prelen = I32 ? 1 : 0;
                т_мера destlen = prelen + len + 1 + pstrlen + 1;

                if (destlen > DEST_LEN)
                    dest = cast(сим *)mem_malloc(destlen);
                dest[0] = '_';
                memcpy(dest + prelen,имя,len);
                dest[prelen + len] = '@';
                memcpy(dest + prelen + 1 + len, pstr, pstrlen + 1);
                break;
            }
            goto case;

        case mTYman_cpp:
        case mTYman_sys:
        case_mTYman_c64:
        case 0:
            if (len >= DEST_LEN)
                dest = cast(сим *)mem_malloc(len + 1);
            memcpy(dest,имя,len+1);// копируй in имя and trailing 0
            break;

        case mTYman_c:
        case mTYman_d:
            if(I64)
                goto case_mTYman_c64;
            // Prepend _ to идентификатор
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

проц MsCoffObj_export_symbol(Symbol *s,бцел argsize)
{
    сим[DEST_LEN+1] dest = проц;
    сим *destr = obj_mangle2(s, dest.ptr);

    цел seg = MsCoffObj_seg_drectve();
    //printf("MsCoffObj_export_symbol(%s,%d)\n",s.Sident.ptr,argsize);
    SegData[seg].SDbuf.пиши(" /EXPORT:".ptr, 9);
    SegData[seg].SDbuf.пиши(dest.ptr, cast(бцел)strlen(dest.ptr));
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

segidx_t MsCoffObj_data_start(Symbol *sdata, targ_т_мера datasize, segidx_t seg)
{
    targ_т_мера alignbytes;

    //printf("MsCoffObj_data_start(%s,size %d,seg %d)\n",sdata.Sident.ptr,(цел)datasize,seg);
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
        MsCoffObj_lidata(seg, смещение, alignbytes);
    sdata.Soffset = смещение + alignbytes;
    return seg;
}

/*******************************
 * Update function info before codgen
 *
 * If code for this function is in a different segment
 * than the current default in cseg, switch cseg to new segment.
 */

проц MsCoffObj_func_start(Symbol *sfunc)
{
    //printf("MsCoffObj_func_start(%s)\n",sfunc.Sident.ptr);
    symbol_debug(sfunc);

    assert(sfunc.Sseg);
    if (sfunc.Sseg == UNKNOWN)
        sfunc.Sseg = CODE;
    //printf("sfunc.Sseg %d CODE %d cseg %d Coffset x%x\n",sfunc.Sseg,CODE,cseg,Offset(cseg));
    cseg = sfunc.Sseg;
    assert(cseg == CODE || cseg > UDATA);
    MsCoffObj_pubdef(cseg, sfunc, Offset(cseg));
    sfunc.Soffset = Offset(cseg);

    if (config.fulltypes)
        cv8_func_start(sfunc);
}

/*******************************
 * Update function info after codgen
 */

проц MsCoffObj_func_term(Symbol *sfunc)
{
    //dbg_printf("MsCoffObj_func_term(%s) смещение %x, Coffset %x symidx %d\n",
//          sfunc.Sident.ptr, sfunc.Soffset,Offset(cseg),sfunc.Sxtrnnum);

    if (config.fulltypes)
        cv8_func_term(sfunc);
}

/********************************
 * Output a public definition.
 * Параметры:
 *      seg =           segment index that symbol is defined in
 *      s =             symbol
 *      смещение =        смещение of имя within segment
 */

проц MsCoffObj_pubdef(segidx_t seg, Symbol *s, targ_т_мера смещение)
{
    //printf("MsCoffObj_pubdef(%d:x%x s=%p, %s)\n", seg, cast(цел)смещение, s, s.Sident.ptr);
    //symbol_print(s);

    symbol_debug(s);

    s.Soffset = смещение;
    s.Sseg = seg;
    switch (s.Sclass)
    {
        case SCglobal:
        case SCinline:
            symbuf.пиши((&s)[0 .. 1]);
            break;
        case SCcomdat:
        case SCcomdef:
            symbuf.пиши((&s)[0 .. 1]);
            break;
        default:
            symbuf.пиши((&s)[0 .. 1]);
            break;
    }
    //printf("%p\n", *(ук*)symbuf.буф);
    s.Sxtrnnum = 1;
}

проц MsCoffObj_pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize)
{
    MsCoffObj_pubdef(seg, s, смещение);
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

цел MsCoffObj_external_def(ткст0 имя)
{
    //printf("MsCoffObj_external_def('%s')\n",имя);
    assert(имя);
    Symbol *s = symbol_name(имя, SCextern, tspvoid);
    symbuf.пиши((&s)[0 .. 1]);
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

цел MsCoffObj_external(Symbol *s)
{
    //printf("MsCoffObj_external('%s') %x\n",s.Sident.ptr,s.Svalue);
    symbol_debug(s);
    symbuf.пиши((&s)[0 .. 1]);
    s.Sxtrnnum = 1;
    return 1;
}

/*******************************
 * Output a common block definition.
 * Параметры:
 *      s =     Symbol for common block
 *      size =  size in bytes of each elem
 *      count = number of elems
 * Возвращает:
 *      Symbol table index for symbol
 */

цел MsCoffObj_common_block(Symbol *s,targ_т_мера size,targ_т_мера count)
{
    //printf("MsCoffObj_common_block('%s', size=%d, count=%d)\n",s.Sident.ptr,size,count);
    symbol_debug(s);

    // can't have code or thread local comdef's
    assert(!(s.ty() & mTYthread));

    s.Sfl = FLudata;
    бцел align_ = 16;
    s.Sseg = MsCoffObj_getsegment(".bss$B",  IMAGE_SCN_CNT_UNINITIALIZED_DATA |
                                        IMAGE_SCN_LNK_COMDAT |
                                        IMAGE_SCN_ALIGN_16BYTES |
                                        IMAGE_SCN_MEM_READ |
                                        IMAGE_SCN_MEM_WRITE);
    if (s.Salignment > align_)
    {
        SegData[s.Sseg].SDalignment = s.Salignment;
        assert(s.Salignment >= -1);
    }
    s.Soffset = SegData[s.Sseg].SDoffset;
    SegData[s.Sseg].SDsym = s;
    SegData[s.Sseg].SDoffset += count * size;

    MsCoffObj_pubdef(s.Sseg, s, s.Soffset);
    searchfixlist(s);               // backpatch any refs to this symbol

    return 1;           // should return проц
}

цел MsCoffObj_common_block(Symbol *s, цел флаг, targ_т_мера size, targ_т_мера count)
{
    return MsCoffObj_common_block(s, size, count);
}

/***************************************
 * Append an iterated данные block of 0s.
 * (uninitialized данные only)
 */

проц MsCoffObj_write_zeros(seg_data *pseg, targ_т_мера count)
{
    MsCoffObj_lidata(pseg.SDseg, pseg.SDoffset, count);
}

/***************************************
 * Output an iterated данные block of 0s.
 *
 *      For boundary alignment and initialization
 */

проц MsCoffObj_lidata(segidx_t seg,targ_т_мера смещение,targ_т_мера count)
{
    //printf("MsCoffObj_lidata(%d,%x,%d)\n",seg,смещение,count);
    т_мера idx = SegData[seg].SDshtidx;
    if ((ScnhdrTab[idx].Characteristics) & IMAGE_SCN_CNT_UNINITIALIZED_DATA)
    {   // Use SDoffset to record size of bss section
        SegData[seg].SDoffset += count;
    }
    else
    {
        MsCoffObj_bytes(seg, смещение, cast(бцел)count, null);
    }
}

/***********************************
 * Append byte to segment.
 */

проц MsCoffObj_write_byte(seg_data *pseg, бцел byte_)
{
    MsCoffObj_byte(pseg.SDseg, pseg.SDoffset, byte_);
}

/************************************
 * Output byte_ to объект файл.
 */

проц MsCoffObj_byte(segidx_t seg,targ_т_мера смещение,бцел byte_)
{
    Outbuffer *буф = SegData[seg].SDbuf;
    цел save = cast(цел)буф.size();
    //dbg_printf("MsCoffObj_byte(seg=%d, смещение=x%lx, byte=x%x)\n",seg,смещение,byte_);
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

проц MsCoffObj_write_bytes(seg_data *pseg, бцел члобайт, проц *p)
{
    MsCoffObj_bytes(pseg.SDseg, pseg.SDoffset, члобайт, p);
}

/************************************
 * Output bytes to объект файл.
 * Возвращает:
 *      члобайт
 */

бцел MsCoffObj_bytes(segidx_t seg, targ_т_мера смещение, бцел члобайт, проц *p)
{
static if (0)
{
    if (!(seg >= 0 && seg <= seg_count))
    {   printf("MsCoffObj_bytes: seg = %d, seg_count = %d\n", seg, seg_count);
        *cast(сим*)0=0;
    }
}
    assert(seg >= 0 && seg <= seg_count);
    Outbuffer *буф = SegData[seg].SDbuf;
    if (буф == null)
    {
        //printf("MsCoffObj_bytes(seg=%d, смещение=x%llx, члобайт=%d, p=x%x)\n", seg, смещение, члобайт, p);
        //raise(SIGSEGV);
        assert(буф != null);
    }
    цел save = cast(цел)буф.size();
    //dbg_printf("MsCoffObj_bytes(seg=%d, смещение=x%lx, члобайт=%d, p=x%x)\n",
            //seg,смещение,члобайт,p);
    буф.устРазм(cast(бцел)смещение);
    буф.резервируй(члобайт);
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

проц MsCoffObj_addrel(segidx_t seg, targ_т_мера смещение, Symbol *targsym,
        бцел targseg, цел rtype, цел val)
{
    //printf("addrel()\n");
    if (!targsym)
    {   // Generate one
        targsym = symbol_generate(SCstatic, tstypes[TYint]);
        targsym.Sseg = targseg;
        targsym.Soffset = val;
        symbuf.пиши((&targsym)[0 .. 1]);
    }

    Relocation rel = проц;
    rel.смещение = смещение;
    rel.targsym = targsym;
    rel.targseg = targseg;
    rel.rtype = cast(ббайт)rtype;
    rel.funcsym = funcsym_p;
    rel.val = cast(short)val;
    seg_data *pseg = SegData[seg];
    if (!pseg.SDrel)
    {
        pseg.SDrel = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(pseg.SDrel);
    }
    pseg.SDrel.пиши((&rel)[0 .. 1]);
}

/****************************************
 * Sort the relocation entry буфер.
 */

extern (C) {
private цел rel_fp(ук e1, ук e2)
{   Relocation *r1 = cast(Relocation *)e1;
    Relocation *r2 = cast(Relocation *)e2;

    return cast(цел)(r1.смещение - r2.смещение);
}
}

проц mach_relsort(Outbuffer *буф)
{
    qsort(буф.буф, буф.size() / (Relocation).sizeof, (Relocation).sizeof, &rel_fp);
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
 *              MsCoffObj_reftodatseg(DATA,смещение,3 * (цел *).sizeof,UDATA);
 */

проц MsCoffObj_reftodatseg(segidx_t seg,targ_т_мера смещение,targ_т_мера val,
        бцел targetdatum,цел flags)
{
    Outbuffer *буф = SegData[seg].SDbuf;
    цел save = cast(цел)буф.size();
    буф.устРазм(cast(бцел)смещение);
static if (0)
{
    printf("MsCoffObj_reftodatseg(seg:смещение=%d:x%llx, val=x%llx, targetdatum %x, flags %x )\n",
        seg,смещение,val,targetdatum,flags);
}
    assert(seg != 0);
    if (SegData[seg].isCode() && SegData[targetdatum].isCode())
    {
        assert(0);
    }
    MsCoffObj_addrel(seg, смещение, null, targetdatum, RELaddr, 0);
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

проц MsCoffObj_reftocodeseg(segidx_t seg,targ_т_мера смещение,targ_т_мера val)
{
    //printf("MsCoffObj_reftocodeseg(seg=%d, смещение=x%lx, val=x%lx )\n",seg,cast(бцел)смещение,cast(бцел)val);
    assert(seg > 0);
    Outbuffer *буф = SegData[seg].SDbuf;
    цел save = cast(цел)буф.size();
    буф.устРазм(cast(бцел)смещение);
    val -= funcsym_p.Soffset;
    if (I32)
        MsCoffObj_addrel(seg, смещение, funcsym_p, 0, RELaddr, 0);
//    MsCoffObj_addrel(seg, смещение, funcsym_p, 0, RELaddr);
//    if (I64)
//        буф.write64(val);
//    else
        буф.write32(cast(цел)val);
    if (save > смещение + 4)
        буф.устРазм(save);
}

/*******************************
 * Refer to an идентификатор.
 * Параметры:
 *      seg =   where the address is going (CODE or DATA)
 *      смещение =        смещение within seg
 *      s =             Symbol table entry for идентификатор
 *      val =           displacement from идентификатор
 *      flags =         CFselfrel: self-relative
 *                      CFseg: get segment
 *                      CFoff: get смещение
 *                      CFpc32: [RIP] addressing, val is 0, -1, -2 or -4
 *                      CFoffset64: 8 byte смещение for 64 bit builds
 * Возвращает:
 *      number of bytes in reference (4 or 8)
 */

цел MsCoffObj_reftoident(segidx_t seg, targ_т_мера смещение, Symbol *s, targ_т_мера val,
        цел flags)
{
    цел refsize = (flags & CFoffset64) ? 8 : 4;
    if (flags & CFseg)
        refsize += 2;
static if (0)
{
    printf("\nMsCoffObj_reftoident('%s' seg %d, смещение x%llx, val x%llx, flags x%x)\n",
        s.Sident.ptr,seg,cast(бдол)смещение,cast(бдол)val,flags);
    //printf("refsize = %d\n", refsize);
    //dbg_printf("Sseg = %d, Sxtrnnum = %d\n",s.Sseg,s.Sxtrnnum);
    //symbol_print(s);
}
    assert(seg > 0);
    if (s.Sclass != SClocstat && !s.Sxtrnnum)
    {   // It may get defined later as public or local, so defer
        т_мера numbyteswritten = addtofixlist(s, смещение, seg, val, flags);
        assert(numbyteswritten == refsize);
    }
    else
    {
        if (I64 || I32)
        {
            //if (s.Sclass != SCcomdat)
                //val += s.Soffset;
            цел v = 0;
            if (flags & CFpc32)
            {
                v = -((flags & CFREL) >> 24);
                assert(v >= -5 && v <= 0);
            }
            if (flags & CFselfrel)
            {
                MsCoffObj_addrel(seg, смещение, s, 0, RELrel, v);
            }
            else if ((flags & (CFseg | CFoff)) == (CFseg | CFoff))
            {
                MsCoffObj_addrel(seg, смещение,     s, 0, RELaddr32, v);
                MsCoffObj_addrel(seg, смещение + 4, s, 0, RELseg, v);
                refsize = 6;    // 4 bytes for смещение, 2 for section
            }
            else
            {
                MsCoffObj_addrel(seg, смещение, s, 0, RELaddr, v);
            }
        }
        else
        {
            if (SegData[seg].isCode() && flags & CFselfrel)
            {
                seg_data *pseg = SegData[jumpTableSeg];
                val -= смещение + 4;
                MsCoffObj_addrel(seg, смещение, null, jumpTableSeg, RELrel, 0);
            }
            else if (SegData[seg].isCode() &&
                    ((s.Sclass != SCextern && SegData[s.Sseg].isCode()) || s.Sclass == SClocstat || s.Sclass == SCstatic))
            {
                val += s.Soffset;
                MsCoffObj_addrel(seg, смещение, null, s.Sseg, RELaddr, 0);
            }
            else if (SegData[seg].isCode() && !tyfunc(s.ty()))
            {
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
                //printf("MsCoffObj_reftoident: seg = %d, смещение = x%x, s = %s, val = x%x, pointersSeg = %d\n", seg, смещение, s.Sident.ptr, val, pointersSeg);
                MsCoffObj_addrel(seg, смещение, null, pointersSeg, RELaddr, 0);
            }
            else
            {   //val -= s.Soffset;
//                MsCoffObj_addrel(seg, смещение, s, 0, RELaddr, 0);
            }
        }

        Outbuffer *буф = SegData[seg].SDbuf;
        цел save = cast(цел)буф.size();
        буф.устРазм(cast(бцел)смещение);
        //printf("смещение = x%llx, val = x%llx\n", смещение, val);
        if (refsize == 8)
            буф.write64(val);
        else if (refsize == 4)
            буф.write32(cast(цел)val);
        else if (refsize == 6)
        {
            буф.write32(cast(цел)val);
            буф.writeWord(0);
        }
        else
            assert(0);
        if (save > смещение + refsize)
            буф.устРазм(save);
    }
    return refsize;
}

/*****************************************
 * Generate far16 thunk.
 * Input:
 *      s       Symbol to generate a thunk for
 */

проц MsCoffObj_far16thunk(Symbol *s)
{
    //dbg_printf("MsCoffObj_far16thunk('%s')\n", s.Sident.ptr);
    assert(0);
}

/**************************************
 * Mark объект файл as using floating point.
 */

проц MsCoffObj_fltused()
{
    //dbg_printf("MsCoffObj_fltused()\n");
    /* Otherwise, we'll get the dreaded
     *    "runtime error R6002 - floating point support not loaded"
     */
    if (!floatused)
    {
        MsCoffObj_external_def("_fltused");
        floatused = 1;
    }
}


цел elf_align(цел size, цел foffset)
{
    if (size <= 1)
        return foffset;
    цел смещение = (foffset + size - 1) & ~(size - 1);
    //printf("смещение = x%lx, foffset = x%lx, size = x%lx\n", смещение, foffset, (цел)size);
    if (смещение > foffset)
        fobjbuf.writezeros(смещение - foffset);
    return смещение;
}

/***************************************
 * Stuff pointer to ModuleInfo in its own segment.
 * Input:
 *      scc     symbol for ModuleInfo
 */

version (Dinrus)
{

проц MsCoffObj_moduleinfo(Symbol *scc)
{
    цел align_ = I64 ? IMAGE_SCN_ALIGN_8BYTES : IMAGE_SCN_ALIGN_4BYTES;

    /* Module info sections
     */
    const цел seg =
    MsCoffObj_getsegment(".minfo$B", IMAGE_SCN_CNT_INITIALIZED_DATA |
                                      align_ |
                                      IMAGE_SCN_MEM_READ);
    //printf("MsCoffObj_moduleinfo(%s) seg = %d:x%x\n", scc.Sident.ptr, seg, Offset(seg));

    цел flags = CFoff;
    if (I64)
        flags |= CFoffset64;
    SegData[seg].SDoffset += MsCoffObj_reftoident(seg, Offset(seg), scc, 0, flags);
}

}

/**********************************
 * Reset code seg to existing seg.
 * Used after a COMDAT for a function is done.
 */

проц MsCoffObj_setcodeseg(цел seg)
{
    assert(0 < seg && seg <= seg_count);
    cseg = seg;
}

Symbol *MsCoffObj_tlv_bootstrap()
{
    // specific for Mach-O
    assert(0);
}

/*****************************************
 * пиши a reference to a mutable pointer into the объект файл
 * Параметры:
 *      s    = symbol that содержит the pointer
 *      soff = смещение of the pointer inside the Symbol's memory
 */
проц MsCoffObj_write_pointerRef(Symbol* s, бцел soff)
{
    if (!ptrref_buf)
    {
        ptrref_buf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(ptrref_buf);
    }

    // defer writing pointer references until the symbols are written out
    ptrref_buf.пиши((&s)[0 .. 1]);
    ptrref_buf.write32(soff);
}

/*****************************************
 * flush a single pointer reference saved by write_pointerRef
 * to the объект файл
 * Параметры:
 *      s    = symbol that содержит the pointer
 *      soff = смещение of the pointer inside the Symbol's memory
 */
extern (D) private проц objflush_pointerRef(Symbol* s, бцел soff)
{
    бул isTls = (s.Sfl == FLtlsdata);
    ткст0 segname = isTls ? ".tp$B" : ".dp$B";
    цел attr = IMAGE_SCN_CNT_INITIALIZED_DATA | IMAGE_SCN_ALIGN_4BYTES | IMAGE_SCN_MEM_READ;
    цел seg = MsCoffObj_getsegment(segname, attr);

    targ_т_мера смещение = SegData[seg].SDoffset;
    MsCoffObj_addrel(seg, смещение, s, cast(бцел)смещение, RELaddr32, 0);
    Outbuffer* буф = SegData[seg].SDbuf;
    буф.устРазм(cast(бцел)смещение);
    буф.write32(soff);
    SegData[seg].SDoffset = буф.size();
}

/*****************************************
 * flush all pointer references saved by write_pointerRef
 * to the объект файл
 */
extern (D) private проц objflush_pointerRefs()
{
    if (!ptrref_buf)
        return;

    ббайт *p = ptrref_buf.буф;
    ббайт *end = ptrref_buf.p;
    while (p < end)
    {
        Symbol* s = *cast(Symbol**)p;
        p += s.sizeof;
        бцел soff = *cast(бцел*)p;
        p += soff.sizeof;
        objflush_pointerRef(s, soff);
    }
    ptrref_buf.сбрось();
}

}

}
