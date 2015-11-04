//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.listview;

private import viz.x.dlib, stdrus;

private import viz.base, viz.control, viz.x.winapi, viz.app;
private import viz.event, viz.drawing, viz.collections, viz.x.utf;

version(VIZ_NO_IMAGELIST)
{
}
else
{
	private import viz.imagelist;
}


private extern(Windows) проц _initListview();


enum ListViewAlignment: ббайт
{
	ВЕРХ, 	ПО_УМОЛЧАНИЮ, 
	ЛЕВ, 
	SNAP_TO_GRID, 
}


private union CallText
{
	Ткст0 ansi;
	Шткст0 юникод;
}


private CallText getCallText(Ткст текст)
{
	CallText результат;
	if(текст is пусто)
	{
		if(использоватьЮникод)
			результат.юникод = пусто;
		else
			результат.ansi = пусто;
	}
	else
	{
		if(использоватьЮникод)
			результат.юникод = вЮни0(текст);
		else
			результат.ansi = вАнзи0(текст);
	}
	return результат;
}


package union LvColumn
{
	LV_COLUMNW lvcw;
	LV_COLUMNA lvca;
	struct
	{
		UINT mask;
		цел фмт;
		цел cx;
		private ук pszText;
		цел cchTextMax;
		цел iSubItem;
	}
}


class ListViewSubItem: Объект
{
		this()
	{
		Приложение.ppin(cast(проц*)this);
	}
	
	
	this(Ткст thisSubItemText)
	{
		this();
		
		setтекстin(thisSubItemText);
	}
	
	
	this(ListViewItem хозяин, Ткст thisSubItemText)
	{
		this();
		
		setтекстin(thisSubItemText);
		if(хозяин)
		{
			this._item = хозяин;
			хозяин.subItems.добавь(this);
		}
	}
	
	/+
	this(Объект объ) // package
	{
		this(дайТкстОбъекта(объ));
	}
	+/
	
	
	package final проц setтекстin(Ткст newText)
	{
		calltxt = getCallText(newText);
		_txt = newText;
	}
	
	
	Ткст вТкст()
	{
		return текст;
	}
	
	
	override т_рав opEquals(Объект o)
	{
		return текст == дайТкстОбъекта(o);
	}
	
	
	т_рав opEquals(Ткст val)
	{
		return текст == val;
	}
	
	
	override цел opCmp(Объект o)
	{
		return сравнлюб(текст, дайТкстОбъекта(o));
	}
	
	
	цел opCmp(Ткст val)
	{
		return сравнлюб(текст, val);
	}
	
	
		final проц текст(Ткст newText) // setter
	{
		setтекстin(newText);
		
		if(_item && _item.lview && _item.lview.создан)
		{
			цел ii, subi;
			ii = _item.lview.элты.индексУ(_item);
			assert(-1 != ii);
			subi = _item.subItems.индексУ(this);
			assert(-1 != subi);
			_item.lview.updateItemText(ii, newText, subi + 1); // Sub элты really старт at 1 in the list view.
		}
	}
	
	
	final Ткст текст() // getter
	{
		return _txt;
	}
	
	
	private:
	package ListViewItem _item;
	Ткст _txt;
	package CallText calltxt;
}


class ListViewItem: Объект
{
		static class ListViewSubItemCollection
	{
		protected this(ListViewItem хозяин)
		in
		{
			assert(!хозяин.isubs);
		}
		body
		{
			_item = хозяин;
		}
		
		
		private:
		
		ListViewItem _item;
		package ListViewSubItem[] _subs;
		
		
		проц _adding(т_мера idx, ListViewSubItem val)
		{
			if(val._item)
				throw new ВизИскл("ListViewSubItem уже принадлежит к ListViewItem");
		}
		
		
		public:
		
		mixin ListWrapArray!(ListViewSubItem, _subs,
			_adding, _blankListCallback!(ListViewSubItem),
			_blankListCallback!(ListViewSubItem), _blankListCallback!(ListViewSubItem),
			да, нет, нет);
	}
	
	
		this()
	{
		Приложение.ppin(cast(проц*)this);
		
		isubs = new ListViewSubItemCollection(this);
	}
	
	
	this(Ткст текст)
	{
		this();
		
		setтекстin(текст);
	}
	
	
	private final проц _setcheckstate(цел thisindex, бул bchecked)
	{
		if(lview && lview.создан)
		{
			LV_ITEMA li;
			li.stateMask = LVIS_STATEIMAGEMASK;
			li.состояние = cast(LPARAM)(bchecked ? 2 : 1) << 12;
			lview.prevwproc(LVM_SETITEMSTATE, cast(WPARAM)thisindex, cast(LPARAM)&li);
		}
	}
	
	
	private final бул _getcheckstate(цел thisindex)
	{
		if(lview && lview.создан)
		{
			if((lview.prevwproc(LVM_GETITEMSTATE, cast(WPARAM)thisindex, LVIS_STATEIMAGEMASK) >> 12) - 1)
				return да;
		}
		return нет;
	}
	
	
		final проц установлен(бул подтвержд) // setter
	{
		return _setcheckstate(индекс, подтвержд);
	}
	
	
	final бул установлен() // getter
	{
		return _getcheckstate(индекс);
	}
	
	
	package final проц setтекстin(Ткст newText)
	{
		calltxt = getCallText(newText);
		_txt = newText;
	}
	
	
	Ткст вТкст()
	{
		return текст;
	}
	
	
	override т_рав opEquals(Объект o)
	{
		return текст == дайТкстОбъекта(o);
	}
	
	
	т_рав opEquals(Ткст val)
	{
		return текст == val;
	}
	
	
	override цел opCmp(Объект o)
	{
		return сравнлюб(текст, дайТкстОбъекта(o));
	}
	
	
	цел opCmp(Ткст val)
	{
		return сравнлюб(текст, val);
	}
	
	
		final Прям границы() // getter
	{
		if(lview)
		{
			цел i = индекс;
			assert(-1 != i);
			return lview.getItemRect(i);
		}
		return Прям(0, 0, 0, 0);
	}
	
	
		final цел индекс() // getter
	{
		if(lview)
			return lview.litems.индексУ(this);
		return -1;
	}
	
	
		final проц текст(Ткст newText) // setter
	{
		setтекстin(newText);
		
		if(lview && lview.создан)
			lview.updateItemText(this, newText);
	}
	
	
	final Ткст текст() // getter
	{
		return _txt;
	}
	
	
		final проц selected(бул подтвержд) // setter
	{
		if(lview && lview.создан)
		{
			LV_ITEMA li;
			li.stateMask = LVIS_SELECTED;
			if(подтвержд)
				li.состояние = LVIS_SELECTED;
			lview.prevwproc(LVM_SETITEMSTATE, cast(WPARAM)индекс, cast(LPARAM)&li);
		}
	}
	
	
	final бул selected() // getter
	{
		if(lview && lview.создан)
		{
			if(lview.prevwproc(LVM_GETITEMSTATE, cast(WPARAM)индекс, LVIS_SELECTED))
				return да;
		}
		return нет;
	}
	
	
		final ListView listView() // getter
	{
		return lview;
	}
	
	
		final проц тэг(Объект объ) // setter
	{
		_tag = объ;
	}
	
	
	final Объект тэг() // getter
	{
		return _tag;
	}
	
	
	final проц beginEdit()
	{
		if(lview && lview.создан)
		{
			if(viz.x.utf.использоватьЮникод)
			{
				lview.prevwproc(LVM_EDITLABELW, индекс, 0);
			}
			else
			{
				lview.prevwproc(LVM_EDITLABELA, индекс, 0);
			}
		}
	}
	
	
		final ListViewSubItemCollection subItems() // getter
	{
		return isubs;
	}
	
	
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
				final проц imageIndex(цел индекс) // setter
		{
			this._imgidx = индекс;
			
			if(lview && lview.создан)
				lview.updateItem(this);
		}
		
		
		final цел imageIndex() // getter
		{
			return _imgidx;
		}
	}
	
	
	private:
	package ListView lview = пусто;
	Объект _tag = пусто;
	package ListViewSubItemCollection isubs = пусто;
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
		цел _imgidx = -1;
	}
	Ткст _txt;
	package CallText calltxt;
}


class ColumnHeader: Объект
{
		this(Ткст текст)
	{
		this();
		
		this._txt = текст;
	}
	
	
	this()
	{
		Приложение.ppin(cast(проц*)this);
	}
	
	
		final ListView listView() // getter
	{
		return lview;
	}
	
	
		final проц текст(Ткст newText) // setter
	{
		_txt = newText;
		
		if(lview && lview.создан)
		{
			lview.updateColumnText(this, newText);
		}
	}
	
	
	final Ткст текст() // getter
	{
		return _txt;
	}
	
	
	Ткст вТкст()
	{
		return текст;
	}
	
	
	override т_рав opEquals(Объект o)
	{
		return текст == дайТкстОбъекта(o);
	}
	
	
	т_рав opEquals(Ткст val)
	{
		return текст == val;
	}
	
	
	override цел opCmp(Объект o)
	{
		return сравнлюб(текст, дайТкстОбъекта(o));
	}
	
	
	цел opCmp(Ткст val)
	{
		return сравнлюб(текст, val);
	}
	
	
		final цел индекс() // getter
	{
		if(lview)
			lview.cols.индексУ(this);
		return -1;
	}
	
	
		final проц разместиТекст(ПГоризРасположение halign) // setter
	{
		_align = halign;
		
		if(lview && lview.создан)
		{
			lview.updateColumnAlign(this, halign);
		}
	}
	
	
	final ПГоризРасположение разместиТекст() // getter
	{
		return _align;
	}
	
	
		final проц ширина(цел w) // setter
	{
		_width = w;
		
		if(lview && lview.создан)
		{
			lview.updateColumnWidth(this, w);
		}
	}
	
	
	final цел ширина() // getter
	{
		if(lview && lview.создан)
		{
			цел xx;
			xx = lview.getColumnWidth(this);
			if(-1 != xx)
				_width = xx;
		}
		return _width;
	}
	
	
	private:
	package ListView lview;
	Ткст _txt;
	цел _width;
	ПГоризРасположение _align;
}


class LabelEditEventArgs: АргиСоб
{
		this(ListViewItem item, Ткст надпись)
	{
		_item = item;
		_label = надпись;
	}
	
	
	this(ListViewItem node)
	{
		_item = item;
	}
	
	
		final ListViewItem item() // getter
	{
		return _item;
	}
	
	
		final Ткст надпись() // getter
	{
		return _label;
	}
	
	
		final проц cancelEdit(бул подтвержд) // setter
	{
		_cancel = подтвержд;
	}
	
	
	final бул cancelEdit() // getter
	{
		return _cancel;
	}
	
	
	private:
	ListViewItem _item;
	Ткст _label;
	бул _cancel = нет;
}


/+
class ItemCheckEventArgs: АргиСоб
{
	this(цел индекс, ПСостУст newCheckState, ПСостУст oldCheckState)
	{
		this._idx = индекс;
		this._ncs = newCheckState;
		this._ocs = oldCheckState;
	}
	
	
	final ПСостУст currentValue() // getter
	{
		return _ocs;
	}
	
	
	/+
	final проц newValue(ПСостУст cs) // setter
	{
		_ncs = cs;
	}
	+/
	
	
	final ПСостУст newValue() // getter
	{
		return _ncs;
	}
	
	
	private:
	цел _idx;
	ПСостУст _ncs, _ocs;
}
+/


class ItemCheckedEventArgs: АргиСоб
{
	this(ListViewItem item)
	{
		this._item = item;
	}
	
	
	final ListViewItem item() // getter
	{
		return this._item;
	}
	
	
	private:
	ListViewItem _item;
}


class ListView: СуперКлассУпрЭлта // docmain
{
		static class ListViewItemCollection
	{
		protected this(ListView lv)
		in
		{
			assert(lv.litems is пусто);
		}
		body
		{
			this.lv = lv;
		}
		
		
		проц добавь(ListViewItem item)
		{
			цел ii = -1; // Insert индекс.
			
			switch(lv.sorting)
			{
				case ППорядокСортировки.НЕУК: // Add to end.
					ii = _items.length;
					break;
				
				case ППорядокСортировки.ВОЗРАСТАНИЕ: // Insertion sort.
					for(ii = 0; ii != _items.length; ii++)
					{
						assert(lv._sortproc);
						//if(item < _items[ii])
						if(lv._sortproc(item, _items[ii]) < 0)
							break;
					}
					break;
				
				case ППорядокСортировки.УМЕНЬШЕНИЕ: // Insertion sort.
					for(ii = 0; ii != _items.length; ii++)
					{
						assert(lv._sortproc);
						//if(item >= _items[ii])
						if(lv._sortproc(item, _items[ii]) >= 0)
							break;
					}
					break;
				
				default:
					assert(0);
			}
			
			assert(-1 != ii);
			вставь(ii, item);
		}
		
		проц добавь(Ткст текст)
		{
			return добавь(new ListViewItem(текст));
		}
		
		
		// добавьДиапазон must have special case in case of sorting.
		
		проц добавьДиапазон(ListViewItem[] range)
		{
			foreach(ListViewItem item; range)
			{
				добавь(item);
			}
		}
		
		/+
		проц добавьДиапазон(Объект[] range)
		{
			foreach(Объект o; range)
			{
				добавь(o);
			}
		}
		+/
		
		проц добавьДиапазон(Ткст[] range)
		{
			foreach(Ткст s; range)
			{
				добавь(s);
			}
		}
		
		
		private:
		
		ListView lv;
		package ListViewItem[] _items;
		
		
		package final бул создан() // getter
		{
			return lv && lv.создан();
		}
		
		
		package final проц doListItems() // DMD 0.125: this member is not accessible when private.
		in
		{
			assert(создан);
		}
		body
		{
			цел ii;
			foreach(цел i, ListViewItem item; _items)
			{
				ii = lv._ins(i, item);
				//assert(-1 != ii);
				assert(i == ii);
				
				/+
				// Add sub элты.
				foreach(цел subi, ListViewSubItem subItem; item.isubs._subs)
				{
					lv._ins(i, subItem, subi + 1); // Sub элты really старт at 1 in the list view.
				}
				+/
			}
		}
		
		
		проц verifyNoParent(ListViewItem item)
		{
			if(item.lview)
				throw new ВизИскл("ListViewItem already belongs to а ListView");
		}
		
		
		проц _adding(т_мера idx, ListViewItem val)
		{
			verifyNoParent(val);
		}
		
		
		проц _added(т_мера idx, ListViewItem val)
		{
			val.lview = lv;
			
			цел i;
			if(создан)
			{
				i = lv._ins(idx, val);
				assert(-1 != i);
			}
		}
		
		
		проц _removed(т_мера idx, ListViewItem val)
		{
			if(т_мера.max == idx) // Clear все.
			{
				if(создан)
				{
					lv.prevwproc(LVM_DELETEALLITEMS, 0, 0);
				}
			}
			else
			{
				if(создан)
				{
					lv.prevwproc(LVM_DELETEITEM, cast(WPARAM)idx, 0);
				}
			}
		}
		
		
		public:
		
		mixin ListWrapArray!(ListViewItem, _items,
			_adding, _added,
			_blankListCallback!(ListViewItem), _removed,
			да, нет, нет);
	}
	
	
		static class ColumnHeaderCollection
	{
		protected this(ListView хозяин)
		in
		{
			assert(!хозяин.cols);
		}
		body
		{
			lv = хозяин;
		}
		
		
		private:
		ListView lv;
		ColumnHeader[] _headers;
		
		
		package final бул создан() // getter
		{
			return lv && lv.создан();
		}
		
		
		проц verifyNoParent(ColumnHeader header)
		{
			if(header.lview)
				throw new ВизИскл("ColumnHeader already belongs to а ListView");
		}
		
		
		package final проц doListHeaders() // DMD 0.125: this member is not accessible when private.
		in
		{
			assert(создан);
		}
		body
		{
			цел ii;
			foreach(цел i, ColumnHeader header; _headers)
			{
				ii = lv._ins(i, header);
				assert(-1 != ii);
				//assert(i == ii);
			}
		}
		
		
		проц _adding(т_мера idx, ColumnHeader val)
		{
			verifyNoParent(val);
		}
		
		
		проц _added(т_мера idx, ColumnHeader val)
		{
			val.lview = lv;
			
			цел i;
			if(создан)
			{
				i = lv._ins(idx, val);
				assert(-1 != i);
			}
		}
		
		
		проц _removed(т_мера idx, ColumnHeader val)
		{
			if(т_мера.max == idx) // Clear все.
			{
			}
			else
			{
				if(создан)
				{
					lv.prevwproc(LVM_DELETECOLUMN, cast(WPARAM)idx, 0);
				}
			}
		}
		
		
		public:
		
		mixin ListWrapArray!(ColumnHeader, _headers,
			_adding, _added,
			_blankListCallback!(ColumnHeader), _removed,
			да, нет, нет,
			да); // СТЕРЕТЬ_КАЖДЫЙ
	}
	
	
		static class SelectedIndexCollection
	{
		deprecated alias length count;
		
		цел length() // getter
		{
			if(!lview.создан)
				return 0;
			
			цел результат = 0;
			foreach(цел onidx; this)
			{
				результат++;
			}
			return результат;
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
			if(!lview.создан)
				return 0;
			
			цел результат = 0;
			цел idx = -1;
			for(;;)
			{
				idx = cast(цел)lview.prevwproc(LVM_GETNEXTITEM, cast(WPARAM)idx, MAKELPARAM(cast(UINT)LVNI_SELECTED, 0));
				if(-1 == idx) // Done.
					break;
				цел dgidx = idx; // Prevent inout.
				результат = дг(dgidx);
				if(результат)
					break;
			}
			return результат;
		}
		
		mixin OpApplyAddIndex!(opApply, цел);
		
		
		protected this(ListView lv)
		{
			lview = lv;
		}
		
		
		package:
		ListView lview;
	}
	
	
	deprecated alias SelectedItemCollection SelectedListViewItemCollection;
	
		static class SelectedItemCollection
	{
		deprecated alias length count;
		
		цел length() // getter
		{
			if(!lview.создан)
				return 0;
			
			цел результат = 0;
			foreach(ListViewItem onitem; this)
			{
				результат++;
			}
			return результат;
		}
		
		
		ListViewItem opIndex(цел idx)
		{
			foreach(ListViewItem onitem; this)
			{
				if(!idx)
					return onitem;
				idx--;
			}
			
			// If it's not found it's out of границы and bad things happen.
			assert(0);
			return пусто;
		}
		
		
		бул содержит(ListViewItem item)
		{
			return индексУ(item) != -1;
		}
		
		
		цел индексУ(ListViewItem item)
		{
			цел i = 0;
			foreach(ListViewItem onitem; this)
			{
				if(onitem == item) // Not using is.
					return i;
				i++;
			}
			return -1;
		}
		
		
		цел opApply(цел delegate(inout ListViewItem) дг)
		{
			if(!lview.создан)
				return 0;
			
			цел результат = 0;
			цел idx = -1;
			for(;;)
			{
				idx = cast(цел)lview.prevwproc(LVM_GETNEXTITEM, cast(WPARAM)idx, MAKELPARAM(cast(UINT)LVNI_SELECTED, 0));
				if(-1 == idx) // Done.
					break;
				ListViewItem litem = lview.litems._items[idx]; // Prevent inout.
				результат = дг(litem);
				if(результат)
					break;
			}
			return результат;
		}
		
		mixin OpApplyAddIndex!(opApply, ListViewItem);
		
		
		protected this(ListView lv)
		{
			lview = lv;
		}
		
		
		package:
		ListView lview;
	}
	
	
		static class CheckedIndexCollection
	{
		deprecated alias length count;
		
		цел length() // getter
		{
			if(!lview.создан)
				return 0;
			
			цел результат = 0;
			foreach(цел onidx; this)
			{
				результат++;
			}
			return результат;
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
			if(!lview.создан)
				return 0;
			
			цел результат = 0;
			foreach(inout т_мера i, inout ListViewItem lvitem; lview.элты)
			{
				if(lvitem._getcheckstate(i))
				{
					цел dgidx = i; // Prevent inout.
					результат = дг(dgidx);
					if(результат)
						break;
				}
			}
			return результат;
		}
		
		mixin OpApplyAddIndex!(opApply, цел);
		
		
		protected this(ListView lv)
		{
			lview = lv;
		}
		
		
		package:
		ListView lview;
	}
	
	
	this()
	{
		_initListview();
		
		litems = new ListViewItemCollection(this);
		cols = new ColumnHeaderCollection(this);
		selidxcollection = new SelectedIndexCollection(this);
		selobjcollection = new SelectedItemCollection(this);
		checkedis = new CheckedIndexCollection(this);
		
		окСтиль |= WS_TABSTOP | LVS_ALIGNTOP | LVS_AUTOARRANGE | LVS_SHAREIMAGELISTS;
		окДопСтиль |= WS_EX_CLIENTEDGE;
		ктрлСтиль |= ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ;
		окСтильКласса = стильКлассаЛиствью;
	}
	
	
		final проц activation(ПАктивацияПункта ia) // setter
	{
		switch(ia)
		{
			case ПАктивацияПункта.СТАНДАРТ:
				_lvexstyle(LVS_EX_ONECLICKACTIVATE | LVS_EX_TWOCLICKACTIVATE, 0);
				break;
			
			case ПАктивацияПункта.ОДИН_КЛИК:
				_lvexstyle(LVS_EX_ONECLICKACTIVATE | LVS_EX_TWOCLICKACTIVATE, LVS_EX_ONECLICKACTIVATE);
				break;
			
			case ПАктивацияПункта.ДВА_КЛИКА:
				_lvexstyle(LVS_EX_ONECLICKACTIVATE | LVS_EX_TWOCLICKACTIVATE, LVS_EX_TWOCLICKACTIVATE);
				break;
			
			default:
				assert(0);
		}
	}
	
	
	final ПАктивацияПункта activation() // getter
	{
		DWORD lvex;
		lvex = _lvexstyle();
		if(lvex & LVS_EX_ONECLICKACTIVATE)
			return ПАктивацияПункта.ОДИН_КЛИК;
		if(lvex & LVS_EX_TWOCLICKACTIVATE)
			return ПАктивацияПункта.ДВА_КЛИКА;
		return ПАктивацияПункта.СТАНДАРТ;
	}
	
	
	/+
		final проц расположение(ListViewAlignment lva)
	{
		// TODO
		
		switch(lva)
		{
			case ListViewAlignment.ВЕРХ:
				_style((_style() & ~(LVS_ALIGNLEFT | foo)) | LVS_ALIGNTOP);
				break;
			
			default:
				assert(0);
		}
	}
	
	
	final ListViewAlignment расположение() // getter
	{
		// TODO
	}
	+/
	
	
		final проц allowColumnReorder(бул подтвержд) // setter
	{
		_lvexstyle(LVS_EX_HEADERDRAGDROP, подтвержд ? LVS_EX_HEADERDRAGDROP : 0);
	}
	
	
	final бул allowColumnReorder() // getter
	{
		return (_lvexstyle() & LVS_EX_HEADERDRAGDROP) == LVS_EX_HEADERDRAGDROP;
	}
	
	
		final проц autoArrange(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | LVS_AUTOARRANGE);
		else
			_style(_style() & ~LVS_AUTOARRANGE);
		
		//_crecreate(); // ?
	}
	
	
	final бул autoArrange() // getter
	{
		return (_style() & LVS_AUTOARRANGE) == LVS_AUTOARRANGE;
	}
	
	
	override проц цветФона(Цвет ктрл) // setter
	{
		if(создан)
		{
			COLORREF cref;
			if(Цвет.пуст == ктрл)
				cref = CLR_NONE;
			else
				cref = ктрл.вКзс();
			prevwproc(LVM_SETBKCOLOR, 0, cast(LPARAM)cref);
			prevwproc(LVM_SETTEXTBKCOLOR, 0, cast(LPARAM)cref);
		}
		
		super.цветФона = ктрл;
	}
	
	
	override Цвет цветФона() // getter
	{
		if(Цвет.пуст == цвфона)
			return дефЦветФона;
		return цвфона;
	}
	
	
		final проц стильКромки(ПСтильКромки bs) // setter
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
		
		if(создан)
		{
			перерисуйПолностью();
		}
	}
	
	
	final ПСтильКромки стильКромки() // getter
	{
		if(_exStyle() & WS_EX_CLIENTEDGE)
			return ПСтильКромки.ФИКС_3М;
		else if(_style() & WS_BORDER)
			return ПСтильКромки.ФИКС_ЕДИН;
		return ПСтильКромки.НЕУК;
	}
	
	
		final проц checkBoxes(бул подтвержд) // setter
	{
		_lvexstyle(LVS_EX_CHECKBOXES, подтвержд ? LVS_EX_CHECKBOXES : 0);
	}
	
	
	final бул checkBoxes() // getter
	{
		return (_lvexstyle() & LVS_EX_CHECKBOXES) == LVS_EX_CHECKBOXES;
	}
	
	
		// ListView.CheckedIndexCollection
	final CheckedIndexCollection checkedIndices() // getter
	{
		return checkedis;
	}
	
	
	/+
		// ListView.CheckedListViewItemCollection
	final CheckedListViewItemCollection checkedItems() // getter
	{
		// TODO
	}
	+/
	
	
		final ColumnHeaderCollection columns() // getter
	{
		return cols;
	}
	
	
		// Extra.
	final цел focusedIndex() // getter
	{
		if(!создан)
			return -1;
		return cast(цел)prevwproc(LVM_GETNEXTITEM, cast(WPARAM)-1, MAKELPARAM(cast(UINT)LVNI_FOCUSED, 0));
	}
	
	
		final ListViewItem focusedItem() // getter
	{
		цел i;
		i = focusedIndex;
		if(-1 == i)
			return пусто;
		return litems._items[i];
	}
	
	
	override проц цветПП(Цвет ктрл) // setter
	{
		if(создан)
			prevwproc(LVM_SETTEXTCOLOR, 0, cast(LPARAM)ктрл.вКзс());
		
		super.цветПП = ктрл;
	}
	
	
	override Цвет цветПП() // getter
	{
		if(Цвет.пуст == цвпп)
			return дефЦветПП;
		return цвпп;
	}
	
	
		final проц fullRowSelect(бул подтвержд) // setter
	{
		_lvexstyle(LVS_EX_FULLROWSELECT, подтвержд ? LVS_EX_FULLROWSELECT : 0);
	}
	
	
	final бул fullRowSelect() // getter
	{
		return (_lvexstyle() & LVS_EX_FULLROWSELECT) == LVS_EX_FULLROWSELECT;
	}
	
	
		final проц gridLines(бул подтвержд) // setter
	{
		_lvexstyle(LVS_EX_GRIDLINES, подтвержд ? LVS_EX_GRIDLINES : 0);
	}
	
	
	final бул gridLines() // getter
	{
		return (_lvexstyle() & LVS_EX_GRIDLINES) == LVS_EX_GRIDLINES;
	}
	
	
	/+
		final проц headerStyle(СтильЗаголовкаСтолбца chs) // setter
	{
		// TODO: LVS_NOCOLUMNHEADER ... default is clickable.
	}
	
	
	final СтильЗаголовкаСтолбца headerStyle() // getter
	{
		// TODO
	}
	+/
	
	
		final проц скройВыделение(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() & ~LVS_SHOWSELALWAYS);
		else
			_style(_style() | LVS_SHOWSELALWAYS);
	}
	
	
	final бул скройВыделение() // getter
	{
		return (_style() & LVS_SHOWSELALWAYS) != LVS_SHOWSELALWAYS;
	}
	
	
		final проц hoverSelection(бул подтвержд) // setter
	{
		_lvexstyle(LVS_EX_TRACKSELECT, подтвержд ? LVS_EX_TRACKSELECT : 0);
	}
	
	
	final бул hoverSelection() // getter
	{
		return (_lvexstyle() & LVS_EX_TRACKSELECT) == LVS_EX_TRACKSELECT;
	}
	
	
		final ListViewItemCollection элты() // getter
	{
		return litems;
	}
	
	
		// Simple as addRow("item", "sub item1", "sub item2", "etc");
	// rowstrings[0] is the item and rowstrings[1 .. rowstrings.length] are its sub элты.
	//final проц addRow(Ткст[] rowstrings ...)
	final ListViewItem addRow(Ткст[] rowstrings ...)
	{
		if(rowstrings.length)
		{
			ListViewItem item;
			item = new ListViewItem(rowstrings[0]);
			if(rowstrings.length > 1)
				item.subItems.добавьДиапазон(rowstrings[1 .. rowstrings.length]);
			элты.добавь(item);
			return item;
		}
		assert(0);
		return пусто;
	}
	
	
		final проц labelEdit(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | LVS_EDITLABELS);
		else
			_style(_style() & ~LVS_EDITLABELS);
	}
	
	
	final бул labelEdit() // getter
	{
		return (_style() & LVS_EDITLABELS) == LVS_EDITLABELS;
	}
	
	
		final проц labelWrap(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() & ~LVS_NOLABELWRAP);
		else
			_style(_style() | LVS_NOLABELWRAP);
	}
	
	
	final бул labelWrap() // getter
	{
		return (_style() & LVS_NOLABELWRAP) != LVS_NOLABELWRAP;
	}
	
	
		final проц multiSelect(бул подтвержд) // setter
	{
		if(подтвержд)
		{
			_style(_style() & ~LVS_SINGLESEL);
		}
		else
		{
			_style(_style() | LVS_SINGLESEL);
			
			if(selectedItems.length > 1)
				selectedItems[0].selected = да; // Clear все but first selected.
		}
	}
	
	
	final бул multiSelect() // getter
	{
		return (_style() & LVS_SINGLESEL) != LVS_SINGLESEL;
	}
	
	
		// Note: scrollable=нет is not compatible with the list or details(report) styles(views).
	// See Knowledge Основа Article Q137520.
	final проц scrollable(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() & ~LVS_NOSCROLL);
		else
			_style(_style() | LVS_NOSCROLL);
		
		_crecreate();
	}
	
	
	final бул scrollable() // getter
	{
		return (_style() & LVS_NOSCROLL) != LVS_NOSCROLL;
	}
	
	
		final SelectedIndexCollection selectedIndices() // getter
	{
		return selidxcollection;
	}
	
	
		final SelectedItemCollection selectedItems() // getter
	{
		return selobjcollection;
	}
	
	
		final проц view(ПВид v) // setter
	{
		switch(v)
		{
			case ПВид.БОЛЬШАЯ_ПИКТ:
				_style(_style() & ~(LVS_SMALLICON | LVS_LIST | LVS_REPORT));
				break;
			
			case ПВид.МАЛЕНЬКАЯ_ПИКТ:
				_style((_style() & ~(LVS_LIST | LVS_REPORT)) | LVS_SMALLICON);
				break;
			
			case ПВид.СПИСОК:
				_style((_style() & ~(LVS_SMALLICON | LVS_REPORT)) | LVS_LIST);
				break;
			
			case ПВид.ДЕТАЛИ:
				_style((_style() & ~(LVS_SMALLICON | LVS_LIST)) | LVS_REPORT);
				break;
			
			default:
				assert(0);
		}
		
		if(создан)
			перерисуйПолностью();
	}
	
	
	final ПВид view() // getter
	{
		LONG st;
		st = _style();
		if(st & LVS_SMALLICON)
			return ПВид.МАЛЕНЬКАЯ_ПИКТ;
		if(st & LVS_LIST)
			return ПВид.СПИСОК;
		if(st & LVS_REPORT)
			return ПВид.ДЕТАЛИ;
		return ПВид.БОЛЬШАЯ_ПИКТ;
	}
	
	
		final проц sorting(ППорядокСортировки so) // setter
	{
		if(so == _sortorder)
			return;
		
		switch(so)
		{
			case ППорядокСортировки.НЕУК:
				_sortproc = пусто;
				break;
			
			case ППорядокСортировки.ВОЗРАСТАНИЕ:
			case ППорядокСортировки.УМЕНЬШЕНИЕ:
				if(!_sortproc)
					_sortproc = &_defsortproc;
				break;
			
			default:
				assert(0);
		}
		
		_sortorder = so;
		
		sort();
	}
	
	
	final ППорядокСортировки sorting() // getter
	{
		return _sortorder;
	}
	
	
		final проц sort()
	{
		if(ППорядокСортировки.НЕУК != _sortorder)
		{
			assert(_sortproc);
			ListViewItem[] sitems = элты._items;
			if(sitems.length > 1)
			{
				sitems = sitems.dup; // So исключение won't damage anything.
				// Stupid bubble sort. At least it's а "stable sort".
				бул swp;
				auto sortmax = sitems.length - 1;
				т_мера iw;
				do
				{
					swp = нет;
					for(iw = 0; iw != sortmax; iw++)
					{
						//if(sitems[iw] > sitems[iw + 1])
						if(_sortproc(sitems[iw], sitems[iw + 1]) > 0)
						{
							swp = да;
							ListViewItem lvis = sitems[iw];
							sitems[iw] = sitems[iw + 1];
							sitems[iw + 1] = lvis;
						}
					}
				}
				while(swp);
				
				if(создан)
				{
					начниОбновление();
					SendMessageA(указатель, LVM_DELETEALLITEMS, 0, 0); // Note: this sends LVN_DELETEALLITEMS.
					foreach(idx, lvi; sitems)
					{
						_ins(idx, lvi);
					}
					завершиОбновление();
				}
				
				элты._items = sitems;
			}
		}
	}
	
	
		final проц sorter(цел delegate(ListViewItem, ListViewItem) sortproc) // setter
	{
		if(sortproc == this._sortproc)
			return;
		
		if(!sortproc)
		{
			this._sortproc = пусто;
			sorting = ППорядокСортировки.НЕУК;
			return;
		}
		
		this._sortproc = sortproc;
		
		if(ППорядокСортировки.НЕУК == sorting)
			sorting = ППорядокСортировки.ВОЗРАСТАНИЕ;
		sort();
	}
	
	
	final цел delegate(ListViewItem, ListViewItem) sorter() // getter
	{
		return _sortproc;
	}
	
	
	/+
		// Gets the first виден item.
	final ListViewItem topItem() // getter
	{
		if(!создан)
			return пусто;
		// TODO: LVM_GETTOPINDEX
	}
	+/
	
	
		final проц arrangeIcons()
	{
		if(создан)
		//	SendMessageA(уок, LVM_ARRANGE, LVA_DEFAULT, 0);
			prevwproc(LVM_ARRANGE, LVA_DEFAULT, 0);
	}
	
	
	final проц arrangeIcons(ListViewAlignment а)
	{
		if(создан)
		{
			switch(а)
			{
				case ListViewAlignment.ВЕРХ:
					//SendMessageA(уок, LVM_ARRANGE, LVA_ALIGNTOP, 0);
					prevwproc(LVM_ARRANGE, LVA_ALIGNTOP, 0);
					break;
				
				case ListViewAlignment.ПО_УМОЛЧАНИЮ:
					//SendMessageA(уок, LVM_ARRANGE, LVA_DEFAULT, 0);
					prevwproc(LVM_ARRANGE, LVA_DEFAULT, 0);
					break;
				
				case ListViewAlignment.ЛЕВ:
					//SendMessageA(уок, LVM_ARRANGE, LVA_ALIGNLEFT, 0);
					prevwproc(LVM_ARRANGE, LVA_ALIGNLEFT, 0);
					break;
				
				case ListViewAlignment.SNAP_TO_GRID:
					//SendMessageA(уок, LVM_ARRANGE, LVA_SNAPTOGRID, 0);
					prevwproc(LVM_ARRANGE, LVA_SNAPTOGRID, 0);
					break;
				
				default:
					assert(0);
			}
		}
	}
	
	
		final проц начниОбновление()
	{
		SendMessageA(указатель, WM_SETREDRAW, нет, 0);
	}
	
	
	final проц завершиОбновление()
	{
		SendMessageA(указатель, WM_SETREDRAW, да, 0);
		инвалидируй(да); // покажи updates.
	}
	
	
		final проц сотри()
	{
		litems.сотри();
	}
	
	
		final проц ensureVisible(цел индекс)
	{
		// Can only be виден if it's создан. Check if correct implementation.
		создайУпрЭлт();
		
		//if(создан)
		//	SendMessageA(уок, LVM_ENSUREVISIBLE, cast(WPARAM)индекс, FALSE);
			prevwproc(LVM_ENSUREVISIBLE, cast(WPARAM)индекс, FALSE);
	}
	
	
	/+
		// Returns пусто if нет item is at this положение.
	final ListViewItem getItemAt(цел ш, цел в)
	{
		// LVM_FINDITEM LVFI_NEARESTXY ? since it's nearest, need to see if it's really at that положение.
		// TODO
	}
	+/
	
	
		final Прям getItemRect(цел индекс)
	{
		if(создан)
		{
			RECT rect;
			rect.лево = LVIR_BOUNDS;
			if(prevwproc(LVM_GETITEMRECT, cast(WPARAM)индекс, cast(LPARAM)&rect))
				return Прям(&rect);
		}
		return Прям(0, 0, 0, 0);
	}
	
	
	final Прям getItemRect(цел индекс, ПорцияГраницЭлемента ibp)
	{
		if(создан)
		{
			RECT rect;
			switch(ibp)
			{
				case ПорцияГраницЭлемента.ВСЯ:
					rect.лево = LVIR_BOUNDS;
					break;
				
				case ПорцияГраницЭлемента.ПИКТОГРАММА:
					rect.лево = LVIR_ICON;
					break;
				
				case ПорцияГраницЭлемента.ТОЛЬКО_ЭЛТ:
					rect.лево = LVIR_SELECTBOUNDS; // ?
					break;
				
				case ПорцияГраницЭлемента.ЯРЛЫК:
					rect.лево = LVIR_LABEL;
					break;
				
				default:
					assert(0);
			}
			if(prevwproc(LVM_GETITEMRECT, cast(WPARAM)индекс, cast(LPARAM)&rect))
				return Прям(&rect);
		}
		return Прям(0, 0, 0, 0);
	}
	
	
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
				final проц largeImageList(ImageList imglist) // setter
		{
			if(созданУказатель_ли)
			{
				prevwproc(LVM_SETIMAGELIST, LVSIL_NORMAL,
					cast(LPARAM)(imglist ? imglist.указатель : cast(HIMAGELIST)пусто));
			}
			
			_lgimglist = imglist;
		}
		
		
		final ImageList largeImageList() // getter
		{
			return _lgimglist;
		}
		
		
				final проц smallImageList(ImageList imglist) // setter
		{
			if(созданУказатель_ли)
			{
				prevwproc(LVM_SETIMAGELIST, LVSIL_SMALL,
					cast(LPARAM)(imglist ? imglist.указатель : cast(HIMAGELIST)пусто));
			}
			
			_smimglist = imglist;
		}
		
		
		final ImageList smallImageList() // getter
		{
			return _smimglist;
		}
		
		
		/+
				final проц stateImageList(ImageList imglist) // setter
		{
			if(созданУказатель_ли)
			{
				prevwproc(LVM_SETIMAGELIST, LVSIL_STATE,
					cast(LPARAM)(imglist ? imglist.указатель : cast(HIMAGELIST)пусто));
			}
			
			_stimglist = imglist;
		}
		
		
		final ImageList stateImageList() // getter
		{
			return _stimglist;
		}
		+/
	}
	
	
	// TODO:
	//  itemActivate, itemDrag
	//ОбработчикСобытияОтмены selectedIndexChanging; // ?
	
	Событие!(ListView, АргиСобКликаСтолбца) columnClick;
 	Событие!(ListView, LabelEditEventArgs) afterLabelEdit; 
	Событие!(ListView, LabelEditEventArgs) beforeLabelEdit; 
	//Событие!(ListView, ItemCheckEventArgs) itemCheck;
 	Событие!(ListView, ItemCheckedEventArgs) itemChecked; 
	Событие!(ListView, АргиСоб) selectedIndexChanged; 	
	
		protected проц onColumnClick(АргиСобКликаСтолбца ea)
	{
		columnClick(this, ea);
	}
	
	
		protected проц onAfterLabelEdit(LabelEditEventArgs ea)
	{
		afterLabelEdit(this, ea);
	}
	
	
		protected проц onBeforeLabelEdit(LabelEditEventArgs ea)
	{
		beforeLabelEdit(this, ea);
	}
	
	
	/+
	protected проц onItemCheck(ItemCheckEventArgs ea)
	{
		itemCheck(this, ea);
	}
	+/
	
	
		protected проц onItemChecked(ItemCheckedEventArgs ea)
	{
		itemChecked(this, ea);
	}
	
	
		protected проц onSelectedIndexChanged(АргиСоб ea)
	{
		selectedIndexChanged(this, ea);
	}
	
	
	protected override Размер дефРазм() // getter
	{
		return Размер(120, 95);
	}
	
	
	static Цвет дефЦветФона() // getter
	{
		return СистемныеЦвета.окно;
	}
	
	
	static Цвет дефЦветПП() // getter
	{
		return СистемныеЦвета.текстОкна;
	}
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = LISTVIEW_CLASSNAME;
	}
	
	
	protected override проц предшОкПроц(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			case WM_MOUSEHOVER:
				if(!hoverSelection)
					return;
				break;
			
			default: ;
		}
		
		//сооб.результат = CallWindowProcA(первОкПроцЛиствью, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцЛиствью, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	protected override проц окПроц(inout Сообщение m)
	{
		// TODO: support the listview messages.
		
		switch(m.сооб)
		{
			/+
			case WM_PAINT:
				// This seems to be the only way to display columns correctly.
				предшОкПроц(m);
				return;
			+/
			
			case LVM_ARRANGE:
				m.результат = FALSE;
				return;
			
			case LVM_DELETEALLITEMS:
				litems.сотри();
				m.результат = TRUE;
				return;
			
			case LVM_DELETECOLUMN:
				cols.удалиПо(cast(цел)m.парам1);
				m.результат = TRUE;
				return;
			
			case LVM_DELETEITEM:
				litems.удалиПо(cast(цел)m.парам1);
				m.результат = TRUE;
				return;
			
			case LVM_INSERTCOLUMNA:
			case LVM_INSERTCOLUMNW:
				m.результат = -1;
				return;
			
			case LVM_INSERTITEMA:
			case LVM_INSERTITEMW:
				m.результат = -1;
				return;
			
			case LVM_SETBKCOLOR:
				цветФона = Цвет.изКзс(cast(COLORREF)m.парам2);
				m.результат = TRUE;
				return;
			
			case LVM_SETCALLBACKMASK:
				m.результат = FALSE;
				return;
			
			case LVM_SETCOLUMNA:
			case LVM_SETCOLUMNW:
				m.результат = FALSE;
				return;
			
			case LVM_SETCOLUMNWIDTH:
				return;
			
			case LVM_SETIMAGELIST:
				m.результат = cast(LRESULT)пусто;
				return;
			
			case LVM_SETITEMA:
				m.результат = FALSE;
				return;
			
			case LVM_SETITEMSTATE:
				m.результат = FALSE;
				return;
			
			case LVM_SETITEMTEXTA:
			case LVM_SETITEMTEXTW:
				m.результат = FALSE;
				return;
			
			//case LVM_SETTEXTBKCOLOR:
			
			case LVM_SETTEXTCOLOR:
				цветПП = Цвет.изКзс(cast(COLORREF)m.парам2);
				m.результат = TRUE;
				return;
			
			case LVM_SORTITEMS:
				m.результат = FALSE;
				return;
			
			default: ;
		}
		super.окПроц(m);
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		//SendMessageA(уок, LVM_SETEXTENDEDLISTVIEWSTYLE, wlvexstyle, wlvexstyle);
		prevwproc(LVM_SETEXTENDEDLISTVIEWSTYLE, 0, wlvexstyle); // wparam=0 sets все.
		
		Цвет цвет;
		COLORREF cref;
		
		цвет = цветФона;
		if(Цвет.пуст == цвет)
			cref = CLR_NONE;
		else
			cref = цвет.вКзс();
		prevwproc(LVM_SETBKCOLOR, 0, cast(LPARAM)cref);
		prevwproc(LVM_SETTEXTBKCOLOR, 0, cast(LPARAM)cref);
		
		//prevwproc(LVM_SETTEXTCOLOR, 0, цветПП.вКзс()); // DMD 0.125: cast(УпрЭлт )(this).цветПП() is not an lvalue
		цвет = цветПП;
		prevwproc(LVM_SETTEXTCOLOR, 0, cast(LPARAM)цвет.вКзс());
		
		version(VIZ_NO_IMAGELIST)
		{
		}
		else
		{
			if(_lgimglist)
				prevwproc(LVM_SETIMAGELIST, LVSIL_NORMAL, cast(LPARAM)_lgimglist.указатель);
			if(_smimglist)
				prevwproc(LVM_SETIMAGELIST, LVSIL_SMALL, cast(LPARAM)_smimglist.указатель);
			//if(_stimglist)
			//	prevwproc(LVM_SETIMAGELIST, LVSIL_STATE, cast(LPARAM)_stimglist.указатель);
		}
		
		cols.doListHeaders();
		litems.doListItems();
		
		перевычислиПолностью(); // Fix frame.
	}
	
	
	protected override проц поОбратномуСообщению(inout Сообщение m)
	{
		super.поОбратномуСообщению(m);
		
		switch(m.сооб)
		{
			case WM_NOTIFY:
				{
					NMHDR* nmh;
					nmh = cast(NMHDR*)m.парам2;
					switch(nmh.code)
					{
						case LVN_GETDISPINFOA:
							if(viz.x.utf.использоватьЮникод)
								break;
							{
								LV_DISPINFOA* lvdi;
								lvdi = cast(LV_DISPINFOA*)nmh;
								
								// Note: might want to verify it's а valid ListViewItem.
								
								ListViewItem item;
								item = cast(ListViewItem)cast(проц*)lvdi.item.парам2;
								
								if(!lvdi.item.iSubItem) // Item.
								{
									version(VIZ_NO_IMAGELIST)
									{
									}
									else
									{
										if(lvdi.item.mask & LVIF_IMAGE)
											lvdi.item.iImage = item._imgidx;
									}
									
									if(lvdi.item.mask & LVIF_TEXT)
										lvdi.item.pszText = cast(typeof(lvdi.item.pszText))item.calltxt.ansi;
								}
								else // Sub item.
								{
									if(lvdi.item.mask & LVIF_TEXT)
									{
										if(lvdi.item.iSubItem <= item.subItems.length)
											lvdi.item.pszText = cast(typeof(lvdi.item.pszText))item.subItems[lvdi.item.iSubItem - 1].calltxt.ansi;
									}
								}
							}
							break;
						
						case LVN_GETDISPINFOW:
							{
								Ткст текст;
								LV_DISPINFOW* lvdi;
								lvdi = cast(LV_DISPINFOW*)nmh;
								
								// Note: might want to verify it's а valid ListViewItem.
								
								ListViewItem item;
								item = cast(ListViewItem)cast(проц*)lvdi.item.парам2;
								
								if(!lvdi.item.iSubItem) // Item.
								{
									version(VIZ_NO_IMAGELIST)
									{
									}
									else
									{
										if(lvdi.item.mask & LVIF_IMAGE)
											lvdi.item.iImage = item._imgidx;
									}
									
									if(lvdi.item.mask & LVIF_TEXT)
										lvdi.item.pszText = cast(typeof(lvdi.item.pszText))item.calltxt.юникод;
								}
								else // Sub item.
								{
									if(lvdi.item.mask & LVIF_TEXT)
									{
										if(lvdi.item.iSubItem <= item.subItems.length)
											lvdi.item.pszText = cast(typeof(lvdi.item.pszText))item.subItems[lvdi.item.iSubItem - 1].calltxt.юникод;
									}
								}
							}
							break;
						
						/+
						case LVN_ITEMCHANGING:
							{
								auto nmlv = cast(NM_LISTVIEW*)nmh;
								if(-1 != nmlv.iItem)
								{
									UINT stchg = nmlv.uNewState ^ nmlv.uOldState;
									if(stchg & (3 << 12))
									{
										// Note: not tested.
										scope ItemCheckEventArgs ea = new ItemCheckEventArgs(nmlv.iItem,
											(((nmlv.uNewState >> 12) & 3) - 1) ? ПСостУст.УСТАНОВЛЕНО : ПСостУст.НЕУСТ,
											(((nmlv.uOldState >> 12) & 3) - 1) ? ПСостУст.УСТАНОВЛЕНО : ПСостУст.НЕУСТ);
										onItemCheck(ea);
									}
								}
							}
							break;
						+/
						
						case LVN_ITEMCHANGED:
							{
								auto nmlv = cast(NM_LISTVIEW*)nmh;
								if(-1 != nmlv.iItem)
								{
									if(nmlv.uChanged & LVIF_STATE)
									{
										UINT stchg = nmlv.uNewState ^ nmlv.uOldState;
										
										//if(stchg & LVIS_SELECTED)
										{
											// Only fire for the selected one; don't fire twice for old/new.
											if(nmlv.uNewState & LVIS_SELECTED)
											{
												onSelectedIndexChanged(АргиСоб.пуст);
											}
										}
										
										if(stchg & (3 << 12))
										{
											scope ItemCheckedEventArgs ea = new ItemCheckedEventArgs(элты[nmlv.iItem]);
											onItemChecked(ea);
										}
									}
								}
							}
							break;
						
						case LVN_COLUMNCLICK:
							{
								auto nmlv = cast(NM_LISTVIEW*)nmh;
								scope ccea = new АргиСобКликаСтолбца(nmlv.iSubItem);
								onColumnClick(ccea);
							}
							break;
						
						case LVN_BEGINLABELEDITW:
							goto begin_label_edit;
						
						case LVN_BEGINLABELEDITA:
							if(viz.x.utf.использоватьЮникод)
								break;
							begin_label_edit:
							
							{
								LV_DISPINFOA* nmdi;
								nmdi = cast(LV_DISPINFOA*)nmh;
								if(nmdi.item.iSubItem)
								{
									m.результат = TRUE;
									break;
								}
								ListViewItem lvitem;
								lvitem = cast(ListViewItem)cast(проц*)nmdi.item.парам2;
								scope LabelEditEventArgs leea = new LabelEditEventArgs(lvitem);
								onBeforeLabelEdit(leea);
								m.результат = leea.cancelEdit;
							}
							break;
						
						case LVN_ENDLABELEDITW:
							{
								Ткст надпись;
								LV_DISPINFOW* nmdi;
								nmdi = cast(LV_DISPINFOW*)nmh;
								if(nmdi.item.pszText)
								{
									ListViewItem lvitem;
									lvitem = cast(ListViewItem)cast(проц*)nmdi.item.парам2;
									if(nmdi.item.iSubItem)
									{
										m.результат = FALSE;
										break;
									}
									надпись = изЮникода0(nmdi.item.pszText);
									scope LabelEditEventArgs nleea = new LabelEditEventArgs(lvitem, надпись);
									onAfterLabelEdit(nleea);
									if(nleea.cancelEdit)
									{
										m.результат = FALSE;
									}
									else
									{
										// TODO: check if correct implementation.
										// Update the lvitem's cached текст..
										lvitem.setтекстin(надпись);
										
										m.результат = TRUE;
									}
								}
							}
							break;
						
						case LVN_ENDLABELEDITA:
							if(viz.x.utf.использоватьЮникод)
								break;
							{
								Ткст надпись;
								LV_DISPINFOA* nmdi;
								nmdi = cast(LV_DISPINFOA*)nmh;
								if(nmdi.item.pszText)
								{
									ListViewItem lvitem;
									lvitem = cast(ListViewItem)cast(проц*)nmdi.item.парам2;
									if(nmdi.item.iSubItem)
									{
										m.результат = FALSE;
										break;
									}
									надпись = изАнзи0(nmdi.item.pszText);
									scope LabelEditEventArgs nleea = new LabelEditEventArgs(lvitem, надпись);
									onAfterLabelEdit(nleea);
									if(nleea.cancelEdit)
									{
										m.результат = FALSE;
									}
									else
									{
										// TODO: check if correct implementation.
										// Update the lvitem's cached текст..
										lvitem.setтекстin(надпись);
										
										m.результат = TRUE;
									}
								}
							}
							break;
						
						default: ;
					}
				}
				break;
			
			default: ;
		}
	}
	
	
	private:
	DWORD wlvexstyle = 0;
	ListViewItemCollection litems;
	ColumnHeaderCollection cols;
	SelectedIndexCollection selidxcollection;
	SelectedItemCollection selobjcollection;
	ППорядокСортировки _sortorder = ППорядокСортировки.НЕУК;
	CheckedIndexCollection checkedis;
	цел delegate(ListViewItem, ListViewItem) _sortproc;
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
		ImageList _lgimglist, _smimglist;
		//ImageList _stimglist;
	}
	
	
	цел _defsortproc(ListViewItem а, ListViewItem с)
	{
		return а.opCmp(с);
	}
	
	
	DWORD _lvexstyle()
	{
		//if(создан)
		//	wlvexstyle = cast(DWORD)SendMessageA(уок, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0);
		//	wlvexstyle = cast(DWORD)prevwproc(LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0);
		return wlvexstyle;
	}
	
	
	проц _lvexstyle(DWORD флаги)
	{
		DWORD _b4;
		_b4 = wlvexstyle;
		
		wlvexstyle = флаги;
		if(создан)
		{
			// уок, сооб, mask, флаги
			//SendMessageA(уок, LVM_SETEXTENDEDLISTVIEWSTYLE, флаги ^ _b4, wlvexstyle);
			prevwproc(LVM_SETEXTENDEDLISTVIEWSTYLE, флаги ^ _b4, wlvexstyle);
			//перерисуйПолностью(); // Need to recalc the frame ?
		}
	}
	
	
	проц _lvexstyle(DWORD mask, DWORD флаги)
	in
	{
		assert(mask);
	}
	body
	{
		wlvexstyle = (wlvexstyle & ~mask) | (флаги & mask);
		if(создан)
		{
			// уок, сооб, mask, флаги
			//SendMessageA(уок, LVM_SETEXTENDEDLISTVIEWSTYLE, mask, флаги);
			prevwproc(LVM_SETEXTENDEDLISTVIEWSTYLE, mask, флаги);
			//перерисуйПолностью(); // Need to recalc the frame ?
		}
	}
	
	
	// If -subItemIndex- is 0 it's an item not а sub item.
	// Returns the insertion индекс or -1 on failure.
	package final LRESULT _ins(цел индекс, LPARAM lparam, Ткст itemText, цел subItemIndex, цел imageIndex = -1)
	in
	{
		assert(создан);
	}
	body
	{
		/+
		эхо("^ Insert item:  индекс=%d, lparam=0x%X, текст='%.*s', subItemIndex=%d\n",
			индекс, lparam, itemText.length > 20 ? 20 : itemText.length, cast(ткст0)itemText, subItemIndex);
		+/
		
		LV_ITEMA lvi;
		lvi.mask = LVIF_TEXT | LVIF_PARAM;
		version(VIZ_NO_IMAGELIST)
		{
		}
		else
		{
			//if(-1 != imageIndex)
			if(!subItemIndex)
				lvi.mask |= LVIF_IMAGE;
			//lvi.iImage = imageIndex;
			lvi.iImage = I_IMAGECALLBACK;
		}
		lvi.iItem = индекс;
		lvi.iSubItem = subItemIndex;
		//lvi.pszText = toStringz(itemText);
		lvi.pszText = LPSTR_TEXTCALLBACKA;
		lvi.парам2 = lparam;
		return prevwproc(LVM_INSERTITEMA, 0, cast(LPARAM)&lvi);
	}
	
	
	package final LRESULT _ins(цел индекс, ListViewItem item)
	{
		//return _ins(индекс, cast(LPARAM)cast(проц*)item, item.текст, 0);
		version(VIZ_NO_IMAGELIST)
		{
			return _ins(индекс, cast(LPARAM)cast(проц*)item, item.текст, 0, -1);
		}
		else
		{
			return _ins(индекс, cast(LPARAM)cast(проц*)item, item.текст, 0, item._imgidx);
		}
	}
	
	
	package final LRESULT _ins(цел индекс, ListViewSubItem subItem, цел subItemIndex)
	in
	{
		assert(subItemIndex > 0);
	}
	body
	{
		return _ins(индекс, cast(LPARAM)cast(проц*)subItem, subItem.текст, subItemIndex);
	}
	
	
	package final LRESULT _ins(цел индекс, ColumnHeader header)
	{
		// TODO: столбец inserted at индекс 0 can only be лево aligned, so will need to
		// вставь а dummy столбец to change the расположение, then delete the dummy столбец.
		
		//LV_COLUMNA lvc;
		LvColumn lvc;
		lvc.mask = LVCF_FMT | LVCF_SUBITEM | LVCF_TEXT | LVCF_WIDTH;
		switch(header.разместиТекст)
		{
			case ПГоризРасположение.ПРАВ:
				lvc.фмт = LVCFMT_RIGHT;
				break;
			
			case ПГоризРасположение.ЦЕНТР:
				lvc.фмт = LVCFMT_CENTER;
				break;
			
			default:
				lvc.фмт = LVCFMT_LEFT;
		}
		lvc.cx = header.ширина;
		lvc.iSubItem = индекс; // iSubItem is probably only used when retrieving столбец инфо.
		if(viz.x.utf.использоватьЮникод)
		{
			lvc.lvcw.pszText = cast(typeof(lvc.lvcw.pszText))viz.x.utf.вЮни0(header.текст);
			return prevwproc(LVM_INSERTCOLUMNW, cast(WPARAM)индекс, cast(LPARAM)&lvc.lvcw);
		}
		else
		{
			lvc.lvca.pszText = cast(typeof(lvc.lvca.pszText))viz.x.utf.вАнзи0(header.текст);
			return prevwproc(LVM_INSERTCOLUMNA, cast(WPARAM)индекс, cast(LPARAM)&lvc.lvca);
		}
	}
	
	
	// If -subItemIndex- is 0 it's an item not а sub item.
	// Returns FALSE on failure.
	LRESULT updateItem(цел индекс)
	in
	{
		assert(создан);
	}
	body
	{
		return prevwproc(LVM_REDRAWITEMS, cast(WPARAM)индекс, cast(LPARAM)индекс);
	}
	
	LRESULT updateItem(ListViewItem item)
	{
		цел индекс;
		индекс = item.индекс;
		assert(-1 != индекс);
		return updateItem(индекс);
	}
	
	
	LRESULT updateItemText(цел индекс, Ткст newText, цел subItemIndex = 0)
	{
		return updateItem(индекс);
	}
	
	LRESULT updateItemText(ListViewItem item, Ткст newText, цел subItemIndex = 0)
	{
		return updateItem(item);
	}
	
	
	LRESULT updateColumnText(цел colIndex, Ткст newText)
	{
		//LV_COLUMNA lvc;
		LvColumn lvc;
		
		lvc.mask = LVCF_TEXT;
		if(viz.x.utf.использоватьЮникод)
		{
			lvc.lvcw.pszText = cast(typeof(lvc.lvcw.pszText))viz.x.utf.вЮни0(newText);
			return prevwproc(LVM_SETCOLUMNW, cast(WPARAM)colIndex, cast(LPARAM)&lvc.lvcw);
		}
		else
		{
			lvc.lvca.pszText = cast(typeof(lvc.lvca.pszText))viz.x.utf.вАнзи0(newText);
			return prevwproc(LVM_SETCOLUMNA, cast(WPARAM)colIndex, cast(LPARAM)&lvc.lvca);
		}
	}
	
	
	LRESULT updateColumnText(ColumnHeader col, Ткст newText)
	{
		цел colIndex;
		colIndex = columns.индексУ(col);
		assert(-1 != colIndex);
		return updateColumnText(colIndex, newText);
	}
	
	
	LRESULT updateColumnAlign(цел colIndex, ПГоризРасположение halign)
	{
		LV_COLUMNA lvc;
		lvc.mask = LVCF_FMT;
		switch(halign)
		{
			case ПГоризРасположение.ПРАВ:
				lvc.фмт = LVCFMT_RIGHT;
				break;
			
			case ПГоризРасположение.ЦЕНТР:
				lvc.фмт = LVCFMT_CENTER;
				break;
			
			default:
				lvc.фмт = LVCFMT_LEFT;
		}
		return prevwproc(LVM_SETCOLUMNA, cast(WPARAM)colIndex, cast(LPARAM)&lvc);
	}
	
	
	LRESULT updateColumnAlign(ColumnHeader col, ПГоризРасположение halign)
	{
		цел colIndex;
		colIndex = columns.индексУ(col);
		assert(-1 != colIndex);
		return updateColumnAlign(colIndex, halign);
	}
	
	
	LRESULT updateColumnWidth(цел colIndex, цел w)
	{
		LV_COLUMNA lvc;
		lvc.mask = LVCF_WIDTH;
		lvc.cx = w;
		return prevwproc(LVM_SETCOLUMNA, cast(WPARAM)colIndex, cast(LPARAM)&lvc);
	}
	
	
	LRESULT updateColumnWidth(ColumnHeader col, цел w)
	{
		цел colIndex;
		colIndex = columns.индексУ(col);
		assert(-1 != colIndex);
		return updateColumnWidth(colIndex, w);
	}
	
	
	цел getColumnWidth(цел colIndex)
	{
		LV_COLUMNA lvc;
		lvc.mask = LVCF_WIDTH;
		lvc.cx = -1;
		prevwproc(LVM_GETCOLUMNA, cast(WPARAM)colIndex, cast(LPARAM)&lvc);
		return lvc.cx;
	}
	
	
	цел getColumnWidth(ColumnHeader col)
	{
		цел colIndex;
		colIndex = columns.индексУ(col);
		assert(-1 != colIndex);
		return getColumnWidth(colIndex);
	}
	
	
	package:
	final:
	LRESULT prevwproc(UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		//return CallWindowProcA(первОкПроцЛиствью, уок, сооб, wparam, lparam);
		return viz.x.utf.вызовиОкПроц(первОкПроцЛиствью, уок, сооб, wparam, lparam);
	}
}

