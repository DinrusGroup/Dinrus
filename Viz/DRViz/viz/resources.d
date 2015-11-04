module dgui.resources;

public import dgui.core.winapi;
public import dgui.core.geometry;
public import dgui.canvas;
public import std.string;

final class Resources
{
	private static Resources _rsrc;
	
	private this()
	{
		
	}	

	public Пиктограмма дайПиктограмму(ushort id)
	{
		return дайПиктограмму(id, NullSize);
	}
	
	public Пиктограмма дайПиктограмму(ushort id, Size разм)
	{
		HICON hIcon = LoadImageA(getHInstance(), cast(ткст0)id, IMAGE_ICON, разм.width, разм.height, LR_LOADTRANSPARENT | (разм == NullSize ? LR_DEFAULTSIZE : 0));

		if(!hIcon)
		{
			debug
			{
				throw new Win32Exception(format("Cannot загрузка Пиктограмма: '%d'", id), __FILE__, __LINE__);
			}
			else
			{
				throw new Win32Exception(format("Cannot загрузка Пиктограмма: '%d'", id));
			}
		}
		
		return Пиктограмма.fromHICON(hIcon);
	}

	public Битмап дайБитмап(ushort id)
	{
		HBITMAP hBitmap = LoadImageA(getHInstance(), cast(ткст0)id, IMAGE_BITMAP, 0, 0, LR_LOADTRANSPARENT | LR_DEFAULTSIZE);

		if(!hBitmap)
		{
			debug
			{
				throw new GdiException(format("Cannot загрузка Битмап: '%d'", id), __FILE__, __LINE__);
			}
			else
			{
				throw new GdiException(format("Cannot загрузка Битмап: '%d'", id));
			}
		}

		return Битмап.fromHBITMAP(hBitmap);
	}

	public T* getRaw(T)(ushort id, ткст0 rt)
	{
		HRSRC hRsrc = FindResourceA(пусто, MAKEINTRESOURCEA(id), rt);

		if(!hRsrc)
		{
			debug
			{
				throw new GdiException(format("Cannot загрузка Custom Resource: '%d'", id), __FILE__, __LINE__);
			}
			else
			{
				throw new GdiException(format("Cannot загрузка Custom Resource: '%d'", id));
			}
		}

		return cast(T*)LockResource(LoadResource(пусто, hRsrc));
	}

	public static Resources instance()
	{
		if(!_rsrc)
		{
			_rsrc = new Resources();
		}

		return _rsrc;
	}
}