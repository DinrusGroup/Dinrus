module gtkD.gda.QuarkList;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;




/**
 * Description
 *  Parameter lists are used primary in the parsing and creation
 *  of connection strings.
 */
public class QuarkList
{
	
	/** the main Gtk struct */
	protected GdaQuarkList* gdaQuarkList;
	
	
	public GdaQuarkList* getQuarkListStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaQuarkList* gdaQuarkList);
	
	/**
	 */
	
	/**
	 * Returns:
	 */
	public static GType getType();
	
	/**
	 * Creates a new GdaQuarkList, which is a set of key->value pairs,
	 * very similar to GLib's GHashTable, but with the only purpose to
	 * make easier the parsing and creation of data source connection
	 * strings.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GdaQuarkList given a connection string.
	 * Params:
	 * string =  a connection string.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string string);
	
	/**
	 * Creates a new GdaQuarkList from an existing one.
	 * Returns: a newly allocated GdaQuarkList with a copy of the data in qlist.
	 */
	public QuarkList copy();
	
	/**
	 * Releases all memory occupied by the given GdaQuarkList.
	 */
	public void free();
	
	/**
	 * Adds new key->value pairs from the given string. If cleanup is
	 * set to TRUE, the previous contents will be discarded before adding
	 * the new pairs.
	 * Params:
	 * string =  a connection string.
	 * cleanup =  whether to cleanup the previous content or not.
	 */
	public void addFromString(string string, int cleanup);
	
	/**
	 * Searches for the value identified by name in the given GdaQuarkList.
	 * Params:
	 * name =  the name of the value to search for.
	 * Returns: the value associated with the given key if found, or NULLif not found.
	 */
	public string find(string name);
	
	/**
	 * Removes an entry from the GdaQuarkList, given its name.
	 * Params:
	 * name =  an entry name.
	 */
	public void remove(string name);
	
	/**
	 * Removes all strings in the given GdaQuarkList.
	 */
	public void clear();
}
