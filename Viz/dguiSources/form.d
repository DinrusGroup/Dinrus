/*
	Copyright (ктрл) 2011 Trogu Antonio Davide

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received а копируй of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

module dgui.form;

public import dgui.control;

private const string WC_FORM = "DForm";

private struct FormInfo
{
	MenuBar Menu;
	Пиктограмма FormIcon;
	FormStartPosition StartPosition = FormStartPosition.MANUAL;
	DialogResult Result = DialogResult.CANCEL;
	FormBorderStyle FrameBorder = FormBorderStyle.SIZEABLE;
	HWND hActiveWnd;
	бул ModalCompleted = нет;
	бул MaximizeBox = да;
	бул MinimizeBox = да;
	бул ControlBox = да;
	бул ShowInTaskbar = нет;
}

class Form: ContainerControl, IDialogResult
{
	private FormInfo _formInfo;

	public Signal!(Control, EventArgs) close;
	public Signal!(Control, CancelEventArgs) закрывается;
	
	public final void formBorderStyle(FormBorderStyle fbs)
	{
		if(this.created)
		{
			uint style, exStyle;

			makeFormBorderStyle(this._formInfo.FrameBorder, style, exStyle); // Vecchio Stile.
			this.установиСтиль(style, нет);
			this.setExStyle(exStyle, нет);

			style = 0;
			exStyle = 0;

			makeFormBorderStyle(fbs, style, exStyle); // Nuovo Stile.
			this.установиСтиль(style, да);
			this.setExStyle(exStyle, да);
		}
		
		this._formInfo.FrameBorder = fbs;
	}

	public final void dialogResult(DialogResult dr)
	{
		this._formInfo.Result = dr;
		this._formInfo.ModalCompleted = да; //E' arrivato il click di un pulsante.

		ShowWindow(this._handle, SW_HIDE); // Hide this окно (it waits to be destroyed)
		SetActiveWindow(this._formInfo.hActiveWnd); // Restore the previous active окно
	}
	
	public final void боксУпрЭлта(бул с)
	{
		this._formInfo.ControlBox = с;
		
		if(this.created)
		{
			this.установиСтиль(WS_SYSMENU, с);
		}
	}

	public final void maximizeBox(бул с)
	{
		this._formInfo.MaximizeBox = с;
		
		if(this.created)
		{
			this.установиСтиль(WS_MAXIMIZEBOX, с);
		}
	}

	public final void minimizeBox(бул с)
	{
		this._formInfo.MinimizeBox = с;
		
		if(this.created)
		{
			this.установиСтиль(WS_MINIMIZEBOX, с);
		}
	}

	public final void покажиВСтрокеЗадач(бул с)
	{
		this._formInfo.ShowInTaskbar = с;
		
		if(this.created)
		{
			this.setExStyle(WS_EX_APPWINDOW, с);
		}
	}

	public final MenuBar menu()
	{
		return this._formInfo.Menu;
	}

	public final void menu(MenuBar mb)
	{
		if(this.created)
		{
			if(this._formInfo.Menu)
			{
				this._formInfo.Menu.dispose();
			}

			mb.create();
			SetMenu(this._handle, mb.handle);
		}

		this._formInfo.Menu = mb;
	}

	public final Пиктограмма пиктограмма()
	{
		return this._formInfo.FormIcon;
	}

	public final void пиктограмма(Пиктограмма ico)
	{
		if(this.created)
		{
			if(this._formInfo.FormIcon)
			{
				this._formInfo.FormIcon.dispose();
			}
			
			this.шлиСооб(WM_SETICON, ICON_BIG, cast(LPARAM)ico.handle);
			this.шлиСооб(WM_SETICON, ICON_SMALL, cast(LPARAM)ico.handle);
		}

		this._formInfo.FormIcon = ico;
	}

	public final void стартPosition(FormStartPosition fsp)
	{
		this._formInfo.StartPosition = fsp;
	}

	public final DialogResult showDialog()
	{
		if(!this.created)
		{			
			try
			{
				this._formInfo.hActiveWnd = GetActiveWindow();
				EnableWindow(this._formInfo.hActiveWnd, нет);
				this.create(да);
			
				MSG m = void; //Inizializzato sotto.

				for(;;)
				{
					if(this._formInfo.ModalCompleted)
					{
						break;
					}
					
					while(PeekMessageA(&m, пусто, 0, 0, PM_REMOVE)) //Gestisci tutti i messaggi in coda
					{
						if(!IsDialogMessageA(this._handle, &m))
						{
							TranslateMessage(&m);
							DispatchMessageA(&m);
						}
					}

					WaitMessage(); //Aspetta fino al prossimo messaggio.
				}
			}
			finally
			{
				EnableWindow(this._formInfo.hActiveWnd, да);
				SetActiveWindow(this._formInfo.hActiveWnd);
			}
		}

		return this._formInfo.Result;
	}

	public override void show()
	{
		if(!this.created)
		{
			this.create();
		}

		super.show();
	}

	private final void doFormStartPosition()
	{
		if((this._formInfo.StartPosition is FormStartPosition.CENTER_PARENT && !this.parent) || 
			this._formInfo.StartPosition is FormStartPosition.CENTER_SCREEN)
		{
			Rect wa = Экран.workArea;
			Rect с = this._controlInfo.Bounds;
			
			this._controlInfo.Bounds.location = Point((wa.width - с.width) / 2, 
													  (wa.height - с.height) / 2);
		}
		else if(this._formInfo.StartPosition is FormStartPosition.CENTER_PARENT)
		{
			Rect pr = this.parent.bounds;
			Rect с = this._controlInfo.Bounds;

			this._controlInfo.Bounds.location = Point(pr.лево + (pr.width - с.width) / 2, 
													  pr.top + (pr.height - с.height) / 2);
		}
		else if(this._formInfo.StartPosition is FormStartPosition.DEFAULT_LOCATION)
		{
			this._controlInfo.Bounds.location = Point(CW_USEDEFAULT, CW_USEDEFAULT);
		}
	}

	private static void makeFormBorderStyle(FormBorderStyle fbs, ref uint style, ref uint exStyle)
	{
		switch(fbs)
		{
			case FormBorderStyle.FIXED_3D:
				style &= ~(WS_BORDER | WS_THICKFRAME | WS_DLGFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_STATICEDGE);
				
				style |= WS_CAPTION;
				exStyle |= WS_EX_CLIENTEDGE | WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME;
				break;
			
			case FormBorderStyle.FIXED_DIALOG:
				style &= ~(WS_BORDER | WS_THICKFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);
			
				style |= WS_CAPTION | WS_DLGFRAME;
				exStyle |= WS_EX_DLGMODALFRAME | WS_EX_WINDOWEDGE;
				break;
			
			case FormBorderStyle.FIXED_SINGLE:
				style &= ~(WS_THICKFRAME | WS_DLGFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_WINDOWEDGE | WS_EX_STATICEDGE);
			
				style |= WS_CAPTION | WS_BORDER;
				exStyle |= WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME;
				break;
			
			case FormBorderStyle.FIXED_TOOLWINDOW:
				style &= ~(WS_BORDER | WS_THICKFRAME | WS_DLGFRAME);
				exStyle &= ~(WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);
			
				style |= WS_CAPTION;
				exStyle |= WS_EX_TOOLWINDOW | WS_EX_WINDOWEDGE | WS_EX_DLGMODALFRAME;
				break;
			
			case FormBorderStyle.SIZEABLE:
				style &= ~(WS_BORDER | WS_DLGFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME | WS_EX_STATICEDGE);
			
				style |= WS_CAPTION | WS_THICKFRAME;
				exStyle |= WS_EX_WINDOWEDGE;
				break;
			
			case FormBorderStyle.SIZEABLE_TOOLWINDOW:
				style &= ~(WS_BORDER | WS_DLGFRAME);
				exStyle &= ~(WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME | WS_EX_STATICEDGE);

				style |= WS_THICKFRAME | WS_CAPTION;
				exStyle |= WS_EX_TOOLWINDOW | WS_EX_WINDOWEDGE;
				break;
			
			case FormBorderStyle.NONE:
				style &= ~(WS_BORDER | WS_THICKFRAME | WS_CAPTION | WS_DLGFRAME);
				exStyle &= ~(WS_EX_TOOLWINDOW | WS_EX_CLIENTEDGE | WS_EX_DLGMODALFRAME | WS_EX_STATICEDGE | WS_EX_WINDOWEDGE);
				break;

			default:
				assert(0, "Unknown Form Border Style");
				//break;
		}		
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.ClassName = WC_FORM;
		pcw.DefaultCursor = SystemCursors.стрелка;

		makeFormBorderStyle(this._formInfo.FrameBorder, pcw.Style, pcw.ExtendedStyle);
		this.doFormStartPosition();

		this._formInfo.ControlBox ? (pcw.Style |= WS_SYSMENU) : (pcw.Style &= ~WS_SYSMENU);

		if(this._formInfo.ControlBox)
		{
			this._formInfo.MaximizeBox ? (pcw.Style |= WS_MAXIMIZEBOX) : (pcw.Style &= ~WS_MAXIMIZEBOX);
			this._formInfo.MinimizeBox ? (pcw.Style |= WS_MINIMIZEBOX) : (pcw.Style &= ~WS_MINIMIZEBOX);
		}

		if(this._formInfo.ShowInTaskbar)
		{
			pcw.ExtendedStyle |= WS_EX_APPWINDOW;
		}

		AdjustWindowRectEx(&this._controlInfo.Bounds.rect, pcw.Style, нет, pcw.ExtendedStyle);
		super.preCreateWindow(pcw);
	}

	protected override void поСозданиюУказателя(EventArgs e)
	{
		if(this._formInfo.Menu)
		{
			this._formInfo.Menu.create();
			SetMenu(this._handle, this._formInfo.Menu.handle);
			DrawMenuBar(this._handle);
		}
		
		if(this._formInfo.FormIcon)
		{	
			this.originalWndProc(WM_SETICON, ICON_BIG, cast(LPARAM)this._formInfo.FormIcon.handle);
			this.originalWndProc(WM_SETICON, ICON_SMALL, cast(LPARAM)this._formInfo.FormIcon.handle);
		}

		super.поСозданиюУказателя(e); //Per ultimo: Prima deve creare il menu se нет i componenti si dispongono male.
	}

	protected override int окПроц(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_CLOSE:
			{
				scope CancelEventArgs e = new CancelEventArgs();
				this.onClosing(e);

				if(!e.cancel)
				{
					this.onClose(EventArgs.пуст);

					if(this._formInfo.hActiveWnd)
					{
						EnableWindow(this._formInfo.hActiveWnd, да);
						SetActiveWindow(this._formInfo.hActiveWnd);
					}
					
					return super.окПроц(msg, парам1, парам2);
				}

				return 0;
			}

			default:
				return super.окПроц(msg, парам1, парам2);
		}
	}

	protected void onClosing(CancelEventArgs e)
	{
		this.закрывается(this, e);
	}

	protected void onClose(EventArgs e)
	{
		this.close(this, e);
	}
}