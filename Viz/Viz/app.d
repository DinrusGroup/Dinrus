//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.app;

private import stdrus, win;
import cidrus: НЕУДАЧНЫЙ_ВЫХОД, realloc, free;
import winapi;

private import viz.common, viz.form, viz.event;
private import viz.control, viz.label;
private import viz.button, viz.textbox, viz.environment;
private import viz.resources, viz.menu;

//version = ВИЗ_БЕЗ_ЗОМБИ_ФОРМ;

//debug = APP_PRINT;
//debug = SHOW_MESSAGE_INFO; // Slow.

debug(APP_PRINT)
{
	pragma(msg, "viz: debug app print");

	version(VIZ_LIB)
		static assert(0);
}


private extern(C) проц abort();


/*export*/  class КонтекстПриложения // docmain
{
/*export*/
		this()
	{
	}

	// If onMainFormClose isn't overridden, the сообщение
	// loop terminates when the main form is destroyed.
	this(Форма главФорма)
	{
		mform = главФорма;
		главФорма.закрыто ~= &приЗакрытииГлавФормы;
	}

	//final проц главФорма(Форма глФорм){главФорма(cast(Форма) глФорм);}
	final проц главФорма(Форма главФорма) // setter
	{
		if(mform)
			mform.закрыто.удалиОбработчик(&приЗакрытииГлавФормы);

		mform = главФорма;

		if(главФорма)
			главФорма.закрыто ~= &приЗакрытииГлавФормы;
	}

	//final проц главФорма(){главФорма();}
	final Форма главФорма() // getter
	{
		return mform;
	}


		Событие!(Объект, АргиСоб) выходИзНити;


		//проц выйтиИзНити(){выйдиИзНити();}
	final проц выйдиИзНити()
	{
		выйдиИзЯдраНити();
	}


	проц выйдиИзЯдраНити()
	{
		выходИзНити(this, АргиСоб.пуст);
		//ExitThread(0);
	}


	проц приЗакрытииГлавФормы(Объект отправитель, АргиСоб арги)
	{
		выйдиИзЯдраНити();
	}


	private:
	Форма mform; // The контекст form.
}


private extern(Windows)
{

	struct ACTCTXW
	{
		ULONG cbSize;
		DWORD dwFlags;
		LPCWSTR lpSource;
		USHORT wProcessorArchitecture;
		LANGID wLangId;
		LPCWSTR lpAssemblyDirectory;
		LPCWSTR lpResourceName;
		LPCWSTR lpApplicationName;
		HMODULE hModule;
	}
	alias ACTCTXW* PACTCTXW;
	alias ACTCTXW* LPACTCTXW;

	alias UINT function(LPCWSTR lpPathName, LPCWSTR lpPrefixString, UINT uUnique,
		LPWSTR lpTempFileName) GetTempFileNameWProc;
	alias DWORD function(DWORD nBufferLength, LPWSTR lpBuffer) GetTempPathWProc;
	alias HANDLE function(PACTCTXW pActCtx) CreateActCtxWProc;
	alias BOOL function(HANDLE hActCtx, ULONG_PTR* lpCookie) ActivateActCtxProc;
}


version(NO_WINDOWS_HUNG_WORKAROUND)
{
}
else
{
	version = WINDOWS_HUNG_WORKAROUND;
}


// Compatibility with previous DFL versions.
// Set version=VIZ_NO_COMPAT to отключи.
enum DflCompat
{
	НЕУК = 0,

	// Adding to menus is the old way.
	MENU_092 = 0x1,

	// Controls don't recreate automatically when necessary.
	КОНТРОЛ_RECREATE_095 = 0x2,

	// Nothing.
	КОНТРОЛ_KEYEVENT_096 = 0x4,

	// When а Форма is in покажиДиалог, changing the резДиалога from НЕУК doesn't закрой the form.
	FORM_DIALOGRESULT_096 = 0x8,

	// Call приЗагрузке/загрузка and фокус а упрэлт at old time.
	FORM_LOAD_096 = 0x10,

	// Parent упрэлты now need to be container-упрэлты; this removes that limit.
	КОНТРОЛ_PARENT_096 = 0x20,
}

/*export*/ extern (D) class Приложение // docmain
{


	private this() {}



	static:
		Событие!(Объект, АргиСоб) вБездействии; // Finished processing and is now вБездействии.
		Событие!(Объект, АргиСобИсклНити) исклНити;
		Событие!(Объект, АргиСоб) выходИзНити;

	/*export*/
		// Should be called before creating any упрэлты.
	// This is typically the first function called in main().
	// Does nothing if not supported.
	//проц вклВизСтили(){вклВизСтили();}
	проц вклВизСтили()
	{
		const Ткст MANIFEST = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>` "\r\n"
									`<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">` "\r\n"
									  `<assemblyIdentity` "\r\n"
										  `version="1.0.0.0"` "\r\n"
										  `processorArchitecture="X86"` "\r\n"
										  `name="client"` "\r\n"
										  `type="win32"` "\r\n"
									  `/>` "\r\n"
									  `<description></description>` "\r\n"
									 "\r\n"
									  `<!-- Enable Windows XP and higher themes with common controls -->` "\r\n"
									  `<dependency>` "\r\n"
										`<dependentAssembly>` "\r\n"
										  `<assemblyIdentity` "\r\n"
											`type="win32"` "\r\n"
											`name="Microsoft.Windows.Common-Controls"` "\r\n"
											`version="6.0.0.0"` "\r\n"
											`processorArchitecture="X86"` "\r\n"
											`publicKeyToken="6595b64144ccf1df"` "\r\n"
											`language="*"` "\r\n"
										  `/>` "\r\n"
										`</dependentAssembly>` "\r\n"
									  `</dependency>` "\r\n"
									  "\r\n"
									  `<!-- Disable Windows Vista UAC compatibility heuristics -->` "\r\n"
									  `<trustInfo xmlns="urn:schemas-microsoft-com:asm.v2">` "\r\n"
										`<security>` "\r\n"
										  `<requestedPrivileges>` "\r\n"
											`<requestedExecutionLevel level="asInvoker"/>` "\r\n"
										  `</requestedPrivileges>` "\r\n"
										`</security>` "\r\n"
									  `</trustInfo> ` "\r\n"
									  "\r\n"
									  `<!-- Enable Windows Vista-style font scaling on Vista -->` "\r\n"
									  `<asmv3:application xmlns:asmv3="urn:schemas-microsoft-com:asm.v3">` "\r\n"
										`<asmv3:windowsSettings xmlns="http://schemas.microsoft.com/SMI/2005/WindowsSettings">` "\r\n"
										  `<dpiAware>да</dpiAware>` "\r\n"
										`</asmv3:windowsSettings>` "\r\n"
									  `</asmv3:application>` "\r\n"
									`</assembly>` "\r\n";

		HMODULE kernel32;
		kernel32 = GetModuleHandleA("kernel32.dll");
		//if(kernel32)
		assert(kernel32);
		{
			CreateActCtxWProc createActCtxW;
			createActCtxW = cast(CreateActCtxWProc)GetProcAddress(kernel32, "CreateActCtxW");
			if(createActCtxW)
			{
				GetTempPathWProc getTempPathW;
				GetTempFileNameWProc getTempFileNameW;
				ActivateActCtxProc activateActCtx;

				getTempPathW = cast(GetTempPathWProc)GetProcAddress(kernel32, "GetTempPathW");
				assert(getTempPathW !is пусто);
				getTempFileNameW = cast(GetTempFileNameWProc)GetProcAddress(kernel32, "GetTempFileNameW");
				assert(getTempFileNameW !is пусто);
				activateActCtx = cast(ActivateActCtxProc)GetProcAddress(kernel32, "ActivateActCtx");
				assert(activateActCtx !is пусто);

				DWORD pathlen;
				wchar[MAX_PATH] pathbuf = void;
				//if(pathbuf)
				{
					pathlen = getTempPathW(pathbuf.length, pathbuf.ptr);
					if(pathlen)
					{
						DWORD manifestlen;
						wchar[MAX_PATH] manifestbuf = void;
						//if(manifestbuf)
						{
							manifestlen = getTempFileNameW(pathbuf.ptr, "dmf", 0, manifestbuf.ptr);
							if(manifestlen)
							{
								HANDLE hf;
								hf = CreateFileW(manifestbuf.ptr, GENERIC_WRITE, 0, пусто, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL | FILE_FLAG_SEQUENTIAL_SCAN, HANDLE.init);
								if(hf != INVALID_HANDLE_VALUE)
								{
									DWORD written;
									if(WriteFile(hf, MANIFEST.ptr, MANIFEST.length, &written, пусто))
									{
										ЗакройДескр(hf);

										ACTCTXW ac;
										HANDLE hac;

										ac.cbSize = ACTCTXW.sizeof;
										//ac.dwFlags = 4; // ACTCTX_FLAG_ASSEMBLY_DIRECTORY_VALID
										ac.dwFlags = 0;
										ac.lpSource = manifestbuf.ptr;
										//ac.lpAssemblyDirectory = pathbuf; // ?

										hac = createActCtxW(&ac);
										if(hac != INVALID_HANDLE_VALUE)
										{
											ULONG_PTR ul;
											activateActCtx(hac, &ul);

											_initCommonControls(ICC_STANDARD_CLASSES); // Yes.
											//InitCommonControls(); // No. Doesn't work with common упрэлты version 6!

											// Ensure the actctx is actually associated with the сообщение queue...
											PostMessageA(пусто, wmViz, 0, 0);
											{
												MSG сооб;
												PeekMessageA(&сооб, пусто, cast(UINT) wmViz, cast(UINT) wmViz, cast(UINT) PM_REMOVE);
											}
										}
										else
										{
											debug(APP_PRINT)
												скажиф("CreateActCtxW не сработал.\n");
										}
									}
									else
									{
										ЗакройДескр(hf);
									}
								}

								DeleteFileW(manifestbuf.ptr);
							}
						}
					}
				}
			}
		}
	}


	/+
	// 	бул visualStyles() // getter
	{
		// IsAppThemed:
		// "Do not call this function during DllMain or global objects contructors.
		// This may cause invalid return значения in Microsoft Windows Vista and may cause Windows XP to become unstable."
	}
	+/


	/// Path of the executable including its file имя.
	//Ткст путьКПроге(){return путьКПрог();}
	Ткст путьКПрог() // getter
	{
		return дайИмяФайлаМодуля(HMODULE.init);
	}


	/// Directory containing the executable.
	//Ткст папкаСтарта(){return папкаСтарта();}
	Ткст папкаСтарта() // getter
	{
		return извлекиПапку(дайИмяФайлаМодуля(HMODULE.init));
	}


	// Used internally.
	Ткст дайОсобыйПуть(Ткст имя) // package
	{
		HKEY hk;
		if(ERROR_SUCCESS != RegOpenKeyA(HKEY_CURRENT_USER,
			r"Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders".ptr, &hk))
		{
			bad_path:
			throw new ВизИскл("Не удаётся получить информацию о папке " ~ имя);
		}
		scope(exit)
			RegCloseKey(hk);
		Ткст результат;
		результат = regQueryValueString(hk, имя);
		if(!результат.length)
			goto bad_path;
		return результат;
	}


	/// Приложение данные base directory path, usually `C:\Documents and Settings\<user>\Приложение Данные`; this directory might not exist yet.
	Ткст путьКАппДата() // getter
	{
		return дайОсобыйПуть("AppData");
	}


	бул циклСооб() // getter
	{
		return (флагиНити & ФН.ПУЩЕНО) != 0;
	}


	проц добавьФильтрСооб(ИФильтрСооб mf)
	{
		//фильтры ~= mf;

		ИФильтрСооб[] fs = фильтры;
		fs ~= mf;
		фильтры = fs;
	}


	проц удалиФильтрСооб(ИФильтрСооб mf)
	{
		бцел i;
		for(i = 0; i != фильтры.length; i++)
		{
			if(mf is фильтры[i])
			{
				if(!i)
					фильтры = фильтры[1 .. фильтры.length];
				else if(i == фильтры.length - 1)
					фильтры = фильтры[0 .. i];
				else
					фильтры = фильтры[0 .. i] ~ фильтры[i + 1 .. фильтры.length];
				break;
			}
		}
	}


	package бул _doEvents(бул* keep)
	{
		if(флагиНити & (ФН.СТОП_ПУЩЕНОЕ | ФН.ВЫХОД))
			return нет;

		try
		{
			Сообщение сооб;

			//while(PeekMessageA(&сооб._винСооб, HWND.init, 0, 0, PM_REMOVE))
			while(peekMessage(&сооб._винСооб, HWND.init, 0, 0, PM_REMOVE))
			{
				полученоСообщение(сооб);

				if(сооб.сооб == WM_QUIT)
				{
					флагиНити = флагиНити | ФН.ВЫХОД;
					return нет;
				}
				if(флагиНити & ФН.СТОП_ПУЩЕНОЕ)
				{
					return нет;
				}
				if(!*keep)
				{
					break;
				}
			}

			// Execution continues after this so it's not вБездействии.
		}
		catch(Объект e)
		{
			приИсклНити(e);
		}

		return (флагиНити & ФН.ВЫХОД) == 0;
	}


	/// Process все messages in the сообщение queue. Returns нет if the приложение should выход.
	бул вершиСобытия()
	{
		бул keep = да;
		return _doEvents(&keep);
	}

	бул вершиСобытия(бцел msDelay)
	{
		if(msDelay <= 3)
			return вершиСобытия();
		struct TMR { public import viz.timer; }
		scope tmr = new TMR.Таймер();
		бул keep = да;
		tmr.интервал = msDelay;
		tmr.тик ~= (TMR.Таймер отправитель, АргиСоб ea) { отправитель.стоп(); keep = нет; };
		tmr.старт();
		while(keep)
		{
			Приложение.ждиСобытия();
			if(!_doEvents(&keep))
				return нет;
		}
		return да;
	}

	/// Run the приложение.
	проц пуск()
	{
		пуск(new КонтекстПриложения);
	}

	проц пуск(проц delegate() бездействуя)
	{
		пуск(new КонтекстПриложения, бездействуя);
	}

	проц пуск(КонтекстПриложения конткстприл)
	{
		проц бездействуя()
		{
			ждиСобытия();
		}


		пуск(конткстприл, &бездействуя);
	}


	// -бездействуя- is called repeatedly while there are нет messages in the queue.
	// Приложение.вБездействии события are supнажато; however, the -бездействуя- обработчик
	// may manually fire the Приложение.вБездействии событие.
	проц пуск(КонтекстПриложения конткстприл, проц delegate() бездействуя)
	{
		if(флагиНити & ФН.ПУЩЕНО)
		{
			//throw new ВизИскл("Cannot have more than one сообщение loop per thread");
			assert(0, "На каждую нить допускается лишь одна очередь сообщений");
			//return;
		}

		if(флагиНити & ФН.ВЫХОД)
		{
			assert(0, "Приложение будет закрыто");
			//return;
		}

		version(CUSTOM_MSG_HOOK)
		{
			HHOOK _msghook = SetWindowsHookExA(WH_CALLWNDPROCRET, &глобальныйХукСооб, пусто, GetCurrentThreadId());
			if(!_msghook)
				throw new ВизИскл("Не удаётся получить оконные сообщения");
			хуксооб = _msghook;
		}

		проц threadJustExited(Объект отправитель, АргиСоб ea)
		{
			выйдиИзНити();
		}

		кнтк = конткстприл;
		кнтк.выходИзНити ~= &threadJustExited;
		try
		{
			флагиНити = флагиНити | ФН.ПУЩЕНО;

			if(кнтк.главФорма)
			{
				//кнтк.главФорма.создайУпрЭлт();
				кнтк.главФорма.покажи();
			}

			for(;;)
			{
				try
				{
					still_running:
					while(!(флагиНити & (ФН.ВЫХОД | ФН.СТОП_ПУЩЕНОЕ)))
					{
						Сообщение сооб;

						//while(PeekMessageA(&сооб._винСооб, HWND.init, 0, 0, PM_REMOVE))
						while(peekMessage(&сооб._винСооб, HWND.init, 0, 0, PM_REMOVE))
						{
							полученоСообщение(сооб);

							if(сооб.сооб == WM_QUIT)
							{
								флагиНити = флагиНити | ФН.ВЫХОД;
								break still_running;
							}

							if(флагиНити & (ФН.ВЫХОД | ФН.СТОП_ПУЩЕНОЕ))
								break still_running;
						}

						бездействуя();
					}

					// Stopped running.
					выходИзНити(typeid(Приложение), АргиСоб.пуст);
					флагиНити = флагиНити & ~(ФН.ПУЩЕНО | ФН.СТОП_ПУЩЕНОЕ);
					return;
				}
				catch(Объект e)
				{
					приИсклНити(e);
				}
			}
		}
		finally
		{
			флагиНити = флагиНити & ~(ФН.ПУЩЕНО | ФН.СТОП_ПУЩЕНОЕ);

			КонтекстПриложения tctx;
			tctx = кнтк;
			кнтк = пусто;

			version(CUSTOM_MSG_HOOK)
				UnhookWindowsHookEx(хуксооб);

			tctx.выходИзНити.удалиОбработчик(&threadJustExited);
		}
	}


	// Makes the form -главФорма- виден.
	проц пуск(Форма главФорма, проц delegate() бездействуя)
	{
		КонтекстПриложения конткстприл = new КонтекстПриложения(главФорма);
		//главФорма.покажи(); // Interferes with -running-.
		пуск(конткстприл, бездействуя);
	}


	проц пуск(Форма главФорма)
	{
		КонтекстПриложения конткстприл = new КонтекстПриложения(главФорма);
		//главФорма.покажи(); // Interferes with -running-.
		пуск(конткстприл);
	}


		проц выход()
	{
		PostQuitMessage(0);
	}


	/// Exit the thread's сообщение loop and return from пуск.
	// Actually only stops the текущий пуск() loop.
	проц выйдиИзНити()
	{
		флагиНити = флагиНити | ФН.СТОП_ПУЩЕНОЕ;
	}


	// Will be пусто if not in а successful Приложение.пуск.
	package КонтекстПриложения контекст() // getter
	{
		return кнтк;
	}


	экз дайЭкз()
	{
		if(!hinst)
			_initInstance();
		return hinst;
	}


	проц устЭкз(экз экземп)
	{
		if(hinst)
		{
			if(экземп != hinst)
				throw new ВизИскл("Экземпляр уже установлен");
			return;
		}

		if(экземп)
		{
			_initInstance(экземп);
		}
		else
		{
			_initInstance(); // ?
		}
	}


	// ApartmentState oleRequired() ...


	/*export*/ static class ОшФорма: Форма
	{
	/*export*/

		 override проц приЗагрузке(АргиСоб ea)
		{
			okBtn.фокус();
		}


		override проц приЗакрытии(АргиСобОтмены cea)
		{
			cea.отмена = !errdone;
		}

		const цел ОТСТУП = 10;


		проц приНажатииОк(Объект отправитель, АргиСоб ea)
		{
			errdone = да;
			ctnu = да;
			//закрой();
			вымести();
		}


		проц приНажатииОтмена(Объект отправитель, АргиСоб ea)
		{
			errdone = да;
			ctnu = нет;
			//закрой();
			вымести();
		}


		this(Ткст ошсооб)
		{
			текст = "Ошибка";
			клиентРазм = Размер(340, 150);
			стартПоз = ПНачПоложениеФормы.ЦЕНТР_ЭКРАНА;
			стильКромкиФормы = ПСтильКромкиФормы.ФИКС_ДИАЛОГ;
			свернутьБокс = нет;
			развернутьБокс = нет;
			боксУпрЭлта = нет;

			Надпись надпись;
			with(надпись = new Надпись)
			{
				границы = Прям(ОТСТУП, ОТСТУП, this.клиентРазм.ширина - ОТСТУП * 2, 40);
				надпись.текст = "Исключение в приложении. Нажмите \"Продолжить\", чтобы приложение "
					"попыталось проигнорировать эту ошибку и продолжить свою работу.";
				родитель = this;
			}

			with(errBox = new ТекстБокс)
			{
				текст = ошсооб;
				границы = Прям(ОТСТУП, 40 + ОТСТУП, this.клиентРазм.ширина - ОТСТУП * 2, 50);
				errBox.цветФона = this.цветФона;
				толькоЧтение = да;
				многострок = да;
				родитель = this;
			}

			with(okBtn = new Кнопка)
			{
				ширина = 100;
				положение = Точка(this.клиентРазм.ширина - ширина - ОТСТУП - ширина - ОТСТУП,
					this.клиентРазм.высота - высота - ОТСТУП);
				текст = "&Продолжить";
				родитель = this;
				клик ~= &приНажатииОк;
			}
			кнопкаПринять = okBtn;

			with(new Кнопка)
			{
				ширина = 100;
				положение = Точка(this.клиентРазм.ширина - ширина - ОТСТУП,
					this.клиентРазм.высота - высота - ОТСТУП);
				текст = "&Выход";
				родитель = this;
				клик ~= &приНажатииОтмена;
			}

			автоМасштаб = да;
		}


		/+
		private цел inThread2()
		{
			try
			{
				// Create in this thread so that it owns the указатель.
				assert(!созданУказатель_ли);
				покажи();
				SetForegroundWindow(указатель);

				MSG сооб;
				assert(созданУказатель_ли);
				// Using the юникод stuf here messes up the redrawing for some reason.
				while(GetMessageA(&сооб, HWND.init, 0, 0)) // TODO: юникод ?
				//while(getMessage(&сооб, HWND.init, 0, 0))
				{
					if(!IsDialogMessageA(указатель, &сооб))
					//if(!isDialogMessage(указатель, &сооб))
					{
						TranslateMessage(&сооб);
						DispatchMessageA(&сооб);
						//dispatchMessage(&сооб);
					}

					if(!созданУказатель_ли)
						break;
				}
			}
			finally
			{
				вымести();
				assert(!созданУказатель_ли);

				//thread1.resume(); // Not supported by Dinrus...
				thread1 = пусто;
			}

			return 0;
		}

		private проц tinThread2() { inThread2(); }


		private Thread thread1;

		бул продолжай()
		{
			assert(!созданУказатель_ли);

			// Need to use а separate thread so that все the main thread's messages
			// will be there still when the исключение is recovered from.
			// This is very important for some messages, such as socket события.
			thread1 = Thread.getThis(); // Problems with DMD 2.ш
			Thread thd;
			version(Dinrus)
				thd = new Thread(&tinThread2);
			else
				thd = new Thread(&inThread2);
			thd.старт();
			//SuspendThread(GetCurrentThread()); // Thread2 will resume me. Not supported by Dinrus.
			do
			{
				Sleep(200);
			}
			while(thread1);

			return ctnu;
		}
		+/

		бул продолжай()
		{
			assert(!созданУказатель_ли);

			покажи();

			Сообщение сооб;
			for(;;)
			{
				WaitMessage();
				if(PeekMessageA(cast(MSG*) &сооб._винСооб, указатель, cast(UINT)0,cast(UINT)0, cast(UINT)(PM_REMOVE | PM_NOYIELD)))
				{
					/+
					//if(!IsDialogMessageA(указатель, &сооб._винСооб)) // Back to the old problems.
					{
						TranslateMessage(&сооб._винСооб);
						DispatchMessageA(&сооб._винСооб);
					}
					+/
					полученоСообщение(сооб);
				}

				if(!созданУказатель_ли)
					break;
			}

			return ctnu;
		}


		Ткст вТкст()
		{
			return errBox.текст;
		}


		private:
		бул errdone = нет;
		бул ctnu = нет;
		Кнопка okBtn;
		ТекстБокс errBox;
	}


		бул покажиДефДиалогИскл(Объект e)
	{
		/+
		if(IDYES == MessageBoxA(пусто,
			"An приложение исключение has occured. Click Yes to allow\r\n"
			"the приложение to ignore this ошибка and attempt to continue.\r\n"
			"Click No to quit the приложение.\r\n\r\n"~
			e.вТкст(),
			пусто, MB_ICONWARNING | MB_TASKMODAL | MB_YESNO))
		{
			except = нет;
			return;
		}
		+/

		//try
		{
			if((new ОшФорма(дайТкстОбъекта(e))).продолжай())
			{
				return да;
			}
		}
		/+
		catch
		{
			MessageBoxA(пусто, "Error displaying ошибка сообщение", "DFL", MB_ICONERROR | MB_TASKMODAL);
		}
		+/

		return нет;
	}


		проц приИсклНити(Объект e)
	{
		static бул except = нет;

		version(WINDOWS_HUNG_WORKAROUND)
		{
			version(WINDOWS_HUNG_WORKAROUND_NO_IGNORE)
			{
			}
			else
			{
				if(cast(ИсклЗависанияWindows)e)
					return;
			}
		}

		if(except)
		{
			скажиф("Ошибка: %.*s\n", cast(цел)дайТкстОбъекта(e).length, дайТкстОбъекта(e).ptr);

			abort();
			return;
		}

		except = да;
		//if(исклНити.обработчики.length)
		if(исклНити.hasHandlers)
		{
			исклНити(typeid(Приложение), new АргиСобИсклНити(e));
			except = нет;
			return;
		}
		else
		{
			// No thread исключение обработчики, display а dialog.
			if(покажиДефДиалогИскл(e))
			{
				except = нет;
				return;
			}
		}
		//except = нет;

		//throw e;
		скажиф("Ошибка: %.*s\n", cast(цел)дайТкстОбъекта(e).length, дайТкстОбъекта(e).ptr);
		//выйдиИзНити();
		Среда.выход(НЕУДАЧНЫЙ_ВЫХОД);
	}


	// Returns пусто if not found.
	package УпрЭлт отыщиУок(УОК уок)
	{
		//if(уок in упрэлты)
		//	return упрэлты[уок];
		auto pc = уок in упрэлты;
		if(pc)
			return *pc;
		return пусто;
	}


	// Also makes а great zombie.
	package проц удалиУок(УОК уок)
	{
		//delete упрэлты[уок];
		упрэлты.remove(уок);
	}


	version(ВИЗ_БЕЗ_ЗОМБИ_ФОРМ)
	{
	}
	else
	{
		package const Ткст ZOMBIE_PROP = "VIZ_Zombie";

		// Doesn't do any good since the child упрэлты still reference this упрэлт.
		package проц зомбируйУок(УпрЭлт ктрл)
		in
		{
			assert(ктрл !is пусто);
			assert(ктрл.созданУказатель_ли);
			assert(отыщиУок(ктрл.указатель));
		}
		body
		{
			SetPropA(ктрл.указатель, ZOMBIE_PROP.ptr, cast(HANDLE)cast(проц*)ктрл);
			удалиУок(ктрл.указатель);
		}


		package проц раззомбируйУок(УпрЭлт ктрл)
		in
		{
			assert(ктрл !is пусто);
			assert(ктрл.созданУказатель_ли);
			assert(!отыщиУок(ктрл.указатель));
		}
		body
		{
			RemovePropA(ктрл.указатель, ZOMBIE_PROP.ptr);
			упрэлты[ктрл.указатель] = ктрл;
		}


		// Doesn't need to be а zombie.
		package проц зомбиКилл(УпрЭлт ктрл)
		in
		{
			assert(ктрл !is пусто);
		}
		body
		{
			if(ктрл.созданУказатель_ли)
			{
				RemovePropA(ктрл.указатель, ZOMBIE_PROP.ptr);
			}
		}
	}


	version(ВИЗ_БЕЗ_МЕНЮ)
	{
	}
	else
	{
		// Returns its new unique меню ID.
		package цел добавьПунктМеню(ПунктМеню меню)
		{
			if(nmenus == ИД_ПОСЛЕДНЕГО_МЕНЮ - ИД_ПЕРВОГО_МЕНЮ)
				throw new ВизИскл("Вне списка меню");

			typeof(menus) tempmenus;

			// TODO: sort меню IDs in 'menus' so that looking for free ID is much faster.

			prevMenuID++;
			if(prevMenuID >= ИД_ПОСЛЕДНЕГО_МЕНЮ || prevMenuID <= ИД_ПЕРВОГО_МЕНЮ)
			{
				prevMenuID = ИД_ПЕРВОГО_МЕНЮ;
				previdloop:
				for(;;)
				{
					for(т_мера iw; iw != nmenus; iw++)
					{
						ПунктМеню mi;
						mi = cast(ПунктМеню)menus[iw];
						if(mi)
						{
							if(prevMenuID == mi._menuID)
							{
								prevMenuID++;
								continue previdloop;
							}
						}
					}
					break;
				}
			}
			tempmenus = cast(Меню*)realloc(menus, Меню.sizeof * (nmenus + 1));
			if(!tempmenus)
			{
				//throw new OutOfMemory;
				throw new ВизИскл("Вне памяти");
			}
			menus = tempmenus;

			menus[nmenus++] = меню;

			return prevMenuID;
		}


		package проц добавьКонтекстноеМеню(КонтекстноеМеню меню)
		{
			if(nmenus == ИД_ПОСЛЕДНЕГО_МЕНЮ - ИД_ПЕРВОГО_МЕНЮ)
				throw new ВизИскл("Вне списка меню");

			typeof(menus) tempmenus;
			цел idx;

			idx = nmenus;
			nmenus++;
			tempmenus = cast(Меню*)realloc(menus, Меню.sizeof * nmenus);
			if(!tempmenus)
			{
				nmenus--;
				//throw new OutOfMemory;
				throw new ВизИскл("Вне памяти");
			}
			menus = tempmenus;

			menus[idx] = меню;
		}


		package проц удалиМеню(Меню меню)
		{
			бцел idx;

			for(idx = 0; idx != nmenus; idx++)
			{
				if(menus[idx] is меню)
				{
					goto found;
				}
			}
			return;

			found:
			if(nmenus == 1)
			{
				free(menus);
				menus = пусто;
				nmenus--;
			}
			else
			{
				if(idx != nmenus - 1)
					menus[idx] = menus[nmenus - 1]; // Move last one in its place

				nmenus--;
				menus = cast(Меню*)realloc(menus, Меню.sizeof * nmenus);
				assert(menus != пусто); // Memory shrink shouldn't be а problem.
			}
		}


		package ПунктМеню отыщиИдМеню(цел идМеню)
		{
			бцел idx;
			ПунктМеню mi;

			for(idx = 0; idx != nmenus; idx++)
			{
				mi = cast(ПунктМеню)menus[idx];
				if(mi && mi._menuID == идМеню)
					return mi;
			}
			return пусто;
		}


		package Меню отыщиМеню(HMENU hmenu)
		{
			бцел idx;

			for(idx = 0; idx != nmenus; idx++)
			{
				if(menus[idx].указатель == hmenu)
					return menus[idx];
			}
			return пусто;
		}
	}


	package проц созданиеУпрЭлта(УпрЭлт упрэлм)
	{
		TlsSetValue(нлхКонтрол, cast(УпрЭлт*)упрэлм);
	}


	version(VIZ_NO_RESOURCES)
	{
	}
	else
	{
		Ресурсы ресурсы() // getter
		{
			static Ресурсы rc = пусто;

			if(!rc)
			{
				synchronized
				{
					if(!rc)
					{
						rc = new Ресурсы(дайЭкз());
					}
				}
			}
			return rc;
		}
	}


	private UINT gctimer = 0;
	private DWORD инфоСМ = 1;


		проц автоСбор(бул подтвержд) // setter
	{
		if(подтвержд)
		{
			if(!автоСбор)
			{
				инфоСМ = 1;
			}
		}
		else
		{
			if(автоСбор)
			{
				инфоСМ = 0;
				KillTimer(HWND.init, gctimer);
				gctimer = 0;
			}
		}
	}


	бул автоСбор() // getter
	{
		return инфоСМ > 0;
	}


	package проц _waitMsg()
	{
		if(флагиНити & (ФН.СТОП_ПУЩЕНОЕ | ФН.ВЫХОД))
			return;

		вБездействии(typeid(Приложение), АргиСоб.пуст);
		WaitMessage();
	}

	package deprecated alias _waitMsg waitMsg;


		// Because waiting for an событие enters an вБездействии состояние,
	// this function fires the -вБездействии- событие.
	проц ждиСобытия()
	{
		if(!автоСбор)
		{
			_waitMsg();
			return;
		}

		if(1 == инфоСМ)
		{
			инфоСМ = инфоСМ.max;
			assert(!gctimer);
			gctimer = SetTimer(HWND.init, 0, 200, &_gcTimeout);
		}

		_waitMsg();

		if(GetTickCount() > инфоСМ)
		{
			инфоСМ = 1;
		}
	}


	version(VIZ_NO_COMPAT)
		package const DflCompat _compat = DflCompat.НЕУК;
	else
		package DflCompat _compat = DflCompat.НЕУК;


	deprecated проц setCompat(DflCompat vizcompat)
	{
		version(VIZ_NO_COMPAT)
		{
			assert(0, "Compatibility disabled"); // version=VIZ_NO_COMPAT
		}
		else
		{
			if(циклСооб)
			{
				assert(0, "setCompat"); // Called too late, must включи compatibility sooner.
				//return;
			}

			_compat |= vizcompat;
		}
	}


	private static т_мера _doref(ук p, цел by)
	{
		assert(1 == by || -1 == by);

		т_мера результат;

		synchronized
		{
			auto pref = p in _refs;
			if(pref)
			{
				т_мера count;
				count = *pref;

				assert(count || -1 != by);

				if(-1 == by)
					count--;
				else
					count++;

				if(!count)
				{
					результат = 0;
					_refs.remove(p);
				}
				else
				{
					результат = count;
					_refs[p] = count;
				}
			}
			else if(1 == by)
			{
				_refs[p] = 1;
				результат = 1;
			}
		}

		return результат;
	}


	package т_мера refCountInc(ук p)
	{
		return _doref(p, 1);
	}


	// Returns the new ref count.
	package т_мера refCountDec(ук p)
	{
		return _doref(p, -1);
	}


	package проц ppin(ук p)
	{
		gcPin(p);
	}


	package проц punpin(ук p)
	{
		gcUnpin(p);
	}


	private:
	static:
	т_мера[проц*] _refs;
	ИФильтрСооб[] фильтры;
	DWORD флагиНЛХНити;
	DWORD нлхКонтрол;
	DWORD фильтрНЛХ; // ИФильтрСооб[]*.
	version(CUSTOM_MSG_HOOK)
		DWORD хукНЛХ; // HHOOK.
	viz.control.УпрЭлт[УОК] упрэлты;
	экз hinst;
	КонтекстПриложения кнтк = пусто;

	version(ВИЗ_БЕЗ_МЕНЮ)
	{
	}
	else
	{
		ushort prevMenuID = ИД_ПЕРВОГО_МЕНЮ;
		// malloc() is needed so the menus can be garbage collected.
		бцел nmenus = 0; // Number of -menus-.
		Меню* menus = пусто; // WARNING: malloc()'d memory!


		// Menus.
		const ushort ИД_ПЕРВОГО_МЕНЮ = 200;
		const ushort ИД_ПОСЛЕДНЕГО_МЕНЮ = 10000;

		// Controls.
		const ushort ИД_ПЕРВОГО_УПРЭЛТА = ИД_ПОСЛЕДНЕГО_МЕНЮ + 1;
		const ushort ИД_ПОСЛЕДНЕГО_УПРЭЛТА = 65500;


		// Destroy все меню уки at program выход because Windows will not
		// unless it is assigned to а окно.
		// Note that this is probably just а 16bit issue, but it still appeared in the 32bit docs.
		private проц sdtorFreeAllMenus()
		{
			foreach(Меню m; menus[0 .. nmenus])
			{
				DestroyMenu(m.указатель);
			}
			nmenus = 0;
			free(menus);
			menus = пусто;
		}
	}


	private struct ЗначениеФильтраНлх
	{
		ИФильтрСооб[] фильтры;
	}


	/+
	проц фильтры(ИФильтрСооб[] фильтры) // setter
	{
		// The ЗначениеФильтраНлх is being garbage collected!

		ЗначениеФильтраНлх* val = cast(ЗначениеФильтраНлх*)TlsGetValue(фильтрНЛХ);
		if(!val)
			val = new ЗначениеФильтраНлх;
		val.фильтры = фильтры;
		TlsSetValue(фильтрНЛХ, cast(LPVOID)val);
	}


	ИФильтрСооб[] фильтры() // getter
	{
		ЗначениеФильтраНлх* val = cast(ЗначениеФильтраНлх*)viz.x.TlsGetValue(фильтрНЛХ);
		if(!val)
			return пусто;
		return val.фильтры;
	}
	+/


	version(CUSTOM_MSG_HOOK)
	{
		проц хуксооб(HHOOK hhook) // setter
		{
			TlsSetValue(хукНЛХ, cast(LPVOID)hhook);
		}


		HHOOK хуксооб() // getter
		{
			return cast(HHOOK)TlsGetValue(хукНЛХ);
		}
	}


	УпрЭлт дайСозданиеУпрЭлта()
	{
		return cast(УпрЭлт)cast(УпрЭлт*)TlsGetValue(нлхКонтрол);
	}


	// Thread флаги.
	enum ФН: DWORD
	{
		ПУЩЕНО = 1, // Приложение.пуск is in affect.
		СТОП_ПУЩЕНОЕ = 2,
		ВЫХОД = 4, // Received WM_QUIT.
	}


	ФН флагиНити() // getter
	{
		return cast(ФН)cast(DWORD)TlsGetValue(флагиНЛХНити);
	}


	проц флагиНити(ФН флаги) // setter
	{
		if(!TlsSetValue(флагиНЛХНити, cast(LPVOID)cast(DWORD)флаги))
			assert(0);
	}


	проц полученоСообщение(inout Сообщение сооб)
	{
		//debug(SHOW_MESSAGE_INFO)
		//	покажиИнфоСообщение(сооб);

		// Don't bother with this extra stuff if there aren't any фильтры.
		if(фильтры.length)
		{
			try
			{
				// Keep а local reference so that обработчики
				// may be added and removed during filtering.
				ИФильтрСооб[] local = фильтры;

				foreach(ИФильтрСооб mf; local)
				{
					// Returning да prevents dispatching.
					if(mf.предфильтровкаСообщения(сооб))
					{
						УпрЭлт упрэлм;
						упрэлм = отыщиУок(сооб.уок);
						if(упрэлм)
							упрэлм.mustWndProc(сооб);
						return;
					}
				}
			}
			catch(Объект o)
			{
				УпрЭлт упрэлм;
				упрэлм = отыщиУок(сооб.уок);
				if(упрэлм)
					упрэлм.mustWndProc(сооб);
				throw o;
			}
		}

		TranslateMessage(cast(MSG*)&сооб._винСооб);
		//DispatchMessageA(&сооб._винСооб);
		dispatchMessage(&сооб._винСооб);
	}
}


package:


/*export*/ extern(Windows) проц _gcTimeout(УОК уок, UINT uMsg, UINT idEvent, DWORD dwTime)
{
	KillTimer(уок, Приложение.gctimer);
	Приложение.gctimer = 0;

	//скажиф("Auto-collecting\n");
	смСобери();

	Приложение.инфоСМ = GetTickCount() + 4000;
}


// Note: phobos-only.
debug(SHOW_MESSAGE_INFO)
{

	проц покажиИнфоСообщение(inout Сообщение m)
	{
		проц пишиСо(Ткст wmName)
		{
			пишиф("Message %s=%d(0x%X)\n", wmName, m.сооб, m.сооб);
		}


		switch(m.сооб)
		{
			case WM_NULL: пишиСо("WM_NULL"); break;
			case WM_CREATE: пишиСо("WM_CREATE"); break;
			case WM_DESTROY: пишиСо("WM_DESTROY"); break;
			case WM_MOVE: пишиСо("WM_MOVE"); break;
			case WM_SIZE: пишиСо("WM_SIZE"); break;
			case WM_ACTIVATE: пишиСо("WM_ACTIVATE"); break;
			case WM_SETFOCUS: пишиСо("WM_SETFOCUS"); break;
			case WM_KILLFOCUS: пишиСо("WM_KILLFOCUS"); break;
			case WM_ENABLE: пишиСо("WM_ENABLE"); break;
			case WM_SETREDRAW: пишиСо("WM_SETREDRAW"); break;
			case WM_SETTEXT: пишиСо("WM_SETTEXT"); break;
			case WM_GETTEXT: пишиСо("WM_GETTEXT"); break;
			case WM_GETTEXTLENGTH: пишиСо("WM_GETTEXTLENGTH"); break;
			case WM_PAINT: пишиСо("WM_PAINT"); break;
			case WM_CLOSE: пишиСо("WM_CLOSE"); break;
			case WM_QUERYENDSESSION: пишиСо("WM_QUERYENDSESSION"); break;
			case WM_QUIT: пишиСо("WM_QUIT"); break;
			case WM_QUERYOPEN: пишиСо("WM_QUERYOPEN"); break;
			case WM_ERASEBKGND: пишиСо("WM_ERASEBKGND"); break;
			case WM_SYSCOLORCHANGE: пишиСо("WM_SYSCOLORCHANGE"); break;
			case WM_ENDSESSION: пишиСо("WM_ENDSESSION"); break;
			case WM_SHOWWINDOW: пишиСо("WM_SHOWWINDOW"); break;
			//case WM_WININICHANGE: пишиСо("WM_WININICHANGE"); break;
			case WM_SETTINGCHANGE: пишиСо("WM_SETTINGCHANGE"); break;
			case WM_DEVMODECHANGE: пишиСо("WM_DEVMODECHANGE"); break;
			case WM_ACTIVATEAPP: пишиСо("WM_ACTIVATEAPP"); break;
			case WM_FONTCHANGE: пишиСо("WM_FONTCHANGE"); break;
			case WM_TIMECHANGE: пишиСо("WM_TIMECHANGE"); break;
			case WM_CANCELMODE: пишиСо("WM_CANCELMODE"); break;
			case WM_SETCURSOR: пишиСо("WM_SETCURSOR"); break;
			case WM_MOUSEACTIVATE: пишиСо("WM_MOUSEACTIVATE"); break;
			case WM_CHILDACTIVATE: пишиСо("WM_CHILDACTIVATE"); break;
			case WM_QUEUESYNC: пишиСо("WM_QUEUESYNC"); break;
			case WM_GETMINMAXINFO: пишиСо("WM_GETMINMAXINFO"); break;
			case WM_NOTIFY: пишиСо("WM_NOTIFY"); break;
			case WM_INPUTLANGCHANGEREQUEST: пишиСо("WM_INPUTLANGCHANGEREQUEST"); break;
			case WM_INPUTLANGCHANGE: пишиСо("WM_INPUTLANGCHANGE"); break;
			case WM_TCARD: пишиСо("WM_TCARD"); break;
			case WM_HELP: пишиСо("WM_HELP"); break;
			case WM_USERCHANGED: пишиСо("WM_USERCHANGED"); break;
			case WM_NOTIFYFORMAT: пишиСо("WM_NOTIFYFORMAT"); break;
			case WM_CONTEXTMENU: пишиСо("WM_CONTEXTMENU"); break;
			case WM_STYLECHANGING: пишиСо("WM_STYLECHANGING"); break;
			case WM_STYLECHANGED: пишиСо("WM_STYLECHANGED"); break;
			case WM_DISPLAYCHANGE: пишиСо("WM_DISPLAYCHANGE"); break;
			case WM_GETICON: пишиСо("WM_GETICON"); break;
			case WM_SETICON: пишиСо("WM_SETICON"); break;
			case WM_NCCREATE: пишиСо("WM_NCCREATE"); break;
			case WM_NCDESTROY: пишиСо("WM_NCDESTROY"); break;
			case WM_NCCALCSIZE: пишиСо("WM_NCCALCSIZE"); break;
			case WM_NCHITTEST: пишиСо("WM_NCHITTEST"); break;
			case WM_NCPAINT: пишиСо("WM_NCPAINT"); break;
			case WM_NCACTIVATE: пишиСо("WM_NCACTIVATE"); break;
			case WM_GETDLGCODE: пишиСо("WM_GETDLGCODE"); break;
			case WM_NCMOUSEMOVE: пишиСо("WM_NCMOUSEMOVE"); break;
			case WM_NCLBUTTONDOWN: пишиСо("WM_NCLBUTTONDOWN"); break;
			case WM_NCLBUTTONUP: пишиСо("WM_NCLBUTTONUP"); break;
			case WM_NCLBUTTONDBLCLK: пишиСо("WM_NCLBUTTONDBLCLK"); break;
			case WM_NCRBUTTONDOWN: пишиСо("WM_NCRBUTTONDOWN"); break;
			case WM_NCRBUTTONUP: пишиСо("WM_NCRBUTTONUP"); break;
			case WM_NCRBUTTONDBLCLK: пишиСо("WM_NCRBUTTONDBLCLK"); break;
			case WM_NCMBUTTONDOWN: пишиСо("WM_NCMBUTTONDOWN"); break;
			case WM_NCMBUTTONUP: пишиСо("WM_NCMBUTTONUP"); break;
			case WM_NCMBUTTONDBLCLK: пишиСо("WM_NCMBUTTONDBLCLK"); break;
			case WM_KEYDOWN: пишиСо("WM_KEYDOWN"); break;
			case WM_KEYUP: пишиСо("WM_KEYUP"); break;
			case WM_CHAR: пишиСо("WM_CHAR"); break;
			case WM_DEADCHAR: пишиСо("WM_DEADCHAR"); break;
			case WM_SYSKEYDOWN: пишиСо("WM_SYSKEYDOWN"); break;
			case WM_SYSKEYUP: пишиСо("WM_SYSKEYUP"); break;
			case WM_SYSCHAR: пишиСо("WM_SYSCHAR"); break;
			case WM_SYSDEADCHAR: пишиСо("WM_SYSDEADCHAR"); break;
			case WM_IME_STARTCOMPOSITION: пишиСо("WM_IME_STARTCOMPOSITION"); break;
			case WM_IME_ENDCOMPOSITION: пишиСо("WM_IME_ENDCOMPOSITION"); break;
			case WM_IME_COMPOSITION: пишиСо("WM_IME_COMPOSITION"); break;
			case WM_INITDIALOG: пишиСо("WM_INITDIALOG"); break;
			case WM_COMMAND: пишиСо("WM_COMMAND"); break;
			case WM_SYSCOMMAND: пишиСо("WM_SYSCOMMAND"); break;
			case WM_TIMER: пишиСо("WM_TIMER"); break;
			case WM_HSCROLL: пишиСо("WM_HSCROLL"); break;
			case WM_VSCROLL: пишиСо("WM_VSCROLL"); break;
			case WM_INITMENU: пишиСо("WM_INITMENU"); break;
			case WM_INITMENUPOPUP: пишиСо("WM_INITMENUPOPUP"); break;
			case WM_MENUSELECT: пишиСо("WM_MENUSELECT"); break;
			case WM_MENUCHAR: пишиСо("WM_MENUCHAR"); break;
			case WM_ENTERIDLE: пишиСо("WM_ENTERIDLE"); break;
			case WM_CTLCOLORMSGBOX: пишиСо("WM_CTLCOLORMSGBOX"); break;
			case WM_CTLCOLOREDIT: пишиСо("WM_CTLCOLOREDIT"); break;
			case WM_CTLCOLORLISTBOX: пишиСо("WM_CTLCOLORLISTBOX"); break;
			case WM_CTLCOLORBTN: пишиСо("WM_CTLCOLORBTN"); break;
			case WM_CTLCOLORDLG: пишиСо("WM_CTLCOLORDLG"); break;
			case WM_CTLCOLORSCROLLBAR: пишиСо("WM_CTLCOLORSCROLLBAR"); break;
			case WM_CTLCOLORSTATIC: пишиСо("WM_CTLCOLORSTATIC"); break;
			case WM_MOUSEMOVE: пишиСо("WM_MOUSEMOVE"); break;
			case WM_LBUTTONDOWN: пишиСо("WM_LBUTTONDOWN"); break;
			case WM_LBUTTONUP: пишиСо("WM_LBUTTONUP"); break;
			case WM_LBUTTONDBLCLK: пишиСо("WM_LBUTTONDBLCLK"); break;
			case WM_RBUTTONDOWN: пишиСо("WM_RBUTTONDOWN"); break;
			case WM_RBUTTONUP: пишиСо("WM_RBUTTONUP"); break;
			case WM_RBUTTONDBLCLK: пишиСо("WM_RBUTTONDBLCLK"); break;
			case WM_MBUTTONDOWN: пишиСо("WM_MBUTTONDOWN"); break;
			case WM_MBUTTONUP: пишиСо("WM_MBUTTONUP"); break;
			case WM_MBUTTONDBLCLK: пишиСо("WM_MBUTTONDBLCLK"); break;
			case WM_PARENTNOTIFY: пишиСо("WM_PARENTNOTIFY"); break;
			case WM_ENTERMENULOOP: пишиСо("WM_ENTERMENULOOP"); break;
			case WM_EXITMENULOOP: пишиСо("WM_EXITMENULOOP"); break;
			case WM_NEXTMENU: пишиСо("WM_NEXTMENU"); break;
			case WM_SETFONT: пишиСо("WM_SETFONT"); break;
			case WM_GETFONT: пишиСо("WM_GETFONT"); break;
			case WM_USER: пишиСо("WM_USER"); break;
			case WM_NEXTDLGCTL: пишиСо("WM_NEXTDLGCTL"); break;
			case WM_CAPTURECHANGED: пишиСо("WM_CAPTURECHANGED"); break;
			case WM_WINDOWPOSCHANGING: пишиСо("WM_WINDOWPOSCHANGING"); break;
			case WM_WINDOWPOSCHANGED: пишиСо("WM_WINDOWPOSCHANGED"); break;
			case WM_DRAWITEM: пишиСо("WM_DRAWITEM"); break;
			case WM_CLEAR: пишиСо("WM_CLEAR"); break;
			case WM_CUT: пишиСо("WM_CUT"); break;
			case WM_COPY: пишиСо("WM_COPY"); break;
			case WM_PASTE: пишиСо("WM_PASTE"); break;
			case WM_MDITILE: пишиСо("WM_MDITILE"); break;
			case WM_MDICASCADE: пишиСо("WM_MDICASCADE"); break;
			case WM_MDIICONARRANGE: пишиСо("WM_MDIICONARRANGE"); break;
			case WM_MDIGETACTIVE: пишиСо("WM_MDIGETACTIVE"); break;
			case WM_MOUSEWHEEL: пишиСо("WM_MOUSEWHEEL"); break;
			case WM_MOUSEHOVER: пишиСо("WM_MOUSEHOVER"); break;
			case WM_MOUSELEAVE: пишиСо("WM_MOUSELEAVE"); break;
			case WM_PRINT: пишиСо("WM_PRINT"); break;
			case WM_PRINTCLIENT: пишиСо("WM_PRINTCLIENT"); break;
			case WM_MEASUREITEM: пишиСо("WM_MEASUREITEM"); break;

			default:
				if(m.сооб >= WM_USER && m.сооб <= 0x7FFF)
				{
					пишиСо("WM_USER+" ~ вТкст(m.сооб - WM_USER));
				}
				else if(m.сооб >=0xC000 && m.сооб <= 0xFFFF)
				{
					пишиСо("RegisterWindowMessage");
				}
				else
				{
					пишиСо("?");
				}
		}

		УпрЭлт упрэлм;
		упрэлм = Приложение.отыщиУок(m.уок);
		пишиф("HWND=%d(0x%X) %s WPARAM=%d(0x%X) LPARAM=%d(0x%X)\n\n",
			cast(т_мера)m.уок, cast(т_мера)m.уок,
			упрэлм ? ("VIZname='" ~ упрэлм.имя ~ "'") : "<nonVIZ>",
			m.парам1, m.парам1,
			m.парам2, m.парам2);

		debug(MESSAGE_PAUSE)
		{
			Sleep(50);
		}
	}
}


/*export*/ extern(Windows) LRESULT vizWndProc(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	//скажиф("УОК %p; WM %d(0x%X); WPARAM %d(0x%X); LPARAM %d(0x%X);\n", уок, сооб, сооб, wparam, wparam, lparam, lparam);

	if(сооб == wmViz)
	{
		switch(wparam)
		{
			case WPARAM_VIZ_INVOKE:
				{
					ДанныеВызова* pinv;
					pinv = cast(ДанныеВызова*)lparam;
					try
					{
						pinv.результат = pinv.дг(pinv.арги);
					}
					catch(Объект e)
					{
						//Приложение.приИсклНити(e);
						try
						{
							if(e)
								pinv.исключение = e;
							else
								pinv.исключение = new Объект;
						}
						catch(Объект e2)
						{
							Приложение.приИсклНити(e2);
						}
					}
					return LRESULT_VIZ_INVOKE;
				}
				//break;

			case WPARAM_VIZ_INVOKE_SIMPLE:
				{
					ПростыеДанныеВызова* pinv;
					pinv = cast(ПростыеДанныеВызова*)lparam;
					try
					{
						pinv.дг();
					}
					catch(Объект e)
					{
						//Приложение.приИсклНити(e);
						try
						{
							if(e)
								pinv.исключение = e;
							else
								pinv.исключение = new Объект;
						}
						catch(Объект e2)
						{
							Приложение.приИсклНити(e2);
						}
					}
					return LRESULT_VIZ_INVOKE;
				}
				//break;

			case WPARAM_VIZ_DELAY_INVOKE:
				try
				{
					(cast(проц function())lparam)();
				}
				catch(Объект e)
				{
					Приложение.приИсклНити(e);
				}
				break;

			case WPARAM_VIZ_DELAY_INVOKE_PARAMS:
				{
					ПарамВызоваВиз* p;
					p = cast(ПарамВызоваВиз*)lparam;
					try
					{
						p.fp(Приложение.отыщиУок(уок), p.params.ptr[0 .. p.nparams]);
					}
					catch(Объект e)
					{
						Приложение.приИсклНити(e);
					}
					free(p);
				}
				break;

			default: ;
		}
	}

	Сообщение dm = Сообщение(уок, сооб, wparam, lparam);
	УпрЭлт упрэлм;

	debug(SHOW_MESSAGE_INFO)
		покажиИнфоСообщение(dm);

	if(сооб == WM_NCCREATE)
	{
		упрэлм = Приложение.дайСозданиеУпрЭлта();
		if(!упрэлм)
		{
			debug(APP_PRINT)
				скажиф("Не удаётся добавить окно 0x%X.\n", уок);
			return dm.результат;
		}
		Приложение.созданиеУпрЭлта(пусто); // Reset.

		Приложение.упрэлты[уок] = упрэлм;
		упрэлм.уок = уок;
		debug(APP_PRINT)
			скажиф("Добавлено окно 0x%X.\n", уок);

		//упрэлм.finishCreating(уок);
		goto do_msg;
	}

	упрэлм = Приложение.отыщиУок(уок);

	if(!упрэлм)
	{
		// Zombie...
		//return 1; // Returns correctly for most messages. e.з. WM_QUERYENDSESSION, WM_NCACTIVATE.
		dm.результат = 1;
		version(ВИЗ_БЕЗ_ЗОМБИ_ФОРМ)
		{
		}
		else
		{
			упрэлм = cast(УпрЭлт)cast(проц*)GetPropA(уок, Приложение.ZOMBIE_PROP.ptr);
			if(упрэлм)
				упрэлм.mustWndProc(dm);
		}
		return dm.результат;
	}

	if(упрэлм)
	{
		do_msg:
		упрэлм.mustWndProc(dm);
		if(!упрэлм.подготовьСообщение(dm))
			упрэлм._wndProc(dm);
	}
	return dm.результат;
}


version(CUSTOM_MSG_HOOK)
{
	typedef CWPRETSTRUCT ОсобоеСооб;


	// Needs to be re-entrant.
	/*export*/ extern(Windows) LRESULT глобальныйХукСооб(цел code, WPARAM wparam, LPARAM lparam)
	{
		if(code == HC_ACTION)
		{
			ОсобоеСооб* сооб = cast(ОсобоеСооб*)lparam;
			УпрЭлт упрэлм;

			switch(сооб.сообщение)
			{
				// ...
			}
		}

		return CallNextHookEx(Приложение.хуксооб, code, wparam, lparam);
	}
}
else
{
	/+
	struct ОсобоеСооб
	{
		УОК уок;
		UINT сообщение;
		WPARAM парам1;
		LPARAM парам2;
	}
	+/
}


const LRESULT LRESULT_VIZ_INVOKE = 0x95FADF; // Magic number.


UINT wmViz;


version(VIZ_NO_WM_GETКОНТРОЛNAME)
{
}
else
{
	UINT wmGetControlName;
}


extern(Windows)
{
	alias BOOL function(LPTRACKMOUSEEVENT lpEventTrack) TrackMouseEventProc;
	alias BOOL function(УОК, COLORREF, BYTE, DWORD) SetLayeredWindowAttributesProc;

	alias HTHEME function(УОК) GetWindowThemeProc;
	alias BOOL function(HTHEME hTheme, цел iPartId, цел iStateId) IsThemeBackgroundPartiallyTransparentProc;
	alias HRESULT function(УОК уок, HDC hdc, RECT* prc) DrawThemeParentBackgroundProc;
	alias проц function(DWORD dwFlags) SetThemeAppPropertiesProc;
}


// Set version = SUPPORTS_MOUSE_TRACKING if it is guaranteed to be supported.
TrackMouseEventProc trackMouseEvent;

// Set version = SUPPORTS_OPACITY if it is guaranteed to be supported.
SetLayeredWindowAttributesProc setLayeredWindowAttributes;

/+
GetWindowThemeProc getWindowTheme;
IsThemeBackgroundPartiallyTransparentProc isThemeBackgroundPartiallyTransparent;
DrawThemeParentBackgroundProc drawThemeParentBackground;
SetThemeAppPropertiesProc setThemeAppProperties;
+/


const Ткст CONTROL_CLASSNAME = "VIZ_Control";
const Ткст FORM_CLASSNAME = "VIZ_Form";
const Ткст TEXTBOX_CLASSNAME = "VIZ_TextBox";
const Ткст LISTBOX_CLASSNAME = "VIZ_ListBox";
//const Ткст LABEL_CLASSNAME = "VIZ_Label";
const Ткст BUTTON_CLASSNAME = "VIZ_Button";
const Ткст MDICLIENT_CLASSNAME = "VIZ_MdiClient";
const Ткст RICHTEXTBOX_CLASSNAME = "VIZ_RichTextBox";
const Ткст COMBOBOX_CLASSNAME = "VIZ_ComboBox";
const Ткст TREEVIEW_CLASSNAME = "VIZ_TreeView";
const Ткст TABКОНТРОЛ_CLASSNAME = "VIZ_TabControl";
const Ткст LISTVIEW_CLASSNAME = "VIZ_ListView";
const Ткст STATUSBAR_CLASSNAME = "VIZ_StatusBar";
const Ткст PROGRESSBAR_CLASSNAME = "VIZ_ProgressBar";

WNDPROC первОкПроцТексБокса;
WNDPROC первОкПроцЛистБокса;
//WNDPROC labelPrevWndProc;
WNDPROC первОкПроцКнопки;
WNDPROC первОкПроцМдиКлиента;
WNDPROC первОкПроцРичТекстБокса;
WNDPROC первОкПроцКомбоБокса;
WNDPROC первОкПроцТривью;
WNDPROC первОкПроцТабконтрола;
WNDPROC первОкПроцЛиствью;
WNDPROC первОкПроцСтатусбара;
WNDPROC первОкПроцПрогрессбара;

LONG стильКлассаТекстБокс;
LONG стильКлассаЛистБокс;
//LONG labelClassStyle;
LONG стильКлассаКнопка;
LONG стильКлассаМдиКлиент;
LONG стильКлассаРичТекстБокс;
LONG стильКлассаКомбоБокс;
LONG стильКлассаТривью;
LONG стильКлассаТабконтрол;
LONG стильКлассаЛиствью;
LONG стильКлассаСтатусбар;
LONG стильКлассаПрогрессбар;

HMODULE укМодРичТекстБокс;

// DMD 0.93: CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS is not an expression
//const UINT WNDCLASS_STYLE = CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
//const UINT WNDCLASS_STYLE = 11;

//const UINT WNDCLASS_STYLE = CS_DBLCLKS;
// DMD 0.106: CS_DBLCLKS is not an expression
const UINT WNDCLASS_STYLE = 0x0008;


extern(Windows)
{
	alias BOOL function(LPINITCOMMONCONTROLSEX lpInitCtrls) InitCommonControlsExProc;
}


// For this to work properly on Windows 95, Internet Explorer 4.0 must be installed.
проц _initCommonControls(DWORD dwControls)
{
	version(SUPPORTS_COMMON_КОНТРОЛS_EX)
	{
		pragma(сооб, "viz: extended common controls supported at compile time");

		alias InitCommonControlsEx initProc;
	}
	else
	{
		// Make sure InitCommonControlsEx() is in comctl32.dll,
		// otherwise use the old InitCommonControls().

		HMODULE hmodCommonControls;
		InitCommonControlsExProc initProc;

		hmodCommonControls = LoadLibraryA("comctl32.dll");
		if(!hmodCommonControls)
		//	throw new ВизИскл("Unable to загрузка 'comctl32.dll'");
			goto no_comctl32;

		initProc = cast(InitCommonControlsExProc)GetProcAddress(hmodCommonControls, "InitCommonControlsEx");
		if(!initProc)
		{
			//FreeLibrary(hmodCommonControls);
			no_comctl32:
			InitCommonControls();
			return;
		}
	}

	INITCOMMONCONTROLSEX icce;
	icce.dwSize = INITCOMMONCONTROLSEX.sizeof;
	icce.dwICC = dwControls;
	initProc(&icce);
}


/*export*/ extern(C)
{
	т_мера C_refCountInc(ук p)
	{
		return Приложение._doref(p, 1);
	}


	// Returns the new ref count.
	т_мера C_refCountDec(ук p)
	{
		return Приложение._doref(p, -1);
	}
}


static this()
{
	_utfinit();

	Приложение.флагиНЛХНити = TlsAlloc();
	Приложение.нлхКонтрол = TlsAlloc();
	Приложение.фильтрНЛХ = TlsAlloc();
	version(CUSTOM_MSG_HOOK)
		Приложение.хукНЛХ = TlsAlloc();

	wmViz = RegisterWindowMessageA("WM_VIZ");
	if(!wmViz)
		wmViz = WM_USER + 0x7CD;

	version(VIZ_NO_WM_GETКОНТРОЛNAME)
	{
	}
	else
	{
		wmGetControlName = RegisterWindowMessageA("WM_GETCONTROLNAME");
	}

	//InitCommonControls(); // Done later. Needs to be linked with comctl32.lib.
	OleInitialize(пусто); // Needs to be linked with ole32.lib.

	HMODULE user32 = GetModuleHandleA("user32.dll");

	version(SUPPORTS_MOUSE_TRACKING)
	{
		pragma(сооб, "viz: mouse tracking supported at compile time");

		trackMouseEvent = &TrackMouseEvent;
	}
	else
	{
		trackMouseEvent = cast(TrackMouseEventProc)GetProcAddress(user32, "TrackMouseEvent");
		if(!trackMouseEvent) // Must be Windows 95; check if common упрэлты has it (IE 5.5).
			trackMouseEvent = cast(TrackMouseEventProc)GetProcAddress(GetModuleHandleA("comctl32.dll"), "_TrackMouseEvent");
	}

	version(SUPPORTS_OPACITY)
	{
		pragma(сооб, "viz: opacity supported at compile time");

		setLayeredWindowAttributes = &SetLayeredWindowAttributes;
	}
	else
	{
		setLayeredWindowAttributes = cast(SetLayeredWindowAttributesProc)GetProcAddress(user32, "SetLayeredWindowAttributes");
	}
}


static ~this()
{
	version(ВИЗ_БЕЗ_МЕНЮ)
	{
	}
	else
	{
		Приложение.sdtorFreeAllMenus();
	}

	if(укМодРичТекстБокс)
		FreeLibrary(укМодРичТекстБокс);
}


проц _unableToInit(Ткст what)
{
	/+if(what.length > 4
		&& what[0] == 'D' && what[1] == 'F'
		&& what[2] == 'L' && what[3] == '_')+/
		what = what[4 .. what.length];
	throw new ВизИскл("Не удалось инициализировать " ~ what);
}


проц _initInstance()
{
	return _initInstance(GetModuleHandleA(пусто));
}


проц _initInstance(экз экземп)
in
{
	assert(!Приложение.hinst);
	assert(экземп);
}
body
{
	Приложение.hinst = экземп;

	/+
	WNDCLASSA ко;
	//(cast(ббайт*)&ко)[0 .. ко.sizeof] = 0;
	ко.стиль = WNDCLASS_STYLE;
	ко.hInstance = экземп;
	ко.lpfnWndProc = &vizWndProc;

	// УпрЭлт wndclass.
	ко.lpszClassName = CONTROL_CLASSNAME;
	if(!RegisterClassA(&ко))
		_unableToInit("УпрЭлт");

	// Форма wndclass.
	ко.cbWndExtra = DLGWINDOWEXTRA;
	ко.lpszClassName = FORM_CLASSNAME;
	if(!RegisterClassA(&ко))
		_unableToInit("Форма");
	+/

	КлассОкна ко;
	ко.ко.стиль = WNDCLASS_STYLE;
	ко.ко.hInstance = cast(HINSTANCE) экземп;
	ко.ко.lpfnWndProc = &vizWndProc;

	// УпрЭлт wndclass.
	ко.имяКласса = CONTROL_CLASSNAME;
	if(!зарегистрируйКласс(ко))
		_unableToInit(CONTROL_CLASSNAME);

	// Форма wndclass.
	ко.ко.cbWndExtra = DLGWINDOWEXTRA;
	ко.имяКласса = FORM_CLASSNAME;
	if(!зарегистрируйКласс(ко))
		_unableToInit(FORM_CLASSNAME);
}


/*export*/ extern(Windows)
{
	проц _initTextBox()
	{
		if(!первОкПроцТексБокса)
		{
			КлассОкна инфо;
			первОкПроцТексБокса = суперКласс(экз.init, "EDIT", TEXTBOX_CLASSNAME, инфо);
			if(!первОкПроцТексБокса)
				_unableToInit(TEXTBOX_CLASSNAME);
			стильКлассаТекстБокс = инфо.ко.стиль;
		}
	}


	проц _initListbox()
	{
		if(!первОкПроцЛистБокса)
		{
			КлассОкна инфо;
			первОкПроцЛистБокса = суперКласс(экз.init, "LISTBOX", LISTBOX_CLASSNAME, инфо);
			if(!первОкПроцЛистБокса)
				_unableToInit(LISTBOX_CLASSNAME);
			стильКлассаЛистБокс = инфо.ко.стиль;
		}
	}


	/+
	проц _initLabel()
	{
		if(!labelPrevWndProc)
		{
			КлассОкна инфо;
			labelPrevWndProc = суперКласс(экз.init, "STATIC", LABEL_CLASSNAME, инфо);
			if(!labelPrevWndProc)
				_unableToInit(LABEL_CLASSNAME);
			labelClassStyle = инфо.ко.стиль;
		}
	}
	+/


	проц _initButton()
	{
		if(!первОкПроцКнопки)
		{
			КлассОкна инфо;
			первОкПроцКнопки = суперКласс(экз.init, "BUTTON", BUTTON_CLASSNAME, инфо);
			if(!первОкПроцКнопки)
				_unableToInit(BUTTON_CLASSNAME);
			стильКлассаКнопка = инфо.ко.стиль;
		}
	}


	проц _initMdiclient()
	{
		if(!первОкПроцМдиКлиента)
		{
			КлассОкна инфо;
			первОкПроцМдиКлиента = суперКласс(экз.init, "MDICLIENT", MDICLIENT_CLASSNAME, инфо);
			if(!первОкПроцМдиКлиента)
				_unableToInit(MDICLIENT_CLASSNAME);
			стильКлассаМдиКлиент = инфо.ко.стиль;
		}c
	}


	проц _initRichTextbox()
	{
		if(!первОкПроцРичТекстБокса)
		{
			if(!укМодРичТекстБокс)
			{
				укМодРичТекстБокс = LoadLibraryA("riched20.dll");
				if(!укМодРичТекстБокс)
					throw new ВизИскл("Не удалось загрузить 'riched20.dll'");
			}

			Ткст classname;
			if(использоватьЮникод)
				classname = "RichEdit20W";
			else
				classname = "RichEdit20A";

			КлассОкна инфо;
			первОкПроцРичТекстБокса = суперКласс(экз.init, classname, RICHTEXTBOX_CLASSNAME, инфо);
			if(!первОкПроцРичТекстБокса)
				_unableToInit(RICHTEXTBOX_CLASSNAME);
			стильКлассаРичТекстБокс = инфо.ко.стиль;
		}
	}


	проц _initCombobox()
	{
		if(!первОкПроцКомбоБокса)
		{
			КлассОкна инфо;
			первОкПроцКомбоБокса = суперКласс(экз.init, "COMBOBOX", COMBOBOX_CLASSNAME, инфо);
			if(!первОкПроцКомбоБокса)
				_unableToInit(COMBOBOX_CLASSNAME);
			стильКлассаКомбоБокс = инфо.ко.стиль;
		}
	}


	проц _initTreeview()
	{
		if(!первОкПроцТривью)
		{
			_initCommonControls(ICC_TREEVIEW_CLASSES);

			КлассОкна инфо;
			первОкПроцТривью = суперКласс(экз.init, "SysTreeView32", TREEVIEW_CLASSNAME, инфо);
			if(!первОкПроцТривью)
				_unableToInit(TREEVIEW_CLASSNAME);
			стильКлассаТривью = инфо.ко.стиль;
		}
	}


	проц _initTabcontrol()
	{
		if(!первОкПроцТабконтрола)
		{
			_initCommonControls(ICC_TAB_CLASSES);

			КлассОкна инфо;
			первОкПроцТабконтрола = суперКласс(экз.init, "SysTabControl32", TABКОНТРОЛ_CLASSNAME, инфо);
			if(!первОкПроцТабконтрола)
				_unableToInit(TABКОНТРОЛ_CLASSNAME);
			стильКлассаТабконтрол = инфо.ко.стиль;
		}
	}


	проц _initListview()
	{
		if(!первОкПроцЛиствью)
		{
			_initCommonControls(ICC_LISTVIEW_CLASSES);

			КлассОкна инфо;
			первОкПроцЛиствью = суперКласс(экз.init, "SysListView32", LISTVIEW_CLASSNAME, инфо);
			if(!первОкПроцЛиствью)
				_unableToInit(LISTVIEW_CLASSNAME);
			стильКлассаЛиствью = инфо.ко.стиль;
		}
	}


	проц _initStatusbar()
	{
		if(!первОкПроцСтатусбара)
		{
			_initCommonControls(ICC_WIN95_CLASSES);

			КлассОкна инфо;
			первОкПроцСтатусбара = суперКласс(экз.init, "msctls_statusbar32", STATUSBAR_CLASSNAME, инфо);
			if(!первОкПроцСтатусбара)
				_unableToInit(STATUSBAR_CLASSNAME);
			стильКлассаСтатусбар = инфо.ко.стиль;
		}
	}


	проц _initProgressbar()
	{
		if(!первОкПроцПрогрессбара)
		{
			_initCommonControls(ICC_PROGRESS_CLASS);

			КлассОкна инфо;
			первОкПроцПрогрессбара = суперКласс(экз.init, "msctls_progress32", PROGRESSBAR_CLASSNAME, инфо);
			if(!первОкПроцПрогрессбара)
				_unableToInit(PROGRESSBAR_CLASSNAME);
			стильКлассаПрогрессбар = инфо.ко.стиль;
		}
	}
}


WNDPROC _superClass(экз hinst, Ткст имяКласса, Ткст newClassName, out WNDCLASSA getInfo) // deprecated
{
	WNDPROC окПроц;

	if(!GetClassInfoA(cast(HINST) hinst, cast(LPCSTR) небезопТкст0(имяКласса), &getInfo)) // TODO: юникод.
		throw new ВизИскл("Не удалось получить информацию об оконном классе '" ~ имяКласса ~ "'");

	окПроц = getInfo.lpfnWndProc;
	getInfo.lpfnWndProc = &vizWndProc;

	getInfo.style &= ~CS_GLOBALCLASS;
	getInfo.hCursor = УКурсор.init;
	getInfo.lpszClassName = небезопТкст0(newClassName);
	getInfo.hInstance = cast(HINSTANCE) Приложение.дайЭкз();

	if(!RegisterClassA(&getInfo)) // TODO: юникод.
		//throw new ВизИскл("Unable to register окно class '" ~ newClassName ~ "'");
		return пусто;
	return окПроц;
}


/*export*/

// Returns the old окПроц.
// This is the old, unsafe, юникод-unfriendly function for superclassing.
deprecated WNDPROC суперКласс(экз hinst, Ткст имяКласса, Ткст newClassName, out WNDCLASSA getInfo) // package
{
	return _superClass(hinst, имяКласса, newClassName, getInfo);
}


deprecated WNDPROC суперКласс(экз hinst, Ткст имяКласса, Ткст newClassName) // package
{
	WNDCLASSA инфо;
	return _superClass(hinst, имяКласса, newClassName, инфо);
}


// Returns the old окПроц.
WNDPROC суперКласс(экз hinst, Ткст имяКласса, Ткст newClassName, out КлассОкна getInfo) // package
{
	WNDPROC окПроц;

	if(!дайИнфОКлассе(hinst, имяКласса, getInfo))
		throw new ВизИскл("Не удалось получить информацию об оконном классе '" ~ имяКласса ~ "'");

	окПроц = getInfo.ко.lpfnWndProc;
	getInfo.ко.lpfnWndProc = &vizWndProc;

	getInfo.ко.стиль &= ~CS_GLOBALCLASS;
	getInfo.ко.hCursor = УКурсор.init;
	getInfo.имяКласса = newClassName;
	getInfo.ко.hInstance = cast(HINSTANCE) Приложение.дайЭкз();

	if(!зарегистрируйКласс(getInfo))
		//throw new ВизИскл("Unable to register окно class '" ~ newClassName ~ "'");
		return пусто;
	return окПроц;
}

