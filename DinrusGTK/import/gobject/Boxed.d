module gtkD.gobject.Boxed;

public  import gtkD.gtkc.gobjecttypes;

private import gtkD.gtkc.gobject;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * GBoxed is a generic wrapper mechanism for arbitrary C structures. The only
 * thing the type system needs to know about the structures is how to copy and
 * free them, beyond that they are treated as opaque chunks of memory.
 * Boxed types are useful for simple value-holder structures like rectangles or
 * points. They can also be used for wrapping structures defined in non-GObject
 * based libraries.
 */
public class Boxed
{
	
	/**
	 */
	
	/**
	 * Provide a copy of a boxed structure src_boxed which is of type boxed_type.
	 * Params:
	 * boxedType =  The type of src_boxed.
	 * srcBoxed =  The boxed structure to be copied.
	 * Returns: The newly created copy of the boxed structure.
	 */
	public static void* boxedCopy(GType boxedType, void* srcBoxed);
	
	/**
	 * Free the boxed structure boxed which is of type boxed_type.
	 * Params:
	 * boxedType =  The type of boxed.
	 * boxed =  The boxed structure to be freed.
	 */
	public static void boxedFree(GType boxedType, void* boxed);
	
	/**
	 * This function creates a new G_TYPE_BOXED derived type id for a new
	 * boxed type with name name. Boxed type handling functions have to be
	 * provided to copy and free opaque boxed structures of this type.
	 * Params:
	 * name =  Name of the new boxed type.
	 * boxedCopy =  Boxed structure copy function.
	 * boxedFree =  Boxed structure free function.
	 * Returns: New G_TYPE_BOXED derived type id for name.
	 */
	public static GType boxedTypeRegisterStatic(string name, GBoxedCopyFunc boxedCopy, GBoxedFreeFunc boxedFree);
	
	/**
	 * Creates a new G_TYPE_POINTER derived type id for a new
	 * pointer type with name name.
	 * Params:
	 * name =  the name of the new pointer type.
	 * Returns: a new G_TYPE_POINTER derived type id for name.
	 */
	public static GType pointerTypeRegisterStatic(string name);
}
