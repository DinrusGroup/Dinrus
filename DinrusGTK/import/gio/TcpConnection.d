module gtkD.gio.TcpConnection;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;





private import gtkD.gio.SocketConnection;

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
public class TcpConnection : SocketConnection
{
	
	/** the main Gtk struct */
	protected GTcpConnection* gTcpConnection;
	
	
	public GTcpConnection* getTcpConnectionStruct()
	{
		return gTcpConnection;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GTcpConnection* gTcpConnection);
	
	/**
	 */
	
	/**
	 * This enabled graceful disconnects on close. A graceful disconnect
	 * means that we signal the recieving end that the connection is terminated
	 * and wait for it to close the connection before closing the connection.
	 * A graceful disconnect means that we can be sure that we successfully sent
	 * all the outstanding data to the other end, or get an error reported.
	 * However, it also means we have to wait for all the data to reach the
	 * other side and for it to acknowledge this by closing the socket, which may
	 * take a while. For this reason it is disabled by default.
	 * Since 2.22
	 * Params:
	 * gracefulDisconnect =  Whether to do graceful disconnects or not
	 */
	public void setGracefulDisconnect(int gracefulDisconnect);
	
	/**
	 * Checks if graceful disconnects are used. See
	 * g_tcp_connection_set_graceful_disconnect().
	 * Since 2.22
	 * Returns: TRUE if graceful disconnect is used on close, FALSE otherwise
	 */
	public int getGracefulDisconnect();
}
