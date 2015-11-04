//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.fontdialog;

private import viz.base, viz.commondialog, viz.x.winapi, viz.app,
	viz.control, viz.drawing, viz.event, viz.x.utf,
	viz.x.dlib;


private extern(Windows)
{
	alias BOOL function(LPCHOOSEFONTW lpcf) ChooseFontWProc;
}


class FontDialog: ОбщийДиалог
{
	this()
	{
		Приложение.ppin(cast(проц*)this);
		
		cf.lStructSize = cf.sizeof;
		cf.Flags = INIT_FLAGS;
		cf.lpLogFont = cast(typeof(cf.lpLogFont))&шлш;
		cf.lCustData = cast(typeof(cf.lCustData))cast(проц*)this;
		cf.lpfnHook = &fondHookProc;
		cf.rgbColors = 0;
	}
	
	
	override проц сброс()
	{
		_fon = пусто;
		cf.Flags = INIT_FLAGS;
		cf.rgbColors = 0;
		cf.nSizeMin = 0;
		cf.nSizeMax = 0;
	}
	
	
		final проц allowSimulations(бул подтвержд) // setter
	{
		if(подтвержд)
			cf.Flags &= ~CF_NOSIMULATIONS;
		else
			cf.Flags |= CF_NOSIMULATIONS;
	}
	
	
	final бул allowSimulations() // getter
	{
		if(cf.Flags & CF_NOSIMULATIONS)
			return нет;
		return да;
	}
	
	
		final проц allowVectorFonts(бул подтвержд) // setter
	{
		if(подтвержд)
			cf.Flags &= ~CF_NOVECTORFONTS;
		else
			cf.Flags |= CF_NOVECTORFONTS;
	}
	
	
	final бул allowVectorFonts() // getter
	{
		if(cf.Flags & CF_NOVECTORFONTS)
			return нет;
		return да;
	}
	
	
		final проц allowVerticalFonts(бул подтвержд) // setter
	{
		if(подтвержд)
			cf.Flags &= ~CF_NOVERTFONTS;
		else
			cf.Flags |= CF_NOVERTFONTS;
	}
	
	
	final бул allowVerticalFonts() // getter
	{
		if(cf.Flags & CF_NOVERTFONTS)
			return нет;
		return да;
	}
	
	
		final проц цвет(Цвет ктрл) // setter
	{
		cf.rgbColors = ктрл.вКзс();
	}
	
	
	final Цвет цвет() // getter
	{
		return Цвет.изКзс(cf.rgbColors);
	}
	
	
		final проц fixedPitchOnly(бул подтвержд) // setter
	{
		if(подтвержд)
			cf.Flags |= CF_FIXEDPITCHONLY;
		else
			cf.Flags &= ~CF_FIXEDPITCHONLY;
	}
	
	
	final бул fixedPitchOnly() // getter
	{
		if(cf.Flags & CF_FIXEDPITCHONLY)
			return да;
		return нет;
	}
	
	
		final проц шрифт(Шрифт f) // setter
	{
		_fon = f;
	}
	
	
	final Шрифт шрифт() // getter
	{
		if(!_fon)
			_fon = УпрЭлт.дефШрифт; // ?
		return _fon;
	}
	
	
		final проц fontMustExist(бул подтвержд) // setter
	{
		if(подтвержд)
			cf.Flags |= CF_FORCEFONTEXIST;
		else
			cf.Flags &= ~CF_FORCEFONTEXIST;
	}
	
	
	final бул fontMustExist() // getter
	{
		if(cf.Flags & CF_FORCEFONTEXIST)
			return да;
		return нет;
	}
	
	
		final проц maxSize(цел max) // setter
	{
		if(max > 0)
		{
			if(max > cf.nSizeMin)
				cf.nSizeMax = max;
			cf.Flags |= CF_LIMITSIZE;
		}
		else
		{
			cf.Flags &= ~CF_LIMITSIZE;
			cf.nSizeMax = 0;
			cf.nSizeMin = 0;
		}
	}
	
	
	final цел maxSize() // getter
	{
		if(cf.Flags & CF_LIMITSIZE)
			return cf.nSizeMax;
		return 0;
	}
	
	
		final проц minSize(цел min) // setter
	{
		if(min > cf.nSizeMax)
			cf.nSizeMax = min;
		cf.nSizeMin = min;
		cf.Flags |= CF_LIMITSIZE;
	}
	
	
	final цел minSize() // getter
	{
		if(cf.Flags & CF_LIMITSIZE)
			return cf.nSizeMin;
		return 0;
	}
	
	
		final проц scriptsOnly(бул подтвержд) // setter
	{
		if(подтвержд)
			cf.Flags |= CF_SCRIPTSONLY;
		else
			cf.Flags &= ~CF_SCRIPTSONLY;
	}
	
	
	final бул scriptsOnly() // getter
	{
		if(cf.Flags & CF_SCRIPTSONLY)
			return да;
		return нет;
	}
	
	
		final проц showApply(бул подтвержд) // setter
	{
		if(подтвержд)
			cf.Flags |= CF_APPLY;
		else
			cf.Flags &= ~CF_APPLY;
	}
	
	
	final бул showApply() // getter
	{
		if(cf.Flags & CF_APPLY)
			return да;
		return нет;
	}
	
	
		final проц покажиСправку(бул подтвержд) // setter
	{
		if(подтвержд)
			cf.Flags |= CF_SHOWHELP;
		else
			cf.Flags &= ~CF_SHOWHELP;
	}
	
	
	final бул покажиСправку() // getter
	{
		if(cf.Flags & CF_SHOWHELP)
			return да;
		return нет;
	}
	
	
		final проц showEffects(бул подтвержд) // setter
	{
		if(подтвержд)
			cf.Flags |= CF_EFFECTS;
		else
			cf.Flags &= ~CF_EFFECTS;
	}
	
	
	final бул showEffects() // getter
	{
		if(cf.Flags & CF_EFFECTS)
			return да;
		return нет;
	}
	
	
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
	
	
		СобОбработчик apply;
	
	
	protected override LRESULT hookProc(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		switch(сооб)
		{
			case WM_COMMAND:
				switch(LOWORD(wparam))
				{
					case CF_APPLY: // ?
						_update();
						onApply(АргиСоб.пуст);
						break;
					
					default: ;
				}
				break;
			
			default: ;
		}
		
		return super.hookProc(уок, сооб, wparam, lparam);
	}
	
	
	protected override бул запустиДиалог(УОК хозяин)
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
		BOOL результат = FALSE;
		
		cf.hwndOwner = хозяин;
		
		if(viz.x.utf.использоватьЮникод)
		{
			шрифт._info(&шлш); // -шрифт- gets default шрифт if not установи.
			
			const Ткст ИМЯ = "ChooseFontW";
			static ChooseFontWProc proc = пусто;
			
			if(!proc)
			{
				proc = cast(ChooseFontWProc)GetProcAddress(GetModuleHandleA("comdlg32.dll"), ИМЯ.ptr);
				if(!proc)
					throw new Exception("Unable to загрузка procedure " ~ ИМЯ ~ ".");
			}
			
			результат = proc(&cfw);
		}
		else
		{
			шрифт._info(&шла); // -шрифт- gets default шрифт if not установи.
			
			результат = ChooseFontA(&cfa);
		}
		
		if(результат)
		{
			_update();
			return результат;
		}
		return FALSE;
	}
	
	
	private проц _update()
	{
		ШрифтЛога шл;
		
		if(viz.x.utf.использоватьЮникод)
			Шрифт.LOGFONTWtoLogFont(шл, &шлш);
		else
			Шрифт.LOGFONTAtoLogFont(шл, &шла);
		
		_fon = new Шрифт(Шрифт._create(шл), да);
	}
	
	
		protected проц onApply(АргиСоб ea)
	{
		apply(this, ea);
	}
	
	
	private:
	
	union
	{
		CHOOSEFONTW cfw;
		CHOOSEFONTA cfa;
		alias cfw cf;
		
		static assert(CHOOSEFONTW.sizeof == CHOOSEFONTA.sizeof);
		static assert(CHOOSEFONTW.Flags.offsetof == CHOOSEFONTA.Flags.offsetof);
		static assert(CHOOSEFONTW.nSizeMax.offsetof == CHOOSEFONTA.nSizeMax.offsetof);
	}
	
	union
	{
		LOGFONTW шлш;
		LOGFONTA шла;
		
		static assert(LOGFONTW.lfFaceName.offsetof == LOGFONTA.lfFaceName.offsetof);
	}
	
	Шрифт _fon;
	
	
	const UINT INIT_FLAGS = CF_EFFECTS | CF_ENABLEHOOK | CF_INITTOLOGFONTSTRUCT | CF_SCREENFONTS;
}


// WM_CHOOSEFONT_SETFLAGS to обнови флаги after dialog creation ... ?


private extern(Windows) UINT fondHookProc(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	const Ткст PROP_STR = "VIZ_FontDialog";
	FontDialog fd;
	LRESULT результат = 0;
	
	try
	{
		if(сооб == WM_INITDIALOG)
		{
			CHOOSEFONTA* cf;
			cf = cast(CHOOSEFONTA*)lparam;
			SetPropA(уок, PROP_STR.ptr, cast(HANDLE)cf.lCustData);
			fd = cast(FontDialog)cast(проц*)cf.lCustData;
		}
		else
		{
			fd = cast(FontDialog)cast(проц*)GetPropA(уок, PROP_STR.ptr);
		}
		
		if(fd)
		{
			результат = fd.hookProc(уок, сооб, wparam, lparam);
		}
	}
	catch(Объект e)
	{
		Приложение.приИсклНити(e);
	}
	
	return результат;
}

