module gtkD.gstreamer.PluginFeature;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * This is a base class for anything that can be added to a GstPlugin.
 */
public class PluginFeature : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstPluginFeature* gstPluginFeature;
	
	
	public GstPluginFeature* getPluginFeatureStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstPluginFeature* gstPluginFeature);
	
	/**
	 * Sets the name of a plugin feature. The name uniquely identifies a feature
	 * within all features of the same type. Renaming a plugin feature is not
	 * allowed. A copy is made of the name so you should free the supplied name
	 * after calling this function.
	 * Params:
	 *  name = the name to set
	 */
	public void setFeatureName(string name);
	
	/**
	 */
	
	/**
	 * Compares type and name of plugin feature. Can be used with gst_filter_run().
	 * Params:
	 * data =  the type and name to check against
	 * Returns: TRUE if equal.
	 */
	public int typeNameFilter(GstTypeNameData* data);
	
	/**
	 * Specifies a rank for a plugin feature, so that autoplugging uses
	 * the most appropriate feature.
	 * Params:
	 * rank =  rank value - higher number means more priority rank
	 */
	public void setRank(uint rank);
	
	/**
	 * Gets the rank of a plugin feature.
	 * Returns: The rank of the feature
	 */
	public uint getRank();
	
	/**
	 * Gets the name of a plugin feature.
	 * Returns: the name
	 */
	public string getName();
	
	/**
	 * Loads the plugin containing feature if it's not already loaded. feature is
	 * unaffected; use the return value instead.
	 * Returns: A reference to the loaded feature, or NULL on error.
	 */
	public PluginFeature load();
	
	/**
	 * Unrefs each member of list, then frees the list.
	 * Params:
	 * list =  list of GstPluginFeature
	 */
	public static void listFree(ListG list);
	
	/**
	 * Checks whether the given plugin feature is at least
	 *  the required version
	 * Params:
	 * minMajor =  minimum required major version
	 * minMinor =  minimum required minor version
	 * minMicro =  minimum required micro version
	 * Returns: TRUE if the plugin feature has at least the required version, otherwise FALSE.
	 */
	public int checkVersion(uint minMajor, uint minMinor, uint minMicro);
}
