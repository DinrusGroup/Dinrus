module gtkD.gio.InetSocketAddress;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.InetAddress;



private import gtkD.gio.SocketAddress;

/**
 * Description
 * An IPv4 or IPv6 socket address; that is, the combination of a
 * GInetAddress and a port number.
 */
public class InetSocketAddress : SocketAddress
{
	
	/** the main Gtk struct */
	protected GInetSocketAddress* gInetSocketAddress;
	
	
	public GInetSocketAddress* getInetSocketAddressStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GInetSocketAddress* gInetSocketAddress);
	
	/**
	 */
	
	/**
	 * Creates a new GInetSocketAddress for address and port.
	 * Since 2.22
	 * Params:
	 * address =  a GInetAddress
	 * port =  a port number
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (InetAddress address, ushort port);
	
	/**
	 * Gets address's GInetAddress.
	 * Since 2.22
	 * Returns: the GInetAddress for address, which must beg_object_ref()'d if it will be stored
	 */
	public InetAddress getAddress();
	
	/**
	 * Gets address's port.
	 * Since 2.22
	 * Returns: the port for address
	 */
	public ushort getPort();
}
