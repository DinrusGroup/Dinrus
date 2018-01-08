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

module dgui.menu;

public import dgui.core.winapi;
import std.string;

public import dgui.core.collection;
public import dgui.core.idisposable;
public import dgui.core.events;
public import dgui.core.signal;
public import dgui.core.handle;
public import dgui.core.utils;

enum: uint
{
	MIIM_STRING 		= 64,
	MIIM_FTYPE  		= 256,
	
	MIM_MAXHEIGHT       = 1,
	MIM_BACKGROUND      = 2,
	MIM_HELPID          = 4,
	MIM_MENUDATA        = 8,
	MIM_STYLE           = 16,
	MIM_APPLYTOSUBMENUS = 0x80000000L,

	MNS_NOCHECK    		= 0x80000000,
	MNS_MODELESS    	= 0x40000000,
	MNS_DRAGDROP    	= 0x20000000,
	MNS_AUTODISMISS 	= 0x10000000,
	MNS_NOTIFYBYPOS 	= 0x08000000,
	MNS_CHECKORBMP  	= 0x04000000,
}

enum MenuStyle: ббайт
{
	NORMAL = 1,
	SEPARATOR = 2,
}

struct MenuInfo
{
	MenuStyle Style = MenuStyle.NORMAL;
	int Index = -1;
	Menu Parent;
	string Text;
	бул Enabled = да;
}

abstract class Menu: Handle!(HMENU), IDisposable
{
	public Signal!(Menu, EventArgs) всплытие;
	
	protected Collection!(MenuItem) _items;
	protected MenuInfo _menuInfo;

	protected this()
	{
		
	}

	protected this(Menu parent, string text)
	{
		this._menuInfo.Parent = parent;
		this._menuInfo.Text = text;
	}

	public ~this()
	{
		this.dispose();
	}

	protected abstract void makeMenu();

	protected void initMenu()
	{
		MENUINFO mi;

		mi.cbSize = MENUINFO.sizeof;
		mi.fMask  = MIM_MENUDATA | MIM_APPLYTOSUBMENUS | MIM_STYLE;
		mi.dwStyle = MNS_NOTIFYBYPOS;
		mi.dwMenuData = winCast!(uint)(this);
	
		SetMenuInfo(this.handle, &mi);
	}
	
	protected static HMENU doMenu(Menu menu)
	{
		menu.makeMenu();

		if(menu._items)
		{			
			foreach(MenuItem mi; menu._items)
			{
				createItem(menu, mi);
			}
		}
		
		return menu.handle;
	}

	private static void createItem(Menu parent, MenuItem m)
	{
		MENUITEMINFOA minfo;

		minfo.cbSize = MENUITEMINFOA.sizeof;
		minfo.fMask = MIIM_FTYPE;
		minfo.dwItemData = winCast!(uint)(m);

		if(m.style is MenuStyle.NORMAL)
		{
			minfo.fMask |= MIIM_DATA | MIIM_STRING | MIIM_STATE;
			minfo.fState = m.enabled ? MFS_ENABLED : MFS_DISABLED;
			minfo.dwTypeData = toStringz(m._menuInfo.Text);
		}
		else if(m.style is MenuStyle.SEPARATOR)
		{
			minfo.fType = MFT_SEPARATOR;
		}

		if(m._items)
		{
			HMENU hMenu = doMenu(m);
			
			minfo.fMask |= MIIM_SUBMENU;
			minfo.hSubMenu = hMenu;
		}

		InsertMenuItemA(parent.handle, -1, TRUE, &minfo);
	}
	
	public void dispose()
	{
		if(this._items)
		{
			foreach(MenuItem mi; this._items)
			{
				mi.dispose();
			}
		}
		
		if(this.created)
		{
			DestroyMenu(this._handle);
		}
	}

	public final string text()
	{
		return this._menuInfo.Text;
	}

	public final void text(string s)
	{
		this._menuInfo.Text = s;

		if(this._menuInfo.Parent && this._menuInfo.Parent.created)
		{
			int idx = this.индекс;

			MENUITEMINFOA minfo;

			minfo.cbSize = MENUITEMINFOA.sizeof;
			minfo.fMask = MIIM_STRING;
			minfo.dwTypeData = toStringz(s);

			SetMenuItemInfoA(this._menuInfo.Parent.handle, idx, да, &minfo);
		}
	}

	public final Collection!(MenuItem) элты()
	{
		return this._items;
	}

	public final int индекс()
	{
		if(this._menuInfo.Parent)
		{
			int i = 0;
			
			foreach(MenuItem mi; this._menuInfo.Parent.элты)
			{
				if(mi is this)
				{
					return i;
				}

				i++;
			}
		}

		return -1;
	}
	
	public final MenuItem addItem(string t, бул enabled = да)
	{
		if(!this._items)
		{
			this._items = new Collection!(MenuItem)();
		}
		
		MenuItem item = new MenuItem(this, MenuStyle.NORMAL, t, enabled);
		this._items.add(item);

		if(this.created)
		{
			createItem(this, item);
		}
		
		return item;
	}

	public final MenuItem addSeparator()
	{
		if(!this._items)
		{
			this._items = new Collection!(MenuItem)();
		}
		
		MenuItem item = new MenuItem(this._menuInfo.Parent, MenuStyle.SEPARATOR, пусто, да);
		this._items.add(item);

		if(this.created)
		{
			createItem(this, item);
		}
		
		return item;
	}

	public final void removeItem(int idx)
	{
		if(this._items)
		{
			this._items.removeAt(idx);
		}
		
		if(this.created)
		{
			DeleteMenu(this._handle, idx, MF_BYPOSITION);
		}
	}

	public final void create()
	{
		doMenu(this);
	}

	package void поВсплытию(EventArgs e)
	{
		this.всплытие(this, e);
	}
}

class MenuItem: Menu
{
	public Signal!(MenuItem, EventArgs) click;
	
	protected this(Menu parent, MenuStyle mt, string t, бул e)
	{
		this._menuInfo.Parent = parent;
		this._menuInfo.Style = mt;
		this._menuInfo.Text = t;
		this._menuInfo.Enabled = e;
	}

	package void performClick() //FixMe: Non va bene in OOP
	{
		this.onClick(EventArgs.пуст);
	}

	public final MenuStyle style()
	{
		return this._menuInfo.Style;
	}

	public final бул enabled()
	{
		return this._menuInfo.Enabled;
	}
	
	public final void enabled(бул с)
	{
		this._menuInfo.Enabled = с;

		if(this._menuInfo.Parent && this._menuInfo.Parent.created)
		{
			int idx = this.индекс;

			MENUITEMINFOA minfo;

			minfo.cbSize = MENUITEMINFOA.sizeof;
			minfo.fMask = MIIM_STATE;
			minfo.fState = с ? MFS_ENABLED : MFS_DISABLED;

			SetMenuItemInfoA(this._menuInfo.Parent.handle, idx, да, &minfo);
		}
	}
	
	protected final void makeMenu()
	{
		this._handle = CreatePopupMenu();
	}

	protected void onClick(EventArgs e)
	{
		this.click(this, e);
	}
}

class MenuBar: Menu
{	
	protected final void makeMenu()
	{
		this._handle = CreateMenu();
		this.initMenu();
	}
}

class ContextMenu: Menu
{
	public void popupMenu(HWND уок, Point тчк)
	{
		if(!this.created)
		{
			this.create();
		}
		
		TrackPopupMenu(this._handle, TPM_LEFTALIGN, тчк.ш, тчк.в, 0, уок, пусто);
	}
	
	protected final void makeMenu()
	{
		this._handle = CreatePopupMenu();
		this.initMenu();
	}
}