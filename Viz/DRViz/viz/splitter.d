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

module dgui.splitter;

public import dgui.control;

private const string WC_DSPLITTER = "DSplitter";
private const int SPLITTER_SIZE = 6;
private const ббайт[] BITMAP_BITS = [ 0xAA, 0, 0x55, 0, 0xAA, 0, 0x55, 0,
									  0xAA, 0, 0x55, 0, 0xAA, 0, 0x55, 0, ];

class Splitter: Control
{
	private static HBRUSH _hXorBrush;
	private Rect _prevPos;
	private int _downpos;
	private int _lastpos;
	private бул _downing = нет;
	private бул _mgrip = да;

	public this()
	{
		if(!_hXorBrush)
		{
			HBITMAP hBitmap = CreateBitmap(8, 8, 1, 1, BITMAP_BITS.ptr);
			this._hXorBrush = CreatePatternBrush(hBitmap);
			DeleteObject(hBitmap);
		}
	}

	private void doSplit()
	{
		Point тчк = Cursor.location;
		convertPoint(тчк, пусто, this.parent);
		Control splitCtrl = this.splitControl();

		if(splitCtrl)
		{
			switch(this.док)
			{
				case DockStyle.LEFT:
					splitCtrl.width = тчк.ш;
					break;

				case DockStyle.TOP:	
					splitCtrl.height = тчк.в;
					break;

				case DockStyle.RIGHT:
					splitCtrl.width = splitCtrl.width - ((тчк.ш + SPLITTER_SIZE) - splitCtrl.location.ш);
					break;

				case DockStyle.BOTTOM:
					splitCtrl.height = splitCtrl.height - ((тчк.в + SPLITTER_SIZE) - splitCtrl.location.в);
					break;

				default:
					break;
			}

			this.parent.doDock();
		}
	}

	private Control splitControl()
	{
		Control ctrl;

		switch(this.док)
		{
			case DockStyle.LEFT:
			{
				foreach(Control ктрл; this.parent.controls)
				{
					if(ктрл.док != DockStyle.LEFT)
					{
						continue;						
					}

					if(ктрл == cast(Control)this)
					{
						return ctrl;
					}

					ctrl = ктрл;
				}
			}
			break;

			case DockStyle.TOP:
			{
				foreach(Control ктрл; this.parent.controls)
				{
					if(ктрл.док != DockStyle.TOP)
					{
						continue;						
					}

					if(ктрл == cast(Control)this)
					{
						return ctrl;
					}

					ctrl = ктрл;
				}				
			}
			break;

			case DockStyle.RIGHT:
			{
				foreach(Control ктрл; this.parent.controls)
				{
					if(ктрл.док != DockStyle.RIGHT)
					{
						continue;						
					}

					if(ктрл == cast(Control)this)
					{
						return ctrl;
					}

					ctrl = ктрл;
				}				
			}
			break;

			case DockStyle.BOTTOM:
			{
				foreach(Control ктрл; this.parent.controls)
				{
					if(ктрл.док != DockStyle.BOTTOM)
					{
						continue;						
					}

					if(ктрл == cast(Control)this)
					{
						return ctrl;
					}

					ctrl = ктрл;
				}				
			}
			break;

			default:
				break;
		}

		return пусто;
	}

	private static void drawBullets(Canvas ктрл, DockStyle док, Rect paintRect)
	{
		const int SPACE = 5;
		const int WIDTH = 3;
		const int HEIGHT = 3;
		
		void drawSingleBullet(int ш, int в)
		{
			static Перо dp; 
			static Перо lp;

			if(!dp && !lp)
			{
				dp = new Перо(СистемныеЦвета.color3DdarkShadow, 2, ПСтильПера.Пунктир);
				lp = new Перо(СистемныеЦвета.color3DLight, 2, ПСтильПера.Пунктир);			
			}
			
			ктрл.рисуйЛинию(dp, ш, в, ш, в + 2);
			ктрл.рисуйЛинию(lp, ш - 1, в - 1, ш - 1, (в - 1) + 2);
		}

		switch(док)
		{
			case DockStyle.LEFT, DockStyle.RIGHT:
			{				
				int ш = (paintRect.width / 2) - (WIDTH / 2);
				int в = (paintRect.height / 2) - 15;

				for(int i = 0; i < 5; i++, в += HEIGHT + SPACE)
				{
					drawSingleBullet(ш, в);
				}
			}
			break;

			case DockStyle.TOP, DockStyle.BOTTOM:
			{
				int ш = (paintRect.width / 2) - 15;
				int в = (paintRect.height / 2) - 1;

				for(int i = 0; i < 5; i++, ш += HEIGHT + SPACE)
				{
					drawSingleBullet(ш, в);
				}				
			}
			break;

			default:
				break;
		}
	}

	private static void drawXorBar(HDC hdc, Rect к)
	{
		SetBrushOrgEx(hdc, к.ш, к.в, пусто);
		HBRUSH hOldBrush = SelectObject(hdc, this._hXorBrush);
		PatBlt(hdc, к.ш, к.в, к.width, к.height, PATINVERT);
		SelectObject(hdc, hOldBrush);
	}

	private void drawXorClient(HDC hdc, int ш, int в)
	{
		Point тчк = Point(ш, в);
		
		convertPoint(тчк, this, this.parent);
		drawXorBar(hdc, Rect(тчк, this.size));
	}

	private void drawXorClient(int ш, int в, int xold = int.min, int yold = int.min)
	{
		HDC hdc = GetDCEx(this.parent.handle, пусто, DCX_CACHE);
		
		if(xold != int.min)
		{
			this.drawXorClient(hdc, xold, yold);
		}
		
		this.drawXorClient(hdc, ш, в);
		ReleaseDC(пусто, hdc);
	}

	private void initSplit(Point поз)
	{		
		this._downing = да;
		
		switch(док)
		{
			case DockStyle.TOP, DockStyle.BOTTOM:
				this._downpos = поз.в;
				this._lastpos = 0;
				this.drawXorClient(0, this._lastpos);
				break;
			
			default: // LEFT / RIGHT.
				this._downpos = поз.ш;
				this._lastpos = 0;
				this.drawXorClient(this._lastpos, 0);
				break;
		}
	}
	
	protected override void preCreateWindow(inout PreCreateWindow pcw)
	{
		pcw.ClassName = WC_DSPLITTER;
		pcw.ClassStyle = ClassStyles.HREDRAW | ClassStyles.VREDRAW;

		if(this._controlInfo.Dock is DockStyle.LEFT || this._controlInfo.Dock is DockStyle.RIGHT)
		{
			pcw.DefaultCursor = SystemCursors.sizeNS;
		}
		else
		{
			pcw.DefaultCursor = SystemCursors.sizeWE;
		}

		this.установиСтиль(ControlStyle.NO_ERASE, да);
		super.preCreateWindow(pcw);
	}

	protected override void поСозданиюУказателя(EventArgs e)
	{
		switch(this.док)
		{
			case DockStyle.LEFT, DockStyle.RIGHT:
				this.cursor = SystemCursors.sizeWE;
				this.bounds = Rect(0, 0, SPLITTER_SIZE, 0);
				this.size = Size(SPLITTER_SIZE, this.height);
				break;

			case DockStyle.TOP, DockStyle.BOTTOM:
				this.cursor = SystemCursors.sizeNS;
				this.bounds = Rect(0, 0, 0, SPLITTER_SIZE);
				this.size = Size(this.width, SPLITTER_SIZE);
				break;
			
			default:
				debug
				{
					throw new DGuiException("DockStyle not valid!", __FILE__, __LINE__);
				}
				else
				{
					throw new DGuiException("DockStyle not valid!");
				}
		}

		super.поСозданиюУказателя(e);
	}

	protected override void onMouseKeyDown(MouseEventArgs e)
	{		
		if(e.keys == MouseKeys.LEFT)
		{
			this._downing = да;
			SetCapture(this._handle);
			this.initSplit(e.location);
		}

		super.onMouseKeyDown(e);
	}

	protected override void onMouseKeyUp(MouseEventArgs e)
	{
		if(this._downing)
		{
			this._downing = нет;

			switch(this.док)
			{
				case DockStyle.TOP, DockStyle.BOTTOM:
					this.drawXorClient(0, this._lastpos);
					break;
					
				default: // LEFT / RIGHT.
					this.drawXorClient(this._lastpos, 0);
					break;
			}

			ReleaseCapture();
			this.doSplit();
		}

		super.onMouseKeyUp(e);
	}

	protected override void onMouseMove(MouseEventArgs e)
	{		
		if(this._downing)
		{
			Point тчк = Cursor.location;
			convertPoint(тчк, пусто, this);
			
			switch(док)
			{
				case DockStyle.TOP, DockStyle.BOTTOM:
					this.drawXorClient(0, тчк.в - this._downpos, 0, this._lastpos);
					this._lastpos = тчк.в - this._downpos;
					break;
				
				default: // LEFT / RIGHT.
					this.drawXorClient(тчк.ш - this._downpos, 0, this._lastpos, 0);
					this._lastpos = тчк.ш - this._downpos;
					break;
			}
		}

		super.onMouseMove(e);
	}

	protected override void onPaint(PaintEventArgs e)
	{
		Canvas ктрл = e.canvas;
		Rect к = void; //Inizializzati sotto

		GetClientRect(this._handle, &к.rect);
		drawBullets(ктрл, this.док, к);
		super.onPaint(e);
	}
}