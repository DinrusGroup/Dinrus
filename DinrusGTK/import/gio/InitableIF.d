module gtkD.gio.InitableIF;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gobject.ObjectG;
private import gtkD.gio.Cancellable;




/**
 * Description
 * GInitable is implemented by objects that can fail during
 * initialization. If an object implements this interface the
 * g_initable_init() function must be called as the first thing
 * after construction. If g_initable_init() is not called, or if
 * it returns an error, all further operations on the object
 * should fail, generally with a G_IO_ERROR_NOT_INITIALIZED error.
 * Users of objects implementing this are not intended to use
 * the interface method directly, instead it will be used automatically
 * in various ways. For C applications you generally just call
 * g_initable_new() directly, or indirectly via a foo_thing_new() wrapper.
 * This will call g_initable_init() under the cover, returning NULL and
 * setting a GError on failure.
 * For bindings in languages where the native constructor supports
 * exceptions the binding could check for objects implemention GInitable
 * during normal construction and automatically initialize them, throwing
 * an exception on failure.
 */
public interface InitableIF
{
	
	
	public GInitable* getInitableTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	/**
	 * Initializes the object implementing the interface. This must be
	 * done before any real use of the object after initial construction.
	 * Implementations may also support cancellation. If cancellable is not NULL,
	 * then initialization can be cancelled by triggering the cancellable object
	 * from another thread. If the operation was cancelled, the error
	 * G_IO_ERROR_CANCELLED will be returned. If cancellable is not NULL and
	 * the object doesn't support cancellable initialization the error
	 * G_IO_ERROR_NOT_SUPPORTED will be returned.
	 * If this function is not called, or returns with an error then all
	 * operations on the object should fail, generally returning the
	 * error G_IO_ERROR_NOT_INITIALIZED.
	 * Implementations of this method must be idempotent, i.e. multiple calls
	 * to this function with the same argument should return the same results.
	 * Only the first call initializes the object, further calls return the result
	 * of the first call. This is so that its safe to implement the singleton
	 * pattern in the GObject constructor function.
	 * Since 2.22
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if successful. If an error has occurred, this function will return FALSE and set error appropriately if present.
	 * Throws: GException on failure.
	 */
	public int init(Cancellable cancellable);
	
	/**
	 * Helper function for constructing GInitiable object. This is
	 * similar to g_object_new_valist() but also initializes the object
	 * and returns NULL, setting an error on failure.
	 * Since 2.22
	 * Params:
	 * objectType =  a GType supporting GInitable.
	 * firstPropertyName =  the name of the first property, followed by
	 * the value, and other property value pairs, and ended by NULL.
	 * varArgs =  The var args list generated from first_property_name.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a newly allocated GObject, or NULL on error
	 * Throws: GException on failure.
	 */
	public static ObjectG newValist(GType objectType, string firstPropertyName, void* varArgs, Cancellable cancellable);
	
	/**
	 * Helper function for constructing GInitiable object. This is
	 * similar to g_object_newv() but also initializes the object
	 * and returns NULL, setting an error on failure.
	 * Since 2.22
	 * Params:
	 * objectType =  a GType supporting GInitable.
	 * parameters =  the parameters to use to construct the object
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a newly allocated GObject, or NULL on error
	 * Throws: GException on failure.
	 */
	public static void* newv(GType objectType, GParameter[] parameters, Cancellable cancellable);
}
