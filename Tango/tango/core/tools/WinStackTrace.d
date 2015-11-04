﻿/**
 *   Stacktracing
 *
 *   Inclusion of this module activates traced exceptions using the drTango own tracers if possible
 *
 *  Copyright: 2009 h3r3tic 
 *  License:   drTango license, apache 2.0
 *  Authors:   Tomasz Stachowiak (h3r3tic)
 */
module core.tools.WinStackTrace;
version(Windows) {
    private {
        import util.Demangler;
        import runtime;
        static import cidrus;
        static import stdrus;
        version (StacktraceSpam) import cidrus : printf;
    }

    version = StacktraceTryMatchCallадресes;
    version = StacktraceTryToBeSmart;
    //version = UseCustomFiberForDemangling;
    version = DemangleFunctionNames;

    struct КонтекстСледа{
        LPCONTEXT контекст;
        HANDLE hProcess;
        HANDLE hThread;
    }

    т_мера winAddrBacktrace(КонтекстСледа* winCtx,КонтекстСледа* contextOut,т_мера* буфСледа,т_мера traceBufLength,цел *флаги){
        CONTEXT     контекст;
        CONTEXT*    ctxPtr = &контекст;
        
        HANDLE hProcess =void;
        HANDLE hThread =void;
        
        if (winCtx !is пусто) {
            ctxPtr=winCtx.контекст;
            hProcess=winCtx.hProcess;
            hThread=winCtx.hThread;
        } else {
            бцел eИПReg, espReg, ebpReg;
            asm {
                call GIMMEH_EИП;
                GIMMEH_EИП:
                    pop EAX;
                    mov eИПReg, EAX;
                mov espReg, ESP;
                mov ebpReg, EBP;
            }

            hProcess = GetCurrentProcess();
            hThread = GetCurrentThread();
            
            контекст.ContextFlags = CONTEXT_i386 | CONTEXT_CONTROL;
            GetThreadContext(hThread, &контекст);
            контекст.EИП = eИПReg;
            контекст.Esp = espReg;
            контекст.Ebp = ebpReg;
        }
        if (contextOut !is пусто){
            contextOut.контекст=ctxPtr;
            contextOut.hProcess=hProcess;
            contextOut.hThread=hThread;
        }
        
        version (StacktraceSpam) printf("EИП: %x, Esp: %x, Ebp: %x"\n, ctxPtr.EИП, ctxPtr.Esp, ctxPtr.Ebp);
    
        version (StacktraceUseWinApiStackWalking) {
            // IsBadReadPtr will always return да here
        } else {
            if (IsBadReadPtr(cast(проц*)ctxPtr.Ebp, 4)) {
                ctxPtr.Ebp = ctxPtr.Esp;
            }
        }

        т_мера traceLen = 0;
        walkStack(ctxPtr, hProcess, hThread, delegate проц(т_мера[]tr){
            if (tr.length > traceBufLength) {
                traceLen = traceBufLength;
            } else {
                traceLen = tr.length;
            }

            буфСледа[0..traceLen] = tr[0..traceLen];
        });
        
        version(StacktraceTryMatchCallадресes){
            *флаги=3;
        } else {
            *флаги=1;
        }
        return traceLen;
    }
    
    
    бул winSymbolizeFrameInfo(ref Исключение.ИнфОКадре fInfo, КонтекстСледа *контекст,ткст буф){
        HANDLE hProcess;
        if (контекст!is пусто){
            hProcess=контекст.hProcess;
        } else {
            hProcess=GetCurrentProcess();
        }
        return addrToSymbolDetails(fInfo.адрес, hProcess, (ткст func, ткст файл, цел строка, т_дельтаук адрСмещение) {
            if (func.length > буф.length) {
                буф[] = func[0..буф.length];
                fInfo.func = буф;
            } else {
                буф[0..func.length] = func;
                fInfo.func = буф[0..func.length];
            }
            fInfo.файл = файл;
            fInfo.строка = строка;
            fInfo.offsetSymb = адрСмещение;
        });
    }

//#строка 2 "части/Main.di"


private extern(C) {
    проц        _Dmain();
    проц        D2rt4core6Thread5Fiber3runMFZv();
}
private {
    т_мера  fiberRunFuncLength = 0;
}


проц walkStack(LPCONTEXT ContextRecord, HANDLE hProcess, HANDLE hThread, проц delegate(т_мера[]) traceПриёмr) {
    const цел maxStackSpace = 32;
    const цел maxHeapSpace      = 256;
    static assert (maxHeapSpace  > maxStackSpace);
    
    т_мера[maxStackSpace]   stackTraceArr =void;
    т_мера[]                            heapTraceArr;
    т_мера[]                            stacktrace = stackTraceArr;
    бцел                                i =void;
    
    проц добавьадрес(т_мера адр) {
        if (i < maxStackSpace) {
            stacktrace[i++] = адр;
        } else {
            if (maxStackSpace == i) {
                if (heapTraceArr is пусто) {
                    heapTraceArr.alloc(maxHeapSpace, нет);
                    heapTraceArr[0..maxStackSpace] = stackTraceArr;
                    stacktrace = heapTraceArr;
                }
                stacktrace[i++] = адр;
            } else if (i < maxHeapSpace) {
                stacktrace[i++] = адр;
            }
        }
    }


    version (StacktraceUseWinApiStackWalking) {
        STACKFRAME64 frame;
        memset(&frame, 0, frame.sizeof);

        frame.AddrStack.Offset  = ContextRecord.Esp;
        frame.AddrPC.Offset     = ContextRecord.EИП;
        frame.AddrFrame.Offset  = ContextRecord.Ebp;
        frame.AddrStack.Mode    = frame.AddrPC.Mode = frame.AddrFrame.Mode = ADDRESS_MODE.AddrModeFlat;

        //for (цел sanity = 0; sanity < 256; ++sanity) {
        for (i = 0; i < maxHeapSpace; ) {
            auto swres = StackWalk64(
                IMAGE_FILE_MACHINE_I386,
                hProcess,
                hThread,
                &frame,
                ContextRecord,
                пусто,
                SymFunctionTableAccess64,
                SymGetModuleBase64,
                пусто
            );
            
            if (!swres) {
                break;
            }
            
            version (StacktraceSpam) printf("pc:%x ret:%x frm:%x stk:%x parm:%x %x %x %x"\n,
                    frame.AddrPC.Offset, frame.AddrReturn.Offset, frame.AddrFrame.Offset, frame.AddrStack.Offset,
                    frame.Params[0], frame.Params[1], frame.Params[2], frame.Params[3]);

            добавьадрес(frame.AddrPC.Offset);
        }
    } else {
        struct Выкладка {
            Выкладка* ebp;
            т_мера  ret;
        }
        Выкладка* p = cast(Выкладка*)ContextRecord.Esp;
        
        
        бул foundMain = нет;     
        enum Phase {
            TryEsp,
            TryEbp,
            GiveUp
        }
        
        Phase phase = ContextRecord.Esp == ContextRecord.Ebp ? Phase.TryEbp : Phase.TryEsp;
        stacktrace[0] = ContextRecord.EИП;
        
        version (StacktraceTryToBeSmart) {
            Нить tobj = Нить.getThis();
        }
        
        while (!foundMain && phase < Phase.GiveUp) {
            version (StacktraceSpam) printf("starting a new tracing phase"\n);
            
            version (StacktraceTryToBeSmart) {
                auto curStack = tobj.topContext();
            }
            
            for (i = 1; p && !IsBadReadPtr(p, Выкладка.sizeof) && i < maxHeapSpace && !IsBadReadPtr(cast(проц*)p.ret, 4);) {
                auto sym = p.ret;
                
                enum {
                    NearPtrCallOpcode = 0xe8,
                    RegisterBasedCallOpcode = 0xff
                }

                бцел адрвызова = p.ret;
                if (т_мера.sizeof == 4 && !IsBadReadPtr(cast(проц*)(p.ret - 5), 8) && NearPtrCallOpcode == *cast(ббайт*)(p.ret - 5)) {
                    адрвызова += *cast(бцел*)(p.ret - 4);
                    version (StacktraceSpam) printf("ret:%x frm:%x вызов:%x"\n, sym, p, адрвызова);
                    version (StacktraceTryMatchCallадресes) {
                        добавьадрес(p.ret - 5);  // a near вызов is 5 байты
                    }
                } else {
                    version (StacktraceTryMatchCallадресes) {
                        if (!IsBadReadPtr(cast(проц*)p.ret - 2, 4) && RegisterBasedCallOpcode == *cast(ббайт*)(p.ret - 2)) {
                            version (StacktraceSpam) printf("ret:%x frm:%x регистрируй-based вызов:[%x]"\n, sym, p, *cast(ббайт*)(p.ret - 1));
                            добавьадрес(p.ret - 2);  // an смещение-less регистрируй-based вызов is 2 байты for the вызов + регистрируй установи
                        } else if (!IsBadReadPtr(cast(проц*)p.ret - 3, 4) && RegisterBasedCallOpcode == *cast(ббайт*)(p.ret - 3)) {
                            version (StacktraceSpam) printf("ret:%x frm:%x регистрируй-based вызов:[%x,%x]"\n, sym, p, *cast(ббайт*)(p.ret - 2), *cast(ббайт*)(p.ret - 1));
                            добавьадрес(p.ret - 3);  // a регистрируй-based вызов is 3 байты for the вызов + регистрируй установи
                        } else {
                            version (StacktraceSpam) printf("ret:%x frm:%x"\n, sym, p);
                            добавьадрес(p.ret);
                        }
                    }
                }

                version (StacktraceTryToBeSmart) {
                    бул inFiber = нет;
                    if  (
                            адрвызова == cast(бцел)&_Dmain
                            || да == (inFiber = (
                                адрвызова >= cast(бцел)&D2rt4core6Thread5Fiber3runMFZv
                                && адрвызова < cast(бцел)&D2rt4core6Thread5Fiber3runMFZv + fiberRunFuncLength
                            ))
                        )
                    {
                        foundMain = да;
                        if (inFiber) {
                            version (StacktraceSpam) printf("Got or Нить.Fiber.run"\n);

                            version (StacktraceTryMatchCallадресes) {
                                // handled above
                            } else {
                                добавьадрес(p.ret);
                            }

                            curStack = curStack.within;
                            if (curStack) {
                                ук  newp = curStack.tstack;

                                if (!IsBadReadPtr(newp + 28, 8)) {
                                    добавьадрес(*cast(т_мера*)(newp + 32));
                                    p = *cast(Выкладка**)(newp + 28);
                                    continue;
                                }
                            }
                        } else {
                            version (StacktraceSpam) printf("Got _Dmain"\n);
                        }
                    }
                }
                
                version (StacktraceTryMatchCallадресes) {
                    // handled above
                } else {
                    добавьадрес(p.ret);
                }
                
                p = p.ebp;
            }

            ++phase;
            p = cast(Выкладка*)ContextRecord.Ebp;
            version (StacktraceSpam) printf("конец of phase"\n);
        }
        
        version (StacktraceSpam) printf("calling traceПриёмr"\n);
    }

    traceПриёмr(stacktrace[0..i]);
    heapTraceArr.free();
}


бул addrToSymbolDetails(т_мера адр, HANDLE hProcess, проц delegate(ткст func, ткст файл, цел строка, т_дельтаук адрСмещение) дг) {
    ббайт буфер[256];

    SYMBOL_INFO* symbol_info = cast(SYMBOL_INFO*)буфер.ptr;
    symbol_info.SizeOfStruct = SYMBOL_INFO.sizeof;
    symbol_info.MaxNameLen = буфер.length - SYMBOL_INFO.sizeof + 1;
    
    т_дельтаук адрСмещение = 0;
    auto ln = дайАдрОтладИнфо(адр, &адрСмещение);

    бул success = да;

    сим* symname = пусто;
    if (!СимИзАдр(hProcess, адр, пусто, symbol_info)) {
        //printf("%.*s"\n, СисОш.последнСооб);
        symname = ln.func;
        success = ln != АдрОтладИнфо.init;
    } else {
        symname = symbol_info.Name.ptr;
    }

    дг(изТкст0(symname), изТкст0(ln.файл), ln.строка, адрСмещение);
    return success;
}


//#строка 2 "части/Memory.di"
private {
    import cidrus : cMalloc = malloc, cRealloc = realloc, cFree = free;
}

public {
    import cidrus : memset;
}


/**
    Размести the Массив using malloc
    
    Параметры:
    Массив = the Массив which will be resized
    numItems = число of items в_ be allocated in the Массив
    init = whether в_ init the allocated items в_ their default values or not
    
    Examples:
    цел[] foo;
    foo.alloc(20);
    
    Remarks:
    The Массив must be пусто and пустой for this function в_ succeed. The rationale behind this is that the coder should состояние his decision clearly. This will help and есть
    already helped в_ spot many intricate bugs. 
*/
проц alloc(T, intT)(ref T Массив, intT numItems, бул init = да) 
in {
    assert (Массив is пусто);
    assert (numItems >= 0);
}
out {
    assert (numItems == Массив.length);
}
body {
    alias typeof(T[0]) ItemT;
    Массив = (cast(ItemT*)cMalloc(ItemT.sizeof * numItems))[0 .. numItems];
    
    static if (is(typeof(ItemT.init))) {
        if (init) {
            Массив[] = ItemT.init;
        }
    }
}


/**
    Clone the given Массив. The результат is allocated using alloc() and copied piecewise из_ the param. Then it's returned
*/
T clone(T)(T Массив) {
    T рез;
    рез.alloc(Массив.length, нет);
    рез[] = Массив[];
    return рез;
}


/**
    Realloc the contents of an Массив
    
    Массив = the Массив which will be resized
    numItems = the new размер for the Массив
    init = whether в_ init the newly allocated items в_ their default values or not
    
    Examples:
    цел[] foo;
    foo.alloc(20);
    foo.realloc(10);        // <--
*/
проц realloc(T, intT)(ref T Массив, intT numItems, бул init = да)
in {
    assert (numItems >= 0);
}
out {
    assert (numItems == Массив.length);
}
body {
    alias typeof(T[0]) ItemT;
    intT oldLen = Массив.length;
    Массив = (cast(ItemT*)cRealloc(Массив.ptr, ItemT.sizeof * numItems))[0 .. numItems];
    
    static if (is(typeof(ItemT.init))) {
        if (init && numItems > oldLen) {
            Массив[oldLen .. numItems] = ItemT.init;
        }
    }
}


/**
    Deallocate an Массив allocated with alloc()
*/
проц free(T)(ref T Массив)
out {
    assert (0 == Массив.length);
}
body {
    cFree(Массив.ptr);
    Массив = пусто;
}


/**
    Append an item в_ an Массив. Optionally keep track of an external 'реал length', while doing squared reallocation of the Массив
    
    Параметры:
    Массив = the Массив в_ добавь the item в_
    elem = the new item в_ be appended
    realLength = the optional external 'реал length'
    
    Remarks:
    if realLength isn't пусто, the Массив is not resized by one, but allocated in a std::vector manner. The Массив's length becomes it's ёмкость, while 'realLength'
    is the число of items in the Массив.
    
    Examples:
    ---
    бцел barLen = 0;
    цел[] bar;
    добавь(bar, 10, &barLen);
    добавь(bar, 20, &barLen);
    добавь(bar, 30, &barLen);
    добавь(bar, 40, &barLen);
    assert (bar.length == 16);
    assert (barLen == 4);
    ---
*/
проц добавь(T, I)(ref T Массив, I elem, бцел* realLength = пусто) {
    бцел длин = realLength is пусто ? Массив.length : *realLength;
    бцел ёмкость = Массив.length;
    alias typeof(T[0]) ItemT;
    
    if (длин >= ёмкость) {
        if (realLength is пусто) {       // just добавь one element в_ the Массив
            цел numItems = длин+1;
            Массив = (cast(ItemT*)cRealloc(Массив.ptr, ItemT.sizeof * numItems))[0 .. numItems];
        } else {                                // be smarter and размести in power-of-two increments
            const бцел initialCapacity = 4;
            цел numItems = ёмкость == 0 ? initialCapacity : ёмкость * 2; 
            Массив = (cast(ItemT*)cRealloc(Массив.ptr, ItemT.sizeof * numItems))[0 .. numItems];
            ++*realLength;
        }
    } else if (realLength !is пусто) ++*realLength;
    
    Массив[длин] = elem;
}
//#строка 2 "части/WinApi.di"
import text.Util;
import thread;
import Array;
import sys.Common : СисОш;
import sys.SharedLib : Длл;
import stringz;





enum {
    MAX_PATH = 260,
}

enum : WORD {
    IMAGE_FILE_MACHINE_UNKNOWN = 0,
    IMAGE_FILE_MACHINE_I386    = 332,
    IMAGE_FILE_MACHINE_R3000   = 354,
    IMAGE_FILE_MACHINE_R4000   = 358,
    IMAGE_FILE_MACHINE_R10000  = 360,
    IMAGE_FILE_MACHINE_ALPHA   = 388,
    IMAGE_FILE_MACHINE_POWERPC = 496
}

version(X86) {
    const SIZE_OF_80387_REGISTERS=80;
    const CONTEXT_i386=0x10000;
    const CONTEXT_i486=0x10000;
    const CONTEXT_CONTROL=(CONTEXT_i386|0x00000001L);
    const CONTEXT_INTEGER=(CONTEXT_i386|0x00000002L);
    const CONTEXT_SEGMENTS=(CONTEXT_i386|0x00000004L);
    const CONTEXT_FLOATING_POINT=(CONTEXT_i386|0x00000008L);
    const CONTEXT_DEBUG_REGISTERS=(CONTEXT_i386|0x00000010L);
    const CONTEXT_EXTENDED_REGISTERS=(CONTEXT_i386|0x00000020L);
    const CONTEXT_FULL=(CONTEXT_CONTROL|CONTEXT_INTEGER|CONTEXT_SEGMENTS);
    const MAXIMUM_SUPPORTED_EXTENSION=512;

    struct FLOATING_SAVE_AREA {
        DWORD    ControlWord;
        DWORD    StatusWord;
        DWORD    TagWord;
        DWORD    ErrorOffset;
        DWORD    ErrorSelector;
        DWORD    DataOffset;
        DWORD    DataSelector;
        BYTE[80] RegisterArea;
        DWORD    Cr0NpxState;
    }

    struct CONTEXT {
        DWORD ContextFlags;
        DWORD Dr0;
        DWORD Dr1;
        DWORD Dr2;
        DWORD Dr3;
        DWORD Dr6;
        DWORD Dr7;
        FLOATING_SAVE_AREA FloatSave;
        DWORD SegGs;
        DWORD SegFs;
        DWORD SegEs;
        DWORD SegDs;
        DWORD Edi;
        DWORD Esi;
        DWORD Ebx;
        DWORD Edx;
        DWORD Ecx;
        DWORD Eax;
        DWORD Ebp;
        DWORD EИП;
        DWORD SegCs;
        DWORD EFlags;
        DWORD Esp;
        DWORD SegSs;
        BYTE[MAXIMUM_SUPPORTED_EXTENSION] ExtendedRegisters;
    }

} else {
    pragma(msg, "Unsupported CPU");
    static assert(0);
    // Versions for PowerPC, Alpha, SHX, and MИПS removed.
}


alias CONTEXT* PCONTEXT, LPCONTEXT;

typedef ук  HANDLE;

alias сим CHAR;
alias ук  PVOID, LPVOID;

alias шим WCHAR;
alias WCHAR* PWCHAR, LPWCH, PWCH, LPWSTR, PWSTR;
alias CHAR* PCHAR, LPCH, PCH, LPSTR, PSTR;

// const versions
alias WCHAR* LPCWCH, PCWCH, LPCWSTR, PCWSTR;
alias CHAR* LPCCH, PCSTR, LPCSTR;

version(Unicode) {
    alias WCHAR TCHAR, _TCHAR;
} else {
    alias CHAR TCHAR, _TCHAR;
}

alias TCHAR* PTCH, PTBYTE, LPTCH, PTSTR, LPTSTR, LP, PTCHAR, LPCTSTR;

alias ббайт   BYTE;
alias ббайт*  PBYTE, LPBYTE;
alias бкрат  USHORT, WORD, ATOM;
alias бкрат* PUSHORT, PWORD, LPWORD;
alias бцел    ULONG, DWORD, UINT, COLORREF;
alias бцел*   PULONG, PDWORD, LPDWORD, PUINT, LPUINT;
alias цел     BOOL, INT, LONG;
alias HANDLE HMODULE;

enum : BOOL {
    FALSE = 0,
    TRUE = 1,
}

struct EXCEPTION_POINTERS {
  ук  ExceptionRecord;
  CONTEXT* ContextRecord;
}

version (Win64) {
    alias дол INT_PTR, LONG_PTR;
    alias бдол UINT_PTR, ULONG_PTR, HANDLE_PTR;
} else {
    alias цел INT_PTR, LONG_PTR;
    alias бцел UINT_PTR, ULONG_PTR, HANDLE_PTR;
}

alias бдол ULONG64, DWORD64, UINT64;
alias бдол* PULONG64, PDWORD64, PUINT64;


extern(Windows) {
    HANDLE GetCurrentProcess();
    HANDLE GetCurrentThread();
    BOOL GetThreadContext(HANDLE, LPCONTEXT);
}


проц loadWinAPIFunctions() {
    auto dbghelp = Длл.загрузи(`dbghelp.dll`);
    
    auto SymEnumerateModules64 = cast(fp_SymEnumerateModules64)dbghelp.дайСимвол("SymEnumerateModules64");
    СимИзАдр = cast(fp_SymFromAddr)dbghelp.дайСимвол("СимИзАдр");
    assert (СимИзАдр !is пусто);
    SymFromName = cast(fp_SymFromName)dbghelp.дайСимвол("SymFromName");
    assert (SymFromName !is пусто);
    SymLoadModule64 = cast(fp_SymLoadModule64)dbghelp.дайСимвол("SymLoadModule64");
    assert (SymLoadModule64 !is пусто);
    SymInitialize = cast(fp_SymInitialize)dbghelp.дайСимвол("SymInitialize");
    assert (SymInitialize !is пусто);
    SymCleanup = cast(fp_SymCleanup)dbghelp.дайСимвол("SymCleanup");
    assert (SymCleanup !is пусто);
    SymSetOptions = cast(fp_SymSetOptions)dbghelp.дайСимвол("SymSetOptions");
    assert (SymSetOptions !is пусто);
    SymGetLineFromAddr64 = cast(fp_SymGetLineFromAddr64)dbghelp.дайСимвол("SymGetLineFromAddr64");
    assert (SymGetLineFromAddr64 !is пусто);
    SymEnumSymbols = cast(fp_SymEnumSymbols)dbghelp.дайСимвол("SymEnumSymbols");
    assert (SymEnumSymbols !is пусто);
    SymGetModuleBase64 = cast(fp_SymGetModuleBase64)dbghelp.дайСимвол("SymGetModuleBase64");
    assert (SymGetModuleBase64 !is пусто);
    StackWalk64 = cast(fp_StackWalk64)dbghelp.дайСимвол("StackWalk64");
    assert (StackWalk64 !is пусто);
    SymFunctionTableAccess64 = cast(fp_SymFunctionTableAccess64)dbghelp.дайСимвол("SymFunctionTableAccess64");
    assert (SymFunctionTableAccess64 !is пусто);
    
    
    auto psapi = Длл.загрузи(`psapi.dll`);
    GetModuleFileNameExA = cast(fp_GetModuleFileNameExA)psapi.дайСимвол("GetModuleFileNameExA");
    assert (GetModuleFileNameExA !is пусто);
}



extern (Windows) {
    fp_SymFromAddr      СимИзАдр;
    fp_SymFromName      SymFromName;
    fp_SymLoadModule64  SymLoadModule64;
    fp_SymInitialize            SymInitialize;
    fp_SymCleanup           SymCleanup;
    fp_SymSetOptions        SymSetOptions;
    fp_SymGetLineFromAddr64 SymGetLineFromAddr64;
    fp_SymEnumSymbols           SymEnumSymbols;
    fp_SymGetModuleBase64   SymGetModuleBase64;
    fp_GetModuleFileNameExA     GetModuleFileNameExA;
    fp_StackWalk64                      StackWalk64;
    fp_SymFunctionTableAccess64 SymFunctionTableAccess64;


    alias DWORD function(
        DWORD SymOptions
    ) fp_SymSetOptions;
    
    enum {
        SYMOPT_ALLOW_ABSOLUTE_SYMBOLS = 0x00000800,
        SYMOPT_DEFERRED_LOADS = 0x00000004,
        SYMOPT_UNDNAME = 0x00000002
    }

    alias BOOL function(
        HANDLE hProcess,
        LPCTSTR UserSearchPath,
        BOOL fInvadeProcess
    ) fp_SymInitialize;
    
    alias BOOL function(
        HANDLE hProcess
    ) fp_SymCleanup;

    alias DWORD64 function(
        HANDLE hProcess,
        HANDLE hFile,
        LPSTR ImageName,
        LPSTR ModuleName,
        DWORD64 BaseOfDll,
        DWORD SizeOfDll
    ) fp_SymLoadModule64;
    
    struct SYMBOL_INFO {
        ULONG SizeOfStruct;
        ULONG TypeIndex;
        ULONG64 Reserved[2];
        ULONG Index;
        ULONG Size;
        ULONG64 ModBase;
        ULONG Flags;
        ULONG64 Значение;
        ULONG64 адрес;
        ULONG Register;
        ULONG Scope;
        ULONG Tag;
        ULONG NameLen;
        ULONG MaxNameLen;
        TCHAR Name[1];
    }
    alias SYMBOL_INFO* PSYMBOL_INFO;
    
    alias BOOL function(
        HANDLE hProcess,
        DWORD64 адрес,
        PDWORD64 Displacement,
        PSYMBOL_INFO Symbol
    ) fp_SymFromAddr;

    alias BOOL function(
        HANDLE hProcess,
        PCSTR Name,
        PSYMBOL_INFO Symbol
    ) fp_SymFromName;

    alias BOOL function(
        HANDLE hProcess,
        PSYM_ENUMMODULES_CALLBACK64 EnumModulesCallback,
        PVOID UserContext
    ) fp_SymEnumerateModules64;
    
    alias BOOL function(
        LPTSTR ModuleName,
        DWORD64 BaseOfDll,
        PVOID UserContext
    ) PSYM_ENUMMODULES_CALLBACK64;

    const DWORD TH32CS_SNAPPROCESS = 0x00000002;
    const DWORD TH32CS_SNAPTHREAD = 0x00000004;
    

    enum {
        MAX_MODULE_NAME32 = 255,
        TH32CS_SNAPMODULE = 0x00000008,
        SYMOPT_LOAD_LINES = 0x10,
    }

    struct IMAGEHLP_LINE64 {
        DWORD SizeOfStruct;
        PVOID Key;
        DWORD LineNumber;
        PTSTR имяф;
        DWORD64 адрес;
    }
    alias IMAGEHLP_LINE64* PIMAGEHLP_LINE64;
 
    alias BOOL function(
        HANDLE hProcess,
        DWORD64 dwAddr,
        PDWORD pdwDisplacement,
        PIMAGEHLP_LINE64 Line
    ) fp_SymGetLineFromAddr64;
    

    alias BOOL function(
        PSYMBOL_INFO pSymInfo,
        ULONG SymbolSize,
        PVOID UserContext
    ) PSYM_ENUMERATESYMBOLS_CALLBACK;

    alias BOOL function(
        HANDLE hProcess,
        ULONG64 BaseOfDll,
        LPCTSTR маска,
        PSYM_ENUMERATESYMBOLS_CALLBACK EnumSymbolsCallback,
        PVOID UserContext
    ) fp_SymEnumSymbols;


    alias DWORD64 function(
        HANDLE hProcess,
        DWORD64 dwAddr
    ) fp_SymGetModuleBase64;
    alias fp_SymGetModuleBase64 PGET_MODULE_BASE_ROUTINE64;
    
    
    alias DWORD function(
      HANDLE hProcess,
      HMODULE hModule,
      LPSTR lpFilename,
      DWORD nSize
    ) fp_GetModuleFileNameExA;
    

    enum ADDRESS_MODE {
        AddrMode1616,
        AddrMode1632,
        AddrModeReal,
        AddrModeFlat
    }
    
    struct KDHELP64 {
        DWORD64 Нить;
        DWORD ThCallbackStack;
        DWORD ThCallbackBStore;
        DWORD NextCallback;
        DWORD FramePointer;
        DWORD64 KiCallUserMode;
        DWORD64 KeUserCallbackDispatcher;
        DWORD64 SystemRangeStart;
        DWORD64 KiUserExceptionDispatcher;
        DWORD64 StackBase;
        DWORD64 StackLimit;
        DWORD64 Reserved[5];
    } 
    alias KDHELP64* PKDHELP64;
    
    struct ADDRESS64 {
        DWORD64 Offset;
        WORD Segment;
        ADDRESS_MODE Mode;
    }
    alias ADDRESS64* LPADDRESS64;


    struct STACKFRAME64 {
        ADDRESS64 AddrPC;
        ADDRESS64 AddrReturn;
        ADDRESS64 AddrFrame;
        ADDRESS64 AddrStack;
        ADDRESS64 AddrBStore;
        PVOID FuncTableEntry;
        DWORD64 Params[4];
        BOOL Far;
        BOOL Virtual;
        DWORD64 Reserved[3];
        KDHELP64 KdHelp;
    }
    alias STACKFRAME64* LPSTACKFRAME64;
    
    
    
    alias BOOL function(
        HANDLE hProcess,
        DWORD64 lpBaseадрес,
        PVOID lpBuffer,
        DWORD nSize,
        LPDWORD lpNumberOfBytesRead
    ) PREAD_PROCESS_MEMORY_ROUTINE64;
    
    alias PVOID function(
        HANDLE hProcess,
        DWORD64 AddrBase
    ) PFUNCTION_TABLE_ACCESS_ROUTINE64;
    alias PFUNCTION_TABLE_ACCESS_ROUTINE64 fp_SymFunctionTableAccess64;
    
    alias DWORD64 function(
        HANDLE hProcess,
        HANDLE hThread,
        LPADDRESS64 lpадр
    ) PTRANSLATE_ADDRESS_ROUTINE64;
    
    
    alias BOOL function (
        DWORD MachineType,
        HANDLE hProcess,
        HANDLE hThread,
        LPSTACKFRAME64 StackFrame,
        PVOID ContextRecord,
        PREAD_PROCESS_MEMORY_ROUTINE64 ReadMemoryRoutine,
        PFUNCTION_TABLE_ACCESS_ROUTINE64 FunctionTableAccessRoutine,
        PGET_MODULE_BASE_ROUTINE64 GetModuleBaseRoutine,
        PTRANSLATE_ADDRESS_ROUTINE64 Translateадрес
    ) fp_StackWalk64;
    
    
    BOOL IsBadReadPtr(проц*, бцел);
}

//#строка 2 "части/DbgInfo.di"
import text.Util;
import stringz;
import cidrus: strcpy;
import sys.win32.CodePage;
import exception;



struct АдрОтладИнфо {
    align(1) {
        т_мера  адр;
        сим*   файл;
        сим*   func;
        бкрат  строка;
    }
}

class ModuleDebugInfo {
    АдрОтладИнфо[] debugInfo;
    бцел                        debugInfoLen;
    т_мера[сим*]           fileMaxAddr;
    сим*[]                 strBuffer;
    бцел                        strBufferLen;
    
    проц добавьDebugInfo(т_мера адр, сим* файл, сим* func, бкрат строка) {
        debugInfo.добавь(АдрОтладИнфо(адр, файл, func, строка), &debugInfoLen);

        if (auto a = файл in fileMaxAddr) {
            if (адр > *a) *a = адр;
        } else {
            fileMaxAddr[файл] = адр;
        }
    }
    
    сим* bufferString(ткст ткт) {
        ткст рез;
        рез.alloc(ткт.length+1, нет);
        рез[0..$-1] = ткт[];
        рез[ткт.length] = 0;
        strBuffer.добавь(рез.ptr, &strBufferLen);
        return рез.ptr;
    }
    
    проц freeArrays() {
        debugInfo.free();
        debugInfoLen = 0;

        fileMaxAddr = пусто;
        foreach (ref s; strBuffer[0..strBufferLen]) {
            cFree(s);
        }
        strBuffer.free();
        strBufferLen = 0;
    }
    
    ModuleDebugInfo prev;
    ModuleDebugInfo следщ;
}

class GlobalDebugInfo {
    ModuleDebugInfo голова;
    ModuleDebugInfo хвост;
    
    
    synchronized цел opApply(цел delegate(ref ModuleDebugInfo) дг) {
        for (auto it = голова; it !is пусто; it = it.следщ) {
            if (auto рез = дг(it)) {
                return рез;
            }
        }
        return 0;
    }
    
    
    synchronized проц добавьDebugInfo(ModuleDebugInfo инфо) {
        if (голова is пусто) {
            голова = хвост = инфо;
            инфо.следщ = инфо.prev = пусто;
        } else {
            хвост.следщ = инфо;
            инфо.prev = хвост;
            инфо.следщ = пусто;
            хвост = инфо;
        }
    }
    
    
    synchronized проц removeDebugInfo(ModuleDebugInfo инфо) {
        assert (инфо !is пусто);
        assert (инфо.следщ !is пусто || инфо.prev !is пусто || голова is инфо);
        
        if (инфо is голова) {
            голова = голова.следщ;
        }
        if (инфо is хвост) {
            хвост = хвост.prev;
        }
        if (инфо.prev) {
            инфо.prev.следщ = инфо.следщ;
        }
        if (инфо.следщ) {
            инфо.следщ.prev = инфо.prev;
        }
        инфо.freeArrays;
        инфо.prev = инфо.следщ = пусто;
        
        delete инфо;
    }
}

private GlobalDebugInfo globalDebugInfo;
static this() {
    globalDebugInfo = new GlobalDebugInfo;
}

extern(C) проц _initLGPLHostExecutableDebugInfo(ткст progName) {
    scope инфо = new DebugInfo(progName);
    // we'll let it die сейчас :)
}


АдрОтладИнфо дайАдрОтладИнфо(т_мера a, т_дельтаук* diff = пусто) {
    АдрОтладИнфо bestInfo;
    цел minDiff = 0x7fffffff;
    цел bestOff = 0;
    const цел добавьBias = 0;
    
    foreach (modInfo; globalDebugInfo) {
        бул local = нет;
        
        foreach (l; modInfo.debugInfo[0 .. modInfo.debugInfoLen]) {
            цел diff = a - l.адр - добавьBias;
            
            // increasing it will сделай the отыщи give results 'higher' in the код (at lower адрesses)
            // using the значение of 1 is recommended when not using version StacktraceTryMatchCallадресes,
            // but it may результат in AVs reporting an earlier строка in the источник код
            const цел minSymbolOffset = 0;
            
            if (diff < minSymbolOffset) {
                continue;
            }
            
            цел absdiff = diff > 0 ? diff : -diff;
            if (absdiff < minDiff) {
                minDiff = absdiff;
                bestOff = diff;
                bestInfo = l;
                local = да;
            }
        }
        
        if (local) {
            if (minDiff > 0x100) {
                bestInfo = bestInfo.init;
                minDiff = 0x7fffffff;
            }
            else {
                if (auto ma = bestInfo.файл in modInfo.fileMaxAddr) {
                    if (a > *ma+добавьBias) {
                        bestInfo = bestInfo.init;
                        minDiff = 0x7fffffff;
                    }
                } else {
                    version (StacktraceSpam) printf("there ain't '%s' in fileMaxAddr\n", bestInfo.файл);
                    bestInfo = bestInfo.init;
                    minDiff = 0x7fffffff;
                }
            }
        }
    }
    
    if (diff !is пусто) {
        *diff = bestOff;
    }
    return bestInfo;
}

   

class DebugInfo {
    ModuleDebugInfo инфо;
    
    
    this(ткст имяф) {
        инфо = new ModuleDebugInfo;
        ParseCVFile(имяф);
        assert (globalDebugInfo !is пусто);
        globalDebugInfo.добавьDebugInfo(инфо);
    }
     
    private {
        цел ParseCVFile(ткст имяф) {
            FILE* debugfile;

            if (имяф == "") return (-1);

            //try {
                debugfile = fopen((имяф ~ \0).ptr, "rb");
            /+} catch(Исключение e){
                return -1;
            }+/

            if (!ParseFileHeaders (debugfile)) return -1;

            g_secthdrs.length = g_nthdr.ФайлЗаг.NumberOfSections;

            if (!ParseSectionHeaders (debugfile)) return -1;

            g_debugdirs.length = g_nthdr.OptionalHeader.DataDirectory[IMAGE_FILE_DEBUG_DIRECTORY].Size /
                IMAGE_DEBUG_DIRECTORY.sizeof;

            if (!ParseDebugDir (debugfile)) return -1;
            if (g_dwStartOfCodeView == 0) return -1;
            if (!ParseCodeViewHeaders (debugfile)) return -1;
            if (!ParseAllModules (debugfile)) return -1;

            g_dwStartOfCodeView = 0;
            g_exe_mode = да;
            g_secthdrs = пусто;
            g_debugdirs = пусто;
            g_cvEntries = пусто;
            g_cvModules = пусто;
            g_filename = пусто;
            g_filenameStringz = пусто;

            fclose(debugfile);
            return 0;
        }
            
        бул ParseFileHeaders(FILE* debugfile) {
            CVHeaderType hdrtype;

            hdrtype = GetHeaderType (debugfile);

            if (hdrtype == CVHeaderType.DOS) {
                if (!ReдобавьOSFileHeader (debugfile, &g_doshdr))return нет;
                hdrtype = GetHeaderType (debugfile);
            }
            if (hdrtype == CVHeaderType.NT) {
                if (!ReadPEFileHeader (debugfile, &g_nthdr)) return нет;
            }

            return да;
        }
            
        CVHeaderType GetHeaderType(FILE* debugfile) {
            бкрат hdrtype;
            CVHeaderType ret = CVHeaderType.Неук;

            цел oldpos = ftell(debugfile);

            if (!ReadChunk (debugfile, &hdrtype, бкрат.sizeof, -1)){
                fseek(debugfile, oldpos, SEEK_SET);
                return CVHeaderType.Неук;
            }

            if (hdrtype == 0x5A4D)       // "MZ"
                ret = CVHeaderType.DOS;
            else if (hdrtype == 0x4550)  // "PE"
                ret = CVHeaderType.NT;
            else if (hdrtype == 0x4944)  // "DI"
                ret = CVHeaderType.DBG;

            fseek(debugfile, oldpos, SEEK_SET);

            return ret;
        }
         
        /*
         * Extract the DOS файл заголовки из_ an executable
         */
        бул ReдобавьOSFileHeader(FILE* debugfile, IMAGE_DOS_HEADER *doshdr) {
            бцел bytes_read;

            bytes_read = fread(doshdr, 1, IMAGE_DOS_HEADER.sizeof, debugfile);
            if (bytes_read < IMAGE_DOS_HEADER.sizeof){
                return нет;
            }

            // SkИП over stub данные, if present
            if (doshdr.e_lfanew) {
                fseek(debugfile, doshdr.e_lfanew, SEEK_SET);
            }

            return да;
        }
         
        /*
         * Extract the DOS and NT файл заголовки из_ an executable
         */
        бул ReadPEFileHeader(FILE* debugfile, IMAGE_NT_HEADERS *nthdr) {
            бцел bytes_read;

            bytes_read = fread(nthdr, 1, IMAGE_NT_HEADERS.sizeof, debugfile);
            if (bytes_read < IMAGE_NT_HEADERS.sizeof) {
                return нет;
            }

            return да;
        }
          
        бул ParseSectionHeaders(FILE* debugfile) {
            if (!ReadSectionHeaders (debugfile, g_secthdrs)) return нет;
            return да;
        }
            
        бул ReadSectionHeaders(FILE* debugfile, ref IMAGE_SECTION_HEADER[] secthdrs) {
            for(цел i=0;i<secthdrs.length;i++){
                бцел bytes_read;
                bytes_read = fread((&secthdrs[i]), 1, IMAGE_SECTION_HEADER.sizeof, debugfile);
                if (bytes_read < 1){
                    return нет;
                }
            }
            return да;
        }
          
        бул ParseDebugDir(FILE* debugfile) {
            цел i;
            цел filepos;

            if (g_debugdirs.length == 0) return нет;

            filepos = GetOffsetFromRVA (g_nthdr.OptionalHeader.DataDirectory[IMAGE_FILE_DEBUG_DIRECTORY].Virtualадрес);

            fseek(debugfile, filepos, SEEK_SET);

            if (!ReдобавьebugDir (debugfile, g_debugdirs)) return нет;

            for (i = 0; i < g_debugdirs.length; i++) {
                enum {
                    IMAGE_DEBUG_TYPE_CODEVIEW = 2,
                }

                if (g_debugdirs[i].Тип == IMAGE_DEBUG_TYPE_CODEVIEW) {
                    g_dwStartOfCodeView = g_debugdirs[i].PointerToНеобрData;
                }
            }

            g_debugdirs = пусто;

            return да;
        }
            
        // Calculate the файл смещение, based on the RVA.
        бцел GetOffsetFromRVA(бцел rva) {
            цел i;
            бцел sectbegin;

            for (i = g_secthdrs.length - 1; i >= 0; i--) {
                sectbegin = g_secthdrs[i].Virtualадрес;
                if (rva >= sectbegin) break;
            }
            бцел смещение = g_secthdrs[i].Virtualадрес - g_secthdrs[i].PointerToНеобрData;
            бцел filepos = rva - смещение;
            return filepos;
        }
         
        // Load in the debug дир table.  This дир describes the various
        // blocks of debug данные that resопрe at the конец of the файл (after the COFF
        // sections), включая FPO данные, COFF-стиль debug инфо, and the CodeView
        // we are *really* after.
        бул ReдобавьebugDir(FILE* debugfile, ref IMAGE_DEBUG_DIRECTORY debugdirs[]) {
            бцел bytes_read;
            for(цел i=0;i<debugdirs.length;i++) {
                bytes_read = fread((&debugdirs[i]), 1, IMAGE_DEBUG_DIRECTORY.sizeof, debugfile);
                if (bytes_read < IMAGE_DEBUG_DIRECTORY.sizeof) {
                    return нет;
                }
            }
            return да;
        }
          
        бул ParseCodeViewHeaders(FILE* debugfile) {
            fseek(debugfile, g_dwStartOfCodeView, SEEK_SET);
            if (!ReadCodeViewHeader (debugfile, g_cvSig, g_cvHeader)) return нет;
            g_cvEntries.length = g_cvHeader.cDir;
            if (!ReadCodeViewDirectory (debugfile, g_cvEntries)) return нет;
            return да;
        }

            
        бул ReadCodeViewHeader(FILE* debugfile, out OMFSignature sig, out OMFDirHeader dirhdr) {
            бцел bytes_read;

            bytes_read = fread((&sig), 1, OMFSignature.sizeof, debugfile);
            if (bytes_read < OMFSignature.sizeof){
                return нет;
            }

            fseek(debugfile, sig.filepos + g_dwStartOfCodeView, SEEK_SET);
            bytes_read = fread((&dirhdr), 1, OMFDirHeader.sizeof, debugfile);
            if (bytes_read < OMFDirHeader.sizeof){
                return нет;
            }
            return да;
        }
         
        бул ReadCodeViewDirectory(FILE* debugfile, ref OMFDirEntry[] записи) {
            бцел bytes_read;

            for(цел i=0;i<записи.length;i++){
                bytes_read = fread((&записи[i]), 1, OMFDirEntry.sizeof, debugfile);
                if (bytes_read < OMFDirEntry.sizeof){
                    return нет;
                }
            }
            return да;
        }
          
        бул ParseAllModules (FILE* debugfile) {
            if (g_cvHeader.cDir == 0){
                return да;
            }

            if (g_cvEntries.length == 0){
                return нет;
            }

            fseek(debugfile, g_dwStartOfCodeView + g_cvEntries[0].lfo, SEEK_SET);

            if (!ReadModuleData (debugfile, g_cvEntries, g_cvModules)){
                return нет;
            }


            for (цел i = 0; i < g_cvModules.length; i++){
                ParseRelatedSections (i, debugfile);
            }

            return да;
        }

            
        бул ReadModuleData(FILE* debugfile, OMFDirEntry[] записи, out OMFModuleFull[] modules) {
            бцел bytes_read;
            цел pad;

            цел module_bytes = (бкрат.sizeof * 3) + (сим.sizeof * 2);

            if (записи == пусто) return нет;

            modules.length = 0;

            for (цел i = 0; i < записи.length; i++){
                if (записи[i].SubSection == sstModule)
                    modules.length = modules.length + 1;
            }

            for (цел i = 0; i < modules.length; i++){

                bytes_read = fread((&modules[i]), 1, module_bytes, debugfile);
                if (bytes_read < module_bytes){
                    return нет;
                }

                цел segnum = modules[i].cSeg;
                OMFSegDesc[] segarray;
                segarray.length=segnum;
                for(цел j=0;j<segnum;j++){
                    bytes_read =  fread((&segarray[j]), 1, OMFSegDesc.sizeof, debugfile);
                    if (bytes_read < OMFSegDesc.sizeof){
                        return нет;
                    }
                }
                modules[i].SegInfo = segarray.ptr;

                сим namelen;
                bytes_read = fread((&namelen), 1, сим.sizeof, debugfile);
                if (bytes_read < 1){
                    return нет;
                }

                pad = ((namelen + 1) % 4);
                if (pad) namelen += (4 - pad);

                modules[i].Name = (new сим[namelen+1]).ptr;
                modules[i].Name[namelen]=0;
                bytes_read = fread((modules[i].Name), 1, namelen, debugfile);
                if (bytes_read < namelen){
                    return нет;
                }
            }
            return да;
        }
         
        бул ParseRelatedSections(цел индекс, FILE* debugfile) {
            цел i;

            if (g_cvEntries == пусто)
                return нет;

            for (i = 0; i < g_cvHeader.cDir; i++){
                if (g_cvEntries[i].iMod != (индекс + 1) ||
                    g_cvEntries[i].SubSection == sstModule)
                    continue;

                switch (g_cvEntries[i].SubSection){
                case sstSrcModule:
                    ParseSrcModuleInfo (i, debugfile);
                    break;
                default:
                    break;
                }
            }

            return да;
        }
            
        бул ParseSrcModuleInfo (цел индекс, FILE* debugfile) {
            цел i;

            байт *Необрdata;
            байт *curpos;
            крат filecount;
            крат segcount;

            цел moduledatalen;
            цел filedatalen;
            цел linedatalen;

            if (g_cvEntries == пусто || debugfile == пусто ||
                g_cvEntries[индекс].SubSection != sstSrcModule)
                return нет;

            цел fileoffset = g_dwStartOfCodeView + g_cvEntries[индекс].lfo;

            Необрdata = (new байт[g_cvEntries[индекс].ов]).ptr;
            if (!Необрdata) return нет;

            if (!ReadChunk (debugfile, Необрdata, g_cvEntries[индекс].ов, fileoffset)) return нет;
            бцел[] baseSrcFile;
            ExtractSrcModuleInfo (Необрdata, &filecount, &segcount,baseSrcFile);

            for(i=0;i<baseSrcFile.length;i++){
                бцел baseSrcLn[];
                ExtractSrcModuleFileInfo (Необрdata+baseSrcFile[i],baseSrcLn);
                for(цел j=0;j<baseSrcLn.length;j++){
                    ExtractSrcModuleLineInfo (Необрdata+baseSrcLn[j], j);
                }
            }

            return да;
        }
        
        проц ExtractSrcModuleInfo (байт* Необрdata, крат *filecount, крат *segcount,out бцел[] fileinfopos) {
            цел i;
            цел datalen;

            крат cFile;
            крат cSeg;
            бцел *baseSrcFile;
            бцел *segarray;
            бкрат *segindexarray;

            cFile = *cast(крат*)Необрdata;
            cSeg = *cast(крат*)(Необрdata + 2);
            baseSrcFile = cast(бцел*)(Необрdata + 4);
            segarray = &baseSrcFile[cFile];
            segindexarray = cast(бкрат*)(&segarray[cSeg * 2]);

            *filecount = cFile;
            *segcount = cSeg;

            fileinfopos.length=cFile;
            for (i = 0; i < cFile; i++) {
                fileinfopos[i]=baseSrcFile[i];
            }
        }
         
        проц ExtractSrcModuleFileInfo(байт* Необрdata,out бцел[] смещение) {
            цел i;
            цел datalen;

            крат cSeg;
            бцел *baseSrcLn;
            бцел *segarray;
            байт cFName;

            cSeg = *cast(крат*)(Необрdata);
            // SkИП the 'pad' field
            baseSrcLn = cast(бцел*)(Необрdata + 4);
            segarray = &baseSrcLn[cSeg];
            cFName = *(cast(байт*)&segarray[cSeg*2]);

            g_filename = (cast(сим*)&segarray[cSeg*2] + 1)[0..cFName].dup;
            g_filenameStringz = инфо.bufferString(g_filename);

            смещение.length=cSeg;
            for (i = 0; i < cSeg; i++){
                смещение[i]=baseSrcLn[i];
            }
        }
         
        проц ExtractSrcModuleLineInfo(байт* Необрdata, цел tablecount) {
            цел i;

            бкрат Seg;
            бкрат cPair;
            бцел *смещение;
            бкрат *linenumber;

            Seg = *cast(бкрат*)Необрdata;
            cPair = *cast(бкрат*)(Необрdata + 2);
            смещение = cast(бцел*)(Необрdata + 4);
            linenumber = cast(бкрат*)&смещение[cPair];

            бцел основа=0;
            if (Seg != 0){
                основа = g_nthdr.OptionalHeader.ImageBase+g_secthdrs[Seg-1].Virtualадрес;
            }
            
            for (i = 0; i < cPair; i++) {
                бцел адрес = смещение[i]+основа;
                инфо.добавьDebugInfo(адрес, g_filenameStringz, пусто, linenumber[i]);
            }
        }

           
        бул ReadChunk(FILE* debugfile, проц *приёмник, цел length, цел fileoffset) {
            бцел bytes_read;

            if (fileoffset >= 0) {
                fseek(debugfile, fileoffset, SEEK_SET);
            }

            bytes_read = fread(приёмник, 1, length, debugfile);
            if (bytes_read < length) {
                return нет;
            }

            return да;
        }


        enum CVHeaderType : цел {
            Неук,
            DOS,
            NT,
            DBG
        }

        цел g_dwStartOfCodeView = 0;

        бул g_exe_mode = да;
        IMAGE_DOS_HEADER g_doshdr;
        IMAGE_SEPARATE_DEBUG_HEADER g_dbghdr;
        IMAGE_NT_HEADERS g_nthdr;

        IMAGE_SECTION_HEADER g_secthdrs[];

        IMAGE_DEBUG_DIRECTORY g_debugdirs[];
        OMFSignature g_cvSig;
        OMFDirHeader g_cvHeader;
        OMFDirEntry g_cvEntries[];
        OMFModuleFull g_cvModules[];
        ткст g_filename;
        сим* g_filenameStringz;
    }
}




enum {
    IMAGE_FILE_DEBUG_DIRECTORY = 6
}
 
enum {
    sstModule           = 0x120,
    sstSrcModule        = 0x127,
    sstGlobalPub        = 0x12a,
}
 
struct OMFSignature {
    сим    Signature[4];
    цел filepos;
}
 
struct OMFDirHeader {
    бкрат  cbDirHeader;
    бкрат  cbDirEntry;
    бцел    cDir;
    цел     lfoNextDir;
    бцел    флаги;
}
 
struct OMFDirEntry {
    бкрат  SubSection;
    бкрат  iMod;
    цел     lfo;
    бцел    ов;
}
  
struct OMFSegDesc {
    бкрат  Seg;
    бкрат  pad;
    бцел    Off;
    бцел    cbSeg;
}
 
struct OMFModule {
    бкрат  ovlNumber;
    бкрат  iLib;
    бкрат  cSeg;
    сим            Стиль[2];
}
 
struct OMFModuleFull {
    бкрат  ovlNumber;
    бкрат  iLib;
    бкрат  cSeg;
    сим            Стиль[2];
    OMFSegDesc      *SegInfo;
    сим            *Name;
}
    
struct OMFSymHash {
    бкрат  symhash;
    бкрат  адрhash;
    бцел    cbSymbol;
    бцел    cbHSym;
    бцел    cbHAddr;
}
 
struct DATASYM16 {
        бкрат reclen;  // Record length
        бкрат rectyp;  // S_LDATA or S_GDATA
        цел off;        // смещение of symbol
        бкрат seg;     // segment of symbol
        бкрат typind;  // Тип индекс
        байт имя[1];   // Length-псеп_в_начале имя
}
typedef DATASYM16 PUBSYM16;
 

struct IMAGE_DOS_HEADER {      // DOS .EXE заголовок
    бкрат   e_magic;                     // Magic число
    бкрат   e_cblp;                      // Bytes on последний страница of файл
    бкрат   e_cp;                        // Pages in файл
    бкрат   e_crlc;                      // Relocations
    бкрат   e_cparhdr;                   // Size of заголовок in paragraphs
    бкрат   e_minalloc;                  // Minimum extra paragraphs needed
    бкрат   e_maxalloc;                  // Maximum extra paragraphs needed
    бкрат   e_ss;                        // Initial (relative) SS значение
    бкрат   e_sp;                        // Initial SP значение
    бкрат   e_csum;                      // Checksum
    бкрат   e_ИП;                        // Initial ИП значение
    бкрат   e_cs;                        // Initial (relative) CS значение
    бкрат   e_lfarlc;                    // Файл адрес of relocation table
    бкрат   e_ovno;                      // Overlay число
    бкрат   e_res[4];                    // Reserved words
    бкрат   e_oemопр;                     // OEM определитель (for e_oeminfo)
    бкрат   e_oeminfo;                   // OEM information; e_oemопр specific
    бкрат   e_res2[10];                  // Reserved words
    цел      e_lfanew;                    // Файл адрес of new exe заголовок
}
 
struct IMAGE_FILE_HEADER {
    бкрат    Machine;
    бкрат    NumberOfSections;
    бцел      TimeDateStamp;
    бцел      PointerToSymbolTable;
    бцел      NumberOfSymbols;
    бкрат    SizeOfOptionalHeader;
    бкрат    Characteristics;
}
 
struct IMAGE_SEPARATE_DEBUG_HEADER {
    бкрат        Signature;
    бкрат        Flags;
    бкрат        Machine;
    бкрат        Characteristics;
    бцел       TimeDateStamp;
    бцел       CheckSum;
    бцел       ImageBase;
    бцел       SizeOfImage;
    бцел       NumberOfSections;
    бцел       ExportedNamesSize;
    бцел       DebugDirectorySize;
    бцел       SectionAlignment;
    бцел       Reserved[2];
}
 
struct IMAGE_DATA_DIRECTORY {
    бцел   Virtualадрес;
    бцел   Size;
}
 
struct IMAGE_OPTIONAL_HEADER {
    //
    // Standard fields.
    //

    бкрат    Magic;
    байт    MajorLinkerVersion;
    байт    MinorLinkerVersion;
    бцел   SizeOfCode;
    бцел   SizeOfInitializedData;
    бцел   SizeOfUninitializedData;
    бцел   адресOfEntryPoint;
    бцел   BaseOfCode;
    бцел   BaseOfData;

    //
    // NT добавьitional fields.
    //

    бцел   ImageBase;
    бцел   SectionAlignment;
    бцел   FileAlignment;
    бкрат    MajorOperatingSystemVersion;
    бкрат    MinorOperatingSystemVersion;
    бкрат    MajorImageVersion;
    бкрат    MinorImageVersion;
    бкрат    MajorSubsystemVersion;
    бкрат    MinorSubsystemVersion;
    бцел   Win32VersionValue;
    бцел   SizeOfImage;
    бцел   SizeOfHeaders;
    бцел   CheckSum;
    бкрат    Subsystem;
    бкрат    DllCharacteristics;
    бцел   SizeOfStackReserve;
    бцел   SizeOfStackCommit;
    бцел   SizeOfHeapReserve;
    бцел   SizeOfHeapCommit;
    бцел   LoaderFlags;
    бцел   NumberOfRvaAndSizes;

    enum {
        IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16,
    }

    IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
}
 
struct IMAGE_NT_HEADERS {
    бцел Signature;
    IMAGE_FILE_HEADER ФайлЗаг;
    IMAGE_OPTIONAL_HEADER OptionalHeader;
}
 
enum {
    IMAGE_SIZEOF_SHORT_NAME = 8,
}

struct IMAGE_SECTION_HEADER {
    байт    Name[IMAGE_SIZEOF_SHORT_NAME];//8
    union misc{
            бцел   Physicalадрес;
            бцел   VirtualSize;//12
    }
    misc Misc;
    бцел   Virtualадрес;//16
    бцел   SizeOfНеобрData;//20
    бцел   PointerToНеобрData;//24
    бцел   PointerToRelocations;//28
    бцел   PointerToLinenumbers;//32
    бкрат NumberOfRelocations;//34
    бкрат NumberOfLinenumbers;//36
    бцел   Characteristics;//40
}
 
struct IMAGE_DEBUG_DIRECTORY {
    бцел   Characteristics;
    бцел   TimeDateStamp;
    бкрат MajorVersion;
    бкрат MinorVersion;
    бцел   Тип;
    бцел   SizeOfData;
    бцел   адресOfНеобрData;
    бцел   PointerToНеобрData;
}
 
struct OMFSourceLine {
    бкрат  Seg;
    бкрат  cLnOff;
    бцел    смещение[1];
    бкрат  lineNbr[1];
}
 
struct OMFSourceFile {
    бкрат  cSeg;
    бкрат  reserved;
    бцел    baseSrcLn[1];
    бкрат  cFName;
    сим    Name;
}
 
struct OMFSourceModule {
    бкрат  cFile;
    бкрат  cSeg;
    бцел    baseSrcFile[1];
}
//#строка 2 "части/CInterface.di"
extern (C) {
    ModuleDebugInfo ModuleDebugInfo_new() {
        return new ModuleDebugInfo;
    }
    
    проц ModuleDebugInfo_добавьDebugInfo(ModuleDebugInfo minfo, т_мера адр, сим* файл, сим* func, бкрат строка) {
        minfo.добавьDebugInfo(адр, файл, func, строка);
    }
    
    сим* ModuleDebugInfo_bufferString(ModuleDebugInfo minfo, ткст ткт) {
        ткст рез;
        рез.alloc(ткт.length+1, нет);
        рез[0..$-1] = ткт[];
        рез[ткт.length] = 0;
        minfo.strBuffer.добавь(рез.ptr, &minfo.strBufferLen);
        return рез.ptr;
    }
    
    проц GlobalDebugInfo_добавьDebugInfo(ModuleDebugInfo minfo) {
        globalDebugInfo.добавьDebugInfo(minfo);
    }
    
    проц GlobalDebugInfo_removeDebugInfo(ModuleDebugInfo minfo) {
        globalDebugInfo.removeDebugInfo(minfo);
    }
}
//#строка 2 "части/Init.di"
static this() {
    loadWinAPIFunctions();

    for (fiberRunFuncLength = 0; fiberRunFuncLength < 0x100; ++fiberRunFuncLength) {
        ббайт* ptr = cast(ббайт*)&D2rt4core6Thread5Fiber3runMFZv + fiberRunFuncLength;
        enum {
            RetOpcode = 0xc3
        }
        if (IsBadReadPtr(ptr, 1) || RetOpcode == *ptr) {
            break;
        }
    }
    
    version (StacktraceSpam) printf ("найдено Нить.Fiber.run at %p with length %x",
            &D2rt4core6Thread5Fiber3runMFZv, fiberRunFuncLength);

    сим modNameBuf[512] = 0;
    цел modNameLen = GetModuleFileNameExA(GetCurrentProcess(), пусто, modNameBuf.ptr, modNameBuf.length-1);
    ткст modName = modNameBuf[0..modNameLen];
    SymSetOptions(SYMOPT_DEFERRED_LOADS/+ | SYMOPT_UNDNAME+/);
    SymInitialize(GetCurrentProcess(), пусто, нет);
    DWORD64 основа;
    if (0 == (основа = SymLoadModule64(GetCurrentProcess(), HANDLE.init, modName.ptr, пусто, 0, 0))) {
        if (СисОш.последнКод != 0) {
            throw new Исключение("Could not SymLoadModule64: " ~ СисОш.последнСооб);
        }
    }

    
    SYMBOL_INFO sym;
    sym.SizeOfStruct = SYMBOL_INFO.sizeof; 

    extern(C) проц function(ткст) initTrace;
    if (SymFromName(GetCurrentProcess(), "__initLGPLHostExecutableDebugInfo", &sym)) {
        initTrace = cast(typeof(initTrace))sym.адрес;
        assert (initTrace !is пусто); 
        initTrace(modName);
    } else {
        throw new Исключение ("Can't инициализуй the TangoTrace LGPL stuff");
    }
}

}
