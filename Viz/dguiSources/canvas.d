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

module dgui.canvas;

import std.gc;
import std.ктрл.string;
public import std.string;
public import dgui.core.winapi;
public import dgui.core.idisposable;
public import dgui.core.exception;
public import dgui.core.geometry;
public import dgui.core.handle;
public import dgui.core.utils;

enum СтильШрифта: ббайт
{
	NORMAL = 0,
	ПОЛУЖИРНЫЙ = 1,
	КУРСИВ = 2,
	ПОДЧЁРКНУТЫЙ = 4,
	ЗАЧЁРКНУТЫЙ = 8,
}

enum ImageType
{
	BITMAP 		   = 0,
	ICON_OR_CURSOR = 1,
}

enum EdgeType: uint
{
	RAISED_OUTER = BDR_RAISEDOUTER,
	RAISED_INNER = BDR_RAISEDINNER,

	SUNKEN_OUTER = BDR_SUNKENOUTER,
	SUNKEN_INNER = BDR_SUNKENINNER,

	BUMP = EDGE_BUMP,
	ETCHED = EDGE_ETCHED,
	EDGE_RAISED = EDGE_RAISED,
	SUNKEN = EDGE_SUNKEN,
}

enum EdgeMode: uint
{
	ADJUST = BF_ADJUST,	
	DIAGONAL = BF_DIAGONAL,
	FLAT = BF_FLAT,
	LEFT = BF_LEFT,
	TOP = BF_TOP,
	RIGHT = BF_RIGHT,
	BOTTOM = BF_BOTTOM,
	MIDDLE = BF_MIDDLE,
	MONO = BF_MONO,
	RECT = BF_RECT,
	SOFT = BF_SOFT,
}

enum HatchStyle: int
{
	HORIZONTAL = HS_HORIZONTAL,
	VERTICAL = HS_VERTICAL,
	BACKWARD_DIAGONAL = HS_BDIAGONAL,
	FORWARD_DIAGONAL = HS_FDIAGONAL,
	CROSS = HS_CROSS,
	DIAGONAL_CROSS = HS_DIAGCROSS,
}

enum ПСтильПера: uint
{
	Сплошной = PS_SOLID,
	Штрих = PS_DASH,
	Пунктир = PS_DOT,
	ШтрихПунктир = PS_DASHDOT,
	ШтрихПунктирПунктир = PS_DASHDOTDOT,
	Никакой = PS_NULL,
	ВРамке = PS_INSIDEFRAME,
}

enum ФлагиФорматаТекста: uint
{
	БЕЗ_ПРЕФИКСОВ = DT_NOPREFIX,
	DIRECTION_RIGHT_TO_LEFT = DT_RTLREADING,
	ПРЕРВАТЬ_СЛОВО = DT_WORDBREAK,
	ЕДИНАЯ_СТРОКА = DT_SINGLELINE,
	БЕЗ_ОБРЕЗКИ = DT_NOCLIP,
	ЛИМИТ_СТРОКА = DT_EDITКОНТРОЛ,
}

enum РасположениеТекста: uint
{
	LEFT = DT_LEFT,
	RIGHT = DT_RIGHT,
	CENTER = DT_CENTER,
	
	TOP = DT_TOP,
	BOTTOM = DT_BOTTOM,
	MIDDLE = DT_VCENTER,
}

enum СокращениеТекста: uint
{
	NONE = 0,
	ЭЛЛИПСИС = DT_END_ELLIPSIS,
	ЭЛЛИПСИС_ПУТЬ = DT_PATH_ELLIPSIS,
}

struct BitmapData
{
	BITMAPINFO* Info;
	uint ImageSize;
	uint BitsCount;
	RGBQUAD* Bits;
}

struct Color
{
	private бул _valid = нет; //Controlla se e' stato assegnato un colore
	
	public union
	{
		align(1) struct
		{
			ббайт красный   = 0xFF;
			ббайт зелёный = 0xFF;
			ббайт синий  = 0xFF;
			ббайт альфа = 0x00; //0x00: Transparent, 0xFF: Opaque (?)
		}

		COLORREF colorref;
	}

	public final бул valid()
	{
		return this._valid;
	}

	public static Color opCall(ббайт к, ббайт з, ббайт с)
	{
		return Color(0x00, к, з, с);
	}

	public static Color opCall(ббайт а, ббайт к, ббайт з, ббайт с)
	{
		Color цвет = void; //Inializzata sotto;

		цвет._valid = да;

		цвет.альфа = а;
		цвет.красный = к;
		цвет.зелёный = з;
		цвет.синий = с;

		return цвет;
	}

	public static Color fromCOLORREF(COLORREF cref)
	{
		Color цвет = void; //Inializzata sotto;

		цвет._valid = да;
		цвет.colorref = cref;
		return цвет;
	}
}

class Canvas: Handle!(HDC), IDisposable
{
	private enum CanvasType: ббайт
	{
		NORMAL = 0,
		FROM_КОНТРОЛ = 1,
		IN_MEMORY = 2,
	}

	private CanvasType _canvasType = CanvasType.NORMAL;
	private HBITMAP _hBitmap;
	private бул _owned;

	protected this(HDC hdc, бул owned, CanvasType type)
	{
		this._handle = hdc;
		this._owned = owned;
		this._canvasType = type;
	}
	
	public ~this()
	{
		if(this._handle && this._owned)
		{
			this.dispose();
			this._handle = пусто;
		}
	}

	public void копируйВ(Canvas ктрл)
	{
		BITMAP bmp;
		GetObjectA(GetCurrentObject(this._handle, OBJ_BITMAP), BITMAP.sizeof, &bmp);
		
		BitBlt(ктрл.handle, 0, 0, bmp.bmWidth, bmp.bmHeight, this._handle, 0, 0, SRCCOPY);
	}

	public void dispose()
	{
		switch(this._canvasType)
		{
			case CanvasType.FROM_КОНТРОЛ:
				ReleaseDC(WindowFromDC(this._handle), this._handle);
				break;

			case CanvasType.IN_MEMORY:
				DeleteObject(this._hBitmap);
				DeleteDC(this._handle);
				break;

			default:
				break;
		}
	}

	public final void drawImage(Image img, Point upLeft, Point upRight, Point lowLeft)
	{
		this.drawImage(img, 0, 0, upLeft, upRight, lowLeft);
	}
	public final void drawImage(Image img, int ш, int в, Point upLeft, Point upRight, Point lowLeft)
	{
		POINT[3] pts;

		pts[0] = upLeft.точка;
		pts[1] = upRight.точка;
		pts[2] = lowLeft.точка;

		Size разм = img.size;
		HDC hdc = CreateCompatibleDC(this._handle);
		HBITMAP hOldBitmap = SelectObject(hdc, img.handle);

		PlgBlt(this._handle, pts.ptr, hdc, ш, в, разм.width, разм.height, пусто, 0, 0);

		SelectObject(hdc, hOldBitmap);
		DeleteDC(hdc);
	}

	public final void drawImage(Image img, int ш, int в)
	{
		Size разм = img.size;
		
		switch(img.type)
		{
			case ImageType.BITMAP:
				HDC hdc = CreateCompatibleDC(this._handle);
				HBITMAP hOldBitmap = SelectObject(hdc, img.handle);
				BitBlt(this._handle, ш, в, разм.width, разм.height, hdc, 0, 0, SRCCOPY);
				SelectObject(hdc, hOldBitmap);
				DeleteDC(hdc);
				break;

			case ImageType.ICON_OR_CURSOR:
				DrawIconEx(this._handle, ш, в, img.handle, разм.width, разм.height, 0, пусто, DI_NORMAL);
				break;
			
			default:
				break;
		}
	}

	public final void drawImage(Image img, Rect к)
	{
		Size разм = img.size;
		
		switch(img.type)
		{
			case ImageType.BITMAP:
				HDC hdc = CreateCompatibleDC(this._handle);
				HBITMAP hOldBitmap = SelectObject(hdc, img.handle);
				StretchBlt(this._handle, к.ш, к.в, к.width, к.height, hdc, 0, 0, разм.width, разм.height, SRCCOPY);
				SelectObject(hdc, hOldBitmap);
				DeleteDC(hdc);
				break;

			case ImageType.ICON_OR_CURSOR:
				DrawIconEx(this._handle, к.ш, к.в, img.handle, к.width, к.height, 0, пусто, DI_NORMAL);
				break;
			
			default:
				break;
		}		
	}

	public final void drawEdge(Rect к, EdgeType edgeType, EdgeMode edgeMode)
	{
		DrawEdge(this._handle, &к.rect, edgeType, edgeMode);
	}

	public final void рисуйТекст(string text, Rect к, Color foreColor, Font font, ФорматТекста textFormat)
	{
		DRAWTEXTPARAMS dtp;

		dtp.cbSize = DRAWTEXTPARAMS.sizeof;
		dtp.iLeftMargin = textFormat.левыйКрай;
		dtp.iRightMargin = textFormat.правыйКрай;
		dtp.iTabLength = textFormat.длинаТаб;

		HFONT hOldFont = SelectObject(this._handle, font.handle);
		COLORREF oldColorRef = SetTextColor(this._handle, foreColor.colorref);
		int oldBkMode = SetBkMode(this._handle, TRANSPARENT);
		
		DrawTextExA(this._handle, text.ptr, text.length, &к.rect, 
				    DT_EXPANDTABS | DT_TABSTOP | textFormat.флагиФормата | textFormat.расположение | textFormat.сокращение,
				    &dtp);

		SetBkMode(this._handle, oldBkMode);
		SetTextColor(this._handle, oldColorRef);
		SelectObject(this._handle, hOldFont);
	}

	public final void рисуйТекст(string text, Rect к, Color foreColor, Font font)
	{
		scope ФорматТекста tf = new ФорматТекста(ФлагиФорматаТекста.БЕЗ_ПРЕФИКСОВ | ФлагиФорматаТекста.ПРЕРВАТЬ_СЛОВО |
											 ФлагиФорматаТекста.БЕЗ_ОБРЕЗКИ | ФлагиФорматаТекста.ЛИМИТ_СТРОКА);

		tf.сокращение = СокращениеТекста.NONE;
		
		this.рисуйТекст(text, к, foreColor, font, tf);
	}

	public final void рисуйТекст(string text, Rect к, Color foreColor)
	{
		this.рисуйТекст(text, к, foreColor, Font.fromHFONT(GetCurrentObject(this._handle, OBJ_FONT), нет));
	}

	public final void рисуйТекст(string text, Rect к, Font f, ФорматТекста tf)
	{
		this.рисуйТекст(text, к, Color.fromCOLORREF(GetTextColor(this._handle)), f, tf);
	}

	public final void рисуйТекст(string text, Rect к, ФорматТекста tf)
	{
		this.рисуйТекст(text, к, Color.fromCOLORREF(GetTextColor(this._handle)),
					  Font.fromHFONT(GetCurrentObject(this._handle, OBJ_FONT), нет), tf);
	}

	public final void рисуйТекст(string text, Rect к)
	{
		this.рисуйТекст(text, к, Color.fromCOLORREF(GetTextColor(this._handle)),
					  Font.fromHFONT(GetCurrentObject(this._handle, OBJ_FONT), нет));
	}

	public final void рисуйЛинию(Перо p, int x1, int y1, int x2, int y2)
	{
		ПЕРО hOldPen = SelectObject(this._handle, p.handle);

		MoveToEx(this._handle, x1, y1, пусто);
		LineTo(this._handle, x2, y2);

		SelectObject(this._handle, hOldPen);
	}

	public final void рисуйЭллипс(Перо pen, Кисть fill, Rect к)
	{
		ПЕРО hOldPen;
		HBRUSH hOldBrush;
		
		if(pen)
		{
			hOldPen = SelectObject(this._handle, pen.handle);
		}

		if(fill)
		{
			hOldBrush = SelectObject(this._handle, fill.handle);
		}		

		Ellipse(this._handle, к.лево, к.top, к.right, к.bottom);

		if(hOldBrush)
		{
			SelectObject(this._handle, hOldBrush);
		}

		if(hOldPen)
		{
			SelectObject(this._handle, hOldPen);
		}
	}

	public final void рисуйЭллипс(Перо pen, Rect к)
	{
		this.рисуйЭллипс(pen, SystemBrushes.nullBrush, к);
	}

	public final void рисуйПрямоугольник(Перо pen, Кисть fill, Rect к)
	{
		ПЕРО hOldPen;
		HBRUSH hOldBrush;
		
		if(pen)
		{
			hOldPen = SelectObject(this._handle, pen.handle);
		}

		if(fill)
		{
			hOldBrush = SelectObject(this._handle, fill.handle);
		}

		Rectangle(this._handle, к.лево, к.top, к.right, к.bottom);

		if(hOldBrush)
		{
			SelectObject(this._handle, hOldBrush);
		}

		if(hOldPen)
		{
			SelectObject(this._handle, hOldPen);
		}
	}

	public final void рисуйПрямоугольник(Перо pen, Rect к)
	{
		this.рисуйПрямоугольник(pen, SystemBrushes.nullBrush, к);
	}

	public final void заполниПрямоугольник(Кисть с, Rect к)
	{
		FillRect(this._handle, &к.rect, с.handle);
	}

	public final void fillEllipse(Кисть с, Rect к)
	{
		this.рисуйЭллипс(SystemPens.nullPen, с, к);
	}

	public final Canvas createInMemory(Битмап с)
	{
		HBITMAP hBitmap;
		HDC hdc = CreateCompatibleDC(this._handle);
		Canvas ктрл = new Canvas(hdc, да, CanvasType.IN_MEMORY);
	
		if(!с)
		{
			BITMAP bmp;
			
			GetObjectA(GetCurrentObject(this._handle, OBJ_BITMAP), BITMAP.sizeof, &bmp);
			hBitmap = CreateCompatibleBitmap(this._handle, bmp.bmWidth, bmp.bmHeight);
			ктрл._hBitmap = hBitmap;
			SelectObject(hdc, hBitmap);  // La seleziona e la distrugge quando ha finito.
		}
		else
		{
			SelectObject(hdc, с.handle); // La prende 'in prestito', ma non la distrugge.
		}
		

		return ктрл;
	}

	public final Canvas createInMemory()
	{
		return this.createInMemory(пусто);
	}

	public static Canvas fromHDC(HDC hdc, бул owned = да)
	{
		return new Canvas(hdc, owned, CanvasType.FROM_КОНТРОЛ);
	}
}

abstract class GraphicObject: Handle!(HGDIOBJ), IDisposable
{
	protected бул _owned;

	protected this()
	{
		
	}

	protected this(HGDIOBJ hGdiObj, бул owned)
	{		
		this._handle = hGdiObj;
		this._owned = owned;
	}

	public ~this()
	{
		if(this._owned && this._handle)
		{
			this.dispose();
			this._handle = пусто;
		}
	}

	public void dispose()
	{
		DeleteObject(this._handle);
	}
}

abstract class Image: GraphicObject
{
	protected this()
	{
		
	}

	public abstract Size size();
	public abstract ImageType type();

	protected static int getInfo(T)(HGDIOBJ hGdiObj, inout T t)
	{
		return GetObjectA(hGdiObj, T.sizeof, &t); 
	}	

	protected this(HGDIOBJ hGdiObj, бул owned)
	{
		super(hGdiObj, owned);
	}
}

class Битмап: Image
{	
	public this(Size разм)
	{
		HBITMAP hBitmap = this.createBitmap(разм.width, разм.height, RGB(0xFF, 0xFF, 0xFF));
		super(hBitmap, да);
	}

	public this(Size разм, Color bc)
	{
		HBITMAP hBitmap = this.createBitmap(разм.width, разм.height, bc.colorref);
		super(hBitmap, да);
	}
	
	public this(int w, int h)
	{
		HBITMAP hBitmap = this.createBitmap(w, h, RGB(0xFF, 0xFF, 0xFF));
		super(hBitmap, да);
	}

	public this(int w, int h, Color bc)
	{
		HBITMAP hBitmap = this.createBitmap(w, h, bc.colorref);
		super(hBitmap, да);
	}
	
	protected this(HBITMAP hBitmap, бул owned)
	{
		super(hBitmap, owned);
	}

	protected this(string fileName)
	{
		HBITMAP hBitmap = LoadImageA(getHInstance(), toStringz(fileName), IMAGE_BITMAP, 0, 0, LR_DEFAULTCOLOR | LR_DEFAULTSIZE | LR_LOADFROMFILE);

		if(!hBitmap)
		{
			debug
			{
				throw new Win32Exception(format("Cannot загрузка Битмап From File: '%s'", fileName), __FILE__, __LINE__);
			}
			else
			{
				throw new Win32Exception(format("Cannot загрузка Битмап From File: '%s'", fileName));
			}
		}
		
		super(hBitmap, да);
	}

	private static HBITMAP createBitmap(int w, int h, COLORREF backColor)
	{
		Rect к = Rect(0, 0, w, h);
		
		HDC hdc = GetDC(пусто);
		HDC hcdc = CreateCompatibleDC(hdc);
		HBITMAP hBitmap = CreateCompatibleBitmap(hdc, w, h);
		HBITMAP hOldBitmap = SelectObject(hcdc, hBitmap);

		COLORREF oldColor = SetBkColor(hcdc, backColor);
		ExtTextOutA(hcdc, 0, 0, ETO_НЕПРОЗРАЧНЫЙ, &к.rect, "", 0, пусто);
		SetBkColor(hcdc, oldColor);

		SelectObject(hcdc, hOldBitmap);
		DeleteDC(hcdc);
		ReleaseDC(пусто, hdc);

		return hBitmap;
	}
	
	public Битмап clone()
	{
		BITMAP с;
		this.getInfo!(BITMAP)(this._handle, с);
		
		HDC hdc = GetDC(пусто);
		HDC hcdc1 = CreateCompatibleDC(hdc); // Contains this битмап
		HDC hcdc2 = CreateCompatibleDC(hdc); // The Битмап will be copied here
		HBITMAP hBitmap = CreateCompatibleBitmap(hdc, с.bmWidth, с.bmHeight); //Don't delete it, it will be deleted by the class Битмап

		HBITMAP hOldBitmap1 = SelectObject(hcdc1, this._handle);
		HBITMAP hOldBitmap2 = SelectObject(hcdc2, hBitmap);

		BitBlt(hcdc2, 0, 0, с.bmWidth, с.bmHeight, hcdc1, 0, 0, SRCCOPY);
		SelectObject(hcdc2, hOldBitmap2);
		SelectObject(hcdc1, hOldBitmap1);
				
		DeleteDC(hcdc2);
		DeleteDC(hcdc1);
		ReleaseDC(пусто, hdc);

		Битмап bmp = new Битмап(hBitmap, да);
		return bmp;
	}

	public void получитьДанные(ref BitmapData bd)
	{
		BITMAPINFO bi;
		bi.bmiHeader.biSize = BITMAPINFOHEADER.sizeof;
		bi.bmiHeader.biBitCount = 0; //Don't get the цвет table.

		HDC hdc = GetDC(пусто);
		GetDIBits(hdc, this._handle, 0, 0, пусто, &bi, DIB_RGB_COLORS);

		bd.ImageSize = bi.bmiHeader.biSizeImage;
		bd.BitsCount = bi.bmiHeader.biSizeImage / RGBQUAD.sizeof;
		bd.Bits = cast(RGBQUAD*)malloc(bi.bmiHeader.biSizeImage);

		switch(bi.bmiHeader.biBitCount) // Calculate цвет table size (if needed)
		{
			case 24:
				bd.Info = cast(BITMAPINFO*)malloc(BITMAPINFOHEADER.sizeof);
				break;

			case 16, 32:
				bd.Info = cast(BITMAPINFO*)malloc(BITMAPINFOHEADER.sizeof + uint.sizeof * 3); // Needs Investigation
				break;

			default:
				bd.Info = cast(BITMAPINFO*)malloc(BITMAPINFOHEADER.sizeof + RGBQUAD.sizeof * (1 << bi.bmiHeader.biBitCount));
				break;
		}

		bd.Info.bmiHeader = bi.bmiHeader;
		GetDIBits(hdc, this._handle, 0, bd.Info.bmiHeader.biHeight, bd.Bits, bd.Info, DIB_RGB_COLORS);
		ReleaseDC(пусто, hdc);
	}

	public void установиДанные(ref BitmapData bd)
	{
		HDC hdc = GetDC(пусто);
		SetDIBits(hdc, this._handle, 0, bd.Info.bmiHeader.biHeight, bd.Bits, bd.Info, DIB_RGB_COLORS);
		ReleaseDC(пусто, hdc);
	}

	public final Size size()
	{
		BITMAP bmp = void; //Inizializzata da getInfo()

		getInfo!(BITMAP)(this._handle, bmp);
		return Size(bmp.bmWidth, bmp.bmHeight);
	}

	public final ImageType type()
	{
		return ImageType.BITMAP;
	}
	
	public static Битмап fromHBITMAP(HBITMAP hBitmap, бул owned = да)
	{
		return new Битмап(hBitmap, owned);
	}

	public static Битмап изФайла(string fileName)
	{
		return new Битмап(fileName);
	}
}

class Пиктограмма: Image
{
	protected this(HICON hIcon, бул owned)
	{
		super(hIcon, owned);
	}

	protected this(string fileName)
	{
		HICON hIcon = LoadImageA(getHInstance(), toStringz(fileName), IMAGE_ICON, 0, 0, LR_DEFAULTCOLOR | LR_DEFAULTSIZE | LR_LOADFROMFILE);

		if(!hIcon)
		{
			debug
			{
				throw new Win32Exception(format("Cannot загрузка Битмап From File: '%s'", fileName), __FILE__, __LINE__);
			}
			else
			{
				throw new Win32Exception(format("Cannot загрузка Битмап From File: '%s'", fileName));
			}
		}
		
		super(hIcon, да);
	}

	public override void dispose()
	{
		DestroyIcon(this._handle);
	}

	public final Size size()
	{
		ICONINFO ii = void; //Inizializzata da GetIconInfo()
		BITMAP bmp = void; //Inizializzata da getInfo()
		Size разм = void; //Inizializzata sotto.

		if(!GetIconInfo(this._handle, &ii))
		{
			debug
			{
				throw new Win32Exception("Unable to get информация from Пиктограмма", __FILE__, __LINE__);
			}
			else
			{
				throw new Win32Exception("Unable to get информация from Пиктограмма");
			}
		}
		
		if(ii.hbmColor) //Exists: Пиктограмма Color Битмап
		{
			if(!getInfo!(BITMAP)(ii.hbmColor, bmp))
			{
				debug
				{
					throw new Win32Exception("Unable to get Пиктограмма Color Битмап", __FILE__, __LINE__);
				}
				else
				{
					throw new Win32Exception("Unable to get Пиктограмма Color Битмап");
				}
			}

			разм.width = bmp.bmWidth;
			разм.height = bmp.bmHeight;
			DeleteObject(ii.hbmColor);
		}
		else
		{
			if(!getInfo!(BITMAP)(ii.hbmMask, bmp))
			{
				debug
				{
					throw new Win32Exception("Unable to get Пиктограмма Mask", __FILE__, __LINE__);
				}
				else
				{
					throw new Win32Exception("Unable to get Пиктограмма Mask");
				}
			}

			разм.width = bmp.bmWidth;
			разм.height = bmp.bmHeight / 2;
		}

		DeleteObject(ii.hbmMask);
		return разм;
	}

	public final ImageType type()
	{
		return ImageType.ICON_OR_CURSOR;
	}

	public static Пиктограмма fromHICON(HICON hIcon, бул owned = да)
	{
		return new Пиктограмма(hIcon, owned);
	}

	public static Пиктограмма изФайла(string fileName)
	{
		return new Пиктограмма(fileName);
	}	
}

final class Cursor: Пиктограмма
{
	protected this(КУРСОР hCursor, бул owned)
	{
		super(hCursor, owned);
	}	

	public override void dispose()
	{
		DestroyCursor(this._handle);
	}

	public static Point location()
	{
		Point тчк;

		GetCursorPos(&тчк.точка);
		return тчк;
	}

	public static Cursor fromHCURSOR(КУРСОР hCursor, бул owned = да)
	{
		return new Cursor(hCursor, owned);
	}
}

final class Font: GraphicObject
{
	private СтильШрифта _style;
	private int _height;
	private string _name;

	private this(HFONT hFont, бул owned)
	{
		super(hFont, owned);
	}
	
	public this(string name, int h, СтильШрифта style = СтильШрифта.NORMAL)
	in
	{
		assert(h > 0, "Font height must be > 0");
	}
	body
	{
		HDC hdc = GetWindowDC(пусто);
				
		this._name = name;
		this._height = MulDiv(cast(int)(h * 100), GetDeviceCaps(hdc, LOGPIXELSY), 72 * 100);
		this._style = style;

		LOGFONTA шл;
		шл.lfHeight = this._height;

		doStyle(style, шл);
		strcpy(шл.lfFaceName.ptr, toStringz(name));
		this._handle = CreateFontIndirectA(&шл);

		ReleaseDC(пусто, hdc);
	}

	private static void doStyle(СтильШрифта style, inout LOGFONTA шл)
	{
		шл.lfCharSet = DEFAULT_CHARSET;
		шл.lfWeight = FW_NORMAL;
		//шл.lfItalic = FALSE;    Inizializzata dal compilatore
		//шл.lfStrikeOut = FALSE; Inizializzata dal compilatore
		//шл.lfUnderline = FALSE; Inizializzata dal compilatore
		
		if(style & СтильШрифта.ПОЛУЖИРНЫЙ)
		{
			шл.lfWeight = FW_BOLD;
		}

		if(style & СтильШрифта.КУРСИВ)
		{
			шл.lfItalic = 1;
		}

		if(style & СтильШрифта.ЗАЧЁРКНУТЫЙ)
		{
			шл.lfStrikeOut = 1;
		}

		if(style & СтильШрифта.ПОДЧЁРКНУТЫЙ)
		{
			шл.lfUnderline = 1;
		}
	}

	public static Font fromHFONT(HFONT hFont, бул owned = да)
	{
		return new Font(hFont, owned);
	}
}

abstract class Кисть: GraphicObject
{
	protected this(HBRUSH hBrush, бул owned)
	{
		super(hBrush, owned);
	}
}

class ПлотнаяКисть: Кисть
{
	private Color _color;

	protected this(HBRUSH hBrush, бул owned)
	{
		super(hBrush, owned);
	}

	public this(Color цвет)
	{
		this._color = цвет;
		super(CreateSolidBrush(цвет.colorref), да);
	}

	public final Color цвет()
	{
		return this._color;
	}

	public static ПлотнаяКисть fromHBRUSH(HBRUSH hBrush, бул owned = да)
	{
		return new ПлотнаяКисть(hBrush, owned);
	}
}

class HatchBrush: Кисть
{
	private Color _color;
	private HatchStyle _style;

	protected this(HBRUSH hBrush, бул owned)
	{
		super(hBrush, owned);
	}

	public this(Color цвет, HatchStyle style)
	{
		this._color = цвет;
		this._style = style;

		super(CreateHatchBrush(style, цвет.colorref), да);
	}

	public final Color цвет()
	{
		return this._color;
	}

	public final HatchStyle style()
	{
		return this._style;
	}

	public static HatchBrush fromHBRUSH(HBRUSH hBrush, бул owned = да)
	{
		return new HatchBrush(hBrush, owned);
	}
}

class PatternBrush: Кисть
{
	private Битмап _bmp;

	protected this(HBRUSH hBrush, бул owned)
	{
		super(hBrush, owned);
	}

	public this(Битмап bmp)
	{
		this._bmp = bmp;
		super(CreatePatternBrush(bmp.handle), да);
	}

	public final Битмап битмап()
	{
		return this._bmp;
	}

	public static PatternBrush fromHBRUSH(HBRUSH hBrush, бул owned = да)
	{
		return new PatternBrush(hBrush, owned);
	}
}

final class Перо: GraphicObject
{
	private ПСтильПера _style;
	private Color _color;
	private int _width;	

	protected this(ПЕРО hPen, бул owned)
	{
		super(hPen, owned);
	}
	
	public this(Color цвет, int width = 1, ПСтильПера style = ПСтильПера.Сплошной)
	{
		this._color = цвет;
		this._width = width;
		this._style = style;

		this._handle = CreatePen(style, width, цвет.colorref);

		super(this._handle, да);
	}

	public ПСтильПера style()
	{
		return this._style;
	}

	public int width()
	{
		return this._width;
	}

	public Color цвет()
	{
		return this._color;
	}

	public static Перо fromHPEN(ПЕРО hPen, бул owned = да)
	{
		return new Перо(hPen, owned);
	}
}

final class SystemPens
{
	public static Перо nullPen()
	{
		return Перо.fromHPEN(GetStockObject(NULL_PEN), нет);
	}

	public static Перо blackPen()
	{
		return Перо.fromHPEN(GetStockObject(BLACK_PEN), нет);
	}

	public static Перо whitePen()
	{
		return Перо.fromHPEN(GetStockObject(WHITE_PEN), нет);
	}
}

final class SystemBrushes
{
	public static ПлотнаяКисть blackBrush()
	{
		return ПлотнаяКисть.fromHBRUSH(GetStockObject(BLACK_BRUSH), нет);
	}

	public static ПлотнаяКисть darkGrayBrush()
	{
		return ПлотнаяКисть.fromHBRUSH(GetStockObject(DKGRAY_BRUSH), нет);
	}

	public static ПлотнаяКисть grayBrush()
	{
		return ПлотнаяКисть.fromHBRUSH(GetStockObject(GRAY_BRUSH), нет);
	}

	public static ПлотнаяКисть lightGrayBrush()
	{
		return ПлотнаяКисть.fromHBRUSH(GetStockObject(LTGRAY_BRUSH), нет);
	}

	public static ПлотнаяКисть nullBrush()
	{
		return ПлотнаяКисть.fromHBRUSH(GetStockObject(NULL_BRUSH), нет);
	}

	public static ПлотнаяКисть whiteBrush()
	{
		return ПлотнаяКисть.fromHBRUSH(GetStockObject(WHITE_BRUSH), нет);
	}

		public static ПлотнаяКисть brush3DdarkShadow()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_3DDKSHADOW), нет);
	}

	public static ПлотнаяКисть brush3Dface()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_3DFACE), нет);
	}

	public static ПлотнаяКисть brushBtnFace()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_BTNFACE), нет);
	}

	public static ПлотнаяКисть brush3DLight()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_3DLIGHT), нет);
	}

	public static ПлотнаяКисть brush3DShadow()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_3DSHADOW), нет);
	}

	public static ПлотнаяКисть brushActiveBorder()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_ACTIVEBORDER), нет);
	}

	public static ПлотнаяКисть brushActiveCaption()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_3DLIGHT), нет);
	}

	public static ПлотнаяКисть brushAppWorkspace()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_APPWORKSPACE), нет);
	}

	public static ПлотнаяКисть brushBackground()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_BACKGROUND), нет);
	}

	public static ПлотнаяКисть brushBtnText()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_BTNTEXT), нет);
	}

	public static ПлотнаяКисть brushCaptionText()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_CAPTIONTEXT), нет);
	}

	public static ПлотнаяКисть brushGrayText()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_GRAYTEXT), нет);
	}

	public static ПлотнаяКисть brushHighLight()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_HIGHLIGHT), нет);
	}

	public static ПлотнаяКисть brushHighLightText()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_HIGHLIGHTTEXT), нет);
	}

	public static ПлотнаяКисть brushInactiveBorder()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_INACTIVEBORDER), нет);
	}

	public static ПлотнаяКисть brushInactiveCaption()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_INACTIVECAPTION), нет);
	}

	public static ПлотнаяКисть brushInactiveCaptionText()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_INACTIVECAPTIONTEXT), нет);
	}

	public static ПлотнаяКисть brushInfoBk()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_INFOBK), нет);
	}

	public static ПлотнаяКисть brushInfoText()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_INFOTEXT), нет);
	}

	public static ПлотнаяКисть brushMenu()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_MENU), нет);
	}

	public static ПлотнаяКисть brushMenuText()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_MENUTEXT), нет);
	}

	public static ПлотнаяКисть brushScrollBar()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_SCROLLBAR), нет);
	}

	public static ПлотнаяКисть brushWindow()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_WINDOW), нет);
	}

	public static ПлотнаяКисть brushWindowFrame()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_WINDOW), нет);
	}

	public static ПлотнаяКисть brushWindowText()
	{
		return ПлотнаяКисть.fromHBRUSH(GetSysColorBrush(COLOR_WINDOWTEXT), нет);
	}
}

final class SystemFonts
{
	public static Font windowsFont()
	{
		static Font f;

		if(!f)
		{
			NONCLIENTMETRICSA ncm = void; //La inizializza sotto.
			ncm.cbSize = NONCLIENTMETRICSA.sizeof;

			if(SystemParametersInfoA(SPI_GETNONCLIENTMETRICS, NONCLIENTMETRICSA.sizeof, &ncm, 0))
			{
				f = Font.fromHFONT(CreateFontIndirectA(&ncm.lfMessageFont));
			}
			else
			{
				f = SystemFonts.ansiVarFont;
			}
		}

		return f;
	}
	
	public static Font ansiFixedFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(ANSI_FIXED_FONT));
		}

		return f;
	}

	public static Font ansiVarFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(ANSI_VAR_FONT));
		}

		return f;
	}

	public static Font deviceDefaultFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(DEVICE_DEFAULT_FONT));
		}

		return f;
	}

	public static Font oemFixedFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(OEM_FIXED_FONT));
		}

		return f;
	}

	public static Font systemFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(SYSTEM_FONT));
		}

		return f;
	}

	public static Font systemFixedFont()
	{
		static Font f;

		if(!f)
		{
			f = Font.fromHFONT(GetStockObject(SYSTEM_FIXED_FONT));
		}

		return f;
	}
}

final class SystemCursors
{
	public static Cursor пускПриложения()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			 ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_APPSTARTING, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}
		
		return ктрл;
	}

	public static Cursor стрелка()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_ARROW, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor крест()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_CROSS, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor ibeam()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_IBEAM, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}
		
		return ктрл;
	}

	public static Cursor пиктограмма()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_ICON, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor нет()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_NO, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor sizeALL()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_SIZEALL, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor sizeNESW()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_SIZENESW, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor sizeNS()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_SIZENS, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor sizeNWSE()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_SIZENWSE, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor sizeWE()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_SIZEWE, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor upArrow()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_UPARROW, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}

	public static Cursor wait()
	{
		static Cursor ктрл;

		if(!ктрл)
		{
			ктрл = Cursor.fromHCURSOR(LoadImageA(пусто, IDC_WAIT, IMAGE_CURSOR, 0, 0, LR_DEFAULTSIZE | LR_DEFAULTCOLOR | LR_SHARED), нет);
		}

		return ктрл;
	}
}

final class СистемныеЦвета
{	
	public static Color красный()
	{
		return Color(0xFF, 0x00, 0x00);
	}

	public static Color зелёный()
	{
		return Color(0x00, 0xFF, 0x00);
	}

	public static Color синий()
	{
		return Color(0x00, 0x00, 0xFF);
	}

	public static Color black()
	{
		return Color(0x00, 0x00, 0x00);
	}

	public static Color white()
	{
		return Color(0xFF, 0xFF, 0xFF);
	}

	public static Color yellow()
	{
		return Color(0xFF, 0xFF, 0x00);
	}

	public static Color magenta()
	{
		return Color(0xFF, 0x00, 0xFF);
	}

	public static Color cyan()
	{
		return Color(0x00, 0xFF, 0xFF);
	}

	public static Color darkGray()
	{
		return Color(0xA9, 0xA9, 0xA9);
	}

	public static Color lightGray()
	{
		return Color(0xD3, 0xD3, 0xD3);
	}

	public static Color darkRed()
	{
		return Color(0x8B, 0x00, 0x00);
	}

	public static Color darkGreen()
	{
		return Color(0x00, 0x64, 0x00);
	}

	public static Color darkBlue()
	{
		return Color(0x00, 0x00, 0x8B);
	}

	public static Color darkYellow()
	{
		return Color(0x00, 0x80, 0x80);
	}

	public static Color darkMagenta()
	{
		return Color(0x80, 0x00, 0x80);
	}

	public static Color darkCyan()
	{
		return Color(0x80, 0x80, 0x00);
	}

	public static Color прозрачный()
	{
		return Color(0x00, 0x00, 0x00, 0x00);
	}
	
	public static Color color3DdarkShadow()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DDKSHADOW));
	}

	public static Color color3Dface()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DFACE));
	}

	public static Color colorBtnFace()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_BTNFACE));
	}

	public static Color color3DLight()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DLIGHT));
	}

	public static Color color3DShadow()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DSHADOW));
	}

	public static Color colorActiveBorder()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_ACTIVEBORDER));
	}

	public static Color colorActiveCaption()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_3DLIGHT));
	}

	public static Color colorAppWorkspace()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_APPWORKSPACE));
	}

	public static Color colorBackground()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_BACKGROUND));
	}

	public static Color colorBtnText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_BTNTEXT));
	}

	public static Color colorCaptionText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_CAPTIONTEXT));
	}

	public static Color colorGrayText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_GRAYTEXT));
	}

	public static Color colorHighLight()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_HIGHLIGHT));
	}

	public static Color colorHighLightText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_HIGHLIGHTTEXT));
	}

	public static Color colorInactiveBorder()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INACTIVEBORDER));
	}

	public static Color colorInactiveCaption()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INACTIVECAPTION));
	}

	public static Color colorInactiveCaptionText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INACTIVECAPTIONTEXT));
	}

	public static Color colorInfoBk()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INFOBK));
	}

	public static Color colorInfoText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_INFOTEXT));
	}

	public static Color colorMenu()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_MENU));
	}

	public static Color colorMenuText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_MENUTEXT));
	}

	public static Color colorScrollBar()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_SCROLLBAR));
	}

	public static Color colorWindow()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_WINDOW));
	}

	public static Color colorWindowFrame()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_WINDOW));
	}

	public static Color colorWindowText()
	{
		return Color.fromCOLORREF(GetSysColor(COLOR_WINDOWTEXT));
	}
}

final class ФорматТекста
{
	private СокращениеТекста _trim = СокращениеТекста.NONE; // СокращениеТекста.CHARACTER.
	private ФлагиФорматаТекста _flags = ФлагиФорматаТекста.БЕЗ_ПРЕФИКСОВ | ФлагиФорматаТекста.ПРЕРВАТЬ_СЛОВО;
	private РасположениеТекста _align = РасположениеТекста.LEFT;
	private DRAWTEXTPARAMS _params = {DRAWTEXTPARAMS.sizeof, 8, 0, 0};

	public this()
	{
		
	}
	
	public this(ФорматТекста tf)
	{
		this._trim = tf._trim;
		this._flags = tf._flags;
		this._align = tf._align;
		this._params = tf._params;
	}

	public this(ФлагиФорматаТекста tff)
	{
		this._flags = tff;
	}

	public РасположениеТекста расположение()
	{
		return this._align;
	}
	
	public void расположение(РасположениеТекста ta)
	{
		this._align = ta;
	}

	public void флагиФормата(ФлагиФорматаТекста tff)
	{
		this._flags = tff;
	}
	
	public ФлагиФорматаТекста флагиФормата()
	{
		return this._flags;
	}
	
	public void сокращение(СокращениеТекста tt)
	{
		this._trim = tt;
	}
	
	public СокращениеТекста сокращение()
	{
		return this._trim;
	}

	public int длинаТаб()
	{
		return _params.iTabLength;
	}

	public void длинаТаб(int tablen)
	{
		this._params.iTabLength = tablen;
	}

	public int левыйКрай()
	{
		return this._params.iLeftMargin;
	}
	
	public void левыйКрай(int разм)
	{
		this._params.iLeftMargin = разм;
	}

	public int правыйКрай()
	{
		return this._params.iRightMargin;
	}
	
	public void правыйКрай(int разм)
	{
		this._params.iRightMargin = разм;
	}
}

final class Экран
{
	public static Size size()
	{
		Size разм = void; //Inizializzata sotto

		разм.width = GetSystemMetrics(SM_CXSCREEN);
		разм.height = GetSystemMetrics(SM_CYSCREEN);

		return разм;
	}

	public static Rect workArea()
	{
		Rect к = void; //Inizializzata sotto

		SystemParametersInfoA(SPI_GETWORKAREA, 0, &к.rect, 0);
		return к;
	}

	public static Canvas canvas()
	{
		return Canvas.fromHDC(GetWindowDC(пусто));
	}
}