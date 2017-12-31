
module gtkD.gio.IOModule;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;



private import gtkD.gobject.TypeModule;

/**
 * Description
 * Provides an interface and default functions for loading and unloading
 * modules. This is used internally to make GIO extensible, but can also
 * be used by others to implement module loading.
 */
public class IOModule : TypeModule
{
	
	/** the main Gtk struct */
	protected GIOModule* gIOModule;
	
	
	public GIOModule* getIOModuleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GIOModule* gIOModule);
	
	/**
	 */
	
	/**
	 * Creates a new GIOModule that will load the specific
	 * shared library when in use.
	 * Params:
	 * filename =  filename of the shared library module.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string filename);
	
	/**
	 * Loads all the modules in the specified directory.
	 * Params:
	 * dirname =  pathname for a directory containing modules to load.
	 * Returns: a list of GIOModules loaded from the directory, All the modules are loaded into memory, if you want to unload them (enabling on-demand loading) you must call g_type_module_unuse() on all the modules. Free the list with g_list_free().
	 */
	public static ListG modulesLoadAllInDirectory(string dirname);
	
	/**
	 * Required API for GIO modules to implement.
	 * This function is ran after the module has been loaded into GIO,
	 * to initialize the module.
	 */
	public void load();
	
	/**
	 * Required API for GIO modules to implement.
	 * This function is ran when the module is being unloaded from GIO,
	 * to finalize the module.
	 */
	public void unload();
}
