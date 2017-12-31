module gtkD.gio.SrvTarget;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;




/**
 * Description
 * SRV (service) records are used by some network protocols to provide
 * service-specific aliasing and load-balancing. For example, XMPP
 * (Jabber) uses SRV records to locate the XMPP server for a domain;
 * rather than connecting directly to "example.com" or assuming a
 * specific server hostname like "xmpp.example.com", an XMPP client
 * would look up the "xmpp-client" SRV record for "example.com", and
 * then connect to whatever host was pointed to by that record.
 * You can use g_resolver_lookup_service() or
 * g_resolver_lookup_service_async() to find the GSrvTargets
 * for a given service. However, if you are simply planning to connect
 * to the remote service, you can use GNetworkService's
 * GSocketConnectable interface and not need to worry about
 * GSrvTarget at all.
 */
public class SrvTarget
{
	
	/** the main Gtk struct */
	protected GSrvTarget* gSrvTarget;
	
	
	public GSrvTarget* getSrvTargetStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSrvTarget* gSrvTarget);
	
	/**
	 */
	
	/**
	 * Creates a new GSrvTarget with the given parameters.
	 * You should not need to use this; normally GSrvTargets are
	 * created by GResolver.
	 * Since 2.22
	 * Params:
	 * hostname =  the host that the service is running on
	 * port =  the port that the service is running on
	 * priority =  the target's priority
	 * weight =  the target's weight
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string hostname, ushort port, ushort priority, ushort weight);
	
	/**
	 * Copies target
	 * Since 2.22
	 * Returns: a copy of target
	 */
	public SrvTarget copy();
	
	/**
	 * Frees target
	 * Since 2.22
	 */
	public void free();
	
	/**
	 * Gets target's hostname (in ASCII form; if you are going to present
	 * this to the user, you should use g_hostname_is_ascii_encoded() to
	 * check if it contains encoded Unicode segments, and use
	 * g_hostname_to_unicode() to convert it if it does.)
	 * Since 2.22
	 * Returns: target's hostname
	 */
	public string getHostname();
	
	/**
	 * Gets target's port
	 * Since 2.22
	 * Returns: target's port
	 */
	public ushort getPort();
	
	/**
	 * Gets target's priority. You should not need to look at this;
	 * GResolver already sorts the targets according to the algorithm in
	 * RFC 2782.
	 * Since 2.22
	 * Returns: target's priority
	 */
	public ushort getPriority();
	
	/**
	 * Gets target's weight. You should not need to look at this;
	 * GResolver already sorts the targets according to the algorithm in
	 * RFC 2782.
	 * Since 2.22
	 * Returns: target's weight
	 */
	public ushort getWeight();
	
	/**
	 * Sorts targets in place according to the algorithm in RFC 2782.
	 * Since 2.22
	 * Params:
	 * targets =  a GList of GSrvTarget
	 * Returns: the head of the sorted list.
	 */
	public static ListG listSort(ListG targets);
}
