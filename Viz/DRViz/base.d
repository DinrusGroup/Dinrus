module viz.base;

private import viz.x.dlib, stdrus, cidrus, sys.consts:НЕВЕРНХЭНДЛ, МАКС_ПУТЬ;

private import viz.x.winapi, viz.drawing, viz.event;

alias HANDLE УОК, УОкно, HTHEME;


interface ИОкно // docmain
{
		УОкно указатель(); // getter
}


class ВизИскл: Исключение // docmain
{
		this(Ткст сооб)
	{
		super(сооб);
	}
}

class СтроковыйОбъект: Объект
{
		Ткст значение;
	
	
		this(Ткст str)
	{
		this.значение = str;
	}
	
	
	Ткст вТкст()
	{
		return значение;
	}
	
	
	override т_рав opEquals(Объект o)
	{
		return значение == дайТкстОбъекта(o); // ?
	}
	
	
	т_рав opEquals(СтроковыйОбъект s)
	{
		return значение == s.значение;
	}
	
	
	override цел opCmp(Объект o)
	{
		return сравнлюб(значение, дайТкстОбъекта(o)); // ?
	}
	
	
	цел opCmp(СтроковыйОбъект s)
	{
		return сравнлюб(значение, s.значение);
	}
}

enum ПКлавиши: бцел // docmain
{
	НЕУК =     0, /// No ПКлавиши задано.
	
		ШИФТ =    0x10000, /// Modifier ПКлавиши.
	КОНТРОЛ =  0x20000, 
	АЛЬТ =      0x40000, 
	
	A = 'A', /// Letters.
	B = 'B', 
	C = 'C', 
	D = 'D', 
	E = 'E', 
	F = 'F', 
	G = 'G', 
	H = 'H', 
	I = 'I', 
	J = 'J', 
	K = 'K', 
	L = 'L', 
	M = 'M', 
	N = 'N', 
	O = 'O', 
	P = 'P', 
	Q = 'Q', 
	R = 'R', 
	S = 'S', 
	T = 'T', 
	U = 'U', 
	V = 'V', 
	W = 'W', 
	X = 'X', 
	Y = 'Y', 
	Z = 'Z', 
	
	D0 = '0', /// Digits.
	D1 = '1', 
	D2 = '2', 
	D3 = '3', 
	D4 = '4', 
	D5 = '5', 
	D6 = '6', 
	D7 = '7', 
	D8 = '8', 
	D9 = '9', 
	
	F1 = 112, /// F - function ПКлавиши.
	F2 = 113, 
	F3 = 114, 
	F4 = 115, 
	F5 = 116, 
	F6 = 117, 
	F7 = 118, 
	F8 = 119, 
	F9 = 120, 
	F10 = 121, 
	F11 = 122, 
	F12 = 123, 
	F13 = 124, 
	F14 = 125, 
	F15 = 126, 
	F16 = 127, 
	F17 = 128, 
	F18 = 129, 
	F19 = 130, 
	F20 = 131, 
	F21 = 132, 
	F22 = 133, 
	F23 = 134, 
	F24 = 135, 
	
	NUM_PAD0 = 96, /// Numbers on keypad.
	NUM_PAD1 = 97, 
	NUM_PAD2 = 98, 
	NUM_PAD3 = 99, 
	NUM_PAD4 = 100, 
	NUM_PAD5 = 101, 
	NUM_PAD6 = 102, 
	NUM_PAD7 = 103, 
	NUM_PAD8 = 104, 
	NUM_PAD9 = 105, 
	
	ADD = 107,
 	APPS = 93,
 /// Приложение.
	ATTN = 246,
 	BACK = 8,
 /// Backspace.
	ОТМЕНА = 3,
 	CAPITAL = 20,
 	CAPS_LOCK = 20,
 
	CLEAR = 12,
 	КЛАВИША_КОНТРОЛ = 17,
 	CRSEL = 247,
 	DECIMAL = 110,
 	DEL = 46,
 	DELETE = DEL,
 	PERIOD = 190,
 	Пунктир = PERIOD,
 
	DIVIDE = 111,
 	DOWN = 40,
 /// Down стрелка.
	END = 35,
 	ENTER = 13,
 	ERASE_EOF = 249,
 	ESCAPE = 27,
 	EXECUTE = 43,
 	EXSEL = 248,
 	FINAL_MODE = 4,
 /// IME final mode.
	HANGUL_MODE = 21,
 /// IME Hangul mode.
	HANGUEL_MODE = 21,
 
	HANJA_MODE = 25,
 /// IME Hanja mode.
	СПРАВКА = 47,
 	HOME = 36,
 	IME_ACCEPT = 30,
 	IME_CONVERT = 28,
 	IME_MODE_CHANGE = 31,
 	IME_NONCONVERT = 29,
 	INSERT = 45,
 	JUNJA_MODE = 23,
 	KANA_MODE = 21,
 	KANJI_MODE = 25,
 	LEFT_КОНТРОЛ = 162,
 /// Left Ctrl.
	ЛЕВ = 37,
 /// Left стрелка.
	LINE_FEED = 10,
 	LEFT_MENU = 164,
 /// Left Alt.
	LEFT_ШИФТ = 160,
 	LEFT_WIN = 91,
 /// Left Windows logo.
	MENU = 18,
 /// Alt.
	MULTIPLY = 106,
 	NEXT = 34,
 /// Page down.
	NO_NAME = 252,
 // Reserved for future use.
	NUM_LOCK = 144,
 	OEM8 = 223,
 // OEM specific.
	OEM_CLEAR = 254,

	PA1 = 253,

	PAGE_DOWN = 34,
 	PAGE_UP = 33,
 	PAUSE = 19,
 	PLAY = 250,
 	PRINT = 42,
 	PRINT_SCREEN = 44,
 	PROCESS_KEY = 229,
 	RIGHT_КОНТРОЛ = 163,
 /// Right Ctrl.
	RETURN = 13,
 	ПРАВ = 39,
 /// Right стрелка.
	RIGHT_MENU = 165,
 /// Right Alt.
	RIGHT_ШИФТ = 161,
 	RIGHT_WIN = 92,
 /// Right Windows logo.
	ПРОМОТКА = 145,
 /// Scroll lock.
	SELECT = 41,
 	SEPARATOR = 108,
 	ШИФТ_KEY = 16,
 	SNAPSHOT = 44,
 /// Print screen.
	SPACE = 32,
 	SPACEBAR = SPACE,
 // Extra.
	SUBTRACT = 109,
 	TAB = 9,
 	UP = 38,
 /// Up стрелка.
	ZOOM = 251,
 	
	// Windows 2000+
	BROWSER_BACK = 166,
 	BROWSER_FAVORITES = 171,
 
	BROWSER_FORWARD = 167,
 
	BROWSER_HOME = 172,
 
	BROWSER_REFRESH = 168,
 
	BROWSER_SEARCH = 170,
 
	BROWSER_STOP = 169,
 
	LAUNCH_APPLICATION1 = 182,
 	LAUNCH_APPLICATION2 = 183,
 
	LAUNCH_MAIL = 180,
 
	MEDIA_NEXT_TRACK = 176,
 	MEDIA_PLAY_PAUSE = 179,
 
	MEDIA_PREVIOUS_TRACK = 177,
 
	MEDIA_STOP = 178,
 
	OEM_BACKSLASH = 226,
 // OEM angle bracket or backslash.
	OEM_CLOSE_BRACKETS = 221,

	OEM_COMMA = 188,
	OEM_MINUS = 189,
	OEM_OPEN_BRACKETS = 219,
	OEM_PERIOD = 190,
	OEM_PIPE = 220,
	OEM_PLUS = 187,
	OEM_QUESTION = 191,
	OEM_QUOTES = 222,
	OEM_SEMICOLON = 186,
	OEM_TILDE = 192,
	SELECT_MEDIA = 181,
 	VOLUME_DOWN = 174,
 	VOLUME_MUTE = 173, 
	VOLUME_UP = 175, 
	
	/// Bit mask to extract key code from key значение.
	КОД_КЛАВИШИ = 0xFFFF,
	
	/// Bit mask to extract модификаторы from key значение.
	МОДИФИКАТОРЫ = 0xFFFF0000,
}


enum ПКнопкиМыши: бцел // docmain
{
	/// No mouse buttons задано.
	НЕУК =      0,
	
	ЛЕВ =      0x100000,
 	ПРАВ =     0x200000, 
	СРЕДН =    0x400000, 
	
	// Windows 2000+
	//XBUTTON1 =  0x800000,
	//XBUTTON2 =  0x1000000,
}


enum ПСостУст: ббайт
{
	НЕУСТ = 0x0000,
 	УСТАНОВЛЕНО = 0x0001, 
	НЕОПРЕД = 0x0002, 
}


struct Сообщение // docmain
{
	union
	{
		struct
		{
			УОК уок; 
			UINT сооб; 
			WPARAM парам1; 
			LPARAM парам2; 
		}
		
		package MSG _винСооб; // .time and .тчк are not always valid.
	}
	LRESULT результат; 	
	
	/// Construct а Сообщение struct.
	static Сообщение opCall(УОК уок, UINT сооб, WPARAM парам1, LPARAM парам2)
	{
		Сообщение m;
		m.уок = уок;
		m.сооб = сооб;
		m.парам1 = парам1;
		m.парам2 = парам2;
		m.результат = 0;
		return m;
	}
}


interface ИФильтрСооб // docmain
{
		// Return нет to allow the сообщение to be dispatched.
	// Filter functions cannot modify messages.
	бул предфильтровкаСообщения(inout Сообщение m);
}


abstract class ЖдиУк
{
	const цел WAIT_TIMEOUT = WAIT_TIMEOUT; // DMD 1.028: needs fqn, otherwise conflicts with std.thread
	const HANDLE НЕВЕРНХЭНДЛ = НЕВЕРНХЭНДЛ;
	
	
	this()
	{
		h = НЕВЕРНХЭНДЛ;
	}
	
	
	// Used internally.
	this(HANDLE h, бул owned = да)
	{
		this.h = h;
		this.owned = owned;
	}
	
	
	HANDLE указатель() // getter
	{
		return h;
	}
	
	
	проц указатель(HANDLE h) // setter
	{
		this.h = h;
	}
	
	
	проц закрой()
	{
		ЗакройДескр(h);
		h = НЕВЕРНХЭНДЛ;
	}
	
	
	~this()
	{
		if(owned)
			закрой();
	}
	
	
	private static DWORD _wait(ЖдиУк[] уки, BOOL ждатьВсе, DWORD msTimeout)
	{
		// Some implementations fail with > 64 уки, but that will return WAIT_FAILED;
		// все implementations fail with >= 128 уки due to WAIT_ABANDONED_0 being 128.
		if(уки.length >= 128)
			goto fail;
		
		DWORD результат;
		HANDLE* hs;
		//hs = new HANDLE[уки.length];
		hs = cast(HANDLE*)alloca(HANDLE.sizeof * уки.length);
		
		foreach(т_мера i, ЖдиУк wh; уки)
		{
			hs[i] = wh.указатель;
		}
		
		результат = ЖдиНесколькоОбъектов(уки.length, hs, ждатьВсе, msTimeout);
		if(WAIT_FAILED == результат)
		{
			fail:
			throw new ВизИскл("Не дождались...");
		}
		return результат;
	}
	
	
	static проц ждиВсе(ЖдиУк[] уки)
	{
		return ждиВсе(уки, INFINITE);
	}
	
	
	static проц ждиВсе(ЖдиУк[] уки, DWORD msTimeout)
	{
		_wait(уки, да, msTimeout);
	}
	
	
	static цел ждиЛюбое(ЖдиУк[] уки)
	{
		return ждиЛюбое(уки, INFINITE);
	}
	
	
	static цел ждиЛюбое(ЖдиУк[] уки, DWORD msTimeout)
	{
		DWORD результат;
		результат = _wait(уки, нет, msTimeout);
		return cast(цел)результат; // Same return инфо.
	}
	
	
	проц ждиОдно()
	{
		return ждиОдно(INFINITE);
	}
	
	
	проц ждиОдно(DWORD msTimeout)
	{
		DWORD результат;
		результат = ЖдиОдинОбъект(указатель, msTimeout);
		if(WAIT_FAILED == результат)
			throw new ВизИскл("Не дождались...");
	}
	
	
	private:
	HANDLE h;
	бул owned = да;
}


interface ИАсинхРез
{
	ЖдиУк ждиУкАсинх(); // getter
	
	// Usually just returns нет.
	бул выполненоСинхронно(); // getter
	
	// When да, it is safe to release its ресурсы.
	бул выполнено_ли(); // getter
}


/+
class AsyncResult: ИАсинхРез
{
}
+/


interface ИУпрЭлтКнопка // docmain
{
		ПРезДиалога резДиалога(); // getter
	
	проц резДиалога(ПРезДиалога); // setter
	
		проц сообщиДеф(бул); // True if default кнопка.
	
		проц выполниКлик(); // Raise клик событие.
}


enum ПРезДиалога: ббайт // docmain
{
	НЕУК, 	
	АБОРТ = IDABORT,
 	ОТМЕНА = IDCANCEL,
 	ИГНОРИРОВАТЬ = IDIGNORE,
 	НЕТ = IDNO,
 	ОК = IDOK,
 	ПОВТОРИТЬ = IDRETRY,
 	ДА = IDYES, 	
	// Extra.
	ЗАКРЫТЬ = IDCLOSE,
	СПРАВКА = IDHELP,
}


interface ИРезДиалога
{
	// 	ПРезДиалога резДиалога(); // getter
	// 
	проц резДиалога(ПРезДиалога); // setter
}


enum ППорядокСортировки: ббайт
{
	НЕУК, 	
	ВОЗРАСТАНИЕ,
 	УМЕНЬШЕНИЕ, 
}


enum ПВид: ббайт
{
	БОЛЬШАЯ_ПИКТ,
 	МАЛЕНЬКАЯ_ПИКТ,
 	СПИСОК,
 	ДЕТАЛИ,
 }


enum ПорцияГраницЭлемента: ббайт
{
	ВСЯ,
 	ПИКТОГРАММА,
 	ТОЛЬКО_ЭЛТ,
 /// Excludes other stuff like check boxes.
	ЯРЛЫК,
 /// Item's текст.
}


enum ПАктивацияПункта: ббайт
{
	СТАНДАРТ,
 	ОДИН_КЛИК,
 	ДВА_КЛИКА,
 }


enum СтильЗаголовкаСтолбца: ббайт
{
	КЛИКАЕМЫЙ,
 	НЕКЛИКАЕМЫЙ,
 	НЕУК,
 /// No столбец header.
}


enum ПСтильКромки: ббайт
{
	НЕУК,
 	
	ФИКС_3М,
 	ФИКС_ЕДИН,
 
}


enum ПлоскийСтиль: ббайт
{
	СТАНДАРТ,
 	FLAT, 
	POPUP, 
	SYSTEM, 
}


enum ПНаружность: ббайт
{
	НОРМА,
 	КНОПКА,
 }


enum ПРасположение: ббайт
{
	ВЕРХ_ЛЕВ,
 	НИЗ_ЦЕНТР,
 	НИЗ_ЛЕВ,
 	НИЗ_ПРАВ,
 	ЦЕНТР,
 	ЦЕНТР_ЛЕВ,
 	ЦЕНТР_ПРАВ,
 	ВЕРХ_ЦЕНТР,
 	ВЕРХ_ПРАВ,
 }


enum ПРегистрСимволов: ббайт
{
	НОРМА,
 	ПРОПИСЬ,
 	ЗАГ,
 }


// Not флаги.
enum ППолосыПрокрутки: ббайт
{
	НЕУК, 	
	ГОРИЗ,
 	ВЕРТ, 
	ОБА, 
}


enum ПГоризРасположение: ббайт
{
	ЛЕВ,
 	ПРАВ, 
	ЦЕНТР, 
}


enum ПРежимОтрисовки: ббайт
{
	НОРМА,
 	OWNER_DRAW_FIXED,
 	OWNER_DRAW_VARIABLE, 
}


enum ПСостОтрисовкиЭлемента: бцел
{
	НЕУК = 0,
 	ВЫДЕЛЕНО = 1, 
	ОТКЛЮЧЕНО = 2, 
	УСТАНОВЛЕНО = 8, 
	ФОКУС = 0x10, 
	ПО_УМОЛЧАНИЮ = 0x20, 
	HOT_LIGHT = 0x40, 
	БЕЗ_АКСЕЛЕРАТОРОВ = 0x80, 
	НЕАКТИВНО = 0x100, 
	NO_FOCUS_RECT = 0x200, 
	COMBO_BOX_EDIT = 0x1000, 
}


enum ПСправаНалево: ббайт
{
	НАСЛЕДОВАТЬ = 2,
 	ДА = 1, 
	НЕТ = 0, 
}


enum ГлубинаЦвета: ббайт
{
	БИТ4 = 0x04,
 	БИТ8 = 0x08, 
	БИТ16 = 0x10, 
	БИТ24 = 0x18, 
	БИТ32 = 0x20, 
}


class АргиСобРис: АргиСоб
{
		this(Графика графика, Прям клипПрям)
	{
		з = графика;
		cr = клипПрям;
	}
	
	
		final Графика графика() // getter
	{
		return з;
	}
	
	
		final Прям клипПрямоугольник() // getter
	{
		return cr;
	}
	
	
	private:
	Графика з;
	Прям cr;
}


class АргиСобОтмены: АргиСоб
{
		// Initialize отмена to нет.
	this()
	{
		cncl = нет;
	}
	
	
	this(бул отмена)
	{
		cncl = отмена;
	}
	
	
		final проц отмена(бул подтвержд) // setter
	{
		cncl = подтвержд;
	}
	
	
	final бул отмена() // getter
	{
		return cncl;
	}
	
	
	private:
	бул cncl;
}


class АргиСобКлавиш: АргиСоб
{
		this(ПКлавиши клавиши)
	{
		ks = клавиши;
	}
	
	
		final бул альт() // getter
	{
		return (ks & ПКлавиши.АЛЬТ) != 0;
	}
	
	
		final бул упрэлт() // getter
	{
		return (ks & ПКлавиши.КОНТРОЛ) != 0;
	}
	
	
		final проц обрабатывается(бул подтвержд) // setter
	{
		рука = подтвержд;
	}
	
		final бул обрабатывается() // getter
	{
		return рука;
	}
	
	
		final ПКлавиши кодКлавиши() // getter
	{
		return ks & ПКлавиши.КОД_КЛАВИШИ;
	}
	
	
		final ПКлавиши данныеКлавиши() // getter
	{
		return ks;
	}
	
	
		// -данныеКлавиши- as an цел.
	final цел значениеКлавиши() // getter
	{
		return cast(цел)ks;
	}
	
	
		final ПКлавиши модификаторы() // getter
	{
		return ks & ПКлавиши.МОДИФИКАТОРЫ;
	}
	
	
		final бул шифт() // getter
	{
		return (ks & ПКлавиши.ШИФТ) != 0;
	}
	
	
	private:
	ПКлавиши ks;
	бул рука = нет;
}


class АргиСобНажатияКлав: АргиСобКлавиш
{
		this(дим ch)
	{
		this(ch, (ch >= 'A' && ch <= 'Z') ? ПКлавиши.ШИФТ : ПКлавиши.НЕУК);
	}
	
	
	this(дим ch, ПКлавиши модификаторы)
	in
	{
		assert((модификаторы & ПКлавиши.МОДИФИКАТОРЫ) == модификаторы, "модификаторы parameter can only contain модификаторы");
	}
	body
	{
		_keych = ch;
		
		цел vk;
		if(использоватьЮникод)
			vk = 0xFF & VkKeyScanW(ch);
		else
			vk = 0xFF & VkKeyScanA(cast(сим)ch);
		
		super(cast(ПКлавиши)(vk | модификаторы));
	}
	
	
		final дим симКлавиши() // getter
	{
		return _keych;
	}
	
	
	private:
	дим _keych;
}


class АргиСобМыши: АргиСоб
{
		// -дельта- is mouse wheel rotations.
	this(ПКнопкиМыши кнопка, цел клики, цел ш, цел в, цел дельта)
	{
		кноп = кнопка;
		clks = клики;
		_x = ш;
		_y = в;
		dlt = дельта;
	}
	
	
		final ПКнопкиМыши кнопка() // getter
	{
		return кноп;
	}
	
	
		final цел клики() // getter
	{
		return clks;
	}
	
	
		final цел дельта() // getter
	{
		return dlt;
	}
	
	
		final цел ш() // getter
	{
		return _x;
	}
	
	
		final цел в() // getter
	{
		return _y;
	}
	
	
	private:
	ПКнопкиМыши кноп;
	цел clks;
	цел _x, _y;
	цел dlt;
}


/+
class LabelEditEventArgs: АргиСоб
{
		this(цел индекс)
	{
		
	}
	
	
	this(цел индекс, Ткст labelText)
	{
		this.idx = индекс;
		this.ltxt = labelText;
	}
	
	
		final проц cancelEdit(бул подтвержд) // setter
	{
		cancl = подтвержд;
	}
	
	
	final бул cancelEdit() // getter
	{
		return cancl;
	}
	
	
		// The текст of the надпись's edit.
	final Ткст надпись() // getter
	{
		return ltxt;
	}
	
	
		// Gets the item's индекс.
	final цел item() // getter
	{
		return idx;
	}
	
	
	private:
	цел idx;
	Ткст ltxt;
	бул cancl = нет;
}
+/


class АргиСобКликаСтолбца: АргиСоб
{
		this(цел col)
	{
		this.col = col;
	}
	
	
		final цел столбец() // getter
	{
		return col;
	}
	
	
	private:
	цел col;
}


class АргиСобПеретягаДанных: АргиСоб
{
		this(Графика з, Шрифт f, Прям к, цел i, ПСостОтрисовкиЭлемента dis)
	{
		this(з, f, к, i , dis, Цвет.пуст, Цвет.пуст);
	}
	
	
	this(Графика з, Шрифт f, Прям к, цел i, ПСостОтрисовкиЭлемента dis, Цвет fc, Цвет bc)
	{
		gpx = з;
		fnt = f;
		rect = к;
		idx = i;
		distate = dis;
		пцвет = fc;
		зцвет = bc;
	}
	
	
		final Цвет цветФона() // getter
	{
		return зцвет;
	}
	
	
		final Прям границы() // getter
	{
		return rect;
	}
	
	
		final Шрифт шрифт() // getter
	{
		return fnt;
	}
	
	
		final Цвет цветПП() // getter
	{
		return пцвет;
	}
	
	
		final Графика графика() // getter
	{
		return gpx;
	}
	
	
		final цел индекс() // getter
	{
		return idx;
	}
	
	
		final ПСостОтрисовкиЭлемента состояние() // getter
	{
		return distate;
	}
	
	
		проц рисуйФон()
	{
		/+
		HBRUSH hbr;
		RECT _rect;
		
		hbr = зцвет.создайКисть();
		try
		{
			rect.дайПрям(&_rect);
			FillRect(gpx.указатель, &_rect, hbr);
		}
		finally
		{
			DeleteObject(hbr);
		}
		+/
		
		gpx.заполниПрямоугольник(зцвет, rect);
	}
	
	
		проц рисуйПрямФокуса()
	{
		if(distate & ПСостОтрисовкиЭлемента.ФОКУС)
		{
			RECT _rect;
			rect.дайПрям(&_rect);
			DrawFocusRect(gpx.указатель, &_rect);
		}
	}
	
	
	private:
	Графика gpx;
	Шрифт fnt; // Suggestion; the родитель's шрифт.
	Прям rect;
	цел idx;
	ПСостОтрисовкиЭлемента distate;
	Цвет пцвет, зцвет; // Suggestion; depends on item состояние.
}


class АргиСобИзмеренияЭлемента: АргиСоб
{
		this(Графика з, цел индекс, цел высотаПункта)
	{
		gpx = з;
		idx = индекс;
		iheight = высотаПункта;
	}
	
	
	this(Графика з, цел индекс)
	{
		this(з, индекс, 0);
	}
	
	
		final Графика графика() // getter
	{
		return gpx;
	}
	
	
		final цел индекс() // getter
	{
		return idx;
	}
	
	
		final проц высотаПункта(цел высота) // setter
	{
		iheight = высота;
	}
	
	
	final цел высотаПункта() // getter
	{
		return iheight;
	}
	
	
		final проц ширинаЭлемента(цел ширина) // setter
	{
		iwidth = ширина;
	}
	
	
	final цел ширинаЭлемента() // getter
	{
		return iwidth;
	}
	
	
	private:
	Графика gpx;
	цел idx, iheight, iwidth = 0;
}


export extern(D) class Курсор // docmain
{
	private static Курсор _cur;
	
	export:
	
	// Used internally.
	this(КУРСОР hcur, бул owned = да)
	{
		this.hcur = hcur;
		this.owned = owned;
	}
	
	
	~this()
	{
		if(owned)
			вымести();
	}
	
	проц вымести()
	{
		assert(owned);
		DestroyCursor(hcur);
		hcur = КУРСОР.init;
	}
	
	
		static проц текущий(Курсор cur) // setter
	{
		// Keep а reference so that it doesn't get garbage collected until установи again.
		_cur = cur;
		
		SetCursor(cur ? cur.hcur : КУРСОР.init);
	}
	
	
	static Курсор текущий() // getter
	{
		КУРСОР hcur = GetCursor();
		return hcur ? new Курсор(hcur, нет) : пусто;
	}
	
	
		static проц клип(Прям к) // setter
	{
		RECT rect;
		к.дайПрям(&rect);
		ClipCursor(&rect);
	}
	
	
	static Прям клип() // getter
	{
		RECT rect;
		GetClipCursor(&rect);
		return Прям(&rect);
	}
	
	
		final КУРСОР указатель() // getter
	{
		return hcur;
	}
	
	
	/+
	// TODO:
	final Размер размер() // getter
	{
		Размер результат;
		ICONINFO iinfo;
		
		if(GetIconInfo(hcur, &iinfo))
		{
			
		}
		
		return результат;
	}
	+/
	
	
		// Uses the actual размер.
	final проц рисуй(Графика з, Точка тчк)
	{
		DrawIconEx(з.указатель, тчк.ш, тчк.в, hcur, 0, 0, 0, HBRUSH.init, DI_NORMAL);
	}
	
	/+
	
	// Should not stretch if bigger, but should crop if smaller.
	final проц рисуй(Графика з, Прям к)
	{
	}
	+/
	
	
		final проц рисуйРастяни(Графика з, Прям к)
	{
		// DrawIconEx operates differently if the ширина or высота is zero
		// so bail out if zero and pretend the zero размер курсор was drawn.
		цел ширина = к.ширина;
		if(!ширина)
			return;
		цел высота = к.высота;
		if(!высота)
			return;
		
		DrawIconEx(з.указатель, к.ш, к.в, hcur, ширина, высота, 0, HBRUSH.init, DI_NORMAL);
	}
	
	
	override т_рав opEquals(Объект o)
	{
		Курсор cur = cast(Курсор)o;
		if(!cur)
			return 0; // Not equal.
		return opEquals(cur);
	}
	
	
	т_рав opEquals(Курсор cur)
	{
		return hcur == cur.hcur;
	}
	
	
	/// покажи/скрой the текущий mouse курсор; reference counted.
	// покажи/скрой are ref counted.
	static проц скрой()
	{
		ShowCursor(нет);
	}
	
	
	// покажи/скрой are ref counted.
	static проц покажи()
	{
		ShowCursor(да);
	}
	
	
	/// The положение of the текущий mouse курсор.
	static проц положение(Точка тчк) // setter
	{
		SetCursorPos(тчк.ш, тчк.в);
	}
	
	
	static Точка положение() // getter
	{
		Точка тчк;
		GetCursorPos(&тчк.точка);
		return тчк;
	}
	
	
	private:
	КУРСОР hcur;
	бул owned = да;
}


export extern(D)  class Курсоры // docmain
{
	private this() {}
	
	export:
	static:
	
		Курсор пускПриложения() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_APPSTARTING), нет); }
	
		Курсор стрелка() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_ARROW), нет); }
	
		Курсор крест() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_CROSS), нет); }
	
		//Курсор default() // getter
	Курсор дефолтныйКурсор() // getter
	{ return стрелка; }
	
		Курсор рука() // getter
	{
		version(SUPPORTS_HAND_CURSOR) // Windows 98+
		{
			return new Курсор(LoadCursorA(экз.init, IDC_HAND), нет);
		}
		else
		{
			static КУРСОР hcurHand;
			
			if(!hcurHand)
			{
				hcurHand = LoadCursorA(экз.init, IDC_HAND);
				if(!hcurHand) // Must be Windows 95, so загрузка the курсор from winhlp32.exe.
				{
					UINT len;
					сим[МАКС_ПУТЬ] winhlppath = void;
					
					len = GetWindowsDirectoryA(winhlppath.ptr, winhlppath.length - 16);
					if(!len || len > winhlppath.length - 16)
					{
						load_failed:
						return стрелка; // Just fall back to а normal стрелка.
					}
					strcpy(winhlppath.ptr + len, "\\winhlp32.exe");
					
					экз hinstWinhlp;
					hinstWinhlp = LoadLibraryExA(winhlppath.ptr, HANDLE.init, LOAD_LIBRARY_AS_DATAFILE);
					if(!hinstWinhlp)
						goto load_failed;
					
					КУРСОР hcur;
					hcur = LoadCursorA(cast(HINSTANCE) hinstWinhlp, cast(ткст0)106);
					if(!hcur) // No such курсор resource.
					{
						FreeLibrary(cast(HINSTANCE) hinstWinhlp);
						goto load_failed;
					}
					hcurHand = CopyCursor(hcur);
					if(!hcurHand)
					{
						FreeLibrary(cast(HINSTANCE) hinstWinhlp);
						//throw new ВизИскл("Unable to копируй курсор resource");
						goto load_failed;
					}
					
					FreeLibrary(cast(HINSTANCE) hinstWinhlp);
				}
			}
			
			assert(hcurHand);
			// Copy the курсор and own it here so that it's safe to вымести it.
			return new Курсор(CopyCursor(hcurHand));
		}
	}
	
		Курсор помощь() // getter
	{
		КУРСОР hcur;
		hcur = LoadCursorA(экз.init, IDC_HELP);
		if(!hcur) // IDC_HELP might not be supported on Windows 95, so fall back to а normal стрелка.
			return стрелка;
		return new Курсор(hcur);
	}
	
		Курсор гСплит() // getter
	{
		// ...
		return sizeNS;
	}
	
	
	Курсор вСплит() // getter
	{
		// ...
		return sizeWE;
	}
	
	
		Курсор айБим() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_IBEAM), нет); }
	
		Курсор нет() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_NO), нет); }
	
	
		Курсор sizeAll() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZEALL), нет); }
	
	
	Курсор sizeNESW() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZENESW), нет); }
	
	
	Курсор sizeNS() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZENS), нет); }
	
	
	Курсор sizeNWSE() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZENWSE), нет); }
	
	
	Курсор sizeWE() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_SIZEWE), нет); }
	
	
	/+
		// Insertion Точка.
	Курсор upArrow() // getter
	{
		// ...
	}
	+/
	
		Курсор ждиКурсор() // getter
	{ return new Курсор(LoadCursorA(экз.init, IDC_WAIT), нет); }
}

