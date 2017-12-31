module gtkD.gdk.DisplayManager;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gdk.Display;
private import gtkD.glib.ListSG;
private import gtkD.gdk.Device;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The purpose of the GdkDisplayManager singleton object is to offer
 * notification when displays appear or disappear or the default display
 * changes.
 */
public class DisplayManager : ObjectG
{
	
	/** the main Gtk struct */
	protected GdkDisplayManager* gdkDisplayManager;
	
	
	public GdkDisplayManager* getDisplayManagerStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkDisplayManager* gdkDisplayManager);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Display, DisplayManager)[] onDisplayOpenedListeners;
	/**
	 * The ::display_opened signal is emitted when a display is opened.
	 * Since 2.2
	 */
	void addOnDisplayOpened(void delegate(Display, DisplayManager) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDisplayOpened(GdkDisplayManager* displayManagerStruct, GdkDisplay* display, DisplayManager displayManager);
	
	
	/**
	 * Returns the global GdkDisplayManager singleton; gdk_parse_pargs(),
	 * gdk_init(), or gdk_init_check() must have been called first.
	 * Since 2.2
	 * Returns: the singleton GdkDisplayManager object.
	 */
	public static DisplayManager get();
	
	/**
	 * Gets the default GdkDisplay.
	 * Since 2.2
	 * Returns: a GdkDisplay, or NULL if there is no default display.
	 */
	public Display getDefaultDisplay();
	
	/**
	 * Sets display as the default display.
	 * Since 2.2
	 * Params:
	 * display =  a GdkDisplay
	 */
	public void setDefaultDisplay(Display display);
	
	/**
	 * List all currently open displays.
	 * Since 2.2
	 * Returns: a newly allocated GSList of GdkDisplay objects. Free this list with g_slist_free() when you are done with it.
	 */
	public ListSG listDisplays();
	
	/**
	 * Returns the core pointer device for the given display
	 * Since 2.2
	 * Params:
	 * display =  a GdkDisplay
	 * Returns: the core pointer device; this is owned by the display and should not be freed.
	 */
	public static Device gdkDisplayGetCorePointer(Display display);
}
