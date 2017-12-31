module gtkD.gio.ThreadedSocketService;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;




private import gtkD.gio.SocketService;

/**
 * Description
 * A GThreadedSocketService is a simple subclass of GSocketService
 * that handles incoming connections by creating a worker thread and
 * dispatching the connection to it by emitting the ::run signal in
 * the new thread.
 * The signal handler may perform blocking IO and need not return
 * until the connection is closed.
 * The service is implemented using a thread pool, so there is a
 * limited amount of threads availible to serve incomming requests.
 * The service automatically stops the GSocketService from accepting
 * new connections when all threads are busy.
 * As with GSocketService, you may connect to "run",
 * or subclass and override the default handler.
 */
public class ThreadedSocketService : SocketService
{
	
	/** the main Gtk struct */
	protected GThreadedSocketService* gThreadedSocketService;
	
	
	public GThreadedSocketService* getThreadedSocketServiceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GThreadedSocketService* gThreadedSocketService);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	bool delegate(GSocketConnection*, GObject*, ThreadedSocketService)[] onRunListeners;
	/**
	 * The ::run signal is emitted in a worker thread in response to an
	 * incoming connection. This thread is dedicated to handling
	 * connection and may perform blocking IO. The signal handler need
	 * not return until the connection is closed.
	 * See Also
	 * #GSocketService.
	 */
	void addOnRun(bool delegate(GSocketConnection*, GObject*, ThreadedSocketService) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackRun(GThreadedSocketService* serviceStruct, GSocketConnection* connection, GObject* sourceObject, ThreadedSocketService threadedSocketService);
	
	
	/**
	 * Creates a new GThreadedSocketService with no listeners. Listeners
	 * must be added with g_socket_service_add_listeners().
	 * Since 2.22
	 * Params:
	 * maxThreads =  the maximal number of threads to execute concurrently
	 *  handling incoming clients, -1 means no limit
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int maxThreads);
}
