module gtkD.pango.PgEngine;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.TypeModule;
private import gtkD.pango.PgEngine;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Pango utilizes a module architecture in which the language-specific
 * and render-system-specific components are provided by loadable
 * modules. Each loadable module supplies one or more
 * engines. Each engine
 * has an associated engine type and
 * render type. These two types are represented by
 * strings.
 * Each dynamically-loaded module exports several functions which provide
 * the public API. These functions are script_engine_list(),
 * script_engine_init() and script_engine_exit, and
 * script_engine_create(). The latter three functions are used when
 * creating engines from the module at run time, while the first
 * function is used when building a catalog of all available modules.
 */
public class PgEngine : ObjectG
{
	
	/** the main Gtk struct */
	protected PangoEngine* pangoEngine;
	
	
	public PangoEngine* getPgEngineStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoEngine* pangoEngine);
	
	/**
	 */
	
	/**
	 * Function to be provided by a module to list the engines that the
	 * module supplies. The function stores a pointer to an array
	 * of PangoEngineInfo structures and the length of that array in
	 * the given location.
	 * Note that script_engine_init() will not be called before this
	 * function.
	 * Params:
	 * engines =  location to store a pointer to an array of engines.
	 */
	public static void list(out PangoEngineInfo[] engines);
	
	/**
	 * Function to be provided by a module to register any
	 * GObject types in the module.
	 */
	public static void init(TypeModule modul);
	
	/**
	 * Function to be provided by the module that is called
	 * when the module is unloading. Frequently does nothing.
	 */
	public static void exit();
	
	/**
	 * Function to be provided by the module to create an instance
	 * of one of the engines implemented by the module.
	 * Params:
	 * id =  the ID of an engine as reported by script_engine_list.
	 * Returns: a newly created PangoEngine of the specified type, or NULL if an error occurred. (In normal operation, a module should not return NULL. A NULL return is only acceptable in the case where system misconfiguration or bugs in the driver routine are encountered.)
	 */
	public static PgEngine create(string id);
}
