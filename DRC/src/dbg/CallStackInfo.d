/**
 A simple runtime crash handler which collects various informations about
 the crash such as registers, stack traces, and loaded modules.

 TODO:
	* Threading support
	* Stack dumps

 Authors:
	Jeremie Pelletier

 License:
	Public Domain
*/
module dbg.CallStackInfo;

import dbg.Debug;
import dbg.image.PE;

import win32.winnt: EXCEPTION_RECORD;
import winapi, cidrus;

//import rt.deh;
extern(C) Exception _d_translate_se_to_d_exception(EXCEPTION_RECORD *exception_record);

class CallStackInfo
{
	this(EXCEPTION_POINTERS* e = null)
	{
		т_мера[16] buff;
		т_мера[] backtrace = buff[];
		т_мера numTraces = 0;
		
		бул skipFirst = нет;
		
		т_мера ip = проц, bp = проц;
		version(Windows) {
		if (e !is null) {
			ip = e.ContextRecord.Eip;
			bp = e.ContextRecord.Ebp;
			
			error = _d_translate_se_to_d_exception(e.ExceptionRecord);
			приставь(backtrace, numTraces, ip);
		} else {
			asm {
				mov bp, EBP;
			}
		}
		}
		
		while (да) {
			ip = cast(т_мера)*(cast(ук*)bp + 1);
			if (ip == 0) break;
			
			приставь(backtrace, numTraces, ip);
			
			bp = cast(т_мера)*cast(ук*)bp;
		}
		
		frames = new StackFrameInfo[numTraces];
		ResolveStackFrames(backtrace[0..numTraces], frames);
	}
	
	Exception error;
	StackFrameInfo[] frames;

	override ткст вТкст()
	{
		ткст text;
		
		if (error !is null) {	
			text ~= error.вТкст() ~ "\n";			
		}
		
		text ~= "Stack trace:\n------------------\n";
		сим[128] буфер;
		foreach(ref frame; frames)
		{
			with(frame.fileLine) if(line)
			{
				auto len = snprintf(буфер.ptr, буфер.length, "%u", line);
				text ~= файл ~ ":" ~ буфер[0 .. len] ~ "\r\n";
			}
		}

		text ~= '\0';

		return text;
	}
	
	проц dump()
	{
		if (error !is null) {	
			ткст0 er = cast(ткст0) error.вТкст();
			printf("%.*s\n",  er);
		}
		
		printf("Stack trace:\n------------------\n");
		foreach(ref frame; frames) {
			with(frame.fileLine) if (line) {
				printf("%.*s:%d\r\n", файл, line);
			}
		}
	}

private:

	struct StackFrameInfo {
		т_мера			va;
		ткст			moduleName;
		SymbolInfo		symbol;
		FileLineInfo	fileLine;
	}

	struct DebugImage {
		DebugImage*			следщ;
		ткст				moduleName;
		т_мера				baseAddress;
		бцел				rvaOffset;
		IExecutableImage	exeModule;
		ISymbolicDebugInfo	debugInfo;
	}

	проц ResolveStackFrames(т_мера[] backtrace, StackFrameInfo[] frames) {
		StackFrameInfo* frame = проц;
		DebugImage* imageList, image = проц;
		сим[255] буфер = проц;
		бцел len = проц;
		бцел rva = проц;

		version(Windows) MEMORY_BASIC_INFORMATION mbi = проц;

		foreach(i, va; backtrace) {
			frame = &frames[i];
			frame.va = va;

			version(Windows) {
			    // mbi.Allocation base is the handle to stack frame's module
			    VirtualQuery(cast(ук)va, &mbi, MEMORY_BASIC_INFORMATION.sizeof);
			    if(!mbi.AllocationBase) break;

			    image = imageList;
			    while(image) {
				    if(image.baseAddress == cast(т_мера)mbi.AllocationBase) break;
				    image = image.следщ;
			    }

			    if(!image) {
				    image = new DebugImage;

				    with(*image) {
					    следщ = imageList;
					    imageList = image;
					    baseAddress = cast(т_мера)mbi.AllocationBase;

					    len = GetModuleFileNameA(cast(HMODULE)baseAddress, буфер.ptr, буфер.length);
					    moduleName = буфер[0 .. len].dup;
					    if (len != 0) {
						    exeModule = new PEImage(moduleName);
						    rvaOffset = baseAddress + exeModule.codeOffset;
						    debugInfo = exeModule.debugInfo;
					    }
				    }
			    }
			}
			else version(POSIX)
			{
				assert(0);
			}
			else static assert(0);

			frame.moduleName = image.moduleName;

			if(!image.debugInfo) continue;

			rva = va - image.rvaOffset;

			with(image.debugInfo) {
				frame.symbol = ResolveSymbol(rva);
				frame.fileLine = ResolveFileLine(rva);
			}
		}

		while(imageList) {
			image = imageList.следщ;
			delete imageList.debugInfo;
			delete imageList.exeModule;
			delete imageList;
			imageList = image;
		}
	}
}

проц CrashHandlerInit() {
	version(Windows) {
	    //SetErrorMode(SetErrorMode(0) | SEM_FAILCRITICALERRORS);
	    SetErrorMode(0);
	    SetUnhandledExceptionFilter(&UnhandledExceptionHandler);
	}
	else version(Posix) {
	assert(0);
	/+	sigaction_t sa;
		sa.sa_handler = cast(sighandler_t)&SignalHandler;
		sigemptyset(&sa.sa_mask);
		sa.sa_flags = SA_RESTART | SA_SIGINFO;

		sigaction(SIGILL, &sa, null);
		sigaction(SIGFPE, &sa, null);
		sigaction(SIGSEGV, &sa, null);+/
	}
	else static assert(0);
}
const EXCEPTION_EXECUTE_HANDLER = 1;

/*extern(Windows) */цел UnhandledExceptionHandler(EXCEPTION_POINTERS* e) {
	scope CallStackInfo info = new CallStackInfo(e);
	info.dump();

	return EXCEPTION_EXECUTE_HANDLER;
}

extern (Windows) extern UINT SetErrorMode(UINT);
alias LONG function(EXCEPTION_POINTERS*) PTOP_LEVEL_EXCEPTION_FILTER;
extern (Windows) PTOP_LEVEL_EXCEPTION_FILTER SetUnhandledExceptionFilter(PTOP_LEVEL_EXCEPTION_FILTER);

проц приставь(T)(ref T[] массив, ref т_мера index, T значение)
{
	т_мера capacity = массив.length;
	assert(capacity >= index);
	if (capacity == index) {
		if (capacity < 8) {
			capacity = 8;
		} else {
			capacity *= 2;
		}
		
		массив.length = capacity;
	}
	
	массив[index++] = значение;
}

struct EXCEPTION_POINTERS {
	EXCEPTION_RECORD* ExceptionRecord;
	CONTEXT*          ContextRecord;
}

const MAXIMUM_SUPPORTED_EXTENSION = 512;

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
	DWORD Eip;
	DWORD SegCs;
	DWORD EFlags;
	DWORD Esp;
	DWORD SegSs;
	BYTE[MAXIMUM_SUPPORTED_EXTENSION] ExtendedRegisters;
}

//extern Throwable _d_translate_se_to_d_exception(EXCEPTION_RECORD* exception_record);
