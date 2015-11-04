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

module dgui.toolbar;

public import dgui.control;
public import dgui.imagelist;

private const string WC_TOOLBAR = "ToolBarWindow32";
private const string WC_DTOOLBAR = "DToolBar";

enum ToolButtonStyle: ббайт
{
	BUTTON = TBSTYLE_BUTTON,
	SEPARATOR = TBSTYLE_SEP,
	DROPDOWN = TBSTYLE_DROPDOWN,
}

class ToolButton
{
	public Signal!(ToolButton, EventArgs) click;
	
	private ToolBar _владелец;
	private ContextMenu _ctxMenu;
	private ToolButtonStyle _tbs;
	private int _imgIndex;
	private бул _enabled;
	
	package this(ToolBar tb, ToolButtonStyle tbs, int imgIndex, бул enabled)
	{
		this._владелец = tb;
		this._tbs = tbs;
		this._imgIndex = imgIndex;
		this._enabled = enabled;
	}

	public final int индекс()
	{
		if(this._владелец && this._владелец.created && this._владелец.buttons)
		{
			int i = 0;

			foreach(ToolButton tbtn; this._владелец.buttons)
			{
				if(tbtn is this)
				{
					return i;
				}
				
				i++;
			}
		}
		
		return -1;
	}

	public final ToolButtonStyle style()
	{
		return this._tbs;
	}

	public final void style(ToolButtonStyle tbs)
	{
		this._tbs = tbs;

		if(this._владелец && this._владелец.created)
		{
			 TBBUTTONINFOA tbinfo = void;

			 tbinfo.cbSize = TBBUTTONINFOA.sizeof;
			 tbinfo.dwMask = TBIF_BYINDEX | TBIF_STYLE;
			 tbinfo.fsStyle = tbs;

			 this._владелец.шлиСооб(TB_SETBUTTONINFOA, this.индекс, cast(LPARAM)&tbinfo);
		}
	}

	public final int imageIndex()
	{
		return this._imgIndex;
	}

	public final void imageIndex(int idx)
	{
		this._imgIndex = idx;

		if(this._владелец && this._владелец.created)
		{
			 TBBUTTONINFOA tbinfo = void;

			 tbinfo.cbSize = TBBUTTONINFOA.sizeof;
			 tbinfo.dwMask = TBIF_BYINDEX | TBIF_IMAGE;
			 tbinfo.iImage = idx;

			 this._владелец.шлиСооб(TB_SETBUTTONINFOA, this.индекс, cast(LPARAM)&tbinfo);
		}
	}

	public final бул enabled()
	{
		return this._enabled;
	}

	public final void enabled(бул с)
	{
		this._enabled = с;

		if(this._владелец && this._владелец.created)
		{
			 TBBUTTONINFOA tbinfo = void;

			 tbinfo.cbSize = TBBUTTONINFOA.sizeof;
			 tbinfo.dwMask = TBIF_BYINDEX | TBIF_STATE;
			 this._владелец.шлиСооб(TB_GETBUTTONINFOA, this.индекс, cast(LPARAM)&tbinfo); //Ricavo i dati completi.

			 с ? (tbinfo.fsState |= TBSTATE_ENABLED) : (tbinfo.fsState &= ~TBSTATE_ENABLED);
			 this._владелец.шлиСооб(TB_SETBUTTONINFOA, this.индекс, cast(LPARAM)&tbinfo);
		}
	}

	public ContextMenu contextMenu()
	{
		return this._ctxMenu;
	}

	public void contextMenu(ContextMenu cm)
	{
		this._ctxMenu = cm;
	}

	public final ToolBar toolBar()
	{
		return this._владелец;
	}

	package void onToolBarButtonClick(EventArgs e)
	{
		this.click(this, e);
	}
}

class ToolBar: SubclassedControl
{
	private Collection!(ToolButton) _buttons;
	private ImageList _imgList;

	public final ImageList imageList()
	{
		return this._imgList;
	}

	public final void imageList(ImageList imgList)
	{
		this._imgList = imgList;

		if(this.created)
		{
			this.шлиСооб(TB_SETIMAGELIST, 0, cast(LPARAM)this._imgList.handle);
		}
	}

	public final ToolButton addDropdownButton(int imgIndex, ContextMenu ctxMenu, бул en = да)
	{
		if(!this._buttons)
		{
			this._buttons = new Collection!(ToolButton)();
		}
		
		ToolButton tb = new ToolButton(this, ToolButtonStyle.DROPDOWN, imgIndex, en);
		tb.contextMenu = ctxMenu;
		this._buttons.add(tb);

		if(this.created)
		{
			ToolBar.addItem(tb);
		}

		return tb;		
	}

	public final ToolButton addButton(int imgIndex, бул en = да)
	{
		if(!this._buttons)
		{
			this._buttons = new Collection!(ToolButton)();
		}
		
		ToolButton tb = new ToolButton(this, ToolButtonStyle.BUTTON, imgIndex, en);
		this._buttons.add(tb);

		if(this.created)
		{
			ToolBar.addItem(tb);
		}

		return tb;
	}

	public final void addSeparator()
	{
		if(!this._buttons)
		{
			this._buttons = new Collection!(ToolButton)();
		}
		
		ToolButton tb = new ToolButton(this, ToolButtonStyle.SEPARATOR, -1, да);
		this._buttons.add(tb);

		if(this.created)
		{
			ToolBar.addItem(tb);
		}
	}

	public final void removeButton(int idx)
	{
		this._buttons.removeAt(idx);
		
		if(this.created)
		{
			this.шлиСооб(TB_DELETEBUTTON, idx, 0);
		}
	}

	public final Collection!(ToolButton) buttons()
	{
		return this._buttons;
	}

	private void forceToolbarSize()
	{
		uint разм = this.шлиСооб(TB_GETBUTTONSIZE, 0, 0);

		this.size = Size(LOWORD(разм), HIWORD(разм));
	}

	private static void addItem(ToolButton tb)
	{
		TBBUTTON tbtn;

		switch(tb.style)
		{
			case ToolButtonStyle.BUTTON, ToolButtonStyle.DROPDOWN:
				tbtn.iBitmap = tb.imageIndex;
				tbtn.fsStyle = cast(ббайт)tb.style;
				tbtn.fsState = cast(ббайт)(tb.enabled ? TBSTATE_ENABLED : 0);
				tbtn.dwData = winCast!(uint)(tb);
				break;

			case ToolButtonStyle.SEPARATOR:
				tbtn.fsStyle = cast(ббайт)tb.style;
				break;

			default:
				assert(нет, "Unknown ToolButton Style");
		}

		if(tb.toolBar._controlInfo.Dock is DockStyle.LEFT || tb.toolBar._controlInfo.Dock is DockStyle.RIGHT)
		{
			tbtn.fsState |= TBSTATE_WRAP;
		}

		tb.toolBar.шлиСооб(TB_INSERTBUTTONA, tb.индекс, cast(LPARAM)&tbtn);		
	}

	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{		
		pcw.OldClassName = WC_TOOLBAR;
		pcw.ClassName = WC_DTOOLBAR;
		pcw.Style |= TBSTYLE_FLAT | CCS_NODIVIDER | CCS_NOPARENTALIGN;

		if(this._controlInfo.Dock is DockStyle.NONE)
		{
			this._controlInfo.Dock = DockStyle.TOP;
		}

		if(this._controlInfo.Dock is DockStyle.LEFT || this._controlInfo.Dock is DockStyle.RIGHT)
		{
			pcw.Style |= CCS_VERT;
		}
		
		super.preCreateWindow(pcw);
	}

	protected override void поСозданиюУказателя(EventArgs e)
	{
		this.шлиСооб(TB_BUTTONSTRUCTSIZE, TBBUTTON.sizeof, 0);
		int exStyle = this.шлиСооб(TB_GETEXTENDEDSTYLE, 0, 0);
		this.шлиСооб(TB_SETEXTENDEDSTYLE, 0, exStyle | TBSTYLE_EX_DRAWDDARROWS);
		this.forceToolbarSize(); // HACK: Forza il ridimensionamento della barra strumenti.

		if(this._imgList)
		{
			this.шлиСооб(TB_SETIMAGELIST, 0, cast(LPARAM)this._imgList.handle);
		}

		if(this._buttons)
		{
			foreach(ToolButton tb; this._buttons)
			{
				ToolBar.addItem(tb);
			}
		}
		
		super.поСозданиюУказателя(e);
	}

	protected override int поОбратномуСообщению(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{
			case WM_NOTIFY:
			{
				NMHDR* pNmhdr = cast(NMHDR*)парам2;

				switch(pNmhdr.code)
				{
					case NM_CLICK:
					{
						NMMOUSE* pNMouse = cast(NMMOUSE*)парам2;
						ToolButton tBtn = winCast!(ToolButton)(pNMouse.dwItemData);

						if(tBtn)
						{
							tBtn.onToolBarButtonClick(EventArgs.пуст);
						}
					}
					break;

					case TBN_DROPDOWN:
					{
						NMTOOLBARA* pNmToolbar = cast(NMTOOLBARA*)парам2;

						Point тчк = Cursor.location;
						convertPoint(тчк, пусто, this);
						int idx = this.шлиСооб(TB_HITTEST, 0, cast(LPARAM)&тчк.точка);

						if(idx != -1)
						{
							ToolButton tbtn = this._buttons[idx];

							if(tbtn && tbtn.contextMenu)
							{
								tbtn.contextMenu.popupMenu(this._handle, Cursor.location);
							}
						}
					}
					break;
					
					default:
						break;
				}
			}
			
			default:
				break;
		}
		
		return super.поОбратномуСообщению(msg, парам1, парам2);
	}

	protected override int окПроц(uint msg, WPARAM парам1, LPARAM парам2)
	{
		if(msg == WM_WINDOWPOSCHANGING)
		{
			/*
			 * HACK: Forza il ridimensionamento della barra strumenti.
			 */
			
			WINDOWPOS* pWindowPos = cast(WINDOWPOS*)парам2;
			uint разм = this.шлиСооб(TB_GETBUTTONSIZE, 0, 0);

			switch(this._controlInfo.Dock)
			{
				case DockStyle.TOP, DockStyle.BOTTOM:
					pWindowPos.cy = HIWORD(разм);
					break;
				
				case DockStyle.LEFT, DockStyle.RIGHT:
					pWindowPos.cx = LOWORD(разм);
					break;

				default:
					break;
			}
		}

		return super.окПроц(msg, парам1, парам2);
	}
}