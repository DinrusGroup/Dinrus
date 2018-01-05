module gtkD.gtk.Types;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * The GTK+ type system is extensible. Because of that, types have to be
 * managed at runtime.
 */
public class Types
{
	
	/** the main Gtk struct */
	protected GtkType* gtkType;
	
	
	public GtkType* getTypesStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkType* gtkType);
	
	/**
	 */
	
	/**
	 * Warning
	 * gtk_type_init is deprecated and should not be used in newly-written code.
	 * Initializes the data structures associated with GTK+ types.
	 * Params:
	 * debugFlags = debug flags
	 */
	public static void init(GTypeDebugFlags debugFlags);
	
	/**
	 * Warning
	 * gtk_type_unique is deprecated and should not be used in newly-written code.
	 * Creates a new, unique type.
	 * Params:
	 * parentType = if zero, a fundamental type is created
	 * gtkinfo = must not be NULL, and type_info->type_name must also not be NULL
	 * Returns:the new GtkType
	 */
	public static GtkType unique(GtkType parentType, GtkTypeInfo* gtkinfo);
	
	/**
	 * Warning
	 * gtk_type_class has been deprecated since version 2.14 and should not be used in newly-written code. Use g_type_class_peek() or g_type_class_ref() instead.
	 * Returns a pointer pointing to the class of type or NULL if there
	 * was any trouble identifying type. Initializes the class if
	 * necessary.
	 * Returns a pointer pointing to the class of type or NULL if there was
	 * any trouble identifying type. Initializes the class if necessary.
	 * Params:
	 * type =  a GtkType.
	 * Returns: pointer to the class.
	 */
	public static void* clss(GtkType type);
	
	/**
	 * Warning
	 * gtk_type_new is deprecated and should not be used in newly-written code.
	 * Creates a new object of a given type, and return a pointer to it.
	 * Returns NULL if you give it an invalid type. It allocates the object
	 * out of the type's memory chunk if there is a memory chunk. The object
	 * has all the proper initializers called.
	 * Params:
	 * type = a GtkType.
	 * Returns:pointer to a GtkTypeObject.
	 */
	public static void* newTypes(GtkType type);
	
	/**
	 * Warning
	 * gtk_type_enum_get_values is deprecated and should not be used in newly-written code.
	 * If enum_type has values, then return a pointer to all of them.
	 * Params:
	 * enumType = a GtkType.
	 * Returns:#GtkEnumValue*
	 */
	public static GtkEnumValue* enumGetValues(GtkType enumType);
	
	/**
	 * Warning
	 * gtk_type_flags_get_values is deprecated and should not be used in newly-written code.
	 * If flags_type has values, then return a pointer to all of them.
	 * Params:
	 * flagsType = a GtkType.
	 * Returns:#GtkFlagValue*
	 */
	public static GtkFlagValue* flagsGetValues(GtkType flagsType);
	
	/**
	 * Warning
	 * gtk_type_enum_find_value is deprecated and should not be used in newly-written code.
	 * Returns a pointer to one of enum_type's GtkEnumValues's whose name (or nickname) matches value_name.
	 * Params:
	 * enumType = a GtkType.
	 * valueName = the name to look for.
	 * Returns:#GtkEnumValue*
	 */
	public static GtkEnumValue* enumFindValue(GtkType enumType, string valueName);
	
	/**
	 * Warning
	 * gtk_type_flags_find_value is deprecated and should not be used in newly-written code.
	 * Returns a pointer to one of flag_type's GtkFlagValue's whose name (or nickname) matches value_name.
	 * Params:
	 * flagsType = a GtkType.
	 * valueName = the name to look for.
	 * Returns:#GtkFlagValue*
	 */
	public static GtkFlagValue* flagsFindValue(GtkType flagsType, string valueName);
}
