//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.commondialog;

private import viz.control, viz.x.winapi, viz.base, viz.drawing,
	viz.event;
private import viz.app;

public import viz.filedialog, viz.folderdialog, viz.colordialog, viz.fontdialog;


abstract class ОбщийДиалог // docmain
{
		abstract проц сброс();
	
		// Uses currently active окно of the приложение as хозяин.
	abstract ПРезДиалога покажиДиалог();
	
	
	abstract ПРезДиалога покажиДиалог(ИОкно хозяин);
	
	
		Событие!(ОбщийДиалог, АргиСобСправка) helpRequest;
	
	
	protected:
	
		// See the CDN_* Windows notification messages.
	LRESULT hookProc(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
	{
		switch(сооб)
		{
			case WM_NOTIFY:
				{
					NMHDR* nmhdr;
					nmhdr = cast(NMHDR*)lparam;
					switch(nmhdr.code)
					{
						case CDN_HELP:
							{
								Точка тчк;
								GetCursorPos(&тчк.точка);
								onHelpRequest(new АргиСобСправка(тчк));
							}
							break;
						
						default: ;
					}
				}
				break;
			
			default: ;
		}
		
		return 0;
	}
	
	
	// TODO: implement.
	//LRESULT ownerWndProc(УОК уок, UINT сооб, WPARAM wparam, LPARAM lparam)
	
	
		проц onHelpRequest(АргиСобСправка ea)
	{
		helpRequest(this, ea);
	}
	
	
		abstract бул запустиДиалог(УОК хозяин);
	
	
	package final проц _cantrun()
	{
		throw new ВизИскл("Error running dialog");
	}
}

