module gtkD.gio.IOExtension;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




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
public class IOExtension
{
	
	/** the main Gtk struct */
	protected GIOExtension* gIOExtension;
	
	
	public GIOExtension* getIOExtensionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GIOExtension* gIOExtension);
	
	/**
	 */
	
	/**
	 * Gets the name under which extension was registered.
	 * Note that the same type may be registered as extension
	 * for multiple extension points, under different names.
	 * Returns: the name of extension.
	 */
	public string getName();
	
	/**
	 * Gets the priority with which extension was registered.
	 * Returns: the priority of extension
	 */
	public int getPriority();
	
	/**
	 * Gets the type associated with extension.
	 * Returns: the type of extension
	 */
	public GType getType();
	
	/**
	 * Gets a reference to the class for the type that is
	 * associated with extension.
	 * Returns: the GTypeClass for the type of extension
	 */
	public GTypeClass* refClass();
}
