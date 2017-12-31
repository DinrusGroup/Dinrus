module gtkD.gdk.Bitmap;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Drawable;




/**
 * Description
 * Pixmaps are offscreen drawables. They can be drawn upon with the
 * standard drawing primitives, then copied to another drawable (such as
 * a GdkWindow) with gdk_pixmap_draw(). The depth of a pixmap
 * is the number of bits per pixels. Bitmaps are simply pixmaps
 * with a depth of 1. (That is, they are monochrome bitmaps - each
 * pixel can be either on or off).
 */
public class Bitmap
{
	
	/** the main Gtk struct */
	protected GdkBitmap* gdkBitmap;
	
	
	public GdkBitmap* getBitmapStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkBitmap* gdkBitmap);
	
	/**
	 */
	
	/**
	 * Creates a new bitmap from data in XBM format.
	 * Params:
	 * drawable = a GdkDrawable, used to determine default values
	 * for the new pixmap. Can be NULL, in which case the root
	 * window is used.
	 * data = a pointer to the XBM data.
	 * width = the width of the new pixmap in pixels.
	 * height = the height of the new pixmap in pixels.
	 * Returns:the GdkBitmap
	 */
	public static Bitmap createFromData(Drawable drawable, string data, int width, int height);
}
