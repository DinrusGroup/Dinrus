
/* Mach-O объект файл format
 * Translated to D from mach.h
 */

module drc.backend.mach;

// Online documentation: https://dlang.org/phobos/dmd_backend_mach.html

alias цел cpu_type_t;
alias цел cpu_subtype_t;
alias цел vm_prot_t;

enum
{
    // magic
    MH_MAGIC = 0xfeedface,
    MH_CIGAM = 0xcefaedfe,

    // cputype
    CPU_TYPE_I386      =  cast(cpu_type_t)7,
    CPU_TYPE_X86_64    = cast(cpu_type_t)7 | 0x1000000,
    CPU_TYPE_POWERPC   = cast(cpu_type_t)18,
    CPU_TYPE_POWERPC64 = CPU_TYPE_POWERPC | 0x1000000,

    // cpusubtype
    CPU_SUBTYPE_POWERPC_ALL = cast(cpu_subtype_t)0,
    CPU_SUBTYPE_I386_ALL    = cast(cpu_subtype_t)3,

    // filetype
    MH_OBJECT       = 1,
    MH_EXECUTE      = 2,
    MH_BUNDLE       = 8,
    MH_DYLIB        = 6,
    MH_PRELOAD      = 5,
    MH_CORE         = 4,
    MH_DYLINKER     = 7,
    MH_DSYM         = 10,

    // flags
    MH_NOUNDEFS                = 1,
    MH_INCRLINK                = 2,
    MH_DYLDLINK                = 4,
    MH_TWOLEVEL                = 0x80,
    MH_BINDATLOAD              = 8,
    MH_PREBOUND                = 0x10,
    MH_PREBINDABLE             = 0x800,
    MH_NOFIXPREBINDING         = 0x400,
    MH_ALLMODSBOUND            = 0x1000,
    MH_CANONICAL               = 0x4000,
    MH_SPLIT_SEGS              = 0x20,
    MH_FORCE_FLAT              = 0x100,
    MH_SUBSECTIONS_VIA_SYMBOLS = 0x2000,
    MH_NOMULTIDEFS             = 0x200,
}

struct mach_header
{
    бцел magic;
    cpu_type_t cputype;
    cpu_subtype_t cpusubtype;
    бцел filetype;
    бцел ncmds;
    бцел sizeofcmds;
    бцел flags;
}

enum
{
    // magic
    MH_MAGIC_64 = 0xfeedfacf,
    MH_CIGAM_64 = 0xcffaedfe,
}

struct mach_header_64
{
    бцел magic;
    cpu_type_t cputype;
    cpu_subtype_t cpusubtype;
    бцел filetype;
    бцел ncmds;
    бцел sizeofcmds;
    бцел flags;
    бцел reserved;
}

enum
{
    // cmd
    LC_SEGMENT      = 1,
    LC_SYMTAB       = 2,
    LC_DYSYMTAB     = 11,
    LC_SEGMENT_64   = 0x19,
}

struct load_command
{
    бцел cmd;
    бцел cmdsize;
}

struct uuid_command
{
    бцел cmd;
    бцел cmdsize;
    ббайт[16] uuid;
}

enum
{
    // flags
    SG_HIGHVM              = 1,
    SG_FVMLIB              = 2,
    SG_NORELOC             = 4,
    SG_PROTECTED_VERSION_1 = 8,
}

struct segment_command
{
    бцел cmd;
    бцел cmdsize;
    сим[16] segname;
    бцел vmaddr;
    бцел vmsize;
    бцел fileoff;
    бцел filesize;
    vm_prot_t maxprot;
    vm_prot_t initprot;
    бцел nsects;
    бцел flags;
}

struct segment_command_64
{
    бцел cmd;
    бцел cmdsize;
    сим[16] segname;
    бдол vmaddr;
    бдол vmsize;
    бдол fileoff;
    бдол filesize;
    vm_prot_t maxprot;
    vm_prot_t initprot;
    бцел nsects;
    бцел flags;
}

enum
{
    // flags
    SECTION_TYPE       = 0xFF,
    SECTION_ATTRIBUTES = 0xFFFFFF00,

    S_REGULAR               = 0,
    S_ZEROFILL              = 1,
    S_CSTRING_LITERALS      = 2,
    S_4BYTE_LITERALS        = 3,
    S_8BYTE_LITERALS        = 4,
    S_LITERAL_POINTERS      = 5,

    S_NON_LAZY_SYMBOL_POINTERS      = 6,
    S_LAZY_SYMBOL_POINTERS          = 7,
    S_SYMBOL_STUBS                  = 8,
    S_MOD_INIT_FUNC_POINTERS        = 9,
    S_MOD_TERM_FUNC_POINTERS        = 10,
    S_COALESCED                     = 11,
    S_GB_ZEROFILL                   = 12,
    S_INTERPOSING                   = 13,
    S_16BYTE_LITERALS               = 14,
    S_DTRACE_DOF                    = 15,

    S_THREAD_LOCAL_REGULAR          = 0x11, // template of initial values for TLVs
    S_THREAD_LOCAL_ZEROFILL         = 0x12, // template of initial values for TLVs
    S_THREAD_LOCAL_VARIABLES        = 0x13, // TLV descriptors

    SECTION_ATTRIBUTES_USR          = 0xFF000000,
    S_ATTR_PURE_INSTRUCTIONS        = 0x80000000,
    S_ATTR_NO_TOC                   = 0x40000000,
    S_ATTR_STRIP_STATIC_SYMS        = 0x20000000,
    S_ATTR_NO_DEAD_STRIP            = 0x10000000,
    S_ATTR_LIVE_SUPPORT             = 0x8000000,
    S_ATTR_SELF_MODIFYING_CODE      = 0x4000000,
    S_ATTR_DEBUG                    = 0x2000000,

    SECTION_ATTRIBUTES_SYS          = 0xFFFF00,
    S_ATTR_SOME_INSTRUCTIONS        = 0x000400,
    S_ATTR_EXT_RELOC                = 0x000200,
    S_ATTR_LOC_RELOC                = 0x000100,
}

struct section
{
    сим[16] sectname;
    сим[16] segname;
    бцел addr;
    бцел size;
    бцел смещение;
    бцел _align;
    бцел reloff;
    бцел nreloc;
    бцел flags;

    бцел reserved1;
    бцел reserved2;
}

struct section_64
{
    сим[16] sectname;
    сим[16] segname;
    бдол addr;
    бдол size;
    бцел смещение;
    бцел _align;
    бцел reloff;
    бцел nreloc;
    бцел flags;
    бцел reserved1;
    бцел reserved2;
    бцел reserved3;
}

struct twolevel_hints_command
{
    бцел cmd;
    бцел cmdsize;
    бцел смещение;
    бцел nhints;
}

struct twolevel_hint
{
    version (all)
    {
        бцел xxx;
    }
    else
    {
        // бцел isub_image:8, itoc:24;
    }
}

struct symtab_command
{
    бцел cmd;
    бцел cmdsize;
    бцел symoff;
    бцел nsyms;
    бцел stroff;
    бцел strsize;
}

enum
{
    // n_type
    N_EXT   = 1,
    N_STAB  = 0xE0,
    N_PEXT  = 0x10,
    N_TYPE  = 0x0E,
    N_UNDF  = 0,
    N_ABS   = 2,
    N_INDR  = 10,
    N_PBUD  = 12,
    N_SECT  = 14,
}

enum
{
    // n_desc
    N_ARM_THUMB_DEF   =     8,
    N_NO_DEAD_STRIP   =  0x20,
    N_DESC_DISCARDED  =  0x20,
    N_WEAK_REF        =  0x40,
    N_WEAK_DEF        =  0x80,
    N_REF_TO_WEAK     =  0x80,
    N_SYMBOL_RESOLVER = 0x100,
}

enum
{
    // n_desc
    REFERENCE_FLAG_UNDEFINED_NON_LAZY         = 0,
    REFERENCE_FLAG_UNDEFINED_LAZY             = 1,
    REFERENCE_FLAG_DEFINED                    = 2,
    REFERENCE_FLAG_PRIVATE_DEFINED            = 3,
    REFERENCE_FLAG_PRIVATE_UNDEFINED_NON_LAZY = 4,
    REFERENCE_FLAG_PRIVATE_UNDEFINED_LAZY     = 5,
}

struct nlist
{
    union
    {
        цел n_strx;
    }
    ббайт n_type;
    ббайт n_sect;
    short n_desc;
    бцел n_value;
}

struct nlist_64
{
    union
    {
        бцел n_strx;
    }
    ббайт n_type;
    ббайт n_sect;
    ushort n_desc;
    бдол n_value;
}

struct dysymtab_command
{
    бцел cmd;
    бцел cmdsize;
    бцел ilocalsym;
    бцел nlocalsym;
    бцел iextdefsym;
    бцел nextdefsym;
    бцел iundefsym;
    бцел nundefsym;
    бцел tocoff;
    бцел ntoc;
    бцел modtaboff;
    бцел nmodtab;
    бцел extrefsymoff;
    бцел nextrefsyms;
    бцел indirectsymoff;
    бцел nindirectsyms;
    бцел extreloff;
    бцел nextrel;
    бцел locreloff;
    бцел nlocrel;
}

enum
{
    // r_address
    R_SCATTERED = 0x80000000,

    // r_type
    // for i386
    GENERIC_RELOC_VANILLA               = 0,
    GENERIC_RELOC_PAIR                  = 1,
    GENERIC_RELOC_SECTDIFF              = 2,
    GENERIC_RELOC_PB_LA_PTR             = 3,
    GENERIC_RELOC_LOCAL_SECTDIFF        = 4,

    // for x86_64
    X86_64_RELOC_UNSIGNED               = 0,
    X86_64_RELOC_SIGNED                 = 1,
    X86_64_RELOC_BRANCH                 = 2,
    X86_64_RELOC_GOT_LOAD               = 3,
    X86_64_RELOC_GOT                    = 4,
    X86_64_RELOC_SUBTRACTOR             = 5,
    X86_64_RELOC_SIGNED_1               = 6,
    X86_64_RELOC_SIGNED_2               = 7,
    X86_64_RELOC_SIGNED_4               = 8,
    X86_64_RELOC_TLV                    = 9, // for thread local variables
}

struct relocation_info
{
    цел r_address;

    /* LITTLE_ENDIAN for x86
     * бцел r_symbolnum:24,
     *      r_pcrel    :1,
     *      r_length   :2,
     *      r_extern   :1,
     *      r_type     :4;
     */
    бцел xxx;
    
    проц r_symbolnum(бцел r) { assert(!(r & ~0x00FF_FFFF)); xxx = (xxx & ~0x00FF_FFFF) | r; }
    проц r_pcrel    (бцел r) { assert(!(r & ~1));           xxx = (xxx & ~0x0100_0000) | (r << 24); }
    проц r_length   (бцел r) { assert(!(r & ~3));           xxx = (xxx & ~0x0600_0000) | (r << (24 + 1)); }
    проц r_extern   (бцел r) { assert(!(r & ~1));           xxx = (xxx & ~0x0800_0000) | (r << (24 + 1 + 2)); }
    проц r_type     (бцел r) { assert(!(r & ~0xF));         xxx = (xxx & ~0xF000_0000) | (r << (24 + 1 + 2 + 1)); }

    бцел r_pcrel() { return (xxx >> 24) & 1; }
}

struct scattered_relocation_info
{
    /* LITTLE_ENDIAN for x86
     * бцел r_address  :24,
     *      r_type     :4,
     *      r_length   :2,
     *      r_pcrel    :1,
     *      r_scattered:1;
     */
    бцел xxx;
    
    проц r_address  (бцел r) { assert(!(r & ~0x00FF_FFFF)); xxx = (xxx & ~0x00FF_FFFF) | r; }
    проц r_type     (бцел r) { assert(!(r & ~0xF));         xxx = (xxx & ~0x0F00_0000) | (r << 24); }
    проц r_length   (бцел r) { assert(!(r & ~3));           xxx = (xxx & ~0x3000_0000) | (r << (24 + 4)); }
    проц r_pcrel    (бцел r) { assert(!(r & ~1));           xxx = (xxx & ~0x4000_0000) | (r << (24 + 4 + 2)); }
    проц r_scattered(бцел r) { assert(!(r & ~1));           xxx = (xxx & ~0x8000_0000) | (r << (24 + 4 + 2 + 1)); }

    бцел r_pcrel() { return (xxx >> (24 + 4 + 2)) & 1; }

    цел r_value;
}
