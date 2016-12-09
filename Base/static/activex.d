module sys.activex;
/***************************************************************
 * $HeadURL: http://svn.dsource.org/projects/core32/trunk/activex/activex.d $
 * $Revision: 39 $
 * $Дата: 2009-05-23 02:44:15 +0400 (Сб, 23 май 2009) $
 * $Author: l8night $
 */

import win, stdrus, tpl.args;

pragma(lib, "DinrusWin32.lib");
//pragma(lib, "import.lib");

import win32.winnt, win32.winnls, win32.uuid, win32.wtypes, win32.basetyps;
import win32.oaidl, win32.objbase; /* for VARIANTARG */

class ИсклАктивОбъ: Исключение
{
this(ткст сооб){super(сооб);}
}

class АктивОбъ
{
    private static LCID defaultLCID;
export:

    static this()
    {
        defaultLCID = GetUserDefaultLCID();
        CoInitialize(пусто);
    }

    static ~this()
    {
        CoUninitialize();
    }

    struct MemberDef
    {
        ткст имя;
        DISPID dispid;
        INVOKEKIND invkind;
        FUNCDESC * pFuncDesc;
    }

    private win32.oaidl.ITypeInfo [FUNCDESC *] allFuncDescs;
    private win32.oaidl.ITypeInfo typeInfo;
    private win32.oaidl.IDispatch pIDispatch;
    private MemberDef [] allMembers;
    private ткст [ DISPID ] methods;
    private ткст [ DISPID ] getters;
        private SHORT [ DISPID ] returns;
    private ткст [ DISPID ] setters;
    private ткст [ DISPID ] settersbyref;

    this(ткст имяПриложения)
    {
        шим* prog = вЮ16н(имяПриложения);
        CLSID clsid;
        HRESULT hr = CLSIDFromProgID(cast(шим*)prog, &clsid);
        hr = CoCreateInstance(&clsid, пусто, win32.objbase.CLSCTX_SERVER, &win32.uuid.IID_IDispatch, cast(void**)&pIDispatch);
        загрузиСостав();
    }

    ~this()
    {
        foreach (FUNCDESC* pFuncDesc, win32.oaidl.ITypeInfo иот; allFuncDescs)
            иот.ReleaseFuncDesc(cast(FUNCDESC *)pFuncDesc);
    }

    void загрузиСостав()
    {
        HRESULT hr = pIDispatch.GetTypeInfo(0,defaultLCID, &typeInfo);
        загрузиСостав(typeInfo);
    }

    void загрузиСостав(win32.oaidl.ITypeInfo pTypeInfo)
    {
        TYPEATTR * pTypeAttr;
        HRESULT hr = pTypeInfo.GetTypeAttr(&pTypeAttr);

        for(бцел i;i<pTypeAttr.cImplTypes;++i)
        {
            HREFTYPE pRefType;
            hr = pTypeInfo.GetRefTypeOfImplType(i,&pRefType);
            win32.oaidl.ITypeInfo  ppTInfo;
            hr = pTypeInfo.GetRefTypeInfo(pRefType,&ppTInfo);
            загрузиСостав(ppTInfo);
        }

        for(бцел i;i<pTypeAttr.cFuncs;++i)
        {
            MemberDef mem;
            hr = pTypeInfo.GetFuncDesc(i,& mem.pFuncDesc);
            FUNCDESC * pFuncDesc=mem.pFuncDesc;

            allFuncDescs[pFuncDesc] = pTypeInfo;

            шим * methodName;
            hr = pTypeInfo.GetDocumentation(pFuncDesc.memid, &methodName, пусто, пусто, пусто);

            шим [] tmp;
            бцел l=wcslen(methodName);
            tmp.length=l;
            for (бцел j;j<l;++j)
                tmp[j]=methodName[j];
            ткст theName_i=вЮ8(tmp);
            ткст theName = theName_i.dup;

            mem.имя=theName;
            mem.invkind=pFuncDesc.invkind;

            DISPID dispid/* = pFuncDesc.memid*/;
            //*
            hr = pIDispatch.GetIDsOfNames(cast(REFIID) &IID_NULL, &methodName, 1, defaultLCID, &dispid);
            mem.dispid=dispid;
            /**/
            allMembers ~= mem;
            SysFreeString (methodName);

            switch (mem.invkind)
            {
                case INVOKE_FUNC:
					methods[dispid] = theName;
                    break;
                case INVOKE_PROPERTYGET:
                    getters[dispid] = theName;
                    returns[dispid] = cast(SHORT) pFuncDesc.lprgelemdescParam[0].tdesc.vt;
                    break;
                case INVOKE_PROPERTYPUT:
                    setters[dispid] = theName;
                    break;
                case INVOKE_PROPERTYPUTREF:
                    settersbyref[dispid] = theName;
                    break;
                default:
            }
        }

        pTypeInfo.ReleaseTypeAttr(pTypeAttr);
    }

	public void покажиСостав()
	{

		скажинс("Методы:");		
		foreach(ткст ключ; methods)
			скажинс(фм("\t%s", ключ));

		скажинс("Получатели:");
		foreach(DISPID value, ткст ключ; getters)
			скажинс(фм("\t%s", ключ));

		скажинс("Установщики:");
		foreach(DISPID value, ткст ключ; setters)
			скажинс(фм("\t%s", ключ));

		скажинс("Установщики по ссылке:");
		foreach(DISPID value, ткст ключ; settersbyref)
			скажинс(фм("\t%s", ключ));

/+		
    private SHORT [ DISPID ] returns;
+/
		
	}
	
    VARIANTARG [] делайМассив(TypeInfo [] args, ук ptr)
    {
        VARIANTARG [] массив;
        массив.length = args.length;

        for (бцел i;i<args.length;++i)
        {
            if (args[i] == typeid(VARIANTARG))
                массив [i] = va_arg!(VARIANTARG)(ptr);
            else
                throw new ИсклАктивОбъ( "Ожидались аргументы типа Варарг" );
        }

        return массив;
    }

    private DISPID найдиЧлен(ткст member, INVOKEKIND ik)
    {
        INVOKEKIND tmp=0xffff;
        foreach(inout MemberDef mem; allMembers)
            if (mem.имя==member)
                if (mem.invkind==ik)
                    return mem.dispid;
                else
                    tmp=mem.invkind;

        if (tmp==0xffff)
            throw new ИсклАктивОбъ(фм("отсутствует член '%s'",member));
        else
		    throw new ИсклАктивОбъ(фм("член '%s' найден с ПТипВызова %s",member,tmp));
    }

    VARIANT дай(ткст member)
    {
        INVOKEKIND ik=INVOKE_PROPERTYGET;
        DISPID dispid = найдиЧлен(member,ik);

        if (!(dispid in getters))
            throw new ИсклАктивОбъ("можно получить только свойства");

        DISPPARAMS param;
        VARIANT result;
        HRESULT hr = pIDispatch.Invoke(dispid, cast(REFIID) &IID_NULL, defaultLCID,
                                       ik, &param, &result, пусто, пусто);
        return result;
    }

    void установи(ткст member,VARIANTARG арг)
    {
        INVOKEKIND ik=INVOKE_PROPERTYPUT;
        DISPID dispid = найдиЧлен(member,ik);

        if (!(dispid in setters))
            throw new ИсклАктивОбъ("можно только установить свойства");

        VARIANTARG [] myArgs = (&арг)[0..1];

        DISPPARAMS param;
        param.cArgs=myArgs.length;
        param.rgvarg=myArgs.ptr;

        DISPID dispidNamed = DISPID_PROPERTYPUT;
        param.cNamedArgs = 1;
        param.rgdispidNamedArgs = &dispidNamed;

        HRESULT hr = pIDispatch.Invoke(dispid, cast(REFIID) &IID_NULL, defaultLCID,
                                       ik, &param, пусто, пусто, пусто);
    }

    void установиПоСсыл(ткст member,VARIANTARG арг)
    {
        INVOKEKIND ik=INVOKE_PROPERTYPUTREF;
        DISPID dispid = найдиЧлен(member,ik);

        if (!(dispid in settersbyref))
            throw new ИсклАктивОбъ("можно только установить свойства");

        VARIANTARG [] myArgs = (&арг)[0..1];

        DISPPARAMS param;
        param.cArgs=myArgs.length;
        param.rgvarg=myArgs.ptr;

        DISPID dispidNamed = DISPID_PROPERTYPUT;
        param.cNamedArgs = 1;
        param.rgdispidNamedArgs = &dispidNamed;

        VARIANT * result;
        HRESULT hr = pIDispatch.Invoke(dispid, cast(REFIID) &IID_NULL, defaultLCID,
                                       ik, &param, result, пусто, пусто);
    }

    VARIANT вызови(ткст member,...)
    {

        /* Can I change the ткст into a variant? */


        INVOKEKIND ik = INVOKE_FUNC;
        DISPID dispid = найдиЧлен(member,ik);

        if (!(dispid in methods))
            throw new ИсклАктивОбъ("можно только вызывать методы");

        VARIANTARG [] myArgs = делайМассив(_arguments,_argptr);

        DISPPARAMS param;
        param.cArgs=myArgs.length;
        param.rgvarg=myArgs.ptr;

		debug пишиф("Calling %s...", member);
		
        VARIANT result;
        HRESULT hr = pIDispatch.Invoke(dispid, cast(REFIID) &IID_NULL, defaultLCID,
                                       ik, &param, &result, пусто, пусто);
        return result;
    }
}




export extern(D) VARIANTARG вар(...)
{
    VARIANTARG variant;

    if (_arguments.length < 1)
        return VARIANT.init;

    if(_arguments.length == 1)
    {

        /* Strings */

        if (_arguments[0] == typeid(шим[]))
        {
            debug пишиф("шим[]\t");
            variant.vt = VARENUM.VT_BSTR;
            variant.bstrVal = cast(шим*) (va_arg!(ткст)(_argptr) ~ "\0");
        }

        else if (_arguments[0] == typeid(ткст))
        {
            debug пишиф("ткст\t");
            variant.vt = VARENUM.VT_BSTR;
            шим[] buf = вЮ16(va_arg!(ткст)(_argptr) ~ "\0");
            variant.bstrVal = SysAllocString( cast(шим*)(buf.ptr) );
        }


        /* Unsigned Integers */

        else if (_arguments[0] == typeid(bool))
        {
            debug пишиф("bool\t");
            variant.vt = VARENUM.VT_BOOL;            
            if(va_arg!(bool)(_argptr) == true)
                variant.boolVal = 1;
            else
                variant.boolVal = 0;                
        }
        else if (_arguments[0] == typeid(ubyte))
        {
            debug пишиф("ubyte\t");
            variant.vt = VARENUM.VT_UI1; /* I'm not sure about this. */
            variant.bVal = va_arg!(ubyte)(_argptr);
        }
        else if (_arguments[0] == typeid(ushort))
        {
            debug пишиф("ushort\t");
            variant.vt = VARENUM.VT_UI2; /* I'm not sure about this. */
            variant.uiVal = va_arg!(ushort)(_argptr);
        }
        else if (_arguments[0] == typeid(бцел))
        {
            debug пишиф("бцел\t");
            variant.vt = VARENUM.VT_UI4; /* I'm not sure about this. */
            variant.ulVal = va_arg!(бцел)(_argptr);
        }
        else if (_arguments[0] == typeid(ulong)) /* 8 биты */
        {
            debug пишиф("ulong\t");
            variant.vt = VARENUM.VT_UI4; /* 4 биты -- дол won't fit! */
            variant.lVal = va_arg!(ulong)(_argptr);
        }


        /* Signed Integers */

        else if (_arguments[0] == typeid(byte))
        {
            debug пишиф("byte\t");
            variant.vt = VARENUM.VT_I1; /* I'm not sure about this. */
            variant. cVal = va_arg!(byte)(_argptr);
        }
        else if (_arguments[0] == typeid(крат))
        {
            debug пишиф("крат\t");
            variant.vt = VARENUM.VT_I2; 
            variant.iVal = va_arg!(крат)(_argptr);
        }
        else if (_arguments[0] == typeid(цел))
        {
            debug пишиф("цел\t");
            variant.vt = VARENUM.VT_I4; 
            variant.lVal = va_arg!(цел)(_argptr);
        }
        else if (_arguments[0] == typeid(дол)) /* 8 биты */
        {
            debug пишиф("дол\t");
            variant.vt = VARENUM.VT_I4; /* 4 биты -- дол might not fit! */
            variant.lVal = cast(цел) va_arg!(дол)(_argptr);
        }


        /* Floating Point */

        else if (_arguments[0] == typeid(float))
        {
            debug пишиф("float\t");
            variant.vt = VARENUM.VT_R4; 
            variant.fltVal = va_arg!(float)(_argptr);
        }
        else if (_arguments[0] == typeid(double))
        {
            debug пишиф("double\t");
            variant.vt = VARENUM.VT_R8; 
            variant.dblVal = va_arg!(double)(_argptr);
        }


        /* objects */

		else if (_arguments[0] == typeid(Object)) 
			/* need to be an AXO to work right now */
		{
            debug пишиф("object\t");
			variant.vt = VARENUM.VT_BYREF; //VARENUM.VT_STORED_OBJECT; /* I doubt this is right. */
			variant.byref = cast(void*)( va_arg!(Object)(_argptr) );
				/* need to дай some kind of pointer from the AXO object */
		}
		

        else
            throw new ИсклАктивОбъ("вар не представляет, что с этим делать.");

    }
    else 
        throw new ИсклАктивОбъ("[нереализованно] вар ещё не способен к использованию нескольких аргументов");

    return variant;
}

export extern(D) АктивОбъ объАктив(ткст арг){return new АктивОбъ(арг);}


extern(C)
цел wcslen(шим*);

extern(Windows)
{
    alias бцел tagINVOKEKIND;
    alias tagINVOKEKIND INVOKEKIND;
    enum :INVOKEKIND
    {
        INVOKE_FUNC    = 1,
        INVOKE_PROPERTYGET    = 2,
        INVOKE_PROPERTYPUT    = 4,
        INVOKE_PROPERTYPUTREF    = 8
    }

    const WORD DISPATCH_METHOD = 0x1;
    const WORD DISPATCH_PROPERTYGET = 0x2;
    const WORD DISPATCH_PROPERTYPUT = 0x4;
    const WORD DISPATCH_PROPERTYPUTREF = 0x8;
    alias win32.uuid.GUID_NULL IID_NULL;

    HRESULT CLSIDFromProgID (LPCOLESTR lpszProgID, CLSID * lpclsid);
    LCID GetUserDefaultLCID();
    BSTR SysAllocString(OLECHAR *);
    void SysFreeString(шим*);
    DWORD FormatMessageA(DWORD dwFlags,LPCVOID lpSource,DWORD dwMessageId,DWORD dwLanguageId,LPSTR lpBuffer,DWORD nРазмер,va_list *Аргументы);
}
