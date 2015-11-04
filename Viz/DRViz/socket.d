//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.socket;


version(VIZ_TANGO0951beta1)
	version = VIZ_TANGObefore099rc3;
else version(VIZ_TANGO097rc1)
	version = VIZ_TANGObefore099rc3;
else version(VIZ_TANGO098rc2)
	version = VIZ_TANGObefore099rc3;


version(WINE)
{
}
else
{

private import viz.x.dlib, stdrus;

private
{
	version(Tango)
	{
		version(VIZ_TANGObefore099rc3)
			private import tango.core.Intrinsic;
		else
			private import std.intrinsic;
		private import tango.net.Сокет;
		
		alias NetHost DInternetHost;
		alias IPv4Address DInternetAddress;
		
		т_сокет дайУкНаСокет(Сокет сок)
		{
			return сок.fileHandle;
		}
	}
	else
	{
		private import dinrus;
		
		alias ИнтернетХост DInternetHost;
		alias ИнтернетАдрес DInternetAddress;
		
		т_сокет дайУкНаСокет(Сокет сок)
		{
			return сок.handle;
		}
	}
}

private import viz.x.winapi, viz.application, viz.base, viz.x.utf;


private
{
	enum
	{
		FD_READ =       0x01,
		FD_WRITE =      0x02,
		FD_OOB =        0x04,
		FD_ACCEPT =     0x08,
		FD_CONNECT =    0x10,
		FD_CLOSE =      0x20,
		FD_QOS =        0x40,
		FD_GROUP_QOS =  0x80,
	}
	
	
	extern(Windows) цел WSAAsyncSelect(т_сокет s, УОК уок, UINT wMsg, цел lEvent);
}


// Can be OR'ed.
enum ТипСобытия
{
	НЕУК = 0, 	
	READ =       FD_READ, 
	WRITE =      FD_WRITE, 
	OOB =        FD_OOB, 
	ACCEPT =     FD_ACCEPT, 
	CONNECT =    FD_CONNECT, 
	ЗАКРЫТЬ =      FD_CLOSE, 
	
	QOS =        FD_QOS,
	GROUP_QOS =  FD_GROUP_QOS,
}


// -err- will be 0 if нет ошибка.
// -тип- will always contain only one флаг.
alias проц delegate(Сокет сок, ТипСобытия тип, цел err) ОбрВызСобРег;


// Calling this twice on the same socket cancels out previously
// registered события for the socket.
// Requires Приложение.пуск() or Приложение.вершиСобытия() loop.
проц регистрируйСобытие(Сокет сок, ТипСобытия события, ОбрВызСобРег обрвыз) // deprecated
{
	if(!hwNet)
		_init();
	
	сок.blocking = нет; // So the getter will be correct.
	
	// SOCKET_ERROR
	if(-1 == WSAAsyncSelect(дайУкНаСокет(сок), hwNet, WM_VIZ_NETEVENT, cast(цел)события))
		throw new ВизИскл("Не удалась регистрация события сокета");
	
	ИнфОСобытии ei;
	
	ei.сок = сок;
	ei.обрвыз = обрвыз;
	всеСобытия[дайУкНаСокет(сок)] = ei;
}


проц отрегистрируйСобытие(Сокет сок) // deprecated
{
	WSAAsyncSelect(дайУкНаСокет(сок), hwNet, 0, 0);
	
	//delete всеСобытия[дайУкНаСокет(сок)];
	всеСобытия.удали(дайУкНаСокет(сок));
}


class АсинхСокет: Сокет // docmain
{
		this(ПСемействоАдресов af, ПТипСок тип, ППротокол протокол)
	{
		super(af, тип, протокол);
		super.blocking = нет;
	}
	
	version(Tango)
	{
	}
	else
	{
		
		this(ПСемействоАдресов af, ПТипСок тип)
		{
			super(af, тип);
			super.blocking = нет;
		}
		
		
		this(ПСемействоАдресов af, ПТипСок тип, Ткст protocolName)
		{
			super(af, тип, protocolName);
			super.blocking = нет;
		}
	}
	
	
	// For use with accept().
	protected this()
	{
	}
	
	
		проц событие(ТипСобытия события, ОбрВызСобРег обрвыз)
	{
		регистрируйСобытие(this, события, обрвыз);
	}
	
	
	version(Tango)
	{
	}
	else
	{
		protected override АсинхСокет принимающий()
		{
			return new АсинхСокет;
		}
	}
	
	
	version(Tango)
		private const бул _IS_TANGO = да;
	else
		private const бул _IS_TANGO = нет;
	
	static if(_IS_TANGO && is(typeof(&this.отсоедини)))
	{
		override проц отсоедини()
		{
			отрегистрируйСобытие(this);
			super.отсоедини();
		}
	}
	else
	{
		проц закрой()
		{
			отрегистрируйСобытие(this);
			super.close();
		}
	}
	
	
	override бул блокируемый() // getter
	{
		return нет;
	}
	
	
	override проц блокируемый(бул подтвержд) // setter
	{
		if(подтвержд)
			assert(0);
	}
}


class АсинхСокетПут: АсинхСокет // docmain
{
		this(ПСемействоАдресов семейство)
	{
		super(семейство, ПТипСок.STREAM, ППротокол.ПУТ);
	}
	
	
	this()
	{
		this(cast(ПСемействоАдресов)ПСемействоАдресов.ИНЕТ);
	}
	
	
	// Shortcut.
	this(Адрес connectTo, ТипСобытия события, ОбрВызСобРег eventCallback)
	{
		this(connectTo.семействоАдресов());
		событие(события, eventCallback);
		подключи(connectTo);
	}
}


class AsyncUdpSocket: АсинхСокет // docmain
{
		this(ПСемействоАдресов семейство)
	{
		super(семейство, ПТипСок.ДГрамма, ППротокол.ППД);
	}
	
	
	this()
	{
		this(cast(ПСемействоАдресов)ПСемействоАдресов.ИНЕТ);
	}
}


/+
private class GetHostWaitHandle: ЖдиУк
{
	this(HANDLE h)
	{
		super.указатель = h;
	}
	
	
	final:
	
	alias ЖдиУк.указатель указатель; // Overload.
	
	override проц указатель(HANDLE h) // setter
	{
		assert(0);
	}
	
	override проц закрой()
	{
		WSACancelAsyncRequest(указатель);
		super.указатель = НЕВЕРНХЭНДЛ;
	}
	
	
	private проц _gotEvent()
	{
		super.указатель = НЕВЕРНХЭНДЛ;
	}
}


private class GetHostAsyncResult, ИАсинхРез
{
	this(HANDLE h, GetHostCallback обрвыз)
	{
		wh = new GetHostWaitHandle(h);
		this.обрвыз = обрвыз;
	}
	
	
	ЖдиУк ждиУкАсинх() // getter
	{
		return wh;
	}
	
	
	бул выполненоСинхронно() // getter
	{
		return нет;
	}
	
	
	бул выполнено_ли() // getter
	{
		return wh.указатель != ЖдиУк.НЕВЕРНХЭНДЛ;
	}
	
	
	private:
	GetHostWaitHandle wh;
	GetHostCallback обрвыз;
	
	
	проц _gotEvent(LPARAM lparam)
	{
		wh._gotEvent();
		
		обрвыз(bla, HIWORD(lparam));
	}
}
+/


private проц _getHostErr()
{
	throw new ВизИскл("Get host failure"); // Needs а better сообщение.. ?
}


private class _InternetHost: DInternetHost
{
	private:
	this(ук hostentBytes)
	{
		super.validHostent(cast(hostent*)hostentBytes);
		super.populate(cast(hostent*)hostentBytes);
	}
}


// If -err- is nonzero, it is а winsock ошибка code and -inetHost- is пусто.
alias проц delegate(DInternetHost inetHost, цел err) GetHostCallback;


class GetHost // docmain
{
		проц отмена()
	{
		WSACancelAsyncRequest(h);
		h = пусто;
	}
	
	
	private:
	HANDLE h;
	GetHostCallback обрвыз;
	ббайт[/+MAXGETHOSTSTRUCT+/ 1024] hostentBytes;
	
	
	проц _gotEvent(LPARAM lparam)
	{
		h = пусто;
		
		цел err;
		err = HIWORD(lparam);
		if(err)
			обрвыз(пусто, err);
		else
			обрвыз(new _InternetHost(hostentBytes.ptr), 0);
	}
	
	
	this()
	{
	}
}


GetHost asyncGetHostByName(Ткст имя, GetHostCallback обрвыз) // docmain
{
	if(!hwNet)
		_init();
	
	HANDLE h;
	GetHost результат;
	
	результат = new GetHost;
	h = WSAAsyncGetHostByName(hwNet, WM_VIZ_HOSTEVENT, небезопТкст0(имя),
		cast(ткст0)результат.hostentBytes, результат.hostentBytes.length);
	if(!h)
		_getHostErr();
	
	результат.h = h;
	результат.обрвыз = обрвыз;
	allGetHosts[h] = результат;
	
	return результат;
}


GetHost asyncGetHostByAddr(uint32_t addr, GetHostCallback обрвыз) // docmain
{
	if(!hwNet)
		_init();
	
	HANDLE h;
	GetHost результат;
	
	результат = new GetHost;
	version(LittleEndian)
		addr = bswap(addr);
	h = WSAAsyncGetHostByAddr(hwNet, WM_VIZ_HOSTEVENT, cast(ткст0)&addr, addr.sizeof,
		ПСемействоАдресов.INET, cast(ткст0)результат.hostentBytes, результат.hostentBytes.length);
	if(!h)
		_getHostErr();
	
	результат.h = h;
	результат.обрвыз = обрвыз;
	allGetHosts[h] = результат;
	
	return результат;
}


// Shortcut.
GetHost asyncGetHostByAddr(Ткст addr, GetHostCallback обрвыз) // docmain
{
	бцел uiaddr;
	uiaddr = DInternetAddress.parse(addr);
	if(DInternetAddress.ADDR_NONE == uiaddr)
		_getHostErr();
	return asyncGetHostByAddr(uiaddr, обрвыз);
}


class SocketQueue // docmain
{
		this(Сокет сок)
	in
	{
		assert(сок !is пусто);
	}
	body
	{
		this.сок = сок;
	}
	
	
		final Сокет socket() // getter
	{
		return сок;
	}
	
	
		проц сброс()
	{
		writebuf = пусто;
		readbuf = пусто;
	}
	
	
	/+
	// DMD 0.92 says ошибка: function вТкст overrides but is not covariant with вТкст
	Ткст вТкст()
	{
		return cast(Ткст)peek();
	}
	+/
	
	
		проц[] peek()
	{
		return readbuf[0 .. rpos];
	}
	
	
	проц[] peek(бцел len)
	{
		if(len >= rpos)
			return peek();
		
		return readbuf[0 .. len];
	}
	
	
		проц[] receive()
	{
		ббайт[] результат;
		
		результат = readbuf[0 .. rpos];
		readbuf = пусто;
		rpos = 0;
		
		return результат;
	}
	
	
	проц[] receive(бцел len)
	{
		if(len >= rpos)
			return receive();
		
		ббайт[] результат;
		
		результат = readbuf[0 .. len];
		readbuf = readbuf[len .. readbuf.length];
		rpos -= len;
		
		return результат;
	}
	
	
		проц send(проц[] buf)
	{
		if(canwrite)
		{
			assert(!writebuf.length);
			
			цел st;
			if(buf.length > 4096)
				st = 4096;
			else
				st = buf.length;
			
			st = сок.send(buf[0 .. st]);
			if(st > 0)
			{
				if(buf.length - st)
				{
					// dup so it can be appended to.
					writebuf = (cast(ббайт[])buf)[st .. buf.length].dup;
				}
			}
			else
			{
				// dup so it can be appended to.
				writebuf = (cast(ббайт[])buf).dup;
			}
			
			//canwrite = нет;
		}
		else
		{
			writebuf ~= cast(ббайт[])buf;
		}
	}
	
	
		// Number of bytes in send queue.
	бцел sendBytes() // getter
	{
		return writebuf.length;
	}
	
	
		// Number of bytes in recv queue.
	бцел receiveBytes() // getter
	{
		return rpos;
	}
	
	
		// Same signature as ОбрВызСобРег for simplicity.
	проц событие(Сокет _sock, ТипСобытия тип, цел err)
	in
	{
		assert(_sock is сок);
	}
	body
	{
		switch(тип)
		{
			case ТипСобытия.READ:
				readEvent();
				break;
			
			case ТипСобытия.WRITE:
				writeEvent();
				break;
			
			default: ;
		}
	}
	
	
		// Call on а read событие so that incoming данные may be buffered.
	проц readEvent()
	{
		if(readbuf.length - rpos < 1024)
			readbuf.length = readbuf.length + 2048;
		
		цел rd = сок.receive(readbuf[rpos .. readbuf.length]);
		if(rd > 0)
			rpos += cast(бцел)rd;
	}
	
	
		// Call on а write событие so that buffered outgoing данные may be sent.
	проц writeEvent()
	{
		if(writebuf.length)
		{
			ббайт[] buf;
			
			if(writebuf.length > 4096)
				buf = writebuf[0 .. 4096];
			else
				buf = writebuf;
			
			цел st = сок.send(buf);
			if(st > 0)
				writebuf = writebuf[st .. writebuf.length];
		}
		else
		{
			//canwrite = да;
		}
	}
	
	
	deprecated
	{
		alias receiveBytes recvBytes;
		alias receive recv;
	}
	
	
	private:
	ббайт[] writebuf;
	ббайт[] readbuf;
	бцел rpos;
	Сокет сок;
	//бул canwrite = нет;
	
	
	бул canwrite() // getter
	{
		return writebuf.length == 0;
	}
}


private:

struct ИнфОСобытии
{
	Сокет сок;
	ОбрВызСобРег обрвыз;
}


const UINT WM_VIZ_NETEVENT = WM_USER + 104;
const UINT WM_VIZ_HOSTEVENT = WM_USER + 105;
const Ткст NETEVENT_CLASSNAME = "VIZ_NetEvent";

ИнфОСобытии[т_сокет] всеСобытия;
GetHost[HANDLE] allGetHosts;
УОК hwNet;


extern(Windows) LRESULT netWndProc(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
{
	switch(сооб)
	{
		case WM_VIZ_NETEVENT:
			if(cast(т_сокет)wparam in всеСобытия)
			{
				ИнфОСобытии ei = всеСобытия[cast(т_сокет)wparam];
				ei.обрвыз(ei.сок, cast(ТипСобытия)LOWORD(lparam), HIWORD(lparam));
			}
			break;
		
		case WM_VIZ_HOSTEVENT:
			if(cast(HANDLE)wparam in allGetHosts)
			{
				GetHost gh;
				gh = allGetHosts[cast(HANDLE)wparam];
				assert(gh !is пусто);
				//delete allGetHosts[cast(HANDLE)wparam];
				allGetHosts.удали(cast(HANDLE)wparam);
				gh._gotEvent(lparam);
			}
			break;
		
		default: ;
	}
	
	return 1;
}


проц _init()
{
	WNDCLASSEXA wce;
	wce.cbSize = wce.sizeof;
	wce.lpszClassName = NETEVENT_CLASSNAME.ptr;
	wce.lpfnWndProc = &netWndProc;
	wce.hInstance = GetModuleHandleA(пусто);
	
	if(!RegisterClassExA(&wce))
	{
		debug(APP_PRINT)
			эхо("RegisterClassEx() failed for network событие class.\n");
		
		init_err:
		throw new ВизИскл("Unable to initialize asynchronous socket library");
	}
	
	hwNet = CreateWindowExA(0, NETEVENT_CLASSNAME.ptr, "", 0, 0, 0, 0, 0, HWND_MESSAGE, пусто, wce.hInstance, пусто);
	if(!hwNet)
	{
		// Guess it doesn't support HWND_MESSAGE, so just try пусто родитель.
		
		hwNet = CreateWindowExA(0, NETEVENT_CLASSNAME.ptr, "", 0, 0, 0, 0, 0, пусто, пусто, wce.hInstance, пусто);
		if(!hwNet)
		{
			debug(APP_PRINT)
				эхо("CreateWindowEx() failed for network событие окно.\n");
			
			goto init_err;
		}
	}
}

} // Not WINE.

