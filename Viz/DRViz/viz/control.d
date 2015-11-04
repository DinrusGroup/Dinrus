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

module dgui.control;

public import std.string;
public import std.массив;

public import dgui.core.winapi;
public import dgui.core.windowclass;
public import dgui.core.collection;
public import dgui.core.events;
public import dgui.menu;

debug
{
	public import std.stdio;
}

final void convertRect(inout Rect rect, Control from, Control to)
{
	MapWindowPoints(from ? from.handle : пусто, to ? to.handle : пусто, cast(POINT*)&rect.rect, 2);
}

final void convertPoint(inout Point тчк, Control from, Control to)
{
	MapWindowPoints(from ? from.handle : пусто, to ? to.handle : пусто, &тчк.точка, 1);
}

struct PreCreateWindow
{
	string ClassName;
	string OldClassName; //Per fare SuperClassing
	Color DefaultBackColor;
	Color DefaultForeColor;
	Cursor DefaultCursor;
	ClassStyles ClassStyle;
	uint ExtendedStyle = 0;
	uint Style = 0;
}

private struct ControlInfo
{
	Color ForeColor;
	Color BackColor;
	Rect Bounds;
	ContextMenu Menu;
	//ContainerControl Parent;
	Control Parent;
	ContextMenu CtxMenu;
	string Text;
	Font DefaultFont;
	Cursor DefaultCursor;
	ControlStyle CStyle = ControlStyle.NONE;
	DockStyle Dock = DockStyle.NONE;
	HBRUSH ForeBrush;
	HBRUSH BackBrush;
	uint ExtendedStyle = 0;
	uint Style = 0;
	бул MouseEnter = нет;
}

interface IDialogResult
{
	void dialogResult(DialogResult result);
}

interface ИУпрЭлтКонтейнер
{
	void addChildControl(Control);
}

abstract class Control: Handle!(HWND), IDisposable
{
	protected Collection!(Control) _childControls;
	protected ControlInfo _controlInfo;

	public Signal!(Control, KeyCharEventArgs) симКлавиши;
	public Signal!(Control, KeyEventArgs) keyDown;
	public Signal!(Control, KeyEventArgs) keyUp;
	public Signal!(Control, EventArgs) click;
	public Signal!(Control, MouseEventArgs) doubleClick;
	public Signal!(Control, MouseEventArgs) mouseKeyDown;
	public Signal!(Control, MouseEventArgs) mouseKeyUp;
	public Signal!(Control, MouseEventArgs) mouseMove;
	public Signal!(Control, MouseEventArgs) mouseEnter;
	public Signal!(Control, MouseEventArgs) mouseLeave;
	public Signal!(Control, MouseWheelEventArgs) mouseWheel;
	public Signal!(Control, ScrollEventArgs) scroll;
	public Signal!(Control, PaintEventArgs) отрисовка;
	public Signal!(Control, EventArgs) handleCreated;
	public Signal!(Control, EventArgs) перемерка;
	public Signal!(Control, EventArgs) видимостьИзменена;

	public this()
	{
		this.установиСтиль(WS_VISIBLE, да);
	}

	public ~this()
	{
		this.dispose();
	}

	public void dispose()
	{		
		if(this._controlInfo.BackBrush)
		{
			DeleteObject(this._controlInfo.BackBrush);
		}

		if(this._controlInfo.ForeBrush)
		{
			DeleteObject(this._controlInfo.ForeBrush);
		}

		if(this._handle)
		{
			DestroyWindow(this._handle);
		}

		this._handle = пусто;
	}

	public final Collection!(Control) controls()
	{
		return this._childControls;
	}

	public final Rect bounds()
	{
		return this._controlInfo.Bounds;
 	}

	public void bounds(Rect rect)
	{
		if(this.created)
		{
			this.setWindowPos(rect.лево, rect.top, rect.width, rect.height, PositionSpecified.ALL);
		}
		else
		{
			this._controlInfo.Bounds = rect;
		}
	}

	public final BorderStyle borderStyle()
	{
		if(this.getExStyle() & WS_EX_CLIENTEDGE)
		{
			return BorderStyle.FIXED_3D;
		}
		else if(this.дайСтиль() & WS_BORDER)
		{
			return BorderStyle.FIXED_SINGLE;
		}

		return BorderStyle.NONE;
	}

	public final void borderStyle(BorderStyle bs)
	{		
		switch(bs)
		{
			case BorderStyle.FIXED_3D:
				this.установиСтиль(WS_BORDER, нет);
				this.setExStyle(WS_EX_CLIENTEDGE, да);
				break;

			case BorderStyle.FIXED_SINGLE:
				this.установиСтиль(WS_BORDER, да);
				this.setExStyle(WS_EX_CLIENTEDGE, нет);
				break;
			
			case BorderStyle.NONE:
				this.установиСтиль(WS_BORDER, нет);
				this.setExStyle(WS_EX_CLIENTEDGE, нет);
				break;

			default:
				assert(0, "Unknown Border Style");
				//break;
		}
	}

	public final Control parent()
	{
		return this._controlInfo.Parent;
	}

	public final void parent(Control ктрл)
	{
		this._controlInfo.Parent = ктрл;
		this.установиСтиль(WS_CHILD, да); //E' un child
		
		ИУпрЭлтКонтейнер cc = cast(ИУпрЭлтКонтейнер)ктрл;

		if(cc) //Non è un ContainerControl, associa solo l'handle.
		{
			cc.addChildControl(this);
		}
	}

	public final Control topLevelControl()
	{
		Control topCtrl = this;

		while(topCtrl.parent)
		{
			topCtrl = topCtrl.parent;
		}

		return topCtrl;
	}

	public final Canvas createCanvas()
	{
		return Canvas.fromHDC(GetDC(this._handle));
	}

	public final void focus()
	{
		if(this.created)
		{
			SetFocus(this._handle);
		}
	}

	public final Color backColor()
	{
		return this._controlInfo.BackColor;
	}

	public final void backColor(Color ктрл)
	{
		if(this._controlInfo.BackBrush)
		{
			DeleteObject(this._controlInfo.BackBrush);
		}
		
		this._controlInfo.BackColor = ктрл;
		this._controlInfo.BackBrush = CreateSolidBrush(ктрл.colorref);
		
		if(this.created)
		{
			this.redraw();
		}
	}

	public final Color foreColor()
	{
		return this._controlInfo.ForeColor;
	}

	public final void foreColor(Color ктрл)
	{
		if(this._controlInfo.ForeBrush)
		{
			DeleteObject(this._controlInfo.ForeBrush);
		}
		
		this._controlInfo.ForeColor = ктрл;
		this._controlInfo.ForeBrush = CreateSolidBrush(ктрл.colorref);
		
		if(this.created)
		{
			this.redraw();
		}
	}

	public final бул полосыПрокрутки()
	{
		return cast(бул)(this.дайСтиль() & (WS_VSCROLL | WS_HSCROLL));
	}

	public final void полосыПрокрутки(бул с)
	{
		this.установиСтиль(WS_VSCROLL | WS_HSCROLL, да);
	}

	public final string text()
	{
		if(this.created)
		{
			int len = this.шлиСооб(WM_GETTEXTLENGTH, 0, 0) + сим.sizeof;
			
			сим[] buffer = new сим[len];
			this.шлиСооб(WM_GETTEXT, len, cast(LPARAM)buffer.ptr);
			return recalcString(buffer);
		}
		
		return this._controlInfo.Text;
	}

	public void text(string s) //Sovrascritto in TabPage
	{
		this._controlInfo.Text = s;

		if(this.created)
		{
			this.шлиСооб(WM_SETTEXT, 0, cast(LPARAM)toStringz(s));
		}
	}

	public final Font font()
	{	
		return this._controlInfo.DefaultFont;
	}

	public final void font(Font f)
	{		
		if(this.created)
		{
			if(this._controlInfo.DefaultFont)
			{
				this._controlInfo.DefaultFont.dispose();
			}
			
			this.шлиСооб(WM_SETFONT, cast(WPARAM)f.handle, да);
		}

		this._controlInfo.DefaultFont = f;
	}

	public final Point location()
	{
		return this.bounds.location;
	}

	public final void location(Point тчк)
	{
		this._controlInfo.Bounds.location = тчк;

		if(this.created)
		{
			this.setWindowPos(тчк.ш, тчк.в, 0, 0, PositionSpecified.POSITION);
		}
	}

	public final Size size()
	{
		return this._controlInfo.Bounds.size;
 	}

	public final void size(Size разм)
	{
		this._controlInfo.Bounds.size = разм;

		if(this.created)
		{
			this.setWindowPos(0, 0, разм.width, разм.height, PositionSpecified.РАЗМЕР);
		}
	}

	public final ContextMenu contextMenu()
	{
		return this._controlInfo.CtxMenu;
	}

	public final void contextMenu(ContextMenu cm)
	{
		if(this._controlInfo.CtxMenu !is cm)
		{
			if(this._controlInfo.CtxMenu)
			{
				this._controlInfo.CtxMenu.dispose();
			}
			
			this._controlInfo.CtxMenu = cm;
		}
	}	

	public final int width()
	{
		return this._controlInfo.Bounds.width;
	}

	public final void width(int w)
	{
		this._controlInfo.Bounds.width = w;

		if(this.created)
		{
			this.setWindowPos(0, 0, w, 0, PositionSpecified.WIDTH);
		}
	}

	public final int height()
	{
		return this._controlInfo.Bounds.height;
	}

	public final void height(int h)
	{
		this._controlInfo.Bounds.height = h;

		if(this.created)
		{
			this.setWindowPos(0, 0, 0, h, PositionSpecified.HEIGHT); 
		}
	}

	public final DockStyle док()
	{
		return this._controlInfo.Dock;
	}

	public final void док(DockStyle ds)
	{
		this._controlInfo.Dock = ds;

		if(this.created)
		{			
			this.doDock();
		}
	}

	public final Cursor cursor()
	{
		if(this.created)
		{
			return Cursor.fromHCURSOR(cast(КУРСОР)GetClassLongA(this._handle, GCL_HCURSOR), нет);
		}

		return this._controlInfo.DefaultCursor;
	}

	public final void cursor(Cursor ктрл)
	{
		if(this._controlInfo.DefaultCursor)
		{
			this._controlInfo.DefaultCursor.dispose();
		}
		
		this._controlInfo.DefaultCursor = ктрл;
		
		if(this.created)
		{
			this.шлиСооб(WM_SETCURSOR, cast(WPARAM)this._handle, 0);
		}
	}

	public final бул visible()
	{
		return cast(бул)(this.дайСтиль() & WS_VISIBLE);
	}

	public final void visible(бул с)
	{
		if(this.created)
		{
			SetWindowPos(this._handle, пусто, 0, 0, 0, 0, SWP_NOZORDER | SWP_NOMOVE | SWP_NOSIZE | (с ? SWP_SHOWWINDOW : SWP_HIDEWINDOW)); // Ridisegna il componente

			if(this._controlInfo.Parent)
			{
				this._controlInfo.Parent.doDock(); // Aggiusta le dimensioni dei componenti
			}
		}
		else
		{
			this.установиСтиль(WS_VISIBLE, с);
		}
	}

	public final бул enabled()
	{
		return !(this.дайСтиль() & WS_DISABLED);
	}

	public final void enabled(бул с)
	{
		if(this.created)
		{
			EnableWindow(this._handle, с);
		}
		else
		{
			this.установиСтиль(WS_DISABLED, !с);
		}
	}

	public void show()
	{
		this.установиСтиль(WS_VISIBLE, да);
	}

	public final void hide()
	{
		this.установиСтиль(WS_VISIBLE, нет);
	}

	public final void redraw()
	in
	{
		assert(this.created);
	}
	body
	{
		SetWindowPos(this._handle, пусто, 0, 0, 0, 0, SWP_NOZORDER | SWP_NOMOVE | SWP_NOSIZE | SWP_FRAMECHANGED);
	}

	public final void invalidate()
	in
	{
		assert(this.created);
	}
	body
	{
		this.invalidate(NullRect);
	}

	public final void invalidate(Rect к)
	in
	{
		assert(this.created);
	}
	body
	{
		InvalidateRect(this._handle, к == NullRect ? пусто : &к.rect, нет);
	}

	public final uint шлиСооб(uint msg, WPARAM парам1, LPARAM парам2)
	in
	{
		assert(this.created, "Cannot send сообщение (Handle not created)");
	}
	body
	{
		/*
		 * Emulazione invio messaggi
		 */
		
		return this.окПроц(msg, парам1, парам2);
	}

	public final void doDock()
	{
		static void dockSingle(Control t, inout Rect da)
		{
			switch(t.док)
			{
				case DockStyle.LEFT:
					t.setWindowPos(da.лево, da.top, t.width, da.height, PositionSpecified.POSITION | PositionSpecified.HEIGHT);
					da.лево += t.width;
					break;
				
				case DockStyle.TOP:
					t.setWindowPos(da.лево, da.top, da.width, t.height, PositionSpecified.POSITION | PositionSpecified.WIDTH);
					da.top += t.height;
					break;

				case DockStyle.RIGHT:
					t.setWindowPos(da.right - t.width, da.top, t.width, da.height, PositionSpecified.ALL);
					da.right -= t.width;
					break;

				case DockStyle.BOTTOM:
					t.setWindowPos(da.лево, da.bottom - t.height, da.width, t.height, PositionSpecified.ALL);
					da.bottom -= t.height;
					break;
				
				case DockStyle.FILL:
					t.bounds = da;
					da.size = NullSize;
					break;
				
				default:
					assert(нет, "Unknown DockStyle");
					//break;
			}
		}

		if(this._childControls && this.created && this.visible && !(this._controlInfo.CStyle & ControlStyle.DOCKING))
		{
			this.установиСтиль(ControlStyle.DOCKING, да);
			
			Rect dockArea = void;
			GetClientRect(this._handle, &dockArea.rect); //Ricava la Client Area.
			
			foreach(Control t; this._childControls)
			{				
				if(dockArea.пуст)
				{
					break;
				}
				
				if(t.док !is DockStyle.NONE && t.visible && t.created)
				{
					dockSingle(t, dockArea);
				}
			}

			this.установиСтиль(ControlStyle.DOCKING, нет);
		}
	}

	private Control getChildControl(HWND уок)
	{
		if(this._childControls && уок)
		{
			foreach(Control ктрл; this._childControls)
			{
				if(ктрл.handle == уок)
				{
					return ктрл;
				}
			}
		}

		return пусто;
	}

	private uint reflectMessage(uint msg, WPARAM парам1, LPARAM парам2)
	{
		HWND hFrom = void; //Inizializzata sotto

		switch(msg)
		{
			case WM_NOTIFY:
				NMHDR* pNotify = cast(NMHDR*)парам2;
				hFrom = pNotify.hwndFrom;
				break;

			case WM_MEASUREITEM:
				MEASUREITEMSTRUCT* pMeasureItem = cast(MEASUREITEMSTRUCT*)парам2;
				hFrom = cast(HWND)pMeasureItem.CtlID;
				break;

			case WM_DRAWITEM:
				DRAWITEMSTRUCT* pDrawItem = cast(DRAWITEMSTRUCT*)парам2;
				hFrom = pDrawItem.CtlType != ODT_COMBOBOX ? pDrawItem.hwndItem : GetParent(pDrawItem.hwndItem);
				break;

			default: // WM_COMMAND
				hFrom = cast(HWND)парам2;
				break;
		}

		Control ктрл = this.getChildControl(hFrom);

		if(ктрл)
		{
			return ктрл.поОбратномуСообщению(msg, парам1, парам2);
		}

		return 0;
	}
	
	extern(Windows) private static LRESULT msgRouter(HWND уок, uint msg, WPARAM парам1, LPARAM парам2)
	{		
		if(msg == WM_NCCREATE)
		{
			/*
			 * TRICK: Id == уок
			 * ---
			 * Inizializzazione Componente
			 */
		
			CREATESTRUCTA* pCreateStruct = cast(CREATESTRUCTA*)парам2;
			LPARAM param = cast(LPARAM)pCreateStruct.lpCreateParams;
			SetWindowLongA(уок, GWL_USERDATA, param);
			SetWindowLongA(уок, GWL_ID, cast(uint)уок);

			Control theThis = winCast!(Control)(param);
			theThis._handle = уок;	//Assegno l'handle.
		}

		Control theThis = winCast!(Control)(GetWindowLongA(уок, GWL_USERDATA));

		if(theThis)
		{
			return theThis.окПроц(msg, парам1, парам2);
		}

		return Control.дефОкПроц(уок, msg, парам1, парам2);
	}

	private void onMenuCommand(WPARAM парам1, LPARAM парам2)
	{
		MENUITEMINFOA minfo;
		
		minfo.cbSize = MENUITEMINFOA.sizeof;
		minfo.fMask = MIIM_DATA;
		
		if(GetMenuItemInfoA(cast(HMENU)парам2, cast(UINT)парам1, TRUE, &minfo))
		{
			MenuItem sender = winCast!(MenuItem)(minfo.dwItemData);
			sender.performClick();
		}
	}

	package final void create(бул модальное = нет)
	{
		static HINSTANCE hInst;
		PreCreateWindow pcw;

		if(!hInst)
		{
			hInst = getHInstance();
		}

		pcw.Style = this._controlInfo.Style;				 //Copio Style Attuale
		pcw.ExtendedStyle = this._controlInfo.ExtendedStyle; //Copio ExtendedStyle Attuale
		pcw.DefaultBackColor = СистемныеЦвета.colorBtnFace;
		pcw.DefaultForeColor = СистемныеЦвета.colorBtnText;

		this.preCreateWindow(pcw);

		this._controlInfo.BackBrush = CreateSolidBrush(pcw.DefaultBackColor.colorref);
		this._controlInfo.ForeBrush = CreateSolidBrush(pcw.DefaultForeColor.colorref);

		if(pcw.DefaultCursor)
		{
			this._controlInfo.DefaultCursor = pcw.DefaultCursor;
		}

		if(!this._controlInfo.DefaultFont)
		{
			this._controlInfo.DefaultFont = SystemFonts.windowsFont;
		}
		
		if(!this._controlInfo.BackColor.valid) // Invalid Color
		{
			this.backColor = pcw.DefaultBackColor;
		}
		
		if(!this._controlInfo.ForeColor.valid) // Invalid Color
		{
			this.foreColor = pcw.DefaultForeColor;
		}

		uint style = pcw.Style;

		if(модальное) //E' una finestra modale?
		{
			style &= ~WS_CHILD;
			style |= WS_POPUP;
		}

		HWND hParent = пусто;

		if(this._controlInfo.Parent)
		{
			hParent = this._controlInfo.Parent.handle;
		}

		if(модальное) //E' una finestra modale?
		{
			hParent = GetActiveWindow();
		}

		CreateWindowExA(pcw.ExtendedStyle, 
						toStringz(pcw.ClassName), 
						toStringz(this._controlInfo.Text), 
						style,
						this._controlInfo.Bounds.ш,
						this._controlInfo.Bounds.в,
						this._controlInfo.Bounds.width,
						this._controlInfo.Bounds.height,
						hParent,
						пусто,
						hInst,
						winCast!(void*)(this));

		if(!this._handle)
		{
			debug
			{
				throw new Win32Exception(format("Control Creation failed.\nClassName: \"%s\", Text: \"%s\"", 
										 pcw.ClassName, this._controlInfo.Text), __FILE__, __LINE__);
			}
			else
			{
				throw new Win32Exception(format("Control Creation failed.\nClassName: \"%s\", Text: \"%s\"", 
										 pcw.ClassName, this._controlInfo.Text));
			}
		}
	}

	protected final void setWindowPos(int ш, int в, int w, int h, PositionSpecified ps)
	{
		if(ps is PositionSpecified.NONE)
		{
			return;
		}

		if(this.created)
		{
			uint wpf = SWP_NOZORDER | SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOSIZE;

			if(ps & PositionSpecified.X)
			{
				if(!(ps & PositionSpecified.Y))
				{
					в = this._controlInfo.Bounds.в;
				}

				wpf &= ~SWP_NOMOVE;
			}
			else if(ps & PositionSpecified.Y)
			{
				ш = this._controlInfo.Bounds.ш;
				wpf &= ~SWP_NOMOVE;
			}

			if(ps & PositionSpecified.WIDTH)
			{
				if(!(ps & PositionSpecified.HEIGHT))
				{
					h = this._controlInfo.Bounds.height;
				}

				wpf &= ~SWP_NOSIZE;
			}
			else if(ps & PositionSpecified.HEIGHT)
			{
				w = this._controlInfo.Bounds.width;
				wpf &= ~SWP_NOSIZE;
			}

			SetWindowPos(this._handle, пусто, ш, в, w, h, wpf); //Bounds aggiornati in WM_WINDOWPOSCHANGED
		}
		else
		{
			if(ps & PositionSpecified.X)
			{
				this._controlInfo.Bounds.ш = ш;
			}

			if(ps & PositionSpecified.Y)
			{
				this._controlInfo.Bounds.в = в;
			}

			if(ps & PositionSpecified.WIDTH)
			{
				if(w < 0)
				{
					w = 0;
				}

				this._controlInfo.Bounds.width = w;
			}

			if(ps & PositionSpecified.HEIGHT)
			{
				if(h < 0)
				{
					h = 0;
				}

				this._controlInfo.Bounds.height = h;
			}
		}
	}

	protected void lockRedraw(бул lock)
	{
		this.шлиСооб(WM_SETREDRAW, !lock, 0);

		if(!lock)
		{
			RedrawWindow(this._handle, пусто, пусто, RDW_ERASE | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN);
		}
	}

	protected final void initDC(HDC hdc)
	{
		SetBkColor(hdc, this.backColor.colorref);
		SetTextColor(hdc, this.foreColor.colorref);
	}

	protected final uint дайСтиль()
	{
		if(this.created)
		{
			return GetWindowLongA(this._handle, GWL_STYLE);
		}

		return this._controlInfo.Style;
	}

	protected final void установиСтиль(uint cstyle, бул установи)
	{
		if(this.created)
		{
			uint style = this.дайСтиль();
			установи ? (style |= cstyle) : (style &= ~cstyle);

			SetWindowLongA(this._handle, GWL_STYLE, style);
			this.redraw();
			this._controlInfo.Style = style;
		}
		else
		{
			установи ? (this._controlInfo.Style |= cstyle) : (this._controlInfo.Style &= ~cstyle);
		}
	}

	protected final void установиСтиль(ControlStyle cstyle, бул установи)
	{
		установи ? (this._controlInfo.CStyle |= cstyle) : (this._controlInfo.CStyle &= ~cstyle);
	}

	protected final uint getExStyle()
	{
		if(this.created)
		{
			return GetWindowLongA(this._handle, GWL_EXSTYLE);
		}

		return this._controlInfo.ExtendedStyle;
	}

	protected final void setExStyle(uint cstyle, бул установи)
	{
		if(this.created)
		{
			uint exStyle = this.getExStyle();
			установи ? (exStyle |= cstyle) : (exStyle &= ~cstyle);
		
			SetWindowLongA(this._handle, GWL_EXSTYLE, exStyle);
			this.redraw();
			this._controlInfo.ExtendedStyle = exStyle;
		}
		else
		{
			установи ? (this._controlInfo.ExtendedStyle |= cstyle) : (this._controlInfo.ExtendedStyle &= ~cstyle);
		}
	}
	
	protected void preCreateWindow(inout PreCreateWindow pcw)
	{
		ClassStyles cstyle = pcw.ClassStyle | ClassStyles.PARENTDC | ClassStyles.DBLCLKS;

		if(this._controlInfo.CStyle & ControlStyle.RESIZE_REDRAW)
		{
			cstyle |= ClassStyles.HREDRAW | ClassStyles.VREDRAW;
		}
		
		registerWindowClass(pcw.ClassName, cstyle, pcw.DefaultCursor, &Control.msgRouter);
	}

	protected int originalWndProc(uint msg, WPARAM парам1, LPARAM парам2)
	{
		return Control.дефОкПроц(this._handle, msg, парам1, парам2);
	}

	protected static int дефОкПроц(HWND уок, uint msg, WPARAM парам1, LPARAM парам2)
	{
		if(!IsWindowUnicode(уок))
		{
			return DefWindowProcA(уок, msg, парам1, парам2);
		}
		else
		{
			return DefWindowProcW(уок, msg, парам1, парам2);
		}
	}

	protected int поОбратномуСообщению(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_CTLCOLOREDIT, WM_CTLCOLORBTN:
				initDC(cast(HDC)парам1);
				return cast(int)this._controlInfo.BackBrush;
				//break;
			
			default:
				return Control.дефОкПроц(this._handle, msg, парам1, парам2);
		}
	}

	protected void onClick(EventArgs e)
	{
		this.click(this, e);
	}

	protected void onKeyUp(KeyEventArgs e)
	{
		this.keyUp(this, e);
	}

	protected void onKeyDown(KeyEventArgs e)
	{
		this.keyDown(this, e);
	}

	protected void onKeyChar(KeyCharEventArgs e)
	{
		this.симКлавиши(this, e);
	}

	protected void onPaint(PaintEventArgs e)
	{
		this.отрисовка(this, e);
	}

	protected void поСозданиюУказателя(EventArgs e)
	{
		this.handleCreated(this, e);
	}

	protected void onResize(EventArgs e)
	{
		this.перемерка(this, e);
	}

	protected void onVisibleChanged(EventArgs e)
	{
		this.видимостьИзменена(this, e);
	}

	protected void onMouseKeyDown(MouseEventArgs e)
	{
		this.mouseKeyDown(this, e);
	}

	protected void onMouseKeyUp(MouseEventArgs e)
	{
		this.mouseKeyUp(this, e);
	}

	protected void onDoubleClick(MouseEventArgs e)
	{
		this.doubleClick(this, e);
	}

	protected void onMouseMove(MouseEventArgs e)
	{
		this.mouseMove(this, e);
	}

	protected void onMouseEnter(MouseEventArgs e)
	{
		this.mouseEnter(this, e);
	}

	protected void onMouseLeave(MouseEventArgs e)
	{
		this.mouseLeave(this, e);
	}

	protected void onMouseWheel(MouseWheelEventArgs e)
	{
		this.mouseWheel(this, e);
	}

	protected void onScroll(ScrollEventArgs e)
	{
		this.scroll(this, e);
	}

	protected void приОтрисовкеФона(HDC hdc)
	{
		RECT к = void;
		GetClientRect(this._handle, &к);
		ExtTextOutA(hdc, 0, 0, ETO_НЕПРОЗРАЧНЫЙ, &к, toStringz(""), 0, пусто);
	}

	protected int окПроц(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_ERASEBKGND:
			{
				if(!(this._controlInfo.CStyle & ControlStyle.NO_ERASE))
				{
					Rect к = void;
					GetClientRect(this._handle, &к.rect);

					HDC hdc = cast(HDC)парам1;
					initDC(hdc);
					this.приОтрисовкеФона(hdc);
				}

				return 1;
			}

			case WM_PAINT, WM_PRINTCLIENT:
			{
				PAINTSTRUCT ps; //Inizializzata da BeginPaint()
				BeginPaint(this._handle, &ps);
				initDC(ps.hdc);
				
				Rect к = Rect.fromRECT(&ps.rcPaint);
				scope Canvas ктрл = Canvas.fromHDC(ps.hdc); 
				scope PaintEventArgs e = new PaintEventArgs(ктрл, к);

				if((!(this._controlInfo.CStyle & ControlStyle.NO_ERASE)) && ps.fErase)
				{
					this.приОтрисовкеФона(ps.hdc);
				}

				this.onPaint(e);
				EndPaint(this._handle, &ps);				
				return 0;
			}
			
			case WM_CREATE: // Aggiornamento Font, rimuove FIXED SYS
			{				
				this.шлиСооб(WM_SETFONT, cast(WPARAM)this._controlInfo.DefaultFont.handle, да);

				if(this._controlInfo.CtxMenu)
				{
					HMENU hDefaultMenu = GetMenu(this._handle);

					if(hDefaultMenu)
					{
						DestroyMenu(hDefaultMenu); //Distruggo il menu predefinito (se esiste)
					}
					
					this._controlInfo.CtxMenu.create();
				}
				
				this.поСозданиюУказателя(EventArgs.пуст);
				return 0; //Continua...
			}

			case WM_WINDOWPOSCHANGED:
			{
				WINDOWPOS* pWndPos = cast(WINDOWPOS*)парам2;

				if(!(pWndPos.flags & SWP_NOMOVE) || !(pWndPos.flags & SWP_NOSIZE))
				{
					/*
					this._controlInfo.Bounds.ш = pWndPos.ш;
					this._controlInfo.Bounds.в = pWndPos.в;
					this._controlInfo.Bounds.width = pWndPos.cx;
					this._controlInfo.Bounds.height = pWndPos.cy;
					*/

					GetWindowRect(this._handle, &this._controlInfo.Bounds.rect);

					if(this._controlInfo.Parent)
					{
						convertRect(this._controlInfo.Bounds, пусто, this._controlInfo.Parent);
					}
					
					if(!(pWndPos.flags & SWP_NOSIZE))
					{
						this.onResize(EventArgs.пуст);
					}
				}
				else if(pWndPos.flags & SWP_SHOWWINDOW || pWndPos.flags & SWP_HIDEWINDOW)
				{
					if(pWndPos.flags & SWP_SHOWWINDOW)
					{
						this.doDock();
					}

					this.onVisibleChanged(EventArgs.пуст);
				}
				
				return this.originalWndProc(msg, парам1, парам2); //Cosi' invia anche WM_SIZE
			}

			case WM_NOTIFY, WM_COMMAND, WM_MEASUREITEM, WM_DRAWITEM, WM_CTLCOLOREDIT, WM_CTLCOLORBTN:
			{
				this.originalWndProc(msg, парам1, парам2);
				return this.reflectMessage(msg, парам1, парам2);
			}

			case WM_KEYDOWN:
			{				
				scope KeyEventArgs e = new KeyEventArgs(cast(Keys)парам1);
				this.onKeyDown(e);				

				if(e.handled)
				{
					return this.originalWndProc(msg, парам1, парам2);
				}

				return 0;
			}

			case WM_KEYUP:
			{
				scope KeyEventArgs e = new KeyEventArgs(cast(Keys)парам1);
				this.onKeyUp(e);

				if(e.handled)
				{
					return this.originalWndProc(msg, парам1, парам2);
				}

				return 0;
			}			

			case WM_CHAR:
			{				
				scope KeyCharEventArgs e = new KeyCharEventArgs(cast(Keys)парам1, cast(сим)парам1);
				this.onKeyChar(e);

				if(e.handled)
				{
					return this.originalWndProc(msg, парам1, парам2);
				}

				return 0;
			}

			case WM_MOUSELEAVE:
			{
				this._controlInfo.MouseEnter = нет;
				
				scope MouseEventArgs e = new MouseEventArgs(Point(LOWORD(парам2), HIWORD(парам2)), cast(MouseKeys)парам1);
				this.onMouseLeave(e);

				return this.originalWndProc(msg, парам1, парам2);
			}

			case WM_MOUSEMOVE:
			{
				scope MouseEventArgs e = new MouseEventArgs(Point(LOWORD(парам2), HIWORD(парам2)), cast(MouseKeys)парам1);
				this.onMouseMove(e);

				if(!this._controlInfo.MouseEnter)
				{
					this._controlInfo.MouseEnter = да;
					
					TRACKMOUSEEVENT tme;

					tme.cbSize = TRACKMOUSEEVENT.sizeof;
					tme.dwFlags = TME_LEAVE;
					tme.hwndTrack = this._handle;

					TrackMouseEvent(&tme);

					this.onMouseEnter(e);
				}

				return this.originalWndProc(msg, парам1, парам2);
			}

			case WM_MOUSEWHEEL:
			{
				short дельта = GetWheelDelta(парам1);
				scope MouseWheelEventArgs e = new MouseWheelEventArgs(Point(LOWORD(парам2), HIWORD(парам2)), 
																      cast(MouseKeys)парам1, дельта > 0 ? MouseWheel.UP : MouseWheel.DOWN);
				this.onMouseWheel(e);
				return this.originalWndProc(msg, парам1, парам2);
			}
			
			case WM_LBUTTONDOWN, WM_MBUTTONDOWN, WM_RBUTTONDOWN:
			{				
				scope MouseEventArgs e = new MouseEventArgs(Point(LOWORD(парам2), HIWORD(парам2)), cast(MouseKeys)парам1);
				this.onMouseKeyDown(e);

				return this.originalWndProc(msg, парам1, парам2);
			}

			case WM_LBUTTONUP, WM_MBUTTONUP, WM_RBUTTONUP:
			{
				MouseKeys mk = MouseKeys.NONE;

				if(GetAsyncKeyState(MK_LBUTTON))
				{
					mk |= MouseKeys.LEFT;
				}

				if(GetAsyncKeyState(MK_MBUTTON))
				{
					mk |= MouseKeys.MIDDLE;
				}

				if(GetAsyncKeyState(MK_RBUTTON))
				{
					mk |= MouseKeys.RIGHT;
				}
				
				scope MouseEventArgs e = new MouseEventArgs(Point(LOWORD(парам2), HIWORD(парам2)), mk);
				this.onMouseKeyUp(e);

				if(msg == WM_LBUTTONUP)
				{
					this.onClick(EventArgs.пуст);
				}
				
				return this.originalWndProc(msg, парам1, парам2);
			}

			case WM_LBUTTONDBLCLK, WM_MBUTTONDBLCLK, WM_RBUTTONDBLCLK:
			{				
				scope MouseEventArgs e = new MouseEventArgs(Point(LOWORD(парам2), HIWORD(парам2)), cast(MouseKeys)парам1);
				this.onDoubleClick(e);

				return this.originalWndProc(msg, парам1, парам2);
			}

			case WM_VSCROLL, WM_HSCROLL:
			{
				ScrollDir sd = msg == WM_VSCROLL ? ScrollDir.VERTICAL : ScrollDir.HORIZONTAL;
				ScrollMode sm = cast(ScrollMode)парам1;

				scope ScrollEventArgs e = new ScrollEventArgs(sd, sm);
				this.onScroll(e);

				return this.originalWndProc(msg, парам1, парам2);
			}

			case WM_SETCURSOR:
			{
				if(this._controlInfo.DefaultCursor && cast(LONG)this._controlInfo.DefaultCursor.handle != GetClassLongA(this._handle, GCL_HCURSOR))
				{
					SetClassLongA(this._handle, GCL_HCURSOR, cast(LONG)this._controlInfo.DefaultCursor.handle);
				}

				return this.originalWndProc(msg, парам1, парам2); //Continuo selezione cursore
			}
		
			case WM_MENUCOMMAND:
				this.onMenuCommand(парам1, парам2);
				return 0;

			case WM_CONTEXTMENU:
			{
				if(this._controlInfo.CtxMenu)
				{
					this._controlInfo.CtxMenu.popupMenu(this._handle, Cursor.location);
				}

				return this.originalWndProc(msg, парам1, парам2);				
			}

			case WM_INITMENU:
			{
				if(this._controlInfo.CtxMenu)
				{
					this._controlInfo.CtxMenu.поВсплытию(EventArgs.пуст);
				}
				
				return 0;
			}

			default:
				return this.originalWndProc(msg, парам1, парам2); //Processa il messaggio col codice originale
		}
	}
}

abstract class SubclassedControl: Control
{
	private WNDPROC _oldWndProc; // Window procedure originale
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		if(this._controlInfo.Parent) // Ha un parent
		{
			pcw.Style |= WS_TABSTOP;
		}
		
		this._oldWndProc = superClassWindowClass(pcw.OldClassName, pcw.ClassName, &SubclassedControl.msgRouter);
	}

	protected override void приОтрисовкеФона(HDC hdc)
	{
		this.originalWndProc(WM_ERASEBKGND, cast(WPARAM)hdc, 0);
	}
	
	protected final int originalWndProc(uint msg, WPARAM парам1, LPARAM парам2)
	{
		if(!IsWindowUnicode(this._handle))
		{
			return CallWindowProcA(this._oldWndProc, this._handle, msg, парам1, парам2);
		}
		else
		{
			return CallWindowProcW(this._oldWndProc, this._handle, msg, парам1, парам2);
		}
	}

	protected override int окПроц(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_PAINT:
			{				
				if(this._controlInfo.CStyle & ControlStyle.USER_PAINT)
				{
					return super.окПроц(msg, парам1, парам2);
				}
				else
				{					
					Rect к = void; // Inizializzato da GetUpdateRect()
					GetUpdateRect(this._handle, &к.rect, нет); //Conserva area da disegnare
					this.originalWndProc(msg, парам1, парам2);

					HDC hdc = GetDC(this._handle);
					HRGN hRgn = CreateRectRgnIndirect(&к.rect);
					SelectClipRgn(hdc, hRgn);
					DeleteObject(hRgn);

					initDC(hdc);
					scope Canvas ктрл = Canvas.fromHDC(hdc);
					scope PaintEventArgs e = new PaintEventArgs(ктрл, к);
					this.onPaint(e);
					
					ReleaseDC(this._handle, hdc);
				}
				
				return 0;
			}

			case WM_PRINTCLIENT:
				return this.originalWndProc(msg, парам1, парам2);

			case WM_CREATE:
				this.originalWndProc(msg, парам1, парам2); //Gestisco prima il messaggio originale
				return super.окПроц(msg, парам1, парам2);

			default:
				return super.окПроц(msg, парам1, парам2);
		}
	}
}

abstract class ContainerControl: Control, ИУпрЭлтКонтейнер
{	
	public override void dispose()
	{
		if(this._childControls)
		{
			foreach(Control t; this._childControls)
			{
				t.dispose();
			}
		}
		
		super.dispose();
	}

	protected final void addChildControl(Control ктрл)
	{
		if(!this._childControls)
		{
			this._childControls = new Collection!(Control);
		}
		
		this._childControls.add(cast(Control)ктрл);

		if(this.created)
		{
			ктрл.create();
		}
	}

	protected final void doChildControls()
	{
		if(this.controls)
		{
			foreach(Control ктрл; this.controls)
			{				
				if(!ктрл.created) //Check aggiuntivo: Evita di creare componenti duplicati (aggiunti а runtime).
				{
					ктрл.create();
					this.doDock();
				}
			}
		}
	}

	protected override void поСозданиюУказателя(EventArgs e)
	{
		this.doChildControls();   //Prima Crea i Componenti inseriti а compile-time...
		this.doDock(); //...poi fai il док...
		super.поСозданиюУказателя(e); //...e poi gestisci l'evento e crea i componenti aggiunti а runtime (se ce ne sono).
	}

	protected override void onResize(EventArgs e)
	{
		this.doDock();
		super.onResize(e);
	}

	protected override int окПроц(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_CLOSE:
				super.окПроц(msg, парам1, парам2);
				this.dispose();
				return 0;

			default:
				return super.окПроц(msg, парам1, парам2);
		}
	}
}

abstract class OwnerDrawControl: SubclassedControl
{
	public Signal!(Control, АргиСобИзмеренияЭлемента) measureItem;
	public Signal!(Control, DrawItemEventArgs) drawItem;

	protected ItemDrawMode _drawMode = ItemDrawMode.NORMAL;

	public ItemDrawMode drawMode()
	{
		return this._drawMode;
	}

	public void drawMode(ItemDrawMode dm)
	{
		this._drawMode = dm;
	}

	protected void onMeasureItem(АргиСобИзмеренияЭлемента e)
	{
		this.measureItem(this, e);
	}

	protected void onDrawItem(DrawItemEventArgs e)
	{
		this.drawItem(this, e);
	}

	protected override int поОбратномуСообщению(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_MEASUREITEM:
			{				
				MEASUREITEMSTRUCT* pMeasureItem = cast(MEASUREITEMSTRUCT*)парам2;
				HDC hdc = GetDC(this._handle);
				initDC(hdc);
					
				scope Canvas ктрл = Canvas.fromHDC(hdc);
				scope АргиСобИзмеренияЭлемента e = new АргиСобИзмеренияЭлемента(ктрл, pMeasureItem.ширинаЭлемента, pMeasureItem.itemHeight, 
																		   pMeasureItem.itemID);
																		   
				this.onMeasureItem(e);

				if(e.width)
				{
					pMeasureItem.ширинаЭлемента = e.width;
				}

				if(e.height)
				{
					pMeasureItem.itemHeight = e.height;
				}

				ReleaseDC(this._handle, пусто);
			}
			break;

			case WM_DRAWITEM:
			{
				DRAWITEMSTRUCT* pDrawItem = cast(DRAWITEMSTRUCT*)парам2;
				Rect к = Rect.fromRECT(&pDrawItem.rcItem);

				Color fc, bc;

				if(pDrawItem.itemState & ODS_SELECTED)
				{
					fc = СистемныеЦвета.colorHighLightText;
					bc = СистемныеЦвета.colorHighLight;
				}
				else
				{
					fc = this.foreColor;
					bc = this.backColor;
				}

				scope Canvas ктрл = Canvas.fromHDC(pDrawItem.hDC);
				scope DrawItemEventArgs e = new DrawItemEventArgs(ктрл, cast(DrawItemState)pDrawItem.itemState, 
																  к, fc, bc, pDrawItem.itemID);

				this.onDrawItem(e);
			}
			break;
			
			default:
				break;
		}

		return super.поОбратномуСообщению(msg, парам1, парам2);
	}
}