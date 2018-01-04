module gtkD.gstreamer.TagList;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.Value;




/**
 * Description
 * List of tags and values used to describe media metadata.
 * Last reviewed on 2005-11-23 (0.9.5)
 */
public class TagList
{
	
	/** the main Gtk struct */
	protected GstTagList* gstTagList;
	
	
	public GstTagList* getTagListStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstTagList* gstTagList);
	
	/**
	 */
	
	/**
	 * Registers a new tag type for the use with GStreamer's type system. If a type
	 * with that name is already registered, that one is used.
	 * The old registration may have used a different type however. So don't rely
	 * on your supplied values.
	 * Important: if you do not supply a merge function the implication will be
	 * that there can only be one single value for this tag in a tag list and
	 * any additional values will silenty be discarded when being added (unless
	 * GST_TAG_MERGE_REPLACE, GST_TAG_MERGE_REPLACE_ALL, or
	 * GST_TAG_MERGE_PREPEND is used as merge mode, in which case the new
	 * value will replace the old one in the list).
	 * The merge function will be called from gst_tag_list_copy_value() when
	 * it is required that one or more values for a tag be condensed into
	 * one single value. This may happen from gst_tag_list_get_string(),
	 * gst_tag_list_get_int(), gst_tag_list_get_double() etc. What will happen
	 * exactly in that case depends on how the tag was registered and if a
	 * merge function was supplied and if so which one.
	 * Two default merge functions are provided: gst_tag_merge_use_first() and
	 * gst_tag_merge_strings_with_commas().
	 * Params:
	 * name =  the name or identifier string
	 * flag =  a flag describing the type of tag info
	 * type =  the type this data is in
	 * nick =  human-readable name
	 * blurb =  a human-readable description about this tag
	 * func =  function for merging multiple values of this tag, or NULL
	 */
	public static void register(string name, GstTagFlag flag, GType type, string nick, string blurb, GstTagMergeFunc func);
	
	/**
	 * This is a convenience function for the func argument of gst_tag_register().
	 * It creates a copy of the first value from the list.
	 * Params:
	 * dest =  uninitialized GValue to store result in
	 * src =  GValue to copy from
	 */
	public static void mergeUseFirst(Value dest, Value src);
	
	/**
	 * This is a convenience function for the func argument of gst_tag_register().
	 * It concatenates all given strings using a comma. The tag must be registered
	 * as a G_TYPE_STRING or this function will fail.
	 * Params:
	 * dest =  uninitialized GValue to store result in
	 * src =  GValue to copy from
	 */
	public static void mergeStringsWithComma(Value dest, Value src);
	
	/**
	 * Checks if the given type is already registered.
	 * Params:
	 * tag =  name of the tag
	 * Returns: TRUE if the type is already registered
	 */
	public static int exists(string tag);
	
	/**
	 * Gets the GType used for this tag.
	 * Params:
	 * tag =  the tag
	 * Returns: the GType of this tag
	 */
	public static GType getType(string tag);
	
	/**
	 * Returns the human-readable name of this tag, You must not change or free
	 * this string.
	 * Params:
	 * tag =  the tag
	 * Returns: the human-readable name of this tag
	 */
	public static string getNick(string tag);
	
	/**
	 * Returns the human-readable description of this tag, You must not change or
	 * free this string.
	 * Params:
	 * tag =  the tag
	 * Returns: the human-readable description of this tag
	 */
	public static string getDescription(string tag);
	
	/**
	 * Gets the flag of tag.
	 * Params:
	 * tag =  the tag
	 * Returns:the flag of this tag.
	 */
	public static GstTagFlag getFlag(string tag);
	
	/**
	 * Checks if the given tag is fixed. A fixed tag can only contain one value.
	 * Unfixed tags can contain lists of values.
	 * Params:
	 * tag =  tag to check
	 * Returns: TRUE, if the given tag is fixed.
	 */
	public static int isFixed(string tag);
	
	/**
	 * Creates a new empty GstTagList.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Checks if the given pointer is a taglist.
	 * Params:
	 * p =  Object that might be a taglist
	 * Returns: TRUE, if the given pointer is a taglist
	 */
	public static int gstIsTagList(void* p);
	
	/**
	 * Checks if the given taglist is empty.
	 * Returns: TRUE if the taglist is empty, otherwise FALSE.Since 0.10.11
	 */
	public int isEmpty();
	
	/**
	 * Copies a given GstTagList.
	 * Returns: copy of the given list
	 */
	public TagList copy();
	
	/**
	 * Inserts the tags of the second list into the first list using the given mode.
	 * Params:
	 * from =  list to merge from
	 * mode =  the mode to use
	 */
	public void insert(TagList from, GstTagMergeMode mode);
	
	/**
	 * Merges the two given lists into a new list. If one of the lists is NULL, a
	 * copy of the other is returned. If both lists are NULL, NULL is returned.
	 * Params:
	 * list2 =  second list to merge
	 * mode =  the mode to use
	 * Returns: the new list
	 */
	public TagList merge(TagList list2, GstTagMergeMode mode);
	
	/**
	 * Frees the given list and all associated values.
	 */
	public void free();
	
	/**
	 * Checks how many value are stored in this tag list for the given tag.
	 * Params:
	 * tag =  the tag to query
	 * Returns: The number of tags stored
	 */
	public uint getTagSize(string tag);
	
	/**
	 * Sets the values for the given tags using the specified mode.
	 * Params:
	 * list =  list to set tags in
	 * mode =  the mode to use
	 * tag =  tag
	 * varArgs =  tag / value pairs to set
	 */
	public void addValist(GstTagMergeMode mode, string tag, void* varArgs);
	
	/**
	 * Sets the GValues for the given tags using the specified mode.
	 * Params:
	 * list =  list to set tags in
	 * mode =  the mode to use
	 * tag =  tag
	 * varArgs =  tag / GValue pairs to set
	 */
	public void addValistValues(GstTagMergeMode mode, string tag, void* varArgs);
	
	/**
	 * Removes the given tag from the taglist.
	 * Params:
	 * tag =  tag to remove
	 */
	public void removeTag(string tag);
	
	/**
	 * Calls the given function for each tag inside the tag list. Note that if there
	 * is no tag, the function won't be called at all.
	 * Params:
	 * func =  function to be called for each tag
	 * userData =  user specified data
	 */
	public void foreac(GstTagForeachFunc func, void* userData);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * Returns: The GValue for the specified entry or NULL if the tag wasn't available or the tag doesn't have as many entries
	 */
	public Value getValueIndex(string tag, uint index);
	
	/**
	 * Copies the contents for the given tag into the value,
	 * merging multiple values into one if multiple values are associated
	 * with the tag.
	 * You must g_value_unset() the value after use.
	 * Params:
	 * dest =  uninitialized GValue to copy into
	 * list =  list to get the tag from
	 * tag =  tag to read out
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public static int copyValue(Value dest, TagList list, string tag);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getChar(string tag, string value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getCharIndex(string tag, uint index, string value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getUchar(string tag, char* value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getUcharIndex(string tag, uint index, char* value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getBoolean(string tag, int* value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getBooleanIndex(string tag, uint index, int* value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getInt(string tag, int* value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getIntIndex(string tag, uint index, int* value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getUint(string tag, uint* value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getUintIndex(string tag, uint index, uint* value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getLong(string tag, int* value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getLongIndex(string tag, uint index, int* value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getUlong(string tag, uint* value);

	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getUlongIndex(string tag, uint index, uint* value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getInt64(string tag, long* value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getInt64_Index(string tag, uint index, long* value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getUint64(string tag, ulong* value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getUint64_Index(string tag, uint index, ulong* value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getFloat(string tag, float* value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getFloatIndex(string tag, uint index, float* value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getDouble(string tag, double* value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getDoubleIndex(string tag, uint index, double* value);
	
	/**
	 * Copies the contents for the given tag into the value, possibly merging
	 * multiple values into one if multiple values are associated with the tag.
	 * Use gst_tag_list_get_string_index (list, tag, 0, value) if you want
	 * to retrieve the first string associated with this tag unmodified.
	 * The resulting string in value should be freed by the caller using g_free
	 * when no longer needed
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getString(string tag, char** value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * The resulting string in value should be freed by the caller using g_free
	 * when no longer needed
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getStringIndex(string tag, uint index, char** value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getPointer(string tag, void** value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list.
	 */
	public int getPointerIndex(string tag, uint index, void** value);
	
	/**
	 * Copies the contents for the given tag into the value, merging multiple values
	 * into one if multiple values are associated with the tag.
	 * Params:
	 * tag =  tag to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list or if it was NULL.
	 */
	public int getDate(string tag, GDate** value);
	
	/**
	 * Gets the value that is at the given index for the given tag in the given
	 * list.
	 * Params:
	 * tag =  tag to read out
	 * index =  number of entry to read out
	 * value =  location for the result
	 * Returns: TRUE, if a value was copied, FALSE if the tag didn't exist in the given list or if it was NULL.
	 */
	public int getDateIndex(string tag, uint index, GDate** value);
}
