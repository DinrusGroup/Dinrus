module gtkD.gobject.CClosure;

public  import gtkD.gtkc.gobjecttypes;

private import gtkD.gtkc.gobject;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.Closure;
private import gtkD.gobject.ObjectG;
private import gtkD.gobject.Value;




/**
 * Description
 * A GClosure represents a callback supplied by the programmer. It
 * will generally comprise a function of some kind and a marshaller
 * used to call it. It is the reponsibility of the marshaller to
 * convert the arguments for the invocation from GValues into
 * a suitable form, perform the callback on the converted arguments,
 * and transform the return value back into a GValue.
 * In the case of C programs, a closure usually just holds a pointer
 * to a function and maybe a data argument, and the marshaller
 * converts between GValue and native C types. The GObject
 * library provides the GCClosure type for this purpose. Bindings for
 * other languages need marshallers which convert between GValues and suitable representations in the runtime of the language in
 * order to use functions written in that languages as callbacks.
 * Within GObject, closures play an important role in the
 * implementation of signals. When a signal is registered, the
 * c_marshaller argument to g_signal_new() specifies the default C
 * marshaller for any closure which is connected to this
 * signal. GObject provides a number of C marshallers for this
 * purpose, see the g_cclosure_marshal_*() functions. Additional C
 * marshallers can be generated with the glib-genmarshal utility. Closures
 * can be explicitly connected to signals with
 * g_signal_connect_closure(), but it usually more convenient to let
 * GObject create a closure automatically by using one of the
 * g_signal_connect_*() functions which take a callback function/user
 * data pair.
 * Using closures has a number of important advantages over a simple
 * callback function/data pointer combination:
 * Closures allow the callee to get the types of the callback parameters,
 * which means that language bindings don't have to write individual glue
 * for each callback type.
 * The reference counting of GClosure makes it easy to handle reentrancy
 * right; if a callback is removed while it is being invoked, the closure
 * and its parameters won't be freed until the invocation finishes.
 * g_closure_invalidate() and invalidation notifiers allow callbacks to be
 * automatically removed when the objects they point to go away.
 */
public class CClosure
{
	
	/** the main Gtk struct */
	protected GCClosure* gCClosure;
	
	
	public GCClosure* getCClosureStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GCClosure* gCClosure);
	
	/**
	 */
	
	/**
	 * Creates a new closure which invokes callback_func with user_data as
	 * the last parameter.
	 * Params:
	 * callbackFunc =  the function to invoke
	 * userData =  user data to pass to callback_func
	 * destroyData =  destroy notify to be called when user_data is no longer used
	 * Returns: a new GCClosure
	 */
	public static Closure newCClosure(GCallback callbackFunc, void* userData, GClosureNotify destroyData);
	
	/**
	 * Creates a new closure which invokes callback_func with user_data as
	 * the first parameter.
	 * Params:
	 * callbackFunc =  the function to invoke
	 * userData =  user data to pass to callback_func
	 * destroyData =  destroy notify to be called when user_data is no longer used
	 * Returns: a new GCClosure
	 */
	public static Closure newSwap(GCallback callbackFunc, void* userData, GClosureNotify destroyData);
	
	/**
	 * A variant of g_cclosure_new() which uses object as user_data and
	 * calls g_object_watch_closure() on object and the created
	 * closure. This function is useful when you have a callback closely
	 * associated with a GObject, and want the callback to no longer run
	 * after the object is is freed.
	 * Params:
	 * callbackFunc =  the function to invoke
	 * object =  a GObject pointer to pass to callback_func
	 * Returns: a new GCClosure
	 */
	public static Closure newObject(GCallback callbackFunc, ObjectG object);
	
	/**
	 * A variant of g_cclosure_new_swap() which uses object as user_data
	 * and calls g_object_watch_closure() on object and the created
	 * closure. This function is useful when you have a callback closely
	 * associated with a GObject, and want the callback to no longer run
	 * after the object is is freed.
	 * Params:
	 * callbackFunc =  the function to invoke
	 * object =  a GObject pointer to pass to callback_func
	 * Returns: a new GCClosure
	 */
	public static Closure newObjectSwap(GCallback callbackFunc, ObjectG object);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  1
	 * paramValues =  a GValue array holding only the instance
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__VOID(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gboolean arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the gboolean parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__BOOLEAN(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gchar arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the gchar parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__CHAR(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, guchar arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the guchar parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__UCHAR(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gint arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the gint parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__INT(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, guint arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the guint parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__UINT(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, glong arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the glong parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__LONG(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gulong arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the gulong parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__ULONG(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gint arg1, gpointer user_data) where the gint parameter denotes an enumeration type..
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the enumeration parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__ENUM(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gint arg1, gpointer user_data) where the gint parameter denotes a flags type.
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the flags parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__FLAGS(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gfloat arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the gfloat parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__FLOAT(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gdouble arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the gdouble parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__DOUBLE(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, const gchar *arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the gchar* parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__STRING(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, GParamSpec *arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the GParamSpec* parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__PARAM(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, GBoxed *arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the GBoxed* parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__BOXED(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, gpointer arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the gpointer parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__POINTER(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, GOBject *arg1, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  2
	 * paramValues =  a GValue array holding the instance and the GObject* parameter
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__OBJECT(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * gchar* (*callback) (gpointer instance, GObject *arg1, gpointer arg2, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  a GValue, which can store the returned string
	 * nParamValues =  3
	 * paramValues =  a GValue array holding instance, arg1 and arg2
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalSTRING__OBJECT_POINTER(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * void (*callback) (gpointer instance, guint arg1, gpointer arg2, gpointer user_data).
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  ignored
	 * nParamValues =  3
	 * paramValues =  a GValue array holding instance, arg1 and arg2
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalVOID__UINT_POINTER(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
	
	/**
	 * A marshaller for a GCClosure with a callback of type
	 * gboolean (*callback) (gpointer instance, gint arg1, gpointer user_data) where the gint parameter
	 * denotes a flags type.
	 * Params:
	 * closure =  the GClosure to which the marshaller belongs
	 * returnValue =  a GValue which can store the returned gboolean
	 * nParamValues =  2
	 * paramValues =  a GValue array holding instance and arg1
	 * invocationHint =  the invocation hint given as the last argument
	 *  to g_closure_invoke()
	 * marshalData =  additional data specified when registering the marshaller
	 */
	public static void marshalBOOLEAN__FLAGS(Closure closure, Value returnValue, uint nParamValues, Value paramValues, void* invocationHint, void* marshalData);
}
