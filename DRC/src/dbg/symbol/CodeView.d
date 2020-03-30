/**
 This module is используется to extract CodeView symbolic debugging information and to
 perform queries upon that information.

 TODO:
	* Add support for CodeView 5.0 and PDB formats.
	* Add support to extract тип information.

 Authors:
	Jeremie Pelletier

 References:
	$(LINK http://www.x86.org/ftp/manuals/tools/sym.pdf)
	$(LINK http://undocumented.rawol.com/sbs-w2k-1-windows-2000-debugging-support.pdf)
	$(LINK http://www.microsoft.com/msj/0399/hood/hood0399.aspx)
	$(LINK http://source.winehq.org/source/include/wine/mscvpdb.h)
	$(LINK http://www.digitalmars.com/d/2.0/abi.html)

 License:
	Public Domain
*/
module dbg.symbol.CodeView;

import dbg.Debug;

class CodeViewDebugInfo : ISymbolicDebugInfo {
	/**
	 Load CodeView данные from the given memory view.
	*/
	this(in проц[] view)
	in {
		assert(view.length && view.ptr);
	}
	body {
		_view = view;

		auto header = cast(CV_HEADER*)_view.ptr;
		CheckOffset(header.смещение);

		// TODO: Only supporting NB09 (CodeView 4.10) right now
		if(!header.signature == CV_SIGNATURE_NB09)
			throw new CodeViewUnsupportedException(this);

		auto dir = cast(CV_DIRECTORY*)(view.ptr + header.смещение);
		if(dir.dirSize != CV_DIRECTORY.sizeof || dir.entrySize != CV_ENTRY.sizeof)
			throw new CodeViewCorruptedException(this);

		CvModule globalModule;
		_modules ~= globalModule;

		foreach(ref e; dir.entries) {
			CheckOffset(e.смещение);

			switch(e.sst) {
			case sstModule:			ParseModule(&e);		break;
			case sstLibraries:		ParseLibraries(&e);		break;
			case sstAlignSym:		ParseAlignSymbols(&e);	break;
			case sstSrcModule:		ParseSrcModule(&e);		break;
			case sstGlobalPub:
			case sstStaticSym:
			case sstGlobalSym:		ParseHashSymbols(&e);	break;
			case sstGlobalTypes:	ParseGlobalTypes(&e);	break;

			// TODO:
			/*case sstFileIndex:
			case sstSegMap:
			case sstSegName:*/

			default:
			}
		}
	}

	/**
	 Get the procedure symbol matching the given address.
	*/
	SymbolInfo ResolveSymbol(т_мера rva) 
	in {
		assert(rva);
	}
	body {
		SymbolInfo symbol;

		foreach(ref m; _modules[0 .. _maxSymModule + 1])
			if(m.symbols.QueryProc(rva, &symbol))
				goto Found;

		foreach(ref m; _modules[0 .. _maxSymModule + 1])
			if(m.symbols.QueryCodeData(rva, &symbol))
				goto Found;

	Found:
		return symbol;
	}

	/**
	 Get the файл/line mapping corresponding to the given relative address.
	*/
	FileLineInfo ResolveFileLine(т_мера rva) 
	in {
		assert(rva);
	}
	body {
		FileLineInfo fileLine;

		if(_maxSrcModule)
			foreach(m; _modules[1 .. _maxSrcModule + 1])
				if(m.src.Query(rva, &fileLine))
					break;

		return fileLine;
	}

private:

	проц ParseModule(in CV_ENTRY* e) {
		auto mod = cast(CV_MODULE*)(_view.ptr + e.смещение);

		if(e.modIndex != _modules.length || mod.style != CV_MOD_STYLE)
			throw new CodeViewCorruptedException(this);

		with(*mod)
		_modules ~= CvModule(overlay, lib, segments, cast(ткст)имя.имя);
	}

	проц ParseLibraries(in CV_ENTRY* e) {
		if(e.modIndex != ushort.max) throw new CodeViewCorruptedException(this);

		auto имя = cast(OMF_NAME*)(_view.ptr + e.смещение);
		auto end = cast(ук)имя + e.size;

		while(имя < end) {
			if(имя.len) _libraries ~= cast(ткст) имя.имя;

			имя = cast(OMF_NAME*)(cast(ук)имя + 1 + имя.len);
		}
	}

	проц ParseAlignSymbols(in CV_ENTRY* e) {
		if(e.modIndex == ushort.max || e.modIndex <= 0 || e.modIndex >= _modules.length)
			throw new CodeViewCorruptedException(this);

		if(e.modIndex > _maxSymModule) _maxSymModule = e.modIndex;

		auto sym = cast(CV_SYMBOL*)(_view.ptr + e.смещение);

		if(sym.header.тип == 0) sym = cast(CV_SYMBOL*)(cast(ук)sym + 4);

		_modules[e.modIndex].symbols.Init(sym, cast(ук)sym + e.size);
	}

	проц ParseHashSymbols(in CV_ENTRY* e) {
		if(e.modIndex != ushort.max) throw new CodeViewCorruptedException(this);

		auto хэш = cast(CV_SYMHASH*)(_view.ptr + e.смещение);
		auto p = cast(ук)хэш + CV_SYMHASH.sizeof;

		_modules[0].symbols.Init(cast(CV_SYMBOL*)p, p + хэш.symInfoSize);
	}

	проц ParseSrcModule(in CV_ENTRY* e) {
		if(e.modIndex == ushort.max || e.modIndex <= 0 || e.modIndex >= _modules.length)
			throw new CodeViewCorruptedException(this);

		if(e.modIndex > _maxSrcModule) _maxSrcModule = e.modIndex;

		auto src = cast(CV_SRCMODULE*)(_view.ptr + e.смещение);

		with(_modules[e.modIndex].src) {
			данные = src;
			fileOffsets = src.fileOffsets;
			codeOffsets = src.codeOffsets;
			segmentIds = src.segmentIds;
		}
	}

	проц ParseGlobalTypes(in CV_ENTRY* e) {
		if(e.modIndex != ushort.max) throw new CodeViewCorruptedException(this);

		// TODO: this currently crash stuff randomly
		/*auto header = cast(CV_GLOBALTYPES*)(_view.ptr + e.смещение);
		_types.Init(header, cast(ук)header + e.size);*/
	}

	проц CheckOffset(цел смещение) {
		if(смещение > _view.length) throw new CodeViewCorruptedException(this);
	}

	проц[]	_view;

	CvModule[]		_modules;
	бцел			_maxSymModule;
	бцел			_maxSrcModule;
	ткст[]		_libraries;
	CvTypes			_types;
}

abstract class CodeViewException : Exception {
	this(ткст msg) {
		super(msg);
	}
}

class CodeViewUnsupportedException : CodeViewException {
	this(in CodeViewDebugInfo cv) {
		super("Эта версия CodeView не поддерживается.");
	}
}

class CodeViewCorruptedException : CodeViewException {
	this(in CodeViewDebugInfo cv) {
		super("Повреждённые данные CodeView.");
	}
}

private:
alias цел cmp_t;
бцел BinarySearch(cmp_t delegate(бцел i) dg, бцел low, бцел high) {
	if(high < low) return бцел.max;

	бцел mid = low + ((high - low) / 2);
	cmp_t cmp = dg(mid);

	if(cmp > 0) return BinarySearch(dg, low, mid - 1);
	if(cmp < 0) return BinarySearch(dg, mid + 1, high);
	return mid;
}

бцел BinarySearch(in бцел[] a, бцел значение, бцел low, бцел high) {
	if(high < low) return бцел.max;

	бцел mid = low + ((high - low) / 2);

	if(a[mid] > значение) return BinarySearch(a, значение, low, mid - 1);
	if(a[mid] < значение) return BinarySearch(a, значение, mid + 1, high);
	return mid;
}

struct CvModule {
	ushort			overlay;
	ushort			lib;
	CV_SEGMENT[]	segments;
	ткст			имя;

	CvSymbols		symbols;
	CvSrcModule		src;
}

struct CvSymbols {
	ббайт		compileMachine;
	ббайт		compileLanguage;
	ushort		compileFlags;
	ткст		compileName;
	ushort		segment;

	CvProc[]	procSymbols;
	CvData[]	codeSymbols;

	проц Init(CV_SYMBOL* sym, in ук end) {
		цел i = 0;
		while(sym < end && i < 100) {
			++i;
			switch(sym.header.тип) {
			case S_COMPILE_V1:
				with(sym.compile_v1) {
					compileMachine = machine;
					compileLanguage = language;
					compileFlags = flags;
					compileName = cast(ткст) имя.имя;
				}
				break;

			case S_SSEARCH_V1:
				if(!segment) segment = sym.ssearch.segment;
				break;

			case S_UDT_V1:
				break;

			case S_BPREL_V1:
				break;

			case S_LDATA_V1:
			case S_GDATA_V1:
			case S_PUB_V1:
				CvData данные = проц;

				with(sym.data_v1) {
					// TODO: its bad to assume 2 to always be the only code segment!
					if(segment != 2) break;

					данные.смещение = смещение;
					данные.имя = cast(ткст) имя.имя;
				}

				codeSymbols ~= данные;
				break;

			case S_LPROC_V1:
			case S_GPROC_V1:
				CvProc proc = проц;

				with(sym.proc_v1) {
					proc.смещение = смещение;
					proc.length = procLength;
					proc.имя = cast(ткст) имя.имя;
				}

				procSymbols ~= proc;
				break;

			case S_PROCREF_V1:
			case S_DATAREF_V1:
			case S_ALIGN_V1:
				break;

			case S_END_V1:
			case S_ENDARG_V1:
			case S_RETURN_V1:
				break;

			default:
			}

			sym = cast(CV_SYMBOL*)(cast(ук)sym + sym.header.size + 2);
		}

		codeSymbols.sort;
	}

	бул QueryProc(бцел rva, SymbolInfo* symbol) {
		if(!procSymbols.length) return нет;

		cmp_t CmpProc(бцел i) {
			if(i >= procSymbols.length) return 0;

			бцел смещение = procSymbols[i].смещение;
			if(смещение > rva) return 1;
			if(смещение + procSymbols[i].length < rva) return -1;
			return 0;
		}

		бцел index = BinarySearch(&CmpProc, 0, procSymbols.length - 1);

		if(index < procSymbols.length) with(procSymbols[index]) {
			symbol.имя = имя.dup;
			symbol.смещение = rva - смещение;
			return да;
		}

		return нет;
	}

	бул QueryCodeData(бцел rva, SymbolInfo* symbol) {
		if(!codeSymbols.length) return нет;

		cmp_t CmpData(бцел i) {
			if(i >= codeSymbols.length) return 0;

			if(codeSymbols[i].смещение > rva) return 1;
			if(i + 1 != codeSymbols.length && codeSymbols[i + 1].смещение < rva) return -1;
			return 0;
		}

		бцел index = BinarySearch(&CmpData, 0, codeSymbols.length - 1);

		if(index < codeSymbols.length) with(codeSymbols[index]) {
			symbol.имя = имя.dup;
			symbol.смещение = rva - смещение;
			return да;
		}

		return нет;
	}
}

struct CvProc {
	бцел	смещение;
	бцел	length;
	ткст	имя;
}

struct CvData {
	бцел смещение;
	ткст имя;

	cmp_t opCmp(ref CvData данные)  {
		if(данные.смещение < смещение) return -1;
		return данные.смещение > смещение;
	}
}

struct CvSrcModule {
	бул Query(бцел rva, FileLineInfo* fileLine) {
		if(!codeOffsets.length || rva < codeOffsets[0][0] || rva > codeOffsets[$ - 1][1])
			return нет;

		бцел fIndex;

		// Get the следщ CV_SRCFILE record having rva within it's code range
		// The code offsets here may overlap over файл records, we have to walk
		// through them and possibly keep walking if the следщ section doesn't
		// найди a matching line record.
	NextFile:
		if(fIndex == fileOffsets.length) return нет;

		CV_SRCFILE* srcFile = cast(CV_SRCFILE*)(данные + fileOffsets[fIndex++]);
		бцел[2][] offsets = srcFile.codeOffsets;

		if(rva < offsets[0][0] || rva > offsets[$ - 1][1])
			goto NextFile;

		CV_SRCSEGMENT* srcSeg;

		// Address is possibly within this файл, now get the CV_SEGMENT record.
		cmp_t CmpFile(бцел i) {
			if(i >= offsets.length) return 0;

			if(offsets[i][0] > rva) return 1;
			if(offsets[i][1] < rva) return -1;

			srcSeg = cast(CV_SRCSEGMENT*)(данные + srcFile.lineOffsets[i]);
			return 0;
		}

		// Ignore the return значение from BinarySearch, if CmpSegment matched, we
		// already have srcSeg set. In some rare cases there may not be a
		// matching segment record even if the файл's segment range said so.
		BinarySearch(&CmpFile, 0, offsets.length - 1);
		if(!srcSeg) goto NextFile;

		// Finally look within the segment's offsets for a matching record.
		бцел[] segOffsets = srcSeg.offsets;
		ushort[] lineNumbers = srcSeg.lineNumbers;

		cmp_t CmpSegment(бцел i) {
			if(i >= segOffsets.length) return 0;

			if(segOffsets[i] > rva) return 1;
			if(i + 1 < segOffsets.length && segOffsets[i + 1] < rva) return -1;

			return 0;
		}

		бцел sIndex = BinarySearch(&CmpSegment, 0, segOffsets.length - 1);
		if(sIndex >= lineNumbers.length) goto NextFile;

		// Found our record
		fileLine.файл = srcFile.имя.имя.dup;
		fileLine.line = srcSeg.lineNumbers[sIndex];

		return да;
	}

	ук		данные;
	бцел[]		fileOffsets;
	бцел[2][]	codeOffsets;
	ushort[]		segmentIds;
}

// TODO!
struct CvTypes {
	проц Init(in CV_GLOBALTYPES* gtypes, in ук end) {
		debug(CodeView) TraceA("CvTypes[%p].Init(gtypes=%p, end=%p)",
			&this, gtypes, end);

		offsets = gtypes.typeOffsets[0 .. gtypes.nTypes].dup;

		ук dataStart = gtypes.types;
		данные = dataStart[0 .. end - dataStart].dup;
	}

	проц GetType(ushort index) {
		/+
		CheckOffset(typeOffsets[index]);

		CV_TYPE* тип = cast(CV_TYPE*)(p + typeOffsets[i]);

		switch(тип.header.тип) {
		case LF_MODIFIER_V1:
			break;

		case LF_POINTER_V1:
			break;

		case LF_ARRAY_V1:
			break;

		case LF_CLASS_V1:
			break;

		case LF_STRUCTURE_V1:
			break;

		case LF_UNION_V1:
			break;

		case LF_ENUM_V1:
			break;

		case LF_PROCEDURE_V1:
			break;

		case LF_MFUNCTION_V1:
			break;

		case LF_VTSHAPE_V1:
			break;

		case LF_OEM_V1:
			with(тип.oem_v1) {
				// Ignore unknown OEMs
				if(oem != OEM_DIGITALMARS || nIndices != 2) break;

				switch(rec) {
				case D_DYN_ARRAY:
					break;

				case D_ASSOC_ARRAY:
					break;

				case D_DELEGATE:
					break;

				default:
				}
			}
			break;

		case LF_ARGLIST_V1:
			break;

		case LF_FIELDLIST_V1:
			break;

		case LF_DERIVED_V1:
			break;

		case LF_METHODLIST_V1:
			break;

		default:
			TraceA("New leaf %x", cast(бцел)тип.header.тип);
			Pause;
		}
		+/
	}

	бцел[]	offsets;
	проц[]	данные;
}

// ----------------------------------------------------------------------------
// O M F  S t r u c t u r e s
// ----------------------------------------------------------------------------

align(1):

/**
 Packed variant header
*/
struct OMF_HEADER {
	short size;
	short тип;
}

/**
 Packed имя, may be 0 padded to maintain alignment
*/
struct OMF_NAME {
	ббайт len;
	//сим[1] имя;

	ткст имя()  {
		return (cast(ткст0)(&len + 1))[0 .. len];
	}
}

// ----------------------------------------------------------------------------
// C o d e V i e w  C o m m o n  S t r u c t u r e s
// ----------------------------------------------------------------------------

/**
 Version signatures
*/
enum : бцел {
	CV_SIGNATURE_NB09	= 0x3930424E,	/// CodeView 4.10
	CV_SIGNATURE_NB11	= 0x3131424E,	/// CodeView 5.0
	CV_SIGNATURE_NB10	= 0x3130424E,	/// CodeView PDB 2.0
	CV_SIGNATURE_RSDS	= 0x53445352	/// CodeView PDB 7.0
}

/**
 SubSection Types
*/
enum : ushort {
	sstModule 		= 0x0120,
	sstTypes 		= 0x0121,
	sstPublic 		= 0x0122,
	sstPublicSym 	= 0x0123,
	sstSymbols 		= 0x0124,
	sstAlignSym 	= 0x0125,
	sstSrcLnSeg 	= 0x0126,
	sstSrcModule 	= 0x0127,
	sstLibraries 	= 0x0128,
	sstGlobalSym 	= 0x0129,
	sstGlobalPub 	= 0x012A,
	sstGlobalTypes 	= 0x012B,
	sstMPC 			= 0x012C,
	sstSegMap 		= 0x012D,
	sstSegName 		= 0x012E,
	sstPreComp 		= 0x012F,
	sstPreCompMap 	= 0x0130,
	sstOffsetMap16 	= 0x0131,
	sstOffsetMap32 	= 0x0132,
	sstFileIndex 	= 0x0133,
	sstStaticSym 	= 0x0134
}

/**
 Header используется with "NB09" and "NB11"
*/
struct CV_HEADER {
	бцел	signature;
	цел		смещение;
}

/**
 Header используется with "NB10"
*/
struct CV_HEADER_NB10 {
	бцел			signature;
	цел				смещение;
	бцел			timestamp;
	бцел			age;
	OMF_NAME		имя;
}

/**
 Header используется with "RSDS"
*/
/*struct CV_HEADER_RSDS {
	бцел			signature;
	GUID			guid;
	бцел			age;
	OMF_NAME		имя;
}*/

/**
 Directory header
*/
struct CV_DIRECTORY {
	ushort			dirSize;
	ushort			entrySize;
	бцел			nEntries;
	цел				смещение;
	бцел			flags;
	//CV_ENTRY[1]	entries;

	CV_ENTRY[] entries() {
		return (cast(CV_ENTRY*)(&this + 1))[0 .. nEntries];
	}
}

/**
 Subsection record
*/
struct CV_ENTRY {
	ushort			sst;
	ushort			modIndex;
	цел				смещение;
	бцел			size;
}

// ----------------------------------------------------------------------------
// sstModule
// ----------------------------------------------------------------------------

/**
 Module style, always "CV"
*/
const CV_MOD_STYLE = 0x5643;

/**
 Module
*/
struct CV_MODULE {
	ushort			overlay;
	ushort			lib;
	ushort			nSegments;
	ushort			style;
	//CV_SEGMENT[1]	segments;
	//OMF_NAME		имя;

	CV_SEGMENT[] segments()  {
		return (cast(CV_SEGMENT*)(&style + 1))[0 .. nSegments];
	}

	OMF_NAME имя()  {
		return *cast(OMF_NAME*)(cast(ук)segments + nSegments * CV_SEGMENT.sizeof);
	}
}

/**
 Module segment
*/
struct CV_SEGMENT {
	ushort			segIndex;
	ushort			padding;
	бцел			смещение;
	бцел			size;
}

// ----------------------------------------------------------------------------
// sstGlobalPub, sstStaticSym, sstGlobalSym, sstAlignSym
// ----------------------------------------------------------------------------

/**
 Symbol IDs, используется by CV_SYMBOL.header.тип
*/
enum : ushort {
	S_COMPILE_V1	= 0x0001,
	S_REGISTER_V1	= 0x0002,
	S_CONSTANT_V1	= 0x0003,
	S_UDT_V1		= 0x0004,
	S_SSEARCH_V1	= 0x0005,
	S_END_V1		= 0x0006,
	S_SKIP_V1		= 0x0007,
	S_CVRESERVE_V1	= 0x0008,
	S_OBJNAME_V1	= 0x0009,
	S_ENDARG_V1		= 0x000A,
	S_COBOLUDT_V1	= 0x000B,
	S_MANYREG_V1	= 0x000C,
	S_RETURN_V1		= 0x000D,
	S_ENTRYTHIS_V1	= 0x000E,

	S_BPREL_V1 		= 0x0200,
	S_LDATA_V1 		= 0x0201,
	S_GDATA_V1 		= 0x0202,
	S_PUB_V1 		= 0x0203,
	S_LPROC_V1 		= 0x0204,
	S_GPROC_V1 		= 0x0205,
	S_THUNK_V1 		= 0x0206,
	S_BLOCK_V1 		= 0x0207,
	S_WITH_V1 		= 0x0208,
	S_LABEL_V1 		= 0x0209,
	S_CEXMODEL_V1 	= 0x020A,
	S_VFTPATH_V1 	= 0x020B,
	S_REGREL_V1 	= 0x020C,
	S_LTHREAD_V1 	= 0x020D,
	S_GTHREAD_V1 	= 0x020E,

	S_PROCREF_V1	= 0x0400,
	S_DATAREF_V1	= 0x0401,
	S_ALIGN_V1		= 0x0402,
	S_LPROCREF_V1	= 0x0403,

	// Variants with 32bit тип indices
	S_REGISTER_V2	= 0x1001,	/// CV_REGISTER_V2
	S_CONSTANT_V2	= 0x1002,	/// CV_CONSTANT_V2
	S_UDT_V2		= 0x1003,	/// CV_UDT_V2
	S_COBOLUDT_V2	= 0x1004,
	S_MANYREG_V2	= 0x1005,
	S_BPREL_V2		= 0x1006,	/// CV_BPREL_V2
	S_LDATA_V2		= 0x1007,	/// CV_DATA_V2
	S_GDATA_V2		= 0x1008,	/// CV_DATA_V2
	S_PUB_V2		= 0x1009,	/// CV_DATA_V2
	S_LPROC_V2		= 0x100A,	/// CV_PROC_V2
	S_GPROC_V2		= 0x100B,	/// CV_PROC_V2
	S_VFTTABLE_V2	= 0x100C,
	S_REGREL_V2		= 0x100D,
	S_LTHREAD_V2	= 0x100E,
	S_GTHREAD_V2	= 0x100F,
	S_FUNCINFO_V2	= 0x1012,
	S_COMPILAND_V2	= 0x1013,	/// CV_COMPILE_V2

	S_COMPILAND_V3	= 0x1101,
	S_THUNK_V3		= 0x1102,
	S_BLOCK_V3		= 0x1103,
	S_LABEL_V3		= 0x1105,
	S_REGISTER_V3	= 0x1106,
	S_CONSTANT_V3	= 0x1107,
	S_UDT_V3		= 0x1108,
	S_BPREL_V3		= 0x110B,
	S_LDATA_V3		= 0x110C,
	S_GDATA_V3		= 0x110D,
	S_PUB_V3		= 0x110E,
	S_LPROC_V3		= 0x110F,
	S_GPROC_V3		= 0x1110,
	S_BPREL_XXXX_V3	= 0x1111,  /* not really understood, but looks like bprel... */
	S_MSTOOL_V3		= 0x1116,  /* compiler command line опции and build information */
	S_PUB_FUNC1_V3	= 0x1125,  /* didn't get the difference between the two */
	S_PUB_FUNC2_V3	= 0x1127,
	S_SECTINFO_V3	= 0x1136,
	S_SUBSECTINFO_V3= 0x1137,
	S_ENTRYPOINT_V3	= 0x1138,
	S_SECUCOOKIE_V3	= 0x113A,
	S_MSTOOLINFO_V3	= 0x113C,
	S_MSTOOLENV_V3	= 0x113D
}

/**
 Packed symbols header
*/
struct CV_SYMHASH {
	ushort			symIndex;
	ushort			addrIndex;
	бцел			symInfoSize;
	бцел			symHashSize;
	бцел			addrHashSize;
}

/**
 Symbol variant record
*/
struct CV_SYMBOL {
	OMF_HEADER			header;
	union {
		CV_COMPILE_V1	compile_v1;
		CV_COMPILE_V2	compile_v2;
		CV_REGISTER_V1	register_v1;
		CV_REGISTER_V2	register_v2;
		CV_CONSTANT_V1	constant_v1;
		CV_CONSTANT_V2	constant_v2;
		CV_UDT_V1		udt_v1;
		CV_UDT_V2		udt_v2;
		CV_SSEARCH		ssearch;
		CV_STACK_V1		stack_v1;
		CV_STACK_V2		stack_v2;
		CV_DATA_V1		data_v1;
		CV_DATA_V2		data_v2;
		CV_PROC_V1		proc_v1;
		CV_PROC_V2		proc_v2;
		CV_THUNK		thunk;
		CV_BLOCK		block;
		CV_LABEL		label;
	}
}

/**
 Compiler information symbol
*/
struct CV_COMPILE_V1 {
	ббайт			machine;
	ббайт			language;
	ushort			flags;
	OMF_NAME		имя;
}
struct CV_COMPILE_V2 {
	бцел[4]			unknown1;
	ushort			unknown2;
	OMF_NAME		имя;
}

/**
 Register данные symbol
*/
struct CV_REGISTER_V1 {
	ushort			typeIndex;
	ushort			reg;
	OMF_NAME		имя;
}
struct CV_REGISTER_V2 {
	бцел			typeIndex;
	ushort			reg;
	OMF_NAME		имя;
}

/**
 Constant данные symbol
*/
struct CV_CONSTANT_V1 {
	ushort			typeIndex;
	ushort			значение;
	OMF_NAME		имя;
}
struct CV_CONSTANT_V2 {
	бцел			typeIndex;
	ushort			значение;
	OMF_NAME		имя;
}

/**
 User defined тип Symbol
*/
struct CV_UDT_V1 {
	ushort			typeIndex;
	OMF_NAME		имя;
}
struct CV_UDT_V2 {
	бцел			typeIndex;
	OMF_NAME		имя;
}

/**
 Start of Search symbol
*/
struct CV_SSEARCH {
	бцел			смещение;
	ushort			segment;
}

/**
 Object имя symbol
*/
struct CV_OBJNAME {
	бцел			signature;
	OMF_NAME		имя;
}

/**
 Stack данные symbol
*/
struct CV_STACK_V1 {
	бцел			смещение;
	ushort			typeIndex;
	OMF_NAME		имя;
}
struct CV_STACK_V2 {
	бцел			смещение;
	бцел			typeIndex;
	OMF_NAME		имя;
}

/**
 Data symbol
*/
struct CV_DATA_V1 {
	бцел			смещение;
	short			segment;
	short			typeIndex;
	OMF_NAME		имя;
}
struct CV_DATA_V2 {
	бцел			typeIndex;
	бцел			смещение;
	short			segment;
	OMF_NAME		имя;
}

/**
 Procedure symbol
*/
struct CV_PROC_V1 {
	бцел			родитель;
	бцел			end;
	бцел			следщ;
	бцел			procLength;
	бцел			dbgStart;
	бцел			dbgEnd;
	бцел			смещение;
	ushort			segment;
	ushort			procType;
	ббайт			flags;
	OMF_NAME		имя;
}
struct CV_PROC_V2 {
	бцел			родитель;
	бцел			end;
	бцел			следщ;
	бцел			procLength;
	бцел			dbgStart;
	бцел			dbgEnd;
	бцел			procType;
	бцел			смещение;
	ushort			segment;
	ббайт			flags;
	OMF_NAME		имя;
}

/**
 Thunk symbol
*/
struct CV_THUNK {
	бцел 			родитель;
	бцел			end;
	бцел			следщ;
	бцел			смещение;
	ushort			segment;
	ushort			size;
	ббайт			тип;
	OMF_NAME		имя;
}

/**
 Block symbol
*/
struct CV_BLOCK {
	бцел			родитель;
	бцел			end;
	бцел			length;
	бцел			смещение;
	ushort			segment;
	OMF_NAME		имя;
}

/**
 Label symbol
*/
struct CV_LABEL {
	бцел			смещение;
	ushort			segment;
	ббайт			flags;
	OMF_NAME		имя;
}

// ----------------------------------------------------------------------------
// sstSrcModule
// ----------------------------------------------------------------------------

/**
 Source module header
*/
struct CV_SRCMODULE {
	ushort			nFiles;			/// number of CV_SRCFILE records
	ushort			nSegments;		/// number of segments in module
	//бцел[]		fileOffsets;
	//бцел[2][]		codeOffsets;
	//ushort[]		segmentIds;

	/// массив of offsets to every CV_SRCFILE record
	бцел[] fileOffsets()  {
		return (cast(бцел*)(&nSegments + 1))[0 .. nFiles];
	}

	/// массив of segment start/end pairs, length = nSegments
	бцел[2][] codeOffsets()  {
		return (cast(бцел[2]*)(cast(ук)fileOffsets + nFiles * бцел.sizeof))[0 .. nSegments];
	}

	/// массив of linker indices, length = nSegments
	ushort[] segmentIds()  {
		return (cast(ushort*)(cast(ук)codeOffsets + nSegments * (бцел[2]).sizeof))[0 .. nSegments];
	}
}

/**
 Source файл record
*/
struct CV_SRCFILE {
	ushort			nSegments;		/// number of CV_SRCSEGMENT records
	ushort			reserved;
	//бцел[]		lineOffsets;
	//бцел[2][]		codeOffsets;
	//OMF_NAME		имя;

	// массив of offsets to every CV_SRCSEGMENT record, length = nSegments
	бцел[] lineOffsets()  {
		return (cast(бцел*)(&reserved + 1))[0 .. nSegments];
	}

	/// массив of segment start/end pairs, length = nSegments
	бцел[2][] codeOffsets()  {
		return (cast(бцел[2]*)(cast(ук)lineOffsets + nSegments * бцел.sizeof))[0 .. nSegments];
	}

	/// имя of файл padded to дол boundary
	OMF_NAME* имя()  {
		return cast(OMF_NAME*)(cast(ук)codeOffsets + nSegments * (бцел[2]).sizeof);
	}
}

/**
 Source segment record
*/
struct CV_SRCSEGMENT {
	ushort			segment;		/// linker segment index
	ushort			nPairs;			/// count of line/смещение pairs
	//бцел[]		offsets;
	//ushort[]		lineNumbers;

	/// массив of offsets in segment, length = nPairs
	бцел[] offsets()  {
		return (cast(бцел*)(&nPairs + 1))[0 .. nPairs];
	}

	/// массив of line lumber in source, length = nPairs
	ushort[] lineNumbers()  {
		return (cast(ushort*)(cast(ук)offsets + nPairs * бцел.sizeof))[0 .. nPairs];
	}
}

// ----------------------------------------------------------------------------
// sstGlobalTypes
// ----------------------------------------------------------------------------

/**
 Basic types

 Official MS documentation says that тип (< 0x4000, so 12 bits) is made of:

 +----------+------+------+----------+------+
 |    11    | 10-8 | 7-4  |     3    | 2-0  |
 +----------+------+------+----------+------+
 | reserved | mode | тип | reserved | size |
 +----------+------+------+----------+------+
*/

/**
 Basic тип: Тип bits
*/
enum : ббайт {
	T_SPECIAL_BITS		= 0x00,	/// Special
	T_SIGNED_BITS		= 0x10, /// Signed integral значение
	T_UNSIGNED_BITS		= 0x20, /// Unsigned integral значение
	T_BOOLEAN_BITS		= 0x30, /// Boolean
	T_REAL_BITS			= 0x40, /// Real
	T_COMPLEX_BITS		= 0x50, /// Complex
	T_SPECIAL2_BITS		= 0x60, /// Special2
	T_INT_BITS			= 0x70, /// Real цел значение
}

/**
 Basic тип: Size bits
*/
enum : ббайт {
	// Special types
	T_NOTYPE_BITS		= 0x00, /// No тип
	T_ABS_BITS			= 0x01, /// Absolute symbol
	T_SEGMENT_BITS		= 0x02, /// Segment
	T_VOID_BITS			= 0x03, /// Void
	T_CURRENCY_BITS		= 0x04, /// Basic 8-byte currency значение
	T_NBASICSTR_BITS	= 0x05, /// Near Basic ткст
	T_FBASICSTR_BITS	= 0x06, /// Far Basic ткст
	T_NOTRANS_BITS		= 0x07, /// Untranslated тип from previous Microsoft symbol formats

	// Signed/Unsigned/Boolean types
	T_INT08_BITS		= 0x00, /// 1 byte
	T_INT16_BITS		= 0x01, /// 2 byte
	T_INT32_BITS		= 0x02, /// 4 byte
	T_INT64_BITS		= 0x03, /// 8 byte

	// Real/Complex types
	T_REAL32_BITS		= 0x00, /// 32 bit
	T_REAL64_BITS		= 0x01, /// 64 bit
	T_REAL80_BITS		= 0x02, /// 80 bit
	T_REAL128_BITS		= 0x03, /// 128 bit
	T_REAL48_BITS		= 0x04, /// 48 bit

	// Special2 types
	T_BIT_BITS			= 0x00, /// Bit
	T_PASCHAR_BITS		= 0x01, /// Pascal CHAR

	// Real Int types
	T_CHAR_BITS			= 0x00, /// Char
	T_WCHAR_BITS		= 0x01, /// Wide character
	T_INT2_BITS			= 0x02, /// 2-byte signed integer
	T_UINT2_BITS		= 0x03, /// 2-byte unsigned integer
	T_INT4_BITS			= 0x04, /// 4-byte signed integer
	T_UINT4_BITS		= 0x05, /// 4-byte unsigned integer
	T_INT8_BITS			= 0x06, /// 8-byte signed integer
	T_UINT8_BITS		= 0x07, /// 8-byte unsigned integer
	T_DCHAR_BITS		= 0x08, /// dchar, DigitalMars D extension
}

/**
 Basic тип: Mode bits
*/
enum : ushort {
	T_DIRECT_BITS		= 0x0000, /// Direct; not a pointer
	T_NEARPTR_BITS		= 0x0100, /// Near pointer
	T_FARPTR_BITS		= 0x0200, /// Far pointer
	T_HUGEPTR_BITS		= 0x0300, /// Huge pointer
	T_NEAR32PTR_BITS	= 0x0400, /// 32-bit near pointer
	T_FAR32PTR_BITS		= 0x0500, /// 32-bit far pointer
	T_NEAR64PTR_BITS	= 0x0600, /// 64-bit near pointer
}

/**
 Basic тип bit masks
*/
enum : ushort {
	T_TYPE_MASK			= 0x00F0, /// тип тип mask (данные treatment mode)
	T_SIZE_MASK			= 0x000F, /// тип size mask (depends on 'тип' значение)
	T_MODE_MASK			= 0x0700, /// тип mode mask (ptr/non-ptr)
}

/**
 Leaf types, используется by CV_TYPE.header.тип
*/
enum : ushort {
	// Can be referenced from symbols
	LF_MODIFIER_V1		= 0x0001,
	LF_POINTER_V1		= 0x0002,
	LF_ARRAY_V1			= 0x0003,
	LF_CLASS_V1			= 0x0004,
	LF_STRUCTURE_V1		= 0x0005,
	LF_UNION_V1			= 0x0006,
	LF_ENUM_V1			= 0x0007,
	LF_PROCEDURE_V1		= 0x0008,
	LF_MFUNCTION_V1		= 0x0009,
	LF_VTSHAPE_V1		= 0x000A,
	LF_COBOL0_V1		= 0x000B,
	LF_COBOL1_V1		= 0x000C,
	LF_BARRAY_V1		= 0x000D,
	LF_LABEL_V1			= 0x000E,
	LF_NULL_V1			= 0x000F,
	LF_NOTTRAN_V1		= 0x0010,
	LF_DIMARRAY_V1		= 0x0011,
	LF_VFTPATH_V1		= 0x0012,
	LF_PRECOMP_V1		= 0x0013,
	LF_ENDPRECOMP_V1	= 0x0014,
	LF_OEM_V1			= 0x0015,
	LF_TYPESERVER_V1	= 0x0016,

	LF_MODIFIER_V2		= 0x1001,
	LF_POINTER_V2		= 0x1002,
	LF_ARRAY_V2			= 0x1003,
	LF_CLASS_V2			= 0x1004,
	LF_STRUCTURE_V2		= 0x1005,
	LF_UNION_V2			= 0x1006,
	LF_ENUM_V2			= 0x1007,
	LF_PROCEDURE_V2		= 0x1008,
	LF_MFUNCTION_V2		= 0x1009,
	LF_COBOL0_V2		= 0x100A,
	LF_BARRAY_V2		= 0x100B,
	LF_DIMARRAY_V2		= 0x100C,
	LF_VFTPATH_V2		= 0x100D,
	LF_PRECOMP_V2		= 0x100E,
	LF_OEM_V2			= 0x100F,

	// Can be referenced from other тип records
	LF_SKIP_V1			= 0x0200,
	LF_ARGLIST_V1		= 0x0201,
	LF_DEFARG_V1		= 0x0202,
	LF_LIST_V1			= 0x0203,
	LF_FIELDLIST_V1		= 0x0204,
	LF_DERIVED_V1		= 0x0205,
	LF_BITFIELD_V1		= 0x0206,
	LF_METHODLIST_V1	= 0x0207,
	LF_DIMCONU_V1		= 0x0208,
	LF_DIMCONLU_V1		= 0x0209,
	LF_DIMVARU_V1		= 0x020A,
	LF_DIMVARLU_V1		= 0x020B,
	LF_REFSYM_V1		= 0x020C,

	LF_SKIP_V2			= 0x1200,
	LF_ARGLIST_V2		= 0x1201,
	LF_DEFARG_V2		= 0x1202,
	LF_FIELDLIST_V2		= 0x1203,
	LF_DERIVED_V2		= 0x1204,
	LF_BITFIELD_V2		= 0x1205,
	LF_METHODLIST_V2	= 0x1206,
	LF_DIMCONU_V2		= 0x1207,
	LF_DIMCONLU_V2		= 0x1208,
	LF_DIMVARU_V2		= 0x1209,
	LF_DIMVARLU_V2		= 0x120A,

	// Field lists
	LF_BCLASS_V1		= 0x0400,
	LF_VBCLASS_V1		= 0x0401,
	LF_IVBCLASS_V1		= 0x0402,
	LF_ENUMERATE_V1		= 0x0403,
	LF_FRIENDFCN_V1		= 0x0404,
	LF_INDEX_V1			= 0x0405,
	LF_MEMBER_V1		= 0x0406,
	LF_STMEMBER_V1		= 0x0407,
	LF_METHOD_V1		= 0x0408,
	LF_NESTTYPE_V1		= 0x0409,
	LF_VFUNCTAB_V1		= 0x040A,
	LF_FRIENDCLS_V1		= 0x040B,
	LF_ONEMETHOD_V1		= 0x040C,
	LF_VFUNCOFF_V1		= 0x040D,
	LF_NESTTYPEEX_V1	= 0x040E,
	LF_MEMBERMODIFY_V1	= 0x040F,

	LF_BCLASS_V2		= 0x1400,
	LF_VBCLASS_V2		= 0x1401,
	LF_IVBCLASS_V2		= 0x1402,
	LF_FRIENDFCN_V2		= 0x1403,
	LF_INDEX_V2			= 0x1404,
	LF_MEMBER_V2		= 0x1405,
	LF_STMEMBER_V2		= 0x1406,
	LF_METHOD_V2		= 0x1407,
	LF_NESTTYPE_V2		= 0x1408,
	LF_VFUNCTAB_V2		= 0x1409,
	LF_FRIENDCLS_V2		= 0x140A,
	LF_ONEMETHOD_V2		= 0x140B,
	LF_VFUNCOFF_V2		= 0x140C,
	LF_NESTTYPEEX_V2	= 0x140D,

	LF_ENUMERATE_V3		= 0x1502,
	LF_ARRAY_V3			= 0x1503,
	LF_CLASS_V3			= 0x1504,
	LF_STRUCTURE_V3		= 0x1505,
	LF_UNION_V3			= 0x1506,
	LF_ENUM_V3			= 0x1507,
	LF_MEMBER_V3		= 0x150D,
	LF_STMEMBER_V3		= 0x150E,
	LF_METHOD_V3		= 0x150F,
	LF_NESTTYPE_V3		= 0x1510,
	LF_ONEMETHOD_V3		= 0x1511,

	// Numeric leaf types
	LF_NUMERIC			= 0x8000,
	LF_CHAR				= 0x8000,
	LF_SHORT			= 0x8001,
	LF_USHORT			= 0x8002,
	LF_LONG				= 0x8003,
	LF_ULONG			= 0x8004,
	LF_REAL32			= 0x8005,
	LF_REAL64			= 0x8006,
	LF_REAL80			= 0x8007,
	LF_REAL128			= 0x8008,
	LF_QUADWORD			= 0x8009,
	LF_UQUADWORD		= 0x800A,
	LF_REAL48			= 0x800B,
	LF_COMPLEX32		= 0x800C,
	LF_COMPLEX64		= 0x800D,
	LF_COMPLEX80		= 0x800E,
	LF_COMPLEX128		= 0x800F,
	LF_VARSTRING		= 0x8010,
	LF_DCHAR			= 0x8011
}

/**
 Global types header
*/
struct CV_GLOBALTYPES {
	ббайт[3]		unused;
	ббайт			flags;
	бцел			nTypes;
	//бцел[1]		typeOffsets;
	//CV_TYPE[1]	types;

	/// массив of offsets to CV_TYPE records
	бцел* typeOffsets()  {
		return cast(бцел*)(&nTypes + 1);
	}

	// Get the first CV_TYPE record
	CV_TYPE* types()  {
		return cast(CV_TYPE*)(cast(ук)(&nTypes + 1) + nTypes * бцел.sizeof);
	}
}

/**
 Тип variant record
*/
struct CV_TYPE {
	OMF_HEADER			header;
	union {
		// Types
		CV_MODIFIER_V1	modifier_v1;
		CV_MODIFIER_V2	modifier_v2;
		CV_POINTER_V1	pointer_v1;
		CV_POINTER_V2	pointer_v2;
		CV_ARRAY_V1		array_v1;
		CV_ARRAY_V2		array_v2;
		CV_STRUCT_V1	struct_v1;
		CV_STRUCT_V2	struct_v2;
		CV_UNION_V1		union_v1;
		CV_UNION_V2		union_v2;
		CV_ENUM_V1		enum_v1;
		CV_ENUM_V2		enum_v2;
		CV_PROCEDURE_V1	proc_v1;
		CV_PROCEDURE_V2	proc_v2;
		CV_MFUNCTION_V1	method_v1;
		CV_MFUNCTION_V2	method_v2;
		CV_OEM_V1		oem_v1;
		CV_OEM_V2		oem_v2;

		// Referenced types
		CV_FIELDLIST	fieldlist;
		CV_BITFIELD_V1	bitfield_v1;
		CV_BITFIELD_V2	bitfield_v2;
		CV_ARGLIST_V1	arglist_v1;
		CV_ARGLIST_V2	arglist_v2;
		CV_DERIVED_V1	derived_v1;
		CV_DERIVED_V2	derived_v2;

		// Field types
	}
}

/**
 Modifier тип
*/
struct CV_MODIFIER_V1 {
	ushort			attribute;
	ushort			тип;
}
struct CV_MODIFIER_V2 {
	бцел			тип;
	ushort			attribute;
}

/**
 Pointer тип
*/
struct CV_POINTER_V1 {
	ushort			attribute;
	ushort			тип;
	OMF_NAME		имя;
}
struct CV_POINTER_V2 {
	бцел			тип;
	бцел			attribute;
	OMF_NAME		имя;
}

/**
 МассивДРК тип
*/
struct CV_ARRAY_V1 {
	ushort			elemType;
	ushort			indexType;
	ushort			length;		/// numeric leaf
	OMF_NAME		имя;
}
struct CV_ARRAY_V2 {
	бцел			elemType;
	бцел			indexType;
	ushort			length;		/// numeric leaf
	OMF_NAME		имя;
}

/**
 Struct тип
*/
struct CV_STRUCT_V1 {
	ushort			nElement;
	ushort			fieldlist;
	ushort			property;
	ushort			derived;
	ushort			vshape;
	ushort			length;		/// numeric leaf
	OMF_NAME		имя;
}
struct CV_STRUCT_V2 {
	ushort			nElement;
	ushort			property;
	бцел			fieldlist;
	бцел			derived;
	бцел			vshape;
	ushort			length;		/// numeric leaf
	OMF_NAME		имя;
}

/**
 Union тип
*/
struct CV_UNION_V1 {
	ushort			count;
	ushort			fieldlist;
	ushort			property;
	ushort			length;		/// numeric leaf
	OMF_NAME		имя;
}
struct CV_UNION_V2 {
	ushort			count;
	ushort			property;
	бцел			fieldlist;
	ushort			length;		/// numeric leaf
	OMF_NAME		имя;
}

/**
 Enumeration тип
*/
struct CV_ENUM_V1 {
	ushort			length;
	ushort			ид;
	ushort			count;
	ushort			тип;
	ushort			fieldlist;
	ushort			property;
	OMF_NAME		p_name;
}
struct CV_ENUM_V2 {
	ushort			length;
	ushort			ид;
	ushort			count;
	ushort			property;
	бцел			тип;
	бцел			fieldlist;
	OMF_NAME		p_name;
}

/**
 Procedure тип
*/
struct CV_PROCEDURE_V1 {
	ushort			retType;
	ббайт			call;
	ббайт			reserved;
	ushort			nParams;
	ushort			argList;
}
struct CV_PROCEDURE_V2 {
	бцел			retType;
	ббайт			call;
	ббайт			reserved;
	ushort			nParams;
	бцел			argList;
}

/**
 Method тип
*/
struct CV_MFUNCTION_V1 {
	ushort			retType;
	ushort			classType;
	ushort			thisType;
	ббайт			call;
	ббайт			reserved;
	ushort			nParams;
	ushort			arglist;
	бцел			thisAdjust;
}
struct CV_MFUNCTION_V2 {
	бцел			retType;
	бцел			classType;
	бцел			thisType;
	ббайт			call;
	ббайт			reserved;
	ushort			nParams;
	бцел			arglist;
	бцел			thisAdjust;
}

/**
 OEM тип
*/
struct CV_OEM_V1 {
	ushort			oem;
	ushort			rec;
	ushort			nIndices;
	//ushort[1]		indices;

	ushort* indices()  {
		return cast(ushort*)(&nIndices + 1);
	}
}
struct CV_OEM_V2 {
	// UNKNOWN!
}

enum {
	OEM_DIGITALMARS	= 0x0042,
	D_DYN_ARRAY		= 0x0001,
	D_ASSOC_ARRAY	= 0x0002,
	D_DELEGATE		= 0x0003
}

struct CV_D_DYNARRAY {
	ushort			indexType;
	ushort			elemType;
}

struct CV_D_ASSOCARRAY {
	ushort			keyType;
	ushort			elemType;
}

struct CV_D_DELEGATE {
	ushort			thisType;
	ushort			funcType;
}

/**
 Field list
*/
struct CV_FIELDLIST {
	ббайт[1]		list;
}

/**
 Bit field
*/
struct CV_BITFIELD_V1 {
	ббайт			nBits;
	ббайт			bitOffset;
	ushort			тип;
}
struct CV_BITFIELD_V2 {
	бцел			тип;
	ббайт			nBits;
	ббайт			bitOffset;
}

/**
 Arguments list
*/
struct CV_ARGLIST_V1 {
	ushort			count;
	ushort[1]		args;
}
struct CV_ARGLIST_V2 {
	бцел			count;
	бцел[1]			args;
}

/**
 Derived
*/
struct CV_DERIVED_V1 {
	ushort			count;
	ushort[1]		derivedClasses;
}
struct CV_DERIVED_V2 {
	бцел			count;
	бцел[1]			derivedClasses;
}

/**
 Class тип
*/
struct CV_CLASS_V1 {
	ushort			тип;
	ushort			attribute;
	ushort			смещение;		/// numeric leaf
}
struct CV_CLASS_V2 {
	ushort			attribute;
	бцел			тип;
	ushort			смещение;		/// numeric leaf
}

struct CvTypeClass {
	ushort			count;
	ushort			fieldList;
	ushort			flags;
	ushort			dList;
	ushort			vShape;
	// length
	// имя
}

// ----------------------------------------------------------------------------
// sstSegMap
// ----------------------------------------------------------------------------

struct CV_SEGMAP {
	ushort				total;
	ushort				logical;
	//CV_SEGMAPDESC[1]	descriptors;

	CV_SEGMAPDESC* descriptors()  {
		return cast(CV_SEGMAPDESC*)(&logical + 1);
	}
}

struct CV_SEGMAPDESC {
	ushort	flags;
	ushort	overlay;
	ushort	group;
	ushort	frame;
	ushort	имя;
	ushort	className;
	бцел	смещение;
	бцел	size;
}

// ----------------------------------------------------------------------------
// sstPreCompMap
// ----------------------------------------------------------------------------

struct OMFPreCompMap {
	ushort			FirstType;		// first precompiled тип index
	ushort			cTypes;			// number of precompiled types
	бцел			signature;		// precompiled types signature
	ushort			padding;
	//CV_typ_t[]	map;			// mapping of precompiled types
}

// ----------------------------------------------------------------------------
// sstOffsetMap16, sstOffsetMap32
// ----------------------------------------------------------------------------

struct OMFOffsetMap16 {
	бцел			csegment;	// Count of physical segments

    // The следщ six items are repeated for each segment

    //бцел			crangeLog;	// Count of logical смещение ranges
    //ushort[]		rgoffLog;	// МассивДРК of logical offsets
    //short[]		rgbiasLog;	// МассивДРК of logical->physical bias
    //бцел			crangePhys;	// Count of physical смещение ranges
    //ushort[]		rgoffPhys;	// МассивДРК of physical offsets
    //short[]		rgbiasPhys;	// МассивДРК of physical->logical bias
}

struct OMFOffsetMap32 {
	бцел			csection;	// Count of physical секции

    // The следщ six items are repeated for each section

    //бцел			crangeLog;	// Count of logical смещение ranges
    //бцел[]		rgoffLog;	// МассивДРК of logical offsets
    //цел[]			rgbiasLog;	// МассивДРК of logical->physical bias
    //бцел			crangePhys;	// Count of physical смещение ranges
    //бцел[]		rgoffPhys;	// МассивДРК of physical offsets
    //цел[]			rgbiasPhys;	// МассивДРК of physical->logical bias
}

// ----------------------------------------------------------------------------
// sstFileIndex
// ----------------------------------------------------------------------------

struct OMFFileIndex {
	ushort			cmodules;	// Number of modules
	ushort			cfilerefs;	// Number of файл references
	//ushort[]		modulelist;	// Index to beginning of list of files
								// for module i. (0 for module w/o files)
	//ushort[]		cfiles;		// Number of файл имена associated
								// with module i.
	//бцел[]		ulNames;	// Offsets from the beginning of this
								// table to the файл имена
	//ткст		Names;		// The length prefixed имена of files
}

struct OMFMpcDebugInfo {
	ushort			cSeg;		// number of segments in module
	//ushort[]		mpSegFrame;	// map seg (нуль based) to frame
}







// Procedure flags
enum {
	PROC_FPO		= 1 << 0, // Frame pointer omitted
	PROC_INTERRUPT	= 1 << 1, // Interrupt
	PROC_RETURN		= 1 << 2, // Far return
	PROC_NEVER		= 1 << 3, // Never returns
}

// Procedure calling conventions
enum {
	CALL_C_NEAR			= 0x00,
	CALL_C_FAR			= 0x01,
	CALL_PASCAL_NEAR	= 0x02,
	CALL_PASCAL_FAR		= 0x03,
	CALL_FASTCALL_NEAR	= 0x04,
	CALL_FASTCALL_FAR	= 0x05,
	CALL_STDCALL_NEAR	= 0x07,
	CALL_STDCALL_FAR	= 0x08,
	CALL_SYSCALL_NEAR	= 0x09,
	CALL_SYSCALL_FAR	= 0x10,
	CALL_THIS			= 0x11,
	CALL_MIPS			= 0x12,
	CALL_GENERIC		= 0x13
}

enum {
	STRUCT_PACKED		= 1 << 0,
	STRUCT_CTOR			= 1 << 1,
	STRUCT_OVERLOADS	= 1 << 2,
	STRUCT_IS_NESTED	= 1 << 3,
	STRUCT_HAS_NESTED	= 1 << 4,
	STRUCT_OPASSIGN		= 1 << 5,
	STRUCT_OPCAST		= 1 << 6,
	STRUCT_FWDREF		= 1 << 7,
	STRUCT_SCOPED		= 1 << 8
}
