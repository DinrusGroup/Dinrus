module core.sys.windows.com;
public import winapi: ComObject;
/+
version (Windows):

pragma(lib,"uuid");

import core.atomic;
import core.sys.windows.windef /+: HRESULT, LONG, ULONG+/;
//import std.string;

public import core.sys.windows.basetyps : GUID, IID, CLSID;
public import core.sys.windows.uuid;

public import core.sys.windows.objbase :
    CLSCTX_INPROC, CLSCTX_ALL, CLSCTX_SERVER,
    COINIT,
    CoBuildVersion, StringFromGUID2,
    CoInitialize, CoInitializeEx, CoUninitialize, CoGetCurrentProcess,
    CoCreateInstance,
    CoFreeLibrary, CoFreeAllLibraries, CoFreeUnusedLibraries;

public import core.sys.windows.ole2ver : rmm, rup;

public import core.sys.windows.unknwn : IUnknown, IClassFactory;

public import core.sys.windows.winerror :
    S_OK,
    S_FALSE,
    NOERROR,
    E_NOTIMPL,
    E_NOINTERFACE,
    E_POINTER,
    E_ABORT,
    E_FAIL,
    E_HANDLE,
    CLASS_E_NOAGGREGATION,
    E_OUTOFMEMORY,
    E_INVALIDARG,
    E_UNEXPECTED,
    RPC_E_CHANGED_MODE;

public import core.sys.windows.wtypes :
    OLECHAR, LPOLESTR, LPCOLESTR;

alias  core.sys.windows.wtypes.CLSCTX.CLSCTX_INPROC_SERVER    CLSCTX_INPROC_SERVER;
alias  core.sys.windows.wtypes.CLSCTX.CLSCTX_INPROC_HANDLER   CLSCTX_INPROC_HANDLER;
alias  core.sys.windows.wtypes.CLSCTX.CLSCTX_LOCAL_SERVER     CLSCTX_LOCAL_SERVER;
alias  core.sys.windows.wtypes.CLSCTX.CLSCTX_INPROC_SERVER16 CLSCTX_INPROC_SERVER16 ;
alias  core.sys.windows.wtypes.CLSCTX.CLSCTX_REMOTE_SERVER   CLSCTX_REMOTE_SERVER ;
alias  core.sys.windows.wtypes.CLSCTX.CLSCTX_INPROC_HANDLER16 CLSCTX_INPROC_HANDLER16;
alias  core.sys.windows.wtypes.CLSCTX.CLSCTX_INPROC_SERVERX86 CLSCTX_INPROC_SERVERX86 ;
alias  core.sys.windows.wtypes.CLSCTX.CLSCTX_INPROC_HANDLERX86 CLSCTX_INPROC_HANDLERX86;

alias    COINIT.COINIT_APARTMENTTHREADED COINIT_APARTMENTTHREADED;
alias    COINIT.COINIT_MULTITHREADED  COINIT_MULTITHREADED  ;
alias    COINIT.COINIT_DISABLE_OLE1DDE  COINIT_DISABLE_OLE1DDE;
alias    COINIT.COINIT_SPEED_OVER_MEMORY COINIT_SPEED_OVER_MEMORY;

extern (System)
{

class ComObject : IUnknown
{
extern (System):
    HRESULT QueryInterface(IID* riid, void** ppv)
    {
        if (*riid == IID_IUnknown)
        {
            *ppv = cast(void*)cast(IUnknown)this;
            AddRef();
            return S_OK;
        }
        else
        {   *ppv = null;
            return E_NOINTERFACE;
        }
    }

    ULONG AddRef()
    {
        return atomicOp!("+=")(&count, 1);
    }

    ULONG Release()
    {
        LONG lRef = atomicOp!("-=")(&count, 1);
        if (lRef == 0)
        {
            // free object

            // If we delete this object, then the postinvariant called upon
            // return from Release() will fail.
            // Just let the GC reap it.
            //delete this;

            return 0;
        }
        return cast(ULONG)lRef;
    }

    LONG count = 0;             // object reference count
}

}
+/