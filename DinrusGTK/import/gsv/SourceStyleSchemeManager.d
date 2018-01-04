module gtkD.gsv.SourceStyleSchemeManager;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;


private import gtkD.gsv.SourceStyleScheme;
private import gtkD.gsv.SourceStyleSchemeManager;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class SourceStyleSchemeManager : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkSourceStyleSchemeManager* gtkSourceStyleSchemeManager;
	
	
	public GtkSourceStyleSchemeManager* getSourceStyleSchemeManagerStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSourceStyleSchemeManager* gtkSourceStyleSchemeManager);
	
	/**
	 */
	
	/**
	 * Creates a new style manager. If you do not need more than one style
	 * manager then use gtk_source_style_scheme_manager_get_default() instead.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Returns the default GtkSourceStyleSchemeManager instance.
	 * Returns: a GtkSourceStyleSchemeManager. Return value is ownedby GtkSourceView library and must not be unref'ed.
	 */
	public static SourceStyleSchemeManager getDefault();
	
	/**
	 * Sets the list of directories where the manager looks for
	 * style scheme files.
	 * If dirs is NULL, the search path is reset to default.
	 * Params:
	 * path =  a NULL-terminated array of strings or NULL.
	 */
	public void setSearchPath(string[] path);
	
	/**
	 * Appends path to the list of directories where the manager looks for
	 * style scheme files.
	 * See gtk_source_style_scheme_manager_set_search_path() for details.
	 * Params:
	 * path =  a directory or a filename.
	 */
	public void appendSearchPath(string path);
	
	/**
	 * Prepends path to the list of directories where the manager looks
	 * for style scheme files.
	 * See gtk_source_style_scheme_manager_set_search_path() for details.
	 * Params:
	 * path =  a directory or a filename.
	 */
	public void prependSearchPath(string path);
	
	/**
	 * Returns the current search path for the manager.
	 * See gtk_source_style_scheme_manager_set_search_path() for details.
	 * Returns: a NULL-terminated array of string containing the search path.The array is owned by the manager and must not be modified.
	 */
	public string[] getSearchPath();
	
	/**
	 * Returns the ids of the available style schemes.
	 * Returns: a NULL-terminated array of string containing the ids of theavailable style schemes or NULL if no style scheme is available. The arrayis owned by the manager and must not be modified.
	 */
	public string[] getSchemeIds();
	
	/**
	 * Looks up style scheme by id.
	 * Params:
	 * schemeId =  style scheme id to find
	 * Returns: a GtkSourceStyleScheme object. Returned value is owned bymanager and must not be unref'ed.
	 */
	public SourceStyleScheme getScheme(string schemeId);
	
	/**
	 * Mark any currently cached information about the available style scehems
	 * as invalid. All the available style schemes will be reloaded next time
	 * the manager is accessed.
	 */
	public void forceRescan();
}
