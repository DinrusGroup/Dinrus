/**
 * Provides (read-only) memory-mapped I/O for ELF files.
 *
 * Reference: http://www.dwarfstd.org/
 *
 * Copyright: Copyright Digital Mars 2015 - 2018.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Yazan Dabain, Martin Kinkelin
 * Source: $(DRUNTIMESRC core/elf/io.d)
 */

module core.internal.elf.io;

version (Posix):

import core.sys.posix.fcntl;
import core.sys.posix.sys.mman;
import core.sys.posix.unistd;

version (linux)
{
    import core.sys.linux.link;
    version = LinuxOrBSD;
}
else version (FreeBSD)
{
    import core.sys.freebsd.sys.link_elf;
    version = LinuxOrBSD;
}
else version (DragonFlyBSD)
{
    import core.sys.dragonflybsd.sys.link_elf;
    version = LinuxOrBSD;
}

/**
 * File-based memory-mapped I/O (read-only).
 * Only supports ELF files with a byte-order matching the target platform's.
 * Params:
 *     Elf_Ehdr = Expected type of the ELF header (Elf{32,64}_Ehdr)
 *     Elf_Shdr = Expected type of the ELF section header (Elf{32,64}_Shdr)
 *     ELFCLASS = Expected ELF class (ELFCLASS{32,64})
 */
template ElfIO(Elf_Ehdr, Elf_Shdr, ubyte ELFCLASS)
{
    /**
     * ELF file (with memory-mapped ELF header).
     */
    struct ElfFile
    {
    @nogc nothrow:
        /**
         * Tries to open the specified file as ELF file matching the ElfIO
         * template parameters.
         * Returns: True on success.
         */
        static bool open(const(char)* path, out ElfFile file)
        {
            file = ElfFile(.open(path, O_RDONLY));
            return file.isValid();
        }

        /**
         * Constructs an instance based on the specified file descriptor.
         * Doesn't validate the file header.
         * The file is closed when destructing the instance.
         */
        this(int fd)
        {
            this.fd = fd;
            if (fd != -1)
            {
                // memory map header
                this.ehdr = MMapRegion!Elf_Ehdr(fd, 0);
            }
        }

        @disable this(this);

        /// Closes the file.
        ~this()
        {
            if (fd != -1)
                close(fd);
        }

        private int fd = -1;
        /// Memory-mapped ELF header.
        MMapRegion!Elf_Ehdr ehdr;

        /// Returns true if the ELF file header matches the ElfIO template parameters.
        bool isValid() const
        {
            enum EI_MAG0 = 0;
            enum EI_MAG1 = 1;
            enum EI_MAG2 = 2;
            enum EI_MAG3 = 3;
            enum EI_CLASS = 4;
            enum EI_DATA = 5;

            enum ELFMAG0 = 0x7f;
            enum ELFMAG1 = 'E';
            enum ELFMAG2 = 'L';
            enum ELFMAG3 = 'F';

            enum ELFCLASS32 = 1;
            enum ELFCLASS64 = 2;

            enum ELFDATA2LSB = 1;
            enum ELFDATA2MSB = 2;

            version (LittleEndian)   alias ELFDATA = ELFDATA2LSB;
            else version (BigEndian) alias ELFDATA = ELFDATA2MSB;
            else static assert(0, "unsupported byte order");

            if (fd == -1)
                return false;

            const ident = ehdr.e_ident;

            if (!(ident[EI_MAG0] == ELFMAG0 &&
                  ident[EI_MAG1] == ELFMAG1 &&
                  ident[EI_MAG2] == ELFMAG2 &&
                  ident[EI_MAG3] == ELFMAG3))
                return false;

            if (ident[EI_CLASS] != ELFCLASS)
                return false;

            // the file's byte order must match the target's
            if (ident[EI_DATA] != ELFDATA)
                return false;

            return true;
        }

        /**
         * Tries to find the header of the section with the specified name.
         * Returns: True on success.
         */
        bool findSectionHeaderByName(const(char)[] sectionName, out ElfSectionHeader header) const
        {
            const index = findSectionIndexByName(sectionName);
            if (index == -1)
                return false;
            header = ElfSectionHeader(this, index);
            return true;
        }

        /**
         * Tries to find the index of the section with the specified name.
         * Returns: -1 if not found, otherwise 0-based section index.
         */
        size_t findSectionIndexByName(const(char)[] sectionName) const
        {
            import core.stdc.string : strlen;

            const stringSectionHeader = ElfSectionHeader(this, ehdr.e_shstrndx);
            const stringSection = ElfSection(this, stringSectionHeader);

            foreach (i; 0 .. ehdr.e_shnum)
            {
                auto sectionHeader = ElfSectionHeader(this, i);
                auto pCurrentName = cast(const(char)*) (stringSection.data.ptr + sectionHeader.sh_name);
                auto currentName = pCurrentName[0 .. strlen(pCurrentName)];
                if (sectionName == currentName)
                    return i;
            }

            // not found
            return -1;
        }
    }

    /**
     * Memory-mapped ELF section header.
     */
    struct ElfSectionHeader
    {
    @nogc nothrow:
        /// Constructs a new instance based on the specified file and section index.
        this(ref const ElfFile file, size_t index)
        {
            assert(Elf_Shdr.sizeof == file.ehdr.e_shentsize);
            shdr = MMapRegion!Elf_Shdr(
                file.fd,
                file.ehdr.e_shoff + index * Elf_Shdr.sizeof
            );
        }

        @disable this(this);

        alias shdr this;
        /// Memory-mapped section header.
        MMapRegion!Elf_Shdr shdr;
    }

    /**
     * Memory-mapped ELF section data.
     */
    struct ElfSection
    {
    @nogc nothrow:
        /// Constructs a new instance based on the specified file and section header.
        this(ref const ElfFile file, ref const ElfSectionHeader shdr)
        {
            mappedRegion = MMapRegion!void(file.fd, shdr.sh_offset, shdr.sh_size);
            size = shdr.sh_size;
        }

        @disable this(this);

        /// Returns the memory-mapped section data.
        /// The data is accessible as long as this ElfSection is alive.
        const(void)[] data() const
        {
            return mappedRegion.data[0 .. size];
        }

        alias data this;

    private:
        MMapRegion!void mappedRegion;
        size_t size;
    }
}

/// ELF class for 32-bit ELF files.
enum ELFCLASS32 = 1;
/// ELF class for 64-bit ELF files.
enum ELFCLASS64 = 2;

// convenience aliases for the target platform
version (LinuxOrBSD)
{
    /// Native ELF header type.
    alias Elf_Ehdr = ElfW!"Ehdr";
    /// Native ELF section header type.
    alias Elf_Shdr = ElfW!"Shdr";

    /// Native ELF class.
    version (D_LP64) alias ELFCLASS = ELFCLASS64;
    else             alias ELFCLASS = ELFCLASS32;

    ///
    alias NativeElfIO = ElfIO!(Elf_Ehdr, Elf_Shdr, ELFCLASS);

    /// Native ELF file.
    alias ElfFile = NativeElfIO.ElfFile;
    /// Native ELF section header.
    alias ElfSectionHeader = NativeElfIO.ElfSectionHeader;
    /// Native ELF section.
    alias ElfSection = NativeElfIO.ElfSection;
}

private struct MMapRegion(T)
{
@nogc nothrow:
    this(int fd, size_t offset, size_t length = 1)
    {
        if (fd == -1)
            return;

        const pageSize = sysconf(_SC_PAGESIZE);
        const pagedOffset = (offset / pageSize) * pageSize;
        const offsetDiff = offset - pagedOffset;
        const mappedSize = length * T.sizeof + offsetDiff;

        auto ptr = cast(ubyte*) mmap(null, mappedSize, PROT_READ, MAP_PRIVATE, fd, pagedOffset);

        mappedRegion = ptr[0 .. mappedSize];
        data = cast(T*) (ptr + offsetDiff);
    }

    @disable this(this);

    ~this()
    {
        if (mappedRegion !is null)
            munmap(mappedRegion.ptr, mappedRegion.length);
    }

    alias data this;

    private ubyte[] mappedRegion;
    const(T)* data;
}
