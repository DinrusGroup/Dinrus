/**
 A simple PE/COFF image format reader.

 Authors:
	Jeremie Pelletier

 References:
	$(LINK http://www.csn.ul.ie/~caolan/publink/winresdump/winresdump/doc/pefile.html)

 License:
	Public Domain
*/
module dbg.image.PE;

import cidrus : strncmp;
import dbg.Debug;
import dbg.symbol.CodeView;

version(Windows)
{
import winapi;

class PEImage : IExecutableImage {
	/**
	Загружает и оценивает файл образа.

	 Параметры:
		имяф =	Путь к файлу образа.
	*/
	this(ткст имяф)
	in {
		assert(имяф.length && имяф.ptr);
	}
	body {
		_filename = имяф;

		// Create the файл mapping
		_file = CreateFileA((имяф ~ '\0').ptr, GENERIC_READ, FILE_SHARE_READ,
			null, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, null);
		if(_file == INVALID_HANDLE_VALUE) SystemException();

		_fileSize = GetFileSize(_file, null);

		_map = CreateFileMappingA(_file, null, PAGE_READONLY, 0, 0, null);
		if(!_map) SystemException();

		_view = cast(ббайт*)MapViewOfFile(_map, FILE_MAP_READ, 0, 0, 0);
		if(!_view) SystemException();

		// Verify image headers
		if(_dos.e_magic != IMAGE_DOS_SIGNATURE) goto m_Error;
		CheckOffset(_dos.e_lfanew);

		_nt = cast(IMAGE_NT_HEADERS32*)(_view + _dos.e_lfanew);
		if(_nt.Signature != IMAGE_NT_SIGNATURE) goto m_Error;

		_is64 = _nt.FileHeader.SizeOfOptionalHeader == IMAGE_SIZEOF_NT_OPTIONAL64_HEADER;

		if(_is64) {
			if(_nt64.OptionalHeader.Magic != IMAGE_NT_OPTIONAL_HDR64_MAGIC)
				goto m_Error;
		}
		else {
			if(_nt.OptionalHeader.Magic != IMAGE_NT_OPTIONAL_HDR32_MAGIC)
				goto m_Error;
		}

		// Create the RVA lookup table
		auto секции = this.секции;
		RVAEntry* e = проц;
		_rvaTable.length = секции.length;
		foreach(i, ref s; секции) with(s) {
			e = &_rvaTable[i];
			e.start = VirtualAddress;
			e.end = VirtualAddress + SizeOfRawData;
			e.base = PointerToRawData;
		}

		return;

	m_Error:
		throw new PEInvalidException(this);
	}

	/**
	 Выгружает файл PE.
	*/
	~this() {
		if(_dos && !UnmapViewOfFile(cast(ук)_dos)) SystemException();
		if(_map && !CloseHandle(_map)) SystemException();
		if(_file && !CloseHandle(_file)) SystemException();
	}

	/**
	 Получить имяФайла образа
	*/
	ткст имяФайла() {
		return _filename;
	}

	/**
	 Get whether the image uses the 64bit structures or not
	*/
	бул is64() {
		return _is64;
	}

	/**
	 Get the base address of the image
	*/
	дол imageBase() {
		return _is64 ? _nt64.OptionalHeader.ImageBase : _nt.OptionalHeader.ImageBase;
	}

	/**
	 Get the raw image данные
	*/
	ббайт[] данные() {
		return _view[0 .. _fileSize];
	}

	/**
	 Get the dos, nt or nt64 headers
	*/
	IMAGE_DOS_HEADER* dosHeader() { return _dos; }
	IMAGE_NT_HEADERS32* ntHeaders32() { return _nt; }
	IMAGE_NT_HEADERS64* ntHeaders64() { return _nt64; }

	/**
	 Get the массив of данные directories
	*/
	IMAGE_DATA_DIRECTORY[] dataDirectory()  {
		return _is64 ? _nt64.OptionalHeader.DataDirectory : _nt.OptionalHeader.DataDirectory;
	}

	/**
	 Get the массив of section headers
	*/
	IMAGE_SECTION_HEADER[] секции() {
		return (_is64 ? IMAGE_FIRST_SECTION64(_nt64) : IMAGE_FIRST_SECTION32(_nt))
			[0 .. _nt.FileHeader.NumberOfSections];
	}

	/**
	 Translate the given Virtual Address to its corresponding данные смещение.
	*/
	дол LookupVA(дол va)  {
		return LookupRVA(va - imageBase);
	}

	/**
	 Translate the given Relative Virtual Address to its corresponding
	 данные смещение.
	*/
	дол LookupRVA(дол rva)  {
		foreach(ref e; _rvaTable) with(e) {
			if(rva >= start && rva < end) {
				дол смещение = base + (rva - start);
				CheckOffset(смещение);
				return смещение;
			}
		}

		return 0;
	}

	/**
	 Get a данные structure in the image from its RVA
	*/
	T* GetDataFromRVA(T : T*)(дол rva)  {
		дол смещение = LookupRVA(rva);
		return смещение ? cast(T*)(_view + смещение) : null;
	}

	/**
	 Get a данные directory in the image from its ID
	*/
	T* GetDirectory(T)(бцел ид) {
		const IMAGE_DATA_DIRECTORY* dir = &dataDirectory[ид];
		return dir.VirtualAddress && dir.Size ?
			GetDataFromRVA!(T*)(dir.VirtualAddress) : null;
	}

	/**
	 Find the first section matching the given flags mask
	*/
	IMAGE_SECTION_HEADER* FindSection(бцел mask) 
	in {
		assert(mask);
	}
	body {
		foreach(ref section; секции)
			if(section.Characteristics & mask)
				return &section;

		return null;
	}

	/**
	 Find a section by its имя
	*/
	IMAGE_SECTION_HEADER* FindSection(ткст имя) 
	in {
		assert(имя.length && имя.ptr);
	}
	body {
		foreach(ref section; секции)
			if(strncmp(cast(ткст0)section.Name.ptr, имя.ptr, section.Name.length) == 0)
				return &section;

		return null;
	}

	/**
	 Get the смещение to the code segment
	*/
	бцел codeOffset()  {
		IMAGE_SECTION_HEADER* section = FindSection(IMAGE_SCN_MEM_EXECUTE);
		return section ? section.VirtualAddress : 0;
	}

	/**
	 Get the symbolic debug info объект for this image
	*/
	ISymbolicDebugInfo debugInfo() {
		бцел va = _nt.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_DEBUG].VirtualAddress;
		if(!va) return null;

		IMAGE_DEBUG_DIRECTORY* dir = проц;
		бцел size = _nt.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_DEBUG].Size;
		бцел смещение = проц;

		// Borland directory
		IMAGE_SECTION_HEADER* section = FindSection(".debug");
		if(section && section.VirtualAddress == va) {
			CheckOffset(section.PointerToRawData);

			dir = cast(IMAGE_DEBUG_DIRECTORY*)(_view + section.PointerToRawData);
		}
		// Microsoft directory
		else {
			section = FindSection(".rdata");
			if(!section) goto NoDebug;

			смещение = section.PointerToRawData + (va - section.VirtualAddress);
			CheckOffset(смещение);

			dir = cast(IMAGE_DEBUG_DIRECTORY*)(_view + смещение);
		}

		ук end = cast(ук)dir + size;
		Scan: for(; dir < end; dir++) {
			switch(dir.Тип) {
			//case IMAGE_DEBUG_TYPE_COFF:
			case IMAGE_DEBUG_TYPE_CODEVIEW:
			// TODO: support more types
				break Scan;

			default:
			}
		}

		if(dir >= end) goto NoDebug;

		смещение = dir.PointerToRawData + dir.SizeOfData;
		CheckOffset(смещение);
		auto debugView = _view[dir.PointerToRawData .. смещение];

		switch(dir.Тип) {
		//case IMAGE_DEBUG_TYPE_COFF:
		//	return new COFFDebugInfo(debugView);
		case IMAGE_DEBUG_TYPE_CODEVIEW:
			return new CodeViewDebugInfo(debugView);
		default:
			assert(0);
		}

	NoDebug:
		// TODO: we have no debug section or directory, but there csould still
		// be external symbol files we can use.
		return null;
	}

private:

	/**
	 Verify a файл смещение before accessing it
	*/
	проц CheckOffset(дол смещение) {
		if (смещение > _fileSize) throw new PECorruptedException(this);
	}

	ткст							_filename;
	HANDLE							_file;
	HANDLE							_map;
	т_мера							_fileSize;
	бул							_is64;

	union {
		ббайт*				_view;
		IMAGE_DOS_HEADER*	_dos;
	}
	union {
		IMAGE_NT_HEADERS32*	_nt;
		IMAGE_NT_HEADERS64*	_nt64;
	}

	struct RVAEntry {
		бцел start;
		бцел end;
		бцел base;
	}

	RVAEntry[] _rvaTable;
}

/// Thrown if файл open failed.
class PEException : Exception {
	this(ткст msg) {
		super("PEImage: " ~ msg);
	}
}

/// Thrown if not a valid module файл
class PEInvalidException : PEException {
	this(in PEImage img) {
		super("Неверный файл PE.");
	}
}

/// Thrown on corrupted module файл.
class PECorruptedException : PEException {
	this(in PEImage img) {
		super("Повреждённый файл PE.");
	}
}

align(2):
struct IMAGE_DOS_HEADER {
	WORD     e_magic;
	WORD     e_cblp;
	WORD     e_cp;
	WORD     e_crlc;
	WORD     e_cparhdr;
	WORD     e_minalloc;
	WORD     e_maxalloc;
	WORD     e_ss;
	WORD     e_sp;
	WORD     e_csum;
	WORD     e_ip;
	WORD     e_cs;
	WORD     e_lfarlc;
	WORD     e_ovno;
	WORD[4] e_res;
	WORD     e_oemid;
	WORD     e_oeminfo;
	WORD[10] e_res2;
	LONG     e_lfanew;
}

align(4):
struct IMAGE_FILE_HEADER {
	WORD  Machine;
	WORD  NumberOfSections;
	DWORD TimeDateStamp;
	DWORD PointerToSymbolTable;
	DWORD NumberOfSymbols;
	WORD  SizeOfOptionalHeader;
	WORD  Characteristics;
}

struct IMAGE_OPTIONAL_HEADER32 {
	WORD  Magic;
	BYTE  MajorLinkerVersion;
	BYTE  MinorLinkerVersion;
	DWORD SizeOfCode;
	DWORD SizeOfInitializedData;
	DWORD SizeOfUninitializedData;
	DWORD AddressOfEntryPoint;
	DWORD BaseOfCode;
	DWORD BaseOfData;
	DWORD ImageBase;
	DWORD SectionAlignment;
	DWORD FileAlignment;
	WORD  MajorOperatingSystemVersion;
	WORD  MinorOperatingSystemVersion;
	WORD  MajorImageVersion;
	WORD  MinorImageVersion;
	WORD  MajorSubsystemVersion;
	WORD  MinorSubsystemVersion;
	DWORD Win32VersionValue;
	DWORD SizeOfImage;
	DWORD SizeOfHeaders;
	DWORD CheckSum;
	WORD  Subsystem;
	WORD  DllCharacteristics;
	DWORD SizeOfStackReserve;
	DWORD SizeOfStackCommit;
	DWORD SizeOfHeapReserve;
	DWORD SizeOfHeapCommit;
	DWORD LoaderFlags;
	DWORD NumberOfRvaAndSizes;
	IMAGE_DATA_DIRECTORY[IMAGE_NUMBEROF_DIRECTORY_ENTRIES] DataDirectory;
}

alias бдол ULONGLONG;

struct IMAGE_OPTIONAL_HEADER64 {
	WORD      Magic;
	BYTE      MajorLinkerVersion;
	BYTE      MinorLinkerVersion;
	DWORD     SizeOfCode;
	DWORD     SizeOfInitializedData;
	DWORD     SizeOfUninitializedData;
	DWORD     AddressOfEntryPoint;
	DWORD     BaseOfCode;
	ULONGLONG ImageBase;
	DWORD     SectionAlignment;
	DWORD     FileAlignment;
	WORD      MajorOperatingSystemVersion;
	WORD      MinorOperatingSystemVersion;
	WORD      MajorImageVersion;
	WORD      MinorImageVersion;
	WORD      MajorSubsystemVersion;
	WORD      MinorSubsystemVersion;
	DWORD     Win32VersionValue;
	DWORD     SizeOfImage;
	DWORD     SizeOfHeaders;
	DWORD     CheckSum;
	WORD      Subsystem;
	WORD      DllCharacteristics;
	ULONGLONG SizeOfStackReserve;
	ULONGLONG SizeOfStackCommit;
	ULONGLONG SizeOfHeapReserve;
	ULONGLONG SizeOfHeapCommit;
	DWORD     LoaderFlags;
	DWORD     NumberOfRvaAndSizes;
	IMAGE_DATA_DIRECTORY[IMAGE_NUMBEROF_DIRECTORY_ENTRIES] DataDirectory;
}

align(4) struct IMAGE_NT_HEADERS32 {
	DWORD                 Signature;
	IMAGE_FILE_HEADER     FileHeader;
	IMAGE_OPTIONAL_HEADER32 OptionalHeader;
}

align(4) struct IMAGE_NT_HEADERS64 {
	DWORD                 Signature;
	IMAGE_FILE_HEADER     FileHeader;
	IMAGE_OPTIONAL_HEADER64 OptionalHeader;
}

enum  {
	IMAGE_DOS_SIGNATURE    = 0x5A4D,
	IMAGE_OS2_SIGNATURE    = 0x454E,
	IMAGE_OS2_SIGNATURE_LE = 0x454C,
	IMAGE_VXD_SIGNATURE    = 0x454C,
	IMAGE_NT_SIGNATURE     = 0x4550
}

const т_мера
	IMAGE_NUMBEROF_DIRECTORY_ENTRIES =  16,
	IMAGE_SIZEOF_ROM_OPTIONAL_HEADER =  56,
	IMAGE_SIZEOF_STD_OPTIONAL_HEADER =  28,
	IMAGE_SIZEOF_NT_OPTIONAL32_HEADER = 224,
	IMAGE_SIZEOF_NT_OPTIONAL64_HEADER = 240,
	IMAGE_SIZEOF_SHORT_NAME          =   8,
	IMAGE_SIZEOF_SECTION_HEADER      =  40,
	IMAGE_SIZEOF_SYMBOL              =  18,
	IMAGE_SIZEOF_AUX_SYMBOL          =  18,
	IMAGE_SIZEOF_RELOCATION          =  10,
	IMAGE_SIZEOF_BASE_RELOCATION     =   8,
	IMAGE_SIZEOF_LINENUMBER          =   6,
	IMAGE_SIZEOF_ARCHIVE_MEMBER_HDR  =  60,
	SIZEOF_RFPO_DATA                 =  16;

struct IMAGE_DATA_DIRECTORY {
	DWORD VirtualAddress;
	DWORD Size;
}

// IMAGE_OPTIONAL_HEADER.Magic
enum : WORD {
	IMAGE_NT_OPTIONAL_HDR32_MAGIC = 0x010B,
	IMAGE_ROM_OPTIONAL_HDR_MAGIC  = 0x0107,
	IMAGE_NT_OPTIONAL_HDR64_MAGIC = 0x020B
}

struct IMAGE_SECTION_HEADER {
	BYTE[IMAGE_SIZEOF_SHORT_NAME] Name;
	union _Misc {
		DWORD PhysicalAddress;
		DWORD VirtualSize;
	}
	_Misc Misc;
	DWORD VirtualAddress;
	DWORD SizeOfRawData;
	DWORD PointerToRawData;
	DWORD PointerToRelocations;
	DWORD PointerToLinenumbers;
	WORD  NumberOfRelocations;
	WORD  NumberOfLinenumbers;
	DWORD Characteristics;
}

// IMAGE_SECTION_HEADER.Characteristics
const DWORD
	IMAGE_SCN_TYPE_REG               = 0x00000000,
	IMAGE_SCN_TYPE_DSECT             = 0x00000001,
	IMAGE_SCN_TYPE_NOLOAD            = 0x00000002,
	IMAGE_SCN_TYPE_GROUP             = 0x00000004,
	IMAGE_SCN_TYPE_NO_PAD            = 0x00000008,
	IMAGE_SCN_TYPE_COPY              = 0x00000010,
	IMAGE_SCN_CNT_CODE               = 0x00000020,
	IMAGE_SCN_CNT_INITIALIZED_DATA   = 0x00000040,
	IMAGE_SCN_CNT_UNINITIALIZED_DATA = 0x00000080,
	IMAGE_SCN_LNK_OTHER              = 0x00000100,
	IMAGE_SCN_LNK_INFO               = 0x00000200,
	IMAGE_SCN_TYPE_OVER              = 0x00000400,
	IMAGE_SCN_LNK_REMOVE             = 0x00000800,
	IMAGE_SCN_LNK_COMDAT             = 0x00001000,
	IMAGE_SCN_MEM_FARDATA            = 0x00008000,
	IMAGE_SCN_GPREL                  = 0x00008000,
	IMAGE_SCN_MEM_PURGEABLE          = 0x00020000,
	IMAGE_SCN_MEM_16BIT              = 0x00020000,
	IMAGE_SCN_MEM_LOCKED             = 0x00040000,
	IMAGE_SCN_MEM_PRELOAD            = 0x00080000,
	IMAGE_SCN_ALIGN_1BYTES           = 0x00100000,
	IMAGE_SCN_ALIGN_2BYTES           = 0x00200000,
	IMAGE_SCN_ALIGN_4BYTES           = 0x00300000,
	IMAGE_SCN_ALIGN_8BYTES           = 0x00400000,
	IMAGE_SCN_ALIGN_16BYTES          = 0x00500000,
	IMAGE_SCN_ALIGN_32BYTES          = 0x00600000,
	IMAGE_SCN_ALIGN_64BYTES          = 0x00700000,
	IMAGE_SCN_ALIGN_128BYTES         = 0x00800000,
	IMAGE_SCN_ALIGN_256BYTES         = 0x00900000,
	IMAGE_SCN_ALIGN_512BYTES         = 0x00A00000,
	IMAGE_SCN_ALIGN_1024BYTES        = 0x00B00000,
	IMAGE_SCN_ALIGN_2048BYTES        = 0x00C00000,
	IMAGE_SCN_ALIGN_4096BYTES        = 0x00D00000,
	IMAGE_SCN_ALIGN_8192BYTES        = 0x00E00000,
	IMAGE_SCN_LNK_NRELOC_OVFL        = 0x01000000,
	IMAGE_SCN_MEM_DISCARDABLE        = 0x02000000,
	IMAGE_SCN_MEM_NOT_CACHED         = 0x04000000,
	IMAGE_SCN_MEM_NOT_PAGED          = 0x08000000,
	IMAGE_SCN_MEM_SHARED             = 0x10000000,
	IMAGE_SCN_MEM_EXECUTE            = 0x20000000,
	IMAGE_SCN_MEM_READ               = 0x40000000,
	IMAGE_SCN_MEM_WRITE              = 0x80000000;

// ImageDirectoryEntryToDataEx()
enum : USHORT {
	IMAGE_DIRECTORY_ENTRY_EXPORT             =  0,
	IMAGE_DIRECTORY_ENTRY_IMPORT,
	IMAGE_DIRECTORY_ENTRY_RESOURCE,
	IMAGE_DIRECTORY_ENTRY_EXCEPTION,
	IMAGE_DIRECTORY_ENTRY_SECURITY,
	IMAGE_DIRECTORY_ENTRY_BASERELOC,
	IMAGE_DIRECTORY_ENTRY_DEBUG,
	IMAGE_DIRECTORY_ENTRY_COPYRIGHT,      // =  7
	IMAGE_DIRECTORY_ENTRY_ARCHITECTURE       =  7,
	IMAGE_DIRECTORY_ENTRY_GLOBALPTR,
	IMAGE_DIRECTORY_ENTRY_TLS,
	IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG,
	IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT,
	IMAGE_DIRECTORY_ENTRY_IAT,
	IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT,
	IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR, // = 14
}

IMAGE_SECTION_HEADER* IMAGE_FIRST_SECTION32(IMAGE_NT_HEADERS32* h) {
	return cast(IMAGE_SECTION_HEADER*)((cast(ткст0)&h.OptionalHeader) + h.FileHeader.SizeOfOptionalHeader);
}

IMAGE_SECTION_HEADER* IMAGE_FIRST_SECTION64(IMAGE_NT_HEADERS64* h) {
	return cast(IMAGE_SECTION_HEADER*)((cast(ткст0)&h.OptionalHeader) + h.FileHeader.SizeOfOptionalHeader);
}

struct IMAGE_DEBUG_DIRECTORY {
	DWORD Characteristics;
	DWORD TimeDateStamp;
	WORD  MajorVersion;
	WORD  MinorVersion;
	DWORD Тип;
	DWORD SizeOfData;
	DWORD AddressOfRawData;
	DWORD PointerToRawData;
}

enum : DWORD {
	IMAGE_DEBUG_TYPE_UNKNOWN,
	IMAGE_DEBUG_TYPE_COFF,
	IMAGE_DEBUG_TYPE_CODEVIEW,
	IMAGE_DEBUG_TYPE_FPO,
	IMAGE_DEBUG_TYPE_MISC,
	IMAGE_DEBUG_TYPE_EXCEPTION,
	IMAGE_DEBUG_TYPE_FIXUP,
	IMAGE_DEBUG_TYPE_OMAP_TO_SRC,
	IMAGE_DEBUG_TYPE_OMAP_FROM_SRC,
	IMAGE_DEBUG_TYPE_BORLAND // = 9
}

}
