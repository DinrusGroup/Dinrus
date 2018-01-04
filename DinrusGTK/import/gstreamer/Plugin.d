module gtkD.gstreamer.Plugin;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.Module;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.ListG;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * GStreamer is extensible, so GstElement instances can be loaded at runtime.
 * A plugin system can provide one or more of the basic
 * GStreamer GstPluginFeature subclasses.
 * A plugin should export a symbol plugin_desc that is a
 * struct of type GstPluginDesc.
 * the plugin loader will check the version of the core library the plugin was
 * linked against and will create a new GstPlugin. It will then call the
 * GstPluginInitFunc function that was provided in the plugin_desc.
 * Once you have a handle to a GstPlugin (e.g. from the GstRegistryPool), you
 * can add any object that subclasses GstPluginFeature.
 * Use gst_plugin_find_feature() and gst_plugin_get_feature_list() to find
 * features in a plugin.
 * Usually plugins are always automaticlly loaded so you don't need to call
 * gst_plugin_load() explicitly to bring it into memory. There are options to
 * statically link plugins to an app or even use GStreamer without a plugin
 * repository in which case gst_plugin_load() can be needed to bring the plugin
 * into memory.
 */
public class Plugin : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstPlugin* gstPlugin;
	
	
	public GstPlugin* getPluginStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstPlugin* gstPlugin);
	
	/**
	 */
	
	/**
	 * Get the error quark.
	 * Returns: The error quark used in GError messages
	 */
	public static GQuark errorQuark();
	
	/**
	 * Get the short name of the plugin
	 * Returns: the name of the plugin
	 */
	public string getName();
	
	/**
	 * Get the long descriptive name of the plugin
	 * Returns: the long name of the plugin
	 */
	public string getDescription();
	
	/**
	 * get the filename of the plugin
	 * Returns: the filename of the plugin
	 */
	public string getFilename();
	
	/**
	 * get the license of the plugin
	 * Returns: the license of the plugin
	 */
	public string getLicense();
	
	/**
	 * get the package the plugin belongs to.
	 * Returns: the package of the plugin
	 */
	public string getPackage();
	
	/**
	 * get the URL where the plugin comes from
	 * Returns: the origin of the plugin
	 */
	public string getOrigin();
	
	/**
	 * get the source module the plugin belongs to.
	 * Returns: the source of the plugin
	 */
	public string getSource();
	
	/**
	 * get the version of the plugin
	 * Returns: the version of the plugin
	 */
	public string getVersion();
	
	/**
	 * Gets the GModule of the plugin. If the plugin isn't loaded yet, NULL is
	 * returned.
	 * Returns: module belonging to the plugin or NULL if the plugin isn't loaded yet.
	 */
	public Module getModule();
	
	/**
	 * queries if the plugin is loaded into memory
	 * Returns: TRUE is loaded, FALSE otherwise
	 */
	public int isLoaded();
	
	/**
	 * A standard filter that returns TRUE when the plugin is of the
	 * given name.
	 * Params:
	 * name =  the name of the plugin
	 * Returns: TRUE if the plugin is of the given name.
	 */
	public int nameFilter(string name);
	
	/**
	 * Loads the given plugin and refs it. Caller needs to unref after use.
	 * Params:
	 * filename =  the plugin filename to load
	 * Returns: a reference to the existing loaded GstPlugin, a reference to thenewly-loaded GstPlugin, or NULL if an error occurred.
	 * Throws: GException on failure.
	 */
	public static Plugin loadFile(string filename);
	
	/**
	 * Loads plugin. Note that the *return value* is the loaded plugin; plugin is
	 * Returns: A reference to a loaded plugin, or NULL on error.
	 */
	public Plugin load();
	
	/**
	 * Load the named plugin. Refs the plugin.
	 * Params:
	 * name =  name of plugin to load
	 * Returns: A reference to a loaded plugin, or NULL on error.
	 */
	public static Plugin loadByName(string name);
	
	/**
	 * Unrefs each member of list, then frees the list.
	 * Params:
	 * list =  list of GstPlugin
	 */
	public static void listFree(ListG list);
}
