module gtkD.gio.InetAddress;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GInetAddress represents an IPv4 or IPv6 internet address. Use
 * g_resolver_lookup_by_name() or g_resolver_lookup_by_name_async() to
 * look up the GInetAddress for a hostname. Use
 * g_resolver_lookup_by_address() or
 * g_resolver_lookup_by_address_async() to look up the hostname for a
 * GInetAddress.
 * To actually connect to a remote host, you will need a
 * GInetSocketAddress (which includes a GInetAddress as well as a
 * port number).
 */
public class InetAddress : ObjectG
{
	
	/** the main Gtk struct */
	protected GInetAddress* gInetAddress;
	
	
	public GInetAddress* getInetAddressStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GInetAddress* gInetAddress);
	
	/**
	 */
	
	/**
	 * Parses string as an IP address and creates a new GInetAddress.
	 * Since 2.22
	 * Params:
	 * string =  a string representation of an IP address
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string string);
	
	/**
	 * Creates a new GInetAddress from the given family and bytes.
	 * bytes should be 4 bytes for G_INET_ADDRESS_IPV4 and 16 bytes for
	 * G_INET_ADDRESS_IPV6.
	 * Since 2.22
	 * Params:
	 * bytes =  raw address data
	 * family =  the address family of bytes
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ubyte[] bytes, GSocketFamily family);
	
	/**
	 * Creates a GInetAddress for the "any" address (unassigned/"don't
	 * care") for family.
	 * Since 2.22
	 * Params:
	 * family =  the address family
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GSocketFamily family);
	
	/**
	 * Gets the raw binary address data from address.
	 * Since 2.22
	 * Returns: a pointer to an internal array of the bytes in address,which should not be modified, stored, or freed. The size of thisarray can be gotten with g_inet_address_get_native_size().
	 */
	public ubyte[] toBytes();
	
	/**
	 * Gets the size of the native raw binary address for address. This
	 * is the size of the data that you get from g_inet_address_to_bytes().
	 * Since 2.22
	 * Returns: the number of bytes used for the native version of address.
	 */
	public uint getNativeSize();
	
	/**
	 * Converts address to string form.
	 * Since 2.22
	 * Returns: a representation of address as a string, which should befreed after use.
	 */
	public string toString();
	
	/**
	 * Gets address's family
	 * Since 2.22
	 * Returns: address's family
	 */
	public GSocketFamily getFamily();
	
	/**
	 * Tests whether address is the "any" address for its family.
	 * Since 2.22
	 * Returns: TRUE if address is the "any" address for its family.
	 */
	public int getIsAny();
	
	/**
	 * Tests whether address is the loopback address for its family.
	 * Since 2.22
	 * Returns: TRUE if address is the loopback address for its family.
	 */
	public int getIsLoopback();
	
	/**
	 * Tests whether address is a link-local address (that is, if it
	 * identifies a host on a local network that is not connected to the
	 * Internet).
	 * Since 2.22
	 * Returns: TRUE if address is a link-local address.
	 */
	public int getIsLinkLocal();
	
	/**
	 * Tests whether address is a site-local address such as 10.0.0.1
	 * (that is, the address identifies a host on a local network that can
	 * not be reached directly from the Internet, but which may have
	 * outgoing Internet connectivity via a NAT or firewall).
	 * Since 2.22
	 * Returns: TRUE if address is a site-local address.
	 */
	public int getIsSiteLocal();
	
	/**
	 * Tests whether address is a multicast address.
	 * Since 2.22
	 * Returns: TRUE if address is a multicast address.
	 */
	public int getIsMulticast();
	
	/**
	 * Tests whether address is a link-local multicast address.
	 * Since 2.22
	 * Returns: TRUE if address is a link-local multicast address.
	 */
	public int getIsMcLinkLocal();
	
	/**
	 * Tests whether address is a node-local multicast address.
	 * Since 2.22
	 * Returns: TRUE if address is a node-local multicast address.
	 */
	public int getIsMcNodeLocal();
	
	/**
	 * Tests whether address is a site-local multicast address.
	 * Since 2.22
	 * Returns: TRUE if address is a site-local multicast address.
	 */
	public int getIsMcSiteLocal();
	
	/**
	 * Tests whether address is an organization-local multicast address.
	 * Since 2.22
	 * Returns: TRUE if address is an organization-local multicast address.
	 */
	public int getIsMcOrgLocal();
	
	/**
	 * Tests whether address is a global multicast address.
	 * Since 2.22
	 * Returns: TRUE if address is a global multicast address.
	 */
	public int getIsMcGlobal();
}
