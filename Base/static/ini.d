/*
	Copyright (C) 2004-2006 Christopher Е. Miller
	
	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any damages
	arising from the use of this software.
	
	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, и to alter it и redistribute it
	freely, subject to the following restrictions:
	
	1. Нельзя искажать источник данного программного обеспечения; либо
	   утверждать, что вами написано оригинальное ПО. Если данное ПО используется
	   Вами в проекте, признательность в документации к продукту будет
	   appreciated but is not requireauxd.
	2. Altered source versions must be plainly marked as such, и must not be
	   misrepresented as being the original software.
	3. This notice may not be removed or altered from any source ни в каком дистрибутиве.
*/

/*

Update:
Объект Ини больше не сохраняется в деструкторе, если его удаляет
сборщик мусора, объект некоторого значения или раздела может быть
удалён первым, что приведёт к непредсказуемому поведению, например,
к нарушению прав доступа. Решение: использовать функцию сохрани()
перед выходом из программы.


Переносной модуль для чтения и записи файлов INI формата:

[раздел]
ключ=значение
...

Пробелы и табуляции в начале строк игнорируются.
Комментарии начинаются с ; и должны быть в отдельной строке.

If there are comments, spaces or ключи above the первый раздел, a имяless раздел is created for them.
This means there need not be any разделы in the файл to have ключи.

Differences with Windows' profile (INI) functions:
* Windows 9x does not allow tabs in the значение.
* Some versions do not allow the файл to exceed 64 KB.
* If not a full файл путь, it's relative to the Windows directory.
* Windows 9x strips trailing spaces from the значение.
* There might be a restriction on how дол разделы/ключи/значениеs may be.
* If there are double quotes around a значение, Windows removes them.
* All ключ/значение pairs must be in a имяd раздел.

*/



/// Переносной модуль для чтения и записи файлов _INI. _ини.d version 0.6
module ini;

import win, stdrus, tpl.stream;


debug = INI; //show файл being parsed
debug=PRINT_DTORS;

class СтрокаИни
{
	~this()
	{
		debug(PRINT_DTORS)
			скажи("~СтрокаИни\n");
	}
	
	
private:
	ткст данные;
}


/// Ключ в файле INI.
class КлючИни: СтрокаИни
{
protected:
	//these are slices in данные if unизменён
	//if изменён, данные is установи to пусто
	ткст _имя;
	ткст _значение;

public:
	this(ткст имя)
	{
		_имя = имя;
	}
	
	
	~this()
	{
		debug(PRINT_DTORS)
			скажиф("~КлючИни '%s'\n", _имя);
	}



	/// Свойство: получить название ключа _имя.
	ткст имя()
	{
		return _имя;
	}


	/// Свойство: получить значение ключа _значение.
	ткст значение()
	{
		return _значение;
	}
}


/// Раздел ключей в файле INI.
class РазделИни
{
protected:
	Ини _ини;
	ткст _имя;
	СтрокаИни[] строки;

public:
	this(Ини ини, ткст имя)
	{
		_ини = ини;
		_имя = имя;
	}
	
	
	~this()
	{
		debug(PRINT_DTORS)
			скажиф("~РазделИни '%s'\n", _имя);
	}

	/// Свойство: получить название секции _имя.
	ткст имя()
	{
		return _имя;
	}


	/// Свойство: установить названии секции _имя.
	проц имя(ткст новИмя)
	{
		_ини._изменён = да;
		_имя = новИмя;
	}


	/// foreach ключ.
	цел opApply(цел delegate(inout КлючИни) dg)
	{
		цел рез = 0;
		бцел i;
		КлючИни иключ;
		for(i = 0; i != строки.length; i++)
		{
			иключ = cast(КлючИни)строки[i];
			if(иключ)
			{
				рез = dg(иключ);
				if(рез)
					break;
			}
		}
		return рез;
	}


	/// Свойство: получить все ключи _keys.
	//better to use foreach unless this массив is needed
	КлючИни[] ключи()
	{
		КлючИни[] ikeys = new КлючИни[строки.length];
		бцел i = 0;
		foreach(КлючИни иключ; this)
		{
			ikeys[i++] = иключ;
		}
		return ikeys[0 .. i];
	}


	/// Возвращает: ключ _key, соответствующий названию ключа имяКлюча, или пусто, если его нет.
	КлючИни ключ(ткст имяКлюча)
	{
		foreach(КлючИни иключ; this)
		{
			if(_ини.совпадают(иключ._имя, имяКлюча))
				return иключ;
		}
		return пусто; //didn't find it
	}


	/// Установить значение существующего ключа.
	проц устЗнач(КлючИни иключ, ткст новЗнач)
	{
		иключ._значение = новЗнач;
		_ини._изменён = да;
		иключ.данные = пусто;
	}


	/// Find or create ключ имяКлюча и установи its _значение to новЗнач.
	проц устЗнач(ткст имяКлюча, ткст новЗнач)
	{
		КлючИни иключ = ключ(имяКлюча);
		if(!иключ)
		{
			иключ = new КлючИни(имяКлюча);
			строки ~= иключ;
			//_ини._изменён = да; //next call does this
		}
		значение(иключ, новЗнач);
	}
	
	
	/+
	///
	alias устЗнач значение;
	+/
	
	
	/// То же, что устЗнач(иключ, новЗнач).
	проц значение(КлючИни иключ, ткст новЗнач)
	{
		return устЗнач(иключ, новЗнач);
	}
	
	
	/// То же, что устЗнач(имяКлюча, новЗнач).
	проц значение(ткст имяКлюча, ткст новЗнач)
	{
		return устЗнач(имяКлюча, новЗнач);
	}


	/// Возвращает: значение of the existing ключ имяКлюча, or дефЗначение if not present.
	ткст дайЗнач(ткст имяКлюча, ткст дефЗначение = пусто)
	{
		foreach(КлючИни иключ; this)
		{
			if(_ини.совпадают(иключ._имя, имяКлюча))
				return иключ.значение;
		}
		return дефЗначение; //didn't find it
	}
	
	
	// /// Возвращает: _значение of the existing ключ имяКлюча, or пусто if not present.
	/// То же, что дайЗнач(имяКлюча, пусто).
	ткст значение(ткст имяКлюча)
	{
		return дайЗнач(имяКлюча, пусто);
	}


	/// Shortcut for дайЗнач(имяКлюча).
	ткст opIndex(ткст имяКлюча)
	{
		return значение(имяКлюча);
	}


	/// Shortcut for устЗнач(имяКлюча, новЗнач).
	проц opIndexAssign(ткст новЗнач, ткст имяКлюча)
	{
		значение(имяКлюча, новЗнач);
	}
	
	
	/// _Remove ключ имяКлюча.
	проц удали(ткст имяКлюча)
	{
		бцел i;
		КлючИни иключ;
		for(i = 0; i != строки.length; i++)
		{
			иключ = cast(КлючИни)строки[i];
			if(иключ && _ини.совпадают(иключ._имя, имяКлюча))
			{
				if(i == строки.length - 1)
					строки = строки[0 .. i];
				else if(i == 0)
					строки = строки[1 .. строки.length];
				else
					строки = строки[0 .. i] ~ строки[i + 1 .. строки.length];
				_ини._изменён = да;
				return;
			}
		}
	}
}


/// An INI файл.
class Ини
{
protected:
	ткст файл;
	бул _изменён = нет;
	РазделИни[] исекции;
	сим начСекц = '[', конСекц = ']';


	проц разбор()
	{
		debug(INI)
			скажиф("Разбор файла INI '%s'\n", файл);

		ткст данные;
		цел i = -1;
		РазделИни isec;
		бцел индНачСтроки = 0; 


		if(естьФайл(файл))	данные = cast(ткст)читайФайл(файл);
				else 
				{
				инфо(фм("INI файл "~файл~" отсутствует"));	
				return;
				}
		
		if(!данные.length)
		{
			инфо(фм("INI файл "~файл~" не содержит записей"));
			return;
		}


		сим возьмис()
		{
			//also increment -i- past end so отдайс works properly
			if(++i >= данные.length)
				return 0;
			return данные[i];
		}


		проц отдайс()
		{
			assert(i > 0);
			i--;
		}
		
		
		проц сбрось()
		{
			индНачСтроки = i + 1;
		}


		проц конСтроки()
		{
			СтрокаИни iline = new СтрокаИни;
			iline.данные = данные[индНачСтроки .. i];
			debug(INI)
				скажиф("Строка INI: '%s'\n", замени(замени(замени(iline.данные, "\\", "\\\\"), "\r", "\\r"), "\n", "\\n"));
			isec.строки ~= iline;
		}


		сим ch, ch2;
		цел i2;
		isec = new РазделИни(this, "");
		for(;;)
		{
			ch = возьмис();
			switch(ch)
			{
				case '\r':
					конСтроки();
					ch2 = возьмис();
					if(ch2 != '\n')
						отдайс();
					сбрось();
					break;

				case '\n':
					конСтроки();
					сбрось();
					break;

				case 0: //eof
					ини_кф:
					if(индНачСтроки < i)
					{
						конСтроки();
						//сбрось();
					}
					исекции ~= isec;
					if(!исекции[0].строки)
						исекции = исекции[1 .. исекции.length];
					debug(INI)
						скажи("Разбор INI выполнен\n\n");
					return;

				case ' ':
				case '\t':
				case '\v':
				case '\f':
					break;
				
				case ';': //comments
				case '#':
					done_comment:
					for(;;)
					{
						ch2 = возьмис();
						switch(ch2)
						{
							case '\r':
								конСтроки();
								ch2 = возьмис();
								if(ch2 != '\n')
									отдайс();
								сбрось();
								break done_comment;
							
							case '\n':
								конСтроки();
								сбрось();
								break done_comment;
							
							case 0: //eof
								goto ини_кф;
							
							default: ;
						}
					}
					break;
				
				default:
					if(ch == начСекц) // '['
					{
						i2 = i + 1;
						done_sec:
						for(;;)
						{
							ch2 = возьмис();
							switch(ch2)
							{
								case '\r':
									конСтроки();
									ch2 = возьмис();
									if(ch2 != '\n')
										отдайс();
									сбрось();
									break done_sec;

								case '\n':
									конСтроки();
									сбрось();
									break done_sec;

								case 0: //eof
									goto ини_кф;

								default:
									if(ch2 == конСекц) // ']'
									{
										исекции ~= isec;
										isec = new РазделИни(this, данные[i2 .. i]);
										debug(INI)
											скажиф("INI раздел: '%s'\n", isec._имя);
										for(;;)
										{
											ch2 = возьмис();
											switch(ch2)
											{
												case ' ':
												case '\t':
												case '\v':
												case '\f':
													//ignore whitespace
													break;
		
												case '\r':
													ch2 = возьмис();
													if(ch2 != '\n')
														отдайс();
													break done_sec;
		
												case '\n':
													break done_sec;
		
												default:
													//just treat junk after the ] as the next line
													отдайс();
													break done_sec;
											}
										}
										break done_sec;
									}
							}
						}
						сбрось();
						break;
					}
					else //must be beginning of ключ имя
					{
						i2 = i;
						done_default:
						for(;;)
						{
							ch2 = возьмис();
							switch(ch2)
							{
								case '\r':
									конСтроки();
									ch2 = возьмис();
									if(ch2 != '\n')
										отдайс();
									сбрось();
									break done_default;
								
								case '\n':
									конСтроки();
									сбрось();
									break done_default;
								
								case 0: //eof
									goto ини_кф;
								
								case ' ':
								case '\t':
								case '\v':
								case '\f':
									break;
								
								case '=':
									КлючИни иключ;
	
	
									проц добавьКлюч()
									{
										иключ.данные = данные[индНачСтроки .. i];
										иключ._значение = данные[i2 .. i];
										isec.строки ~= иключ;
										debug(INI)
											скажиф("INI ключ: '%s' = '%s'\n", иключ._имя, иключ._значение);
									}
									
									
									иключ = new КлючИни(данные[i2 .. i]);
									i2 = i + 1; //after =
									for(;;) //дай ключ значение
									{
										ch2 = возьмис();
										switch(ch2)
										{
											case '\r':
												добавьКлюч();
												ch2 = возьмис();
												if(ch2 != '\n')
													отдайс();
												сбрось();
												break done_default;
											
											case '\n':
												добавьКлюч();
												сбрось();
												break done_default;
											
											case 0: //eof
												добавьКлюч();
												сбрось();
												goto ини_кф;
											
											default: ;
										}
									}
									break done_default;
								
								default: ;
							}
						}
					}
			}
		}
	}
	
	
	проц откройПервым(ткст файл)
	{
		//пусто terminated just to make it easier for the implementation
		this.файл = вТкст0(файл)[0 .. файл.length];
		//debug(INI) скажиф(файл);
		разбор();
	}


public:
	// Use different раздел имя разграничители; not recommendeauxd.
	this(ткст файл, сим начСекц, сим конСекц)
	{
		this.начСекц = начСекц;
		this.конСекц = конСекц;
		
		откройПервым(файл);
	}


	/// Construct a new INI файл.
	this(ткст файл)
	{
		откройПервым(файл);
	}


	~this()
	{
		debug(PRINT_DTORS)
			скажиф("~Ини '%s'\n", файл);
		
		// The reason this is commented is explained above.
		/+
		if(_изменён)
			сохрани();
		+/
	}


	/// Comparison function for раздел и ключ имяs. Override to change behavior.
	бул совпадают(ткст s1, ткст s2)
	{
		return !сравнлюб(s1, s2);
	}


	//reuse same object for another файл
	/// Открыть an INI файл.
	проц открой(ткст файл)
	{
		if(_изменён)
			сохрани();
		_изменён = нет;
		исекции = пусто;
		
		откройПервым(файл);
	}


	/// Reload INI файл; any unsaved changes are lost.
	проц рехэшируй()
	{
		_изменён = нет;
		исекции = пусто;
		разбор();
	}


	/// Release memory without saving changes; contents become empty.
	проц дамп()
	{
		_изменён = нет;
		исекции = пусто;
	}


	/// Property: дай whether or not the INI файл was _изменён since it was loaded or saveauxd.
	бул изменён()
	{
		return _изменён;
	}
	
	
	/// Параметры:
	/// f = an opened-for-write stream; сохрани() uses БуфФайл by default. Override сохрани() to change stream.
	protected final проц сохраниВПоток(Поток f)
	{
		_изменён = нет;

		if(!исекции.length)
			return;

		КлючИни иключ;
		РазделИни isec;
		бцел i = 0, j;
		assert(f.записываемый);

		if(исекции[0]._имя.length)
			goto пишим_имя;
		else //первый раздел doesn't have a имя; just ключи at start of файл
			goto после_имя;

		for(; i != исекции.length; i++)
		{
			пишим_имя:
			f.выводф("%c%.*s%c\r\n", начСекц, исекции[i]._имя, конСекц);
			после_имя:
			isec = исекции[i];
			for(j = 0; j != isec.строки.length; j++)
			{
				if(isec.строки[j].данные is пусто)
				{
					иключ = cast(КлючИни)isec.строки[j];
					if(иключ)
						иключ.данные = иключ._имя ~ "=" ~ иключ._значение;
				}
				f.пишиТкст(isec.строки[j].данные);
				f.пишиТкст("\r\n");
			}
		}
	}


	/// Зап contents to disk, even if no changes were made. It is common to do if(изменён)сохрани();
	проц сохрани()
	{
	
		Файл f = new Файл;
		f.создай(файл);
		try
		{
			сохраниВПоток(f);
			f.слей();
		}
		finally
		{
			f.закрой();
		}
	}


	/// Finds a _section; returns пусто if one имяd имя does not exist.
	РазделИни раздел(ткст имя)
	{
		foreach(РазделИни isec; исекции)
		{
			if(совпадают(isec._имя, имя))
				return isec;
		}
		return пусто; //didn't find it
	}


	/// Shortcut for раздел(имяРаздела).
	РазделИни opIndex(ткст имяРаздела)
	{
		return раздел(имяРаздела);
	}


	/// The раздел is created if one имяd имя does not exist.
	/// Возвращает: Section имяd имя.
	РазделИни добавьРаздел(ткст имя)
	{
		РазделИни isec = раздел(имя);
		if(!isec)
		{
			isec = new РазделИни(this, имя);
			_изменён = да;
			исекции ~= isec;
		}
		return isec;
	}


	/// foreach раздел.
	цел opApply(цел delegate(inout РазделИни) dg)
	{
		цел рез = 0;
		foreach(РазделИни isec; исекции)
		{
			рез = dg(isec);
			if(рез)
				break;
		}
		return рез;
	}


	/// Property: дай all _sections.
	РазделИни[] разделы()
	{
		return исекции;
	}
	
	
	/// _Remove раздел имяd имяРаздела.
	проц удали(ткст имяРаздела)
	{
		бцел i;
		for(i = 0; i != исекции.length; i++)
		{
			if(совпадают(имяРаздела, исекции[i]._имя))
			{
				if(i == исекции.length - 1)
					исекции = исекции[0 .. i];
				else if(i == 0)
					исекции = исекции[1 .. исекции.length];
				else
					исекции = исекции[0 .. i] ~ исекции[i + 1 .. исекции.length];
				_изменён = да;
				return;
			}
		}
	}
}


unittest
{
	ткст инифайл = "unittest.ini";
	Ини ини;

	ини = new Ини(инифайл);
	with(ини.добавьРаздел("foo"))
	{
		значение("asdf", "jkl");
		значение("bar", "wee!");
		значение("hi", "hello");
	}
	ини.добавьРаздел("BAR");
	with(ини.добавьРаздел("fOO"))
	{
		значение("yes", "no");
	}
	with(ини.добавьРаздел("Hello"))
	{
		значение("world", "да");
	}
	with(ини.добавьРаздел("test"))
	{
		значение("1", "2");
		значение("3", "4");
	}
	ини["test"]["значение"] = "да";
	assert(ини["Foo"]["yes"] == "no");
	ини.сохрани();
	delete ини;

	ини = new Ини(инифайл);
	assert(ини["FOO"]["Bar"] == "wee!");
	assert(ини["Foo"]["yes"] == "no");
	assert(ини["hello"]["world"] == "да");
	assert(ини["FOO"]["Bar"] == "wee!");
	assert(ини["55"] is пусто);
	assert(ини["hello"]["Yes"] is пусто);
	
	ини.открой(инифайл);
	ини["bar"].удали("notta");
	ини["foo"].удали("bar");
	ини.удали("bar");
	assert(ини["bar"] is пусто);
	assert(ини["foo"] !is пусто);
	assert(ини["foo"]["bar"] is пусто);
	ини.удали("foo");
	assert(ини["foo"] is пусто);
	ини.сохрани();
	delete ини;
}

