module viz.control;
import viz.common, viz.menu, viz.form, viz.data, viz.app;

debug=EVENT_PRINT;
debug=APP_PRINT;

private struct ЗэтИндексГет
	{
		УпрЭлт найди;
		цел индекс = -1;
		private цел _tmp = 0;
	}
	
export extern(Windows) BOOL обрвызовЗэтИндексГет(HWND уок, LPARAM lparam)
	{
		ЗэтИндексГет* gzi = cast(ЗэтИндексГет*)lparam;
		if(уок == gzi.найди.уок)
		{
			gzi.индекс = gzi._tmp;
			return FALSE; // Stop, found it.
		}
		
		УпрЭлт упрэлм;
		упрэлм = УпрЭлт.поУказателю(уок);
		if(упрэлм && упрэлм.родитель is gzi.найди.родитель)
		{
			gzi._tmp++;
		}
		
		return TRUE; // Keep looking.
	}

package alias BOOL delegate(HWND) EnumWindowsCallback;


// Callback for EnumWindows() and EnumChildWindows().
export extern(Windows) BOOL перечисляемОкна(HWND уок, LPARAM lparam)
{
	EnumWindowsCallback дг = *(cast(EnumWindowsCallback*)lparam);
	return дг(уок);
}


private struct Efi
{
	HWND hwParent;
	EnumWindowsCallback дг;
}


// Callback for EnumChildWindows(). -lparam- = pointer to Efi;
export extern(Windows) BOOL перечисляемПервыеОкна(HWND уок, LPARAM lparam)
{
	Efi* efi = cast(Efi*)lparam;
	if(efi.hwParent == GetParent(уок))
		return efi.дг(уок);
	return да;
}


package BOOL перечислиОкна(EnumWindowsCallback дг)
{
	static assert((&дг).sizeof <= LPARAM.sizeof);
	return EnumWindows(&перечисляемОкна, cast(LPARAM)&дг);
}


package BOOL перечислиОкнаОтпрыски(HWND hwParent, EnumWindowsCallback дг)
{
	static assert((&дг).sizeof <= LPARAM.sizeof);
	return EnumChildWindows(hwParent, &перечисляемОкна, cast(LPARAM)&дг);
}


// Only the родитель's отпрыски, not its отпрыски.
package BOOL перечислиПервыеОтпрыскиОкна(HWND hwParent, EnumWindowsCallback дг)
{
	Efi efi;
	efi.hwParent = hwParent;
	efi.дг = дг;
	return EnumChildWindows(hwParent, &перечисляемПервыеОкна, cast(LPARAM)&efi);
}

	
/// УпрЭлт class.
export extern(D) class УпрЭлт: Объект, ИОкно // docmain
{

export extern(D) class КоллекцияУпрЭлтов
	{
	export:
		 this(УпрЭлт хозяин)
		{
			_владелец = хозяин;
			debug(APP_PRINT) скажинс(_владелец.вТкст());
		}
		
		цел длина() // getter
		{
			if(_владелец.созданУказатель_ли)
			{
				// Inefficient :(
				бцел len = 0;
				foreach(УпрЭлт упрэлм; this)
				{
					len++;
				}
				return len;
			}
			else
			{
				return отпрыски.length;
			}
		}
				
		УпрЭлт opIndex(цел i) // getter
		{
			if(_владелец.созданУказатель_ли)
			{
				цел oni = 0;
				foreach(УпрЭлт упрэлм; this)
				{
					if(oni == i)
						return упрэлм;
					oni++;
				}
				// Index out of границы, bad things happen.
				assert(0);
				return пусто;
			}
			else
			{
				return отпрыски[i];
			}
		}		
		
		проц добавь(УпрЭлт упрэлм)
		{
			упрэлм.родитель = _владелец;
		}
		// opIn ?
		бул содержит(УпрЭлт упрэлм)
		{
			return индексУ(упрэлм) != -1;
		}		
		
		цел индексУ(УпрЭлт упрэлм)
		{
			if(_владелец.созданУказатель_ли)
			{
				цел i = 0;
				цел foundi = -1;
				
				
				BOOL перечисляем(HWND уок)
				{
					if(уок == упрэлм.указатель)
					{
						foundi = i;
						return нет; // Stop.
					}
					
					i++;
					return да; // Continue.
				}
				
				
				перечислиПервыеОтпрыскиОкна(cast(HWND)_владелец.указатель, &перечисляем);
				return foundi;
			}
			else
			{
				foreach(цел i, УпрЭлт onCtrl; отпрыски)
				{
					if(onCtrl == упрэлм)
						return i;
				}
				return -1;
			}
		}
		
		проц удали(УпрЭлт упрэлм)
		{
			if(_владелец.созданУказатель_ли)
			{
				_removeCreated(упрэлм.указатель);
			}
			else
			{
				цел i = индексУ(упрэлм);
				if(i != -1)
					_removeNotCreated(i);
			}
		}		
		
		private проц _removeCreated(HWND уок)
		{
			DestroyWindow(уок); // ?
		}		
		
		package проц _removeNotCreated(цел i)
		{
			if(!i)
				отпрыски = отпрыски[1 .. отпрыски.length];
			else if(i == отпрыски.length - 1)
				отпрыски = отпрыски[0 .. i];
			else
				отпрыски = отпрыски[0 .. i] ~ отпрыски[i + 1 .. отпрыски.length];
		}		
		
		проц удалиПо(цел i)
		{
			if(_владелец.созданУказатель_ли)
			{
				цел ith = 0;
				HWND окн;
				
				
				BOOL перечисляем(HWND уок)
				{
					if(ith == i)
					{
						окн = уок;
						return нет; // Stop.
					}
					
					ith++;
					return да; // Continue.
				}
				
				
				перечислиПервыеОтпрыскиОкна(_владелец.указатель, &перечисляем);
				if(окн)
					_removeCreated(окн);
			}
			else
			{
				_removeNotCreated(i);
			}
		}
				
		 final УпрЭлт хозяин() // getter
		{
			return _владелец;
		}
		
		
		цел opApply(цел delegate(inout УпрЭлт) дг)
		{
			цел результат = 0;
			
			if(_владелец.созданУказатель_ли)
			{
				BOOL перечисляем(HWND уок)
				{
					УпрЭлт упрэлм = Приложение.отыщиУок(уок);
					if(упрэлм)
					{
						результат = дг(упрэлм);
						if(результат)
							return нет; // Stop.
					}
					
					return да; // Continue.
				}
				
				
			перечислиПервыеОтпрыскиОкна(_владелец.указатель, &перечисляем);
			}
			else
			{
				foreach(УпрЭлт упрэлм; отпрыски)
				{
					результат = дг(упрэлм);
					if(результат)
						break;
				}
			}
			
			return результат;
		}
		
		mixin OpApplyAddIndex!(opApply, УпрЭлт);
		
		
		//package:
		УпрЭлт _владелец;
		УпрЭлт[] отпрыски; // Only valid if -хозяин- isn't создан yet (or is recreating).
		
		
		/+
		final проц _array_swap(цел ifrom, цел ito)
		{
			if(ifrom == ito ||
				ifrom < 0 || ito < 0 ||
				ifrom >= length || ito >= length)
				return;
			
			УпрЭлт cto;
			cto = отпрыски[ito];
			отпрыски[ito] = отпрыски[ifrom];
			отпрыски[ifrom] = cto;
		}
		+/
		
		
		final проц _simple_front_one(цел i)
		{
			if(i < 0 || i >= длина - 1)
				return;
			
			отпрыски = отпрыски[0 .. i] ~ отпрыски[i + 1 .. i + 2] ~ отпрыски[i .. i + 1] ~ отпрыски[i + 2 .. отпрыски.length];
		}
		
		
		final проц _simple_front_one(УпрЭлт ктрл)
		{
			return _simple_front_one(индексУ(ктрл));
		}
		
		
		final проц _simple_back_one(цел i)
		{
			if(i <= 0 || i >= длина)
				return;
			
			отпрыски = отпрыски[0 .. i - 1] ~ отпрыски[i + 1 .. i + 2] ~ отпрыски[i .. i + 1] ~ отпрыски[i + 2 .. отпрыски.length];
		}
		
		
		final проц _simple_back_one(УпрЭлт ктрл)
		{
			return _simple_back_one(индексУ(ктрл));
		}
		
		
		final проц _simple_back(цел i)
		{
			if(i <= 0 || i >= длина)
				return;
			
			отпрыски = отпрыски[i .. i + 1] ~ отпрыски[0 .. i] ~ отпрыски[i + 1 .. отпрыски.length];
		}
		
		
		final проц _simple_back(УпрЭлт ктрл)
		{
			return _simple_back(индексУ(ктрл));
		}
		
		
		final проц _simple_front(цел i)
		{
			if(i < 0 || i >= длина - 1)
				return;
			
			отпрыски = отпрыски[0 .. i] ~ отпрыски[i + 1 .. отпрыски.length] ~ отпрыски[i .. i + 1];
		}
		
		
		final проц _simple_front(УпрЭлт ктрл)
		{
			return _simple_front(индексУ(ктрл));
		}
	}
//////
export:

	private проц _ctrladded(АргиСобУпрЭлта cea)
	{
		if(Приложение._compat & DflCompat.КОНТРОЛ_PARENT_096)
		{
			if(!(_exStyle() & WS_EX_CONTROLPARENT))
			{
				if(!(cbits & CBits.FORM))
				{
					//if((cea.упрэлт._style() & WS_TABSTOP) || (cea.упрэлт._exStyle() & WS_EX_CONTROLPARENT))
						_exStyle(_exStyle() | WS_EX_CONTROLPARENT);
				}
			}
		}
		else
		{
			assert(дайСтиль(ПСтилиУпрЭлта.КОНТЕЙНЕР), "УпрЭлт добавлен не в родительский контейнер");
		}
		
		приДобавленииУпрЭлта(cea);
	}
	
	
	private проц _ctrlremoved(АргиСобУпрЭлта cea)
	{
		н_раскладка(cea.упрэлт);
		
		приУдаленииУпрЭлта(cea);
	}
	
	
	 проц приДобавленииУпрЭлта(АргиСобУпрЭлта cea)
	{
		добавленУпрЭлт(this, cea);
	}
	
	
	 проц приУдаленииУпрЭлта(АргиСобУпрЭлта cea)
	{
		удалёнУпрЭлт(this, cea);
	}
	
	
	final HWND указатель() // ИОкно getter
	{
		if(!созданУказатель_ли)
		{
			debug(APP_PRINT) 
				скажиф("УпрЭлт создан по запросу указателя.\n");
			
			создайУказатель();
		}
		
		return уок;
	}
	
проц разрешиБрос(бул подтвержд) // setter
		{
			/+
			if(dyes)
				_exStyle(_exStyle() | WS_EX_ACCEPTFILES);
			else
				_exStyle(_exStyle() & ~WS_EX_ACCEPTFILES);
			+/
			
			if(подтвержд)
			{
				if(!цельброса)
				{
					цельброса = new ЦельБроска(this);
					if(созданУказатель_ли)
					{
						switch(RegisterDragDrop(cast(HWND) уок, cast(winapi.IDropTarget) цельброса))
						{
							case S_OK:
							case DRAGDROP_E_ALREADYREGISTERED: // Hmm.
								break;
							
							default:
								цельброса = пусто;
								throw new ВизИскл("Не удаётся зарегистрировать drag-drop");
						}
					}
				}
			}
			else
			{
				delete цельброса;
				цельброса = пусто;
				RevokeDragDrop(уок);
			}
		}
				
		бул разрешиБрос() // getter
		{
			/+
			return (_exStyle() & WS_EX_ACCEPTFILES) != 0;
			+/
			
			return цельброса !is пусто;
		}
	
		
	/+
	deprecated проц anchor(ПСтилиЯкоря а) // setter
	{
		/+
		anch = а;
		if(!(anch & (ПСтилиЯкоря.ЛЕВ | ПСтилиЯкоря.ПРАВ)))
			anch |= ПСтилиЯкоря.ЛЕВ;
		if(!(anch & (ПСтилиЯкоря.ВЕРХ | ПСтилиЯкоря.НИЗ)))
			anch |= ПСтилиЯкоря.ВЕРХ;
		+/
		
		sdock = ПДокСтиль.НЕУК; // Can't be установи at the same time.
	}
	
	
	deprecated ПСтилиЯкоря anchor() // getter
	{
		//return anch;
		return cast(ПСтилиЯкоря)(ПСтилиЯкоря.ЛЕВ | ПСтилиЯкоря.ВЕРХ);
	}
	+/
	
	
	private проц _propagateBackColorAmbience()
	{
		Цвет bc;
		bc = цветФона;
		
		
		проц pa(УпрЭлт pc)
		{
			foreach(УпрЭлт упрэлм; pc.коллекция)
			{
				if(Цвет.пуст == упрэлм.цвфона) // If default.
				{
					if(bc == упрэлм.цветФона) // If same default.
					{
						упрэлм.удалиЭтуКистьЗП(); // Needs to be recreated with new цвет.
						упрэлм.приИзмененииЦветаФона(АргиСоб.пуст);
						
						pa(упрэлм); // Recursive.
					}
				}
			}
		}
		
		
		pa(this);
	}
	
	
	 проц приИзмененииЦветаФона(АргиСоб ea)
	{
		debug(EVENT_PRINT)
		{
			скажиф("{ Событие: приИзмененииЦветаФона - УпрЭлт %s }\n", имя);
		}
		
		цветФонаИзменён(this, ea);
	}
	
	
		проц цветФона(Цвет ктрл) // setter
	{
		if(цвфона == ктрл)
			return;
		
		удалиЭтуКистьЗП(); // Needs to be recreated with new цвет.
		цвфона = ктрл;
		приИзмененииЦветаФона(АргиСоб.пуст);
		
		_propagateBackColorAmbience();
		if(созданУказатель_ли)
			инвалидируй(да); // Redraw!
	}
	
	
	Цвет цветФона() // getter
	{
		if(Цвет.пуст == цвфона)
		{
			if(родитель)
			{
				return родитель.цветФона;
			}
			return дефЦветФона;
		}
		return цвфона;
	}
	
	
		final цел низ() // getter
	{
		return окПрям.низ;
	}
	
	
		final проц границы(Прям к) // setter
	{
		установиЯдроГраниц(к.ш, к.в, к.ширина, к.высота, ПЗаданныеПределы.ВСЕ);
	}
	
	
	final Прям границы() // getter
	{
		return окПрям;
	}
	
	
	/+
	final Прям originalBounds() // getter package
	{
		return oldwrect;
	}
	+/
	
	
		 проц установиЯдроГраниц(цел ш, цел в, цел ширина, цел высота, ПЗаданныеПределы задано)
	{
		// Make sure at least one флаг is установи.
		//if(!(задано & ПЗаданныеПределы.ВСЕ))
		if(!задано)
			return;
		
		if(созданУказатель_ли)
		{
			UINT swpf = SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE;
			
			if(задано & ПЗаданныеПределы.X)
			{
				if(!(задано & ПЗаданныеПределы.Y))
					в = this.верх();
				swpf &= ~SWP_NOMOVE;
			}
			else if(задано & ПЗаданныеПределы.Y)
			{
				ш = this.лево();
				swpf &= ~SWP_NOMOVE;
			}
			
			if(задано & ПЗаданныеПределы.ШИРИНА)
			{
				if(!(задано & ПЗаданныеПределы.ВЫСОТА))
					высота = this.высота();
				swpf &= ~SWP_NOSIZE;
			}
			else if(задано & ПЗаданныеПределы.ВЫСОТА)
			{
				ширина = this.ширина();
				swpf &= ~SWP_NOSIZE;
			}
			
			SetWindowPos(уок, HWND.init, ш, в, ширина, высота, swpf);
			// Window события will обнови -окПрям-.
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
				клиентОкРазм.ширина = ширина;
			}
			if(задано & ПЗаданныеПределы.ВЫСОТА)
			{
				if(высота < 0)
					высота = 0;
				
				окПрям.высота = высота;
				клиентОкРазм.высота = высота;
			}
			
			//oldwrect = окПрям;
		}
	}
		
	final бул фокусируемый() // getter
	{
		/+
		LONG wl = _style();
		return /+ уок && +/ (wl & WS_VISIBLE) && !(wl & WS_DISABLED);
		+/
		//return виден && включен;
		// Don't need to check -созданУказатель_ли- because IsWindowVisible() will fail from а пусто HWND.
		return /+ созданУказатель_ли && +/ IsWindowVisible(cast(HWND) уок) && IsWindowEnabled(cast(HWND) уок);
	}
	
	final бул выделяемый() // getter
	out(результат)
	{
		if(результат)
		{
			assert(созданУказатель_ли);
		}
	}
	body
	{
		// All родитель упрэлты need to be виден and включен, too.
		// Don't need to check -созданУказатель_ли- because IsWindowVisible() will fail from а пусто HWND.
		return /+ созданУказатель_ли && +/ (ктрлСтиль & ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ) &&
			IsWindowVisible(cast(HWND) уок) && IsWindowEnabled(cast(HWND) уок);
	}
	
	
	package final бул _hasSelStyle()
	{
		return дайСтиль(ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ);
	}
		
		// Returns да if this упрэлт has the mouse захвати.
	final бул захвати() // getter
	{
		return созданУказатель_ли && уок == GetCapture();
	}
		
	final проц захвати(бул cyes) // setter
	{
		if(cyes)
			SetCapture(cast(HWND) уок);
		else
			ReleaseCapture();
	}
		
	final Прям клиентскийПрямоугольник() // getter
	{
		return Прям(Точка(0, 0), клиентОкРазм);
	}
	
	
	final бул содержит(УпрЭлт упрэлм)
	{
		//return коллекция.содержит(упрэлм);
		return упрэлм && упрэлм.родитель is this;
	}
	
	
	final Размер клиентРазм() // getter
	{
		return клиентОкРазм;
	}
	
	
	final проц клиентРазм(Размер разм) // setter
	{
		установиЯдроКлиентскогоРазмера(разм.ширина, разм.высота);
	}
	
	
	 проц установиЯдроКлиентскогоРазмера(цел ширина, цел высота)
	{
		/+
		if(созданУказатель_ли)
			установиЯдроГраниц(0, 0, ширина, высота, ПЗаданныеПределы.РАЗМЕР);
		
		//клиентОкРазм = Размер(ширина, высота);
		+/
		
		ПРЯМ к;
		
		к.лево = 0;
		к.верх = 0;
		к.право = ширина;
		к.низ = высота;
		
		AdjustWindowRectEx(cast(RECT*)&к, _style(), FALSE, _exStyle());
		
		установиЯдроГраниц(0, 0, к.право - к.лево, к.низ - к.верх, ПЗаданныеПределы.РАЗМЕР);
	}
	
	
		// This окно or one of its отпрыски has фокус.
	final бул содержитФокус() // getter
	{
		if(!созданУказатель_ли)
			return нет;
		
		HWND hwfocus = GetFocus();
		return hwfocus == уок || IsChild(cast(HWND) уок, hwfocus);
	}
	
	 проц приИзмененииКонтекстногоМеню(АргиСоб ea)
		{
			контекстноеМенюИзменено(this, ea);
		}
			
	проц контекстноеМеню(КонтекстноеМеню меню) // setter
		{
			if(cmenu is меню)
				return;
			
			cmenu = меню;
			
			if(созданУказатель_ли)
			{
				приИзмененииКонтекстногоМеню(АргиСоб.пуст);
			}
		}
		
		
	КонтекстноеМеню контекстноеМеню() // getter
		{
			return cmenu;
		}
		
	final КоллекцияУпрЭлтов упрэлты() // getter
	{
	//скажифнс("Проверка упрэлтов");
		//return new КоллекцияУпрЭлтов(this);
		return this.коллекция;
	}
		
	final бул создан() // getter
	{
		// To-do: only return да when создайУказатель finishes.
		// Will also need to обнови uses of создан/созданУказатель_ли.
		// Return нет again when вымещается/удаляется.
		//return созданУказатель_ли;
		return созданУказатель_ли || восстановлениеУказателя;
	}
	
	
	private проц _propagateCursorAmbience()
	{
		Курсор cur;
		cur = курсор;
		
		
		проц pa(УпрЭлт pc)
		{
			foreach(УпрЭлт упрэлм; pc.коллекция)
			{
				if(упрэлм.окКурс is пусто) // If default.
				{
					if(cur is упрэлм.курсор) // If same default.
					{
						упрэлм.приИзмененииКурсора(АргиСоб.пуст);
						
						pa(упрэлм); // Recursive.
					}
				}
			}
		}
		
		
		pa(this);
	}
		
	проц приИзмененииКурсора(АргиСоб ea)
	{
		/+
		debug(EVENT_PRINT)
		{
			скажиф("{ Событие: приИзмененииКурсора - УпрЭлт %.*s }\n", имя);
		}
		+/
		
		if(созданУказатель_ли)
		{
			if(виден && включен)
			{
				Точка curpt = Курсор.положение;
				if(уок == WindowFromPoint(cast(POINT) curpt.точка))
				{
					SendMessageA(уок, WM_SETCURSOR, cast(WPARAM)уок,
						MAKELPARAM(
							SendMessageA(уок, WM_NCHITTEST, 0, MAKELPARAM(curpt.ш, curpt.в)),
							WM_MOUSEMOVE)
							);
				}
			}
		}
		
		курсорИзменён(this, ea);
	}
		
	проц курсор(Курсор cur) // setter
	{
		if(cur is окКурс)
			return;
		
		окКурс = cur;
		приИзмененииКурсора(АргиСоб.пуст);
		
		_propagateCursorAmbience();
	}
		
	Курсор курсор() // getter
	{
		if(!окКурс)
		{
			if(родитель)
			{
				return родитель.курсор;
			}
			return _defaultCursor;
		}
		return окКурс;
	}
		
	static Цвет дефЦветФона() // getter
	{
		return Цвет.системныйЦвет(COLOR_BTNFACE);
	}
		
	static Цвет дефЦветПП() //getter
	{
		return Цвет.системныйЦвет(COLOR_BTNTEXT);
	}
		
	private static Шрифт _deffont = пусто;
	
	private static Шрифт _createOldFont()
	{
		return new Шрифт(cast(HFONT)GetStockObject(DEFAULT_GUI_FONT), нет);
	}
		
	private static Шрифт _createCompatibleFont()
	{
		Шрифт результат;
		//результат = _createOldFont();
		
		try
		{
			OSVERSIONINFOA osi;
			osi.dwOSVersionInfoSize = osi.sizeof;
			if(GetVersionExA(&osi) && osi.dwMajorVersion >= 5)
			{
				// "MS Shell Dlg" / "MS Shell Dlg 2" not always supported.
				результат = new Шрифт("MS Shell Dlg 2", результат.дайРазмер(ЕдиницаГрафики.ТОЧКА), ЕдиницаГрафики.ТОЧКА);
			}
		}
		catch
		{
		}
		
		if(!результат)
			результат = _createOldFont();
		
		return результат;
	}
	
	
	private static Шрифт _createNativeFont()
	{
		Шрифт результат;
		
		NONCLIENTMETRICSA ncm;
		ncm.cbSize = ncm.sizeof;
		if(!SystemParametersInfoA(SPI_GETNONCLIENTMETRICS, ncm.sizeof, &ncm, 0))
		{
			результат = _createCompatibleFont();
		}
		else
		{
			результат = new Шрифт(&ncm.lfMessageFont, да);
		}
		
		return результат;
	}
	
	
	private static проц _setDeffont(ПШрифтУпрЭлта cf)
	{
		synchronized
		{
			assert(_deffont is пусто);
			switch(cf)
			{
				case ПШрифтУпрЭлта.СОВМЕСТИМЫЙ:
					_deffont = _createCompatibleFont();
					break;
				case ПШрифтУпрЭлта.ИСКОННЫЙ:
					_deffont = _createNativeFont();
					break;
				case ПШрифтУпрЭлта.СТАРЫЙ:
					_deffont = _createOldFont();
					break;
				default:
					assert(0);
			}
		}
	}
	
	static проц дефШрифт(ПШрифтУпрЭлта cf) // setter
	{
		if(_deffont)
			throw new ВизИскл("Шрифт управляющему элементу уже назначен");
		_setDeffont(cf);
	}
		
	static проц дефШрифт(Шрифт f) // setter
	{
		if(_deffont)
			throw new ВизИскл("Шрифт управляющему элементу уже назначен");
		_deffont = f;
	}
		
	static Шрифт дефШрифт() // getter
	{
		if(!_deffont)
		{
			_setDeffont(ПШрифтУпрЭлта.СОВМЕСТИМЫЙ);
		}
		
		return _deffont;
	}
		
	package static class БезопасныйКурсор: Курсор
	{
	export:
		this(УКурсор hcur)
		{
			super(hcur, нет);
		}
		
		
		override проц вымести()
		{
		}

	}
		
	package static Курсор _defaultCursor() // getter
	{
		static Курсор def = пусто;
		
		if(!def)
		{
			synchronized
			{
				if(!def)
					def = new БезопасныйКурсор(LoadCursorA(экз.init, IDC_ARROW));
			}
		}
		
		return def;
	}
	
	
	Прям выведиПрямоугольник() // getter
	{
		return клиентскийПрямоугольник;
	}
	
		// проц onDockChanged(АргиСоб ea)
	 проц приИзменённомРасположении(АргиСоб ea)
	{
		if(родитель)
			родитель.н_раскладка(this);
		
		//
		докИзменён(this, ea);
		измененаРазметка(this, ea);
	}
	
	alias приИзменённомРасположении onDockChanged;
	
	
	private final проц _alreadyLayout()
	{
		throw new ВизИскл("Управляющий элемент уже имеет разметку");
	}
	
	
		ПДокСтиль док() // getter
	{
		return sdock;
	}
	
	
	проц док(ПДокСтиль ds) // setter
	{
		if(ds == sdock)
			return;
		
		ПДокСтиль _olddock = sdock;
		sdock = ds;
		/+
		anch = ПСтилиЯкоря.НЕУК; // Can't be установи at the same time.
		+/
		
		if(ПДокСтиль.НЕУК == ds)
		{
			if(ПДокСтиль.НЕУК != _olddock) // If it was even docking before; don't unset естьРасположение for something else.
				естьРасположение = нет;
		}
		else
		{
			// Ensure not replacing some other разметка, but ОК if replacing another док.
			if(ПДокСтиль.НЕУК == _olddock)
			{
				if(естьРасположение)
					_alreadyLayout();
			}
			естьРасположение = да;
		}
		
		/+ // Called by естьРасположение.
		if(созданУказатель_ли)
		{
			onDockChanged(АргиСоб.пуст);
		}
		+/
	}
	
	
	/// Get or установи whether or not this упрэлт currently has its границы managed. Fires приИзменённомРасположении as needed.
	final бул естьРасположение() // getter
	{
		if(cbits & CBits.HAS_LAYOUT)
			return да;
		return нет;
	}
	
	
	final проц естьРасположение(бул подтвержд) // setter
	{
		//if(подтвержд == естьРасположение)
		//	return; // No! setting this property again must trigger приИзменённомРасположении again.
		
		if(подтвержд)
			cbits |= CBits.HAS_LAYOUT;
		else
			cbits &= ~CBits.HAS_LAYOUT;
		
		if(подтвержд) // No need if разметка is removed.
		{
			if(созданУказатель_ли)
			{
				приИзменённомРасположении(АргиСоб.пуст);
			}
		}
	}
		
	package final проц _venabled(бул подтвержд)
	{
		if(созданУказатель_ли)
		{
			EnableWindow(уок, подтвержд);
			// Window события will обнови -окСтиль-.
		}
		else
		{
			if(подтвержд)
				окСтиль &= ~WS_DISABLED;
			else
				окСтиль |= WS_DISABLED;
		}
	}
		
	final проц включен(бул подтвержд) // setter
	{
		if(подтвержд)
			cbits |= CBits.ENABLED;
		else
			cbits &= ~CBits.ENABLED;
		
		_venabled(подтвержд);
	}
	
	final бул включен() // getter
	{
		/*
		return IsWindowEnabled(уок) ? да : нет;
		*/
		
		return (окСтиль & WS_DISABLED) == 0;
	}
	
	
	private проц _propagateEnabledAmbience()
	{
		/+ // Isn't working...
		if(cbits & CBits.FORM)
			return;
		
		бул en = включен;
		
		проц pa(УпрЭлт pc)
		{
			foreach(УпрЭлт упрэлм; pc.коллекция)
			{
				if(упрэлм.cbits & CBits.ENABLED)
				{
					_venabled(en);
					
					pa(упрэлм);
				}
			}
		}
		
		pa(this);
		+/
	}
	
	
	final проц включи()
	{
		включен = да;
	}
	
	
	final проц отключи()
	{
		включен = нет;
	}
	
	
		бул вФокусе() // getter
	{
		//return созданУказатель_ли && уок == GetFocus();
		return создан && поУказателюОтпрыска(GetFocus()) is this;
	}
	
	
		проц шрифт(Шрифт f) // setter
	{
		if(окШрифт is f)
			return;
		
		окШрифт = f;
		if(созданУказатель_ли)
			SendMessageA(cast(HWND) уок, WM_SETFONT, cast(WPARAM)окШрифт.указатель, MAKELPARAM(да, 0));
		приИзмененииШрифта(АргиСоб.пуст);
		
		_propagateFontAmbience();
	}
	
	
	Шрифт шрифт() // getter
	{
		if(!окШрифт)
		{
			if(родитель)
			{
				return родитель.шрифт;
			}
			return дефШрифт;
		}
		return окШрифт;
	}
	
	
	private проц _propagateForeColorAmbience()
	{
		Цвет fc;
		fc = цветПП;
		
		
		проц pa(УпрЭлт pc)
		{
			foreach(УпрЭлт упрэлм; pc.коллекция)
			{
				if(Цвет.пуст == упрэлм.цвпп) // If default.
				{
					if(fc == упрэлм.цветПП) // If same default.
					{
						упрэлм.приИзмененииЦветаПП(АргиСоб.пуст);
						
						pa(упрэлм); // Recursive.
					}
				}
			}
		}
		
		
		pa(this);
	}
	
	
		 проц приИзмененииЦветаПП(АргиСоб ea)
	{
		debug(EVENT_PRINT)
		{
			скажиф("{ Событие: приИзмененииЦветаПП - УпрЭлт %s }\n", имя);
		}
		
		цветППИзменён(this, ea);
	}
	
	
		проц цветПП(Цвет ктрл) // setter
	{
		if(ктрл == цвпп)
			return;
		
		цвпп = ктрл;
		приИзмененииЦветаПП(АргиСоб.пуст);
		
		_propagateForeColorAmbience();
		if(созданУказатель_ли)
			инвалидируй(да); // Redraw!
	}
	
	
	Цвет цветПП() // getter
	{
		if(Цвет.пуст == цвпп)
		{
			if(родитель)
			{
				return родитель.цветПП;
			}
			return дефЦветПП;
		}
		return цвпп;
	}
	
	
		// Doesn't cause а КоллекцияУпрЭлтов to be constructed so
	// it could improve performance when walking through отпрыски.
	final бул естьОтпрыски() // getter
	{
		//return созданУказатель_ли && GetWindow(уок, GW_CHILD) != HWND.init;
		
		if(созданУказатель_ли)
		{
			return GetWindow(cast(HWND) уок, GW_CHILD) != HWND.init;
		}
		else
		{
			return коллекция.отпрыски.length != 0;
		}
	}
	
	
		final проц высота(цел h) // setter
	{
		/*
		ПРЯМ rect;
		GetWindowRect(уок, &rect);
		SetWindowPos(уок, HWND.init, 0, 0, rect.право - rect.лево, h, SWP_NOACTIVATE | SWP_NOZORDER | SWP_NOMOVE);
		*/
		
		установиЯдроГраниц(0, 0, 0, h, ПЗаданныеПределы.ВЫСОТА);
	}
	
	
	final цел высота() // getter
	{
		return окПрям.высота;
	}
	
	
		final бул созданУказатель_ли() // getter
	{
		return уок != HWND.init;
	}
	
	
		final проц лево(цел l) // setter
	{
		/*
		ПРЯМ rect;
		GetWindowRect(уок, &rect);
		SetWindowPos(уок, HWND.init, l, rect.верх, 0, 0, SWP_NOACTIVATE | SWP_NOZORDER | SWP_NOSIZE);
		*/
		
		установиЯдроГраниц(l, 0, 0, 0, ПЗаданныеПределы.X);
	}
	
	
	final цел лево() // getter
	{
		return окПрям.ш;
	}
	
	
	/// Property: get or установи the X and Y положение of the упрэлт.
	final проц положение(Точка тчк) // setter
	{
		/*
		SetWindowPos(уок, HWND.init, тчк.ш, тчк.в, 0, 0, SWP_NOACTIVATE | SWP_NOZORDER | SWP_NOSIZE);
		*/
		
		установиЯдроГраниц(тчк.ш, тчк.в, 0, 0, ПЗаданныеПределы.ПОЛОЖЕНИЕ);
	}
	
	
	final Точка положение() // getter
	{
		return окПрям.положение;
	}
	
	
	/// Currently deнажато modifier ПКлавиши.
	static ПКлавиши клавишиМодификаторы() // getter
	{
		// Is there а better way to do this?
		ПКлавиши ks = ПКлавиши.НЕУК;
		if(GetAsyncKeyState(VK_SHIFT) & 0x8000)
			ks |= ПКлавиши.ШИФТ;
		if(GetAsyncKeyState(VK_MENU) & 0x8000)
			ks |= ПКлавиши.АЛЬТ;
		if(GetAsyncKeyState(VK_CONTROL) & 0x8000)
			ks|= ПКлавиши.КОНТРОЛ;
		return ks;
	}
	
	/// Currently deнажато mouse buttons.
	static ПКнопкиМыши кнопкиМыши() // getter
	{
		ПКнопкиМыши результат;
		
		результат = ПКнопкиМыши.НЕУК;
		if(GetSystemMetrics(SM_SWAPBUTTON))
		{
			if(GetAsyncKeyState(VK_LBUTTON) & 0x8000)
				результат |= ПКнопкиМыши.ПРАВ; // Swapped.
			if(GetAsyncKeyState(VK_RBUTTON) & 0x8000)
				результат |= ПКнопкиМыши.ЛЕВ; // Swapped.
		}
		else
		{
			if(GetAsyncKeyState(VK_LBUTTON) & 0x8000)
				результат |= ПКнопкиМыши.ЛЕВ;
			if(GetAsyncKeyState(VK_RBUTTON) & 0x8000)
				результат |= ПКнопкиМыши.ПРАВ;
		}
		if(GetAsyncKeyState(VK_MBUTTON) & 0x8000)
			результат |= ПКнопкиМыши.СРЕДН;
		
		return результат;
	}
	
	static Точка позМыши() // getter
	{
		Точка тчк;
		GetCursorPos(cast(POINT*)&тчк.точка);
		return тчк;
	}
		
	/// Property: get or установи the имя of this упрэлт used in code.
	final проц имя(Ткст txt) // setter
	{
		_ctrlname = txt;
	}
		
	final Ткст имя() // getter
	{
		return _ctrlname;
	}
		
	 проц приИзмененииРодителя(АргиСоб ea)
	{
		debug(EVENT_PRINT)
		{
			скажиф("{ Событие: приИзмененииРодителя - УпрЭлт %s }\n", имя);
		}
		
		родительИзменён(this, ea);
	}
	
	
	/+
		// ea is the new родитель.
	 проц onParentChanging(АргиСобУпрЭлта ea)
	{
	}
	+/	
	final Форма найдиФорму()
	{
		Форма f;
		УпрЭлт ктрл;
		
		ктрл = this;
		for(;;)
		{
			f = cast(Форма)ктрл;
			if(f)
				break;
			ктрл = ктрл.родитель;
			if(!ктрл)
				return пусто;
		}
		return f;
	}
		
	final проц родитель(УпрЭлт ктрл) // setter
	{
		if(ктрл is окРодитель)
			return;
		
		if(!(_style() & WS_CHILD) || (_exStyle() & WS_EX_MDICHILD))
			throw new ВизИскл("Не удаётся добавить в элементу управления высокоуровневый элемент");
		
		//scope АргиСобУпрЭлта pcea = new АргиСобУпрЭлта(ктрл);
		//onParentChanging(pcea);
		
		УпрЭлт старРодитель;
		_FixAmbientOld старИнфо;
		
		старРодитель = окРодитель;
		
		if(старРодитель)
		{
			старИнфо.установи(старРодитель);
			
			if(!старРодитель.созданУказатель_ли)
			{
				цел oi = старРодитель.упрэлты.индексУ(this);
				//assert(-1 != oi); // Fails if the родитель (and thus this) уки destroyed.
				if(-1 != oi)
					старРодитель.упрэлты._removeNotCreated(oi);
			}
		}
		else
		{
			старИнфо.установи(this);
		}
		
		scope АргиСобУпрЭлта cea = new АргиСобУпрЭлта(this);
		
		if(ктрл)
		{
			окРодитель = ктрл;
			
			// I want the destroy notification. Don't need it anymore.
			//ктрл._exStyle(ктрл._exStyle() & ~WS_EX_NOPARENTNOTIFY);
			
			if(ктрл.созданУказатель_ли)
			{
				cbits &= ~CBits.NEED_INIT_LAYOUT;
				
				//if(создан)
				if(созданУказатель_ли)
				{
					SetParent(cast(HWND) уок, ктрл.уок);
				}
				else
				{
					// If the родитель is создан, create me!
					создайУпрЭлт();
				}
				
				приИзмененииРодителя(АргиСоб.пуст);
				if(старРодитель)
					старРодитель._ctrlremoved(cea);
				ктрл._ctrladded(cea);
				_fixAmbient(&старИнфо);
				
				//скажинс("Вызов отсюда");
				иницРаскладку();
			}
			else
			{
				// If the родитель exists and isn't создан, need to добавь
				// -this- to its отпрыски array.
				ктрл.коллекция.отпрыски ~= this;
				
				приИзмененииРодителя(АргиСоб.пуст);
				if(старРодитель)
					старРодитель._ctrlremoved(cea);
				ктрл._ctrladded(cea);
				_fixAmbient(&старИнфо);
				
				cbits |= CBits.NEED_INIT_LAYOUT;
			}
		}
		else
		{
			assert(ктрл is пусто);
			//окРодитель = ктрл;
			окРодитель = пусто;
			
			if(созданУказатель_ли)
				SetParent(cast(HWND) уок, HWND.init);
			
			приИзмененииРодителя(АргиСоб.пуст);
			assert(старРодитель !is пусто);
			старРодитель._ctrlremoved(cea);
			_fixAmbient(&старИнфо);
		}
	}
		
	final УпрЭлт родитель() // getter
	{
		return окРодитель;
	}
		
	private final УпрЭлт _fetchParent()
	{
		HWND hwParent = GetParent(cast(HWND) уок);
		return поУказателю(hwParent);
	}
		
	// TODO: check implementation.
	private static HRGN dupHrgn(HRGN hrgn)
	{
		HRGN rdup = CreateRectRgn(0, 0, 1, 1);
		CombineRgn(rdup, hrgn, HRGN.init, RGN_COPY);
		return rdup;
	}
	
	
		final проц регион(Регион rgn) // setter
	{
		if(созданУказатель_ли)
		{
			// Need to make а копируй of the регион.
			SetWindowRgn(cast(HWND) уок, dupHrgn(rgn.указатель), да);
		}
		
		окРегион = rgn;
	}
	
	
	final Регион регион() // getter
	{
		return окРегион;
	}
	
	
	private final Регион _fetchRegion()
	{
		HRGN hrgn = CreateRectRgn(0, 0, 1, 1);
		GetWindowRgn(cast(HWND) уок, hrgn);
		return new Регион(hrgn); // Owned because GetWindowRgn() gives а копируй.
	}
	
	
		final цел право() // getter
	{
		return окПрям.право;
	}
	
	
	/+
	проц справаНалево(бул подтвержд) // setter
	{
		LONG wl = _exStyle();
		if(подтвержд)
			wl |= WS_EX_RTLREADING;
		else
			wl &= ~WS_EX_RTLREADING;
		_exStyle(wl);
	}
	
	
	бул справаНалево() // getter
	{
		return (_exStyle() & WS_EX_RTLREADING) != 0;
	}
	+/
	
	
	deprecated проц справаНалево(бул подтвержд) // setter
	{
		справаНалево = подтвержд ? ПСправаНалево.ДА : ПСправаНалево.НЕТ;
	}
	
	
	package final проц _fixRtol(ПСправаНалево val)
	{
		switch(val)
		{
			case ПСправаНалево.НАСЛЕДОВАТЬ:
				if(родитель && родитель.справаНалево == ПСправаНалево.ДА)
				{
					goto case ПСправаНалево.ДА;
				}
				goto case ПСправаНалево.НЕТ;
				break;
			
			case ПСправаНалево.ДА:
				_exStyle(_exStyle() | WS_EX_RTLREADING);
				break;
			
			case ПСправаНалево.НЕТ:
				_exStyle(_exStyle() & ~WS_EX_RTLREADING);
				break;
			
			default:
				assert(0);
		}
		
		//инвалидируй(да); // Children too in case they inherit.
		инвалидируй(нет); // Since отпрыски are enumerated.
	}
	
	
	private проц _propagateRtolAmbience()
	{
		ПСправаНалево rl;
		rl = справаНалево;
		
		
		проц pa(УпрЭлт pc)
		{
			if(ПСправаНалево.НАСЛЕДОВАТЬ == pc.пнал)
			{
				//pc._fixRtol(пнал);
				pc._fixRtol(rl); // Set the specific родитель значение so it doesn't have to look up the chain.
				
				foreach(УпрЭлт упрэлм; pc.коллекция)
				{
					упрэлм.приИзмененииСправаНалево(АргиСоб.пуст);
					
					pa(упрэлм);
				}
			}
		}
		
		
		pa(this);
	}
	
	
		проц справаНалево(ПСправаНалево val) // setter
	{
		if(пнал != val)
		{
			пнал = val;
			приИзмененииСправаНалево(АргиСоб.пуст);
			_propagateRtolAmbience(); // Also sets the class стиль and invalidates.
		}
	}
	
	
	// Returns ДА or НЕТ; if inherited, returns родитель's setting.
	ПСправаНалево справаНалево() // getter
	{
		if(ПСправаНалево.НАСЛЕДОВАТЬ == пнал)
		{
			return родитель ? родитель.справаНалево : ПСправаНалево.НЕТ;
		}
		return пнал;
	}
	
	
	package struct _FixAmbientOld
	{
		Шрифт шрифт;
		Курсор курсор;
		Цвет цветФона;
		Цвет цветПП;
		ПСправаНалево справаНалево;
		//CBits cbits;
		бул включен;
		
		
		проц установи(УпрЭлт упрэлм)
		{
			if(упрэлм)
			{
				шрифт = упрэлм.шрифт;
				курсор = упрэлм.курсор;
				цветФона = упрэлм.цветФона;
				цветПП = упрэлм.цветПП;
				справаНалево = упрэлм.справаНалево;
				//cbits = упрэлм.cbits;
				включен = упрэлм.включен;
			}
			/+else
			{
				шрифт = пусто;
				курсор = пусто;
				цветФона = Цвет.пуст;
				цветПП = Цвет.пуст;
				справаНалево = ПСправаНалево.НАСЛЕДОВАТЬ;
				//cbits = CBits.init;
				включен = да;
			}+/
		}
	}
	
	
	// This is called when the inherited ambience changes.
	package final проц _fixAmbient(_FixAmbientOld* старИнфо)
	{
		// Note: исключение will screw things up.
		
		_FixAmbientOld новИнфо;
		if(родитель)
			новИнфо.установи(родитель);
		else
			новИнфо.установи(this);
		
		if(ПСправаНалево.НАСЛЕДОВАТЬ == пнал)
		{
			if(новИнфо.справаНалево !is старИнфо.справаНалево)
			{
				приИзмененииСправаНалево(АргиСоб.пуст);
				_propagateRtolAmbience();
			}
		}
		
		if(Цвет.пуст == цвфона)
		{
			if(новИнфо.цветФона !is старИнфо.цветФона)
			{
				приИзмененииЦветаФона(АргиСоб.пуст);
				_propagateBackColorAmbience();
			}
		}
		
		if(Цвет.пуст == цвпп)
		{
			if(новИнфо.цветПП !is старИнфо.цветПП)
			{
				приИзмененииЦветаПП(АргиСоб.пуст);
				_propagateForeColorAmbience();
			}
		}
		
		if(!окШрифт)
		{
			if(новИнфо.шрифт !is старИнфо.шрифт)
			{
				приИзмененииШрифта(АргиСоб.пуст);
				_propagateFontAmbience();
			}
		}
		
		if(!окКурс)
		{
			if(новИнфо.курсор !is старИнфо.курсор)
			{
				приИзмененииКурсора(АргиСоб.пуст);
				_propagateCursorAmbience();
			}
		}
		
		/+
		if(новИнфо.включен != старИнфо.включен)
		{
			if(cbits & CBits.ENABLED)
			{
				_venabled(новИнфо.включен);
				_propagateEnabledAmbience();
			}
		}
		+/
	}
	
	
	/+
	package final проц _fixAmbientChildren()
	{
		foreach(УпрЭлт упрэлм; коллекция.отпрыски)
		{
			упрэлм._fixAmbient();
		}
	}
	+/
	
	
		final проц размер(Размер разм) // setter
	{
		/*
		SetWindowPos(уок, HWND.init, 0, 0, разм.ширина, разм.высота, SWP_NOACTIVATE | SWP_NOZORDER | SWP_NOMOVE);
		*/
		
		установиЯдроГраниц(0, 0, разм.ширина, разм.высота, ПЗаданныеПределы.РАЗМЕР);
	}
	
	
	final Размер размер() // getter
	{
		return окПрям.размер; // struct Размер, not sizeof.
	}
	
	
	/+
	final проц табИндекс(цел i) // setter
	{
		// TODO: ?
	}
	
	
	final цел табИндекс() // getter
	{
		return tabidx;
	}
	+/
	
	
	// Use -зэдИндекс- instead.
	// -табИндекс- may return different значения in the future.
	deprecated цел табИндекс() // getter
	{
		return зэдИндекс;
	}
	
	
		final цел зэдИндекс() // getter
	out(результат)
	{
		assert(результат >= 0);
	}
	body
	{
		if(!родитель)
			return 0;
		
		if(созданУказатель_ли)
		{
			ЗэтИндексГет gzi;
			gzi.найди = this;
			EnumChildWindows(cast(HWND) родитель.уок, &обрвызовЗэтИндексГет, cast(LPARAM)&gzi);
			return gzi.индекс;
		}
		else
		{
			return родитель.упрэлты.индексУ(this);
		}
	}
	
	
		// True if упрэлт can be tabbed to.
	final проц табСтоп(бул подтвержд) // setter
	{
		LONG wl = _style();
		if(подтвержд)
			wl |= WS_TABSTOP;
		else
			wl &= ~WS_TABSTOP;
		_style(wl);
	}
	
	
	final бул табСтоп() // getter
	{
		return (_style() & WS_TABSTOP) != 0;
	}
	
	
	/// Property: get or установи additional данные tagged onto the упрэлт.
	final проц тэг(Объект o) // setter
	{
		окТэг = o;
	}
	
	
	final Объект тэг() // getter
	{
		return окТэг;
	}
	
	
	private final Ткст _fetchText()
	{
		return дайТекстОкна(уок);
	}
	
	
		проц текст(Ткст txt) // setter
	{
		if(созданУказатель_ли)
		{
			if(ктрлСтиль & ПСтилиУпрЭлта.CACHE_TEXT)
			{
				//if(окТекст == txt)
				//	return;
				окТекст = txt;
			}
			
			установиТекстОкна(уок, txt);
		}
		else
		{
			окТекст = txt;
		}
	}
	
	
	Ткст текст() // getter
	{
		if(созданУказатель_ли)
		{
			if(ктрлСтиль & ПСтилиУпрЭлта.CACHE_TEXT)
				return окТекст;
			
			return _fetchText();
		}
		else
		{
			return окТекст;
		}
	}
	
	
		final проц верх(цел t) // setter
	{
		установиЯдроГраниц(0, t, 0, 0, ПЗаданныеПределы.Y);
	}
	
	
	final цел верх() // getter
	{
		return окПрям.в;
	}
	
	
	/// Returns the topmost УпрЭлт related to this упрэлт.
	// Returns the хозяин упрэлт that has нет родитель.
	// Returns this УпрЭлт if нет хозяин ?
	final УпрЭлт высокоуровневыйУпрЭлт() // getter
	{
		if(созданУказатель_ли)
		{
			HWND hwCurrent = cast(HWND) уок;
			HWND hwParent;
			
			for(;;)
			{
				hwParent = GetParent(hwCurrent); // This gets the верх-level one, whereas the previous code jumped owners.
				if(!hwParent)
					break;
				
				hwCurrent = hwParent;
			}
			
			return поУказателю(hwCurrent);
		}
		else
		{
			УпрЭлт упрэлм;
			упрэлм = this;
			while(упрэлм.родитель)
			{
				упрэлм = упрэлм.родитель; // This shouldn't jump owners..
			}
			return упрэлм;
		}
	}
	
	
	/+
	private DWORD _fetchVisible()
	{
		//return IsWindowVisible(уок) != FALSE;
		окСтиль = GetWindowLongA(уок, GWL_STYLE);
		return окСтиль & WS_VISIBLE;
	}
	+/
	
	
		final проц виден(бул подтвержд) // setter
	{
		установиЯдроВидимого(подтвержд);
	}
	
	
	final бул виден() // getter
	{
		//if(созданУказатель_ли)
		//	окСтиль = GetWindowLongA(уок, GWL_STYLE); // ...
		//return (окСтиль & WS_VISIBLE) != 0;
		return (cbits & CBits.VISIBLE) != 0;
	}
	
	
		final проц ширина(цел w) // setter
	{
		установиЯдроГраниц(0, 0, w, 0, ПЗаданныеПределы.ШИРИНА);
	}
	
	
	final цел ширина() // getter
	{
		return окПрям.ширина;
	}
	
	
		final проц поместиНазад()
	{
		if(!созданУказатель_ли)
		{
			if(родитель)
				родитель.коллекция._simple_front(this);
			return;
		}
		
		SetWindowPos(cast(HWND) уок, HWND_BOTTOM, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
	}
	
	
		final проц выведиВперёд()
	{
		if(!созданУказатель_ли)
		{
			if(родитель)
				родитель.коллекция._simple_back(this);
			return;
		}
		
		SetWindowPos(cast(HWND) уок, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
		//BringWindowToTop(уок);
	}
	
	
	deprecated alias выведиВышеНаОдно zIndexUp;
	
		// Move up one.
	final проц выведиВышеНаОдно()
	{
		if(!созданУказатель_ли)
		{
			if(родитель)
				родитель.коллекция._simple_front_one(this);
			return;
		}
		
		HWND hw;
		
		// Need to перемещение back twice because the previous one already precedes this one.
		hw = GetWindow(cast(HWND) уок, GW_HWNDPREV);
		if(!hw)
		{
			hw = HWND_TOP;
		}
		else
		{
			hw = GetWindow(hw, GW_HWNDPREV);
			if(!hw)
				hw = HWND_TOP;
		}
		
		SetWindowPos(cast(HWND) уок, hw, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
	}
	
	
	deprecated alias поместиНижеНаОдно zIndexDown;
	
		// Move back one.
	final проц поместиНижеНаОдно()
	{
		if(!созданУказатель_ли)
		{
			if(родитель)
				родитель.коллекция._simple_back_one(this);
			return;
		}
		
		HWND hw;
		
		hw = GetWindow(cast(HWND) уок, GW_HWNDNEXT);
		if(!hw)
			hw = HWND_BOTTOM;
		
		SetWindowPos(cast(HWND) уок, hw, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOSIZE);
	}
	
	
	// Note: да if нет отпрыски, even if this not создан.
	package final бул отпрыскиСозданы_ли() // getter
	{
		return !коллекция.отпрыски.length;
	}
	
	
	package final проц создайОтпрыски()
	{
		assert(созданУказатель_ли);
		
		УпрЭлт[] ctrls;
		ctrls = коллекция.отпрыски;
		коллекция.отпрыски = пусто;
		
		foreach(УпрЭлт упрэлм; ctrls)
		{
			assert(упрэлм.родитель is this);
			assert(!(упрэлм is пусто));
			assert(упрэлм);
			упрэлм.создайУпрЭлт();
		}
	}
	
	
		// Force creation of the окно and its child упрэлты.
	final проц создайУпрЭлт()
	{
		создайУказатель();
		
		// Called in WM_CREATE also.
		создайОтпрыски();
	}
	
	
	/// Returns а new Графика object for this упрэлт, creating the упрэлт указатель if necessary.
	final Графика создайГрафику()
	{
		HDC hdc = GetDC(указатель); // Create указатель as necessary.
		SetTextColor(hdc, цветПП.вКзс());
		return new ОбщаяГрафика(уок, hdc);
	}
	
	
	version(VIZ_NO_DRAG_DROP) {} else
	{
		static class ЦельБроска: ВизКомОбъект, winapi.IDropTarget
		{
		export:
			this(УпрЭлт упрэлм)
			{
				this.упрэлм = упрэлм;
			}
			
			
			export extern(Windows):
			override HRESULT QueryInterface(IID* riid, проц** ppv)
			{
				if(*riid == _IID_IDropTarget)
				{
					*ppv = cast(проц*)cast(winapi.IDropTarget)this;
					AddRef();
					return S_OK;
				}
				else if(*riid == _IID_IUnknown)
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
			
			
			HRESULT DragEnter(winapi.IDataObject pDataObject, DWORD grfKeyState, POINTL тчк, DWORD *pdwEffect)
			{
				HRESULT результат;
				
				try
				{
					//объДанных = new КомВОбъектДанных(pDataObject);
					проверьОбъДанных(pDataObject);
					
					scope АргиСобДрэг ea = new АргиСобДрэг(объДанных, cast(цел)grfKeyState, тчк.ш, тчк.в, 
						cast(ПЭффектыДД)*pdwEffect, ПЭффектыДД.НЕУК); // ?
					упрэлм.приДрэгВошёл(ea);
					*pdwEffect = ea.эффект;
					
					результат = S_OK;
				}
				catch(Объект e)
				{
					Приложение.приИсклНити(e);
					
					результат = E_UNEXPECTED;
				}
				
				return результат;
			}
			
			
			HRESULT DragOver(DWORD grfKeyState, POINTL тчк, DWORD *pdwEffect)
			{
				HRESULT результат;
				
				try
				{
					assert(объДанных !is пусто);
					
					scope АргиСобДрэг ea = new АргиСобДрэг(объДанных, cast(цел)grfKeyState, тчк.ш, тчк.в, 
						cast(ПЭффектыДД)*pdwEffect, ПЭффектыДД.НЕУК); // ?
					упрэлм.приДрэгНад(ea);
					*pdwEffect = ea.эффект;
					
					результат = S_OK;
				}
				catch(Объект e)
				{
					Приложение.приИсклНити(e);
					
					результат = E_UNEXPECTED;
				}
				
				return результат;
			}
			
			
			HRESULT DragLeave()
			{
				HRESULT результат;
				
				try
				{
					упрэлм.приДрэгВышел(АргиСоб.пуст);
					
					удалиОбъДанных();
					
					результат = S_OK;
				}
				catch(Объект e)
				{
					Приложение.приИсклНити(e);
					
					результат = E_UNEXPECTED;
				}
				
				return результат;
			}
			
			
			HRESULT Drop(winapi.IDataObject pDataObject, DWORD grfKeyState, POINTL тчк, DWORD *pdwEffect)
			{
				HRESULT результат;
				
				try
				{
					//assert(объДанных !is пусто);
					проверьОбъДанных(pDataObject);
					
					scope АргиСобДрэг ea = new АргиСобДрэг(объДанных, cast(цел)grfKeyState, тчк.ш, тчк.в, 
						cast(ПЭффектыДД)*pdwEffect, ПЭффектыДД.НЕУК); // ?
					упрэлм.приДрэгБрос(ea);
					*pdwEffect = ea.эффект;
					
					результат = S_OK;
				}
				catch(Объект e)
				{
					Приложение.приИсклНити(e);
					
					результат = E_UNEXPECTED;
				}
				
				return результат;
			}
			
			
			private:
			
			УпрЭлт упрэлм;
			//viz.data.ИОбъектДанных объДанных;
			КомВОбъектДанных объДанных;
			
			
			проц проверьОбъДанных(winapi.IDataObject pDataObject)
			{
				if(!объДанных || !объДанных.такойЖеОбъектДанных_ли(pDataObject))
				{
					объДанных = new КомВОбъектДанных(pDataObject);
				}
			}
			
			
			проц удалиОбъДанных()
			{
				// Can't do this because the COM object might still need to be released elsewhere.
				//delete объДанных;
				//объДанных = пусто;
			}
		}
		
		
				 проц приДрэгВышел(АргиСоб ea)
		{
			дрэгВыход(this, ea);
		}
		
		
				 проц приДрэгВошёл(АргиСобДрэг ea)
		{
			дрэгВход(this, ea);
		}
		
		
				 проц приДрэгНад(АргиСобДрэг ea)
		{
			дрэгНад(this, ea);
		}
		
		
				 проц приДрэгБрос(АргиСобДрэг ea)
		{
			дрэгДроп(this, ea);
		}
		
		
		static class ИстокБроска: ВизКомОбъект, winapi.IDropSource
		{
		export:
			this(УпрЭлт упрэлм)
			{
				this.упрэлм = упрэлм;
				mbtns = УпрЭлт.кнопкиМыши;
			}
			
			
			export extern(Windows):
			override HRESULT QueryInterface(IID* riid, проц** ppv)
			{
				if(*riid == _IID_IDropSource)
				{
					*ppv = cast(проц*)cast(winapi.IDropSource)this;
					AddRef();
					return S_OK;
				}
				else if(*riid == _IID_IUnknown)
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
			
			
			HRESULT QueryContinueDrag(BOOL fEscapePressed, DWORD grfKeyState)
			{
				HRESULT результат;
				
				try
				{
					ПДрэгДействие act;
					
					if(fEscapePressed)
					{
						act = cast(ПДрэгДействие)ПДрэгДействие.ОТМЕНА;
					}
					else
					{
						if(mbtns & ПКнопкиМыши.ЛЕВ)
						{
							if(!(grfKeyState & MK_LBUTTON))
							{
								act = cast(ПДрэгДействие)ПДрэгДействие.БРОС;
								goto qdoit;
							}
						}
						else
						{
							if(grfKeyState & MK_LBUTTON)
							{
								act = cast(ПДрэгДействие)ПДрэгДействие.ОТМЕНА;
								goto qdoit;
							}
						}
						if(mbtns & ПКнопкиМыши.ПРАВ)
						{
							if(!(grfKeyState & MK_RBUTTON))
							{
								act = cast(ПДрэгДействие)ПДрэгДействие.БРОС;
								goto qdoit;
							}
						}
						else
						{
							if(grfKeyState & MK_RBUTTON)
							{
								act = cast(ПДрэгДействие)ПДрэгДействие.ОТМЕНА;
								goto qdoit;
							}
						}
						if(mbtns & ПКнопкиМыши.СРЕДН)
						{
							if(!(grfKeyState & MK_MBUTTON))
							{
								act = cast(ПДрэгДействие)ПДрэгДействие.БРОС;
								goto qdoit;
							}
						}
						else
						{
							if(grfKeyState & MK_MBUTTON)
							{
								act = cast(ПДрэгДействие)ПДрэгДействие.ОТМЕНА;
								goto qdoit;
							}
						}
						
						act = cast(ПДрэгДействие)ПДрэгДействие.ПРОДОЛЖЕНИЕ;
					}
					
					qdoit:
					scope АргиСобДрэгОпросПродолжить ea = new АргиСобДрэгОпросПродолжить(cast(цел)grfKeyState,
						fEscapePressed != FALSE, act); // ?
					упрэлм.приПродолженииДрэгОпроса(ea);
					
					результат = cast(HRESULT)ea.действие;
				}
				catch(Объект e)
				{
					Приложение.приИсклНити(e);
					
					результат = E_UNEXPECTED;
				}
				
				return результат;
			}
			
			
			HRESULT GiveFeedback(DWORD dwEffect)
			{
				HRESULT результат;
				
				try
				{
					scope АргиСобФидбэк ea = new АргиСобФидбэк(cast(ПЭффектыДД)dwEffect, да);
					упрэлм.приПодачеФидбэка(ea);
					
					результат = ea.испДефКурсоры ? DRAGDROP_S_USEDEFAULTCURSORS : S_OK;
				}
				catch(Объект e)
				{
					Приложение.приИсклНити(e);
					
					результат = E_UNEXPECTED;
				}
				
				return результат;
			}
			
			
			private:
			УпрЭлт упрэлм;
			ПКнопкиМыши mbtns;
		}
		
		
		 проц приПродолженииДрэгОпроса(АргиСобДрэгОпросПродолжить ea)
		{
			запросПродолжитьДрэг(this, ea);
		}
		
		
		 проц приПодачеФидбэка(АргиСобФидбэк ea)
		{
			подачаФидбэка(this, ea);
		}
		
		
		/// Perform а drag/drop operation.
		final ПЭффектыДД выполниДД(ИОбъектДанных объДанных, ПЭффектыДД разрешённыеЭффекты)
		{
			Объект foo = cast(Объект)объДанных; // Hold а reference to the Объект...
			
			DWORD эффект;
			ИстокБроска dropsrc;
			winapi.IDataObject dropdata;
			
			dropsrc = new ИстокБроска(this);
			dropdata = new DtoComDataObject(объДанных);
			
			// объДанных seems to be killed too early.
			switch(DoDragDrop(cast(winapi.IDataObject) dropdata, cast(winapi.IDropSource) dropsrc, cast(DWORD)разрешённыеЭффекты, &эффект))
			{
				case DRAGDROP_S_DROP: // All good.
					break;
				
				case DRAGDROP_S_CANCEL:
					return ПЭффектыДД.НЕУК; // ?
				
				default:
					throw new ВизИскл("Unable to complete drag-drop operation");
			}
			
			return cast(ПЭффектыДД)эффект;
		}
		
		
		final ПЭффектыДД выполниДД(Данные объ, ПЭффектыДД разрешённыеЭффекты)
		{
			ИОбъектДанных dd;
			dd = new ОбъектДанных;
			dd.установиДанные(объ);
			return выполниДД(dd, разрешённыеЭффекты);
		}
	}
	
	
	override т_рав opEquals(Объект o)
	{
		УпрЭлт упрэлм = cast(УпрЭлт)o;
		if(!упрэлм)
			return 0; // Not equal.
		return opEquals(упрэлм);
	}
	
	
	т_рав opEquals(УпрЭлт упрэлм)
	{
		if(!созданУказатель_ли)
			return super.opEquals(упрэлм);
		return уок == упрэлм.уок;
	}
	
	
	override цел opCmp(Объект o)
	{
		УпрЭлт упрэлм = cast(УпрЭлт)o;
		if(!упрэлм)
			return -1;
		return opCmp(упрэлм);
	}
	
	
	цел opCmp(УпрЭлт упрэлм)
	{
		if(!созданУказатель_ли || уок != упрэлм.уок)
			return super.opCmp(упрэлм);
		return 0;
	}
	
	
		final бул фокус()
	{
		return SetFocus(cast(HWND) уок) != HWND.init;
	}
	
	
	/// Returns the УпрЭлт instance from one of its окно уки, or пусто if none.
	// Finds упрэлты that own more than one указатель.
	// A combo box has several HWNDs, this would return the
	// correct combo box упрэлт if any of those уки are
	// provided.
	static УпрЭлт поУказателюОтпрыска(HWND hwChild)
	{
		УпрЭлт результат;
		for(;;)
		{
			if(!hwChild)
				return пусто;
			
			результат = поУказателю(hwChild);
			if(результат)
				return результат;
			
			hwChild = GetParent(cast(HWND) hwChild);
		}
	}
	
	
	/// Returns the УпрЭлт instance from its окно указатель, or пусто if none.
	static УпрЭлт поУказателю(HWND hw)
	{
		return Приложение.отыщиУок(hw);
	}
	
	
		final УпрЭлт дайОтпрыскВТочке(Точка тчк)
	{
		HWND hwChild;
		hwChild = ChildWindowFromPoint(cast(HWND) уок, cast(POINT)тчк.точка);
		if(!hwChild)
			return пусто;
		return поУказателюОтпрыска(hwChild);
	}
	
	
		final проц скрой()
	{
		установиЯдроВидимого(нет);
	}
	
	
	final проц покажи()
	{
		/*
		ShowWindow(уок, SW_SHOW);
		Покажи();
		*/
		
		установиЯдроВидимого(да);
	}
	
	
	package final проц перерисуйПолностью()
	{
		if(уок)
		{
			SetWindowPos(cast(HWND) уок, HWND.init, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_DRAWFRAME | SWP_NOMOVE
				| SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE);
		}
	}
	
	
	package final проц перевычислиПолностью()
	{
		if(уок)
		{
			SetWindowPos(cast(HWND) уок, HWND.init, 0, 0, 0, 0, SWP_FRAMECHANGED | SWP_NOMOVE
				| SWP_NOSIZE | SWP_NOZORDER | SWP_NOACTIVATE);
		}
	}
	
	
		final проц инвалидируй()
	{
		if(!уок)
			return;
		
		RedrawWindow(cast(HWND) уок, пусто, HRGN.init, RDW_ERASE | RDW_INVALIDATE | RDW_NOCHILDREN);
	}
	
	
	final проц инвалидируй(бул andChildren)
	{
		if(!уок)
			return;
		
		RedrawWindow(cast(HWND) уок, пусто, HRGN.init, RDW_ERASE | RDW_INVALIDATE | (andChildren ? RDW_ALLCHILDREN : RDW_NOCHILDREN));
	}
	
	
	final проц инвалидируй(Прям к)
	{
		if(!уок)
			return;
		
		ПРЯМ rect;
		к.дайПрям(&rect);
		
		RedrawWindow(cast(HWND) уок, cast(RECT*)&rect, HRGN.init, RDW_ERASE | RDW_INVALIDATE | RDW_NOCHILDREN);
	}
	
	
	final проц инвалидируй(Прям к, бул andChildren)
	{
		if(!уок)
			return;
		
		ПРЯМ rect;
		к.дайПрям(&rect);
		
		RedrawWindow(cast(HWND) уок, cast(RECT*)&rect, HRGN.init, RDW_ERASE | RDW_INVALIDATE | (andChildren ? RDW_ALLCHILDREN : RDW_NOCHILDREN));
	}
	
	
	final проц инвалидируй(Регион rgn)
	{
		if(!уок)
			return;
		
		RedrawWindow(cast(HWND) уок, пусто, rgn.указатель, RDW_ERASE | RDW_INVALIDATE | RDW_NOCHILDREN);
	}
	
	
	final проц инвалидируй(Регион rgn, бул andChildren)
	{
		if(!уок)
			return;
		
		RedrawWindow(cast(HWND) уок, пусто, rgn.указатель, RDW_ERASE | RDW_INVALIDATE | (andChildren ? RDW_ALLCHILDREN : RDW_NOCHILDREN));
	}
	
	
		// Redraws the entire упрэлт, including nonclient area.
	final проц перерисуй()
	{
		if(!уок)
			return;
		
		RedrawWindow(cast(HWND) уок, пусто, HRGN.init, RDW_ERASE | RDW_INVALIDATE | RDW_FRAME);
	}
	
	
	/// Returns да if the окно does not belong to the текущий thread.
	бул требуетсяВызов() // getter
	{
		DWORD tid = GetWindowThreadProcessId(cast(HWND) уок, пусто);
		return tid != GetCurrentThreadId();
	}
	
	
	private static проц плохойУказательВызова()
	{
		//throw new ВизИскл("Must вызови after creating указатель");
		throw new ВизИскл("Вызов процедуры требуется вывполнять по созданному указателю");
	}
	
	
	/// Synchronously calls а delegate in this УпрЭлт's thread. This function is thread safe and exceptions are propagated to the caller.
	// Exceptions are propagated back to the caller of вызови().
	final Объект вызови(Объект delegate(Объект[]) дг, Объект[] арги ...)
	{
		if(!уок)
			плохойУказательВызова();
		
		ДанныеВызова inv;
		inv.дг = дг;
		inv.арги = арги;
		
		if(LRESULT_VIZ_INVOKE != SendMessageA(cast(HWND) уок, wmViz, WPARAM_VIZ_INVOKE, cast(LRESULT)&inv))
			throw new ВизИскл("Неудачный вызов процедуры");
		if(inv.исключение)
			throw inv.исключение;
		
		return inv.результат;
	}
		
	final проц вызови(проц delegate() дг)
	{
		if(!уок)
			плохойУказательВызова();
		
		ПростыеДанныеВызова inv;
		inv.дг = дг;
		
		if(LRESULT_VIZ_INVOKE != SendMessageA(cast(HWND) уок, wmViz, WPARAM_VIZ_INVOKE_SIMPLE, cast(LRESULT)&inv))
			throw new ВизИскл("Неудачный вызов процедуры");
		if(inv.исключение)
			throw inv.исключение;
	}
	
	
	/** Asynchronously calls а function after the окно сообщение queue processes its текущий messages.
	    It is generally not safe to pass references to the delayed function.
	    Exceptions are not propagated to the caller.
	**/
	// Extra.
	// Exceptions will be passed to Приложение.приИсклНити() and
	// trigger the исклНити событие or the default исключение dialog.
	final проц задержиВызов(проц function() fn)
	{
		if(!уок)
			плохойУказательВызова();
		
		assert(!требуетсяВызов);
		
		static assert(fn.sizeof <= LPARAM.sizeof);
		PostMessageA(cast(HWND) уок, wmViz, WPARAM_VIZ_DELAY_INVOKE, cast(LPARAM)fn);
	}
	
	
	// Extra.
	// Exceptions will be passed to Приложение.приИсклНити() and
	// trigger the исклНити событие or the default исключение dialog.
	// Copy of params are passed to fn, they do not exist after it returns.
	// It is unsafe to pass references to а delayed function.
	final проц задержиВызов(проц function(УпрЭлт, т_мера[]) fn, т_мера[] params ...)
	{
		if(!уок)
			плохойУказательВызова();
		
		assert(!требуетсяВызов);
		
		static assert((ПарамВызоваВиз*).sizeof <= LPARAM.sizeof);
		
		ПарамВызоваВиз* p;
		p = cast(ПарамВызоваВиз*)malloc(
			(ПарамВызоваВиз.sizeof - т_мера.sizeof)
				+ params.length * т_мера.sizeof);
		if(!p)
			throw new ВнеПамИскл();
		
		p.fp = fn;
		p.nparams = params.length;
		p.params.ptr[0 .. params.length] = params;
		
		PostMessageA(уок, wmViz, WPARAM_VIZ_DELAY_INVOKE_PARAMS, cast(LPARAM)p);
	}
	
	
	static бул мнемоника_ли(дим кодСим, Ткст текст)
	{
		бцел ui;
		for(ui = 0; ui != текст.length; ui++)
		{
			if('&' == текст[ui])
			{
				if(++ui == текст.length)
					break;
				if('&' == текст[ui]) // && means literal & so skip it.
					continue;
				дим dch;
				dch = раскодируйЮ(текст, ui);
				return в_юпроп(кодСим) == в_юпроп(dch);
			}
		}
		return нет;
	}
	
	
	/// Converts а screen Точка to а client Точка.
	final Точка точкаККлиенту(Точка тчк)
	{
		ScreenToClient(cast(HWND) уок, cast(POINT*) &тчк.точка);
		return тчк;
	}
	
	
	/// Converts а client Точка to а screen Точка.
	final Точка точкаКЭкрану(Точка тчк)
	{
		ClientToScreen(cast(HWND) уок, cast(POINT*) &тчк.точка);
		return тчк;
	}
		
	/// Converts а screen Rectangle to а client Rectangle.
	final Прям прямоугольникККлиенту(Прям к)
	{
		ПРЯМ rect;
		к.дайПрям(&rect);
		
		MapWindowPoints(HWND.init, уок, cast(POINT*)&rect, 2);
		return Прям(&rect);
	}
		
	/// Converts а client Rectangle to а screen Rectangle.
	final Прям прямоугольникКЭкрану(Прям к)
	{
		ПРЯМ rect;
		к.дайПрям(&rect);
		
		MapWindowPoints(cast(HWND) уок, HWND.init, cast(POINT*)&rect, 2);
		return Прям(&rect);
	}
	
	
		// Return да if processed.
	бул подготовьСообщение(inout Сообщение сооб)
	{
		return нет;
	}
	
	
		final Размер дайРазмерАвтоМасштаба(Шрифт f)
	{
		Размер результат;
		Графика з;
		з = создайГрафику();
		результат = з.getScaleSize(f);
		з.вымести();
		return результат;
	}
	
	
	final Размер дайРазмерАвтоМасштаба()
	{
		return дайРазмерАвтоМасштаба(шрифт);
	}
	
	
		проц освежи()
	{
		инвалидируй(да);
	}
	
	
		проц сбросьЦветФона()
	{
		//цветФона = дефЦветФона;
		цветФона = Цвет.пуст;
	}
	
	
		проц сбросьКурсор()
	{
		//курсор = new Курсор(LoadCursorA(экз.init, IDC_ARROW), нет);
		курсор = пусто;
	}
	
	
		проц сбросьШрифт()
	{
		//шрифт = дефШрифт;
		шрифт = пусто;
	}
	
	
		проц сбросьЦветПП()
	{
		//цветПП = дефЦветПП;
		цветПП = Цвет.пуст;
	}
	
	
		проц сбросьСправаНалево()
	{
		//справаНалево = нет;
		справаНалево = ПСправаНалево.НАСЛЕДОВАТЬ;
	}
	
	
		проц сбросьТекст()
	{
		//текст = "";
		текст = пусто;
	}
	
	
		// Just allow разметка recalc, but don't do it право now.
	final проц возобновиРазметку()
	{
		//_allowLayout = да;
		if(_disallowLayout)
			_disallowLayout--;
	}
	
	
	// Allow разметка recalc, only do it now if -подтвержд- is да.
	final проц возобновиРазметку(бул подтвержд)
	{
		if(_disallowLayout)
			_disallowLayout--;
		
		// This is correct.
		if(подтвержд)
		{
			if(!_disallowLayout)
				н_раскладка(пусто);
		}
	}
	
	
		final проц заморозьРазметку()
	{
		//_allowLayout = нет;
		_disallowLayout++;
	}
	
	
	final проц выполниРазметку(УпрЭлт задействованныйУпрэлт)
	{
		н_раскладка(задействованныйУпрэлт, нет);
	}
	
	
	final проц выполниРазметку()
	{
		return выполниРазметку(this);
	}
	
	
	/+
	// TODO: implement.
	
	// Scale both высота and ширина to -ratio-.
	final проц scale(float ratio)
	{
		scaleCore(ratio, ratio);
	}
	
	
	// Scale -ширина- and -высота- ratios.
	final проц scale(float ширина, float высота)
	{
		scaleCore(ширина, высота);
	}
	
	
	// Also scales child упрэлты recursively.
	 проц scaleCore(float ширина, float высота)
	{
		заморозьРазметку();
		
		// ...
		
		возобновиРазметку();
	}
	+/
	
	
	private static бул _eachild(HWND hw, бул delegate(HWND hw) обрвыз, inout т_мера xiter, бул nested)
	{
		for(; hw; hw = GetWindow(hw, GW_HWNDNEXT))
		{
			if(!xiter)
				return нет;
			xiter--;
			
			LONG st = GetWindowLongA(hw, GWL_STYLE);
			if(!(st & WS_VISIBLE))
				continue;
			if(st & WS_DISABLED)
				continue;
			
			if(!обрвыз(hw))
				return нет;
			
			if(nested)
			{
				//LONG exst = GetWindowLongA(hw, GWL_EXSTYLE);
				//if(exst & WS_EX_CONTROLPARENT) // It's нет longer added.
				{
					HWND hwc = GetWindow(hw, GW_CHILD);
					if(hwc)
					{
						//if(!_eachild(hwc, обрвыз, xiter, nested))
						if(!_eachild(hwc, обрвыз, xiter, да))
							return нет;
					}
				}
			}
		}
		return да;
	}
	
	package static проц eachGoodChildHandle(HWND hwparent, бул delegate(HWND hw) обрвыз, бул nested = да)
	{
		HWND hw = GetWindow(hwparent, GW_CHILD);
		т_мера xiter = 2000;
		_eachild(hw, обрвыз, xiter, nested);
	}
	
	
	private static бул _isHwndControlSel(HWND hw)
	{
		УпрЭлт ктрл = УпрЭлт.поУказателю(hw);
		return ктрл && ктрл.дайСтиль(ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ);
	}
	
	
	package static проц _dlgselnext(Форма dlg, HWND hwcursel, бул forward,
		бул tabStopOnly = да, бул selectableOnly = нет,
		бул nested = да, бул wrap = да,
		HWND hwchildrenof = пусто)
	{
		//assert(cast(Форма)УпрЭлт.поУказателю(hwdlg) !is пусто);
		
		if(!hwchildrenof)
			hwchildrenof = dlg.указатель;
		if(forward)
		{
			бул foundthis = нет, tdone = нет;
			HWND hwfirst;
			eachGoodChildHandle(hwchildrenof,
				(HWND hw)
				{
					assert(!tdone);
					if(hw == hwcursel)
					{
						foundthis = да;
					}
					else
					{
						if(!tabStopOnly || (GetWindowLongA(hw, GWL_STYLE) & WS_TABSTOP))
						{
							if(!selectableOnly || _isHwndControlSel(hw))
							{
								if(foundthis)
								{
									//DefDlgProcA(dlg.указатель, WM_NEXTDLGCTL, cast(WPARAM)hw, MAKELPARAM(да, 0));
									dlg._selectChild(hw);
									tdone = да;
									return нет; // Break.
								}
								else
								{
									if(HWND.init == hwfirst)
										hwfirst = hw;
								}
							}
						}
					}
					return да; // Continue.
				}, nested);
			if(!tdone && HWND.init != hwfirst)
			{
				// If it falls through without finding hwcursel, let it выдели the first one, even if not wrapping.
				if(wrap || !foundthis)
				{
					//DefDlgProcA(dlg.указатель, WM_NEXTDLGCTL, cast(WPARAM)hwfirst, MAKELPARAM(да, 0));
					dlg._selectChild(hwfirst);
				}
			}
		}
		else
		{
			HWND hwprev;
			eachGoodChildHandle(hwchildrenof,
				(HWND hw)
				{
					if(hw == hwcursel)
					{
						if(HWND.init != hwprev) // Otherwise, keep looping and get last one.
							return нет; // Break.
						if(!wrap) // No wrapping, so don't get last one.
						{
							assert(HWND.init == hwprev);
							return нет; // Break.
						}
					}
					if(!tabStopOnly || (GetWindowLongA(hw, GWL_STYLE) & WS_TABSTOP))
					{
						if(!selectableOnly || _isHwndControlSel(hw))
						{
							hwprev = hw;
						}
					}
					return да; // Continue.
				}, nested);
			// If it falls through without finding hwcursel, let it выдели the last one, even if not wrapping.
			if(HWND.init != hwprev)
				//DefDlgProcA(dlg.указатель, WM_NEXTDLGCTL, cast(WPARAM)hwprev, MAKELPARAM(да, 0));
				dlg._selectChild(hwprev);
		}
	}
	
	
	package final проц _selectNextControl(Форма ctrltoplevel,
		УпрЭлт упрэлм, бул forward, бул tabStopOnly, бул nested, бул wrap)
	{
		if(!создан)
			return;
		
		assert(ctrltoplevel !is пусто);
		assert(ctrltoplevel.созданУказатель_ли);
		
		_dlgselnext(ctrltoplevel,
			(упрэлм && упрэлм.созданУказатель_ли) ? упрэлм.указатель : пусто,
			forward, tabStopOnly, !tabStopOnly, nested, wrap,
			this.указатель);
	}
	
	
	package final проц _selectThisControl()
	{
		
	}
	
	
	// Only considers child упрэлты of this упрэлт.
	final проц выделиСледующийУпрЭлт(УпрЭлт упрэлм, бул forward, бул tabStopOnly, бул nested, бул wrap)
	{
		if(!создан)
			return;
		
		auto ctrltoplevel = найдиФорму();
		if(ctrltoplevel)
			return _selectNextControl(ctrltoplevel, упрэлм, forward, tabStopOnly, nested, wrap);
	}
	
	
		final проц выдели()
	{
		выдели(нет, нет);
	}
	
	
	// If -directed- is да, -forward- is used; otherwise, selects this упрэлт.
	// If -forward- is да, the next упрэлт in the tab order is selected,
	// otherwise the previous упрэлт in the tab order is selected.
	// Controls without стиль ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ are skipped.
	проц выдели(бул directed, бул forward)
	{
		if(!создан)
			return;
		
		auto ctrltoplevel = найдиФорму();
		if(ctrltoplevel && ctrltoplevel !is this)
		{
			/+ // Old...
			// Even if directed, ensure THIS one is selected first.
			if(!directed || уок != GetFocus())
			{
				DefDlgProcA(ctrltoplevel.указатель, WM_NEXTDLGCTL, cast(WPARAM)уок, MAKELPARAM(да, 0));
			}
			
			if(directed)
			{
				DefDlgProcA(ctrltoplevel.указатель, WM_NEXTDLGCTL, !forward, MAKELPARAM(нет, 0));
			}
			+/
			
			if(directed)
			{
				_dlgselnext(ctrltoplevel, this.указатель, forward);
			}
			else
			{
				ctrltoplevel._selectChild(this);
			}
		}
		else
		{
			фокус(); // This must be а form so just фокус it ?
		}
	}
	
	
		final проц установиГраницы(цел ш, цел в, цел ширина, цел высота)
	{
		установиЯдроГраниц(ш, в, ширина, высота, ПЗаданныеПределы.ВСЕ);
	}
	
	
	final проц установиГраницы(цел ш, цел в, цел ширина, цел высота, ПЗаданныеПределы задано)
	{
		установиЯдроГраниц(ш, в, ширина, высота, задано);
	}
	
	
	Ткст вТкст()
	{
		return текст;
	}
	
	
		final проц обнови()
	{
		if(!создан)
			return;
		
		UpdateWindow(cast(HWND) уок);
	}
	
	
		// If мышьВошла, mouseHover and мышьВышла события are supported.
	// Returns да on Windows 95 with IE 5.5, Windows 98+ or Windows NT 4.0+.
	static бул поддерживаетОтслеживаниеМыши() // getter
	{
		return trackMouseEvent != пусто;
	}
	
	
	package final Прям _fetchBounds()
	{
		ПРЯМ к;
		GetWindowRect(cast(HWND) уок,cast(RECT*) &к);
		HWND hwParent = GetParent(cast(HWND) уок);
		if(hwParent && (_style() & WS_CHILD))
			MapWindowPoints(HWND.init, hwParent, cast(POINT*)&к, 2);
		return Прям(&к);
	}
	
	
	package final Размер _fetchClientSize()
	{
		ПРЯМ к;
		GetClientRect(cast(HWND) уок, cast(RECT*)&к);
		return Размер(к.право, к.низ);
	}
	
	
	deprecated  проц приИнвалидировании(АргиСобИнвалидировать iea)
	{
		//invalidated(this, iea);
	}
	
	
	проц приОтрисовке(АргиСобРис pea)
	{
		отрисовка(this, pea);
	}
	
	
	проц приПеремещении(АргиСоб ea)
	{
		перемещение(this, ea);
	}
	
	
	/+
	 проц приИзмененииПоложения(АргиСоб ea)
	{
		положениеИзменено(this, ea);
	}
	+/
	alias приПеремещении приИзмененииПоложения;
	
	
		 проц приИзмененииРазмера(АргиСоб ea)
	{
		перемерка(this, ea);
	}
	
	
	/+
	 проц onSizeChanged(АргиСоб ea)
	{
		размерИзменён(this, ea);
	}
	+/
	alias приИзмененииРазмера onSizeChanged;
	
	
	/+
	// 	// Allows comparing before and after dimensions, and also allows modifying the new dimensions.
	deprecated  проц onBeforeResize(BeforeResizeEventArgs ea)
	{
	}
	+/
	
	
		 проц приВходеМыши(АргиСобМыши mea)
	{
		мышьВошла(this, mea);
	}
	
	
		 проц приДвиженииМыши(АргиСобМыши mea)
	{
		мышьДвижется(this, mea);
	}
	
	
		 проц приКлавишеВнизу(АргиСобКлавиш kea)
	{
		клавишаВнизу(this, kea);
	}
	
	
		 проц приНажатииКлавиши(АргиСобНажатияКлав kea)
	{
		клавишаНажата(this, kea);
	}
	
	
		 проц приКлавишиВверху(АргиСобКлавиш kea)
	{
		клавишаВверху(this, kea);
	}
	
	
		 проц приВращенииМыши(АргиСобМыши mea)
	{
		вращениеМыши(this, mea);
	}
	
	
		 проц onMouseHover(АргиСобМыши mea)
	{
		mouseHover(this, mea);
	}
	
	
		 проц приВыходеМыши(АргиСобМыши mea)
	{
		мышьВышла(this, mea);
	}
	
	
		 проц приМышиВнизу(АргиСобМыши mea)
	{
		мышьВнизу(this, mea);
	}
	
	
		 проц приМышиВверху(АргиСобМыши mea)
	{
		мышьВверху(this, mea);
	}
	
	
		 проц приКлике(АргиСоб ea)
	{
		клик(this, ea);
	}
	
	
		 проц приДвуклике(АргиСоб ea)
	{
		двуклик(this, ea);
	}
	
	
		 проц приФокусировке(АргиСоб ea)
	{
		полученФокус(this, ea);
	}
	
	
	/+
	deprecated  проц onEnter(АргиСоб ea)
	{
		//enter(this, ea);
	}
	
	
	deprecated  проц onLeave(АргиСоб ea)
	{
		//leave(this, ea);
	}
	
	
	deprecated  проц onValidated(АргиСоб ea)
	{
		//validated(this, ea);
	}
	
	
	deprecated  проц onValidating(АргиСобОтмены cea)
	{
		/+
		foreach(ОбработчикСобытияОтмены.Обработчик обработчик; validating.обработчики())
		{
			обработчик(this, cea);
			
			if(cea.отмена)
				return; // Not validated.
		}
		
		onValidated(АргиСоб.пуст);
		+/
	}
	+/
	
	
проц приРасфокусировке(АргиСоб ea)
	{
		расфокусировка(this, ea);
	}
	
	
проц приИзмененииВключения(АргиСоб ea)
	{
		измененоВключение(this, ea);
	}
	
	
проц приИзмененииТекста(АргиСоб ea)
	{
		текстИзменён(this, ea);
	}
	
	
	private проц _propagateFontAmbience()
	{
		Шрифт fon;
		fon = шрифт;
		
		
		проц pa(УпрЭлт pc)
		{
			foreach(УпрЭлт упрэлм; pc.коллекция)
			{
				if(!упрэлм.окШрифт) // If default.
				{
					if(fon is упрэлм.шрифт) // If same default.
					{
						if(упрэлм.созданУказатель_ли)
							SendMessageA(упрэлм.уок, WM_SETFONT, cast(WPARAM)fon.указатель, MAKELPARAM(да, 0));
						упрэлм.приИзмененииШрифта(АргиСоб.пуст);
						
						pa(упрэлм); // Recursive.
					}
				}
			}
		}
		
		
		pa(this);
	}
	
	
		 проц приИзмененииШрифта(АргиСоб ea)
	{
		debug(EVENT_PRINT)
		{
			скажиф("{ Событие: приИзмененииШрифта - УпрЭлт %s }\n", имя);
		}
		
		изменёнШрифт(this, ea);
	}
	
	
		 проц приИзмененииСправаНалево(АргиСоб ea)
	{
		debug(EVENT_PRINT)
		{
			скажиф("{ Событие: приИзмененииСправаНалево - УпрЭлт %s }\n", имя);
		}
		
		справаНаЛевоИзменено(this, ea);
	}
	
	
		 проц приИзмененииВидимости(АргиСоб ea)
	{
		if(окРодитель)
		{
			окРодитель.в_изменено();
			заморозьРазметку(); // Note: исключение could cause failure to restore.
			окРодитель.н_раскладка(this);
			возобновиРазметку(нет);
		}
		if(виден)
			н_раскладка(this);
		
		видимостьИзменена(this, ea);
		
		if(виден)
		{
			// If нет фокус or the вФокусе упрэлт is hidden, try to выдели something...
			HWND hwfocus = GetFocus();
			if(!hwfocus
				|| (hwfocus == уок && !дайСтиль(ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ))
				|| !IsWindowVisible(hwfocus))
			{
				выделиСледующийУпрЭлт(пусто, да, да, да, нет);
			}
		}
	}
	
	
		 проц приЗапросеСправки(АргиСобСправка hea)
	{
		debug(EVENT_PRINT)
		{
			скажиф("{ Событие: приЗапросеСправки - УпрЭлт %s }\n", имя);
		}
		
		затребованаСправка(this, hea);
	}
	
	
		 проц приИзмененииСистемныхЦветов(АргиСоб ea)
	{
		debug(EVENT_PRINT)
		{
			скажиф("{ Событие: приИзмененииСистемныхЦветов - УпрЭлт %s }\n", имя);
		}
		
		системныеЦветаИзменены(this, ea);
	}
	
	
		 проц поСозданиюУказателя(АргиСоб ea)
	{
		if(!(cbits & CBits.VSTYLE))
			_disableVisualStyle();
		
		Шрифт fon;
		fon = шрифт;
		if(fon)
			SendMessageA(cast(HWND)  уок, WM_SETFONT, cast(WPARAM)fon.указатель, 0);
		
		if(окРегион)
		{
			// Need to make а копируй of the регион.
			SetWindowRgn(уок, dupHrgn(окРегион.указатель), да);
		}
		
		version(VIZ_NO_DRAG_DROP) {} else
		{
			if(цельброса)
			{
				if(S_OK != RegisterDragDrop(cast(HWND) уок, cast(winapi.IDropTarget) цельброса))
				{
					цельброса = пусто;
					throw new ВизИскл("Не удаётся регистрация drag-drop");
				}
			}
		}
		
		debug
		{
			_handlecreated = да;
		}
	}
	
	
		 проц поУдалениюУказателя(АргиСоб ea)
	{
		указательУдалён(this, ea);
	}
	
	
		 проц приОтрисовкеФона(АргиСобРис pea)
	{
		ПРЯМ rect;
		pea.клипПрямоугольник.дайПрям(&rect);
		FillRect(pea.графика.указатель, cast(RECT*)&rect, hbrBg);
	}
	
	
	private static ПКнопкиМыши wparamMouseButtons(WPARAM wparam)
	{
		ПКнопкиМыши результат;
		if(wparam & MK_LBUTTON)
			результат |= ПКнопкиМыши.ЛЕВ;
		if(wparam & MK_RBUTTON)
			результат |= ПКнопкиМыши.ПРАВ;
		if(wparam & MK_MBUTTON)
			результат |= ПКнопкиМыши.СРЕДН;
		return результат;
	}
	
	
	package final проц prepareDc(HDC hdc)
	{
		//SetBkMode(hdc, TRANSPARENT); // ?
		//SetBkMode(hdc, НЕПРОЗРАЧНЫЙ); // ?
		SetBkColor(hdc, цветФона.вКзс());
		SetTextColor(hdc, цветПП.вКзс());
	}
	
	
	// Сообщение копируй so it cannot be изменён.
	deprecated  проц onNotifyMessage(Сообщение сооб)
	{
	}
	
	
	/+
	/+package+/ LRESULT customMsg(inout ОсобоеСооб сооб) // package
	{
		return 0;
	}
	+/
	
	
		 проц поОбратномуСообщению(inout Сообщение m)
	{
		switch(m.сооб)
		{
			case WM_CTLCOLORSTATIC:
			case WM_CTLCOLORLISTBOX:
			case WM_CTLCOLOREDIT:
			case WM_CTLCOLORSCROLLBAR:
			case WM_CTLCOLORBTN:
			//case WM_CTLCOLORDLG: // ?
			//case 0x0019: //WM_CTLCOLOR; obsolete.
				prepareDc(cast(HDC)m.парам1);
				//assert(GetObjectA(hbrBg, 0, пусто));
				m.результат = cast(LRESULT)hbrBg;
				break;
			
			default: ;
		}
	}
	
	
	// ChildWindowFromPoint includes both hidden and disabled.
	// This includes disabled windows, but not hidden.
	// Here is а Точка in this упрэлт, see if it's over а виден child.
	// Returns пусто if not even in this упрэлт's client.
	final HWND тчкНадВидимымОтпрыском(Точка тчк) // package
	{
		if(тчк.ш < 0 || тчк.в < 0)
			return HWND.init;
		if(тчк.ш > клиентОкРазм.ширина || тчк.в > клиентОкРазм.высота)
			return HWND.init;
		
		// Note: doesn't include non-DFL windows... TO-DO: fix.
		foreach(УпрЭлт упрэлм; коллекция)
		{
			if(!упрэлм.виден)
				continue;
			if(!упрэлм.созданУказатель_ли) // Shouldn't..
				continue;
			if(упрэлм.границы.содержит(тчк))
				return упрэлм.уок;
		}
		
		return уок; // Just over this упрэлт.
	}
	
	
	version(_VIZ_WINDOWS_HUNG_WORKAROUND)
	{
		DWORD ldlgcode = 0;
	}
	
	
		 проц окПроц(inout Сообщение сооб)
	{
		//if(ктрлСтиль & ПСтилиУпрЭлта.ENABLE_NOTIFY_MESSAGE)
		//	onNotifyMessage(сооб);
		
		switch(сооб.сооб)
		{
			case WM_PAINT:
				{
					// This can't be done in BeginPaint() becuase part might get
					// validated during this событие ?
					//ПРЯМ uprect;
					//GetUpdateRect(уок, &uprect, да);
					//приИнвалидировании(new АргиСобИнвалидировать(Прям(&uprect)));
					
					PAINTSTRUCT ps;
					BeginPaint(cast(HWND) сооб.уок, &ps);
					try
					{
						//приИнвалидировании(new АргиСобИнвалидировать(Прям(&uprect)));
						
						scope АргиСобРис pea = new АргиСобРис(new Графика(ps.hdc, нет), Прям(cast(ПРЯМ*)&ps.rcPaint));
						
						// Probably because ПСтилиУпрЭлта.ALL_PAINTING_IN_WM_PAINT.
						if(ps.fErase)
						{
							prepareDc(ps.hdc);
							приОтрисовкеФона(pea);
						}
						
						prepareDc(ps.hdc);
						приОтрисовке(pea);
					}
					finally
					{
						EndPaint(уок, &ps);
					}
				}
				return;
			
			case WM_ERASEBKGND:
				if(ктрлСтиль & ПСтилиУпрЭлта.НЕПРОЗРАЧНЫЙ)
				{
					сооб.результат = 1; // Erased.
				}
				else if(!(ктрлСтиль & ПСтилиУпрЭлта.ALL_PAINTING_IN_WM_PAINT))
				{
					ПРЯМ uprect;
					/+
					GetUpdateRect(уок, &uprect, нет);
					+/
					uprect.лево = 0;
					uprect.верх = 0;
					uprect.право = клиентРазм.ширина;
					uprect.низ = клиентРазм.высота;
					
					prepareDc(cast(HDC)сооб.парам1);
					scope АргиСобРис pea = new АргиСобРис(new Графика(cast(HDC)сооб.парам1, нет), Прям(&uprect));
					приОтрисовкеФона(pea);
					сооб.результат = 1; // Erased.
				}
				return;
			
			case WM_PRINTCLIENT:
				prepareDc(cast(HDC)сооб.парам1);
				scope АргиСобРис pea = new АргиСобРис(new Графика(cast(HDC)сооб.парам1, нет), Прям(Точка(0, 0), клиентОкРазм));
				приОтрисовке(pea);
				return;
			
			case WM_CTLCOLORSTATIC:
			case WM_CTLCOLORLISTBOX:
			case WM_CTLCOLOREDIT:
			case WM_CTLCOLORSCROLLBAR:
			case WM_CTLCOLORBTN:
			//case WM_CTLCOLORDLG: // ?
			//case 0x0019: //WM_CTLCOLOR; obsolete.
				{
					УпрЭлт упрэлм = поУказателюОтпрыска(cast(HWND)сооб.парам2);
					if(упрэлм)
					{
						//упрэлм.prepareDc(cast(HDC)сооб.парам1);
						//сооб.результат = cast(LRESULT)упрэлм.hbrBg;
						упрэлм.поОбратномуСообщению(сооб);
						return;
					}
				}
				break;
			
			case WM_WINDOWPOSCHANGED:
				{
					WINDOWPOS* wp = cast(WINDOWPOS*)сооб.парам2;
					бул needLayout = нет;
					
					//if(!wp.уокInsertAfter)
					//	wp.флаги |= SWP_NOZORDER; // ?
					
					бул didvis = нет;
					if(wp.флаги & (SWP_HIDEWINDOW | SWP_SHOWWINDOW))
					{
						needLayout = да; // Only if not didvis / if not recreating.
						if(!восстановлениеУказателя) // Note: suppresses приИзмененииВидимости
						{
							if(wp.флаги & SWP_HIDEWINDOW) // Hiding.
								_clicking = нет;
							приИзмененииВидимости(АргиСоб.пуст);
							didvis = да;
							//break; // Showing min/max includes other флаги.
						}
					}
					
					if(!(wp.флаги & SWP_NOZORDER) /+ || (wp.флаги & SWP_SHOWWINDOW) +/)
					{
						if(окРодитель)
							окРодитель.в_изменено();
					}
					
					if(!(wp.флаги & SWP_NOMOVE))
					{
						приПеремещении(АргиСоб.пуст);
					}
					
					if(!(wp.флаги & SWP_NOSIZE))
					{
						if(szdraw)
							инвалидируй(да);
						
						приИзмененииРазмера(АргиСоб.пуст);
						
						needLayout = да;
					}
					
					// Frame change results in а new client размер.
					if(wp.флаги & SWP_FRAMECHANGED)
					{
						if(szdraw)
							инвалидируй(да);
						
						needLayout = да;
					}
					
					if(!didvis) // приИзмененииВидимости already triggers разметка.
					{
						if(/+ (wp.флаги & SWP_SHOWWINDOW) || +/ !(wp.флаги & SWP_NOSIZE) ||
							!(wp.флаги & SWP_NOZORDER)) // z-order determines what is positioned first.
						{
							заморозьРазметку(); // Note: исключение could cause failure to restore.
							if(окРодитель)
								окРодитель.н_раскладка(this);
							возобновиРазметку(нет);
							needLayout = да;
						}
						
						if(needLayout)
						{
							н_раскладка(this);
						}
					}
				}
				break;
			
			/+
			case WM_WINDOWPOSCHANGING:
				{
					WINDOWPOS* wp = cast(WINDOWPOS*)сооб.парам2;
					
					/+
					//if(!(wp.флаги & SWP_NOSIZE))
					if(ширина != wp.cx || высота != wp.cy)
					{
						scope BeforeResizeEventArgs ea = new BeforeResizeEventArgs(wp.cx, wp.cy);
						onBeforeResize(ea);
						/+if(wp.cx == ea.ширина && wp.cy == ea.высота)
						{
							wp.флаги |= SWP_NOSIZE;
						}
						else+/
						{
							wp.cx = ea.ширина;
							wp.cy = ea.высота;
						}
					}
					+/
				}
				break;
			+/
			
			case WM_MOUSEMOVE:
				if(_clicking)
				{
					if(!(сооб.парам1 & MK_LBUTTON))
						_clicking = нет;
				}
				
				if(trackMouseEvent) // Requires Windows 95 with IE 5.5, 98 or NT4.
				{
					if(!menter)
					{
						menter = да;
						
						ТОЧКА тчк;
						GetCursorPos(cast(POINT*)&тчк);
						MapWindowPoints(HWND.init, cast(HWND) уок,cast(POINT*) &тчк, 1);
						scope АргиСобМыши mea = new АргиСобМыши(wparamMouseButtons(сооб.парам1), 0, тчк.ш, тчк.в, 0);
						приВходеМыши(mea);
						
						TRACKMOUSEEVENT tme;
						tme.cbSize = TRACKMOUSEEVENT.sizeof;
						tme.dwFlags = TME_HOVER | TME_LEAVE;
						tme.hwndTrack = сооб.уок;
						tme.dwHoverTime = HOVER_DEFAULT;
						trackMouseEvent(&tme);
					}
				}
				
				приДвиженииМыши(new АргиСобМыши(wparamMouseButtons(сооб.парам1), 0, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0));
				break;
			
			case WM_SETCURSOR:
				// Just обнови it so that УпрЭлт.дефОкПроц() can установи it correctly.
				if(cast(HWND)сооб.парам1 == уок)
				{
					Курсор cur;
					cur = курсор;
					if(cur)
					{
						if(cast(УКурсор)GetClassLongA(уок, GCL_HCURSOR) != cur.указатель)
							SetClassLongA(уок, GCL_HCURSOR, cast(LONG)cur.указатель);
					}
					else
					{
						if(cast(УКурсор)GetClassLongA(уок, GCL_HCURSOR) != УКурсор.init)
							SetClassLongA(уок, GCL_HCURSOR, cast(LONG)cast(УКурсор)пусто);
					}
					УпрЭлт.дефОкПроц(сооб);
					return;
				}
				break;
			
			/+
			case WM_NEXTDLGCTL:
				if(!LOWORD(сооб.парам2))
				{
					выдели(да, сооб.парам1 != 0);
					return;
				}
				break;
			+/
			
			case WM_KEYDOWN:
			case WM_KEYUP:
			case WM_CHAR:
			case WM_SYSKEYDOWN:
			case WM_SYSKEYUP:
			case WM_SYSCHAR:
			//case WM_IMECHAR:
				/+
				if(обработайАргиСобКлавиш(сооб))
				{
					// The key was processed.
					сооб.результат = 0;
					return;
				}
				сооб.результат = 1; // The key was not processed.
				break;
				+/
				сооб.результат = !обработайАргиСобКлавиш(сооб);
				return;
			
			case WM_MOUSEWHEEL: // Requires Windows 98 or NT4.
				{
					scope АргиСобМыши mea = new АргиСобМыши(wparamMouseButtons(LOWORD(сооб.парам1)), 0, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), cast(short)HIWORD(сооб.парам1));
					приВращенииМыши(mea);
				}
				break;
			
			case WM_MOUSEHOVER: // Requires Windows 95 with IE 5.5, 98 or NT4.
				{
					scope АргиСобМыши mea = new АргиСобМыши(wparamMouseButtons(сооб.парам1), 0, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					onMouseHover(mea);
				}
				break;
			
			case WM_MOUSELEAVE: // Requires Windows 95 with IE 5.5, 98 or NT4.
				{
					menter = нет;
					
					ТОЧКА тчк;
					GetCursorPos(cast(POINT*)&тчк);
					MapWindowPoints(HWND.init, уок,cast(POINT*) &тчк, 1);
					scope АргиСобМыши mea = new АргиСобМыши(wparamMouseButtons(сооб.парам1), 0, тчк.ш, тчк.в, 0);
					приВыходеМыши(mea);
				}
				break;
			
			case WM_LBUTTONDOWN:
				{
					_clicking = да;
					
					scope АргиСобМыши mea = new АргиСобМыши(ПКнопкиМыши.ЛЕВ, 1, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					приМышиВнизу(mea);
					
					//if(ктрлСтиль & ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ)
					//	SetFocus(уок); // No, this goofs up stuff, including the КомбоБокс dropdown.
				}
				break;
			
			case WM_RBUTTONDOWN:
				{
					scope АргиСобМыши mea = new АргиСобМыши(ПКнопкиМыши.ПРАВ, 1, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					приМышиВнизу(mea);
				}
				break;
			
			case WM_MBUTTONDOWN:
				{
					scope АргиСобМыши mea = new АргиСобМыши(ПКнопкиМыши.СРЕДН, 1, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					приМышиВнизу(mea);
				}
				break;
			
			case WM_LBUTTONUP:
				{
					if(сооб.парам2 == -1)
						break;
					
					// Use temp in case of исключение.
					бул wasClicking = _clicking;
					_clicking = нет;
					
					scope АргиСобМыши mea = new АргиСобМыши(ПКнопкиМыши.ЛЕВ, 1, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					приМышиВверху(mea);
					
					if(wasClicking && (ктрлСтиль & ПСтилиУпрЭлта.СТАНДАРТНЫЙ_КЛИК))
					{
						// See if the mouse up was over the упрэлт.
						if(Прям(0, 0, клиентОкРазм.ширина, клиентОкРазм.высота).содержит(mea.ш, mea.в))
						{
							// Now make sure there's нет child in the way.
							//if(ChildWindowFromPoint(уок, Точка(mea.ш, mea.в).точка) == уок) // Includes hidden windows.
							if(тчкНадВидимымОтпрыском(Точка(mea.ш, mea.в)) == уок)
								приКлике(АргиСоб.пуст);
						}
					}
				}
				break;
			
			version(CUSTOM_MSG_HOOK)
			{}
			else
			{
				case WM_DRAWITEM:
					{
						УпрЭлт упрэлм;
						
						DRAWITEMSTRUCT* dis = cast(DRAWITEMSTRUCT*)сооб.парам2;
						if(dis.CtlType == ODT_MENU)
						{
							// dis.hwndItem is the HMENU.
						}
						else
						{
							упрэлм = УпрЭлт.поУказателюОтпрыска(dis.hwndItem);
							if(упрэлм)
							{
								//сооб.результат = упрэлм.customMsg(*(cast(ОсобоеСооб*)&сооб));
								упрэлм.поОбратномуСообщению(сооб);
								return;
							}
						}
					}
					break;
				
				case WM_MEASUREITEM:
					{
						УпрЭлт упрэлм;
						
						MEASUREITEMSTRUCT* mis = cast(MEASUREITEMSTRUCT*)сооб.парам2;
						if(!(mis.CtlType == ODT_MENU))
						{
							упрэлм = УпрЭлт.поУказателюОтпрыска(cast(HWND)mis.CtlID);
							if(упрэлм)
							{
								//сооб.результат = упрэлм.customMsg(*(cast(ОсобоеСооб*)&сооб));
								упрэлм.поОбратномуСообщению(сооб);
								return;
							}
						}
					}
					break;
				
				case WM_COMMAND:
					{
						/+
						switch(LOWORD(сооб.парам1))
						{
							case IDOK:
							case IDCANCEL:
								if(родитель)
								{
									родитель.окПроц(сооб);
								}
								//break;
								return; // ?
							
							default: ;
						}
						+/
						
						УпрЭлт упрэлм;
						
						упрэлм = УпрЭлт.поУказателюОтпрыска(cast(HWND)сооб.парам2);
						if(упрэлм)
						{
							//сооб.результат = упрэлм.customMsg(*(cast(ОсобоеСооб*)&сооб));
							упрэлм.поОбратномуСообщению(сооб);
							return;
						}
						else
						{
							version(ВИЗ_БЕЗ_МЕНЮ)
							{
							}
							else
							{
								ПунктМеню m;
								
								m = cast(ПунктМеню)Приложение.отыщиИдМеню(LOWORD(сооб.парам1));
								if(m)
								{
									//сооб.результат = m.customMsg(*(cast(ОсобоеСооб*)&сооб));
									m._reflectMenu(сооб);
									//return; // ?
								}
							}
						}
					}
					break;
				
				case WM_NOTIFY:
					{
						УпрЭлт упрэлм;
						NMHDR* nmh;
						nmh = cast(NMHDR*)сооб.парам2;
						
						упрэлм = УпрЭлт.поУказателюОтпрыска(nmh.hwndFrom);
						if(упрэлм)
						{
							//сооб.результат = упрэлм.customMsg(*(cast(ОсобоеСооб*)&сооб));
							упрэлм.поОбратномуСообщению(сооб);
							return;
						}
					}
					break;
				
				version(ВИЗ_БЕЗ_МЕНЮ)
				{
				}
				else
				{
					case WM_MENUSELECT:
						{
							UINT mflags;
							UINT uitem;
							цел mid;
							ПунктМеню m;
							
							mflags = HIWORD(сооб.парам1);
							uitem = LOWORD(сооб.парам1); // Depends on the флаги.
							
							if(mflags & MF_SYSMENU)
								break;
							
							if(mflags & MF_POPUP)
							{
								// -uitem- is an индекс.
								mid = GetMenuItemID(cast(HMENU)сооб.парам2, uitem);
							}
							else
							{
								// -uitem- is the item identifier.
								mid = uitem;
							}
							
							m = cast(ПунктМеню)Приложение.отыщиИдМеню(mid);
							if(m)
							{
								//сооб.результат = m.customMsg(*(cast(ОсобоеСооб*)&сооб));
								m._reflectMenu(сооб);
								//return;
							}
						}
						break;
					
					case WM_INITMENUPOPUP:
						if(HIWORD(сооб.парам2))
						{
							// System меню.
						}
						else
						{
							ПунктМеню m;
							
							//m = cast(ПунктМеню)Приложение.отыщиИдМеню(GetMenuItemID(cast(HMENU)сооб.парам1, LOWORD(сооб.парам2)));
							m = cast(ПунктМеню)Приложение.отыщиМеню(cast(HMENU)сооб.парам1);
							if(m)
							{
								//сооб.результат = m.customMsg(*(cast(ОсобоеСооб*)&сооб));
								m._reflectMenu(сооб);
								//return;
							}
						}
						break;
					
					case WM_INITMENU:
						{
							КонтекстноеМеню m;
							
							m = cast(КонтекстноеМеню)Приложение.отыщиМеню(cast(HMENU)сооб.парам1);
							if(m)
							{
								//сооб.результат = m.customMsg(*(cast(ОсобоеСооб*)&сооб));
								m._reflectMenu(сооб);
								//return;
							}
						}
						break;
				}
			}
			
			case WM_RBUTTONUP:
				{
					scope АргиСобМыши mea = new АргиСобМыши(ПКнопкиМыши.ПРАВ, 1, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					приМышиВверху(mea);
				}
				break;
			
			case WM_MBUTTONUP:
				{
					scope АргиСобМыши mea = new АргиСобМыши(ПКнопкиМыши.СРЕДН, 1, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					приМышиВверху(mea);
				}
				break;
			
			case WM_LBUTTONDBLCLK:
				{
					scope АргиСобМыши mea = new АргиСобМыши(ПКнопкиМыши.ЛЕВ, 2, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					приМышиВнизу(mea);
					
					if((ктрлСтиль & (ПСтилиУпрЭлта.СТАНДАРТНЫЙ_КЛИК | ПСтилиУпрЭлта.СТАНДАРТНЫЙ_ДВУКЛИК))
						== (ПСтилиУпрЭлта.СТАНДАРТНЫЙ_КЛИК | ПСтилиУпрЭлта.СТАНДАРТНЫЙ_ДВУКЛИК))
					{
						приДвуклике(АргиСоб.пуст);
					}
				}
				break;
			
			case WM_RBUTTONDBLCLK:
				{
					scope АргиСобМыши mea = new АргиСобМыши(ПКнопкиМыши.ПРАВ, 2, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					приМышиВнизу(mea);
				}
				break;
			
			case WM_MBUTTONDBLCLK:
				{
					scope АргиСобМыши mea = new АргиСобМыши(ПКнопкиМыши.СРЕДН, 2, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0);
					приМышиВнизу(mea);
				}
				break;
			
			case WM_SETFOCUS:
				_wmSetFocus();
				// дефОкПроц* Форма focuses а child.
				break;
			
			case WM_KILLFOCUS:
				_wmKillFocus();
				break;
			
			case WM_ENABLE:
				приИзмененииВключения(АргиСоб.пуст);
				
				// дефОкПроц*
				break;
			
			/+
			case WM_NEXTDLGCTL:
				if(сооб.парам1 && !LOWORD(сооб.парам2))
				{
					HWND hwf;
					hwf = GetFocus();
					if(hwf)
					{
						УпрЭлт hwc;
						hwc = УпрЭлт.поУказателю(hwf);
						if(hwc)
						{
							if(hwc._rtype() & 0x20) // TabControl
							{
								hwf = GetWindow(hwf, GW_CHILD);
								if(hwf)
								{
									// Can't do this because it could be modifying someone else's memory.
									//сооб.парам1 = cast(WPARAM)hwf;
									//сооб.парам2 = MAKELPARAM(1, 0);
									сооб.результат = DefWindowProcA(сооб.уок, WM_NEXTDLGCTL, cast(WPARAM)hwf, MAKELPARAM(TRUE, 0));
									return;
								}
							}
						}
					}
				}
				break;
			+/
			
			case WM_SETTEXT:
				дефОкПроц(сооб);
				
				// Need to fetch it because cast(ткст0)lparam isn't always accessible ?
				// Should this go in _wndProc()? Need to дефОкПроц() first ?
				if(ктрлСтиль & ПСтилиУпрЭлта.CACHE_TEXT)
					окТекст = _fetchText();
				
				приИзмененииТекста(АргиСоб.пуст);
				return;
			
			case WM_SETFONT:
				// Don't replace -окШрифт- if it's the same one, beacuse the old Шрифт
				// object will get garbage collected and probably delete the HFONT.
				
				//приИзмененииШрифта(АргиСоб.пуст);
				
				// дефОкПроц*
				return;
			
			/+
			case WM_STYLECHANGED:
				{
					//дефОкПроц(сооб);
					
					STYLESTRUCT* ss = cast(STYLESTRUCT*)сооб.парам2;
					DWORD изменено = ss.styleOld ^ ss.styleNew;
					
					if(сооб.парам1 == GWL_EXSTYLE)
					{
						//if(изменено & WS_EX_RTLREADING)
						//	приИзмененииСправаНалево(АргиСоб.пуст);
					}
				}
				break;
			+/
			
			case WM_ACTIVATE:
				switch(LOWORD(сооб.парам1))
				{
					case WA_INACTIVE:
						_clicking = нет;
						break;
					
					default: ;
				}
				break;
			
			version(ВИЗ_БЕЗ_МЕНЮ)
			{
			}
			else
			{
				case WM_CONTEXTMENU:
					if(уок == cast(HWND)сооб.парам1)
					{
						if(cmenu)
						{
							// Shift+F10 causes xPos and yPos to be -1.
							
							Точка Точка;
							
							if(сооб.парам2 == -1)
								Точка = точкаКЭкрану(Точка(0, 0));
							else
								Точка = Точка(cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2));
							
							SetFocus(указатель); // ?
							cmenu.покажи(this, Точка);
							
							return;
						}
					}
					break;
			}
			
			case WM_HELP:
				{
					HELPINFO* hi = cast(HELPINFO*)сооб.парам2;
					
					scope АргиСобСправка hea = new АргиСобСправка(Точка(hi.MousePos.ш, hi.MousePos.в));
					приЗапросеСправки(hea);
					if(hea.обрабатывается)
					{
						сооб.результат = TRUE;
						return;
					}
				}
				break;
			
			case WM_SYSCOLORCHANGE:
				приИзмененииСистемныхЦветов(АргиСоб.пуст);
				
				// Need to send the сообщение to отпрыски for some common упрэлты to обнови properly.
				foreach(УпрЭлт упрэлм; коллекция)
				{
					SendMessageA(упрэлм.указатель, WM_SYSCOLORCHANGE, сооб.парам1, сооб.парам2);
				}
				break;
			
			case WM_SETTINGCHANGE:
				// Send the сообщение to отпрыски.
				foreach(УпрЭлт упрэлм; коллекция)
				{
					SendMessageA(упрэлм.указатель, WM_SETTINGCHANGE, сооб.парам1, сооб.парам2);
				}
				break;
			
			case WM_PALETTECHANGED:
				/+
				if(cast(HWND)сооб.парам1 != уок)
				{
					// Realize palette.
				}
				+/
				
				// Send the сообщение to отпрыски.
				foreach(УпрЭлт упрэлм; коллекция)
				{
					SendMessageA(упрэлм.указатель, WM_PALETTECHANGED, сооб.парам1, сооб.парам2);
				}
				break;
			
			//case WM_QUERYNEWPALETTE: // Send this сообщение to отпрыски ?
			
			/+
			// Moved this stuff to -родитель-.
			case WM_PARENTNOTIFY:
				switch(LOWORD(сооб.парам1))
				{
					case WM_DESTROY:
						УпрЭлт упрэлм = поУказателюОтпрыска(cast(HWND)сооб.парам2);
						if(упрэлм)
						{
							_ctrlremoved(new АргиСобУпрЭлта(упрэлм));
							
							// ?
							в_изменено();
							//н_раскладка(упрэлм); // This is already being called from somewhere else..
						}
						break;
					
					/+
					case WM_CREATE:
						иницРаскладку();
						break;
					+/
					
					default: ;
				}
				break;
			+/
			
			case WM_CREATE:
				/+
				if(окРодитель)
					иницРаскладку(); // ?
				+/
				if(cbits & CBits.NEED_INIT_LAYOUT)
				{
					if(виден)
					{
						if(окРодитель)
						{
							окРодитель.в_изменено();
							заморозьРазметку(); // Note: исключение could cause failure to restore.
							окРодитель.н_раскладка(this);
							возобновиРазметку(нет);
						}
						н_раскладка(this);
					}
				}
				break;
			
			case WM_DESTROY:
				поУдалениюУказателя(АргиСоб.пуст);
				break;
			
			case WM_GETDLGCODE:
				{
					version(_VIZ_WINDOWS_HUNG_WORKAROUND)
					{
						/+
						if(ктрлСтиль & ПСтилиУпрЭлта.КОНТЕЙНЕР)
						{
							if(!(_exStyle & WS_EX_CONTROLPARENT))
								assert(0);
						}
						+/
						
						DWORD dw;
						dw = GetTickCount();
						if(ldlgcode < dw - 1020)
						{
							ldlgcode = dw - 1000;
						}
						else
						{
							ldlgcode += 50;
							if(ldlgcode > dw)
							{
								// Probably а problem with WS_EX_CONTROLPARENT and WS_TABSTOP.
								if(ldlgcode >= ldlgcode.max - 10_000)
								{
									ldlgcode = 0;
									throw new ИсклЗависанияWindows("Windows hung");
								}
								//сооб.результат |= 0x0004 | 0x0002 | 0x0001; //DLGC_WANTALLKEYS | DLGC_WANTTAB | DLGC_WANTARROWS;
								ldlgcode = ldlgcode.max - 10_000;
								return;
							}
						}
					}
					
					/+
					if(сооб.парам2)
					{
						Сообщение m;
						m._винСооб = *cast(MSG*)сооб.парам2;
						if(обработайАргиСобКлавиш(m))
							return;
					}
					+/
					
					дефОкПроц(сооб);
					
					if(ктрлСтиль & ПСтилиУпрЭлта.WANT_ALL_KEYS)
						сооб.результат |= DLGC_WANTALLKEYS;
					
					// Only want chars if АЛЬТ isn't down, because it would break mnemonics.
					if(!(GetKeyState(VK_MENU) & 0x8000))
						сооб.результат |= DLGC_WANTCHARS;
					
					return;
				}
				break;
			
			case WM_CLOSE:
				/+{
					if(родитель)
					{
						Сообщение mp;
						mp = сооб;
						mp.уок = родитель.указатель;
						родитель.окПроц(mp); // Pass to родитель so it can decide what to do.
					}
				}+/
				return; // Prevent дефОкПроц from destroying the окно!
			
			case 0: // WM_NULL
				// Don't confuse with failed RegisterWindowMessage().
				break;
			
			default: ;
				//дефОкПроц(сооб);
				version(VIZ_NO_WM_GETКОНТРОЛNAME)
				{
				}
				else
				{
					if(сооб.сооб == wmGetControlName)
					{
						//скажиф("WM_GETКОНТРОЛNAME: %.*s; wparam: %d\n", cast(бцел)имя.length, имя.ptr, сооб.парам1);
						if(сооб.парам1 && this.имя.length)
						{
							OSVERSIONINFOA osver;
							osver.dwOSVersionInfoSize = OSVERSIONINFOA.sizeof;
							if(GetVersionExA(&osver))
							{
								try
								{
									if(osver.dwPlatformId <= VER_PLATFORM_WIN32_WINDOWS)
									{
										version(VIZ_UNICODE)
										{
										}
										else
										{
											// ANSI.
											Ткст ansi;
											ansi = вАнзи(this.имя);
											if(сооб.парам1 <= ansi.length)
												ansi = ansi[0 .. сооб.парам1 - 1];
											(cast(ткст0)сооб.парам2)[0 .. ansi.length] = ansi;
											(cast(ткст0)сооб.парам2)[ansi.length] = 0;
											сооб.результат = ansi.length + 1;
										}
									}
									else
									{
										// Unicode.
										Шткст uni;
										uni = вЮни(this.имя);
										if(сооб.парам1 <= uni.length)
											uni = uni[0 .. сооб.парам1 - 1];
										(cast(шткст0)сооб.парам2)[0 .. uni.length] = uni;
										(cast(шткст0)сооб.парам2)[uni.length] = 0;
										сооб.результат = uni.length + 1;
									}
								}
								catch
								{
								}
								return;
							}
						}
					}
				}
		}
		
		дефОкПроц(сооб);
		
		if(сооб.сооб == WM_CREATE)
		{
			АргиСоб ea;
			ea = АргиСоб.пуст;
			поСозданиюУказателя(ea);
			
			debug
			{
				assert(_handlecreated, "При переписании поСозданиюУказателя() обязательно вызывайте super.поСозданиюУказателя()!");
			}
			созданУказатель(this, ea);
			debug
			{
				_handlecreated = нет; // Reset.
			}
		}
	}
	
	
	package final проц _wmSetFocus()
	{
		//onEnter(АргиСоб.пуст);
		
		приФокусировке(АргиСоб.пуст);
		
		// дефОкПроц* Форма focuses а child.
	}
	
	
	package final проц _wmKillFocus()
	{
		_clicking = нет;
		
		//onLeave(АргиСоб.пуст);
		
		//if(cvalidation)
		//	onValidating(new АргиСобОтмены);
		
		приРасфокусировке(АргиСоб.пуст);
	}
	
	
	 проц дефОкПроц(inout Сообщение сооб)
	{
		//сооб.результат = DefWindowProcA(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.common.дефОкПроц(сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	// Always called право when destroyed, before doing anything else.
	// уок is cleared after this step.
	проц _destroying() // package
	{
		//окРодитель = пусто; // ?
	}
	
	
	// This function must be called FIRST for EVERY сообщение to this
	// окно in order to keep the correct окно состояние.
	// This function must not throw exceptions.
	package final проц mustWndProc(inout Сообщение сооб)
	{
		if(needCalcSize)
		{
			needCalcSize = нет;
			ПРЯМ crect;
			GetClientRect(сооб.уок,cast(RECT*) &crect);
			клиентОкРазм.ширина = crect.право;
			клиентОкРазм.высота = crect.низ;
		}
		
		switch(сооб.сооб)
		{
			case WM_NCCALCSIZE:
				needCalcSize = да;
				break;
			
			case WM_WINDOWPOSCHANGED:
				{
					WINDOWPOS* wp = cast(WINDOWPOS*)сооб.парам2;
					
					if(!восстановлениеУказателя)
					{
						//окСтиль = GetWindowLongA(уок, GWL_STYLE); // ..WM_SHOWWINDOW.
						if(wp.флаги & (SWP_HIDEWINDOW | SWP_SHOWWINDOW))
						{
							//окСтиль = GetWindowLongA(уок, GWL_STYLE);
							cbits |= CBits.VISIBLE;
							окСтиль |= WS_VISIBLE;
							if(wp.флаги & SWP_HIDEWINDOW) // Hiding.
							{
								cbits &= ~CBits.VISIBLE;
								окСтиль &= ~WS_VISIBLE;
							}
							//break; // Showing min/max includes other флаги.
						}
					}
					
					//if(!(wp.флаги & SWP_NOMOVE))
					//	окПрям.положение = Точка(wp.ш, wp.в);
					if(!(wp.флаги & SWP_NOSIZE) || !(wp.флаги & SWP_NOMOVE) || (wp.флаги & SWP_FRAMECHANGED))
					{
						//окПрям = _fetchBounds();
						окПрям = Прям(wp.ш, wp.в, wp.cx, wp.cy);
						клиентОкРазм = _fetchClientSize();
					}
					
					if((wp.флаги & (SWP_SHOWWINDOW | SWP_HIDEWINDOW)) || !(wp.флаги & SWP_NOSIZE))
					{
						DWORD rstyle;
						rstyle = GetWindowLongA(сооб.уок, GWL_STYLE);
						rstyle &= WS_MAXIMIZE | WS_MINIMIZE;
						окСтиль &= ~(WS_MAXIMIZE | WS_MINIMIZE);
						окСтиль |= rstyle;
					}
				}
				break;
			
			/+
			case WM_WINDOWPOSCHANGING:
				//oldwrect = окПрям;
				break;
			+/
			
			/+
			case WM_SETFONT:
				//окШрифт = _fetchFont();
				break;
			+/
			
			case WM_STYLECHANGED:
				{
					STYLESTRUCT* ss = cast(STYLESTRUCT*)сооб.парам2;
					
					if(сооб.парам1 == GWL_STYLE)
						окСтиль = ss.styleNew;
					else if(сооб.парам1 == GWL_EXSTYLE)
						окДопСтиль = ss.styleNew;
					
					/+
					окПрям = _fetchBounds();
					клиентОкРазм = _fetchClientSize();
					+/
				}
				break;
			
			/+
			// NOTE: this is sent even if the родитель is shown.
			case WM_SHOWWINDOW:
				if(!сооб.парам2)
				{
					/+
					{
						cbits &= ~(CBits.SW_SHOWN | CBits.SW_HIDDEN);
						DWORD rstyle;
						rstyle = GetWindowLongA(сооб.уок, GWL_STYLE);
						if(cast(BOOL)сооб.парам1)
						{
							//окСтиль |= WS_VISIBLE;
							if(!(WS_VISIBLE & окСтиль) && (WS_VISIBLE & rstyle))
							{
								окСтиль = rstyle;
								cbits |= CBits.SW_SHOWN;
								
								try
								{
									создайОтпрыски(); // Might throw.
								}
								catch(Объект e)
								{
									Приложение.приИсклНити(e);
								}
							}
							окСтиль = rstyle;
						}
						else
						{
							//окСтиль &= ~WS_VISIBLE;
							if((WS_VISIBLE & окСтиль) && !(WS_VISIBLE & rstyle))
							{
								окСтиль = rstyle;
								cbits |= CBits.SW_HIDDEN;
							}
							окСтиль = rstyle;
						}
					}
					+/
					окСтиль = GetWindowLongA(сооб.уок, GWL_STYLE);
					//if(cbits & CBits.FVISIBLE)
					//	окСтиль |= WS_VISIBLE;
				}
				break;
			+/
			
			case WM_ENABLE:
				/+
				//if(IsWindowEnabled(уок))
				if(cast(BOOL)сооб.парам1)
					окСтиль &= ~WS_DISABLED;
				else
					окСтиль |= WS_DISABLED;
				+/
				окСтиль = GetWindowLongA(уок, GWL_STYLE);
				break;
			
			/+
			case WM_PARENTNOTIFY:
				switch(LOWORD(сооб.парам1))
				{
					case WM_DESTROY:
						// ...
						break;
					
					default: ;
				}
				break;
			+/
			
			case WM_NCCREATE:
				{
					//уок = сооб.уок;
					
					/+
					// Not using CREATESTRUCT for окно границы because it can contain
					// CW_USEDEFAULT and other magic значения.
					
					CREATESTRUCTA* cs;
					cs = cast(CREATESTRUCTA*)сооб.парам2;
					
					//окПрям = Прям(cs.ш, cs.в, cs.cx, cs.cy);
					+/
					
					окПрям = _fetchBounds();
					//oldwrect = окПрям;
					клиентОкРазм = _fetchClientSize();
				}
				break;
			
			case WM_CREATE:
				try
				{
					cbits |= CBits.CREATED;
					
					//уок = сооб.уок;
					
					CREATESTRUCTA* cs;
					cs = cast(CREATESTRUCTA*)сооб.парам2;
					/+
					// Done in WM_NCCREATE now.
					//окПрям = _fetchBounds();
					окПрям = Прям(cs.ш, cs.в, cs.cx, cs.cy);
					клиентОкРазм = _fetchClientSize();
					+/
					
					// If class стиль was изменено, обнови.
					if(_fetchClassLong() != окСтильКласса)
						SetClassLongA(уок, GCL_STYLE, окСтильКласса);
					
					// Need to обнови клиентРазм in case of styles in создайПараметры().
					клиентОкРазм = _fetchClientSize();
					
					//finishCreating(сооб.уок);
					
					if(!(ктрлСтиль & ПСтилиУпрЭлта.CACHE_TEXT))
						окТекст = пусто;
					
					/+
					// Gets создан on demand instead.
					if(Цвет.пуст != цвфона)
					{
						hbrBg = цвфона.создайКисть();
					}
					+/
					
					/+
					// ?
					окСтиль = cs.стиль;
					окДопСтиль = cs.dwExStyle;
					+/
					
					создайОтпрыски(); // Might throw. Used to be commented-out.
					
					if(восстановлениеУказателя)
					{
						// After existing messages and functions are done.
						задержиВызов(function(УпрЭлт cthis, т_мера[] params){ cthis.cbits &= ~CBits.RECREATING; });
					}
				}
				catch(Объект e)
				{
					Приложение.приИсклНити(e);
				}
				break;
			
			case WM_DESTROY:
				cbits &= ~CBits.CREATED;
				if(!восстановлениеУказателя)
					cbits &= ~CBits.FORMLOADED;
				_destroying();
				//if(!удаляется)
				if(восстановлениеУказателя)
					заполниДанныеВосстановления();
				break;
			
			case WM_NCDESTROY:
				Приложение.удалиУок(уок);
				уок = HWND.init;
				break;
			
			default: ;
				/+
				if(сооб.сооб == wmViz)
				{
					switch(сооб.парам1)
					{
						case WPARAM_VIZ_:
						
						default: ;
					}
				}
				+/
		}
	}
	
	
	package final проц _wndProc(inout Сообщение сооб)
	{
		//mustWndProc(сооб); // Done in vizWndProc() now.
		окПроц(сооб);
	}
	
	
	package final проц _defWndProc(inout Сообщение сооб)
	{
		this.дефОкПроц(сооб);
	}
	
	
	package final проц Покажи()
	{
		if(окРодитель) // Exclude хозяин.
		{
			SetWindowPos(уок, HWND.init, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_SHOWWINDOW | SWP_NOACTIVATE | SWP_NOZORDER);
		}
		else
		{
			SetWindowPos(уок, HWND_TOP, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_SHOWWINDOW);
		}
	}
	
	
	package final проц doHide()
	{
		SetWindowPos(уок, HWND.init, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE | SWP_HIDEWINDOW | SWP_NOZORDER);
	}
	
	
	//СобОбработчик цветФонаИзменён;
	Событие!(УпрЭлт, АргиСоб) цветФонаИзменён; 	// СобОбработчик backgroundImageChanged;
	//СобОбработчик клик;
	Событие!(УпрЭлт, АргиСоб) клик;
 	version(ВИЗ_БЕЗ_МЕНЮ)
	{
	}
	else
	{
		//СобОбработчик контекстноеМенюИзменено;
		Событие!(УпрЭлт, АргиСоб) контекстноеМенюИзменено;
	}
	//ControlEventHandler добавленУпрЭлт;
	Событие!(УпрЭлт, АргиСобУпрЭлта) добавленУпрЭлт;
 	//ControlEventHandler удалёнУпрЭлт;
	Событие!(УпрЭлт, АргиСобУпрЭлта) удалёнУпрЭлт;
 	//СобОбработчик курсорИзменён;
	Событие!(УпрЭлт, АргиСоб) курсорИзменён;
 	//СобОбработчик вымещен;
	Событие!(УпрЭлт, АргиСоб) вымещен;
 	//СобОбработчик докИзменён;
	//Событие!(УпрЭлт, АргиСоб) докИзменён;
 	Событие!(УпрЭлт, АргиСоб) измененаРазметка;
 	alias измененаРазметка докИзменён;
	
	//СобОбработчик двуклик;
	Событие!(УпрЭлт, АргиСоб) двуклик;
 	//СобОбработчик измененоВключение;
	Событие!(УпрЭлт, АргиСоб) измененоВключение;
 	//СобОбработчик изменёнШрифт;
	Событие!(УпрЭлт, АргиСоб) изменёнШрифт; 
	//СобОбработчик цветППИзменён;
	Событие!(УпрЭлт, АргиСоб) цветППИзменён; 
	//СобОбработчик полученФокус; // After enter.
	Событие!(УпрЭлт, АргиСоб) полученФокус; 
	//СобОбработчик созданУказатель;
	Событие!(УпрЭлт, АргиСоб) созданУказатель; 
	//СобОбработчик указательУдалён;
	Событие!(УпрЭлт, АргиСоб) указательУдалён;
 	//HelpEventHandler затребованаСправка;
	Событие!(УпрЭлт, АргиСобСправка) затребованаСправка;
 	//KeyEventHandler клавишаВнизу;
	Событие!(УпрЭлт, АргиСобКлавиш) клавишаВнизу; 
	//KeyEventHandler клавишаНажата;
	Событие!(УпрЭлт, АргиСобНажатияКлав) клавишаНажата; 
	//KeyEventHandler клавишаВверху;
	Событие!(УпрЭлт, АргиСобКлавиш) клавишаВверху; 
	//LayoutEventHandler разметка;
	Событие!(УпрЭлт, АргиСобРасположение) разметка; 
	//СобОбработчик расфокусировка;
	Событие!(УпрЭлт, АргиСоб) расфокусировка; 
	//MouseEventHandler мышьВнизу;
	Событие!(УпрЭлт, АргиСобМыши) мышьВнизу; 
	//MouseEventHandler мышьВошла;
	Событие!(УпрЭлт, АргиСобМыши) мышьВошла; 
	//MouseEventHandler mouseHover;
	Событие!(УпрЭлт, АргиСобМыши) mouseHover; 
	//MouseEventHandler мышьВышла;
	Событие!(УпрЭлт, АргиСобМыши) мышьВышла; 
	//MouseEventHandler мышьДвижется;
	Событие!(УпрЭлт, АргиСобМыши) мышьДвижется; 
	//MouseEventHandler мышьВверху;
	Событие!(УпрЭлт, АргиСобМыши) мышьВверху; 
	//MouseEventHandler вращениеМыши;
	Событие!(УпрЭлт, АргиСобМыши) вращениеМыши;
 	//СобОбработчик перемещение;
	Событие!(УпрЭлт, АргиСоб) перемещение; 
	//СобОбработчик положениеИзменено;
	alias перемещение положениеИзменено;
	//PaintEventHandler отрисовка;
	Событие!(УпрЭлт, АргиСобРис) отрисовка; 
	//СобОбработчик родительИзменён;
	Событие!(УпрЭлт, АргиСоб) родительИзменён; 
	//СобОбработчик перемерка;
	Событие!(УпрЭлт, АргиСоб) перемерка;
 	//СобОбработчик размерИзменён;
	alias перемерка размерИзменён;
	//СобОбработчик справаНаЛевоИзменено;
	Событие!(УпрЭлт, АргиСоб) справаНаЛевоИзменено; 
		// СобОбработчик styleChanged;
		//СобОбработчик системныеЦветаИзменены;
	Событие!(УпрЭлт, АргиСоб) системныеЦветаИзменены; 
		// СобОбработчик tabIndexChanged;
		// СобОбработчик tabStopChanged;
		//СобОбработчик текстИзменён;
	Событие!(УпрЭлт, АргиСоб) текстИзменён; 	
		//СобОбработчик видимостьИзменена;
	Событие!(УпрЭлт, АргиСоб) видимостьИзменена; 	
		//DragEventHandler дрэгДроп;
	Событие!(УпрЭлт, АргиСобДрэг) дрэгДроп; 	
		//DragEventHandler дрэгВход;
	Событие!(УпрЭлт, АргиСобДрэг) дрэгВход; 
		//СобОбработчик дрэгВыход;
	Событие!(УпрЭлт, АргиСоб) дрэгВыход; 	
		//DragEventHandler дрэгНад;
	Событие!(УпрЭлт, АргиСобДрэг) дрэгНад; 
		//GiveFeedbackEventHandler подачаФидбэка;
	Событие!(УпрЭлт, АргиСобФидбэк) подачаФидбэка; 	
		//QueryContinueDragEventHandler запросПродолжитьДрэг;
	Событие!(УпрЭлт, АргиСобДрэгОпросПродолжить) запросПродолжитьДрэг;
	
package // static
{	
	HWND уок;
	//ПСтилиЯкоря anch = cast(ПСтилиЯкоря)(ПСтилиЯкоря.ВЕРХ | ПСтилиЯкоря.ЛЕВ);
	//бул cvalidation = да;
	version(ВИЗ_БЕЗ_МЕНЮ)
	{
	}
	else
	{
		КонтекстноеМеню cmenu;
	}
	ПДокСтиль sdock = ПДокСтиль.НЕУК;
	Ткст _ctrlname;
	Объект окТэг;
	Цвет цвфона, цвпп;
	Прям окПрям;
	//Прям oldwrect;
	Размер клиентОкРазм;
	Курсор окКурс;
	Шрифт окШрифт;
	УпрЭлт окРодитель;
	Регион окРегион;
	КоллекцияУпрЭлтов коллекция;
	Ткст окТекст; // After creation, this isn't used unless ПСтилиУпрЭлта.CACHE_TEXT.
	ПСтилиУпрЭлта ктрлСтиль = ПСтилиУпрЭлта.СТАНДАРТНЫЙ_КЛИК | ПСтилиУпрЭлта.СТАНДАРТНЫЙ_ДВУКЛИК /+ | ПСтилиУпрЭлта.ПЕРЕРИС_ПЕРЕМЕР +/ ;
	HBRUSH _hbrBg;
	ПСправаНалево пнал = ПСправаНалево.НАСЛЕДОВАТЬ;
	бцел _disallowLayout = 0;
	
	version(VIZ_NO_DRAG_DROP) {} else
	{
		ЦельБроска цельброса = пусто;
	}
	
	// Note: WS_VISIBLE is not reliable.
	LONG окСтиль = WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN | WS_CLIPSIBLINGS; // Child, виден and включен by default.
	LONG окДопСтиль;
	LONG окСтильКласса = WNDCLASS_STYLE;
}	
	
	Размер дефРазм() // getter
	{
		return Размер(0, 0);
	}
	
	/// Construct а new УпрЭлт instance.
	this()
	{
	скажифнс("зис контрола");
		имя = Объект.вТкст(); // ?
		
		окПрям.размер = дефРазм();
		//oldwrect = окПрям;
		
		/+
		цвфона = дефЦветФона;
		цвпп = дефЦветПП;
		окШрифт = дефШрифт;
		окКурс = new Курсор(LoadCursorA(экз.init, IDC_ARROW), нет);
		+/
		цвфона = Цвет.пуст;
		цвпп = Цвет.пуст;
		окШрифт = пусто;
		окКурс = пусто;
		debug(APP_PRINT) скажифнс("зис контрола будет создавать коллекцию");
		коллекция = создайЭкземплярУпрЭлтов();
		debug(APP_PRINT) скажифнс("зис контрола создал коллекцию");
	}
	
	
	this(Ткст текст)
	{
		//this();
		окТекст = текст;
		
		this.коллекция = создайЭкземплярУпрЭлтов();
	}
	
	
	this(УпрЭлт ктрлРодитель, Ткст текст)
	{
		//this();
		окТекст = текст;
		родитель = ктрлРодитель;
		
		коллекция = new КоллекцияУпрЭлтов(this);
	}
	
	
	this(Ткст текст, цел лево, цел верх, цел ширина, цел высота)
	{
		//this();
		окТекст = текст;
		окПрям = Прям(лево, верх, ширина, высота);
		
		коллекция = new КоллекцияУпрЭлтов(this);
	}
	
	
	this(УпрЭлт ктрлРодитель, Ткст текст, цел лево, цел верх, цел ширина, цел высота)
	{
		//this();
		окТекст = текст;
		окПрям = Прям(лево, верх, ширина, высота);
		родитель = ктрлРодитель;
		
		коллекция = new КоллекцияУпрЭлтов(this);
	}
	
	
	/+
	// Used internally.
	this(HWND уок)
	in
	{
		assert(уок);
	}
	body
	{
		this.уок = уок;
		owned = нет;
		
		коллекция = new КоллекцияУпрЭлтов(this);
	}
	+/
	
	
	~this()
	{
		debug(APP_PRINT)
			скажиф("~УпрЭлт %p\n", cast(проц*)this);
		
		version(ВИЗ_БЕЗ_ЗОМБИ_ФОРМ)
		{
		}
		else
		{
			Приложение.зомбиКилл(this); // Does nothing if not zombie.
		}
		
		//вымести(нет);
		удалиУказатель();
		удалиЭтуКистьЗП();
	}
	
	
	/+ package +/ /+  +/ цел _rtype() // package
	{
		return 0;
	}
	
	
		проц вымести()
	{
		вымести(да);
	}
	
	
	 проц вымести(бул вымещается)
	{
		if(вымещается)
		{
			удаляется = да;
			
			version(ВИЗ_БЕЗ_МЕНЮ)
			{
			}
			else
			{
				cmenu = cmenu.init;
			}
			_ctrlname = _ctrlname.init;
			окТэг = окТэг.init;
			окКурс = окКурс.init;
			окШрифт = окШрифт.init;
			окРодитель = окРодитель.init;
			окРегион = окРегион.init;
			окТекст = окТекст.init;
			удалиЭтуКистьЗП();
			//коллекция.отпрыски = пусто; // Not GC-safe in dtor.
			//коллекция = пусто; // ? Causes bad things. Leaving it will do just fine.
		}
		
		if(!созданУказатель_ли)
			return;
		
		удалиУказатель();
		/+
		//assert(уок == HWND.init); // Zombie trips this. (Not anymore with the уок-prop)
		if(уок)
		{
			assert(!IsWindow(уок));
			уок = HWND.init;
		}
		+/
		assert(уок == HWND.init);
		
		приВымещении(АргиСоб.пуст);
	}
	
	

	/+
	// TODO: implement.
	EventHandlerList события() // getter
	{
	}
	+/
	
	
	/+
	// TODO: implement. Is this worth implementing?
	
	// Set to -1 to сброс cache.
	final проц fontHeight(цел fh) // setter
	{
		
	}
	
	
	final цел fontHeight() // getter
	{
		return fonth;
	}
	+/
	
	
		//final проц перемерьПерерисуй(бул подтвержд) // setter
	public final проц перемерьПерерисуй(бул подтвержд) // setter
	{
		/+
		// These class styles get lost sometimes so don't rely on them.
		LONG cl = _classStyle();
		if(подтвержд)
			cl |= CS_HREDRAW | CS_VREDRAW;
		else
			cl &= ~(CS_HREDRAW | CS_VREDRAW);
		
		_classStyle(cl);
		+/
		szdraw = подтвержд;
	}
	
	
	final бул перемерьПерерисуй() // getter
	{
		//return (_classStyle() & (CS_HREDRAW | CS_VREDRAW)) != 0;
		return szdraw;
	}
	
	
	/+
	// 	// I don't think this is reliable.
	final бул hasVisualStyle() // getter
	{
		бул результат = нет;
		HWND hw = указатель; // Always reference указатель.
		HMODULE huxtheme = GetModuleHandleA("uxtheme.dll");
		//HMODULE huxtheme = LoadLibraryA("uxtheme.dll");
		if(huxtheme)
		{
			auto getwintheme = cast(typeof(&GetWindowTheme))GetProcAddress(huxtheme, "GetWindowTheme");
			if(getwintheme)
			{
				результат = getwintheme(hw) != пусто;
			}
			//FreeLibrary(huxtheme);
		}
		return результат;
	}
	+/
	
	
	package final проц _disableVisualStyle()
	{
		assert(созданУказатель_ли);
		
		HMODULE hmuxt;
		hmuxt = GetModuleHandleA("uxtheme.dll");
		if(hmuxt)
		{
			auto setWinTheme = cast(typeof(&SetWindowTheme))GetProcAddress(hmuxt, "SetWindowTheme");
			if(setWinTheme)
			{
				setWinTheme(уок, " "w.ptr, " "w.ptr); // Clear the theme.
			}
		}
	}
	
	
		public final проц дезактивируйВизСтили(бул подтвержд = да)
	{
		if(!подтвержд)
		{
			if(cbits & CBits.VSTYLE)
				return;
			cbits |= CBits.VSTYLE;
			
			if(созданУказатель_ли)
			{
				_crecreate();
			}
		}
		else
		{
			if(!(cbits & CBits.VSTYLE))
				return;
			cbits &= ~CBits.VSTYLE;
			
			if(созданУказатель_ли)
				_disableVisualStyle();
		}
	}
	
	deprecated public final проц активируйВизСтили(бул подтвержд = да)
	{
		return дезактивируйВизСтили(!подтвержд);
	}
	
	
	КоллекцияУпрЭлтов создайЭкземплярУпрЭлтов()
	{
	debug(APP_PRINT) скажифнс("создайЭкземплярУпрЭлтов");
		return new КоллекцияУпрЭлтов(this);		
	}
	
	
	deprecated package final проц создайУказательНаКласс(Ткст имяКласса)
	{
		if(!окРодитель || !окРодитель.указатель || удаляется)
		{
			create_err:
			throw new ВизИскл("Неудачное создание управляющего элемента");
		}
		
		// This is here because referencing окРодитель.указатель might create me.
		//if(создан)
		if(созданУказатель_ли)
			return;
		
		Приложение.созданиеУпрЭлта(this);
		уок = создайОкноДоп(окДопСтиль, имяКласса, окТекст, окСтиль, окПрям.ш, окПрям.в,
			окПрям.ширина, окПрям.высота, окРодитель.указатель, HMENU.init, Приложение.дайЭкз(), пусто);
		if(!уок)
			goto create_err;
	}
	
	
		// Override to change the creation parameters.
	// Be sure to call super.создайПараметры() or все the create params will need to be filled.
	 проц создайПараметры(inout ПарамыСозд cp)
	{
		with(cp)
		{
			имяКласса = CONTROL_CLASSNAME;
			заглавие = окТекст;
			парам = пусто;
			//родитель = окРодитель.указатель;
			родитель = окРодитель ? окРодитель.указатель : HWND.init;
			меню = HMENU.init;
			экземп = Приложение.дайЭкз();
			ш = окПрям.ш;
			в = окПрям.в;
			ширина = окПрям.ширина;
			высота = окПрям.высота;
			стильКласса = окСтильКласса;
			допСтиль = окДопСтиль;
			окСтиль |= WS_VISIBLE;
			if(!(cbits & CBits.VISIBLE))
				окСтиль &= ~WS_VISIBLE;
			стиль = окСтиль;
		}
	}
	
	
		 проц создайУказатель()
	{
		// Note: if изменён, Форма.создайУказатель() should be изменён as well.
		
		if(созданУказатель_ли)
			return;
		
		//создайУказательНаКласс(CONTROL_CLASSNAME);
		
		/+
		if(!окРодитель || !окРодитель.указатель || удаляется)
		{
			create_err:
			//throw new ВизИскл("УпрЭлт creation failure");
			throw new ВизИскл(Объект.вТкст() ~ " creation failure"); // ?
		}
		+/
		
		debug
		{
			Ткст ош;
		}
		if(удаляется)
		{
			debug
			{
				ош = "управляющий элемент вымещается";
			}
			
			debug(APP_PRINT)
			{
				скажиф("Создаётся УпрЭлт указатель при вымещении.\n");
			}
			
			create_err:
			Ткст kmsg = "Неудачное созлание управляющего элемента";
			if(имя.length)
				kmsg ~= " (" ~ имя ~ ")";
			debug
			{
				if(ош.length)
					kmsg ~= " - " ~ ош;
			}
			throw new ВизИскл(kmsg);
			//throw new ВизИскл(Объект.вТкст() ~ " creation failure"); // ?
		}
		
		// Need the родитель's указатель to exist.
		if(окРодитель)
			окРодитель.создайУказатель();
		
		// This is here because окРодитель.создайУказатель() might create me.
		//if(создан)
		if(созданУказатель_ли)
			return;
		
		ПарамыСозд cp;
		/+
		DWORD prevClassStyle;
		prevClassStyle = окСтильКласса;
		+/
		
		создайПараметры(cp);
		assert(!созданУказатель_ли); // Make sure the указатель wasn't создан in создайПараметры().
		
		with(cp)
		{
			окТекст = заглавие;
			//окПрям = Прям(ш, в, ширина, высота); // This gets updated in WM_CREATE.
			окСтильКласса = стильКласса;
			окДопСтиль = допСтиль;
			окСтиль = стиль;
			
			//if(стиль & WS_CHILD) // Breaks контекст-помощь.
			if((ктрлСтиль & ПСтилиУпрЭлта.КОНТЕЙНЕР) && (стиль & WS_CHILD))
			{
				допСтиль |= WS_EX_CONTROLPARENT;
			}
			
			бул vis = (стиль & WS_VISIBLE) != 0;
			
			Приложение.созданиеУпрЭлта(this);
			уок = создайОкноДоп(допСтиль, имяКласса, заглавие, (стиль & ~WS_VISIBLE), ш, в,
				ширина, высота, родитель, меню, экземп, парам);
			if(!уок)
			{
				debug(APP_PRINT)
				{
					скажиф("CreateWindowEx завершился с ошибкой."
						" (допСтиль=0x%X, имяКласса=`%.*s`, заглавие=`%.*s`, стиль=0x%X, ш=%d, в=%d, ширина=%d, высота=%d,"
						" родитель=0x%X, меню=0x%X, экземп=0x%X, парам=0x%X)\n",
						допСтиль, имяКласса, заглавие, стиль, ш, в, ширина, высота,
						родитель, меню, экземп, парам);
				}
				
				debug
				{
						ош =фм("CreateWindowEx завершился с ошибкой.{имяКласса=%s;допСтиль=0x%X;стиль=0x%X;родитель=0x%X;меню=0x%X;экземп=0x%X;}",
							имяКласса, допСтиль, стиль, cast(проц*)родитель, cast(проц*)меню, cast(проц*)экземп);
					
				}
				
				goto create_err;
			}
			
			if(vis)
				Покажи(); // Properly fires приИзмененииВидимости.
		}
		
		//поСозданиюУказателя(АргиСоб.пуст); // Called in WM_CREATE now.
	}
	
	
	package final проц _createHandle()
	{
		создайУказатель();
	}
	
	
		public final бул восстановлениеУказателя() // getter
	{
		if(cbits & CBits.RECREATING)
			return да;
		return нет;
	}
	
	
	private проц _setAllRecreating()
	{
		cbits |= CBits.RECREATING;
		foreach(УпрЭлт cc; упрэлты)
		{
			cc._setAllRecreating();
		}
	}
	
	
		 проц восстановиУказатель()
	in
	{
		assert(!восстановлениеУказателя);
	}
	body
	{
		if(!созданУказатель_ли)
			return;
		
		if(восстановлениеУказателя)
			return;
		
		бул hfocus = вФокусе;
		HWND prevHwnd = GetWindow(уок, GW_HWNDPREV);
		
		_setAllRecreating();
		//scope(exit)
		//	cbits &= ~CBits.RECREATING; // Now done from WM_CREATE.
		
		удалиУказатель();
		создайУказатель();
		
		if(prevHwnd)
			SetWindowPos(уок, prevHwnd, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE);
		else
			SetWindowPos(уок, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE);
		if(hfocus)
			выдели();
	}	
	
	проц удалиУказатель()
	{
		if(!созданУказатель_ли)
			return;
		
		DestroyWindow(уок);
		
		// This stuff is done in WM_DESTROY because DestroyWindow() could be called elsewhere..
		//уок = HWND.init; // Done in WM_DESTROY.
		//поУдалениюУказателя(АргиСоб.пуст); // Done in WM_DESTROY.
	}
	
	
	private final проц заполниДанныеВосстановления()
	{
		//скажиф(" { заполниДанныеВосстановления %.*s }\n", имя);
		
		if(!(ктрлСтиль & ПСтилиУпрЭлта.CACHE_TEXT))
			окТекст = _fetchText();
		
		//окСтильКласса = _fetchClassLong(); // ?
		
		// Fetch отпрыски.
		УпрЭлт[] ccs;
		foreach(УпрЭлт cc; упрэлты)
		{
			ccs ~= cc;
		}
		коллекция.отпрыски = ccs;
	}
	
	
		 проц приВымещении(АргиСоб ea)
	{
		вымещен(this, ea);
	}
	
	
		 final бул дайСтиль(ПСтилиУпрЭлта флаг)
	{
		return (ктрлСтиль & флаг) != 0;
	}
	
	
	 final проц установиСтиль(ПСтилиУпрЭлта флаг, бул значение)
	{
		if(флаг & ПСтилиУпрЭлта.CACHE_TEXT)
		{
			if(значение)
				окТекст = _fetchText();
			else
				окТекст = пусто;
		}
		
		if(значение)
			ктрлСтиль |= флаг;
		else
			ктрлСтиль &= ~флаг;
	}
	
	
		// Only for установиСтиль() styles that are part of уок and wndclass styles.
	 final проц обновиСтили()
	{
		LONG новСтильКласса = _classStyle();
		LONG новСтильОкна = _style();
		
		if(ктрлСтиль & ПСтилиУпрЭлта.СТАНДАРТНЫЙ_ДВУКЛИК)
			новСтильКласса |= CS_DBLCLKS;
		else
			новСтильКласса &= ~CS_DBLCLKS;
		
		/+
		if(ктрлСтиль & ПСтилиУпрЭлта.ПЕРЕРИС_ПЕРЕМЕР)
			новСтильКласса |= CS_HREDRAW | CS_VREDRAW;
		else
			новСтильКласса &= ~(CS_HREDRAW | CS_VREDRAW);
		+/
		
		/+
		if(ктрлСтиль & ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ)
			новСтильОкна |= WS_TABSTOP;
		else
			новСтильОкна &= ~WS_TABSTOP;
		+/
		
		_classStyle(новСтильКласса);
		_style(новСтильОкна);
	}
	
	
	final бул дайВерхнийУровень()
	{
		// return GetParent(уок) == HWND.init;
		return окРодитель is пусто;
	}
		
	package final проц н_раскладка(УпрЭлт упрэлм, бул vcheck = да)
	{
		if(vcheck && !виден)
			return;
		
		if(cbits & CBits.IN_LAYOUT)
			return;
		
		//if(_allowLayout)
		if(!_disallowLayout)
		{
			//скажиф("н_раскладка\n");
			scope АргиСобРасположение lea = new АргиСобРасположение(упрэлм);
			приРазметке(lea);
		}
	}
	
	
	// Z-order of упрэлты has изменено.
	package final проц в_изменено()
	{
		// Z-order can't change if it's not создан or invisible.
		//if(!созданУказатель_ли || !виден)
		//	return;
		
		version(RADIO_GROUP_LAYOUT)
		{
			//скажиф("в_изменено\n");
			
			бул foundRadio = нет;
			
			foreach(УпрЭлт упрэлм; коллекция)
			{
				if(!упрэлм.виден)
					continue;
				
				if(упрэлм._rtype() & 1) // Radio тип.
				{
					LONG wlg;
					wlg = упрэлм._style();
					if(foundRadio)
					{
						if(wlg & WS_GROUP)
							//упрэлм._style(wlg & ~WS_GROUP);
							упрэлм._style(wlg & ~(WS_GROUP | WS_TABSTOP));
					}
					else
					{
						foundRadio = да;
						
						if(!(wlg & WS_GROUP))
							//упрэлм._style(wlg | WS_GROUP);
							упрэлм._style(wlg | WS_GROUP | WS_TABSTOP);
					}
				}
				else
				{
					// Found non-radio so сброс group.
					// Update: only сброс group if found упрэлм with WS_EX_CONTROLPARENT.
					// TODO: check if correct implementation.
					if(упрэлм._exStyle() & WS_EX_CONTROLPARENT)
						foundRadio = нет;
				}
			}
		}
	}
	
	
		// Called after adding the упрэлт to а container.
	 проц иницРаскладку()
	{
		assert(окРодитель !is пусто);
		if(виден && создан) // ?
		{
			окРодитель.в_изменено();
			окРодитель.н_раскладка(this);
		}
	}
	
	
	 проц приРазметке(АргиСобРасположение lea)
	{
		// Note: исключение could cause failure to restore.
		//заморозьРазметку();
		cbits |= CBits.IN_LAYOUT;
		
		debug(EVENT_PRINT)
		{
			скажиф("{ Событие: приРазметке - УпрЭлт %s }\n", имя);
		}
		
		Прям area;
		area = выведиПрямоугольник();
		//УпрЭлт упрэлм;
	assert(упрэлты() !is пусто, "КоллекцияУпрЭлтов \"коллекция\" класса УпрЭлт \n имеет недопустимое значение!");
	
		foreach(УпрЭлт упрэлм; this.коллекция)
		{
		if(!упрэлм.виден || !упрэлм.создан)
				continue;
			if(упрэлм._rtype() & (2 | 4)) // Mdichild | Tabpage
				continue;
			
			//Прям prevctrlграницы;
			//prevctrlграницы = упрэлм.границы;
			//упрэлм.заморозьРазметку(); // Note: исключение could cause failure to restore.
			switch(упрэлм.sdock)
			{
				case ПДокСтиль.НЕУК:
					/+
					if(упрэлм.anch & (ПСтилиЯкоря.ПРАВ | ПСтилиЯкоря.НИЗ)) // If none of these are установи, нет Точка in doing any anchor code.
					{
						Прям newb;
						newb = упрэлм.границы;
						if(упрэлм.anch & ПСтилиЯкоря.ПРАВ)
						{
							if(упрэлм.anch & ПСтилиЯкоря.ЛЕВ)
								newb.ширина += границы.ширина - originalBounds.ширина;
							else
								newb.ш += границы.ширина - originalBounds.ширина;
						}
						if(упрэлм.anch & ПСтилиЯкоря.НИЗ)
						{
							if(упрэлм.anch & ПСтилиЯкоря.ЛЕВ)
								newb.высота += границы.высота - originalBounds.высота;
							else
								newb.в += границы.высота - originalBounds.высота;
						}
						if(newb != упрэлм.границы)
							упрэлм.границы = newb;
					}
					+/
					break;
				
				case ПДокСтиль.ЛЕВ:
					упрэлм.установиЯдроГраниц(area.ш, area.в, 0, area.высота, cast(ПЗаданныеПределы)(ПЗаданныеПределы.ПОЛОЖЕНИЕ | ПЗаданныеПределы.ВЫСОТА));
					area.ш = area.ш + упрэлм.ширина;
					area.ширина = area.ширина - упрэлм.ширина;
					break;
				
				case ПДокСтиль.ВЕРХ:
					упрэлм.установиЯдроГраниц(area.ш, area.в, area.ширина, 0, cast(ПЗаданныеПределы)(ПЗаданныеПределы.ПОЛОЖЕНИЕ | ПЗаданныеПределы.ШИРИНА));
					area.в = area.в + упрэлм.высота;
					area.высота = area.высота - упрэлм.высота;
					break;
				
				case ПДокСтиль.ЗАПОЛНИТЬ:
					//упрэлм.границы(Прям(area.ш, area.в, area.ширина, area.высота));
					упрэлм.границы = area;
					// area = ?
					break;
				
				case ПДокСтиль.НИЗ:
					упрэлм.установиЯдроГраниц(area.ш, area.низ - упрэлм.высота, area.ширина, 0, cast(ПЗаданныеПределы)(ПЗаданныеПределы.ПОЛОЖЕНИЕ | ПЗаданныеПределы.ШИРИНА));
					area.высота = area.высота - упрэлм.высота;
					break;
				
				case ПДокСтиль.ПРАВ:
					упрэлм.установиЯдроГраниц(area.право - упрэлм.ширина, area.в, 0, area.высота, cast(ПЗаданныеПределы)(ПЗаданныеПределы.ПОЛОЖЕНИЕ | ПЗаданныеПределы.ВЫСОТА));
					area.ширина = area.ширина - упрэлм.ширина;
					break;
				
				default:
					assert(0);
			}
			//упрэлм.возобновиРазметку(да);
			//упрэлм.возобновиРазметку(prevctrlграницы != упрэлм.границы);
		}
	
		разметка(this, lea);
		
		//возобновиРазметку(нет);
		cbits &= ~CBits.IN_LAYOUT;
	
	}
		
	/+
	// Not sure what to do here.
	deprecated бул isInputChar(сим кодСим)
	{
		return нет;
	}
	+/
		
	проц установиЯдроВидимого(бул подтвержд)
	{
		if(созданУказатель_ли)
		{
			//окСтиль = GetWindowLongA(уок, GWL_STYLE);
			if(виден == подтвержд)
				return;
			
			//ShowWindow(уок, подтвержд ? SW_SHOW : SW_HIDE);
			if(подтвержд)
				Покажи();
			else
				doHide();
		}
		else
		{
			if(подтвержд)
			{
				cbits |= CBits.VISIBLE;
				окСтиль |= WS_VISIBLE;
				создайУпрЭлт();
			}
			else
			{
				cbits &= ~CBits.VISIBLE;
				окСтиль &= ~WS_VISIBLE;
				return; // Not создан and being hidden..
			}
		}
	}
		
	package final бул _wantTabKey()
	{
		if(ктрлСтиль & ПСтилиУпрЭлта.WANT_TAB_KEY)
			return да;
		return нет;
	}
		
		// Return да if processed.
	 бул обработайАргиСобКлавиш(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			case WM_KEYDOWN:
				{
					scope АргиСобКлавиш kea = new АргиСобКлавиш(cast(ПКлавиши)(сооб.парам1 | клавишиМодификаторы));
					
					ushort repeat = сооб.парам2 & 0xFFFF; // First 16 bits.
					for(; repeat; repeat--)
					{
						//kea.обрабатывается = нет;
						приКлавишеВнизу(kea);
					}
					
					if(kea.обрабатывается)
						return да;
				}
				break;
			
			case WM_KEYUP:
				{
					// Repeat count is always 1 for key up.
					scope АргиСобКлавиш kea = new АргиСобКлавиш(cast(ПКлавиши)(сооб.парам1 | клавишиМодификаторы));
					приКлавишиВверху(kea);
					if(kea.обрабатывается)
						return да;
				}
				break;
			
			case WM_CHAR:
				{
					scope АргиСобНажатияКлав kpea = new АргиСобНажатияКлав(cast(дим)сооб.парам1, клавишиМодификаторы);
					приНажатииКлавиши(kpea);
					if(kpea.обрабатывается)
						return да;
				}
				break;
			
			default: ;
		}
		
		дефОкПроц(сооб);
		return !сооб.результат;
	}
	
	
	package final бул _processKeyEventArgs(inout Сообщение сооб)
	{
		return обработайАргиСобКлавиш(сооб);
	}
	
	
	/+
	бул processKeyPreview(inout Сообщение m)
	{
		if(окРодитель)
			return окРодитель.processKeyPreview(m);
		return нет;
	}
	
	
	 бул processDialogChar(дим кодСим)
	{
		if(окРодитель)
			return окРодитель.processDialogChar(кодСим);
		return нет;
	}
	+/
	
	
	 бул обработайМнемонику(дим кодСим)
	{
		return нет;
	}
	
	
	package бул _processMnemonic(дим кодСим)
	{
		return обработайМнемонику(кодСим);
	}
	
	
	
	private enum CCompat: ббайт
	{
		НЕУК = 0,
		DFL095 = 1,
	}
	
		package const ббайт _compat = CCompat.НЕУК;

	
	package final проц _crecreate()
	{
		if(CCompat.DFL095 != _compat)
		{
			if(!восстановлениеУказателя)
				восстановиУказатель();
		}
	}
	
	
	package:

	
	enum CBits: бцел
	{
		НЕУК = 0x0,
		MENTER = 0x1, // Is mouse entered? Only valid if -trackMouseEvent- is non-пусто.
		KILLING = 0x2,
		OWNED = 0x4,
		//ALLOW_LAYOUT = 0x8,
		CLICKING = 0x10,
		NEED_CALC_SIZE = 0x20,
		SZDRAW = 0x40,
		OWNEDBG = 0x80,
		HANDLE_CREATED = 0x100, // debug only
		SW_SHOWN = 0x200,
		SW_HIDDEN = 0x400,
		CREATED = 0x800,
		NEED_INIT_LAYOUT = 0x1000,
		IN_LAYOUT = 0x2000,
		FVISIBLE = 0x4000,
		VISIBLE = 0x8000,
		NOCLOSING = 0x10000,
		ASCROLL = 0x20000,
		ASCALE = 0x40000,
		FORM = 0x80000,
		RECREATING = 0x100000,
		HAS_LAYOUT = 0x200000,
		VSTYLE = 0x400000, // If not forced off.
		FORMLOADED = 0x800000, // If not forced off.
		ENABLED = 0x1000000, // Enabled состояние, not considering the родитель.
	}
	
	//CBits cbits = CBits.ALLOW_LAYOUT;
	//CBits cbits = CBits.НЕУК;
	CBits cbits = CBits.VISIBLE | CBits.VSTYLE | CBits.ENABLED;
	
	
	final:
	
	проц menter(бул подтвержд) // setter
		{ if(подтвержд) cbits |= CBits.MENTER; else cbits &= ~CBits.MENTER; }
	бул menter() // getter
		{ return (cbits & CBits.MENTER) != 0; }
	
	проц удаляется(бул подтвержд) // setter
		//{ if(подтвержд) cbits |= CBits.KILLING; else cbits &= ~CBits.KILLING; }
		{ assert(подтвержд); if(подтвержд) cbits |= CBits.KILLING; }
	бул удаляется() // getter
		{ return (cbits & CBits.KILLING) != 0; }
	
	проц owned(бул подтвержд) // setter
		{ if(подтвержд) cbits |= CBits.OWNED; else cbits &= ~CBits.OWNED; }
	бул owned() // getter
		{ return (cbits & CBits.OWNED) != 0; }
	
	/+
	проц _allowLayout(бул подтвержд) // setter
		{ if(подтвержд) cbits |= CBits.ALLOW_LAYOUT; else cbits &= ~CBits.ALLOW_LAYOUT; }
	бул _allowLayout() // getter
		{ return (cbits & CBits.ALLOW_LAYOUT) != 0; }
	+/
	
	проц _clicking(бул подтвержд) // setter
		{ if(подтвержд) cbits |= CBits.CLICKING; else cbits &= ~CBits.CLICKING; }
	бул _clicking() // getter
		{ return (cbits & CBits.CLICKING) != 0; }
	
	проц needCalcSize(бул подтвержд) // setter
		{ if(подтвержд) cbits |= CBits.NEED_CALC_SIZE; else cbits &= ~CBits.NEED_CALC_SIZE; }
	бул needCalcSize() // getter
		{ return (cbits & CBits.NEED_CALC_SIZE) != 0; }
	
	проц szdraw(бул подтвержд) // setter
		{ if(подтвержд) cbits |= CBits.SZDRAW; else cbits &= ~CBits.SZDRAW; }
	бул szdraw() // getter
		{ return (cbits & CBits.SZDRAW) != 0; }
	
	проц ownedbg(бул подтвержд) // setter
		{ if(подтвержд) cbits |= CBits.OWNEDBG; else cbits &= ~CBits.OWNEDBG; }
	бул ownedbg() // getter
		{ return (cbits & CBits.OWNEDBG) != 0; }
	
	debug
	{
		проц _handlecreated(бул подтвержд) // setter
			{ if(подтвержд) cbits |= CBits.HANDLE_CREATED; else cbits &= ~CBits.HANDLE_CREATED; }
		бул _handlecreated() // getter
			{ return (cbits & CBits.HANDLE_CREATED) != 0; }
	}
	
	
	LONG _exStyle()
	{
		// return GetWindowLongA(уок, GWL_EXSTYLE);
		return окДопСтиль;
	}
	
	
	проц _exStyle(LONG wl)
	{
		if(созданУказатель_ли)
		{
			SetWindowLongA(уок, GWL_EXSTYLE, wl);
		}
		
		окДопСтиль = wl;
	}
	
	
	LONG _style()
	{
		// return GetWindowLongA(уок, GWL_STYLE);
		return окСтиль;
	}
	
	
	проц _style(LONG wl)
	{
		if(созданУказатель_ли)
		{
			SetWindowLongA(уок, GWL_STYLE, wl);
		}
		
		окСтиль = wl;
	}
	
	
	HBRUSH hbrBg() // getter
	{
		if(_hbrBg)
			return _hbrBg;
		if(цвфона == Цвет.пуст && родитель && цветФона == родитель.цветФона)
		{
			ownedbg = нет;
			_hbrBg = родитель.hbrBg;
			return _hbrBg;
		}
		hbrBg = цветФона.создайКисть(); // Call hbrBg's setter and установи ownedbg.
		return _hbrBg;
	}
	
	
	проц hbrBg(HBRUSH hbr) // setter
	in
	{
		if(hbr)
		{
			assert(!_hbrBg);
		}
	}
	body
	{
		_hbrBg = hbr;
		ownedbg = да;
	}
	
	
	проц удалиЭтуКистьЗП()
	{
		if(_hbrBg)
		{
			if(ownedbg)
				DeleteObject(_hbrBg);
			_hbrBg = HBRUSH.init;
		}
	}
	
	
	LRESULT defwproc(UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		//return DefWindowProcA(уок, сооб, wparam, lparam);
		return viz.common.дефОкПроц(уок, сооб, wparam, lparam);
	}
	
	
	LONG _fetchClassLong()
	{
		return GetClassLongA(уок, GCL_STYLE);
	}
	
	
	LONG _classStyle()
	{
		// return GetClassLongA(уок, GCL_STYLE);
		// return окСтильКласса;
		
		if(созданУказатель_ли)
		{
			// Always fetch because it's not guaranteed to be accurate.
			окСтильКласса = _fetchClassLong();
		}
		
		return окСтильКласса;
	}
	
	
	package проц _classStyle(LONG cl)
	{
		if(созданУказатель_ли)
		{
			SetClassLongA(уок, GCL_STYLE, cl);
		}
		
		окСтильКласса = cl;
	}
}


export extern(D) package abstract class СуперКлассУпрЭлта: УпрЭлт // dapi.d
{
	// Call previous окПроц().
	abstract  проц предшОкПроц(inout Сообщение сооб);
	
	export:
	
	 override проц окПроц(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			case WM_PAINT:
				{
					ПРЯМ uprect;
					//GetUpdateRect(уок, &uprect, да);
					//приИнвалидировании(new АргиСобИнвалидировать(Прям(&uprect)));
					
					//if(!сооб.парам1)
						GetUpdateRect(уок, cast(RECT*)&uprect, нет); // Preserve.
					
					предшОкПроц(сооб);
					
					// Now fake а normal отрисовка событие...
					
					scope Графика gpx = new ОбщаяГрафика(уок, GetDC(уок));
					//scope Графика gpx = new ОбщаяГрафика(уок, сооб.парам1 ? cast(HDC)сооб.парам1 : GetDC(уок), сооб.парам1 ? нет : да);
					HRGN hrgn;
					
					hrgn = CreateRectRgnIndirect(cast(RECT*) &uprect);
					SelectClipRgn(gpx.указатель, hrgn);
					DeleteObject(hrgn);
					
					scope АргиСобРис pea = new АргиСобРис(gpx, Прям(&uprect));
					
					// Can't erase the background now, Windows just painted..
					//if(ps.fErase)
					//{
					//	prepareDc(gpx.указатель);
					//	приОтрисовкеФона(pea);
					//}
					
					prepareDc(gpx.указатель);
					приОтрисовке(pea);
				}
				break;
			
			case WM_PRINTCLIENT:
				{
					предшОкПроц(сооб);
					
					scope Графика gpx = new ОбщаяГрафика(уок, GetDC(уок));
					scope АргиСобРис pea = new АргиСобРис(gpx,
						Прям(Точка(0, 0), клиентОкРазм));
					
					prepareDc(pea.графика.указатель);
					приОтрисовке(pea);
				}
				break;
			
			case WM_PRINT:
				УпрЭлт.дефОкПроц(сооб);
				break;
			
			case WM_ERASEBKGND:
				УпрЭлт.окПроц(сооб);
				break;
			
			case WM_NCACTIVATE:
			case WM_NCCALCSIZE:
			case WM_NCCREATE:
			case WM_NCPAINT:
				предшОкПроц(сооб);
				break;
			
			case WM_KEYDOWN:
			case WM_KEYUP:
			case WM_CHAR:
			case WM_SYSKEYDOWN:
			case WM_SYSKEYUP:
			case WM_SYSCHAR:
			//case WM_IMECHAR:
				super.окПроц(сооб);
				return;
			
			default:
				предшОкПроц(сооб);
				super.окПроц(сооб);
		}
	}
	
	
	override проц дефОкПроц(inout Сообщение m)
	{
		switch(m.сооб)
		{
			case WM_KEYDOWN:
			case WM_KEYUP:
			case WM_CHAR:
			case WM_SYSKEYDOWN:
			case WM_SYSKEYUP:
			case WM_SYSCHAR:
			//case WM_IMECHAR: // ?
				предшОкПроц(m);
				break;
			
			default: ;
		}
	}
		
	 override проц приОтрисовкеФона(АргиСобРис pea)
	{
		Сообщение сооб;
		
		сооб.уок = указатель;
		сооб.сооб = WM_ERASEBKGND;
		сооб.парам1 = cast(WPARAM)pea.графика.указатель;
		
		предшОкПроц(сооб);
		
		// Don't отрисовка the background twice.
		//super.приОтрисовкеФона(pea);
		
		// Событие ?
		//paintBackground(this, pea);
	}
}


export extern (D) class УпрЭлтСПрокруткой: УпрЭлт // docmain
{
export:
	//
 	deprecated проц автоПрокрутка(бул подтвержд) // setter
	{
		if(подтвержд)
			cbits |= CBits.ASCROLL;
		else
			cbits &= ~CBits.ASCROLL;
	}
	
	// 
	deprecated бул автоПрокрутка() // getter
	{
		return (cbits & CBits.ASCROLL) == CBits.ASCROLL;
	}
	
	
	//
 	deprecated final проц autoScrollMargin(Размер разм) // setter
	{
		//scrollmargin = разм;
	}
	
	// 
	deprecated final Размер autoScrollMargin() // getter
	{
		//return scrollmargin;
		return Размер(0, 0);
	}
	
	
	// 
	deprecated final проц autoScrollMinSize(Размер разм) // setter
	{
		//scrollmin = разм;
	}
	
	// 
	deprecated final Размер autoScrollMinSize() // getter
	{
		//return scrollmin;
		return Размер(0, 0);
	}
	
	
	//
 	deprecated final проц autoScrollPosition(Точка тчк) // setter
	{
		//autoscrollpos = тчк;
	}
	
	// 
	deprecated final Точка autoScrollPosition() // getter
	{
		//return autoscrollpos;
		return Точка(0, 0);
	}
	
	
		final Размер autoScaleBaseSize() // getter
	{
		return autossz;
	}
	
	
	final проц autoScaleBaseSize(Размер newSize) // setter
	in
	{
		assert(newSize.ширина > 0);
		assert(newSize.высота > 0);
	}
	body
	{
		autossz = newSize;
	}
	
	
		final проц автоМасштаб(бул подтвержд) // setter
	{
		if(подтвержд)
			cbits |= CBits.ASCALE;
		else
			cbits &= ~CBits.ASCALE;
	}
	
	
	final бул автоМасштаб() // getter
	{
		return (cbits & CBits.ASCALE) == CBits.ASCALE;
	}
	
	
	final Точка позПрокрутки() // getter
	{
		return Точка(xspos, yspos);
	}
	
	
	static Размер вычислиМасштаб(Размер area, Размер toScale, Размер fromScale) // package
	in
	{
		assert(fromScale.ширина);
		assert(fromScale.высота);
	}
	body
	{
		area.ширина = cast(цел)(cast(float)area.ширина / cast(float)fromScale.ширина * cast(float)toScale.ширина);
		area.высота = cast(цел)(cast(float)area.высота / cast(float)fromScale.высота * cast(float)toScale.высота);
		return area;
	}
	
	
	Размер вычислиМасштаб(Размер area, Размер toScale) // package
	{
		return вычислиМасштаб(area, toScale, ДЕФОЛТНЫЙ_МАСШТАБ);
	}
	
	
	final проц _scale(Размер toScale) // package
	{
		бул first = да;
		
		// Note: doesn't get to-scale for nested scrollable-упрэлты.
		проц xscale(УпрЭлт ктрл, Размер fromScale)
		{
			ктрл.заморозьРазметку();
			
			if(first)
			{
				first = нет;
				ктрл.размер = вычислиМасштаб(ктрл.размер, toScale, fromScale);
			}
			else
			{
				Точка тчк;
				Размер разм;
				разм = вычислиМасштаб(Размер(ктрл.лево, ктрл.верх), toScale, fromScale);
				тчк = Точка(разм.ширина, разм.высота);
				разм = вычислиМасштаб(ктрл.размер, toScale, fromScale);
				ктрл.границы = Прям(тчк, разм);
			}
			
			if(ктрл.естьОтпрыски)
			{
				УпрЭлтСПрокруткой scc;
				foreach(УпрЭлт cc; ктрл.упрэлты)
				{
					scc = cast(УпрЭлтСПрокруткой)cc;
					if(scc)
					{
						if(scc.автоМасштаб) // ?
						{
							xscale(scc, scc.autoScaleBaseSize);
							scc.autoScaleBaseSize = toScale;
						}
					}
					else
					{
						xscale(cc, fromScale);
					}
				}
			}
			
			//ктрл.возобновиРазметку(да);
			ктрл.возобновиРазметку(нет); // Should still be perfectly proportionate if it was properly laid out before scaling.
		}
		
		
		xscale(this, autoScaleBaseSize);
		autoScaleBaseSize = toScale;
	}
	
	
	final проц _scale() // package
	{
		return _scale(дайРазмерАвтоМасштаба());
	}
	
	
	 override проц приДобавленииУпрЭлта(АргиСобУпрЭлта ea)
	{
		super.приДобавленииУпрЭлта(ea);
		
		if(создан) // ?
		if(созданУказатель_ли)
		{
			auto sc = cast(УпрЭлтСПрокруткой)ea.упрэлт;
			if(sc)
			{
				if(sc.автоМасштаб)
					sc._scale();
			}
			else
			{
				if(автоМасштаб)
					_scale();
			}
		}
	}
	
	export class КраяДокПаддинга
	{
		private{
		
		цел _left, _top, _right, _bottom;
		цел _all;
		}
		
		export:
		
		проц изменено()
		{
			дпадИзменён();
		}
		
		проц все(цел ш) // setter
		{
			_bottom = _right = _top = _left = _all = ш;
			
			изменено();
		}
		
		
		final цел все() // getter
		{
			return _all;
		}
		
		
		проц лево(цел ш) // setter
		{
			_left = ш;
			
			изменено();
		}
		
		
		цел лево() // getter
		{
			return _left;
		}
		
		
		проц верх(цел ш) // setter
		{
			_top = ш;
			
			изменено();
		}
		
		
		цел верх() // getter
		{
			return _top;
		}
		
		
		проц право(цел ш) // setter
		{
			_right = ш;
			
			изменено();
		}
		
		
		цел право() // getter
		{
			return _right;
		}
		
		
		проц низ(цел ш) // setter
		{
			_bottom = ш;
			
			изменено();
		}
		
		
		цел низ() // getter
		{
			return _bottom;
		}
	}

static{	
	КраяДокПаддинга dpad;
	Размер autossz = ДЕФОЛТНЫЙ_МАСШТАБ;
	Размер scrollsz = { 0, 0 };
	цел xspos = 0, yspos = 0;
	}
	
	
	//override final Прям выведиПрямоугольник() // getter
	override Прям выведиПрямоугольник() // getter
	{
		Прям результат = клиентскийПрямоугольник;
		
		// Subtract док padding.
		if(dpad)
		{
		результат.ш += dpad.лево;
		результат.ширина -= dpad.право - dpad.лево;
		результат.в += dpad.верх;
		результат.высота -= dpad.низ - dpad.верх;
		}
		// Add scroll ширина.
		if(размПрокрутки.ширина > клиентРазм.ширина)
			результат.ширина = результат.ширина + (размПрокрутки.ширина - клиентРазм.ширина);
		if(размПрокрутки.высота > клиентРазм.высота)
			результат.высота = результат.высота + (размПрокрутки.высота - клиентРазм.высота);
		
		// Adjust scroll положение.
		результат.положение = Точка(результат.положение.ш - позПрокрутки.ш, результат.положение.в - позПрокрутки.в);
		
		return результат;
	}
	
	
		final проц размПрокрутки(Размер разм) // setter
	{
		scrollsz = разм;
		
		_fixScrollBounds(); // Implies _adjustScrollSize().
	}
	
	
	final Размер размПрокрутки() // getter
	{
		return scrollsz;
	}
	
	
	
	final КраяДокПаддинга докПаддинг() // getter
	{
		return dpad;
	}

	
	this()
	{
		//super();
		_init();
	}
	
	
	const Размер ДЕФОЛТНЫЙ_МАСШТАБ = { 5, 13 };
	
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
		
	final бул прокруткаВ() // getter
	{
		return (_style() & WS_VSCROLL) != 0;
	}
		
	/+
	override проц приРазметке(АргиСобРасположение lea)
	{
		// ...
		super.приРазметке(lea);
	}
	+/
	
	
	/+
	override проц scaleCore(float ширина, float высота)
	{
		// Might not want to call super.scaleCore().
	}
	+/
	
	
	override проц окПроц(inout Сообщение m)
	{
		switch(m.сооб)
		{
			case WM_VSCROLL:
				{
					SCROLLINFO si = void;
					si.cbSize = SCROLLINFO.sizeof;
					si.fMask = SIF_ALL;
					if(GetScrollInfo(m.уок, SB_VERT, &si))
					{
						цел дельта, maxp;
						maxp = размПрокрутки.высота - клиентРазм.высота;
						switch(LOWORD(m.парам1))
						{
							case SB_LINEDOWN:
								if(yspos >= maxp)
									return;
								дельта = maxp - yspos;
								if(autossz.высота < дельта)
									дельта = autossz.высота;
								break;
							case SB_LINEUP:
								if(yspos <= 0)
									return;
								дельта = yspos;
								if(autossz.высота < дельта)
									дельта = autossz.высота;
								дельта = -дельта;
								break;
							case SB_PAGEDOWN:
								if(yspos >= maxp)
									return;
								if(yspos >= maxp)
									return;
								дельта = maxp - yspos;
								if(клиентРазм.высота < дельта)
									дельта = клиентРазм.высота;
								break;
							case SB_PAGEUP:
								if(yspos <= 0)
									return;
								дельта = yspos;
								if(клиентРазм.высота < дельта)
									дельта = клиентРазм.высота;
								дельта = -дельта;
								break;
							case SB_THUMBTRACK:
							case SB_THUMBPOSITION:
								//дельта = cast(цел)HIWORD(m.парам1) - yspos; // Limited to 16-bits.
								дельта = si.nTrackPos - yspos;
								break;
							case SB_BOTTOM:
								дельта = maxp - yspos;
								break;
							case SB_TOP:
								дельта = -yspos;
								break;
							default: ;
						}
						yspos += дельта;
						SetScrollPos(m.уок, SB_VERT, yspos, TRUE);
						ScrollWindow(m.уок, 0, -дельта, пусто, пусто);
					}
				}
				break;
			
			case WM_HSCROLL:
				{
					SCROLLINFO si = void;
					si.cbSize = SCROLLINFO.sizeof;
					si.fMask = SIF_ALL;
					if(GetScrollInfo(m.уок, SB_HORZ, &si))
					{
						цел дельта, maxp;
						maxp = размПрокрутки.ширина - клиентРазм.ширина;
						switch(LOWORD(m.парам1))
						{
							case SB_LINERIGHT:
								if(xspos >= maxp)
									return;
								дельта = maxp - xspos;
								if(autossz.ширина < дельта)
									дельта = autossz.ширина;
								break;
							case SB_LINELEFT:
								if(xspos <= 0)
									return;
								дельта = xspos;
								if(autossz.ширина < дельта)
									дельта = autossz.ширина;
								дельта = -дельта;
								break;
							case SB_PAGERIGHT:
								if(xspos >= maxp)
									return;
								if(xspos >= maxp)
									return;
								дельта = maxp - xspos;
								if(клиентРазм.ширина < дельта)
									дельта = клиентРазм.ширина;
								break;
							case SB_PAGELEFT:
								if(xspos <= 0)
									return;
								дельта = xspos;
								if(клиентРазм.ширина < дельта)
									дельта = клиентРазм.ширина;
								дельта = -дельта;
								break;
							case SB_THUMBTRACK:
							case SB_THUMBPOSITION:
								//дельта = cast(цел)HIWORD(m.парам1) - xspos; // Limited to 16-bits.
								дельта = si.nTrackPos - xspos;
								break;
							case SB_RIGHT:
								дельта = maxp - xspos;
								break;
							case SB_LEFT:
								дельта = -xspos;
								break;
							default: ;
						}
						xspos += дельта;
						SetScrollPos(m.уок, SB_HORZ, xspos, TRUE);
						ScrollWindow(m.уок, -дельта, 0, пусто, пусто);
					}
				}
				break;
			
			default: ;
		}
		
		super.окПроц(m);
	}
	
	
	override проц приВращенииМыши(АргиСобМыши ea)
	{
		цел maxp = размПрокрутки.высота - клиентРазм.высота;
		цел дельта;
		
		UINT wlines;
		if(!SystemParametersInfoA(SPI_GETWHEELSCROLLLINES, 0, &wlines, 0))
			wlines = 3;
		
		if(ea.дельта < 0)
		{
			if(yspos < maxp)
			{
				дельта = maxp - yspos;
				if(autossz.высота * wlines < дельта)
					дельта = autossz.высота * wlines;
				
				yspos += дельта;
				SetScrollPos(cast(HWND) уок, SB_VERT, yspos, TRUE);
				ScrollWindow(cast(HWND) уок, 0, -дельта, пусто, пусто);
			}
		}
		else
		{
			if(yspos > 0)
			{
				дельта = yspos;
				if(autossz.высота * wlines < дельта)
					дельта = autossz.высота * wlines;
				дельта = -дельта;
				
				yspos += дельта;
				SetScrollPos(cast(HWND) уок, SB_VERT, yspos, TRUE);
				ScrollWindow(cast(HWND) уок, 0, -дельта, пусто, пусто);
			}
		}
		
		super.приВращенииМыши(ea);
	}
	
	
	override проц поСозданиюУказателя(АргиСоб ea)
	{
		xspos = 0;
		yspos = 0;
		
		super.поСозданиюУказателя(ea);
		
		//_adjustScrollSize(FALSE);
		if(прокруткаГ || прокруткаВ)
		{
			_adjustScrollSize(FALSE);
			перевычислиПолностью(); // Need to recalc frame.
		}
	}
	
	
	override проц приИзмененииВидимости(АргиСоб ea)
	{
		if(виден)
			_adjustScrollSize(FALSE);
		
		super.приИзмененииВидимости(ea);
	}
	
	
	private проц _fixScrollBounds()
	{
		if(прокруткаГ || прокруткаВ)
		{
			цел ydiff = 0, xdiff = 0;
			
			if(yspos > размПрокрутки.высота - клиентРазм.высота)
			{
				ydiff = (клиентРазм.высота + yspos) - размПрокрутки.высота;
				yspos -= ydiff;
				if(yspos < 0)
				{
					ydiff += yspos;
					yspos = 0;
				}
			}
			
			if(xspos > размПрокрутки.ширина - клиентРазм.ширина)
			{
				xdiff = (клиентРазм.ширина + xspos) - размПрокрутки.ширина;
				xspos -= xdiff;
				if(xspos < 0)
				{
					xdiff += xspos;
					xspos = 0;
				}
			}
			
			if(созданУказатель_ли)
			{
				if(xdiff || ydiff)
					ScrollWindow(уок, xdiff, ydiff, пусто, пусто);
				
				_adjustScrollSize();
			}
		}
	}
	
	
	override проц приИзмененииРазмера(АргиСоб ea)
	{
		super.приИзмененииРазмера(ea);
		
		_fixScrollBounds();
	}
	
	
	//private:
	//Размер scrollmargin, scrollmin;
	//Точка autoscrollpos;
	
	проц _init()
	{
		dpad = new КраяДокПаддинга;
		//dpad.изменено = &дпадИзменён;
	}
	
	
	проц дпадИзменён()
	{
		н_раскладка(this);
	}
	
	
	проц _adjustScrollSize(BOOL fRedraw = TRUE)
	{
		assert(созданУказатель_ли);
		
		if(!прокруткаГ && !прокруткаВ)
			return;
		
		SCROLLINFO si;
		//if(прокруткаВ)
		{
			si.cbSize = SCROLLINFO.sizeof;
			si.fMask = SIF_RANGE | SIF_PAGE | SIF_POS;
			si.nPos = yspos;
			si.nMin = 0;
			si.nMax = клиентРазм.высота;
			si.nPage = клиентРазм.высота;
			if(размПрокрутки.высота > клиентРазм.высота)
				si.nMax = размПрокрутки.высота;
			if(si.nMax)
				si.nMax--;
			SetScrollInfo(уок, SB_VERT, &si, fRedraw);
		}
		//if(прокруткаГ)
		{
			si.cbSize = SCROLLINFO.sizeof;
			si.fMask = SIF_RANGE | SIF_PAGE | SIF_POS;
			si.nPos = xspos;
			si.nMin = 0;
			si.nMax = клиентРазм.ширина;
			si.nPage = клиентРазм.ширина;
			if(размПрокрутки.ширина > клиентРазм.ширина)
				si.nMax = размПрокрутки.ширина;
			if(si.nMax)
				si.nMax--;
			SetScrollInfo(cast(HWND) уок, SB_HORZ, &si, fRedraw);
		}
	}
}

export extern (D) class УпрЭлтКонтейнер: УпрЭлтСПрокруткой, ИУпрЭлтКонтейнер // docmain
{
export:
		УпрЭлт активныйУпрЭлт() // getter
	{
		/+
		HWND hwfocus, hw;
		hw = hwfocus = GetFocus();
		while(hw)
		{
			if(hw == this.уок)
				return УпрЭлт.поУказателюОтпрыска(hwfocus);
			hw = GetParent(hw);
		}
		return пусто;
		+/
		УпрЭлт ctrlfocus, упрэлм;
		упрэлм = ctrlfocus = УпрЭлт.поУказателюОтпрыска(GetFocus());
		while(упрэлм)
		{
			if(упрэлм is this)
				return ctrlfocus;
			упрэлм = упрэлм.родитель;
		}
		return пусто;
	}
	
	
	проц активныйУпрЭлт(УпрЭлт упрэлм) // setter
	{
		if(!активируйУпрЭлт(упрэлм))
			throw new ВизИскл(" Не удаётся активировать управляющий элемент");
	}
	
	
		// Returns да if successfully активировано.
	final бул активируйУпрЭлт(УпрЭлт упрэлм)
	{
		// Not sure if this is correct.
		
		if(!упрэлм.выделяемый)
			return нет;
		//if(!SetActiveWindow(упрэлм.указатель))
		//	return нет;
		упрэлм.выдели();
		return да;
	}
	
	
		final Форма формаРодитель() // getter
	{
		УпрЭлт par;
		Форма f;
		
		for(par = родитель; par; par = par.родитель)
		{
			f = cast(Форма)par;
			if(f)
				return f;
		}
		
		return пусто;
	}
	
	
	/+
	final бул validate()
	{
		// ...
	}
	+/
	
	
	this()
	{
		//super();
		_init();
	}
	
	
	/+
	// Used internally.
	this(HWND уок)
	{
		super(уок);
		_init();
	}
	+/
	
	
	private проц _init()
	{
		//окДопСтиль |= WS_EX_CONTROLPARENT;
		ктрлСтиль |= ПСтилиУпрЭлта.КОНТЕЙНЕР;
	}
	
	
	/+
	override бул processDialogChar(сим кодСим)
	{
		// Not sure if this is correct.
		return нет;
	}
	+/
	
	
	/+
	deprecated  override бул обработайМнемонику(дим кодСим)
	{
		return нет;
	}
	
	
	бул processTabKey(бул forward)
	{
		if(созданУказатель_ли)
		{
			//SendMessageA(уок, WM_NEXTDLGCTL, !forward, 0);
			//return да;
			выдели(да, forward);
		}
		return нет;
	}
	+/
}

