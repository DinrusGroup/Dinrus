module gtkD.gstreamer.IndexFactory;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Index;



private import gtkD.gstreamer.PluginFeature;

/**
 * Description
 * GstIndexFactory is used to dynamically create GstIndex implementations.
 */
public class IndexFactory : PluginFeature
{
	
	/** the main Gtk struct */
	protected GstIndexFactory* gstIndexFactory;
	
	
	public GstIndexFactory* getIndexFactoryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstIndexFactory* gstIndexFactory);
	
	/**
	 */
	
	/**
	 * Create a new indexfactory with the given parameters
	 * Params:
	 * name =  name of indexfactory to create
	 * longdesc =  long description of indexfactory to create
	 * type =  the GType of the GstIndex element of this factory
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string longdesc, GType type);
	
	/**
	 * Removes the index from the global list.
	 */
	public void destroy();
	
	/**
	 * Search for an indexfactory of the given name.
	 * Params:
	 * name =  name of indexfactory to find
	 * Returns: GstIndexFactory if found, NULL otherwise
	 */
	public static IndexFactory find(string name);
	
	/**
	 * Create a new GstIndex instance from the
	 * given indexfactory.
	 * Returns: A new GstIndex instance.
	 */
	public Index create();
	
	/**
	 * Create a new GstIndex instance from the
	 * indexfactory with the given name.
	 * Params:
	 * name =  the name of the factory used to create the instance
	 * Returns: A new GstIndex instance.
	 */
	public static Index make(string name);
}
