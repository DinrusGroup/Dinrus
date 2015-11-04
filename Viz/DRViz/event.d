// Not actually part of forms, but is needed.
// This code is public domain.

/// Событие handling.
module viz.event;

import viz.x.dlib, tpl.traits;


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
			static assert(is(TDG == delegate), "viz: Event обработчик must be а delegate");
			
			alias КортежТипаПараметров!(TDG) TDGParams;
			static assert(TDGParams.length == 2, "viz: Event обработчик needs exactly 2 parameters");
			
			static if(is(TDGParams[0] : Объект))
			{
				static assert(is(T1: TDGParams[0]), "viz: Event обработчик parameter 1 тип mismatch");
			}
			else
			{
				static assert(is(T1 == TDGParams[0]), "viz: Event обработчик parameter 1 тип mismatch");
			}
			
			static if(is(TDGParams[1] : Объект))
			{
				static assert(is(T2 : TDGParams[1]), "viz: Event обработчик parameter 2 тип mismatch");
			}
			else
			{
				static assert(is(T2 == TDGParams[1]), "viz: Event обработчик parameter 2 тип mismatch");
			}
		}
	}
}


/// Основа событие arguments.
class АргиСоб // docmain
{
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
		
		// std.gc.добавьДиапазон(результат, результат + разм); // So that it can contain pointers.
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


class АргиСобИсклНити: АргиСоб
{
		// The исключение that occured.
	this(Объект theException)
	{
		except = theException;
	}
	
	
		final Объект исключение() // getter
	{
		return except;
	}
	
	
	private:
	Объект except;
}

