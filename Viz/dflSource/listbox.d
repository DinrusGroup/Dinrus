//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.listbox;

private import viz.x.dlib;

private import viz.x.winapi, viz.control, viz.base, viz.app;
private import viz.drawing, viz.event, viz.collections;


private extern(C) ук memmove(проц*, проц*, т_мера len);

private extern(Windows) проц _initListbox();


alias СтроковыйОбъект ListString;


abstract class УпрЭлтСписок: СуперКлассУпрЭлта // docmain
{
		final Ткст getItemText(Объект item)
	{
		return дайТкстОбъекта(item);
	}
	
	
	//СобОбработчик selectedValueChanged;
	Событие!(УпрЭлтСписок, АргиСоб) selectedValueChanged; 	
	
		abstract проц выбранныйИндекс(цел idx); // setter
	
	abstract цел выбранныйИндекс(); // getter
	
		abstract проц выбранноеЗначение(Объект val); // setter
	
	
		abstract проц выбранноеЗначение(Ткст str); // setter
	
	abstract Объект выбранноеЗначение(); // getter
	
	
	static Цвет дефЦветФона() // getter
	{
		return СистемныеЦвета.окно;
	}
	
	
	override Цвет цветФона() // getter
	{
		if(Цвет.пуст == цвфона)
			return дефЦветФона;
		return цвфона;
	}
	
	alias УпрЭлт.цветФона цветФона; // Overload.
	
	
	static Цвет дефЦветПП() //getter
	{
		return СистемныеЦвета.текстОкна;
	}
	
	
	override Цвет цветПП() // getter
	{
		if(Цвет.пуст == цвпп)
			return дефЦветПП;
		return цвпп;
	}
	
	alias УпрЭлт.цветПП цветПП; // Overload.
	
	
	this()
	{
	}
	
	
	protected:
	
		проц onSelectedValueChanged(АргиСоб ea)
	{
		selectedValueChanged(this, ea);
	}
	
	
		// Index change causes the значение to be изменено.
	проц onSelectedIndexChanged(АргиСоб ea)
	{
		onSelectedValueChanged(ea); // This appears to be correct.
	}
}


enum SelectionMode: ббайт
{
	ONE, 	НЕУК, 
	MULTI_SIMPLE, 
	MULTI_EXTENDED, 
}


class ListBox: УпрЭлтСписок // docmain
{
		static class SelectedIndexCollection
	{
		deprecated alias length count;
		
		цел length() // getter
		{
			if(!lbox.созданУказатель_ли)
				return 0;
			
			if(lbox.isMultSel())
			{
				return lbox.prevwproc(LB_GETSELCOUNT, 0, 0);
			}
			else
			{
				return (lbox.выбранныйИндекс == -1) ? 0 : 1;
			}
		}
		
		
		цел opIndex(цел idx)
		{
			foreach(цел onidx; this)
			{
				if(!idx)
					return onidx;
				idx--;
			}
			
			// If it's not found it's out of границы and bad things happen.
			assert(0);
			return -1;
		}
		
		
		бул содержит(цел idx)
		{
			return индексУ(idx) != -1;
		}
		
		
		цел индексУ(цел idx)
		{
			цел i = 0;
			foreach(цел onidx; this)
			{
				if(onidx == idx)
					return i;
				i++;
			}
			return -1;
		}
		
		
		цел opApply(цел delegate(inout цел) дг)
		{
			цел результат = 0;
			
			if(lbox.isMultSel())
			{
				цел[] элты;
				элты = new цел[length];
				if(элты.length != lbox.prevwproc(LB_GETSELITEMS, элты.length, cast(LPARAM)cast(цел*)элты))
					throw new ВизИскл("Unable to enumerate selected list элты");
				foreach(цел _idx; элты)
				{
					цел idx = _idx; // Prevent inout.
					результат = дг(idx);
					if(результат)
						break;
				}
			}
			else
			{
				цел idx;
				idx = lbox.выбранныйИндекс;
				if(-1 != idx)
					результат = дг(idx);
			}
			return результат;
		}
		
		mixin OpApplyAddIndex!(opApply, цел);
		
		
		protected this(ListBox lb)
		{
			lbox = lb;
		}
		
		
		package:
		ListBox lbox;
	}
	
	
		static class SelectedObjectCollection
	{
		deprecated alias length count;
		
		цел length() // getter
		{
			if(!lbox.созданУказатель_ли)
				return 0;
			
			if(lbox.isMultSel())
			{
				return lbox.prevwproc(LB_GETSELCOUNT, 0, 0);
			}
			else
			{
				return (lbox.выбранныйИндекс == -1) ? 0 : 1;
			}
		}
		
		
		Объект opIndex(цел idx)
		{
			foreach(Объект объ; this)
			{
				if(!idx)
					return объ;
				idx--;
			}
			
			// If it's not found it's out of границы and bad things happen.
			assert(0);
			return пусто;
		}
		
		
		бул содержит(Объект объ)
		{
			return индексУ(объ) != -1;
		}
		
		
		бул содержит(Ткст str)
		{
			return индексУ(str) != -1;
		}
		
		
		цел индексУ(Объект объ)
		{
			цел idx = 0;
			foreach(Объект onobj; this)
			{
				if(onobj == объ) // Not using is.
					return idx;
				idx++;
			}
			return -1;
		}
		
		
		цел индексУ(Ткст str)
		{
			цел idx = 0;
			foreach(Объект onobj; this)
			{
				//if(дайТкстОбъекта(onobj) is str && дайТкстОбъекта(onobj).length == str.length)
				if(дайТкстОбъекта(onobj) == str)
					return idx;
				idx++;
			}
			return -1;
		}
		
		
		private цел myOpApply(цел delegate(inout Объект) дг)
		{
			цел результат = 0;
			
			if(lbox.isMultSel())
			{
				цел[] элты;
				элты = new цел[length];
				if(элты.length != lbox.prevwproc(LB_GETSELITEMS, элты.length, cast(LPARAM)cast(цел*)элты))
					throw new ВизИскл("Unable to enumerate selected list элты");
				foreach(цел idx; элты)
				{
					Объект объ;
					объ = lbox.элты[idx];
					результат = дг(объ);
					if(результат)
						break;
				}
			}
			else
			{
				Объект объ;
				объ = lbox.выбранныйПункт;
				if(объ)
					результат = дг(объ);
			}
			return результат;
		}
		
		
		private цел myOpApply(цел delegate(inout Ткст) дг)
		{
			цел результат = 0;
			
			if(lbox.isMultSel())
			{
				цел[] элты;
				элты = new цел[length];
				if(элты.length != lbox.prevwproc(LB_GETSELITEMS, элты.length, cast(LPARAM)cast(цел*)элты))
					throw new ВизИскл("Unable to enumerate selected list элты");
				foreach(цел idx; элты)
				{
					Ткст str;
					str = дайТкстОбъекта(lbox.элты[idx]);
					результат = дг(str);
					if(результат)
						break;
				}
			}
			else
			{
				Объект объ;
				Ткст str;
				объ = lbox.выбранныйПункт;
				if(объ)
				{
					str = дайТкстОбъекта(объ);
					результат = дг(str);
				}
			}
			return результат;
		}
		
		mixin OpApplyAddIndex!(myOpApply, Ткст);
		
		mixin OpApplyAddIndex!(myOpApply, Объект);
		
		// Had to do it this way because: DMD 1.028: -H is broken for mixin identifiers
		// Note that this way probably prevents opApply from being overridden.
		alias myOpApply opApply;
		
		
		protected this(ListBox lb)
		{
			lbox = lb;
		}
		
		
		package:
		ListBox lbox;
	}
	
	
		const цел DEFAULT_ITEM_HEIGHT = 13;
		const цел NO_MATCHES = LB_ERR;
	
	
	protected override Размер дефРазм() // getter
	{
		return Размер(120, 95);
	}
	
	
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
	
	
		проц режимОтрисовки(ПРежимОтрисовки dm) // setter
	{
		LONG wl = _style() & ~(LBS_OWNERDRAWVARIABLE | LBS_OWNERDRAWFIXED);
		
		switch(dm)
		{
			case ПРежимОтрисовки.OWNER_DRAW_VARIABLE:
				wl |= LBS_OWNERDRAWVARIABLE;
				break;
			
			case ПРежимОтрисовки.OWNER_DRAW_FIXED:
				wl |= LBS_OWNERDRAWFIXED;
				break;
			
			case ПРежимОтрисовки.НОРМА:
				break;
		}
		
		_style(wl);
		
		_crecreate();
	}
	
	
	ПРежимОтрисовки режимОтрисовки() // getter
	{
		LONG wl = _style();
		
		if(wl & LBS_OWNERDRAWVARIABLE)
			return ПРежимОтрисовки.OWNER_DRAW_VARIABLE;
		if(wl & LBS_OWNERDRAWFIXED)
			return ПРежимОтрисовки.OWNER_DRAW_FIXED;
		return ПРежимОтрисовки.НОРМА;
	}
	
	
		final проц horizontalExtent(цел he) // setter
	{
		if(созданУказатель_ли)
			prevwproc(LB_SETHORIZONTALEXTENT, he, 0);
		
		hextent = he;
	}
	
	
	final цел horizontalExtent() // getter
	{
		if(созданУказатель_ли)
			hextent = cast(цел)prevwproc(LB_GETHORIZONTALEXTENT, 0, 0);
		return hextent;
	}
	
	
		final проц horizontalScrollbar(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | WS_HSCROLL);
		else
			_style(_style() & ~WS_HSCROLL);
		
		_crecreate();
	}
	
	
	final бул horizontalScrollbar() // getter
	{
		return (_style() & WS_HSCROLL) != 0;
	}
	
	
		final проц интегральнаяВысота(бул подтвержд) //setter
	{
		if(подтвержд)
			_style(_style() & ~LBS_NOINTEGRALHEIGHT);
		else
			_style(_style() | LBS_NOINTEGRALHEIGHT);
		
		_crecreate();
	}
	
	
	final бул интегральнаяВысота() // getter
	{
		return (_style() & LBS_NOINTEGRALHEIGHT) == 0;
	}
	
	
		// This function has нет эффект if the ПРежимОтрисовки is OWNER_DRAW_VARIABLE.
	final проц высотаПункта(цел h) // setter
	{
		if(режимОтрисовки == ПРежимОтрисовки.OWNER_DRAW_VARIABLE)
			return;
		
		iheight = h;
		
		if(созданУказатель_ли)
			prevwproc(LB_SETITEMHEIGHT, 0, MAKELPARAM(h, 0));
	}
	
	
	// Return значение is meaningless when ПРежимОтрисовки is OWNER_DRAW_VARIABLE.
	final цел высотаПункта() // getter
	{
		// Requesting it like this when хозяин рисуй variable doesn't work.
		/+
		if(!созданУказатель_ли)
			return iheight;
		
		цел результат = prevwproc(LB_GETITEMHEIGHT, 0, 0);
		if(результат == LB_ERR)
			результат = iheight; // ?
		else
			iheight = результат;
		
		return результат;
		+/
		
		return iheight;
	}
	
	
		final ObjectCollection элты() // getter
	{
		return icollection;
	}
	
	
		final проц multiColumn(бул подтвержд) // setter
	{
		// TODO: is this the correct implementation?
		
		if(подтвержд)
			_style(_style() | LBS_MULTICOLUMN | WS_HSCROLL);
		else
			_style(_style() & ~(LBS_MULTICOLUMN | WS_HSCROLL));
		
		_crecreate();
	}
	
	
	final бул multiColumn() // getter
	{
		return (_style() & LBS_MULTICOLUMN) != 0;
	}
	
	
		final проц scrollAlwaysVisible(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | LBS_DISABLENOSCROLL);
		else
			_style(_style() & ~LBS_DISABLENOSCROLL);
		
		_crecreate();
	}
	
	
	final бул scrollAlwaysVisible() // getter
	{
		return (_style() & LBS_DISABLENOSCROLL) != 0;
	}
	
	
	override проц выбранныйИндекс(цел idx) // setter
	{
		if(созданУказатель_ли)
		{
			if(isMultSel())
			{
				if(idx == -1)
				{
					// Remove все selection.
					
					// Not working право.
					//prevwproc(LB_SELITEMRANGE, нет, MAKELPARAM(0, ushort.max));
					
					// Get the indices directly because deselecting them during
					// selidxcollection.foreach could screw it up.
					
					цел[] элты;
					
					элты = new цел[selidxcollection.length];
					if(элты.length != prevwproc(LB_GETSELITEMS, элты.length, cast(LPARAM)cast(цел*)элты))
						throw new ВизИскл("Unable to сотри selected list элты");
					
					foreach(цел _idx; элты)
					{
						prevwproc(LB_SETSEL, нет, _idx);
					}
				}
				else
				{
					// ?
					prevwproc(LB_SETSEL, да, idx);
				}
			}
			else
			{
				prevwproc(LB_SETCURSEL, idx, 0);
			}
		}
	}
	
	override цел выбранныйИндекс() // getter
	{
		if(созданУказатель_ли)
		{
			if(isMultSel())
			{
				if(selidxcollection.length)
					return selidxcollection[0];
			}
			else
			{
				LRESULT результат;
				результат = prevwproc(LB_GETCURSEL, 0, 0);
				if(LB_ERR != результат) // Redundant.
					return cast(цел)результат;
			}
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
	
	
		final SelectedIndexCollection selectedIndices() // getter
	{
		return selidxcollection;
	}
	
	
		final SelectedObjectCollection selectedItems() // getter
	{
		return selobjcollection;
	}
	
	
		проц selectionMode(SelectionMode selmode) // setter
	{
		LONG wl = _style() & ~(LBS_NOSEL | LBS_EXTENDEDSEL | LBS_MULTIPLESEL);
		
		switch(selmode)
		{
			case SelectionMode.ONE:
				break;
			
			case SelectionMode.MULTI_SIMPLE:
				wl |= LBS_MULTIPLESEL;
				break;
			
			case SelectionMode.MULTI_EXTENDED:
				wl |= LBS_EXTENDEDSEL;
				break;
			
			case SelectionMode.НЕУК:
				wl |= LBS_NOSEL;
				break;
		}
		
		_style(wl);
		
		_crecreate();
	}
	
	
	SelectionMode selectionMode() // getter
	{
		LONG wl = _style();
		
		if(wl & LBS_NOSEL)
			return SelectionMode.НЕУК;
		if(wl & LBS_EXTENDEDSEL)
			return SelectionMode.MULTI_EXTENDED;
		if(wl & LBS_MULTIPLESEL)
			return SelectionMode.MULTI_SIMPLE;
		return SelectionMode.ONE;
	}
	
	
		final проц сортированный(бул подтвержд) // setter
	{
		/+
		if(подтвержд)
			_style(_style() | LBS_SORT);
		else
			_style(_style() & ~LBS_SORT);
		+/
		_sorting = подтвержд;
	}
	
	
	final бул сортированный() // getter
	{
		//return (_style() & LBS_SORT) != 0;
		return _sorting;
	}
	
	
		final проц topIndex(цел idx) // setter
	{
		if(созданУказатель_ли)
			prevwproc(LB_SETTOPINDEX, idx, 0);
	}
	
	
	final цел topIndex() // getter
	{
		if(созданУказатель_ли)
			return prevwproc(LB_GETTOPINDEX, 0, 0);
		return 0;
	}
	
	
		final проц useTabStops(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | LBS_USETABSTOPS);
		else
			_style(_style() & ~LBS_USETABSTOPS);
		
		_crecreate();
	}
	
	
	final бул useTabStops() // getter
	{
		return (_style() & LBS_USETABSTOPS) != 0;
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
	
	
	package final бул isMultSel()
	{
		return (_style() & (LBS_EXTENDEDSEL | LBS_MULTIPLESEL)) != 0;
	}
	
	
		final проц clearSelected()
	{
		if(создан)
			выбранныйИндекс = -1;
	}
	
	
		final цел найдиТекст(Ткст str, цел начИндекс)
	{
		// TODO: найди string if упрэлт not создан ?
		
		цел результат = NO_MATCHES;
		
		if(создан)
		{
			if(viz.x.utf.использоватьЮникод)
				результат = prevwproc(LB_FINDSTRING, начИндекс, cast(LPARAM)viz.x.utf.вЮни0(str));
			else
				результат = prevwproc(LB_FINDSTRING, начИндекс, cast(LPARAM)viz.x.utf.небезопАнзи0(str));
			if(результат == LB_ERR) // Redundant.
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
		
		if(создан)
		{
			if(viz.x.utf.использоватьЮникод)
				результат = prevwproc(LB_FINDSTRINGEXACT, начИндекс, cast(LPARAM)viz.x.utf.вЮни0(str));
			else
				результат = prevwproc(LB_FINDSTRINGEXACT, начИндекс, cast(LPARAM)viz.x.utf.небезопАнзи0(str));
			if(результат == LB_ERR) // Redundant.
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
		цел результат = prevwproc(LB_GETITEMHEIGHT, idx, 0);
		if(LB_ERR == результат)
			throw new ВизИскл("Unable to obtain item высота");
		return результат;
	}
	
	
		final Прям getItemRectangle(цел idx)
	{
		RECT rect;
		if(LB_ERR == prevwproc(LB_GETITEMRECT, idx, cast(LPARAM)&rect))
		{
			//if(idx >= 0 && idx < элты.length)
				return Прям(0, 0, 0, 0); // ?
			//throw new ВизИскл("Unable to obtain item rectangle");
		}
		return Прям(&rect);
	}
	
	
		final бул getSelected(цел idx)
	{
		return prevwproc(LB_GETSEL, idx, 0) > 0;
	}
	
	
		final цел indexFromPoint(цел ш, цел в)
	{
		// LB_ITEMFROMPOINT is "nearest", so also check with the item rectangle to
		// see if the Точка is directly in the item.
		
		// Maybe use LBItemFromPt() from common упрэлты.
		
		цел результат = NO_MATCHES;
		
		if(создан)
		{
			результат = prevwproc(LB_ITEMFROMPOINT, 0, MAKELPARAM(ш, в));
			if(!HIWORD(результат)) // In client area
			{
				//результат = LOWORD(результат); // High word already 0.
				if(результат < 0 || !getItemRectangle(результат).содержит(ш, в))
					результат = NO_MATCHES;
			}
			else // Outside client area.
			{
				результат = NO_MATCHES;
			}
		}
		
		return результат;
	}
	
	
	final цел indexFromPoint(Точка тчк)
	{
		return indexFromPoint(тчк.ш, тчк.в);
	}
	
	
		final проц setSelected(цел idx, бул подтвержд)
	{
		if(создан)
			prevwproc(LB_SETSEL, подтвержд, idx);
	}
	
	
		protected ObjectCollection createItemCollection()
	{
		return new ObjectCollection(this);
	}
	
	
		проц sort()
	{
		if(icollection._items.length)
		{
			Объект[] itemscopy;
			itemscopy = icollection._items.dup;
			itemscopy.sort;
			
			элты.сотри();
			
			начниОбновление();
			scope(exit)
				завершиОбновление();
			
			foreach(цел i, Объект o; itemscopy)
			{
				элты.вставь(i, o);
			}
		}
	}
	
	
		static class ObjectCollection
	{
		protected this(ListBox lbox)
		{
			this.lbox = lbox;
		}
		
		
		protected this(ListBox lbox, Объект[] range)
		{
			this.lbox = lbox;
			добавьДиапазон(range);
		}
		
		
		protected this(ListBox lbox, Ткст[] range)
		{
			this.lbox = lbox;
			добавьДиапазон(range);
		}
		
		
		/+
		protected this(ListBox lbox, ObjectCollection range)
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
				_wraparray.добавьДиапазон(range);
			}
		}
		
		
		проц добавьДиапазон(Ткст[] range)
		{
			foreach(Ткст значение; range)
			{
				добавь(значение);
			}
		}
		
		
		private:
		
		ListBox lbox;
		Объект[] _items;
		
		
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
			if(lbox.создан)
			{
				if(viz.x.utf.использоватьЮникод)
					lbox.prevwproc(LB_INSERTSTRING, idx, cast(LPARAM)viz.x.utf.вЮни0(дайТкстОбъекта(val)));
				else
					lbox.prevwproc(LB_INSERTSTRING, idx, cast(LPARAM)viz.x.utf.вАнзи0(дайТкстОбъекта(val))); // Can this be небезопАнзи0()?
			}
		}
		
		
		проц _removed(т_мера idx, Объект val)
		{
			if(т_мера.max == idx) // Clear все.
			{
				if(lbox.создан)
				{
					lbox.prevwproc(LB_RESETCONTENT, 0, 0);
				}
			}
			else
			{
				if(lbox.создан)
				{
					lbox.prevwproc(LB_DELETESTRING, cast(WPARAM)idx, 0);
				}
			}
		}
		
		
		public:
		
		mixin ListWrapArray!(Объект, _items,
			_blankListCallback!(Объект), _added,
			_blankListCallback!(Объект), _removed,
			да, нет, нет) _wraparray;
	}
	
	
	this()
	{
		_initListbox();
		
		// Default useTabStops and vertical scrolling.
		окСтиль |= WS_TABSTOP | LBS_USETABSTOPS | LBS_HASSTRINGS | WS_VSCROLL | LBS_NOTIFY;
		окДопСтиль |= WS_EX_CLIENTEDGE;
		ктрлСтиль |= ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ;
		окСтильКласса = стильКлассаЛистБокс;
		
		icollection = createItemCollection();
		selidxcollection = new SelectedIndexCollection(this);
		selobjcollection = new SelectedObjectCollection(this);
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		// Set the Ctrl ID to the УОК so that it is unique
		// and WM_MEASUREITEM will work properly.
		SetWindowLongA(уок, GWL_ID, cast(LONG)уок);
		
		if(hextent != 0)
			prevwproc(LB_SETHORIZONTALEXTENT, hextent, 0);
		
		if(iheight != DEFAULT_ITEM_HEIGHT)
			prevwproc(LB_SETITEMHEIGHT, 0, MAKELPARAM(iheight, 0));
		
		Сообщение m;
		m.уок = указатель;
		m.сооб = LB_INSERTSTRING;
		// Note: duplicate code.
		if(viz.x.utf.использоватьЮникод)
		{
			foreach(цел i, Объект объ; icollection._items)
			{
				m.парам1 = i;
				m.парам2 = cast(LPARAM)viz.x.utf.вЮни0(дайТкстОбъекта(объ)); // <--
				
				предшОкПроц(m);
				//if(LB_ERR == m.результат || LB_ERRSPACE == m.результат)
				if(m.результат < 0)
					throw new ВизИскл("Unable to добавь list item");
				
				//prevwproc(LB_SETITEMDATA, m.результат, cast(LPARAM)cast(проц*)объ);
			}
		}
		else
		{
			foreach(цел i, Объект объ; icollection._items)
			{
				m.парам1 = i;
				m.парам2 = cast(LPARAM)viz.x.utf.вАнзи0(дайТкстОбъекта(объ)); // Can this be небезопАнзи0? // <--
				
				предшОкПроц(m);
				//if(LB_ERR == m.результат || LB_ERRSPACE == m.результат)
				if(m.результат < 0)
					throw new ВизИскл("Unable to добавь list item");
				
				//prevwproc(LB_SETITEMDATA, m.результат, cast(LPARAM)cast(проц*)объ);
			}
		}
		
		//перерисуйПолностью();
	}
	
	
	/+
	override проц создайУказатель()
	{
		if(созданУказатель_ли)
			return;
		
		создайУказательНаКласс(LISTBOX_CLASSNAME);
		
		поСозданиюУказателя(АргиСоб.пуст);
	}
	+/
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = LISTBOX_CLASSNAME;
	}
	
	
	//DrawItemEventHandler drawItem;
	Событие!(ListBox, АргиСобПеретягаДанных) drawItem; 	//MeasureItemEventHandler measureItem;
	Событие!(ListBox, АргиСобИзмеренияЭлемента) measureItem; 	
	
	protected:
	
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
		assert(dis.CtlType == ODT_LISTBOX);
	}
	body
	{
		ПСостОтрисовкиЭлемента состояние;
		состояние = cast(ПСостОтрисовкиЭлемента)dis.itemState;
		
		if(dis.itemID == -1)
		{
			FillRect(dis.hDC, &dis.rcItem, hbrBg);
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
		assert(mis.CtlType == ODT_LISTBOX);
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
		//сооб.результат = CallWindowProcA(первОкПроцЛистБокса, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцЛистБокса, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
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
			
			case WM_COMMAND:
				assert(cast(УОК)m.парам2 == указатель);
				switch(HIWORD(m.парам1))
				{
					case LBN_SELCHANGE:
						onSelectedIndexChanged(АргиСоб.пуст);
						break;
					
					case LBN_SELCANCEL:
						onSelectedIndexChanged(АргиСоб.пуст);
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
			case LB_ADDSTRING:
				//сооб.результат = icollection.add2(вТкст(cast(ткст0)сооб.парам2).dup); // TODO: fix.
				//сооб.результат = icollection.add2(вТкст(cast(ткст0)сооб.парам2).idup); // TODO: fix. // Needed in D2. Doesn't work in D1.
				сооб.результат = icollection.add2(cast(Ткст)вТкст(cast(ткст0)сооб.парам2).dup); // TODO: fix. // Needed in D2.
				return;
			
			case LB_INSERTSTRING:
				//сооб.результат = icollection.insert2(сооб.парам1, вТкст(cast(ткст0)сооб.парам2).dup); // TODO: fix.
				//сооб.результат = icollection.insert2(сооб.парам1, вТкст(cast(ткст0)сооб.парам2).idup); // TODO: fix. // Needed in D2. Doesn't work in D1.
				сооб.результат = icollection.insert2(сооб.парам1, cast(Ткст)вТкст(cast(ткст0)сооб.парам2).dup); // TODO: fix. // Needed in D2.
				return;
			
			case LB_DELETESTRING:
				icollection.удалиПо(сооб.парам1);
				сооб.результат = icollection.length;
				return;
			
			case LB_RESETCONTENT:
				icollection.сотри();
				return;
			
			case LB_SETITEMDATA:
				// Cannot установи item данные from outside DFL.
				сооб.результат = LB_ERR;
				return;
			
			case LB_ADDFILE:
				сооб.результат = LB_ERR;
				return;
			
			case LB_DIR:
				сооб.результат = LB_ERR;
				return;
			
			default:
				super.окПроц(сооб);
				return;
		}
		предшОкПроц(сооб);
	}
	
	
	private:
	цел hextent = 0;
	цел iheight = DEFAULT_ITEM_HEIGHT;
	ObjectCollection icollection;
	SelectedIndexCollection selidxcollection;
	SelectedObjectCollection selobjcollection;
	бул _sorting = нет;
	
	
	package:
	final:
	LRESULT prevwproc(UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		//return CallWindowProcA(первОкПроцЛиствью, уок, сооб, wparam, lparam);
		return viz.x.utf.вызовиОкПроц(первОкПроцЛистБокса, уок, сооб, wparam, lparam);
	}
}

