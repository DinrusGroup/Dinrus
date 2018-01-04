module gtkD.gstreamer.MiniObject;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.Value;




/**
 * Description
 * GstMiniObject is a baseclass like GObject, but has been stripped down of
 * features to be fast and small.
 * It offers sub-classing and ref-counting in the same way as GObject does.
 * It has no properties and no signal-support though.
 * Last reviewed on 2005-11-23 (0.9.5)
 */
public class MiniObject
{
	
	/** the main Gtk struct */
	protected GstMiniObject* gstMiniObject;
	
	
	public GstMiniObject* getMiniObjectStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstMiniObject* gstMiniObject);
	
	/**
	 */
	
	/**
	 * Creates a new mini-object of the desired type.
	 * MT safe
	 * Params:
	 * type =  the GType of the mini-object to create
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GType type);
	
	/**
	 * Creates a copy of the mini-object.
	 * MT safe
	 * Returns: the new mini-object.
	 */
	public MiniObject copy();
	
	/**
	 * Checks if a mini-object is writable. A mini-object is writable
	 * if the reference count is one and the GST_MINI_OBJECT_FLAG_READONLY
	 * flag is not set. Modification of a mini-object should only be
	 * done after verifying that it is writable.
	 * MT safe
	 * Returns: TRUE if the object is writable.
	 */
	public int isWritable();
	
	/**
	 * Checks if a mini-object is writable. If not, a writeable copy is made and
	 * returned. This gives away the reference to the original mini object,
	 * and returns a reference to the new object.
	 * MT safe
	 * Returns: a mini-object (possibly the same pointer) that is writable.
	 */
	public MiniObject makeWritable();
	
	/**
	 * Increase the reference count of the mini-object.
	 * Note that the refcount affects the writeability
	 * of mini-object, see gst_mini_object_is_writable(). It is
	 * important to note that keeping additional references to
	 * GstMiniObject instances can potentially increase the number
	 * of memcpy operations in a pipeline, especially if the minibject
	 * is a GstBuffer.
	 * Returns: the mini-object.
	 */
	public MiniObject doref();
	
	/**
	 * Decreases the reference count of the mini-object, possibly freeing
	 * the mini-object.
	 */
	public void unref();
	
	/**
	 * Modifies a pointer to point to a new mini-object. The modification
	 * is done atomically, and the reference counts are updated correctly.
	 * Either newdata and the value pointed to by olddata may be NULL.
	 * Params:
	 * olddata =  pointer to a pointer to a mini-object to be replaced
	 * newdata =  pointer to new mini-object
	 */
	public static void replace(GstMiniObject** olddata, MiniObject newdata);
	
	/**
	 * Creates a new GParamSpec instance that hold GstMiniObject references.
	 * Params:
	 * name =  the canonical name of the property
	 * nick =  the nickname of the property
	 * blurb =  a short description of the property
	 * objectType =  the GstMiniObjectType for the property
	 * flags =  a combination of GParamFlags
	 * Returns: a newly allocated GParamSpec instance
	 */
	public static GParamSpec* gstParamSpecMiniObject(string name, string nick, string blurb, GType objectType, GParamFlags flags);
	
	/**
	 * Set the contents of a GST_TYPE_MINI_OBJECT derived GValue to
	 * mini_object.
	 * The caller retains ownership of the reference.
	 * Params:
	 * value =  a valid GValue of GST_TYPE_MINI_OBJECT derived type
	 * miniObject =  mini object value to set
	 */
	public static void gstValueSetMiniObject(Value value, MiniObject miniObject);
	
	/**
	 * Set the contents of a GST_TYPE_MINI_OBJECT derived GValue to
	 * mini_object.
	 * Takes over the ownership of the caller's reference to mini_object;
	 * the caller doesn't have to unref it any more.
	 * Params:
	 * value =  a valid GValue of GST_TYPE_MINI_OBJECT derived type
	 * miniObject =  mini object value to take
	 */
	public static void gstValueTakeMiniObject(Value value, MiniObject miniObject);
	
	/**
	 * Get the contents of a GST_TYPE_MINI_OBJECT derived GValue.
	 * Does not increase the refcount of the returned object.
	 * Params:
	 * value =  a valid GValue of GST_TYPE_MINI_OBJECT derived type
	 * Returns: mini object contents of value
	 */
	public static MiniObject gstValueGetMiniObject(Value value);
}
