module gtkD.glib.Quark;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * Quarks are associations between strings and integer identifiers.
 * Given either the string or the GQuark identifier it is possible to
 * retrieve the other.
 * Quarks are used for both
 * Datasets and
 * Keyed Data Lists.
 * To create a new quark from a string, use g_quark_from_string() or
 * g_quark_from_static_string().
 * To find the string corresponding to a given GQuark, use g_quark_to_string().
 * To find the GQuark corresponding to a given string, use g_quark_try_string().
 * Another use for the string pool maintained for the quark functions is string
 * interning, using g_intern_string() or g_intern_static_string(). An interned string
 * is a canonical representation for a string. One important advantage of interned strings
 * is that they can be compared for equality by a simple pointer comparision, rather than
 * using strcmp().
 */
public class Quark
{
	
	/** the main Gtk struct */
	protected GQuark* gQuark;
	
	
	public GQuark* getQuarkStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GQuark* gQuark);
	
	/**
	 */
	
	/**
	 * Gets the GQuark identifying the given string.
	 * If the string does not currently have an associated GQuark, a new
	 * GQuark is created, using a copy of the string.
	 * Params:
	 * string = a string.
	 * Returns:the GQuark identifying the string, or 0 if string is NULL.
	 */
	public static GQuark fromString(string string);
	
	/**
	 * Gets the GQuark identifying the given (static) string.
	 * If the string does not currently have an associated GQuark, a new
	 * GQuark is created, linked to the given string.
	 * Note that this function is identical to g_quark_from_string() except
	 * that if a new GQuark is created the string itself is used rather than
	 * a copy. This saves memory, but can only be used if the string will
	 * always exist. It can be used with statically
	 * allocated strings in the main program, but not with statically
	 * allocated memory in dynamically loaded modules, if you expect to
	 * ever unload the module again (e.g. do not use this function in
	 * GTK+ theme engines).
	 * Params:
	 * string = a string.
	 * Returns:the GQuark identifying the string, or 0 if string is NULL.
	 */
	public static GQuark fromStaticString(string string);
	
	/**
	 * Gets the string associated with the given GQuark.
	 * Params:
	 * quark = a GQuark.
	 * Returns:the string associated with the GQuark.
	 */
	public static string toString(GQuark quark);
	
	/**
	 * Gets the GQuark associated with the given string, or 0 if string is
	 * NULL or it has no associated GQuark.
	 * If you want the GQuark to be created if it doesn't already exist, use
	 * g_quark_from_string() or g_quark_from_static_string().
	 * Params:
	 * string = a string.
	 * Returns:the GQuark associated with the string, or 0 if string isNULL or there is no GQuark associated with it.
	 */
	public static GQuark tryString(string string);
	
	/**
	 * Returns a canonical representation for string. Interned strings can
	 * be compared for equality by comparing the pointers, instead of using strcmp().
	 * Since 2.10
	 * Params:
	 * string =  a string
	 * Returns: a canonical representation for the string
	 */
	public static string gInternString(string string);
	
	/**
	 * Returns a canonical representation for string. Interned strings can
	 * be compared for equality by comparing the pointers, instead of using strcmp().
	 * g_intern_static_string() does not copy the string, therefore string must
	 * not be freed or modified.
	 * Since 2.10
	 * Params:
	 * string =  a static string
	 * Returns: a canonical representation for the string
	 */
	public static string gInternStaticString(string string);
}
