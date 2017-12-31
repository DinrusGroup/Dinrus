
module gtkD.gio.UnixSocketAddress;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gio.SocketAddress;

/**
 * Description
 * Support for UNIX-domain (aka local) sockets.
 */
public class UnixSocketAddress : SocketAddress
{
	
	/** the main Gtk struct */
	protected GUnixSocketAddress* gUnixSocketAddress;
	
	
	public GUnixSocketAddress* getUnixSocketAddressStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixSocketAddress* gUnixSocketAddress);
	
	/**
	 */
	
	/**
	 * Creates a new GUnixSocketAddress for path.
	 * To create abstract socket addresses, on systems that support that,
	 * use g_unix_socket_address_new_abstract().
	 * Since 2.22
	 * Params:
	 * path =  the socket path
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string path);
	
	/**
	 * Creates a new abstract GUnixSocketAddress for path.
	 * Unix domain sockets are generally visible in the filesystem. However, some
	 * systems support abstract socket name which are not visible in the
	 * filesystem and not affected by the filesystem permissions, visibility, etc.
	 * Note that not all systems (really only Linux) support abstract
	 * socket names, so if you use them on other systems function calls may
	 * return G_IO_ERROR_NOT_SUPPORTED errors. You can use
	 * g_unix_socket_address_abstract_names_supported() to see if abstract
	 * names are supported.
	 * If path_len is -1 then path is assumed to be a zero terminated
	 * string (although in general abstract names need not be zero terminated
	 * and can have embedded nuls). All bytes after path_len up to the max size
	 * of an abstract unix domain name is filled with zero bytes.
	 * Since 2.22
	 * Params:
	 * path =  the abstract name
	 * pathLen =  the length of path, or -1
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string path, int pathLen);
	
	/**
	 * Gets address's path.
	 * Since 2.22
	 * Returns: TRUE if the address is abstract, FALSE otherwise
	 */
	public int getIsAbstract();
	
	/**
	 * Gets address's path, or for abstract sockets the "name".
	 * Guaranteed to be zero-terminated, but an abstract socket
	 * may contain embedded zeros, and thus you should use
	 * g_unix_socket_address_get_path_len() to get the true length
	 * of this string.
	 * Since 2.22
	 * Returns: the path for address
	 */
	public string getPath();
	
	/**
	 * Gets the length of address's path.
	 * For details, see g_unix_socket_address_get_path().
	 * Since 2.22
	 * Returns: the length of the path
	 */
	public uint getPathLen();
	
	/**
	 * Checks if abstract unix domain socket names are supported.
	 * Since 2.22
	 * Returns: TRUE if supported, FALSE otherwise
	 */
	public static int abstractNamesSupported();
}
