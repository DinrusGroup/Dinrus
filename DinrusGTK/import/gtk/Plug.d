module gtkD.gtk.Plug;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gdk.Display;



private import gtkD.gtk.Window;

/**
 * Description
 * Together with GtkSocket, GtkPlug provides the ability
 * to embed widgets from one process into another process
 * in a fashion that is transparent to the user. One
 * process creates a GtkSocket widget and, passes the
 * ID of that widgets window to the other process,
 * which then creates a GtkPlug with that window ID.
 * Any widgets contained in the GtkPlug then will appear
 * inside the first applications window.
 * Note
 * The GtkPlug and GtkSocket widgets are currently not available
 * on all platforms supported by GTK+.
 */
public class Plug : Window
{
	
	/** the main Gtk struct */
	protected GtkPlug* gtkPlug;
	
	
	public GtkPlug* getPlugStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPlug* gtkPlug);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Plug)[] onEmbeddedListeners;
	/**
	 * Gets emitted when the plug becomes embedded in a socket
	 * and when the embedding ends.
	 * See Also
	 * GtkSocket
	 * the widget that a GtkPlug plugs into.
	 */
	void addOnEmbedded(void delegate(Plug) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackEmbedded(GtkPlug* plugStruct, Plug plug);
	
	
	/**
	 * Finish the initialization of plug for a given GtkSocket identified by
	 * socket_id. This function will generally only be used by classes deriving from GtkPlug.
	 * Params:
	 * socketId =  the XID of the socket's window.
	 */
	public void construct(GdkNativeWindow socketId);
	
	/**
	 * Finish the initialization of plug for a given GtkSocket identified by
	 * socket_id which is currently displayed on display.
	 * This function will generally only be used by classes deriving from GtkPlug.
	 * Since 2.2
	 * Params:
	 * display =  the GdkDisplay associated with socket_id's
	 *  GtkSocket.
	 * socketId =  the XID of the socket's window.
	 */
	public void constructForDisplay(Display display, GdkNativeWindow socketId);
	
	/**
	 * Creates a new plug widget inside the GtkSocket identified
	 * by socket_id. If socket_id is 0, the plug is left "unplugged" and
	 * can later be plugged into a GtkSocket by gtk_socket_add_id().
	 * Params:
	 * socketId =  the window ID of the socket, or 0.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdkNativeWindow socketId);
	
	/**
	 * Create a new plug widget inside the GtkSocket identified by socket_id.
	 * Since 2.2
	 * Params:
	 * display =  the GdkDisplay on which socket_id is displayed
	 * socketId =  the XID of the socket's window.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Display display, GdkNativeWindow socketId);
	
	/**
	 * Gets the window ID of a GtkPlug widget, which can then
	 * be used to embed this window inside another window, for
	 * instance with gtk_socket_add_id().
	 * Returns: the window ID for the plug
	 */
	public GdkNativeWindow getId();
	
	/**
	 * Determines whether the plug is embedded in a socket.
	 * Since 2.14
	 * Returns: TRUE if the plug is embedded in a socket
	 */
	public int getEmbedded();
	
	/**
	 * Retrieves the socket the plug is embedded in.
	 * Since 2.14
	 * Returns: the window of the socket, or NULL
	 */
	public GdkWindow* getSocketWindow();
}
