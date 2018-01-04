module gtkD.gstreamer.Registry;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gstreamer.Plugin;
private import gtkD.gstreamer.PluginFeature;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * One registry holds the metadata of a set of plugins.
 * All registries build the GstRegistryPool.
 * Design:
 * The GstRegistry object is a list of plugins and some functions for dealing
 * with them. GstPlugins are matched 1-1 with a file on disk, and may or may
 * not be loaded at a given time. There may be multiple GstRegistry objects,
 * but the "default registry" is the only object that has any meaning to the
 * core.
 * The registry.xml file is actually a cache of plugin information. This is
 * unlike versions prior to 0.10, where the registry file was the primary source
 * of plugin information, and was created by the gst-register command.
 * The primary source, at all times, of plugin information is each plugin file
 * itself. Thus, if an application wants information about a particular plugin,
 * or wants to search for a feature that satisfies given criteria, the primary
 * means of doing so is to load every plugin and look at the resulting
 * information that is gathered in the default registry. Clearly, this is a time
 * consuming process, so we cache information in the registry.xml file.
 * On startup, plugins are searched for in the plugin search path. This path can
 * be set directly using the GST_PLUGIN_PATH environment variable. The registry
 * file is loaded from ~/.gstreamer-$GST_MAJORMINOR/registry-$ARCH.xml or the
 * file listed in the GST_REGISTRY env var. The only reason to change the
 * registry location is for testing.
 * For each plugin that is found in the plugin search path, there could be 3
 * possibilities for cached information:
 * the cache may not contain information about a given file.
 * the cache may have stale information.
 * the cache may have current information.
 * In the first two cases, the plugin is loaded and the cache updated. In
 * addition to these cases, the cache may have entries for plugins that are not
 * relevant to the current process. These are marked as not available to the
 * current process. If the cache is updated for whatever reason, it is marked
 * dirty.
 * A dirty cache is written out at the end of initialization. Each entry is
 * checked to make sure the information is minimally valid. If not, the entry is
 * simply dropped.
 * Implementation notes:
 * The "cache" and "default registry" are different concepts and can represent
 * different sets of plugins. For various reasons, at init time, the cache is
 * stored in the default registry, and plugins not relevant to the current
 * process are marked with the GST_PLUGIN_FLAG_CACHED bit. These plugins are
 * removed at the end of intitialization.
 */
public class Registry : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstRegistry* gstRegistry;
	
	
	public GstRegistry* getRegistryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstRegistry* gstRegistry);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(gpointer, Registry)[] onFeatureAddedListeners;
	/**
	 * Signals that a feature has been added to the registry (possibly
	 * replacing a previously-added one by the same name)
	 */
	void addOnFeatureAdded(void delegate(gpointer, Registry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackFeatureAdded(GstRegistry* registryStruct, gpointer feature, Registry registry);
	
	void delegate(gpointer, Registry)[] onPluginAddedListeners;
	/**
	 * Signals that a plugin has been added to the registry (possibly
	 * replacing a previously-added one by the same name)
	 * See Also
	 * GstPlugin, GstPluginFeature
	 */
	void addOnPluginAdded(void delegate(gpointer, Registry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPluginAdded(GstRegistry* registryStruct, gpointer plugin, Registry registry);
	
	
	/**
	 * Retrieves the default registry. The caller does not own a reference on the
	 * registry, as it is alive as long as GStreamer is initialized.
	 * Returns: The default GstRegistry.
	 */
	public static Registry getDefault();
	
	/**
	 * Retrieves a GList of GstPluginFeature of type.
	 * Params:
	 * type =  a GType.
	 * Returns: a GList of GstPluginFeature of type. gst_plugin_feature_list_freeafter usage.MT safe.
	 */
	public ListG getFeatureList(GType type);
	
	/**
	 * Retrieves a GList of features of the plugin with name name.
	 * Params:
	 * name =  a plugin name.
	 * Returns: a GList of GstPluginFeature. gst_plugin_feature_list_free() after usage.
	 */
	public ListG getFeatureListByPlugin(string name);
	
	/**
	 * Get the list of paths for the given registry.
	 * Returns: A Glist of paths as strings. g_list_free after use.MT safe.
	 */
	public ListG getPathList();
	
	/**
	 * Get a copy of all plugins registered in the given registry. The refcount
	 * of each element in the list in incremented.
	 * Returns: a GList of GstPlugin. gst_plugin_list_free after use.MT safe.
	 */
	public ListG getPluginList();
	
	/**
	 * Add the plugin to the registry. The plugin-added signal will be emitted.
	 * This function will sink plugin.
	 * Params:
	 * plugin =  the plugin to add
	 * Returns: TRUE on success.MT safe.
	 */
	public int addPlugin(Plugin plugin);
	
	/**
	 * Remove the plugin from the registry.
	 * MT safe.
	 * Params:
	 * plugin =  the plugin to remove
	 */
	public void removePlugin(Plugin plugin);
	
	/**
	 * Runs a filter against all plugins in the registry and returns a GList with
	 * the results. If the first flag is set, only the first match is
	 * returned (as a list with a single object).
	 * Every plugin is reffed; use gst_plugin_list_free() after use, which
	 * will unref again.
	 * Params:
	 * filter =  the filter to use
	 * first =  only return first match
	 * userData =  user data passed to the filter function
	 * Returns: a GList of GstPlugin. Use gst_plugin_list_free() after usage.MT safe.
	 */
	public ListG pluginFilter(GstPluginFilter filter, int first, void* userData);
	
	/**
	 * Runs a filter against all features of the plugins in the registry
	 * and returns a GList with the results.
	 * If the first flag is set, only the first match is
	 * returned (as a list with a single object).
	 * Params:
	 * filter =  the filter to use
	 * first =  only return first match
	 * userData =  user data passed to the filter function
	 * Returns: a GList of plugin features, gst_plugin_feature_list_free after use.MT safe.
	 */
	public ListG featureFilter(GstPluginFeatureFilter filter, int first, void* userData);
	
	/**
	 * Find the plugin with the given name in the registry.
	 * The plugin will be reffed; caller is responsible for unreffing.
	 * Params:
	 * name =  the plugin name to find
	 * Returns: The plugin with the given name or NULL if the plugin was not found.gst_object_unref() after usage.MT safe.
	 */
	public Plugin findPlugin(string name);
	
	/**
	 * Find the pluginfeature with the given name and type in the registry.
	 * Params:
	 * name =  the pluginfeature name to find
	 * type =  the pluginfeature type to find
	 * Returns: The pluginfeature with the given name and type or NULLif the plugin was not found. gst_object_unref() after usage.MT safe.
	 */
	public PluginFeature findFeature(string name, GType type);
	
	/**
	 * Find a GstPluginFeature with name in registry.
	 * Params:
	 * name =  a GstPluginFeature name
	 * Returns: a GstPluginFeature with its refcount incremented, usegst_object_unref() after usage.MT safe.
	 */
	public PluginFeature lookupFeature(string name);
	
	/**
	 * Add the given path to the registry. The syntax of the
	 * path is specific to the registry. If the path has already been
	 * added, do nothing.
	 * Params:
	 * path =  the path to add to the registry
	 * Returns: TRUE if registry changed
	 */
	public int scanPath(string path);
	
	/**
	 * Read the contents of the binary cache file at location into registry.
	 * Params:
	 * location =  a filename
	 * Returns: TRUE on success.
	 */
	public int binaryReadCache(string location);
	
	/**
	 * Write the cache to file. Part of the code was taken from gstregistryxml.c
	 * Params:
	 * Returns:
	 */
	public int binaryWriteCache(string location);
	
	/**
	 * Read the contents of the XML cache file at location into registry.
	 * Params:
	 * location =  a filename
	 * Returns: TRUE on success.
	 */
	public int xmlReadCache(string location);
	
	/**
	 * Write registry in an XML format at the location given by
	 * location. Directories are automatically created.
	 * Params:
	 * location =  a filename
	 * Returns: TRUE on success.
	 */
	public int xmlWriteCache(string location);
	
	/**
	 * Look up a plugin in the given registry with the given filename.
	 * If found, plugin is reffed.
	 * Params:
	 * filename =  the name of the file to look up
	 * Returns: the GstPlugin if found, or NULL if not. gst_object_unref()after usage.
	 */
	public Plugin lookup(string filename);
	
	/**
	 * Remove the feature from the registry.
	 * MT safe.
	 * Params:
	 * feature =  the feature to remove
	 */
	public void removeFeature(PluginFeature feature);
	
	/**
	 * Add the feature to the registry. The feature-added signal will be emitted.
	 * This function sinks feature.
	 * Params:
	 * feature =  the feature to add
	 * Returns: TRUE on success.MT safe.
	 */
	public int addFeature(PluginFeature feature);
	
	/**
	 * Checks whether a plugin feature by the given name exists in the
	 * default registry and whether its version is at least the
	 * version required.
	 * Params:
	 * featureName =  the name of the feature (e.g. "oggdemux")
	 * minMajor =  the minimum major version number
	 * minMinor =  the minimum minor version number
	 * minMicro =  the minimum micro version number
	 * Returns: TRUE if the feature could be found and the version isthe same as the required version or newer, and FALSE otherwise.
	 */
	public static int defaultRegistryCheckFeatureVersion(string featureName, uint minMajor, uint minMinor, uint minMicro);
}
