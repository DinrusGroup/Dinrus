module gtkD.glib.ByteArray;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * GByteArray is based on GArray, to provide arrays of bytes which grow
 * automatically as elements are added.
 * To create a new GByteArray use g_byte_array_new().
 * To add elements to a GByteArray, use g_byte_array_append(), and
 * g_byte_array_prepend().
 * To set the size of a GByteArray, use g_byte_array_set_size().
 * To free a GByteArray, use g_byte_array_free().
 * Example 22. Using a GByteArray
 *  GByteArray *gbarray;
 *  gint i;
 *  gbarray = g_byte_array_new ();
 *  for (i = 0; i < 10000; i++)
 *  g_byte_array_append (gbarray, (guint8*) "abcd", 4);
 *  for (i = 0; i < 10000; i++)
 *  {
	 *  g_assert (gbarray->data[4*i] == 'a');
	 *  g_assert (gbarray->data[4*i+1] == 'b');
	 *  g_assert (gbarray->data[4*i+2] == 'c');
	 *  g_assert (gbarray->data[4*i+3] == 'd');
 *  }
 *  g_byte_array_free (gbarray, TRUE);
 */
public class ByteArray
{
	
	/** the main Gtk struct */
	protected GByteArray* gByteArray;
	
	
	public GByteArray* getByteArrayStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GByteArray* gByteArray);
	
	/**
	 */
	
	/**
	 * Creates a new GByteArray with a reference count of 1.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GByteArray with reserved_size bytes preallocated. This
	 * avoids frequent reallocation, if you are going to add many bytes to
	 * the array. Note however that the size of the array is still 0.
	 * Params:
	 * reservedSize = number of bytes preallocated.
	 * Returns:the new GByteArray.
	 */
	public static ByteArray sizedNew(uint reservedSize);
	
	/**
	 * Atomically increments the reference count of array by one. This
	 * function is MT-safe and may be called from any thread.
	 * Since 2.22
	 * Returns: The passed in GByteArray.
	 */
	public ByteArray doref();
	
	/**
	 * Atomically decrements the reference count of array by one. If the
	 * reference count drops to 0, all memory allocated by the array is
	 * released. This function is MT-safe and may be called from any
	 * thread.
	 * Since 2.22
	 */
	public void unref();
	
	/**
	 * Adds the given bytes to the end of the GByteArray.
	 * The array will grow in size automatically if necessary.
	 * Params:
	 * data = the byte data to be added.
	 * Returns:the GByteArray.
	 */
	public ByteArray append(ubyte[] data);
	
	/**
	 * Adds the given data to the start of the GByteArray.
	 * The array will grow in size automatically if necessary.
	 * Params:
	 * data = the byte data to be added.
	 * Returns:the GByteArray.
	 */
	public ByteArray prepend(ubyte[] data);
	
	/**
	 * Removes the byte at the given index from a GByteArray.
	 * The following bytes are moved down one place.
	 * Params:
	 * index = the index of the byte to remove.
	 * Returns:the GByteArray.
	 */
	public ByteArray removeIndex(uint index);
	
	/**
	 * Removes the byte at the given index from a GByteArray.
	 * The last element in the array is used to fill in the space, so this function
	 * does not preserve the order of the GByteArray. But it is faster than
	 * g_byte_array_remove_index().
	 * Params:
	 * index = the index of the byte to remove.
	 * Returns:the GByteArray.
	 */
	public ByteArray removeIndexFast(uint index);
	
	/**
	 * Removes the given number of bytes starting at the given index from a
	 * GByteArray. The following elements are moved to close the gap.
	 * Since 2.4
	 * Params:
	 * index = the index of the first byte to remove.
	 * length = the number of bytes to remove.
	 * Returns:the GByteArray.
	 */
	public ByteArray removeRange(uint index, uint length);
	
	/**
	 * Sorts a byte array, using compare_func which should be a qsort()-style
	 * comparison function (returns less than zero for first arg is less than second
	 * arg, zero for equal, greater than zero if first arg is greater than second
	 * arg).
	 * If two array elements compare equal, their order in the sorted array is
	 * undefined.
	 * Params:
	 * compareFunc = comparison function.
	 */
	public void sort(GCompareFunc compareFunc);
	
	/**
	 * Like g_byte_array_sort(), but the comparison function takes an extra user data
	 * argument.
	 * Params:
	 * compareFunc = comparison function.
	 * userData = data to pass to compare_func.
	 */
	public void sortWithData(GCompareDataFunc compareFunc, void* userData);
	
	/**
	 * Sets the size of the GByteArray, expanding it if necessary.
	 * Params:
	 * length = the new size of the GByteArray.
	 * Returns:the GByteArray.
	 */
	public ByteArray setSize(uint length);
	
	/**
	 * Frees the memory allocated by the GByteArray.
	 * If free_segment is TRUE it frees the actual byte data. If the reference
	 * count of array is greater than one, the GByteArray wrapper is preserved but
	 * the size of array will be set to zero.
	 * Params:
	 * freeSegment = if TRUE the actual byte data is freed as well.
	 * Returns:the element data if free_segment is FALSE, otherwise NULL. The element data should be freed using g_free().
	 */
	public ubyte* free(int freeSegment);
}
