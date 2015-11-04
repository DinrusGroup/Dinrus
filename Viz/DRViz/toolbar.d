module viz.toolbar;

private import viz.base, viz.control, viz.drawing, viz.application,
	viz.event, viz.collections;
private import viz.x.winapi, viz.x.dlib;

version(VIZ_NO_IMAGELIST)
{
}
else
{
	private import viz.imagelist;
}

version(ВИЗ_БЕЗ_МЕНЮ)
	version = VIZ_TOOLBAR_NO_MENU;

version(VIZ_TOOLBAR_NO_MENU)
{
}
else
{
	private import viz.menu;
}


enum ToolBarButtonStyle: ббайт
{
	PUSH_BUTTON = TBSTYLE_BUTTON, 	TOGGLE_BUTTON = TBSTYLE_CHECK, 
	SEPARATOR = TBSTYLE_SEP, 
	//DROP_DOWN_BUTTON = TBSTYLE_DROPDOWN, 
	DROP_DOWN_BUTTON = TBSTYLE_DROPDOWN | BTNS_WHOLEDROPDOWN, 
}


class ToolBarButton
{
		this()
	{
		Приложение.ppin(cast(проц*)this);
	}
	
		this(Ткст текст)
	{
		this();
		
		this.текст = текст;
	}
	
	
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
				final проц imageIndex(цел индекс) // setter
		{
			this._imgidx = индекс;
			
			//if(tbar && tbar.создан)
			//	tbar.updateItem(this);
		}
		
		
		final цел imageIndex() // getter
		{
			return _imgidx;
		}
	}
	
	
		проц текст(Ткст newText) // setter
	{
		_текст = newText;
		
		//if(tbar && tbar.создан)
		//	
	}
	
	
	Ткст текст() // getter
	{
		return _текст;
	}
	
	
		final проц стиль(ToolBarButtonStyle st) // setter
	{
		this._style = st;
		
		//if(tbar && tbar.создан)
		//	
	}
	
	
	final ToolBarButtonStyle стиль() // getter
	{
		return _style;
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
	
	
		final проц тэг(Объект o) // setter
	{
		_tag = o;
	}
	
	
	final Объект тэг() // getter
	{
		return _tag;
	}
	
	
	version(VIZ_TOOLBAR_NO_MENU)
	{
	}
	else
	{
				final проц dropDownMenu(КонтекстноеМеню cmenu) // setter
		{
			_cmenu = cmenu;
		}
		
		
		final КонтекстноеМеню dropDownMenu() // getter
		{
			return _cmenu;
		}
	}
	
	
		final ToolBar родитель() // getter
	{
		return tbar;
	}
	
	
		final Прям rectangle() // getter
	{
		//if(!tbar || !tbar.создан)
		if(!виден)
			return Прям(0, 0, 0, 0); // ?
		assert(tbar !is пусто);
		RECT rect;
		//assert(-1 != tbar.buttons.индексУ(this));
		tbar.prevwproc(TB_GETITEMRECT, tbar.buttons.индексУ(this), cast(LPARAM)&rect); // Fails if item is hidden.
		return Прям(&rect); // Should return все 0`s if TB_GETITEMRECT failed.
	}
	
	
		final проц виден(бул подтвержд) // setter
	{
		if(подтвержд)
			_state &= ~TBSTATE_HIDDEN;
		else
			_state |= TBSTATE_HIDDEN;
		
		if(tbar && tbar.создан)
			tbar.prevwproc(TB_SETSTATE, _id, MAKELPARAM(_state, 0));
	}
	
	
	final бул виден() // getter
	{
		if(!tbar || !tbar.создан)
			return нет;
		return да; // To-do: get actual hidden состояние.
	}
	
	
		final проц включен(бул подтвержд) // setter
	{
		if(подтвержд)
			_state |= TBSTATE_ENABLED;
		else
			_state &= ~TBSTATE_ENABLED;
		
		if(tbar && tbar.создан)
			tbar.prevwproc(TB_SETSTATE, _id, MAKELPARAM(_state, 0));
	}
	
	
	final бул включен() // getter
	{
		if(_state & TBSTATE_ENABLED)
			return да;
		return нет;
	}
	
	
		final проц pushed(бул подтвержд) // setter
	{
		if(подтвержд)
			_state = (_state & ~TBSTATE_INDETERMINATE) | TBSTATE_CHECKED;
		else
			_state &= ~TBSTATE_CHECKED;
		
		if(tbar && tbar.создан)
			tbar.prevwproc(TB_SETSTATE, _id, MAKELPARAM(_state, 0));
	}
	
	
	final бул pushed() // getter
	{
		if(TBSTATE_CHECKED == (_state & TBSTATE_CHECKED))
			return да;
		return нет;
	}
	
	
		final проц partialPush(бул подтвержд) // setter
	{
		if(подтвержд)
			_state = (_state & ~TBSTATE_CHECKED) | TBSTATE_INDETERMINATE;
		else
			_state &= ~TBSTATE_INDETERMINATE;
		
		if(tbar && tbar.создан)
			tbar.prevwproc(TB_SETSTATE, _id, MAKELPARAM(_state, 0));
	}
	
	
	final бул partialPush() // getter
	{
		if(TBSTATE_INDETERMINATE == (_state & TBSTATE_INDETERMINATE))
			return да;
		return нет;
	}
	
	
	private:
	ToolBar tbar;
	цел _id = 0;
	Ткст _текст;
	Объект _tag;
	ToolBarButtonStyle _style = ToolBarButtonStyle.PUSH_BUTTON;
	BYTE _state = TBSTATE_ENABLED;
	version(VIZ_TOOLBAR_NO_MENU)
	{
	}
	else
	{
		КонтекстноеМеню _cmenu;
	}
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
		цел _imgidx = -1;
	}
}


class ToolBarButtonClickEventArgs: АргиСоб
{
	this(ToolBarButton tbbtn)
	{
		_btn = tbbtn;
	}
	
	
		final ToolBarButton кнопка() // getter
	{
		return _btn;
	}
	
	
	private:
	
	ToolBarButton _btn;
}


class ToolBar: СуперКлассУпрЭлта // docmain
{
	class ToolBarButtonCollection
	{
		protected this()
		{
		}
		
		
		private:
		
		ToolBarButton[] _buttons;
		
		
		проц _adding(т_мера idx, ToolBarButton val)
		{
			if(val.tbar)
				throw new ВизИскл("ToolBarButton already belongs to а ToolBar");
		}
		
		
		проц _added(т_мера idx, ToolBarButton val)
		{
			val.tbar = tbar;
			val._id = tbar._allocTbbID();
			
			if(создан)
			{
				_ins(idx, val);
			}
		}
		
		
		проц _removed(т_мера idx, ToolBarButton val)
		{
			if(т_мера.max == idx) // Clear все.
			{
			}
			else
			{
				if(создан)
				{
					prevwproc(TB_DELETEBUTTON, idx, 0);
				}
				val.tbar = пусто;
			}
		}
		
		
		public:
		
		mixin ListWrapArray!(ToolBarButton, _buttons,
			_adding, _added,
			_blankListCallback!(ToolBarButton), _removed,
			да, нет, нет,
			да); // СТЕРЕТЬ_КАЖДЫЙ
	}
	
	
	private ToolBar tbar()
	{
		return this;
	}
	
	
	this()
	{
		_initToolbar();
		
		_tbuttons = new ToolBarButtonCollection();
		
		док = ПДокСтиль.ВЕРХ;
		
		//окДопСтиль |= WS_EX_CLIENTEDGE;
		окСтильКласса = toolbarClassStyle;
	}
	
	
		final ToolBarButtonCollection buttons() // getter
	{
		return _tbuttons;
	}
	
	
	// buttonSize...
	
	
		final Размер imageSize() // getter
	{
		version(VIZ_NO_IMAGELIST)
		{
		}
		else
		{
			if(_imglist)
				return _imglist.imageSize;
		}
		return Размер(16, 16); // ?
	}
	
	
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
				final проц imageList(ImageList imglist) // setter
		{
			if(созданУказатель_ли)
			{
				prevwproc(TB_SETIMAGELIST, 0, cast(WPARAM)imglist.указатель);
			}
			
			_imglist = imglist;
		}
		
		
		final ImageList imageList() // getter
		{
			return _imglist;
		}
	}
	
	
		Событие!(ToolBar, ToolBarButtonClickEventArgs) buttonClick;
	
	
		protected проц onButtonClick(ToolBarButtonClickEventArgs ea)
	{
		buttonClick(this, ea);
	}
	
	
	protected override проц поОбратномуСообщению(inout Сообщение m)
	{
		switch(m.сооб)
		{
			case WM_NOTIFY:
				{
					auto nmh = cast(LPNMHDR)m.парам2;
					switch(nmh.code)
					{
						case NM_CLICK:
							{
								auto nmm = cast(LPNMMOUSE)nmh;
								if(nmm.dwItemData)
								{
									auto tbb = cast(ToolBarButton)cast(проц*)nmm.dwItemData;
									scope ToolBarButtonClickEventArgs bcea = new ToolBarButtonClickEventArgs(tbb);
									onButtonClick(bcea);
								}
							}
							break;
						
						case TBN_DROPDOWN:
							version(VIZ_TOOLBAR_NO_MENU) // This condition might be removed later.
							{
							}
							else // Ditto.
							{
								auto nmtb = cast(LPNMTOOLBARA)nmh; // NMTOOLBARA/NMTOOLBARW doesn't matter here; string fields not used.
								auto tbb = buttomFromID(nmtb.iItem);
								if(tbb)
								{
									version(VIZ_TOOLBAR_NO_MENU) // Keep this here in case the other condition is removed.
									{
									}
									else // Ditto.
									{
										if(tbb._cmenu)
										{
											auto brect = tbb.rectangle;
											tbb._cmenu.покажи(this, точкаКЭкрану(Точка(brect.ш, brect.низ)));
											// Note: showing а меню also triggers а клик!
										}
									}
								}
							}
							return;// 0; //TBDDRET_DEFAULT;
						
						default: ;
					}
				}
				break;
			
			default: ;
				super.поОбратномуСообщению(m);
		}
	}
	
	
	protected override Размер дефРазм() // getter
	{
		return Размер(100, 16);
	}
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = TOOLBAR_CLASSNAME;
	}
	
	
	
	// Used internally
	/+package+/ final ToolBarButton buttomFromID(цел id) // package
	{
		foreach(tbb; _tbuttons._buttons)
		{
			if(id == tbb._id)
				return tbb;
		}
		return пусто;
	}
	
	
	package цел _lastTbbID = 0;
	
	package final цел _allocTbbID()
	{
		for(цел j = 0; j != 250; j++)
		{
			_lastTbbID++;
			if(_lastTbbID >= short.max)
				_lastTbbID = 1;
			
			if(!buttomFromID(_lastTbbID))
				return _lastTbbID;
		}
		return 0;
	}
	
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		static assert(TBBUTTON.sizeof == 20);
		prevwproc(TB_BUTTONSTRUCTSIZE, TBBUTTON.sizeof, 0);
		
		//prevwproc(TB_SETPADDING, 0, MAKELPARAM(0, 0));
		
		version(VIZ_NO_IMAGELIST)
		{
		}
		else
		{
			if(_imglist)
				prevwproc(TB_SETIMAGELIST, 0, cast(WPARAM)_imglist.указатель);
		}
		
		foreach(idx, tbb; _tbuttons._buttons)
		{
			_ins(idx, tbb);
		}
		
		//prevwproc(TB_AUTOSIZE, 0, 0);
	}
	
	
	protected override проц предшОкПроц(inout Сообщение сооб)
	{
		//сооб.результат = CallWindowProcA(toolbarPrevWndProc, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(toolbarPrevWndProc, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	private:
	
	ToolBarButtonCollection _tbuttons;
	
	version(VIZ_NO_IMAGELIST)
	{
	}
	else
	{
		ImageList _imglist;
	}
	
	
	проц _ins(т_мера idx, ToolBarButton tbb)
	{
		// To change: TB_SETBUTTONINFO
		
		TBBUTTON xtb;
		version(VIZ_NO_IMAGELIST)
		{
			xtb.iBitmap = -1;
		}
		else
		{
			xtb.iBitmap = tbb._imgidx;
		}
		xtb.idCommand = tbb._id;
		xtb.dwData = cast(DWORD)cast(проц*)tbb;
		xtb.fsState = tbb._state;
		xtb.fsStyle = TBSTYLE_AUTOSIZE | tbb._style; // TBSTYLE_AUTOSIZE factors in the текст's ширина instead of default кнопка размер.
		LRESULT lresult;
		// MSDN says iString can be either an цел смещение or pointer to а string buffer.
		if(viz.x.utf.использоватьЮникод)
		{
			if(tbb._текст.length)
				xtb.iString = cast(typeof(xtb.iString))viz.x.utf.вЮни0(tbb._текст);
			//prevwproc(TB_ADDBUTTONSW, 1, cast(LPARAM)&xtb);
			lresult = prevwproc(TB_INSERTBUTTONW, idx, cast(LPARAM)&xtb);
		}
		else
		{
			if(tbb._текст.length)
				xtb.iString = cast(typeof(xtb.iString))viz.x.utf.вАнзи0(tbb._текст);
			//prevwproc(TB_ADDBUTTONSA, 1, cast(LPARAM)&xtb);
			lresult = prevwproc(TB_INSERTBUTTONA, idx, cast(LPARAM)&xtb);
		}
		//if(!lresult)
		//	throw new ВизИскл("Unable to добавь ToolBarButton");
	}
	
	
	package:
	final:
	LRESULT prevwproc(UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		//return CallWindowProcA(toolbarPrevWndProc, уок, сооб, wparam, lparam);
		return viz.x.utf.вызовиОкПроц(toolbarPrevWndProc, уок, сооб, wparam, lparam);
	}
}


private
{
	const Ткст TOOLBAR_CLASSNAME = "VIZ_ToolBar";
	
	WNDPROC toolbarPrevWndProc;
	
	LONG toolbarClassStyle;
	
	проц _initToolbar()
	{
		if(!toolbarPrevWndProc)
		{
			_initCommonControls(ICC_BAR_CLASSES);
			
			viz.x.utf.КлассОкна инфо;
			toolbarPrevWndProc = суперКласс(экз.init, "ToolbarWindow32", TOOLBAR_CLASSNAME, инфо);
			if(!toolbarPrevWndProc)
				_unableToInit(TOOLBAR_CLASSNAME);
			toolbarClassStyle = инфо.ко.стиль;
		}
	}
}

