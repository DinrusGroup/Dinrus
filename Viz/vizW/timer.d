//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.timer;

private import viz.common, viz.app;


export class Таймер // docmain
{
export:
	//СобОбработчик тик;
	Событие!(Таймер, АргиСоб) тик; 	
	
		проц включен(бул on) // setter
	{
		if(on)
			старт();
		else
			стоп();
	}
	
	
	бул включен() // getter
	{
		return timerId != 0;
	}
	
	
		final проц интервал(т_мера timeout) // setter
	{
		if(!timeout)
			throw new ВизИскл("Неправильный интервал таймера");
		
		if(this._timeout != timeout)
		{
			this._timeout = timeout;
			
			if(timerId)
			{
				// I don't know if this is the correct behavior.
				// Reset the timer for the new timeout...
				стоп();
				старт();
			}
		}
	}
	
	
	final т_мера интервал() // getter
	{
		return _timeout;
	}
	
	
		final проц старт()
	{
		if(timerId)
			return;
		
		assert(_timeout > 0);
		
		timerId = SetTimer(пусто, 0, _timeout, &процТаймера);
		if(!timerId)
			throw new ВизИскл("Не удаётся запустить таймер");
		всеТаймеры[timerId] = this;
	}
	
	
	final проц стоп()
	{
		if(timerId)
		{
			//delete всеТаймеры[timerId];
			всеТаймеры.remove(timerId);
			KillTimer(пусто, timerId);
			timerId = 0;
		}
	}
	
	
		this()
	{
	}
	
	
	this(проц delegate(Таймер) дг)
	{
		this();
		if(дг)
		{
			this._dg = дг;
			тик ~= &_dgcall;
		}
	}
	
	
	this(проц delegate(Объект, АргиСоб) дг)
	{
		assert(дг !is пусто);
		
		this();
		тик ~= дг;
	}
	
	
	this(проц delegate(Таймер, АргиСоб) дг)
	{
		assert(дг !is пусто);
		
		this();
		тик ~= дг;
	}
	
	
	~this()
	{
		вымести();
	}
	
	
	проц вымести()
	{
		стоп();
	}
	
	
	проц наТик(АргиСоб ea)
	{
		тик(this, ea);
	}
	
	
	private:
	DWORD _timeout = 100;
	UINT timerId = 0;
	проц delegate(Таймер) _dg;
	
	
	проц _dgcall(Объект отправитель, АргиСоб ea)
	{
		assert(_dg !is пусто);
		_dg(this);
	}
}


private:

Таймер[UINT] всеТаймеры;


extern(Windows) проц процТаймера(УОК уок, UINT uMsg, UINT idEvent, DWORD dwTime)
{
	try
	{
		if(idEvent in всеТаймеры)
		{
			всеТаймеры[idEvent].наТик(АргиСоб.пуст);
		}
		else
		{
			debug(APP_PRINT)
				скажиф("Неизвестный таймер 0x%X.\n", idEvent);
		}
	}
	catch(Объект e)
	{
		Приложение.приИсклНити(e);
	}
}

