//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.richtextbox;

private import viz.textbox, viz.x.winapi, viz.event, viz.application;
private import viz.base, viz.drawing, viz.data;
private import viz.control, viz.x.utf, viz.x.dlib;

version(ВИЗ_БЕЗ_МЕНЮ)
{
}
else
{
	private import viz.menu;
}


private extern(C) ткст0 strcpy(ткст0, ткст0);


private extern(Windows) проц _initRichTextbox();


class LinkClickedEventArgs: АргиСоб
{
		this(Ткст linkText)
	{
		_linktxt = linkText;
	}
	
	
		final Ткст linkText() // getter
	{
		return _linktxt;
	}
	
	
	private:
	Ткст _linktxt;
}


enum RichTextBoxScrollBars: ббайт
{
	НЕУК, 	ГОРИЗ, 
	ВЕРТ, 
	ОБА, 
	FORCED_HORIZONTAL, 
	FORCED_VERTICAL, 
	FORCED_BOTH, 
}


class RichTextBox: ОсноваТекстБокса // docmain
{
	this()
	{
		super();
		
		_initRichTextbox();
		
		окСтиль |= ES_MULTILINE | ES_WANTRETURN | ES_AUTOHSCROLL | ES_AUTOVSCROLL | WS_HSCROLL | WS_VSCROLL;
		окКурс = пусто; // So that the упрэлт can change it accordingly.
		окСтильКласса = стильКлассаРичТекстБокс;
		
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
		}
		else
		{
			with(miredo = new ПунктМеню)
			{
				текст = "&Redo";
				клик ~= &menuRedo;
				контекстноеМеню.элтыМеню.вставь(1, miredo);
			}
			
			контекстноеМеню.всплытие ~= &menuPopup2;
		}
	}
	
	
	private
	{
		version(ВИЗ_БЕЗ_МЕНЮ)
		{
		}
		else
		{
			проц menuRedo(Объект отправитель, АргиСоб ea)
			{
				redo();
			}
			
			
			проц menuPopup2(Объект отправитель, АргиСоб ea)
			{
				miredo.включен = canRedo;
			}
			
			
			ПунктМеню miredo;
		}
	}
	
	
	override Курсор курсор() // getter
	{
		return окКурс; // Do return пусто and don't inherit.
	}
	
	alias ОсноваТекстБокса.курсор курсор; // Overload.
	
	
	override Ткст выделенныйТекст() // getter
	{
		if(создан)
		{
			/+
			бцел len = длинаВыделения + 1;
			Ткст результат = new сим[len];
			len = SendMessageA(указатель, EM_GETSELTEXT, 0, cast(LPARAM)cast(ткст0)результат);
			assert(!результат[len]);
			return результат[0 .. len];
			+/
			
			return viz.x.utf.emGetSelText(уок, длинаВыделения + 1);
		}
		return пусто;
	}
	
	alias ОсноваТекстБокса.выделенныйТекст выделенныйТекст; // Overload.
	
	
	override проц длинаВыделения(бцел len) // setter
	{
		if(создан)
		{
			CHARRANGE chrg;
			SendMessageA(указатель, EM_EXGETSEL, 0, cast(LPARAM)&chrg);
			chrg.cpMax = chrg.cpMin + len;
			SendMessageA(указатель, EM_EXSETSEL, 0, cast(LPARAM)&chrg);
		}
	}
	
	
	// Current selection length, in characters.
	// This does not necessarily correspond to the length of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	override бцел длинаВыделения() // getter
	{
		if(создан)
		{
			CHARRANGE chrg;
			SendMessageA(указатель, EM_EXGETSEL, 0, cast(LPARAM)&chrg);
			assert(chrg.cpMax >= chrg.cpMin);
			return chrg.cpMax - chrg.cpMin;
		}
		return 0;
	}
	
	
	override проц началоВыделения(бцел поз) // setter
	{
		if(создан)
		{
			CHARRANGE chrg;
			SendMessageA(указатель, EM_EXGETSEL, 0, cast(LPARAM)&chrg);
			assert(chrg.cpMax >= chrg.cpMin);
			chrg.cpMax = поз + (chrg.cpMax - chrg.cpMin);
			chrg.cpMin = поз;
			SendMessageA(указатель, EM_EXSETSEL, 0, cast(LPARAM)&chrg);
		}
	}
	
	
	// Current selection стартing индекс, in characters.
	// This does not necessarily correspond to the индекс of chars; some characters use multiple chars.
	// An end of line (\r\n) takes up 2 characters.
	override бцел началоВыделения() // getter
	{
		if(создан)
		{
			CHARRANGE chrg;
			SendMessageA(указатель, EM_EXGETSEL, 0, cast(LPARAM)&chrg);
			return chrg.cpMin;
		}
		return 0;
	}
	
	
	override проц максДлина(бцел len) // setter
	{
		lim = len;
		
		if(создан)
			SendMessageA(указатель, EM_EXLIMITTEXT, 0, cast(LPARAM)len);
	}
	
	alias ОсноваТекстБокса.максДлина максДлина; // Overload.
	
	
	override Размер дефРазм() // getter
	{
		return Размер(120, 120); // ?
	}
	
	
	private проц _setbk(Цвет ктрл)
	{
		if(создан)
		{
			if(ктрл._systemColorIndex == COLOR_WINDOW)
				SendMessageA(указатель, EM_SETBKGNDCOLOR, 1, 0);
			else
				SendMessageA(указатель, EM_SETBKGNDCOLOR, 0, cast(LPARAM)ктрл.вКзс());
		}
	}
	
	
	override проц цветФона(Цвет ктрл) // setter
	{
		_setbk(ктрл);
		super.цветФона(ктрл);
	}
	
	alias ОсноваТекстБокса.цветФона цветФона; // Overload.
	
	
	private проц _setfc(Цвет ктрл)
	{
		if(создан)
		{
			CHARFORMAT2A cf;
			
			cf.cbSize = cf.sizeof;
			cf.dwMask = CFM_COLOR;
			if(ктрл._systemColorIndex == COLOR_WINDOWTEXT)
				cf.dwEffects = CFE_AUTOCOLOR;
			else
				cf.crTextColor = ктрл.вКзс();
			
			_setFormat(&cf, SCF_ALL);
		}
	}
	
	
	override проц цветПП(Цвет ктрл) // setter
	{
		_setfc(ктрл);
		super.цветПП(ктрл);
	}
	
	alias ОсноваТекстБокса.цветПП цветПП; // Overload.
	
	
		final бул canRedo() // getter
	{
		if(!создан)
			return нет;
		return SendMessageA(указатель, EM_CANREDO, 0, 0) != 0;
	}
	
	
		final бул canPaste(ФорматыДанных.Формат df)
	{
		if(создан)
		{
			if(SendMessageA(указатель, EM_CANPASTE, df.id, 0))
				return да;
		}
		
		return нет;
	}
	
	
		final проц redo()
	{
		if(создан)
			SendMessageA(указатель, EM_REDO, 0, 0);
	}
	
	
		// "Paste special."
	final проц вставь(ФорматыДанных.Формат df)
	{
		if(создан)
		{
			SendMessageA(указатель, EM_PASTESPECIAL, df.id, cast(LPARAM)пусто);
		}
	}
	
	alias ОсноваТекстБокса.вставь вставь; // Overload.
	
	
		final проц selectionCharOffset(цел yoffset) // setter
	{
		if(!создан)
			return;
		
		CHARFORMAT2A cf;
		
		cf.cbSize = cf.sizeof;
		cf.dwMask = CFM_OFFSET;
		cf.yOffset = yoffset;
		
		_setFormat(&cf);
	}
	
	
	final цел selectionCharOffset() // getter
	{
		if(создан)
		{
			CHARFORMAT2A cf;
			cf.cbSize = cf.sizeof;
			cf.dwMask = CFM_OFFSET;
			_getFormat(&cf);
			return cf.yOffset;
		}
		return 0;
	}
	
	
		final проц selectionColor(Цвет ктрл) // setter
	{
		if(!создан)
			return;
		
		CHARFORMAT2A cf;
		
		cf.cbSize = cf.sizeof;
		cf.dwMask = CFM_COLOR;
		if(ктрл._systemColorIndex == COLOR_WINDOWTEXT)
			cf.dwEffects = CFE_AUTOCOLOR;
		else
			cf.crTextColor = ктрл.вКзс();
		
		_setFormat(&cf);
	}
	
	
	final Цвет selectionColor() // getter
	{
		if(создан)
		{
			CHARFORMAT2A cf;
			
			cf.cbSize = cf.sizeof;
			cf.dwMask = CFM_COLOR;
			_getFormat(&cf);
			
			if(cf.dwMask & CFM_COLOR)
			{
				if(cf.dwEffects & CFE_AUTOCOLOR)
					return Цвет.системныйЦвет(COLOR_WINDOWTEXT);
				return Цвет.изКзс(cf.crTextColor);
			}
		}
		return Цвет.пуст;
	}
	
	
		final проц selectionBackColor(Цвет ктрл) // setter
	{
		if(!создан)
			return;
		
		CHARFORMAT2A cf;
		
		cf.cbSize = cf.sizeof;
		cf.dwMask = CFM_BACKCOLOR;
		if(ктрл._systemColorIndex == COLOR_WINDOW)
			cf.dwEffects = CFE_AUTOBACKCOLOR;
		else
			cf.crBackColor = ктрл.вКзс();
		
		_setFormat(&cf);
	}
	
	
	final Цвет selectionBackColor() // getter
	{
		if(создан)
		{
			CHARFORMAT2A cf;
			
			cf.cbSize = cf.sizeof;
			cf.dwMask = CFM_BACKCOLOR;
			_getFormat(&cf);
			
			if(cf.dwMask & CFM_BACKCOLOR)
			{
				if(cf.dwEffects & CFE_AUTOBACKCOLOR)
					return Цвет.системныйЦвет(COLOR_WINDOW);
				return Цвет.изКзс(cf.crBackColor);
			}
		}
		return Цвет.пуст;
	}
	
	
		final проц selectionSubscript(бул подтвержд) // setter
	{
		if(!создан)
			return;
		
		CHARFORMAT2A cf;
		
		cf.cbSize = cf.sizeof;
		cf.dwMask = CFM_SUPERSCRIPT | CFM_SUBSCRIPT;
		if(подтвержд)
		{
			cf.dwEffects = CFE_SUBSCRIPT;
		}
		else
		{
			// Make sure it doesn't accidentally unset superscript.
			CHARFORMAT2A cf2get;
			cf2get.cbSize = cf2get.sizeof;
			cf2get.dwMask = CFM_SUPERSCRIPT | CFM_SUBSCRIPT;
			_getFormat(&cf2get);
			if(cf2get.dwEffects & CFE_SUPERSCRIPT)
				return; // Superscript is установи, so don't bother.
			if(!(cf2get.dwEffects & CFE_SUBSCRIPT))
				return; // Don't need to unset twice.
		}
		
		_setFormat(&cf);
	}
	
	
	final бул selectionSubscript() // getter
	{
		if(создан)
		{
			CHARFORMAT2A cf;
			
			cf.cbSize = cf.sizeof;
			cf.dwMask = CFM_SUPERSCRIPT | CFM_SUBSCRIPT;
			_getFormat(&cf);
			
			return (cf.dwEffects & CFE_SUBSCRIPT) == CFE_SUBSCRIPT;
		}
		return нет;
	}
	
	
		final проц selectionSuperscript(бул подтвержд) // setter
	{
		if(!создан)
			return;
		
		CHARFORMAT2A cf;
		
		cf.cbSize = cf.sizeof;
		cf.dwMask = CFM_SUPERSCRIPT | CFM_SUBSCRIPT;
		if(подтвержд)
		{
			cf.dwEffects = CFE_SUPERSCRIPT;
		}
		else
		{
			// Make sure it doesn't accidentally unset subscript.
			CHARFORMAT2A cf2get;
			cf2get.cbSize = cf2get.sizeof;
			cf2get.dwMask = CFM_SUPERSCRIPT | CFM_SUBSCRIPT;
			_getFormat(&cf2get);
			if(cf2get.dwEffects & CFE_SUBSCRIPT)
				return; // Subscript is установи, so don't bother.
			if(!(cf2get.dwEffects & CFE_SUPERSCRIPT))
				return; // Don't need to unset twice.
		}
		
		_setFormat(&cf);
	}
	
	
	final бул selectionSuperscript() // getter
	{
		if(создан)
		{
			CHARFORMAT2A cf;
			
			cf.cbSize = cf.sizeof;
			cf.dwMask = CFM_SUPERSCRIPT | CFM_SUBSCRIPT;
			_getFormat(&cf);
			
			return (cf.dwEffects & CFE_SUPERSCRIPT) == CFE_SUPERSCRIPT;
		}
		return нет;
	}
	
	
	private const DWORD FONT_MASK = CFM_BOLD | CFM_ITALIC | CFM_STRIKEOUT |
		CFM_UNDERLINE | CFM_CHARSET | CFM_FACE | CFM_SIZE | CFM_UNDERLINETYPE | CFM_WEIGHT;
	
		final проц selectionFont(Шрифт f) // setter
	{
		if(создан)
		{
			// To-do: support Unicode шрифт names.
			
			CHARFORMAT2A cf;
			LOGFONTA шл;
			
			f._info(&шл);
			
			cf.cbSize = cf.sizeof;
			cf.dwMask = FONT_MASK;
			
			//cf.dwEffects = 0;
			if(шл.lfWeight >= FW_BOLD)
				cf.dwEffects |= CFE_BOLD;
			if(шл.lfItalic)
				cf.dwEffects |= CFE_ITALIC;
			if(шл.lfStrikeOut)
				cf.dwEffects |= CFE_STRIKEOUT;
			if(шл.lfUnderline)
				cf.dwEffects |= CFE_UNDERLINE;
			cf.yHeight = cast(typeof(cf.yHeight))Шрифт.getEmSize(шл.lfHeight, ЕдиницаГрафики.TWIP);
			cf.bCharSet = шл.lfCharSet;
			strcpy(cf.szFaceName.ptr, шл.lfFaceName.ptr);
			cf.bUnderlineType = CFU_UNDERLINE;
			cf.wWeight = шл.lfWeight;
			
			_setFormat(&cf);
		}
	}
	
	
	// Returns пусто if the selection has different fonts.
	final Шрифт selectionFont() // getter
	{
		if(создан)
		{
			CHARFORMAT2A cf;
			
			cf.cbSize = cf.sizeof;
			cf.dwMask = FONT_MASK;
			_getFormat(&cf);
			
			if((cf.dwMask & FONT_MASK) == FONT_MASK)
			{
				LOGFONTA шл;
				with(шл)
				{
					lfHeight = -Шрифт.getLfHeight(cast(float)cf.yHeight, ЕдиницаГрафики.TWIP);
					lfWidth = 0; // ?
					lfEscapement = 0; // ?
					lfOrientation = 0; // ?
					lfWeight = cf.wWeight;
					if(cf.dwEffects & CFE_BOLD)
					{
						if(lfWeight < FW_BOLD)
							lfWeight = FW_BOLD;
					}
					lfItalic = (cf.dwEffects & CFE_ITALIC) != 0;
					lfUnderline = (cf.dwEffects & CFE_UNDERLINE) != 0;
					lfStrikeOut = (cf.dwEffects & CFE_STRIKEOUT) != 0;
					lfCharSet = cf.bCharSet;
					strcpy(lfFaceName.ptr, cf.szFaceName.ptr);
					lfOutPrecision = OUT_DEFAULT_PRECIS;
					шл.lfClipPrecision = CLIP_DEFAULT_PRECIS;
					шл.lfQuality = DEFAULT_QUALITY;
					шл.lfPitchAndFamily = DEFAULT_PITCH | FF_DONTCARE;
				}
				//return new Шрифт(Шрифт._create(&шл));
				ШрифтЛога _lf;
				Шрифт.LOGFONTAtoLogFont(_lf, &шл);
				return new Шрифт(Шрифт._create(_lf));
			}
		}
		
		return пусто;
	}
	
	
		final проц selectionBold(бул подтвержд) // setter
	{
		if(!создан)
			return;
		
		CHARFORMAT2A cf;
		
		cf.cbSize = cf.sizeof;
		cf.dwMask = CFM_BOLD;
		if(подтвержд)
			cf.dwEffects |= CFE_BOLD;
		else
			cf.dwEffects &= ~CFE_BOLD;
		_setFormat(&cf);
	}
	
	
	final бул selectionBold() // getter
	{
		if(создан)
		{
			CHARFORMAT2A cf;
			
			cf.cbSize = cf.sizeof;
			cf.dwMask = CFM_BOLD;
			_getFormat(&cf);
			
			return (cf.dwEffects & CFE_BOLD) == CFE_BOLD;
		}
		return нет;
	}
	
	
		final проц selectionUnderline(бул подтвержд) // setter
	{
		if(!создан)
			return;
		
		CHARFORMAT2A cf;
		
		cf.cbSize = cf.sizeof;
		cf.dwMask = CFM_UNDERLINE;
		if(подтвержд)
			cf.dwEffects |= CFE_UNDERLINE;
		else
			cf.dwEffects &= ~CFE_UNDERLINE;
		_setFormat(&cf);
	}
	
	
	final бул selectionUnderline() // getter
	{
		if(создан)
		{
			CHARFORMAT2A cf;
			
			cf.cbSize = cf.sizeof;
			cf.dwMask = CFM_UNDERLINE;
			_getFormat(&cf);
			
			return (cf.dwEffects & CFE_UNDERLINE) == CFE_UNDERLINE;
		}
		return нет;
	}
	
	
		final проц полосыПрокрутки(RichTextBoxScrollBars sb) // setter
	{
		LONG st;
		st = _style() & ~(ES_DISABLENOSCROLL | WS_HSCROLL | WS_VSCROLL |
			ES_AUTOHSCROLL | ES_AUTOVSCROLL);
		
		switch(sb)
		{
			case RichTextBoxScrollBars.FORCED_BOTH:
				st |= ES_DISABLENOSCROLL;
			case RichTextBoxScrollBars.ОБА:
				st |= WS_HSCROLL | WS_VSCROLL | ES_AUTOHSCROLL | ES_AUTOVSCROLL;
				break;
			
			case RichTextBoxScrollBars.FORCED_HORIZONTAL:
				st |= ES_DISABLENOSCROLL;
			case RichTextBoxScrollBars.ГОРИЗ:
				st |= WS_HSCROLL | ES_AUTOHSCROLL;
				break;
			
			case RichTextBoxScrollBars.FORCED_VERTICAL:
				st |= ES_DISABLENOSCROLL;
			case RichTextBoxScrollBars.ВЕРТ:
				st |= WS_VSCROLL | ES_AUTOVSCROLL;
				break;
			
			case RichTextBoxScrollBars.НЕУК:
				break;
		}
		
		_style(st);
		
		_crecreate();
	}
	
	
	final RichTextBoxScrollBars полосыПрокрутки() // getter
	{
		LONG wl = _style();
		
		if(wl & WS_HSCROLL)
		{
			if(wl & WS_VSCROLL)
			{
				if(wl & ES_DISABLENOSCROLL)
					return RichTextBoxScrollBars.FORCED_BOTH;
				return RichTextBoxScrollBars.ОБА;
			}
			
			if(wl & ES_DISABLENOSCROLL)
				return RichTextBoxScrollBars.FORCED_HORIZONTAL;
			return RichTextBoxScrollBars.ГОРИЗ;
		}
		
		if(wl & WS_VSCROLL)
		{
			if(wl & ES_DISABLENOSCROLL)
				return RichTextBoxScrollBars.FORCED_VERTICAL;
			return RichTextBoxScrollBars.ВЕРТ;
		}
		
		return RichTextBoxScrollBars.НЕУК;
	}
	
	
		override цел getLineFromCharIndex(цел charIndex)
	{
		if(!созданУказатель_ли)
			return -1; // ...
		if(charIndex < 0)
			return -1;
		return SendMessageA(уок, EM_EXLINEFROMCHAR, 0, charIndex);
	}
	
	
	private проц _getFormat(CHARFORMAT2A* cf, BOOL selection = TRUE)
	in
	{
		assert(создан);
	}
	body
	{
		//SendMessageA(указатель, EM_GETCHARFORMAT, selection, cast(LPARAM)cf);
		//CallWindowProcA(первОкПроцРичТекстБокса, уок, EM_GETCHARFORMAT, selection, cast(LPARAM)cf);
		viz.x.utf.вызовиОкПроц(первОкПроцРичТекстБокса, уок, EM_GETCHARFORMAT, selection, cast(LPARAM)cf);
	}
	
	
	private проц _setFormat(CHARFORMAT2A* cf, WPARAM scf = SCF_SELECTION)
	in
	{
		assert(создан);
	}
	body
	{
		/+
		//if(!SendMessageA(указатель, EM_SETCHARFORMAT, scf, cast(LPARAM)cf))
		//if(!CallWindowProcA(первОкПроцРичТекстБокса, уок, EM_SETCHARFORMAT, scf, cast(LPARAM)cf))
		if(!viz.x.utf.вызовиОкПроц(первОкПроцРичТекстБокса, уок, EM_SETCHARFORMAT, scf, cast(LPARAM)cf))
			throw new ВизИскл("Unable to установи текст formatting");
		+/
		viz.x.utf.вызовиОкПроц(первОкПроцРичТекстБокса, уок, EM_SETCHARFORMAT, scf, cast(LPARAM)cf);
	}
	
	
	private struct _StreamStr
	{
		Ткст str;
	}
	
	
	// Note: RTF should only be ASCII so нет conversions are necessary.
	// TODO: verify this; I'm not certain.
	
	private проц _streamIn(UINT фмт, Ткст str)
	in
	{
		assert(создан);
	}
	body
	{
		_StreamStr si;
		EDITSTREAM es;
		
		si.str = str;
		es.dwCookie = cast(DWORD)&si;
		es.pfnCallback = &_streamingInStr;
		
		//if(SendMessageA(указатель, EM_STREAMIN, cast(WPARAM)фмт, cast(LPARAM)&es) != str.length)
		//	throw new ВизИскл("Unable to установи RTF");
		
		SendMessageA(указатель, EM_STREAMIN, cast(WPARAM)фмт, cast(LPARAM)&es);
	}
	
	
	private Ткст _streamOut(UINT фмт)
	in
	{
		assert(создан);
	}
	body
	{
		_StreamStr so;
		EDITSTREAM es;
		
		so.str = пусто;
		es.dwCookie = cast(DWORD)&so;
		es.pfnCallback = &_streamingOutStr;
		
		SendMessageA(указатель, EM_STREAMOUT, cast(WPARAM)фмт, cast(LPARAM)&es);
		return so.str;
	}
	
	
		final проц selectedRtf(Ткст rtf) // setter
	{
		_streamIn(SF_RTF | SFF_SELECTION, rtf);
	}
	
	
	final Ткст selectedRtf() // getter
	{
		return _streamOut(SF_RTF | SFF_SELECTION);
	}
	
	
		final проц rtf(Ткст newRtf) // setter
	{
		_streamIn(SF_RTF, rtf);
	}
	
	
	final Ткст rtf() // getter
	{
		return _streamOut(SF_RTF);
	}
	
	
		final проц detectUrls(бул подтвержд) // setter
	{
		autoUrl = подтвержд;
		
		if(создан)
		{
			SendMessageA(указатель, EM_AUTOURLDETECT, подтвержд, 0);
		}
	}
	
	
	final бул detectUrls() // getter
	{
		return autoUrl;
	}
	
	
	/+
	override проц создайУказатель()
	{
		if(созданУказатель_ли)
			return;
		
		создайУказательНаКласс(RICHTEXTBOX_CLASSNAME);
		
		поСозданиюУказателя(АргиСоб.пуст);
	}
	+/
	
	
	/+
	override проц создайУказатель()
	{
		/+ // ОсноваТекстБокса.создайУказатель() does this.
		if(!созданУказатель_ли)
		{
			Ткст txt;
			txt = окТекст;
			
			super.создайУказатель();
			
			//viz.x.utf.установиТекстОкна(уок, txt);
			текст = txt; // So that it can be overridden.
		}
		+/
	}
	+/
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = RICHTEXTBOX_CLASSNAME;
		//cp.заглавие = пусто; // Set in создайУказатель() to allow larger buffers. // ОсноваТекстБокса.создайУказатель() does this.
	}
	
	
	//LinkClickedEventHandler linkClicked;
	Событие!(RichTextBox, LinkClickedEventArgs) linkClicked; 	
	
	protected:
	
		проц onLinkClicked(LinkClickedEventArgs ea)
	{
		linkClicked(this, ea);
	}
	
	
	private Ткст _getRange(LONG min, LONG max)
	in
	{
		assert(создан);
		assert(max >= 0);
		assert(max >= min);
	}
	body
	{
		if(min == max)
			return пусто;
		
		TEXTRANGEA tr;
		сим[] s;
		
		tr.chrg.cpMin = min;
		tr.chrg.cpMax = max;
		max = max - min + 1;
		if(viz.x.utf.использоватьЮникод)
			max = cast(бцел)max << 1;
		s = new сим[max];
		tr.lpstrText = s.ptr;
		
		//max = SendMessageA(указатель, EM_GETTEXTRANGE, 0, cast(LPARAM)&tr);
		max = viz.x.utf.шлиСооб(указатель, EM_GETTEXTRANGE, 0, cast(LPARAM)&tr);
		Ткст результат;
		if(viz.x.utf.использоватьЮникод)
			результат = изЮникода(cast(шткст0)s.ptr, max);
		else
			результат = изАнзи(s.ptr, max);
		return результат;
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
					
					assert(nmh.hwndFrom == указатель);
					
					switch(nmh.code)
					{
						case EN_LINK:
							{
								ENLINK* enl;
								enl = cast(ENLINK*)nmh;
								
								if(enl.сооб == WM_LBUTTONUP)
								{
									if(!длинаВыделения)
										onLinkClicked(new LinkClickedEventArgs(_getRange(enl.chrg.cpMin, enl.chrg.cpMax)));
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
	
	
	override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		SendMessageA(указатель, EM_AUTOURLDETECT, autoUrl, 0);
		
		_setbk(this.цветФона);
		
		//Приложение.вершиСобытия(); // цветПП won't work otherwise.. seems to work now
		_setfc(this.цветПП);
		
		SendMessageA(указатель, EM_SETEVENTMASK, 0, ENM_CHANGE | ENM_CHANGE | ENM_LINK | ENM_PROTECTED);
	}
	
	
	override проц предшОкПроц(inout Сообщение m)
	{
		m.результат = CallWindowProcA(первОкПроцРичТекстБокса, m.уок, m.сооб, m.парам1, m.парам2);
		//m.результат = viz.x.utf.вызовиОкПроц(первОкПроцРичТекстБокса, m.уок, m.сооб, m.парам1, m.парам2);
	}
	
	
	private:
	бул autoUrl = да;
}


private extern(Windows) DWORD _streamingInStr(DWORD dwCookie, LPBYTE pbBuff, LONG cb, LONG* pcb)
{
	RichTextBox._StreamStr* si;
	si = cast(typeof(si))dwCookie;
	
	if(!si.str.length)
	{
		*pcb = 0;
		return 1; // ?
	}
	else if(cb >= si.str.length)
	{
		pbBuff[0 .. si.str.length] = cast(BYTE[])si.str;
		*pcb = si.str.length;
		si.str = пусто;
	}
	else
	{
		pbBuff[0 .. cb] = cast(BYTE[])si.str[0 .. cb];
		*pcb = cb;
		si.str = si.str[cb .. si.str.length];
	}
	
	return 0;
}


private extern(Windows) DWORD _streamingOutStr(DWORD dwCookie, LPBYTE pbBuff, LONG cb, LONG* pcb)
{
	RichTextBox._StreamStr* so;
	so = cast(typeof(so))dwCookie;
	
	so.str ~= cast(Ткст)pbBuff[0 .. cb];
	*pcb = cb;
	
	return 0;
}

