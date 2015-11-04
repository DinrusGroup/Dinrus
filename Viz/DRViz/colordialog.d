//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.colordialog;

private import viz.commondialog, viz.base, viz.x.winapi, viz.x.wincom;
private import viz.x.utf, viz.app, viz.drawing;


class ColorDialog: ОбщийДиалог // docmain
{
	this()
	{
		Приложение.ppin(cast(проц*)this);
		
		cc.lStructSize = cc.sizeof;
		cc.Flags = INIT_FLAGS;
		cc.rgbResult = Цвет.пуст.вАкзс();
		cc.lCustData = cast(typeof(cc.lCustData))cast(проц*)this;
		cc.lpfnHook = cast(typeof(cc.lpfnHook))&ccHookProc;
		_initcust();
	}
	
	
		проц allowFullOpen(бул подтвержд) // setter
	{
		if(подтвержд)
			cc.Flags &= ~CC_PREVENTFULLOPEN;
		else
			cc.Flags |= CC_PREVENTFULLOPEN;
	}
	
	
	бул allowFullOpen() // getter
	{
		return (cc.Flags & CC_PREVENTFULLOPEN) != CC_PREVENTFULLOPEN;
	}
	
	
		проц anyColor(бул подтвержд) // setter
	{
		if(подтвержд)
			cc.Flags |= CC_ANYCOLOR;
		else
			cc.Flags &= ~CC_ANYCOLOR;
	}
	
	
	бул anyColor() // getter
	{
		return (cc.Flags & CC_ANYCOLOR) == CC_ANYCOLOR;
	}
	
	
		проц solidColorOnly(бул подтвержд) // setter
	{
		if(подтвержд)
			cc.Flags |= CC_SOLIDCOLOR;
		else
			cc.Flags &= ~CC_SOLIDCOLOR;
	}
	
	
	бул solidColorOnly() // getter
	{
		return (cc.Flags & CC_SOLIDCOLOR) == CC_SOLIDCOLOR;
	}
	
	
		final проц цвет(Цвет ктрл) // setter
	{
		cc.rgbResult = ктрл.вКзс();
	}
	
	
	final Цвет цвет() // getter
	{
		return Цвет.изКзс(cc.rgbResult);
	}
	
	
		final проц customColors(COLORREF[] colors) // setter
	{
		if(colors.length >= _cust.length)
			_cust[] = colors[0 .. _cust.length];
		else
			_cust[0 .. colors.length] = colors;
	}
	
	
	final COLORREF[] customColors() // getter
	{
		return _cust;
	}
	
	
		проц fullOpen(бул подтвержд) // setter
	{
		if(подтвержд)
			cc.Flags |= CC_FULLOPEN;
		else
			cc.Flags &= ~CC_FULLOPEN;
	}
	
	
	бул fullOpen() // getter
	{
		return (cc.Flags & CC_FULLOPEN) == CC_FULLOPEN;
	}
	
	
		проц покажиСправку(бул подтвержд) // setter
	{
		if(подтвержд)
			cc.Flags |= CC_SHOWHELP;
		else
			cc.Flags &= ~CC_SHOWHELP;
	}
	
	
	бул покажиСправку() // getter
	{
		return (cc.Flags & CC_SHOWHELP) == CC_SHOWHELP;
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
	
	
		override проц сброс()
	{
		cc.Flags = INIT_FLAGS;
		cc.rgbResult = Цвет.пуст.вАкзс();
		_initcust();
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
		if(cc.rgbResult == Цвет.пуст.вАкзс())
			cc.Flags &= ~CC_RGBINIT;
		else
			cc.Flags |= CC_RGBINIT;
		cc.hwndOwner = хозяин;
		cc.lpCustColors = _cust.ptr;
		return ChooseColorA(&cc);
	}
	
	
	private:
	const DWORD INIT_FLAGS = CC_ENABLEHOOK;
	
	CHOOSECOLORA cc;
	COLORREF[16] _cust;
	
	
	проц _initcust()
	{
		COLORREF cdef;
		cdef = Цвет(0xFF, 0xFF, 0xFF).вКзс();
		foreach(inout COLORREF cref; _cust)
		{
			cref = cdef;
		}
	}
}


private extern(Windows) UINT ccHookProc(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	const сим[] PROP_STR = "VIZ_ColorDialog";
	ColorDialog cd;
	UINT результат = 0;
	
	try
	{
		if(сооб == WM_INITDIALOG)
		{
			CHOOSECOLORA* cc;
			cc = cast(CHOOSECOLORA*)lparam;
			SetPropA(уок, PROP_STR.ptr, cast(HANDLE)cc.lCustData);
			cd = cast(ColorDialog)cast(проц*)cc.lCustData;
		}
		else
		{
			cd = cast(ColorDialog)cast(проц*)GetPropA(уок, PROP_STR.ptr);
		}
		
		if(cd)
		{
			результат = cast(UINT)cd.hookProc(уок, сооб, wparam, lparam);
		}
	}
	catch(Объект e)
	{
		Приложение.приИсклНити(e);
	}
	
	return результат;
}

