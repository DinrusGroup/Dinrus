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

module dgui.core.events;

public import dgui.core.signal;
public import dgui.core.enums;
public import dgui.canvas;

class EventArgs
{
	private static EventArgs _empty;	

	private this()
	{
		
	}

	public static EventArgs пуст()
	{
		if(!this._empty)	
		{
			_empty = new EventArgs();
		}

		return _empty;
	}	
}

class CancelEventArgs: EventArgs
{
	private бул _cancel = нет;
	
	public бул cancel()
	{
		return this._cancel;
	}

	public void cancel(бул с)
	{
		this._cancel = с;
	}
}

class PaintEventArgs: EventArgs
{
	private Canvas _canvas;
	private Rect _clipRectangle;

	public this(Canvas ктрл, Rect к)
	{
		this._canvas = ктрл;
		this._clipRectangle = к;
	}

	public final Canvas canvas()
	{
		return this._canvas;
	}

	public final Rect клипПрямоугольник()
	{
		return this._clipRectangle;
	}
}

class DrawItemEventArgs: EventArgs
{
	private DrawItemState _state;
	private Color _foreColor;
	private Color _backColor;
	private Canvas _canvas;
	private Rect _itemRect;
	private int _index;

	public this(Canvas ктрл, DrawItemState состояние, Rect itemRect, Color foreColor, Color backColor, int индекс)
	{
		this._canvas = ктрл;
		this._state = состояние;
		this._itemRect = itemRect;
		this._foreColor = foreColor;
		this._backColor = backColor;
		this._index = индекс;
	}

	public Canvas canvas()
	{
		return this._canvas;
	}

	public DrawItemState itemState()
	{
		return this._state;
	}

	public Rect itemRect()
	{
		return this._itemRect;
	}

	public Color foreColor()
	{
		return this._foreColor;
	}

	public Color backColor()
	{
		return this._backColor;
	}

	public void drawBackground()
	{
		scope ПлотнаяКисть кисть = new ПлотнаяКисть(this._backColor);
		this._canvas.заполниПрямоугольник(кисть, this._itemRect);
	}

	public void drawFocusRect()
	{
		if(this._state & DrawItemState.FOCUSED)
		{
			DrawFocusRect(this._canvas.handle, &this._itemRect.rect);
		}
	}

	public int индекс()
	{
		return this._index;
	}
}

class АргиСобИзмеренияЭлемента: EventArgs
{
	private int _width;
	private int _height;
	private int _index;
	private Canvas _canvas;
	
	public this(Canvas ктрл, int width, int height, int индекс)
	{
		this._canvas = ктрл;
		this._width = width;
		this._height = height;
		this._index = индекс;
	}

	public Canvas canvas()
	{
		return this._canvas;
	}

	public int width()
	{
		return this._width;
	}

	public void width(int w)
	{
		this._width = w;
	}

	public int height()
	{
		return this._height;
	}

	public void height(int h)
	{
		this._height = h;
	}

	public int индекс()
	{
		return this._index;
	}
}

class MouseEventArgs: EventArgs
{
	private MouseKeys _mKeys;
	private Point _cursorPos;

	public this(Point cursorPos, MouseKeys mk)
	{
		this._cursorPos = cursorPos;
		this._mKeys = mk;
	}

	public Point location()
	{
		return this._cursorPos;
	}

	public MouseKeys keys()
	{
		return this._mKeys;
	}
}

class MouseWheelEventArgs: MouseEventArgs
{
	private MouseWheel _mw;
	
	public this(Point cursorPos, MouseKeys mk, MouseWheel mw)
	{
		this._mw = mw;
		
		super(cursorPos, mk);
	}

	public MouseWheel wheel()
	{
		return this._mw;
	}
}

class ScrollEventArgs: EventArgs
{
	private ScrollDir _dir;
	private ScrollMode _mode;

	public this(ScrollDir sd, ScrollMode sm)
	{
		this._dir = sd;
		this._mode = sm;
	}

	public ScrollDir direction()
	{
		return this._dir;
	}

	public ScrollMode mode()
	{
		return this._mode;
	}
}

class KeyEventArgs: EventArgs
{
	private Keys _keys;
	private бул _handled = да;

	public this(Keys keys)
	{
		this._keys = keys;
	}

	public Keys кодКлавиши()
	{
		return this._keys;
	}

	public бул handled()
	{
		return this._handled;
	}

	public void handled(бул с)
	{
		this._handled = с;
	}
}

class KeyCharEventArgs: KeyEventArgs
{
	private сим _keyChar;	

	public this(Keys keys, сим keyCh)
	{
		super(keys);
		this._keyChar = keyCh;
	}

	public сим симКлавиши()
	{
		return this._keyChar;
	}
}

class ItemCheckedEventArgs(T): EventArgs
{
	private T _checkedItem;

	public this(T item)
	{
		this._checkedItem = item;
	}

	public T item()
	{
		return this._checkedItem;
	}
}

class ItemChangedEventArgs(T): EventArgs
{
	private T _oldItem;
	private T _newItem;

	public this(T oItem, T nItem)
	{
		this._oldItem = oItem;
		this._newItem = nItem;
	}

	public T oldItem()
	{
		return this._oldItem;
	}

	public T newItem()
	{
		return this._newItem;
	}
}