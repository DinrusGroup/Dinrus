/**
 * Windows API header module
 *
 * Translated from MinGW Windows headers
 *
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source: $(DRUNTIMESRC src/core/sys/windows/_oledlg.d)
 */
module core.sys.windows.oledlg;
version (Windows):

version (ANSI) {} else version = Unicode;

import core.sys.windows.commdlg, core.sys.windows.dlgs, core.sys.windows.ole2, core.sys.windows.prsht, core.sys.windows.shellapi;
private import core.sys.windows.winbase, core.sys.windows.objidl, core.sys.windows.objfwd, core.sys.windows.winnt;

// FIXME: remove inherited methods from interface definitions

const PS_MAXLINKTYPES=8;

const TCHAR[] OLESTDDELIM = "\\";
const TCHAR[] SZOLEUI_MSG_HELP = "OLEUI_MSG_HELP";
const TCHAR[] SZOLEUI_MSG_ENDDIALOG = "OLEUI_MSG_ENDDIALOG";
const TCHAR[] SZOLEUI_MSG_BROWSE = "OLEUI_MSG_BROWSE";
const TCHAR[] SZOLEUI_MSG_CHANGEICON = "OLEUI_MSG_CHANGEICON";
const TCHAR[] SZOLEUI_MSG_CLOSEBUSYDIALOG = "OLEUI_MSG_CLOSEBUSYDIALOG";
const TCHAR[] SZOLEUI_MSG_CONVERT = "OLEUI_MSG_CONVERT";
const TCHAR[] SZOLEUI_MSG_CHANGESOURCE = "OLEUI_MSG_CHANGESOURCE";
const TCHAR[] SZOLEUI_MSG_ADDCONTROL = "OLEUI_MSG_ADDCONTROL";
const TCHAR[] SZOLEUI_MSG_BROWSE_OFN = "OLEUI_MSG_BROWSE_OFN";

const TCHAR[] PROP_HWND_CHGICONDLG = "HWND_CIDLG";

const IDC_OLEUIHELP=99;

enum {
    IDC_IO_CREATENEW = 2100,
    IDC_IO_CREATEFROMFILE,
    IDC_IO_LINKFILE,
    IDC_IO_OBJECTTYPELIST,
    IDC_IO_DISPLAYASICON,
    IDC_IO_CHANGEICON,
    IDC_IO_FILE,
    IDC_IO_FILEDISPLAY,
    IDC_IO_RESULTIMAGE,
    IDC_IO_RESULTTEXT,
    IDC_IO_ICONDISPLAY,
    IDC_IO_OBJECTTYPETEXT,
    IDC_IO_FILETEXT,
    IDC_IO_FILETYPE,
    IDC_IO_INSERTCONTROL,
    IDC_IO_ADDCONTROL,
    IDC_IO_CONTROLTYPELIST // = 2116
}

const IDC_PS_PASTE=500;
const IDC_PS_PASTELINK=501;
const IDC_PS_SOURCETEXT=502;
const IDC_PS_PASTELIST=503;
const IDC_PS_PASTELINKLIST=504;
const IDC_PS_DISPLAYLIST=505;
const IDC_PS_DISPLAYASICON=506;
const IDC_PS_ICONDISPLAY=507;
const IDC_PS_CHANGEICON=508;
const IDC_PS_RESULTIMAGE=509;
const IDC_PS_RESULTTEXT=510;

const IDC_CI_GROUP=120;
const IDC_CI_CURRENT=121;
const IDC_CI_CURRENTICON=122;
const IDC_CI_DEFAULT=123;
const IDC_CI_DEFAULTICON=124;
const IDC_CI_FROMFILE=125;
const IDC_CI_FROMFILEEDIT=126;
const IDC_CI_ICONLIST=127;
const IDC_CI_LABEL=128;
const IDC_CI_LABELEDIT=129;
const IDC_CI_BROWSE=130;
const IDC_CI_ICONDISPLAY=131;

const IDC_CV_OBJECTTYPE=150;
const IDC_CV_DISPLAYASICON=152;
const IDC_CV_CHANGEICON=153;
const IDC_CV_ACTIVATELIST=154;
const IDC_CV_CONVERTTO=155;
const IDC_CV_ACTIVATEAS=156;
const IDC_CV_RESULTTEXT=157;
const IDC_CV_CONVERTLIST=158;
const IDC_CV_ICONDISPLAY=165;

const IDC_EL_CHANGESOURCE=201;
const IDC_EL_AUTOMATIC=202;
const IDC_EL_CANCELLINK=209;
const IDC_EL_UPDATENOW=210;
const IDC_EL_OPENSOURCE=211;
const IDC_EL_MANUAL=212;
const IDC_EL_LINKSOURCE=216;
const IDC_EL_LINKTYPE=217;
const IDC_EL_LINKSLISTBOX=206;
const IDC_EL_COL1=220;
const IDC_EL_COL2=221;
const IDC_EL_COL3=222;

const IDC_BZ_RETRY=600;
const IDC_BZ_ICON=601;
const IDC_BZ_MESSAGE1=602;
const IDC_BZ_SWITCHTO=604;

const IDC_UL_METER=1029;
const IDC_UL_STOP=1030;
const IDC_UL_PERCENT=1031;
const IDC_UL_PROGRESS=1032;

const IDC_PU_LINKS=900;
const IDC_PU_TEXT=901;
const IDC_PU_CONVERT=902;
const IDC_PU_ICON=908;

const IDC_GP_OBJECTNAME=1009;
const IDC_GP_OBJECTTYPE=1010;
const IDC_GP_OBJECTSIZE=1011;
const IDC_GP_CONVERT=1013;
const IDC_GP_OBJECTICON=1014;
const IDC_GP_OBJECTLOCATION=1022;

const IDC_VP_PERCENT=1000;
const IDC_VP_CHANGEICON=1001;
const IDC_VP_EDITABLE=1002;
const IDC_VP_ASICON=1003;
const IDC_VP_RELATIVE=1005;
const IDC_VP_SPIN=1006;
const IDC_VP_SCALETXT=1034;
const IDC_VP_ICONDISPLAY=1021;
const IDC_VP_RESULTIMAGE=1033;

const IDC_LP_OPENSOURCE=1006;
const IDC_LP_UPDATENOW=1007;
const IDC_LP_BREAKLINK=1008;
const IDC_LP_LINKSOURCE=1012;
const IDC_LP_CHANGESOURCE=1015;
const IDC_LP_AUTOMATIC=1016;
const IDC_LP_MANUAL=1017;
const IDC_LP_DATE=1018;
const IDC_LP_TIME=1019;

const IDD_INSERTOBJECT=1000;
const IDD_CHANGEICON=1001;
const IDD_CONVERT=1002;
const IDD_PASTESPECIAL=1003;
const IDD_EDITLINKS=1004;
const IDD_BUSY=1006;
const IDD_UPDATELINKS=1007;
const IDD_CHANGESOURCE=1009;
const IDD_INSERTFILEBROWSE=1010;
const IDD_CHANGEICONBROWSE=1011;
const IDD_CONVERTONLY=1012;
const IDD_CHANGESOURCE4=1013;
const IDD_GNRLPROPS=1100;
const IDD_VIEWPROPS=1101;
const IDD_LINKPROPS=1102;
const IDD_CANNOTUPDATELINK=1008;
const IDD_LINKSOURCEUNAVAILABLE=1020;
const IDD_SERVERNOTFOUND=1023;
const IDD_OUTOFMEMORY=1024;
const IDD_SERVERNOTREGW=1021;
const IDD_LINKTYPECHANGEDW=1022;
const IDD_SERVERNOTREGA=1025;
const IDD_LINKTYPECHANGEDA=1026;

const ID_BROWSE_CHANGEICON=1;
const ID_BROWSE_INSERTFILE=2;
const ID_BROWSE_ADDCONTROL=3;
const ID_BROWSE_CHANGESOURCE=4;

const OLEUI_FALSE=0;
const OLEUI_SUCCESS=1;
const OLEUI_OK=1;
const OLEUI_CANCEL=2;

const OLEUI_ERR_STANDARDMIN=100;
const OLEUI_ERR_STRUCTURENULL=101;
const OLEUI_ERR_STRUCTUREINVALID=102;
const OLEUI_ERR_CBSTRUCTINCORRECT=103;
const OLEUI_ERR_HWNDOWNERINVALID=104;
const OLEUI_ERR_LPSZCAPTIONINVALID=105;
const OLEUI_ERR_LPFNHOOKINVALID=106;
const OLEUI_ERR_HINSTANCEINVALID=107;
const OLEUI_ERR_LPSZTEMPLATEINVALID=108;
const OLEUI_ERR_HRESOURCEINVALID=109;
const OLEUI_ERR_FINDTEMPLATEFAILURE=110;
const OLEUI_ERR_LOADTEMPLATEFAILURE=111;
const OLEUI_ERR_DIALOGFAILURE=112;
const OLEUI_ERR_LOCALMEMALLOC=113;
const OLEUI_ERR_GLOBALMEMALLOC=114;
const OLEUI_ERR_LOADSTRING=115;
const OLEUI_ERR_OLEMEMALLOC=116;
const OLEUI_ERR_STANDARDMAX=116;

const OPF_OBJECTISLINK=1;
const OPF_NOFILLDEFAULT=2;
const OPF_SHOWHELP=4;
const OPF_DISABLECONVERT=8;

const OLEUI_OPERR_SUBPROPNULL=OLEUI_ERR_STANDARDMAX;
const OLEUI_OPERR_SUBPROPINVALID=(OLEUI_ERR_STANDARDMAX+1);
const OLEUI_OPERR_PROPSHEETNULL=(OLEUI_ERR_STANDARDMAX+2);
const OLEUI_OPERR_PROPSHEETINVALID=(OLEUI_ERR_STANDARDMAX+3);
const OLEUI_OPERR_SUPPROP=(OLEUI_ERR_STANDARDMAX+4);
const OLEUI_OPERR_PROPSINVALID=(OLEUI_ERR_STANDARDMAX+5);
const OLEUI_OPERR_PAGESINCORRECT=(OLEUI_ERR_STANDARDMAX+6);
const OLEUI_OPERR_INVALIDPAGES=(OLEUI_ERR_STANDARDMAX+7);
const OLEUI_OPERR_NOTSUPPORTED=(OLEUI_ERR_STANDARDMAX+8);
const OLEUI_OPERR_DLGPROCNOTNULL=(OLEUI_ERR_STANDARDMAX+9);
const OLEUI_OPERR_LPARAMNOTZERO=(OLEUI_ERR_STANDARDMAX+10);
const OLEUI_GPERR_STRINGINVALID=(OLEUI_ERR_STANDARDMAX+11);
const OLEUI_GPERR_CLASSIDINVALID=(OLEUI_ERR_STANDARDMAX+12);
const OLEUI_GPERR_LPCLSIDEXCLUDEINVALID=(OLEUI_ERR_STANDARDMAX+13);
const OLEUI_GPERR_CBFORMATINVALID=(OLEUI_ERR_STANDARDMAX+14);
const OLEUI_VPERR_METAPICTINVALID=(OLEUI_ERR_STANDARDMAX+15);
const OLEUI_VPERR_DVASPECTINVALID=(OLEUI_ERR_STANDARDMAX+16);
const OLEUI_LPERR_LINKCNTRNULL=(OLEUI_ERR_STANDARDMAX+17);
const OLEUI_LPERR_LINKCNTRINVALID=(OLEUI_ERR_STANDARDMAX+18);
const OLEUI_OPERR_PROPERTYSHEET=(OLEUI_ERR_STANDARDMAX+19);
const OLEUI_OPERR_OBJINFOINVALID=(OLEUI_ERR_STANDARDMAX+20);
const OLEUI_OPERR_LINKINFOINVALID=(OLEUI_ERR_STANDARDMAX+21);

const OLEUI_QUERY_GETCLASSID=65280;
const OLEUI_QUERY_LINKBROKEN=65281;

const IOF_SHOWHELP=1;
const IOF_SELECTCREATENEW=2;
const IOF_SELECTCREATEFROMFILE=4;
const IOF_CHECKLINK=8;
const IOF_CHECKDISPLAYASICON=16;
const IOF_CREATENEWOBJECT=32;
const IOF_CREATEFILEOBJECT=64;
const IOF_CREATELINKOBJECT=128;
const IOF_DISABLELINK=256;
const IOF_VERIFYSERVERSEXIST=512;
const IOF_DISABLEDISPLAYASICON=1024;
const IOF_HIDECHANGEICON=2048;
const IOF_SHOWINSERTCONTROL=4096;
const IOF_SELECTCREATECONTROL=8192;

const OLEUI_IOERR_LPSZFILEINVALID=OLEUI_ERR_STANDARDMAX;
const OLEUI_IOERR_LPSZLABELINVALID=(OLEUI_ERR_STANDARDMAX+1);
const OLEUI_IOERR_HICONINVALID=(OLEUI_ERR_STANDARDMAX+2);
const OLEUI_IOERR_LPFORMATETCINVALID=(OLEUI_ERR_STANDARDMAX+3);
const OLEUI_IOERR_PPVOBJINVALID=(OLEUI_ERR_STANDARDMAX+4);
const OLEUI_IOERR_LPIOLECLIENTSITEINVALID=(OLEUI_ERR_STANDARDMAX+5);
const OLEUI_IOERR_LPISTORAGEINVALID=(OLEUI_ERR_STANDARDMAX+6);
const OLEUI_IOERR_SCODEHASERROR=(OLEUI_ERR_STANDARDMAX+7);
const OLEUI_IOERR_LPCLSIDEXCLUDEINVALID=(OLEUI_ERR_STANDARDMAX+8);
const OLEUI_IOERR_CCHFILEINVALID=(OLEUI_ERR_STANDARDMAX+9);

const PSF_SHOWHELP=1;
const PSF_SELECTPASTE=2;
const PSF_SELECTPASTELINK=4;
const PSF_CHECKDISPLAYASICON=8;
const PSF_DISABLEDISPLAYASICON=16;
const PSF_HIDECHANGEICON=32;
const PSF_STAYONCLIPBOARDCHANGE=64;
const PSF_NOREFRESHDATAOBJECT=128;

const OLEUI_IOERR_SRCDATAOBJECTINVALID=OLEUI_ERR_STANDARDMAX;
const OLEUI_IOERR_ARRPASTEENTRIESINVALID=(OLEUI_ERR_STANDARDMAX+1);
const OLEUI_IOERR_ARRLINKTYPESINVALID=(OLEUI_ERR_STANDARDMAX+2);
const OLEUI_PSERR_CLIPBOARDCHANGED=(OLEUI_ERR_STANDARDMAX+3);
const OLEUI_PSERR_GETCLIPBOARDFAILED=(OLEUI_ERR_STANDARDMAX+4);
const OLEUI_ELERR_LINKCNTRNULL=OLEUI_ERR_STANDARDMAX;
const OLEUI_ELERR_LINKCNTRINVALID=(OLEUI_ERR_STANDARDMAX+1);

const ELF_SHOWHELP=1;
const ELF_DISABLEUPDATENOW=2;
const ELF_DISABLEOPENSOURCE=4;
const ELF_DISABLECHANGESOURCE=8;
const ELF_DISABLECANCELLINK=16;

const CIF_SHOWHELP=1;
const CIF_SELECTCURRENT=2;
const CIF_SELECTDEFAULT=4;
const CIF_SELECTFROMFILE=8;
const CIF_USEICONEXE=16;

const OLEUI_CIERR_MUSTHAVECLSID=OLEUI_ERR_STANDARDMAX;
const OLEUI_CIERR_MUSTHAVECURRENTMETAFILE=OLEUI_ERR_STANDARDMAX+1;
const OLEUI_CIERR_SZICONEXEINVALID=OLEUI_ERR_STANDARDMAX+2;

const CF_SHOWHELPBUTTON=1;
const CF_SETCONVERTDEFAULT=2;
const CF_SETACTIVATEDEFAULT=4;
const CF_SELECTCONVERTTO=8;
const CF_SELECTACTIVATEAS=16;
const CF_DISABLEDISPLAYASICON=32;
const CF_DISABLEACTIVATEAS=64;
const CF_HIDECHANGEICON=128;
const CF_CONVERTONLY=256;

const OLEUI_CTERR_CLASSIDINVALID = OLEUI_ERR_STANDARDMAX+1;
const OLEUI_CTERR_DVASPECTINVALID = OLEUI_ERR_STANDARDMAX+2;
const OLEUI_CTERR_CBFORMATINVALID = OLEUI_ERR_STANDARDMAX+3;
const OLEUI_CTERR_HMETAPICTINVALID = OLEUI_ERR_STANDARDMAX+4;
const OLEUI_CTERR_STRINGINVALID = OLEUI_ERR_STANDARDMAX+5;

const BZ_DISABLECANCELBUTTON = 1;
const BZ_DISABLESWITCHTOBUTTON = 2;
const BZ_DISABLERETRYBUTTON = 4;
const BZ_NOTRESPONDINGDIALOG = 8;

const OLEUI_BZERR_HTASKINVALID = OLEUI_ERR_STANDARDMAX;
const OLEUI_BZ_SWITCHTOSELECTED = OLEUI_ERR_STANDARDMAX+1;
const OLEUI_BZ_RETRYSELECTED = OLEUI_ERR_STANDARDMAX+2;
const OLEUI_BZ_CALLUNBLOCKED = OLEUI_ERR_STANDARDMAX+3;

const CSF_SHOWHELP = 1;
const CSF_VALIDSOURCE = 2;
const CSF_ONLYGETSOURCE = 4;
const CSF_EXPLORER = 8;

const OLEUI_CSERR_LINKCNTRNULL = OLEUI_ERR_STANDARDMAX;
const OLEUI_CSERR_LINKCNTRINVALID = OLEUI_ERR_STANDARDMAX+1;
const OLEUI_CSERR_FROMNOTNULL = OLEUI_ERR_STANDARDMAX+2;
const OLEUI_CSERR_TONOTNULL = OLEUI_ERR_STANDARDMAX+3;
const OLEUI_CSERR_SOURCENULL = OLEUI_ERR_STANDARDMAX+4;
const OLEUI_CSERR_SOURCEINVALID = OLEUI_ERR_STANDARDMAX+5;
const OLEUI_CSERR_SOURCEPARSERROR = OLEUI_ERR_STANDARDMAX+6;
const OLEUI_CSERR_SOURCEPARSEERROR = OLEUI_ERR_STANDARDMAX+7;

const VPF_SELECTRELATIVE=1;
const VPF_DISABLERELATIVE=2;
const VPF_DISABLESCALE=4;

align(8):
extern (Windows) {
    alias UINT function(HWND, UINT, WPARAM, LPARAM) LPFNOLEUIHOOK;
}

struct OLEUIINSERTOBJECTW {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCWSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCWSTR lpszTemplate;
    HRSRC hResource;
    CLSID clsid;
    LPWSTR lpszFile;
    UINT cchFile;
    UINT cClsidExclude;
    LPCLSID lpClsidExclude;
    IID iid;
    DWORD oleRender;
    LPFORMATETC lpFormatEtc;
    LPOLECLIENTSITE lpIOleClientSite;
    LPSTORAGE lpIStorage;
    PVOID *ppvObj;
    SCODE sc;
    HGLOBAL hMetaPict;
}
alias OLEUIINSERTOBJECTW* POLEUIINSERTOBJECTW, LPOLEUIINSERTOBJECTW;

struct OLEUIINSERTOBJECTA {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCSTR lpszTemplate;
    HRSRC hResource;
    CLSID clsid;
    LPSTR lpszFile;
    UINT cchFile;
    UINT cClsidExclude;
    LPCLSID lpClsidExclude;
    IID iid;
    DWORD oleRender;
    LPFORMATETC lpFormatEtc;
    LPOLECLIENTSITE lpIOleClientSite;
    LPSTORAGE lpIStorage;
    PVOID *ppvObj;
    SCODE sc;
    HGLOBAL hMetaPict;
}
alias OLEUIINSERTOBJECTA* POLEUIINSERTOBJECTA, LPOLEUIINSERTOBJECTA;

extern (Windows) {
    UINT OleUIInsertObjectW(LPOLEUIINSERTOBJECTW);
    UINT OleUIInsertObjectA(LPOLEUIINSERTOBJECTA);
}

enum OLEUIPASTEFLAG {
    OLEUIPASTE_PASTEONLY,
    OLEUIPASTE_LINKTYPE1,
    OLEUIPASTE_LINKTYPE2,
    OLEUIPASTE_LINKTYPE3 = 4,
    OLEUIPASTE_LINKTYPE4 = 8,
    OLEUIPASTE_LINKTYPE5 = 16,
    OLEUIPASTE_LINKTYPE6 = 32,
    OLEUIPASTE_LINKTYPE7 = 64,
    OLEUIPASTE_LINKTYPE8 = 128,
    OLEUIPASTE_PASTE = 512,
    OLEUIPASTE_LINKANYTYPE = 1024,
    OLEUIPASTE_ENABLEICON = 2048
}

struct OLEUIPASTEENTRYW {
    FORMATETC fmtetc;
    LPCWSTR lpstrFormatName;
    LPCWSTR lpstrResultText;
    DWORD dwFlags;
    DWORD dwScratchSpace;
}
alias OLEUIPASTEENTRYW* POLEUIPASTEENTRYW, LPOLEUIPASTEENTRYW;

struct OLEUIPASTEENTRYA {
    FORMATETC fmtetc;
    LPCSTR lpstrFormatName;
    LPCSTR lpstrResultText;
    DWORD dwFlags;
    DWORD dwScratchSpace;
}
alias OLEUIPASTEENTRYA* POLEUIPASTEENTRYA, LPOLEUIPASTEENTRYA;

struct OLEUIPASTESPECIALW {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCWSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCWSTR lpszTemplate;
    HRSRC hResource;
    LPDATAOBJECT lpSrcDataObj;
    LPOLEUIPASTEENTRYW arrPasteEntries;
    int cPasteEntries;
    UINT *arrLinkTypes;
    int cLinkTypes;
    UINT cClsidExclude;
    LPCLSID lpClsidExclude;
    int nSelectedIndex;
    BOOL fLink;
    HGLOBAL hMetaPict;
    SIZEL sizel;
}
alias OLEUIPASTESPECIALW* POLEUIPASTESPECIALW, LPOLEUIPASTESPECIALW;

struct OLEUIPASTESPECIALA {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCSTR lpszTemplate;
    HRSRC hResource;
    LPDATAOBJECT lpSrcDataObj;
    LPOLEUIPASTEENTRYA arrPasteEntries;
    int cPasteEntries;
    UINT* arrLinkTypes;
    int cLinkTypes;
    UINT cClsidExclude;
    LPCLSID lpClsidExclude;
    int nSelectedIndex;
    BOOL fLink;
    HGLOBAL hMetaPict;
    SIZEL sizel;
}
alias OLEUIPASTESPECIALA* POLEUIPASTESPECIALA, LPOLEUIPASTESPECIALA;

interface IOleUILinkContainerW : IUnknown
{
    HRESULT QueryInterface(REFIID, PVOID*);
    ULONG AddRef();
    ULONG Release();
    DWORD GetNextLink(DWORD dwLink);
    HRESULT SetLinkUpdateOptions(DWORD, DWORD);
    HRESULT GetLinkUpdateOptions(DWORD, PDWORD);
    HRESULT SetLinkSource(DWORD, LPWSTR, ULONG, PULONG, BOOL);
    HRESULT GetLinkSource(DWORD, LPWSTR*, PULONG, LPWSTR*, LPWSTR*, BOOL*, BOOL*);
    HRESULT OpenLinkSource(DWORD);
    HRESULT UpdateLink(DWORD, BOOL, BOOL);
    HRESULT CancelLink(DWORD);
}
alias IOleUILinkContainerW LPOLEUILINKCONTAINERW;

interface IOleUILinkContainerA : IUnknown
{
    HRESULT QueryInterface(REFIID, PVOID*);
    ULONG AddRef();
    ULONG Release();
    DWORD GetNextLink(DWORD);
    HRESULT SetLinkUpdateOptions(DWORD, DWORD);
    HRESULT GetLinkUpdateOptions(DWORD, PDWORD);
    HRESULT SetLinkSource(DWORD, LPSTR, ULONG, PULONG, BOOL);
    HRESULT GetLinkSource(DWORD, LPSTR*, PULONG, LPSTR*, LPSTR*, BOOL*, BOOL*);
    HRESULT OpenLinkSource(DWORD);
    HRESULT UpdateLink(DWORD, BOOL, BOOL);
    HRESULT CancelLink(DWORD);
}
alias IOleUILinkContainerA LPOLEUILINKCONTAINERA;

struct OLEUIEDITLINKSW {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCWSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCWSTR lpszTemplate;
    HRSRC hResource;
    LPOLEUILINKCONTAINERW lpOleUILinkContainer;
}
alias OLEUIEDITLINKSW* POLEUIEDITLINKSW, LPOLEUIEDITLINKSW;

struct OLEUIEDITLINKSA {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCSTR lpszTemplate;
    HRSRC hResource;
    LPOLEUILINKCONTAINERA lpOleUILinkContainer;
}
alias OLEUIEDITLINKSA* POLEUIEDITLINKSA, LPOLEUIEDITLINKSA;

struct OLEUICHANGEICONW {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCWSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCWSTR lpszTemplate;
    HRSRC hResource;
    HGLOBAL hMetaPict;
    CLSID clsid;
    WCHAR[MAX_PATH] szIconExe = 0;
    int cchIconExe;
}
alias OLEUICHANGEICONW* POLEUICHANGEICONW, LPOLEUICHANGEICONW;

struct OLEUICHANGEICONA {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCSTR lpszTemplate;
    HRSRC hResource;
    HGLOBAL hMetaPict;
    CLSID clsid;
    CHAR[MAX_PATH] szIconExe = 0;
    int cchIconExe;
}
alias OLEUICHANGEICONA* POLEUICHANGEICONA, LPOLEUICHANGEICONA;

struct OLEUICONVERTW {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCWSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCWSTR lpszTemplate;
    HRSRC hResource;
    CLSID clsid;
    CLSID clsidConvertDefault;
    CLSID clsidActivateDefault;
    CLSID clsidNew;
    DWORD dvAspect;
    WORD wFormat;
    BOOL fIsLinkedObject;
    HGLOBAL hMetaPict;
    LPWSTR lpszUserType;
    BOOL fObjectsIconChanged;
    LPWSTR lpszDefLabel;
    UINT cClsidExclude;
    LPCLSID lpClsidExclude;
}
alias OLEUICONVERTW* POLEUICONVERTW, LPOLEUICONVERTW;

struct OLEUICONVERTA {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCSTR lpszTemplate;
    HRSRC hResource;
    CLSID clsid;
    CLSID clsidConvertDefault;
    CLSID clsidActivateDefault;
    CLSID clsidNew;
    DWORD dvAspect;
    WORD wFormat;
    BOOL fIsLinkedObject;
    HGLOBAL hMetaPict;
    LPSTR lpszUserType;
    BOOL fObjectsIconChanged;
    LPSTR lpszDefLabel;
    UINT cClsidExclude;
    LPCLSID lpClsidExclude;
}
alias OLEUICONVERTA* POLEUICONVERTA, LPOLEUICONVERTA;

struct OLEUIBUSYW {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCWSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCWSTR lpszTemplate;
    HRSRC hResource;
    HTASK hTask;
    HWND *lphWndDialog;
}
alias OLEUIBUSYW* POLEUIBUSYW, LPOLEUIBUSYW;

struct OLEUIBUSYA {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCSTR lpszTemplate;
    HRSRC hResource;
    HTASK hTask;
    HWND *lphWndDialog;
}
alias OLEUIBUSYA* POLEUIBUSYA, LPOLEUIBUSYA;

struct OLEUICHANGESOURCEW {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCWSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCWSTR lpszTemplate;
    HRSRC hResource;
    OPENFILENAMEW* lpOFN;
    DWORD[4] dwReserved1;
    LPOLEUILINKCONTAINERW lpOleUILinkContainer;
    DWORD dwLink;
    LPWSTR lpszDisplayName;
    ULONG nFileLength;
    LPWSTR lpszFrom;
    LPWSTR lpszTo;
}
alias OLEUICHANGESOURCEW* POLEUICHANGESOURCEW, LPOLEUICHANGESOURCEW;

struct OLEUICHANGESOURCEA {
    DWORD cbStruct;
    DWORD dwFlags;
    HWND hWndOwner;
    LPCSTR lpszCaption;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    HINSTANCE hInstance;
    LPCSTR lpszTemplate;
    HRSRC hResource;
    OPENFILENAMEA *lpOFN;
    DWORD[4] dwReserved1;
    LPOLEUILINKCONTAINERA lpOleUILinkContainer;
    DWORD dwLink;
    LPSTR lpszDisplayName;
    ULONG nFileLength;
    LPSTR lpszFrom;
    LPSTR lpszTo;
}
alias OLEUICHANGESOURCEA* POLEUICHANGESOURCEA, LPOLEUICHANGESOURCEA;

interface IOleUIObjInfoW : IUnknown
{
    HRESULT QueryInterface(REFIID, PVOID*);
    ULONG AddRef();
    ULONG Release();
    HRESULT GetObjectInfo(DWORD, PDWORD, LPWSTR*, LPWSTR*, LPWSTR*, LPWSTR*);
    HRESULT GetConvertInfo(DWORD, CLSID*, PWORD, CLSID*, LPCLSID*, UINT*);
    HRESULT ConvertObject(DWORD, REFCLSID);
    HRESULT GetViewInfo(DWORD, HGLOBAL*, PDWORD, int*);
    HRESULT SetViewInfo(DWORD, HGLOBAL, DWORD, int, BOOL);
}
alias IOleUIObjInfoW LPOLEUIOBJINFOW;

interface IOleUIObjInfoA : IUnknown
{
    HRESULT QueryInterface(REFIID, PVOID*);
    ULONG AddRef();
    ULONG Release();
    HRESULT GetObjectInfo(DWORD, PDWORD, LPSTR*, LPSTR*, LPSTR*, LPSTR*);
    HRESULT GetConvertInfo(DWORD, CLSID*, PWORD, CLSID*, LPCLSID*, UINT*);
    HRESULT ConvertObject(DWORD, REFCLSID);
    HRESULT GetViewInfo(DWORD, HGLOBAL*, PDWORD, int*);
    HRESULT SetViewInfo(DWORD, HGLOBAL, DWORD, int, BOOL);
}
alias IOleUIObjInfoA LPOLEUIOBJINFOA;

interface IOleUILinkInfoW : IOleUILinkContainerW
{
    HRESULT QueryInterface(REFIID, PVOID*);
    ULONG AddRef();
    ULONG Release();
    DWORD GetNextLink(DWORD);
    HRESULT SetLinkUpdateOptions(DWORD, DWORD);
    HRESULT GetLinkUpdateOptions(DWORD, DWORD*);
    HRESULT SetLinkSource(DWORD, LPWSTR, ULONG, PULONG, BOOL);
    HRESULT GetLinkSource(DWORD, LPWSTR*, PULONG, LPWSTR*, LPWSTR*, BOOL*, BOOL*);
    HRESULT OpenLinkSource(DWORD);
    HRESULT UpdateLink(DWORD, BOOL, BOOL);
    HRESULT CancelLink(DWORD);
    HRESULT GetLastUpdate(DWORD, FILETIME*);
}
alias IOleUILinkInfoW LPOLEUILINKINFOW;

interface IOleUILinkInfoA : IOleUILinkContainerA
{
    HRESULT QueryInterface(REFIID, PVOID*);
    ULONG AddRef();
    ULONG Release();
    DWORD GetNextLink(DWORD);
    HRESULT SetLinkUpdateOptions(DWORD, DWORD);
    HRESULT GetLinkUpdateOptions(DWORD, DWORD*);
    HRESULT SetLinkSource(DWORD, LPSTR, ULONG, PULONG, BOOL);
    HRESULT GetLinkSource(DWORD, LPSTR*, PULONG, LPSTR*, LPSTR*, BOOL*, BOOL*);
    HRESULT OpenLinkSource(DWORD);
    HRESULT UpdateLink(DWORD, BOOL, BOOL);
    HRESULT CancelLink(DWORD);
    HRESULT GetLastUpdate(DWORD, FILETIME*);
}
alias IOleUILinkInfoA LPOLEUILINKINFOA;

struct OLEUIGNRLPROPSW {
    DWORD cbStruct;
    DWORD dwFlags;
    DWORD[2] dwReserved1;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    DWORD[3] dwReserved2;
    OLEUIOBJECTPROPSW* lpOP;
}
alias OLEUIGNRLPROPSW* POLEUIGNRLPROPSW, LPOLEUIGNRLPROPSW;

struct OLEUIGNRLPROPSA {
    DWORD cbStruct;
    DWORD dwFlags;
    DWORD[2] dwReserved1;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    DWORD[3] dwReserved2;
    OLEUIOBJECTPROPSA* lpOP;
}
alias OLEUIGNRLPROPSA* POLEUIGNRLPROPSA, LPOLEUIGNRLPROPSA;

struct OLEUIVIEWPROPSW {
    DWORD cbStruct;
    DWORD dwFlags;
    DWORD[2] dwReserved1;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    DWORD[3] dwReserved2;
    OLEUIOBJECTPROPSW* lpOP;
    int nScaleMin;
    int nScaleMax;
}
alias OLEUIVIEWPROPSW* POLEUIVIEWPROPSW, LPOLEUIVIEWPROPSW;

struct OLEUIVIEWPROPSA {
    DWORD cbStruct;
    DWORD dwFlags;
    DWORD[2] dwReserved1;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    DWORD[3] dwReserved2;
    OLEUIOBJECTPROPSA *lpOP;
    int nScaleMin;
    int nScaleMax;
}
alias OLEUIVIEWPROPSA* POLEUIVIEWPROPSA, LPOLEUIVIEWPROPSA;

struct OLEUILINKPROPSW {
    DWORD cbStruct;
    DWORD dwFlags;
    DWORD[2] dwReserved1;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    DWORD[3] dwReserved2;
    OLEUIOBJECTPROPSW *lpOP;
}
alias OLEUILINKPROPSW* POLEUILINKPROPSW, LPOLEUILINKPROPSW;

struct OLEUILINKPROPSA {
    DWORD cbStruct;
    DWORD dwFlags;
    DWORD[2] dwReserved1;
    LPFNOLEUIHOOK lpfnHook;
    LPARAM lCustData;
    DWORD[3] dwReserved2;
    OLEUIOBJECTPROPSA* lpOP;
}
alias OLEUILINKPROPSA*  POLEUILINKPROPSA, LPOLEUILINKPROPSA;

struct OLEUIOBJECTPROPSW {
    DWORD cbStruct;
    DWORD dwFlags;
    LPPROPSHEETHEADERW lpPS;
    DWORD dwObject;
    LPOLEUIOBJINFOW lpObjInfo;
    DWORD dwLink;
    LPOLEUILINKINFOW lpLinkInfo;
    LPOLEUIGNRLPROPSW lpGP;
    LPOLEUIVIEWPROPSW lpVP;
    LPOLEUILINKPROPSW lpLP;
}
alias OLEUIOBJECTPROPSW* POLEUIOBJECTPROPSW, LPOLEUIOBJECTPROPSW;

struct OLEUIOBJECTPROPSA {
    DWORD cbStruct;
    DWORD dwFlags;
    LPPROPSHEETHEADERA lpPS;
    DWORD dwObject;
    LPOLEUIOBJINFOA lpObjInfo;
    DWORD dwLink;
    LPOLEUILINKINFOA lpLinkInfo;
    LPOLEUIGNRLPROPSA lpGP;
    LPOLEUIVIEWPROPSA lpVP;
    LPOLEUILINKPROPSA lpLP;
}
alias OLEUIOBJECTPROPSA* POLEUIOBJECTPROPSA, LPOLEUIOBJECTPROPSA;

extern (Windows) {
    BOOL OleUIAddVerbMenuW(LPOLEOBJECT, LPCWSTR, HMENU, UINT, UINT, UINT, BOOL, UINT, HMENU*);
    BOOL OleUIAddVerbMenuA(LPOLEOBJECT, LPCSTR, HMENU, UINT, UINT, UINT, BOOL, UINT, HMENU*);
    UINT OleUIBusyW(LPOLEUIBUSYW);
    UINT OleUIBusyA(LPOLEUIBUSYA);
    BOOL OleUICanConvertOrActivateAs(REFCLSID, BOOL, WORD);
    UINT OleUIChangeIconW(LPOLEUICHANGEICONW);
    UINT OleUIChangeIconA(LPOLEUICHANGEICONA);
    UINT OleUIChangeSourceW(LPOLEUICHANGESOURCEW);
    UINT OleUIChangeSourceA(LPOLEUICHANGESOURCEA);
    UINT OleUIConvertW(LPOLEUICONVERTW);
    UINT OleUIConvertA(LPOLEUICONVERTA);
    UINT OleUIEditLinksW(LPOLEUIEDITLINKSW);
    UINT OleUIEditLinksA(LPOLEUIEDITLINKSA);
    UINT OleUIObjectPropertiesW(LPOLEUIOBJECTPROPSW);
    UINT OleUIObjectPropertiesA(LPOLEUIOBJECTPROPSA);
    UINT OleUIPasteSpecialW(LPOLEUIPASTESPECIALW);
    UINT OleUIPasteSpecialA(LPOLEUIPASTESPECIALA);
    BOOL OleUIUpdateLinksW(LPOLEUILINKCONTAINERW, HWND, LPWSTR, int);
    BOOL OleUIUpdateLinksA(LPOLEUILINKCONTAINERA, HWND, LPSTR, int);
}

extern (C) {
    int OleUIPromptUserW(int, HWND, ...);
    int OleUIPromptUserA(int, HWND, ...);
}

version (Unicode) {
    alias IDD_SERVERNOTREGW IDD_SERVERNOTREG;
    alias IDD_LINKTYPECHANGEDW IDD_LINKTYPECHANGED;
    alias OleUIUpdateLinksW OleUIUpdateLinks;
    alias OleUIAddVerbMenuW OleUIAddVerbMenu;
    alias OLEUIOBJECTPROPSW OLEUIOBJECTPROPS;
    alias POLEUIOBJECTPROPSW POLEUIOBJECTPROPS;
    alias LPOLEUIOBJECTPROPSW LPOLEUIOBJECTPROPS;
    alias OleUIObjectPropertiesW OleUIObjectProperties;
    alias OLEUIINSERTOBJECTW OLEUIINSERTOBJECT;
    alias POLEUIINSERTOBJECTW POLEUIINSERTOBJECT;
    alias LPOLEUIINSERTOBJECTW LPOLEUIINSERTOBJECT;
    alias OleUIInsertObjectW OleUIInsertObject;
    alias OleUIPromptUserW OleUIPromptUser;
    alias OLEUIPASTEENTRYW OLEUIPASTEENTRY;
    alias POLEUIPASTEENTRYW POLEUIPASTEENTRY;
    alias LPOLEUIPASTEENTRYW LPOLEUIPASTEENTRY;
    alias OLEUIPASTESPECIALW OLEUIPASTESPECIAL;
    alias POLEUIPASTESPECIALW POLEUIPASTESPECIAL;
    alias LPOLEUIPASTESPECIALW LPOLEUIPASTESPECIAL;
    alias OleUIPasteSpecialW OleUIPasteSpecial;
    alias IOleUILinkContainerW IOleUILinkContainer;
    alias LPOLEUILINKCONTAINERW LPOLEUILINKCONTAINER;
    alias OLEUIEDITLINKSW OLEUIEDITLINKS;
    alias POLEUIEDITLINKSW POLEUIEDITLINKS;
    alias LPOLEUIEDITLINKSW LPOLEUIEDITLINKS;
    alias OleUIEditLinksW OleUIEditLinks;
    alias OLEUICHANGEICONW OLEUICHANGEICON;
    alias POLEUICHANGEICONW POLEUICHANGEICON;
    alias LPOLEUICHANGEICONW LPOLEUICHANGEICON;
    alias OleUIChangeIconW OleUIChangeIcon;
    alias OLEUICONVERTW OLEUICONVERT;
    alias POLEUICONVERTW POLEUICONVERT;
    alias LPOLEUICONVERTW LPOLEUICONVERT;
    alias OleUIConvertW OleUIConvert;
    alias OLEUIBUSYW OLEUIBUSY;
    alias POLEUIBUSYW POLEUIBUSY;
    alias LPOLEUIBUSYW LPOLEUIBUSY;
    alias OleUIBusyW OleUIBusy;
    alias OLEUICHANGESOURCEW OLEUICHANGESOURCE;
    alias POLEUICHANGESOURCEW POLEUICHANGESOURCE;
    alias LPOLEUICHANGESOURCEW LPOLEUICHANGESOURCE;
    alias OleUIChangeSourceW OleUIChangeSource;
    alias IOleUIObjInfoW IOleUIObjInfo;
    alias LPOLEUIOBJINFOW LPOLEUIOBJINFO;
    alias IOleUILinkInfoW IOleUILinkInfo;
    //alias IOleUILinkInfoWVtbl IOleUILinkInfoVtbl;
    alias LPOLEUILINKINFOW LPOLEUILINKINFO;
    alias OLEUIGNRLPROPSW OLEUIGNRLPROPS;
    alias POLEUIGNRLPROPSW POLEUIGNRLPROPS;
    alias LPOLEUIGNRLPROPSW LPOLEUIGNRLPROPS;
    alias OLEUIVIEWPROPSW OLEUIVIEWPROPS;
    alias POLEUIVIEWPROPSW POLEUIVIEWPROPS;
    alias LPOLEUIVIEWPROPSW LPOLEUIVIEWPROPS;
    alias OLEUILINKPROPSW OLEUILINKPROPS;
    alias POLEUILINKPROPSW POLEUILINKPROPS;
    alias LPOLEUILINKPROPSW LPOLEUILINKPROPS;
} else {
    alias IDD_SERVERNOTREGA IDD_SERVERNOTREG;
    alias IDD_LINKTYPECHANGEDA IDD_LINKTYPECHANGED;
    alias OleUIUpdateLinksA OleUIUpdateLinks;
    alias OleUIAddVerbMenuA OleUIAddVerbMenu;
    alias OLEUIOBJECTPROPSA OLEUIOBJECTPROPS;
    alias POLEUIOBJECTPROPSA POLEUIOBJECTPROPS;
    alias LPOLEUIOBJECTPROPSA LPOLEUIOBJECTPROPS;
    alias OleUIObjectPropertiesA OleUIObjectProperties;
    alias OLEUIINSERTOBJECTA OLEUIINSERTOBJECT;
    alias POLEUIINSERTOBJECTA POLEUIINSERTOBJECT;
    alias LPOLEUIINSERTOBJECTA LPOLEUIINSERTOBJECT;
    alias OleUIInsertObjectA OleUIInsertObject;
    alias OleUIPromptUserA OleUIPromptUser;
    alias OLEUIPASTEENTRYA OLEUIPASTEENTRY;
    alias POLEUIPASTEENTRYA POLEUIPASTEENTRY;
    alias LPOLEUIPASTEENTRYA LPOLEUIPASTEENTRY;
    alias OLEUIPASTESPECIALA OLEUIPASTESPECIAL;
    alias POLEUIPASTESPECIALA POLEUIPASTESPECIAL;
    alias LPOLEUIPASTESPECIALA LPOLEUIPASTESPECIAL;
    alias OleUIPasteSpecialA OleUIPasteSpecial;
    alias IOleUILinkContainerA IOleUILinkContainer;
    alias LPOLEUILINKCONTAINERA LPOLEUILINKCONTAINER;
    alias OLEUIEDITLINKSA OLEUIEDITLINKS;
    alias POLEUIEDITLINKSA POLEUIEDITLINKS;
    alias LPOLEUIEDITLINKSA LPOLEUIEDITLINKS;
    alias OleUIEditLinksA OleUIEditLinks;
    alias OLEUICHANGEICONA OLEUICHANGEICON;
    alias POLEUICHANGEICONA POLEUICHANGEICON;
    alias LPOLEUICHANGEICONA LPOLEUICHANGEICON;
    alias OleUIChangeIconA OleUIChangeIcon;
    alias OLEUICONVERTA OLEUICONVERT;
    alias POLEUICONVERTA POLEUICONVERT;
    alias LPOLEUICONVERTA LPOLEUICONVERT;
    alias OleUIConvertA OleUIConvert;
    alias OLEUIBUSYA OLEUIBUSY;
    alias POLEUIBUSYA POLEUIBUSY;
    alias LPOLEUIBUSYA LPOLEUIBUSY;
    alias OleUIBusyA OleUIBusy;
    alias OLEUICHANGESOURCEA OLEUICHANGESOURCE;
    alias POLEUICHANGESOURCEA POLEUICHANGESOURCE;
    alias LPOLEUICHANGESOURCEA LPOLEUICHANGESOURCE;
    alias OleUIChangeSourceA OleUIChangeSource;
    alias IOleUIObjInfoA IOleUIObjInfo;
    alias LPOLEUIOBJINFOA LPOLEUIOBJINFO;
    alias IOleUILinkInfoA IOleUILinkInfo;
    //alias IOleUILinkInfoAVtbl IOleUILinkInfoVtbl;
    alias LPOLEUILINKINFOA LPOLEUILINKINFO;
    alias OLEUIGNRLPROPSA OLEUIGNRLPROPS;
    alias POLEUIGNRLPROPSA POLEUIGNRLPROPS;
    alias LPOLEUIGNRLPROPSA LPOLEUIGNRLPROPS;
    alias OLEUIVIEWPROPSA OLEUIVIEWPROPS;
    alias POLEUIVIEWPROPSA POLEUIVIEWPROPS;
    alias LPOLEUIVIEWPROPSA LPOLEUIVIEWPROPS;
    alias OLEUILINKPROPSA OLEUILINKPROPS;
    alias POLEUILINKPROPSA POLEUILINKPROPS;
    alias LPOLEUILINKPROPSA LPOLEUILINKPROPS;
}
