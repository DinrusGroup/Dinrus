module gtkD.glib.ListG;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * The GList structure and its associated functions provide a standard
 * doubly-linked list data structure.
 * Each element in the list contains a piece of data, together with pointers
 * which link to the previous and next elements in the list.
 * Using these pointers it is possible to move through the list in both
 * directions (unlike the
 * Singly-Linked Lists
 * which only allows movement through the list in the forward direction).
 * The data contained in each element can be either integer values, by using one
 * of the
 * Type Conversion Macros,
 * or simply pointers to any type of data.
 * List elements are allocated from the slice
 * allocator, which is more efficient than allocating elements
 * individually.
 * Note that most of the GList functions expect to be passed a pointer to
 * the first element in the list. The functions which insert elements return
 * the new start of the list, which may have changed.
 * There is no function to create a GList. NULL is considered to be the empty
 * list so you simply set a GList* to NULL.
 * To add elements, use g_list_append(), g_list_prepend(), g_list_insert()
 * and g_list_insert_sorted().
 * To remove elements, use g_list_remove().
 * To find elements in the list use g_list_first(), g_list_last(), g_list_next(),
 * g_list_previous(), g_list_nth(), g_list_nth_data(), g_list_find() and
 * g_list_find_custom().
 * To find the index of an element use g_list_position() and g_list_index().
 * To call a function for each element in the list use g_list_foreach().
 * To free the entire list, use g_list_free().
 */
public class ListG
{
	
	/** the main Gtk struct */
	protected GList* gList;
	
	
	public GList* getListGStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GList* gList);
	
	/** */
	void* data();
	
	/**
	 * get the next element
	 * Returns: the next element, or NULL if there are no more elements.
	 */
	ListG next();
	
	/**
	 * get the previous element
	 * Returns: the previous element, or NULL if there are no more elements.
	 */
	ListG previous();
	
	/**
	 */
	
	/**
	 * Adds a new element on to the end of the list.
	 * Note
	 * The return value is the new start of the list, which
	 * may have changed, so make sure you store the new value.
	 * Note
	 * Note that g_list_append() has to traverse the entire list
	 * to find the end, which is inefficient when adding multiple
	 * elements. A common idiom to avoid the inefficiency is to prepend
	 * the elements and reverse the list when all elements have been added.
	 * /+* Notice that these are initialized to the empty list. +/
	 * GList *list = NULL, *number_list = NULL;
	 * /+* This is a list of strings. +/
	 * list = g_list_append (list, "first");
	 * list = g_list_append (list, "second");
	 * /+* This is a list of integers. +/
	 * number_list = g_list_append (number_list, GINT_TO_POINTER (27));
	 * number_list = g_list_append (number_list, GINT_TO_POINTER (14));
	 * Params:
	 * data =  the data for the new element
	 * Returns: the new start of the GList
	 */
	public ListG append(void* data);
	
	/**
	 * Adds a new element on to the start of the list.
	 * Note
	 * The return value is the new start of the list, which
	 * may have changed, so make sure you store the new value.
	 * /+* Notice that it is initialized to the empty list. +/
	 * GList *list = NULL;
	 * list = g_list_prepend (list, "last");
	 * list = g_list_prepend (list, "first");
	 * Params:
	 * data =  the data for the new element
	 * Returns: the new start of the GList
	 */
	public ListG prepend(void* data);
	
	/**
	 * Inserts a new element into the list at the given position.
	 * Params:
	 * data =  the data for the new element
	 * position =  the position to insert the element. If this is
	 *  negative, or is larger than the number of elements in the
	 *  list, the new element is added on to the end of the list.
	 * Returns: the new start of the GList
	 */
	public ListG insert(void* data, int position);
	
	/**
	 * Inserts a new element into the list before the given position.
	 * Params:
	 * sibling =  the list element before which the new element
	 *  is inserted or NULL to insert at the end of the list
	 * data =  the data for the new element
	 * Returns: the new start of the GList
	 */
	public ListG insertBefore(ListG sibling, void* data);
	
	/**
	 * Inserts a new element into the list, using the given comparison
	 * function to determine its position.
	 * Params:
	 * data =  the data for the new element
	 * func =  the function to compare elements in the list. It should
	 *  return a number > 0 if the first parameter comes after the
	 *  second parameter in the sort order.
	 * Returns: the new start of the GList
	 */
	public ListG insertSorted(void* data, GCompareFunc func);
	
	/**
	 * Removes an element from a GList.
	 * If two elements contain the same data, only the first is removed.
	 * If none of the elements contain the data, the GList is unchanged.
	 * Params:
	 * data =  the data of the element to remove
	 * Returns: the new start of the GList
	 */
	public ListG remove(void* data);
	
	/**
	 * Removes an element from a GList, without freeing the element.
	 * The removed element's prev and next links are set to NULL, so
	 * that it becomes a self-contained list with one element.
	 * Params:
	 * llink =  an element in the GList
	 * Returns: the new start of the GList, without the element
	 */
	public ListG removeLink(ListG llink);
	
	/**
	 * Removes the node link_ from the list and frees it.
	 * Compare this to g_list_remove_link() which removes the node
	 * without freeing it.
	 * Params:
	 * link =  node to delete from list
	 * Returns: the new head of list
	 */
	public ListG deleteLink(ListG link);
	
	/**
	 * Removes all list nodes with data equal to data.
	 * Returns the new head of the list. Contrast with
	 * g_list_remove() which removes only the first node
	 * matching the given data.
	 * Params:
	 * data =  data to remove
	 * Returns: new head of list
	 */
	public ListG removeAll(void* data);
	
	/**
	 * Frees all of the memory used by a GList.
	 * The freed elements are returned to the slice allocator.
	 * Note
	 * If list elements contain dynamically-allocated memory,
	 * they should be freed first.
	 */
	public void free();
	
	/**
	 * Allocates space for one GList element.
	 * It is called by g_list_append(), g_list_prepend(), g_list_insert() and
	 * g_list_insert_sorted() and so is rarely used on its own.
	 * Returns:a pointer to the newly-allocated GList element.
	 */
	public static ListG alloc();
	
	/**
	 * Frees one GList element.
	 * It is usually used after g_list_remove_link().
	 */
	public void free1();
	
	/**
	 * Gets the number of elements in a GList.
	 * Note
	 * This function iterates over the whole list to
	 * count its elements.
	 * Returns: the number of elements in the GList
	 */
	public uint length();
	
	/**
	 * Copies a GList.
	 * Note
	 * Note that this is a "shallow" copy. If the list elements
	 * consist of pointers to data, the pointers are copied but
	 * the actual data is not.
	 * Returns: a copy of list
	 */
	public ListG copy();
	
	/**
	 * Reverses a GList.
	 * It simply switches the next and prev pointers of each element.
	 * Returns: the start of the reversed GList
	 */
	public ListG reverse();
	
	/**
	 * Sorts a GList using the given comparison function.
	 * Params:
	 * compareFunc =  the comparison function used to sort the GList.
	 *  This function is passed the data from 2 elements of the GList
	 *  and should return 0 if they are equal, a negative value if the
	 *  first element comes before the second, or a positive value if
	 *  the first element comes after the second.
	 * Returns: the start of the sorted GList
	 */
	public ListG sort(GCompareFunc compareFunc);
	
	/**
	 * Inserts a new element into the list, using the given comparison
	 * function to determine its position.
	 * Since 2.10
	 * Params:
	 * data =  the data for the new element
	 * func =  the function to compare elements in the list.
	 *  It should return a number > 0 if the first parameter
	 *  comes after the second parameter in the sort order.
	 * userData =  user data to pass to comparison function.
	 * Returns: the new start of the GList
	 */
	public ListG insertSortedWithData(void* data, GCompareDataFunc func, void* userData);
	
	/**
	 * Like g_list_sort(), but the comparison function accepts
	 * a user data argument.
	 * Params:
	 * compareFunc =  comparison function
	 * userData =  user data to pass to comparison function
	 * Returns: the new head of list
	 */
	public ListG sortWithData(GCompareDataFunc compareFunc, void* userData);
	
	/**
	 * Adds the second GList onto the end of the first GList.
	 * Note that the elements of the second GList are not copied.
	 * They are used directly.
	 * Params:
	 * list2 =  the GList to add to the end of the first GList
	 * Returns: the start of the new GList
	 */
	public ListG concat(ListG list2);
	
	/**
	 * Calls a function for each element of a GList.
	 * Params:
	 * func =  the function to call with each element's data
	 * userData =  user data to pass to the function
	 */
	public void foreac(GFunc func, void* userData);
	
	/**
	 * Gets the first element in a GList.
	 * Returns: the first element in the GList,  or NULL if the GList has no elements
	 */
	public ListG first();
	
	/**
	 * Gets the last element in a GList.
	 * Returns: the last element in the GList,  or NULL if the GList has no elements
	 */
	public ListG last();
	
	/**
	 * Gets the element at the given position in a GList.
	 * Params:
	 * n =  the position of the element, counting from 0
	 * Returns: the element, or NULL if the position is off  the end of the GList
	 */
	public ListG nth(uint n);
	
	/**
	 * Gets the data of the element at the given position.
	 * Params:
	 * n =  the position of the element
	 * Returns: the element's data, or NULL if the position  is off the end of the GList
	 */
	public void* nthData(uint n);
	
	/**
	 * Gets the element n places before list.
	 * Params:
	 * n =  the position of the element, counting from 0
	 * Returns: the element, or NULL if the position is  off the end of the GList
	 */
	public ListG nthPrev(uint n);
	
	/**
	 * Finds the element in a GList which
	 * contains the given data.
	 * Params:
	 * data =  the element data to find
	 * Returns: the found GList element,  or NULL if it is not found
	 */
	public ListG find(void* data);
	
	/**
	 * Finds an element in a GList, using a supplied function to
	 * find the desired element. It iterates over the list, calling
	 * the given function which should return 0 when the desired
	 * element is found. The function takes two gconstpointer arguments,
	 * the GList element's data as the first argument and the
	 * given user data.
	 * Params:
	 * data =  user data passed to the function
	 * func =  the function to call for each element.
	 *  It should return 0 when the desired element is found
	 * Returns: the found GList element, or NULL if it is not found
	 */
	public ListG findCustom(void* data, GCompareFunc func);
	
	/**
	 * Gets the position of the given element
	 * in the GList (starting from 0).
	 * Params:
	 * llink =  an element in the GList
	 * Returns: the position of the element in the GList,  or -1 if the element is not found
	 */
	public int position(ListG llink);
	
	/**
	 * Gets the position of the element containing
	 * the given data (starting from 0).
	 * Params:
	 * data =  the data to find
	 * Returns: the index of the element containing the data,  or -1 if the data is not found
	 */
	public int index(void* data);
	
	/**
	 * Warning
	 * g_list_push_allocator has been deprecated since version 2.10 and should not be used in newly-written code. It does nothing, since GList has been
	 * converted to the slice allocator
	 * Sets the allocator to use to allocate GList elements.
	 * Use g_list_pop_allocator() to restore the previous allocator.
	 * Note that this function is not available if GLib has been compiled
	 * with --disable-mem-pools
	 * Params:
	 * allocator = the GAllocator to use when allocating GList elements.
	 */
	public static void pushAllocator(void* allocator);
	
	/**
	 * Warning
	 * g_list_pop_allocator has been deprecated since version 2.10 and should not be used in newly-written code. It does nothing, since GList has been
	 * converted to the slice allocator
	 * Restores the previous GAllocator, used when allocating GList elements.
	 * Note that this function is not available if GLib has been compiled
	 * with --disable-mem-pools
	 */
	public static void popAllocator();
}
