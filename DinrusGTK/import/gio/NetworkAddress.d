module gtkD.gio.NetworkAddress;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.SocketConnectableIF;
private import gtkD.gio.SocketConnectableT;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GNetworkAddress provides an easy way to resolve a hostname and
 * then attempt to connect to that host, handling the possibility of
 * multiple IP addresses and multiple address families.
 * See GSocketConnectable for and example of using the connectable
 * interface.
 */
public class NetworkAddress : ObjectG, SocketConnectableIF
{
	
	/** the main Gtk struct */
	protected GNetworkAddress* gNetworkAddress;
	
	
	public GNetworkAddress* getNetworkAddressStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GNetworkAddress* gNetworkAddress);
	
	// add the SocketConnectable capabilities
	mixin SocketConnectableT!(GNetworkAddress);
	
	/**
	 * Creates a new GSocketConnectable for connecting to the given
	 * hostname and port. May fail and return NULL in case
	 * parsing host_and_port fails.
	 * host_and_port may be in any of a number of recognised formats: an IPv6
	 * address, an IPv4 address, or a domain name (in which case a DNS
	 * lookup is performed). Quoting with [] is supported for all address
	 * types. A port override may be specified in the usual way with a
	 * colon. Ports may be given as decimal numbers or symbolic names (in
	 * which case an /etc/services lookup is performed).
	 * If no port is specified in host_and_port then default_port will be
	 * used as the port number to connect to.
	 * In general, host_and_port is expected to be provided by the user
	 * (allowing them to give the hostname, and a port overide if necessary)
	 * and default_port is expected to be provided by the application.
	 * Since 2.22
	 * Params:
	 * hostAndPort =  the hostname and optionally a port
	 * defaultPort =  the default port if not in host_and_port
	 * Returns: the new GNetworkAddress, or NULL on error
	 * Throws: GException on failure.
	 */
	public static SocketConnectableIF parse(string hostAndPort, ushort defaultPort);
	
	/**
	 */
	
	/**
	 * Creates a new GSocketConnectable for connecting to the given
	 * hostname and port.
	 * Since 2.22
	 * Params:
	 * hostname =  the hostname
	 * port =  the port
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string hostname, ushort port);
	
	/**
	 * Gets addr's hostname. This might be either UTF-8 or ASCII-encoded,
	 * depending on what addr was created with.
	 * Since 2.22
	 * Returns: addr's hostname
	 */
	public string getHostname();
	
	/**
	 * Gets addr's port number
	 * Since 2.22
	 * Returns: addr's port (which may be 0)
	 */
	public ushort getPort();
}
