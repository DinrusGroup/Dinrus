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

module dgui.statusbar;

public import dgui.control;

private const string WC_STATUSBAR = "msctls_statusbar32";
private const string WC_DSTATUSBAR = "DStatusBar";

final class StatusPart
{
	private StatusBar _владелец;
	private string _text;
	private int _width;
	
	package this(StatusBar sb, string txt, int w)
	{
		this._владелец = sb;	
		this._text = txt;
		this._width = w;
	}

	public string text()
	{
		return this._text;
	}

	public void text(string s)
	{
		this._text = s;

		if(this._владелец && this._владелец.created)
		{
			this._владелец.шлиСооб(SB_SETTEXTA, MAKEWPARAM(this.индекс, 0), cast(LPARAM)toStringz(s));
		}
	}

	public int width()
	{
		return this._width;
	}

	public int индекс()
	{
		foreach(int i, StatusPart sp; this._владелец.parts)
		{
			if(sp is this)
			{
				return i;
			}
		}

		return -1;
	}

	public StatusBar statusBar()
	{
		return this._владелец;
	}
}

class StatusBar: SubclassedControl
{
	private Collection!(StatusPart) _parts;
	private бул _partsVisible = нет;

	public StatusPart addPart(string s, int w)
	{
		if(!this._parts)
		{
			this._parts = new Collection!(StatusPart)();
		}

		StatusPart sp = new StatusPart(this, s, w);
		this._parts.add(sp);

		if(this.created)
		{
			StatusBar.insertPart(sp);
		}

		return sp;
	}

	public StatusPart addPart(int w)
	{
		return this.addPart(пусто, w);
	}

	/*
	public void removePanel(int idx)
	{
		
	}
	*/

	public бул partsVisible()
	{
		return this._partsVisible;
	}

	public void partsVisible(бул с)
	{
		this._partsVisible = с;

		if(this.created)
		{
			this.установиСтиль(SBARS_SIZEGRIP, с);
		}
	}

	public Collection!(StatusPart) parts()
	{
		return this._parts;
	}

	private static void insertPart(StatusPart sp)
	{
		StatusBar owner = sp.statusBar;
		Collection!(StatusPart) sparts = owner.parts;
		uint[] parts = new uint[sparts.length];

		foreach(int i, StatusPart sp; sparts)
		{
			if(!i)
			{
				parts[i] = sp.width;
			}
			else
			{
				parts[i] = parts[i - 1] + sp.width;
			}
		}

		owner.шлиСооб(SB_SETPARTS, sparts.length, cast(LPARAM)parts.ptr);

		foreach(int i, StatusPart sp; sparts)
		{
			owner.шлиСооб(SB_SETTEXTA, MAKEWPARAM(i, 0), cast(LPARAM)toStringz(sp.text));
		}
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		this._controlInfo.Dock = DockStyle.BOTTOM; //Forza il док
		
		pcw.OldClassName = WC_STATUSBAR;
		pcw.ClassName = WC_DSTATUSBAR;
		pcw.Style |= (this._partsVisible ? SBARS_SIZEGRIP : 0);

		super.preCreateWindow(pcw);
	}

	protected override void поСозданиюУказателя(EventArgs e)
	{
		
		if(this._parts)
		{
			foreach(StatusPart sp; this._parts)
			{
				StatusBar.insertPart(sp);
			}
		}
		
		super.поСозданиюУказателя(e);
	}
}