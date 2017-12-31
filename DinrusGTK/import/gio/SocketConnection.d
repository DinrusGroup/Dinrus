module gtkD.gio.SocketConnection;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.Socket;
private import gtkD.gio.SocketAddress;



private import gtkD.gio.IOStream;

/**
 * Description
 * GSocketConnection is a GIOStream for a connected socket. They
 * can be created either by GSocketClient when connecting to a host,
 * or by GSocketListener when accepting a new client.
 * The type of the GSocketConnection object returned from these calls
 * depends on the type of the underlying socket that is in use. For
 * instance, for a TCP/IP connection it will be a GTcpConnection.
 * Chosing what type of object to construct is done with the socket
 * connection factory, and it is possible for 3rd parties to register
 * custom socket connection types for specific combination of socket
 * family/type/protocol using g_socket_connection_factory_register_type().
 */
public class SocketConnection : IOStream
{
	
	/** the main Gtk struct */
	protected GSocketConnection* gSocketConnection;
	
	
	public GSocketConnection* getSocketConnectionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSocketConnection* gSocketConnection);
	
	/**
	 */
	
	/**
	 * Try to get the local address of a socket connection.
	 * Since 2.22
	 * Returns: a GSocketAddress or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public SocketAddress getLocalAddress();
	
	/**
	 * Try to get the remote address of a socket connection.
	 * Since 2.22
	 * Returns: a GSocketAddress or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public SocketAddress getRemoteAddress();
	
	/**
	 * Gets the underlying GSocket object of the connection.
	 * This can be useful if you want to do something unusual on it
	 * not supported by the GSocketConnection APIs.
	 * Since 2.22
	 * Returns: a GSocketAddress or NULL on error.
	 */
	public Socket getSocket();
	
	/**
	 * Creates a GSocketConnection subclass of the right type for
	 * socket.
	 * Since 2.22
	 * Params:
	 * socket =  a GSocket
	 * Returns: a GSocketConnection
	 */
	public static SocketConnection factoryCreateConnection(Socket socket);
	
	/**
	 * Looks up the GType to be used when creating socket connections on
	 * sockets with the specified family,type and protocol_id.
	 * If no type is registered, the GSocketConnection base type is returned.
	 * Since 2.22
	 * Params:
	 * family =  a GSocketFamily
	 * type =  a GSocketType
	 * protocolId =  a protocol id
	 * Returns: a GType
	 */
	public static GType factoryLookupType(GSocketFamily family, GSocketType type, int protocolId);
	
	/**
	 * Looks up the GType to be used when creating socket connections on
	 * sockets with the specified family,type and protocol.
	 * If no type is registered, the GSocketConnection base type is returned.
	 * Since 2.22
	 * Params:
	 * gType =  a GType, inheriting from G_TYPE_SOCKET_CONNECTION
	 * family =  a GSocketFamily
	 * type =  a GSocketType
	 * protocol =  a protocol id
	 */
	public static void factoryRegisterType(GType gType, GSocketFamily family, GSocketType type, int protocol);
}
