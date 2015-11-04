//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.progressbar;

private import viz.base, viz.control, viz.drawing, viz.app,
	viz.event;
private import viz.x.winapi;


private extern(Windows) проц _initProgressbar();


class ProgressBar: СуперКлассУпрЭлта // docmain
{
	this()
	{
		_initProgressbar();
		
		окДопСтиль |= WS_EX_CLIENTEDGE;
		окСтильКласса = стильКлассаПрогрессбар;
	}
	
	
		final проц maximum(цел max) // setter
	{
		if(max <= 0 /+ || max < _min +/)
		{
			//bad_max:
			//throw new ВизИскл("Unable to установи progress bar maximum значение");
			if(max)
				return;
		}
		
		if(создан)
		{
			prevwproc(PBM_SETRANGE, 0, MAKELPARAM(_min, max));
		}
		
		_max = max;
		
		if(_val > max)
			_val = max; // ?
	}
	
	
	final цел maximum() // getter
	{
		return _max;
	}
	
	
		final проц minimum(цел min) // setter
	{
		if(min < 0 /+ || min > _max +/)
		{
			//bad_min:
			//throw new ВизИскл("Unable to установи progress bar minimum значение");
			return;
		}
		
		if(создан)
		{
			prevwproc(PBM_SETRANGE, 0, MAKELPARAM(min, _max));
		}
		
		_min = min;
		
		if(_val < min)
			_val = min; // ?
	}
	
	
	final цел minimum() // getter
	{
		return _min;
	}
	
	
		final проц step(цел stepby) // setter
	{
		if(stepby <= 0 /+ || stepby > _max +/)
		{
			//bad_max:
			//throw new ВизИскл("Unable to установи progress bar step значение");
			if(stepby)
				return;
		}
		
		if(создан)
		{
			prevwproc(PBM_SETSTEP, stepby, 0);
		}
		
		_step = stepby;
	}
	
	
	final цел step() // getter
	{
		return _step;
	}
	
	
		final проц значение(цел setval) // setter
	{
		if(setval < _min || setval > _max)
		{
			//throw new ВизИскл("Progress bar значение out of minimum/maximum range");
			//return;
			if(setval > _max)
				setval = _max;
			else
				setval = _min;
		}
		
		if(создан)
		{
			prevwproc(PBM_SETPOS, setval, 0);
		}
		
		_val = setval;
	}
	
	
	final цел значение() // getter
	{
		return _val;
	}
	
	
		final проц increment(цел incby)
	{
		цел newpos = _val + incby;
		if(newpos < _min)
			newpos = _min;
		if(newpos > _max)
			newpos = _max;
		
		if(создан)
		{
			prevwproc(PBM_SETPOS, newpos, 0);
		}
		
		_val = newpos;
	}
	
	
		final проц performStep()
	{
		increment(_step);
	}
	
	
	protected override проц поСозданиюУказателя(АргиСоб ea)
	{
		super.поСозданиюУказателя(ea);
		
		if(_min != MIN_INIT || _max != MAX_INIT)
		{
			prevwproc(PBM_SETRANGE, 0, MAKELPARAM(_min, _max));
		}
		
		if(_step != STEP_INIT)
		{
			prevwproc(PBM_SETSTEP, _step, 0);
		}
		
		if(_val != VAL_INIT)
		{
			prevwproc(PBM_SETPOS, _val, 0);
		}
	}
	
	
	protected override Размер дефРазм() // getter
	{
		return Размер(100, 23);
	}
	
	
	static Цвет дефЦветПП() // getter
	{
		return СистемныеЦвета.подсветка;
	}
	
	
	protected override проц создайПараметры(inout ПарамыСозд cp)
	{
		super.создайПараметры(cp);
		
		cp.имяКласса = PROGRESSBAR_CLASSNAME;
	}
	
	
	protected override проц предшОкПроц(inout Сообщение сооб)
	{
		//сооб.результат = CallWindowProcA(первОкПроцПрогрессбара, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
		сооб.результат = viz.x.utf.вызовиОкПроц(первОкПроцПрогрессбара, сооб.уок, сооб.сооб, сооб.парам1, сооб.парам2);
	}
	
	
	private:
	
	const цел MIN_INIT = 0;
	const цел MAX_INIT = 100;
	const цел STEP_INIT = 10;
	const цел VAL_INIT = 0;
	
	цел _min = MIN_INIT, _max = MAX_INIT, _step = STEP_INIT, _val = VAL_INIT;
	
	
	package:
	final:
	LRESULT prevwproc(UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		//return CallWindowProcA(первОкПроцПрогрессбара, уок, сооб, wparam, lparam);
		return viz.x.utf.вызовиОкПроц(первОкПроцПрогрессбара, уок, сооб, wparam, lparam);
	}
}

