
module viz.common;
public import base, stdrus, cidrus, sys.WinStructs, sys.WinConsts, sys.com, tpl.all, tpl.stream, viz.consts, viz.iface, viz.event, viz.graphics, viz.structs, viz.collections, sys.WinFuncs, sys.WinIfaces: ПотокВвода, ПотокВывода;

version = VIZ_UNICODE;

//...............................
void gcPin(void* p) { }
void gcUnpin(void* p) { }



/*export*/ class ВизИскл: Исключение // docmain
{
/*export*/
		this(Ткст сооб)
	{
		super(сооб);
	}
}

/*export*/ class ИсклЗависанияWindows: ВизИскл
	{
	/*export*/
		this(Ткст сооб)
		{
			super(сооб);
		}
	}

template ФобосТрэтс()
	{
		static if(!is(КортежТипаПараметров!(function() { })))
		{
			// Grabbed from std.traits since Dinrus's meta.Traits lacks these:

			template КортежТипаПараметров(alias дг)
			{
				alias КортежТипаПараметров!(typeof(дг)) КортежТипаПараметров;
			}

			/** ditto */
			template КортежТипаПараметров(дг)
			{
				static if (is(дг P == function))
					alias P КортежТипаПараметров;
				else static if (is(дг P == delegate))
					alias КортежТипаПараметров!(P) КортежТипаПараметров;
				else static if (is(дг P == P*))
					alias КортежТипаПараметров!(P) КортежТипаПараметров;
				else
					static assert(0, "у аргумента отсутствуют параметры");
			}
		}
	}

	mixin ФобосТрэтс;


alias ВозврТип!(Объект.opEquals) т_равно;

/*export*/ Ткст дайТкстОбъекта(Объект o)
	{
		return o.вТкст();
	}

/*export*/ Ткст бцелВГексТкст(бцел num)
	{
		return stdrus.фм("%X", num);
	}

/*export*/ ткст0 небезопВТкст0(Ткст s)
{
	if(!s.ptr[s.length])
		return cast(ткст0)s.ptr;
	return cast(ткст0)вТкст0(s);
}

/*export*/ abstract class ЖдиУк
{
	const цел ТАЙМАУТ_ОЖИДАНИЯ = 258;
/*export*/
	this()
	{
		h = НЕВЕРНХЭНДЛ;
	}

	this(ук h, бул owned = да)
	{
		this.h = h;
		this.owned = owned;
	}

	ук указатель() // getter
	{
		return h;
	}

	проц указатель(ук h) // setter
	{
		this.h = h;
	}

	проц закрой()
	{
		ЗакройДескр(h);
		h = НЕВЕРНХЭНДЛ;
	}

	~this()
	{
		if(owned)
			закрой();
	}

	private static бцел _wait(ЖдиУк[] уки, бул ждатьВсе, бцел msTimeout)
	{
		// Some implementations fail with > 64 уки, but that will return 0xFFFFFFFF;
		// все implementations fail with >= 128 уки due to WAIT_ABANDONED_0 being 128.
		if(уки.length >= 128)
			goto fail;

		бцел результат;
		ук* hs;
		//hs = new ук[уки.length];
		hs = cast(ук*)alloca(ук.sizeof * уки.length);

		foreach(т_мера i, ЖдиУк wh; уки)
		{
			hs[i] = wh.указатель;
		}

		результат = ЖдиНесколькоОбъектов(уки.length, hs, ждатьВсе, msTimeout);
		if(0xFFFFFFFF == результат)
		{
			fail:
			throw new ВизИскл("Не дождались...");
		}
		return результат;
	}

	static проц ждиВсе(ЖдиУк[] уки)
	{
		return ждиВсе(уки, БЕСК);
	}

	static проц ждиВсе(ЖдиУк[] уки, бцел msTimeout)
	{
		_wait(уки, да, msTimeout);
	}

	static цел ждиЛюбое(ЖдиУк[] уки)
	{
		return ждиЛюбое(уки, БЕСК);
	}

	static цел ждиЛюбое(ЖдиУк[] уки, бцел msTimeout)
	{
		бцел результат;
		результат = _wait(уки, нет, msTimeout);
		return cast(цел)результат; // Same return инфо.
	}

	проц ждиОдно()
	{
		return ждиОдно(БЕСК);
	}

	проц ждиОдно(бцел msTimeout)
	{
		бцел результат;
		результат = ЖдиОдинОбъект(указатель, msTimeout);
		if(0xFFFFFFFF == результат)
			throw new ВизИскл("Не дождались...");
	}

	private:
	ук h;
	бул owned = да;
}

/*export*/ class Курсор // docmain
{
	private static Курсор _cur;

	/*export*/

	// Used internally.
	this(УКурсор hcur, бул owned = да)
	{
		this.hcur = hcur;
		this.owned = owned;
	}

	~this()
	{
		if(owned)
			вымести();
	}

	проц вымести()
	{
		assert(owned);
		DestroyCursor(cast(HCURSOR) hcur);
		hcur = УКурсор.init;
	}

	static проц текущий(Курсор cur) // setter
	{
		// Keep а reference so that it doesn't get garbage collected until установи again.
		_cur = cur;

		SetCursor(cast(HCURSOR) cur ? cur.hcur : УКурсор.init);
	}

	static Курсор текущий() // getter
	{
		УКурсор hcur =cast(УКурсор) GetCursor();
		return hcur ? new Курсор(hcur, нет) : пусто;
	}

	static проц клип(Прям к) // setter
	{
		ПРЯМ rect;
		к.дайПрям(&rect);
		ClipCursor(cast(RECT*)&rect);
	}

	static Прям клип() // getter
	{
		ПРЯМ rect;
		GetClipCursor(cast(RECT*)&rect);
		return Прям(&rect);
	}

	final УКурсор указатель() // getter
	{
		return hcur;
	}


	/+
	// TODO:
	final Размер размер() // getter
	{
		Размер результат;
		ICONINFO iinfo;

		if(GetIconInfo(hcur, &iinfo))
		{

		}

		return результат;
	}
	+/


		// Uses the actual размер.
	final проц рисуй(Графика з, Точка тчк)
	{
		DrawIconEx(з.указатель, тчк.ш, тчк.в, hcur, 0, 0, 0, HBRUSH.init, DI_NORMAL);
	}

	/+

	// Should not stretch if bigger, but should crop if smaller.
	final проц рисуй(Графика з, Прям к)
	{
	}
	+/


		final проц рисуйРастяни(Графика з, Прям к)
	{
		// DrawIconEx operates differently if the ширина or высота is zero
		// so bail out if zero and pretend the zero размер курсор was drawn.
		цел ширина = к.ширина;
		if(!ширина)
			return;
		цел высота = к.высота;
		if(!высота)
			return;

		DrawIconEx(з.указатель, к.ш, к.в, hcur, ширина, высота, 0, HBRUSH.init, DI_NORMAL);
	}


	override т_рав opEquals(Объект o)
	{
		Курсор cur = cast(Курсор)o;
		if(!cur)
			return 0; // Not equal.
		return opEquals(cur);
	}


	т_рав opEquals(Курсор cur)
	{
		return hcur == cur.hcur;
	}


	/// покажи/скрой the текущий mouse курсор; reference counted.
	// покажи/скрой are ref counted.
	static проц скрой()
	{
		ShowCursor(нет);
	}


	// покажи/скрой are ref counted.
	static проц покажи()
	{
		ShowCursor(да);
	}


	/// The положение of the текущий mouse курсор.
	static проц положение(Точка тчк) // setter
	{
		SetCursorPos(тчк.ш, тчк.в);
	}


	static Точка положение() // getter
	{
		Точка тчк;
		GetCursorPos(cast(POINT*)&тчк.точка);
		return тчк;
	}


	private:
	УКурсор hcur;
	бул owned = да;
}


/*export*/   class Курсоры // docmain
{

	/*export*/
	this() {}

		Курсор пускПриложения() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_APPSTARTING), нет); }

		Курсор стрелка() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_ARROW), нет); }

		Курсор крест() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_CROSS), нет); }

		//Курсор default() // getter
	Курсор дефолтныйКурсор() // getter
	{ return стрелка; }

	Курсор рука() // getter
	{
		version(SUPPORTS_HAND_CURSOR) // Windows 98+
		{
			return new Курсор(LoadCursorA(экз.init, IDC_HAND), нет);
		}
		else
		{
			static УКурсор hcurHand;

			if(!hcurHand)
			{
				hcurHand = LoadCursorA(экз.init, IDC_HAND);
				if(!hcurHand) // Must be Windows 95, so загрузка the курсор from winhlp32.exe.
				{
					UINT len;
					сим[МАКС_ПУТЬ] winhlppath = void;

					len = GetWindowsDirectoryA(winhlppath.ptr, winhlppath.length - 16);
					if(!len || len > winhlppath.length - 16)
					{
						load_failed:
						return стрелка; // Just fall back to а normal стрелка.
					}
					strcpy(winhlppath.ptr + len, "\\winhlp32.exe");

					экз hinstWinhlp;
					hinstWinhlp = LoadLibraryExA(winhlppath.ptr, ук.init, LOAD_LIBRARY_AS_DATAFILE);
					if(!hinstWinhlp)
						goto load_failed;

					УКурсор hcur;
					hcur = LoadCursorA(cast(HINSTANCE) hinstWinhlp, cast(ткст0)106);
					if(!hcur) // No such курсор resource.
					{
						FreeLibrary(cast(HINSTANCE) hinstWinhlp);
						goto load_failed;
					}
					hcurHand = CopyCursor(hcur);
					if(!hcurHand)
					{
						FreeLibrary(cast(HINSTANCE) hinstWinhlp);
						//throw new ВизИскл("Unable to копируй курсор resource");
						goto load_failed;
					}

					FreeLibrary(cast(HINSTANCE) hinstWinhlp);
				}
			}

			assert(hcurHand);
			// Copy the курсор and own it here so that it's safe to вымести it.
			return new Курсор(CopyCursor(hcurHand));
		}
	}

	Курсор помощь() // getter
	{
		УКурсор hcur;
		hcur = LoadCursorA(экз.init, IDC_HELP);
		if(!hcur) // IDC_HELP might not be supported on Windows 95, so fall back to а normal стрелка.
			return стрелка;
		return new Курсор(hcur);
	}

	Курсор гСплит() // getter
	{
		// ...
		return sizeNS;
	}

	Курсор вСплит() // getter
	{
		// ...
		return sizeWE;
	}

	Курсор айБим() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_IBEAM), нет); }

	Курсор к_нет() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_NO), нет); }


	Курсор sizeAll() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZEALL), нет); }


	Курсор sizeNESW() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZENESW), нет); }


	Курсор sizeNS() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZENS), нет); }


	Курсор sizeNWSE() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZENWSE), нет); }


	Курсор sizeWE() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZEWE), нет); }


	/+
		// Insertion Точка.
	Курсор upArrow() // getter
	{
		// ...
	}
	+/

		Курсор ждиКурсор() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_WAIT), нет); }
}

//.................................
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


/*export*/

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

	len = MultiByteToWideChar(0, 0, ansi, len, ws.ptr, len);
	//assert(len == ws.length);
	ws = ws[0 .. len - 1]; // Exclude пусто сим at end.

	//return ws;
	return cast(Шткст)ws; // Needed in D2.
}


Ткст изАнзи(Ткст0 ansi, т_мера len)
{
	return вЮ8(анзиВЮникод(ansi, len));
}

Ткст изАнзи0(Ткст0 ansiz)
{
	if(!ansiz)
		return пусто;

	//return изАнзи(ansiz, _getlen!(сим)(ansiz));
	return изАнзи(ansiz, _getlen(ansiz));
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


Ткст изЮникода0(Шткст0 unicodez)
{
	if(!unicodez)
		return пусто;

	//return изЮникода(unicodez, _getlen!(wchar)(unicodez));
	return изЮникода(unicodez, _getlen(unicodez));
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
	alias HWND function(DWORD dwExStyle, LPCWSTR lpClassName, LPCWSTR lpWindowName, DWORD dwStyle,
		цел ш, цел в, цел nWidth, цел nHeight, HWND hWndParent, HMENU hMenu, экз hInstance,
		LPVOID lpParam) CreateWindowExWProc;
	alias цел function(HWND уок) GetWindowTextLengthWProc;
	alias цел function(HWND уок, LPCWSTR lpString, цел nMaxCount) GetWindowTextWProc;
	alias BOOL function(HWND уок, LPCWSTR lpString) SetWindowTextWProc;
	alias LRESULT function(HWND уок, UINT Msg, WPARAM парам1, LPARAM парам2) SendMessageWProc;
	alias LRESULT function(WNDPROC lpPrevWndFunc, HWND уок, UINT Msg, WPARAM парам1, LPARAM парам2)
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
	alias BOOL function(LPMSG lpMsg, HWND уок, UINT wMsgFilterMin, UINT wMsgFilterMax, UINT wRemoveMsg)
		PeekMessageWProc;
	alias BOOL function(HWND hDlg, LPMSG lpMsg) IsDialogMessageWProc;
	alias LRESULT function(HWND уок, UINT Msg, WPARAM парам1, LPARAM парам2) DefWindowProcWProc;
	alias LRESULT function(HWND hDlg, UINT Msg, WPARAM парам1, LPARAM парам2) DefDlgProcWProc;
	alias LRESULT function(HWND уок, HWND hWndMDIClient, UINT uMsg, WPARAM парам1, LPARAM парам2) DefFrameProcWProc;
	alias LRESULT function(HWND уок, UINT uMsg, WPARAM парам1, LPARAM парам2) DefMDIChildProcWProc;
	alias BOOL function(экз hInstance, LPCWSTR lpClassName, LPWNDCLASSW lpWndClass) GetClassInfoWProc;
	alias HANDLE function(LPCWSTR lpPathName, BOOL bWatchSubtree, DWORD dwNotifyFilter) FindFirstChangeNotificationWProc;
	alias DWORD function(LPCWSTR lpFileName, DWORD nBufferLength, LPWSTR lpBuffer, LPWSTR *lpFilePart) GetFullPathNameWProc;
	alias typeof(&LoadLibraryExW) LoadLibraryExWProc;
	alias typeof(&SetMenuItemInfoW) SetMenuItemInfoWProc;
	alias typeof(&InsertMenuItemW) InsertMenuItemWProc;
	alias typeof(&CreateFontIndirectW) CreateFontIndirectWProc;
	alias typeof(&GetObjectW) GetObjectWProc;
}

const бул использоватьЮникод = да;

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
	throw new Искл("Не удаётся загрузить процедуру " ~ procName ~ errdesc);
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
		return cast(УОК) proc(dwExStyle, вЮни0(имяКласса), вЮни0(windowName), dwStyle,
			ш, в, nWidth, nHeight, hWndParent, hMenu, hInstance, lpParam);
	}
	else
	{
		return cast(УОК) CreateWindowExA(dwExStyle, небезопАнзи0(имяКласса), небезопАнзи0(windowName), dwStyle,
			ш, в, nWidth, nHeight, hWndParent, hMenu, cast(HINSTANCE) hInstance, lpParam);
	}
}


УОК создайОкно(Ткст имяКласса, Ткст windowName, DWORD dwStyle, цел ш, цел в,
	цел nWidth, цел nHeight, УОК hWndParent, HMENU hMenu, HANDLE hInstance, LPVOID lpParam)
{
	return cast(УОК) создайОкноДоп(0, имяКласса, windowName, dwStyle, ш, в,
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

		len = proclen(cast(HWND) уок);
		if(!len)
			return пусто;
		len++;
		buf = (new wchar[len]).ptr;

		len = proc(cast(HWND) уок, buf, len);
		return изЮникода(buf, len);
	}
	else
	{
		ткст0 buf;
		т_мера len;

		len = GetWindowTextLengthA(cast(HWND) уок);
		if(!len)
			return пусто;
		len++;
		buf = (new сим[len]).ptr;

		len = GetWindowTextA(cast(HWND) уок, buf, len);
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

		return proc(cast(HWND) уок, вЮни0(str));
	}
	else
	{
		return SetWindowTextA(cast(HWND) уок, небезопАнзи0(str));
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
		len = proc(cast(HWND) уок, EM_GETSELTEXT, 0, cast(LPARAM)buf.ptr);
		return изЮникода(buf.ptr, len);
	}
	else
	{
		сим[] buf;
		т_мера len;
		buf = new сим[selTextLength + 1];
		len = SendMessageA(cast(HWND) уок, EM_GETSELTEXT, 0, cast(LPARAM)buf.ptr);
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

		proc(cast(HWND) уок, EM_GETSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
		if(v1 == v2)
			return пусто;
		assert(v2 > v1);

		len = proc(cast(HWND) уок, WM_GETTEXTLENGTH, 0, 0);
		if(len)
		{
			len++;
			шткст0 buf;
			buf = (new wchar[len]).ptr;

			len = proc(cast(HWND) уок, WM_GETTEXT, len, cast(LPARAM)buf);
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
		SendMessageA(cast(HWND) уок, EM_GETSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
		if(v1 == v2)
			return пусто;
		assert(v2 > v1);

		len = SendMessageA(cast(HWND) уок, WM_GETTEXTLENGTH, 0, 0);
		if(len)
		{
			len++;
			ткст0 buf;
			buf = (new сим[len]).ptr;

			len = SendMessageA(cast(HWND) уок, WM_GETTEXT, len, cast(LPARAM)buf);
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

		proc(cast(HWND) уок, EM_SETPASSWORDCHAR, pwc, 0); // ?
	}
	else
	{
		Ткст chs;
		Ткст ansichs;
		chs = вЮ8((&pwc)[0 .. 1]);
		ansichs = небезопАнзи(chs);

		if(ansichs)
			SendMessageA(cast(HWND) уок, EM_SETPASSWORDCHAR, ansichs[0], 0); // ?
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

		return cast(дим)proc(cast(HWND) уок, EM_GETPASSWORDCHAR, 0, 0); // ?
	}
	else
	{
		сим ansich;
		Ткст chs;
		Дткст dchs;
		ansich = cast(сим)SendMessageA(cast(HWND) уок, EM_GETPASSWORDCHAR, 0, 0);
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

		return proc(cast(HWND) уок, сооб, wparam, lparam);
	}
	else
	{
		return SendMessageA(cast(HWND) уок, сооб, wparam, lparam);
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

		return proc(cast(HWND) уок, сооб, wparam, cast(LPARAM)вЮни0(lparam));
	}
	else
	{
		return SendMessageA(cast(HWND) уок, сооб, wparam, cast(LPARAM)вАнзи0(lparam, safe)); // Can't assume небезопАнзи0() is ОК here.
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

		return proc(lpPrevWndFunc, cast(HWND) уок, сооб, wparam, lparam);
	}
	else
	{
		return CallWindowProcA(lpPrevWndFunc, cast(HWND) уок, сооб, wparam, lparam);
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

		return proc(cast(HWND) уок, сооб, wparam, lparam);
	}
	else
	{
		return DefWindowProcA(cast(HWND)  уок, сооб, wparam, lparam);
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

		return proc(cast(HWND) уок, сооб, wparam, lparam);
	}
	else
	{
		return DefDlgProcA(cast(HWND) уок, сооб, wparam, lparam);
	}
}


LRESULT дефФреймПроц(УОК уок, УОК уокMdiClient, UINT сооб, WPARAM wparam, LPARAM lparam)
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

		return proc(cast(HWND) уок, уокMdiClient, сооб, wparam, lparam);
	}
	else
	{
		return DefFrameProcA(cast(HWND) уок, уокMdiClient, сооб, wparam, lparam);
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

		return proc(cast(HWND) уок, сооб, wparam, lparam);
	}
	else
	{
		return DefMDIChildProcA(cast(HWND) уок, сооб, wparam, lparam);
	}
}


version = STATIC_UNICODE_PEEK_MESSAGE;
version = STATIC_UNICODE_DISPATCH_MESSAGE;


LONG dispatchMessage(СООБ* pmsg)
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

		return dispatchproc(cast(MSG*) pmsg);
	}
	else
	{
		return DispatchMessageA(cast(MSG*)pmsg);
	}
}


BOOL peekMessage(СООБ* pmsg, УОК уок = HWND.init, UINT wmFilterMin = 0, UINT wmFilterMax = 0, UINT removeMsg = PM_NOREMOVE)
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
		if(!peekproc(cast(MSG*) pmsg, cast(HWND) уок, wmFilterMin, wmFilterMax, PM_NOREMOVE)) // Don't удали to test if юникод.
			return 0;
		if(!IsWindowUnicode(cast(MSG*)pmsg.окноПолучатель)) // Window is not юникод.
		{
			return PeekMessageA(cast(MSG*) pmsg, cast(HWND) уок, wmFilterMin, wmFilterMax, removeMsg);
		}
		else // Window is юникод.
		{
			if(removeMsg == PM_NOREMOVE)
				return 1; // No need to do extra work here.
			return peekproc(cast(MSG*) pmsg, cast(HWND) уок, wmFilterMin, wmFilterMax, removeMsg);
		}
	}
	else
	{
		return PeekMessageA(cast(MSG*) pmsg, cast(HWND) уок, wmFilterMin, wmFilterMax, removeMsg);
	}
}


BOOL getMessage(СООБ* pmsg, УОК уок = HWND.init, UINT wmFilterMin = 0, UINT wmFilterMax = 0)
{
	if(!WaitMessage())
		return -1;
	if(!peekMessage(pmsg, cast(HWND) уок, wmFilterMin, wmFilterMax, PM_REMOVE))
		return -1;
	if(WM_QUIT == pmsg.сообщение)
		return 0;
	return 1;
}


BOOL isDialogMessage(УОК уок, СООБ* pmsg)
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

		return proc(cast(HWND) уок, cast(MSG*)pmsg);
	}
	else
	{
		return IsDialogMessageA(cast(HWND) уок, cast(MSG*) pmsg);
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



// Importing viz.application here causes the compiler to crash.
//import viz.application;
private extern(C)
{
	т_мера C_refCountInc(ук p);
	т_мера C_refCountDec(ук p);
}


// Won't be killed by GC if not referenced in D and the refcount is > 0.
/*export*/ class ВизКомОбъект: КомОбъект // package
{
	extern(Windows):


	ULONG AddRef()
	{
		//скажиф("AddRef `%.*s`\n", cast(цел)вТкст().length, вТкст().ptr);
		return C_refCountInc(cast(проц*)this);
	}

	ULONG Release()
	{
		//скажиф("Release `%.*s`\n", cast(цел)вТкст().length, вТкст().ptr);
		return C_refCountDec(cast(проц*)this);
	}
}

/*export*/ class ПотокВИПоток: ВизКомОбъект, winapi.IStream
{
/*export*/
	this(Поток sourceStream)
	{
		this.stm = sourceStream;
	}


	extern(Windows):

	override HRESULT QueryInterface(IID* riid, проц** ppv)
	{
		if(*riid == cast(IID) IID_IStream)
		{
			*ppv = cast(проц*)cast(winapi.IStream)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == cast(IID) IID_ISequentialStream)
		{
			*ppv = cast(проц*)cast(winapi.ISequentialStream)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == cast(IID) IID_IUnknown)
		{
			*ppv = cast(проц*)cast(winapi.IUnknown)this;
			AddRef();
			return S_OK;
		}
		else
		{
			*ppv = пусто;
			return E_NOINTERFACE;
		}
	}


	HRESULT Read(ук pv, ULONG cb, ULONG* pcbRead)
	{
		ULONG read;
		HRESULT результат = S_OK;

		try
		{
				read = stm.читайБлок(pv, cb);

		}
		catch(Искл e)
		{
			результат = S_FALSE; // ?
		}

		if(pcbRead)
			*pcbRead = read;
		//if(!read)
		//	результат = S_FALSE;
		return результат;
	}


	HRESULT Write(ук pv, ULONG cb, ULONG* pcbWritten)
	{
		ULONG written;
		HRESULT результат = S_OK;

		try
		{

		if(!stm.записываемый())
		return E_NOTIMPL;
		written = stm.пишиБлок(pv, cb);

		}
		catch(Искл e)
		{
			результат = S_FALSE; // ?
		}

		if(pcbWritten)
			*pcbWritten = written;
		//if(!written)
		//	результат = S_FALSE;
		return результат;
	}


	version(VIZ_TANGO_NO_SEEK_COMPAT)
	{
	}
	else
	{
		long _fakepos = 0;
	}


	HRESULT Seek(LARGE_INTEGER dlibMove, DWORD dwOrigin, ULARGE_INTEGER* plibNewPosition)
	{
		HRESULT результат = S_OK;

		//скажиф("seek перемещение=%u, origin=0x%ш\n", cast(бцел)dlibMove.QuadPart, dwOrigin);

		try
		{

				if(!stm.сканируемый())
					//return S_FALSE; // ?
					return E_NOTIMPL; // ?

				ulong поз;
				switch(dwOrigin)
				{
					case STREAM_SEEK_SET:
						поз = stm.измпозУст(dlibMove.QuadPart);
						if(plibNewPosition)
							plibNewPosition.QuadPart = поз;
						break;

					case STREAM_SEEK_CUR:
						поз = stm.измпозТек(dlibMove.QuadPart);
						if(plibNewPosition)
							plibNewPosition.QuadPart = поз;
						break;

					case STREAM_SEEK_END:
						поз = stm.измпозКон(dlibMove.QuadPart);
						if(plibNewPosition)
							plibNewPosition.QuadPart = поз;
						break;

					default:
						результат = STG_E_INVALIDFUNCTION;
				}
		}
		catch(Искл e)
		{
			результат = S_FALSE; // ?
		}

		return результат;
	}


	HRESULT SetSize(ULARGE_INTEGER libNewSize)
	{
		return E_NOTIMPL;
	}


	HRESULT CopyTo(winapi.IStream pstm, ULARGE_INTEGER cb, ULARGE_INTEGER* pcbRead, ULARGE_INTEGER* pcbWritten)
	{
		// TODO: implement.
		return E_NOTIMPL;
	}


	HRESULT Commit(DWORD grfCommitFlags)
	{
		// Ignore -grfCommitFlags- and just слей the stream..
		//stm.слей();
		version(Dinrus)
		{
			auto outstm = cast(ПотокВывода)stm;
			if(!outstm)
				return E_NOTIMPL;
			outstm.слей();
		}
		else
		{
			stm.слей();
		}
		return S_OK; // ?
	}


	HRESULT Revert()
	{
		return E_NOTIMPL; // ? S_FALSE ?
	}


	HRESULT LockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType)
	{
		return E_NOTIMPL;
	}


	HRESULT UnlockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType)
	{
		return E_NOTIMPL;
	}


	HRESULT Stat(STATSTG* pstatstg, DWORD grfStatFlag)
	{
		return E_NOTIMPL; // ?
	}


	HRESULT Clone(winapi.IStream* ppstm)
	{
		// Cloned stream needs its own seek положение.
		return E_NOTIMPL; // ?
	}



	private:
	Поток stm;
}


/*export*/ class ИПотокПамяти: ВизКомОбъект, winapi.IStream
{
/*export*/
	this(проц[] memory)
	{
		this.mem = memory;
	}

	бул впределах(long поз)
	{
		if(поз < seekpos.min || поз > seekpos.max)
			return нет;
		// Note: it IS within границы if it's AT the end, it just can't read there.
		return cast(т_мера)поз <= mem.length;
	}


	extern(Windows):

	override HRESULT QueryInterface(IID* riid, проц** ppv)
	{
		if(*riid == cast(IID) IID_IStream)
		{
			*ppv = cast(проц*)cast(winapi.IStream)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == cast(IID) IID_ISequentialStream)
		{
			*ppv = cast(проц*)cast(winapi.ISequentialStream)this;
			AddRef();
			return S_OK;
		}
		else if(*riid == cast(IID) IID_IUnknown)
		{
			*ppv = cast(проц*)cast(winapi.IUnknown)this;
			AddRef();
			return S_OK;
		}
		else
		{
			*ppv = пусто;
			return E_NOINTERFACE;
		}
	}


	HRESULT Read(ук pv, ULONG cb, ULONG* pcbRead)
	{
		// Shouldn't happen unless the mem changes, which doesn't happen yet.
		if(seekpos > mem.length)
			return S_FALSE; // ?

		т_мера count = mem.length - seekpos;
		if(count > cb)
			count = cb;

		pv[0 .. count] = mem[seekpos .. seekpos + count];
		seekpos += count;

		if(pcbRead)
			*pcbRead = count;
		return S_OK;
	}


	HRESULT Write(ук pv, ULONG cb, ULONG* pcbWritten)
	{
		//return STG_E_ACCESSDENIED;
		return E_NOTIMPL;
	}


	HRESULT Seek(LARGE_INTEGER dlibMove, DWORD dwOrigin, ULARGE_INTEGER* plibNewPosition)
	{
		//скажиф("seek перемещение=%u, origin=0x%ш\n", cast(бцел)dlibMove.QuadPart, dwOrigin);

		auto toPos = cast(long)dlibMove.QuadPart;
		switch(dwOrigin)
		{
			case STREAM_SEEK_SET:
				break;

			case STREAM_SEEK_CUR:
				toPos = cast(long)seekpos + toPos;
				break;

			case STREAM_SEEK_END:
				toPos = cast(long)mem.length - toPos;
				break;

			default:
				return STG_E_INVALIDFUNCTION;
		}

		if(впределах(toPos))
		{
			seekpos = cast(т_мера)toPos;
			if(plibNewPosition)
				plibNewPosition.QuadPart = seekpos;
			return S_OK;
		}
		else
		{
			return 0x80030005; //STG_E_ACCESSDENIED; // Seeking past end needs write access.
		}
	}


	HRESULT SetSize(ULARGE_INTEGER libNewSize)
	{
		return E_NOTIMPL;
	}


	HRESULT CopyTo(winapi.IStream pstm, ULARGE_INTEGER cb, ULARGE_INTEGER* pcbRead, ULARGE_INTEGER* pcbWritten)
	{
		// TODO: implement.
		return E_NOTIMPL;
	}


	HRESULT Commit(DWORD grfCommitFlags)
	{
		return S_OK; // ?
	}


	HRESULT Revert()
	{
		return E_NOTIMPL; // ? S_FALSE ?
	}


	HRESULT LockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType)
	{
		return E_NOTIMPL;
	}


	HRESULT UnlockRegion(ULARGE_INTEGER libOffset, ULARGE_INTEGER cb, DWORD dwLockType)
	{
		return E_NOTIMPL;
	}


	HRESULT Stat(STATSTG* pstatstg, DWORD grfStatFlag)
	{
		return E_NOTIMPL; // ?
	}


	HRESULT Clone(winapi.IStream* ppstm)
	{
		// Cloned stream needs its own seek положение.
		return E_NOTIMPL; // ?
	}


	private:
	проц[] mem;
	т_мера seekpos = 0;

}

extern(Windows):

    struct POINTL
	{
		LONG x;
		LONG y;
	}

    struct CLIENTCREATESTRUCT
	{
		HANDLE hWindowMenu;
		UINT idFirstChild;
	}
	alias CLIENTCREATESTRUCT* LPCLIENTCREATESTRUCT;

struct FORMATETC
{
	CLIPFORMAT cfFormat;
	DVTARGETDEVICE* ptd;
	DWORD dwAspect;
	LONG lindex;
	DWORD tymed;
}
alias FORMATETC* LPFORMATETC;

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
		IStream pstm;
		//IStorage pstg;
	}
	IUnknown pUnkForRelease;
}
alias STGMEDIUM* LPSTGMEDIUM;

alias UINT OLE_HANDLE;

alias LONG OLE_XPOS_HIMETRIC;

alias LONG OLE_YPOS_HIMETRIC;

alias LONG OLE_XSIZE_HIMETRIC;

alias LONG OLE_YSIZE_HIMETRIC;

	struct DRAWTEXTPARAMS
	{
		UINT cbSize;
		цел iTabLength;
		цел iLeftMargin;
		цел iRightMargin;
		UINT uiLengthDrawn;
	}
	alias DRAWTEXTPARAMS* LPDRAWTEXTPARAMS;




