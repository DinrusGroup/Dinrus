//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.tooltip;


private import viz.x.dlib, stdrus;

private import viz.control, viz.base, viz.application, viz.x.winapi,
	viz.x.utf;


class ToolTip // docmain
{
	package this(DWORD стиль)
	{
		_initCommonControls(ICC_TREEVIEW_CLASSES); // Includes tooltip.
		
		hwtt = CreateWindowExA(WS_EX_TOPMOST | WS_EX_TOOLWINDOW, _TOOLTIPS_CLASSA.ptr,
			"", стиль, 0, 0, 50, 50, пусто, пусто, пусто, пусто);
		if(!hwtt)
			throw new ВизИскл("Unable to create tooltip");
	}
	
	
	this()
	{
		this(cast(DWORD)WS_POPUP);
	}
	
	
	~this()
	{
		removeAll(); // Fixes ref count.
		DestroyWindow(hwtt);
	}
	
	
		final УОК указатель() // getter
	{
		return hwtt;
	}
	
	
		final проц active(бул подтвержд) // setter
	{
		SendMessageA(hwtt, TTM_ACTIVATE, подтвержд, 0); // ?
		_active = подтвержд;
	}
	
	
	final бул active() // getter
	{
		return _active;
	}
	
	
		// Sets autoPopDelay, initialDelay and reshowDelay.
	final проц automaticDelay(DWORD ms) // setter
	{
		SendMessageA(hwtt, TTM_SETDELAYTIME, TTDT_AUTOMATIC, ms);
	}
	
	/+
	
	final DWORD automaticDelay() // getter
	{
	}
	+/
	
	
		final проц autoPopDelay(DWORD ms) // setter
	{
		SendMessageA(hwtt, TTM_SETDELAYTIME, TTDT_AUTOPOP, ms);
	}
	
	/+
	
	final DWORD autoPopDelay() // getter
	{
	}
	+/
	
	
		final проц initialDelay(DWORD ms) // setter
	{
		SendMessageA(hwtt, TTM_SETDELAYTIME, TTDT_INITIAL, ms);
	}
	
	/+
	
	final DWORD initialDelay() // getter
	{
	}
	+/
	
	
		final проц reshowDelay(DWORD ms) // setter
	{
		SendMessageA(hwtt, TTM_SETDELAYTIME, TTDT_RESHOW, ms);
	}
	
	/+
	
	final DWORD reshowDelay() // getter
	{
	}
	+/
	
	
		final проц showAlways(бул подтвержд) // setter
	{
		LONG wl;
		wl = GetWindowLongA(hwtt, GWL_STYLE);
		if(подтвержд)
		{
			if(wl & TTS_ALWAYSTIP)
				return;
			wl |= TTS_ALWAYSTIP;
		}
		else
		{
			if(!(wl & TTS_ALWAYSTIP))
				return;
			wl &= ~TTS_ALWAYSTIP;
		}
		SetWindowLongA(hwtt, GWL_STYLE, wl);
	}
	
	
	final бул showAlways() // getter
	{
		return (GetWindowLongA(hwtt, GWL_STYLE) & TTS_ALWAYSTIP) != 0;
	}
	
	
		// Remove все tooltip текст associated with this instance.
	final проц removeAll()
	{
		TOOLINFOA tool;
		tool.cbSize = TOOLINFOA.sizeof;
		while(SendMessageA(hwtt, TTM_ENUMTOOLSA, 0, cast(LPARAM)&tool))
		{
			SendMessageA(hwtt, TTM_DELTOOLA, 0, cast(LPARAM)&tool);
			Приложение.refCountDec(cast(проц*)this);
		}
	}
	
	
		// WARNING: possible buffer overflow.
	final Ткст getToolTip(УпрЭлт упрэлм)
	{
		Ткст результат;
		TOOLINFOA tool;
		tool.cbSize = TOOLINFOA.sizeof;
		tool.uFlags = TTF_IDISHWND;
		tool.уок = упрэлм.указатель;
		tool.uId = cast(UINT)упрэлм.указатель;
		
		if(viz.x.utf.использоватьЮникод)
		{
			tool.lpszText = cast(typeof(tool.lpszText))malloc((MAX_TIP_TEXT_LENGTH + 1) * wchar.sizeof);
			if(!tool.lpszText)
				throw new ВнеПамИскл;
			scope(exit)
				free(tool.lpszText);
			tool.lpszText[0 .. 2] = 0;
			SendMessageA(hwtt, TTM_GETTEXTW, 0, cast(LPARAM)&tool);
			if(!(cast(шткст0)tool.lpszText)[0])
				результат = пусто;
			else
				результат = изЮникода0(cast(шткст0)tool.lpszText);
		}
		else
		{
			tool.lpszText = cast(typeof(tool.lpszText))malloc(MAX_TIP_TEXT_LENGTH + 1);
			if(!tool.lpszText)
				throw new ВнеПамИскл;
			scope(exit)
				free(tool.lpszText);
			tool.lpszText[0] = 0;
			SendMessageA(hwtt, TTM_GETTEXTA, 0, cast(LPARAM)&tool);
			if(!tool.lpszText[0])
				результат = пусто;
			else
				результат = изАнзи0(tool.lpszText); // Assumes изАнзи0() copies.
		}
		return результат;
	}
	
	
	final проц setToolTip(УпрЭлт упрэлм, Ткст текст)
	in
	{
		try
		{
			упрэлм.создайУпрЭлт();
		}
		catch(Объект o)
		{
			assert(0); // If -упрэлм- is а child, make sure the родитель is установи before setting tool tip текст.
			//throw o;
		}
	}
	body
	{
		TOOLINFOA tool;
		tool.cbSize = TOOLINFOA.sizeof;
		tool.uFlags = TTF_IDISHWND;
		tool.уок = упрэлм.указатель;
		tool.uId = cast(UINT)упрэлм.указатель;
		
		if(!текст.length)
		{
			if(SendMessageA(hwtt, TTM_GETTOOLINFOA, 0, cast(LPARAM)&tool))
			{
				// Remove.
				
				SendMessageA(hwtt, TTM_DELTOOLA, 0, cast(LPARAM)&tool);
				
				Приложение.refCountDec(cast(проц*)this);
			}
			return;
		}
		
		// Hack to помощь prevent getToolTip() overflow.
		if(текст.length > MAX_TIP_TEXT_LENGTH)
			текст = текст[0 .. MAX_TIP_TEXT_LENGTH];
		
		if(SendMessageA(hwtt, TTM_GETTOOLINFOA, 0, cast(LPARAM)&tool))
		{
			// Update.
			
			if(viz.x.utf.использоватьЮникод)
			{
				tool.lpszText = cast(typeof(tool.lpszText))вЮни0(текст);
				SendMessageA(hwtt, TTM_UPDATETIPTEXTW, 0, cast(LPARAM)&tool);
			}
			else
			{
				tool.lpszText = cast(typeof(tool.lpszText))небезопАнзи0(текст);
				SendMessageA(hwtt, TTM_UPDATETIPTEXTA, 0, cast(LPARAM)&tool);
			}
		}
		else
		{
			// Add.
			
			/+
			// TOOLINFOA.rect is ignored if TTF_IDISHWND.
			tool.rect.лево = 0;
			tool.rect.верх = 0;
			tool.rect.право = упрэлм.клиентРазм.ширина;
			tool.rect.низ = упрэлм.клиентРазм.высота;
			+/
			tool.uFlags |= TTF_SUBCLASS; // Not а good idea ?
			LRESULT lr;
			if(viz.x.utf.использоватьЮникод)
			{
				tool.lpszText = cast(typeof(tool.lpszText))вЮни0(текст);
				lr = SendMessageA(hwtt, TTM_ADDTOOLW, 0, cast(LPARAM)&tool);
			}
			else
			{
				tool.lpszText = cast(typeof(tool.lpszText))небезопАнзи0(текст);
				lr = SendMessageA(hwtt, TTM_ADDTOOLA, 0, cast(LPARAM)&tool);
			}
			
			if(lr)
				Приложение.refCountInc(cast(проц*)this);
		}
	}
	
	
	private:
	const Ткст _TOOLTIPS_CLASSA = "tooltips_class32";
	const т_мера MAX_TIP_TEXT_LENGTH = 2045;
	
	УОК hwtt; // Tooltip упрэлт указатель.
	бул _active = да;
}

