module gtkD.gstreamer.Caps;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Structure;




/**
 * Description
 * Caps (capabilities) are lighweight refcounted objects describing media types.
 * They are composed of an array of GstStructure.
 * Caps are exposed on GstPadTemplate to describe all possible types a
 * given pad can handle. They are also stored in the GstRegistry along with
 * a description of the GstElement.
 * Caps are exposed on the element pads using the gst_pad_get_caps() pad
 * function. This function describes the possible types that the pad can
 * handle or produce at runtime.
 * Caps are also attached to buffers to describe to content of the data
 * pointed to by the buffer with gst_buffer_set_caps(). Caps attached to
 * a GstBuffer allow for format negotiation upstream and downstream.
 * A GstCaps can be constructed with the following code fragment:
 * Example4.Creating caps
 *  GstCaps *caps;
 *  caps = gst_caps_new_simple ("video/x-raw-yuv",
 *  "format", GST_TYPE_FOURCC, GST_MAKE_FOURCC ('I', '4', '2', '0'),
 *  "framerate", GST_TYPE_FRACTION, 25, 1,
 *  "pixel-aspect-ratio", GST_TYPE_FRACTION, 1, 1,
 *  "width", G_TYPE_INT, 320,
 *  "height", G_TYPE_INT, 240,
 *  NULL);
 * A GstCaps is fixed when it has no properties with ranges or lists. Use
 * gst_caps_is_fixed() to test for fixed caps. Only fixed caps can be
 * set on a GstPad or GstBuffer.
 * Various methods exist to work with the media types such as subtracting
 * or intersecting.
 * Last reviewed on 2007-02-13 (0.10.10)
 */
public class Caps
{
	
	/** the main Gtk struct */
	protected GstCaps* gstCaps;
	
	
	public GstCaps* getCapsStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstCaps* gstCaps);
	
	/**
	 * Creates a new GstCaps that indicates that it is compatible with
	 * any media format.
	 * Returns:
	 *  the new GstCaps
	 */
	public static Caps newAny();
	
	/**
	 */
	
	/**
	 * Creates a new GstCaps that is empty. That is, the returned
	 * GstCaps contains no media formats.
	 * Caller is responsible for unreffing the returned caps.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GstCaps and adds all the structures listed as
	 * arguments. The list must be NULL-terminated. The structures
	 * are not copied; the returned GstCaps owns the structures.
	 * Params:
	 * structure =  the first structure to add
	 * varArgs =  additional structures to add
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Structure structure, void* varArgs);
	
	/**
	 * Creates a new GstCaps as a copy of the old caps. The new caps will have a
	 * refcount of 1, owned by the caller. The structures are copied as well.
	 * Note that this function is the semantic equivalent of a gst_caps_ref()
	 * followed by a gst_caps_make_writable(). If you only want to hold on to a
	 * reference to the data, you should use gst_caps_ref().
	 * When you are finished with the caps, call gst_caps_unref() on it.
	 * Returns: the new GstCaps
	 */
	public Caps copy();
	
	/**
	 * Creates a new GstCaps and appends a copy of the nth structure
	 * contained in caps.
	 * Params:
	 * nth =  the nth structure to copy
	 * Returns: the new GstCaps
	 */
	public Caps copyNth(uint nth);
	
	/**
	 * Converts a GstStaticCaps to a GstCaps.
	 * Params:
	 * staticCaps =  the GstStaticCaps to convert
	 * Returns: A pointer to the GstCaps. Unref after usage. Since thecore holds an additional ref to the returned caps,use gst_caps_make_writable() on the returned caps to modify it.
	 */
	public static Caps staticCapsGet(GstStaticCaps* staticCaps);
	
	/**
	 * Appends the structures contained in caps2 to caps1. The structures in
	 * caps2 are not copied -- they are transferred to caps1, and then caps2 is
	 * freed. If either caps is ANY, the resulting caps will be ANY.
	 * Params:
	 * caps2 =  the GstCaps to append
	 */
	public void append(Caps caps2);
	
	/**
	 * Appends the structures contained in caps2 to caps1 if they are not yet
	 * expressed by caps1. The structures in caps2 are not copied -- they are
	 * transferred to caps1, and then caps2 is freed.
	 * If either caps is ANY, the resulting caps will be ANY.
	 * Params:
	 * caps2 =  the GstCaps to merge in
	 * Since 0.10.10
	 */
	public void merge(Caps caps2);
	
	/**
	 * Appends structure to caps. The structure is not copied; caps
	 * becomes the owner of structure.
	 * Params:
	 * structure =  the GstStructure to append
	 */
	public void appendStructure(Structure structure);
	
	/**
	 * removes the stucture with the given index from the list of structures
	 * contained in caps.
	 * Params:
	 * idx =  Index of the structure to remove
	 */
	public void removeStructure(uint idx);

	/**
	 * Appends structure to caps if its not already expressed by caps. The
	 * structure is not copied; caps becomes the owner of structure.
	 * Params:
	 * structure =  the GstStructure to merge
	 */
	public void mergeStructure(Structure structure);
	
	/**
	 * Gets the number of structures contained in caps.
	 * Returns: the number of structures that caps contains
	 */
	public uint getSize();
	
	/**
	 * Finds the structure in caps that has the index index, and
	 * returns it.
	 * WARNING: This function takes a const GstCaps *, but returns a
	 * non-const GstStructure *. This is for programming convenience --
	 * the caller should be aware that structures inside a constant
	 * GstCaps should not be modified.
	 * Params:
	 * index =  the index of the structure
	 * Returns: a pointer to the GstStructure corresponding to index
	 */
	public Structure getStructure(uint index);
	
	/**
	 * Sets fields in a simple GstCaps. A simple GstCaps is one that
	 * only has one structure. The arguments must be passed in the same
	 * manner as gst_structure_set(), and be NULL-terminated.
	 * Params:
	 * field =  first field to set
	 * varargs =  additional parameters
	 */
	public void setSimpleValist(string field, void* varargs);
	
	/**
	 * Determines if caps represents any media format.
	 * Returns: TRUE if caps represents any format.
	 */
	public int isAny();
	
	/**
	 * Determines if caps represents no media formats.
	 * Returns: TRUE if caps represents no formats.
	 */
	public int isEmpty();
	
	/**
	 * Fixed GstCaps describe exactly one format, that is, they have exactly
	 * one structure, and each field in the structure describes a fixed type.
	 * Examples of non-fixed types are GST_TYPE_INT_RANGE and GST_TYPE_LIST.
	 * Returns: TRUE if caps is fixed
	 */
	public int isFixed();
	
	/**
	 * Checks if the given caps represent the same set of caps.
	 * Note
	 * This function does not work reliably if optional properties for caps
	 * are included on one caps and omitted on the other.
	 * This function deals correctly with passing NULL for any of the caps.
	 * Params:
	 * caps2 =  another GstCaps
	 * Returns: TRUE if both caps are equal.
	 */
	public int isEqual(Caps caps2);
	
	/**
	 * Tests if two GstCaps are equal. This function only works on fixed
	 * GstCaps.
	 * Params:
	 * caps2 =  the GstCaps to test
	 * Returns: TRUE if the arguments represent the same format
	 */
	public int isEqualFixed(Caps caps2);
	
	/**
	 * A given GstCaps structure is always compatible with another if
	 * every media format that is in the first is also contained in the
	 * second. That is, caps1 is a subset of caps2.
	 * Params:
	 * caps2 =  the GstCaps to test
	 * Returns: TRUE if caps1 is a subset of caps2.
	 */
	public int isAlwaysCompatible(Caps caps2);
	
	/**
	 * Checks if all caps represented by subset are also represented by superset.
	 * Note
	 * This function does not work reliably if optional properties for caps
	 * are included on one caps and omitted on the other.
	 * Params:
	 * superset =  a potentially greater GstCaps
	 * Returns: TRUE if subset is a subset of superset
	 */
	public int isSubset(Caps superset);
	
	/**
	 * Creates a new GstCaps that contains all the formats that are common
	 * to both caps1 and caps2.
	 * Params:
	 * caps2 =  a GstCaps to intersect
	 * Returns: the new GstCaps
	 */
	public Caps intersect(Caps caps2);
	
	/**
	 * Creates a new GstCaps that contains all the formats that are in
	 * either caps1 and caps2.
	 * Params:
	 * caps2 =  a GstCaps to union
	 * Returns: the new GstCaps
	 */
	public Caps unio(Caps caps2);
	
	/**
	 * Creates a new GstCaps that represents the same set of formats as
	 * caps, but contains no lists. Each list is expanded into separate
	 * GstStructures.
	 * Returns: the new GstCaps
	 */
	public Caps normalize();
	
	/**
	 * Modifies the given caps inplace into a representation that represents the
	 * same set of formats, but in a simpler form. Component structures that are
	 * identical are merged. Component structures that have values that can be
	 * merged are also merged.
	 * Returns: TRUE, if the caps could be simplified
	 */
	public int doSimplify();
	
	/**
	 * Replaces *caps with newcaps. Unrefs the GstCaps in the location
	 * pointed to by caps, if applicable, then modifies caps to point to
	 * newcaps. An additional ref on newcaps is taken.
	 * This function does not take any locks so you might want to lock
	 * the object owning caps pointer.
	 * Params:
	 * caps =  a pointer to GstCaps
	 * newcaps =  a GstCaps to replace *caps
	 */
	public static void replace(GstCaps** caps, Caps newcaps);
	
	/**
	 * Converts caps to a string representation. This string representation
	 * can be converted back to a GstCaps by gst_caps_from_string().
	 * Returns: a newly allocated string representing caps.
	 */
	public string toString();
	
	/**
	 * Converts caps from a string representation.
	 * Params:
	 * string =  a string to convert to GstCaps
	 * Returns: a newly allocated GstCaps
	 */
	public static Caps fromString(string string);
	
	/**
	 * Subtracts the subtrahend from the minuend.
	 * Note
	 * This function does not work reliably if optional properties for caps
	 * are included on one caps and omitted on the other.
	 * Params:
	 * subtrahend =  GstCaps to substract
	 * Returns: the resulting caps
	 */
	public Caps subtract(Caps subtrahend);
	
	/**
	 * Returns a writable copy of caps.
	 * If there is only one reference count on caps, the caller must be the owner,
	 * and so this function will return the caps object unchanged. If on the other
	 * hand there is more than one reference on the object, a new caps object will
	 * be returned. The caller's reference on caps will be removed, and instead the
	 * caller will own a reference to the returned object.
	 * In short, this function unrefs the caps in the argument and refs the caps
	 * that it returns. Don't access the argument after calling this function. See
	 * also: gst_caps_ref().
	 * Returns: the same GstCaps object.
	 */
	public Caps makeWritable();
	
	/**
	 * Add a reference to a GstCaps object.
	 * From this point on, until the caller calls gst_caps_unref() or
	 * gst_caps_make_writable(), it is guaranteed that the caps object will not
	 * change. This means its structures won't change, etc. To use a GstCaps
	 * object, you must always have a refcount on it -- either the one made
	 * implicitly by gst_caps_new(), or via taking one explicitly with this
	 * function.
	 * Returns: the same GstCaps object.
	 */
	public Caps doref();
	
	/**
	 * Destructively discard all but the first structure from caps. Useful when
	 * fixating. caps must be writable.
	 */
	public void truncate();
	
	/**
	 * Unref a GstCaps and and free all its structures and the
	 * structures' values when the refcount reaches 0.
	 */
	public void unref();
}
