
module gtkD.gio.SocketConnectableT;

public  import gtkD.gtkc.giotypes;

public import gtkD.gtkc.gio;
public import gtkD.glib.ConstructionException;


public import gtkD.gio.SocketAddressEnumerator;




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
public template SocketConnectableT(TStruct)
{
	
	/** the main Gtk struct */
	protected GSocketConnectable* gSocketConnectable;
	
	
	public GSocketConnectable* getSocketConnectableTStruct()
	{
		return cast(GSocketConnectable*)getStruct();
	}
	
	
	/**
	 */
	
	/**
	 * Creates a GSocketAddressEnumerator for connectable.
	 * Since 2.22
	 * Returns: a new GSocketAddressEnumerator.
	 */
	public SocketAddressEnumerator enumerate()
	{
		// GSocketAddressEnumerator * g_socket_connectable_enumerate  (GSocketConnectable *connectable);
		auto p = g_socket_connectable_enumerate(getSocketConnectableTStruct());
		if(p is null)
		{
			return null;
		}
		return new SocketAddressEnumerator(cast(GSocketAddressEnumerator*) p);
	}
}
