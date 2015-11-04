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

module dgui.core.geometry;

public import dgui.core.winapi;

struct Rect
{	
	public union
	{
		struct
		{
			uint лево = 0;
			uint top = 0;
			uint right = 0;
			uint bottom = 0;
		}

		RECT rect;
	}

	public static Rect opCall(Point тчк, Size разм)
	{
		return opCall(тчк.ш, тчк.в, разм.width, разм.height);
	}

	public static Rect opCall(uint l, uint t, uint w, uint h)
	{
		Rect к = void; //Viene inizializzata sotto.

		к.лево = l;
		к.top = t;
		к.right = l + w;
		к.bottom = t + h;

		return к;
	}

	public бул opEquals(Rect к)
	{
		return this.лево == к.лево && this.top == к.top && this.right == к.right && this.bottom == к.bottom;
	}

	public int ш()
	{
		return this.лево;
	}

	public void ш(int newX)
	{
		int w = this.width;

		this.лево = newX;
		this.right = newX + w;
	}

	public int в()
	{
		return this.top;
	}

	public void в(int newY)
	{
		int h = this.height;

		this.top = newY;
		this.bottom = newY + h;
	}

	public int width()
	{		
		return this.right - this.лево;
	}

	public void width(int w)
	{
		this.right = this.лево + w;
	}

	public int height()
	{
		return this.bottom - this.top;
	}

	public void height(int h)
	{
		this.bottom = this.top + h;
	}

	public Point location()
	{
		return Point(this.лево, this.top);
	}

	public void location(Point тчк)
	{
		Size разм = this.size; //Copia dimensioni
		
		this.лево = тчк.ш;
		this.top = тчк.в;
		this.right = this.лево + разм.width;
		this.bottom = this.top + разм.height;
	}

	public Size size()
	{
		return Size(this.width, this.height);
	}

	public void size(Size разм)
	{
		this.right = this.лево + разм.width;
		this.bottom = this.top + разм.height;
	}

	public бул пуст()
	{
		return this.width <= 0 && this.height <= 0;
	}

	public static Rect fromRECT(RECT* pWinRect)
	{
		Rect к = void; //Inizializzata sotto

		к.rect = *pWinRect;
		return к;
	}
}

struct Point
{	
	public union
	{
		struct
		{
			uint ш = 0;
			uint в = 0;
		}

		POINT точка;
	}

	public бул opEquals(Point тчк)
	{
		return this.ш == тчк.ш && this.в == тчк.в;
	}

	public static Point opCall(int ш, int в)
	{
		Point тчк = void; //Viene inizializzata sotto.
		
		тчк.ш = ш;
		тчк.в = в;
		return тчк;
	}
}

struct Size
{	
	public union
	{
		struct
		{
			uint width = 0;
			uint height = 0;
		}

		РАЗМЕР size;
	}

	public бул opEquals(Size разм)
	{
		return this.width == разм.width && this.height == разм.height;
	}

	public static Size opCall(int w, int h)
	{
		Size разм = void;
		
		разм.width = w;
		разм.height = h;
		return разм;
	}
}

public const Rect NullRect = Rect.init;
public const Point NullPoint = Point.init;
public const Size NullSize = Size.init;