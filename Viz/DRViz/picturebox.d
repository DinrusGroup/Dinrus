//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.picturebox;

private import viz.control, viz.base, viz.drawing, viz.event;
private import viz.x.winapi;


enum PictureBoxSizeMode: ббайт
{
		НОРМА, // Рисунок at upper лево of упрэлт.
	
	AUTO_SIZE, // УпрЭлт sizes to fit рисунок размер.
	
	CENTER_IMAGE, // Рисунок at center of упрэлт.
	
	STRETCH_IMAGE, // Рисунок stretched to fit упрэлт.
}


class PictureBox: УпрЭлт // docmain
{
	this()
	{
		//перемерьПерерисуй = да; // Redrawn manually in приИзмененииРазмера() when necessary.
	}
	
	
		final проц рисунок(Рисунок img) // setter
	{
		if(this.img is img)
			return;
		
		if(_mode == PictureBoxSizeMode.AUTO_SIZE)
		{
			if(img)
				клиентРазм = img.размер;
			else
				клиентРазм = Размер(0, 0);
		}
		
		this.img = img;
		
		if(создан)
			инвалидируй();
		
		onImageChanged(АргиСоб.пуст);
	}
	
	
	final Рисунок рисунок() // getter
	{
		return img;
	}
	
	
		final проц sizeMode(PictureBoxSizeMode sm) // setter
	{
		if(_mode == sm)
			return;
		
		switch(sm)
		{
			case PictureBoxSizeMode.AUTO_SIZE:
				if(img)
					клиентРазм = img.размер;
				else
					клиентРазм = Размер(0, 0);
				break;
			
			case PictureBoxSizeMode.НОРМА:
				break;
			
			case PictureBoxSizeMode.CENTER_IMAGE:
				break;
			
			case PictureBoxSizeMode.STRETCH_IMAGE:
				break;
		}
		
		_mode = sm;
		
		if(создан)
			инвалидируй();
		
		onSizeModeChanged(АргиСоб.пуст);
	}
	
	
	final PictureBoxSizeMode sizeMode() // getter
	{
		return _mode;
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
	
	
	//СобОбработчик sizeModeChanged;
	Событие!(PictureBox, АргиСоб) sizeModeChanged; 	//СобОбработчик imageChanged;
	Событие!(PictureBox, АргиСоб) imageChanged; 	
	
	protected:
	
		проц onSizeModeChanged(АргиСоб ea)
	{
		sizeModeChanged(this, ea);
	}
	
	
		проц onImageChanged(АргиСоб ea)
	{
		imageChanged(this, ea);
	}
	
	
	override проц приОтрисовке(АргиСобРис ea)
	{
		if(img)
		{
			switch(_mode)
			{
				case PictureBoxSizeMode.НОРМА:
				case PictureBoxSizeMode.AUTO_SIZE: // Drawn the same as normal.
					img.рисуй(ea.графика, Точка(0, 0));
					break;
				
				case PictureBoxSizeMode.CENTER_IMAGE:
					{
						Размер isz;
						isz = img.размер;
						img.рисуй(ea.графика, Точка((клиентРазм.ширина  - isz.ширина) / 2,
							(клиентРазм.высота - isz.высота) / 2));
					}
					break;
				
				case PictureBoxSizeMode.STRETCH_IMAGE:
					img.рисуйРастяни(ea.графика, Прям(0, 0, клиентРазм.ширина, клиентРазм.высота));
					break;
			}
		}
		
		super.приОтрисовке(ea);
	}
	
	
	override проц приИзмененииРазмера(АргиСоб ea)
	{
		if(PictureBoxSizeMode.CENTER_IMAGE == _mode || PictureBoxSizeMode.STRETCH_IMAGE == _mode)
			инвалидируй();
		
		super.приИзмененииРазмера(ea);
	}
	
	
	private:
	PictureBoxSizeMode _mode = PictureBoxSizeMode.НОРМА;
	Рисунок img = пусто;
}

