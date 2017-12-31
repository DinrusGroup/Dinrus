module gtkD.gdk.Cursor;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Pixmap;
private import gtkD.gdk.Color;
private import gtkD.gdk.Display;
private import gtkD.gdk.Pixbuf;




/**
 * Description
 * These functions are used to create and destroy cursors.
 * There is a number of standard cursors, but it is also
 * possible to construct new cursors from pixmaps and
 * pixbufs. There may be limitations as to what kinds of
 * cursors can be constructed on a given display, see
 * gdk_display_supports_cursor_alpha(),
 * gdk_display_supports_cursor_color(),
 * gdk_display_get_default_cursor_size() and
 * gdk_display_get_maximal_cursor_size().
 * Cursors by themselves are not very interesting, they must be be
 * bound to a window for users to see them. This is done with
 * gdk_window_set_cursor() or by setting the cursor member of the
 * GdkWindowAttr struct passed to gdk_window_new().
 */
public class Cursor
{
	
	/** the main Gtk struct */
	protected GdkCursor* gdkCursor;
	
	
	public GdkCursor* getCursorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkCursor* gdkCursor);
	
	/**
	 */
	
	/**
	 * Creates a new cursor from the set of builtin cursors for the default display.
	 * See gdk_cursor_new_for_display().
	 * To make the cursor invisible, use GDK_BLANK_CURSOR.
	 * Params:
	 * cursorType =  cursor to create
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdkCursorType cursorType);
	
	/**
	 * Creates a new cursor from a given pixmap and mask. Both the pixmap and mask
	 * must have a depth of 1 (i.e. each pixel has only 2 values - on or off).
	 * The standard cursor size is 16 by 16 pixels. You can create a bitmap
	 * from inline data as in the below example.
	 * Example 6. Creating a custom cursor
	 * /+* This data is in X bitmap format, and can be created with the 'bitmap'
	 *  utility. +/
	 * #define cursor1_width 16
	 * #define cursor1_height 16
	 * static unsigned char cursor1_bits[] = {
		 *  0x80, 0x01, 0x40, 0x02, 0x20, 0x04, 0x10, 0x08, 0x08, 0x10, 0x04, 0x20,
		 *  0x82, 0x41, 0x41, 0x82, 0x41, 0x82, 0x82, 0x41, 0x04, 0x20, 0x08, 0x10,
	 *  0x10, 0x08, 0x20, 0x04, 0x40, 0x02, 0x80, 0x01};
	 * static unsigned char cursor1mask_bits[] = {
		 *  0x80, 0x01, 0xc0, 0x03, 0x60, 0x06, 0x30, 0x0c, 0x18, 0x18, 0x8c, 0x31,
		 *  0xc6, 0x63, 0x63, 0xc6, 0x63, 0xc6, 0xc6, 0x63, 0x8c, 0x31, 0x18, 0x18,
	 *  0x30, 0x0c, 0x60, 0x06, 0xc0, 0x03, 0x80, 0x01};
	 *  GdkCursor *cursor;
	 *  GdkPixmap *source, *mask;
	 *  GdkColor fg = { 0, 65535, 0, 0 }; /+* Red. +/
	 *  GdkColor bg = { 0, 0, 0, 65535 }; /+* Blue. +/
	 *  source = gdk_bitmap_create_from_data (NULL, cursor1_bits,
	 *  cursor1_width, cursor1_height);
	 *  mask = gdk_bitmap_create_from_data (NULL, cursor1mask_bits,
	 *  cursor1_width, cursor1_height);
	 *  cursor = gdk_cursor_new_from_pixmap (source, mask, fg, bg, 8, 8);
	 *  gdk_pixmap_unref (source);
	 *  gdk_pixmap_unref (mask);
	 *  gdk_window_set_cursor (widget->window, cursor);
	 * Params:
	 * source =  the pixmap specifying the cursor.
	 * mask =  the pixmap specifying the mask, which must be the same size as
	 *  source.
	 * fg =  the foreground color, used for the bits in the source which are 1.
	 *  The color does not have to be allocated first.
	 * bg =  the background color, used for the bits in the source which are 0.
	 *  The color does not have to be allocated first.
	 * x =  the horizontal offset of the 'hotspot' of the cursor.
	 * y =  the vertical offset of the 'hotspot' of the cursor.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Pixmap source, Pixmap mask, Color fg, Color bg, int x, int y);
	
	/**
	 * Creates a new cursor from a pixbuf.
	 * Not all GDK backends support RGBA cursors. If they are not
	 * supported, a monochrome approximation will be displayed.
	 * The functions gdk_display_supports_cursor_alpha() and
	 * gdk_display_supports_cursor_color() can be used to determine
	 * whether RGBA cursors are supported;
	 * gdk_display_get_default_cursor_size() and
	 * gdk_display_get_maximal_cursor_size() give information about
	 * cursor sizes.
	 * On the X backend, support for RGBA cursors requires a
	 * sufficently new version of the X Render extension.
	 * Since 2.4
	 * Params:
	 * display =  the GdkDisplay for which the cursor will be created
	 * pixbuf =  the GdkPixbuf containing the cursor image
	 * x =  the horizontal offset of the 'hotspot' of the cursor.
	 * y =  the vertical offset of the 'hotspot' of the cursor.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Display display, Pixbuf pixbuf, int x, int y);
	
	/**
	 * Creates a new cursor by looking up name in the current cursor
	 * theme.
	 * Since 2.8
	 * Params:
	 * display =  the GdkDisplay for which the cursor will be created
	 * name =  the name of the cursor
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Display display, string name);
	
	/**
	 * Creates a new cursor from the set of builtin cursors.
	 * Since 2.2
	 * Params:
	 * display =  the GdkDisplay for which the cursor will be created
	 * cursorType =  cursor to create
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Display display, GdkCursorType cursorType);
	
	/**
	 * Returns the display on which the GdkCursor is defined.
	 * Since 2.2
	 * Returns: the GdkDisplay associated to cursor
	 */
	public Display getDisplay();
	
	/**
	 * Returns a GdkPixbuf with the image used to display the cursor.
	 * Note that depending on the capabilities of the windowing system and
	 * on the cursor, GDK may not be able to obtain the image data. In this
	 * case, NULL is returned.
	 * Since 2.8
	 * Returns: a GdkPixbuf representing cursor, or NULL
	 */
	public Pixbuf getImage();
	
	/**
	 * Adds a reference to cursor.
	 * Returns: Same cursor that was passed in
	 */
	public Cursor doref();
	
	/**
	 * Removes a reference from cursor, deallocating the cursor
	 * if no references remain.
	 */
	public void unref();
}
