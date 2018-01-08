//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.textbox;
private import viz.control, viz.common, viz.app;

version(ВИЗ_БЕЗ_МЕНЮ)
{
}
else
{
	private import viz.menu;
}


private extern(Windows) проц _initTextBox();


// Note: ПСтилиУпрЭлта.CACHE_TEXT might not work correctly with а текст box.
// It's not actually а bug, but а limitation of this упрэлт.

/*export*/ abstract class ОсноваТекстБокса: СуперКлассУпрЭлта // docmain
{
/*export*/
		final проц acceptsTab(бул подтвержд) // setter
	{
		atab = подтвержд;
		установиСтиль(ПСтилиУпрЭлта.WANT_TAB_KEY, atab);
	}
	
	
	final бул acceptsTab() // getter
	{
		return atab;
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
		
		if(создан)
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
	
	
		final бул можноОтменить() // getter
	{
		if(!создан)
			return нет;
		return SendMessageA(указатель, EM_CANUNDO, 0, 0) != 0;
	}
	
	
		final проц скройВыделение(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() & ~ES_NOHIDESEL);
		else
			_style(_style() | ES_NOHIDESEL);
	}
	
	
	final бул скройВыделение() // getter
	{
		return (_style() & ES_NOHIDESEL) == 0;
	}
	
	
		final проц строки(Ткст[] lns) // setter
	{
		Ткст результат;
		foreach(Ткст s; lns)
		{
			результат ~= s ~ \r\n;
		}
		if(результат.length) // Remove last \r\n.
			результат = результат[0 .. результат.length - 2];
		текст = результат;
	}
	
	
	final Ткст[] строки() // getter
	{
		return разбейнастр(текст);
	}
	
	
		проц максДлина(бцел len) // setter
	{
		if(!len)
		{
			if(многострок)
				lim = 0xFFFFFFFF;
			else
				lim = 0x7FFFFFFE;
		}
		else
		{
			lim = len;
		}
		
		if(создан)
		{
			Сообщение m;
			m = Сообщение(указатель, EM_SETLIMITTEXT, cast(WPARAM)lim, 0);
			предшОкПроц(m);
		}
	}
	
	
	бцел максДлина() // getter
	{
		if(создан)
			lim = cast(бцел)SendMessageA(указатель, EM_GETLIMITTEXT, 0, 0);
		return lim;
	}
	
	
		final бцел дайЧлоСтрок()
	{
		if(!многострок)
			return 1;
		
		if(создан)
		{
			return cast(бцел)SendMessageA(указатель, EM_GETLINECOUNT, 0, 0);
		}
		
		Ткст s;
		т_мера iw = 0;
		бцел count = 1;
		s = текст;
		for(; iw != s.length; iw++)
		{
			if('\r' == s[iw])
			{
				if(iw + 1 == s.length)
					break;
				if('\n' == s[iw + 1])
				{
					iw++;
					count++;
				}
			}
		}
		return count;
	}
	
	
		final проц изменён(бул подтвержд) // setter
	{
		if(создан)
			SendMessageA(указатель, EM_SETMODIFY, подтвержд, 0);
	}
	
	
	final бул изменён() // getter
	{
		if(!создан)
			return нет;
		return SendMessageA(указатель, EM_GETMODIFY, 0, 0) != 0;
	}
	
	
		проц многострок(бул подтвержд) // setter
	{
		/+
		if(подтвержд)
			_style(_style() & ~ES_AUTOHSCROLL | ES_MULTILINE);
		else
			_style(_style() & ~ES_MULTILINE | ES_AUTOHSCROLL);
		+/
		
		// TODO: check if correct implementation.
		
		LONG st;
		
		if(подтвержд)
		{
			st = _style() | ES_MULTILINE | ES_AUTOVSCROLL;
			
			if(_wrap)
				st &= ~ES_AUTOHSCROLL;
			else
				st |= ES_AUTOHSCROLL;
		}
		else
		{
			st = _style() & ~(ES_MULTILINE | ES_AUTOVSCROLL);
			
			// Always H-scroll when single line.
			st |= ES_AUTOHSCROLL;
		}
		
		_style(st);
		
		_crecreate();
	}
	
	
	бул многострок() // getter
	{
		return (_style() & ES_MULTILINE) != 0;
	}
	
	
		final проц толькоЧтение(бул подтвержд) // setter
	{
		if(создан)
		{
			SendMessageA(указатель, EM_SETREADONLY, подтвержд, 0); // Should trigger WM_STYLECHANGED.
			инвалидируй(); // ?
		}
		else
		{
			if(подтвержд)
				_style(_style() | ES_READONLY);
			else
				_style(_style() & ~ES_READONLY);
		}
	}
	
	
	final бул толькоЧтение() // getter
	{
		return (_style() & ES_READONLY) != 0;
	}
	
	
		проц выделенныйТекст(Ткст sel) // setter
	{
		/+
		if(создан)
			SendMessageA(указатель, EM_REPLACESEL, FALSE, cast(LPARAM)небезопТкст0(sel));
		+/
		
		if(создан)
		{
			//шлиСооб(указатель, EM_REPLACESEL, FALSE, sel);
			шлиСообНебезоп(указатель, EM_REPLACESEL, FALSE, sel);
		}
	}
	
	
	Ткст выделенныйТекст() // getter
	{
		/+
		if(создан)
		{
			бцел v1, v2;
			SendMessageA(указатель, EM_GETSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
			if(v1 == v2)
				return пусто;
			assert(v2 > v1);
			Ткст результат = new сим[v2 - v1 + 1];
			результат[результат.length - 1] = 0;
			результат = результат[0 .. результат.length - 1];
			результат[] = текст[v1 .. v2];
			return результат;
		}
		return пусто;
		+/
		
		if(создан)
			return дайВыделенныйТекст(указатель);
		return пусто;
	}
	
	
		проц длинаВыделения(бцел len) // setter
	{
		if(создан)
		{
			бцел v1, v2;
			SendMessageA(указатель, EM_GETSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
			v2 = v1 + len;
			SendMessageA(указатель, EM_SETSEL, v1, v2);
		}
	}
	
	
	// Current selection length, in characters.
	// This does not necessarily correspond to the length of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	бцел длинаВыделения() // getter
	{
		if(создан)
		{
			бцел v1, v2;
			SendMessageA(указатель, EM_GETSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
			assert(v2 >= v1);
			return v2 - v1;
		}
		return 0;
	}
	
	
		проц началоВыделения(бцел поз) // setter
	{
		if(создан)
		{
			бцел v1, v2;
			SendMessageA(указатель, EM_GETSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
			assert(v2 >= v1);
			v2 = поз + (v2 - v1);
			SendMessageA(указатель, EM_SETSEL, поз, v2);
		}
	}
	
	
	// Current selection стартing индекс, in characters.
	// This does not necessarily correspond to the индекс of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	бцел началоВыделения() // getter
	{
		if(создан)
		{
			бцел v1, v2;
			SendMessageA(указатель, EM_GETSEL, cast(WPARAM)&v1, cast(LPARAM)&v2);
			return v1;
		}
		return 0;
	}
	
	
		// Number of characters in the текстbox.
	// This does not necessarily correspond to the number of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	// Return may be larger than the amount of characters.
	// This is а lot faster than retrieving the текст, but retrieving the текст is completely accurate.
	бцел длинаТекста() // getter
	{
		if(!(ктрлСтиль & ПСтилиУпрЭлта.CACHE_TEXT) && создан())
			//return cast(бцел)SendMessageA(указатель, WM_GETTEXTLENGTH, 0, 0);
			return cast(бцел)шлиСооб(указатель, WM_GETTEXTLENGTH, 0, 0);
		return окТекст.length;
	}
	
	
		final проц wordWrap(бул подтвержд) // setter
	{
		/+
		if(подтвержд)
			_style(_style() | ES_AUTOVSCROLL);
		else
			_style(_style() & ~ES_AUTOVSCROLL);
		+/
		
		// TODO: check if correct implementation.
		
		if(_wrap == подтвержд)
			return;
		
		_wrap = подтвержд;
		
		// Always H-scroll when single line.
		if(многострок)
		{
			if(подтвержд)
			{
				_style(_style() & ~(ES_AUTOHSCROLL | WS_HSCROLL));
			}
			else
			{
				LONG st;
				st = _style();
				
				st |=  ES_AUTOHSCROLL;
				
				if(_hscroll)
					st |= WS_HSCROLL;
				
				_style(st);
			}
		}
		
		_crecreate();
	}
	
	
	final бул wordWrap() // getter
	{
		//return (_style() & ES_AUTOVSCROLL) != 0;
		
		return _wrap;
	}
	
	
		final проц добавьТекст(Ткст txt)
	{
		if(создан)
		{
			началоВыделения = длинаТекста;
			выделенныйТекст = txt;
		}
		else
		{
			текст = текст ~ txt;
		}
	}
	
	
		final проц сотри()
	{
		/+
		// WM_CLEAR only clears the selection ?
		if(создан)
			SendMessageA(указатель, WM_CLEAR, 0, 0);
		else
			окТекст = пусто;
		+/
		
		текст = пусто;
	}
	
	
		final проц сотриОтмену()
	{
		if(создан)
			SendMessageA(указатель, EM_EMPTYUNDOBUFFER, 0, 0);
	}
	
	
		final проц копируй()
	{
		if(создан)
		{
			SendMessageA(указатель, WM_COPY, 0, 0);
		}
		else
		{
			// There's never а selection if the окно isn't создан; so just пуст the clipboard.
			
			if(!OpenClipboard(пусто))
			{
				debug(APP_PRINT)
					скажиф("Unable to OpenClipboard().\n");
				//throw new ВизИскл("Unable to установи clipboard данные.");
				return;
			}
			EmptyClipboard();
			CloseClipboard();
		}
	}
	
	
		final проц вырежь()
	{
		if(создан)
		{
			SendMessageA(указатель, WM_CUT, 0, 0);
		}
		else
		{
			// There's never а selection if the окно isn't создан; so just пуст the clipboard.
			
			if(!OpenClipboard(пусто))
			{
				debug(APP_PRINT)
					скажиф("Unable to OpenClipboard().\n");
				//throw new ВизИскл("Unable to установи clipboard данные.");
				return;
			}
			EmptyClipboard();
			CloseClipboard();
		}
	}
	
	
		final проц вставь()
	{
		if(создан)
		{
			SendMessageA(указатель, WM_PASTE, 0, 0);
		}
		else
		{
			// Can't do anything because there's нет selection ?
		}
	}
	
	
		final проц прокрутиДоКаретки()
	{
		if(создан)
			SendMessageA(указатель, EM_SCROLLCARET, 0, 0);
	}
	
	
		final проц выдели(бцел старт, бцел length)
	{
		if(создан)
			SendMessageA(указатель, EM_SETSEL, старт, старт + length);
	}
	
	alias УпрЭлт.выдели выдели; // Overload.
	
	
		final проц выделиВсе()
	{
		if(создан)
			SendMessageA(указатель, EM_SETSEL, 0, -1);
	}
	
	
	Ткст вТкст()
	{
		return текст; // ?
	}
	
	
		final проц отмени()
	{
		if(создан)
			SendMessageA(указатель, EM_UNDO, 0, 0);
	}
	
	
	/+
	override проц создайУказатель()
	{
		if(созданУказатель_ли)
			return;
		
		создайУказательНаКласс(TEXTBOX_CLASSNAME);
		
		поСозданиюУказателя(АргиСоб.пуст);
	}
	+/
	
	
	override проц создайУказатель()
	{
		if(!созданУказатель_ли)
		{
			Ткст txt;
			txt = окТекст;
			
			super.создайУказатель();
			
			//установиТекстОкна(уок, txt);
			текст = txt; // So that it can be overridden.
		}
	}
	
	
	 override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = TEXTBOX_CLASSNAME;
		cp.заглавие = пусто; // Set in создайУказатель() to allow larger buffers.
	}
	
	
	 override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		//SendMessageA(уок, EM_SETLIMITTEXT, cast(WPARAM)lim, 0);
		максДлина = lim; // Call virtual function.
	}
	
	
	private
	{
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
		}
		else
		{
			проц menuUndo(Объект отправитель, АргиСоб ea)
			{
				отмени();
			}
			
			
			проц menuCut(Объект отправитель, АргиСоб ea)
			{
				вырежь();
			}
			
			
			проц menuCopy(Объект отправитель, АргиСоб ea)
			{
				копируй();
			}
			
			
			проц menuPaste(Объект отправитель, АргиСоб ea)
			{
				вставь();
			}
			
			
			проц menuDelete(Объект отправитель, АргиСоб ea)
			{
				// Only сотри selection.
				SendMessageA(указатель, WM_CLEAR, 0, 0);
			}
			
			
			проц menuSelectAll(Объект отправитель, АргиСоб ea)
			{
				выделиВсе();
			}
			
			
			бул isClipboardText()
			{
				if(!OpenClipboard(указатель))
					return нет;
				
				бул результат;
				результат = GetClipboardData(CF_TEXT) != пусто;
				
				CloseClipboard();
				
				return результат;
			}
			
			
			проц menuPopup(Объект отправитель, АргиСоб ea)
			{
				цел slen, tlen;
				бул issel;
				
				slen = длинаВыделения;
				tlen = длинаТекста;
				issel = slen != 0;
				
				miundo.включен = можноОтменить;
				micut.включен = !толькоЧтение() && issel;
				micopy.включен = issel;
				mipaste.включен = !толькоЧтение() && isClipboardText();
				midel.включен = !толькоЧтение() && issel;
				misel.включен = tlen != 0 && tlen != slen;
			}
			
			
			ПунктМеню miundo, micut, micopy, mipaste, midel, misel;
		}
	}
	
	
	this()
	{
		_initTextBox();
		
		окСтиль |= WS_TABSTOP | ES_AUTOHSCROLL;
		окДопСтиль |= WS_EX_CLIENTEDGE;
		ктрлСтиль |= ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ;
		окСтильКласса = стильКлассаТекстБокс;
		
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
		}
		else
		{
			ПунктМеню mi;
			
			cmenu = new КонтекстноеМеню;
			cmenu.всплытие ~= &menuPopup;
			
			miundo = new ПунктМеню;
			miundo.текст = "&Undo";
			miundo.клик ~= &menuUndo;
			miundo.индекс = 0;
			cmenu.элтыМеню.добавь(miundo);
			
			mi = new ПунктМеню;
			mi.текст = "-";
			mi.индекс = 1;
			cmenu.элтыМеню.добавь(mi);
			
			micut = new ПунктМеню;
			micut.текст = "Cu&t";
			micut.клик ~= &menuCut;
			micut.индекс = 2;
			cmenu.элтыМеню.добавь(micut);
			
			micopy = new ПунктМеню;
			micopy.текст = "&Copy";
			micopy.клик ~= &menuCopy;
			micopy.индекс = 3;
			cmenu.элтыМеню.добавь(micopy);
			
			mipaste = new ПунктМеню;
			mipaste.текст = "&Paste";
			mipaste.клик ~= &menuPaste;
			mipaste.индекс = 4;
			cmenu.элтыМеню.добавь(mipaste);
			
			midel = new ПунктМеню;
			midel.текст = "&Delete";
			midel.клик ~= &menuDelete;
			midel.индекс = 5;
			cmenu.элтыМеню.добавь(midel);
			
			mi = new ПунктМеню;
			mi.текст = "-";
			mi.индекс = 6;
			cmenu.элтыМеню.добавь(mi);
			
			misel = new ПунктМеню;
			misel.текст = "Select &All";
			misel.клик ~= &menuSelectAll;
			misel.индекс = 7;
			cmenu.элтыМеню.добавь(misel);
		}
	}
	
	
	override Цвет цветФона() // getter
	{
		if(Цвет.пуст == цвфона)
			return дефЦветФона;
		return цвфона;
	}
	
	alias УпрЭлт.цветФона цветФона; // Overload.
	
	
	static Цвет дефЦветФона() // getter
	{
		return Цвет.системныйЦвет(COLOR_WINDOW);
	}
	
	
	override Цвет цветПП() // getter
	{
		if(Цвет.пуст == цвпп)
			return дефЦветПП;
		return цвпп;
	}
	
	alias УпрЭлт.цветПП цветПП; // Overload.
	
	
	static Цвет дефЦветПП() //getter
	{
		return Цвет.системныйЦвет(COLOR_WINDOWTEXT);
	}
	
	
	override Курсор курсор() // getter
	{
		if(!окКурс)
			return _defaultCursor;
		return окКурс;
	}
	
	alias УпрЭлт.курсор курсор; // Overload.
	
	
		цел getFirstCharIndexFromLine(цел line)
	{
		if(!созданУказатель_ли)
			return -1; // ...
		if(line < 0)
			return -1;
		return SendMessageA(уок, EM_LINEINDEX, line, 0);
	}
	
	
	цел getFirstCharIndexOfCurrentLine()
	{
		if(!созданУказатель_ли)
			return -1; // ...
		return SendMessageA(уок, EM_LINEINDEX, -1, 0);
	}
	
	
		цел getLineFromCharIndex(цел charIndex)
	{
		if(!созданУказатель_ли)
			return -1; // ...
		if(charIndex < 0)
			return -1;
		return SendMessageA(уок, EM_LINEFROMCHAR, charIndex, 0);
	}
	
	
		Точка getPositionFromCharIndex(цел charIndex)
	{
		if(!созданУказатель_ли)
			return Точка(0, 0); // ...
		if(charIndex < 0)
			return Точка(0, 0);
		Точка Точка;
		SendMessageA(уок, EM_POSFROMCHAR, cast(WPARAM)&Точка, charIndex);
		return Точка(Точка.ш, Точка.в);
	}
	
	
	цел getCharIndexFromPosition(Точка тчк)
	{
		if(!созданУказатель_ли)
			return -1; // ...
		if(!многострок)
			return 0;
		auto lresult = SendMessageA(уок, EM_CHARFROMPOS, 0, MAKELPARAM(тчк.ш, тчк.в));
		if(-1 == lresult)
			return -1;
		return cast(цел)cast(short)(lresult & 0xFFFF);
	}
	
	
	package static Курсор _defaultCursor() // getter
	{
		static Курсор def = пусто;
		
		if(!def)
		{
			synchronized
			{
				if(!def)
					def = new БезопасныйКурсор(LoadCursorA(пусто, IDC_IBEAM));
			}
		}
		
		return def;
	}
	
	
	 override проц поОбратномуСообщению(inout Сообщение m)
	{
		super.поОбратномуСообщению(m);
		
		switch(m.сооб)
		{
			case WM_COMMAND:
				switch(HIWORD(m.парам1))
				{
					case EN_CHANGE:
						приИзмененииТекста(АргиСоб.пуст);
						break;
					
					default: ;
				}
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
			
			default: ;
		}
	}
	
	
	override проц предшОкПроц(inout Сообщение сооб)
	{
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
			// Don't prevent WM_CONTEXTMENU so at least it'll have а default меню.
		}
		else
		{
			if(сооб.сооб == WM_CONTEXTMENU) // Ignore the default контекст меню.
				return;
		}
		
		//сооб.результат = CallWindowProcA(первОкПроцТексБокса, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = вызовиОкПроц(первОкПроцТексБокса, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	 override бул обработайАргиСобКлавиш(inout Сообщение сооб) // package
	{
		switch(сооб.сооб)
		{
			case WM_KEYDOWN:
			case WM_KEYUP:
			case WM_CHAR:
				if('\t' == сооб.парам1)
				{
					// TODO: fix this. This case shouldn't be needed.
					if(atab)
					{
						if(super.обработайАргиСобКлавиш(сооб))
							return да; // Handled.
						if(WM_KEYDOWN == сооб.сооб)
						{
							if(многострок) // Only многострок текстboxes can have real tabs..
							{
								//выделенныйТекст = "\t";
								//SendMessageA(указатель, EM_REPLACESEL, TRUE, cast(LPARAM)"\t".ptr); // Allow отмени. // Crashes DMD 0.161.
								auto str = "\t".ptr;
								SendMessageA(указатель, EM_REPLACESEL, TRUE, cast(LPARAM)str); // Allow отмени.
							}
						}
						return да; // Handled.
					}
				}
				break;
			
			default: ;
		}
		return super.обработайАргиСобКлавиш(сооб);
	}
	
	
	override проц окПроц(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			case WM_GETDLGCODE:
				super.окПроц(сооб);
				if(atab)
				{
					//if(GetKeyState(ПКлавиши.TAB) & 0x8000)
					{
						//сооб.результат |= DLGC_WANTALLKEYS;
						сооб.результат |= DLGC_WANTTAB;
					}
				}
				else
				{
					сооб.результат &= ~DLGC_WANTTAB;
				}
				return;
			
			default:
				super.окПроц(сооб);
		}
	}
	
	
	override Размер дефРазм() // getter
	{
		return Размер(120, 23); // ?
	}
	
	
	private:
	package бцел lim = 30_000; // Documented as default.
	бул _wrap = да;
	бул _hscroll;
	
	бул atab = нет;
	
	/+
	бул atab() // getter
	{
		if(_style() & X)
			return да;
		return нет;
	}
	
	проц atab(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | X);
		else
			_style(_style() & ~X);
	}
	+/
	
	
	проц hscroll(бул подтвержд) // setter
	{
		_hscroll = подтвержд;
		
		if(подтвержд && (!_wrap || !многострок))
			_style(_style() | WS_HSCROLL | ES_AUTOHSCROLL);
	}
	
	
	бул hscroll() // getter
	{
		return _hscroll;
	}
}


/*export*/ class ТекстБокс: ОсноваТекстБокса // docmain
{
/*export*/
		final проц acceptsReturn(бул подтвержд) // setter
	{
		if(подтвержд)
			_style(_style() | ES_WANTRETURN);
		else
			_style(_style() & ~ES_WANTRETURN);
	}
	
	
	final бул acceptsReturn() // getter
	{
		return (_style() & ES_WANTRETURN) != 0;
	}
	
	
		final проц characterCasing(ПРегистрСимволов cc) // setter
	{
		LONG wl = _style() & ~(ES_UPPERCASE | ES_LOWERCASE);
		
		switch(cc)
		{
			case ПРегистрСимволов.ЗАГ:
				wl |= ES_UPPERCASE;
				break;
			
			case ПРегистрСимволов.ПРОПИСЬ:
				wl |= ES_LOWERCASE;
				break;
			
			case ПРегистрСимволов.НОРМА:
				break;
		}
		
		_style(wl);
	}
	
	
	final ПРегистрСимволов characterCasing() // getter
	{
		LONG wl = _style();
		if(wl & ES_UPPERCASE)
			return ПРегистрСимволов.ЗАГ;
		else if(wl & ES_LOWERCASE)
			return ПРегистрСимволов.ПРОПИСЬ;
		return ПРегистрСимволов.НОРМА;
	}
	
	
		// Set to 0 (NUL) to удали.
	final проц passwordChar(дим pwc) // setter
	{
		if(pwc)
		{
			// When the EM_SETPASSWORDCHAR сообщение is received by an edit упрэлт,
			// the edit упрэлт redraws все виден characters by using the
			// character задано by the ch parameter.
			
			if(создан)
				//SendMessageA(указатель, EM_SETPASSWORDCHAR, pwc, 0);
				emSetPasswordChar(указатель, pwc);
			else
				_style(_style() | ES_PASSWORD);
		}
		else
		{
			// The стиль ES_PASSWORD is removed if an EM_SETPASSWORDCHAR сообщение
			// is sent with the ch parameter установи to zero.
			
			if(создан)
				//SendMessageA(указатель, EM_SETPASSWORDCHAR, 0, 0);
				emSetPasswordChar(указатель, 0);
			else
				_style(_style() & ~ES_PASSWORD);
		}
		
		passchar = pwc;
	}
	
	
	final дим passwordChar() // getter
	{
		if(создан)
			//passchar = cast(дим)SendMessageA(указатель, EM_GETPASSWORDCHAR, 0, 0);
			passchar = emGetPasswordChar(указатель);
		return passchar;
	}
	
	
		final проц полосыПрокрутки(ППолосыПрокрутки sb) // setter
	{
		/+
		switch(sb)
		{
			case ППолосыПрокрутки.ОБА:
				_style(_style() | WS_HSCROLL | WS_VSCROLL);
				break;
			
			case ППолосыПрокрутки.ГОРИЗ:
				_style(_style() & ~WS_VSCROLL | WS_HSCROLL);
				break;
			
			case ППолосыПрокрутки.ВЕРТ:
				_style(_style() & ~WS_HSCROLL | WS_VSCROLL);
				break;
			
			case ППолосыПрокрутки.НЕУК:
				_style(_style() & ~(WS_HSCROLL | WS_VSCROLL));
				break;
		}
		+/
		switch(sb)
		{
			case ППолосыПрокрутки.ОБА:
				_style(_style() | WS_VSCROLL);
				hscroll = да;
				break;
			
			case ППолосыПрокрутки.ГОРИЗ:
				_style(_style() & ~WS_VSCROLL);
				hscroll = да;
				break;
			
			case ППолосыПрокрутки.ВЕРТ:
				_style(_style() | WS_VSCROLL);
				hscroll = нет;
				break;
			
			case ППолосыПрокрутки.НЕУК:
				_style(_style() & ~WS_VSCROLL);
				hscroll = нет;
				break;
		}
		
		if(создан)
			перерисуйПолностью();
	}
	
	
	final ППолосыПрокрутки полосыПрокрутки() // getter
	{
		LONG wl = _style();
		
		//if(wl & WS_HSCROLL)
		if(hscroll)
		{
			if(wl & WS_VSCROLL)
				return ППолосыПрокрутки.ОБА;
			return ППолосыПрокрутки.ГОРИЗ;
		}
		if(wl & WS_VSCROLL)
			return ППолосыПрокрутки.ВЕРТ;
		return ППолосыПрокрутки.НЕУК;
	}
	
	
		final проц разместиТекст(ПГоризРасположение ha) // setter
	{
		LONG wl = _style() & ~(ES_RIGHT | ES_CENTER | ES_LEFT);
		
		switch(ha)
		{
			case ПГоризРасположение.ПРАВ:
				wl |= ES_RIGHT;
				break;
			
			case ПГоризРасположение.ЦЕНТР:
				wl |= ES_CENTER;
				break;
			
			case ПГоризРасположение.ЛЕВ:
				wl |= ES_LEFT;
				break;
		}
		
		_style(wl);
		
		_crecreate();
	}
	
	
	final ПГоризРасположение разместиТекст() // getter
	{
		LONG wl = _style();
		
		if(wl & ES_RIGHT)
			return ПГоризРасположение.ПРАВ;
		if(wl & ES_CENTER)
			return ПГоризРасположение.ЦЕНТР;
		return ПГоризРасположение.ЛЕВ;
	}
	
	
	this()
	{
		окСтиль |= ES_LEFT;
	}
	
	
	 override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		if(passchar)
		{
			SendMessageA(уок, EM_SETPASSWORDCHAR, passchar, 0);
		}
	}
	
	
	/+
	override проц окПроц(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			/+
			case WM_GETDLGCODE:
				if(!acceptsReturn && (GetKeyState(ПКлавиши.RETURN) & 0x8000))
				{
					// Hack.
					сооб.результат = DLGC_HASSETSEL | DLGC_WANTCHARS | DLGC_WANTARROWS;
					return;
				}
				break;
			+/
			
			default: ;
		}
		
		super.окПроц(сооб);
	}
	+/
	
	
	private:
	дим passchar = 0;
}

