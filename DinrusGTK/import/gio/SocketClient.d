module gtkD.gio.SocketClient;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.SocketAddress;
private import gtkD.gio.SocketConnection;
private import gtkD.gio.SocketConnectableIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GSocketClient is a high-level utility class for connecting to a
 * network host using a connection oriented socket type.
 * You create a GSocketClient object, set any options you want, then
 * call a sync or async connect operation, which returns a GSocketConnection
 * subclass on success.
 * The type of the GSocketConnection object returned depends on the type of
 * the underlying socket that is in use. For instance, for a TCP/IP connection
 * it will be a GTcpConnection.
 */
public class SocketClient : ObjectG
{
	
	/** the main Gtk struct */
	protected GSocketClient* gSocketClient;
	
	
	public GSocketClient* getSocketClientStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSocketClient* gSocketClient);
	
	/**
	 */
	
	/**
	 * Creates a new GSocketClient with the default options.
	 * Since 2.22
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Tries to resolve the connectable and make a network connection to it..
	 * Upon a successful connection, a new GSocketConnection is constructed
	 * and returned. The caller owns this new object and must drop their
	 * reference to it when finished with it.
	 * The type of the GSocketConnection object returned depends on the type of
	 * the underlying socket that is used. For instance, for a TCP/IP connection
	 * it will be a GTcpConnection.
	 * The socket created will be the same family as the the address that the
	 * connectable resolves to, unless family is set with g_socket_client_set_family()
	 * or indirectly via g_socket_client_set_local_address(). The socket type
	 * defaults to G_SOCKET_TYPE_STREAM but can be set with
	 * g_socket_client_set_socket_type().
	 * If a local address is specified with g_socket_client_set_local_address() the
	 * socket will be bound to this address before connecting.
	 * Since 2.22
	 * Params:
	 * connectable =  a GSocketConnectable specifying the remote address.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connect(SocketConnectableIF connectable, Cancellable cancellable);
	
	/**
	 * This is the asynchronous version of g_socket_client_connect().
	 * When the operation is finished callback will be
	 * called. You can then call g_socket_client_connect_finish() to get
	 * the result of the operation.
	 * Since 2.22
	 * Params:
	 * connectable =  a GSocketConnectable specifying the remote address.
	 * cancellable =  a GCancellable, or NULL
	 * callback =  a GAsyncReadyCallback
	 * userData =  user data for the callback
	 */
	public void connectAsync(SocketConnectableIF connectable, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an async connect operation. See g_socket_client_connect_async()
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connectFinish(AsyncResultIF result);
	
	/**
	 * This is a helper function for g_socket_client_connect().
	 * Attempts to create a TCP connection to the named host.
	 * host_and_port may be in any of a number of recognised formats: an IPv6
	 * address, an IPv4 address, or a domain name (in which case a DNS
	 * lookup is performed). Quoting with [] is supported for all address
	 * types. A port override may be specified in the usual way with a
	 * colon. Ports may be given as decimal numbers or symbolic names (in
	 * which case an /etc/services lookup is performed).
	 * If no port override is given in host_and_port then default_port will be
	 * used as the port number to connect to.
	 * In general, host_and_port is expected to be provided by the user (allowing
	 * them to give the hostname, and a port overide if necessary) and
	 * default_port is expected to be provided by the application.
	 * In the case that an IP address is given, a single connection
	 * attempt is made. In the case that a name is given, multiple
	 * connection attempts may be made, in turn and according to the
	 * number of address records in DNS, until a connection succeeds.
	 * Upon a successful connection, a new GSocketConnection is constructed
	 * and returned. The caller owns this new object and must drop their
	 * reference to it when finished with it.
	 * In the event of any failure (DNS error, service not found, no hosts
	 * connectable) NULL is returned and error (if non-NULL) is set
	 * accordingly.
	 * Since 2.22
	 * Params:
	 * hostAndPort =  the name and optionally port of the host to connect to
	 * defaultPort =  the default port to connect to
	 * cancellable =  a GCancellable, or NULL
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connectToHost(string hostAndPort, ushort defaultPort, Cancellable cancellable);
	
	/**
	 * This is the asynchronous version of g_socket_client_connect_to_host().
	 * When the operation is finished callback will be
	 * called. You can then call g_socket_client_connect_to_host_finish() to get
	 * the result of the operation.
	 * Since 2.22
	 * Params:
	 * hostAndPort =  the name and optionally the port of the host to connect to
	 * defaultPort =  the default port to connect to
	 * cancellable =  a GCancellable, or NULL
	 * callback =  a GAsyncReadyCallback
	 * userData =  user data for the callback
	 */
	public void connectToHostAsync(string hostAndPort, ushort defaultPort, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an async connect operation. See g_socket_client_connect_to_host_async()
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connectToHostFinish(AsyncResultIF result);
	
	/**
	 * Attempts to create a TCP connection to a service.
	 * This call looks up the SRV record for service at domain for the
	 * "tcp" protocol. It then attempts to connect, in turn, to each of
	 * the hosts providing the service until either a connection succeeds
	 * or there are no hosts remaining.
	 * Upon a successful connection, a new GSocketConnection is constructed
	 * and returned. The caller owns this new object and must drop their
	 * reference to it when finished with it.
	 * In the event of any failure (DNS error, service not found, no hosts
	 * connectable) NULL is returned and error (if non-NULL) is set
	 * accordingly.
	 * Params:
	 * domain =  a domain name
	 * service =  the name of the service to connect to
	 * cancellable =  a GCancellable, or NULL
	 * Returns: a GSocketConnection if successful, or NULL on error
	 * Throws: GException on failure.
	 */
	public SocketConnection connectToService(string domain, string service, Cancellable cancellable);
	
	/**
	 * This is the asynchronous version of
	 * g_socket_client_connect_to_service().
	 * Since 2.22
	 * Params:
	 * domain =  a domain name
	 * service =  the name of the service to connect to
	 * cancellable =  a GCancellable, or NULL
	 * callback =  a GAsyncReadyCallback
	 * userData =  user data for the callback
	 */
	public void connectToServiceAsync(string domain, string service, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an async connect operation. See g_socket_client_connect_to_service_async()
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a GSocketConnection on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public SocketConnection connectToServiceFinish(AsyncResultIF result);
	
	/**
	 * Sets the socket family of the socket client.
	 * If this is set to something other than G_SOCKET_FAMILY_INVALID
	 * then the sockets created by this object will be of the specified
	 * family.
	 * This might be useful for instance if you want to force the local
	 * connection to be an ipv4 socket, even though the address might
	 * be an ipv6 mapped to ipv4 address.
	 * Since 2.22
	 * Params:
	 * family =  a GSocketFamily
	 */
	public void setFamily(GSocketFamily family);
	
	/**
	 * Sets the local address of the socket client.
	 * The sockets created by this object will bound to the
	 * specified address (if not NULL) before connecting.
	 * This is useful if you want to ensure the the local
	 * side of the connection is on a specific port, or on
	 * a specific interface.
	 * Since 2.22
	 * Params:
	 * address =  a GSocketAddress, or NULL
	 */
	public void setLocalAddress(SocketAddress address);
	
	/**
	 * Sets the protocol of the socket client.
	 * The sockets created by this object will use of the specified
	 * protocol.
	 * If protocol is 0 that means to use the default
	 * protocol for the socket family and type.
	 * Since 2.22
	 * Params:
	 * protocol =  a GSocketProtocol
	 */
	public void setProtocol(GSocketProtocol protocol);
	
	/**
	 * Sets the socket type of the socket client.
	 * The sockets created by this object will be of the specified
	 * type.
	 * It doesn't make sense to specify a type of G_SOCKET_TYPE_DATAGRAM,
	 * as GSocketClient is used for connection oriented services.
	 * Since 2.22
	 * Params:
	 * type =  a GSocketType
	 */
	public void setSocketType(GSocketType type);
	
	/**
	 * Gets the socket family of the socket client.
	 * See g_socket_client_set_family() for details.
	 * Since 2.22
	 * Returns: a GSocketFamily
	 */
	public GSocketFamily getFamily();
	
	/**
	 * Gets the local address of the socket client.
	 * See g_socket_client_set_local_address() for details.
	 * Since 2.22
	 * Returns: a GSocketAddres or NULL. don't free
	 */
	public SocketAddress getLocalAddress();
	
	/**
	 * Gets the protocol name type of the socket client.
	 * See g_socket_client_set_protocol() for details.
	 * Since 2.22
	 * Returns: a GSocketProtocol
	 */
	public GSocketProtocol getProtocol();
	
	/**
	 * Gets the socket type of the socket client.
	 * See g_socket_client_set_socket_type() for details.
	 * Since 2.22
	 * Returns: a GSocketFamily
	 */
	public GSocketType getSocketType();
}
