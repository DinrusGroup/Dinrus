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

module dgui.listbox;

public import dgui.control;

const string WC_LISTBOX = "ListBox";
const string WC_DLISTBOX = "DListBox";

struct ListBoxInfo
{
	int SelectedIndex;
	Object SelectedItem;
}

class ListBox: OwnerDrawControl
{
	private Collection!(Object) _items;
	private ListBoxInfo _lbxInfo;

	public this()
	{
		super();

		this.установиСтиль(WS_BORDER, да);
	}

	public final int addItem(string s)
	{
		return this.addItem(new ObjectContainer!(string)(s));
	}

	public final int addItem(Object объ)
	{
		if(!this._items)
		{
			this._items = new Collection!(Object)();
		}

		this._items.add(объ);

		if(this.created)
		{
			return ListBox.insertItem(this, объ);
		}

		return this._items.length - 1;
	}

	public final void removeItem(int idx)
	{
		if(this.created)
		{
			this.шлиСооб(LB_DELETESTRING, idx, 0);
		}

		this._items.removeAt(idx);
	}

	public final int selectedIndex()
	{
		if(this.created)
		{
			return this.шлиСооб(LB_GETCURSEL, 0, 0);
		}

		return this._lbxInfo.SelectedIndex;
	}

	public final void selectedIndex(int i)
	{
		this._lbxInfo.SelectedIndex = i;

		if(this.created)
		{
			this.шлиСооб(LB_SETCURSEL, i, 0);
		}
	}

	public final Object selectedItem()
	{
		int idx = this.selectedIndex;

		if(this._items)
		{
			return this._items[idx];
		}

		return пусто;
	}

	public final string selectedString()
	{
		Object объ = this.selectedItem;
		return (объ ? объ.toString() : пусто);
	}

	public final Collection!(Object) элты()
	{
		return this._items;
	}

	private static int insertItem(ListBox lb, Object объ)
	{
		return lb.шлиСооб(LB_ADDSTRING, 0, cast(LPARAM)toStringz(объ.toString()));
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.OldClassName = WC_LISTBOX;
		pcw.ClassName = WC_DLISTBOX;
		pcw.DefaultBackColor = СистемныеЦвета.colorWindow;

		super.preCreateWindow(pcw);
	}

	protected override void поСозданиюУказателя(EventArgs e)
	{
		if(this._items)
		{
			foreach(Object объ; this._items)
			{
				ListBox.insertItem(this, объ);
			}
		}

		super.поСозданиюУказателя(e);
	}
}