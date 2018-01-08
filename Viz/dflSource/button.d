//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.кнопка;

private import viz.base, viz.control, viz.app, viz.x.winapi;
private import viz.event, viz.drawing, viz.x.dlib;


private extern(Windows) проц _initButton();


/*export*/ extern(D) abstract class ОсноваКнопки: СуперКлассУпрЭлта // docmain
{
/*export*/
		проц разместиТекст(ПРасположение calign) // setter
	{
		LONG wl = _bstyle() & ~(BS_BOTTOM | BS_CENTER | BS_TOP | BS_RIGHT | BS_LEFT | BS_VCENTER);
		
		switch(calign)
		{
			case ПРасположение.ВЕРХ_ЛЕВ:
				wl |= BS_TOP | BS_LEFT;
				break;
			
			case ПРасположение.НИЗ_ЦЕНТР:
				wl |= BS_BOTTOM | BS_CENTER;
				break;
			
			case ПРасположение.НИЗ_ЛЕВ:
				wl |= BS_BOTTOM | BS_LEFT;
				break;
			
			case ПРасположение.НИЗ_ПРАВ:
				wl |= BS_BOTTOM | BS_RIGHT;
				break;
			
			case ПРасположение.ЦЕНТР:
				wl |= BS_CENTER | BS_VCENTER;
				break;
			
			case ПРасположение.ЦЕНТР_ЛЕВ:
				wl |= BS_VCENTER | BS_LEFT;
				break;
			
			case ПРасположение.ЦЕНТР_ПРАВ:
				wl |= BS_VCENTER | BS_RIGHT;
				break;
			
			case ПРасположение.ВЕРХ_ЦЕНТР:
				wl |= BS_TOP | BS_CENTER;
				break;
			
			case ПРасположение.ВЕРХ_ПРАВ:
				wl |= BS_TOP | BS_RIGHT;
				break;
				
			default: ;
		}
		
		_bstyle(wl);
		
		_crecreate();
	}
	
	
	ПРасположение разместиТекст() // getter
	{
		LONG wl = _bstyle();
		
		if(wl & BS_VCENTER) // Middle.
		{
			if(wl & BS_CENTER)
				return ПРасположение.ЦЕНТР;
			if(wl & BS_RIGHT)
				return ПРасположение.ЦЕНТР_ПРАВ;
			return ПРасположение.ЦЕНТР_ЛЕВ;
		}
		else if(wl & BS_BOTTOM) // Bottom.
		{
			if(wl & BS_CENTER)
				return ПРасположение.НИЗ_ЦЕНТР;
			if(wl & BS_RIGHT)
				return ПРасположение.НИЗ_ПРАВ;
			return ПРасположение.НИЗ_ЛЕВ;
		}
		else // Top.
		{
			if(wl & BS_CENTER)
				return ПРасположение.ВЕРХ_ЦЕНТР;
			if(wl & BS_RIGHT)
				return ПРасположение.ВЕРХ_ПРАВ;
			return ПРасположение.ВЕРХ_ЛЕВ;
		}
	}
	
	
	// Border stuff...
	
	
	/+
	override проц создайУказатель()
	{
		if(созданУказатель_ли)
			return;
		
		создайУказательНаКласс(BUTTON_CLASSNAME);
		
		поСозданиюУказателя(АргиСоб.пуст);
	}
	+/
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = BUTTON_CLASSNAME;
		if(isdef)
		{
			cp.меню = cast(HMENU)IDOK;
			if(!(cp.стиль & WS_DISABLED))
				cp.стиль |= BS_DEFPUSHBUTTON;
		}
		else if(cp.стиль & WS_DISABLED)
		{
			cp.стиль &= ~BS_DEFPUSHBUTTON;
		}
	}
	
	
	protected override проц предшОкПроц(inout Сообщение сооб)
	{
		//сооб.результат = CallWindowProcA(первОкПроцКнопки, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцКнопки, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	protected override проц поОбратномуСообщению(inout Сообщение m)
	{
		super.поОбратномуСообщению(m);
		
		switch(m.сооб)
		{
			case WM_COMMAND:
				assert(cast(УОК)m.парам2 == указатель);
				
				switch(HIWORD(m.парам1))
				{
					case BN_CLICKED:
						приКлике(АргиСоб.пуст);
						break;
					
					default: ;
				}
				break;
			
			default: ;
		}
	}
	
	
	protected override проц окПроц(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			case WM_LBUTTONDOWN:
				приМышиВнизу(new АргиСобМыши(ПКнопкиМыши.ЛЕВ, 0, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0));
				break;
			
			case WM_LBUTTONUP:
				приМышиВверху(new АргиСобМыши(ПКнопкиМыши.ЛЕВ, 1, cast(short)LOWORD(сооб.парам2), cast(short)HIWORD(сооб.парам2), 0));
				break;
			
			default:
				super.окПроц(сооб);
				return;
		}
		предшОкПроц(сооб);
	}
	
	
	/+
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		/+
		// Done in создайПараметры() now.
		if(isdef)
			SetWindowLongA(указатель, GWL_ID, IDOK);
		+/
	}
	+/
	
	
	this()
	{
		_initButton();
		
		окСтиль |= WS_TABSTOP /+ | BS_NOTIFY +/;
		ктрлСтиль |= ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ;
		окСтильКласса = стильКлассаКнопка;
	}
	
	
	protected:
	
		final проц дефолт_ли(бул подтвержд) // setter
	{
		isdef = подтвержд;
	}
	
	
	final бул дефолт_ли() // getter
	{
		//return (_bstyle() & BS_DEFPUSHBUTTON) == BS_DEFPUSHBUTTON;
		//return GetDlgCtrlID(m.уок) == IDOK;
		return isdef;
	}
	
	
	protected override бул обработайМнемонику(дим кодСим)
	{
		if(выделяемый)
		{
			if(мнемоника_ли(кодСим, текст))
			{
				выдели();
				//Приложение.вершиСобытия(); // ?
				//выполниКлик();
				приКлике(АргиСоб.пуст);
				return да;
			}
		}
		return нет;
	}
	
	
		Размер дефРазм() // getter
	{
		return Размер(75, 23);
	}
	
	
	private:
	бул isdef = нет;
	
	
	package:
	final:
	// Automatically redraws кнопка styles, unlike _style().
	// Don't use with regular окно styles ?
	проц _bstyle(LONG newStyle)
	{
		if(созданУказатель_ли)
			//SendMessageA(указатель, BM_SETSTYLE, LOWORD(newStyle), MAKELPARAM(TRUE, 0));
			SendMessageA(указатель, BM_SETSTYLE, newStyle, MAKELPARAM(TRUE, 0));
		
		окСтиль = newStyle;
		//_style(newStyle);
	}
	
	
	LONG _bstyle()
	{
		return _style();
	}
}


class Кнопка: ОсноваКнопки, ИУпрЭлтКнопка // docmain
{
	this()
	{
	}
	
	
		ПРезДиалога резДиалога() // getter
	{
		return dresult;
	}
	
	
	проц резДиалога(ПРезДиалога dr) // setter
	{
		dresult = dr;
	}
	
	
		// True if default кнопка.
	проц сообщиДеф(бул подтвержд)
	{
		дефолт_ли = подтвержд;
		
		if(подтвержд)
		{
			if(включен) // Only покажи thick border if включен.
				_bstyle(_bstyle() | BS_DEFPUSHBUTTON);
		}
		else
		{
			_bstyle(_bstyle() & ~BS_DEFPUSHBUTTON);
		}
	}
	
	
		проц выполниКлик()
	{
		if(!включен || !виден || !созданУказатель_ли) // ?
			return; // ?
		
		// This is actually not so good because it sets фокус to the упрэлт.
		//SendMessageA(указатель, BM_CLICK, 0, 0); // So that окПроц() gets it.
		
		приКлике(АргиСоб.пуст);
	}
	
	
	protected override проц приКлике(АргиСоб ea)
	{
		super.приКлике(ea);
		
		if(!(Приложение._compat & DflCompat.FORM_DIALOGRESULT_096))
		{
			if(ПРезДиалога.НЕУК != this.резДиалога)
			{
				auto xx = cast(ИРезДиалога)высокоуровневыйУпрЭлт;
				if(xx)
					xx.резДиалога = this.резДиалога;
			}
		}
	}
	
	
	protected override проц окПроц(inout Сообщение m)
	{
		switch(m.сооб)
		{
			case WM_ENABLE:
				{
					// Fixing the thick border of а default кнопка when enabling and disabling it.
					
					// To-do: check if correct implementation.
					
					DWORD bst;
					bst = _bstyle();
					if(bst & BS_DEFPUSHBUTTON)
					{
						//_bstyle(bst); // Force the border to be updated. Only works when enabling.
						if(!m.парам1)
						{
							_bstyle(bst & ~BS_DEFPUSHBUTTON);
						}
					}
					else if(m.парам1)
					{
						//if(GetDlgCtrlID(m.уок) == IDOK)
						if(isdef)
						{
							_bstyle(bst | BS_DEFPUSHBUTTON);
						}
					}
				}
				break;
			
			default: ;
		}
		
		super.окПроц(m);
	}
	
	
	override проц текст(Ткст txt) // setter
	in
	{
		if(txt.length)
			assert(!this.рисунок, "Кнопка рисунок with текст not supported");
	}
	body
	{
		super.текст = txt;
	}
	
	alias УпрЭлт.текст текст; // Overload.
	
	
		final Рисунок рисунок() // getter
	{
		return _img;
	}
	
	
	final проц рисунок(Рисунок img) // setter
	in
	{
		if(img)
			assert(!this.текст.length, "Кнопка рисунок with текст not supported");
	}
	body
	{
		/+
		if(_picbm)
		{
			_picbm.вымести();
			_picbm = пусто;
		}
		+/
		
		_img = пусто; // In case of исключение.
		LONG imgst = 0;
		if(img)
		{
			/+
			if(cast(Битмап)img)
			{
				imgst = BS_BITMAP;
			}
			else if(cast(Пиктограмма)img)
			{
				imgst = BS_ICON;
			}
			else
			{
				if(cast(Картинка)img)
				{
					_picbm = (cast(Картинка)img).вБитмап();
					imgst = BS_BITMAP;
					goto not_unsupported;
				}
				
				throw new ВизИскл("Unsupported рисунок format");
				not_unsupported: ;
			}
			+/
			switch(img._imgtype(пусто))
			{
				case 1:
					imgst = BS_BITMAP;
					break;
				
				case 2:
					imgst = BS_ICON;
					break;
				
				default:
					throw new ВизИскл("Unsupported рисунок format");
					not_unsupported: ;
			}
		}
		
		_img = img;
		_style((_style() & ~(BS_BITMAP | BS_ICON)) | imgst); // Redrawn manually in setImg().
		if(img)
		{
			if(созданУказатель_ли)
				setImg(imgst);
		}
		//_bstyle((_bstyle() & ~(BS_BITMAP | BS_ICON)) | imgst);
	}
	
	
	private проц setImg(LONG bsImageStyle)
	in
	{
		assert(созданУказатель_ли);
	}
	body
	{
		WPARAM wparam = 0;
		LPARAM lparam = 0;
		
		/+
		if(bsImageStyle & BS_BITMAP)
		{
			wparam = IMAGE_BITMAP;
			lparam = cast(LPARAM)(_picbm ? _picbm.указатель : (cast(Битмап)_img).указатель);
		}
		else if(bsImageStyle & BS_ICON)
		{
			wparam = IMAGE_ICON;
			lparam = cast(LPARAM)((cast(Пиктограмма)(_img)).указатель);
		}
		else
		{
			return;
		}
		+/
		if(!_img)
			return;
		HGDIOBJ hgo;
		switch(_img._imgtype(&hgo))
		{
			case 1:
				wparam = IMAGE_BITMAP;
				break;
			
			case 2:
				wparam = IMAGE_ICON;
				break;
			
			default:
				return;
		}
		lparam = cast(LPARAM)hgo;
		
		//assert(lparam);
		SendMessageA(указатель, BM_SETIMAGE, wparam, lparam);
		инвалидируй();
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		setImg(_bstyle());
	}
	
	
	protected override проц поУдалениюУказателя(АргиСоб ea)
	{
		super.поУдалениюУказателя(ea);
		
		/+
		if(_picbm)
		{
			_picbm.вымести();
			_picbm = пусто;
		}
		+/
	}
	
	
	private:
	ПРезДиалога dresult = ПРезДиалога.НЕУК;
	Рисунок _img = пусто;
	//Битмап _picbm = пусто; // If -_img- is а Картинка, need to keep а separate Битмап.
}


class Флажок: ОсноваКнопки // docmain
{
		final проц наружность(ПНаружность ap) // setter
	{
		switch(ap)
		{
			case ПНаружность.НОРМА:
				_bstyle(_bstyle() & ~BS_PUSHLIKE);
				break;
			
			case ПНаружность.КНОПКА:
				_bstyle(_bstyle() | BS_PUSHLIKE);
				break;
			
			default: ;
		}
		
		_crecreate();
	}
	
	
	final ПНаружность наружность() // getter
	{
		if(_bstyle() & BS_PUSHLIKE)
			return ПНаружность.КНОПКА;
		return ПНаружность.НОРМА;
	}
	
	
		final проц автоУстанов(бул подтвержд) // setter
	{
		if(подтвержд)
			_bstyle((_bstyle() & ~BS_CHECKBOX) | BS_AUTOCHECKBOX);
		else
			_bstyle((_bstyle() & ~BS_AUTOCHECKBOX) | BS_CHECKBOX);
		// Enabling/disabling the окно before creation messes
		// up the autocheck стиль флаг, so указатель it manually.
		_autocheck = подтвержд;
	}
	
	
	final бул автоУстанов() // getter
	{
		/+
		return (_bstyle() & BS_AUTOCHECKBOX) == BS_AUTOCHECKBOX;
		+/
		return _autocheck;
	}
	
	
	this()
	{
		окСтиль |= BS_AUTOCHECKBOX | BS_LEFT | BS_VCENTER; // Auto check and ЦЕНТР_ЛЕВ by default.
	}
	
	
	/+
	protected override проц приКлике(АргиСоб ea)
	{
		_updateState();
		
		super.приКлике(ea);
	}
	+/
	
	
		final проц установлен(бул подтвержд) // setter
	{
		if(подтвержд)
			_check = ПСостУст.УСТАНОВЛЕНО;
		else
			_check = ПСостУст.НЕУСТ;
		
		if(созданУказатель_ли)
			SendMessageA(указатель, BM_SETCHECK, cast(WPARAM)_check, 0);
	}
	
	
	// Returns да for indeterminate too.
	final бул установлен() // getter
	{
		if(созданУказатель_ли)
			_updateState();
		return _check != ПСостУст.НЕУСТ;
	}
	
	
		final проц состояние(ПСостУст st) // setter
	{
		_check = st;
		
		if(созданУказатель_ли)
			SendMessageA(указатель, BM_SETCHECK, cast(WPARAM)st, 0);
	}
	
	
	final ПСостУст состояние() // getter
	{
		if(созданУказатель_ли)
			_updateState();
		return _check;
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		if(_autocheck)
			_bstyle((_bstyle() & ~BS_CHECKBOX) | BS_AUTOCHECKBOX);
		else
			_bstyle((_bstyle() & ~BS_AUTOCHECKBOX) | BS_CHECKBOX);
		
		SendMessageA(указатель, BM_SETCHECK, cast(WPARAM)_check, 0);
	}
	
	
	private:
	ПСостУст _check = ПСостУст.НЕУСТ; // Not always accurate.
	бул _autocheck = да;
	
	
	проц _updateState()
	{
		_check = cast(ПСостУст)SendMessageA(указатель, BM_GETCHECK, 0, 0);
	}
}


class РадиоКнопка: ОсноваКнопки // docmain
{
		final проц наружность(ПНаружность ap) // setter
	{
		switch(ap)
		{
			case ПНаружность.НОРМА:
				_bstyle(_bstyle() & ~BS_PUSHLIKE);
				break;
			
			case ПНаружность.КНОПКА:
				_bstyle(_bstyle() | BS_PUSHLIKE);
				break;
			default: ;
		}
		
		_crecreate();
	}
	
	
	final ПНаружность наружность() // getter
	{
		if(_bstyle() & BS_PUSHLIKE)
			return ПНаружность.КНОПКА;
		return ПНаружность.НОРМА;
	}
	
	
		final проц автоУстанов(бул подтвержд) // setter
	{
		/+
		if(подтвержд)
			_bstyle((_bstyle() & ~BS_RADIOBUTTON) | BS_AUTORADIOBUTTON);
		else
			_bstyle((_bstyle() & ~BS_AUTORADIOBUTTON) | BS_RADIOBUTTON);
		// Enabling/disabling the окно before creation messes
		// up the autocheck стиль флаг, so указатель it manually.
		+/
		_autocheck = подтвержд;
	}
	
	
	
	final бул автоУстанов() // getter
	{
		/+ // Also commented out when using BS_AUTORADIOBUTTON.
		return (_bstyle() & BS_AUTOCHECKBOX) == BS_AUTOCHECKBOX;
		+/
		return _autocheck;
	}
	
	
	this()
	{
		окСтиль &= ~WS_TABSTOP;
		//окСтиль |= BS_AUTORADIOBUTTON | BS_LEFT | BS_VCENTER; // ЦЕНТР_ЛЕВ by default.
		окСтиль |= BS_RADIOBUTTON | BS_LEFT | BS_VCENTER; // ЦЕНТР_ЛЕВ by default.
	}
	
	
	protected override проц приКлике(АргиСоб ea)
	{
		if(автоУстанов)
		{
			if(родитель) // Sanity.
			{
				foreach(УпрЭлт упрэлм; родитель.упрэлты)
				{
					if(упрэлм is this)
						continue;
					if((упрэлм._rtype() & (1 | 8)) == (1 | 8)) // Radio кнопка + auto check.
					{
						(cast(РадиоКнопка)упрэлм).установлен = нет;
					}
				}
			}
			установлен = да;
		}
		
		super.приКлике(ea);
	}
	
	
	/+
	protected override проц приКлике(АргиСоб ea)
	{
		_updateState();
		
		super.приКлике(ea);
	}
	+/
	
	
		final проц установлен(бул подтвержд) // setter
	{
		if(подтвержд)
			_check = ПСостУст.УСТАНОВЛЕНО;
		else
			_check = ПСостУст.НЕУСТ;
		
		if(созданУказатель_ли)
			SendMessageA(указатель, BM_SETCHECK, cast(WPARAM)_check, 0);
	}
	
	
	// Returns да for indeterminate too.
	final бул установлен() // getter
	{
		if(созданУказатель_ли)
			_updateState();
		return _check != ПСостУст.НЕУСТ;
	}
	
	
		final проц состояние(ПСостУст st) // setter
	{
		_check = st;
		
		if(созданУказатель_ли)
			SendMessageA(указатель, BM_SETCHECK, cast(WPARAM)st, 0);
	}
	
	
	final ПСостУст состояние() // getter
	{
		if(созданУказатель_ли)
			_updateState();
		return _check;
	}
	
	
		проц выполниКлик()
	{
		//приКлике(АргиСоб.пуст);
		SendMessageA(указатель, BM_CLICK, 0, 0); // So that окПроц() gets it.
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		/+
		if(_autocheck)
			_bstyle((_bstyle() & ~BS_RADIOBUTTON) | BS_AUTORADIOBUTTON);
		else
			_bstyle((_bstyle() & ~BS_AUTORADIOBUTTON) | BS_RADIOBUTTON);
		+/
		
		SendMessageA(указатель, BM_SETCHECK, cast(WPARAM)_check, 0);
	}
	
	
	/+
	protected override проц поОбратномуСообщению(inout Сообщение m)
	{
		super.поОбратномуСообщению(m);
		
		switch(m.сооб)
		{
			/+
			// Without this, with XP styles, the background just ends up прозрачный; not the requested цвет.
			// This erases the текст when XP styles aren't включен.
			case WM_CTLCOLORSTATIC:
			case WM_CTLCOLORBTN:
				{
					//if(hasVisualStyle)
					{
						RECT rect;
						rect.право = ширина;
						rect.низ = высота;
						FillRect(cast(HDC)m.парам1, &rect, hbrBg);
					}
				}
				break;
			+/
			
			default: ;
		}
	}
	+/
	
	
	/+ package +/ /+ protected +/ override цел _rtype() // package
	{
		if(автоУстанов)
			return 1 | 8; // Radio кнопка + auto check.
		return 1; // Radio кнопка.
	}
	
	
	private:
	ПСостУст _check = ПСостУст.НЕУСТ; // Not always accurate.
	бул _autocheck = да;
	
	
	проц _updateState()
	{
		_check = cast(ПСостУст)SendMessageA(указатель, BM_GETCHECK, 0, 0);
	}
}

