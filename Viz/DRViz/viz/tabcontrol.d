﻿/*
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

module dgui.tabcontrol;

public import dgui.imagelist;
public import dgui.control;
public import std.string;

private const string WC_TABКОНТРОЛ ="SysTabControl32";
private const string WC_DTABКОНТРОЛ = "DTabControl";
private const string WC_DTABPAGE = "DTabPage";

private struct TcItem
{
	TC_ITEMHEADERA Header;
	TabPage Page;
}

private struct TabControlInfo
{
	TabPage SelectedPage;
	int SelectedIndex = -1;
}

enum TabAlignment
{
	TOP    = 0,
	LEFT   = TCS_VERTICAL,
	RIGHT  = TCS_VERTICAL | TCS_RIGHT,
	BOTTOM = TCS_BOTTOM,
}

class TabPage: ContainerControl
{
	private int _imgIndex;
	private TabControl _владелец;

	private this()
	{
		
	}

	public final int индекс()
	{
		if(this._владелец && this._владелец.created && this._владелец.tabPages)
		{
			int i = 0;
			
			foreach(TabPage tp; this._владелец.tabPages)
			{
				if(tp is this)
				{
					return i;
				}

				i++;
			}
		}

		return -1;
	}

	package void tabControl(TabControl tc)
	{
		this._владелец = tc;
	}

	public final TabControl tabControl()
	{
		return this._владелец;
	}

	alias Control.text text;

	public override void text(string txt)
	{
		super.text = txt;

		if(this._владелец && this._владелец.created)
		{
			TcItem tci = void;

			tci.Header.mask = TCIF_TEXT;
			tci.Header.pszText = std.string.toStringz(txt);

			this._владелец.шлиСооб(TCM_SETITEMA, this.индекс, cast(LPARAM)&tci);
			this.redraw();
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
			TcItem tci = void;

			tci.Header.mask = TCIF_IMAGE;
			tci.Header.iImage = idx;

			this._владелец.шлиСооб(TCM_SETITEMA, this.индекс, cast(LPARAM)&tci);
		}
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.ExtendedStyle = WS_EX_STATICEDGE;
		pcw.ClassName = WC_DTABPAGE;
		pcw.DefaultCursor = SystemCursors.стрелка;
		
		super.preCreateWindow(pcw);
	}
}

class TabControl: OwnerDrawControl, ИУпрЭлтКонтейнер
{
	public Signal!(Control, CancelEventArgs) tabPageChanging;
	public Signal!(Control, EventArgs) tagPageChanged;

	private Collection!(TabPage) _tabPages;
	private ImageList _imgList;
	private int _selIndex = 0; //Di default seleziona il primo TabPage.
	private TabAlignment _ta = TabAlignment.TOP;

	public final T addPage(T: TabPage = TabPage)(string t, int imgIndex = -1)
	{
		T tp = new T();
		tp.text = t;
		tp.imageIndex = imgIndex;
		tp.visible = нет;
		tp.tabControl = this;
		tp.parent = this;

		if(this.created)
		{
			this.createTabPage(tp);
		}

		return tp;		
	}

	public final void removePage(int idx)
	{
		if(this.created)
		{
			this.removeTabPage(idx);
		}
		
		this._tabPages.removeAt(idx);
	}

	public final Collection!(TabPage) tabPages()
	{
		return this._tabPages;
	}
	
	public final TabPage selectedPage()
	{
		if(this._tabPages)
		{
			return this._tabPages[this._selIndex];
		}

		return пусто;
	}

	public final void selectedPage(TabPage stp)
	{		
		this.selectedIndex = stp.индекс;
	}

	public final int selectedIndex()
	{
		return this._selIndex;
	}

	public final void selectedIndex(int idx)
	{
		if(this._tabPages)
		{
			TabPage sp = this.selectedPage; 	//Vecchio TabPage
			TabPage tp = this._tabPages[idx];	//Nuovo TabPage	

			if(sp && sp !is tp)
			{
				this._selIndex = idx;
				tp.visible = да;  //Visualizzo il nuovo TabPage
				sp.visible = нет; //Nascondo il vecchio TabPage
			}
			else if(sp is tp) // E' lo stesso TabPage, rendilo visibile (succede quando si aggiunge un TabPage а runtime)
			{
				/*
				 * Di default i TabPage appena creati sono nascosti.
				 */
				
				tp.visible = да;
			}

			if(this.created)
			{
				TabControl.adjustTabPage(tp);
			}			
		}
	}

	public final ImageList imageList()
	{
		return this._imgList;
	}

	public final void imageList(ImageList imgList)
	{
		this._imgList = imgList;

		if(this.created)
		{
			this.шлиСооб(TCM_SETIMAGELIST, 0, cast(LPARAM)this._imgList.handle);
		}
	}

	public final TabAlignment расположение()
	{
		return this._ta;
	}

	public final void расположение(TabAlignment ta)
	{
		this.установиСтиль(this._ta, нет);
		this.установиСтиль(ta, да);
		
		this._ta = ta;
	}

	private static void adjustTabPage(TabPage selPage)
	{
		/*
		 * Resize TabPage e posizionamento al centro del TabControl
		 */

		Rect к, adjRect;

		TabControl tc = selPage.tabControl;				
		GetClientRect(tc.handle, &к.rect);
		tc.шлиСооб(TCM_ADJUSTRECT, FALSE, cast(LPARAM)&adjRect.rect);

		к.лево += adjRect.лево;
		к.top += adjRect.top;
		к.right += к.лево + adjRect.width;
		к.bottom += к.top + adjRect.height;
		
		selPage.bounds = к; //Fa anche il Dock (inviati WM_WINDOWPOSCHANGED -> WM_MOVE -> WM_SIZE)
	}

	private TcItem createTabPage(TabPage tp, бул adding = да)
	{
		TcItem tci;
		tci.Header.mask = TCIF_IMAGE | TCIF_TEXT | TCIF_PARAM;		
		tci.Header.iImage = tp.imageIndex;
		tci.Header.pszText = std.string.toStringz(tp.text);
		tci.Page = tp;

		tp.create();

		int idx = tp.индекс;
		this.шлиСооб(TCM_INSERTITEMA, idx, cast(LPARAM)&tci);

		if(adding) //Il componente e' stato creato in precedentemente, verra' selezionato l'ultimo TabPage.
		{
			this.шлиСооб(TCM_SETCURSEL, idx, 0);
			this.selectedIndex = idx;
		}
		
		return tci;
	}

	private void removeTabPage(int idx)
	{		
		if(this._tabPages)
		{
			if(idx == this._selIndex)
			{
				this.selectedIndex = idx > 0 ? idx - 1 : 0;
			}

			if(this.created)
			{
				this.шлиСооб(TCM_DELETEITEM, idx, 0);
				this.шлиСооб(TCM_SETCURSEL, this._selIndex, 0); //Mi posiziono nel nuovo tab
			}

			TabPage tp = this._tabPages[idx];
			tp.dispose(); //Deallocazione Risorse.
		}
	}

	protected final void addChildControl(Control ктрл)
	{		
		if(!this._tabPages)
		{
			this._tabPages = new Collection!(TabPage)();
		}

		this._tabPages.add(cast(TabPage)ктрл);
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.OldClassName = WC_TABКОНТРОЛ;
		pcw.ClassName = WC_DTABКОНТРОЛ;
		pcw.DefaultCursor = SystemCursors.стрелка;
		
		super.preCreateWindow(pcw);
	}

	protected override void поСозданиюУказателя(EventArgs e)
	{
		if(this._imgList)
		{
			this.шлиСооб(TCM_SETIMAGELIST, 0, cast(LPARAM)this._imgList.handle);
		}

		if(this._tabPages)
		{
			int i;
			TcItem tci = void;
			
			foreach(TabPage tp; this._tabPages)
			{
				tci = this.createTabPage(tp, нет);

				if(i == this._selIndex)
				{
					tp.visible = да;
					TabControl.adjustTabPage(tp);
				}

				i++;
			}

			this.selectedIndex = this._selIndex;
		}

		super.поСозданиюУказателя(e);
	}

	protected override int поОбратномуСообщению(uint msg, WPARAM парам1, LPARAM парам2)
	{
		if(msg == WM_NOTIFY)
		{	
			NMHDR* pNotify = cast(NMHDR*)парам2;

			switch(pNotify.code)
			{
				case TCN_SELCHANGING:
				{
					scope CancelEventArgs e = new CancelEventArgs();

					this.onTabPageChanging(e);
					return e.cancel;
				}

				case TCN_SELCHANGE:
				{
					this.selectedIndex = this.шлиСооб(TCM_GETCURSEL, 0, 0);
					this.onTabPageChanged(EventArgs.пуст);
					return 0;
					
				}
				
				default:
					break;
			}
		}
		
		return super.поОбратномуСообщению(msg, парам1, парам2);
	}

	protected void onTabPageChanging(CancelEventArgs e)
	{
		this.tabPageChanging(this, e);
	}

	protected void onTabPageChanged(EventArgs e)
	{
		this.tagPageChanged(this, e);
	}

	protected override int окПроц(uint msg, WPARAM парам1, LPARAM парам2)
	{
		switch(msg)
		{			
			case WM_WINDOWPOSCHANGED:
			{
				WINDOWPOS* pWndPos = cast(WINDOWPOS*)парам2;
				
				if(!(pWndPos.flags & SWP_NOMOVE) || !(pWndPos.flags & SWP_NOSIZE))
				{
					if(this._tabPages)
					{
						TabControl.adjustTabPage(this.selectedPage);
					}
				}
			}
			break;
			
			default:
				break;
		}

		return super.окПроц(msg, парам1, парам2);
	}
}