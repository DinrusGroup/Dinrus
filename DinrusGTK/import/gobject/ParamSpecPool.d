module gtkD.gobject.ParamSpecPool;

public  import gtkD.gtkc.gobjecttypes;

private import gtkD.gtkc.gobject;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.ParamSpec;
private import gtkD.glib.ListG;




/**
 * Description
 * GParamSpec is an object structure that encapsulates the metadata
 * required to specify parameters, such as e.g. GObject properties.
 * Parameter names need to start with a letter (a-z or A-Z). Subsequent
 * characters can be letters, numbers or a '-'.
 * All other characters are replaced by a '-' during construction.
 * The result of this replacement is called the canonical name of the
 * parameter.
 */
public class ParamSpecPool
{
	
	/** the main Gtk struct */
	protected GParamSpecPool* gParamSpecPool;
	
	
	public GParamSpecPool* getParamSpecPoolStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GParamSpecPool* gParamSpecPool);
	
	/**
	 */
	
	/**
	 * Creates a new GParamSpecPool.
	 * If type_prefixing is TRUE, lookups in the newly created pool will
	 * allow to specify the owner as a colon-separated prefix of the
	 * property name, like "GtkContainer:border-width". This feature is
	 * deprecated, so you should always set type_prefixing to FALSE.
	 * Params:
	 * typePrefixing =  Whether the pool will support type-prefixed property names.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int typePrefixing);
	
	/**
	 * Inserts a GParamSpec in the pool.
	 * Params:
	 * pspec =  the GParamSpec to insert
	 * ownerType =  a GType identifying the owner of pspec
	 */
	public void insert(ParamSpec pspec, GType ownerType);
	
	/**
	 * Removes a GParamSpec from the pool.
	 * Params:
	 * pspec =  the GParamSpec to remove
	 */
	public void remove(ParamSpec pspec);
	
	/**
	 * Looks up a GParamSpec in the pool.
	 * Params:
	 * paramName =  the name to look for
	 * ownerType =  the owner to look for
	 * walkAncestors =  If TRUE, also try to find a GParamSpec with param_name
	 *  owned by an ancestor of owner_type.
	 * Returns: The found GParamSpec, or NULL if no matching GParamSpec was found.
	 */
	public ParamSpec lookup(string paramName, GType ownerType, int walkAncestors);
	
	/**
	 * Gets an array of all GParamSpecs owned by owner_type in
	 * the pool.
	 * Params:
	 * ownerType =  the owner to look for
	 * Returns: a newly allocated array containing pointers to all GParamSpecs owned by owner_type in the pool
	 */
	public ParamSpec[] list(GType ownerType);
	
	/**
	 * Gets an GList of all GParamSpecs owned by owner_type in
	 * the pool.
	 * Params:
	 * ownerType =  the owner to look for
	 * Returns: a GList of all GParamSpecs owned by owner_type in the poolGParamSpecs.
	 */
	public ListG listOwned(GType ownerType);
}
