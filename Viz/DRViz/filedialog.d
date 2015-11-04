//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.filedialog;

private import viz.x.dlib;

private import viz.control, viz.x.winapi, viz.base, viz.drawing;
private import viz.app, viz.commondialog, viz.event, viz.x.utf;


export extern(D) abstract class Файлвыбор: ОбщийДиалог // docmain
{
	private this()
	{
		Приложение.ppin(cast(проц*)this);
		
		ofn.lStructSize = ofn.sizeof;
		ofn.lCustData = cast(typeof(ofn.lCustData))cast(проц*)this;
		ofn.Flags = INIT_FLAGS;
		ofn.nFilterIndex = INIT_FILTER_INDEX;
		иницЭкз();
		ofn.lpfnHook = cast(typeof(ofn.lpfnHook))&ofnHookProc;
	}
	
	export:
	
	override ПРезДиалога покажиДиалог()
	{
		return запустиДиалог(GetActiveWindow()) ?
			ПРезДиалога.ОК : ПРезДиалога.ОТМЕНА;
	}
	
	override ПРезДиалога покажиДиалог(ИОкно хозяин)
	{
		return запустиДиалог(хозяин ? хозяин.указатель : GetActiveWindow()) ?
			ПРезДиалога.ОК : ПРезДиалога.ОТМЕНА;
	}
	
	
	override проц сброс()
	{
		ofn.Flags = INIT_FLAGS;
		ofn.lpstrFilter = пусто;
		ofn.nFilterIndex = INIT_FILTER_INDEX;
		ofn.lpstrDefExt = пусто;
		_defext = пусто;
		_fileNames = пусто;
		needRebuildFiles = нет;
		_filter = пусто;
		ofn.lpstrInitialDir = пусто;
		_initDir = пусто;
		ofn.lpstrTitle = пусто;
		_title = пусто;
		иницЭкз();
	}
	
	
	private проц иницЭкз()
	{
		//ofn.hInstance = ?; // Should this be initialized?
	}
	
	
	/+
	final проц addExtension(бул подтвержд) // setter
	{
		addext = подтвержд;
	}
	
	
	final бул addExtension() // getter
	{
		return addext;
	}
	+/
	
	
		проц проверьФайлЕсть(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags |= OFN_FILEMUSTEXIST;
		else
			ofn.Flags &= ~OFN_FILEMUSTEXIST;
	}
	
	
	бул проверьФайлЕсть() // getter
	{
		return (ofn.Flags & OFN_FILEMUSTEXIST) != 0;
	}
	
	
		final проц проверьПутьЕсть(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags |= OFN_PATHMUSTEXIST;
		else
			ofn.Flags &= ~OFN_PATHMUSTEXIST;
	}
	
	
	final бул проверьПутьЕсть() // getter
	{
		return (ofn.Flags & OFN_PATHMUSTEXIST) != 0;
	}
	
	
		final проц дефРасш(Ткст ext) // setter
	{
		if(!ext.length)
		{
			ofn.lpstrDefExt = пусто;
			_defext = пусто;
		}
		else
		{
			if(ext.length && ext[0] == '.')
				ext = ext[1 .. ext.length];
			
			if(viz.x.utf.использоватьЮникод)
			{
				ofnw.lpstrDefExt = viz.x.utf.вЮни0(ext);
			}
			else
			{
				ofna.lpstrDefExt = viz.x.utf.вАнзи0(ext);
			}
			_defext = ext;
		}
	}
	
	
	final Ткст дефРасш() // getter
	{
		return _defext;
	}
	
	
		final проц dereferenceLinks(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags &= ~OFN_NODEREFERENCELINKS;
		else
			ofn.Flags |= OFN_NODEREFERENCELINKS;
	}
	
	
	final бул dereferenceLinks() // getter
	{
		return (ofn.Flags & OFN_NODEREFERENCELINKS) == 0;
	}
	
	
		final проц фимя(Ткст fn) // setter
	{
		// TODO: check if correct implementation.
		
		if(fn.length > МАКС_ПУТЬ)
			throw new ВизИскл("Неверное имя файла");
		
		if(фимена.length)
		{
			_fileNames = (&fn)[0 .. 1] ~ _fileNames[1 .. _fileNames.length];
		}
		else
		{
			_fileNames = new Ткст[1];
			_fileNames[0] = fn;
		}
	}
	
	
	final Ткст фимя() // getter
	{
		if(фимена.length)
			return фимена[0];
		return пусто;
	}
	
	
		final Ткст[] фимена() // getter
	{
		if(needRebuildFiles)
			заполниФайлы();
		
		return _fileNames;
	}
	
	
		// The format string is like "Text files (*.txt)|*.txt|All files (*.*)|*.*".
	final проц фильтр(Ткст filterString) // setter
	{
		if(!filterString.length)
		{
			ofn.lpstrFilter = пусто;
			_filter = пусто;
		}
		else
		{
			struct _Str
			{
				union
				{
					wchar[] sw;
					сим[] sa;
				}
			}
			_Str str;
			
			т_мера i, стартi;
			т_мера nitems = 0;
			
			if(viz.x.utf.использоватьЮникод)
			{
				str.sw = new wchar[filterString.length + 2];
				str.sw = str.sw[0 .. 0];
			}
			else
			{
				str.sa = new сим[filterString.length + 2];
				str.sa = str.sa[0 .. 0];
			}
			
			
			for(i = стартi = 0; i != filterString.length; i++)
			{
				switch(filterString[i])
				{
					case '|':
						if(стартi == i)
							goto bad_filter;
						
						if(viz.x.utf.использоватьЮникод)
						{
							str.sw ~= viz.x.utf.вЮни(filterString[стартi .. i]);
							str.sw ~= "\0";
						}
						else
						{
							str.sa ~= viz.x.utf.небезопАнзи(filterString[стартi .. i]);
							str.sa ~= "\0";
						}
						
						стартi = i + 1;
						nitems++;
						break;
					
					case 0:
					case '\r', '\n':
						goto bad_filter;
					
					default: ;
				}
			}
			if(стартi == i || !(nitems % 2))
				goto bad_filter;
			if(viz.x.utf.использоватьЮникод)
			{
				str.sw ~= viz.x.utf.вЮни(filterString[стартi .. i]);
				str.sw ~= "\0\0";
				
				ofnw.lpstrFilter = str.sw.ptr;
			}
			else
			{
				str.sa ~= viz.x.utf.небезопАнзи(filterString[стартi .. i]);
				str.sa ~= "\0\0";
				
				ofna.lpstrFilter = str.sa.ptr;
			}
			
			_filter = filterString;
			return;
			
			bad_filter:
			throw new ВизИскл("Неправильная строка файл-фильтра");
		}
	}
	
	
	final Ткст фильтр() // getter
	{
		return _filter;
	}
	
	
		// Note: индекс is 1-based.
	final проц индексФильтра(цел индекс) // setter
	{
		ofn.nFilterIndex = (индекс > 0) ? индекс : 1;
	}
	
	
	final цел индексФильтра() // getter
	{
		return ofn.nFilterIndex;
	}
	
	
		final проц начальнаяПапка(Ткст dir) // setter
	{
		if(!dir.length)
		{
			ofn.lpstrInitialDir = пусто;
			_initDir = пусто;
		}
		else
		{
			if(viz.x.utf.использоватьЮникод)
			{
				ofnw.lpstrInitialDir = viz.x.utf.вЮни0(dir);
			}
			else
			{
				ofna.lpstrInitialDir = viz.x.utf.вАнзи0(dir);
			}
			_initDir = dir;
		}
	}
	
	
	final Ткст начальнаяПапка() // getter
	{
		return _initDir;
	}
	
	
	// Should be instance(), but conflicts with D's old keyword.
	
		protected проц экземп(экз hinst) // setter
	{
		ofn.hInstance = hinst;
	}
	
	
	protected экз экземп() // getter
	{
		return ofn.hInstance;
	}
	
	
		protected DWORD options() // getter
	{
		return ofn.Flags;
	}
	
	
		final проц восстановиПапку(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags |= OFN_NOCHANGEDIR;
		else
			ofn.Flags &= ~OFN_NOCHANGEDIR;
	}
	
	
	final бул восстановиПапку() // getter
	{
		return (ofn.Flags & OFN_NOCHANGEDIR) != 0;
	}
	
	
		final проц покажиСправку(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags |= OFN_SHOWHELP;
		else
			ofn.Flags &= ~OFN_SHOWHELP;
	}
	
	
	final бул покажиСправку() // getter
	{
		return (ofn.Flags & OFN_SHOWHELP) != 0;
	}
	
	
		final проц заглавие(Ткст newTitle) // setter
	{
		if(!newTitle.length)
		{
			ofn.lpstrTitle = пусто;
			_title = пусто;
		}
		else
		{
			if(viz.x.utf.использоватьЮникод)
			{
				ofnw.lpstrTitle = viz.x.utf.вЮни0(newTitle);
			}
			else
			{
				ofna.lpstrTitle = viz.x.utf.вАнзи0(newTitle);
			}
			_title = newTitle;
		}
	}
	
	
	final Ткст заглавие() // getter
	{
		return _title;
	}
	
	
		final проц оцениИмена(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags &= ~OFN_NOVALIDATE;
		else
			ofn.Flags |= OFN_NOVALIDATE;
	}
	
	
	final бул оцениИмена() // getter
	{
		return(ofn.Flags & OFN_NOVALIDATE) == 0;
	}
	
	
		Событие!(Файлвыбор, АргиСобОтмены) fileOk;
	
	
	protected:
	
	override бул запустиДиалог(УОК хозяин)
	{
		assert(0);
		return нет;
	}
	
	
		проц приФайлОк(АргиСобОтмены ea)
	{
		fileOk(this, ea);
	}
	
	
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
						case CDN_FILEOK:
							{
								АргиСобОтмены cea;
								cea = new АргиСобОтмены;
								приФайлОк(cea);
								if(cea.отмена)
								{
									SetWindowLongA(уок, DWL_MSGRESULT, 1);
									return 1;
								}
							}
							break;
						
						default: ;
							//эхо("   nmhdr.code = %d/0x%X\n", nmhdr.code, nmhdr.code);
					}
				}
				break;
			
			default: ;
		}
		
		return super.hookProc(уок, сооб, wparam, lparam);
	}
	
	
	private:
	union
	{
		OPENFILENAMEW ofnw;
		OPENFILENAMEA ofna;
		alias ofnw ofn;
		
		static assert(OPENFILENAMEW.sizeof == OPENFILENAMEA.sizeof);
		static assert(OPENFILENAMEW.Flags.offsetof == OPENFILENAMEA.Flags.offsetof);
	}
	Ткст[] _fileNames;
	Ткст _filter;
	Ткст _initDir;
	Ткст _defext;
	Ткст _title;
	//бул addext = да;
	бул needRebuildFiles = нет;
	
	const DWORD INIT_FLAGS = OFN_EXPLORER | OFN_PATHMUSTEXIST | OFN_HIDEREADONLY |
		OFN_ENABLEHOOK | OFN_ENABLESIZING;
	const цел INIT_FILTER_INDEX = 0;
	const цел FILE_BUF_LEN = 4096; // ? 12288 ? 12800 ?
	
	
	проц beginOfn(УОК хозяин)
	{
		if(viz.x.utf.использоватьЮникод)
		{
			auto buf = new wchar[(ofn.Flags & OFN_ALLOWMULTISELECT) ? FILE_BUF_LEN : МАКС_ПУТЬ];
			buf[0] = 0;
			
			if(фимена.length)
			{
				Шткст ts;
				ts = viz.x.utf.вЮни(_fileNames[0]);
				buf[0 .. ts.length] = ts;
				buf[ts.length] = 0;
			}
			
			ofnw.nMaxFile = buf.length;
			ofnw.lpstrFile = buf.ptr;
		}
		else
		{
			auto buf = new сим[(ofn.Flags & OFN_ALLOWMULTISELECT) ? FILE_BUF_LEN : МАКС_ПУТЬ];
			buf[0] = 0;
			
			if(фимена.length)
			{
				Ткст ts;
				ts = viz.x.utf.небезопАнзи(_fileNames[0]);
				buf[0 .. ts.length] = ts;
				buf[ts.length] = 0;
			}
			
			ofna.nMaxFile = buf.length;
			ofna.lpstrFile = buf.ptr;
		}
		
		ofn.hwndOwner = хозяин;
	}
	
	
	// Populate -_fileNames- from -ofn.lpstrFile-.
	проц заполниФайлы()
	in
	{
		assert(ofn.lpstrFile !is пусто);
	}
	body
	{
		if(ofn.Flags & OFN_ALLOWMULTISELECT)
		{
			// Nonstandard reserve.
			_fileNames = new Ткст[4];
			_fileNames = _fileNames[0 .. 0];
			
			if(viz.x.utf.использоватьЮникод)
			{
				шткст0 стартp, p;
				p = стартp = ofnw.lpstrFile;
				for(;;)
				{
					if(!*p)
					{
						_fileNames ~= viz.x.utf.изЮникода(стартp, p - стартp); // dup later.
						
						p++;
						if(!*p)
							break;
						
						стартp = p;
						continue;
					}
					
					p++;
				}
			}
			else
			{
				ткст0 стартp, p;
				p = стартp = ofna.lpstrFile;
				for(;;)
				{
					if(!*p)
					{
						_fileNames ~= viz.x.utf.изАнзи(стартp, p - стартp); // dup later.
						
						p++;
						if(!*p)
							break;
						
						стартp = p;
						continue;
					}
					
					p++;
				}
			}
			
			assert(_fileNames.length);
			if(_fileNames.length == 1)
			{
				//_fileNames[0] = _fileNames[0].dup;
				//_fileNames[0] = _fileNames[0].idup; // Needed in D2. Doesn't work in D1.
				_fileNames[0] = cast(Ткст)_fileNames[0].dup; // Needed in D2.
			}
			else
			{
				Ткст s;
				т_мера i;
				s = _fileNames[0];
				
				// Not sure which of these 2 is better...
				/+
				for(i = 1; i != _fileNames.length; i++)
				{
					_fileNames[i - 1] = _объедини(s, _fileNames[i]);
				}
				_fileNames = _fileNames[0 .. _fileNames.length - 1];
				+/
				for(i = 1; i != _fileNames.length; i++)
				{
					_fileNames[i] = _объедини(s, _fileNames[i]);
				}
				_fileNames = _fileNames[1 .. _fileNames.length];
			}
		}
		else
		{
			_fileNames = new Ткст[1];
			if(viz.x.utf.использоватьЮникод)
			{
				_fileNames[0] = viz.x.utf.изЮникода0(ofnw.lpstrFile);
			}
			else
			{
				_fileNames[0] = viz.x.utf.изАнзи0(ofna.lpstrFile);
			}
			
			/+
			if(addext && проверьФайлЕсть() && ofn.nFilterIndex)
			{
				if(!ofn.nFileExtension || ofn.nFileExtension == _fileNames[0].length)
				{
					Ткст s;
					typeof(ofn.nFilterIndex) onidx;
					цел i;
					Ткст[] exts;
					
					s = _filter;
					onidx = ofn.nFilterIndex << 1;
					do
					{
						i = _найди(s, '|');
						if(i == -1)
							goto no_such_filter;
						
						s = s[i + 1 .. s.length];
						
						onidx--;
					}
					while(onidx != 1);
					
					i = _найди(s, '|');
					if(i != -1)
						s = s[0 .. i];
					
					exts = разбей(s, ";");
					foreach(Ткст ext; exts)
					{
						эхо("sel ext:  %.*s\n", ext);
					}
					
					// ...
					
					no_such_filter: ;
				}
			}
			+/
		}
		
		needRebuildFiles = нет;
	}
	
	
	// Call only if the dialog succeeded.
	проц finishOfn()
	{
		if(needRebuildFiles)
			заполниФайлы();
		
		ofn.lpstrFile = пусто;
	}
	
	
	// Call only if dialog fail or отмена.
	проц cancelOfn()
	{
		needRebuildFiles = нет;
		
		ofn.lpstrFile = пусто;
		_fileNames = пусто;
	}
}


private extern(Windows)
{
	alias BOOL function(LPOPENFILENAMEW lpofn) GetOpenFileNameWProc;
	alias BOOL function(LPOPENFILENAMEW lpofn) GetSaveFileNameWProc;
}


export extern(D) class ОткрФайлвыбор: Файлвыбор // docmain
{
export:
	this()
	{
		super();
		ofn.Flags |= OFN_FILEMUSTEXIST;
	}
	
	
	override проц сброс()
	{
		super.сброс();
		ofn.Flags |= OFN_FILEMUSTEXIST;
	}
	
	
		final проц мультивыбор(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags |= OFN_ALLOWMULTISELECT;
		else
			ofn.Flags &= ~OFN_ALLOWMULTISELECT;
	}
	
	
	final бул мультивыбор() // getter
	{
		return (ofn.Flags & OFN_ALLOWMULTISELECT) != 0;
	}
	
	
		final проц толькоЧтениеУст(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags |= OFN_READONLY;
		else
			ofn.Flags &= ~OFN_READONLY;
	}
	
	
	final бул толькоЧтениеУст() // getter
	{
		return (ofn.Flags & OFN_READONLY) != 0;
	}
	
	
		final проц показатьТолькоЧтение(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags &= ~OFN_HIDEREADONLY;
		else
			ofn.Flags |= OFN_HIDEREADONLY;
	}
	
	
	final бул показатьТолькоЧтение() // getter
	{
		return (ofn.Flags & OFN_HIDEREADONLY) == 0;
	}
	
	
	version(Tango)
	{
		// TO-DO: not implemented yet.
	}
	else
	{
		private import tpl.stream; // TO-DO: удали this import; use viz.x.dlib.
		
				final Поток откройФайл()
		{
			return new Файл(фимя(), ПФРежим.Ввод);
		}
	}
	
	
	protected:
	
	override бул запустиДиалог(УОК хозяин)
	{
		if(!_runDialog(хозяин))
		{
			if(!CommDlgExtendedError())
				return нет;
			_cantrun();
		}
		return да;
	}
	
	
	private BOOL _runDialog(УОК хозяин)
	{
		BOOL результат = 0;
		
		beginOfn(хозяин);
		
		if(viz.x.utf.использоватьЮникод)
		{
			const Ткст ИМЯ = "GetOpenFileNameW";
			static GetOpenFileNameWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetOpenFileNameWProc)GetProcAddress(GetModuleHandleA("comdlg32.dll"), ИМЯ.ptr);
				if(!proc)
					throw new Exception("Не удаётся загрузить процедуру " ~ ИМЯ ~ "");
			}
			
			результат = proc(&ofnw);
		}
		else
		{
			результат = GetOpenFileNameA(&ofna);
		}
		
		if(результат)
		{
			finishOfn();
			return результат;
		}
		
		cancelOfn();
		return результат;
	}
}


export extern(D)  class СохрФайлвыбор: Файлвыбор // docmain
{
export:

	this()
	{
		super();
		ofn.Flags |= OFN_OVERWRITEPROMPT;
	}
	
	
	override проц сброс()
	{
		super.сброс();
		ofn.Flags |= OFN_OVERWRITEPROMPT;
	}
	
	
		final проц создайПромпт(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags |= OFN_CREATEPROMPT;
		else
			ofn.Flags &= ~OFN_CREATEPROMPT;
	}
	
	
	final бул создайПромпт() // getter
	{
		return (ofn.Flags & OFN_CREATEPROMPT) != 0;
	}
	
	
		final проц перепишиПромпт(бул подтвержд) // setter
	{
		if(подтвержд)
			ofn.Flags |= OFN_OVERWRITEPROMPT;
		else
			ofn.Flags &= ~OFN_OVERWRITEPROMPT;
	}
	
	
	final бул перепишиПромпт() // getter
	{
		return (ofn.Flags & OFN_OVERWRITEPROMPT) != 0;
	}
	
	
	version(Tango)
	{
		// TO-DO: not implemented yet.
	}
	else
	{
		private import tpl.stream; // TO-DO: удали this import; use viz.x.dlib.
			
				// Opens and creates with read and write access.
		// Warning: if file exists, it's truncated.
		final Поток откройФайл()
		{
			return new Файл(фимя(), ПФРежим.ВыводНов | ПФРежим.Вывод | ПФРежим.Ввод);
		}
	}
	
	
	protected:
	
	override бул запустиДиалог(УОК хозяин)
	{
		beginOfn(хозяин);
		
		if(viz.x.utf.использоватьЮникод)
		{
			const Ткст ИМЯ = "GetSaveFileNameW";
			static GetSaveFileNameWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(GetSaveFileNameWProc)GetProcAddress(GetModuleHandleA("comdlg32.dll"), ИМЯ.ptr);
				if(!proc)
					throw new Exception("Не удаётся загрузить процедуру " ~ ИМЯ ~ "");
			}
			
			if(proc(&ofnw))
			{
				finishOfn();
				return да;
			}
		}
		else
		{
			if(GetSaveFileNameA(&ofna))
			{
				finishOfn();
				return да;
			}
		}
		
		cancelOfn();
		return нет;
	}
}


private extern(Windows) LRESULT ofnHookProc(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	alias viz.x.winapi.HANDLE HANDLE; // Otherwise, odd conflict with wine.
	
	const Ткст PROP_STR = "VIZ_FileDialog";
	Файлвыбор fd;
	LRESULT результат = 0;
	
	try
	{
		if(сооб == WM_INITDIALOG)
		{
			OPENFILENAMEA* ofn;
			ofn = cast(OPENFILENAMEA*)lparam;
			SetPropA(уок, PROP_STR.ptr, cast(HANDLE)ofn.lCustData);
			fd = cast(Файлвыбор)cast(проц*)ofn.lCustData;
		}
		else
		{
			fd = cast(Файлвыбор)cast(проц*)GetPropA(уок, PROP_STR.ptr);
		}
		
		//эхо("hook сооб(%d/0x%X) to объ %p\n", сооб, сооб, fd);
		if(fd)
		{
			fd.needRebuildFiles = да;
			результат = fd.hookProc(уок, сооб, wparam, lparam);
		}
	}
	catch(Объект e)
	{
		Приложение.приИсклНити(e);
	}
	
	return результат;
}

