
module wx.Icon;
public import wx.common;
public import wx.Bitmap;

//! \cond STD
version (Tango)
{
import tango.core.Version;
import tango.text.convert.Utf;
static if (Tango.Major == 0 && Tango.Minor >= 994)
alias tango.text.convert.Utf.toString toUtf8;
char[] toUTF8( char[] str) { return str; }
char[] toUTF8(wchar[] str) { return toUtf8(str); }
char[] toUTF8(dchar[] str) { return toUtf8(str); }
}
else // Phobos
{
private import std.string;
private import std.utf;
}
//! \endcond

		//! \cond EXTERN
		static extern (C) IntPtr wxIcon_ctor();
		static extern (C) void   wxIcon_CopyFromBitmap(IntPtr self, IntPtr bitmap);
		static extern (C) bool   wxIcon_LoadFile(IntPtr self, string name, BitmapType type);
		//! \endcond

		//---------------------------------------------------------------------

	alias Icon wxIcon;
	public class Icon : Bitmap
	{
		public static Icon wxNullIcon;
		public this(string name);
		public this(string name, BitmapType type);
		public this();
		
		public this(IntPtr wxobj) ;
		public void CopyFromBitmap(Bitmap bitmap);
	}
