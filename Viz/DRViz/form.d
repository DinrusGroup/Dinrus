//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.form;

private import viz.x.dlib;

private import viz.control, viz.x.winapi, viz.event, viz.drawing;
private import viz.app, viz.base, viz.x.utf;
private import viz.collections;

version(ВИЗ_БЕЗ_МЕНЮ)
{
}
else
{
	private import viz.menu;
}

version(ВИЗ_БЕЗ_ПАРК_ОКНА)
{
}
else
{
	version = ВИЗ_ПАРК_ОКНО;
}


version = ВИЗ_БЕЗ_ЗОМБИ_ФОРМ;


private extern(Windows) проц _initMdiclient();


enum ПСтильКромкиФормы: ббайт //: ПСтильКромки
{
	НЕУК = ПСтильКромки.НЕУК, 	
	ФИКС_3М = ПСтильКромки.ФИКС_3М, 
	ФИКС_ЕДИН = ПСтильКромки.ФИКС_ЕДИН, 
	ФИКС_ДИАЛОГ, 
	НЕФИКС, 
	ФИКС_ИНСТР, 
	НЕФИКС_ИНСТР, 
}


deprecated enum SizeGripStyle: ббайт
{
	АВТО,
 	СКРОЙ, 
	ПОКАЖИ, 
}


enum ПНачПоложениеФормы: ббайт
{
	ЦЕНТР_РОДИТЕЛЯ,
 	ЦЕНТР_ЭКРАНА, 
	РУЧНОЕ, 
	ДЕФГРАНИЦЫ, 
	ВИНДЕФГРАНИЦЫ = ДЕФГРАНИЦЫ, // deprecated
	ДЕФПОЛОЖЕНИЕ, 
	ВИНДЕФПОЛОЖЕНИЕ = ДЕФПОЛОЖЕНИЕ, // deprecated
}


enum ПСостОкнаФормы: ббайт
{
	РАЗВЁРНУТО,
 	СВЁРНУТО, 
	НОРМА, 
}


enum РаскладкаМди: ббайт
{
	ARRANGE_ICONS,
 	CASCADE, 
	TILE_HORIZONTAL, 
	TILE_VERTICAL, 
}


// The Форма's быстрыйЗапуск was нажато.
export extern (D) class АргиСобБыстрЗапускаФормы: АргиСоб
{
export:
		this(ПКлавиши быстрыйЗапуск)
	{
		this._shortcut = быстрыйЗапуск;
	}
	
	
		final ПКлавиши быстрыйЗапуск() // getter
	{
		return _shortcut;
	}
	
	
	private:
	ПКлавиши _shortcut;
}


// DMD 0.93 crashes if this is placed in Форма.
//private import viz.кнопка;


version = СТАРОЕ_ЗАКРЫТИЕ_МОДАЛЬНОГО; // New version destroys упрэлт инфо.


export extern (D) class Форма: УпрЭлтКонтейнер, ИРезДиалога // docmain
{
export:
		final проц кнопкаПринять(ИУпрЭлтКнопка кноп) // setter
	{
		if(кнпПринять)
			кнпПринять.сообщиДеф(нет);
		
		кнпПринять = кноп;
		
		if(кноп)
			кноп.сообщиДеф(да);
	}
	
	
	final ИУпрЭлтКнопка кнопкаПринять() // getter
	{
		return кнпПринять;
	}
	
	
		final проц кнопкаОтменить(ИУпрЭлтКнопка кноп) // setter
	{
		кнпОтменить = кноп;
		
		if(кноп)
		{
			if(!(Приложение._compat & DflCompat.FORM_DIALOGRESULT_096))
			{
				кноп.резДиалога = ПРезДиалога.ОТМЕНА;
			}
		}
	}
	
	
	final ИУпрЭлтКнопка кнопкаОтменить() // getter
	{
		return кнпОтменить;
	}
	
	
		// An исключение is thrown if the быстрыйЗапуск was already added.
	final проц добавьЯрлык(ПКлавиши быстрыйЗапуск, проц delegate(Объект отправитель, АргиСобБыстрЗапускаФормы ea) нажато)
	in
	{
		assert(быстрыйЗапуск & ПКлавиши.КОД_КЛАВИШИ); // At least one key code.
		assert(нажато !is пусто);
	}
	body
	{
		if(быстрыйЗапуск in _shortcuts)
			throw new ВизИскл("Конфликт кнопок ускоренного вызова");
		
		_shortcuts[быстрыйЗапуск] = нажато;
	}
	
	
	// Delegate parameter contravariance.
	final проц добавьЯрлык(ПКлавиши быстрыйЗапуск, проц delegate(Объект отправитель, АргиСоб ea) нажато)
	{
		return добавьЯрлык(быстрыйЗапуск, cast(проц delegate(Объект отправитель, АргиСобБыстрЗапускаФормы ea))нажато);
	}
	
	
	final проц removeShortcut(ПКлавиши быстрыйЗапуск)
	{
		//delete _shortcuts[быстрыйЗапуск];
		_shortcuts.удали(быстрыйЗапуск);
	}
	
	
		static Форма активнаяФорма() // getter
	{
		return cast(Форма)поУказателю(GetActiveWindow());
	}
	
	
		final Форма дайАктивныйОтпрыскМди() // getter
	{
		return cast(Форма)поУказателю(cast(УОК)SendMessageA(указатель, WM_MDIGETACTIVE, 0, 0));
	}
	
	
	protected override Размер дефРазм() // getter
	{
		return Размер(300, 300);
	}
	
	
	// Note: the following 2 functions aren't completely accurate;
	// it sounds like it should return the center Точка, but it
	// returns the Точка that would center the текущий form.
	
	final Точка центрЭкрана() // getter
	{
		RECT area;
		SystemParametersInfoA(SPI_GETWORKAREA, 0, &area, FALSE);
		
		Точка тчк;
		тчк.ш = area.лево + (((area.право - area.лево) - this.ширина) / 2);
		тчк.в = area.верх + (((area.низ - area.верх) - this.высота) / 2);
		return тчк;
	}
	
	
	final Точка центрРодителя() // getter
	{
		УпрЭлт cwparent;
		if(окСтиль & WS_CHILD)
			cwparent = окРодитель;
		else
			cwparent = wowner;
		
		if(!cwparent || !cwparent.виден)
			return центрЭкрана;
		
		Точка тчк;
		тчк.ш = cwparent.лево + ((cwparent.ширина - this.ширина) / 2);
		тчк.в = cwparent.верх + ((cwparent.высота - this.высота) / 2);
		return тчк;
	}
	
	
		final проц поЦентруЭкрана()
	{
		положение = центрЭкрана;
	}
	
	
		final проц поЦентруРодителя()
	{
		положение = центрРодителя;
	}
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		УпрЭлт cwparent;
		if(cp.стиль & WS_CHILD)
			cwparent = окРодитель;
		else
			cwparent = wowner;
		
		cp.имяКласса = FORM_CLASSNAME;
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
			cp.меню = HMENU.init;
		}
		else
		{
			cp.меню = wmenu ? wmenu.указатель : HMENU.init;
		}
		
		//cp.родитель = окРодитель ? окРодитель.указатель : HWND.init;
		//if(!(cp.стиль & WS_CHILD))
		//	cp.родитель = wowner ? wowner.указатель : HWND.init;
		cp.родитель = cwparent ? cwparent.указатель : HWND.init;
		if(!cp.родитель)
			cp.родитель = sowner;
		version(ВИЗ_ПАРК_ОКНО)
		{
			if(!cp.родитель && !покажиВСтрокеЗадач)
				cp.родитель = getParkHwnd();
		}
		
		if(!восстановлениеУказателя)
		{
			switch(стартпоз)
			{
				case ПНачПоложениеФормы.ЦЕНТР_РОДИТЕЛЯ:
					if(cwparent && cwparent.виден)
					{
						cp.ш = cwparent.лево + ((cwparent.ширина - cp.ширина) / 2);
						cp.в = cwparent.верх + ((cwparent.высота - cp.высота) / 2);
						
						// Make sure part of the form isn't off the screen.
						RECT area;
						SystemParametersInfoA(SPI_GETWORKAREA, 0, &area, FALSE);
						if(cp.ш < area.лево)
							cp.ш = area.лево;
						else if(cp.ш + cp.ширина > area.право)
							cp.ш = area.право - cp.ширина;
						if(cp.в < area.верх)
							cp.в = area.верх;
						else if(cp.в + cp.высота > area.низ)
							cp.в = area.низ - cp.высота;
						break;
					}
					// No родитель so use the screen.
				case ПНачПоложениеФормы.ЦЕНТР_ЭКРАНА:
					{
						// TODO: map to client coords if MDI child.
						
						RECT area;
						SystemParametersInfoA(SPI_GETWORKAREA, 0, &area, FALSE);
						
						cp.ш = area.лево + (((area.право - area.лево) - cp.ширина) / 2);
						cp.в = area.верх + (((area.низ - area.верх) - cp.высота) / 2);
					}
					break;
				
				case ПНачПоложениеФормы.ДЕФГРАНИЦЫ:
					// WM_CREATE fixes these.
					cp.ширина = CW_USEDEFAULT;
					cp.высота = CW_USEDEFAULT;
					//break; // ДЕФГРАНИЦЫ assumes default положение.
				case ПНачПоложениеФормы.ДЕФПОЛОЖЕНИЕ:
					// WM_CREATE fixes these.
					cp.ш = CW_USEDEFAULT;
					//cp.в = CW_USEDEFAULT;
					cp.в = виден ? SW_SHOW : SW_HIDE;
					break;
				
				default: ;
			}
		}
	}
	
	
	protected override проц создайУказатель()
	{
		// This code is reimplemented to allow some tricks.
		
		if(созданУказатель_ли)
			return;
		
		debug
		{
			Ткст er;
		}
		if(удаляется)
		{
			/+
			create_err:
			throw new ВизИскл("Форма creation failure");
			//throw new ВизИскл(Объект.вТкст() ~ " creation failure"); // ?
			+/
			debug
			{
				er = "форма удаляется";
			}
			
			debug(APP_PRINT)
			{
				эхо("Creating Форма указатель while удаляется.\n");
			}
			
			create_err:
			Ткст kmsg = "Неудача при создании формы";
			if(имя.length)
				kmsg ~= " (" ~ имя ~ ")";
			debug
			{
				if(er.length)
					kmsg ~= " - " ~ er;
			}
			throw new ВизИскл(kmsg);
			//throw new ВизИскл(Объект.вТкст() ~ " creation failure"); // ?
		}
		
		// Need the хозяин's указатель to exist.
		if(wowner)
		//	wowner.создайУказатель(); // DMD 0.111: class viz.control.УпрЭлт member создайУказатель is not accessible
			wowner._createHandle();
		
		// This is here because wowner.создайУказатель() might create me.
		//if(создан)
		if(созданУказатель_ли)
			return;
		
		//DWORD vis;
		CBits vis;
		ПарамыСозд cp;
		
		создайПараметры(cp);
		assert(!созданУказатель_ли); // Make sure the указатель wasn't создан in создайПараметры().
		
		with(cp)
		{
			окТекст = заглавие;
			//окПрям = Прям(ш, в, ширина, высота); // Avoid CW_USEDEFAULT problems. This gets updated in WM_CREATE.
			окСтильКласса = стильКласса;
			окДопСтиль = допСтиль;
			окСтиль = стиль;
			
			// Use local var to avoid changing -cp- at this Точка.
			цел ly;
			ly = в;
			
			// Delay setting виден.
			//vis = окСтиль;
			vis = cbits;
			vis |= CBits.FVISIBLE;
			if(!(vis & CBits.VISIBLE))
				vis &= ~CBits.FVISIBLE;
			if(ш == CW_USEDEFAULT)
				ly = SW_HIDE;
			
			Приложение.созданиеУпрЭлта(this);
			уок = viz.x.utf.создайОкноДоп(допСтиль, имяКласса, заглавие, окСтиль & ~WS_VISIBLE,
				ш, ly, ширина, высота, родитель, меню, экземп, парам);
			if(!уок)
			{
				debug
				{
					version(Tango)
					{
						er = "CreateWindowEx failed";
					}
					else
					{
						er = фм("CreateWindowEx неудачно завершён {имяКласса=%s;допСтиль=0x%X;стиль=0x%X;родитель=0x%X;меню=0x%X;экземп=0x%X;}",
							имяКласса, допСтиль, стиль, cast(проц*)родитель, cast(проц*)меню, cast(проц*)экземп);
					}
				}
				goto create_err;
			}
		}
		
		if(setLayeredWindowAttributes)
		{
			BYTE альфа = opacityToAlpha(opa);
			DWORD флаги = 0;
			
			if(альфа != BYTE.max)
				флаги |= LWA_ALPHA;
			
			if(transKey != Цвет.пуст)
				флаги |= LWA_COLORKEY;
			
			if(флаги)
			{
				//_exStyle(_exStyle() | WS_EX_LAYERED); // Should already be установи.
				setLayeredWindowAttributes(уок, transKey.вКзс(), альфа, флаги);
			}
		}
		
		if(!nofilter)
			Приложение.добавьФильтрСооб(mfilter); // To process IsDialogMessage().
		
		//создайОтпрыски();
		try
		{
			создайОтпрыски(); // Might throw.
		}
		catch(Объект e)
		{
			Приложение.приИсклНити(e);
		}
		
		н_раскладка(this, нет); // ?
		
		if(!восстановлениеУказателя) // This stuff already happened if recreating...
		{
			if(автоМасштаб)
			{
				//Приложение.вершиСобытия(); // ?
				
				_scale();
				
				// Scaling can goof up the centering, so fix it..
				switch(стартпоз)
				{
					case ПНачПоложениеФормы.ЦЕНТР_РОДИТЕЛЯ:
						поЦентруРодителя();
						break;
					case ПНачПоложениеФормы.ЦЕНТР_ЭКРАНА:
						поЦентруЭкрана();
						break;
					default: ;
				}
			}
			
			if(Приложение._compat & DflCompat.FORM_LOAD_096)
			{
				// Load before shown.
				// Not calling if recreating указатель!
				приЗагрузке(АргиСоб.пуст);
			}
		}
		
		//assert(!виден);
		//if(vis & WS_VISIBLE)
		//if(vis & CBits.VISIBLE)
		if(vis & CBits.FVISIBLE)
		{
			cbits |= CBits.VISIBLE;
			окСтиль |= WS_VISIBLE;
			if(восстановлениеУказателя)
				goto show_normal;
			// These fire приИзмененииВидимости as needed...
			switch(состояниеОкна)
			{
				case ПСостОкнаФормы.НОРМА: show_normal:
					ShowWindow(уок, SW_SHOW);
					// Possible to-do: see if non-MDI is "main form" and use SHOWNORMAL or doShow.
					break;
				case ПСостОкнаФормы.РАЗВЁРНУТО:
					ShowWindow(уок, SW_SHOWMAXIMIZED);
					break;
				case ПСостОкнаФормы.СВЁРНУТО:
					ShowWindow(уок, SW_SHOWMINIMIZED);
					break;
				default:
					assert(0);
			}
		}
		//cbits &= ~CBits.FVISIBLE;
	}
	
	
	/+
		// Focused отпрыски are scrolled into view.
	override проц автоПрокрутка(бул подтвержд) // setter
	{
		super.автоПрокрутка(подтвержд);
	}
	
	
	override бул автоПрокрутка() // getter
	{
		return super.автоПрокрутка(подтвержд);
	}
	+/
	
	
	// This only works if the windows version is
	// установи to 4.0 or higher.
	
		final проц боксУпрЭлта(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | WS_SYSMENU);
		else
			_style(_style() & ~WS_SYSMENU);
		
		// Update taskbar кнопка.
		if(созданУказатель_ли)
		{
			if(виден)
			{
				//скрой();
				//покажи();
				// Do it directly so that DFL code can't prevent it.
				cbits |= CBits.RECREATING;
				scope(exit)
					cbits &= ~CBits.RECREATING;
				doHide();
				doShow();
			}
		}
	}
	
	
	final бул боксУпрЭлта() // getter
	{
		return (_style() & WS_SYSMENU) != 0;
	}
	
	
		final проц границыРабСтола(Прям к) // setter
	{
		RECT rect;
		if(к.ширина < 0)
			к.ширина = 0;
		if(к.высота < 0)
			к.высота = 0;
		к.дайПрям(&rect);
		
		//УпрЭлт par = родитель;
		//if(par) // Convert from screen coords to родитель coords.
		//	MapWindowPoints(HWND.init, par.указатель, cast(Точка*)&rect, 2);
		
		установиЯдроГраниц(rect.лево, rect.верх, rect.право - rect.лево, rect.низ - rect.верх, ПЗаданныеПределы.ВСЕ);
	}
	
	
	final Прям границыРабСтола() // getter
	{
		RECT к;
		GetWindowRect(указатель, &к);
		return Прям(&к);
	}
	
	
		final проц положениеРабСтола(Точка dp) // setter
	{
		//УпрЭлт par = родитель;
		//if(par) // Convert from screen coords to родитель coords.
		//	MapWindowPoints(HWND.init, par.указатель, &dp.точка, 1);
		
		установиЯдроГраниц(dp.ш, dp.в, 0, 0, ПЗаданныеПределы.ПОЛОЖЕНИЕ);
	}
	
	
	final Точка положениеРабСтола() // getter
	{
		RECT к;
		GetWindowRect(указатель, &к);
		return Точка(к.лево, к.верх);
	}
	
	
		final проц резДиалога(ПРезДиалога dr) // setter
	{
		fresult = dr;
		
		if(!(Приложение._compat & DflCompat.FORM_DIALOGRESULT_096))
		{
			if(модальное && ПРезДиалога.НЕУК != dr)
				закрой();
		}
	}
	
	
	final ПРезДиалога резДиалога() // getter
	{
		return fresult;
	}
	
	
	override Цвет цветФона() // getter
	{
		if(Цвет.пуст == цвфона)
			return дефЦветФона; // УпрЭлт's.
		return цвфона;
	}
	
	alias УпрЭлт.цветФона цветФона; // Overload.
	
	
		final проц стильКромкиФормы(ПСтильКромкиФормы bstyle) // setter
	{
		ПСтильКромкиФормы curbstyle;
		curbstyle = стильКромкиФормы;
		if(bstyle == curbstyle)
			return;
		
		бул vis = нет;
		
		if(созданУказатель_ли && виден)
		{
			vis = да;
			cbits |= CBits.RECREATING;
			// Do it directly so that DFL code can't prevent it.
			//doHide();
			ShowWindow(уок, SW_HIDE);
		}
		scope(exit)
			cbits &= ~CBits.RECREATING;
		
		LONG st;
		LONG exst;
		//Размер csz;
		st = _style();
		exst = _exStyle();
		//csz = клиентРазм;
		
		const DWORD STNOTNONE = ~(WS_BORDER | WS_THICKFRAME | WS_CAPTION | WS_DLGFRAME);
		const DWORD EXSTNOTNONE = ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE
			| WS_EX_DLGMODALFRAME | WS_EX_STATICEDGE | WS_EX_WINDOWEDGE);
		
		// This is needed to work on Vista.
		if(ПСтильКромкиФормы.НЕУК != curbstyle)
		{
			_style(st & STNOTNONE);
			_exStyle(exst & EXSTNOTNONE);
		}
		
		switch(bstyle)
		{
			case ПСтильКромкиФормы.ФИКС_3М:
				st &= ~(WS_BORDER | WS_THICKFRAME | WS_DLGFRAME);
				exst &= ~(WS_EX_TOOLWINDOW | WS_EX_STATICEDGE);
				
				st |= WS_CAPTION;
				exst |= WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE;
				break;
			
			case ПСтильКромкиФормы.ФИКС_ДИАЛОГ:
				st &= ~(WS_BORDER | WS_THICKFRAME);
				exst &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);
				
				st |= WS_CAPTION | WS_DLGFRAME;
				exst |= WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE;
				break;
			
			case ПСтильКромкиФормы.ФИКС_ЕДИН:
				st &= ~(WS_THICKFRAME | WS_DLGFRAME);
				exst &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_WINDOWEDGE | WS_EX_STATICEDGE);
				
				st |= WS_BORDER | WS_CAPTION;
				exst |= WS_EX_DLGMODALFRAME;
				break;
			
			case ПСтильКромкиФормы.ФИКС_ИНСТР:
				st &= ~(WS_BORDER | WS_THICKFRAME | WS_DLGFRAME);
				exst &= ~(WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);
				
				st |= WS_CAPTION;
				exst |= WS_EX_TOOLWINDOW | WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME;
				break;
			
			case ПСтильКромкиФормы.НЕФИКС:
				st &= ~(WS_BORDER | WS_DLGFRAME);
				exst &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME | WS_EX_STATICEDGE);
				
				st |= WS_THICKFRAME | WS_CAPTION;
				exst |= WS_EX_WINDOWEDGE;
				break;
			
			case ПСтильКромкиФормы.НЕФИКС_ИНСТР:
				st &= ~(WS_BORDER | WS_DLGFRAME);
				exst &= ~(WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME | WS_EX_STATICEDGE);
				
				st |= WS_THICKFRAME | WS_CAPTION;
				exst |= WS_EX_TOOLWINDOW | WS_EX_WINDOWEDGE;
				break;
			
			case ПСтильКромкиФормы.НЕУК:
				st &= STNOTNONE;
				exst &= EXSTNOTNONE;
				break;
		}
		
		_style(st);
		_exStyle(exst);
		//клиентРазм = csz;
		
		// Update taskbar кнопка.
		if(созданУказатель_ли)
		{
			if(vis)
			{
				//скрой();
				//покажи();
				SetWindowPos(уок, HWND.init, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE
					| SWP_NOSIZE | SWP_NOZORDER); // Recalculate the frame while hidden.
				_resetSystemMenu();
				// Do it directly so that DFL code can't prevent it.
				doShow();
				инвалидируй(да);
			}
			else
			{
				SetWindowPos(уок, HWND.init, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE
					| SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE); // Recalculate the frame.
				_resetSystemMenu();
			}
		}
	}
	
	
	final ПСтильКромкиФормы стильКромкиФормы() // getter
	{
		LONG st = _style();
		LONG exst = _exStyle();
		
		if(exst & WS_EX_TOOLWINDOW)
		{
			if(st & WS_THICKFRAME)
				return ПСтильКромкиФормы.НЕФИКС_ИНСТР;
			else
				return ПСтильКромкиФормы.ФИКС_ИНСТР;
		}
		else
		{
			if(st & WS_THICKFRAME)
			{
				return ПСтильКромкиФормы.НЕФИКС;
			}
			else
			{
				if(exst & WS_EX_CLIENTEDGE)
					return ПСтильКромкиФормы.ФИКС_3М;
				
				if(exst & WS_EX_WINDOWEDGE)
					return ПСтильКромкиФормы.ФИКС_ДИАЛОГ;
				
				if(st & WS_BORDER)
					return ПСтильКромкиФормы.ФИКС_ЕДИН;
			}
		}
		
		return ПСтильКромкиФормы.НЕУК;
	}
	
	
		// Ignored if min and max buttons are включен.
	final проц кнопкаПомощь(бул подтвержд) // setter
	{
		if(подтвержд)
			_exStyle(_exStyle() | WS_EX_CONTEXTHELP);
		else
			_exStyle(_exStyle() & ~WS_EX_CONTEXTHELP);
		
		перерисуйПолностью();
	}
	
	
	final бул кнопкаПомощь() // getter
	{
		return (_exStyle() & WS_EX_CONTEXTHELP) != 0;
	}
	
	
	private проц _setIcon()
	{
		HICON hico, hicoSm;
		
		if(wicon)
		{
			hico = wicon.указатель;
			
			цел smx, smy;
			smx = GetSystemMetrics(SM_CXSMICON);
			smy = GetSystemMetrics(SM_CYSMICON);
			hicoSm = CopyImage(hico, IMAGE_ICON, smx, smy, LR_COPYFROMRESOURCE);
			if(!hicoSm)
				hicoSm = CopyImage(hico, IMAGE_ICON, smx, smy, 0);
			if(hicoSm)
			{
				wiconSm = new Пиктограмма(hicoSm);
			}
			else
			{
				wiconSm = пусто;
				hicoSm = hico;
			}
		}
		else
		{
			hico = HICON.init;
			hicoSm = HICON.init;
			
			wiconSm = пусто;
		}
		
		SendMessageA(уок, WM_SETICON, ICON_BIG, cast(LPARAM)hico);
		SendMessageA(уок, WM_SETICON, ICON_SMALL, cast(LPARAM)hicoSm);
		
		if(виден)
			перерисуйПолностью();
	}
	
	
		final проц пиктограмма(Пиктограмма ico) // setter
	{
		wicon = ico;
		
		if(созданУказатель_ли)
			_setIcon();
	}
	
	
	final Пиктограмма пиктограмма() // getter
	{
		return wicon;
	}
	
	
	// TODO: implement.
	// keyPreview
	
	
		final бул мдиОтпрыск_ли() // getter
	{
		return (_exStyle() & WS_EX_MDICHILD) != 0;
	}
	
	
	version(NO_MDI)
	{
		private alias УпрЭлт КлиентМди; // ?
	}
	
		// Note: keeping this here for NO_MDI to keep the vtable.
	protected КлиентМди создатьКлиентМди()
	{
		version(NO_MDI)
		{
			assert(0, "MDI disabled");
			return пусто;
		}
		else
		{
			return new КлиентМди();
		}
	}
	
	
	version(NO_MDI) {} else
	{
				final проц мдиКонтейнер_ли(бул подтвержд) // setter
		{
			if(клиентМди)
			{
				if(!подтвержд)
				{
					// Remove MDI client.
					клиентМди.вымести();
					//клиентМди = пусто;
					_mdiClient = пусто;
				}
			}
			else
			{
				if(подтвержд)
				{
					// Create MDI client.
					//клиентМди = new КлиентМди;
					//_mdiClient = new КлиентМди;
					//клиентМди = создатьКлиентМди();
					_mdiClient = создатьКлиентМди();
					клиентМди.родитель = this;
				}
			}
		}
		
		
		final бул мдиКонтейнер_ли() // getter
		{
			version(NO_MDI)
			{
				return нет;
			}
			else
			{
				return !(клиентМди is пусто);
			}
		}
		
		
				final Форма[] мдиОтпрыски() // getter
		{
			version(NO_MDI)
			{
				return пусто;
			}
			else
			{
				/+
				if(!клиентМди)
					return пусто;
				+/
				
				return _mdiChildren;
			}
		}
		
		
		// родитель is the MDI client and мдиРодитель is the MDI frame.
		
		
		version(NO_MDI) {} else
		{
						final проц мдиРодитель(Форма frm) // setter
			in
			{
				if(frm)
				{
					assert(frm.мдиКонтейнер_ли);
					assert(!(frm.клиентМди is пусто));
				}
			}
			/+out
			{
				if(frm)
				{
					бул found = нет;
					foreach(Форма elem; frm._mdiChildren)
					{
						if(elem is this)
						{
							found = да;
							break;
						}
					}
					assert(found);
				}
			}+/
			body
			{
				if(wmdiparent is frm)
					return;
				
				_removeFromOldOwner();
				wowner = пусто;
				wmdiparent = пусто; // Safety in case of исключение.
				
				if(frm)
				{
					if(созданУказатель_ли)
					{
						frm.создайУпрЭлт(); // ?
						frm.клиентМди.создайУпрЭлт(); // Should already be done from frm.создайУпрЭлт().
					}
					
					// Copy so that old мдиОтпрыски arrays won't get overwritten.
					Форма[] _thisa = new Форма[1]; // DMD 0.123: this can't be а static массив or the append screws up.
					_thisa[0] = this;
					frm._mdiChildren = frm._mdiChildren ~ _thisa;
					
					_style((_style() | WS_CHILD) & ~WS_POPUP);
					_exStyle(_exStyle() | WS_EX_MDICHILD);
					
					окРодитель = frm.клиентМди;
					wmdiparent = frm;
					if(созданУказатель_ли)
						SetParent(уок, frm.клиентМди.уок);
				}
				else
				{
					_exStyle(_exStyle() & ~WS_EX_MDICHILD);
					_style((_style() | WS_POPUP) & ~WS_CHILD);
					
					if(созданУказатель_ли)
						SetParent(уок, HWND.init);
					окРодитель = пусто;
					
					//wmdiparent = пусто;
				}
			}
		}
		
		
		final Форма мдиРодитель() // getter
		{
			version(NO_MDI)
			{
			}
			else
			{
				//if(мдиОтпрыск_ли)
					return wmdiparent;
			}
			return пусто;
		}
	}
	
	
		final проц развернутьБокс(бул подтвержд) // setter
	{
		if(подтвержд == развернутьБокс)
			return;
		
		if(подтвержд)
			_style(_style() | WS_MAXIMIZEBOX);
		else
			_style(_style() & ~WS_MAXIMIZEBOX);
		
		if(созданУказатель_ли)
		{
			перерисуйПолностью();
			
			_resetSystemMenu();
		}
	}
	
	
	final бул развернутьБокс() // getter
	{
		return (_style() & WS_MAXIMIZEBOX) != 0;
	}
	
	
		final проц свернутьБокс(бул подтвержд) // setter
	{
		if(подтвержд == свернутьБокс)
			return;
		
		if(подтвержд)
			_style(_style() | WS_MINIMIZEBOX);
		else
			_style(_style() & ~WS_MINIMIZEBOX);
		
		if(созданУказатель_ли)
		{
			перерисуйПолностью();
			
			_resetSystemMenu();
		}
	}
	
	
	final бул свернутьБокс() // getter
	{
		return (_style() & WS_MINIMIZEBOX) != 0;
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
		}
		else
		{
			if(wmenu)
				wmenu._setHwnd(указатель);
		}
		
		_setIcon();
		
		//SendMessageA(указатель, DM_SETDEFID, IDOK, 0);
	}
	
	
	protected override проц приИзмененииРазмера(АргиСоб ea)
	{
		super.приИзмененииРазмера(ea);
		
		if(_isPaintingSizeGrip)
		{
			RECT rect;
			_getSizeGripArea(&rect);
			InvalidateRect(уок, &rect, TRUE);
		}
	}
	
	
	private проц _getSizeGripArea(RECT* rect)
	{
		rect.право = клиентРазм.ширина;
		rect.низ = клиентРазм.высота;
		rect.лево = rect.право - GetSystemMetrics(SM_CXVSCROLL);
		rect.верх = rect.низ - GetSystemMetrics(SM_CYHSCROLL);
	}
	
	
	private бул _isPaintingSizeGrip()
	{
		if(grip)
		{
			if(окСтиль & WS_THICKFRAME)
			{
				return !(окСтиль & (WS_MINIMIZE | WS_MAXIMIZE |
					WS_VSCROLL | WS_HSCROLL));
			}
		}
		return нет;
	}
	
	
	protected override проц приОтрисовке(АргиСобРис ea)
	{
		super.приОтрисовке(ea);
		
		if(_isPaintingSizeGrip)
		{
			/+
			RECT rect;
			_getSizeGripArea(&rect);
			DrawFrameControl(ea.графика.указатель, &rect, DFC_SCROLL, DFCS_SCROLLSIZEGRIP);
			+/
			
			ea.графика.drawSizeGrip(клиентРазм.ширина, клиентРазм.высота);
		}
	}
	
	
	version(ВИЗ_БЕЗ_МЕНЮ)
	{
	}
	else
	{
				final проц меню(ГлавноеМеню меню) // setter
		{
			if(созданУказатель_ли)
			{
				УОК уок;
				уок = указатель;
				
				if(меню)
				{
					SetMenu(уок, меню.указатель);
					меню._setHwnd(уок);
				}
				else
				{
					SetMenu(уок, HMENU.init);
				}
				
				if(wmenu)
					wmenu._setHwnd(HWND.init);
				wmenu = меню;
				
				DrawMenuBar(уок);
			}
			else
			{
				wmenu = меню;
				_recalcClientSize();
			}
		}
		
		
		final ГлавноеМеню меню() // getter
		{
			return wmenu;
		}
		
		
		/+
				final ГлавноеМеню mergedMenu() // getter
		{
			// Return меню belonging to active MDI child if maximized ?
		}
		+/
	}
	
	
		final проц минимальныйРазмер(Размер min) // setter
	{
		if(!min.ширина && !min.высота)
		{
			minsz.ширина = 0;
			minsz.высота = 0;
			return;
		}
		
		if(maxsz.ширина && maxsz.высота)
		{
			if(min.ширина > maxsz.ширина || min.высота > maxsz.высота)
				throw new ВизИскл("Минимальный размер не может быть больше максимального!");
		}
		
		minsz = min;
		
		бул ischangesz = нет;
		Размер changesz;
		changesz = размер;
		
		if(ширина < min.ширина)
		{
			changesz.ширина = min.ширина;
			ischangesz = да;
		}
		if(высота < min.высота)
		{
			changesz.высота = min.высота;
			ischangesz = да;
		}
		
		if(ischangesz)
			размер = changesz;
	}
	
	
	final Размер минимальныйРазмер() // getter
	{
		return minsz;
	}
	
	
		final проц максимальныйРазмер(Размер max) // setter
	{
		if(!max.ширина && !max.высота)
		{
			maxsz.ширина = 0;
			maxsz.высота = 0;
			return;
		}
		
		//if(minsz.ширина && minsz.высота)
		{
			if(max.ширина < minsz.ширина || max.высота < minsz.высота)
				throw new ВизИскл("Максимальный размер не может быть меньше минимального!");
		}
		
		maxsz = max;
		
		бул ischangesz = нет;
		Размер changesz;
		changesz = размер;
		
		if(ширина > max.ширина)
		{
			changesz.ширина = max.ширина;
			ischangesz = да;
		}
		if(высота > max.высота)
		{
			changesz.высота = max.высота;
			ischangesz = да;
		}
		
		if(ischangesz)
			размер = changesz;
	}
	
	
	final Размер максимальныйРазмер() // getter
	{
		return maxsz;
	}
	
	
		final бул модальное() // getter
	{
		return wmodal;
	}
	
	
		// If непрозрачность and transparency are supported.
	static бул поддерживаетНепрозрачность() // getter
	{
		return setLayeredWindowAttributes != пусто;
	}
	
	
	private static BYTE opacityToAlpha(double opa)
	{
		return cast(BYTE)(opa * BYTE.max);
	}
	
	
		// 1.0 is 100%, 0.0 is 0%, 0.75 is 75%.
	// Does nothing if not supported.
	final проц непрозрачность(double opa) // setter
	{
		if(setLayeredWindowAttributes)
		{
			BYTE альфа;
			
			if(opa >= 1.0)
			{
				this.opa = 1.0;
				альфа = BYTE.max;
			}
			else if(opa <= 0.0)
			{
				this.opa = 0.0;
				альфа = BYTE.min;
			}
			else
			{
				this.opa = opa;
				альфа = opacityToAlpha(opa);
			}
			
			if(альфа == BYTE.max) // Disable
			{
				if(transKey == Цвет.пуст)
					_exStyle(_exStyle() & ~WS_EX_LAYERED);
				else
					setLayeredWindowAttributes(указатель, transKey.вКзс(), 0, LWA_COLORKEY);
			}
			else
			{
				_exStyle(_exStyle() | WS_EX_LAYERED);
				if(созданУказатель_ли)
				{
					//_exStyle(_exStyle() | WS_EX_LAYERED);
					if(transKey == Цвет.пуст)
						setLayeredWindowAttributes(указатель, 0, альфа, LWA_ALPHA);
					else
						setLayeredWindowAttributes(указатель, transKey.вКзс(), альфа, LWA_ALPHA | LWA_COLORKEY);
				}
			}
		}
	}
	
	
	final double непрозрачность() // getter
	{
		return opa;
	}
	
	
	/+
		final Форма[] ownedForms() // getter
	{
		// TODO: implement.
	}
	+/
	
	
	// the "old хозяин" is the текущий -wowner- or -wmdiparent-.
	// If neither are установи, nothing happens.
	private проц _removeFromOldOwner()
	{
		цел idx;
		
		if(wmdiparent)
		{
			idx = найдиИндекс!(Форма)(wmdiparent._mdiChildren, this);
			if(-1 != idx)
				wmdiparent._mdiChildren = удалиИндекс!(Форма)(wmdiparent._mdiChildren, idx);
			//else
			//	assert(0);
		}
		else if(wowner)
		{
			idx = найдиИндекс!(Форма)(wowner._owned, this);
			if(-1 != idx)
				wowner._owned = удалиИндекс!(Форма)(wowner._owned, idx);
			//else
			//	assert(0);
		}
	}
	
	
		final проц хозяин(Форма frm) // setter
	/+out
	{
		if(frm)
		{
			бул found = нет;
			foreach(Форма elem; frm._owned)
			{
				if(elem is this)
				{
					found = да;
					break;
				}
			}
			assert(found);
		}
	}+/
	body
	{
		if(wowner is frm)
			return;
		
		// Remove from old хозяин.
		_removeFromOldOwner();
		wmdiparent = пусто;
		wowner = пусто; // Safety in case of исключение.
		_exStyle(_exStyle() & ~WS_EX_MDICHILD);
		_style((_style() | WS_POPUP) & ~WS_CHILD);
		
		// Add to new хозяин.
		if(frm)
		{
			if(созданУказатель_ли)
			{
				frm.создайУпрЭлт(); // ?
			}
			
			// Copy so that old ownedForms arrays won't get overwritten.
			Форма[] _thisa = new Форма[1]; // DMD 0.123: this can't be а static массив or the append screws up.
			_thisa[0] = this;
			frm._owned = frm._owned ~ _thisa;
			
			wowner = frm;
			if(созданУказатель_ли)
			{
				if(CCompat.DFL095 == _compat)
					SetParent(уок, frm.уок);
				else
					_crecreate();
			}
		}
		else
		{
			if(созданУказатель_ли)
			{
				if(покажиВСтрокеЗадач || CCompat.DFL095 == _compat)
					SetParent(уок, HWND.init);
				else
					_crecreate();
			}
		}
		
		//wowner = frm;
	}
	
	
	final Форма хозяин() // getter
	{
		return wowner;
	}
	
	
		// This function does not work in все cases.
	final проц покажиВСтрокеЗадач(бул подтвержд) // setter
	{
		if(созданУказатель_ли)
		{
			бул vis;
			vis = виден;
			
			if(vis)
			{
				//скрой();
				// Do it directly so that DFL code can't prevent it.
				cbits |= CBits.RECREATING;
				doHide();
			}
			scope(exit)
				cbits &= ~CBits.RECREATING;
			
			if(подтвержд)
			{
				_exStyle(_exStyle() | WS_EX_APPWINDOW);
				
				version(ВИЗ_ПАРК_ОКНО)
				{
					if(_hwPark && GetParent(указатель) == _hwPark)
						SetParent(указатель, HWND.init);
				}
			}
			else
			{
				_exStyle(_exStyle() & ~WS_EX_APPWINDOW);
				
				version(ВИЗ_ПАРК_ОКНО)
				{
					/+ // Not working, the form disappears (probably stuck as а child).
					if(!GetParent(указатель))
					{
						//_style((_style() | WS_POPUP) & ~WS_CHILD);
						
						SetParent(указатель, getParkHwnd());
					}
					+/
					_crecreate();
				}
			}
			
			if(vis)
			{
				//покажи();
				// Do it directly so that DFL code can't prevent it.
				doShow();
			}
		}
		else
		{
			if(подтвержд)
				окДопСтиль |= WS_EX_APPWINDOW;
			else
				окДопСтиль &= ~WS_EX_APPWINDOW;
		}
	}
	
	
	final бул покажиВСтрокеЗадач() // getter
	{
		return (_exStyle() & WS_EX_APPWINDOW) != 0;
	}
	
	
		final проц sizingGrip(бул подтвержд) // setter
	{
		if(grip == подтвержд)
			return;
		
		this.grip = подтвержд;
		
		if(созданУказатель_ли)
		{
			RECT rect;
			_getSizeGripArea(&rect);
			
			InvalidateRect(уок, &rect, TRUE);
		}
	}
	
	
	final бул sizingGrip() // getter
	{
		return grip;
	}
	
	deprecated alias sizingGrip sizeGrip;
	
	
		final проц стартПоз(ПНачПоложениеФормы стартпоз) // setter
	{
		this.стартпоз = стартпоз;
	}
	
	
	final ПНачПоложениеФормы стартПоз() // getter
	{
		return стартпоз;
	}
	
	
		final проц самоеВерхнее(бул подтвержд) // setter
	{
		/+
		if(подтвержд)
			_exStyle(_exStyle() | WS_EX_TOPMOST);
		else
			_exStyle(_exStyle() & ~WS_EX_TOPMOST);
		+/
		
		if(созданУказатель_ли)
		{
			SetWindowPos(указатель, подтвержд ? HWND_TOPMOST : HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
		}
		else
		{
			if(подтвержд)
				окДопСтиль |= WS_EX_TOPMOST;
			else
				окДопСтиль &= ~WS_EX_TOPMOST;
		}
	}
	
	
	final бул самоеВерхнее() // getter
	{
		return (_exStyle() & WS_EX_TOPMOST) != 0;
	}
	
	
		final проц ключПрозрачности(Цвет ктрл) // setter
	{
		if(setLayeredWindowAttributes)
		{
			transKey = ктрл;
			BYTE альфа = opacityToAlpha(opa);
			
			if(ктрл == Цвет.пуст) // Disable
			{
				if(альфа == BYTE.max)
					_exStyle(_exStyle() & ~WS_EX_LAYERED);
				else
					setLayeredWindowAttributes(указатель, 0, альфа, LWA_ALPHA);
			}
			else
			{
				_exStyle(_exStyle() | WS_EX_LAYERED);
				if(созданУказатель_ли)
				{
					//_exStyle(_exStyle() | WS_EX_LAYERED);
					if(альфа == BYTE.max)
						setLayeredWindowAttributes(указатель, ктрл.вКзс(), 0, LWA_COLORKEY);
					else
						setLayeredWindowAttributes(указатель, ктрл.вКзс(), альфа, LWA_COLORKEY | LWA_ALPHA);
				}
			}
		}
	}
	
	
	final Цвет ключПрозрачности() // getter
	{
		return transKey;
	}
	
	
		final проц состояниеОкна(ПСостОкнаФормы состояние) // setter
	{
		// Not sure if виден should be установлен here..
		if(созданУказатель_ли && виден)
		{
			switch(состояние)
			{
				case ПСостОкнаФормы.РАЗВЁРНУТО:
					ShowWindow(указатель, SW_MAXIMIZE);
					//окСтиль = окСтиль & ~WS_MINIMIZE | WS_MAXIMIZE;
					break;
				
				case ПСостОкнаФормы.СВЁРНУТО:
					ShowWindow(указатель, SW_MINIMIZE);
					//окСтиль = окСтиль | WS_MINIMIZE & ~WS_MAXIMIZE;
					break;
				
				case ПСостОкнаФормы.НОРМА:
					ShowWindow(указатель, SW_RESTORE);
					//окСтиль = окСтиль & ~(WS_MINIMIZE | WS_MAXIMIZE);
					break;
			}
			//окСтиль = GetWindowLongA(уок, GWL_STYLE);
		}
		else
		{
			switch(состояние)
			{
				case ПСостОкнаФормы.РАЗВЁРНУТО:
					_style(_style() & ~WS_MINIMIZE | WS_MAXIMIZE);
					break;
				
				case ПСостОкнаФормы.СВЁРНУТО:
					_style(_style() | WS_MINIMIZE & ~WS_MAXIMIZE);
					break;
				
				case ПСостОкнаФормы.НОРМА:
					_style(_style() & ~(WS_MINIMIZE | WS_MAXIMIZE));
					break;
			}
		}
	}
	
	
	final ПСостОкнаФормы состояниеОкна() // getter
	{
		LONG wl;
		//wl = окСтиль = GetWindowLongA(уок, GWL_STYLE);
		wl = _style();
		
		if(wl & WS_MAXIMIZE)
			return ПСостОкнаФормы.РАЗВЁРНУТО;
		else if(wl & WS_MINIMIZE)
			return ПСостОкнаФормы.СВЁРНУТО;
		else
			return ПСостОкнаФормы.НОРМА;
	}
	
	
	protected override проц установиЯдроВидимого(бул подтвержд)
	{
		if(созданУказатель_ли)
		{
			if(виден == подтвержд)
				return;
			
			version(СТАРОЕ_ЗАКРЫТИЕ_МОДАЛЬНОГО)
			{
				if(!wmodal)
				{
					if(подтвержд)
					{
						cbits &= ~CBits.NOCLOSING;
					}
				}
			}
			
			//if(!виден)
			if(подтвержд)
			{
				version(ВИЗ_БЕЗ_ЗОМБИ_ФОРМ)
				{
				}
				else
				{
					nozombie();
				}
				
				if(окСтиль & WS_MAXIMIZE)
				{
					ShowWindow(уок, SW_MAXIMIZE);
					cbits |= CBits.VISIBLE; // ?
					окСтиль |= WS_VISIBLE; // ?
					приИзмененииВидимости(АргиСоб.пуст);
					return;
				}
				/+else if(окСтиль & WS_MINIMIZE)
				{
					ShowWindow(указатель, SW_MINIMIZE);
					приИзмененииВидимости(АргиСоб.пуст);
					cbits |= CBits.VISIBLE; // ?
					окСтиль |= WS_VISIBLE; // ?
					return;
				}+/
			}
		}
		
		return super.установиЯдроВидимого(подтвержд);
	}
	
	
	protected override проц приИзмененииВидимости(АргиСоб ea)
	{
		version(СТАРОЕ_ЗАКРЫТИЕ_МОДАЛЬНОГО)
		{
			if(!wmodal)
			{
				if(виден)
				{
					cbits &= ~CBits.NOCLOSING;
				}
			}
		}
		
		if(!(Приложение._compat & DflCompat.FORM_LOAD_096))
		{
			if(виден)
			{
				if(!(cbits & CBits.FORMLOADED))
				{
					cbits |= CBits.FORMLOADED;
					приЗагрузке(АргиСоб.пуст);
				}
			}
		}
		
		// Ensure УпрЭлт.приИзмененииВидимости is called AFTER приЗагрузке, so приЗагрузке can установи the selection first.
		super.приИзмененииВидимости(ea);
	}
	
	
		final проц активируй()
	{
		if(!созданУказатель_ли)
			return;
		
		//if(!виден)
		//	покажи(); // ?
		
		version(NO_MDI)
		{
		}
		else
		{
			if(мдиОтпрыск_ли)
			{
				// Good, make sure client окно proc уки it too.
				SendMessageA(мдиРодитель.клиентМди.указатель, WM_MDIACTIVATE, cast(WPARAM)указатель, 0);
				return;
			}
		}
		
		//SetActiveWindow(указатель);
		SetForegroundWindow(указатель);
	}
	
	
	override проц удалиУказатель()
	{
		if(!созданУказатель_ли)
			return;
		
		if(мдиОтпрыск_ли)
			DefMDIChildProcA(уок, WM_CLOSE, 0, 0);
		DestroyWindow(уок);
	}
	
	
		final проц закрой()
	{
		if(wmodal)
		{
			/+
			if(ПРезДиалога.НЕУК == fresult)
			{
				fresult = ПРезДиалога.ОТМЕНА;
			}
			+/
			
			version(СТАРОЕ_ЗАКРЫТИЕ_МОДАЛЬНОГО)
			{
				cbits |= CBits.NOCLOSING;
				//doHide();
				установиЯдроВидимого(нет);
				//if(!виден)
				if(!wmodal)
					поЗакрытию(АргиСоб.пуст);
			}
			else
			{
				scope АргиСобОтмены cea = new АргиСобОтмены;
				приЗакрытии(cea);
				if(!cea.отмена)
				{
					wmodal = нет; // Must be нет or will результат in recursion.
					удалиУказатель();
				}
			}
			return;
		}
		
		scope АргиСобОтмены cea = new АргиСобОтмены;
		приЗакрытии(cea);
		if(!cea.отмена)
		{
			//удалиУказатель();
			вымести();
		}
	}
	
	
		final проц разложиМди(РаскладкаМди lay)
	{
		switch(lay)
		{
			case РаскладкаМди.ARRANGE_ICONS:
				SendMessageA(указатель, WM_MDIICONARRANGE, 0, 0);
				break;
			
			case РаскладкаМди.CASCADE:
				SendMessageA(указатель, WM_MDICASCADE, 0, 0);
				break;
			
			case РаскладкаМди.TILE_HORIZONTAL:
				SendMessageA(указатель, WM_MDITILE, MDITILE_HORIZONTAL, 0);
				break;
			
			case РаскладкаМди.TILE_VERTICAL:
				SendMessageA(указатель, WM_MDITILE, MDITILE_VERTICAL, 0);
				break;
		}
	}
	
	
		final проц установиГраницыРабСтола(цел ш, цел в, цел ширина, цел высота)
	{
		границыРабСтола = Прям(ш, в, ширина, высота);
	}
	
	
		final проц установиПоложениеРабСтола(цел ш, цел в)
	{
		положениеРабСтола = Точка(ш, в);
	}
	
	
		final ПРезДиалога покажиДиалог()
	{
		// Use active окно as the хозяин.
		this.sowner = GetActiveWindow();
		if(this.sowner == this.уок) // Possible due to fast flash?
			this.sowner = HWND.init;
		покажиДиалог2();
		return fresult;
	}
	
	
	final ПРезДиалога покажиДиалог(ИОкно iwsowner)
	{
		//this.sowner = iwsowner ? iwsowner.указатель : GetActiveWindow();
		if(!iwsowner)
			return покажиДиалог();
		this.sowner = iwsowner.указатель;
		покажиДиалог2();
		return fresult;
	}
	
	
	// Used internally.
	package final проц покажиДиалог2()
	{
		version(ВИЗ_БЕЗ_ЗОМБИ_ФОРМ)
		{
		}
		else
		{
			nozombie();
		}
		
		LONG wl = _style();
		sownerEnabled = нет;
		
		if(wl & WS_DISABLED)
		{
			debug
			{
				throw new ВизИскл("Невозможно показать диалоговое окно, т.к. оно отключено");
			}
			no_show:
			throw new ВизИскл("Не удаётся показать диалоговое окно");
		}
		
		if(созданУказатель_ли)
		{
			//if(wl & WS_VISIBLE)
			if(виден)
			{
				if(!wmodal && хозяин && sowner == хозяин.указатель)
				{
				}
				else
				{
					debug
					{
						throw new ВизИскл("Не удаётся показать диалог, так как он уже виден");
					}
					goto no_show;
				}
			}
			
			if(sowner == уок)
			{
				bad_владелец:
				debug
				{
					throw new ВизИскл("Неправильный хозяин диалогового окна");
				}
				goto no_show;
			}
			
			//хозяин = пусто;
			//_exStyle(_exStyle() & ~WS_EX_MDICHILD);
			//_style((_style() | WS_POPUP) & ~WS_CHILD);
			//SetParent(уок, sowner);
		}
		
		try
		{
			if(sowner)
			{
				LONG owl = GetWindowLongA(sowner, GWL_STYLE);
				if(owl & WS_CHILD)
					goto bad_владелец;
				
				wowner = cast(Форма)поУказателю(sowner);
				
				if(!(owl & WS_DISABLED))
				{
					sownerEnabled = да;
					EnableWindow(sowner, нет);
				}
			}
			
			покажи();
			
			wmodal = да;
			for(;;)
			{
				if(!Приложение.вершиСобытия())
				{
					wmodal = нет;
					//резДиалога = ПРезДиалога.АБОРТ; // ?
					// Leave it at ПРезДиалога.НЕУК ?
					break;
				}
				if(!wmodal)
					break;
				/+
				//assert(виден);
				if(!виден)
				{
					wmodal = нет;
					break;
				}
				+/
				Приложение.ждиСобытия();
			}
		}
		finally
		{
			if(sownerEnabled)
			{
				EnableWindow(sowner, да); // In case of исключение.
				SetActiveWindow(sowner);
				//SetFocus(sowner);
			}
			
			//if(!wmodal)
			//	DestroyWindow(уок);
			
			wmodal = нет;
			sowner = HWND.init;
			
			//скрой();
			// Do it directly so that DFL code can't prevent it.
			doHide();
			
			version(ВИЗ_БЕЗ_ЗОМБИ_ФОРМ)
			{
			}
			else
			{
				Приложение.вершиСобытия();
				Приложение.зомбируйУок(this); // Zombie; allows this to be GC'd but keep состояние until then.
			}
		}
	}
	
	
	version(ВИЗ_БЕЗ_ЗОМБИ_ФОРМ)
	{
	}
	else
	{
		package final бул nozombie()
		{
			if(this.уок)
			{
				if(!Приложение.отыщиУок(this.уок))
				{
					// Zombie!
					Приложение.раззомбируйУок(this);
					return да;
				}
			}
			return нет;
		}
	}
	
	
	//СобОбработчик активировано;
	Событие!(Форма, АргиСоб) активировано; 	//СобОбработчик дезактивировано;
	Событие!(Форма, АргиСоб) дезактивировано; 	//СобОбработчик закрыто;
	Событие!(Форма, АргиСоб) закрыто; 	//ОбработчикСобытияОтмены закрывается;
	Событие!(Форма, АргиСобОтмены) закрывается; 	//СобОбработчик загрузка;
	Событие!(Форма, АргиСоб) загрузка; 	
	
		protected проц поАктивации(АргиСоб ea)
	{
		активировано(this, ea);
	}
	
	
		protected проц поДезактивации(АргиСоб ea)
	{
		дезактивировано(this, ea);
	}
	
	
	/+
		protected проц onInputLanguageChanged(InputLanguageChangedEventArgs ilcea)
	{
		inputLanguageChanged(this, ilcea);
	}
	
	
		protected проц onInputLanguageChanging(InputLanguageChangingEventArgs ilcea)
	{
		inputLanguageChanging(this, ilcea);
	}
	+/
	
	
		protected проц приЗагрузке(АргиСоб ea)
	{
		загрузка(this, ea);
		
		if(!(Приложение._compat & DflCompat.FORM_LOAD_096))
		{
			// Needed anyway because MDI client form needs it.
			УОК hwfocus = GetFocus();
			if(!hwfocus || !IsChild(уок, hwfocus))
				_selectNextControl(this, пусто, да, да, да, нет);
		}
	}
	
	
	private проц _init()
	{
		_recalcClientSize();
		
		//wicon = new Пиктограмма(LoadIconA(экз.init, IDI_APPLICATION), нет);
		wicon = СистемныеПиктограммы.приложение;
		transKey = Цвет.пуст;
	}
	
	
	this()
	{
		super();
		
		mfilter = new ФильтрСообщенийФормы(this);
		
		// Default border: ПСтильКромкиФормы.НЕФИКС.
		// Default виден: нет.
		окСтиль = WS_OVERLAPPEDWINDOW | WS_CLIPCHILDREN | WS_CLIPSIBLINGS;
		окДопСтиль = /+ WS_EX_CONTROLPARENT | +/ WS_EX_WINDOWEDGE | WS_EX_APPWINDOW;
		cbits |= CBits.FORM;
		
		_init();
	}
	
	
	/+
	// Used internally.
	this(УОК уок)
	{
		super(уок);
		_init();
	}
	+/
	
	
	protected override проц окПроц(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			case WM_COMMAND:
				// Don't let УпрЭлт указатель the WM_COMMAND if it's а default or отмена кнопка;
				// otherwise, the события will be fired twice.
				switch(LOWORD(сооб.парам1))
				{
					case IDOK:
						if(кнпПринять)
						{
							if(HIWORD(сооб.парам1) == BN_CLICKED)
								кнпПринять.выполниКлик();
							return;
						}
						break;
						//return;
					
					case IDCANCEL:
						if(кнпОтменить)
						{
							if(HIWORD(сооб.парам1) == BN_CLICKED)
								кнпОтменить.выполниКлик();
							return;
						}
						break;
						//return;
					
					default: ;
				}
				break;
			
			//case WM_CREATE: // WM_NCCREATE seems like а better choice.
			case WM_NCCREATE:
				// Make sure Windows doesn't magically change the styles.
				SetWindowLongA(уок, GWL_EXSTYLE, окДопСтиль);
				SetWindowLongA(уок, GWL_STYLE, окСтиль & ~WS_VISIBLE);
				
				SetWindowPos(уок, HWND.init, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE
					| SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE); // Recalculate the frame.
				
				_setSystemMenu();
				break;
			
			case WM_WINDOWPOSCHANGING:
				{
					WINDOWPOS* wp = cast(WINDOWPOS*)сооб.парам2;
					
					if(wp.флаги & SWP_HIDEWINDOW)
					{
						if(wmodal)
						{
							version(СТАРОЕ_ЗАКРЫТИЕ_МОДАЛЬНОГО)
							{
								scope АргиСобОтмены cea = new АргиСобОтмены;
								приЗакрытии(cea);
								if(cea.отмена)
								{
									wp.флаги &= ~SWP_HIDEWINDOW; // Cancel.
								}
							}
							else
							{
								wp.флаги &= ~SWP_HIDEWINDOW; // Don't скрой because we're destroying or canceling.
								закрой();
							}
						}
					}
					
					version(ВИЗ_БЕЗ_ЗОМБИ_ФОРМ)
					{
					}
					else
					{
						if(wp.флаги & SWP_SHOWWINDOW)
						{
							nozombie();
						}
					}
				}
				break;
			
			case WM_CLOSE:
				if(!восстановлениеУказателя)
				{
					// Check for this first because дефОкПроц() will destroy the окно.
					/+ // Moved to закрой().
					// version(СТАРОЕ_ЗАКРЫТИЕ_МОДАЛЬНОГО) ...
					fresult = ПРезДиалога.ОТМЕНА;
					if(wmodal)
					{
						doHide();
					}
					else+/
					{
						закрой();
					}
				}
				return;
			
			default: ;
		}
		
		super.окПроц(сооб);
		
		switch(сооб.сооб)
		{
			case WM_NCHITTEST:
				//if(сооб.результат == HTCLIENT || сооб.результат == HTBORDER)
				if(сооб.результат != HTNOWHERE && сооб.результат != HTERROR)
				{
					if(_isPaintingSizeGrip)
					{
						RECT rect;
						_getSizeGripArea(&rect);
						
						Точка тчк;
						тчк.ш = LOWORD(сооб.парам2);
						тчк.в = HIWORD(сооб.парам2);
						тчк = точкаККлиенту(тчк);
						
						if(тчк.ш >= rect.лево && тчк.в >= rect.верх)
							сооб.результат = HTBOTTOMRIGHT;
					}
				}
				break;
			
			case WM_ACTIVATE:
				switch(LOWORD(сооб.парам1))
				{
					case WA_ACTIVE:
					case WA_CLICKACTIVE:
						поАктивации(АргиСоб.пуст);
						break;
					
					case WA_INACTIVE:
						поДезактивации(АргиСоб.пуст);
						break;
					
					default: ;
				}
				break;
			
			case WM_WINDOWPOSCHANGING:
				{
					WINDOWPOS* wp = cast(WINDOWPOS*)сооб.парам2;
					
					/+ // Moved to WM_GETMINMAXINFO.
					if(minsz.ширина && minsz.высота)
					{
						if(wp.cx < minsz.ширина)
							wp.cx = minsz.ширина;
						if(wp.cy < minsz.высота)
							wp.cy = minsz.высота;
					}
					if(maxsz.ширина && maxsz.высота)
					{
						if(wp.cx > minsz.ширина)
							wp.cx = minsz.ширина;
						if(wp.cy > minsz.высота)
							wp.cy = minsz.высота;
					}
					+/
					
					/+
					if(_closingvisible)
					{
						wp.флаги &= ~SWP_HIDEWINDOW;
					}
					+/
					
					if(!(wp.флаги & SWP_NOSIZE))
					{
						if(_isPaintingSizeGrip)
						{
							// This comparison is needed to prevent some painting glitches
							// when moving the окно...
							if(ширина != wp.cx || высота != wp.cy)
							{
								RECT rect;
								_getSizeGripArea(&rect);
								InvalidateRect(уок, &rect, TRUE);
							}
						}
					}
					
					if(wp.флаги & SWP_HIDEWINDOW)
					{
						if(sownerEnabled)
						{
							EnableWindow(sowner, да);
							SetActiveWindow(sowner);
							//SetFocus(sowner);
						}
						
						wmodal = нет;
					}
				}
				break;
			
			case WM_GETMINMAXINFO:
				{
					super.окПроц(сооб);
					
					MINMAXINFO* mmi;
					mmi = cast(MINMAXINFO*)сооб.парам2;
					
					if(minsz.ширина && minsz.высота)
					{
						if(mmi.ptMinTrackSize.ш < minsz.ширина)
							mmi.ptMinTrackSize.ш = minsz.ширина;
						if(mmi.ptMinTrackSize.в < minsz.высота)
							mmi.ptMinTrackSize.в = minsz.высота;
					}
					if(maxsz.ширина && maxsz.высота)
					{
						if(mmi.ptMaxTrackSize.ш > maxsz.ширина)
							mmi.ptMaxTrackSize.ш = maxsz.ширина;
						if(mmi.ptMaxTrackSize.в > maxsz.высота)
							mmi.ptMaxTrackSize.в = maxsz.высота;
					}
					
					// Do this again so that the user's preference isn't
					// outside the Windows valid min/max границы.
					super.окПроц(сооб);
				}
				return;
			
			case WM_DESTROY:
				/+
				if(_closingvisible)
				{
					assert(окСтиль & WS_VISIBLE);
				}
				+/
				if(!восстановлениеУказателя)
				{
					if(!(cbits & CBits.NOCLOSING))
					{
						поЗакрытию(АргиСоб.пуст);
					}
				}
				break;
			
			default: ;
		}
	}
	
	
	package final проц _setSystemMenu()
	{
		HMENU hwm;
		assert(созданУказатель_ли);
		hwm = GetSystemMenu(указатель, FALSE);
		
		switch(стильКромкиФормы)
		{
			case ПСтильКромкиФормы.ФИКС_3М:
			case ПСтильКромкиФормы.ФИКС_ЕДИН:
			case ПСтильКромкиФормы.ФИКС_ДИАЛОГ:
			case ПСтильКромкиФормы.ФИКС_ИНСТР:
				// Fall through.
			case ПСтильКромкиФормы.НЕУК:
				RemoveMenu(hwm, SC_SIZE, MF_BYCOMMAND);
				RemoveMenu(hwm, SC_MAXIMIZE, MF_BYCOMMAND);
				//RemoveMenu(hwm, SC_MINIMIZE, MF_BYCOMMAND);
				RemoveMenu(hwm, SC_RESTORE, MF_BYCOMMAND);
				break;
			
			//case ПСтильКромкиФормы.НЕФИКС:
			//case ПСтильКромкиФормы.НЕФИКС_ИНСТР:
			default: ;
		}
		
		if(!развернутьБокс)
		{
			RemoveMenu(hwm, SC_MAXIMIZE, MF_BYCOMMAND);
		}
		if(!свернутьБокс)
		{
			RemoveMenu(hwm, SC_MINIMIZE, MF_BYCOMMAND);
		}
	}
	
	
	package final проц _resetSystemMenu()
	{
		assert(созданУказатель_ли);
		GetSystemMenu(указатель, TRUE); // Reset.
		_setSystemMenu();
	}
	
	
	/+ package +/ проц _destroying() // package
	{
		_removeFromOldOwner();
		//wowner = пусто;
		wmdiparent = пусто;
		
		Приложение.удалиФильтрСооб(mfilter);
		//mfilter = пусто;
		
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
		}
		else
		{
			if(wmenu)
				wmenu._setHwnd(HWND.init);
		}
		
		super._destroying();
	}
	
	
	/+ package +/ /+ protected +/ цел _rtype() // package
	{
		return мдиОтпрыск_ли ? 2 : 0;
	}
	
	
	package BOOL _isNonMdiChild(УОК hw)
	{
		assert(созданУказатель_ли);
		
		if(!hw || hw == this.уок)
			return нет;
		
		if(IsChild(this.уок, hw))
		{
			version(NO_MDI)
			{
			}
			else
			{
				if(клиентМди && клиентМди.созданУказатель_ли)
				{
					if(IsChild(клиентМди.уок, hw))
						return нет; // !
				}
			}
			return да;
		}
		return нет;
	}
	
	
	package УОК _lastSelBtn; // Last selected кнопка (not necessarily вФокусе), excluding accept кнопка!
	package УОК _lastSel; // Last senected and вФокусе упрэлт.
	package УОК _hadfocus; // Before being deactivated.
	
	
	// Returns if there was а selection.
	package final бул _selbefore()
	{
		бул wasselbtn = нет;
		if(_lastSelBtn)
		{
			wasselbtn = да;
			//if(IsChild(this.уок, _lastSelBtn))
			if(_isNonMdiChild(_lastSelBtn))
			{
				auto lastctrl = УпрЭлт.поУказателю(_lastSelBtn);
				if(lastctrl)
				{
					auto lastibc = cast(ИУпрЭлтКнопка)lastctrl;
					if(lastibc)
						lastibc.сообщиДеф(нет);
				}
			}
		}
		return wasselbtn;
	}
	
	package final проц _selafter(УпрЭлт упрэлм, бул wasselbtn)
	{
		_lastSelBtn = _lastSelBtn.init;
		auto ibc = cast(ИУпрЭлтКнопка)упрэлм;
		if(ibc)
		{
			if(кнопкаПринять)
			{
				if(ibc !is кнопкаПринять)
				{
					кнопкаПринять.сообщиДеф(нет);
					_lastSelBtn = упрэлм.уок;
				}
				//else don't установи _lastSelBtn to accept кнопка.
			}
			else
			{
				_lastSelBtn = упрэлм.уок;
			}
			
			ibc.сообщиДеф(да);
		}
		else
		{
			if(wasselbtn) // Only do it if there was а different кнопка; don't keep doing this.
			{
				if(кнопкаПринять)
					кнопкаПринять.сообщиДеф(да);
			}
		}
	}
	
	package final проц _seldeactivate()
	{
		if(!_selbefore())
		{
			if(кнопкаПринять)
				кнопкаПринять.сообщиДеф(нет);
		}
		//_lastSel = GetFocus(); // Not reliable, especially when minimizing.
	}
	
	package final проц _selactivate()
	{
		if(_lastSel && _isNonMdiChild(_lastSel))
		{
			УпрЭлт упрэлм = УпрЭлт.поУказателюОтпрыска(_lastSel);
			if(упрэлм && упрэлм._hasSelStyle())
			{
				auto ibc = cast(ИУпрЭлтКнопка)упрэлм;
				if(ibc)
				{
					//ibc.сообщиДеф(да);
					упрэлм.выдели();
					return;
				}
				упрэлм.выдели();
			}
			else
			{
				SetFocus(упрэлм.уок);
			}
		}
		if(кнопкаПринять)
		{
			кнопкаПринять.сообщиДеф(да);
		}
	}
	
	// Child can be nested at any level.
	package final проц _selectChild(УпрЭлт упрэлм)
	{
		if(упрэлм.выделяемый)
		{
			бул wasselbtn = _selbefore();
			
			// Need to do some things, like выдели-все for edit.
			DefDlgProcA(this.уок, WM_NEXTDLGCTL, cast(WPARAM)упрэлм.уок, MAKELPARAM(да, 0));
			
			_selafter(упрэлм, wasselbtn);
			
			_lastSel = упрэлм.уок;
		}
	}
	
	package final проц _selectChild(УОК hw)
	{
		УпрЭлт упрэлм = УпрЭлт.поУказателю(hw);
		if(упрэлм)
			_selectChild(упрэлм);
	}
	
	
	private проц _selonecontrol()
	{
		УОК hwfocus = GetFocus();
		if(!hwfocus || hwfocus == уок)
		{
			_selectNextControl(this, пусто, да, да, да, нет);
			if(!GetFocus())
				выдели();
		}
	}
	
	
	package alias viz.x.utf.дефДлгПроц _defFormProc;
	
	protected override проц дефОкПроц(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			/+
			// Not обрабатывается by дефОкПроц() anymore..
			
			case WM_PAINT:
			case WM_PRINT:
			case WM_PRINTCLIENT:
			case WM_ERASEBKGND:
				// DefDlgProc() doesn't let you use а custom background
				// цвет, so call the default окно proc instead.
				super.дефОкПроц(сооб);
				break;
			+/
			
			case WM_SETFOCUS:
				/+
				{
					бул didf = нет;
					перечислиОкнаОтпрыски(сооб.уок,
						(УОК hw)
						{
							auto wl = GetWindowLongA(hw, GWL_STYLE);
							if(((WS_VISIBLE | WS_TABSTOP) == ((WS_VISIBLE | WS_TABSTOP) & wl))
								&& !(WS_DISABLED & wl))
							{
								DefDlgProcA(сооб.уок, WM_NEXTDLGCTL, cast(WPARAM)hw, MAKELPARAM(да, 0));
								didf = да;
								return FALSE;
							}
							return TRUE;
						});
					if(!didf)
						SetFocus(сооб.уок);
				}
				+/
				//_selonecontrol();
				
				version(NO_MDI)
				{
				}
				else
				{
					if(мдиОтпрыск_ли)
					{
						// ?
						//сооб.результат = DefMDIChildProcA(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
						сооб.результат = viz.x.utf.дефМДИОтпрыскПроц(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
						return;
					}
				}
				
				// Prevent DefDlgProc from getting this сообщение because it'll фокус упрэлты it shouldn't.
				return;
			
			case WM_NEXTDLGCTL:
				if(LOWORD(сооб.парам2))
				{
					_selectChild(cast(УОК)сооб.парам1);
				}
				else
				{
					_dlgselnext(this, GetFocus(), сооб.парам1 != 0);
				}
				return;
			
			case WM_ENABLE:
				if(сооб.парам1)
				{
					if(GetActiveWindow() == сооб.уок)
					{
						_selonecontrol();
					}
				}
				break;
			
			case WM_ACTIVATE:
				switch(LOWORD(сооб.парам1))
				{
					case WA_ACTIVE:
					case WA_CLICKACTIVE:
						_selactivate();
						
						/+
						version(NO_MDI)
						{
						}
						else
						{
							if(мдиКонтейнер_ли)
							{
								auto amc = дайАктивныйОтпрыскМди();
								if(amc)
									amc._selactivate();
							}
						}
						+/
						break;
					
					case WA_INACTIVE:
						/+
						version(NO_MDI)
						{
						}
						else
						{
							if(мдиКонтейнер_ли)
							{
								auto amc = дайАктивныйОтпрыскМди();
								if(amc)
									amc._seldeactivate();
							}
						}
						+/
						
						_seldeactivate();
						break;
					
					default: ;
				}
				return;
			
			// Note: WM_MDIACTIVATE here is to the MDI child forms.
			case WM_MDIACTIVATE:
				if(cast(УОК)сооб.парам2 == уок)
				{
					_selactivate();
				}
				else if(cast(УОК)сооб.парам1 == уок)
				{
					_seldeactivate();
				}
				goto def_def;
			
			default: def_def:
				version(NO_MDI)
				{
					//сооб.результат = DefDlgProcA(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
					сооб.результат = _defFormProc(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
				}
				else
				{
					if(клиентМди && клиентМди.созданУказатель_ли && сооб.сооб != WM_SIZE)
						//сооб.результат = DefFrameProcA(сооб.уок, клиентМди.указатель, сооб.сооб, сооб.парам1, сооб.парам2);
						сооб.результат = viz.x.utf.дефФреймПроц(сооб.уок, клиентМди.указатель, сооб.сооб, сооб.парам1, сооб.парам2);
					else if(мдиОтпрыск_ли)
						//сооб.результат = DefMDIChildProcA(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
						сооб.результат = viz.x.utf.дефМДИОтпрыскПроц(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
					else
						//сооб.результат = DefDlgProcA(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
						сооб.результат = _defFormProc(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
				}
		}
	}
	
	
	protected:
	
		проц приЗакрытии(АргиСобОтмены cea)
	{
		закрывается(this, cea);
	}
	
	
		проц поЗакрытию(АргиСоб ea)
	{
		закрыто(this, ea);
	}
	
	
	override проц установиЯдроКлиентскогоРазмера(цел ширина, цел высота)
	{
		RECT к;
		
		к.лево = 0;
		к.верх = 0;
		к.право = ширина;
		к.низ = высота;
		
		LONG wl = _style();
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
			const hasmenu = пусто;
		}
		else
		{
			auto hasmenu = wmenu;
		}
		AdjustWindowRectEx(&к, wl, !(wl & WS_CHILD) && hasmenu, _exStyle());
		
		установиЯдроГраниц(0, 0, к.право - к.лево, к.низ - к.верх, ПЗаданныеПределы.РАЗМЕР);
	}
	
	
	protected override проц установиЯдроГраниц(цел ш, цел в, цел ширина, цел высота, ПЗаданныеПределы задано)
	{
		if(созданУказатель_ли)
		{
			super.установиЯдроГраниц(ш, в, ширина, высота, задано);
		}
		else
		{
			if(задано & ПЗаданныеПределы.X)
				окПрям.ш = ш;
			if(задано & ПЗаданныеПределы.Y)
				окПрям.в = в;
			if(задано & ПЗаданныеПределы.ШИРИНА)
			{
				if(ширина < 0)
					ширина = 0;
				
				окПрям.ширина = ширина;
			}
			if(задано & ПЗаданныеПределы.ВЫСОТА)
			{
				if(высота < 0)
					высота = 0;
				
				окПрям.высота = высота;
			}
			
			_recalcClientSize();
		}
	}
	
	
	// Must be called before указатель creation.
	protected final проц безФильтраСообщений() // package
	{
		nofilter = да;
	}
	
	
	version(NO_MDI) {} else
	{
		protected final КлиентМди клиентМди() // getter
		{ return _mdiClient; }
	}
	
	
	private:
	ИУпрЭлтКнопка кнпПринять, кнпОтменить;
	бул autoscale = да;
	Размер autoscaleBase;
	ПРезДиалога fresult = ПРезДиалога.НЕУК;
	Пиктограмма wicon, wiconSm;
	version(ВИЗ_БЕЗ_МЕНЮ)
	{
	}
	else
	{
		ГлавноеМеню wmenu;
	}
	Размер minsz, maxsz; // {0, 0} means none.
	бул wmodal = нет;
	бул sownerEnabled;
	УОК sowner;
	double opa = 1.0; // Opacity.
	Цвет transKey;
	бул grip = нет;
	ПНачПоложениеФормы стартпоз = ПНачПоложениеФормы.ДЕФПОЛОЖЕНИЕ;
	//ФильтрСообщенийФормы mfilter;
	const ФильтрСообщенийФормы mfilter;
	бул _loaded = нет;
	проц delegate(Объект отправитель, АргиСобБыстрЗапускаФормы ea)[ПКлавиши] _shortcuts;
	Форма[] _owned, _mdiChildren; // Always установи because they can be создан and destroyed at any time.
	Форма wowner = пусто, wmdiparent = пусто;
	//бул _closingvisible;
	бул nofilter = нет;
	
	version(NO_MDI) {} else
	{
		КлиентМди _mdiClient = пусто; // пусто == not MDI container.
	}
	
	
	package static бул нужныВсеКлючи(УОК уок)
	{
		return (SendMessageA(уок, WM_GETDLGCODE, 0, 0) &
			DLGC_WANTALLKEYS) != 0;
	}
	
	
	private static class ФильтрСообщенийФормы: ИФильтрСооб
	{
		protected бул предфильтровкаСообщения(inout Сообщение m)
		{
			version(NO_MDI)
				const бул mdistuff = нет;
			else
				бул mdistuff = form.клиентМди && form.клиентМди.созданУказатель_ли
					&& (form.клиентМди.указатель == m.уок || IsChild(form.клиентМди.указатель, m.уок));
			
			if(mdistuff)
			{
			}
			else if(m.уок == form.указатель || IsChild(form.указатель, m.уок))
			{
				{
					УОК hwfocus = GetFocus();
					// Don't need _isNonMdiChild here; mdistuff excludes MDI stuff.
					if(hwfocus != form._lastSel && IsChild(form.указатель, hwfocus))
						form._lastSel = hwfocus; // ?
				}
				
				switch(m.сооб)
				{
					// Process быстрыйЗапуск ПКлавиши.
					// This should be better than TranslateAccelerator().
					case WM_SYSKEYDOWN:
					case WM_KEYDOWN:
						{
							проц delegate(Объект отправитель, АргиСобБыстрЗапускаФормы ea)* pнажато;
							ПКлавиши k;
							
							k = cast(ПКлавиши)m.парам1 | УпрЭлт.клавишиМодификаторы;
							pнажато = k in form._shortcuts;
							
							if(pнажато)
							{
								scope АргиСобБыстрЗапускаФормы ea = new АргиСобБыстрЗапускаФормы(k);
								(*pнажато)(form, ea);
								return да; // Prevent.
							}
						}
						break;
					
					default: ;
				}
				
				switch(m.сооб)
				{
					case WM_KEYDOWN:
					case WM_KEYUP:
					case WM_CHAR:
						switch(cast(ПКлавиши)m.парам1)
						{
							case ПКлавиши.ENTER:
								if(form.кнопкаПринять)
								{
									viz.x.utf.isDialogMessage(form.указатель, &m._винСооб);
									return да; // Prevent.
								}
								return нет;
							
							case ПКлавиши.ESCAPE:
								if(form.кнопкаОтменить)
								{
									//viz.x.utf.isDialogMessage(form.указатель, &m._винСооб); // Closes the родитель; bad for nested упрэлты.
									if(m.уок == form.указатель || IsChild(form.указатель, m.уок))
									{
										if(WM_KEYDOWN == m.сооб)
										{
											Сообщение mesc;
											mesc.уок = form.указатель;
											mesc.сооб = WM_COMMAND;
											mesc.парам1 = MAKEWPARAM(IDCANCEL, 0);
											//mesc.парам2 = form.кнопкаОтменить.указатель; // указатель isn't here, isn't guaranteed to be, and doesn't matter.
											form.окПроц(mesc);
										}
										return да; // Prevent.
									}
								}
								return нет;
							
							case ПКлавиши.UP, ПКлавиши.DOWN:
							case ПКлавиши.ПРАВ, ПКлавиши.ЛЕВ:
								//if(viz.x.utf.isDialogMessage(form.указатель, &m._винСооб)) // Stopped working after removing controlparent.
								//	return да; // Prevent.
								{
									LRESULT dlgc;
									dlgc = SendMessageA(m.уок, WM_GETDLGCODE, 0, 0);
									if(!(dlgc & (DLGC_WANTALLKEYS | DLGC_WANTARROWS)))
									{
										if(WM_KEYDOWN == m.сооб)
										{
											switch(cast(ПКлавиши)m.парам1)
											{
												case ПКлавиши.UP, ПКлавиши.ЛЕВ:
													// Backwards...
													УпрЭлт._dlgselnext(form, m.уок, нет, нет, да);
													break;
												case ПКлавиши.DOWN, ПКлавиши.ПРАВ:
													// Forwards...
													УпрЭлт._dlgselnext(form, m.уок, да, нет, да);
													break;
												default:
													assert(0);
											}
										}
										return да; // Prevent.
									}
								}
								return нет; // Continue.
							
							case ПКлавиши.TAB:
								{
									LRESULT dlgc;
									УпрЭлт cc;
									dlgc = SendMessageA(m.уок, WM_GETDLGCODE, 0, 0);
									cc = поУказателю(m.уок);
									if(cc)
									{
										if(cc._wantTabKey())
											return нет; // Continue.
									}
									else
									{
										if(dlgc & DLGC_WANTALLKEYS)
											return нет; // Continue.
									}
									//if(dlgc & (DLGC_WANTTAB | DLGC_WANTALLKEYS))
									if(dlgc & DLGC_WANTTAB)
										return нет; // Continue.
									if(WM_KEYDOWN == m.сооб)
									{
										if(GetKeyState(VK_ШИФТ) & 0x8000)
										{
											// Backwards...
											//DefDlgProcA(form.указатель, WM_NEXTDLGCTL, 1, MAKELPARAM(FALSE, 0));
											_dlgselnext(form, m.уок, нет);
										}
										else
										{
											// Forwards...
											//DefDlgProcA(form.указатель, WM_NEXTDLGCTL, 0, MAKELPARAM(FALSE, 0));
											_dlgselnext(form, m.уок, да);
										}
									}
									return да; // Prevent.
								}
								break;
							
							default: ;
						}
						break;
					
					case WM_SYSCHAR:
						{
							/+
							LRESULT dlgc;
							dlgc = SendMessageA(m.уок, WM_GETDLGCODE, 0, 0);
							/+ // Mnemonics bypass want-все-ПКлавиши!
							if(dlgc & DLGC_WANTALLKEYS)
								return нет; // Continue.
							+/
							+/
							
							бул pmnemonic(УОК hw)
							{
								УпрЭлт cc = УпрЭлт.поУказателю(hw);
								//эхо("мнемоника for ");
								if(!cc)
								{
									// To-do: check dlgcode for static/кнопка and process.
									return нет;
								}
								//эхо("'%.*s' ", cc.имя);
								return cc._processMnemonic(cast(дим)m.парам1);
							}
							
							бул foundmhw = нет;
							бул foundmn = нет;
							eachGoodChildHandle(form.указатель,
								(УОК hw)
								{
									if(foundmhw)
									{
										if(pmnemonic(hw))
										{
											foundmn = да;
											return нет; // Break.
										}
									}
									else
									{
										if(hw == m.уок)
											foundmhw = да;
									}
									return да; // Continue.
								});
							if(foundmn)
								return да; // Prevent.
							
							if(!foundmhw)
							{
								// Didn't найди текущий упрэлт, so go from верх-to-низ.
								eachGoodChildHandle(form.указатель,
									(УОК hw)
									{
										if(pmnemonic(hw))
										{
											foundmn = да;
											return нет; // Break.
										}
										return да; // Continue.
									});
							}
							else
							{
								// Didn't найди мнемоника after текущий упрэлт, so go from верх-to-this.
								eachGoodChildHandle(form.указатель,
									(УОК hw)
									{
										if(pmnemonic(hw))
										{
											foundmn = да;
											return нет; // Break.
										}
										if(hw == m.уок)
											return нет; // Break.
										return да; // Continue.
									});
							}
							if(foundmn)
								return да; // Prevent.
						}
						break;
					
					case WM_LBUTTONUP:
					case WM_MBUTTONUP:
					case WM_RBUTTONUP:
						if(m.уок != form.уок)
						{
							УпрЭлт упрэлм = УпрЭлт.поУказателюОтпрыска(m.уок);
							if(упрэлм.вФокусе && упрэлм.выделяемый)
							{
								бул wasselbtn = form._selbefore();
								form._selafter(упрэлм, wasselbtn);
							}
						}
						break;
					
					default: ;
				}
			}
			
			return нет; // Continue.
		}
		
		
		this(Форма form)
		{
			this.form = form;
		}
		
		
		private:
		Форма form;
	}
	
	
	/+
	package final бул _dlgescape()
	{
		if(кнпОтменить)
		{
			кнпОтменить.выполниКлик();
			return да;
		}
		return нет;
	}
	+/
	
	
	final проц _recalcClientSize()
	{
		RECT к;
		к.лево = 0;
		к.право = окПрям.ширина;
		к.верх = 0;
		к.низ = окПрям.высота;
		
		LONG wl = _style();
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
			const hasmenu = пусто;
		}
		else
		{
			auto hasmenu = wmenu;
		}
		AdjustWindowRectEx(&к, wl, hasmenu && !(wl & WS_CHILD), _exStyle());
		
		// Subtract the difference.
		клиентОкРазм = Размер(окПрям.ширина - ((к.право - к.лево) - окПрям.ширина), окПрям.высота - ((к.низ - к.верх) - окПрям.высота));
	}
}


version(NO_MDI) {} else
{
export extern(D) class КлиентМди: СуперКлассУпрЭлта
	{
		private this()
		{
			_initMdiclient();
			
			окСтильКласса = стильКлассаМдиКлиент;
			окСтиль |= WS_VSCROLL | WS_HSCROLL;
			окДопСтиль |= WS_EX_CLIENTEDGE /+ | WS_EX_CONTROLPARENT +/;
			
			док = ПДокСтиль.ЗАПОЛНИТЬ;
		}
	export:	
		
		проц стильКромки(ПСтильКромки bs) // setter
		{
			switch(bs)
			{
				case ПСтильКромки.ФИКС_3М:
					_style(_style() & ~WS_BORDER);
					_exStyle(_exStyle() | WS_EX_CLIENTEDGE);
					break;
					
				case ПСтильКромки.ФИКС_ЕДИН:
					_exStyle(_exStyle() & ~WS_EX_CLIENTEDGE);
					_style(_style() | WS_BORDER);
					break;
					
				case ПСтильКромки.НЕУК:
					_style(_style() & ~WS_BORDER);
					_exStyle(_exStyle() & ~WS_EX_CLIENTEDGE);
					break;
			}

			if(созданУказатель_ли)
			{
				перерисуйПолностью();
			}
		}

		
		ПСтильКромки стильКромки() // getter
		{
			if(_exStyle() & WS_EX_CLIENTEDGE)
				return ПСтильКромки.ФИКС_3М;
			else if(_style() & WS_BORDER)
				return ПСтильКромки.ФИКС_ЕДИН;
			return ПСтильКромки.НЕУК;
		}
		
		
				final проц прокруткаГ(бул подтвержд) // setter
		{
			LONG wl = _style();
			if(подтвержд)
				wl |= WS_HSCROLL;
			else
				wl &= ~WS_HSCROLL;
			_style(wl);
			
			if(созданУказатель_ли)
				перерисуйПолностью();
		}


		
		final бул прокруткаГ() // getter
		{
			return (_style() & WS_HSCROLL) != 0;
		}


				final проц прокруткаВ(бул подтвержд) // setter
		{
			LONG wl = _style();
			if(подтвержд)
				wl |= WS_VSCROLL;
			else
				wl &= ~WS_VSCROLL;
			_style(wl);
			
			if(созданУказатель_ли)
				перерисуйПолностью();
		}
		
		
		/+
		override проц создайУказатель()
		{
			//if(создан)
			if(созданУказатель_ли)
				return;
			
			if(!wowner || удаляется)
			{
				create_err:
				throw new ВизИскл("MDI client creation failure");
			}
			
			CLIENTCREATESTRUCT ccs;
			ccs.hWindowMenu = HMENU.init; //wowner.меню ? wowner.меню.указатель : HMENU.init;
			ccs.idFirstChild = 10000;
			
			Приложение.созданиеУпрЭлта(this);
			уок = viz.x.utf.создайОкноДоп(окДопСтиль, MDICLIENT_CLASSNAME, окТекст, окСтиль, окПрям.ш, окПрям.в,
				окПрям.ширина, окПрям.высота, окРодитель.указатель, HMENU.init, Приложение.дайЭкз(), &ccs);
			if(!уок)
				goto create_err;
			
			поСозданиюУказателя(АргиСоб.пуст);
		}
		+/
		
		
		protected override проц создайПараметры(inout ПарамыСозд cp)
		{
			if(!окРодитель)
				throw new ВизИскл("Неправильный родитель окна-отпрыска MDI");
			
			super.создайПараметры(cp);
			
			cp.имяКласса = MDICLIENT_CLASSNAME;
			
			ccs.hWindowMenu = HMENU.init; //wowner.меню ? wowner.меню.указатель : HMENU.init;
			ccs.idFirstChild = 10000;
			cp.парам = &ccs;
		}
		
		
		static Цвет дефЦветФона() // getter
		{
			return Цвет.системныйЦвет(COLOR_APPWORKSPACE);
		}
		
		
		override Цвет цветФона() // getter
		{
			if(Цвет.пуст == цвфона)
				return дефЦветФона;
			return цвфона;
		}
		
		alias УпрЭлт.цветФона цветФона; // Overload.
		
		
		/+
		static Цвет дефЦветПП() //getter
		{
			return Цвет.системныйЦвет(COLOR_WINDOWTEXT);
		}
		+/
		
		
		protected override проц предшОкПроц(inout Сообщение сооб)
		{
			//сооб.результат = CallWindowProcA(первОкПроцМдиКлиента, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
			сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцМдиКлиента, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		}
		
		
		private:
		CLIENTCREATESTRUCT ccs;
	}
}


private:

version(ВИЗ_ПАРК_ОКНО)
{
	УОК getParkHwnd()
	{
		if(!_hwPark)
		{
			synchronized
			{
				if(!_hwPark)
					_makePark();
			}
		}
		return _hwPark;
	}
	
	
	проц _makePark()
	{
		WNDCLASSEXA wce;
		wce.cbSize = wce.sizeof;
		wce.style = CS_DBLCLKS;
		wce.lpszClassName = PARK_CLASSNAME.ptr;
		wce.lpfnWndProc = &DefWindowProcA;
		wce.hInstance =cast(HINSTANCE) Приложение.дайЭкз();
		
		if(!RegisterClassExA(&wce))
		{
			debug(APP_PRINT)
				эхо("RegisterClassEx() failed for park class.\n");
			
			init_err:
			//throw new ВизИскл("Unable to initialize forms library");
			throw new ВизИскл("Не удаётся создать парковочное окно");
		}
		
		_hwPark = CreateWindowExA(WS_EX_TOOLWINDOW, PARK_CLASSNAME.ptr, "",
			WS_OVERLAPPEDWINDOW, 0, 0, 0, 0,
			HWND.init, HMENU.init, wce.hInstance, пусто);
		if(!_hwPark)
		{
			debug(APP_PRINT)
				эхо("CreateWindowEx() failed for park окно.\n");
			
			goto init_err;
		}
	}
	
	
	const Ткст PARK_CLASSNAME = "VIZ_Parking";
	
	УОК _hwPark; // Don't use directly; use getParkHwnd().
}

