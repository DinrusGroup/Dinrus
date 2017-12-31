
module gtkD.gda.Transaction;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class Transaction : ObjectG
{
	
	/** the main Gtk struct */
	protected GdaTransaction* gdaTransaction;
	
	
	public GdaTransaction* getTransactionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaTransaction* gdaTransaction);
	
	/**
	 */
	
	/**
	 * Creates a new GdaTransaction object, which allows a fine-tune and
	 * full control of transactions to be used with providers.
	 * Params:
	 * name =  name for the transaction.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name);
	
	/**
	 * Gets the isolation level for the given transaction. This specifies
	 * the locking behavior for the database connection during the given
	 * transaction.
	 * Returns: the isolation level.
	 */
	public GdaTransactionIsolation getIsolationLevel();
	
	/**
	 * Sets the isolation level for the given transaction.
	 * Params:
	 * level =  the isolation level.
	 */
	public void setIsolationLevel(GdaTransactionIsolation level);
	
	/**
	 * Retrieves the name of the given transaction, as specified by the
	 * client application (via a non-NULL parameter in the call to
	 * gda_transaction_new, or by calling gda_transaction_set_name).
	 * Note that some providers may set, when you call
	 * gda_connection_begin_transaction, the name of the transaction if
	 * it's not been specified by the client application, so this function
	 * may return, for some providers, values that you don't expect.
	 * Returns: the name of the transaction.
	 */
	public string getName();
	
	/**
	 * Sets the name of the given transaction. This is very useful when
	 * using providers that support named transactions.
	 * Params:
	 * name =  new name for the transaction.
	 */
	public void setName(string name);
}
