
module gtkD.gio.SocketService;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;




private import gtkD.gio.SocketListener;

/**
 * Description
 * A GSocketService is an object that represents a service that is
 * provided to the network or over local sockets. When a new
 * connection is made to the service the "incoming"
 * signal is emitted.
 * A GSocketService is a subclass of GSocketListener and you need
 * to add the addresses you want to accept connections on to the
 * with the GSocketListener APIs.
 * There are two options for implementing a network service based on
 * GSocketService. The first is to create the service using
 * g_socket_service_new() and to connect to the "incoming"
 * signal. The second is to subclass GSocketService and override the
 * default signal handler implementation.
 * In either case, the handler must immediately return, or else it
 * will block additional incoming connections from being serviced.
 * If you are interested in writing connection handlers that contain
 * blocking code then see GThreadedSocketService.
 * The socket service runs on the main loop in the main thread, and is
 * not threadsafe in general. However, the calls to start and stop
 * the service are threadsafe so these can be used from threads that
 * handle incoming clients.
 */
public class SocketService : SocketListener
{
	
	/** the main Gtk struct */
	protected GSocketService* gSocketService;
	
	
	public GSocketService* getSocketServiceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSocketService* gSocketService);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	bool delegate(GSocketConnection*, GObject*, SocketService)[] onIncomingListeners;
	/**
	 * The ::incoming signal is emitted when a new incoming connection
	 * to service needs to be handled. The handler must initiate the
	 * handling of connection, but may not block; in essence,
	 * asynchronous operations must be used.
	 * Since 2.22
	 * See Also
	 * #GThreadedSocketService, GSocketListener.
	 */
	void addOnIncoming(bool delegate(GSocketConnection*, GObject*, SocketService) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackIncoming(GSocketService* serviceStruct, GSocketConnection* connection, GObject* sourceObject, SocketService socketService);
	
	
	/**
	 * Creates a new GSocketService with no sockets to listen for.
	 * New listeners can be added with e.g. g_socket_listener_add_address()
	 * or g_socket_listener_add_inet_port().
	 * Since 2.22
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Starts the service, i.e. start accepting connections
	 * from the added sockets when the mainloop runs.
	 * This call is threadsafe, so it may be called from a thread
	 * handling an incomming client request.
	 * Since 2.22
	 */
	public void start();
	
	/**
	 * Stops the service, i.e. stops accepting connections
	 * from the added sockets when the mainloop runs.
	 * This call is threadsafe, so it may be called from a thread
	 * handling an incomming client request.
	 * Since 2.22
	 */
	public void stop();
	
	/**
	 * Check whether the service is active or not. An active
	 * service will accept new clients that connect, while
	 * a non-active service will let connecting clients queue
	 * up until the service is started.
	 * Since 2.22
	 * Signal Details
	 * The "incoming" signal
	 * gboolean user_function (GSocketService *service,
	 *  GSocketConnection *connection,
	 *  GObject *source_object,
	 *  gpointer user_data) : Run Last
	 * The ::incoming signal is emitted when a new incoming connection
	 * to service needs to be handled. The handler must initiate the
	 * handling of connection, but may not block; in essence,
	 * asynchronous operations must be used.
	 * Since 2.22
	 * Returns: TRUE if the service is active, FALSE otherwiseReturns: TRUE to stop other handlers from being called
	 */
	public int isActive();
}
