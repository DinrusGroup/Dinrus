module gtkD.gtk.Socket;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gdk.Window;



private import gtkD.gtk.Container;

/**
 * Description
 * Together with GtkPlug, GtkSocket provides the ability
 * to embed widgets from one process into another process
 * in a fashion that is transparent to the user. One
 * process creates a GtkSocket widget and, passes the
 * that widget's window ID to the other process,
 * which then creates a GtkPlug with that window ID.
 * Any widgets contained in the GtkPlug then will appear
 * inside the first applications window.
 * The socket's window ID is obtained by using
 * gtk_socket_get_id(). Before using this function,
 * the socket must have been realized, and for hence,
 * have been added to its parent.
 * Example 56. Obtaining the window ID of a socket.
 * GtkWidget *socket = gtk_socket_new ();
 * gtk_widget_show (socket);
 * gtk_container_add (GTK_CONTAINER (parent), socket);
 * /+* The following call is only necessary if one of
 *  * the ancestors of the socket is not yet visible.
 *  +/
 * gtk_widget_realize (socket);
 * g_print ("The ID of the sockets window is %x\n",
 *  gtk_socket_get_id (socket));
 * Note that if you pass the window ID of the socket to another
 * process that will create a plug in the socket, you
 * must make sure that the socket widget is not destroyed
 * until that plug is created. Violating this rule will
 * cause unpredictable consequences, the most likely
 * consequence being that the plug will appear as a
 * separate toplevel window. You can check if the plug
 * has been created by examining the
 * plug_window field of the
 * GtkSocket structure. If this field is non-NULL,
 * then the plug has been successfully created inside
 * of the socket.
 * When GTK+ is notified that the embedded window has been
 * destroyed, then it will destroy the socket as well. You
 * should always, therefore, be prepared for your sockets
 * to be destroyed at any time when the main event loop
 * is running. To prevent this from happening, you can
 * connect to the "plug-removed" signal.
 * The communication between a GtkSocket and a GtkPlug follows the
 * XEmbed
 * protocol. This protocol has also been implemented in other toolkits, e.g.
 * Qt, allowing the same level of integration
 * when embedding a Qt widget in GTK or vice versa.
 * A socket can also be used to swallow arbitrary
 * pre-existing top-level windows using gtk_socket_steal(),
 * though the integration when this is done will not be as close
 * as between a GtkPlug and a GtkSocket.
 * Note
 * The GtkPlug and GtkSocket widgets are currently not available
 * on all platforms supported by GTK+.
 */
public class Socket : Container
{
	
	/** the main Gtk struct */
	protected GtkSocket* gtkSocket;
	
	
	public GtkSocket* getSocketStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSocket* gtkSocket);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Socket)[] onPlugAddedListeners;
	/**
	 * This signal is emitted when a client is successfully
	 * added to the socket.
	 */
	void addOnPlugAdded(void delegate(Socket) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPlugAdded(GtkSocket* socketStruct, Socket socket);
	
	bool delegate(Socket)[] onPlugRemovedListeners;
	/**
	 * This signal is emitted when a client is removed from the socket.
	 * The default action is to destroy the GtkSocket widget, so if you
	 * want to reuse it you must add a signal handler that returns TRUE.
	 * See Also
	 * GtkPlug
	 * the widget that plugs into a GtkSocket.
	 * XEmbed
	 * the XEmbed Protocol Specification.
	 */
	void addOnPlugRemoved(bool delegate(Socket) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackPlugRemoved(GtkSocket* socketStruct, Socket socket);
	
	
	/**
	 * Create a new empty GtkSocket.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Warning
	 * gtk_socket_steal is deprecated and should not be used in newly-written code.
	 * Reparents a pre-existing toplevel window into a GtkSocket. This is
	 * meant to embed clients that do not know about embedding into a
	 * GtkSocket, however doing so is inherently unreliable, and using
	 * this function is not recommended.
	 * The GtkSocket must have already be added into a toplevel window
	 *  before you can make this call.
	 * Params:
	 * wid =  the window ID of an existing toplevel window.
	 */
	public void steal(GdkNativeWindow wid);
	
	/**
	 * Adds an XEMBED client, such as a GtkPlug, to the GtkSocket. The
	 * client may be in the same process or in a different process.
	 * To embed a GtkPlug in a GtkSocket, you can either create the
	 * GtkPlug with gtk_plug_new (0), call
	 * gtk_plug_get_id() to get the window ID of the plug, and then pass that to the
	 * gtk_socket_add_id(), or you can call gtk_socket_get_id() to get the
	 * window ID for the socket, and call gtk_plug_new() passing in that
	 * ID.
	 * The GtkSocket must have already be added into a toplevel window
	 *  before you can make this call.
	 * Params:
	 * windowId =  the window ID of a client participating in the XEMBED protocol.
	 */
	public void addId(GdkNativeWindow windowId);
	
	/**
	 * Gets the window ID of a GtkSocket widget, which can then
	 * be used to create a client embedded inside the socket, for
	 * instance with gtk_plug_new().
	 * The GtkSocket must have already be added into a toplevel window
	 * before you can make this call.
	 * Returns: the window ID for the socket
	 */
	public GdkNativeWindow getId();
	
	/**
	 * Retrieves the window of the plug. Use this to check if the plug has
	 * been created inside of the socket.
	 * Since 2.14
	 * Signal Details
	 * The "plug-added" signal
	 * void user_function (GtkSocket *socket_,
	 *  gpointer user_data) : Run Last
	 * This signal is emitted when a client is successfully
	 * added to the socket.
	 * Returns: the window of the plug if available, or NULL
	 */
	public Window getPlugWindow();
}
