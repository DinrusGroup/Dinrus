//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.groupbox;

private import viz.control, viz.base, viz.button, viz.drawing;
private import viz.x.winapi, viz.app, viz.event;


private extern(Windows) проц _initButton();


version(NO_DRAG_DROP)
	version = VIZ_NO_DRAG_DROP;


class GroupBox: СуперКлассУпрЭлта // docmain
{
	override Прям выведиПрямоугольник() // getter
	{
		// Should only calculate this upon setting the текст ?

		цел xw = GetSystemMetrics(SM_CXFRAME);
		цел yw = GetSystemMetrics(SM_CYFRAME);
		//const цел _текстHeight = 13; // Hack.
		return Прям(xw, yw + _текстHeight, клиентРазм.ширина - xw * 2, клиентРазм.высота - yw - _текстHeight - yw);
	}


	override Размер дефРазм() // getter
	{
		return Размер(200, 100);
	}


	version(VIZ_NO_DRAG_DROP) {} else
	{
		проц разрешиБрос(бул dyes) // setter
		{
			//if(dyes)
			//	throw new ВизИскл("Cannot drop on а group box");
			assert(!dyes, "Cannot drop on а group box");
		}

		alias УпрЭлт.разрешиБрос разрешиБрос; // Overload.
	}


	this()
	{
		_initButton();

		if(DEFTEXTHEIGHT_INIT == _defTextHeight)
		{
			//_recalcTextHeight(дефШрифт);
			_recalcTextHeight(шрифт);
			_defTextHeight = _текстHeight;
		}
		_текстHeight = _defTextHeight;

		окСтиль |= BS_GROUPBOX /+ | WS_TABSTOP +/; // Should WS_TABSTOP be установи?
		//окСтиль |= BS_GROUPBOX | WS_TABSTOP;
		//окДопСтиль |= WS_EX_CONTROLPARENT; // ?
		окСтильКласса = стильКлассаКнопка;
		ктрлСтиль |= ПСтилиУпрЭлта.КОНТЕЙНЕР;
	}


	protected проц приИзмененииШрифта(АргиСоб ea)
	{
		_dispChanged();

		super.приИзмененииШрифта(ea);
	}


	protected проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);

		_dispChanged();
	}


	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);

		cp.имяКласса = BUTTON_CLASSNAME;
	}


	protected override проц окПроц(inout Сообщение сооб)
	{
		switch(сооб.сооб)
		{
			case WM_NCHITTEST:
				УпрЭлт._defWndProc(сооб);
				break;

			default:
				super.окПроц(сооб);
		}
	}


	protected override проц приОтрисовкеФона(АргиСобРис ea)
	{
		//УпрЭлт.приОтрисовкеФона(ea); // DMD 0.106: not accessible.

		RECT rect;
		ea.клипПрямоугольник.дайПрям(&rect);
		FillRect(ea.графика.указатель, &rect, hbrBg);
	}


	protected override проц предшОкПроц(inout Сообщение сооб)
	{
		//сооб.результат = CallWindowProcA(первОкПроцКнопки, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцКнопки, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);

		// Work around а Windows issue...
		if(WM_PAINT == сооб.сооб)
		{
			auto hmuxt = GetModuleHandleA("uxtheme.dll");
			if(hmuxt)
			{
				auto isAppThemed = cast(typeof(&IsAppThemed))GetProcAddress(hmuxt, "IsAppThemed");
				if(isAppThemed && isAppThemed())
				{
					auto txt = текст;
					if(txt.length)
					{
						auto openThemeData = cast(typeof(&OpenThemeData))GetProcAddress(hmuxt, "OpenThemeData");
						HTHEME htd;
						if(openThemeData
							&& HTHEME.init != (htd = openThemeData(сооб.уок, "Кнопка")))
						{
							HDC hdc = cast(HDC)сооб.парам1;
							//PAINTSTRUCT ps;
							бул gotdc = нет;
							if(!hdc)
							{
								//hdc = BeginPaint(сооб.уок, &ps);
								gotdc = да;
								hdc = GetDC(сооб.уок);
							}
							try
							{
								scope з = new Графика(hdc, нет); // Not owned.
								auto f = шрифт;
								scope тфмт = new ФорматТекста(ФлагиФорматаТекста.ЕДИНАЯ_СТРОКА);

								Цвет ктрл;
								COLORREF cr;
								auto getThemeColor = cast(typeof(&GetThemeColor))GetProcAddress(hmuxt, "GetThemeColor");
								auto gtcState = включен ? (1 /*PBS_NORMAL*/) : (2 /*GBS_DISABLED*/);
								if(getThemeColor
									&& 0 == getThemeColor(htd, 4 /*BP_GROUPBOX*/, gtcState, 3803 /*TMT_TEXTCOLOR*/, &cr))
									ктрл = Цвет.изКзс(cr);
								else
									ктрл = включен ? цветПП : СистемныеЦвета.серыйТекст; // ?

								Размер tsz = з.мерьТекст(txt, f, тфмт);

								з.заполниПрямоугольник(цветФона, 8, 0, 2 + tsz.ширина + 2, tsz.высота + 2);
								з.рисуйТекст(txt, f, ктрл, Прям(8 + 2, 0, tsz.ширина, tsz.высота), тфмт);
							}
							finally
							{
								//if(ps.hdc)
								//	EndPaint(сооб.уок, &ps);
								if(gotdc)
									ReleaseDC(сооб.уок, hdc);

								auto closeThemeData = cast(typeof(&CloseThemeData))GetProcAddress(hmuxt, "CloseThemeData");
								assert(closeThemeData !is пусто);
								closeThemeData(htd);
							}
						}
					}
				}
			}
		}
	}


	private:

	const цел DEFTEXTHEIGHT_INIT = -1;
	static цел _defTextHeight = DEFTEXTHEIGHT_INIT;
	цел _текстHeight = -1;


	проц _recalcTextHeight(Шрифт f)
	{
		_текстHeight = cast(цел)f.дайРазмер(ЕдиницаГрафики.ПИКСЕЛЬ);
	}


	проц _dispChanged()
	{
		цел old = _текстHeight;
		_recalcTextHeight(шрифт);
		if(old != _текстHeight)
		{
			//if(созданУказатель_ли)
			{
				// Display area изменено...
				// ?
				заморозьРазметку();
				возобновиРазметку(да);
			}
		}
	}
}

