//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.panel;

private import viz.control, viz.base, viz.x.winapi;


class Panel: УпрЭлтКонтейнер // docmain
{
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
	
	
	this()
	{
		//ктрлСтиль |= ПСтилиУпрЭлта.ВЫДЕЛЕНИЕ | ПСтилиУпрЭлта.КОНТЕЙНЕР;
		ктрлСтиль |= ПСтилиУпрЭлта.КОНТЕЙНЕР;
		/+ окСтиль |= WS_TABSTOP; +/ // Should WS_TABSTOP be установи?
		//окДопСтиль |= WS_EX_CONTROLPARENT; // Allow tabbing through отпрыски. ?
	}
}

