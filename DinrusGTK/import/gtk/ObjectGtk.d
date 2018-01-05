module gtkD.gtk.ObjectGtk;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.ObjectGtk;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Description
 * GtkObject is the base class for all widgets, and for a few
 * non-widget objects such as GtkAdjustment. GtkObject predates
 * GObject; non-widgets that derive from GtkObject rather than
 * GObject do so for backward compatibility reasons.
 * GtkObjects are created with a "floating" reference count.
 * This means that the initial reference is not owned by anyone. Calling
 * g_object_unref() on a newly-created GtkObject is incorrect, the floating
 * reference has to be removed first. This can be done by anyone at any time,
 * by calling g_object_ref_sink() to convert the floating reference into a
 * regular reference. g_object_ref_sink() returns a new reference if an object
 * is already sunk (has no floating reference).
 * When you add a widget to its parent container, the parent container
 * will do this:
 *  g_object_ref_sink (G_OBJECT (child_widget));
 * This means that the container now owns a reference to the child widget
 * and the child widget has no floating reference.
 * The purpose of the floating reference is to keep the child widget alive
 * until you add it to a parent container:
 *  button = gtk_button_new ();
 *  /+* button has one floating reference to keep it alive +/
 *  gtk_container_add (GTK_CONTAINER (container), button);
 *  /+* button has one non-floating reference owned by the container +/
 * GtkWindow is a special case, because GTK+ itself will ref/sink it on creation.
 * That is, after calling gtk_window_new(), the GtkWindow will have one
 * reference which is owned by GTK+, and no floating references.
 * One more factor comes into play: the "destroy" signal, emitted by the
 * gtk_object_destroy() method. The "destroy" signal asks all code owning a
 * reference to an object to release said reference. So, for example, if you call
 * gtk_object_destroy() on a GtkWindow, GTK+ will release the reference count that
 * it owns; if you call gtk_object_destroy() on a GtkButton, then the button will
 * be removed from its parent container and the parent container will release its
 * reference to the button. Because these references are released, calling
 * gtk_object_destroy() should result in freeing all memory associated with an
 * object, unless some buggy code fails to release its references in response to
 * the "destroy" signal. Freeing memory (referred to as
 * finalization only happens if the reference count reaches
 * zero.
 * Some simple rules for handling ""
 * Never call g_object_unref() unless you have previously called g_object_ref(),
 * even if you created the GtkObject. (Note: this is not
 * true for GObject; for GObject, the creator of the object owns a reference.)
 * Call gtk_object_destroy() to get rid of most objects in most cases.
 * In particular, widgets are almost always destroyed in this way.
 *  Because of the floating reference count, you don't need to
 * worry about reference counting for widgets and toplevel windows, unless you
 * explicitly call g_object_ref() yourself.
 */
public class ObjectGtk : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkObject* gtkObject;
	
	
	public GtkObject* getObjectGtkStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkObject* gtkObject);
	
	/** */
	public static string getId(StockID id);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ObjectGtk)[] onDestroyListeners;
	/**
	 * Signals that all holders of a reference to the GtkObject should release
	 * the reference that they hold. May result in finalization of the object
	 * if all references are released.
	 * See Also
	 * GObject
	 */
	void addOnDestroy(void delegate(ObjectGtk) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDestroy(GtkObject* objectStruct, ObjectGtk objectGtk);
	
	
	/**
	 * Warning
	 * gtk_object_sink has been deprecated since version 2.10 and should not be used in newly-written code. Use g_object_ref_sink() instead
	 * Removes the floating reference from a GtkObject, if it exists;
	 * otherwise does nothing. See the GtkObject overview documentation at
	 * the top of the page.
	 */
	public void sink();
	
	/**
	 * Warning
	 * gtk_object_ref is deprecated and should not be used in newly-written code. Use g_object_ref() instead.
	 * Increases the reference count of the object.
	 * Returns:@object.
	 */
	public ObjectGtk doref();
	
	/**
	 * Warning
	 * gtk_object_unref is deprecated and should not be used in newly-written code. Use g_object_unref() instead.
	 * Decreases the reference count of an object. When its reference count drops
	 * to 0, the object is finalized (i.e. its memory is freed).
	 */
	public void unref();
	
	/**
	 * Warning
	 * gtk_object_weakref is deprecated and should not be used in newly-written code. Use g_object_weak_ref() instead.
	 * Adds a weak reference callback to an object. Weak references are used for notification when an object is
	 * finalized. They are called "weak references" because they allow you to safely
	 * hold a pointer to an object without calling g_object_ref() (g_object_ref() adds
	 * a strong reference, that is, forces the object to stay alive).
	 * Params:
	 * notify = callback to invoke before the object is freed.
	 * data = extra data to pass to notify.
	 */
	public void weakref(GDestroyNotify notify, void* data);
	
	/**
	 * Warning
	 * gtk_object_weakunref is deprecated and should not be used in newly-written code. Use g_object_weak_unref() instead.
	 * Removes a weak reference callback to an object.
	 * Params:
	 * notify = callback to search for.
	 * data = data to search for.
	 */
	public void weakunref(GDestroyNotify notify, void* data);
	
	/**
	 * Emits the "destroy" signal notifying all reference holders that they should
	 * release the GtkObject. See the overview documentation at the top of the
	 * page for more details.
	 * The memory for the object itself won't be deleted until
	 * its reference count actually drops to 0; gtk_object_destroy() merely asks
	 * reference holders to release their references, it does not free the object.
	 */
	public void destroy();
	
	/**
	 * Warning
	 * gtk_object_set_data is deprecated and should not be used in newly-written code. Use g_object_set_data() instead.
	 * Each object carries around a table of associations from
	 * strings to pointers. This function lets you set an association.
	 * If the object already had an association with that name,
	 * the old association will be destroyed.
	 * Params:
	 * key = name of the key.
	 * data = data to associate with that key.
	 */
	public override void setData(string key, void* data);
	
	/**
	 * Warning
	 * gtk_object_set_data_full is deprecated and should not be used in newly-written code. Use g_object_set_data_full() instead.
	 * Like gtk_object_set_data() except it adds notification
	 * for when the association is destroyed, either by
	 * gtk_object_remove_data() or when the object is destroyed.
	 * Params:
	 * key = name of the key.
	 * data = data to associate with that key.
	 * destroy = function to call when the association is destroyed.
	 */
	public void setDataFull(string key, void* data, GDestroyNotify destroy);
	
	/**
	 * Warning
	 * gtk_object_remove_data is deprecated and should not be used in newly-written code. Use g_object_set_data() to set the object data to NULL instead.
	 * Removes a specified datum from the object's data associations (the object_data).
	 * Subsequent calls to gtk_object_get_data() will return NULL.
	 * If you specified a destroy handler with gtk_object_set_data_full(),
	 * it will be invoked.
	 * Params:
	 * key = name of the key for that association.
	 */
	public void removeData(string key);
	
	/**
	 * Warning
	 * gtk_object_get_data is deprecated and should not be used in newly-written code. Use g_object_get_data() instead.
	 * Get a named field from the object's table of associations (the object_data).
	 * Params:
	 * key = name of the key for that association.
	 * Returns:the data if found, or NULL if no such data exists.
	 */
	public override void* getData(string key);
	
	/**
	 * Warning
	 * gtk_object_remove_no_notify is deprecated and should not be used in newly-written code. Use g_object_steal_data() instead.
	 * Remove a specified datum from the object's data associations (the object_data),
	 * without invoking the association's destroy handler.
	 * Just like gtk_object_remove_data() except that any destroy handler
	 * will be ignored.
	 * Therefore this only affects data set using gtk_object_set_data_full().
	 * Params:
	 * key = name of the key for that association.
	 */
	public void removeNoNotify(string key);
	
	/**
	 * Warning
	 * gtk_object_set_user_data is deprecated and should not be used in newly-written code. Use g_object_set_data() instead.
	 * For convenience, every object offers a generic user data
	 * pointer. This function sets it.
	 * Params:
	 * data = the new value for the user data.
	 */
	public void setUserData(void* data);
	
	/**
	 * Warning
	 * gtk_object_get_user_data is deprecated and should not be used in newly-written code. Use g_object_get_data() instead.
	 * Get the object's user data pointer.
	 * This is intended to be a pointer for your convenience in
	 * writing applications.
	 * Returns:the user data field for object.
	 */
	public void* getUserData();
	
	/**
	 * Warning
	 * gtk_object_add_arg_type is deprecated and should not be used in newly-written code.
	 * Deprecated in favor of the GObject property system including GParamSpec.
	 * Add a new type of argument to an object class.
	 * Usually this is called when registering a new type of object.
	 * Params:
	 * argName = fully qualify object name, for example GtkObject::user_data.
	 * argType = type of the argument.
	 * argFlags = bitwise-OR of the GtkArgFlags enum. (Whether the argument is
	 * settable or gettable, whether it is set when the object is constructed.)
	 * argId = an internal number, passed in from here to the "set_arg" and
	 * "get_arg" handlers of the object.
	 */
	public static void addArgType(string argName, GType argType, uint argFlags, uint argId);
	
	/**
	 * Warning
	 * gtk_object_set_data_by_id is deprecated and should not be used in newly-written code. Use g_object_set_qdata() instead.
	 * Just like gtk_object_set_data() except that it takes
	 * a GQuark instead of a string, so it is slightly faster.
	 * Use gtk_object_data_try_key() and gtk_object_data_force_id()
	 * to get an id from a string.
	 * Params:
	 * dataId = quark of the key.
	 * data = data to associate with that key.
	 */
	public void setDataById(GQuark dataId, void* data);
	
	/**
	 * Warning
	 * gtk_object_set_data_by_id_full is deprecated and should not be used in newly-written code. Use g_object_set_qdata_full() instead.
	 * Just like gtk_object_set_data_full() except that it takes
	 * a GQuark instead of a string, so it is slightly faster.
	 * Use gtk_object_data_try_key() and gtk_object_data_force_id()
	 * to get an id from a string.
	 * Params:
	 * dataId = quark of the key.
	 * data = data to associate with that key.
	 * destroy = function to call when the association is destroyed.
	 */
	public void setDataByIdFull(GQuark dataId, void* data, GDestroyNotify destroy);
	
	/**
	 * Warning
	 * gtk_object_get_data_by_id is deprecated and should not be used in newly-written code. Use g_object_get_qdata() instead.
	 * Just like gtk_object_get_data() except that it takes
	 * a GQuark instead of a string, so it is slightly faster.
	 * Use gtk_object_data_try_key() and gtk_object_data_force_id()
	 * to get an id from a string.
	 * Params:
	 * dataId = quark of the key.
	 * Returns:the data if found, or NULL if no such data exists.
	 */
	public void* getDataById(GQuark dataId);
	
	/**
	 * Warning
	 * gtk_object_remove_data_by_id is deprecated and should not be used in newly-written code. Use g_object_set_qdata() with data of NULL instead.
	 * Just like gtk_object_remove_data() except that it takes
	 * a GQuark instead of a string, so it is slightly faster.
	 * Remove a specified datum from the object's data associations.
	 * Subsequent calls to gtk_object_get_data() will return NULL.
	 * Use gtk_object_data_try_key() and gtk_object_data_force_id()
	 * to get an id from a string.
	 * Params:
	 * dataId = quark of the key.
	 */
	public void removeDataById(GQuark dataId);
	
	/**
	 * Warning
	 * gtk_object_remove_no_notify_by_id is deprecated and should not be used in newly-written code. Use g_object_steal_qdata() instead.
	 * Just like gtk_object_remove_no_notify() except that it takes
	 * a GQuark instead of a string, so it is slightly faster.
	 * Use gtk_object_data_try_key() and gtk_object_data_force_id()
	 * to get an id from a string.
	 * Params:
	 * keyId = quark of the key.
	 */
	public void removeNoNotifyById(GQuark keyId);
}
