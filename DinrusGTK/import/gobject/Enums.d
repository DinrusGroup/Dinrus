module gtkD.gobject.Enums;

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
public class Enums
{
	
	/** the main Gtk struct */
	protected GEnumValue* gEnumValue;
	
	
	public GEnumValue* getEnumsStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GEnumValue* gEnumValue);
	
	/**
	 */
	
	/**
	 * Returns the GEnumValue for a value.
	 * Params:
	 * enumClass =  a GEnumClass
	 * value =  the value to look up
	 * Returns: the GEnumValue for value, or NULL if value is not a member of the enumeration
	 */
	public static Enums getValue(GEnumClass* enumClass, int value);
	
	/**
	 * Looks up a GEnumValue by name.
	 * Params:
	 * enumClass =  a GEnumClass
	 * name =  the name to look up
	 * Returns: the GEnumValue with name name, or NULL if the enumeration doesn't have a member with that name
	 */
	public static Enums getValueByName(GEnumClass* enumClass, string name);
	
	/**
	 * Looks up a GEnumValue by nickname.
	 * Params:
	 * enumClass =  a GEnumClass
	 * nick =  the nickname to look up
	 * Returns: the GEnumValue with nickname nick, or NULL if the enumeration doesn't have a member with that nickname
	 */
	public static Enums getValueByNick(GEnumClass* enumClass, string nick);
	
	/**
	 * Registers a new static enumeration type with the name name.
	 * It is normally more convenient to let glib-mkenums generate a
	 * my_enum_get_type() function from a usual C enumeration definition
	 * than to write one yourself using g_enum_register_static().
	 * Params:
	 * name =  A nul-terminated string used as the name of the new type.
	 * Returns: The new type identifier.
	 */
	public static GType registerStatic(string name, Enums _StaticValues);
	
	/**
	 * This function is meant to be called from the complete_type_info()
	 * function of a GTypePlugin implementation, as in the following
	 * Params:
	 * type =  the type identifier of the type being completed
	 * info =  the GTypeInfo struct to be filled in
	 */
	public static void completeTypeInfo(GType type, out GTypeInfo info, Enums _Values);
	
}
