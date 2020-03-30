/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Copyright:   Copyright (C) 1984-1998 by Symantec
 *              Copyright (C) 2000-2020 by The D Language Foundation, All Rights Reserved
 * Authors:     $(LINK2 http://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/cgobj.d, backend/cgobj.d)
 */

module drc.backend.cgobj;

version (SCPP)
    version = COMPILE;
version (Dinrus)
    version = COMPILE;

version (COMPILE)
{

import cidrus;

import drc.backend.cc;
import drc.backend.cdef;
import drc.backend.cgcv;
import drc.backend.code;
import drc.backend.code_x86;
import drc.backend.dlist;
import drc.backend.dvec;
import drc.backend.el;
import drc.backend.md5;
import drc.backend.mem;
import drc.backend.глоб2;
import drc.backend.obj;
import drc.backend.oper;
import drc.backend.outbuf;
import drc.backend.rtlsym;
import drc.backend.ty;
import drc.backend.тип;

/*extern (C++):*/



version (SCPP)
{
    import filespec;
    import msgs2;
    import scopeh;

    extern(C) ткст0 strupr(сим*);
    extern(C) ткст0 itoa(цел,сим*,цел);
    extern(C) ткст0 getcwd(сим*,т_мера);
}

version (Dinrus)
{
    import drc.backend.dvarstats;

    //import drc.backend.filespec;
    сим *filespecdotext(ткст0 filespec);
    сим *filespecgetroot(ткст0 имя);
    сим *filespecname(ткст0 filespec);

    version (Windows)
    {
        extern (C) цел stricmp(сим*, сим*) /*pure  */;
        alias stricmp filespeccmp;
    }
    else
        alias strcmp filespeccmp;

    extern(C) ткст0 strupr(сим*);
    extern(C) ткст0 itoa(цел,сим*,цел);
    extern(C) ткст0 getcwd(сим*,т_мера);

struct Место
{
    сим *имяф;
    бцел номстр;
    бцел имяс;

    this(цел y, цел x)
    {
        номстр = y;
        имяс = x;
        имяф = null;
    }
}

проц выведиОшибку(Место место, ткст0 format, ...);
}

version (Dinrus)
{
// C++ имя mangling is handled by front end
ткст0 cpp_mangle(Symbol* s) { return s.Sident.ptr; }
}

static if (TARGET_WINDOS)
{

const MULTISCOPE = 1;            /* account for bug in MultiScope debugger
                                   where it cannot handle a line number
                                   with multiple offsets. We use a bit vector
                                   to filter out the extra offsets.
                                 */

extern (C) проц TOOFFSET(ук p, targ_т_мера значение);

проц TOWORD(ук a, бцел b)
{
    *cast(ushort*)a = cast(ushort)b;
}

проц TOLONG(ук a, бцел b)
{
    *cast(бцел*)a = b;
}


/**************************
 * Record types:
 */

enum
{
    RHEADR  = 0x6E,
    REGINT  = 0x70,
    REDATA  = 0x72,
    RIDATA  = 0x74,
    OVLDEF  = 0x76,
    ENDREC  = 0x78,
    BLKDEF  = 0x7A,
    BLKEND  = 0x7C,
//  DEBSYM  = 0x7E,
    THEADR  = 0x80,
    LHEADR  = 0x82,
    PEDATA  = 0x84,
    PIDATA  = 0x86,
    COMENT  = 0x88,
    MODEND  = 0x8A,
    EXTDEF  = 0x8C,
    TYPDEF  = 0x8E,
    PUBDEF  = 0x90,
    PUB386  = 0x91,
    LOCSYM  = 0x92,
    LINNUM  = 0x94,
    LNAMES  = 0x96,
    SEGDEF  = 0x98,
    SEG386  = 0x99,
    GRPDEF  = 0x9A,
    FIXUPP  = 0x9C,
    FIX386  = 0x9D,
    LEDATA  = 0xA0,
    LED386  = 0xA1,
    LIDATA  = 0xA2,
    LID386  = 0xA3,
    LIBHED  = 0xA4,
    LIBNAM  = 0xA6,
    LIBLOC  = 0xA8,
    LIBDIC  = 0xAA,
    COMDEF  = 0xB0,
    LEXTDEF = 0xB4,
    LPUBDEF = 0xB6,
    LCOMDEF = 0xB8,
    CEXTDEF = 0xBC,
    COMDAT  = 0xC2,
    LINSYM  = 0xC4,
    ALIAS   = 0xC6,
    LLNAMES = 0xCA,
}

// Some definitions for .OBJ files. Trial and error to determine which
// one to use when. Page #s refer to Intel spec on .OBJ files.

// Values for LOCAT byte: (pg. 71)
enum
{
    LOCATselfrel            = 0x8000,
    LOCATsegrel             = 0xC000,

// OR'd with one of the following:
    LOClobyte               = 0x0000,
    LOCbase                 = 0x0800,
    LOChibyte               = 0x1000,
    LOCloader_resolved      = 0x1400,

// Unfortunately, the fixup stuff is different for EASY OMF and Microsoft
    EASY_LOCoffset          = 0x1400,          // 32 bit смещение
    EASY_LOCpointer         = 0x1800,          // 48 bit seg/смещение

    LOC32offset             = 0x2400,
    LOC32tlsoffset          = 0x2800,
    LOC32pointer            = 0x2C00,

    LOC16offset             = 0x0400,
    LOC16pointer            = 0x0C00,

    LOCxx                   = 0x3C00
}

// FDxxxx are constants for the FIXDAT byte in fixup records (pg. 72)

enum
{
    FD_F0 = 0x00,            // segment index
    FD_F1 = 0x10,            // group index
    FD_F2 = 0x20,            // external index
    FD_F4 = 0x40,            // canonic frame of LSEG that содержит Location
    FD_F5 = 0x50,            // Target determines the frame

    FD_T0 = 0,               // segment index
    FD_T1 = 1,               // group index
    FD_T2 = 2,               // external index
    FD_T4 = 4,               // segment index, 0 displacement
    FD_T5 = 5,               // group index, 0 displacement
    FD_T6 = 6,               // external index, 0 displacement
}

/***************
 * Fixup list.
 */

struct FIXUP
{
    FIXUP              *FUnext;
    targ_т_мера         FUoffset;       // смещение from start of ledata
    ushort              FUlcfd;         // LCxxxx | FDxxxx
    ushort              FUframedatum;
    ushort              FUtargetdatum;
}

FIXUP* list_fixup(list_t fl) { return cast(FIXUP *)list_ptr(fl); }

цел seg_is_comdat(цел seg) { return seg < 0; }

/*****************************
 * Ledata records
 */

const LEDATAMAX = 1024-14;

struct Ledatarec
{
    ббайт[14] header;           // big enough to handle COMDAT header
    ббайт[LEDATAMAX] данные;
    цел lseg;                   // segment значение
    бцел i;                     // number of bytes in данные
    targ_т_мера смещение;         // segment смещение of start of данные
    FIXUP *fixuplist;           // fixups for this ledata

    // For COMDATs
    ббайт flags;                // flags byte of COMDAT
    ббайт alloctyp;             // allocation тип of COMDAT
    ббайт _align;               // align тип
    цел typidx;
    цел pubbase;
    цел pubnamidx;
}

/*****************************
 * For defining segments.
 */

бцел SEG_ATTR(бцел A, бцел C, бцел B, бцел P)
{
    return (A << 5) | (C << 2) | (B << 1) | P;
}

enum
{
// Segment alignment A
    SEG_ALIGN0    = 0,       // absolute segment
    SEG_ALIGN1    = 1,       // byte align
    SEG_ALIGN2    = 2,       // word align
    SEG_ALIGN16   = 3,       // paragraph align
    SEG_ALIGN4K   = 4,       // 4Kb page align
    SEG_ALIGN4    = 5,       // dword align

// Segment combine types C
    SEG_C_ABS     = 0,
    SEG_C_PUBLIC  = 2,
    SEG_C_STACK   = 5,
    SEG_C_COMMON  = 6,

// Segment тип P
    USE16 = 0,
    USE32 = 1,

    USE32_CODE    = (4+2),          // use32 + execute/читай
    USE32_DATA    = (4+3),          // use32 + читай/пиши
}

/*****************************
 * Line number support.
 */

const LINNUMMAX = 512;

struct Linnum
{
version (Dinrus)
        ткст0 имяф;  // source файл имя
else
        Sfile *filptr;          // файл pointer

        цел cseg;               // our internal segment number
        цел seg;                // segment/public index
        цел i;                  // используется in данные[]
        ббайт[LINNUMMAX] данные;  // номстр/смещение данные
}

const LINRECMAX = 2 + 255 * 2;   // room for 255 line numbers

/************************************
 * State of объект файл.
 */

struct Objstate
{
    ткст0 modname;
    сим *csegname;
    Outbuffer *буф;     // output буфер

    цел fdsegattr;      // far данные segment attribute
    цел csegattr;       // code segment attribute

    цел lastfardatasegi;        // SegData[] index of last far данные seg

    цел LOCoffset;
    цел LOCpointer;

    цел mlidata;
    цел mpubdef;
    цел mfixupp;
    цел mmodend;

    цел lnameidx;               // index of следщ LNAMES record
    цел segidx;                 // index of следщ SEGDEF record
    цел extidx;                 // index of следщ EXTDEF record
    цел pubnamidx;              // index of COMDAT public имя index
    Outbuffer *reset_symbuf;    // Keep pointers to сбрось symbols

    Symbol *startaddress;       // if !null, then Symbol is start address

    debug
    цел fixup_count;

    Ledatarec **ledatas;
    т_мера ledatamax;           // index of allocated size
    т_мера ledatai;             // max index используется in ledatas[]

    // Line numbers
    list_t linnum_list;
    сим *linrec;               // line number record
    бцел linreci;               // index of следщ avail in linrec[]
    бцел linrecheader;          // size of line record header
    бцел linrecnum;             // number of line record entries
    list_t linreclist;          // list of line records
    цел mlinnum;
    цел recseg;
    цел term;
static if (MULTISCOPE)
{
    vec_t linvec;               // bit vector of line numbers используется
    vec_t offvec;               // and offsets используется
}

    цел fisegi;                 // SegData[] index of FI segment

version (Dinrus)
{
    цел fmsegi;                 // SegData[] of FM segment
    цел datrefsegi;             // SegData[] of DATA pointer ref segment
    цел tlsrefsegi;             // SegData[] of TLS pointer ref segment

    Outbuffer *ptrref_buf;      // буфер for pointer references
}

    цел tlssegi;                // SegData[] of tls segment
    цел fardataidx;

    сим[1024] pubdata;
    цел pubdatai;

    сим[1024] extdata;
    цел extdatai;

    // For OmfObj_far16thunk
    цел code16segi;             // SegData[] index
    targ_т_мера CODE16offset;

    цел fltused;
    цел nullext;
}


//{
public seg_data **SegData;

    цел seg_count;
    цел seg_max;

    Objstate obj;
//}


/*******************************
 * Output an объект файл данные record.
 * Input:
 *      rectyp  =       record тип
 *      record  .      the данные
 *      reclen  =       # of bytes in record
 */

проц objrecord(бцел rectyp, ткст0 record, бцел reclen)
{
    Outbuffer *o = obj.буф;

    //printf("rectyp = x%x, record[0] = x%x, reclen = x%x\n",rectyp,record[0],reclen);
    o.резервируй(reclen + 4);
    o.writeByten(cast(ббайт)rectyp);
    o.writeWordn(reclen + 1);  // record length includes checksum
    o.writen(record,reclen);
    o.writeByten(0);           // use 0 for checksum
}


/**************************
 * Insert an index number.
 * Input:
 *      p . where to put the 1 or 2 byte index
 *      index = the 15 bit index
 * Возвращает:
 *      # of bytes stored
 */

проц выведиОшибку(ткст0 имяф, бцел номстр, бцел имяс, ткст0 format, ...);
проц fatal();

проц too_many_symbols()
{
version (SCPP)
    err_fatal(EM_too_many_symbols, 0x7FFF);
else // Dinrus
{
    выведиОшибку(null, 0, 0, "more than %d symbols in объект файл", 0x7FFF);
    fatal();
}
}

version (X86) version (DigitalMars)
    version = X86ASM;

version (X86ASM)
{
цел insidx(сим *p,бцел index)
{
    asm
    {
        naked                           ;
        mov     EAX,[ESP+8]             ; // index
        mov     ECX,[ESP+4]             ; // p

        cmp     EAX,0x7F                ;
        jae     L1                      ;
        mov     [ECX],AL                ;
        mov     EAX,1                   ;
        ret                             ;


    L1:                                 ;
        cmp     EAX,0x7FFF              ;
        ja      L2                      ;

        mov     [ECX+1],AL              ;
        or      EAX,0x8000              ;
        mov     [ECX],AH                ;
        mov     EAX,2                   ;
        ret                             ;
    }
    L2:
        too_many_symbols();
}
}
else
{
цел insidx(сим *p,бцел index)
{
    //if (index > 0x7FFF) printf("index = x%x\n",index);
    /* OFM spec says it could be <=0x7F, but that seems to cause
     * "library is corrupted" messages. Unverified. See Bugzilla 3601
     */
    if (index < 0x7F)
    {
        *p = cast(сим)index;
        return 1;
    }
    else if (index <= 0x7FFF)
    {
        *(p + 1) = cast(сим)index;
        *p = cast(сим)((index >> 8) | 0x80);
        return 2;
    }
    else
    {
        too_many_symbols();
        return 0;
    }
}
}

/**************************
 * Insert a тип index number.
 * Input:
 *      p . where to put the 1 or 2 byte index
 *      index = the 15 bit index
 * Возвращает:
 *      # of bytes stored
 */

цел instypidx(сим *p,бцел index)
{
    if (index <= 127)
    {   *p = cast(сим)index;
        return 1;
    }
    else if (index <= 0x7FFF)
    {   *(p + 1) = cast(сим)index;
        *p = cast(сим)((index >> 8) | 0x80);
        return 2;
    }
    else                        // overflow
    {   *p = 0;                 // the linker ignores this field anyway
        return 1;
    }
}

/****************************
 * Read index.
 */

цел getindex(ббайт* p)
{
    return ((*p & 0x80)
    ? ((*p & 0x7F) << 8) | *(p + 1)
    : *p);
}

/*****************************
 * Возвращает:
 *      # of bytes stored
 */

const ONS_OHD = 4;               // max # of extra bytes added by obj_namestring()

private цел obj_namestring(сим *p,ткст0 имя)
{   бцел len;

    len = cast(бцел)strlen(имя);
    if (len > 255)
    {   p[0] = 0xFF;
        p[1] = 0;
        debug assert(len <= 0xFFFF);
        TOWORD(p + 2,len);
        memcpy(p + 4,имя,len);
        len += ONS_OHD;
    }
    else
    {   p[0] = cast(сим)len;
        memcpy(p + 1,имя,len);
        len++;
    }
    return len;
}

/******************************
 * Allocate a new segment.
 * Return index for the new segment.
 */

seg_data *getsegment()
{
    цел seg = ++seg_count;
    if (seg_count == seg_max)
    {
        seg_max += 10;
        SegData = cast(seg_data **)mem_realloc(SegData, seg_max * (seg_data *).sizeof);
        memset(&SegData[seg_count], 0, 10 * (seg_data *).sizeof);
    }
    assert(seg_count < seg_max);
    if (SegData[seg])
        memset(SegData[seg], 0, seg_data.sizeof);
    else
        SegData[seg] = cast(seg_data *)mem_calloc(seg_data.sizeof);

    seg_data *pseg = SegData[seg];
    pseg.SDseg = seg;
    pseg.segidx = 0;
    return pseg;
}

/**************************
 * Output читай only данные and generate a symbol for it.
 *
 */

Symbol * OmfObj_sym_cdata(tym_t ty,сим *p,цел len)
{
    Symbol *s;

    alignOffset(CDATA, tysize(ty));
    s = symboldata(Offset(CDATA), ty);
    s.Sseg = CDATA;
    OmfObj_bytes(CDATA, Offset(CDATA), len, p);
    Offset(CDATA) += len;

    s.Sfl = FLdata; //FLextern;
    return s;
}

/**************************
 * Ouput читай only данные for данные.
 * Output:
 *      *pseg   segment of that данные
 * Возвращает:
 *      смещение of that данные
 */

цел OmfObj_data_readonly(сим *p, цел len, цел *pseg)
{
version (Dinrus)
{
    targ_т_мера oldoff = Offset(CDATA);
    OmfObj_bytes(CDATA,Offset(CDATA),len,p);
    Offset(CDATA) += len;
    *pseg = CDATA;
}
else
{
    targ_т_мера oldoff = Offset(DATA);
    OmfObj_bytes(DATA,Offset(DATA),len,p);
    Offset(DATA) += len;
    *pseg = DATA;
}
    return cast(цел)oldoff;
}

цел OmfObj_data_readonly(сим *p, цел len)
{
    цел pseg;

    return OmfObj_data_readonly(p, len, &pseg);
}

/*****************************
 * Get segment for readonly ткст literals.
 * The linker will pool strings in this section.
 * Параметры:
 *    sz = number of bytes per character (1, 2, or 4)
 * Возвращает:
 *    segment index
 */
цел OmfObj_string_literal_segment(бцел sz)
{
    assert(0);
}

segidx_t OmfObj_seg_debugT()
{
    return DEBTYP;
}

/******************************
 * Perform initialization that applies to all .obj output files.
 * Input:
 *      имяф        source файл имя
 *      csegname        code segment имя (can be null)
 */

Obj OmfObj_init(Outbuffer *objbuf, ткст0 имяф, ткст0 csegname)
{
        //printf("OmfObj_init()\n");
        Obj mobj = cast(Obj)mem_calloc(__traits(classInstanceSize, Obj));

        Outbuffer *reset_symbuf = obj.reset_symbuf;
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

        memset(&obj,0,obj.sizeof);

        obj.буф = objbuf;
        obj.буф.резервируй(40000);

        obj.reset_symbuf = reset_symbuf; // reuse буфер

        obj.lastfardatasegi = -1;

        obj.mlidata = LIDATA;
        obj.mpubdef = PUBDEF;
        obj.mfixupp = FIXUPP;
        obj.mmodend = MODEND;
        obj.mlinnum = LINNUM;


        // Reset for different OBJ файл formats
        if (I32)
        {   if (config.flags & CFGeasyomf)
            {   obj.LOCoffset = EASY_LOCoffset;
                obj.LOCpointer = EASY_LOCpointer;
            }
            else
            {
                obj.mlidata = LID386;
                obj.mpubdef = PUB386;
                obj.mfixupp = FIX386;
                obj.mmodend = MODEND + 1;
                obj.LOCoffset = LOC32offset;
                obj.LOCpointer = LOC32pointer;
            }
            obj.fdsegattr = SEG_ATTR(SEG_ALIGN16,SEG_C_PUBLIC,0,USE32);
            obj.csegattr  = SEG_ATTR(SEG_ALIGN4, SEG_C_PUBLIC,0,USE32);
        }
        else
        {
            obj.LOCoffset  = LOC16offset;
            obj.LOCpointer = LOC16pointer;
            obj.fdsegattr = SEG_ATTR(SEG_ALIGN16,SEG_C_PUBLIC,0,USE16);
            obj.csegattr  = SEG_ATTR(SEG_ALIGN2, SEG_C_PUBLIC,0,USE16);
        }

        if (config.flags4 & CFG4speed && // if optimized for speed
            config.target_cpu == TARGET_80486)
            // 486 is only CPU that really benefits from alignment
            obj.csegattr  = I32 ? SEG_ATTR(SEG_ALIGN16, SEG_C_PUBLIC,0,USE32)
                                : SEG_ATTR(SEG_ALIGN16, SEG_C_PUBLIC,0,USE16);

        if (!SegData)
        {   seg_max = UDATA + 10;
            SegData = cast(seg_data **)mem_calloc(seg_max * (seg_data *).sizeof);
        }

        for (цел i = 0; i < seg_max; i++)
        {
            if (SegData[i])
                memset(SegData[i], 0, seg_data.sizeof);
            else
                SegData[i] = cast(seg_data *)mem_calloc(seg_data.sizeof);
        }

        SegData[CODE].SDseg = CODE;
        SegData[DATA].SDseg = DATA;
        SegData[CDATA].SDseg = CDATA;
        SegData[UDATA].SDseg = UDATA;

        SegData[CODE].segidx = CODE;
        SegData[DATA].segidx = DATA;
        SegData[CDATA].segidx = CDATA;
        SegData[UDATA].segidx = UDATA;

        seg_count = UDATA;

        if (config.fulltypes)
        {
            SegData[DEBSYM].SDseg = DEBSYM;
            SegData[DEBTYP].SDseg = DEBTYP;

            SegData[DEBSYM].segidx = DEBSYM;
            SegData[DEBTYP].segidx = DEBTYP;

            seg_count = DEBTYP;
        }

        OmfObj_theadr(имяф);
        obj.modname = имяф;
        if (!csegname || !*csegname)            // if no code seg имя supplied
            obj.csegname = objmodtoseg(obj.modname);    // generate one
        else
            obj.csegname = mem_strdup(csegname);        // our own копируй
        objheader(obj.csegname);
        OmfObj_segment_group(0,0,0,0);             // obj seg and grp info
        ledata_new(cseg,0);             // so ledata is never null
        if (config.fulltypes)           // if full typing information
        {   objmod = mobj;
            cv_init();                  // initialize debug output code
        }

        return mobj;
}

/**************************
 * Initialize the start of объект output for this particular .obj файл.
 */

проц OmfObj_initfile(ткст0 имяф,ткст0 csegname, ткст0 modname)
{
}

/***************************
 * Fixup and terminate объект файл.
 */

проц OmfObj_termfile()
{
}

/*********************************
 * Terminate package.
 */

проц OmfObj_term(ткст0 objfilename)
{
        //printf("OmfObj_term()\n");
        list_t dl;
        бцел size;

version (SCPP)
{
        if (!errcnt)
        {
            obj_defaultlib();
            objflush_pointerRefs();
            outfixlist();               // backpatches
        }
}
else
{
        obj_defaultlib();
        objflush_pointerRefs();
        outfixlist();               // backpatches
}
        if (config.fulltypes)
            cv_term();                  // пиши out final debug info
        outextdata();                   // finish writing EXTDEFs
        outpubdata();                   // finish writing PUBDEFs

        // Put out LEDATA records and associated fixups
        for (т_мера i = 0; i < obj.ledatai; i++)
        {   Ledatarec *d = obj.ledatas[i];

            if (d.i)                   // if any данные in this record
            {   // Fill in header
                цел headersize;
                цел rectyp;
                assert(d.lseg > 0 && d.lseg <= seg_count);
                цел lseg = SegData[d.lseg].segidx;
                сим[(d.header).sizeof] header = проц;

                if (seg_is_comdat(lseg))   // if COMDAT
                {
                    header[0] = d.flags | (d.смещение ? 1 : 0); // continuation флаг
                    header[1] = d.alloctyp;
                    header[2] = d._align;
                    TOOFFSET(header.ptr + 3,d.смещение);
                    headersize = 3 + _tysize[TYint];
                    headersize += instypidx(header.ptr + headersize,d.typidx);
                    if ((header[1] & 0x0F) == 0)
                    {   // Group index
                        header[headersize] = (d.pubbase == DATA) ? 1 : 0;
                        headersize++;

                        // Segment index
                        headersize += insidx(header.ptr + headersize,d.pubbase);
                    }
                    headersize += insidx(header.ptr + headersize,d.pubnamidx);

                    rectyp = I32 ? COMDAT + 1 : COMDAT;
                }
                else
                {
                    rectyp = LEDATA;
                    headersize = insidx(header.ptr,lseg);
                    if (_tysize[TYint] == LONGSIZE || d.смещение & ~0xFFFFL)
                    {   if (!(config.flags & CFGeasyomf))
                            rectyp++;
                        TOLONG(header.ptr + headersize,cast(бцел)d.смещение);
                        headersize += 4;
                    }
                    else
                    {
                        TOWORD(header.ptr + headersize,cast(бцел)d.смещение);
                        headersize += 2;
                    }
                }
                assert(headersize <= (d.header).sizeof);

                // Right-justify данные in d.header[]
                memcpy(d.header.ptr + (d.header).sizeof - headersize,header.ptr,headersize);
                //printf("objrecord(rectyp=x%02x, d=%p, p=%p, size = %d)\n",
                //rectyp,d,d.header.ptr + ((d.header).sizeof - headersize),d.i + headersize);

                objrecord(rectyp,cast(сим*)d.header.ptr + ((d.header).sizeof - headersize),
                        d.i + headersize);
                objfixupp(d.fixuplist);
            }
        }

static if (TERMCODE)
{
        //list_free(&obj.ledata_list,mem_freefp);
}

        linnum_term();
        obj_modend();

        size = cast(бцел)obj.буф.size();
        obj.буф.устРазм(0);            // rewind файл
        OmfObj_theadr(obj.modname);
        objheader(obj.csegname);
        mem_free(obj.csegname);
        OmfObj_segment_group(SegData[CODE].SDoffset, SegData[DATA].SDoffset, SegData[CDATA].SDoffset, SegData[UDATA].SDoffset);  // do real sizes

        // Update any out-of-date far segment sizes
        for (т_мера i = 0; i <= seg_count; i++)
        {
            seg_data* f = SegData[i];
            if (f.isfarseg && f.origsize != f.SDoffset)
            {   obj.буф.устРазм(cast(цел)f.seek);
                objsegdef(f.attr,f.SDoffset,f.lnameidx,f.classidx);
            }
        }
        //mem_free(obj.farseg);

        //printf("Ledata max = %d\n", obj.ledatai);
        //printf("Max # of fixups = %d\n",obj.fixup_count);

        obj.буф.устРазм(size);
}

/*****************************
 * Line number support.
 */

/***************************
 * Record line number номстр at смещение.
 * Параметры:
 *      srcpos = source файл position
 *      seg = segment it corresponds to (negative for COMDAT segments)
 *      смещение = смещение within seg
 *      pubnamidx = public имя index
 *      obj.mlinnum = LINNUM or LINSYM
 */

проц OmfObj_linnum(Srcpos srcpos,цел seg,targ_т_мера смещение)
{
version (Dinrus)
    varStats_recordLineOffset(srcpos, смещение);

    бцел номстр = srcpos.Slinnum;

static if (0)
{
    printf("OmfObj_linnum(seg=%d, смещение=0x%x) ", seg, cast(цел)смещение);
    srcpos.print("");
}

    сим linos2 = config.exe == EX_OS2 && !seg_is_comdat(SegData[seg].segidx);

version (Dinrus)
{
    бул cond = (!obj.term &&
        (seg_is_comdat(SegData[seg].segidx) || (srcpos.Sfilename && srcpos.Sfilename != obj.modname)));
}
else
{
    if (!srcpos.Sfilptr)
        return;
    sfile_debug(*srcpos.Sfilptr);
    бул cond = !obj.term &&
                (!(srcpos_sfile(srcpos).SFflags & SFtop) || (seg_is_comdat(SegData[seg].segidx) && !obj.term));
}
    if (cond)
    {
        // Not original source файл, or a COMDAT.
        // Save данные away and deal with it at close of compile.
        // It is done this way because presumably 99% of the строки
        // will be in the original source файл, so we wish to minimize
        // memory consumption and maximize speed.
        list_t ll;
        Linnum *ln;

        if (linos2)
            return;             // BUG: not supported under OS/2
        for (ll = obj.linnum_list; 1; ll = list_next(ll))
        {
            if (!ll)
            {
                ln = cast(Linnum *) mem_calloc(Linnum.sizeof);
version (Dinrus)
{
                ln.имяф = srcpos.Sfilename;
}
else
{
                ln.filptr = *srcpos.Sfilptr;
}
                ln.cseg = seg;
                ln.seg = obj.pubnamidx;
                list_prepend(&obj.linnum_list,ln);
                break;
            }
            ln = cast(Linnum *)list_ptr(ll);

version (Dinrus)
            бул cond2 = ln.имяф == srcpos.Sfilename;
else version (SCPP)
            бул cond2 = ln.filptr == *srcpos.Sfilptr;

            if (cond2 &&
                ln.cseg == seg &&
                ln.i < LINNUMMAX - 6)
                break;
        }
        //printf("смещение = x%x, line = %d\n", (цел)смещение, номстр);
        TOWORD(&ln.данные[ln.i],номстр);
        TOOFFSET(&ln.данные[ln.i + 2],смещение);
        ln.i += 2 + _tysize[TYint];
    }
    else
    {
        if (linos2 && obj.linreci > LINRECMAX - 8)
            obj.linrec = null;                  // размести a new one
        else if (seg != obj.recseg)
            linnum_flush();

        if (!obj.linrec)                        // if not allocated
        {
            obj.linrec = cast(ткст0 ) mem_calloc(LINRECMAX);
            obj.linrec[0] = 0;              // base group / flags
            obj.linrecheader = 1 + insidx(obj.linrec + 1,seg_is_comdat(SegData[seg].segidx) ? obj.pubnamidx : SegData[seg].segidx);
            obj.linreci = obj.linrecheader;
            obj.recseg = seg;
static if (MULTISCOPE)
{
            if (!obj.linvec)
            {
                obj.linvec = vec_calloc(1000);
                obj.offvec = vec_calloc(1000);
            }
}
            if (linos2)
            {
                if (!obj.linreclist)        // if first line number record
                    obj.linreci += 8;       // leave room for header
                list_append(&obj.linreclist,obj.linrec);
            }

            // Select record тип to use
            obj.mlinnum = seg_is_comdat(SegData[seg].segidx) ? LINSYM : LINNUM;
            if (I32 && !(config.flags & CFGeasyomf))
                obj.mlinnum++;
        }
        else if (obj.linreci > LINRECMAX - (2 + _tysize[TYint]))
        {
            objrecord(obj.mlinnum,obj.linrec,obj.linreci);  // output данные
            obj.linreci = obj.linrecheader;
            if (seg_is_comdat(SegData[seg].segidx))        // if LINSYM record
                obj.linrec[0] |= 1;         // continuation bit
        }
static if (MULTISCOPE)
{
        if (номстр >= vec_numbits(obj.linvec))
            obj.linvec = vec_realloc(obj.linvec,номстр + 1000);
        if (смещение >= vec_numbits(obj.offvec))
        {
            if (смещение < 0xFF00)        // otherwise we overflow ph_malloc()
                obj.offvec = vec_realloc(obj.offvec,cast(бцел)смещение * 2);
        }
        бул cond3 =
            // disallow multiple offsets per line
            !vec_testbit(номстр,obj.linvec) &&  // if номстр not already используется

            // disallow multiple строки per смещение
            (смещение >= 0xFF00 || !vec_testbit(cast(бцел)смещение,obj.offvec));      // and смещение not already используется
}
else
        const cond3 = да;

        if (cond3)
        {
static if (MULTISCOPE)
{
            vec_setbit(номстр,obj.linvec);              // mark номстр as используется
            if (смещение < 0xFF00)
                vec_setbit(cast(бцел)смещение,obj.offvec);  // mark смещение as используется
}
            TOWORD(obj.linrec + obj.linreci,номстр);
            if (linos2)
            {
                obj.linrec[obj.linreci + 2] = 1;        // source файл index
                TOLONG(obj.linrec + obj.linreci + 4,cast(бцел)смещение);
                obj.linrecnum++;
                obj.linreci += 8;
            }
            else
            {
                TOOFFSET(obj.linrec + obj.linreci + 2,смещение);
                obj.linreci += 2 + _tysize[TYint];
            }
        }
    }
}

/***************************
 * Flush any pending line number records.
 */

private проц linnum_flush()
{
    if (obj.linreclist)
    {
        list_t list;
        т_мера len;

        obj.linrec = cast(сим *) list_ptr(obj.linreclist);
        TOWORD(obj.linrec + 6,obj.linrecnum);
        list = obj.linreclist;
        while (1)
        {
            obj.linrec = cast(сим *) list_ptr(list);

            list = list_next(list);
            if (list)
            {
                objrecord(obj.mlinnum,obj.linrec,LINRECMAX);
                mem_free(obj.linrec);
            }
            else
            {
                objrecord(obj.mlinnum,obj.linrec,obj.linreci);
                break;
            }
        }
        list_free(&obj.linreclist,FPNULL);

        // Put out Файл Names Table
        TOLONG(obj.linrec + 2,0);               // record no. of start of source (???)
        TOLONG(obj.linrec + 6,obj.linrecnum);   // number of primary source records
        TOLONG(obj.linrec + 10,1);              // number of source and listing files
        len = obj_namestring(obj.linrec + 14,obj.modname);
        assert(14 + len <= LINRECMAX);
        objrecord(obj.mlinnum,obj.linrec,cast(бцел)(14 + len));

        mem_free(obj.linrec);
        obj.linrec = null;
    }
    else if (obj.linrec)                        // if some line numbers to send
    {
        objrecord(obj.mlinnum,obj.linrec,obj.linreci);
        mem_free(obj.linrec);
        obj.linrec = null;
    }
static if (MULTISCOPE)
{
    vec_clear(obj.linvec);
    vec_clear(obj.offvec);
}
}

/*************************************
 * Terminate line numbers.
 */

private проц linnum_term()
{
    list_t ll;

version (SCPP)
    Sfile *lastfilptr = null;

version (Dinrus)
    ткст0 lastfilename = null;

    цел csegsave = cseg;

    linnum_flush();
    obj.term = 1;
    while (obj.linnum_list)
    {
        Linnum *ln;
        бцел u;
        Srcpos srcpos;
        targ_т_мера смещение;

        ll = obj.linnum_list;
        ln = cast(Linnum *) list_ptr(ll);
version (SCPP)
{
        Sfile *filptr = ln.filptr;
        if (filptr != lastfilptr)
        {
            if (lastfilptr == null && strcmp(filptr.SFname,obj.modname))
            {
                OmfObj_theadr(filptr.SFname);
            }
            lastfilptr = filptr;
        }
}
version (Dinrus)
{
        ткст0 имяф = ln.имяф;
        if (имяф != lastfilename)
        {
            if (имяф)
                objmod.theadr(имяф);
            lastfilename = имяф;
        }
}
        while (1)
        {
            cseg = ln.cseg;
            assert(cseg > 0);
            obj.pubnamidx = ln.seg;
version (Dinrus)
{
            srcpos.Sfilename = ln.имяф;
}
else
{
            srcpos.Sfilptr = &ln.filptr;
}
            for (u = 0; u < ln.i; )
            {
                srcpos.Slinnum = *cast(ushort *)&ln.данные[u];
                u += 2;
                if (I32)
                    смещение = *cast(бцел *)&ln.данные[u];
                else
                    смещение = *cast(ushort *)&ln.данные[u];
                OmfObj_linnum(srcpos,cseg,смещение);
                u += _tysize[TYint];
            }
            linnum_flush();
            ll = list_next(ll);
            list_subtract(&obj.linnum_list,ln);
            mem_free(ln);
        L1:
            if (!ll)
                break;
            ln = cast(Linnum *) list_ptr(ll);
version (SCPP)
{
            if (filptr != ln.filptr)
            {   ll = list_next(ll);
                goto L1;
            }
}
else
{
            if (имяф != ln.имяф)
            {   ll = list_next(ll);
                goto L1;
            }
}
        }
    }
    cseg = csegsave;
    assert(cseg > 0);
static if (MULTISCOPE)
{
    vec_free(obj.linvec);
    vec_free(obj.offvec);
}
}

/*******************************
 * Set start address
 */

проц OmfObj_startaddress(Symbol *s)
{
    obj.startaddress = s;
}

/*******************************
 * Output DOSSEG coment record.
 */

проц OmfObj_dosseg()
{
    static const сим[2] dosseg = [ 0x80,0x9E ];

    objrecord(COMENT, dosseg.ptr, dosseg.sizeof);
}

/*******************************
 * Embed коммент record.
 */

private проц obj_comment(ббайт x, ткст0 ткст, т_мера len)
{
    сим[128] буф = проц;

    сим *library = (2 + len <= буф.sizeof) ? буф.ptr : cast(сим *) malloc(2 + len);
    assert(library);
    library[0] = 0;
    library[1] = x;
    memcpy(library + 2,ткст,len);
    objrecord(COMENT,library,cast(бцел)(len + 2));
    if (library != буф.ptr)
        free(library);
}

/*******************************
 * Output library имя.
 * Output:
 *      имя is modified
 * Возвращает:
 *      да if operation is supported
 */

бул OmfObj_includelib(ткст0 имя)
{
    ткст0 p;
    т_мера len = strlen(имя);

    p = filespecdotext(имя);
    if (!filespeccmp(p,".lib"))
        len -= strlen(p);               // lop off .LIB extension
    obj_comment(0x9F, имя, len);
    return да;
}

/*******************************
* Output linker directive.
* Output:
*      directive is modified
* Возвращает:
*      да if operation is supported
*/

бул OmfObj_linkerdirective(ткст0 имя)
{
    return нет;
}

/**********************************
 * Do we allow нуль sized objects?
 */

бул OmfObj_allowZeroSize()
{
    return нет;
}

/**************************
 * Embed ткст in executable.
 */

проц OmfObj_exestr(ткст0 p)
{
    obj_comment(0xA4,p, strlen(p));
}

/**************************
 * Embed ткст in obj.
 */

проц OmfObj_user(ткст0 p)
{
    obj_comment(0xDF,p, strlen(p));
}

/*********************************
 * Put out default library имя.
 */

private проц obj_defaultlib()
{
    сим[4] library;            // default library
    static const сим[5+1] model = "SMCLV";

version (Dinrus)
    memcpy(library.ptr,"SM?".ptr,4);
else
    memcpy(library.ptr,"SD?".ptr,4);

    switch (config.exe)
    {
        case EX_OS2:
            library[2] = 'F';
            goto case;

        case EX_OS1:
            library[1] = 'O';
            break;
        case EX_WIN32:
version (Dinrus)
            library[1] = 'M';
else
            library[1] = 'N';

            library[2] = (config.flags4 & CFG4dllrtl) ? 'D' : 'N';
            break;
        case EX_DOSX:
        case EX_PHARLAP:
            library[2] = 'X';
            break;
        default:
            library[2] = model[config.memmodel];
            if (config.wflags & WFwindows)
                library[1] = 'W';
            break;
    }

    if (!(config.flags2 & CFG2nodeflib))
    {
        objmod.includelib(configv.deflibname ? configv.deflibname : library.ptr);
    }
}

/*******************************
 * Output a weak extern record.
 * s1 is the weak extern, s2 is its default resolution.
 */

проц OmfObj_wkext(Symbol *s1,Symbol *s2)
{
    //printf("OmfObj_wkext(%s)\n", s1.Sident.ptr);
    if (I32)
    {
        // Optlink crashes with weak symbols at EIP 41AFE7, 402000
        return;
    }

    цел x2;
    if (s2)
        x2 = s2.Sxtrnnum;
    else
    {
        if (!obj.nullext)
        {
            obj.nullext = OmfObj_external_def("__nullext");
        }
        x2 = obj.nullext;
    }
    outextdata();

    сим[2+2+2] буфер = проц;
    буфер[0] = 0x80;
    буфер[1] = 0xA8;
    цел i = 2;
    i += insidx(&буфер[2],s1.Sxtrnnum);
    i += insidx(&буфер[i],x2);
    objrecord(COMENT,буфер.ptr,i);
}

/*******************************
 * Output a lazy extern record.
 * s1 is the lazy extern, s2 is its default resolution.
 */

проц OmfObj_lzext(Symbol *s1,Symbol *s2)
{
    сим[2+2+2] буфер = проц;
    цел i;

    outextdata();
    буфер[0] = 0x80;
    буфер[1] = 0xA9;
    i = 2;
    i += insidx(&буфер[2],s1.Sxtrnnum);
    i += insidx(&буфер[i],s2.Sxtrnnum);
    objrecord(COMENT,буфер.ptr,i);
}

/*******************************
 * Output an alias definition record.
 */

проц OmfObj_alias(ткст0 n1,ткст0 n2)
{
    бцел len;
    ткст0 буфер;

    буфер = cast(сим *) alloca(strlen(n1) + strlen(n2) + 2 * ONS_OHD);
    len = obj_namestring(буфер,n1);
    len += obj_namestring(буфер + len,n2);
    objrecord(ALIAS,буфер,len);
}

/*******************************
 * Output module имя record.
 */

проц OmfObj_theadr(ткст0 modname)
{
    //printf("OmfObj_theadr(%s)\n", modname);

    // Convert to absolute файл имя, so debugger can найди it anywhere
    сим[260] absname = проц;
    if (config.fulltypes &&
        modname[0] != '\\' && modname[0] != '/' && !(modname[0] && modname[1] == ':'))
    {
        if (getcwd(absname.ptr, absname.sizeof))
        {
            цел len = cast(цел)strlen(absname.ptr);
            if(absname[len - 1] != '\\' && absname[len - 1] != '/')
                absname[len++] = '\\';
            strcpy(absname.ptr + len, modname);
            modname = absname.ptr;
        }
    }

    сим *theadr = cast(сим *)alloca(ONS_OHD + strlen(modname));
    цел i = obj_namestring(theadr,modname);
    objrecord(THEADR,theadr,i);                 // module имя record
}

/*******************************
 * Embed compiler version in .obj файл.
 */

проц OmfObj_compiler()
{
    ткст0 compiler = "\0\xDB" ~ "Digital Mars C/C++"
        ~ VERSION
        ;       // compiled by ...

    objrecord(COMENT,compiler,cast(бцел)strlen(compiler));
}

/*******************************
 * Output header stuff for объект files.
 * Input:
 *      csegname        Name to use for code segment (null if use default)
 */

const CODECLASS  = 4;    // code class lname index
const DATACLASS  = 6;    // данные class lname index
const CDATACLASS = 7;    // CONST class lname index
const BSSCLASS   = 9;    // BSS class lname index

private проц objheader(сим *csegname)
{
  сим *nam;
     сим[78] lnames =
        "\0\06DGROUP\05_TEXT\04CODE\05_DATA\04DATA\05CONST\04_BSS\03BSS" ~
        "\07$$TYPES\06DEBTYP\011$$SYMBOLS\06DEBSYM";
    assert(lnames[lnames.length - 2] == 'M');

    // Include debug segment имена if inserting тип information
    цел lnamesize = config.fulltypes ? lnames.sizeof - 1 : lnames.sizeof - 1 - 32;
    цел texti = 8;                                // index of _TEXT

     сим[5] коммент = [0,0x9D,'0','?','O']; // memory model
     сим[5+1] model = "smclv";
     сим[5] exten = [0,0xA1,1,'C','V'];     // extended format
     сим[7] pmdeb = [0x80,0xA1,1,'H','L','L',0];    // IBM PM debug format

    if (I32)
    {
        if (config.flags & CFGeasyomf)
        {
            // Indicate we're in EASY OMF (hah!) format
            static const сим[7] easy_omf = [ 0x80,0xAA,'8','0','3','8','6' ];
            objrecord(COMENT,easy_omf.ptr,easy_omf.sizeof);
        }
    }

    // Send out a коммент record showing what memory model was используется
    коммент[2] = cast(сим)(config.target_cpu + '0');
    коммент[3] = model[config.memmodel];
    if (I32)
    {
        if (config.exe == EX_WIN32)
            коммент[3] = 'n';
        else if (config.exe == EX_OS2)
            коммент[3] = 'f';
        else
            коммент[3] = 'x';
    }
    objrecord(COMENT,коммент.ptr,коммент.sizeof);

    // Send out коммент indicating we're using extensions to .OBJ format
    if (config.exe == EX_OS2)
        objrecord(COMENT, pmdeb.ptr, pmdeb.sizeof);
    else
        objrecord(COMENT, exten.ptr, exten.sizeof);

    // Change DGROUP to FLAT if we are doing flat memory model
    // (Watch out, objheader() is called twice!)
    if (config.exe & EX_flat)
    {
        if (lnames[2] != 'F')                   // do not do this twice
        {
            memcpy(lnames.ptr + 1, "\04FLAT".ptr, 5);
            memmove(lnames.ptr + 6, lnames.ptr + 8, lnames.sizeof - 8);
        }
        lnamesize -= 2;
        texti -= 2;
    }

    // Put out segment and group имена
    if (csegname)
    {
        // Replace the module имя _TEXT with the new code segment имя
        const т_мера i = strlen(csegname);
        сим *p = cast(сим *)alloca(lnamesize + i - 5);
        memcpy(p,lnames.ptr,8);
        p[texti] = cast(сим)i;
        texti++;
        memcpy(p + texti,csegname,i);
        memcpy(p + texti + i,lnames.ptr + texti + 5,lnamesize - (texti + 5));
        objrecord(LNAMES,p,cast(бцел)(lnamesize + i - 5));
    }
    else
        objrecord(LNAMES,lnames.ptr,lnamesize);
}

/********************************
 * Convert module имя to code segment имя.
 * Output:
 *      mem_malloc'd code seg имя
 */

private ткст0  objmodtoseg(ткст0 modname)
{
    ткст0 csegname = null;

    if (LARGECODE)              // if need to add in module имя
    {
        цел i;
        ткст0 m;
        static const сим[6] suffix = "_TEXT";

        // Prepend the module имя to the beginning of the _TEXT
        m = filespecgetroot(filespecname(modname));
        strupr(m);
        i = cast(цел)strlen(m);
        csegname = cast(сим *)mem_malloc(i + suffix.sizeof);
        strcpy(csegname,m);
        strcat(csegname,suffix.ptr);
        mem_free(m);
    }
    return csegname;
}

/*********************************
 * Put out a segment definition.
 */

private проц objsegdef(цел attr,targ_т_мера size,цел segnamidx,цел classnamidx)
{
    бцел reclen;
    сим[1+4+2+2+2+1] sd = проц;

    //printf("objsegdef(attr=x%x, size=x%x, segnamidx=x%x, classnamidx=x%x)\n",
      //attr,size,segnamidx,classnamidx);
    sd[0] = cast(сим)attr;
    if (attr & 1 || config.flags & CFGeasyomf)
    {
        TOLONG(sd.ptr + 1, cast(бцел)size);          // store segment size
        reclen = 5;
    }
    else
    {
        debug
        assert(size <= 0xFFFF);

        TOWORD(sd.ptr + 1,cast(бцел)size);
        reclen = 3;
    }
    reclen += insidx(sd.ptr + reclen,segnamidx);    // segment имя index
    reclen += insidx(sd.ptr + reclen,classnamidx);  // class имя index
    sd[reclen] = 1;                             // overlay имя index
    reclen++;
    if (attr & 1)                       // if USE32
    {
        if (config.flags & CFGeasyomf)
        {
            // Translate to Pharlap format
            sd[0] &= ~1;                // turn off P bit

            // Translate A: 4.6
            attr &= SEG_ATTR(7,0,0,0);
            if (attr == SEG_ATTR(4,0,0,0))
                sd[0] ^= SEG_ATTR(4 ^ 6,0,0,0);

            // 2 is execute/читай
            // 3 is читай/пиши
            // 4 is use32
            sd[reclen] = (classnamidx == 4) ? (4+2) : (4+3);
            reclen++;
        }
    }
    else                                // 16 bit segment
    {
version (Dinrus)
        assert(0);
else
{
        if (size & ~0xFFFFL)
        {
            if (size == 0x10000)        // if exactly 64Kb
                sd[0] |= 2;             // set "B" bit
            else
                synerr(EM_seg_gt_64k,size);     // segment exceeds 64Kb
        }
//printf("attr = %x\n", attr);
}
    }
    debug
    assert(reclen <= sd.sizeof);

    objrecord(SEGDEF + (sd[0] & 1),sd.ptr,reclen);
}

/*********************************
 * Output segment and group definitions.
 * Input:
 *      codesize        size of code segment
 *      datasize        size of initialized данные segment
 *      cdatasize       size of initialized const данные segment
 *      udatasize       size of uninitialized данные segment
 */

проц OmfObj_segment_group(targ_т_мера codesize,targ_т_мера datasize,
                targ_т_мера cdatasize,targ_т_мера udatasize)
{
    цел dsegattr;
    цел dsymattr;

    // Group into DGROUP the segments CONST, _BSS and _DATA
    // For FLAT model, it's just GROUP FLAT
    static const сим[7] grpdef = [2,0xFF,2,0xFF,3,0xFF,4];

    objsegdef(obj.csegattr,codesize,3,CODECLASS);  // seg _TEXT, class CODE

version (Dinrus)
{
    dsegattr = SEG_ATTR(SEG_ALIGN16,SEG_C_PUBLIC,0,USE32);
    objsegdef(dsegattr,datasize,5,DATACLASS);   // [DATA]  seg _DATA, class DATA
    objsegdef(dsegattr,cdatasize,7,CDATACLASS); // [CDATA] seg CONST, class CONST
    objsegdef(dsegattr,udatasize,8,BSSCLASS);   // [UDATA] seg _BSS,  class BSS
}
else
{
    dsegattr = I32
          ? SEG_ATTR(SEG_ALIGN4,SEG_C_PUBLIC,0,USE32)
          : SEG_ATTR(SEG_ALIGN2,SEG_C_PUBLIC,0,USE16);
    objsegdef(dsegattr,datasize,5,DATACLASS);   // seg _DATA, class DATA
    objsegdef(dsegattr,cdatasize,7,CDATACLASS); // seg CONST, class CONST
    objsegdef(dsegattr,udatasize,8,BSSCLASS);   // seg _BSS, class BSS
}

    obj.lnameidx = 10;                          // следщ lname index
    obj.segidx = 5;                             // следщ segment index

    if (config.fulltypes)
    {
        dsymattr = I32
              ? SEG_ATTR(SEG_ALIGN1,SEG_C_ABS,0,USE32)
              : SEG_ATTR(SEG_ALIGN1,SEG_C_ABS,0,USE16);

        if (config.exe & EX_flat)
        {
            // IBM's version of CV uses dword aligned segments
            dsymattr = SEG_ATTR(SEG_ALIGN4,SEG_C_ABS,0,USE32);
        }
        else if (config.fulltypes == CV4)
        {
            // Always use 32 bit segments
            dsymattr |= USE32;
            assert(!(config.flags & CFGeasyomf));
        }
        objsegdef(dsymattr,SegData[DEBSYM].SDoffset,0x0C,0x0D);
        objsegdef(dsymattr,SegData[DEBTYP].SDoffset,0x0A,0x0B);
        obj.lnameidx += 4;                      // следщ lname index
        obj.segidx += 2;                        // следщ segment index
    }

    objrecord(GRPDEF,grpdef.ptr,(config.exe & EX_flat) ? 1 : grpdef.sizeof);
static if (0)
{
    // Define fixup threads, we don't use them
    {
        static const сим[12] thread = [ 0,3,1,2,2,1,3,4,0x40,1,0x45,1 ];
        objrecord(obj.mfixupp,thread.ptr,thread.sizeof);
    }
    // This коммент appears to indicate that no more PUBDEFs, EXTDEFs,
    // or COMDEFs are coming.
    {
        static const сим[3] cv = [0,0xA2,1];
        objrecord(COMENT,cv.ptr,cv.sizeof);
    }
}
}


/**************************************
 * Symbol is the function that calls the static constructors.
 * Put a pointer to it into a special segment that the startup code
 * looks at.
 * Input:
 *      s       static constructor function
 *      dtor    number of static destructors
 *      seg     1:      user
 *              2:      lib
 *              3:      compiler
 */

проц OmfObj_staticctor(Symbol *s,цел dtor,цел seg)
{
    // We need to always put out the segments in triples, so that the
    // linker will put them in the correct order.
    static const сим[28] lnamector = "\05XIFCB\04XIFU\04XIFL\04XIFM\05XIFCE";
    static const сим[15] lnamedtor = "\04XOFB\03XOF\04XOFE";
    static const сим[12] lnamedtorf = "\03XOB\02XO\03XOE";

    symbol_debug(s);

    // Determine if near or far function
    assert(I32 || tyfarfunc(s.ty()));

    // Put out LNAMES record
    objrecord(LNAMES,lnamector.ptr,lnamector.sizeof - 1);

    цел dsegattr = I32
        ? SEG_ATTR(SEG_ALIGN4,SEG_C_PUBLIC,0,USE32)
        : SEG_ATTR(SEG_ALIGN2,SEG_C_PUBLIC,0,USE16);

    for (цел i = 0; i < 5; i++)
    {
        цел sz;

        sz = (i == seg) ? 4 : 0;

        // Put out segment definition record
        objsegdef(dsegattr,sz,obj.lnameidx,DATACLASS);

        if (i == seg)
        {
            seg_data *pseg = getsegment();
            pseg.segidx = obj.segidx;
            OmfObj_reftoident(pseg.SDseg,0,s,0,0);     // put out function pointer
        }

        obj.segidx++;
        obj.lnameidx++;
    }

    if (dtor)
    {
        // Leave space in XOF segment so that __fatexit() can вставь a
        // pointer to the static destructor in XOF.

        // Put out LNAMES record
        if (LARGEDATA)
            objrecord(LNAMES,lnamedtorf.ptr,lnamedtorf.sizeof - 1);
        else
            objrecord(LNAMES,lnamedtor.ptr,lnamedtor.sizeof - 1);

        // Put out beginning segment
        objsegdef(dsegattr,0,obj.lnameidx,BSSCLASS);

        // Put out segment definition record
        objsegdef(dsegattr,4 * dtor,obj.lnameidx + 1,BSSCLASS);

        // Put out ending segment
        objsegdef(dsegattr,0,obj.lnameidx + 2,BSSCLASS);

        obj.lnameidx += 3;                      // for следщ time
        obj.segidx += 3;
    }
}

проц OmfObj_staticdtor(Symbol *s)
{
    assert(0);
}


/***************************************
 * Set up function to be called as static constructor on program
 * startup or static destructor on program shutdown.
 * Параметры:
 *      s = function symbol
 *      isCtor = да if constructor, нет if destructor
 */

проц OmfObj_setModuleCtorDtor(Symbol *s, бул isCtor)
{
    // We need to always put out the segments in triples, so that the
    // linker will put them in the correct order.
    static const сим[5+4+5+1][4] lnames =
    [   "\03XIB\02XI\03XIE",            // near constructor
        "\03XCB\02XC\03XCE",            // near destructor
        "\04XIFB\03XIF\04XIFE",         // far constructor
        "\04XCFB\03XCF\04XCFE",         // far destructor
    ];
    // Size of each of the above strings
    static const цел[4] lnamesize = [ 4+3+4,4+3+4,5+4+5,5+4+5 ];

    цел dsegattr;

    symbol_debug(s);

version (SCPP)
    debug assert(memcmp(s.Sident.ptr,"_ST".ptr,3) == 0);

    // Determine if constructor or destructor
    // _STI... is a constructor, _STD... is a destructor
    цел i = !isCtor;
    // Determine if near or far function
    if (tyfarfunc(s.Stype.Tty))
        i += 2;

    // Put out LNAMES record
    objrecord(LNAMES,lnames[i].ptr,lnamesize[i]);

    dsegattr = I32
        ? SEG_ATTR(SEG_ALIGN4,SEG_C_PUBLIC,0,USE32)
        : SEG_ATTR(SEG_ALIGN2,SEG_C_PUBLIC,0,USE16);

    // Put out beginning segment
    objsegdef(dsegattr,0,obj.lnameidx,DATACLASS);
    obj.segidx++;

    // Put out segment definition record
    // size is NPTRSIZE or FPTRSIZE
    objsegdef(dsegattr,(i & 2) + tysize(TYnptr),obj.lnameidx + 1,DATACLASS);
    seg_data *pseg = getsegment();
    pseg.segidx = obj.segidx;
    OmfObj_reftoident(pseg.SDseg,0,s,0,0);     // put out function pointer
    obj.segidx++;

    // Put out ending segment
    objsegdef(dsegattr,0,obj.lnameidx + 2,DATACLASS);
    obj.segidx++;

    obj.lnameidx += 3;                  // for следщ time
}


/***************************************
 * Stuff pointer to function in its own segment.
 * Used for static ctor and dtor lists.
 */

проц OmfObj_ehtables(Symbol *sfunc,бцел size,Symbol *ehsym)
{
    // We need to always put out the segments in triples, so that the
    // linker will put them in the correct order.
    static const сим[12] lnames =
       "\03FIB\02FI\03FIE";             // near constructor
    цел i;
    цел dsegattr;
    targ_т_мера смещение;

    symbol_debug(sfunc);

    if (obj.fisegi == 0)
    {
        // Put out LNAMES record
        objrecord(LNAMES,lnames.ptr,lnames.sizeof - 1);

        dsegattr = I32
            ? SEG_ATTR(SEG_ALIGN4,SEG_C_PUBLIC,0,USE32)
            : SEG_ATTR(SEG_ALIGN2,SEG_C_PUBLIC,0,USE16);

        // Put out beginning segment
        objsegdef(dsegattr,0,obj.lnameidx,DATACLASS);
        obj.lnameidx++;
        obj.segidx++;

        // Put out segment definition record
        obj.fisegi = obj_newfarseg(0,DATACLASS);
        objsegdef(dsegattr,0,obj.lnameidx,DATACLASS);
        SegData[obj.fisegi].attr = dsegattr;
        assert(SegData[obj.fisegi].segidx == obj.segidx);

        // Put out ending segment
        objsegdef(dsegattr,0,obj.lnameidx + 1,DATACLASS);

        obj.lnameidx += 2;              // for следщ time
        obj.segidx += 2;
    }
    смещение = SegData[obj.fisegi].SDoffset;
    смещение += OmfObj_reftoident(obj.fisegi,смещение,sfunc,0,LARGECODE ? CFoff | CFseg : CFoff);   // put out function pointer
    смещение += OmfObj_reftoident(obj.fisegi,смещение,ehsym,0,0);   // pointer to данные
    OmfObj_bytes(obj.fisegi,смещение,_tysize[TYint],&size);          // size of function
    SegData[obj.fisegi].SDoffset = смещение + _tysize[TYint];
}

проц OmfObj_ehsections()
{
    assert(0);
}

/***************************************
 * Append pointer to ModuleInfo to "FM" segment.
 * The FM segment is bracketed by the empty FMB and FME segments.
 */

version (Dinrus)
{

проц OmfObj_moduleinfo(Symbol *scc)
{
    // We need to always put out the segments in triples, so that the
    // linker will put them in the correct order.
    static const сим[12] lnames =
        "\03FMB\02FM\03FME";

    symbol_debug(scc);

    if (obj.fmsegi == 0)
    {
        // Put out LNAMES record
        objrecord(LNAMES,lnames.ptr,lnames.sizeof - 1);

        цел dsegattr = I32
            ? SEG_ATTR(SEG_ALIGN4,SEG_C_PUBLIC,0,USE32)
            : SEG_ATTR(SEG_ALIGN2,SEG_C_PUBLIC,0,USE16);

        // Put out beginning segment
        objsegdef(dsegattr,0,obj.lnameidx,DATACLASS);
        obj.lnameidx++;
        obj.segidx++;

        // Put out segment definition record
        obj.fmsegi = obj_newfarseg(0,DATACLASS);
        objsegdef(dsegattr,0,obj.lnameidx,DATACLASS);
        SegData[obj.fmsegi].attr = dsegattr;
        assert(SegData[obj.fmsegi].segidx == obj.segidx);

        // Put out ending segment
        objsegdef(dsegattr,0,obj.lnameidx + 1,DATACLASS);

        obj.lnameidx += 2;              // for следщ time
        obj.segidx += 2;
    }

    targ_т_мера смещение = SegData[obj.fmsegi].SDoffset;
    смещение += OmfObj_reftoident(obj.fmsegi,смещение,scc,0,LARGECODE ? CFoff | CFseg : CFoff);     // put out function pointer
    SegData[obj.fmsegi].SDoffset = смещение;
}

}


/*********************************
 * Setup for Symbol s to go into a COMDAT segment.
 * Output (if s is a function):
 *      cseg            segment index of new current code segment
 *      Coffset         starting смещение in cseg
 * Возвращает:
 *      "segment index" of COMDAT (which will be a negative значение to
 *      distinguish it from regular segments).
 */

цел OmfObj_comdatsize(Symbol *s, targ_т_мера symsize)
{
    return generate_comdat(s, нет);
}

цел OmfObj_comdat(Symbol *s)
{
    return generate_comdat(s, нет);
}

цел OmfObj_readonly_comdat(Symbol *s)
{
    s.Sseg = generate_comdat(s, да);
    return s.Sseg;
}

static цел generate_comdat(Symbol *s, бул is_readonly_comdat)
{
    сим[IDMAX+IDOHD+1] lnames = проц; // +1 to allow room for strcpy() terminating 0
    сим[2+2] cextdef = проц;
    сим *p;
    т_мера lnamesize;
    бцел ti;
    цел isfunc;
    tym_t ty;

    symbol_debug(s);
    obj.reset_symbuf.пиши((&s)[0 .. 1]);
    ty = s.ty();
    isfunc = tyfunc(ty) != 0 || is_readonly_comdat;

    // Put out LNAME for имя of Symbol
    lnamesize = OmfObj_mangle(s,lnames.ptr);
    objrecord((s.Sclass == SCstatic ? LLNAMES : LNAMES),lnames.ptr,cast(бцел)lnamesize);

    // Put out CEXTDEF for имя of Symbol
    outextdata();
    p = cextdef.ptr;
    p += insidx(p,obj.lnameidx++);
    ti = (config.fulltypes == CVOLD) ? cv_typidx(s.Stype) : 0;
    p += instypidx(p,ti);
    objrecord(CEXTDEF,cextdef.ptr,cast(бцел)(p - cextdef.ptr));
    s.Sxtrnnum = ++obj.extidx;

    seg_data *pseg = getsegment();
    pseg.segidx = -obj.extidx;
    assert(pseg.SDseg > 0);

    // Start new LEDATA record for this COMDAT
    Ledatarec *lr = ledata_new(pseg.SDseg,0);
    lr.typidx = ti;
    lr.pubnamidx = obj.lnameidx - 1;
    if (isfunc)
    {   lr.pubbase = SegData[cseg].segidx;
        if (s.Sclass == SCcomdat || s.Sclass == SCinline)
            lr.alloctyp = 0x10 | 0x00; // pick any instance | explicit allocation
        if (is_readonly_comdat)
        {
            assert(lr.lseg > 0 && lr.lseg <= seg_count);
            lr.flags |= 0x08;      // данные in code seg
        }
        else
        {
            cseg = lr.lseg;
            assert(cseg > 0 && cseg <= seg_count);
            obj.pubnamidx = obj.lnameidx - 1;
            Offset(cseg) = 0;
            if (tyfarfunc(ty) && strcmp(s.Sident.ptr,"main") == 0)
                lr.alloctyp |= 1;  // because MS does for unknown reasons
        }
    }
    else
    {
        ббайт atyp;

        switch (ty & mTYLINK)
        {
            case 0:
            case mTYnear:       lr.pubbase = DATA;
static if (0)
                                atyp = 0;       // only one instance is allowed
else
                                atyp = 0x10;    // pick any (also means it is
                                                // not searched for in a library)

                                break;

            case mTYcs:         lr.flags |= 0x08;      // данные in code seg
                                atyp = 0x11;    break;

            case mTYfar:        atyp = 0x12;    break;

            case mTYthread:     lr.pubbase = OmfObj_tlsseg().segidx;
                                atyp = 0x10;    // pick any (also means it is
                                                // not searched for in a library)
                                break;

            default:            assert(0);
        }
        lr.alloctyp = atyp;
    }
    if (s.Sclass == SCstatic)
        lr.flags |= 0x04;      // local bit (make it an "LCOMDAT")
    s.Soffset = 0;
    s.Sseg = pseg.SDseg;
    return pseg.SDseg;
}

/***********************************
 * Возвращает:
 *      jump table segment for function s
 */
цел OmfObj_jmpTableSegment(Symbol *s)
{
    return (config.flags & CFGromable) ? cseg : DATA;
}

/**********************************
 * Reset code seg to existing seg.
 * Used after a COMDAT for a function is done.
 */

проц OmfObj_setcodeseg(цел seg)
{
    assert(0 < seg && seg <= seg_count);
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
 *      Coffset         starting смещение in cseg
 * Возвращает:
 *      segment index of newly created code segment
 */

цел OmfObj_codeseg(сим *имя,цел suffix)
{
    if (!имя)
    {
        if (cseg != CODE)
        {
            cseg = CODE;
        }
        return cseg;
    }

    // Put out LNAMES record
    т_мера lnamesize = strlen(имя) + suffix * 5;
    сим *lnames = cast(сим *) alloca(1 + lnamesize + 1);
    lnames[0] = cast(сим)lnamesize;
    assert(lnamesize <= (255 - 2 - цел.sizeof*3));
    strcpy(lnames + 1,имя);
    if (suffix)
        strcat(lnames + 1,"_TEXT");
    objrecord(LNAMES,lnames,cast(бцел)(lnamesize + 1));

    cseg = obj_newfarseg(0,4);
    SegData[cseg].attr = obj.csegattr;
    SegData[cseg].segidx = obj.segidx;
    assert(cseg > 0);
    obj.segidx++;
    Offset(cseg) = 0;

    objsegdef(obj.csegattr,0,obj.lnameidx++,4);

    return cseg;
}

/*********************************
 * Define segment for Thread Local Storage.
 * Output:
 *      tlsseg  set to segment number for TLS segment.
 * Возвращает:
 *      segment for TLS segment
 */

seg_data* OmfObj_tlsseg_bss() { return OmfObj_tlsseg(); }

seg_data* OmfObj_tlsseg()
{
    //static сим tlssegname[] = "\04$TLS\04$TLS";
    //static сим tlssegname[] = "\05.tls$\03tls";
    static const сим[25] tlssegname = "\05.tls$\03tls\04.tls\010.tls$ZZZ";

    assert(tlssegname[tlssegname.length - 5] == '$');

    if (obj.tlssegi == 0)
    {
        цел segattr;

        objrecord(LNAMES,tlssegname.ptr,tlssegname.sizeof - 1);

version (Dinrus)
        segattr = SEG_ATTR(SEG_ALIGN16,SEG_C_PUBLIC,0,USE32);
else
        segattr = I32
            ? SEG_ATTR(SEG_ALIGN4,SEG_C_PUBLIC,0,USE32)
            : SEG_ATTR(SEG_ALIGN2,SEG_C_PUBLIC,0,USE16);


        // Put out beginning segment (.tls)
        objsegdef(segattr,0,obj.lnameidx + 2,obj.lnameidx + 1);
        obj.segidx++;

        // Put out .tls$ segment definition record
        obj.tlssegi = obj_newfarseg(0,obj.lnameidx + 1);
        objsegdef(segattr,0,obj.lnameidx,obj.lnameidx + 1);
        SegData[obj.tlssegi].attr = segattr;
        SegData[obj.tlssegi].segidx = obj.segidx;

        // Put out ending segment (.tls$ZZZ)
        objsegdef(segattr,0,obj.lnameidx + 3,obj.lnameidx + 1);

        obj.lnameidx += 4;
        obj.segidx += 2;
    }
    return SegData[obj.tlssegi];
}

seg_data *OmfObj_tlsseg_data()
{
    // specific for Mach-O
    assert(0);
}

/********************************
 * Define a far данные segment.
 * Input:
 *      имя    Name of module
 *      size    Size of the segment to be created
 * Возвращает:
 *      segment index of far данные segment created
 *      *poffset start of the данные for the far данные segment
 */

цел OmfObj_fardata(сим *имя,targ_т_мера size,targ_т_мера *poffset)
{
    static const сим[10] fardataclass = "\010FAR_DATA";
    цел len;
    цел i;
    сим *буфер;

    // See if we can use existing far segment, and just bump its size
    i = obj.lastfardatasegi;
    if (i != -1
        && (_tysize[TYint] != 2 || cast(бцел) SegData[i].SDoffset + size < 0x8000)
        )
    {   *poffset = SegData[i].SDoffset;        // BUG: should align this
        SegData[i].SDoffset += size;
        return i;
    }

    // No. We need to build a new far segment

    if (obj.fardataidx == 0)            // if haven't put out far данные lname
    {   // Put out class lname
        objrecord(LNAMES,fardataclass.ptr,fardataclass.sizeof - 1);
        obj.fardataidx = obj.lnameidx++;
    }

    // Generate имя based on module имя
    имя = strupr(filespecgetroot(filespecname(obj.modname)));

    // Generate имя for this far segment
    len = 1 + cast(цел)strlen(имя) + 3 + 5 + 1;
    буфер = cast(сим *)alloca(len);
    sprintf(буфер + 1,"%s%d_DATA",имя,obj.segidx);
    len = cast(цел)strlen(буфер + 1);
    буфер[0] = cast(сим)len;
    assert(len <= 255);
    objrecord(LNAMES,буфер,len + 1);

    mem_free(имя);

    // Construct a new SegData[] entry
    obj.lastfardatasegi = obj_newfarseg(size,obj.fardataidx);

    // Generate segment definition
    objsegdef(obj.fdsegattr,size,obj.lnameidx++,obj.fardataidx);
    obj.segidx++;

    *poffset = 0;
    return SegData[obj.lastfardatasegi].SDseg;
}

/************************************
 * Remember where we put a far segment so we can adjust
 * its size later.
 * Input:
 *      obj.segidx
 *      lnameidx
 * Возвращает:
 *      index of SegData[]
 */

private цел obj_newfarseg(targ_т_мера size,цел classidx)
{
    seg_data *f = getsegment();
    f.isfarseg = да;
    f.seek = cast(цел)obj.буф.size();
    f.attr = obj.fdsegattr;
    f.origsize = size;
    f.SDoffset = size;
    f.segidx = obj.segidx;
    f.lnameidx = obj.lnameidx;
    f.classidx = classidx;
    return f.SDseg;
}

/******************************
 * Convert reference to imported имя.
 */

проц OmfObj_import(elem *e)
{
version (Dinrus)
    assert(0);
else
{
    Symbol *s;
    Symbol *simp;

    elem_debug(e);
    if ((e.Eoper == OPvar || e.Eoper == OPrelconst) &&
        (s = e.EV.Vsym).ty() & mTYimport &&
        (s.Sclass == SCextern || s.Sclass == SCinline)
       )
    {
        ткст0 имя;
        ткст0 p;
        т_мера len;
        сим[IDMAX + IDOHD + 1] буфер = проц;

        // Create import имя
        len = OmfObj_mangle(s,буфер.ptr);
        if (буфер[0] == cast(сим)0xFF && буфер[1] == 0)
        {   имя = буфер.ptr + 4;
            len -= 4;
        }
        else
        {   имя = буфер.ptr + 1;
            len -= 1;
        }
        if (config.flags4 & CFG4underscore)
        {   p = cast(сим *) alloca(5 + len + 1);
            memcpy(p,"_imp_".ptr,5);
            memcpy(p + 5,имя,len);
            p[5 + len] = 0;
        }
        else
        {   p = cast(сим *) alloca(6 + len + 1);
            memcpy(p,"__imp_".ptr,6);
            memcpy(p + 6,имя,len);
            p[6 + len] = 0;
        }
        simp = scope_search(p,SCTglobal);
        if (!simp)
        {   тип *t;

            simp = scope_define(p,SCTglobal,SCextern);
            simp.Ssequence = 0;
            simp.Sfl = FLextern;
            simp.Simport = s;
            t = newpointer(s.Stype);
            t.Tmangle = mTYman_c;
            t.Tcount++;
            simp.Stype = t;
        }
        assert(!e.EV.Voffset);
        if (e.Eoper == OPrelconst)
        {
            e.Eoper = OPvar;
            e.EV.Vsym = simp;
        }
        else // OPvar
        {
            e.Eoper = OPind;
            e.EV.E1 = el_var(simp);
            e.EV.E2 = null;
        }
    }
}
}

/*******************************
 * Mangle a имя.
 * Возвращает:
 *      length of mangled имя
 */

т_мера OmfObj_mangle(Symbol *s,сим *dest)
{   т_мера len;
    т_мера ilen;
    ткст0 имя;
    сим *name2 = null;

    //printf("OmfObj_mangle('%s'), mangle = x%x\n",s.Sident.ptr,type_mangle(s.Stype));
version (SCPP)
    имя = CPP ? cpp_mangle(s) : s.Sident.ptr;
else version (Dinrus)
    имя = cast(сим*)cpp_mangle(s);
else
    static assert(0);

    len = strlen(имя);                 // # of bytes in имя

    // Use as max length the max length lib.exe can handle
    // Use 5 as length of _ + @nnn
//    const LIBIDMAX = ((512 - 0x25 - 3 - 4) - 5);
    const LIBIDMAX = 128;
    if (len > LIBIDMAX)
    //if (len > IDMAX)
    {
        т_мера len2;

        // Attempt to compress the имя
        name2 = id_compress(имя, cast(цел)len, &len2);
version (Dinrus)
{
        if (len2 > LIBIDMAX)            // still too long
        {
            /* Form md5 digest of the имя and store it in the
             * last 32 bytes of the имя.
             */
            MD5_CTX mdContext;
            MD5Init(&mdContext);
            MD5Update(&mdContext, cast(ббайт *)имя, cast(бцел)len);
            MD5Final(&mdContext);
            memcpy(name2, имя, LIBIDMAX - 32);
            for (цел i = 0; i < 16; i++)
            {   ббайт c = mdContext.digest[i];
                ббайт c1 = (c >> 4) & 0x0F;
                ббайт c2 = c & 0x0F;
                c1 += (c1 < 10) ? '0' : 'A' - 10;
                name2[LIBIDMAX - 32 + i * 2] = c1;
                c2 += (c2 < 10) ? '0' : 'A' - 10;
                name2[LIBIDMAX - 32 + i * 2 + 1] = c2;
            }
            len = LIBIDMAX;
            name2[len] = 0;
            имя = name2;
            //printf("имя = '%s', len = %d, strlen = %d\n", имя, len, strlen(имя));
        }
        else
        {
            имя = name2;
            len = len2;
        }
}
else
{
        if (len2 > IDMAX)               // still too long
        {
version (SCPP)
            synerr(EM_identifier_too_long, имя, len - IDMAX, IDMAX);
else version (Dinrus)
{
//          выведиОшибку(Место(), "идентификатор %s is too long by %d characters", имя, len - IDMAX);
}
else
            assert(0);

            len = IDMAX;
        }
        else
        {
            имя = name2;
            len = len2;
        }
}
    }
    ilen = len;
    if (ilen > (255-2-цел.sizeof*3))
        dest += 3;
    switch (type_mangle(s.Stype))
    {
        case mTYman_pas:                // if upper case
        case mTYman_for:
            memcpy(dest + 1,имя,len);  // копируй in имя
            dest[1 + len] = 0;
            strupr(dest + 1);           // to upper case
            break;

        case mTYman_cpp:
            memcpy(dest + 1,имя,len);
            break;

        case mTYman_std:
            if (!(config.flags4 & CFG4oldstdmangle) &&
                config.exe == EX_WIN32 && tyfunc(s.ty()) &&
                !variadic(s.Stype))
            {
                dest[1] = '_';
                memcpy(dest + 2,имя,len);
                dest[1 + 1 + len] = '@';
                itoa(type_paramsize(s.Stype),dest + 3 + len,10);
                len = strlen(dest + 1);
                assert(isdigit(dest[len]));
                break;
            }
            goto case;

        case mTYman_c:
        case mTYman_d:
            if (config.flags4 & CFG4underscore)
            {
                dest[1] = '_';          // leading _ in имя
                memcpy(&dest[2],имя,len);      // копируй in имя
                len++;
                break;
            }
            goto case;

        case mTYman_sys:
            memcpy(dest + 1, имя, len);        // no mangling
            dest[1 + len] = 0;
            break;
        default:
            symbol_print(s);
            assert(0);
    }
    if (ilen > (255-2-цел.sizeof*3))
    {
        dest -= 3;
        dest[0] = 0xFF;
        dest[1] = 0;
        debug
        assert(len <= 0xFFFF);

        TOWORD(dest + 2,cast(бцел)len);
        len += 4;
    }
    else
    {
        *dest = cast(сим)len;
        len++;
    }
    if (name2)
        free(name2);
    assert(len <= IDMAX + IDOHD);
    return len;
}

/*******************************
 * Export a function имя.
 */

проц OmfObj_export_symbol(Symbol* s, бцел argsize)
{
    ткст0 coment;
    т_мера len;

    coment = cast(сим *) alloca(4 + 1 + (IDMAX + IDOHD) + 1); // allow extra byte for mangling
    len = OmfObj_mangle(s,&coment[4]);
    assert(len <= IDMAX + IDOHD);
    coment[1] = 0xA0;                           // коммент class
    coment[2] = 2;                              // why??? who knows
    if (argsize >= 64)                          // we only have a 5 bit field
        argsize = 0;                            // hope we don't need callgate
    coment[3] = cast(сим)((argsize + 1) >> 1); // # words on stack
    coment[4 + len] = 0;                        // no internal имя
    objrecord(COMENT,coment,cast(бцел)(4 + len + 1));       // module имя record
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

цел OmfObj_data_start(Symbol *sdata, targ_т_мера datasize, цел seg)
{
    targ_т_мера alignbytes;
    //printf("OmfObj_data_start(%s,size %llx,seg %d)\n",sdata.Sident.ptr,datasize,seg);
    //symbol_print(sdata);

    if (sdata.Sseg == UNKNOWN) // if we don't know then there
        sdata.Sseg = seg;      // wasn't any segment override
    else
        seg = sdata.Sseg;
    targ_т_мера смещение = SegData[seg].SDoffset;
    if (sdata.Salignment > 0)
    {
        if (SegData[seg].SDalignment < sdata.Salignment)
            SegData[seg].SDalignment = sdata.Salignment;
        alignbytes = ((смещение + sdata.Salignment - 1) & ~(sdata.Salignment - 1)) - смещение;
    }
    else
        alignbytes = _align(datasize, смещение) - смещение;
    sdata.Soffset = смещение + alignbytes;
    SegData[seg].SDoffset = sdata.Soffset;
    return seg;
}

проц OmfObj_func_start(Symbol *sfunc)
{
    //printf("OmfObj_func_start(%s)\n",sfunc.Sident.ptr);
    symbol_debug(sfunc);
    sfunc.Sseg = cseg;             // current code seg
    sfunc.Soffset = Offset(cseg);       // смещение of start of function

version (Dinrus)
    varStats_startFunction();
}

/*******************************
 * Update function info after codgen
 */

проц OmfObj_func_term(Symbol *sfunc)
{
}

/********************************
 * Output a public definition.
 * Input:
 *      seg =           segment index that symbol is defined in
 *      s .            symbol
 *      смещение =        смещение of имя
 */

private проц outpubdata()
{
    if (obj.pubdatai)
    {
        objrecord(obj.mpubdef,obj.pubdata.ptr,obj.pubdatai);
        obj.pubdatai = 0;
    }
}

проц OmfObj_pubdef(цел seg,Symbol *s,targ_т_мера смещение)
{
    бцел reclen, len;
    ткст0 p;
    бцел ti;

    assert(смещение < 100000000);
    obj.reset_symbuf.пиши((&s)[0 .. 1]);

    цел idx = SegData[seg].segidx;
    if (obj.pubdatai + 1 + (IDMAX + IDOHD) + 4 + 2 > obj.pubdata.sizeof ||
        idx != getindex(cast(ббайт*)obj.pubdata.ptr + 1))
        outpubdata();
    if (obj.pubdatai == 0)
    {
        obj.pubdata[0] = (seg == DATA || seg == CDATA || seg == UDATA) ? 1 : 0; // group index
        obj.pubdatai += 1 + insidx(obj.pubdata.ptr + 1,idx);        // segment index
    }
    p = &obj.pubdata[obj.pubdatai];
    len = cast(бцел)OmfObj_mangle(s,p);              // mangle in имя
    reclen = len + _tysize[TYint];
    p += len;
    TOOFFSET(p,смещение);
    p += _tysize[TYint];
    ti = (config.fulltypes == CVOLD) ? cv_typidx(s.Stype) : 0;
    reclen += instypidx(p,ti);
    obj.pubdatai += reclen;
}

проц OmfObj_pubdefsize(цел seg, Symbol *s, targ_т_мера смещение, targ_т_мера symsize)
{
    OmfObj_pubdef(seg, s, смещение);
}

/*******************************
 * Output an external definition.
 * Input:
 *      имя . external идентификатор
 * Возвращает:
 *      External index of the definition (1,2,...)
 */

private проц outextdata()
{
    if (obj.extdatai)
    {
        objrecord(EXTDEF, obj.extdata.ptr, obj.extdatai);
        obj.extdatai = 0;
    }
}

цел OmfObj_external_def(ткст0 имя)
{
    бцел len;
    сим *e;

    //printf("OmfObj_external_def('%s', %d)\n",имя,obj.extidx + 1);
    assert(имя);
    len = cast(бцел)strlen(имя);                 // length of идентификатор
    if (obj.extdatai + len + ONS_OHD + 1 > obj.extdata.sizeof)
        outextdata();

    e = &obj.extdata[obj.extdatai];
    len = obj_namestring(e,имя);
    e[len] = 0;                         // typidx = 0
    obj.extdatai += len + 1;
    assert(obj.extdatai <= obj.extdata.sizeof);
    return ++obj.extidx;
}

/*******************************
 * Output an external definition.
 * Input:
 *      s       Symbol to do EXTDEF on
 * Возвращает:
 *      External index of the definition (1,2,...)
 */

цел OmfObj_external(Symbol *s)
{
    //printf("OmfObj_external('%s', %d)\n",s.Sident.ptr, obj.extidx + 1);
    symbol_debug(s);
    obj.reset_symbuf.пиши((&s)[0 .. 1]);
    if (obj.extdatai + (IDMAX + IDOHD) + 3 > obj.extdata.sizeof)
        outextdata();

    сим *e = &obj.extdata[obj.extdatai];
    бцел len = cast(бцел)OmfObj_mangle(s,e);
    e[len] = 0;                 // typidx = 0
    obj.extdatai += len + 1;
    s.Sxtrnnum = ++obj.extidx;
    return obj.extidx;
}

/*******************************
 * Output a common block definition.
 * Input:
 *      p .    external идентификатор
 *      флаг    TRUE:   in default данные segment
 *              FALSE:  not in default данные segment
 *      size    size in bytes of each elem
 *      count   number of elems
 * Возвращает:
 *      External index of the definition (1,2,...)
 */

// Helper for OmfObj_common_block()

static бцел storelength(бцел length,бцел i)
{
    obj.extdata[i] = cast(сим)length;
    if (length >= 128)  // Microsoft docs say 129, but their linker
                        // won't take >=128, so accommodate it
    {   obj.extdata[i] = 129;
        debug
        assert(length <= 0xFFFF);

        TOWORD(obj.extdata.ptr + i + 1,length);
        if (length >= 0x10000)
        {   obj.extdata[i] = 132;
            obj.extdata[i + 3] = cast(сим)(length >> 16);

            // Only 386 can generate lengths this big
            if (I32 && length >= 0x1000000)
            {   obj.extdata[i] = 136;
                obj.extdata[i + 4] = length >> 24;
                i += 4;
            }
            else
                i += 3;
        }
        else
            i += 2;
    }
    return i + 1;               // index past where we stuffed length
}

цел OmfObj_common_block(Symbol *s,targ_т_мера size,targ_т_мера count)
{
    return OmfObj_common_block(s, 0, size, count);
}

цел OmfObj_common_block(Symbol *s,цел флаг,targ_т_мера size,targ_т_мера count)
{
  бцел i;
  бцел length;
  бцел ti;

    //printf("OmfObj_common_block('%s',%d,%d,%d, %d)\n",s.Sident.ptr,флаг,size,count, obj.extidx + 1);
    obj.reset_symbuf.пиши((&s)[0 .. 1]);
    outextdata();               // borrow the extdata[] storage
    i = cast(бцел)OmfObj_mangle(s,obj.extdata.ptr);

    ti = (config.fulltypes == CVOLD) ? cv_typidx(s.Stype) : 0;
    i += instypidx(obj.extdata.ptr + i,ti);

  if (флаг)                             // if in default данные segment
  {
        //printf("NEAR comdef\n");
        obj.extdata[i] = 0x62;
        length = cast(бцел) size * cast(бцел) count;
        assert(I32 || length <= 0x10000);
        i = storelength(length,i + 1);
  }
  else
  {
        //printf("FAR comdef\n");
        obj.extdata[i] = 0x61;
        i = storelength(cast(бцел) size,i + 1);
        i = storelength(cast(бцел) count,i);
  }
  assert(i <= obj.extdata.length);
  objrecord(COMDEF,obj.extdata.ptr,i);
  return ++obj.extidx;
}

/***************************************
 * Append an iterated данные block of 0s.
 * (uninitialized данные only)
 */

проц OmfObj_write_zeros(seg_data *pseg, targ_т_мера count)
{
    OmfObj_lidata(pseg.SDseg, pseg.SDoffset, count);
    //pseg.SDoffset += count;
}

/***************************************
 * Output an iterated данные block of 0s.
 * (uninitialized данные only)
 */

проц OmfObj_lidata(цел seg,targ_т_мера смещение,targ_т_мера count)
{   цел i;
    бцел reclen;
    static const сим[20] нуль = 0;
    сим[20] данные = проц;
    сим *di;

    //printf("OmfObj_lidata(seg = %d, смещение = x%x, count = %d)\n", seg, смещение, count);

    SegData[seg].SDoffset += count;

    if (seg == UDATA)
        return;
    цел idx = SegData[seg].segidx;

Lagain:
    if (count <= нуль.sizeof)          // if shorter to use ledata
    {
        OmfObj_bytes(seg,смещение,cast(бцел)count,cast(сим*)нуль.ptr);
        return;
    }

    if (seg_is_comdat(idx))
    {
        while (count > нуль.sizeof)
        {
            OmfObj_bytes(seg,смещение,нуль.sizeof,cast(сим*)нуль.ptr);
            смещение += нуль.sizeof;
            count -= нуль.sizeof;
        }
        OmfObj_bytes(seg,смещение,cast(бцел)count,cast(сим*)нуль.ptr);
        return;
    }

    i = insidx(данные.ptr,idx);
    di = данные.ptr + i;
    TOOFFSET(di,смещение);

    if (config.flags & CFGeasyomf)
    {
        if (count >= 0x8000)            // repeat count can only go to 32k
        {
            TOWORD(di + 4,cast(ushort)(count / 0x8000));
            TOWORD(di + 4 + 2,1);               // 1 данные block follows
            TOWORD(di + 4 + 2 + 2,0x8000);      // repeat count
            TOWORD(di + 4 + 2 + 2 + 2,0);       // block count
            TOWORD(di + 4 + 2 + 2 + 2 + 2,1);   // 1 byte of 0
            reclen = i + 4 + 5 * 2;
            objrecord(obj.mlidata,данные.ptr,reclen);

            смещение += (count & ~cast(targ_т_мера)0x7FFF);
            count &= 0x7FFF;
            goto Lagain;
        }
        else
        {
            TOWORD(di + 4,cast(ushort)count);       // repeat count
            TOWORD(di + 4 + 2,0);                       // block count
            TOWORD(di + 4 + 2 + 2,1);                   // 1 byte of 0
            reclen = i + 4 + 2 + 2 + 2;
            objrecord(obj.mlidata,данные.ptr,reclen);
        }
    }
    else
    {
        TOOFFSET(di + _tysize[TYint],count);
        TOWORD(di + _tysize[TYint] * 2,0);     // block count
        TOWORD(di + _tysize[TYint] * 2 + 2,1); // repeat 1 byte of 0s
        reclen = i + (I32 ? 12 : 8);
        objrecord(obj.mlidata,данные.ptr,reclen);
    }
    assert(reclen <= данные.sizeof);
}

/****************************
 * Output a MODEND record.
 */

private проц obj_modend()
{
    if (obj.startaddress)
    {   сим[10] mdata = проц;
        цел i;
        бцел framedatum,targetdatum;
        ббайт fd;
        targ_т_мера смещение;
        цел external;           // !=0 if идентификатор is defined externally
        tym_t ty;
        Symbol *s = obj.startaddress;

        // Turn startaddress into a fixup.
        // Borrow heavilly from OmfObj_reftoident()

        obj.reset_symbuf.пиши((&s)[0 .. 1]);
        symbol_debug(s);
        смещение = 0;
        ty = s.ty();

        switch (s.Sclass)
        {
            case SCcomdat:
            case_SCcomdat:
            case SCextern:
            case SCcomdef:
                if (s.Sxtrnnum)                // идентификатор is defined somewhere else
                    external = s.Sxtrnnum;
                else
                {
                 Ladd:
                    s.Sclass = SCextern;
                    external = objmod.external(s);
                    outextdata();
                }
                break;
            case SCinline:
                if (config.flags2 & CFG2comdat)
                    goto case_SCcomdat; // treat as initialized common block
                goto case;

            case SCsinline:
            case SCstatic:
            case SCglobal:
                if (s.Sseg == UNKNOWN)
                    goto Ladd;
                if (seg_is_comdat(SegData[s.Sseg].segidx))   // if in comdat
                    goto case_SCcomdat;
                goto case;

            case SClocstat:
                external = 0;           // идентификатор is static or глоб2
                                            // and we know its смещение
                смещение += s.Soffset;
                break;
            default:
                //symbol_print(s);
                assert(0);
        }

        if (external)
        {   fd = FD_T2;
            targetdatum = external;
            switch (s.Sfl)
            {
                case FLextern:
                    if (!(ty & (mTYcs | mTYthread)))
                        goto L1;
                    goto case;

                case FLfunc:
                case FLfardata:
                case FLcsdata:
                case FLtlsdata:
                    if (config.exe & EX_flat)
                    {   fd |= FD_F1;
                        framedatum = 1;
                    }
                    else
                    {
                //case FLtlsdata:
                        fd |= FD_F2;
                        framedatum = targetdatum;
                    }
                    break;
                default:
                    goto L1;
            }
        }
        else
        {
            fd = FD_T0;                 // target is always a segment
            targetdatum = SegData[s.Sseg].segidx;
            assert(targetdatum != -1);
            switch (s.Sfl)
            {
                case FLextern:
                    if (!(ty & (mTYcs | mTYthread)))
                        goto L1;
                    goto case;

                case FLfunc:
                case FLfardata:
                case FLcsdata:
                case FLtlsdata:
                    if (config.exe & EX_flat)
                    {   fd |= FD_F1;
                        framedatum = 1;
                    }
                    else
                    {
                //case FLtlsdata:
                        fd |= FD_F0;
                        framedatum = targetdatum;
                    }
                    break;
                default:
                L1:
                    fd |= FD_F1;
                    framedatum = DGROUPIDX;
                    //if (flags == CFseg)
                    {   fd = FD_F1 | FD_T1;     // target is DGROUP
                        targetdatum = DGROUPIDX;
                    }
                    break;
            }
        }

        // Write the fixup into mdata[]
        mdata[0] = 0xC1;
        mdata[1] = fd;
        i = 2 + insidx(&mdata[2],framedatum);
        i += insidx(&mdata[i],targetdatum);
        TOOFFSET(mdata.ptr + i,смещение);

        objrecord(obj.mmodend,mdata.ptr,i + _tysize[TYint]);       // пиши mdata[] to .OBJ файл
    }
    else
    {   static const сим[1] modend = [0];

        objrecord(obj.mmodend,modend.ptr,modend.sizeof);
    }
}

/****************************
 * Output the fixups in list fl.
 */

private проц objfixupp(FIXUP *f)
{
  бцел i,j,k;
  targ_т_мера locat;
  FIXUP *fn;

static if (1)   // store in one record
{
  сим[1024] данные = проц;

  i = 0;
  for (; f; f = fn)
  {     ббайт fd;

        if (i >= данные.sizeof - (3 + 2 + 2))    // if not enough room
        {   objrecord(obj.mfixupp,данные.ptr,i);
            i = 0;
        }

        //printf("f = %p, смещение = x%x\n",f,f.FUoffset);
        assert(f.FUoffset < 1024);
        locat = (f.FUlcfd & 0xFF00) | f.FUoffset;
        данные[i+0] = cast(сим)(locat >> 8);
        данные[i+1] = cast(сим)locat;
        данные[i+2] = fd = cast(ббайт)f.FUlcfd;
        k = i;
        i += 3 + insidx(&данные[i+3],f.FUframedatum);
        //printf("FUframedatum = x%x\n", f.FUframedatum);
        if ((fd >> 4) == (fd & 3) && f.FUframedatum == f.FUtargetdatum)
        {
            данные[k + 2] = (fd & 15) | FD_F5;
        }
        else
        {   i += insidx(&данные[i],f.FUtargetdatum);
            //printf("FUtargetdatum = x%x\n", f.FUtargetdatum);
        }
        //printf("[%d]: %02x %02x %02x\n", k, данные[k + 0] & 0xFF, данные[k + 1] & 0xFF, данные[k + 2] & 0xFF);
        fn = f.FUnext;
        mem_ffree(f);
  }
  assert(i <= данные.sizeof);
  if (i)
      objrecord(obj.mfixupp,данные.ptr,i);
}
else   // store in multiple records
{
  for (; fl; fl = list_next(fl))
  {
        сим[7] данные = проц;

        assert(f.FUoffset < 1024);
        locat = (f.FUlcfd & 0xFF00) | f.FUoffset;
        данные[0] = locat >> 8;
        данные[1] = locat;
        данные[2] = f.FUlcfd;
        i = 3 + insidx(&данные[3],f.FUframedatum);
        i += insidx(&данные[i],f.FUtargetdatum);
        objrecord(obj.mfixupp,данные,i);
  }
}
}


/***************************
 * Add a new fixup to the fixup list.
 * Write things out if we overflow the list.
 */

private проц addfixup(Ledatarec *lr, targ_т_мера смещение,бцел lcfd,
        бцел framedatum,бцел targetdatum)
{   FIXUP *f;

    assert(смещение < 0x1024);
debug
{
    assert(targetdatum <= 0x7FFF);
    assert(framedatum <= 0x7FFF);
}
    f = cast(FIXUP *) mem_fmalloc(FIXUP.sizeof);
    //printf("f = %p, смещение = x%x\n",f,смещение);
    f.FUoffset = смещение;
    f.FUlcfd = cast(ushort)lcfd;
    f.FUframedatum = cast(ushort)framedatum;
    f.FUtargetdatum = cast(ushort)targetdatum;
    f.FUnext = lr.fixuplist;  // link f into list
    lr.fixuplist = f;
    debug
    obj.fixup_count++;                  // gather statistics
}


/*********************************
 * Open up a new ledata record.
 * Input:
 *      seg     segment number данные is in
 *      смещение  starting смещение of start of данные for this record
 */

private Ledatarec *ledata_new(цел seg,targ_т_мера смещение)
{

    //printf("ledata_new(seg = %d, смещение = x%lx)\n",seg,смещение);
    assert(seg > 0 && seg <= seg_count);

    if (obj.ledatai == obj.ledatamax)
    {
        т_мера o = obj.ledatamax;
        obj.ledatamax = o * 2 + 100;
        obj.ledatas = cast(Ledatarec **)mem_realloc(obj.ledatas, obj.ledatamax * (Ledatarec *).sizeof);
        memset(obj.ledatas + o, 0, (obj.ledatamax - o) * (Ledatarec *).sizeof);
    }
    Ledatarec *lr = obj.ledatas[obj.ledatai];
    if (!lr)
    {   lr = cast(Ledatarec *) mem_malloc(Ledatarec.sizeof);
        obj.ledatas[obj.ledatai] = lr;
    }
    memset(lr, 0, Ledatarec.sizeof);
    obj.ledatas[obj.ledatai] = lr;
    obj.ledatai++;

    lr.lseg = seg;
    lr.смещение = смещение;

    if (seg_is_comdat(SegData[seg].segidx) && смещение)      // if continuation of an existing COMDAT
    {
        Ledatarec *d = cast(Ledatarec*)SegData[seg].ledata;
        if (d)
        {
            if (d.lseg == seg)                 // found existing COMDAT
            {   lr.flags = d.flags;
                lr.alloctyp = d.alloctyp;
                lr._align = d._align;
                lr.typidx = d.typidx;
                lr.pubbase = d.pubbase;
                lr.pubnamidx = d.pubnamidx;
            }
        }
    }
    SegData[seg].ledata = lr;
    return lr;
}

/***********************************
 * Append byte to segment.
 */

проц OmfObj_write_byte(seg_data *pseg, бцел _byte)
{
    OmfObj_byte(pseg.SDseg, pseg.SDoffset, _byte);
    pseg.SDoffset++;
}

/************************************
 * Output byte to объект файл.
 */

проц OmfObj_byte(цел seg,targ_т_мера смещение,бцел _byte)
{
    Ledatarec *lr = cast(Ledatarec*)SegData[seg].ledata;
    if (!lr)
        goto L2;

    if (
         lr.i > LEDATAMAX - 1 ||       // if it'll overflow
         смещение < lr.смещение || // underflow
         смещение > lr.смещение + lr.i
     )
    {
        // Try to найди an existing ledata
        for (т_мера i = obj.ledatai; i; )
        {   Ledatarec *d = obj.ledatas[--i];
            if (seg == d.lseg &&       // segments match
                смещение >= d.смещение &&
                смещение + 1 <= d.смещение + LEDATAMAX &&
                смещение <= d.смещение + d.i
               )
            {
                lr = d;
                SegData[seg].ledata = cast(ук)d;
                goto L1;
            }
        }
L2:
        lr = ledata_new(seg,смещение);
L1:     { }
    }

    бцел i = cast(бцел)(смещение - lr.смещение);
    if (lr.i <= i)
        lr.i = i + 1;
    lr.данные[i] = cast(ббайт)_byte;           // 1st byte of данные
}

/***********************************
 * Append bytes to segment.
 */

проц OmfObj_write_bytes(seg_data *pseg, бцел члобайт, проц *p)
{
    OmfObj_bytes(pseg.SDseg, pseg.SDoffset, члобайт, p);
    pseg.SDoffset += члобайт;
}

/************************************
 * Output bytes to объект файл.
 * Возвращает:
 *      члобайт
 */

бцел OmfObj_bytes(цел seg, targ_т_мера смещение, бцел члобайт, ук p)
{
    бцел n = члобайт;

    //dbg_printf("OmfObj_bytes(seg=%d, смещение=x%lx, члобайт=x%x, p=%p)\n",seg,смещение,члобайт,p);
    Ledatarec *lr = cast(Ledatarec*)SegData[seg].ledata;
    if (!lr)
        lr = ledata_new(seg, смещение);
 L1:
    if (
         lr.i + члобайт > LEDATAMAX ||  // or it'll overflow
         смещение < lr.смещение ||         // underflow
         смещение > lr.смещение + lr.i
     )
    {
        while (члобайт)
        {
            OmfObj_byte(seg, смещение, *cast(сим*)p);
            смещение++;
            p = (cast(сим *)p) + 1;
            члобайт--;
            lr = cast(Ledatarec*)SegData[seg].ledata;
            if (lr.i + члобайт <= LEDATAMAX)
                goto L1;
        }
    }
    else
    {
        бцел i = cast(бцел)(смещение - lr.смещение);
        if (lr.i < i + члобайт)
            lr.i = i + члобайт;
        memcpy(lr.данные.ptr + i,p,члобайт);
    }
    return n;
}

/************************************
 * Output word of данные. (Two words if segment:смещение pair.)
 * Input:
 *      seg     CODE, DATA, CDATA, UDATA
 *      смещение  смещение of start of данные
 *      данные    word of данные
 *      lcfd    LCxxxx | FDxxxx
 *      if (FD_F2 | FD_T6)
 *              idx1 = external Symbol #
 *      else
 *              idx1 = frame datum
 *              idx2 = target datum
 */

проц OmfObj_ledata(цел seg,targ_т_мера смещение,targ_т_мера данные,
        бцел lcfd,бцел idx1,бцел idx2)
{
    бцел size;                      // number of bytes to output

    бцел ptrsize = tysize(TYfptr);

    if ((lcfd & LOCxx) == obj.LOCpointer)
        size = ptrsize;
    else if ((lcfd & LOCxx) == LOCbase)
        size = 2;
    else
        size = tysize(TYnptr);

    Ledatarec *lr = cast(Ledatarec*)SegData[seg].ledata;
    if (!lr)
         lr = ledata_new(seg, смещение);
    assert(seg == lr.lseg);
    if (
         lr.i + size > LEDATAMAX ||    // if it'll overflow
         смещение < lr.смещение || // underflow
         смещение > lr.смещение + lr.i
     )
    {
        // Try to найди an existing ledata
//dbg_printf("seg = %d, смещение = x%lx, size = %d\n",seg,смещение,size);
        for (т_мера i = obj.ledatai; i; )
        {   Ledatarec *d = obj.ledatas[--i];

//dbg_printf("d: seg = %d, смещение = x%lx, i = x%x\n",d.lseg,d.смещение,d.i);
            if (seg == d.lseg &&       // segments match
                смещение >= d.смещение &&
                смещение + size <= d.смещение + LEDATAMAX &&
                смещение <= d.смещение + d.i
               )
            {
//dbg_printf("match\n");
                lr = d;
                SegData[seg].ledata = cast(ук)d;
                goto L1;
            }
        }
        lr = ledata_new(seg,смещение);
L1:     { }
    }

    бцел i = cast(бцел)(смещение - lr.смещение);
    if (lr.i < i + size)
        lr.i = i + size;
    if (size == 2 || !I32)
        TOWORD(lr.данные.ptr + i,cast(бцел)данные);
    else
        TOLONG(lr.данные.ptr + i,cast(бцел)данные);
    if (size == ptrsize)         // if doing a seg:смещение pair
        TOWORD(lr.данные.ptr + i + tysize(TYnptr),0);        // segment portion
    addfixup(lr, смещение - lr.смещение,lcfd,idx1,idx2);
}

/************************************
 * Output long word of данные.
 * Input:
 *      seg     CODE, DATA, CDATA, UDATA
 *      смещение  смещение of start of данные
 *      данные    long word of данные
 *   Present only if size == 2:
 *      lcfd    LCxxxx | FDxxxx
 *      if (FD_F2 | FD_T6)
 *              idx1 = external Symbol #
 *      else
 *              idx1 = frame datum
 *              idx2 = target datum
 */

проц OmfObj_write_long(цел seg,targ_т_мера смещение,бцел данные,
        бцел lcfd,бцел idx1,бцел idx2)
{
    бцел sz = tysize(TYfptr);
    Ledatarec *lr = cast(Ledatarec*)SegData[seg].ledata;
    if (!lr)
         lr = ledata_new(seg, смещение);
    if (
         lr.i + sz > LEDATAMAX || // if it'll overflow
         смещение < lr.смещение || // underflow
         смещение > lr.смещение + lr.i
       )
        lr = ledata_new(seg,смещение);
    бцел i = cast(бцел)(смещение - lr.смещение);
    if (lr.i < i + sz)
        lr.i = i + sz;
    TOLONG(lr.данные.ptr + i,данные);
    if (I32)                              // if 6 byte far pointers
        TOWORD(lr.данные.ptr + i + LONGSIZE,0);              // fill out seg
    addfixup(lr, смещение - lr.смещение,lcfd,idx1,idx2);
}

/*******************************
 * Refer to address that is in the данные segment.
 * Input:
 *      seg =           where the address is going
 *      смещение =        смещение within seg
 *      val =           displacement from address
 *      targetdatum =   DATA, CDATA or UDATA, depending where the address is
 *      flags =         CFoff, CFseg
 * Example:
 *      цел *abc = &def[3];
 *      to размести storage:
 *              OmfObj_reftodatseg(DATA,смещение,3 * (цел *).sizeof,UDATA);
 */

проц OmfObj_reftodatseg(цел seg,targ_т_мера смещение,targ_т_мера val,
        бцел targetdatum,цел flags)
{
    assert(flags);

    if (flags == 0 || flags & CFoff)
    {
        // The frame datum is always 1, which is DGROUP
        OmfObj_ledata(seg,смещение,val,
            LOCATsegrel | obj.LOCoffset | FD_F1 | FD_T4,DGROUPIDX,SegData[targetdatum].segidx);
        смещение += _tysize[TYint];
    }

    if (flags & CFseg)
    {
static if (0)
{
        if (config.wflags & WFdsnedgroup)
            warerr(WM_ds_ne_dgroup);
}
        OmfObj_ledata(seg,смещение,0,
            LOCATsegrel | LOCbase | FD_F1 | FD_T5,DGROUPIDX,DGROUPIDX);
    }
}

/*******************************
 * Refer to address that is in a far segment.
 * Input:
 *      seg =           where the address is going
 *      смещение =        смещение within seg
 *      val =           displacement from address
 *      farseg =        far segment index
 *      flags =         CFoff, CFseg
 */

проц OmfObj_reftofarseg(цел seg,targ_т_мера смещение,targ_т_мера val,
        цел farseg,цел flags)
{
    assert(flags);

    цел idx = SegData[farseg].segidx;
    if (flags == 0 || flags & CFoff)
    {
        OmfObj_ledata(seg,смещение,val,
            LOCATsegrel | obj.LOCoffset | FD_F0 | FD_T4,idx,idx);
        смещение += _tysize[TYint];
    }

    if (flags & CFseg)
    {
        OmfObj_ledata(seg,смещение,0,
            LOCATsegrel | LOCbase | FD_F0 | FD_T4,idx,idx);
    }
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

проц OmfObj_reftocodeseg(цел seg,targ_т_мера смещение,targ_т_мера val)
{
    бцел framedatum;
    бцел lcfd;

    цел idx = SegData[cseg].segidx;
    if (seg_is_comdat(idx))             // if comdat
    {   idx = -idx;
        framedatum = idx;
        lcfd = (LOCATsegrel | obj.LOCoffset) | (FD_F2 | FD_T6);
    }
    else if (config.exe & EX_flat)
    {   framedatum = 1;
        lcfd = (LOCATsegrel | obj.LOCoffset) | (FD_F1 | FD_T4);
    }
    else
    {   framedatum = idx;
        lcfd = (LOCATsegrel | obj.LOCoffset) | (FD_F0 | FD_T4);
    }

    OmfObj_ledata(seg,смещение,val,lcfd,framedatum,idx);
}

/*******************************
 * Refer to an идентификатор.
 * Input:
 *      seg =           where the address is going (CODE or DATA)
 *      смещение =        смещение within seg
 *      s .            Symbol table entry for идентификатор
 *      val =           displacement from идентификатор
 *      flags =         CFselfrel: self-relative
 *                      CFseg: get segment
 *                      CFoff: get смещение
 * Возвращает:
 *      number of bytes in reference (2 or 4)
 * Example:
 *      extern цел def[];
 *      цел *abc = &def[3];
 *      to размести storage:
 *              OmfObj_reftodatseg(DATA,смещение,3 * (цел *).sizeof,UDATA);
 */

цел OmfObj_reftoident(цел seg,targ_т_мера смещение,Symbol *s,targ_т_мера val,
        цел flags)
{
    бцел targetdatum;       // which datum the symbol is in
    бцел framedatum;
    цел     lc;
    цел     external;           // !=0 if идентификатор is defined externally
    цел numbytes;
    tym_t ty;

static if (0)
{
    printf("OmfObj_reftoident('%s' seg %d, смещение x%lx, val x%lx, flags x%x)\n",
        s.Sident.ptr,seg,смещение,val,flags);
    printf("Sseg = %d, Sxtrnnum = %d\n",s.Sseg,s.Sxtrnnum);
    symbol_print(s);
}
    assert(seg > 0);

    ty = s.ty();
    while (1)
    {
        switch (flags & (CFseg | CFoff))
        {
            case 0:
                // Select default
                flags |= CFoff;
                if (tyfunc(ty))
                {
                    if (tyfarfunc(ty))
                        flags |= CFseg;
                }
                else // DATA
                {
                    if (LARGEDATA)
                        flags |= CFseg;
                }
                continue;
            case CFoff:
                if (I32)
                {
                    if (ty & mTYthread)
                    {   lc = LOC32tlsoffset;
                    }
                    else
                        lc = obj.LOCoffset;
                }
                else
                {
                    // The 'loader_resolved' смещение is required for VCM
                    // and Windows support. A fixup of this тип is
                    // relocated by the linker to point to a 'thunk'.
                    lc = (tyfarfunc(ty)
                          && !(flags & CFselfrel))
                            ? LOCloader_resolved : obj.LOCoffset;
                }
                numbytes = tysize(TYnptr);
                break;
            case CFseg:
                lc = LOCbase;
                numbytes = 2;
                break;
            case CFoff | CFseg:
                lc = obj.LOCpointer;
                numbytes = tysize(TYfptr);
                break;

            default:
                assert(0);
        }
        break;
    }

    switch (s.Sclass)
    {
        case SCcomdat:
        case_SCcomdat:
        case SCextern:
        case SCcomdef:
            if (s.Sxtrnnum)            // идентификатор is defined somewhere else
            {
                external = s.Sxtrnnum;

                debug
                if (external > obj.extidx)
                {
                    printf("obj.extidx = %d\n", obj.extidx);
                    symbol_print(s);
                }

                assert(external <= obj.extidx);
            }
            else
            {
                // Don't know yet, worry about it later
             Ladd:
                т_мера byteswritten = addtofixlist(s,смещение,seg,val,flags);
                assert(byteswritten == numbytes);
                return numbytes;
            }
            break;
        case SCinline:
            if (config.flags2 & CFG2comdat)
                goto case_SCcomdat;     // treat as initialized common block
            goto case;

        case SCsinline:
        case SCstatic:
        case SCglobal:
            if (s.Sseg == UNKNOWN)
                goto Ladd;
            if (seg_is_comdat(SegData[s.Sseg].segidx))
                goto case_SCcomdat;
            goto case;

        case SClocstat:
            external = 0;               // идентификатор is static or глоб2
                                        // and we know its смещение
            if (flags & CFoff)
                val += s.Soffset;
            break;
        default:
            symbol_print(s);
            assert(0);
    }

    lc |= (flags & CFselfrel) ? LOCATselfrel : LOCATsegrel;
    if (external)
    {   lc |= FD_T6;
        targetdatum = external;
        switch (s.Sfl)
        {
            case FLextern:
                if (!(ty & (mTYcs | mTYthread)))
                    goto L1;
                goto case;

            case FLfunc:
            case FLfardata:
            case FLcsdata:
            case FLtlsdata:
                if (config.exe & EX_flat)
                {   lc |= FD_F1;
                    framedatum = 1;
                }
                else
                {
            //case FLtlsdata:
                    lc |= FD_F2;
                    framedatum = targetdatum;
                }
                break;
            default:
                goto L1;
        }
    }
    else
    {
        lc |= FD_T4;                    // target is always a segment
        targetdatum = SegData[s.Sseg].segidx;
        assert(s.Sseg != UNKNOWN);
        switch (s.Sfl)
        {
            case FLextern:
                if (!(ty & (mTYcs | mTYthread)))
                    goto L1;
                goto case;

            case FLfunc:
            case FLfardata:
            case FLcsdata:
            case FLtlsdata:
                if (config.exe & EX_flat)
                {   lc |= FD_F1;
                    framedatum = 1;
                }
                else
                {
            //case FLtlsdata:
                    lc |= FD_F0;
                    framedatum = targetdatum;
                }
                break;
            default:
            L1:
                lc |= FD_F1;
                framedatum = DGROUPIDX;
                if (flags == CFseg)
                {   lc = LOCATsegrel | LOCbase | FD_F1 | FD_T5;
                    targetdatum = DGROUPIDX;
                }
static if (0)
{
                if (flags & CFseg && config.wflags & WFdsnedgroup)
                    warerr(WM_ds_ne_dgroup);
}
                break;
        }
    }

    OmfObj_ledata(seg,смещение,val,lc,framedatum,targetdatum);
    return numbytes;
}

/*****************************************
 * Generate far16 thunk.
 * Input:
 *      s       Symbol to generate a thunk for
 */

проц OmfObj_far16thunk(Symbol *s)
{
    static ббайт[25] cod32_1 =
    [
        0x55,                           //      PUSH    EBP
        0x8B,0xEC,                      //      MOV     EBP,ESP
        0x83,0xEC,0x04,                 //      SUB     ESP,4
        0x53,                           //      PUSH    EBX
        0x57,                           //      PUSH    EDI
        0x56,                           //      PUSH    ESI
        0x06,                           //      PUSH    ES
        0x8C,0xD2,                      //      MOV     DX,SS
        0x80,0xE2,0x03,                 //      AND     DL,3
        0x80,0xCA,0x07,                 //      OR      DL,7
        0x89,0x65,0xFC,                 //      MOV     -4[EBP],ESP
        0x8C,0xD0,                      //      MOV     AX,SS
        0x66,0x3D, // 0x00,0x00 */      /*      CMP     AX,seg FLAT:_DATA
    ];
    assert(cod32_1[cod32_1.length - 1] == 0x3D);

    static ббайт[22 + 46] cod32_2 =
    [
        0x0F,0x85,0x10,0x00,0x00,0x00,  //      JNE     L1
        0x8B,0xC4,                      //      MOV     EAX,ESP
        0x66,0x3D,0x00,0x08,            //      CMP     AX,2048
        0x0F,0x83,0x04,0x00,0x00,0x00,  //      JAE     L1
        0x66,0x33,0xC0,                 //      XOR     AX,AX
        0x94,                           //      XCHG    ESP,EAX
                                        // L1:
        0x55,                           //      PUSH    EBP
        0x8B,0xC4,                      //      MOV     EAX,ESP
        0x16,                           //      PUSH    SS
        0x50,                           //      PUSH    EAX
        LEA,0x75,0x08,                  //      LEA     ESI,8[EBP]
        0x81,0xEC,0x00,0x00,0x00,0x00,  //      SUB     ESP,numparam
        0x8B,0xFC,                      //      MOV     EDI,ESP
        0xB9,0x00,0x00,0x00,0x00,       //      MOV     ECX,numparam
        0x66,0xF3,0xA4,                 //      REP     MOVSB
        0x8B,0xC4,                      //      MOV     EAX,ESP
        0xC1,0xC8,0x10,                 //      ROR     EAX,16
        0x66,0xC1,0xE0,0x03,            //      SHL     AX,3
        0x0A,0xC2,                      //      OR      AL,DL
        0xC1,0xC0,0x10,                 //      ROL     EAX,16
        0x50,                           //      PUSH    EAX
        0x66,0x0F,0xB2,0x24,0x24,       //      LSS     SP,[ESP]
        0x66,0xEA, // 0,0,0,0, */       /*      JMPF    L3
    ];
    assert(cod32_2[cod32_2.length - 1] == 0xEA);

    static ббайт[26] cod32_3 =
    [                                   // L2:
        0xC1,0xE0,0x10,                 //      SHL     EAX,16
        0x0F,0xAC,0xD0,0x10,            //      SHRD    EAX,EDX,16
        0x0F,0xB7,0xE4,                 //      MOVZX   ESP,SP
        0x0F,0xB2,0x24,0x24,            //      LSS     ESP,[ESP]
        0x5D,                           //      POP     EBP
        0x8B,0x65,0xFC,                 //      MOV     ESP,-4[EBP]
        0x07,                           //      POP     ES
        0x5E,                           //      POP     ESI
        0x5F,                           //      POP     EDI
        0x5B,                           //      POP     EBX
        0xC9,                           //      LEAVE
        0xC2,0x00,0x00                  //      RET     numparam
    ];
    assert(cod32_3[cod32_3.length - 3] == 0xC2);

    бцел numparam = 24;
    targ_т_мера L2offset;
    цел idx;

    s.Sclass = SCstatic;
    s.Sseg = cseg;             // идентификатор is defined in code segment
    s.Soffset = Offset(cseg);

    // Store numparam into right places
    assert((numparam & 0xFFFF) == numparam);    // 2 byte значение
    TOWORD(&cod32_2[32],numparam);
    TOWORD(&cod32_2[32 + 7],numparam);
    TOWORD(&cod32_3[cod32_3.sizeof - 2],numparam);

    //------------------------------------------
    // Generate CODE16 segment if it isn't there already
    if (obj.code16segi == 0)
    {
        // Define CODE16 segment for far16 thunks

        static const сим[8] lname = "\06CODE16";

        // Put out LNAMES record
        objrecord(LNAMES,lname.ptr,lname.sizeof - 1);

        obj.code16segi = obj_newfarseg(0,4);
        obj.CODE16offset = 0;

        // class CODE
        бцел attr = SEG_ATTR(SEG_ALIGN2,SEG_C_PUBLIC,0,USE16);
        SegData[obj.code16segi].attr = attr;
        objsegdef(attr,0,obj.lnameidx++,4);
        obj.segidx++;
    }

    //------------------------------------------
    // Output the 32 bit thunk

    OmfObj_bytes(cseg,Offset(cseg),cod32_1.sizeof,cod32_1.ptr);
    Offset(cseg) += cod32_1.sizeof;

    // Put out fixup for SEG FLAT:_DATA
    OmfObj_ledata(cseg,Offset(cseg),0,LOCATsegrel|LOCbase|FD_F1|FD_T4,
        DGROUPIDX,DATA);
    Offset(cseg) += 2;

    OmfObj_bytes(cseg,Offset(cseg),cod32_2.sizeof,cod32_2.ptr);
    Offset(cseg) += cod32_2.sizeof;

    // Put out fixup to CODE16 part of thunk
    OmfObj_ledata(cseg,Offset(cseg),obj.CODE16offset,LOCATsegrel|LOC16pointer|FD_F0|FD_T4,
        SegData[obj.code16segi].segidx,
        SegData[obj.code16segi].segidx);
    Offset(cseg) += 4;

    L2offset = Offset(cseg);
    OmfObj_bytes(cseg,Offset(cseg),cod32_3.sizeof,cod32_3.ptr);
    Offset(cseg) += cod32_3.sizeof;

    s.Ssize = Offset(cseg) - s.Soffset;            // size of thunk

    //------------------------------------------
    // Output the 16 bit thunk

    OmfObj_byte(obj.code16segi,obj.CODE16offset++,0x9A);       //      CALLF   function

    // Make function external
    idx = OmfObj_external(s);                         // use Pascal имя mangling

    // Output fixup for function
    OmfObj_ledata(obj.code16segi,obj.CODE16offset,0,LOCATsegrel|LOC16pointer|FD_F2|FD_T6,
        idx,idx);
    obj.CODE16offset += 4;

    OmfObj_bytes(obj.code16segi,obj.CODE16offset,3,cast(ук)"\x66\x67\xEA".ptr);    // JMPF L2
    obj.CODE16offset += 3;

    OmfObj_ledata(obj.code16segi,obj.CODE16offset,L2offset,
        LOCATsegrel | LOC32pointer | FD_F1 | FD_T4,
        DGROUPIDX,
        SegData[cseg].segidx);
    obj.CODE16offset += 6;

    SegData[obj.code16segi].SDoffset = obj.CODE16offset;
}

/**************************************
 * Mark объект файл as using floating point.
 */

проц OmfObj_fltused()
{
    if (!obj.fltused)
    {
        obj.fltused = 1;
        if (!(config.flags3 & CFG3wkfloat))
            OmfObj_external_def("__fltused");
    }
}

Symbol *OmfObj_tlv_bootstrap()
{
    // specific for Mach-O
    assert(0);
}

проц OmfObj_gotref(Symbol *s)
{
}

/*****************************************
 * пиши a reference to a mutable pointer into the объект файл
 * Параметры:
 *      s    = symbol that содержит the pointer
 *      soff = смещение of the pointer inside the Symbol's memory
 */

проц OmfObj_write_pointerRef(Symbol* s, бцел soff)
{
version (Dinrus)
{
    if (!obj.ptrref_buf)
    {
        obj.ptrref_buf = cast(Outbuffer*) calloc(1, Outbuffer.sizeof);
        assert(obj.ptrref_buf);
    }

    // defer writing pointer references until the symbols are written out
    obj.ptrref_buf.пиши(&s, s.sizeof);
    obj.ptrref_buf.write32(soff);
}
}

/*****************************************
 * flush a single pointer reference saved by write_pointerRef
 * to the объект файл
 * Параметры:
 *      s    = symbol that содержит the pointer
 *      soff = смещение of the pointer inside the Symbol's memory
 */
private проц objflush_pointerRef(Symbol* s, бцел soff)
{
version (Dinrus)
{
    бул isTls = (s.Sfl == FLtlsdata);
    цел* segi = isTls ? &obj.tlsrefsegi : &obj.datrefsegi;
    symbol_debug(s);

    if (*segi == 0)
    {
        // We need to always put out the segments in triples, so that the
        // linker will put them in the correct order.
        static const сим[12] lnames_dat = "\03DPB\02DP\03DPE";
        static const сим[12] lnames_tls = "\03TPB\02TP\03TPE";
        const lnames = isTls ? lnames_tls.ptr : lnames_dat.ptr;
        // Put out LNAMES record
        objrecord(LNAMES,lnames,lnames_dat.sizeof - 1);

        цел dsegattr = obj.csegattr;

        // Put out beginning segment
        objsegdef(dsegattr,0,obj.lnameidx,CODECLASS);
        obj.lnameidx++;
        obj.segidx++;

        // Put out segment definition record
        *segi = obj_newfarseg(0,CODECLASS);
        objsegdef(dsegattr,0,obj.lnameidx,CODECLASS);
        SegData[*segi].attr = dsegattr;
        assert(SegData[*segi].segidx == obj.segidx);

        // Put out ending segment
        objsegdef(dsegattr,0,obj.lnameidx + 1,CODECLASS);

        obj.lnameidx += 2;              // for следщ time
        obj.segidx += 2;
    }

    targ_т_мера смещение = SegData[*segi].SDoffset;
    смещение += objmod.reftoident(*segi, смещение, s, soff, CFoff);
    SegData[*segi].SDoffset = смещение;
}
}

/*****************************************
 * flush all pointer references saved by write_pointerRef
 * to the объект файл
 */
private проц objflush_pointerRefs()
{
version (Dinrus)
{
    if (!obj.ptrref_buf)
        return;

    ббайт *p = obj.ptrref_buf.буф;
    ббайт *end = obj.ptrref_buf.p;
    while (p < end)
    {
        Symbol* s = *cast(Symbol**)p;
        p += s.sizeof;
        бцел soff = *cast(бцел*)p;
        p += soff.sizeof;
        objflush_pointerRef(s, soff);
    }
    obj.ptrref_buf.сбрось();
}
}

}

}
