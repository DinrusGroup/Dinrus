module gtkD.gda.ErrorGda;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class ErrorGda : ObjectG
{
	
	/** the main Gtk struct */
	protected GdaError* gdaError;
	
	
	public GdaError* getErrorGdaStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaError* gdaError);
	
	/** */
	this (ListG glist) ;
	
	/**
	 */
	
	/**
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Frees the memory allocated by the error object.
	 */
	public void free();
	
	/**
	 * Creates a new list which contains the same errors as errors and
	 * adds a reference for each error in the list.
	 * You must free the list using gda_error_list_free.
	 * Params:
	 * errors =  a GList holding error objects.
	 * Returns: a list of errors.
	 */
	public static ListG listCopy(ListG errors);
	
	/**
	 * Frees all error objects in the list and the list itself.
	 * After this function has been called, the errors parameter doesn't point
	 * to valid storage any more.
	 * Params:
	 * errors =  a GList holding error objects.
	 */
	public static void listFree(ListG errors);
	
	/**
	 * Returns: error's description.
	 */
	public string getDescription();
	
	/**
	 * Sets error's description.
	 * Params:
	 * description =  a description.
	 */
	public void setDescription(string description);
	
	/**
	 * Returns: error's number.
	 */
	public int getNumber();
	
	/**
	 * Sets error's number.
	 * Params:
	 * number =  a number.
	 */
	public void setNumber(int number);
	
	/**
	 * Returns: error's source.
	 */
	public string getSource();
	
	/**
	 * Sets error's source.
	 * Params:
	 * source =  a source.
	 */
	public void setSource(string source);
	
	/**
	 * Returns: error's SQL state.
	 */
	public string getSqlstate();
	
	/**
	 * Sets error's SQL state.
	 * Params:
	 * sqlstate =  SQL state.
	 */
	public void setSqlstate(string sqlstate);
}
