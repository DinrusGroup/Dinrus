module viz.event;

import tpl.traits, viz.control, viz.common;

// Create an событие обработчик; old стиль.
deprecated template Событие(TArgs : АргиСоб = АргиСоб)
{
	alias Событие!(Объект, TArgs) Событие;
}

/** Managing событие обработчики.
    Параметры:
		T1 = the отправитель тип.
		T2 = the событие arguments тип.
**/
template Событие(T1, T2) // docmain
{
	/// Managing событие обработчики.
	struct Событие // docmain
	{
		alias проц delegate(T1, T2) Обработчик; /// Событие обработчик тип.
		
		
		/// Add an событие обработчик with the exact тип.
		проц добавитьСоответствОбработчик(Обработчик обработчик)
		in
		{
			assert(обработчик);
		}
		body
		{
			if(!_массив.length)
			{
				_массив = new Обработчик[2];
				_массив[1] = обработчик;
				охлади();
			}
			else
			{
				if(!горяч_ли())
				{
					_массив ~= обработчик;
				}
				else // Hot.
				{
					_массив = _массив ~ (&обработчик)[0 .. 1]; // Force duplicate.
					охлади();
				}
			}
		}
		
		
		/// Add an событие обработчик with parameter contravariance.
		проц добавитьОбработчик(TDG)(TDG обработчик)
		in
		{
			assert(обработчик);
		}
		body
		{
			mixin _оцениОбработчик!(TDG);
			
			добавитьСоответствОбработчик(cast(Обработчик)обработчик);
		}
		
		
		/// Shortcut for добавитьОбработчик().
		проц opCatAssign(TDG)(TDG обработчик)
		{
			добавитьОбработчик!(TDG)(обработчик);
		}
		
		
		/// Remove the задано событие обработчик with the exact Обработчик тип.
		проц удалитьОбработчикСоответствующе(Обработчик обработчик)
		{
			if(!_массив.length)
				return;
			
			т_мера iw;
			for(iw = 1; iw != _массив.length; iw++)
			{
				if(обработчик == _массив[iw])
				{
					if(iw == 1 && _массив.length == 2)
					{
						_массив = пусто;
						break;
					}
					
					if(iw == _массив.length - 1)
					{
						_массив[iw] = пусто;
						_массив = _массив[0 .. iw];
						break;
					}
					
					if(!горяч_ли())
					{
						_массив[iw] = _массив[_массив.length - 1];
						_массив[_массив.length - 1] = пусто;
						_массив = _массив[0 .. _массив.length - 1];
					}
					else // Hot.
					{
						_массив = _массив[0 .. iw] ~ _массив[iw + 1 .. _массив.length]; // Force duplicate.
						охлади();
					}
					break;
				}
			}
		}
		
		
		/// Remove the задано событие обработчик with parameter contravariance.
		проц удалиОбработчик(TDG)(TDG обработчик)
		{
			mixin _оцениОбработчик!(TDG);
			
			удалитьОбработчикСоответствующе(cast(Обработчик)обработчик);
		}
		
		
		/// Fire the событие обработчики.
		проц opCall(T1 v1, T2 v2)
		{
			if(!_массив.length)
				return;
			установиГорячим();
			
			Обработчик[] local;
			local = _массив[1 .. _массив.length];
			foreach(Обработчик обработчик; local)
			{
				обработчик(v1, v2);
			}
			
			if(!_массив.length)
				return;
			охлади();
		}
		
		
				цел opApply(цел delegate(Обработчик) дг)
		{
			if(!_массив.length)
				return 0;
			установиГорячим();
			
			цел результат = 0;
			
			Обработчик[] local;
			local = _массив[1 .. _массив.length];
			foreach(Обработчик обработчик; local)
			{
				результат = дг(обработчик);
				if(результат)
					break;
			}
			
			if(_массив.length)
				охлади();
			
			return результат;
		}
		
		
				бул hasHandlers() // getter
		{
			return _массив.length > 1;
		}
		
		
		// Use opApply and hasHandlers instead.
		deprecated Обработчик[] обработчики() // getter
		{
			if(!hasHandlers)
				return пусто;
			return _массив[1 .. _массив.length].dup; // Because _массив can be изменён. Function is deprecated anyway.
		}
		
		
		private:
		Обработчик[] _массив; // Not what it seems.
		
		
		проц установиГорячим()
		{
			assert(_массив.length);
			_массив[0] = cast(Обработчик)&установиГорячим; // Non-пусто, GC friendly.
		}
		
		
		проц охлади()
		{
			assert(_массив.length);
			_массив[0] = пусто;
		}
		
		
		Обработчик горяч_ли()
		{
			assert(_массив.length);
			return _массив[0];
		}
		
		
		// Thanks to Tomasz "h3r3tic" Stachowiak for his assistance.
		template _оцениОбработчик(TDG)
		{
			static assert(is(TDG == delegate), "viz: Обработчик события должен быть делегатом");
			
			alias КортежТипаПараметров!(TDG) TDGParams;
			static assert(TDGParams.length == 2, "viz: Обработчику событий требуется ровно 2 параметра");
			
			static if(is(TDGParams[0] : Объект))
			{
				static assert(is(T1: TDGParams[0]), "viz: Параметр 1 обработчика события не соответствует типу");
			}
			else
			{
				static assert(is(T1 == TDGParams[0]), "viz: Параметр 1 обработчика события не соответствует типу");
			}
			
			static if(is(TDGParams[1] : Объект))
			{
				static assert(is(T2 : TDGParams[1]), "viz: Параметр 2 обработчика события не соответствует типу");
			}
			else
			{
				static assert(is(T2 == TDGParams[1]), "viz: Параметр 2 обработчика события не соответствует типу");
			}
		}
	}
}


/// Основа событие arguments.
/*export*/ class АргиСоб // docmain
{
/*export*/
	/+
	private static byte[] buf;
	private import std.gc; // <-- ...
	
	
	new(бцел разм)
	{
		ук результат;
		
		// synchronized // Slows it down а lot.
		{
			if(разм > buf.length)
				buf = new byte[100 + разм];
			
			результат = buf[0 .. разм];
			buf = buf[разм .. buf.length];
		}
		
		// std.gc.addRange(результат, результат + разм); // So that it can contain pointers.
		return результат;
	}
	+/
	
	
	/+
	delete(ук p)
	{
		std.gc.removeRange(p);
	}
	+/
	
	
	//private static const АргиСоб _e;
	private static АргиСоб _e;
	
	
	static this()
	{
		_e = new АргиСоб;
	}
		
	/// Property: get а reusable, _empty АргиСоб.
	static АргиСоб пуст() // getter
	{
		return _e;
	}
}

// Simple событие обработчик.
alias Событие!(Объект, АргиСоб) СобОбработчик; // deprecated


/*export*/ class АргиСобИсклНити: АргиСоб
{
/*export*/
		// The исключение that occured.
	this(Объект исключение)
	{
		except = исключение;
	}
	
	
		final Объект исключение() // getter
	{
		return except;
	}
	
	
	private:
	Объект except;
}

//////////////////////
/*export*/ class АргиСобУпрЭлта: АргиСоб
{
/*export*/
		this(УпрЭлт упрэлм)
	{
		this.упрэлм = упрэлм;
	}
	
	
		final УпрЭлт упрэлт() // getter
	{
		return упрэлм;
	}
	
	
	private:
	УпрЭлт упрэлм;
}


/*export*/  class АргиСобСправка: АргиСоб
{
/*export*/
		this(Точка позМыши)
	{
		mpos = позМыши;
	}
	
	
		final проц обрабатывается(бул подтвержд) // setter
	{
		рука = подтвержд;
	}
	
	
	final бул обрабатывается() // getter
	{
		return рука;
	}
	
	
		final Точка позМыши() // getter
	{
		return mpos;
	}
	
	
	private:
	Точка mpos;
	бул рука = нет;
}


/*export*/  class АргиСобИнвалидировать: АргиСоб
{
/*export*/
		this(Прям невернПрям)
	{
		ir = невернПрям;
	}
	
	
	final Прям невернПрям() // getter
	{
		return ir;
	}
	
	
	private:
	Прям ir;
}


/*export*/ class АргиСобРасположение: АргиСоб
{
/*export*/
		this(УпрЭлт задействованныйУпрэлт)
	{
		ac = задействованныйУпрэлт;
	}
	
	
		final УпрЭлт задействованныйУпрэлт() // getter
	{
		return ac;
	}
	
	
	private:
	УпрЭлт ac;
}


/*export*/ class АргиСобДрэг: АргиСоб
	{
	/*export*/
			this(ИОбъектДанных объДанных, цел состКл, цел ш, цел в,	ПЭффектыДД разрешённыйЭффект, ПЭффектыДД эффект)
		{
			_dobj = объДанных;
			_состКл = состКл;
			_x = ш;
			_y = в;
			_разрешённыйЭффект = разрешённыйЭффект;
			_эффект = эффект;
		}
		
		
				final ПЭффектыДД разрешённыйЭффект() // getter
		{
			return _разрешённыйЭффект;
		}
		
		
				final проц эффект(ПЭффектыДД новыйЭффект) // setter
		{
			_эффект = новыйЭффект;
		}
		
		
		
		final ПЭффектыДД эффект() // getter
		{
			return _эффект;
		}
		
		
				final ИОбъектДанных данные() // getter
		{
			return _dobj;
		}
		
		
				// State of упрэлм, alt, шифт, and mouse buttons.
		final цел состКл() // getter
		{
			return _состКл;
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
		ИОбъектДанных _dobj;
		цел _состКл;
		цел _x, _y;
		ПЭффектыДД _разрешённыйЭффект, _эффект;
	}
	
	
/*export*/ class АргиСобФидбэк: АргиСоб
	{
	/*export*/
				this(ПЭффектыДД эффект, бул испДефКурсоры)
		{
			_эффект = эффект;
			udefcurs = испДефКурсоры;
		}
		
		
				final ПЭффектыДД эффект() // getter
		{
			return _эффект;
		}
		
		
				final проц испДефКурсоры(бул подтвержд) // setter
		{
			udefcurs = подтвержд;
		}
		
		
		final бул испДефКурсоры() // getter
		{
			return udefcurs;
		}
		
		
		private:
		ПЭффектыДД _эффект;
		бул udefcurs;
	}
	
	
/*export*/ class АргиСобДрэгОпросПродолжить: АргиСоб
	{
	/*export*/
		this(цел состКл, бул нажатИскейп, ПДрэгДействие действие)
		{
			_состКл = состКл;
			escp = нажатИскейп;
			_действие = действие;
		}
		
		
				final проц действие(ПДрэгДействие новДействие) // setter
		{
			_действие = новДействие;
		}
		
		
		final ПДрэгДействие действие() // getter
		{
			return _действие;
		}
		
		
				final бул нажатИскейп() // getter
		{
			return escp;
		}
		
		
				// State of упрэлм, alt and шифт.
		final цел состКл() // getter
		{
			return _состКл;
		}
		
		
		private:
		цел _состКл;
		бул escp;
		ПДрэгДействие _действие;
	}
//////////////////////////////////////
/*export*/ class АргиСобРис: АргиСоб
{
/*export*/
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

/*export*/ class АргиСобОтмены: АргиСоб
{
/*export*/
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

/*export*/ class АргиСобКлавиш: АргиСоб
{
/*export*/
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

/*export*/ class АргиСобНажатияКлав: АргиСобКлавиш
{
/*export*/
		this(дим ch)
	{
		this(ch, (ch >= 'A' && ch <= 'Z') ? ПКлавиши.ШИФТ : ПКлавиши.НЕУК);
	}
		
	this(дим ch, ПКлавиши модификаторы)
	in
	{
		assert((модификаторы & ПКлавиши.МОДИФИКАТОРЫ) == модификаторы, "параметр модификаторы может содержать только модификаторы");
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


/*export*/ class АргиСобМыши: АргиСоб
{
/*export*/
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


/*export*/ class АргиСобКликаСтолбца: АргиСоб
{
/*export*/
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


/*export*/ class АргиСобПеретягаДанных: АргиСоб
{
/*export*/
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
		ПРЯМ _rect;
		
		hbr = зцвет.createBrush();
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
			ПРЯМ _rect;
			rect.дайПрям(&_rect);
			DrawFocusRect(gpx.указатель,cast(RECT*) &_rect);
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


/*export*/ class АргиСобИзмеренияЭлемента: АргиСоб
{
/*export*/
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

// The Форма's быстрыйЗапуск was нажато.
/*export*/ class АргиСобБыстрЗапускаФормы: АргиСоб
{
/*export*/
		this(ПКлавиши быстрыйЗапуск)
	{
		this._shortcut = быстрыйЗапуск;
	}
	
	
		final ПКлавиши быстрыйЗапуск() // getter
	{
		return _shortcut;
	}
	
	
	private:
	ПКлавиши _shortcut;
}
