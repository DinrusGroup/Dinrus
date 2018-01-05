module gtkD.gtk.StatusIcon;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gdk.Pixbuf;
private import gtkD.gdk.Screen;
private import gtkD.gtk.Menu;
private import gtkD.gtk.Tooltip;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The "system tray" or notification area is normally used for transient icons
 * that indicate some special state. For example, a system tray icon might
 * appear to tell the user that they have new mail, or have an incoming instant
 * message, or something along those lines. The basic idea is that creating an
 * icon in the notification area is less annoying than popping up a dialog.
 * A GtkStatusIcon object can be used to display an icon in a "system tray".
 * The icon can have a tooltip, and the user can interact with it by
 * activating it or popping up a context menu. Critical information should
 * not solely be displayed in a GtkStatusIcon, since it may not be
 * visible (e.g. when the user doesn't have a notification area on his panel).
 * This can be checked with gtk_status_icon_is_embedded().
 * On X11, the implementation follows the freedesktop.org "System Tray"
 * specification. Implementations of the "tray" side of this specification can
 * be found e.g. in the GNOME and KDE panel applications.
 * Note that a GtkStatusIcon is not a widget, but just
 * a GObject. Making it a widget would be impractical, since the system tray
 * on Win32 doesn't allow to embed arbitrary widgets.
 */
public class StatusIcon : ObjectG
{

	/** the main Gtk struct */
	protected GtkStatusIcon* gtkStatusIcon;


	public GtkStatusIcon* getStatusIconStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkStatusIcon* gtkStatusIcon);

	/**
	 * Creates a status icon displaying a stock icon. Sample stock icon
	 * names are StockID.OPEN, StockID.QUIT. You can register your
	 * own stock icon names, see gtk_icon_factory_add_default() and
	 * gtk_icon_factory_add().
	 * Since 2.10
	 * Params:
	 *  stock_id = a stock icon id
	 * Returns:
	 *  a new GtkStatusIcon
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (StockID stockID);

	/**
	 * Creates a status icon displaying an icon from the current icon theme.
	 * If the current icon theme is changed, the icon will be updated
	 * appropriately.
	 * Since 2.10
	 * Params:
	 *  iconName =  an icon name
	 *  loadFromFile = treat iconName as a filename and load that image
	 *  with gtk_status_icon_new_from_file.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string iconName, bool loadFromFile = false);

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(StatusIcon)[] onActivateListeners;
	/**
	 * Gets emitted when the user activates the status icon.
	 * If and how status icons can activated is platform-dependent.
	 * Unlike most G_SIGNAL_ACTION signals, this signal is meant to
	 * be used by applications and should be wrapped by language bindings.
	 * Since 2.10
	 */
	void addOnActivate(void delegate(StatusIcon) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackActivate(GtkStatusIcon* statusIconStruct, StatusIcon statusIcon);

	bool delegate(GdkEventButton*, StatusIcon)[] onButtonPressListeners;
	/**
	 * The ::button-press-event signal will be emitted when a button
	 * (typically from a mouse) is pressed.
	 * Whether this event is emitted is platform-dependent. Use the ::activate
	 * and ::popup-menu signals in preference.
	 * Since 2.14
	 */
	void addOnButtonPress(bool delegate(GdkEventButton*, StatusIcon) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackButtonPress(GtkStatusIcon* statusIconStruct, GdkEventButton* event, StatusIcon statusIcon);

	bool delegate(GdkEventButton*, StatusIcon)[] onButtonReleaseListeners;
	/**
	 * The ::button-release-event signal will be emitted when a button
	 * (typically from a mouse) is released.
	 * Whether this event is emitted is platform-dependent. Use the ::activate
	 * and ::popup-menu signals in preference.
	 * Since 2.14
	 */
	void addOnButtonRelease(bool delegate(GdkEventButton*, StatusIcon) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackButtonRelease(GtkStatusIcon* statusIconStruct, GdkEventButton* event, StatusIcon statusIcon);

	void delegate(guint, guint, StatusIcon)[] onPopupMenuListeners;
	/**
	 * Gets emitted when the user brings up the context menu
	 * of the status icon. Whether status icons can have context
	 * menus and how these are activated is platform-dependent.
	 * The button and activate_time parameters should be
	 * passed as the last to arguments to gtk_menu_popup().
	 * Unlike most G_SIGNAL_ACTION signals, this signal is meant to
	 * be used by applications and should be wrapped by language bindings.
	 * Since 2.10
	 */
	void addOnPopupMenu(void delegate(guint, guint, StatusIcon) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPopupMenu(GtkStatusIcon* statusIconStruct, guint button, guint activateTime, StatusIcon statusIcon);

	bool delegate(gint, gint, gboolean, Tooltip, StatusIcon)[] onQueryTooltipListeners;
	/**
	 * Emitted when the "gtk-tooltip-timeout" has expired with the
	 * cursor hovering above status_icon; or emitted when status_icon got
	 * focus in keyboard mode.
	 * Using the given coordinates, the signal handler should determine
	 * whether a tooltip should be shown for status_icon. If this is
	 * the case TRUE should be returned, FALSE otherwise. Note that if
	 * keyboard_mode is TRUE, the values of x and y are undefined and
	 * should not be used.
	 * The signal handler is free to manipulate tooltip with the therefore
	 * destined function calls.
	 * Whether this signal is emitted is platform-dependent.
	 * For plain text tooltips, use "tooltip-text" in preference.
	 * Since 2.16
	 */
	void addOnQueryTooltip(bool delegate(gint, gint, gboolean, Tooltip, StatusIcon) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackQueryTooltip(GtkStatusIcon* statusIconStruct, gint x, gint y, gboolean keyboardMode, GtkTooltip* tooltip, StatusIcon statusIcon);


	bool delegate(GdkEventScroll*, StatusIcon)[] onScrollListeners;
	/**
	 * The ::scroll-event signal is emitted when a button in the 4 to 7
	 * range is pressed. Wheel mice are usually configured to generate
	 * button press events for buttons 4 and 5 when the wheel is turned.
	 * Whether this event is emitted is platform-dependent.
	 */
	void addOnScroll(bool delegate(GdkEventScroll*, StatusIcon) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackScroll(GtkStatusIcon* statusIconStruct, GdkEventScroll* event, StatusIcon statusIcon);

	bool delegate(gint, StatusIcon)[] onSizeChangedListeners;
	/**
	 * Gets emitted when the size available for the image
	 * changes, e.g. because the notification area got resized.
	 * Since 2.10
	 */
	void addOnSizeChanged(bool delegate(gint, StatusIcon) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackSizeChanged(GtkStatusIcon* statusIconStruct, gint size, StatusIcon statusIcon);


	/**
	 * Creates an empty status icon object.
	 * Since 2.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();

	/**
	 * Creates a status icon displaying pixbuf.
	 * The image will be scaled down to fit in the available
	 * space in the notification area, if necessary.
	 * Since 2.10
	 * Params:
	 * pixbuf =  a GdkPixbuf
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Pixbuf pixbuf);

	/**
	 * Creates a status icon displaying a GIcon. If the icon is a
	 * themed icon, it will be updated when the theme changes.
	 * Since 2.14
	 * Params:
	 * icon =  a GIcon
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (IconIF icon);

	/**
	 * Makes status_icon display pixbuf.
	 * See gtk_status_icon_new_from_pixbuf() for details.
	 * Since 2.10
	 * Params:
	 * pixbuf =  a GdkPixbuf or NULL
	 */
	public void setFromPixbuf(Pixbuf pixbuf);

	/**
	 * Makes status_icon display the file filename.
	 * See gtk_status_icon_new_from_file() for details.
	 * Since 2.10
	 * Params:
	 * filename =  a filename
	 */
	public void setFromFile(string filename);

	/**
	 * Makes status_icon display the stock icon with the id stock_id.
	 * See gtk_status_icon_new_from_stock() for details.
	 * Since 2.10
	 * Params:
	 * stockId =  a stock icon id
	 */
	public void setFromStock(string stockId);

	/**
	 * Makes status_icon display the icon named icon_name from the
	 * current icon theme.
	 * See gtk_status_icon_new_from_icon_name() for details.
	 * Since 2.10
	 * Params:
	 * iconName =  an icon name
	 */
	public void setFromIconName(string iconName);

	/**
	 * Makes status_icon display the GIcon.
	 * See gtk_status_icon_new_from_gicon() for details.
	 * Since 2.14
	 * Params:
	 * icon =  a GIcon
	 */
	public void setFromGicon(IconIF icon);

	/**
	 * Gets the type of representation being used by the GtkStatusIcon
	 * to store image data. If the GtkStatusIcon has no image data,
	 * the return value will be GTK_IMAGE_EMPTY.
	 * Since 2.10
	 * Returns: the image representation being used
	 */
	public GtkImageType getStorageType();

	/**
	 * Gets the GdkPixbuf being displayed by the GtkStatusIcon.
	 * The storage type of the status icon must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_PIXBUF (see gtk_status_icon_get_storage_type()).
	 * The caller of this function does not own a reference to the
	 * returned pixbuf.
	 * Since 2.10
	 * Returns: the displayed pixbuf, or NULL if the image is empty.
	 */
	public Pixbuf getPixbuf();

	/**
	 * Gets the id of the stock icon being displayed by the GtkStatusIcon.
	 * The storage type of the status icon must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_STOCK (see gtk_status_icon_get_storage_type()).
	 * The returned string is owned by the GtkStatusIcon and should not
	 * be freed or modified.
	 * Since 2.10
	 * Returns: stock id of the displayed stock icon, or NULL if the image is empty.
	 */
	public string getStock();

	/**
	 * Gets the name of the icon being displayed by the GtkStatusIcon.
	 * The storage type of the status icon must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_ICON_NAME (see gtk_status_icon_get_storage_type()).
	 * The returned string is owned by the GtkStatusIcon and should not
	 * be freed or modified.
	 * Since 2.10
	 * Returns: name of the displayed icon, or NULL if the image is empty.
	 */
	public string getIconName();

	/**
	 * Retrieves the GIcon being displayed by the GtkStatusIcon.
	 * The storage type of the status icon must be GTK_IMAGE_EMPTY or
	 * GTK_IMAGE_GICON (see gtk_status_icon_get_storage_type()).
	 * The caller of this function does not own a reference to the
	 * returned GIcon.
	 * If this function fails, icon is left unchanged;
	 * Since 2.14
	 * Returns: the displayed icon, or NULL if the image is empty
	 */
	public IconIF getGicon();

	/**
	 * Gets the size in pixels that is available for the image.
	 * Stock icons and named icons adapt their size automatically
	 * if the size of the notification area changes. For other
	 * storage types, the size-changed signal can be used to
	 * react to size changes.
	 * Note that the returned size is only meaningful while the
	 * status icon is embedded (see gtk_status_icon_is_embedded()).
	 * Since 2.10
	 * Returns: the size that is available for the image
	 */
	public int getSize();

	/**
	 * Sets the GdkScreen where status_icon is displayed; if
	 * the icon is already mapped, it will be unmapped, and
	 * then remapped on the new screen.
	 * Since 2.12
	 * Params:
	 * screen =  a GdkScreen
	 */
	public void setScreen(Screen screen);

	/**
	 * Returns the GdkScreen associated with status_icon.
	 * Since 2.12
	 * Returns: a GdkScreen.
	 */
	public Screen getScreen();

	/**
	 * Warning
	 * gtk_status_icon_set_tooltip has been deprecated since version 2.16 and should not be used in newly-written code. Use gtk_status_icon_set_tooltip_text() instead.
	 * Sets the tooltip of the status icon.
	 * Since 2.10
	 * Params:
	 * tooltipText =  the tooltip text, or NULL
	 */
	public void setTooltip(string tooltipText);

	/**
	 * Sets text as the contents of the tooltip.
	 * This function will take care of setting "has-tooltip" to
	 * TRUE and of the default handler for the "query-tooltip"
	 * signal.
	 * See also the "tooltip-text" property and
	 * gtk_tooltip_set_text().
	 * Since 2.16
	 * Params:
	 * text =  the contents of the tooltip for status_icon
	 */
	public void setTooltipText(string text);

	/**
	 * Gets the contents of the tooltip for status_icon.
	 * Since 2.16
	 * Returns: the tooltip text, or NULL. You should free the returned string with g_free() when done.
	 */
	public string getTooltipText();

	/**
	 * Sets markup as the contents of the tooltip, which is marked up with
	 *  the Pango text markup language.
	 * This function will take care of setting "has-tooltip" to TRUE
	 * and of the default handler for the "query-tooltip" signal.
	 * See also the "tooltip-markup" property and
	 * gtk_tooltip_set_markup().
	 * Since 2.16
	 * Params:
	 * markup =  the contents of the tooltip for status_icon, or NULL
	 */
	public void setTooltipMarkup(string markup);

	/**
	 * Gets the contents of the tooltip for status_icon.
	 * Since 2.16
	 * Returns: the tooltip text, or NULL. You should free the returned string with g_free() when done.
	 */
	public string getTooltipMarkup();

	/**
	 * Sets the has-tooltip property on status_icon to has_tooltip.
	 * See "has-tooltip" for more information.
	 * Since 2.16
	 * Params:
	 * hasTooltip =  whether or not status_icon has a tooltip
	 */
	public void setHasTooltip(int hasTooltip);

	/**
	 * Returns the current value of the has-tooltip property.
	 * See "has-tooltip" for more information.
	 * Since 2.16
	 * Returns: current value of has-tooltip on status_icon.
	 */
	public int getHasTooltip();

	/**
	 * Sets the title of this tray icon.
	 * This should be a short, human-readable, localized string
	 * describing the tray icon. It may be used by tools like screen
	 * readers to render the tray icon.
	 * Since 2.18
	 * Params:
	 * title =  the title
	 */
	public void setTitle(string title);

	/**
	 * Gets the title of this tray icon. See gtk_status_icon_set_title().
	 * Since 2.18
	 * Returns: the title of the status icon
	 */
	public string getTitle();

	/**
	 * Shows or hides a status icon.
	 * Since 2.10
	 * Params:
	 * visible =  TRUE to show the status icon, FALSE to hide it
	 */
	public void setVisible(int visible);

	/**
	 * Returns whether the status icon is visible or not.
	 * Note that being visible does not guarantee that
	 * the user can actually see the icon, see also
	 * gtk_status_icon_is_embedded().
	 * Since 2.10
	 * Returns: TRUE if the status icon is visible
	 */
	public int getVisible();

	/**
	 * Makes the status icon start or stop blinking.
	 * Note that blinking user interface elements may be problematic
	 * for some users, and thus may be turned off, in which case
	 * this setting has no effect.
	 * Since 2.10
	 * Params:
	 * blinking =  TRUE to turn blinking on, FALSE to turn it off
	 */
	public void setBlinking(int blinking);

	/**
	 * Returns whether the icon is blinking, see
	 * gtk_status_icon_set_blinking().
	 * Since 2.10
	 * Returns: TRUE if the icon is blinking
	 */
	public int getBlinking();

	/**
	 * Returns whether the status icon is embedded in a notification
	 * area.
	 * Since 2.10
	 * Returns: TRUE if the status icon is embedded in a notification area.
	 */
	public int isEmbedded();

	/**
	 * Menu positioning function to use with gtk_menu_popup()
	 * to position menu aligned to the status icon user_data.
	 * Since 2.10
	 * Params:
	 * menu =  the GtkMenu
	 * x =  return location for the x position
	 * y =  return location for the y position
	 * pushIn =  whether the first menu item should be offset (pushed in) to be
	 *  aligned with the menu popup position (only useful for GtkOptionMenu).
	 * userData =  the status icon to position the menu on
	 */
	public static void positionMenu(Menu menu, out int x, out int y, out int pushIn, void* userData);

	/**
	 * Obtains information about the location of the status icon
	 * on screen. This information can be used to e.g. position
	 * popups like notification bubbles.
	 * See gtk_status_icon_position_menu() for a more convenient
	 * alternative for positioning menus.
	 * Note that some platforms do not allow GTK+ to provide
	 * this information, and even on platforms that do allow it,
	 * the information is not reliable unless the status icon
	 * is embedded in a notification area, see
	 * gtk_status_icon_is_embedded().
	 * Since 2.10
	 * Params:
	 * screen =  return location for the screen, or NULL if the
	 *  information is not needed
	 * area =  return location for the area occupied by the status
	 *  icon, or NULL
	 * orientation =  return location for the orientation of the panel
	 *  in which the status icon is embedded, or NULL. A panel
	 *  at the top or bottom of the screen is horizontal, a panel
	 *  at the left or right is vertical.
	 * Returns: TRUE if the location information has  been filled in
	 */
	public int getGeometry(out Screen screen, out GdkRectangle area, out GtkOrientation orientation);

	/**
	 * This function is only useful on the X11/freedesktop.org platform.
	 * It returns a window ID for the widget in the underlying
	 * status icon implementation. This is useful for the Galago
	 * notification service, which can send a window ID in the protocol
	 * in order for the server to position notification windows
	 * pointing to a status icon reliably.
	 * This function is not intended for other use cases which are
	 * more likely to be met by one of the non-X11 specific methods, such
	 * as gtk_status_icon_position_menu().
	 * Since 2.14
	 * Returns: An 32 bit unsigned integer identifier for the underlying X11 Window
	 */
	public uint getX11_WindowId();
}
