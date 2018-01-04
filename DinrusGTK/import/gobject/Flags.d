module gtkD.gobject.Flags;

public  import gtkD.gtkc.gobjecttypes;

private import gtkD.gtkc.gobject;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * glib-mkenums
 * title: Enumeration and Flag Types
 * The GLib type system provides fundamental types for enumeration and
 * flags types. (Flags types are like enumerations, but allow their
 * values to be combined by bitwise or). A registered enumeration or
 * flags type associates a name and a nickname with each allowed
 * value, and the methods g_enum_get_value_by_name(),
 * g_enum_get_value_by_nick(), g_flags_get_value_by_name() and
 * g_flags_get_value_by_nick() can look up values by their name or
 * nickname. When an enumeration or flags type is registered with the
 * GLib type system, it can be used as value type for object
 * properties, using g_param_spec_enum() or g_param_spec_flags().
 * GObject ships with a utility called glib-mkenums that can construct
 * suitable type registration functions from C enumeration
 * definitions.
 */
public class Flags
{
	
	/** the main Gtk struct */
	protected GFlagsValue* gFlagsValue;
	
	
	public GFlagsValue* getFlagsStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFlagsValue* gFlagsValue);
	
	/**
	 */
	
	/**
	 * Returns the first GFlagsValue which is set in value.
	 * Params:
	 * flagsClass =  a GFlagsClass
	 * value =  the value
	 * Returns: the first GFlagsValue which is set in value, or NULL if none is set
	 */
	public static Flags getFirstValue(GFlagsClass* flagsClass, uint value);
	
	/**
	 * Looks up a GFlagsValue by name.
	 * Params:
	 * flagsClass =  a GFlagsClass
	 * name =  the name to look up
	 * Returns: the GFlagsValue with name name, or NULL if there is no flag with that name
	 */
	public static Flags getValueByName(GFlagsClass* flagsClass, string name);
	
	/**
	 * Looks up a GFlagsValue by nickname.
	 * Params:
	 * flagsClass =  a GFlagsClass
	 * nick =  the nickname to look up
	 * Returns: the GFlagsValue with nickname nick, or NULL if there is no flag with that nickname
	 */
	public static Flags getValueByNick(GFlagsClass* flagsClass, string nick);
	
	/**
	 * Registers a new static flags type with the name name.
	 * It is normally more convenient to let glib-mkenums generate a
	 * my_flags_get_type() function from a usual C enumeration definition
	 * than to write one yourself using g_flags_register_static().
	 * Params:
	 * name =  A nul-terminated string used as the name of the new type.
	 * Returns: The new type identifier.
	 */
	public static GType registerStatic(string name, Flags _StaticValues);
	
	/**
	 * This function is meant to be called from the complete_type_info()
	 * function of a GTypePlugin implementation, see the example for
	 * g_enum_complete_type_info() above.
	 * Params:
	 * type =  the type identifier of the type being completed
	 * info =  the GTypeInfo struct to be filled in
	 */
	public static void completeTypeInfo(GType type, GTypeInfo* info, Flags _Values);
}
