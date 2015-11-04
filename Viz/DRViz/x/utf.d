/*
	Copyright (C) 2004-2007 Christopher E. Miller
	
	This software is provided 'as-is', without any express or implied
	warranty.  In нет событие will the authors be held liable for any damages
	arising from the use of this software.
	
	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:
	
	1. The origin of this software must not be misrepresented; you must not
	   claim that you wrote the original software. If you use this software
	   in а product, an acknowledgment in the product documentation would be
	   appreciated but is not required.
	2. Altered source versions must be plainly marked as such, and must not be
	   misrepresented as being the original software.
	3. This notice may not be removed or altered from any source distribution.
*/


module viz.x.utf;

private import viz.x.dlib, stdrus;

private import viz.x.winapi;

//version(VIZ_UNICODE)
	version = VIZ_UNICODE;
	
version(Tango)
{
	version(VIZ_BOTH_STRINGS)
	{
		pragma(сооб, "viz: предупреждение: this Tango version might not support VIZ_BOTH_STRINGS");
	}
	else
	{
		version(Win32SansUnicode)
		{
			version = VIZ_ANSI;
		}
		else
		{
			version = VIZ_UNICODE;
		}
	}
}
else
{
	private import dinrus; // D2 useWfuncs.
}


version(VIZ_NO_D2_AND_ABOVE)
{
}
else
{
	version(D_Version2)
	{
		version = VIZ_D2_AND_ABOVE;
	}
	else version(D_Version3)
	{
		version = VIZ_D3_AND_ABOVE;
		version = VIZ_D2_AND_ABOVE;
	}
}


// Determine if using the "W" functions on Windows NT.
version(VIZ_UNICODE)
{
	const бул использоватьЮникод = да;
}
else version(VIZ_ANSI)
{
	const бул использоватьЮникод = нет;
}
else
{
	version = VIZ_BOTH_STRINGS;
	
	//бул использоватьЮникод = нет;
	//alias os.win.charset.useWfuncs использоватьЮникод; // D2 has this in std.file.
	//alias useWfuncs использоватьЮникод; // D1 has it in both, causing а conflict.
	// os.win.charset is а better place for it, so use that one if present.
	static if(is(typeof(&os.win.charset.useWfuncs)))
		alias os.win.charset.useWfuncs использоватьЮникод;
	else
		const использоватьЮникод = 1;
}

package:

version(VIZ_LOAD_INTERNAL_LIBS)
{
	alias LoadLibraryA иницВнутрБиб;
}
else
{
	version = VIZ_GET_INTERNAL_LIBS;
	
	alias GetModuleHandleA иницВнутрБиб;
}


HMODULE _user32, _kernel32, _advapi32, _gdi32;

package HMODULE advapi32() // getter
{
	// advapi32 generally always delay loads.
	if(!_advapi32)
		_advapi32 = LoadLibraryA("advapi32.dll");
	return _advapi32;
}

package HMODULE gdi32() // getter
{
	// gdi32 sometimes delay loads.
	version(VIZ_GET_INTERNAL_LIBS)
	{
		if(!_gdi32)
			_gdi32 = LoadLibraryA("gdi32.dll");
	}
	return _gdi32;
}

package HMODULE user32() // getter
{
	version(VIZ_GET_INTERNAL_LIBS)
	{
		if(!_user32)
			_user32 = LoadLibraryA("user32.dll");
	}
	return _user32;
}

package HMODULE kernel32() // getter
{
	version(VIZ_GET_INTERNAL_LIBS)
	{
		if(!_kernel32)
			_kernel32 = LoadLibraryA("kernel32.dll");
	}
	return _kernel32;
}


private:

version(VIZ_UNICODE)
	version = STATIC_UNICODE;


public проц _utfinit() // package
{
	version(VIZ_UNICODE)
	{
	}
	else version(VIZ_ANSI)
	{
	}
	else
	{
		/+
		OSVERSIONINFOA osv;
		osv.dwOSVersionInfoSize = OSVERSIONINFOA.sizeof;
		if(GetVersionExA(&osv))
			использоватьЮникод = osv.dwPlatformId == VER_PLATFORM_WIN32_NT;
		+/
		
		_user32 = иницВнутрБиб("user32.dll");
		_kernel32 = иницВнутрБиб("kernel32.dll");
		_advapi32 = GetModuleHandleA("advapi32.dll"); // Not guaranteed to be loaded.
		_gdi32 = иницВнутрБиб("gdi32.dll");
	}
}


template _getlen(T)
{
	т_мера _getlen(T* tz)
	in
	{
		assert(tz);
	}
	body
	{
		T* p;
		for(p = tz; *p; p++)
		{
		}
		return p - tz;
	}
}


public:

Ткст0 небезопТкст0(Ткст s)
{
	if(!s.length)
		return "";
	
	// Check if already пусто terminated.
	if(!s.ptr[s.length]) // Disables границы checking.
		return s.ptr;
	
	// Need to duplicate with пусто terminator.
	сим[] результат;
	результат = new сим[s.length + 1];
	результат[0 .. s.length] = s;
	результат[s.length] = 0;
	//return результат.ptr;
	return cast(Ткст0)результат.ptr; // Needed in D2.
}


Ткст юникодВАнзи(Шткст0 юникод, т_мера ulen)
{
	if(!ulen)
		return пусто;
	
	шткст0 wsz;
	сим[] результат;
	цел len;
	
	len = WideCharToMultiByte(0, 0, юникод, ulen, пусто, 0, пусто, пусто);
	assert(len > 0);
	
	результат = new сим[len];
	len = WideCharToMultiByte(0, 0, юникод, ulen, результат.ptr, len, пусто, пусто);
	assert(len == результат.length);
	//return результат[0 .. len - 1];
	return cast(Ткст)результат[0 .. len - 1]; // Needed in D2.
}


Шткст анзиВЮникод(Ткст0 ansi, т_мера len)
{
	wchar[] ws;
	
	len++;
	ws = new wchar[len];
	
	len = os.windows.MultiByteToWideChar(0, 0, ansi, len, ws.ptr, len);
	//assert(len == ws.length);
	ws = ws[0 .. len - 1]; // Exclude пусто сим at end.
	
	//return ws;
	return cast(Шткст)ws; // Needed in D2.
}


Ткст изАнзи(Ткст0 ansi, т_мера len)
{
	return вЮ8(анзиВЮникод(ansi, len));
}

version(VIZ_D2_AND_ABOVE)
{
	Ткст изАнзи(ткст0 ansi, т_мера len)
	{
		return изАнзи(cast(Ткст0)ansi, len);
	}
}


Ткст изАнзи0(Ткст0 ansiz)
{
	if(!ansiz)
		return пусто;
	
	//return изАнзи(ansiz, _getlen!(сим)(ansiz));
	return изАнзи(ansiz, _getlen(ansiz));
}

version(VIZ_D2_AND_ABOVE)
{
	Ткст изАнзи0(ткст0 ansi)
	{
		return изАнзи0(cast(Ткст0)ansi);
	}
}


private Ткст _toAnsiz(Ткст utf8, бул safe = да)
{
	// This function is intentionally unsafe; depends on "safe" парам.
	foreach(сим ch; utf8)
	{
		if(ch >= 0x80)
		{
			сим[] результат;
			auto wsz = вЮ16н(utf8);
			auto len = WideCharToMultiByte(0, 0, wsz, -1, пусто, 0, пусто, пусто);
			assert(len > 0);
			
			результат = new сим[len];
			len = WideCharToMultiByte(0, 0, wsz, -1, результат.ptr, len, пусто, пусто);
			assert(len == результат.length);
			//return результат[0 .. len - 1];
			return cast(Ткст)результат[0 .. len - 1]; // Needed in D2.
		}
	}
	
	// Don't need conversion.
	if(safe)
		//return вТкст0(utf8)[0 .. utf8.length];
		return cast(Ткст)вТкст0(utf8)[0 .. utf8.length]; // Needed in D2.
	return небезопТкст0(utf8)[0 .. utf8.length];
}


private т_мера toAnsiLength(Ткст utf8)
{
	foreach(сим ch; utf8)
	{
		if(ch >= 0x80)
		{
			auto wsz = вЮ16н(utf8);
			auto len = WideCharToMultiByte(0, 0, wsz, -1, пусто, 0, пусто, пусто);
			assert(len > 0);
			return len - 1; // Minus пусто.
		}
	}
	return utf8.length; // Just ASCII; same length.
}


private Ткст _unsafeAnsiz(Ткст utf8)
{
	return _toAnsiz(utf8, нет);
}


Ткст0 вАнзи0(Ткст utf8, бул safe = да)
{
	return _toAnsiz(utf8, safe).ptr;
}


Ткст0 небезопАнзи0(Ткст utf8)
{
	return _toAnsiz(utf8, нет).ptr;
}


Ткст вАнзи(Ткст utf8, бул safe = да)
{
	return _toAnsiz(utf8, safe);
}


Ткст небезопАнзи(Ткст utf8)
{
	return _toAnsiz(utf8, нет);
}


Ткст изЮникода(Шткст0 юникод, т_мера len)
{
	return вЮ8(юникод[0 .. len]);
}

version(VIZ_D2_AND_ABOVE)
{
	Ткст изЮникода(шткст0 юникод, т_мера len)
	{
		return изЮникода(cast(Шткст0)юникод, len);
	}
}


Ткст изЮникода0(Шткст0 unicodez)
{
	if(!unicodez)
		return пусто;
	
	//return изЮникода(unicodez, _getlen!(wchar)(unicodez));
	return изЮникода(unicodez, _getlen(unicodez));
}

version(VIZ_D2_AND_ABOVE)
{
	Ткст изЮникода0(шткст0 unicodez)
	{
		return изЮникода0(cast(Шткст0)unicodez);
	}
}


Шткст0 вЮни0(Ткст utf8)
{
	//return вЮ16н(utf8);
	return cast(Шткст0)вЮ16н(utf8); // Needed in D2.
}


Шткст вЮни(Ткст utf8)
{
	return вЮ16(utf8);
}


т_мера вДлинуЮникода(Ткст utf8)
{
	т_мера результат = 0;
	foreach(wchar wch; utf8)
	{
		результат++;
	}
	return результат;
}


private extern(Windows)
{
	alias УОК function(DWORD dwExStyle, LPCWSTR lpClassName, LPCWSTR lpWindowName, DWORD dwStyle,
		цел ш, цел в, цел nWidth, цел nHeight, УОК hWndParent, HMENU hMenu, экз hInstance,
		LPVOID lpParam) CreateWindowExWProc;
	alias цел function(УОК уок) GetWindowTextLengthWProc;
	alias цел function(УОК уок, LPCWSTR lpString, цел nMaxCount) GetWindowTextWProc;
	alias BOOL function(УОК уок, LPCWSTR lpString) SetWindowTextWProc;
	alias LRESULT function(УОК уок, UINT Msg, WPARAM парам1, LPARAM парам2) SendMessageWProc;
	alias LRESULT function(WNDPROC lpPrevWndFunc, УОК уок, UINT Msg, WPARAM парам1, LPARAM парам2)
		CallWindowProcWProc;
	alias UINT function(LPCWSTR lpszFormat) RegisterClipboardFormatWProc;
	alias цел function (UINT format, LPWSTR lpszFormatName, цел cchMaxCount)
		GetClipboardFormatNameWProc;
	alias цел function(HDC hdc, LPWSTR lpchText, цел cchText, LPRECT lprc, UINT dwDTFormat,
		LPDRAWTEXTPARAMS lpDTParams) DrawTextExWProc;
	alias BOOL function(LPCWSTR lpPathName) SetCurrentDirectoryWProc;
	alias DWORD function(DWORD nBufferLength, LPWSTR lpBuffer) GetCurrentDirectoryWProc;
	alias BOOL function(LPWSTR lpBuffer, LPDWORD nSize) GetComputerNameWProc;
	alias UINT function(LPWSTR lpBuffer, UINT uSize) GetSystemDirectoryWProc;
	alias BOOL function(LPWSTR lpBuffer, LPDWORD nSize) GetUserNameWProc;
	alias DWORD function(LPCWSTR lpSrc, LPWSTR lpDst, DWORD nSize) ExpandEnvironmentStringsWProc;
	alias DWORD function(LPCWSTR lpName, LPWSTR lpBuffer, DWORD nSize) GetEnvironmentVariableWProc;
	alias LONG function(HKEY hKey, LPCWSTR lpValueName, DWORD Reserved, DWORD dwType, BYTE* lpData,
		DWORD cbData) RegSetValueExWProc;
	alias LONG function(HKEY hKey, LPCWSTR lpSubKey, DWORD Reserved, LPWSTR lpClass, DWORD dwOptions,
		REGSAM samDesired, LPSECURITY_ATTRIBUTES lpSecurityAttributes, PHKEY phkResult,
		LPDWORD lpdwDisposition) RegCreateKeyExWProc;
	alias LONG function(HKEY hKey, LPCWSTR lpSubKey, DWORD ulOptions, REGSAM samDesired,
		PHKEY phkResult) RegOpenKeyExWProc;
	alias LONG function(HKEY hKey, LPCWSTR lpSubKey) RegDeleteKeyWProc;
	alias LONG function(HKEY hKey, DWORD dwIndex, LPWSTR lpName, LPDWORD lpcbName, LPDWORD lpReserved,
		LPWSTR lpClass, LPDWORD lpcbClass, PFILETIME lpftLastWriteTime) RegEnumKeyExWProc;
	alias LONG function(HKEY hKey, LPCWSTR lpValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData,
		LPDWORD lpcbData) RegQueryValueExWProc;
	alias LONG function(HKEY hKey, DWORD dwIndex, LPTSTR lpValueName, LPDWORD lpcbValueName,
		LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData) RegEnumValueWProc;
	alias ATOM function(WNDCLASSW* lpWndClass) RegisterClassWProc;
	alias BOOL function(HDC hdc, LPCWSTR lpString, цел cbString, LPSIZE lpSize) GetTextExtentPoint32WProc;
	alias HANDLE function(экз hinst, LPCWSTR lpszName, UINT uType, цел cxDesired, цел cyDesired, UINT fuLoad)
		LoadImageWProc;
	alias UINT function(HDROP hDrop, UINT iFile, LPWSTR lpszFile, UINT cch) DragQueryFileWProc;
	alias DWORD function(HMODULE hModule, LPWSTR lpFilename, DWORD nSize) GetModuleFileNameWProc;
	alias LONG function(MSG* lpmsg) DispatchMessageWProc;
	alias BOOL function(LPMSG lpMsg, УОК уок, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg)
		PeekMessageWProc;
	alias BOOL function(УОК hDlg, LPMSG lpMsg) IsDialogMessageWProc;
	alias LRESULT function(УОК уок, UINT Msg, WPARAM парам1, LPARAM парам2) DefWindowProcWProc;
	alias LRESULT function(УОК hDlg, UINT Msg, WPARAM парам1, LPARAM парам2) DefDlgProcWProc;
	alias LRESULT function(УОК уок, УОК hWndMDIClient, UINT uMsg, WPARAM парам1, LPARAM парам2) DefFrameProcWProc;
	alias LRESULT function(УОК уок, UINT uMsg, WPARAM парам1, LPARAM парам2) DefMDIChildProcWProc;
	alias BOOL function(экз hInstance, LPCWSTR lpClassName, LPWNDCLASSW lpWndClass) GetClassInfoWProc;
	alias HANDLE function(LPCWSTR lpPathName, BOOL bWatchSubtree, DWORD dwNotifyFilter) FindFirstChangeNotificationWProc;
	alias DWORD function(LPCWSTR lpFileName, DWORD nBufferLength, LPWSTR lpBuffer, LPWSTR *lpFilePart) GetFullPathNameWProc;
	alias typeof(&LoadLibraryExW) LoadLibraryExWProc;
	alias typeof(&SetMenuItemInfoW) SetMenuItemInfoWProc;
	alias typeof(&InsertMenuItemW) InsertMenuItemWProc;
	alias typeof(&CreateFontIndirectW) CreateFontIndirectWProc;
	alias typeof(&GetObjectW) GetObjectWProc;
}


private проц дайОшПроц(Ткст procName)
{
	Ткст errdesc;
	version(VIZ_NO_PROC_ERROR_INFO)
	{
	}
	else
	{
		auto le = cast(цел)GetLastError();
		if(le)
			errdesc = " (ошибка " ~ вТкст(le) ~ ")";
	}
	throw new Exception("Unable to загрузка procedure " ~ procName ~ errdesc);
}


// If loading from а resource just use LoadImageA().
HANDLE загрузиРисунок(экз hinst, Ткст имя, UINT uType, цел cxDesired, цел cyDesired, UINT fuLoa)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias LoadImageW proc;
		}
		else
		{
			const Ткст ИМЯ = "LoadImageW";
			static LoadImageWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(LoadImageWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(hinst, вЮни0(имя), uType, cxDesired, cyDesired, fuLoa);
	}
	else
	{
		return LoadImageA(hinst, небезопАнзи0(имя), uType, cxDesired, cyDesired, fuLoa);
	}
}


УОК создайОкноДоп(DWORD dwExStyle, Ткст имяКласса, Ткст windowName, DWORD dwStyle,
	цел ш, цел в, цел nWidth, цел nHeight, УОК hWndParent, HMENU hMenu, экз hInstance,
	LPVOID lpParam)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias CreateWindowExW proc;
		}
		else
		{
			const Ткст ИМЯ = "CreateWindowExW";
			static CreateWindowExWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(CreateWindowExWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		//if(windowName.length)
		//	MessageBoxW(пусто, вЮни0(windowName), вЮни0(имяКласса ~ " заглавие"), 0);
		return proc(dwExStyle, вЮни0(имяКласса), вЮни0(windowName), dwStyle,
			ш, в, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
	}
	else
	{
		return CreateWindowExA(dwExStyle, небезопАнзи0(имяКласса), небезопАнзи0(windowName), dwStyle,
			ш, в, nWidth, nHeight, hWndParent, hMenu, cast(HINSTANCE) hInstance, lpParam);
	}
}


УОК создайОкно(Ткст имяКласса, Ткст windowName, DWORD dwStyle, цел ш, цел в,
	цел nWidth, цел nHeight, УОК hWndParent, HMENU hMenu, HANDLE hInstance, LPVOID lpParam)
{
	return создайОкноДоп(0, имяКласса, windowName, dwStyle, ш, в,
		nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
}


Ткст дайТекстОкна(УОК уок)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetWindowTextW proc;
			alias GetWindowTextLengthW proclen;
		}
		else
		{
			const Ткст ИМЯ = "GetWindowTextW";
			static GetWindowTextWProc proc = пусто;
			
			const Ткст NAMELEN = "GetWindowTextLengthW";
			static GetWindowTextLengthWProc proclen = пусто;
			
			if(!proc)
			{
				proc = cast(GetWindowTextWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
				
				//if(!proclen)
				{
					proclen = cast(GetWindowTextLengthWProc)GetProcAddress(user32, NAMELEN.ptr);
					//if(!proclen)
					//	дайОшПроц(NAMELEN);
				}
			}
		}
		
		шткст0 buf;
		т_мера len;
		
		len = proclen(уок);
		if(!len)
			return пусто;
		len++;
		buf = (new wchar[len]).ptr;
		
		len = proc(уок, buf, len);
		return изЮникода(buf, len);
	}
	else
	{
		ткст0 buf;
		т_мера len;
		
		len = GetWindowTextLengthA(уок);
		if(!len)
			return пусто;
		len++;
		buf = (new сим[len]).ptr;
		
		len = GetWindowTextA(уок, buf, len);
		return изАнзи(buf, len);
	}
}


BOOL установиТекстОкна(УОК уок, Ткст str)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias SetWindowTextW proc;
		}
		else
		{
			const Ткст ИМЯ = "SetWindowTextW";
			static SetWindowTextWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(SetWindowTextWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(уок, вЮни0(str));
	}
	else
	{
		return SetWindowTextA(уок, небезопАнзи0(str));
	}
}


Ткст дайИмяФайлаМодуля(HMODULE hmod)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetModuleFileNameW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetModuleFileNameW";
			static GetModuleFileNameWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetModuleFileNameWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		wchar[] s;
		DWORD len;
		s = new wchar[МАКС_ПУТЬ];
		len = proc(hmod, s.ptr, s.length);
		return изЮникода(s.ptr, len);
	}
	else
	{
		сим[] s;
		DWORD len;
		s = new сим[МАКС_ПУТЬ];
		len = GetModuleFileNameA(hmod, s.ptr, s.length);
		return изАнзи(s.ptr, len);
	}
}


version = STATIC_UNICODE_SEND_MESSAGE;


version(STATIC_UNICODE_SEND_MESSAGE)
{
}
else
{
	version(VIZ_UNICODE)
	{
		version = STATIC_UNICODE_SEND_MESSAGE;
	}
	else version(VIZ_ANSI)
	{
	}
	else
	{
		private SendMessageWProc _loadSendMessageW()
		{
			const Ткст ИМЯ = "SendMessageW";
			static SendMessageWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(SendMessageWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
			
			return proc;
		}
	}
}


// Sends EM_GETSELTEXT to а rich текст box and returns the текст.
Ткст emGetSelText(УОК уок, т_мера selTextLength)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_SEND_MESSAGE)
		{
			alias SendMessageW proc;
		}
		else
		{
			SendMessageWProc proc;
			proc = _loadSendMessageW();
		}
		
		wchar[] buf;
		т_мера len;
		buf = new wchar[selTextLength + 1];
		len = proc(уок, EM_GETSELTEXT, 0, cast(LPARAM)buf.ptr);
		return изЮникода(buf.ptr, len);
	}
	else
	{
		сим[] buf;
		т_мера len;
		buf = new сим[selTextLength + 1];
		len = SendMessageA(уок, EM_GETSELTEXT, 0, cast(LPARAM)buf.ptr);
		return изАнзи(buf.ptr, len);
	}
}


// Gets the selected текст of an edit box.
// This needs to retrieve the entire текст and strip out the extra.
Ткст дайВыделенныйТекст(УОК уок)
{
	бцел v1, v2;
	бцел len;
	
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_SEND_MESSAGE)
		{
			alias SendMessageW proc;
		}
		else
		{
			SendMessageWProc proc;
			proc = _loadSendMessageW();
		}
		
		proc(уок, EM_GETSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
		if(v1 == v2)
			return пусто;
		assert(v2 > v1);
		
		len = proc(уок, WM_GETTEXTLENGTH, 0, 0);
		if(len)
		{
			len++;
			шткст0 buf;
			buf = (new wchar[len]).ptr;
			
			len = proc(уок, WM_GETTEXT, len, cast(LPARAM)buf);
			if(len)
			{
				wchar[] s;
				s = buf[v1 .. v2].dup;
				return изЮникода(s.ptr, s.length);
			}
		}
	}
	else
	{
		SendMessageA(уок, EM_GETSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
		if(v1 == v2)
			return пусто;
		assert(v2 > v1);
		
		len = SendMessageA(уок, WM_GETTEXTLENGTH, 0, 0);
		if(len)
		{
			len++;
			ткст0 buf;
			buf = (new сим[len]).ptr;
			
			len = SendMessageA(уок, WM_GETTEXT, len, cast(LPARAM)buf);
			if(len)
			{
				сим[] s;
				s = buf[v1 .. v2].dup;
				return изАнзи(s.ptr, s.length);
			}
		}
	}
	
	return пусто;
}


// Sends EM_SETPASSWORDCHAR to an edit box.
// TODO: check if correct implementation.
проц emSetPasswordChar(УОК уок, дим pwc)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_SEND_MESSAGE)
		{
			alias SendMessageW proc;
		}
		else
		{
			SendMessageWProc proc;
			proc = _loadSendMessageW();
		}
		
		proc(уок, EM_SETPASSWORDCHAR, pwc, 0); // ?
	}
	else
	{
		Ткст chs;
		Ткст ansichs;
		chs = вЮ8((&pwc)[0 .. 1]);
		ansichs = небезопАнзи(chs);
		
		if(ansichs)
			SendMessageA(уок, EM_SETPASSWORDCHAR, ansichs[0], 0); // ?
	}
}


// Sends EM_GETPASSWORDCHAR to an edit box.
// TODO: check if correct implementation.
дим emGetPasswordChar(УОК уок)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_SEND_MESSAGE)
		{
			alias SendMessageW proc;
		}
		else
		{
			SendMessageWProc proc;
			proc = _loadSendMessageW();
		}
		
		return cast(дим)proc(уок, EM_GETPASSWORDCHAR, 0, 0); // ?
	}
	else
	{
		сим ansich;
		Ткст chs;
		Дткст dchs;
		ansich = cast(сим)SendMessageA(уок, EM_GETPASSWORDCHAR, 0, 0);
		//chs = изАнзи((&ansich)[0 .. 1], 1);
		chs = изАнзи(&ansich, 1);
		dchs = вЮ32(chs);
		if(dchs.length == 1)
			return dchs[0]; // ?
		return 0;
	}
}


LRESULT шлиСооб(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_SEND_MESSAGE)
		{
			alias SendMessageW proc;
		}
		else
		{
			SendMessageWProc proc;
			proc = _loadSendMessageW();
		}
		
		return proc(уок, сооб, wparam, lparam);
	}
	else
	{
		return SendMessageA(уок, сооб, wparam, lparam);
	}
}


LRESULT шлиСооб(УОК уок, UINT сооб, WPARAM wparam, Ткст lparam, бул safe = да)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_SEND_MESSAGE)
		{
			alias SendMessageW proc;
		}
		else
		{
			SendMessageWProc proc;
			proc = _loadSendMessageW();
		}
		
		return proc(уок, сооб, wparam, cast(LPARAM)вЮни0(lparam));
	}
	else
	{
		return SendMessageA(уок, сооб, wparam, cast(LPARAM)вАнзи0(lparam, safe)); // Can't assume небезопАнзи0() is ОК here.
	}
}


LRESULT шлиСообНебезоп(УОК уок, UINT сооб, WPARAM wparam, Ткст lparam)
{
	return шлиСооб(уок, сооб, wparam, lparam, нет);
}


version = STATIC_UNICODE_CALL_WINDOW_PROC;


LRESULT вызовиОкПроц(WNDPROC lpPrevWndFunc, УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_CALL_WINDOW_PROC)
		{
			alias CallWindowProcW proc;
		}
		else
		{
			const Ткст ИМЯ = "CallWindowProcW";
			static CallWindowProcWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(CallWindowProcWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(lpPrevWndFunc, уок, сооб, wparam, lparam);
	}
	else
	{
		return CallWindowProcA(lpPrevWndFunc, уок, сооб, wparam, lparam);
	}
}


UINT регистрируйФорматБуфОбмена(Ткст formatName)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias RegisterClipboardFormatW proc;
		}
		else
		{
			const Ткст ИМЯ = "RegisterClipboardFormatW";
			static RegisterClipboardFormatWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(RegisterClipboardFormatWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(вЮни0(formatName));
	}
	else
	{
		return RegisterClipboardFormatA(небезопАнзи0(formatName));
	}
}


Ткст дайИмяФорматаБуфОбмена(UINT format)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetClipboardFormatNameW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetClipboardFormatNameW";
			static GetClipboardFormatNameWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetClipboardFormatNameWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		wchar[] buf;
		цел len;
		buf = new wchar[64];
		len = proc(format, buf.ptr, buf.length);
		if(!len)
			return пусто;
		return изЮникода(buf.ptr, len);
	}
	else
	{
		сим[] buf;
		цел len;
		buf = new сим[64];
		len = GetClipboardFormatNameA(format, buf.ptr, buf.length);
		if(!len)
			return пусто;
		return изАнзи(buf.ptr, len);
	}
}


// On Windows 9x, the number of characters cannot exceed 8192.
цел рисуйТекстДоп(HDC hdc, Ткст текст, LPRECT lprc, UINT dwDTFormat, LPDRAWTEXTPARAMS lpDTParams)
{
	// Note: an older version of MSDN says cchText should be -1 for а пусто terminated string,
	// whereas the newer MSDN says 1. Lets just play it safe and use а local пусто terminated
	// string when the length is 1 so that it won't continue reading past the 1 character,
	// reguardless of which MSDN version is correct.
	
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias DrawTextExW proc;
		}
		else
		{
			const Ткст ИМЯ = "DrawTextExW";
			static DrawTextExWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(DrawTextExWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		/+
		шткст0 strz;
		strz = вЮни0(текст);
		return proc(hdc, strz, -1, lprc, dwDTFormat, lpDTParams);
		+/
		Шткст str;
		wchar[2] tempStr;
		str = вЮни(текст);
		if(str.length == 1)
		{
			tempStr[0] = str[0];
			tempStr[1] = 0;
			//str = tempStr[0 .. 1];
			str = cast(Шткст)tempStr[0 .. 1]; // Needed in D2.
		}
		//return proc(hdc, str.ptr, str.length, lprc, dwDTFormat, lpDTParams);
		return proc(hdc, cast(шткст0)str.ptr, str.length, lprc, dwDTFormat, lpDTParams); // Needed in D2.
	}
	else
	{
		/+
		ткст0 strz;
		strz = небезопАнзи0(текст);
		return DrawTextExA(hdc, strz, -1, lprc, dwDTFormat, lpDTParams);
		+/
		Ткст str;
		сим[2] tempStr;
		str = небезопАнзи(текст);
		if(str.length == 1)
		{
			tempStr[0] = str[0];
			tempStr[1] = 0;
			//str = tempStr[0 .. 1];
			str = cast(Ткст)tempStr[0 .. 1]; // Needed in D2.
		}
		//return DrawTextExA(hdc, str.ptr, str.length, lprc, dwDTFormat, lpDTParams);
		return DrawTextExA(hdc, cast(ткст0)str.ptr, str.length, lprc, dwDTFormat, lpDTParams); // Needed in D2.
	}
}


Ткст дайКоманднуюСтроку()
{
	// Windows 9x supports GetCommandLineW().
	return изЮникода0(GetCommandLineW());
}


BOOL установиТекущуюПапку(Ткст pathName)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias SetCurrentDirectoryW proc;
		}
		else
		{
			const Ткст ИМЯ = "SetCurrentDirectoryW";
			static SetCurrentDirectoryWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(SetCurrentDirectoryWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(вЮни0(pathName));
	}
	else
	{
		return SetCurrentDirectoryA(небезопАнзи0(pathName));
	}
}


Ткст дайТекущуюПапку()
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetCurrentDirectoryW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetCurrentDirectoryW";
			static GetCurrentDirectoryWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetCurrentDirectoryWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		шткст0 buf;
		цел len;
		len = proc(0, пусто);
		buf = (new wchar[len]).ptr;
		len = proc(len, buf);
		if(!len)
			return пусто;
		return изЮникода(buf, len);
	}
	else
	{
		ткст0 buf;
		цел len;
		len = GetCurrentDirectoryA(0, пусто);
		buf = (new сим[len]).ptr;
		len = GetCurrentDirectoryA(len, buf);
		if(!len)
			return пусто;
		return изАнзи(buf, len);
	}
}


Ткст дайИмяКомпьютера()
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetComputerNameW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetComputerNameW";
			static GetComputerNameWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetComputerNameWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		wchar[] buf;
		DWORD len = MAX_COMPUTERNAME_LENGTH + 1;
		buf = new wchar[len];
		if(!proc(buf.ptr, &len))
			return пусто;
		return изЮникода(buf.ptr, len);
	}
	else
	{
		сим[] buf;
		DWORD len = MAX_COMPUTERNAME_LENGTH + 1;
		buf = new сим[len];
		if(!GetComputerNameA(buf.ptr, &len))
			return пусто;
		return изАнзи(buf.ptr, len);
	}
}


Ткст дайСистПапку()
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetSystemDirectoryW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetSystemDirectoryW";
			static GetSystemDirectoryWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetSystemDirectoryWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		wchar[] buf;
		UINT len;
		buf = new wchar[МАКС_ПУТЬ];
		len = proc(buf.ptr, buf.length);
		if(!len)
			return пусто;
		return изЮникода(buf.ptr, len);
	}
	else
	{
		сим[] buf;
		UINT len;
		buf = new сим[МАКС_ПУТЬ];
		len = GetSystemDirectoryA(buf.ptr, buf.length);
		if(!len)
			return пусто;
		return изАнзи(buf.ptr, len);
	}
}


Ткст дайИмяПользователя()
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetUserNameW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetUserNameW";
			static GetUserNameWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetUserNameWProc)GetProcAddress(advapi32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		wchar[256 + 1] buf;
		DWORD len = buf.length;
		if(!proc(buf.ptr, &len) || !len || !--len) // Also удали пусто-terminator.
			return пусто;
		return изЮникода(buf.ptr, len);
	}
	else
	{
		сим[256 + 1] buf;
		DWORD len = buf.length;
		if(!GetUserNameA(buf.ptr, &len) || !len || !--len) // Also удали пусто-terminator.
			return пусто;
		return изАнзи(buf.ptr, len);
	}
}


// Returns 0 on failure.
DWORD разверниСтрокиСреды(Ткст src, out Ткст результат)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias ExpandEnvironmentStringsW proc;
		}
		else
		{
			const Ткст ИМЯ = "ExpandEnvironmentStringsW";
			static ExpandEnvironmentStringsWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(ExpandEnvironmentStringsWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		шткст0 dest;
		DWORD len;
		
		auto strz = вЮни0(src);
		len = proc(strz, пусто, 0);
		if(!len)
			return 0;
		dest = (new wchar[len]).ptr;
		len = proc(strz, dest, len);
		if(!len)
			return 0;
		результат = изЮникода(dest, len - 1);
		return len;
	}
	else
	{
		ткст0 dest;
		DWORD len;
		
		auto strz = небезопАнзи0(src);
		len = ExpandEnvironmentStringsA(strz, пусто, 0);
		if(!len)
			return 0;
		dest = (new сим[len]).ptr;
		len = ExpandEnvironmentStringsA(strz, dest, len);
		if(!len)
			return 0;
		результат = изАнзи(dest, len - 1);
		return len;
	}
}


Ткст дайПеременнуюСреды(Ткст имя)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetEnvironmentVariableW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetEnvironmentVariableW";
			static GetEnvironmentVariableWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetEnvironmentVariableWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		шткст0 buf;
		DWORD len;
		auto strz = вЮни0(имя);
		len = proc(strz, пусто, 0);
		if(!len)
			return пусто;
		buf = (new wchar[len]).ptr;
		len = proc(strz, buf, len);
		return изЮникода(buf, len);
	}
	else
	{
		ткст0 buf;
		DWORD len;
		auto strz = небезопАнзи0(имя);
		len = GetEnvironmentVariableA(strz, пусто, 0);
		if(!len)
			return пусто;
		buf = (new сим[len]).ptr;
		len = GetEnvironmentVariableA(strz, buf, len);
		return изАнзи(buf, len);
	}
}


цел окноСообщ(УОК уок, Ткст текст, Ткст заглавие, UINT uType)
{
	// Windows 9x supports MessageBoxW().
	return MessageBoxW(уок, вЮни0(текст), вЮни0(заглавие), uType);
}


struct КлассОкна
{
	union
	{
		WNDCLASSW кош;
		WNDCLASSA коа;
	}
	alias кош ко;
	
	Ткст имяКласса;
}


ATOM зарегистрируйКласс(inout КлассОкна ко)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias RegisterClassW proc;
		}
		else
		{
			const Ткст ИМЯ = "RegisterClassW";
			static RegisterClassWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(RegisterClassWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		ко.кош.lpszClassName = вЮни0(ко.имяКласса);
		return proc(&ко.кош);
	}
	else
	{
		ко.коа.lpszClassName = небезопАнзи0(ко.имяКласса);
		return RegisterClassA(&ко.коа);
	}
}


BOOL дайИнфОКлассе(экз hinst, Ткст имяКласса, inout КлассОкна ко)
{
	ко.имяКласса = имяКласса; // ?
	
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetClassInfoW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetClassInfoW";
			static GetClassInfoWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetClassInfoWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(hinst, вЮни0(имяКласса), &ко.кош);
	}
	else
	{
		return GetClassInfoA(hinst, небезопАнзи0(имяКласса), &ко.коа);
	}
}


// Shouldn't have been implemented this way.
deprecated BOOL getTextExtentPoint32(HDC hdc, Ткст текст, LPSIZE lpSize)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetTextExtentPoint32W proc;
		}
		else
		{
			const Ткст ИМЯ = "GetTextExtentPoint32W";
			static GetTextExtentPoint32WProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetTextExtentPoint32WProc)GetProcAddress(gdi32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		Шткст str;
		str = вЮни(текст);
		return proc(hdc, str.ptr, str.length, lpSize);
	}
	else
	{
		// Using GetTextExtentPoint32A here even though W is supported in order
		// to keep the measurements accurate with DrawTextA.
		Ткст str;
		str = небезопАнзи(текст);
		return GetTextExtentPoint32A(hdc, str.ptr, str.length, lpSize);
	}
}


Ткст dragQueryFile(HDROP hDrop, UINT iFile)
{
	if(iFile >= 0xFFFFFFFF)
		return пусто;
	
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias DragQueryFileW proc;
		}
		else
		{
			const Ткст ИМЯ = "DragQueryFileW";
			static DragQueryFileWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(DragQueryFileWProc)GetProcAddress(GetModuleHandleA("shell32.dll"), ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		wchar[] str;
		UINT len;
		len = proc(hDrop, iFile, пусто, 0);
		if(!len)
			return пусто;
		str = new wchar[len + 1];
		proc(hDrop, iFile, str.ptr, str.length);
		return изЮникода(str.ptr, len);
	}
	else
	{
		сим[] str;
		UINT len;
		len = DragQueryFileA(hDrop, iFile, пусто, 0);
		if(!len)
			return пусто;
		str = new сим[len + 1];
		DragQueryFileA(hDrop, iFile, str.ptr, str.length);
		return изАнзи(str.ptr, len);
	}
}


// Just gets the number of files.
UINT dragQueryFile(HDROP hDrop)
{
	return DragQueryFileA(hDrop, 0xFFFFFFFF, пусто, 0);
}


HANDLE создайФайл(Ткст фимя, DWORD dwDesiredAccess, DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes,
	DWORD dwCreationDistribution, DWORD dwFlagsAndAttributes, HANDLE hTemplateFile)
{
	if(использоватьЮникод)
	{
		return CreateFileW(вЮни0(фимя), dwDesiredAccess, dwShareMode, lpSecurityAttributes,
			dwCreationDistribution, dwFlagsAndAttributes, hTemplateFile);
	}
	else
	{
		return CreateFileA(небезопАнзи0(фимя), dwDesiredAccess, dwShareMode, lpSecurityAttributes,
			dwCreationDistribution, dwFlagsAndAttributes, hTemplateFile);
	}
}


version = STATIC_UNICODE_DEF_WINDOW_PROC;


LRESULT дефОкПроц(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_DEF_WINDOW_PROC)
		{
			alias DefWindowProcW proc;
		}
		else
		{
			const Ткст ИМЯ = "DefWindowProcW";
			static DefWindowProcWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(DefWindowProcWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(уок, сооб, wparam, lparam);
	}
	else
	{
		return DefWindowProcA(уок, сооб, wparam, lparam);
	}
}


LRESULT дефДлгПроц(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_DEF_WINDOW_PROC)
		{
			alias DefDlgProcW proc;
		}
		else
		{
			const Ткст ИМЯ = "DefDlgProcW";
			static DefDlgProcWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(DefDlgProcWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(уок, сооб, wparam, lparam);
	}
	else
	{
		return DefDlgProcA(уок, сооб, wparam, lparam);
	}
}


LRESULT дефФреймПроц(УОК уок, УОК hwndMdiClient, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_DEF_WINDOW_PROC)
		{
			alias DefFrameProcW proc;
		}
		else
		{
			const Ткст ИМЯ = "DefFrameProcW";
			static DefFrameProcWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(DefFrameProcWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(уок, hwndMdiClient, сооб, wparam, lparam);
	}
	else
	{
		return DefFrameProcA(уок, hwndMdiClient, сооб, wparam, lparam);
	}
}


LRESULT дефМДИОтпрыскПроц(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_DEF_WINDOW_PROC)
		{
			alias DefMDIChildProcW proc;
		}
		else
		{
			const Ткст ИМЯ = "DefMDIChildProcW";
			static DefMDIChildProcWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(DefMDIChildProcWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(уок, сооб, wparam, lparam);
	}
	else
	{
		return DefMDIChildProcA(уок, сооб, wparam, lparam);
	}
}


version = STATIC_UNICODE_PEEK_MESSAGE;
version = STATIC_UNICODE_DISPATCH_MESSAGE;


LONG dispatchMessage(MSG* pmsg)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_DISPATCH_MESSAGE)
		{
			alias DispatchMessageW dispatchproc;
		}
		else
		{
			const Ткст DISPATCHNAME = "DispatchMessageW";
			static DispatchMessageWProc dispatchproc = пусто;
			
			if(!dispatchproc)
			{
				dispatchproc = cast(DispatchMessageWProc)GetProcAddress(user32, DISPATCHNAME);
				if(!dispatchproc)
					дайОшПроц(DISPATCHNAME);
			}
		}
		
		return dispatchproc(pmsg);
	}
	else
	{
		return DispatchMessageA(pmsg);
	}
}


BOOL peekMessage(MSG* pmsg, УОК уок = HWND.init, UINT wmFilterMin = 0, UINT wmFilterMax = 0, UINT removeMsg = PM_NOREMOVE)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE_PEEK_MESSAGE)
		{
			alias PeekMessageW peekproc;
		}
		else
		{
			const Ткст PEEKNAME = "PeekMessageW";
			static PeekMessageWProc peekproc = пусто;
			
			if(!peekproc)
			{
				peekproc = cast(PeekMessageWProc)GetProcAddress(user32, PEEKNAME);
				if(!peekproc)
					дайОшПроц(PEEKNAME);
			}
		}
		
		/+
		// Using PeekMessageA to test if the окно is unicod.
		if(!PeekMessageA(pmsg, уок, wmFilterMin, wmFilterMax, PM_NOREMOVE)) // Don't удали to test if юникод.
			return 0;
		if(!IsWindowUnicode(pmsg.уок)) // Window is not юникод.
		{
			if(removeMsg == PM_NOREMOVE)
				return 1; // No need to do extra work here.
			return PeekMessageA(pmsg, уок, wmFilterMin, wmFilterMax, removeMsg);
		}
		else // Window is юникод.
		{
			return peekproc(pmsg, уок, wmFilterMin, wmFilterMax, removeMsg);
		}
		+/
		// Since I already know использоватьЮникод, use PeekMessageW to test if the окно is юникод.
		if(!peekproc(pmsg, уок, wmFilterMin, wmFilterMax, PM_NOREMOVE)) // Don't удали to test if юникод.
			return 0;
		if(!IsWindowUnicode(pmsg.уок)) // Window is not юникод.
		{
			return PeekMessageA(pmsg, уок, wmFilterMin, wmFilterMax, removeMsg);
		}
		else // Window is юникод.
		{
			if(removeMsg == PM_NOREMOVE)
				return 1; // No need to do extra work here.
			return peekproc(pmsg, уок, wmFilterMin, wmFilterMax, removeMsg);
		}
	}
	else
	{
		return PeekMessageA(pmsg, уок, wmFilterMin, wmFilterMax, removeMsg);
	}
}


BOOL getMessage(MSG* pmsg, УОК уок = HWND.init, UINT wmFilterMin = 0, UINT wmFilterMax = 0)
{
	if(!WaitMessage())
		return -1;
	if(!peekMessage(pmsg, уок, wmFilterMin, wmFilterMax, PM_REMOVE))
		return -1;
	if(WM_QUIT == pmsg.сообщение)
		return 0;
	return 1;
}


BOOL isDialogMessage(УОК уок, MSG* pmsg)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias IsDialogMessageW proc;
		}
		else
		{
			const Ткст ИМЯ = "IsDialogMessageW";
			static IsDialogMessageWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(IsDialogMessageWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(уок, pmsg);
	}
	else
	{
		return IsDialogMessageA(уок, pmsg);
	}
}


HANDLE findFirstChangeNotification(Ткст pathName, BOOL watchSubtree, DWORD notifyFilter)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias FindFirstChangeNotificationW proc;
		}
		else
		{
			const Ткст ИМЯ = "FindFirstChangeNotificationW";
			static FindFirstChangeNotificationWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(FindFirstChangeNotificationWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(вЮни0(pathName), watchSubtree, notifyFilter);
	}
	else
	{
		return FindFirstChangeNotificationA(небезопАнзи0(pathName), watchSubtree, notifyFilter);
	}
}


Ткст getFullPathName(Ткст фимя)
{
	DWORD len;
	
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetFullPathNameW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetFullPathNameW";
			static GetFullPathNameWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetFullPathNameWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		auto fnw = вЮни0(фимя);
		len = proc(fnw, 0, пусто, пусто);
		if(!len)
			return пусто;
		wchar[260] _wbuf;
		wchar[] wbuf = _wbuf;
		if(len > _wbuf.sizeof)
			wbuf = new wchar[len];
		len = proc(fnw, wbuf.length, wbuf.ptr, пусто);
		assert(len < wbuf.length);
		return изЮникода(wbuf.ptr, len);
	}
	else
	{
		auto fna = небезопАнзи0(фимя);
		len = GetFullPathNameA(fna, 0, пусто, пусто);
		if(!len)
			return пусто;
		сим[260] _abuf;
		сим[] abuf = _abuf;
		if(len > _abuf.sizeof)
			abuf = new сим[len];
		len = GetFullPathNameA(fna, abuf.length, abuf.ptr, пусто);
		assert(len < abuf.length);
		return изАнзи(abuf.ptr, len);
	}
}


экз загрузиБиблиотекуДоп(Ткст libFileName, DWORD флаги)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias LoadLibraryExW proc;
		}
		else
		{
			const Ткст ИМЯ = "LoadLibraryExW";
			static LoadLibraryExWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(LoadLibraryExWProc)GetProcAddress(kernel32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(вЮни0(libFileName), HANDLE.init, флаги);
	}
	else
	{
		return LoadLibraryExA(небезопАнзи0(libFileName), HANDLE.init, флаги);
	}
}


BOOL _setMenuItemInfoW(HMENU hMenu, UINT uItem, BOOL fByPosition, LPMENUITEMINFOW lpmii) // package
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias SetMenuItemInfoW proc;
		}
		else
		{
			const Ткст ИМЯ = "SetMenuItemInfoW";
			static SetMenuItemInfoWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(SetMenuItemInfoWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(hMenu, uItem, fByPosition, lpmii);
	}
	else
	{
		assert(0);
		return FALSE;
	}
}


BOOL _insertMenuItemW(HMENU hMenu, UINT uItem, BOOL fByPosition, LPMENUITEMINFOW lpmii) // package
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias InsertMenuItemW proc;
		}
		else
		{
			const Ткст ИМЯ = "InsertMenuItemW";
			static InsertMenuItemWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(InsertMenuItemWProc)GetProcAddress(user32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		return proc(hMenu, uItem, fByPosition, lpmii);
	}
	else
	{
		assert(0);
		return FALSE;
	}
}


Ткст regQueryValueString(HKEY hkey, Ткст valueName, LPDWORD lpType = пусто)
{
	DWORD _type;
	if(!lpType)
		lpType = &_type;
	
	DWORD разм;
	
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias RegQueryValueExW proc;
		}
		else
		{
			const Ткст ИМЯ = "RegQueryValueExW";
			static RegQueryValueExWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(RegQueryValueExWProc)GetProcAddress(advapi32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		//разм = 0;
		auto lpValueName = вЮни0(valueName);
		proc(hkey, lpValueName, пусто, lpType, пусто, &разм);
		if(!разм || (REG_SZ != *lpType && REG_EXPAND_SZ != *lpType))
			return пусто;
		wchar[] ws = new wchar[разм];
		if(ERROR_SUCCESS != proc(hkey, lpValueName, пусто, пусто, cast(LPBYTE)ws.ptr, &разм))
			return пусто;
		//return изЮникода(ws.ptr, ws.length - 1); // Somehow ends up throwing invalid UTF-16.
		return изЮникода0(ws.ptr);
	}
	else
	{
		//разм = 0;
		auto lpValueName = вАнзи0(valueName);
		RegQueryValueExA(hkey, lpValueName, пусто, lpType, пусто, &разм);
		if(!разм || (REG_SZ != *lpType && REG_EXPAND_SZ != *lpType))
			return пусто;
		сим[] s = new сим[разм];
		if(ERROR_SUCCESS != RegQueryValueExA(hkey, lpValueName, пусто, пусто, cast(LPBYTE)s.ptr, &разм))
			return пусто;
		//return изАнзи(s.ptr, s.length - 1);
		return изАнзи0(s.ptr);
	}
}


struct ШрифтЛога
{
	union
	{
		LOGFONTW шлш;
		LOGFONTA шла;
	}
	alias шлш шл;
	
	Ткст имяФаса;
}


HFONT createFontIndirect(inout ШрифтЛога шл)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias CreateFontIndirectW proc;
		}
		else
		{
			const Ткст ИМЯ = "CreateFontIndirectW";
			static CreateFontIndirectWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(CreateFontIndirectWProc)GetProcAddress(gdi32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		Шткст ws = вЮни(шл.имяФаса);
		if(ws.length >= LF_FACESIZE)
			ws = ws[0 .. LF_FACESIZE - 1]; // ?
		foreach(idx, wch; ws)
		{
			шл.шлш.lfFaceName[idx] = wch;
		}
		шл.шлш.lfFaceName[ws.length] = 0;
		
		return proc(&шл.шлш);
	}
	else
	{
		Ткст as = вАнзи(шл.имяФаса);
		if(as.length >= LF_FACESIZE)
			as = as[0 .. LF_FACESIZE - 1]; // ?
		foreach(idx, ach; as)
		{
			шл.шла.lfFaceName[idx] = ach;
		}
		шл.шла.lfFaceName[as.length] = 0;
		
		return CreateFontIndirectA(&шл.шла);
	}
}


// GetObject for а ШрифтЛога.
цел getLogFont(HFONT hf, inout ШрифтЛога шл)
{
	if(использоватьЮникод)
	{
		version(STATIC_UNICODE)
		{
			alias GetObjectW proc;
		}
		else
		{
			const Ткст ИМЯ = "GetObjectW";
			static GetObjectWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetObjectWProc)GetProcAddress(gdi32, ИМЯ.ptr);
				if(!proc)
					дайОшПроц(ИМЯ);
			}
		}
		
		if(LOGFONTW.sizeof != proc(hf, LOGFONTW.sizeof, &шл.шлш))
			return 0;
		шл.имяФаса = изЮникода0(шл.шлш.lfFaceName.ptr);
		return LOGFONTW.sizeof;
	}
	else
	{
		if(LOGFONTA.sizeof != GetObjectA(hf, LOGFONTA.sizeof, &шл.шла))
			return 0;
		шл.имяФаса = изАнзи0(шл.шла.lfFaceName.ptr);
		return LOGFONTA.sizeof;
	}
}

