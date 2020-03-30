
/**
 * Compiler implementation of the
 * $(LINK2 http://www.dlang.org, D programming language).
 *
 * Translation to D of Linux's melf.h
 *
 * Source:      $(LINK2 https://github.com/dlang/dmd/blob/master/src/dmd/backend/melf.d, backend/melf.d)
 */

module drc.backend.melf;

/* ELF файл format */

alias   ushort Elf32_Half;
alias   бцел Elf32_Word;
alias  цел Elf32_Sword;
alias   бцел Elf32_Addr;
alias    бцел Elf32_Off;
alias   бцел elf_u8_f32;

const EI_NIDENT = 16;



// EHident
        const EI_MAG0         = 0;       /* Identification byte смещение 0*/
        const EI_MAG1         = 1;       /* Identification byte смещение 1*/
        const EI_MAG2         = 2;       /* Identification byte смещение 2*/
        const EI_MAG3         = 3;       /* Identification byte смещение 3*/
            const ELFMAG0     = 0x7f;    /* Magic number byte 0 */
            const ELFMAG1     = 'E';     /* Magic number byte 1 */
            const ELFMAG2     = 'L';     /* Magic number byte 2 */
            const ELFMAG3     = 'F';     /* Magic number byte 3 */

        const EI_CLASS        = 4;       /* Файл class byte смещение 4 */
            const ELFCLASSNONE = 0;      // invalid
            const ELFCLASS32  = 1;       /* 32-bit objects */
            const ELFCLASS64  = 2;       /* 64-bit objects */

        const EI_DATA         = 5;       /* Data encoding byte смещение 5 */
            const ELFDATANONE = 0;       // invalid
            const ELFDATA2LSB = 1;       /* 2's comp,lsb low address */
            const ELFDATA2MSB = 2;       /* 2's comp,msb low address */

        const EI_VERSION      = 6;       /* Header version byte смещение 6 */
            //const EV_CURRENT        = 1;       /* Current header format */

        const EI_OSABI        = 7;       /* OS ABI  byte смещение 7 */
            const ELFOSABI_SYSV       = 0;       /* UNIX System V ABI */
            const ELFOSABI_HPUX       = 1;       /* HP-UX */
            const ELFOSABI_NETBSD     = 2;
            const ELFOSABI_LINUX      = 3;
            const ELFOSABI_FREEBSD    = 9;
            const ELFOSABI_OPENBSD    = 12;
            const ELFOSABI_ARM        = 97;      /* ARM */
            const ELFOSABI_STANDALONE = 255;     /* Standalone/embedded */

        const EI_ABIVERSION   = 8;   /* ABI version byte смещение 8 */

        const EI_PAD  = 9;           /* Byte to start of padding */

// e_type
        const ET_NONE     = 0;       /* No specified файл тип */
        const ET_REL      = 1;       /* Relocatable объект файл */
        const ET_EXEC     = 2;       /* Executable файл */
        const ET_DYN      = 3;       /* Dynamic link объект файл */
        const ET_CORE     = 4;       /* Core файл */
        const ET_LOPROC   = 0xff00;  /* Processor low index */
        const ET_HIPROC   = 0xffff;  /* Processor hi index */

// e_machine
        const EM_386      = 3;       /* Intel 80386 */
        const EM_486      = 6;       /* Intel 80486 */
        const EM_X86_64   = 62;      // Advanced Micro Devices X86-64 processor

// e_version
            const EV_NONE     = 0;   // invalid version
            const EV_CURRENT  = 1;   // Current файл format

// e_ehsize
        const EH_HEADER_SIZE = 0x34;

// e_phentsize
        const EH_PHTENT_SIZE = 0x20;

// e_shentsize
        const EH_SHTENT_SIZE = 0x28;

struct Elf32_Ehdr
    {
    ббайт[EI_NIDENT] EHident; /* Header identification info */
    Elf32_Half e_type;             /* Object файл тип */
    Elf32_Half e_machine;          /* Machine architecture */
    Elf32_Word e_version;              /* Файл format version */
    Elf32_Addr e_entry;                /* Entry point virtual address */
    Elf32_Off e_phoff;                /* Program header table(PHT)смещение */
    Elf32_Off e_shoff;                /* Section header table(SHT)смещение */
    Elf32_Word e_flags;                /* Processor-specific flags */
    Elf32_Half e_ehsize;               /* Size of ELF header (bytes) */
    Elf32_Half e_phentsize;            /* Size of PHT (bytes) */
    Elf32_Half e_phnum;                /* Number of PHT entries */
    Elf32_Half e_shentsize;            /* Size of SHT entry in bytes */
    Elf32_Half e_shnum;                /* Number of SHT entries */
    Elf32_Half e_shstrndx;             /* SHT index for ткст table */
  }


/* Section header.  */

// sh_type
        const SHT_NULL         = 0;          /* SHT entry unused */
        const SHT_PROGBITS     = 1;          /* Program defined данные */
        const SHT_SYMTAB       = 2;          /* Symbol table */
        const SHT_STRTAB       = 3;          /* String table */
        const SHT_RELA         = 4;          /* Relocations with addends */
        const SHT_HASHTAB      = 5;          /* Symbol хэш table */
        const SHT_DYNAMIC      = 6;          /* String table for dynamic symbols */
        const SHT_NOTE         = 7;          /* Notes */
        const SHT_RESDATA      = 8;          /* Reserved данные space */
        const SHT_NOBITS       = SHT_RESDATA;
        const SHT_REL          = 9;          /* Relocations no addends */
        const SHT_RESTYPE      = 10;         /* Reserved section тип*/
        const SHT_DYNTAB       = 11;         /* Dynamic linker symbol table */
        const SHT_INIT_ARRAY   = 14;         /* МассивДРК of constructors */
        const SHT_FINI_ARRAY   = 15;         /* МассивДРК of destructors */
        const SHT_GROUP        = 17;         /* Section group (COMDAT) */
        const SHT_SYMTAB_SHNDX = 18;         /* Extended section indices */

// sh_flags
        const SHF_WRITE       = (1 << 0);    /* Writable during execution */
        const SHF_ALLOC       = (1 << 1);    /* In memory during execution */
        const SHF_EXECINSTR   = (1 << 2);    /* Executable machine instructions*/
        const SHF_MERGE       = 0x10;
        const SHF_STRINGS     = 0x20;
        const SHF_INFO_LINK   = 0x40;
        const SHF_LINK_ORDER  = 0x80;
        const SHF_OS_NONCONFORMING  = 0x100;
        const SHF_GROUP       = 0x200;       // Member of a section group
        const SHF_TLS         = 0x400;       /* Thread local */
        const SHF_MASKPROC    = 0xf0000000;  /* Mask for processor-specific */

struct Elf32_Shdr
{
  Elf32_Word   sh_name;                /* String table смещение for section имя */
  Elf32_Word   sh_type;                /* Section тип */
  Elf32_Word   sh_flags;               /* Section attribute flags */
  Elf32_Addr   sh_addr;                /* Starting virtual memory address */
  Elf32_Off    sh_offset;              /* Offset to section in файл */
  Elf32_Word   sh_size;                /* Size of section */
  Elf32_Word   sh_link;                /* Index to optional related section */
  Elf32_Word   sh_info;                /* Optional extra section information */
  Elf32_Word   sh_addralign;           /* Required section alignment */
  Elf32_Word   sh_entsize;             /* Size of fixed size section entries */
}

// Special Section Header Table Indices
const SHN_UNDEF       = 0;               /* Undefined section */
const SHN_LORESERVE   = 0xff00;          /* Start of reserved indices */
const SHN_LOPROC      = 0xff00;          /* Start of processor-specific */
const SHN_HIPROC      = 0xff1f;          /* End of processor-specific */
const SHN_LOOS        = 0xff20;          /* Start of OS-specific */
const SHN_HIOS        = 0xff3f;          /* End of OS-specific */
const SHN_ABS         = 0xfff1;          /* Absolute значение for symbol references */
const SHN_COMMON      = 0xfff2;          /* Symbol defined in common section */
const SHN_XINDEX      = 0xffff;          /* Index is in extra table.  */
const SHN_HIRESERVE   = 0xffff;          /* End of reserved indices */


/* Symbol Table */

   // st_info

        ббайт ELF32_ST_BIND(ббайт s) { return s >> 4; }
        ббайт ELF32_ST_TYPE(ббайт s) { return s & 0xf; }
        ббайт ELF32_ST_INFO(ббайт b, ббайт t) { return cast(ббайт)((b << 4) + (t & 0xf)); }

        const STB_LOCAL       = 0;           /* Local symbol */
        const STB_GLOBAL      = 1;           /* Global symbol */
        const STB_WEAK        = 2;           /* Weak symbol */
        const ST_NUM_BINDINGS = 3;           /* Number of defined types.  */
        const STB_LOOS        = 10;          /* Start of OS-specific */
        const STB_HIOS        = 12;          /* End of OS-specific */
        const STB_LOPROC      = 13;          /* Start of processor-specific */
        const STB_HIPROC      = 15;          /* End of processor-specific */

        const STT_NOTYPE      = 0;           /* Symbol тип is unspecified */
        const STT_OBJECT      = 1;           /* Symbol is a данные объект */
        const STT_FUNC        = 2;           /* Symbol is a code объект */
        const STT_SECTION     = 3;           /* Symbol associated with a section */
        const STT_FILE        = 4;           /* Symbol's имя is файл имя */
        const STT_COMMON      = 5;
        const STT_TLS         = 6;
        const STT_NUM         = 5;           /* Number of defined types.  */
        const STT_LOOS        = 11;          /* Start of OS-specific */
        const STT_HIOS        = 12;          /* End of OS-specific */
        const STT_LOPROC      = 13;          /* Start of processor-specific */
        const STT_HIPROC      = 15;          /* End of processor-specific */

        const STV_DEFAULT     = 0;           /* Default symbol visibility rules */
        const STV_INTERNAL    = 1;           /* Processor specific hidden class */
        const STV_HIDDEN      = 2;           /* Sym unavailable in other modules */
        const STV_PROTECTED   = 3;           /* Not preemptible, not exported */


struct Elf32_Sym
{
    Elf32_Word st_name;                /* ткст table index for symbol имя */
    Elf32_Addr st_value;               /* Associated symbol значение */
    Elf32_Word st_size;                /* Symbol size */
    ббайт st_info;                     /* Symbol тип and binding */
    ббайт st_other;                    /* Currently not defined */
    Elf32_Half st_shndx;       /* SHT index for symbol definition */
}


/* Relocation table entry without addend (in section of тип SHT_REL).  */


// r_info

        // 386 Relocation types

        бцел ELF32_R_SYM(бцел i) { return i >> 8; }       /* Symbol idx */
        бцел ELF32_R_TYPE(бцел i) { return i & 0xff; }     /* Тип of relocation */
        бцел ELF32_R_INFO(бцел i, бцел t) { return ((i << 8) + (t & 0xff)); }

        const R_386_NONE    = 0;              /* No reloc */
        const R_386_32      = 1;              /* Symbol значение 32 bit  */
        const R_386_PC32    = 2;              /* PC relative 32 bit */
        const R_386_GOT32   = 3;              /* 32 bit GOT entry */
        const R_386_PLT32   = 4;              /* 32 bit PLT address */
        const R_386_COPY    = 5;              /* Copy symbol at runtime */
        const R_386_GLOB_DAT = 6;              /* Create GOT entry */
        const R_386_JMP_SLOT = 7;              /* Create PLT entry */
        const R_386_RELATIVE = 8;              /* Adjust by program base */
        const R_386_GOTOFF  = 9;              /* 32 bit смещение to GOT */
        const R_386_GOTPC   = 10;             /* 32 bit PC relative смещение to GOT */
        const R_386_TLS_TPOFF = 14;
        const R_386_TLS_IE    = 15;
        const R_386_TLS_GOTIE = 16;
        const R_386_TLS_LE    = 17;           /* negative смещение relative to static TLS */
        const R_386_TLS_GD    = 18;
        const R_386_TLS_LDM   = 19;
        const R_386_TLS_GD_32 = 24;
        const R_386_TLS_GD_PUSH  = 25;
        const R_386_TLS_GD_CALL  = 26;
        const R_386_TLS_GD_POP   = 27;
        const R_386_TLS_LDM_32   = 28;
        const R_386_TLS_LDM_PUSH = 29;
        const R_386_TLS_LDM_CALL = 30;
        const R_386_TLS_LDM_POP  = 31;
        const R_386_TLS_LDO_32   = 32;
        const R_386_TLS_IE_32    = 33;
        const R_386_TLS_LE_32    = 34;
        const R_386_TLS_DTPMOD32 = 35;
        const R_386_TLS_DTPOFF32 = 36;
        const R_386_TLS_TPOFF32  = 37;

struct Elf32_Rel
{
    Elf32_Addr r_offset;               /* Address */
    Elf32_Word r_info;                 /* Relocation тип and symbol index */
}

/* stabs debug records */

// DBtype
        const DBT_UNDEF       = 0x00;       /* undefined symbol */
        const DBT_EXT         = 0x01;       /* exernal modifier */
        const DBT_ABS         = 0x02;       /* absolute */
        const DBT_TEXT        = 0x04;       /* code text */
        const DBT_DATA        = 0x06;       /* данные */
        const DBT_BSS         = 0x08;       /* BSS */
        const DBT_INDR        = 0x0a;       /* indirect to another symbol */
        const DBT_COMM        = 0x12;       /* common -visible after shr'd lib link */
        const DBT_SETA        = 0x14;       /* Absolue set element */
        const DBT_SETT        = 0x16;       /* code text segment set element */
        const DBT_SETD        = 0x18;       /* данные segment set element */
        const DBT_SETB        = 0x1a;       /* BSS segment set element */
        const DBT_SETV        = 0x1c;       /* Pointer to set vector */
        const DBT_WARNING     = 0x1e;       /* print warning during link */
        const DBT_FN          = 0x1f;       /* имя of объект файл */

        const DBT_GSYM        = 0x20;       /* глоб2 symbol */
        const DBT_FUN         = 0x24;       /* function имя */
        const DBT_STSYM       = 0x26;       /* static данные */
        const DBT_LCSYM       = 0x28;       /* static bss */
        const DBT_MAIN        = 0x2a;       /* main routine */
        const DBT_RO          = 0x2c;       /* читай only */
        const DBT_OPT         = 0x3c;       /* target опция? */
        const DBT_REG         = 0x40;       /* register variable */
        const DBT_TLINE       = 0x44;       /* text line number */
        const DBT_DLINE       = 0x46;       /* dat line number */
        const DBT_BLINE       = 0x48;       /* bss line number */
        const DBT_STUN        = 0x62;       /* structure or union */
        const DBT_SRCF        = 0x64;       /* source файл */
        const DBT_AUTO        = 0x80;       /* stack variable */
        const DBT_TYPE        = 0x80;       /* тип definition */
        const DBT_INCS        = 0x84;       /* include файл start */
        const DBT_PARAM       = 0xa0;       /* параметр */
        const DBT_INCE        = 0xa2;       /* include файл end */


struct elf_stab
{
    Elf32_Word DBstring;               /* ткст table index for the symbol */
    elf_u8_f32  DBtype;                 /* тип of the symbol */
    elf_u8_f32  DBmisc;                 /* misc. info */
    Elf32_Half DBdesc;                 /* description field */
    Elf32_Word DBvalu;                 /* symbol значение */
}


/* Program header.  */

// PHtype
        const PHT_NULL       = 0;         /* SHT entry unused */

struct Elf32_Phdr
{
  Elf32_Word   PHtype;                 /* Program тип */
  Elf32_Off   PHoff;                  /* Offset to segment in файл */
  Elf32_Addr   PHvaddr;                /* Starting virtual memory address */
  Elf32_Addr   PHpaddr;                /* Starting absolute memory address */
  Elf32_Word   PHfilesz;               /* Size of файл image */
  Elf32_Word   PHmemsz;                /* Size of memory image */
  Elf32_Word   PHflags;                /* Program attribute flags */
  Elf32_Word   PHalign;                /* Program loading alignment */
}



/* Legal values for sh_flags (section flags).  */

/***************************** 64 bit Elf *****************************************/

alias     бдол Elf64_Addr;
alias      бдол Elf64_Off;
alias    бдол Elf64_Xword;
alias   long Elf64_Sxword;
alias    цел Elf64_Sword;
alias     бцел Elf64_Word;
alias     ushort Elf64_Half;

struct Elf64_Ehdr
{
    ббайт[EI_NIDENT] EHident; /* Header identification info */
    Elf64_Half  e_type;
    Elf64_Half  e_machine;
    Elf64_Word  e_version;
    Elf64_Addr  e_entry;
    Elf64_Off   e_phoff;
    Elf64_Off   e_shoff;
    Elf64_Word  e_flags;
    Elf64_Half  e_ehsize;
    Elf64_Half  e_phentsize;
    Elf64_Half  e_phnum;
    Elf64_Half  e_shentsize;
    Elf64_Half  e_shnum;
    Elf64_Half  e_shstrndx;
}

struct Elf64_Shdr
{
    Elf64_Word  sh_name;
    Elf64_Word  sh_type;
    Elf64_Xword sh_flags;
    Elf64_Addr  sh_addr;
    Elf64_Off   sh_offset;
    Elf64_Xword sh_size;
    Elf64_Word  sh_link;
    Elf64_Word  sh_info;
    Elf64_Xword sh_addralign;
    Elf64_Xword sh_entsize;
}

struct Elf64_Phdr
{
    Elf64_Word  p_type;
    Elf64_Word  p_flags;
    Elf64_Off   p_offset;
    Elf64_Addr  p_vaddr;
    Elf64_Addr  p_paddr;
    Elf64_Xword p_filesz;
    Elf64_Xword p_memsz;
    Elf64_Xword p_align;
}

struct Elf64_Sym
{
    Elf64_Word  st_name;
    ббайт       st_info;
    ббайт       st_other;
    Elf64_Half  st_shndx;
    Elf64_Addr  st_value;
    Elf64_Xword st_size;
}

ббайт ELF64_ST_BIND(ббайт s) { return ELF32_ST_BIND(s); }
ббайт ELF64_ST_TYPE(ббайт s) { return ELF32_ST_TYPE(s); }
ббайт ELF64_ST_INFO(ббайт b, ббайт t) { return ELF32_ST_INFO(b,t); }

// r_info
        бцел ELF64_R_SYM(бдол i)  { return cast(Elf64_Word)(i>>32); }
        бцел ELF64_R_TYPE(бдол i) { return cast(Elf64_Word)(i & 0xFFFF_FFFF); }
        бдол ELF64_R_INFO(бдол s, бдол t) { return ((cast(Elf64_Xword)s)<<32)|cast(Elf64_Word)t; }

        // X86-64 Relocation types

        const R_X86_64_NONE      = 0;     // -- No relocation
        const R_X86_64_64        = 1;     // 64 Direct 64 bit
        const R_X86_64_PC32      = 2;     // 32 PC relative 32 bit signed
        const R_X86_64_GOT32     = 3;     // 32 32 bit GOT entry
        const R_X86_64_PLT32     = 4;     // 32 bit PLT address
        const R_X86_64_COPY      = 5;     // -- Copy symbol at runtime
        const R_X86_64_GLOB_DAT  = 6;     // 64 Create GOT entry
        const R_X86_64_JUMP_SLOT = 7;     // 64 Create PLT entry
        const R_X86_64_RELATIVE  = 8;     // 64 Adjust by program base
        const R_X86_64_GOTPCREL  = 9;     // 32 32 bit signed pc relative смещение to GOT
        const R_X86_64_32       = 10;     // 32 Direct 32 bit нуль extended
        const R_X86_64_32S      = 11;     // 32 Direct 32 bit sign extended
        const R_X86_64_16       = 12;     // 16 Direct 16 bit нуль extended
        const R_X86_64_PC16     = 13;     // 16 16 bit sign extended pc relative
        const R_X86_64_8        = 14;     //  8 Direct 8 bit sign extended
        const R_X86_64_PC8      = 15;     //  8 8 bit sign extended pc relative
        const R_X86_64_DTPMOD64 = 16;     // 64 ID of module containing symbol
        const R_X86_64_DTPOFF64 = 17;     // 64 Offset in TLS block
        const R_X86_64_TPOFF64  = 18;     // 64 Offset in initial TLS block
        const R_X86_64_TLSGD    = 19;     // 32 PC relative смещение to GD GOT block
        const R_X86_64_TLSLD    = 20;     // 32 PC relative смещение to LD GOT block
        const R_X86_64_DTPOFF32 = 21;     // 32 Offset in TLS block
        const R_X86_64_GOTTPOFF = 22;     // 32 PC relative смещение to IE GOT entry
        const R_X86_64_TPOFF32  = 23;     // 32 Offset in initial TLS block
        const R_X86_64_PC64     = 24;     // 64
        const R_X86_64_GOTOFF64 = 25;     // 64
        const R_X86_64_GOTPC32  = 26;     // 32
        const R_X86_64_GNU_VTINHERIT = 250;    // GNU C++ hack
        const R_X86_64_GNU_VTENTRY   = 251;    // GNU C++ hack

struct Elf64_Rel
{
    Elf64_Addr  r_offset;
    Elf64_Xword r_info;

}

struct Elf64_Rela
{
    Elf64_Addr   r_offset;
    Elf64_Xword  r_info;
    Elf64_Sxword r_addend;
}

// Section Group Flags
const GRP_COMDAT   = 1;
const GRP_MASKOS   = 0x0ff0_0000;
const GRP_MASKPROC = 0xf000_0000;


