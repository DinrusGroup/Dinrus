//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.tabcontrol;

private import viz.x.dlib;

private import viz.control, viz.panel, viz.x.winapi, viz.drawing;
private import viz.application, viz.event, viz.base, viz.collections;


private extern(Windows) проц _initTabcontrol();


class TabPage: Panel
{
		this(Ткст tabText)
	{
		this();
		
		this.текст = tabText;
	}
	
	/+
	
	this(Объект v) // package
	{
		this(дайТкстОбъекта(v));
	}
	+/
	
	
	this()
	{
		Приложение.ppin(cast(проц*)this);
		
		ктрлСтиль |= ПСтилиУпрЭлта.КОНТЕЙНЕР;
		
		окСтиль &= ~WS_VISIBLE;
		cbits &= ~CBits.VISIBLE;
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
	
	
	// imageIndex
	
	
	override проц текст(Ткст newText) // setter
	{
		// Note: this probably causes toStringz() to be called twice,
		// allocating 2 of the same string.
		
		super.текст = newText;
		
		if(создан)
		{
			TabControl tc;
			tc = cast(TabControl)родитель;
			if(tc)
				tc.updateTabText(this, newText);
		}
	}
	
	alias Panel.текст текст; // Overload with Panel.текст.
	
	
	/+
	final проц toolTipText(Ткст ttt) // setter
	{
		// TODO: ...
	}
	
	
	final Ткст toolTipText() // getter
	{
		// TODO: ...
		return пусто;
	}
	+/
	
	
	/+ package +/ /+ protected +/ цел _rtype() // package
	{
		return 4;
	}
	
	
	protected override проц установиЯдроГраниц(цел ш, цел в, цел ширина, цел высота, ПЗаданныеПределы задано)
	{
		assert(0); // Cannot установи границы of TabPage; it is done automatically.
	}
	
	
	package final проц realBounds(Прям к) // setter
	{
		// DMD 0.124: if I don't put this here, super.установиЯдроГраниц ends up calling установиЯдроГраниц instead of super.установиЯдроГраниц.
		проц delegate(цел, цел, цел, цел, ПЗаданныеПределы) _foo = &установиЯдроГраниц;
		
		super.установиЯдроГраниц(к.ш, к.в, к.ширина, к.высота, ПЗаданныеПределы.ВСЕ);
	}
	
	
	protected override проц установиЯдроВидимого(бул подтвержд)
	{
		assert(0); // Cannot установи visibility of TabPage; it is done automatically.
	}
	
	
	package final проц realVisible(бул подтвержд) // setter
	{
		// DMD 0.124: if I don't put this here, super.установиЯдроВидимого ends up calling установиЯдроВидимого instead of super.установиЯдроВидимого.
		проц delegate(бул подтвержд) _foo = &установиЯдроВидимого;
		
		super.установиЯдроВидимого(подтвержд);
	}
}


package union TcItem
{
	TC_ITEMW tciw;
	TC_ITEMA tcia;
	struct
	{
		UINT mask;
		UINT lpReserved1;
		UINT lpReserved2;
		private ук pszText;
		цел cchTextMax;
		цел iImage;
		LPARAM парам2;
	}
}


class TabPageCollection
{
	protected this(TabControl хозяин)
	in
	{
		assert(хозяин.tchildren is пусто);
	}
	body
	{
		tc = хозяин;
	}
	
	
	private:
	
	TabControl tc;
	TabPage[] _pages = пусто;
	
	
	проц doPages()
	in
	{
		assert(создан);
	}
	body
	{
		Прям area;
		area = tc.выведиПрямоугольник;
		
		Сообщение m;
		m.уок = tc.указатель;
		
		// Note: duplicate code.
		//TC_ITEMA tci;
		TcItem tci;
		if(viz.x.utf.использоватьЮникод)
		{
			m.сооб = TCM_INSERTITEMW; // <--
			foreach(цел i, TabPage page; _pages)
			{
				// TODO: TCIF_RTLREADING флаг based on справаНалево property.
				tci.mask = TCIF_TEXT | TCIF_PARAM;
				tci.tciw.pszText = cast(typeof(tci.tciw.pszText))viz.x.utf.вЮни0(page.текст); // <--
				static assert(tci.парам2.sizeof >= (проц*).sizeof);
				tci.парам2 = cast(LPARAM)cast(проц*)page;
				
				m.парам1 = i;
				m.парам2 = cast(LPARAM)&tci.tciw;
				tc.предшОкПроц(m);
				assert(cast(цел)m.результат != -1);
			}
		}
		else
		{
			m.сооб = TCM_INSERTITEMA; // <--
			foreach(цел i, TabPage page; _pages)
			{
				// TODO: TCIF_RTLREADING флаг based on справаНалево property.
				tci.mask = TCIF_TEXT | TCIF_PARAM;
				tci.tcia.pszText = cast(typeof(tci.tcia.pszText))viz.x.utf.вАнзи0(page.текст); // <--
				static assert(tci.парам2.sizeof >= (проц*).sizeof);
				tci.парам2 = cast(LPARAM)cast(проц*)page;
				
				m.парам1 = i;
				m.парам2 = cast(LPARAM)&tci.tcia;
				tc.предшОкПроц(m);
				assert(cast(цел)m.результат != -1);
			}
		}
	}
	
	
	package final бул создан() // getter
	{
		return tc && tc.создан();
	}
	
	
	проц _added(т_мера idx, TabPage val)
	{
		if(val.родитель)
		{
			TabControl tc;
			tc = cast(TabControl)val.родитель;
			if(tc && tc.tabPages.индексУ(val) != -1)
				throw new ВизИскл("TabPage already has а родитель");
		}
		
		//val.realVisible = нет;
		assert(val.виден == нет);
		assert(!(tc is пусто));
		val.родитель = tc;
		
		if(создан)
		{
			Сообщение m;
			//TC_ITEMA tci;
			TcItem tci;
			// TODO: TCIF_RTLREADING флаг based on справаНалево property.
			tci.mask = TCIF_TEXT | TCIF_PARAM;
			static assert(tci.парам2.sizeof >= (проц*).sizeof);
			tci.парам2 = cast(LPARAM)cast(проц*)val;
			if(viz.x.utf.использоватьЮникод)
			{
				tci.tciw.pszText = cast(typeof(tci.tciw.pszText))viz.x.utf.вЮни0(val.текст);
				m = Сообщение(tc.указатель, TCM_INSERTITEMW, idx, cast(LPARAM)&tci.tciw);
			}
			else
			{
				tci.tcia.pszText = cast(typeof(tci.tcia.pszText))viz.x.utf.вАнзи0(val.текст);
				m = Сообщение(tc.указатель, TCM_INSERTITEMA, idx, cast(LPARAM)&tci.tcia);
			}
			tc.предшОкПроц(m);
			assert(cast(цел)m.результат != -1);
			
			if(tc.selectedTab is val)
			{
				//val.realVisible = да;
				tc.tabToFront(val);
			}
		}
	}
	
	
	проц _removed(т_мера idx, TabPage val)
	{
		if(т_мера.max == idx) // Clear все.
		{
			if(создан)
			{
				Сообщение m;
				m = Сообщение(tc.указатель, TCM_DELETEALLITEMS, 0, 0);
				tc.предшОкПроц(m);
			}
		}
		else
		{
			//val.родитель = пусто; // Can't do that.
			
			if(создан)
			{
				Сообщение m;
				m = Сообщение(tc.указатель, TCM_DELETEITEM, idx, 0);
				tc.предшОкПроц(m);
				
				// Hide this one.
				val.realVisible = нет;
				
				// покажи next виден.
				val = tc.selectedTab;
				if(val)
					tc.tabToFront(val);
			}
		}
	}
	
	
	public:
	
	mixin ListWrapArray!(TabPage, _pages,
		_blankListCallback!(TabPage), _added,
		_blankListCallback!(TabPage), _removed,
		да, нет, нет,
		да); // СТЕРЕТЬ_КАЖДЫЙ
}


enum TabAlignment: ббайт
{
	ВЕРХ, 	НИЗ, 
	ЛЕВ, 
	ПРАВ, 
}


enum TabAppearance: ббайт
{
	НОРМА, 	BUTTONS, 
	FLAT_BUTTONS, 
}


enum TabDrawMode: ббайт
{
	НОРМА, 	OWNER_DRAW_FIXED, 
}


class TabControlBase: СуперКлассУпрЭлта
{
	this()
	{
		_initTabcontrol();
		
		окСтиль |= WS_TABSTOP;
		ктрлСтиль |= ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ | ПСтилиУпрЭлта.КОНТЕЙНЕР;
		окСтильКласса = стильКлассаТабконтрол;
	}
	
	
		final проц ПРежимОтрисовки(TabDrawMode dm) // setter
	{
		switch(dm)
		{
			case TabDrawMode.OWNER_DRAW_FIXED:
				_style(окСтиль | TCS_OWNERDRAWFIXED);
				break;
			
			case TabDrawMode.НОРМА:
				_style(окСтиль & ~TCS_OWNERDRAWFIXED);
				break;
			
			default:
				assert(0);
		}
		
		_crecreate();
	}
	
	
	final TabDrawMode ПРежимОтрисовки() // getter
	{
		if(окСтиль & TCS_OWNERDRAWFIXED)
			return TabDrawMode.OWNER_DRAW_FIXED;
		return TabDrawMode.НОРМА;
	}
	
	
	override Прям выведиПрямоугольник() // getter
	{
		if(!создан)
		{
			return super.выведиПрямоугольник(); // Hack?
		}
		else
		{
			RECT drr;
			Сообщение m;
			drr.лево = 0;
			drr.верх = 0;
			drr.право = клиентРазм.ширина;
			drr.низ = клиентРазм.высота;
			m = Сообщение(уок, TCM_ADJUSTRECT, FALSE, cast(LPARAM)&drr);
			предшОкПроц(m);
			return Прям(&drr);
		}
	}
	
	
	protected override Размер дефРазм() // getter
	{
		return Размер(200, 200); // ?
	}
	
	
		final Прям getTabRect(цел i)
	{
		Прям результат;
		
		if(создан)
		{
			RECT rt;
			Сообщение m;
			m = Сообщение(уок, TCM_GETITEMRECT, cast(WPARAM)i, cast(LPARAM)&rt);
			предшОкПроц(m);
			if(!m.результат)
				goto rtfail;
			результат = Прям(&rt);
		}
		else
		{
			rtfail:
			with(результат)
			{
				ш = 0;
				в = 0;
				ширина = 0;
				высота = 0;
			}
		}
		
		return результат;
	}
	
	
	// drawItem событие.
	//СобОбработчик selectedIndexChanged;
	Событие!(TabControlBase, АргиСоб) selectedIndexChanged; 	//ОбработчикСобытияОтмены selectedIndexChanging;
	Событие!(TabControlBase, АргиСобОтмены) selectedIndexChanging; 	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = TABКОНТРОЛ_CLASSNAME;
	}
	
	
		protected проц onSelectedIndexChanged(АргиСоб ea)
	{
		selectedIndexChanged(this, ea);
	}
	
	
		protected проц onSelectedIndexChanging(АргиСобОтмены ea)
	{
		selectedIndexChanging(this, ea);
	}
	
	
	protected override проц предшОкПроц(inout Сообщение сооб)
	{
		//сооб.результат = CallWindowProcA(первОкПроцТабконтрола, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцТабконтрола, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	protected override проц окПроц(inout Сообщение m)
	{
		// TODO: support the tab упрэлт messages.
		
		switch(m.сооб)
		{
			/+
			case WM_SETFOCUS:
				_exStyle(_exStyle() | WS_EX_CONTROLPARENT);
				break;
			
			case WM_KILLFOCUS:
				_exStyle(_exStyle() & ~WS_EX_CONTROLPARENT);
				break;
			+/
			
			case TCM_DELETEALLITEMS:
				m.результат = FALSE;
				return;
			
			case TCM_DELETEITEM:
				m.результат = FALSE;
				return;
			
			case TCM_INSERTITEMA:
			case TCM_INSERTITEMW:
				m.результат = -1;
				return;
			
			//case TCM_REMOVEIMAGE:
			//	return;
			
			//case TCM_SETIMAGELIST:
			//	m.результат = cast(LRESULT)пусто;
			//	return;
			
			case TCM_SETITEMA:
			case TCM_SETITEMW:
				m.результат = FALSE;
				return;
			
			case TCM_SETITEMEXTRA:
				m.результат = FALSE;
				return;
			
			case TCM_SETITEMSIZE:
				m.результат = 0;
				return;
			
			case TCM_SETPADDING:
				return;
			
			case TCM_SETTOOLTIPS:
				return;
			
			default: ;
		}
		
		super.окПроц(m);
	}
	
	
	protected override проц поОбратномуСообщению(inout Сообщение m)
	{
		super.поОбратномуСообщению(m);
		
		TabPage page;
		NMHDR* nmh;
		nmh = cast(NMHDR*)m.парам2;
		
		switch(nmh.code)
		{
			case TCN_SELCHANGE:
				onSelectedIndexChanged(АргиСоб.пуст);
				break;
			
			case TCN_SELCHANGING:
				{
					scope АргиСобОтмены ea = new АргиСобОтмены;
					onSelectedIndexChanging(ea);
					if(ea.отмена)
					{
						m.результат = TRUE; // Prevent change.
						return;
					}
				}
				m.результат = FALSE; // Allow change.
				return;
			
			default: ;
		}
	}
}


class TabControl: TabControlBase // docmain
{
	this()
	{
		tchildren = new TabPageCollection(this);
	}
	
	
		final проц расположение(TabAlignment talign) // setter
	{
		switch(talign)
		{
			case TabAlignment.ВЕРХ:
				_style(окСтиль & ~(TCS_VERTICAL | TCS_RIGHT | TCS_BOTTOM));
				break;
			
			case TabAlignment.НИЗ:
				_style((окСтиль & ~(TCS_VERTICAL | TCS_RIGHT)) | TCS_BOTTOM);
				break;
			
			case TabAlignment.ЛЕВ:
				_style((окСтиль & ~(TCS_BOTTOM | TCS_RIGHT)) | TCS_VERTICAL);
				break;
			
			case TabAlignment.ПРАВ:
				_style((окСтиль & ~TCS_BOTTOM) | TCS_VERTICAL | TCS_RIGHT);
				break;
			
			default:
				assert(0);
		}
		
		// Display rectangle изменено.
		
		if(создан && виден)
		{
			инвалидируй(да); // Update отпрыски too ?
			
			TabPage page;
			page = selectedTab;
			if(page)
				page.realBounds = выведиПрямоугольник;
		}
	}
	
	
	final TabAlignment расположение() // getter
	{
		// Note: TCS_RIGHT and TCS_BOTTOM are the same флаг.
		
		if(окСтиль & TCS_VERTICAL)
		{
			if(окСтиль & TCS_RIGHT)
				return TabAlignment.ПРАВ;
			return TabAlignment.ЛЕВ;
		}
		else
		{
			if(окСтиль & TCS_BOTTOM)
				return TabAlignment.НИЗ;
			return TabAlignment.ВЕРХ;
		}
	}
	
	
		final проц наружность(TabAppearance tappear) // setter
	{
		switch(tappear)
		{
			case TabAppearance.НОРМА:
				_style(окСтиль & ~(TCS_BUTTONS | TCS_FLATBUTTONS));
				break;
			
			case TabAppearance.BUTTONS:
				_style((окСтиль & ~TCS_FLATBUTTONS) | TCS_BUTTONS);
				break;
			
			case TabAppearance.FLAT_BUTTONS:
				_style(окСтиль | TCS_BUTTONS | TCS_FLATBUTTONS);
				break;
			
			default:
				assert(0);
		}
		
		if(создан && виден)
		{
			инвалидируй(нет);
			
			TabPage page;
			page = selectedTab;
			if(page)
				page.realBounds = выведиПрямоугольник;
		}
	}
	
	
	final TabAppearance наружность() // getter
	{
		if(окСтиль & TCS_FLATBUTTONS)
			return TabAppearance.FLAT_BUTTONS;
		if(окСтиль & TCS_BUTTONS)
			return TabAppearance.BUTTONS;
		return TabAppearance.НОРМА;
	}
	
	
		final проц padding(Точка pad) // setter
	{
		if(создан)
		{
			SendMessageA(уок, TCM_SETPADDING, 0, MAKELPARAM(pad.ш, pad.в));
			
			TabPage page;
			page = selectedTab;
			if(page)
				page.realBounds = выведиПрямоугольник;
		}
		
		_pad = pad;
	}
	
	
	final Точка padding() // getter
	{
		return _pad;
	}
	
	
		final TabPageCollection tabPages() // getter
	{
		return tchildren;
	}
	
	
		final проц многострок(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TCS_MULTILINE);
		else
			_style(_style() & ~TCS_MULTILINE);
		
		TabPage page;
		page = selectedTab;
		if(page)
			page.realBounds = выведиПрямоугольник;
	}
	
	
	final бул многострок() // getter
	{
		return (_style() & TCS_MULTILINE) != 0;
	}
	
	
		final цел rowCount() // getter
	{
		if(!создан || !многострок)
			return 0;
		Сообщение m;
		m = Сообщение(уок, TCM_GETROWCOUNT, 0, 0);
		предшОкПроц(m);
		return cast(цел)m.результат;
	}
	
	
		final цел tabCount() // getter
	{
		return tchildren._pages.length;
	}
	
	
		final проц выбранныйИндекс(цел i) // setter
	{
		if(!создан || !tchildren._pages.length)
			return;
		
		TabPage curpage;
		curpage = selectedTab;
		if(curpage is tchildren._pages[i])
			return; // Already selected.
		curpage.realVisible = нет;
		
		SendMessageA(уок, TCM_SETCURSEL, cast(WPARAM)i, 0);
		tabToFront(tchildren._pages[i]);
	}
	
	
	// Returns -1 if there are нет tabs selected.
	final цел выбранныйИндекс() // getter
	{
		if(!создан || !tchildren._pages.length)
			return -1;
		Сообщение m;
		m = Сообщение(уок, TCM_GETCURSEL, 0, 0);
		предшОкПроц(m);
		return cast(цел)m.результат;
	}
	
	
		final проц selectedTab(TabPage page) // setter
	{
		цел i;
		i = tabPages.индексУ(page);
		if(-1 != i)
			выбранныйИндекс = i;
	}
	
	
	final TabPage selectedTab() // getter
	{
		цел i;
		i = выбранныйИндекс;
		if(-1 == i)
			return пусто;
		return tchildren._pages[i];
	}
	
	
	/+
		final проц showToolTips(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | TCS_TOOLTIPS);
		else
			_style(_style() & ~TCS_TOOLTIPS);
	}
	
	
	final бул showToolTips() // getter
	{
		return (_style() & TCS_TOOLTIPS) != 0;
	}
	+/
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		SendMessageA(уок, TCM_SETPADDING, 0, MAKELPARAM(_pad.ш, _pad.в));
		
		tchildren.doPages();
		
		// Bring selected tab to front.
		if(tchildren._pages.length)
		{
			цел i;
			i = выбранныйИндекс;
			if(-1 != i)
				tabToFront(tchildren._pages[i]);
		}
	}
	
	
	protected override проц приРазметке(АргиСобРасположение ea)
	{
		if(tchildren._pages.length)
		{
			цел i;
			i = выбранныйИндекс;
			if(-1 != i)
			{
				tchildren._pages[i].realBounds = выведиПрямоугольник;
				//assert(tchildren._pages[i].границы == выведиПрямоугольник);
			}
		}
		
		//super.приРазметке(ea); // Tab упрэлт shouldn't even have other упрэлты on it.
		super.приРазметке(ea); // Should call it for consistency. Ideally it just checks обработчики.length == 0 and does nothing.
	}
	
	
	/+
	protected override проц окПроц(inout Сообщение m)
	{
		// TODO: support the tab упрэлт messages.
		
		switch(m.сооб)
		{
			/+ // Now обрабатывается in приРазметке().
			case WM_WINDOWPOSCHANGED:
				{
					WINDOWPOS* wp;
					wp = cast(WINDOWPOS*)m.парам2;
					
					if(!(wp.флаги & SWP_NOSIZE) || (wp.флаги & SWP_FRAMECHANGED))
					{
						if(tchildren._pages.length)
						{
							цел i;
							i = выбранныйИндекс;
							if(-1 != i)
							{
								tchildren._pages[i].realBounds = выведиПрямоугольник;
								//assert(tchildren._pages[i].границы == выведиПрямоугольник);
							}
						}
					}
				}
				break;
			+/
			
			default: ;
		}
		
		super.окПроц(m);
	}
	+/
	
	
	protected override проц поОбратномуСообщению(inout Сообщение m)
	{
		TabPage page;
		NMHDR* nmh;
		nmh = cast(NMHDR*)m.парам2;
		
		switch(nmh.code)
		{
			case TCN_SELCHANGE:
				page = selectedTab;
				if(page)
					tabToFront(page);
				super.поОбратномуСообщению(m);
				break;
			
			case TCN_SELCHANGING:
				super.поОбратномуСообщению(m);
				if(!m.результат) // Allowed.
				{
					page = selectedTab;
					if(page)
						page.realVisible = нет;
				}
				return;
			
			default:
				super.поОбратномуСообщению(m);
		}
	}
	
	
	/+
	/+ package +/ /+ protected +/ override цел _rtype() // package
	{
		return 0x20;
	}
	+/
	
	
	private:
	Точка _pad = {ш: 6, в: 3};
	TabPageCollection tchildren;
	
	
	проц tabToFront(TabPage page)
	{
		page.realBounds = выведиПрямоугольник;
		//page.realVisible = да;
		SetWindowPos(page.указатель, HWND_TOP, 0, 0, 0, 0, /+ SWP_NOACTIVATE | +/ SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW);
		assert(page.виден == да);
		
		/+
		// Make sure the previous tab isn't still вФокусе.
		// Will "steal" фокус if done programatically.
		SetFocus(указатель);
		//SetFocus(page.указатель);
		+/
	}
	
	
	проц updateTabText(TabPage page, Ткст newText)
	in
	{
		assert(создан);
	}
	body
	{
		цел i;
		i = tabPages.индексУ(page);
		assert(-1 != i);
		
		//TC_ITEMA tci;
		TcItem tci;
		tci.mask = TCIF_TEXT;
		Сообщение m;
		if(viz.x.utf.использоватьЮникод)
		{
			tci.tciw.pszText = cast(typeof(tci.tciw.pszText))viz.x.utf.вЮни0(newText);
			m = Сообщение(уок, TCM_SETITEMW, cast(WPARAM)i, cast(LPARAM)&tci.tciw);
		}
		else
		{
			tci.tcia.pszText = cast(typeof(tci.tcia.pszText))viz.x.utf.вАнзи0(newText);
			m = Сообщение(уок, TCM_SETITEMA, cast(WPARAM)i, cast(LPARAM)&tci.tcia);
		}
		предшОкПроц(m);
		
		// Updating а tab's текст could cause tab rows to be adjusted,
		// so обнови the selected tab's area.
		page = selectedTab;
		if(page)
			page.realBounds = выведиПрямоугольник;
	}
}

