
module gtkD.gio.SocketAddressEnumerator;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.SocketAddress;




/**
 * Description
 * Objects that describe one or more potential socket endpoints
 * implement GSocketConnectable. Callers can then use
 * g_socket_connectable_enumerate() to get a GSocketAddressEnumerator
 * to try out each socket address in turn until one succeeds, as shown
 * in the sample code below.
 * MyConnectionType *
 * connect_to_host (const char *hostname,
 *  guint16 port,
 *  GCancellable *cancellable,
 *  GError **error)
 * {
	 *  MyConnection *conn = NULL;
	 *  GSocketConnectable *addr;
	 *  GSocketAddressEnumerator *enumerator;
	 *  GSocketAddress *sockaddr;
	 *  GError *conn_error = NULL;
	 *  addr = g_network_address_new ("www.gnome.org", 80);
	 *  enumerator = g_socket_connectable_enumerate (addr);
	 *  g_object_unref (addr);
	 *  /+* Try each sockaddr until we succeed. Record the first
	 *  * connection error, but not any further ones (since they'll probably
	 *  * be basically the same as the first).
	 *  +/
	 *  while (!conn  (sockaddr = g_socket_address_enumerator_next (enumerator, cancellable, error))
	 *  {
		 *  conn = connect_to_sockaddr (sockaddr, conn_error ? NULL : conn_error);
		 *  g_object_unref (sockaddr);
	 *  }
	 *  g_object_unref (enumerator);
	 *  if (conn)
	 *  {
		 *  if (conn_error)
		 *  {
			 *  /+* We couldn't connect to the first address, but we succeeded
			 *  * in connecting to a later address.
			 *  +/
			 *  g_error_free (conn_error);
		 *  }
		 *  return conn;
	 *  }
	 *  else if (error)
	 *  {
		 *  /+* Either the initial lookup failed, or else the caller
		 *  * cancelled us.
		 *  +/
		 *  if (conn_error)
		 *  g_error_free (conn_error);
		 *  return NULL;
	 *  }
	 *  else
	 *  {
		 *  g_error_propagate (error, conn_error);
		 *  return NULL;
	 *  }
 * }
 */
public class SocketAddressEnumerator
{
	
	/** the main Gtk struct */
	protected GSocketAddressEnumerator* gSocketAddressEnumerator;
	
	
	public GSocketAddressEnumerator* getSocketAddressEnumeratorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSocketAddressEnumerator* gSocketAddressEnumerator);
	
	/**
	 */
	
	/**
	 * Retrieves the next GSocketAddress from enumerator. Note that this
	 * may block for some amount of time. (Eg, a GNetworkAddress may need
	 * to do a DNS lookup before it can return an address.) Use
	 * g_socket_address_enumerator_next_async() if you need to avoid
	 * blocking.
	 * If enumerator is expected to yield addresses, but for some reason
	 * is unable to (eg, because of a DNS error), then the first call to
	 * g_socket_address_enumerator_next() will return an appropriate error
	 * in *error. However, if the first call to
	 * g_socket_address_enumerator_next() succeeds, then any further
	 * internal errors (other than cancellable being triggered) will be
	 * ignored.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GSocketAddress (owned by the caller), or NULL on error (in which case *error will be set) or if there are no more addresses.
	 * Throws: GException on failure.
	 */
	public SocketAddress next(Cancellable cancellable);
	
	/**
	 * Asynchronously retrieves the next GSocketAddress from enumerator
	 * and then calls callback, which must call
	 * g_socket_address_enumerator_next_finish() to get the result.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void nextAsync(Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Retrieves the result of a completed call to
	 * g_socket_address_enumerator_next_async(). See
	 * g_socket_address_enumerator_next() for more information about
	 * error handling.
	 * Params:
	 * result =  a GAsyncResult
	 * Returns: a GSocketAddress (owned by the caller), or NULL on error (in which case *error will be set) or if there are no more addresses.
	 * Throws: GException on failure.
	 */
	public SocketAddress nextFinish(AsyncResultIF result);
}
