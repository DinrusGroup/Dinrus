
module gtkD.gio.SocketAddress;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.SocketConnectableT;
private import gtkD.gio.SocketConnectableIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GSocketAddress is the equivalent of struct sockaddr
 * in the BSD sockets API. This is an abstract class; use
 * GInetSocketAddress for internet sockets, or GUnixSocketAddress
 * for UNIX domain sockets.
 */
public class SocketAddress : ObjectG, SocketConnectableIF
{
	
	/** the main Gtk struct */
	protected GSocketAddress* gSocketAddress;
	
	
	public GSocketAddress* getSocketAddressStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSocketAddress* gSocketAddress);
	
	// add the SocketConnectable capabilities
	mixin SocketConnectableT!(GSocketAddress);
	
	/**
	 */
	
	/**
	 * Creates a GSocketAddress subclass corresponding to the native
	 * struct sockaddr native.
	 * Since 2.22
	 * Params:
	 * native =  a pointer to a struct sockaddr
	 * len =  the size of the memory location pointed to by native
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (void* native, uint len);
	
	/**
	 * Gets the socket family type of address.
	 * Since 2.22
	 * Returns: the socket family type of address.
	 */
	public GSocketFamily getFamily();
	
	/**
	 * Converts a GSocketAddress to a native struct
	 * sockaddr, which can be passed to low-level functions like
	 * connect() or bind().
	 * If not enough space is availible, a G_IO_ERROR_NO_SPACE error is
	 * returned. If the address type is not known on the system
	 * then a G_IO_ERROR_NOT_SUPPORTED error is returned.
	 * Since 2.22
	 * Params:
	 * dest =  a pointer to a memory location that will contain the native
	 * struct sockaddr.
	 * destlen =  the size of dest. Must be at least as large as
	 * g_socket_address_get_native_size().
	 * Returns: TRUE if dest was filled in, FALSE on error
	 * Throws: GException on failure.
	 */
	public int toNative(void* dest, uint destlen);
	
	/**
	 * Gets the size of address's native struct sockaddr.
	 * You can use this to allocate memory to pass to
	 * g_socket_address_to_native().
	 * Since 2.22
	 * Returns: the size of the native struct sockaddr that address represents
	 */
	public int getNativeSize();
}
