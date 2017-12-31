
module gtkD.gdk.X11;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Drawable;
private import gtkD.gdk.Display;
private import gtkD.gdk.Window;
private import gtkD.gdk.Font;
private import gtkD.gdk.Pixmap;




/**
 * Description
 */
public class X11
{
	
	/**
	 */
	
	/**
	 * Wraps a native window for the default display in a GdkWindow.
	 * This may fail if the window has been destroyed.
	 * For example in the X backend, a native window handle is an Xlib
	 * XID.
	 * Params:
	 * anid =  a native window handle.
	 * Returns: the newly-created GdkWindow wrapper for the native window or NULL if the window has been destroyed.
	 */
	public static Window gdkWindowForeignNew(GdkNativeWindow anid);
	
	/**
	 * Returns the Gdk object associated with the given X id for the default
	 * display.
	 * Params:
	 * xid =  an X id.
	 * Returns: the associated Gdk object, which may be a GdkPixmap, a GdkWindow or a GdkFont or NULL if no object is associated with the X id.
	 */
	public static void* gdkXidTableLookup(uint xid);
	
	/**
	 * Looks up the GdkWindow that wraps the given native window handle.
	 * For example in the X backend, a native window handle is an Xlib
	 * XID.
	 * Params:
	 * anid =  a native window handle.
	 * Returns: the GdkWindow wrapper for the native window,  or NULL if there is none.
	 */
	public static Window gdkWindowLookup(GdkNativeWindow anid);
	
	/**
	 * Looks up the GdkPixmap that wraps the given native pixmap handle.
	 * For example in the X backend, a native pixmap handle is an Xlib
	 * XID.
	 * Params:
	 * anid =  a native pixmap handle.
	 * Returns: the GdkPixmap wrapper for the native pixmap, or NULL if there is none.
	 */
	public static Pixmap gdkPixmapLookup(GdkNativeWindow anid);
	
	/**
	 * Routine to get the current X server time stamp.
	 * Params:
	 * window =  a GdkWindow, used for communication with the server.
	 *  The window must have GDK_PROPERTY_CHANGE_MASK in its
	 *  events mask or a hang will result.
	 * Returns: the time stamp.
	 */
	public static uint getServerTime(Window window);
	
	/**
	 * Gets the XID of the specified output/monitor.
	 * If the X server does not support version 1.2 of the RANDR
	 * extension, 0 is returned.
	 * Since 2.14
	 * Params:
	 * screen =  a GdkScreen
	 * monitorNum =  number of the monitor
	 * Returns: the XID of the monitor
	 */
	public static uint screenGetMonitorOutput(GdkScreen* screen, int monitorNum);
	
	/**
	 * The application can use this call to update the _NET_WM_USER_TIME
	 * property on a toplevel window. This property stores an Xserver
	 * time which represents the time of the last user input event
	 * received for this window. This property may be used by the window
	 * manager to alter the focus, stacking, and/or placement behavior of
	 * windows when they are mapped depending on whether the new window
	 * was created by a user action or is a "pop-up" window activated by a
	 * timer or some other event.
	 * Note that this property is automatically updated by GDK, so this
	 * function should only be used by applications which handle input
	 * events bypassing GDK.
	 * Since 2.6
	 * Params:
	 * window =  A toplevel GdkWindow
	 * timestamp =  An XServer timestamp to which the property should be set
	 */
	public static void windowSetUserTime(Window window, uint timestamp);
	
	/**
	 * Moves the window to the correct workspace when running under a
	 * window manager that supports multiple workspaces, as described
	 * in the Extended
	 * Window Manager Hints. Will not do anything if the
	 * window is already on all workspaces.
	 * Since 2.8
	 * Params:
	 * window =  a GdkWindow
	 */
	public static void windowMoveToCurrentDesktop(Window window);
	
	/**
	 * Gets the startup notification ID for a display.
	 * Since 2.12
	 * Params:
	 * display =  a GdkDisplay
	 * Returns: the startup notification ID for display
	 */
	public static string displayGetStartupNotificationId(Display display);
	
	/**
	 * Returns the X resource (window or pixmap) belonging to a GdkDrawable.
	 * Params:
	 * drawable =  a GdkDrawable.
	 * Returns: the ID of drawable's X resource.
	 */
	public static uint drawableGetXid(Drawable drawable);
	
	/**
	 * Warning
	 * gdk_x11_font_get_name is deprecated and should not be used in newly-written code.
	 * Return the X Logical Font Description (for font->type == GDK_FONT_FONT)
	 * or comma separated list of XLFDs (for font->type == GDK_FONT_FONTSET)
	 * that was used to load the font. If the same font was loaded
	 * via multiple names, which name is returned is undefined.
	 * Params:
	 * font =  a GdkFont.
	 * Returns: the name of the font. This string is owned by GDK and must not be modified or freed.
	 */
	public static string fontGetName(Font font);
	
	/**
	 * Warning
	 * gdk_x11_font_get_xfont is deprecated and should not be used in newly-written code.
	 * Returns the X font belonging to a GdkFont.
	 * Params:
	 * font =  a GdkFont.
	 * Returns: an Xlib XFontStruct* or an XFontSet.
	 */
	public static void* fontGetXfont(Font font);
	
	/**
	 * Gets the default GTK+ screen number.
	 * Returns: returns the screen number specified by the --display command line option or the DISPLAY environment variable when gdk_init() calls XOpenDisplay().
	 */
	public static int getDefaultScreen();
	
	/**
	 * Call gdk_x11_display_grab() on the default display.
	 * To ungrab the server again, use gdk_x11_ungrab_server().
	 * gdk_x11_grab_server()/gdk_x11_ungrab_server() calls can be nested.
	 */
	public static void grabServer();
	
	/**
	 * Ungrab the default display after it has been grabbed with
	 * gdk_x11_grab_server().
	 */
	public static void ungrabServer();
}
