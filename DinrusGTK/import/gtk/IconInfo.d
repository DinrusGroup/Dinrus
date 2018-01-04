module gtkD.gtk.IconInfo;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gtk.IconInfo;
private import gtkD.gtk.IconTheme;
private import gtkD.gdk.Pixbuf;




/**
 * Description
 * GtkIconTheme provides a facility for looking up icons by name
 * and size. The main reason for using a name rather than simply
 * providing a filename is to allow different icons to be used
 * depending on what icon theme is selecetd
 * by the user. The operation of icon themes on Linux and Unix
 * follows the Icon
 * Theme Specification. There is a default icon theme,
 * named hicolor where applications should install
 * their icons, but more additional application themes can be
 * installed as operating system vendors and users choose.
 * Named icons are similar to the Themeable Stock Images(3)
 * facility, and the distinction between the two may be a bit confusing.
 * A few things to keep in mind:
 * Stock images usually are used in conjunction with
 * Stock Items(3)., such as GTK_STOCK_OK or
 * GTK_STOCK_OPEN. Named icons are easier to set up and therefore
 * are more useful for new icons that an application wants to
 * add, such as application icons or window icons.
 * Stock images can only be loaded at the symbolic sizes defined
 * by the GtkIconSize enumeration, or by custom sizes defined
 * by gtk_icon_size_register(), while named icons are more flexible
 * and any pixel size can be specified.
 * Because stock images are closely tied to stock items, and thus
 * to actions in the user interface, stock images may come in
 * multiple variants for different widget states or writing
 * directions.
 * A good rule of thumb is that if there is a stock image for what
 * you want to use, use it, otherwise use a named icon. It turns
 * out that internally stock images are generally defined in
 * terms of one or more named icons. (An example of the
 * more than one case is icons that depend on writing direction;
 * GTK_STOCK_GO_FORWARD uses the two themed icons
 * "gtk-stock-go-forward-ltr" and "gtk-stock-go-forward-rtl".)
 * In many cases, named themes are used indirectly, via GtkImage
 * or stock items, rather than directly, but looking up icons
 * directly is also simple. The GtkIconTheme object acts
 * as a database of all the icons in the current theme. You
 * can create new GtkIconTheme objects, but its much more
 * efficient to use the standard icon theme for the GdkScreen
 * so that the icon information is shared with other people
 * looking up icons. In the case where the default screen is
 * being used, looking up an icon can be as simple as:
 * GError *error = NULL;
 * GtkIconTheme *icon_theme;
 * GdkPixbuf *pixbuf;
 * icon_theme = gtk_icon_theme_get_default ();
 * pixbuf = gtk_icon_theme_load_icon (icon_theme,
 *  "my-icon-name", /+* icon name +/
 *  48, /+* size +/
 *  0, /+* flags +/
 *  error);
 * if (!pixbuf)
 *  {
	 *  g_warning ("Couldn't load icon: %s", error->message);
	 *  g_error_free (error);
 *  }
 * else
 *  {
	 *  /+* Use the pixbuf +/
	 *  g_object_unref (pixbuf);
 *  }
 */
public class IconInfo
{
	
	/** the main Gtk struct */
	protected GtkIconInfo* gtkIconInfo;
	
	
	public GtkIconInfo* getIconInfoStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkIconInfo* gtkIconInfo);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(IconInfo)[] onChangedListeners;
	/**
	 * Emitted when the current icon theme is switched or GTK+ detects
	 * that a change has occurred in the contents of the current
	 * icon theme.
	 */
	void addOnChanged(void delegate(IconInfo) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChanged(GtkIconTheme* iconThemeStruct, IconInfo iconInfo);
	
	
	/**
	 * Make a copy of a GtkIconInfo.
	 * Since 2.4
	 * Returns: the new GtkIconInfo
	 */
	public IconInfo copy();
	
	/**
	 * Free a GtkIconInfo and associated information
	 * Since 2.4
	 */
	public void free();
	
	/**
	 * Creates a GtkIconInfo for a GdkPixbuf.
	 * Since 2.14
	 * Params:
	 * iconTheme =  a GtkIconTheme
	 * pixbuf =  the pixbuf to wrap in a GtkIconInfo
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (IconTheme iconTheme, Pixbuf pixbuf);
	
	/**
	 * Gets the base size for the icon. The base size
	 * is a size for the icon that was specified by
	 * the icon theme creator. This may be different
	 * than the actual size of image; an example of
	 * this is small emblem icons that can be attached
	 * to a larger icon. These icons will be given
	 * the same base size as the larger icons to which
	 * they are attached.
	 * Since 2.4
	 * Returns: the base size, or 0, if no base size is known for the icon.
	 */
	public int getBaseSize();
	
	/**
	 * Gets the filename for the icon. If the
	 * GTK_ICON_LOOKUP_USE_BUILTIN flag was passed
	 * to gtk_icon_theme_lookup_icon(), there may be
	 * no filename if a builtin icon is returned; in this
	 * case, you should use gtk_icon_info_get_builtin_pixbuf().
	 * Since 2.4
	 * Returns: the filename for the icon, or NULL if gtk_icon_info_get_builtin_pixbuf() should be used instead. The return value is owned by GTK+ and should not be modified or freed.
	 */
	public string getFilename();
	
	/**
	 * Gets the built-in image for this icon, if any. To allow
	 * GTK+ to use built in icon images, you must pass the
	 * GTK_ICON_LOOKUP_USE_BUILTIN to
	 * gtk_icon_theme_lookup_icon().
	 * Since 2.4
	 * Returns: the built-in image pixbuf, or NULL. No extra reference is added to the returned pixbuf, so if you want to keep it around, you must use g_object_ref(). The returned image must not be modified.
	 */
	public Pixbuf getBuiltinPixbuf();
	
	/**
	 * Renders an icon previously looked up in an icon theme using
	 * gtk_icon_theme_lookup_icon(); the size will be based on the size
	 * passed to gtk_icon_theme_lookup_icon(). Note that the resulting
	 * pixbuf may not be exactly this size; an icon theme may have icons
	 * that differ slightly from their nominal sizes, and in addition GTK+
	 * will avoid scaling icons that it considers sufficiently close to the
	 * requested size or for which the source image would have to be scaled
	 * up too far. (This maintains sharpness.). This behaviour can be changed
	 * by passing the GTK_ICON_LOOKUP_FORCE_SIZE flag when obtaining
	 * the GtkIconInfo. If this flag has been specified, the pixbuf
	 * returned by this function will be scaled to the exact size.
	 * Since 2.4
	 * Returns: the rendered icon; this may be a newly created icon or a new reference to an internal icon, so you must not modify the icon. Use g_object_unref() to release your reference to the icon.
	 * Throws: GException on failure.
	 */
	public Pixbuf loadIcon();
	
	/**
	 * Sets whether the coordinates returned by gtk_icon_info_get_embedded_rect()
	 * and gtk_icon_info_get_attach_points() should be returned in their
	 * original form as specified in the icon theme, instead of scaled
	 * appropriately for the pixbuf returned by gtk_icon_info_load_icon().
	 * Raw coordinates are somewhat strange; they are specified to be with
	 * respect to the unscaled pixmap for PNG and XPM icons, but for SVG
	 * icons, they are in a 1000x1000 coordinate space that is scaled
	 * to the final size of the icon. You can determine if the icon is an SVG
	 * icon by using gtk_icon_info_get_filename(), and seeing if it is non-NULL
	 * and ends in '.svg'.
	 * This function is provided primarily to allow compatibility wrappers
	 * for older API's, and is not expected to be useful for applications.
	 * Since 2.4
	 * Params:
	 * rawCoordinates =  whether the coordinates of embedded rectangles
	 *  and attached points should be returned in their original
	 *  (unscaled) form.
	 */
	public void setRawCoordinates(int rawCoordinates);
	
	/**
	 * Gets the coordinates of a rectangle within the icon
	 * that can be used for display of information such
	 * as a preview of the contents of a text file.
	 * See gtk_icon_info_set_raw_coordinates() for further
	 * information about the coordinate system.
	 * Since 2.4
	 * Params:
	 * rectangle =  GdkRectangle in which to store embedded
	 *  rectangle coordinates; coordinates are only stored
	 *  when this function returns TRUE.
	 * Returns: TRUE if the icon has an embedded rectangle
	 */
	public int getEmbeddedRect(out GdkRectangle rectangle);
	
	/**
	 * Fetches the set of attach points for an icon. An attach point
	 * is a location in the icon that can be used as anchor points for attaching
	 * emblems or overlays to the icon.
	 * Since 2.4
	 * Params:
	 * points =  location to store pointer to an array of points, or NULL
	 *  free the array of points with g_free().
	 * Returns: TRUE if there are any attach points for the icon.
	 */
	public int getAttachPoints(out GdkPoint[] points);
	
	/**
	 * Gets the display name for an icon. A display name is a
	 * string to be used in place of the icon name in a user
	 * visible context like a list of icons.
	 * Since 2.4
	 * Signal Details
	 * The "changed" signal
	 * void user_function (GtkIconTheme *icon_theme,
	 *  gpointer user_data) : Run Last
	 * Emitted when the current icon theme is switched or GTK+ detects
	 * that a change has occurred in the contents of the current
	 * icon theme.
	 * Returns: the display name for the icon or NULL, if the icon doesn't have a specified display name. This value is owned icon_info and must not be modified or free.
	 */
	public string getDisplayName();
}
