//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


// Not actually part of forms, but is handy.

module viz.environment;

private import viz.x.dlib, stdrus;

private import viz.x.winapi, viz.base, viz.x.utf, viz.event;


final class Среда // docmain
{
	private this() {}
	
	
	static:
	
		Ткст команднаяСтрока() // getter
	{
		return viz.x.utf.дайКоманднуюСтроку();
	}
	
	
		проц текущаяПапка(Ткст cd) // setter
	{
		if(!viz.x.utf.установиТекущуюПапку(cd))
			throw new ВизИскл("Unable to установи текущий directory");
	}
	
	
	Ткст текущаяПапка() // getter
	{
		return viz.x.utf.дайТекущуюПапку();
	}
	
	
		Ткст имяМашины() // getter
	{
		Ткст результат;
		результат = viz.x.utf.дайИмяКомпьютера();
		if(!результат.length)
			throw new ВизИскл("Unable to obtain machine имя");
		return результат;
	}
	
	
		Ткст новСтр() // getter
	{
		return РАЗДСТР;
	}
	
	
		ОперационнаяСистема версияОС() // getter
	{
		OSVERSIONINFOA osi;
		Версия вер;
		
		osi.dwOSVersionInfoSize = osi.sizeof;
		if(!GetVersionExA(&osi))
			throw new ВизИскл("Unable to obtain operating system version информация");
		
		цел постройка;
		
		switch(osi.dwPlatformId)
		{
			case VER_PLATFORM_WIN32_NT:
				вер = new Версия(osi.dwMajorVersion, osi.dwMinorVersion, osi.dwBuildNumber);
				break;
			
			case VER_PLATFORM_WIN32_WINDOWS:
				вер = new Версия(osi.dwMajorVersion, osi.dwMinorVersion, LOWORD(osi.dwBuildNumber));
				break;
			
			default:
				вер = new Версия(osi.dwMajorVersion, osi.dwMinorVersion);
		}
		
		return new ОперационнаяСистема(cast(ИдПлатформы)osi.dwPlatformId, вер);
	}
	
	
		Ткст папкаСистемы() // getter
	{
		Ткст результат;
		результат = viz.x.utf.дайСистПапку();
		if(!результат.length)
			throw new ВизИскл("Unable to obtain system directory");
		return результат;
	}
	
	
	// Should return цел ?
	DWORD счётТиков() // getter
	{
		return GetTickCount();
	}
	
	
		Ткст имяПользователя() // getter
	{
		Ткст результат;
		результат = viz.x.utf.дайИмяПользователя();
		if(!результат.length)
			throw new ВизИскл("Unable to obtain user имя");
		return результат;
	}
	
	
		проц выход(цел code)
	{
		// This is probably better than ExitProcess(code).
		выход(code);
	}
	
	
		Ткст разверниПеременныеСреды(Ткст str)
	{
		Ткст результат;
		if(!viz.x.utf.разверниСтрокиСреды(str, результат))
			throw new ВизИскл("Unable to expand environment variables");
		return результат;
	}
	
	
		Ткст[] дайАргументыКоманднойСтроки()
	{
		return парсируйАрги(команднаяСтрока);
	}
	
	
		Ткст дайПеременнуюСреды(Ткст имя)
	{
		Ткст результат;
		результат = viz.x.utf.дайПеременнуюСреды(имя);
		if(!результат.length)
			throw new ВизИскл("Unable to obtain environment variable");
		return результат;
	}
	
	
	//Ткст[Ткст] getEnvironmentVariables()
	//Ткст[] getEnvironmentVariables()
	
	
		Ткст[] дайЛогическиеДиски()
	{
		DWORD dr = GetLogicalDrives();
		Ткст[] результат;
		цел i;
		сим[4] tmp = " :\\\0";
		
		for(i = 0; dr; i++)
		{
			if(dr & 1)
			{
				сим[] s = tmp.dup[0 .. 3];
				s[0] = 'A' + i;
				//результат ~= s;
				результат ~= cast(Ткст)s; // Needed in D2.
			}
			dr >>= 1;
		}
		
		return результат;
	}
}


/+
enum PowerModes: ббайт
{
	STATUS_CHANGE,
	RESUME,
	SUSPEND,
}


class PowerModeChangedEventArgs: АргиСоб
{
	this(PowerModes pm)
	{
		this._pm = pm;
	}
	
	
	final PowerModes mode() // getter
	{
		return _pm;
	}
	
	
	private:
	PowerModes _pm;
}
+/


/+
enum SessionEndReasons: ббайт
{
	SYSTEM_SHUTDOWN, 	LOGOFF, 
}


class SystemEndedEventArgs: АргиСоб
{
		this(SessionEndReasons reason)
	{
		this._reason = reason;
	}
	
	
		final SessionEndReasons reason() // getter
	{
		return this._reason;
	}
	
	
	private:
	SessionEndReasons _reason;
}


class SessionEndingEventArgs: АргиСоб
{
		this(SessionEndReasons reason)
	{
		this._reason = reason;
	}
	
	
		final SessionEndReasons reason() // getter
	{
		return this._reason;
	}
	
	
		final проц отмена(бул подтвержд) // setter
	{
		this._cancel = подтвержд;
	}
	
	
	final бул отмена() // getter
	{
		return this._cancel;
	}
	
	
	private:
	SessionEndReasons _reason;
	бул _cancel = нет;
}
+/


/+
final class SystemEvents // docmain
{
	private this() {}
	
	
	static:
	СобОбработчик displaySettingsChanged;
	СобОбработчик installedFontsChanged;
	СобОбработчик lowMemory; // GC automatically collects before this событие.
	СобОбработчик paletteChanged;
	//PowerModeChangedEventHandler powerModeChanged; // WM_POWERBROADCAST
	SystemEndedEventHandler systemEnded;
	SessionEndingEventHandler systemEnding;
	SessionEndingEventHandler sessionEnding;
	СобОбработчик timeChanged;
	// user preference changing/изменено. WM_SETTINGCHANGE ?
	
	
	/+
	проц useOwnThread(бул подтвержд) // setter
	{
		if(подтвержд != useOwnThread)
		{
			if(подтвержд)
			{
				_ownthread = new Thread;
				// вБездействии priority..
			}
			else
			{
				// Kill thread.
			}
		}
	}
	
	
	бул useOwnThread() // getter
	{
		return _ownthread !is пусто;
	}
	+/
	
	
	private:
	//package Thread _ownthread = пусто;
	
	
	SessionEndReasons sessionEndReasonFromLparam(LPARAM lparam)
	{
		if(ENDSESSION_LOGOFF == lparam)
			return SessionEndReasons.LOGOFF;
		return SessionEndReasons.SYSTEM_SHUTDOWN;
	}
	
	
	проц _realCheckMessage(inout Сообщение m)
	{
		switch(m.сооб)
		{
			case WM_DISPLAYCHANGE:
				displaySettingsChanged(typeid(SystemEvents), АргиСоб.пуст);
				break;
			
			case WM_FONTCHANGE:
				installedFontsChanged(typeid(SystemEvents), АргиСоб.пуст);
				break;
			
			case WM_COMPACTING:
				//gcFullCollect();
				lowMemory(typeid(SystemEvents), АргиСоб.пуст);
				break;
			
			case WM_PALETTECHANGED:
				paletteChanged(typeid(SystemEvents), АргиСоб.пуст);
				break;
			
			case WM_ENDSESSION:
				if(m.парам1)
				{
					scope SystemEndedEventArgs ea = new SystemEndedEventArgs(sessionEndReasonFromLparam(m.парам2));
					systemEnded(typeid(SystemEvents), ea);
				}
				break;
			
			case WM_QUERYENDSESSION:
				{
					scope SessionEndingEventArgs ea = new SessionEndingEventArgs(sessionEndReasonFromLparam(m.парам2));
					systemEnding(typeid(SystemEvents), ea);
					if(ea.отмена)
						m.результат = FALSE; // Stop shutdown.
					m.результат = TRUE; // Continue shutdown.
				}
				break;
			
			case WM_TIMECHANGE:
				timeChanged(typeid(SystemEvents), АргиСоб.пуст);
				break;
			
			default: ;
		}
	}
	
	
	package проц _checkMessage(inout Сообщение m)
	{
		//if(_ownthread)
			_realCheckMessage(m);
	}
}
+/


package Ткст[] парсируйАрги(Ткст арги)
{
	Ткст[] результат;
	бцел i;
	бул inQuote = нет;
	бул findStart = да;
	бцел начИндекс = 0;
	
	for(i = 0;; i++)
	{
		if(i == арги.length)
		{
			if(findStart)
				начИндекс = i;
			break;
		}
		
		if(findStart)
		{
			if(арги[i] == ' ' || арги[i] == '\t')
				continue;
			findStart = нет;
			начИндекс = i;
		}
		
		if(арги[i] == '"')
		{
			inQuote = !inQuote;
			if(!inQuote) //matched quotes
			{
				результат.length = результат.length + 1;
				результат[результат.length - 1] = арги[начИндекс .. i];
				findStart = да;
			}
			else //стартing quote
			{
				if(начИндекс != i) //must be а quote stuck to another word, separate them
				{
					результат.length = результат.length + 1;
					результат[результат.length - 1] = арги[начИндекс .. i];
					начИндекс = i + 1;
				}
				else
				{
					начИндекс++; //exclude the quote
				}
			}
		}
		else if(!inQuote)
		{
			if(арги[i] == ' ' || арги[i] == '\t')
			{
				результат.length = результат.length + 1;
				результат[результат.length - 1] = арги[начИндекс .. i];
				findStart = да;
			}
		}
	}
	
	if(начИндекс != i)
	{
		результат.length = результат.length + 1;
		результат[результат.length - 1] = арги[начИндекс .. i];
	}
	
	return результат;
}


unittest
{
	Ткст[] арги;
	
	арги = парсируйАрги(`"foo" bar`);
	assert(арги.length == 2);
	assert(арги[0] == "foo");
	assert(арги[1] == "bar");
	
	арги = парсируйАрги(`"environment"`);
	assert(арги.length == 1);
	assert(арги[0] == "environment");
	
	/+
	writefln("команднаяСтрока = '%s'", Среда.команднаяСтрока);
	foreach(Ткст arg; Среда.дайАргументыКоманднойСтроки())
	{
		writefln("\t'%s'", arg);
	}
	+/
}


// Any version, not just the operating system.
class Версия // docmain ?
{
	private:
	цел _major = 0, _minor = 0;
	цел _build = -1, _revision = -1;
	
	
	public:
	
		this()
	{
	}
	
	
	final:
	
	
	// A string containing "майор.минор.постройка.ревизия".
	// 2 to 4 parts expected.
	this(Ткст str)
	{
		Ткст[] stuff = разбей(str, ".");
		
		// Note: fallthrough.
		switch(stuff.length)
		{
			case 4:
				_revision = вЦел(stuff[3]);
			case 3:
				_build = вЦел(stuff[2]);
			case 2:
				_minor = вЦел(stuff[1]);
				_major = вЦел(stuff[0]);
			default:
				throw new ВизИскл("Invalid version parameter");
		}
	}
	
	
	this(цел майор, цел минор)
	{
		_major = майор;
		_minor = минор;
	}
	
	
	this(цел майор, цел минор, цел постройка)
	{
		_major = майор;
		_minor = минор;
		_build = постройка;
	}
	
	
	this(цел майор, цел минор, цел постройка, цел ревизия)
	{
		_major = майор;
		_minor = минор;
		_build = постройка;
		_revision = ревизия;
	}
	
	
	/+ // D2 doesn't like this without () but this invariant doesn't really even matter.
	invariant
	{
		assert(_major >= 0);
		assert(_minor >= 0);
		assert(_build >= -1);
		assert(_revision >= -1);
	}
	+/
	
	
		Ткст вТкст()
	{
		Ткст результат;
		
		результат = вТкст(_major) ~ "." ~ вТкст(_minor);
		if(_build != -1)
			результат ~= "." ~ вТкст(_build);
		if(_revision != -1)
			результат ~= "." ~ вТкст(_revision);
		
		return результат;
	}
	
	
		цел майор() // getter
	{
		return _major;
	}
	
	
	цел минор() // getter
	{
		return _minor;
	}
	
	
	// -1 if нет постройка.
	цел постройка() // getter
	{
		return _build;
	}
	
	
	// -1 if нет ревизия.
	цел ревизия() // getter
	{
		return _revision;
	}
}


enum ИдПлатформы: DWORD
{
	WIN_CE = cast(DWORD)-1,
	WIN32s = VER_PLATFORM_WIN32s,
	WIN32_WINDOWS = VER_PLATFORM_WIN32_WINDOWS,
	WIN32_NT = VER_PLATFORM_WIN32_NT,
}


final class ОперационнаяСистема // docmain
{
	final
	{
				this(ИдПлатформы platId, Версия вер)
		{
			this.platId = platId;
			this.vers = вер;
		}
		
		
				Ткст вТкст()
		{
			Ткст результат;
			
			// DMD 0.92 says ошибка: cannot implicitly convert бцел to ИдПлатформы
			switch(cast(DWORD)platId)
			{
				case ИдПлатформы.WIN32_NT:
					результат = "Microsoft Windows NT ";
					break;
				
				case ИдПлатформы.WIN32_WINDOWS:
					результат = "Microsoft Windows 95 ";
					break;
				
				case ИдПлатформы.WIN32s:
					результат = "Microsoft Win32s ";
					break;
				
				case ИдПлатформы.WIN_CE:
					результат = "Microsoft Windows CE ";
					break;
				
				default:
					throw new ВизИскл("Unknown платформа ID");
			}
			
			результат ~= vers.вТкст();
			return результат;
		}
		
		
				ИдПлатформы платформа() // getter
		{
			return platId;
		}
		
		
				// Should be version() :p
		Версия вер() // getter
		{
			return vers;
		}
	}
	
	
	private:
	ИдПлатформы platId;
	Версия vers;
}

