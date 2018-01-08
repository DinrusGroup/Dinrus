//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.combobox;

private import viz.x.dlib;

private import viz.listbox, viz.app, viz.base, viz.x.winapi;
private import viz.event, viz.drawing, viz.collections, viz.control,
	viz.x.utf;


private extern(Windows) проц _initCombobox();


enum ПСтильКомбоБокса: ббайт
{
	ВЫПАДАЮЩИЙ,
 	ВЫПАДАЮЩИЙ_СПИСОК, 
	ПРОСТОЙ, 
}


/*export*/ extern(D) class КомбоБокс: УпрЭлтСписок // docmain
{
/*export*/
	this()
	{
		_initCombobox();
		
		окСтиль |= WS_TABSTOP | WS_VSCROLL | CBS_DROPDOWN | CBS_AUTOHSCROLL | CBS_HASSTRINGS;
		окДопСтиль |= WS_EX_CLIENTEDGE;
		ктрлСтиль |= ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ;
		окСтильКласса = стильКлассаКомбоБокс;
		
		icollection = createItemCollection();
	}
	
	
		final проц выпадающийСтиль(ПСтильКомбоБокса ddstyle) // setter
	{
		LONG st;
		st = _style() & ~(CBS_DROPDOWN | CBS_DROPDOWNLIST | CBS_SIMPLE);
		
		switch(ddstyle)
		{
			case ПСтильКомбоБокса.ВЫПАДАЮЩИЙ:
				_style(st | CBS_DROPDOWN);
				break;
			
			case ПСтильКомбоБокса.ВЫПАДАЮЩИЙ_СПИСОК:
				_style(st | CBS_DROPDOWNLIST);
				break;
			
			case ПСтильКомбоБокса.ПРОСТОЙ:
				_style(st | CBS_SIMPLE);
				break;
				
			default: ;
		}
		
		_crecreate();
	}
	
	
	final ПСтильКомбоБокса выпадающийСтиль() // getter
	{
		LONG st;
		st = _style() & (CBS_DROPDOWN | CBS_DROPDOWNLIST | CBS_SIMPLE);
		
		switch(st)
		{
			case CBS_DROPDOWN:
				return ПСтильКомбоБокса.ВЫПАДАЮЩИЙ;
			
			case CBS_DROPDOWNLIST:
				return ПСтильКомбоБокса.ВЫПАДАЮЩИЙ_СПИСОК;
			
			case CBS_SIMPLE:
				return ПСтильКомбоБокса.ПРОСТОЙ;
				
			default: ;
		}
		return cast(ПСтильКомбоБокса)st;
	}
	
	
		final проц интегральнаяВысота(бул подтвержд) //setter
	{
		if(подтвержд)
			_style(_style() & ~CBS_NOINTEGRALHEIGHT);
		else
			_style(_style() | CBS_NOINTEGRALHEIGHT);
		
		_crecreate();
	}
	
	
	final бул интегральнаяВысота() // getter
	{
		return (_style() & CBS_NOINTEGRALHEIGHT) == 0;
	}
	
	
		// This function has нет эффект if the ПРежимОтрисовки is OWNER_DRAW_VARIABLE.
	проц высотаПункта(цел h) // setter
	{
		if(режимОтрисовки == ПРежимОтрисовки.OWNER_DRAW_VARIABLE)
			return;
		
		iheight = h;
		
		if(созданУказатель_ли)
			prevwproc(CB_SETITEMHEIGHT, 0, h);
	}
	
	
	// Return значение is meaningless when ПРежимОтрисовки is OWNER_DRAW_VARIABLE.
	цел высотаПункта() // getter
	{
		/+
		if(ПРежимОтрисовки == ПРежимОтрисовки.OWNER_DRAW_VARIABLE || !созданУказатель_ли)
			return iheight;
		
		цел результат = prevwproc(CB_GETITEMHEIGHT, 0, 0);
		if(результат == CB_ERR)
			результат = iheight; // ?
		else
			iheight = результат;
		
		return результат;
		+/
		return iheight;
	}
	
	
		проц выбранныйИндекс(цел idx)
	{
		if(созданУказатель_ли)
		{
			prevwproc(CB_SETCURSEL, cast(WPARAM)idx, 0);
		}
	}
	
	
	цел выбранныйИндекс()
	{
		if(созданУказатель_ли)
		{
			LRESULT результат;
			результат = prevwproc(CB_GETCURSEL, 0, 0);
			if(CB_ERR != результат) // Redundant.
				return cast(цел)результат;
		}
		return -1;
	}
	
	
		final проц выбранныйПункт(Объект o) // setter
	{
		цел i;
		i = элты.индексУ(o);
		if(i != -1)
			выбранныйИндекс = i;
	}
	
	
	final проц выбранныйПункт(Ткст str) // setter
	{
		цел i;
		i = элты.индексУ(str);
		if(i != -1)
			выбранныйИндекс = i;
	}
	
	
	final Объект выбранныйПункт() // getter
	{
		цел idx;
		idx = выбранныйИндекс;
		if(idx == -1)
			return пусто;
		return элты[idx];
	}
	
	
		override проц выбранноеЗначение(Объект val) // setter
	{
		выбранныйПункт = val;
	}
	
	
	override проц выбранноеЗначение(Ткст str) // setter
	{
		выбранныйПункт = str;
	}
	
	
	override Объект выбранноеЗначение() // getter
	{
		return выбранныйПункт;
	}
	
	
		final проц сортированный(бул подтвержд) // setter
	{
		/+
		if(подтвержд)
			_style(_style() | CBS_SORT);
		else
			_style(_style() & ~CBS_SORT);
		+/
		_sorting = подтвержд;
	}
	
	
	final бул сортированный() // getter
	{
		//return (_style() & CBS_SORT) != 0;
		return _sorting;
	}
	
	
		final проц начниОбновление()
	{
		prevwproc(WM_SETREDRAW, нет, 0);
	}
	
	
	final проц завершиОбновление()
	{
		prevwproc(WM_SETREDRAW, да, 0);
		инвалидируй(да); // покажи updates.
	}
	
	
		final цел найдиТекст(Ткст str, цел начИндекс)
	{
		// TODO: найди string if упрэлт not создан ?
		
		цел результат = NO_MATCHES;
		
		if(созданУказатель_ли)
		{
			if(viz.x.utf.использоватьЮникод)
				результат = prevwproc(CB_FINDSTRING, начИндекс, cast(LPARAM)viz.x.utf.вЮни0(str));
			else
				результат = prevwproc(CB_FINDSTRING, начИндекс, cast(LPARAM)viz.x.utf.небезопАнзи0(str));
			if(результат == CB_ERR) // Redundant.
				результат = NO_MATCHES;
		}
		
		return результат;
	}
	
	
	final цел найдиТекст(Ткст str)
	{
		return найдиТекст(str, -1); // Start at beginning.
	}
	
	
		final цел найдиТекстСтрого(Ткст str, цел начИндекс)
	{
		// TODO: найди string if упрэлт not создан ?
		
		цел результат = NO_MATCHES;
		
		if(созданУказатель_ли)
		{
			if(viz.x.utf.использоватьЮникод)
				результат = prevwproc(CB_FINDSTRINGEXACT, начИндекс, cast(LPARAM)viz.x.utf.вЮни0(str));
			else
				результат = prevwproc(CB_FINDSTRINGEXACT, начИндекс, cast(LPARAM)viz.x.utf.небезопАнзи0(str));
			if(результат == CB_ERR) // Redundant.
				результат = NO_MATCHES;
		}
		
		return результат;
	}
	
	
	final цел найдиТекстСтрого(Ткст str)
	{
		return найдиТекстСтрого(str, -1); // Start at beginning.
	}
	
	
		final цел дайВысотуПункта(цел idx)
	{
		цел результат = prevwproc(CB_GETITEMHEIGHT, idx, 0);
		if(CB_ERR == результат)
			throw new ВизИскл("Не удаётся получить высоту пункта");
		return результат;
	}
	
	
		final проц режимОтрисовки(ПРежимОтрисовки dm) // setter
	{
		LONG wl = _style() & ~(CBS_OWNERDRAWVARIABLE | CBS_OWNERDRAWFIXED);
		
		switch(dm)
		{
			case ПРежимОтрисовки.OWNER_DRAW_VARIABLE:
				wl |= CBS_OWNERDRAWVARIABLE;
				break;
			
			case ПРежимОтрисовки.OWNER_DRAW_FIXED:
				wl |= CBS_OWNERDRAWFIXED;
				break;
			
			case ПРежимОтрисовки.НОРМА:
				break;
				
			default: ;
		}
		
		_style(wl);
		
		_crecreate();
	}
	
	
	final ПРежимОтрисовки режимОтрисовки() // getter
	{
		LONG wl = _style();
		
		if(wl & CBS_OWNERDRAWVARIABLE)
			return ПРежимОтрисовки.OWNER_DRAW_VARIABLE;
		if(wl & CBS_OWNERDRAWFIXED)
			return ПРежимОтрисовки.OWNER_DRAW_FIXED;
		return ПРежимОтрисовки.НОРМА;
	}
	
	
		final проц выделиВсе()
	{
		if(созданУказатель_ли)
			prevwproc(CB_SETEDITSEL, 0, MAKELPARAM(0, cast(ushort)-1));
	}
	
	
		final проц максДлина(бцел len) // setter
	{
		if(!len)
			lim = 0x7FFFFFFE;
		else
			lim = len;
		
		if(созданУказатель_ли)
		{
			Сообщение m;
			m = Сообщение(указатель, CB_LIMITTEXT, cast(WPARAM)lim, 0);
			предшОкПроц(m);
		}
	}
	
	
	final бцел максДлина() // getter
	{
		return lim;
	}
	
	
		final проц длинаВыделения(бцел len) // setter
	{
		if(созданУказатель_ли)
		{
			бцел v1, v2;
			prevwproc(CB_GETEDITSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
			v2 = v1 + len;
			prevwproc(CB_SETEDITSEL, 0, MAKELPARAM(cast(ushort)v1, cast(ushort)v2));
		}
	}
	
	
	final бцел длинаВыделения() // getter
	{
		if(созданУказатель_ли)
		{
			бцел v1, v2;
			prevwproc(CB_GETEDITSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
			assert(v2 >= v1);
			return v2 - v1;
		}
		return 0;
	}
	
	
		final проц началоВыделения(бцел поз) // setter
	{
		if(созданУказатель_ли)
		{
			бцел v1, v2;
			prevwproc(CB_GETEDITSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
			assert(v2 >= v1);
			v2 = поз + (v2 - v1);
			prevwproc(CB_SETEDITSEL, 0, MAKELPARAM(cast(ushort)поз, cast(ushort)v2));
		}
	}
	
	
	final бцел началоВыделения() // getter
	{
		if(созданУказатель_ли)
		{
			бцел v1, v2;
			prevwproc(CB_GETEDITSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
			return v1;
		}
		return 0;
	}
	
	
		// Number of characters in the текстbox.
	// This does not necessarily correspond to the number of chars; some characters use multiple chars.
	// Return may be larger than the amount of characters.
	// This is а lot faster than retrieving the текст, but retrieving the текст is completely accurate.
	бцел длинаТекста() // getter
	{
		if(!(ктрлСтиль & ПСтилиУпрЭлта.CACHE_TEXT) && созданУказатель_ли)
			//return cast(бцел)SendMessageA(указатель, WM_GETTEXTLENGTH, 0, 0);
			return cast(бцел)viz.x.utf.шлиСооб(указатель, WM_GETTEXTLENGTH, 0, 0);
		return окТекст.length;
	}
	
	
		final проц droppedDown(бул подтвержд) // setter
	{
		if(созданУказатель_ли)
			prevwproc(CB_SHOWDROPDOWN, cast(WPARAM)подтвержд, 0);
	}
	
	
	final бул droppedDown() // getter
	{
		if(созданУказатель_ли)
			return prevwproc(CB_GETDROPPEDSTATE, 0, 0) != FALSE;
		return нет;
	}
	
	
		final проц dropDownWidth(цел w) // setter
	{
		if(dropw == w)
			return;
		
		if(w < 0)
			w = 0;
		dropw = w;
		
		if(созданУказатель_ли)
		{
			if(dropw < ширина)
				prevwproc(CB_SETDROPPEDWIDTH, ширина, 0);
			else
				prevwproc(CB_SETDROPPEDWIDTH, dropw, 0);
		}
	}
	
	
	final цел dropDownWidth() // getter
	{
		if(созданУказатель_ли)
		{
			цел w;
			w = cast(цел)prevwproc(CB_GETDROPPEDWIDTH, 0, 0);
			if(dropw != -1)
				dropw = w;
			return w;
		}
		else
		{
			if(dropw < ширина)
				return ширина;
			return dropw;
		}
	}
	
	
		final ObjectCollection элты() // getter
	{
		return icollection;
	}
	
	
	const цел DEFAULT_ITEM_HEIGHT = 13;
	const цел NO_MATCHES = CB_ERR;
	
	
		static class ObjectCollection
	{
		protected this(КомбоБокс lbox)
		{
			this.lbox = lbox;
		}
		
		
		protected this(КомбоБокс lbox, Объект[] range)
		{
			this.lbox = lbox;
			добавьДиапазон(range);
		}
		
		
		protected this(КомбоБокс lbox, Ткст[] range)
		{
			this.lbox = lbox;
			добавьДиапазон(range);
		}
		
		
		/+
		protected this(КомбоБокс lbox, ObjectCollection range)
		{
			this.lbox = lbox;
			добавьДиапазон(range);
		}
		+/
		
		
		проц добавь(Объект значение)
		{
			add2(значение);
		}
		
		проц добавь(Ткст значение)
		{
			добавь(new ListString(значение));
		}
		
		проц добавьДиапазон(Ткст[] range)
		{
			foreach(Ткст s; range)
			{
				добавь(s);
			}
		}
		
		проц добавьДиапазон(Объект[] range)
		{
			if(lbox.сортированный)
			{
				foreach(Объект значение; range)
				{
					добавь(значение);
				}
			}
			else
			{
				throw new Exception("Range cannot be added. Exception in viz.combobox.d, 574 line");//_wraparray.добавьДиапазон(range);
			}
		}
		
		
		
		
		private:
		
		КомбоБокс lbox;
		Объект[] _items;
		
		
		this()
		{
		}
		
		
		LRESULT insert2(WPARAM idx, Ткст val)
		{
			вставь(idx, val);
			return idx;
		}
		
		
		LRESULT add2(Объект val)
		{
			цел i;
			if(lbox.сортированный)
			{
				for(i = 0; i != _items.length; i++)
				{
					if(val < _items[i])
						break;
				}
			}
			else
			{
				i = _items.length;
			}
			
			вставь(i, val);
			
			return i;
		}
		
		
		LRESULT add2(Ткст val)
		{
			return add2(new ListString(val));
		}
		
		
		проц _added(т_мера idx, Объект val)
		{
			if(lbox.созданУказатель_ли)
			{
				if(viz.x.utf.использоватьЮникод)
					lbox.prevwproc(CB_INSERTSTRING, idx, cast(LPARAM)viz.x.utf.вЮни0(дайТкстОбъекта(val)));
				else
					lbox.prevwproc(CB_INSERTSTRING, idx, cast(LPARAM)viz.x.utf.вАнзи0(дайТкстОбъекта(val))); // Can this be небезопАнзи0()?
			}
		}
		
		
		проц _removed(т_мера idx, Объект val)
		{
			if(т_мера.max == idx) // Clear все.
			{
				if(lbox.созданУказатель_ли)
				{
					lbox.prevwproc(CB_RESETCONTENT, 0, 0);
				}
			}
			else
			{
				if(lbox.созданУказатель_ли)
				{
					lbox.prevwproc(CB_DELETESTRING, cast(WPARAM)idx, 0);
				}
			}
		}
		
		
		public:
		
		mixin ListWrapArray!(Объект, _items,
			_blankListCallback!(Объект), _added,
			_blankListCallback!(Объект), _removed,
			да, нет, нет) _wraparray;
	}
	
	
		protected ObjectCollection createItemCollection()
	{
		return new ObjectCollection(this);
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		// Set the Ctrl ID to the УОК so that it is unique
		// and WM_MEASUREITEM will work properly.
		SetWindowLongA(уок, GWL_ID, cast(LONG)уок);
		
		//prevwproc(EM_SETLIMITTEXT, cast(WPARAM)lim, 0);
		максДлина = lim; // Call virtual function.
		
		if(dropw < ширина)
			prevwproc(CB_SETDROPPEDWIDTH, ширина, 0);
		else
			prevwproc(CB_SETDROPPEDWIDTH, dropw, 0);
		
		if(iheight != DEFAULT_ITEM_HEIGHT)
			prevwproc(CB_SETITEMHEIGHT, 0, iheight);
		
		Сообщение m;
		m.уок = уок;
		m.сооб = CB_INSERTSTRING;
		// Note: duplicate code.
		if(viz.x.utf.использоватьЮникод)
		{
			foreach(цел i, Объект объ; icollection._items)
			{
				m.парам1 = i;
				m.парам2 = cast(LPARAM)viz.x.utf.вЮни0(дайТкстОбъекта(объ)); // <--
				
				предшОкПроц(m);
				//if(CB_ERR == m.результат || CB_ERRSPACE == m.результат)
				if(m.результат < 0)
					throw new ВизИскл("Unable to добавь combo box item");
				
				//prevwproc(CB_SETITEMDATA, m.результат, cast(LPARAM)cast(проц*)объ);
			}
		}
		else
		{
			foreach(цел i, Объект объ; icollection._items)
			{
				m.парам1 = i;
				m.парам2 = cast(LPARAM)viz.x.utf.вАнзи0(дайТкстОбъекта(объ)); // Can this be небезопАнзи0()? // <--
				
				предшОкПроц(m);
				//if(CB_ERR == m.результат || CB_ERRSPACE == m.результат)
				if(m.результат < 0)
					throw new ВизИскл("Unable to добавь combo box item");
				
				//prevwproc(CB_SETITEMDATA, m.результат, cast(LPARAM)cast(проц*)объ);
			}
		}
		
		//перерисуйПолностью();
	}
	
	
	package final бул hasDropList() // getter
	{
		return выпадающийСтиль != ПСтильКомбоБокса.ПРОСТОЙ;
	}
	
	
	// This is needed for the ПРОСТОЙ стиль.
	protected override проц приОтрисовкеФона(АргиСобРис pea)
	{
		RECT rect;
		pea.клипПрямоугольник.дайПрям(&rect);
		FillRect(pea.графика.указатель, &rect, родитель.hbrBg); // Hack.
	}
	
	
	override проц создайУказатель()
	{
		if(созданУказатель_ли)
			return;
		
		// TODO: check if correct implementation.
		if(hasDropList)
			окПрям.высота = DEFAULT_ITEM_HEIGHT * 8;
		
		Ткст ft;
		ft = окТекст;
		
		super.создайУказатель();
		
		// Fix the cached окно rect.
		// This is getting screen coords, not родитель coords. Why was it here, anyway?
		//RECT rect;
		//GetWindowRect(уок, &rect);
		//окПрям = Прям(&rect);
		
		// Fix the combo box's текст since the initial окно
		// текст isn't put in the edit box for some reason.
		Сообщение m;
		if(viz.x.utf.использоватьЮникод)
			m = Сообщение(уок, WM_SETTEXT, 0, cast(LPARAM)viz.x.utf.вЮни0(ft));
		else
			m = Сообщение(уок, WM_SETTEXT, 0, cast(LPARAM)viz.x.utf.вАнзи0(ft)); // Can this be небезопАнзи0()?
		предшОкПроц(m);
	}
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = COMBOBOX_CLASSNAME;
	}
	
	
	//DrawItemEventHandler drawItem;
	Событие!(КомбоБокс, АргиСобПеретягаДанных) drawItem;
	//MeasureItemEventHandler measureItem;
	Событие!(КомбоБокс, АргиСобИзмеренияЭлемента) measureItem;
	
	
	protected:
	override Размер дефРазм() // getter
	{
		return Размер(120, 23); // ?
	}
	
	
	проц onDrawItem(АргиСобПеретягаДанных dieh)
	{
		drawItem(this, dieh);
	}
	
	
	проц onMeasureItem(АргиСобИзмеренияЭлемента miea)
	{
		measureItem(this, miea);
	}
	
	
	package final проц _WmDrawItem(DRAWITEMSTRUCT* dis)
	in
	{
		assert(dis.hwndItem == указатель);
		assert(dis.CtlType == ODT_COMBOBOX);
	}
	body
	{
		ПСостОтрисовкиЭлемента состояние;
		состояние = cast(ПСостОтрисовкиЭлемента)dis.itemState;
		
		if(dis.itemID == -1)
		{
			if(состояние & ПСостОтрисовкиЭлемента.ФОКУС)
				DrawFocusRect(dis.hDC, &dis.rcItem);
		}
		else
		{
			АргиСобПеретягаДанных diea;
			Цвет bc, fc;
			
			if(состояние & ПСостОтрисовкиЭлемента.ВЫДЕЛЕНО)
			{
				bc = Цвет.системныйЦвет(COLOR_HIGHLIGHT);
				fc = Цвет.системныйЦвет(COLOR_HIGHLIGHTTEXT);
			}
			else
			{
				bc = цветФона;
				fc = цветПП;
			}
			
			prepareDc(dis.hDC);
			diea = new АргиСобПеретягаДанных(new Графика(dis.hDC, нет), окШрифт,
				Прям(&dis.rcItem), dis.itemID, состояние, fc, bc);
			
			onDrawItem(diea);
		}
	}
	
	
	package final проц _WmMeasureItem(MEASUREITEMSTRUCT* mis)
	in
	{
		assert(mis.CtlType == ODT_COMBOBOX);
	}
	body
	{
		АргиСобИзмеренияЭлемента miea;
		scope Графика gpx = new ОбщаяГрафика(указатель(), GetDC(указатель));
		miea = new АргиСобИзмеренияЭлемента(gpx, mis.itemID, /+ mis.высотаПункта +/ iheight);
		miea.ширинаЭлемента = mis.ширинаЭлемента;
		
		onMeasureItem(miea);
		
		mis.высотаПункта = miea.высотаПункта;
		mis.ширинаЭлемента = miea.ширинаЭлемента;
	}
	
	
	override проц предшОкПроц(inout Сообщение сооб)
	{
		//сооб.результат = CallWindowProcA(первОкПроцКомбоБокса, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцКомбоБокса, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	protected override проц поОбратномуСообщению(inout Сообщение m)
	{
		super.поОбратномуСообщению(m);
		
		switch(m.сооб)
		{
			case WM_DRAWITEM:
				_WmDrawItem(cast(DRAWITEMSTRUCT*)m.парам2);
				m.результат = 1;
				break;
			
			case WM_MEASUREITEM:
				_WmMeasureItem(cast(MEASUREITEMSTRUCT*)m.парам2);
				m.результат = 1;
				break;
			
			/+
			case WM_CTLCOLORSTATIC:
			case WM_CTLCOLOREDIT:
				/+
				//SetBkColor(cast(HDC)m.парам1, цветФона.вКзс()); // ?
				SetBkMode(cast(HDC)m.парам1, НЕПРОЗРАЧНЫЙ); // ?
				+/
				break;
			+/
			
			case WM_COMMAND:
				//assert(cast(УОК)сооб.парам2 == указатель); // Might be one of its отпрыски.
				switch(HIWORD(m.парам1))
				{
					case CBN_SELCHANGE:
						/+
						if(ПРежимОтрисовки != ПРежимОтрисовки.НОРМА)
						{
							// Hack.
							Объект item = выбранныйПункт;
							текст = item ? дайТкстОбъекта(item) : cast(Ткст)пусто;
						}
						+/
						onSelectedIndexChanged(АргиСоб.пуст);
						приИзмененииТекста(АргиСоб.пуст); // ?
						break;
					
					case CBN_SETFOCUS:
						_wmSetFocus();
						break;
					
					case CBN_KILLFOCUS:
						_wmKillFocus();
						break;
					
					case CBN_EDITCHANGE:
						приИзмененииТекста(АргиСоб.пуст); // ?
						break;
					
					default: ;
				}
				break;
			
			default: ;
		}
	}
	
	
	override проц окПроц(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			case CB_ADDSTRING:
				//сооб.результат = icollection.add2(вТкст(cast(ткст0)сооб.парам2).dup); // TODO: fix.
				//сооб.результат = icollection.add2(вТкст(cast(ткст0)сооб.парам2).idup); // TODO: fix. // Needed in D2. Doesn't work in D1.
				сооб.результат = icollection.add2(cast(Ткст)вТкст(cast(ткст0)сооб.парам2).dup); // TODO: fix. // Needed in D2.
				return;
			
			case CB_INSERTSTRING:
				//сооб.результат = icollection.insert2(сооб.парам1, вТкст(cast(ткст0)сооб.парам2).dup); // TODO: fix.
				//сооб.результат = icollection.insert2(сооб.парам1, вТкст(cast(ткст0)сооб.парам2).idup); // TODO: fix. // Needed in D2. Doesn't work in D1.
				сооб.результат = icollection.insert2(сооб.парам1, cast(Ткст)вТкст(cast(ткст0)сооб.парам2).dup); // TODO: fix. // Needed in D2.
				return;
			
			case CB_DELETESTRING:
				icollection.удалиПо(сооб.парам1);
				сооб.результат = icollection.length;
				return;
			
			case CB_RESETCONTENT:
				icollection.сотри();
				return;
			
			case CB_SETITEMDATA:
				// Cannot установи item данные from outside DFL.
				сооб.результат = CB_ERR;
				return;
			
			case CB_DIR:
				сооб.результат = CB_ERR;
				return;
			
			case CB_LIMITTEXT:
				максДлина = сооб.парам1;
				return;
			
			case WM_SETFOCUS:
			case WM_KILLFOCUS:
				предшОкПроц(сооб);
				return; // Handled by reflected сообщение.
			
			default: ;
		}
		super.окПроц(сооб);
	}
	
	
	private:
	цел iheight = DEFAULT_ITEM_HEIGHT;
	цел dropw = -1;
	ObjectCollection icollection;
	package бцел lim = 30_000; // Documented as default.
	бул _sorting = нет;
	
	
	package:
	final:
	LRESULT prevwproc(UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		//return CallWindowProcA(первОкПроцЛиствью, уок, сооб, wparam, lparam);
		return viz.x.utf.вызовиОкПроц(первОкПроцКомбоБокса, уок, сооб, wparam, lparam);
	}
}

