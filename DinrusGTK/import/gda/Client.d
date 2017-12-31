module gtkD.gda.Client;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gda.Connection;
private import gtkD.gda.ErrorGda;
private import gtkD.gda.ParameterList;
private import gtkD.gda.Transaction;



private import gtkD.gobject.ObjectG;

/**
 * Description
 *  This class is the main entry point for libgda client applications. It provides
 *  the way by which client applications open connections. Thus, before using any other
 *  database-oriented function in libgda, applications must create a GdaClient object
 *  (via gda_client_new), and, once created, open the connections from it.
 *  GdaClient also provides a way to treat several connections as if they were only
 *  one (a connection pool), which allows applications to, for instance, commit/rollback
 *  a transaction in all the connections being managed by a unique GdaClient object, or
 *  obtain the list of all tables in all opened connections.
 */
public class Client : ObjectG
{
	
	/** the main Gtk struct */
	protected GdaClient* gdaClient;
	
	
	public GdaClient* getClientStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaClient* gdaClient);
	
	/**
	 * Establishes a connection to a data source. The connection will be opened
	 * if no identical connection is available in the GdaClient connection pool,
	 * and re-used if available. If you dont want to share the connection,
	 * specify GDA_CONNECTION_OPTIONS_DONT_SHARE as one of the flags in
	 * the options parameter.
	 * This function is the way of opening database connections with libgtkD.gda.
	 * Params:
	 *  dsn = data source name.
	 *  username = user name.
	 *  password = password for username.
	 *  options = options for the connection (see GdaConnectionOptions).
	 * Returns :
	 *  the opened connection if successful, NULL if there is
	 *  an error.
	 */
	public Connection openConnection(string dsn, string username, string password, GdaConnectionOptions options);
	
	/**
	 */
	
	/**
	 * Creates a new GdaClient object, which is the entry point for libgda
	 * client applications. This object, once created, can be used for
	 * opening new database connections and activating other services
	 * available to GDA clients.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Opens a connection given a provider ID and a connection string. This
	 * allows applications to open connections without having to create
	 * a data source in the configuration. The format of cnc_string is
	 * similar to PostgreSQL and MySQL connection strings. It is a ;-separated
	 * series of key=value pairs. Do not add extra whitespace after the ;
	 * separator. The possible keys depend on the provider, but
	 * Params:
	 * providerId =  provider ID to connect to.
	 * cncString =  connection string.
	 * options =  options for the connection (see GdaConnectionOptions).
	 * Returns: the opened connection if successful, NULL if there isan error.
	 */
	public Connection openConnectionFromString(string providerId, string cncString, GdaConnectionOptions options);
	
	/**
	 * Gets the list of all open connections in the given GdaClient object.
	 * The GList returned is an internal pointer, so DON'T TRY TO
	 * FREE IT.
	 * Returns: a GList of GdaConnection objects.
	 */
	public ListG getConnectionList();
	
	/**
	 * Looks for an open connection given a data source name (per libgda
	 * configuration), a username and a password.
	 * This function iterates over the list of open connections in the
	 * given GdaClient and looks for one that matches the given data source
	 * name, username and password.
	 * Params:
	 * dsn =  data source name.
	 * username =  user name.
	 * password =  password for username.
	 * Returns: a pointer to the found connection, or NULL if it could notbe found.
	 */
	public Connection findConnection(string dsn, string username, string password);
	
	/**
	 * Closes all connections opened by the given GdaClient object.
	 */
	public void closeAllConnections();
	
	/**
	 * Notifies an event to the given GdaClient's listeners. The event can be
	 * anything (see GdaClientEvent) ranging from a connection opening
	 * operation, to changes made to a table in an underlying database.
	 * Params:
	 * cnc =  a GdaConnection object where the event has occurred.
	 * event =  event ID.
	 * params =  parameters associated with the event.
	 */
	public void notifyEvent(Connection cnc, GdaClientEvent event, ParameterList params);
	
	/**
	 * Notifies the given GdaClient of the GDA_CLIENT_EVENT_ERROR event.
	 * Params:
	 * cnc =  a GdaConnection object.
	 * error =  the error to be notified.
	 */
	public void notifyErrorEvent(Connection cnc, ErrorGda error);
	
	/**
	 * Notifies the given GdaClient of the GDA_CLIENT_EVENT_CONNECTION_OPENED
	 * event.
	 * Params:
	 * cnc =  a GdaConnection object.
	 */
	public void notifyConnectionOpenedEvent(Connection cnc);
	
	/**
	 * Notifies the given GdaClient of the GDA_CLIENT_EVENT_CONNECTION_CLOSED
	 * event.
	 * Params:
	 * cnc =  a GdaConnection object.
	 */
	public void notifyConnectionClosedEvent(Connection cnc);
	
	/**
	 * Notifies the given GdaClient of the GDA_CLIENT_EVENT_TRANSACTION_STARTED
	 * event.
	 * Params:
	 * cnc =  a GdaConnection object.
	 * xaction =  a GdaTransaction object.
	 */
	public void notifyTransactionStartedEvent(Connection cnc, Transaction xaction);
	
	/**
	 * Notifies the given GdaClient of the GDA_CLIENT_EVENT_TRANSACTION_COMMITTED
	 * event.
	 * Params:
	 * cnc =  a GdaConnection object.
	 * xaction =  a GdaTransaction object.
	 */
	public void notifyTransactionCommittedEvent(Connection cnc, Transaction xaction);
	
	/**
	 * Notifies the given GdaClient of the GDA_CLIENT_EVENT_TRANSACTION_CANCELLED
	 * event.
	 * Params:
	 * cnc =  a GdaConnection object.
	 * xaction =  a GdaTransaction object.
	 */
	public void notifyTransactionCancelledEvent(Connection cnc, Transaction xaction);
	
	/**
	 * Starts a transaction on all connections being managed by the given
	 * GdaClient. It is important to note that this operates on all
	 * connections opened within a GdaClient, which could not be what
	 * you're looking for.
	 * To execute a transaction on a unique connection, use
	 * gda_connection_begin_transaction, gda_connection_commit_transaction
	 * and gda_connection_rollback_transaction.
	 * Params:
	 * xaction =  a GdaTransaction object.
	 * Returns: TRUE if all transactions could be started successfully,or FALSE if one of them fails.
	 */
	public int beginTransaction(Transaction xaction);
	
	/**
	 * Commits a running transaction on all connections being managed by the given
	 * GdaClient. It is important to note that this operates on all
	 * connections opened within a GdaClient, which could not be what
	 * you're looking for.
	 * To execute a transaction on a unique connection, use
	 * gda_connection_begin_transaction, gda_connection_commit_transaction
	 * and gda_connection_rollback_transaction.
	 * Params:
	 * xaction =  a GdaTransaction object.
	 * Returns: TRUE if all transactions could be committed successfully,or FALSE if one of them fails.
	 */
	public int commitTransaction(Transaction xaction);
	
	/**
	 * Cancels a running transaction on all connections being managed by the given
	 * GdaClient. It is important to note that this operates on all
	 * connections opened within a GdaClient, which could not be what
	 * you're looking for.
	 * To execute a transaction on a unique connection, use
	 * gda_connection_begin_transaction, gda_connection_commit_transaction
	 * and gda_connection_rollback_transaction.
	 * Params:
	 * xaction =  a GdaTransaction object.
	 * Returns: TRUE if all transactions could be cancelled successfully,or FALSE if one of them fails.
	 */
	public int rollbackTransaction(Transaction xaction);
}
