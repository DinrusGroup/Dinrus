
module gtkD.gio.NetworkService;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gio.SocketConnectableT;
private import gtkD.gio.SocketConnectableIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Like GNetworkAddress does with hostnames, GNetworkService
 * provides an easy way to resolve a SRV record, and then attempt to
 * connect to one of the hosts that implements that service, handling
 * service priority/weighting, multiple IP addresses, and multiple
 * address families.
 * See GSrvTarget for more information about SRV records, and see
 * GSocketConnectable for and example of using the connectable
 * interface.
 */
public class NetworkService : ObjectG, SocketConnectableIF
{
	
	/** the main Gtk struct */
	protected GNetworkService* gNetworkService;
	
	
	public GNetworkService* getNetworkServiceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GNetworkService* gNetworkService);
	
	// add the SocketConnectable capabilities
	mixin SocketConnectableT!(GNetworkService);
	
	/**
	 */
	
	/**
	 * Creates a new GNetworkService representing the given service,
	 * protocol, and domain. This will initially be unresolved; use the
	 * GSocketConnectable interface to resolve it.
	 * Since 2.22
	 * Params:
	 * service =  the service type to look up (eg, "ldap")
	 * protocol =  the networking protocol to use for service (eg, "tcp")
	 * domain =  the DNS domain to look up the service in
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string service, string protocol, string domain);
	
	/**
	 * Gets srv's service name (eg, "ldap").
	 * Since 2.22
	 * Returns: srv's service name
	 */
	public string getService();
	
	/**
	 * Gets srv's protocol name (eg, "tcp").
	 * Since 2.22
	 * Returns: srv's protocol name
	 */
	public string getProtocol();
	
	/**
	 * Gets the domain that srv serves. This might be either UTF-8 or
	 * ASCII-encoded, depending on what srv was created with.
	 * Since 2.22
	 * Returns: srv's domain name
	 */
	public string getDomain();
}
