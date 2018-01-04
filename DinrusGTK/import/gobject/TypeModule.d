
module gtkD.gobject.TypeModule;

public  import gtkD.gtkc.gobjecttypes;

private import gtkD.gtkc.gobject;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.Enums;
private import gtkD.gobject.Flags;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GTypeModule provides a simple implementation of the GTypePlugin
 * interface. The model of GTypeModule is a dynamically loaded module
 * which implements some number of types and interface
 * implementations. When the module is loaded, it registers its types
 * and interfaces using g_type_module_register_type() and
 * g_type_module_add_interface(). As long as any instances of these
 * types and interface implementations are in use, the module is kept
 * loaded. When the types and interfaces are gone, the module may be
 * unloaded. If the types and interfaces become used again, the module
 * will be reloaded. Note that the last unref can not happen in module
 * code, since that would lead to the caller's code being unloaded before
 * g_object_unref() returns to it.
 * Keeping track of whether the module should be loaded or not is done by
 * using a use count - it starts at zero, and whenever it is greater than
 * zero, the module is loaded. The use count is maintained internally by
 * the type system, but also can be explicitly controlled by
 * g_type_module_use() and g_type_module_unuse(). Typically, when loading
 * a module for the first type, g_type_module_use() will be used to load
 * it so that it can initialize its types. At some later point, when the
 * module no longer needs to be loaded except for the type
 * implementations it contains, g_type_module_unuse() is called.
 * GTypeModule does not actually provide any implementation of module
 * loading and unloading. To create a particular module type you must
 * derive from GTypeModule and implement the load and unload functions
 * in GTypeModuleClass.
 */
public class TypeModule : ObjectG
{
	
	/** the main Gtk struct */
	protected GTypeModule* gTypeModule;
	
	
	public GTypeModule* getTypeModuleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GTypeModule* gTypeModule);
	
	/**
	 */
	
	/**
	 * Increases the use count of a GTypeModule by one. If the
	 * use count was zero before, the plugin will be loaded.
	 * If loading the plugin fails, the use count is reset to
	 * its prior value.
	 * Returns: FALSE if the plugin needed to be loaded and loading the plugin failed.
	 */
	public int use();
	
	/**
	 * Decreases the use count of a GTypeModule by one. If the
	 * result is zero, the module will be unloaded. (However, the
	 * GTypeModule will not be freed, and types associated with the
	 * GTypeModule are not unregistered. Once a GTypeModule is
	 * initialized, it must exist forever.)
	 */
	public void unuse();
	
	/**
	 * Sets the name for a GTypeModule
	 * Params:
	 * name =  a human-readable name to use in error messages.
	 */
	public void setName(string name);
	
	/**
	 * Looks up or registers a type that is implemented with a particular
	 * type plugin. If a type with name type_name was previously registered,
	 * the GType identifier for the type is returned, otherwise the type
	 * is newly registered, and the resulting GType identifier returned.
	 * When reregistering a type (typically because a module is unloaded
	 * then reloaded, and reinitialized), module and parent_type must
	 * be the same as they were previously.
	 * As long as any instances of the type exist, the type plugin will
	 * not be unloaded.
	 * Params:
	 * parentType =  the type for the parent class
	 * typeName =  name for the type
	 * typeInfo =  type information structure
	 * flags =  flags field providing details about the type
	 * Returns: the new or existing type ID
	 */
	public GType registerType(GType parentType, string typeName, GTypeInfo* typeInfo, GTypeFlags flags);
	
	/**
	 * Registers an additional interface for a type, whose interface lives
	 * in the given type plugin. If the interface was already registered
	 * for the type in this plugin, nothing will be done.
	 * As long as any instances of the type exist, the type plugin will
	 * not be unloaded.
	 * Params:
	 * instanceType =  type to which to add the interface.
	 * interfaceType =  interface type to add
	 * interfaceInfo =  type information structure
	 */
	public void addInterface(GType instanceType, GType interfaceType, GInterfaceInfo* interfaceInfo);
	
	/**
	 * Looks up or registers an enumeration that is implemented with a particular
	 * type plugin. If a type with name type_name was previously registered,
	 * the GType identifier for the type is returned, otherwise the type
	 * is newly registered, and the resulting GType identifier returned.
	 * As long as any instances of the type exist, the type plugin will
	 * not be unloaded.
	 * Since 2.6
	 * Params:
	 * name =  name for the type
	 * Returns: the new or existing type ID
	 */
	public GType registerEnum(string name, Enums _StaticValues);
	
	/**
	 * Looks up or registers a flags type that is implemented with a particular
	 * type plugin. If a type with name type_name was previously registered,
	 * the GType identifier for the type is returned, otherwise the type
	 * is newly registered, and the resulting GType identifier returned.
	 * As long as any instances of the type exist, the type plugin will
	 * not be unloaded.
	 * Since 2.6
	 * Params:
	 * name =  name for the type
	 * Returns: the new or existing type ID
	 */
	public GType registerFlags(string name, Flags _StaticValues);
}
