module gtkD.glib.ArrayG;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * Arrays are similar to standard C arrays, except that they grow automatically
 * as elements are added.
 * Array elements can be of any size (though all elements of one array are the
 * same size), and the array can be automatically cleared to '0's and
 * zero-terminated.
 * To create a new array use g_array_new().
 * To add elements to an array, use g_array_append_val(), g_array_append_vals(),
 * g_array_prepend_val(), and g_array_prepend_vals().
 * To access an element of an array, use g_array_index().
 * To set the size of an array, use g_array_set_size().
 * To free an array, use g_array_free().
 * Example 19. Using a GArray to store gint values
 *  GArray *garray;
 *  gint i;
 *  /+* We create a new array to store gint values.
 *  We don't want it zero-terminated or cleared to 0's. +/
 *  garray = g_array_new (FALSE, FALSE, sizeof (gint));
 *  for (i = 0; i < 10000; i++)
 *  g_array_append_val (garray, i);
 *  for (i = 0; i < 10000; i++)
 *  if (g_array_index (garray, gint, i) != i)
 *  g_print ("ERROR: got %d instead of %d\n",
 *  g_array_index (garray, gint, i), i);
 *  g_array_free (garray, TRUE);
 */
public class ArrayG
{
	
	/** the main Gtk struct */
	protected GArray* gArray;
	
	
	public GArray* getArrayGStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GArray* gArray);
	
	/**
	 */
	
	/**
	 * Creates a new GArray with a reference count of 1.
	 * Params:
	 * zeroTerminated = %TRUE if the array should have an extra element at the end
	 * which is set to 0.
	 * clear = %TRUE if GArray elements should be automatically cleared to 0
	 * when they are allocated.
	 * elementSize = the size of each element in bytes.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int zeroTerminated, int clear, uint elementSize);
	
	/**
	 * Creates a new GArray with reserved_size elements
	 * preallocated and a reference count of 1. This avoids frequent reallocation,
	 * if you are going to add many elements to the array. Note however that the
	 * size of the array is still 0.
	 * Params:
	 * zeroTerminated = %TRUE if the array should have an extra element at the end with all bits cleared.
	 * clear = %TRUE if all bits in the array should be cleared to 0 on allocation.
	 * elementSize = size of each element in the array.
	 * reservedSize = number of elements preallocated.
	 * Returns:the new GArray.
	 */
	public static ArrayG sizedNew(int zeroTerminated, int clear, uint elementSize, uint reservedSize);
	
	/**
	 * Atomically increments the reference count of array by one. This
	 * function is MT-safe and may be called from any thread.
	 * Since 2.22
	 * Returns: The passed in GArray.
	 */
	public ArrayG doref();
	
	/**
	 * Atomically decrements the reference count of array by one. If the
	 * reference count drops to 0, all memory allocated by the array is
	 * released. This function is MT-safe and may be called from any
	 * thread.
	 * Since 2.22
	 */
	public void unref();
	
	/**
	 * Gets the size of the elements in array.
	 * Since 2.22
	 * Returns: Size of each element, in bytes.
	 */
	public uint getElementSize();
	
	/**
	 * Adds len elements onto the end of the array.
	 * Params:
	 * data = a pointer to the elements to append to the end of the array.
	 * len = the number of elements to append.
	 * Returns:the GArray.
	 */
	public ArrayG appendVals(void* data, uint len);
	
	/**
	 * Adds len elements onto the start of the array.
	 * This operation is slower than g_array_append_vals() since the existing elements
	 * in the array have to be moved to make space for the new elements.
	 * Params:
	 * data = a pointer to the elements to prepend to the start of the array.
	 * len = the number of elements to prepend.
	 * Returns:the GArray.
	 */
	public ArrayG prependVals(void* data, uint len);
	
	/**
	 * Inserts len elements into a GArray at the given index.
	 * Params:
	 * index = the index to place the elements at.
	 * data = a pointer to the elements to insert.
	 * len = the number of elements to insert.
	 * Returns:the GArray.
	 */
	public ArrayG insertVals(uint index, void* data, uint len);
	
	/**
	 * Removes the element at the given index from a GArray.
	 * The following elements are moved down one place.
	 * Params:
	 * index = the index of the element to remove.
	 * Returns:the GArray.
	 */
	public ArrayG removeIndex(uint index);
	
	/**
	 * Removes the element at the given index from a GArray.
	 * The last element in the array is used to fill in the space, so this function
	 * does not preserve the order of the GArray. But it is faster than
	 * g_array_remove_index().
	 * Params:
	 * index = the index of the element to remove.
	 * Returns:the GArray.
	 */
	public ArrayG removeIndexFast(uint index);
	
	/**
	 * Removes the given number of elements starting at the given index from a
	 * GArray. The following elements are moved to close the gap.
	 * Since 2.4
	 * Params:
	 * index = the index of the first element to remove.
	 * length = the number of elements to remove.
	 * Returns:the GArray.
	 */
	public ArrayG removeRange(uint index, uint length);
	
	/**
	 * Sorts a GArray using compare_func which should be a qsort()-style comparison
	 * function (returns less than zero for first arg is less than second arg,
	 * zero for equal, greater zero if first arg is greater than second arg).
	 * If two array elements compare equal, their order in the sorted array is
	 * undefined.
	 * Params:
	 * compareFunc = comparison function.
	 */
	public void sort(GCompareFunc compareFunc);
	
	/**
	 * Like g_array_sort(), but the comparison function receives an extra user data
	 * argument.
	 * Params:
	 * compareFunc = comparison function.
	 * userData = data to pass to compare_func.
	 */
	public void sortWithData(GCompareDataFunc compareFunc, void* userData);
	
	/**
	 * Sets the size of the array, expanding it if necessary.
	 * If the array was created with clear_ set to TRUE, the new elements are set to 0.
	 * Params:
	 * length = the new size of the GArray.
	 * Returns:the GArray.
	 */
	public ArrayG setSize(uint length);
	
	/**
	 * Frees the memory allocated for the GArray.
	 * If free_segment is TRUE it frees the memory block holding the elements
	 * as well and also each element if array has a element_free_func set.
	 * Pass FALSE if you want to free the GArray wrapper but preserve
	 * the underlying array for use elsewhere. If the reference count of array
	 * is greater than one, the GArray wrapper is preserved but the size of
	 * array will be set to zero.
	 * Note
	 * If array elements contain dynamically-allocated memory, they should be freed
	 * separately.
	 * Params:
	 * freeSegment = if TRUE the actual element data is freed as well.
	 * Returns:the element data if free_segment is FALSE, otherwise NULL.	The element data should be freed using g_free().
	 */
	public string free(int freeSegment);
}
