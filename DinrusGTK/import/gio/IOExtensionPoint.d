
module gtkD.gio.IOExtensionPoint;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gio.IOExtension;




/**
 * Description
 * GIOExtensionPoint provides a mechanism for modules to extend the
 * functionality of the library or application that loaded it in an
 * organized fashion.
 * An extension point is identified by a name, and it may optionally
 * require that any implementation must by of a certain type (or derived
 * thereof). Use g_io_extension_point_register() to register an
 * extension point, and g_io_extension_point_set_required_type() to
 * set a required type.
 * A module can implement an extension point by specifying the GType
 * that implements the functionality. Additionally, each implementation
 * of an extension point has a name, and a priority. Use
 * g_io_extension_point_implement() to implement an extension point.
 *  GIOExtensionPoint *ep;
 *  /+* Register an extension point +/
 *  ep = g_io_extension_point_register ("my-extension-point");
 *  g_io_extension_point_set_required_type (ep, MY_TYPE_EXAMPLE);
 *  /+* Implement an extension point +/
 *  G_DEFINE_TYPE (MyExampleImpl, my_example_impl, MY_TYPE_EXAMPLE);
 *  g_io_extension_point_implement ("my-extension-point",
 *  my_example_impl_get_type (),
 *  "my-example",
 *  10);
 *  It is up to the code that registered the extension point how
 *  it uses the implementations that have been associated with it.
 *  Depending on the use case, it may use all implementations, or
 *  only the one with the highest priority, or pick a specific
 *  one by name.
 */
public class IOExtensionPoint
{
	
	/** the main Gtk struct */
	protected GIOExtensionPoint* gIOExtensionPoint;
	
	
	public GIOExtensionPoint* getIOExtensionPointStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GIOExtensionPoint* gIOExtensionPoint);
	
	/**
	 */
	
	/**
	 * Finds a GIOExtension for an extension point by name.
	 * Params:
	 * name =  the name of the extension to get
	 * Returns: the GIOExtension for extension_point that has the given name, or NULL if there is no extension with that name
	 */
	public IOExtension getExtensionByName(string name);
	
	/**
	 * Gets a list of all extensions that implement this extension point.
	 * The list is sorted by priority, beginning with the highest priority.
	 * Returns: a GList of GIOExtensions. The list is owned by GIO and should not be modified
	 */
	public ListG getExtensions();
	
	/**
	 * Gets the required type for extension_point.
	 * Returns: the GType that all implementations must have,  or G_TYPE_INVALID if the extension point has no required type
	 */
	public GType getRequiredType();
	
	/**
	 * Registers type as extension for the extension point with name
	 * extension_point_name.
	 * If type has already been registered as an extension for this
	 * extension point, the existing GIOExtension object is returned.
	 * Params:
	 * extensionPointName =  the name of the extension point
	 * type =  the GType to register as extension
	 * extensionName =  the name for the extension
	 * priority =  the priority for the extension
	 * Returns: a GIOExtension object for GType
	 */
	public static IOExtension implement(string extensionPointName, GType type, string extensionName, int priority);
	
	/**
	 * Looks up an existing extension point.
	 * Params:
	 * name =  the name of the extension point
	 * Returns: the GIOExtensionPoint, or NULL if there is no registered extension point with the given name
	 */
	public static IOExtensionPoint lookup(string name);
	
	/**
	 * Registers an extension point.
	 * Params:
	 * name =  The name of the extension point
	 * Returns: the new GIOExtensionPoint. This object is owned by GIO and should not be freed
	 */
	public static IOExtensionPoint register(string name);
	
	/**
	 * Sets the required type for extension_point to type.
	 * All implementations must henceforth have this type.
	 * Params:
	 * type =  the GType to require
	 */
	public void setRequiredType(GType type);
}
