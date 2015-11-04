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

module dgui.trackbar;

public import dgui.control;

private const string WC_TRACKBAR = "msctls_trackbar32";
private const string WC_DTRACKBAR = "DTrackBar";

class TrackBar: SubclassedControl
{
	public Signal!(Control, EventArgs) valueChanged;
	
	private int _minRange = 0;
	private int _maxRange = 100;
	private int _position = 0;
	private int _lastValue = 0;

	public uint minRange()
	{
		return this._minRange;
	}

	public void minRange(uint mr)
	{
		this._minRange = mr;

		if(this.created)
		{
			this.шлиСооб(TBM_SETRANGE, да, MAKELPARAM(this._minRange, this._maxRange));
		}
	}

	public uint maxRange()
	{
		return this._maxRange;
	}

	public void maxRange(uint mr)
	{
		this._maxRange = mr;

		if(this.created)
		{
			this.шлиСооб(TBM_SETRANGE, да, MAKELPARAM(this._minRange, this._maxRange));
		}
	}

	public int position()
	{
		if(this.created)
		{
			return this.шлиСооб(TBM_GETPOS, 0, 0);
		}
		
		return this._position;
	}
	
	public void position(int p)
	{
		this._position = p;
		
		if(this.created)
		{
			this.шлиСооб(TBM_SETPOS, да, p);
		}
	}
	
	protected override void preCreateWindow(ref PreCreateWindow pcw)
	{
		pcw.OldClassName = WC_TRACKBAR;
		pcw.ClassName = WC_DTRACKBAR;
		pcw.Style |= TBS_AUTOTICKS;

		assert(this._controlInfo.Dock is DockStyle.FILL, "TrackBar: Invalid Dock Style");

		if(this._controlInfo.Dock is DockStyle.TOP || this._controlInfo.Dock is DockStyle.BOTTOM || (this._controlInfo.Dock is DockStyle.NONE && this._controlInfo.Bounds.width >= this._controlInfo.Bounds.height))
		{
			pcw.Style |= TBS_HORZ;
		}
		else if(this._controlInfo.Dock is DockStyle.LEFT || this._controlInfo.Dock is DockStyle.RIGHT || (this._controlInfo.Dock is DockStyle.NONE && this._controlInfo.Bounds.height < this._controlInfo.Bounds.width))
		{
			pcw.Style |= TBS_VERT;
		}
		
		super.preCreateWindow(pcw);
	}
	
	protected override void поСозданиюУказателя(EventArgs e)
	{
		this.шлиСооб(TBM_SETRANGE, да, MAKELPARAM(this._minRange, this._maxRange));
		this.шлиСооб(TBM_SETTIC, 20, 0);
		this.шлиСооб(TBM_SETPOS, да, this._position);
		
		super.поСозданиюУказателя(e);
	}

	protected override uint окПроц(uint msg, WPARAM парам1, LPARAM парам2)
	{
		if(msg == WM_MOUSEMOVE && (cast(MouseKeys)парам1) is MouseKeys.LEFT || msg == WM_KEYDOWN && ((cast(Keys)парам1) is Keys.LEFT || (cast(Keys)парам1) is Keys.UP || (cast(Keys)парам1) is Keys.RIGHT || (cast(Keys)парам1) is Keys.DOWN))
		{
			if(this._lastValue != this.position)
			{
				this._lastValue = this.position; //Save last position.
				this.onValueChanged(EventArgs.пуст);
			}
		}

		return super.окПроц(msg, парам1, парам2);
	}

	private void onValueChanged(EventArgs e)
	{
		this.valueChanged(this, e);
	}
}