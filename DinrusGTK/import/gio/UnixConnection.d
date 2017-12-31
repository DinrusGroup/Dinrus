
module gtkD.gio.UnixConnection;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.Cancellable;



private import gtkD.gio.TcpConnection;

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
public class UnixConnection : TcpConnection
{
	
	/** the main Gtk struct */
	protected GUnixConnection* gUnixConnection;
	
	
	public GUnixConnection* getUnixConnectionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixConnection* gUnixConnection);
	
	/**
	 */
	
	/**
	 * Receives a file descriptor from the sending end of the connection.
	 * The sending end has to call g_unix_connection_send_fd() for this
	 * to work.
	 * As well as reading the fd this also reads a single byte from the
	 * stream, as this is required for fd passing to work on some
	 * implementations.
	 * Since 2.22
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore
	 * Returns: a file descriptor on success, -1 on error.
	 * Throws: GException on failure.
	 */
	public int receiveFd(Cancellable cancellable);
	
	/**
	 * Passes a file descriptor to the recieving side of the
	 * connection. The recieving end has to call g_unix_connection_receive_fd()
	 * to accept the file descriptor.
	 * As well as sending the fd this also writes a single byte to the
	 * stream, as this is required for fd passing to work on some
	 * implementations.
	 * Since 2.22
	 * Params:
	 * fd =  a file descriptor
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a TRUE on success, NULL on error.
	 * Throws: GException on failure.
	 */
	public int sendFd(int fd, Cancellable cancellable);
}
