//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.folderdialog;

private import viz.x.dlib, stdrus;

private import viz.commondialog, viz.base, viz.x.winapi, viz.x.wincom;
private import viz.x.utf, viz.app;


private extern(Windows)
{
	alias LPITEMIDLIST function(LPBROWSEINFOW lpbi) SHBrowseForFolderWProc;
	alias BOOL function(LPCITEMIDLIST pidl, LPWSTR pszPath) SHGetPathFromIDListWProc;
}


class FolderBrowserDialog: ОбщийДиалог // docmain
{
	this()
	{
		// Flag BIF_NEWDIALOGSTYLE requires OleInitialize().
		//OleInitialize(пусто);
		
		Приложение.ppin(cast(проц*)this);
		
		bi.ulFlags = INIT_FLAGS;
		bi.парам2 = cast(typeof(bi.парам2))cast(проц*)this;
		bi.lpfn = &fbdHookProc;
	}
	
	
	~this()
	{
		//OleUninitialize();
	}
	
	
	override ПРезДиалога покажиДиалог()
	{
		if(!запустиДиалог(GetActiveWindow()))
			return ПРезДиалога.ОТМЕНА;
		return ПРезДиалога.ОК;
	}
	
	
	override ПРезДиалога покажиДиалог(ИОкно хозяин)
	{
		if(!запустиДиалог(хозяин ? хозяин.указатель : GetActiveWindow()))
			return ПРезДиалога.ОТМЕНА;
		return ПРезДиалога.ОК;
	}
	
	
	override проц сброс()
	{
		bi.ulFlags = INIT_FLAGS;
		_desc = пусто;
		_selpath = пусто;
	}
	
	
		final проц description(Ткст desc) // setter
	{
		// lpszTitle
		
		_desc = desc;
	}
	
	
	final Ткст description() // getter
	{
		return _desc;
	}
	
	
		final проц selectedPath(Ткст selpath) // setter
	{
		// pszDisplayName
		
		_selpath = selpath;
	}
	
	
	final Ткст selectedPath() // getter
	{
		return _selpath;
	}
	
	
	// 	// Currently only works for shell32.dll version 6.0+.
	final проц showNewFolderButton(бул подтвержд) // setter
	{
		// BIF_NONEWFOLDERBUTTON exists with shell 6.0+.
		// Might need to enum child windows looking for окно заглавие
		// "&New Folder" and скрой it, then шифт "ОК" and "Cancel" over.
		
		if(подтвержд)
			bi.ulFlags &= ~BIF_NONEWFOLDERBUTTON;
		else
			bi.ulFlags |= BIF_NONEWFOLDERBUTTON;
	}
	
	// 
	final бул showNewFolderButton() // getter
	{
		return (bi.ulFlags & BIF_NONEWFOLDERBUTTON) == 0;
	}
	
	
	private проц _errPathTooLong()
	{
		throw new ВизИскл("Path имя is too long");
	}
	
	
	private проц _errNoGetPath()
	{
		throw new ВизИскл("Unable to obtain path");
	}
	
	
	private проц _errNoShMalloc()
	{
		throw new ВизИскл("Unable to get shell memory allocator");
	}
	
	
	protected override бул запустиДиалог(УОК хозяин)
	{
		IMalloc shmalloc;
		
		bi.hwndOwner = хозяин;
		
		// Using размер of wchar so that the buffer works for ansi and юникод.
		//ук pdescz = alloca(wchar.sizeof * МАКС_ПУТЬ);
		//if(!pdescz)
		//	throw new ВизИскл("Вне памяти"); // Stack overflow ?
		//wchar[МАКС_ПУТЬ] pdescz = void;
		wchar[МАКС_ПУТЬ] pdescz; // Initialize because SHBrowseForFolder() is модальное.
		
		if(viz.x.utf.использоватьЮникод)
		{
			const Ткст BROWSE_NAME = "SHBrowseForFolderW";
			const Ткст PATH_NAME = "SHGetPathFromIDListW";
			static SHBrowseForFolderWProc browseproc = пусто;
			static SHGetPathFromIDListWProc pathproc = пусто;
			
			if(!browseproc)
			{
				HMODULE hmod;
				hmod = GetModuleHandleA("shell32.dll");
				
				browseproc = cast(SHBrowseForFolderWProc)GetProcAddress(hmod, BROWSE_NAME.ptr);
				if(!browseproc)
					throw new Exception("Unable to загрузка procedure " ~ BROWSE_NAME);
				
				pathproc = cast(SHGetPathFromIDListWProc)GetProcAddress(hmod, PATH_NAME.ptr);
				if(!pathproc)
					throw new Exception("Unable to загрузка procedure " ~ PATH_NAME);
			}
			
			biw.lpszTitle = viz.x.utf.вЮни0(_desc);
			
			biw.pszDisplayName = cast(шткст0)pdescz;
			if(_desc.length)
			{
				Шткст tmp;
				tmp = viz.x.utf.вЮни(_desc);
				if(tmp.length >= МАКС_ПУТЬ)
					_errPathTooLong();
				biw.pszDisplayName[0 .. tmp.length] = tmp;
				biw.pszDisplayName[tmp.length] = 0;
			}
			else
			{
				biw.pszDisplayName[0] = 0;
			}
			
			// покажи the dialog!
			LPITEMIDLIST результат;
			результат = browseproc(&biw);
			
			if(!результат)
			{
				biw.lpszTitle = пусто;
				return нет;
			}
			
			if(NOERROR != SHGetMalloc(&shmalloc))
				_errNoShMalloc();
			
			//шткст0 wbuf = cast(шткст0)alloca(wchar.sizeof * МАКС_ПУТЬ);
			wchar[МАКС_ПУТЬ] wbuf = void;
			if(!pathproc(результат, wbuf.ptr))
			{
				shmalloc.Free(результат);
				shmalloc.Release();
				_errNoGetPath();
				assert(0);
			}
			
			_selpath = viz.x.utf.изЮникода0(wbuf.ptr); // Assumes изЮникода0() copies.
			
			shmalloc.Free(результат);
			shmalloc.Release();
			
			biw.lpszTitle = пусто;
		}
		else
		{
			bia.lpszTitle = viz.x.utf.вАнзи0(_desc);
			
			bia.pszDisplayName = cast(ткст0)pdescz;
			if(_desc.length)
			{
				Ткст tmp; // ansi.
				tmp = viz.x.utf.вАнзи(_desc);
				if(tmp.length >= МАКС_ПУТЬ)
					_errPathTooLong();
				bia.pszDisplayName[0 .. tmp.length] = tmp;
				bia.pszDisplayName[tmp.length] = 0;
			}
			else
			{
				bia.pszDisplayName[0] = 0;
			}
			
			// покажи the dialog!
			LPITEMIDLIST результат;
			результат = SHBrowseForFolderA(&bia);
			
			if(!результат)
			{
				bia.lpszTitle = пусто;
				return нет;
			}
			
			if(NOERROR != SHGetMalloc(&shmalloc))
				_errNoShMalloc();
			
			//ткст0 abuf = cast(ткст0)alloca(сим.sizeof * МАКС_ПУТЬ);
			сим[МАКС_ПУТЬ] abuf = void;
			if(!SHGetPathFromIDListA(результат, abuf.ptr))
			{
				shmalloc.Free(результат);
				shmalloc.Release();
				_errNoGetPath();
				assert(0);
			}
			
			_selpath = viz.x.utf.изАнзи0(abuf.ptr); // Assumes изАнзи0() copies.
			
			shmalloc.Free(результат);
			shmalloc.Release();
			
			bia.lpszTitle = пусто;
		}
		
		return да;
	}
	
	
	protected:
	
	/+
	override LRESULT hookProc(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		switch(сооб)
		{
			case WM_NOTIFY:
				{
					NMHDR* nmhdr;
					nmhdr = cast(NMHDR*)lparam;
					switch(nmhdr.code)
					{
						/+
						case CDN_FILEOK:
							break;
						+/
						
						default: ;
					}
				}
				break;
			
			default: ;
		}
		
		return super.hookProc(уок, сооб, wparam, lparam);
	}
	+/
	
	
	private:
	
	union
	{
		BROWSEINFOW biw;
		BROWSEINFOA bia;
		alias biw bi;
		
		static assert(BROWSEINFOW.sizeof == BROWSEINFOA.sizeof);
		static assert(BROWSEINFOW.ulFlags.offsetof == BROWSEINFOA.ulFlags.offsetof);
	}
	
	Ткст _desc;
	Ткст _selpath;
	
	
	const UINT INIT_FLAGS = BIF_RETURNONLYFSDIRS | BIF_NEWDIALOGSTYLE;
}


private:

private extern(Windows) цел fbdHookProc(УОК уок, UINT сооб, LPARAM lparam, LPARAM lpData)
{
	FolderBrowserDialog fd;
	цел результат = 0;
	
	try
	{
		fd = cast(FolderBrowserDialog)cast(проц*)lpData;
		if(fd)
		{
			Ткст s;
			switch(сооб)
			{
				case BFFM_INITIALIZED:
					s = fd.selectedPath;
					if(s.length)
					{
						if(viz.x.utf.использоватьЮникод)
							SendMessageA(уок, BFFM_SETSELECTIONW, TRUE, cast(LPARAM)viz.x.utf.вЮни0(s));
						else
							SendMessageA(уок, BFFM_SETSELECTIONA, TRUE, cast(LPARAM)viz.x.utf.вАнзи0(s));
					}
					break;
				
				default: ;
			}
		}
	}
	catch(Объект e)
	{
		Приложение.приИсклНити(e);
	}
	
	return результат;
}

