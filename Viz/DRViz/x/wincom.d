// This module just содержит things that are needed but aren't in windows.com.
// This code is public domain.

module viz.x.wincom;

private import viz.x.winapi;

version =_viz_needcom;

version(Tango)
	version = _viz_needcom;
version(WINE)
	version = _viz_needcom;

version(_viz_needcom)
{
	private import viz.x.dlib;
	
	// Grabbed from windows.com:
	
	alias WCHAR OLECHAR;
	alias OLECHAR *LPOLESTR;
	alias OLECHAR *LPCOLESTR;
	
	enum
	{
		rmm = 23,	// OLE 2 version number info
		rup = 639,
	}
	/*
	enum : цел
	{
		// S_OK = 0,
		//S_FALSE = 0x00000001,
		//NOERROR = 0,
		//E_NOTIMPL     = cast(цел)0x80004001,
		//E_NOINTERFACE = cast(цел)0x80004002,
		//E_POINTER     = cast(цел)0x80004003,
		//E_ABORT       = cast(цел)0x80004004,
		//E_FAIL        = cast(цел)0x80004005,
		//E_HANDLE      = cast(цел)0x80070006,
		//CLASS_E_NOAGGREGATION = cast(цел)0x80040110,
		//E_OUTOFMEMORY = cast(цел)0x8007000E,
		//E_INVALIDARG  = cast(цел)0x80070057,
		//E_UNEXPECTED  = cast(цел)0x8000FFFF,
	}
	*/
	struct GUID {          // размер is 16
		 align(1):
		DWORD Data1;
		WORD  Data2;
		WORD  Data3;
		BYTE  Data4[8];
	}
	
	enum
	{
		CLSCTX_INPROC_SERVER	= 0x1,
		CLSCTX_INPROC_HANDLER	= 0x2,
		CLSCTX_LOCAL_SERVER	= 0x4,
		CLSCTX_INPROC_SERVER16	= 0x8,
		CLSCTX_REMOTE_SERVER	= 0x10,
		CLSCTX_INPROC_HANDLER16	= 0x20,
		CLSCTX_INPROC_SERVERX86	= 0x40,
		CLSCTX_INPROC_HANDLERX86 = 0x80,
	
		CLSCTX_INPROC = (CLSCTX_INPROC_SERVER|CLSCTX_INPROC_HANDLER),
		CLSCTX_ALL = (CLSCTX_INPROC_SERVER| CLSCTX_INPROC_HANDLER| CLSCTX_LOCAL_SERVER),
		CLSCTX_SERVER = (CLSCTX_INPROC_SERVER|CLSCTX_LOCAL_SERVER),
	}
	
	//alias GUID IID;
	//alias GUID CLSID;
	
	extern (C)
	{
		 extern IID IID_IUnknown;
		 extern IID IID_IClassFactory;
		 extern IID IID_IMarshal;
		 extern IID IID_IMallocSpy;
		 extern IID IID_IStdMarshalInfo;
		 extern IID IID_IExternalConnection;
		 extern IID IID_IMultiQI;
		 extern IID IID_IEnumUnknown;
		 extern IID IID_IBindCtx;
		 extern IID IID_IEnumMoniker;
		 extern IID IID_IRunnableObject;
		 extern IID IID_IRunningObjectTable;
		 extern IID IID_IPersist;
		 extern IID IID_IPersistStream;
		 extern IID IID_IMoniker;
		 extern IID IID_IROTData;
		 extern IID IID_IEnumString;
		 extern IID IID_ISequentialStream;
		 extern IID IID_IStream;
		 extern IID IID_IEnumSTATSTG;
		 extern IID IID_IStorage;
		 extern IID IID_IPersistFile;
		 extern IID IID_IPersistStorage;
		 extern IID IID_ILockBytes;
		 extern IID IID_IEnumFORMATETC;
		 extern IID IID_IEnumSTATDATA;
		 extern IID IID_IRootStorage;
		 extern IID IID_IAdviseSink;
		 extern IID IID_IAdviseSink2;
		 extern IID IID_ИОбъектДанных;
		 extern IID IID_IDataAdviseHolder;
		 extern IID IID_IMessageFilter;
		 extern IID IID_IRpcChannelBuffer;
		 extern IID IID_IRpcProxyBuffer;
		 extern IID IID_IRpcStubBuffer;
		 extern IID IID_IPSFactoryBuffer;
		 extern IID IID_IPropertyStorage;
		 extern IID IID_IPropertySetStorage;
		 extern IID IID_IEnumSTATPROPSTG;
		 extern IID IID_IEnumSTATPROPSETSTG;
		 extern IID IID_IFillLockBytes;
		 extern IID IID_IProgressNotify;
		 extern IID IID_ILayoutStorage;
		 extern IID GUID_NULL;
		 extern IID IID_IRpcChannel;
		 extern IID IID_IRpcStub;
		 extern IID IID_IStubManager;
		 extern IID IID_IRpcProxy;
		 extern IID IID_IProxyManager;
		 extern IID IID_IPSFactory;
		 extern IID IID_IInternalMoniker;
		 extern IID IID_IDfReserved1;
		 extern IID IID_IDfReserved2;
		 extern IID IID_IDfReserved3;
		 extern IID IID_IStub;
		 extern IID IID_IProxy;
		 extern IID IID_IEnumGeneric;
		 extern IID IID_IEnumHolder;
		 extern IID IID_IEnumCallback;
		 extern IID IID_IOleManager;
		 extern IID IID_IOlePresObj;
		 extern IID IID_IDebug;
		 extern IID IID_IDebugStream;
		 extern IID IID_StdOle;
		 extern IID IID_ICreateTypeInfo;
		 extern IID IID_ICreateTypeInfo2;
		 extern IID IID_ICreateTypeLib;
		 extern IID IID_ICreateTypeLib2;
		 extern IID IID_IDispatch;
		 extern IID IID_IEnumVARIANT;
		 extern IID IID_ITypeComp;
		 extern IID IID_ITypeInfo;
		 extern IID IID_ITypeInfo2;
		 extern IID IID_ITypeLib;
		 extern IID IID_ITypeLib2;
		 extern IID IID_ITypeChangeEvents;
		 extern IID IID_IErrorInfo;
		 extern IID IID_ICreateErrorInfo;
		 extern IID IID_ISupportErrorInfo;
		 extern IID IID_IOleAdviseHolder;
		 extern IID IID_IOleCache;
		 extern IID IID_IOleCache2;
		 extern IID IID_IOleCacheControl;
		 extern IID IID_IParseDisplayName;
		 extern IID IID_IOleContainer;
		 extern IID IID_IOleClientSite;
		 extern IID IID_IOleObject;
		 extern IID IID_IOleWindow;
		 extern IID IID_IOleLink;
		 extern IID IID_IOleItemContainer;
		 extern IID IID_IOleInPlaceUIWindow;
		 extern IID IID_IOleInPlaceActiveObject;
		 extern IID IID_IOleInPlaceFrame;
		 extern IID IID_IOleInPlaceObject;
		 extern IID IID_IOleInPlaceSite;
		 extern IID IID_IContinue;
		 extern IID IID_IViewObject;
		 extern IID IID_IViewObject2;
		 extern IID IID_IDropSource;
		 extern IID IID_sys.DIfaces.IDropTarget;
		 extern IID IID_IEnumOLEVERB;
	}
	

extern(C)
{
	extern IID IID_IPicture;
	
	version(REDEFINE_UUIDS)
	{
		// These are needed because uuid.lib is broken in DMC 8.46.
		IID _IID_IUnknown= { 0, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70] };
		IID _IID_IDataObject = { 270, 0, 0, [192, 0, 0, 0, 0, 0, 0, 70 ] };
		IID _IID_IPicture = { 2079852928, 48946, 4122, [139, 187, 0, 170, 0, 48, 12, 171] };
		IID _IID_ISequentialStream = { 208878128, 10780, 4558, [ 173, 229, 0, 170, 0, 68, 119, 61 ] };
		IID _IID_IStream = { 12, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70 ] };
		IID _IID_IDropTarget = { 290, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70 ] };
		IID _IID_IDropSource = { 289, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70 ] };
		IID _IID_IEnumFORMATETC = { 259, 0, 0, [ 192, 0, 0, 0, 0, 0, 0, 70 ] };
	}
	else
	{
		alias IID_IUnknown _IID_IUnknown;
		alias IID_IDataObject _IID_IDataObject;
		alias IID_IPicture _IID_IPicture;
		
		alias IID_ISequentialStream _IID_ISequentialStream;
		alias IID_IStream _IID_IStream;
		alias IID_sys.DIfaces.IDropTarget _IID_IDropTarget;
		alias IID_IDropSource _IID_IDropSource;
		alias IID_IEnumFORMATETC _IID_IEnumFORMATETC;
	}
}


extern(Windows):

interface ISequentialStream: winapi.IUnknown
{
	extern(Windows):
	HRESULT Read(ук pv, ULONG cb, ULONG* pcbRead);
	HRESULT Write(ук pv, ULONG cb, ULONG* pcbWritten);
}


/// STREAM_SEEK
enum: DWORD
{
	STREAM_SEEK_SET = 0,
	STREAM_SEEK_CUR = 1,
	STREAM_SEEK_END = 2,
}
alias DWORD STREAM_SEEK;


// TODO: implement the enum`s used here.
struct STATSTG
{
	LPWSTR pwcsName;
	DWORD тип;
	ULARGE_INTEGER cbSize;
	FILETIME mtime;
	FILETIME ctime;
	FILETIME atime;
	DWORD grfMode;
	DWORD grfLocksSupported;
	CLSID clsid;
	DWORD grfStateBits;
	DWORD reserved;
}


interface IStream: winapi.ISequentialStream
{
	extern(Windows):
	HRESULT Seek(LARGE_INTEGER dlibMove, DWORD dwOrigin, ULARGE_INTEGER* plibNewPosition);
	HRESULT SetSize(ULARGE_INTEGER libNewSize);
	HRESULT CopyTo(winapi.IStream pstm, ULARGE_INTEGER cb, ULARGE_INTEGER* pcbRead, ULARGE_INTEGER* pcbWritten);
	HRESULT Commit(DWORD grfCommitFlags);
	HRESULT Revert();
	HRESULT LockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType);
	HRESULT UnlockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType);
	HRESULT Stat(STATSTG* pstatstg, DWORD grfStatFlag);
	HRESULT Clone(winapi.IStream* ppstm);
}
alias winapi.IStream* LPSTREAM;


alias UINT OLE_HANDLE;

alias LONG OLE_XPOS_HIMETRIC;

alias LONG OLE_YPOS_HIMETRIC;

alias LONG OLE_XSIZE_HIMETRIC;

alias LONG OLE_YSIZE_HIMETRIC;


interface IPicture: winapi.IUnknown
{
	extern(Windows):
	HRESULT get_Handle(OLE_HANDLE* phandle);
	HRESULT get_hPal(OLE_HANDLE* phpal);
	HRESULT get_Type(short* ptype);
	HRESULT get_Width(OLE_XSIZE_HIMETRIC* pwidth);
	HRESULT get_Height(OLE_YSIZE_HIMETRIC* pheight);
	HRESULT Render(HDC hdc, цел ш, цел в, цел cx, цел cy, OLE_XPOS_HIMETRIC xSrc, OLE_YPOS_HIMETRIC ySrc, OLE_XSIZE_HIMETRIC cxSrc, OLE_YSIZE_HIMETRIC cySrc, LPCRECT prcWBounds);
	HRESULT set_hPal(OLE_HANDLE hpal);
	HRESULT get_CurDC(HDC* phdcOut);
	HRESULT SelectPicture(HDC hdcIn, HDC* phdcOut, OLE_HANDLE* phbmpOut);
	HRESULT get_KeepOriginalFormat(BOOL* pfkeep);
	HRESULT put_KeepOriginalFormat(BOOL keep);
	HRESULT PictureChanged();
	HRESULT SaveAsFile(winapi.IStream pstream, BOOL fSaveMemCopy, LONG* pcbSize);
	HRESULT get_Attributes(DWORD* pdwAttr);
}

struct DVTARGETDEVICE
{
	DWORD tdSize;
	WORD tdDriverNameOffset;
	WORD tdDeviceNameOffset;
	WORD tdPortNameOffset;
	WORD tdExtDevmodeOffset;
	BYTE[1] tdData;
}


struct FORMATETC
{
	CLIPFORMAT cfFormat;
	DVTARGETDEVICE* ptd;
	DWORD dwAspect;
	LONG lindex;
	DWORD tymed;
}
alias FORMATETC* LPFORMATETC;


struct STATDATA 
{
	FORMATETC formatetc;
	DWORD grfAdvf;
	winapi.IAdviseSink pAdvSink;
	DWORD dwConnection;
}


struct STGMEDIUM
{
	DWORD tymed;
	union //u
	{
		HBITMAP hBitmap;
		//HMETAFILEPICT hMetaFilePict;
		HENHMETAFILE hEnhMetaFile;
		HGLOBAL hGlobal;
		LPOLESTR lpszFileName;
		winapi.IStream pstm;
		//IStorage pstg;
	}
	winapi.IUnknown pUnkForRelease;
}
alias STGMEDIUM* LPSTGMEDIUM;


interface winapi.IDataObject: winapi.IUnknown
{
	extern(Windows):
	HRESULT GetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium);
	HRESULT GetDataHere(FORMATETC* pFormatetc, STGMEDIUM* pmedium);
	HRESULT QueryGetData(FORMATETC* pFormatetc);
	HRESULT GetCanonicalFormatEtc(FORMATETC* pFormatetcIn, FORMATETC* pFormatetcOut);
	HRESULT SetData(FORMATETC* pFormatetc, STGMEDIUM* pmedium, BOOL fRelease);
	HRESULT EnumFormatEtc(DWORD dwDirection, winapi.IEnumFORMATETC* ppenumFormatetc);
	HRESULT DAdvise(FORMATETC* pFormatetc, DWORD advf, winapi.IAdviseSink pAdvSink, DWORD* pdwConnection);
	HRESULT DUnadvise(DWORD dwConnection);
	HRESULT EnumDAdvise(winapi.IEnumSTATDATA* ppenumAdvise);
}
alias winapi.IDataObject ИОбъектДанных;

interface winapi.IDropSource: winapi.IUnknown
{
	extern(Windows):
	HRESULT QueryContinueDrag(BOOL fEscapePressed, DWORD grfKeyState);
	HRESULT GiveFeedback(DWORD dwEffect);
}


interface winapi.IDropTarget: winapi.IUnknown
{
	extern(Windows):
	HRESULT DragEnter(ИОбъектДанных pDataObject, DWORD grfKeyState, POINTL тчк, DWORD* pdwEffect);
	HRESULT DragOver(DWORD grfKeyState, POINTL тчк, DWORD* pdwEffect);
	HRESULT DragLeave();
	HRESULT Drop(ИОбъектДанных pDataObject, DWORD grfKeyState, POINTL тчк, DWORD* pdwEffect);
}


interface winapi.IEnumFORMATETC: winapi.IUnknown
{
	extern(Windows):
	HRESULT Next(ULONG celt, FORMATETC* rgelt, ULONG* pceltFetched);
	HRESULT Skip(ULONG celt);
	HRESULT Reset();
	HRESULT Clone(winapi.IEnumFORMATETC* ppenum);
}


interface winapi.IEnumSTATDATA: winapi.IUnknown
{
	extern(Windows):
	HRESULT Next(ULONG celt, STATDATA* rgelt, ULONG* pceltFetched);
	HRESULT Skip(ULONG celt);
	HRESULT Reset();
	HRESULT Clone(winapi.IEnumSTATDATA* ppenum);
}


interface winapi.IAdviseSink: winapi.IUnknown
{
	// TODO: finish.
}


interface IMalloc: winapi.IUnknown
{
	extern(Windows):
	ук Alloc(ULONG cb);
	ук Realloc(проц *pv, ULONG cb);
	проц Free(ук pv);
	ULONG GetSize(ук pv);
	цел DidAlloc(ук pv);
	проц HeapMinimize();
}

// Since an interface is а pointer..
alias IMalloc PMALLOC;
alias IMalloc LPMALLOC;


LONG MAP_LOGHIM_TO_PIX(LONG ш, LONG logpixels)
{
	return MulDiv(logpixels, ш, 2540);
}


enum: DWORD
{
	DVASPECT_CONTENT = 1,
	DVASPECT_THUMBNAIL = 2,
	DVASPECT_ICON = 4,
	DVASPECT_DOCPRINT = 8,
}
alias DWORD DVASPECT;


enum: DWORD
{
	TYMED_HGLOBAL = 1,
	TYMED_FILE = 2,
	TYMED_ISTREAM = 4,
	TYMED_ISTORAGE = 8,
	TYMED_GDI = 16,
	TYMED_MFPICT = 32,
	TYMED_ENHMF = 64,
	TYMED_NULL = 0
}
alias DWORD TYMED;


enum
{
	DATADIR_GET = 1,
}


enum: HRESULT
{
	DRAGDROP_S_DROP = 0x00040100,
	DRAGDROP_S_CANCEL = 0x00040101,
	DRAGDROP_S_USEDEFAULTCURSORS = 0x00040102,
	V_E_LINDEX = cast(HRESULT)0x80040068,
	STG_E_MEDIUMFULL = cast(HRESULT)0x80030070,
	STG_E_INVALIDFUNCTION = cast(HRESULT)0x80030001,
	DV_E_TYMED = cast(HRESULT)0x80040069,
	DV_E_DVASPECT = cast(HRESULT)0x8004006B,
	DV_E_FORMATETC = cast(HRESULT)0x80040064,
	DV_E_LINDEX = cast(HRESULT)0x80040068,
	DRAGDROP_E_ALREADYREGISTERED = cast(HRESULT)0x80040101,
}


alias HRESULT WINOLEAPI;


WINOLEAPI OleInitialize(LPVOID pvReserved);
WINOLEAPI DoDragDrop(ИОбъектДанных pDataObject, winapi.IDropSource pDropSource, DWORD dwOKEffect, DWORD* pdwEffect);
WINOLEAPI RegisterDragDrop(УОК уок, winapi.IDropTarget pDropTarget);
WINOLEAPI RevokeDragDrop(УОК уок);
WINOLEAPI OleGetClipboard(ИОбъектДанных* ppDataObj);
WINOLEAPI OleSetClipboard(ИОбъектДанных pDataObj);
WINOLEAPI OleFlushClipboard();
WINOLEAPI CreateStreamOnHGlobal(HGLOBAL hGlobal, BOOL fDeleteOnRelease, LPSTREAM ppstm);
WINOLEAPI OleLoadPicture(winapi.IStream pStream, LONG lSize, BOOL fRunmode, IID* riid, проц** ppv);
}
