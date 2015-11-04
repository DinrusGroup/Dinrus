//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.notifyicon;

private import viz.x.winapi, viz.base, viz.drawing;
private import viz.control, viz.form, viz.app;
private import viz.event, viz.x.utf, viz.x.dlib;

version(ВИЗ_БЕЗ_МЕНЮ)
{
}
else
{
	private import viz.menu;
}


class NotifyIcon // docmain
{
	version(ВИЗ_БЕЗ_МЕНЮ)
	{
	}
	else
	{
				final проц контекстноеМеню(КонтекстноеМеню меню) // setter
		{
			this.cmenu = меню;
		}
		
		
		final КонтекстноеМеню контекстноеМеню() // getter
		{
			return cmenu;
		}
	}
	
	
		final проц пиктограмма(Пиктограмма ico) // setter
	{
		_icon = ico;
		nid.hIcon = ico ? ico.указатель : пусто;
		
		if(виден)
		{
			nid.uFlags = NIF_ICON;
			Shell_NotifyIconA(NIM_MODIFY, &nid);
		}
	}
	
	
	final Пиктограмма пиктограмма() // getter
	{
		return _icon;
	}
	
	
		// Must be less than 64 chars.
	// To-do: hold reference to setter's string, use that for getter.. ?
	final проц текст(Ткст txt) // setter
	{
		if(txt.length >= nid.szTip.length)
			throw new ВизИскл("Notify пиктограмма текст too long");
		
		// To-do: support Unicode.
		
		txt = небезопАнзи(txt); // ...
		nid.szTip[txt.length] = 0;
		nid.szTip[0 .. txt.length] = txt;
		tipLen = txt.length;
		
		if(виден)
		{
			nid.uFlags = NIF_TIP;
			Shell_NotifyIconA(NIM_MODIFY, &nid);
		}
	}
	
	
	final Ткст текст() // getter
	{
		//return nid.szTip[0 .. tipLen]; // Returning possibly mutated текст!
		//return nid.szTip[0 .. tipLen].dup;
		//return nid.szTip[0 .. tipLen].idup; // Needed in D2. Doesn't work in D1.
		return cast(Ткст)nid.szTip[0 .. tipLen].dup; // Needed in D2. Doesn't work in D1.
	}
	
	
		final проц виден(бул подтвержд) // setter
	{
		if(подтвержд)
		{
			if(!nid.uID)
			{
				nid.uID = allocNotifyIconID();
				assert(nid.uID);
				allNotifyIcons[nid.uID] = this;
			}
			
			_forceAdd();
		}
		else if(nid.uID)
		{
			_forceDelete();
			
			//delete allNotifyIcons[nid.uID];
			allNotifyIcons.удали(nid.uID);
			nid.uID = 0;
		}
	}
	
	
	final бул виден() // getter
	{
		return nid.uID != 0;
	}
	
	
		final проц покажи()
	{
		виден = да;
	}
	
	
	final проц скрой()
	{
		виден = нет;
	}
	
	
	//СобОбработчик клик;
	Событие!(NotifyIcon, АргиСоб) клик; 	//СобОбработчик двуклик;
	Событие!(NotifyIcon, АргиСоб) двуклик; 	//MouseEventHandler мышьВнизу;
	Событие!(NotifyIcon, АргиСобМыши) мышьВнизу; 	//MouseEventHandler мышьВверху;
	Событие!(NotifyIcon, АргиСобМыши) мышьВверху; 	//MouseEventHandler мышьДвижется;
	Событие!(NotifyIcon, АргиСобМыши) мышьДвижется; 	
	
	this()
	{
		if(!ctrlNotifyIcon)
			_init();
		
		nid.cbSize = nid.sizeof;
		nid.уок = ctrlNotifyIcon.указатель;
		nid.uID = 0;
		nid.uCallbackMessage = WM_NOTIFYICON;
		nid.hIcon = пусто;
		nid.szTip[0] = '\0';
	}
	
	
	~this()
	{
		if(nid.uID)
		{
			_forceDelete();
			//delete allNotifyIcons[nid.uID];
			allNotifyIcons.удали(nid.uID);
		}
		
		//delete allNotifyIcons[nid.uID];
		//allNotifyIcons.удали(nid.uID);
		
		/+
		if(!allNotifyIcons.length)
		{
			delete ctrlNotifyIcon;
			ctrlNotifyIcon = пусто;
		}
		+/
	}
	
	
		// Extra.
	проц minimize(ИОкно win)
	{
		LONG стиль;
		УОК уок;
		
		уок = win.указатель;
		стиль = GetWindowLongA(cast(HWND) уок, GWL_STYLE);
		
		if(стиль & WS_VISIBLE)
		{
			ShowOwnedPopups(cast(HWND) уок, FALSE);
			
			if(!(стиль & WS_MINIMIZE) && _animation())
			{
				RECT myRect, areaRect;
				
				GetWindowRect(cast(HWND) уок, &myRect);
				_area(areaRect);
				DrawAnimatedRects(уок, 3, &myRect, &areaRect);
			}
			
			ShowWindow(cast(HWND) уок, SW_HIDE);
		}
	}
	
	
		// Extra.
	проц restore(ИОкно win)
	{
		LONG стиль;
		УОК уок;
		
		уок = win.указатель;
		стиль = GetWindowLongA(cast(HWND) уок, GWL_STYLE);
		
		if(!(стиль & WS_VISIBLE))
		{
			if(стиль & WS_MINIMIZE)
			{
				ShowWindow(cast(HWND) уок, SW_RESTORE);
			}
			else
			{
				if(_animation())
				{
					RECT myRect, areaRect;
					
					GetWindowRect(cast(HWND) уок, &myRect);
					_area(areaRect);
					DrawAnimatedRects(cast(HWND) уок, 3, &areaRect, &myRect);
				}
				
				ShowWindow(cast(HWND) уок, SW_SHOW);
				
				ShowOwnedPopups(cast(HWND) уок, TRUE);
			}
		}
		else
		{
			if(стиль & WS_MINIMIZE)
				ShowWindow(cast(HWND) уок, SW_RESTORE);
		}
		
		SetForegroundWindow(уок);
	}
	
	
	private:
	
	NOTIFYICONDATA nid;
	цел tipLen = 0;
	version(ВИЗ_БЕЗ_МЕНЮ)
	{
	}
	else
	{
		КонтекстноеМеню cmenu;
	}
	Пиктограмма _icon;
	
	
	package final проц _forceAdd()
	{
		nid.uFlags = NIF_MESSAGE | NIF_ICON | NIF_TIP;
		Shell_NotifyIconA(NIM_ADD, &nid);
	}
	
	
	package final проц _forceDelete()
	{
		Shell_NotifyIconA(NIM_DELETE, &nid);
	}
	
	
	// Returns да if min/restore animation is on.
	static бул _animation()
	{
		ANIMATIONINFO ai;
		
		ai.cbSize = ai.sizeof;
		SystemParametersInfoA(SPI_GETANIMATION, ai.sizeof, &ai, 0);
		
		return ai.iMinAnimate ? да : нет;
	}
	
	
	// Gets the tray area.
	static проц _area(out RECT rect)
	{
		УОК hwTaskbar, hw;
		
		hwTaskbar = FindWindowExA(пусто, пусто, "Shell_TrayWnd", пусто);
		if(hwTaskbar)
		{
			hw = FindWindowExA(hwTaskbar, пусто, "TrayNotifyWnd", пусто);
			if(hw)
			{
				GetWindowRect(hw, &rect);
				return;
			}
		}
		
		APPBARDATA abd;
		
		abd.cbSize = abd.sizeof;
		if(SHAppBarMessage(ABM_GETTASKBARPOS, &abd))
		{
			switch(abd.uEdge)
			{
				case ABE_LEFT:
				case ABE_RIGHT:
					rect.верх = abd.rc.низ - 100;
					rect.низ = abd.rc.низ - 16;
					rect.лево = abd.rc.лево;
					rect.право = abd.rc.право;
					break;
				
				case ABE_TOP:
				case ABE_BOTTOM:
					rect.верх = abd.rc.верх;
					rect.низ = abd.rc.низ;
					rect.лево = abd.rc.право - 100;
					rect.право = abd.rc.право - 16;
					break;
				
				default: ;
			}
		}
		else if(hwTaskbar)
		{
			GetWindowRect(hwTaskbar, &rect);
			if(rect.право - rect.лево > 150)
				rect.лево = rect.право - 150;
			if(rect.низ - rect.верх > 30)
				rect.верх = rect.низ - 30;
		}
		else
		{
			SystemParametersInfoA(SPI_GETWORKAREA, 0, &rect, 0);
			rect.лево = rect.право - 150;
			rect.верх = rect.низ - 30;
		}
	}
}


package:


const UINT WM_NOTIFYICON = WM_USER + 34; // -wparam- is id, -lparam- is the mouse сообщение such as WM_LBUTTONDBLCLK.
UINT wmTaskbarCreated;
NotifyIcon[UINT] allNotifyIcons; // Indexed by ID.
UINT lastId = 1;
NotifyIconControl ctrlNotifyIcon;


class NotifyIconControl: УпрЭлт
{
	override проц создайУказатель()
	{
		//if(создан)
		if(созданУказатель_ли)
			return;
		
		if(удаляется)
		{
			create_err:
			throw new ВизИскл("Notify пиктограмма initialization failure");
		}
		
		Приложение.созданиеУпрЭлта(this);
		уок = CreateWindowExA(окДопСтиль, CONTROL_CLASSNAME.ptr, "NotifyIcon", 0, 0, 0, 0, 0, пусто, пусто,
			cast(HINSTANCE) Приложение.дайЭкз(), пусто);
		if(!уок)
			goto create_err;
	}
	
	
	protected override проц окПроц(inout Сообщение сооб)
	{
		if(сооб.сооб == WM_NOTIFYICON)
		{
			if(cast(UINT)сооб.парам1 in allNotifyIcons)
			{
				NotifyIcon ni;
				Точка тчк;
				
				ni = allNotifyIcons[cast(UINT)сооб.парам1];
				
				switch(cast(UINT)сооб.парам2) // сооб.
				{
					case WM_MOUSEMOVE:
						тчк = Курсор.положение;
						ni.мышьДвижется(ni, new АргиСобМыши(УпрЭлт.кнопкиМыши(), 0, тчк.ш, тчк.в, 0));
						break;
					
					case WM_LBUTTONUP:
						тчк = Курсор.положение;
						ni.мышьВверху(ni, new АргиСобМыши(ПКнопкиМыши.ЛЕВ, 1, тчк.ш, тчк.в, 0));
						
						ni.клик(ni, АргиСоб.пуст);
						break;
					
					case WM_RBUTTONUP:
						тчк = Курсор.положение;
						ni.мышьВверху(ni, new АргиСобМыши(ПКнопкиМыши.ПРАВ, 1, тчк.ш, тчк.в, 0));
						
						version(ВИЗ_БЕЗ_МЕНЮ)
						{
						}
						else
						{
							if(ni.cmenu)
								ni.cmenu.покажи(ctrlNotifyIcon, тчк);
						}
						break;
					
					case WM_LBUTTONDOWN:
						тчк = Курсор.положение;
						ni.мышьВнизу(ni, new АргиСобМыши(ПКнопкиМыши.ЛЕВ, 0, тчк.ш, тчк.в, 0));
						break;
					
					case WM_RBUTTONDOWN:
						тчк = Курсор.положение;
						ni.мышьВнизу(ni, new АргиСобМыши(ПКнопкиМыши.ПРАВ, 0, тчк.ш, тчк.в, 0));
						break;
					
					case WM_LBUTTONDBLCLK:
						ni.двуклик(ni, АргиСоб.пуст);
						break;
					
					default: ;
				}
			}
		}
		else if(сооб.сооб == wmTaskbarCreated)
		{
			// покажи все виден NotifyIcon's.
			foreach(NotifyIcon ni; allNotifyIcons)
			{
				if(ni.виден)
					ni._forceAdd();
			}
		}
		
		super.окПроц(сооб);
	}
}


static ~this()
{
	// Due to все элты not being destructed at program выход,
	// удали все виден notify icons because the OS won't.
	foreach(NotifyIcon ni; allNotifyIcons)
	{
		if(ni.виден)
			ni._forceDelete();
	}
	
	allNotifyIcons = пусто;
}


UINT allocNotifyIconID()
{
	UINT prev;
	prev = lastId;
	for(;;)
	{
		lastId++;
		if(lastId == ushort.max)
			lastId = 1;
		if(lastId == prev)
			throw new ВизИскл("Too many notify icons");
		
		if(!(lastId in allNotifyIcons))
			break;
	}
	return lastId;
}


проц _init()
{
	wmTaskbarCreated = RegisterWindowMessageA("TaskbarCreated");
	
	ctrlNotifyIcon = new NotifyIconControl;
	ctrlNotifyIcon.виден = нет;
}

