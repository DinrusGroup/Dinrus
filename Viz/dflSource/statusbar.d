//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.statusbar;


private import viz.control, viz.base, viz.x.winapi, viz.event,
	viz.collections, viz.x.utf, viz.x.dlib, viz.application;

private import viz.x.dlib;


private extern(Windows) проц _initStatusbar();


/+
enum StatusBarPanelAutoSize: ббайт
{
	НЕУК,
	CONTENTS,
	SPRING,
}
+/


enum StatusBarPanelПСтильКромки: ббайт
{
	НЕУК, 	SUNKEN, 
	RAISED 
}


class StatusBarPanel: Объект
{
		this(Ткст текст)
	{
		this._txt = текст;
	}
	
	
	this(Ткст текст, цел ширина)
	{
		this._txt = текст;
		this._width = ширина;
	}
	
	
	this()
	{
	}
	
	
	Ткст вТкст()
	{
		return _txt;
	}
	
	
	override т_рав opEquals(Объект o)
	{
		return _txt == дайТкстОбъекта(o); // ?
	}
	
	т_рав opEquals(StatusBarPanel pnl)
	{
		return _txt == pnl._txt;
	}
	
	т_рав opEquals(Ткст val)
	{
		return _txt == val;
	}
	
	
	override цел opCmp(Объект o)
	{
		return сравнлюб(_txt, дайТкстОбъекта(o)); // ?
	}
	
	цел opCmp(StatusBarPanel pnl)
	{
		return сравнлюб(_txt, pnl._txt);
	}
	
	цел opCmp(Ткст val)
	{
		return сравнлюб(_txt, val);
	}
	
	
	/+
		final проц расположение(ПГоризРасположение ha) // setter
	{
		
	}
	
	
	final ПГоризРасположение расположение() // getter
	{
		//ЛЕВ
	}
	+/
	
	
	/+
		final проц автоРазмер(StatusBarPanelAutoSize asize) // setter
	{
		
	}
	
	
	final StatusBarPanelAutoSize автоРазмер() // getter
	{
		//НЕУК
	}
	+/
	
	
		final проц стильКромки(StatusBarPanelПСтильКромки bs) // setter
	{
		switch(bs)
		{
			case StatusBarPanelПСтильКромки.НЕУК:
				_utype = (_utype & ~SBT_POPOUT) | SBT_NOBORDERS;
				break;
			
			case StatusBarPanelПСтильКромки.RAISED:
				_utype = (_utype & ~SBT_NOBORDERS) | SBT_POPOUT;
				break;
			
			case StatusBarPanelПСтильКромки.SUNKEN:
				_utype &= ~(SBT_NOBORDERS | SBT_POPOUT);
				break;
			
			default:
				assert(0);
		}
		
		if(_parent && _parent.созданУказатель_ли)
		{
			_parent.panels._fixтекстs(); // Also fixes styles.
		}
	}
	
	
	final StatusBarPanelПСтильКромки стильКромки() // getter
	{
		if(_utype & SBT_POPOUT)
			return StatusBarPanelПСтильКромки.RAISED;
		if(_utype & SBT_NOBORDERS)
			return StatusBarPanelПСтильКромки.НЕУК;
		return StatusBarPanelПСтильКромки.RAISED;
	}
	
	
	// пиктограмма
	
	
	/+
		final проц minWidth(цел mw) // setter
	in
	{
		assert(mw >= 0);
	}
	body
	{
		
	}
	
	
	final цел minWidth() // getter
	{
		//10
	}
	+/
	
	
		final StatusBar родитель() // getter
	{
		return _parent;
	}
	
	
	// стиль
	
	
		final проц текст(Ткст txt) // setter
	{
		if(_parent && _parent.созданУказатель_ли)
		{
			цел idx = _parent.panels.индексУ(this);
			assert(-1 != idx);
			_parent._sendidxтекст(idx, _utype, txt);
		}
		
		this._txt = txt;
	}
	
	
	final Ткст текст() // getter
	{
		return _txt;
	}
	
	
	/+
		final проц toolTipText(Ткст txt) // setter
	{
		
	}
	
	
	final Ткст toolTipText() // getter
	{
		//пусто
	}
	+/
	
	
		final проц ширина(цел w) // setter
	{
		_width = w;
		
		if(_parent && _parent.созданУказатель_ли)
		{
			_parent.panels._fixwidths();
		}
	}
	
	
	final цел ширина() // getter
	{
		return _width;
	}
	
	
	private:
	
	Ткст _txt = пусто;
	цел _width = 100;
	StatusBar _parent = пусто;
	WPARAM _utype = 0; // StatusBarPanelПСтильКромки.SUNKEN.
}


/+
class StatusBarPanelClickEventArgs: АргиСобМыши
{
		this(StatusBarPanel sbpanel, ПКнопкиМыши кноп, цел клики, цел ш, цел в)
	{
		this._sbpanel = sbpanel;
		super(кноп, клики, ш, в, 0);
	}
	
	
	private:
	StatusBarPanel _sbpanel;
}
+/


class StatusBar: СуперКлассУпрЭлта // docmain
{
		class StatusBarPanelCollection
	{
		protected this(StatusBar sb)
		in
		{
			assert(sb.lpanels is пусто);
		}
		body
		{
			this.sb = sb;
		}
		
		
		private:
		
		StatusBar sb;
		package StatusBarPanel[] _panels;
		
		
		package проц _fixwidths()
		{
			assert(созданУказатель_ли);
			
			UINT[20] _pws = void;
			UINT[] pws = _pws;
			if(_panels.length > _pws.length)
				pws = new UINT[_panels.length];
			UINT право = 0;
			foreach(idx, pnl; _panels)
			{
				if(-1 == pnl.ширина)
				{
					pws[idx] = -1;
				}
				else
				{
					право += pnl.ширина;
					pws[idx] = право;
				}
			}
			sb.prevwproc(SB_SETPARTS, cast(WPARAM)_panels.length, cast(LPARAM)pws.ptr);
		}
		
		
		проц _fixтекстs()
		{
			assert(созданУказатель_ли);
			
			if(viz.x.utf.использоватьЮникод)
			{
				foreach(idx, pnl; _panels)
				{
					sb.prevwproc(SB_SETTEXTW, cast(WPARAM)idx | pnl._utype, cast(LPARAM)viz.x.utf.вЮни0(pnl._txt));
				}
			}
			else
			{
				foreach(idx, pnl; _panels)
				{
					sb.prevwproc(SB_SETTEXTA, cast(WPARAM)idx | pnl._utype, cast(LPARAM)viz.x.utf.вАнзи0(pnl._txt));
				}
			}
		}
		
		
		проц _setcurparts()
		{
			assert(созданУказатель_ли);
			
			_fixwidths();
			
			_fixтекстs();
		}
		
		
		проц _removed(т_мера idx, Объект val)
		{
			if(т_мера.max == idx) // Clear все.
			{
				if(sb.созданУказатель_ли)
				{
					sb.prevwproc(SB_SETPARTS, 0, 0); // 0 parts.
				}
			}
			else
			{
				if(sb.созданУказатель_ли)
				{
					_setcurparts();
				}
			}
		}
		
		
		проц _added(т_мера idx, StatusBarPanel val)
		{
			if(val._parent)
				throw new ВизИскл("StatusBarPanel already belongs to а StatusBar");
			
			val._parent = sb;
			
			if(sb.созданУказатель_ли)
			{
				_setcurparts();
			}
		}
		
		
		проц _adding(т_мера idx, StatusBarPanel val)
		{
			if(_panels.length >= 254) // Since SB_SETTEXT with 255 has special meaning.
				throw new ВизИскл("Too many status bar panels");
		}
		
		
		public:
		
		mixin ListWrapArray!(StatusBarPanel, _panels,
			_adding, _added,
			_blankListCallback!(StatusBarPanel), _removed,
			да, /+да+/ нет, нет) _wraparray;
	}
	
	
		this()
	{
		_initStatusbar();
		
		_issimple = да;
		окСтиль |= SBARS_SIZEGRIP;
		окСтильКласса = стильКлассаСтатусбар;
		//высота = ?;
		док = ПДокСтиль.НИЗ;
		
		lpanels = new StatusBarPanelCollection(this);
	}
	
	
	// цветФона / шрифт / цветПП ...
	
	
	override проц док(ПДокСтиль ds) // setter
	{
		switch(ds)
		{
			case ПДокСтиль.НИЗ:
			case ПДокСтиль.ВЕРХ:
				super.док = ds;
				break;
			
			default:
				throw new ВизИскл("Invalid status bar доr");
		}
	}
	
	alias УпрЭлт.док док; // Overload.
	
	
		final StatusBarPanelCollection panels() // getter
	{
		return lpanels;
	}
	
	
		final проц showPanels(бул подтвержд) // setter
	{
		if(!подтвержд == _issimple)
			return;
		
		if(созданУказатель_ли)
		{
			prevwproc(SB_SIMPLE, cast(WPARAM)!подтвержд, 0);
			
			/+ // It's kept in sync even if simple.
			if(подтвержд)
			{
				panels._setcurparts();
			}
			+/
			
			if(!подтвержд)
			{
				_sendidxтекст(255, 0, _simpleтекст);
			}
		}
		
		_issimple = !подтвержд;
	}
	
	
	final бул showPanels() // getter
	{
		return !_issimple;
	}
	
	
		final проц sizingGrip(бул подтвержд) // setter
	{
		if(подтвержд == sizingGrip)
			return;
		
		if(подтвержд)
			_style(_style() | SBARS_SIZEGRIP);
		else
			_style(_style() & ~SBARS_SIZEGRIP);
	}
	
	
	final бул sizingGrip() // getter
	{
		if(окСтиль & SBARS_SIZEGRIP)
			return да;
		return нет;
	}
	
	
	override проц текст(Ткст txt) // setter
	{
		if(созданУказатель_ли && !showPanels)
		{
			_sendidxтекст(255, 0, txt);
		}
		
		this._simpleтекст = txt;
		
		приИзмененииТекста(АргиСоб.пуст);
	}
	
	
	override Ткст текст() // getter
	{
		return this._simpleтекст;
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		if(_issimple)
		{
			prevwproc(SB_SIMPLE, cast(WPARAM)да, 0);
			panels._setcurparts();
			if(_simpleтекст.length)
				_sendidxтекст(255, 0, _simpleтекст);
		}
		else
		{
			panels._setcurparts();
			prevwproc(SB_SIMPLE, cast(WPARAM)нет, 0);
		}
	}
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = STATUSBAR_CLASSNAME;
	}
	
	
	protected override проц предшОкПроц(inout Сообщение сооб)
	{
		//сооб.результат = CallWindowProcA(первОкПроцСтатусбара, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцСтатусбара, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	/+
	protected override проц создайУказатель()
	{
		//CreateStatusWindow
	}
	+/
	
	
	//StatusBarPanelClickEventHandler panelClick;
	//Событие!(StatusBar, StatusBarPanelClickEventArgs) panelClick; 	
	
	protected:
	
	// onDrawItem ...
	
	
	/+
		проц onPanelClick(StatusBarPanelClickEventArgs ea)
	{
		panelClick(this, ea);
	}
	+/
	
	
	private:
	
	StatusBarPanelCollection lpanels;
	Ткст _simpleтекст = пусто;
	бул _issimple = да;
	
	
	package:
	final:
	
	LRESULT prevwproc(UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		//return CallWindowProcA(первОкПроцСтатусбара, уок, сооб, wparam, lparam);
		return viz.x.utf.вызовиОкПроц(первОкПроцСтатусбара, уок, сооб, wparam, lparam);
	}
	
	
	проц _sendidxтекст(цел idx, WPARAM utype, Ткст txt)
	{
		assert(созданУказатель_ли);
		
		if(viz.x.utf.использоватьЮникод)
			prevwproc(SB_SETTEXTW, cast(WPARAM)idx | utype, cast(LPARAM)viz.x.utf.вЮни0(txt));
		else
			prevwproc(SB_SETTEXTA, cast(WPARAM)idx | utype, cast(LPARAM)viz.x.utf.вАнзи0(txt));
	}
}

