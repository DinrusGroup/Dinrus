
module viz.x.dlib;
public import dinrus;

alias typeof(""ктрл[]) Ткст;
alias typeof(""ктрл.ptr) Ткст0;
alias typeof(" "ктрл[0]) Сим;
alias typeof(""w[]) Шткст;
alias typeof(""w.ptr) Шткст0;
alias typeof(" "w[0]) Шим;
alias typeof(""d[]) Дткст;
alias typeof(""d.ptr) Дткст0;
alias typeof(" "d[0]) Дим;


	template ФобосТрэтс()
	{
		static if(!is(КортежТипаПараметров!(function() { })))
		{
			// Grabbed from std.traits since Tango's meta.Traits lacks these:
			
			template КортежТипаПараметров(alias дг)
			{
				alias КортежТипаПараметров!(typeof(дг)) КортежТипаПараметров;
			}
			
			/** ditto */
			template КортежТипаПараметров(дг)
			{
				static if (is(дг P == function))
					alias P КортежТипаПараметров;
				else static if (is(дг P == delegate))
					alias КортежТипаПараметров!(P) КортежТипаПараметров;
				else static if (is(дг P == P*))
					alias КортежТипаПараметров!(P) КортежТипаПараметров;
				else
					static assert(0, "у аргумента отсутствуют параметры");
			}
		}
	}
	
	mixin ФобосТрэтс;
	
	
	Ткст дайТкстОбъекта(Объект o)
	{
			return o.вТкст();
	}
	
	
	alias ТипВозврата!(Объект.opEquals) т_рав; // Since D2 changes mid-stream.
	
	
	Ткст дайТкстОбъекта(Объект o)
	{
		return o.вТкст();
	}
	
	Ткст бцелВГексТкст(бцел num)
	{
		return stdrus.фм("%X", num);
	}
	
	
ткст0 небезопВТкст0(Ткст s)
{
	// This is intentionally unsafe, hence the имя.
	if(!s.ptr[s.length])
		//return s.ptr;
		return cast(ткст0)s.ptr; // Needed in D2.
	//return вТкст0(s);
	return cast(ткст0)вТкст0(s); // Needed in D2.
}

