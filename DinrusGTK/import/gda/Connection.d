module gtkD.gda.Connection;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gda.Blob;
private import gtkD.gda.Client;
private import gtkD.gda.Command;
private import gtkD.gda.DataModel;
private import gtkD.gda.ErrorGda;
private import gtkD.gda.FieldAttributes;
private import gtkD.gda.ParameterList;
private import gtkD.gda.Transaction;



private import gtkD.gobject.ObjectG;

/**
 * Description
 *  The GdaConnection class offers access to all operations involving an
 *  opened connection to a database. GdaConnection objects are obtained
 *  via the GdaClient class.
 *  Once obtained, applications can use GdaConnection to execute commands,
 *  run transactions, and get information about all objects stored in the
 *  underlying database.
 */
public class Connection : ObjectG
{
	
	/** the main Gtk struct */
	protected GdaConnection* gdaConnection;
	
	
	public GdaConnection* getConnectionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaConnection* gdaConnection);
	
	/**
	 */
	
	/**
	 * This function creates a new GdaConnection object. It is not
	 * intended to be used directly by applications (use
	 * gda_client_open_connection instead).
	 * Params:
	 * client =  a GdaClient object.
	 * provider =  a GdaServerProvider object.
	 * dsn =  GDA data source to connect to.
	 * username =  user name to use to connect.
	 * password =  password for username.
	 * options =  options for the connection.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Client client, GdaServerProvider* provider, string dsn, string username, string password, GdaConnectionOptions options);
	
	/**
	 * Closes the connection to the underlying data source. After calling this
	 * function, you should not use anymore the GdaConnection object, since
	 * it may have been destroyed.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int close();
	
	/**
	 * Checks whether a connection is open or not.
	 * Returns: TRUE if the connection is open, FALSE if it's not.
	 */
	public int isOpen();
	
	/**
	 * Gets the GdaClient object associated with a connection. This
	 * is always the client that created the connection, as returned
	 * by gda_client_open_connection.
	 * Returns: the client to which the connection belongs to.
	 */
	public Client getClient();
	
	/**
	 * Associates a GdaClient with this connection. This function is
	 * not intended to be called by applications.
	 * Params:
	 * client =  a GdaClient object.
	 */
	public void setClient(Client client);
	
	/**
	 * Gets the GdaConnectionOptions used to open this connection.
	 * Returns: the connection options.
	 */
	public GdaConnectionOptions getOptions();
	
	/**
	 * Gets the version string of the underlying database server.
	 * Returns: the server version string.
	 */
	public string getServerVersion();
	
	/**
	 * Gets the name of the currently active database in the given
	 * GdaConnection.
	 * Returns: the name of the current database.
	 */
	public string getDatabase();
	
	/**
	 * Returns:the data source name the connection object is connectedto.
	 */
	public string getDsn();
	
	/**
	 * Gets the connection string used to open this connection.
	 * The connection string is the string sent over to the underlying
	 * database provider, which describes the parameters to be used
	 * to open a connection on the underlying data source.
	 * Returns: the connection string used when opening the connection.
	 */
	public string getCncString();
	
	/**
	 * Gets the provider id that this connection is connected to.
	 * Returns: the provider ID used to open this connection.
	 */
	public string getProvider();
	
	/**
	 * Gets the user name used to open this connection.
	 * Returns: the user name.
	 */
	public string getUsername();
	
	/**
	 * Gets the password used to open this connection.
	 * Returns: the password.
	 */
	public string getPassword();
	
	/**
	 * Adds an error to the given connection. This function is usually
	 * called by providers, to inform clients of errors that happened
	 * during some operation.
	 * As soon as a provider (or a client, it does not matter) calls this
	 * function, the connection object (and the associated GdaClient object)
	 * emits the "error" signal, to which clients can connect to be
	 * informed of errors.
	 * Params:
	 * error =  is stored internally, so you don't need to unref it.
	 */
	public void addError(ErrorGda error);

	/**
	 * This is just another convenience function which lets you add
	 * a list of GdaError's to the given connection. As with
	 * gda_connection_add_error and gda_connection_add_error_string,
	 * this function makes the connection object emit the "error"
	 * signal. The only difference is that, instead of a notification
	 * for each error, this function only does one notification for
	 * the whole list of errors.
	 * error_list is copied to an internal list and freed.
	 * Params:
	 * errorList =  a list of GdaError.
	 */
	public void addErrorList(ListG errorList);
	
	/**
	 * Changes the current database for the given connection. This operation
	 * is not available in all providers.
	 * Params:
	 * name =  name of database to switch to.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int changeDatabase(string name);
	
	/**
	 * Creates a new database named name on the given connection.
	 * Params:
	 * name =  database name.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int createDatabase(string name);
	
	/**
	 * Drops a database from the given connection.
	 * Params:
	 * name =  database name.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int dropDatabase(string name);
	
	/**
	 * Creates a table on the given connection from the specified set of fields.
	 * Params:
	 * tableName =  name of the table to be created.
	 * attributes =  description of all fields for the new table.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int createTable(string tableName, GdaFieldAttributes*[] attributes);
	
	/**
	 * Drops a table from the database.
	 * Params:
	 * tableName =  name of the table to be removed
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int dropTable(string tableName);
	
	/**
	 * Executes a command on the underlying data source.
	 * This function provides the way to send several commands
	 * at once to the data source being accessed by the given
	 * GdaConnection object. The GdaCommand specified can contain
	 * a list of commands in its "text" property (usually a set
	 * of SQL commands separated by ';').
	 * The return value is a GList of GdaDataModel's, which you
	 * are responsible to free when not needed anymore.
	 * Params:
	 * cmd =  a GdaCommand.
	 * params =  parameter list.
	 * Returns: a list of GdaDataModel's, as returned by the underlyingprovider.
	 */
	public ListG executeCommand(Command cmd, ParameterList params);
	
	/**
	 * Retrieve from the given GdaConnection the ID of the last inserted row.
	 * A connection must be specified, and, optionally, a result set. If not NULL,
	 * the underlying provider should try to get the last insert ID for the given result set.
	 * Params:
	 * recset =  recordset.
	 * Returns: a string representing the ID of the last inserted row, or NULLif an error occurred or no row has been inserted. It is the caller'sreponsibility to free the returned string.
	 */
	public string getLastInsertId(DataModel recset);
	
	/**
	 * Executes a single command on the given connection.
	 * This function lets you retrieve a simple data model from
	 * the underlying difference, instead of having to retrieve
	 * a list of them, as is the case with gda_connection_execute_command.
	 * Params:
	 * cmd =  a GdaCommand.
	 * params =  parameter list.
	 * Returns: a GdaDataModel containing the data returned by thedata source, or NULL on error.
	 */
	public DataModel executeSingleCommand(Command cmd, ParameterList params);
	
	/**
	 * Executes a single command on the underlying database, and gets the
	 * number of rows affected.
	 * Params:
	 * cmd =  a GdaCommand.
	 * params =  parameter list.
	 * Returns: the number of affected rows by the executed command,or -1 on error.
	 */
	public int executeNonQuery(Command cmd, ParameterList params);
	
	/**
	 * Starts a transaction on the data source, identified by the
	 * xaction parameter.
	 * Before starting a transaction, you can check whether the underlying
	 * provider does support transactions or not by using the
	 * gda_connection_supports function.
	 * Params:
	 * xaction =  a GdaTransaction object.
	 * Returns: TRUE if the transaction was started successfully, FALSEotherwise.
	 */
	public int beginTransaction(Transaction xaction);
	
	/**
	 * Commits the given transaction to the backend database. You need to do
	 * gda_connection_begin_transaction() first.
	 * Params:
	 * xaction =  a GdaTransaction object.
	 * Returns: TRUE if the transaction was finished successfully,FALSE otherwise.
	 */
	public int commitTransaction(Transaction xaction);
	
	/**
	 * Rollbacks the given transaction. This means that all changes
	 * made to the underlying data source since the last call to
	 * gda_connection_begin_transaction or gda_connection_commit_transaction
	 * will be discarded.
	 * Params:
	 * xaction =  a GdaTransaction object.
	 * Returns: TRUE if the operation was successful, FALSE otherwise.
	 */
	public int rollbackTransaction(Transaction xaction);
	
	/**
	 * Creates a BLOB (Binary Large OBject) with read/write access.
	 * Params:
	 * blob =  a user-allocated GdaBlob structure.
	 * Returns: FALSE if the database does not support BLOBs. TRUE otherwiseand the GdaBlob is created and ready to be used.
	 */
	public int createBlob(Blob blob);
	
	/**
	 * Retrieves a list of the last errors ocurred in the connection.
	 * You can make a copy of the list using gda_error_list_copy.
	 * Returns: a GList of GdaError.
	 */
	public ListG getErrors();
	
	/**
	 * Asks the underlying provider for if a specific feature is supported.
	 * Params:
	 * feature =  feature to ask for.
	 * Returns: TRUE if the provider supports it, FALSE if not.
	 */
	public int supports(GdaConnectionFeature feature);
	
	/**
	 * Asks the underlying data source for a list of database objects.
	 * This is the function that lets applications ask the different
	 * providers about all their database objects (tables, views, procedures,
	 * etc). The set of database objects that are retrieved are given by the
	 * 2 parameters of this function: schema, which specifies the specific
	 * schema required, and params, which is a list of parameters that can
	 * be used to give more detail about the objects to be returned.
	 * The list of parameters is specific to each schema type.
	 * Params:
	 * schema =  database schema to get.
	 * params =  parameter list.
	 * Returns: a GdaDataModel containing the data required. The caller is responsibleof freeing the returned model.
	 */
	public DataModel getSchema(GdaConnectionSchema schema, ParameterList params);
}
