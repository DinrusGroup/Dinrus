module gtkD.glib.Sequence;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.SequenceIter;




/**
 * Description
 * The GSequence data structure has the API of a list, but is
 * implemented internally with a balanced binary tree. This means that it
 * is possible to maintain a sorted list of n elements in time O(n log
 * n). The data contained in each element can be either integer values, by
 * using of the
 * Type Conversion Macros,
 * or simply pointers to any type of data.
 * A GSequence is accessed through iterators,
 * represented by a GSequenceIter. An iterator represents a position
 * between two elements of the sequence. For example, the
 * begin iterator represents the gap immediately
 * before the first element of the sequence, and the
 * end iterator represents the gap immediately
 * after the last element. In an empty sequence, the begin and end
 * iterators are the same.
 * Some methods on GSequence operate on ranges of items. For example
 * g_sequence_foreach_range() will call a user-specified function on each
 * element with the given range. The range is delimited by the gaps
 * represented by the passed-in iterators, so if you pass in the begin
 * and end iterators, the range in question is the entire sequence.
 * The function g_sequence_get() is used with an iterator to access the
 * element immediately following the gap that the iterator
 * represents. The iterator is said to point to
 * that element.
 * Iterators are stable across most operations on a GSequence. For
 * example an iterator pointing to some element of a sequence will
 * continue to point to that element even after the sequence is
 * sorted. Even moving an element to another sequence using for example
 * g_sequence_move_range() will not invalidate the iterators pointing to
 * it. The only operation that will invalidate an iterator is when the
 * element it points to is removed from any sequence.
 */
public class Sequence
{
	
	/** the main Gtk struct */
	protected GSequence* gSequence;
	
	
	public GSequence* getSequenceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSequence* gSequence);
	
	/**
	 */
	
	/**
	 * Creates a new GSequence. The data_destroy function, if non-NULL will
	 * be called on all items when the sequence is destroyed and on items that
	 * are removed from the sequence.
	 * Since 2.14
	 * Params:
	 * dataDestroy =  a GDestroyNotify function, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GDestroyNotify dataDestroy);
	
	/**
	 * Frees the memory allocated for seq. If seq has a data destroy
	 * function associated with it, that function is called on all items in
	 * seq.
	 * Since 2.14
	 */
	public void free();
	
	/**
	 * Returns the length of seq
	 * Since 2.14
	 * Returns: the length of seq
	 */
	public int getLength();
	
	/**
	 * Calls func for each item in the sequence passing user_data
	 * to the function.
	 * Since 2.14
	 * Params:
	 * func =  the function to call for each item in seq
	 * userData =  user data passed to func
	 */
	public void foreac(GFunc func, void* userData);
	
	/**
	 * Calls func for each item in the range (begin, end) passing
	 * user_data to the function.
	 * Since 2.14
	 * Params:
	 * begin =  a GSequenceIter
	 * end =  a GSequenceIter
	 * func =  a GFunc
	 * userData =  user data passed to func
	 */
	public static void foreachRange(SequenceIter begin, SequenceIter end, GFunc func, void* userData);
	
	/**
	 * Sorts seq using cmp_func.
	 * Since 2.14
	 * Params:
	 * cmpFunc =  the GCompareDataFunc used to sort seq. This function is
	 *  passed two items of seq and should return 0 if they are equal,
	 *  a negative value if the first comes before the second, and a
	 *  positive value if the second comes before the first.
	 * cmpData =  user data passed to cmp_func
	 */
	public void sort(GCompareDataFunc cmpFunc, void* cmpData);
	
	/**
	 * Like g_sequence_sort(), but uses a GSequenceIterCompareFunc instead
	 * of a GCompareDataFunc as the compare function
	 * Since 2.14
	 * Params:
	 * cmpFunc =  the GSequenceItercompare used to compare iterators in the
	 *  sequence. It is called with two iterators pointing into seq. It should
	 *  return 0 if the iterators are equal, a negative value if the first
	 *  iterator comes before the second, and a positive value if the second
	 *  iterator comes before the first.
	 * cmpData =  user data passed to cmp_func
	 */
	public void sortIter(GSequenceIterCompareFunc cmpFunc, void* cmpData);
	
	/**
	 * Returns the begin iterator for seq.
	 * Since 2.14
	 * Returns: the begin iterator for seq.
	 */
	public SequenceIter getBeginIter();
	
	/**
	 * Returns the end iterator for seg
	 * Since 2.14
	 * Returns: the end iterator for seq
	 */
	public SequenceIter getEndIter();
	
	/**
	 * Returns the iterator at position pos. If pos is negative or larger
	 * than the number of items in seq, the end iterator is returned.
	 * Since 2.14
	 * Params:
	 * pos =  a position in seq, or -1 for the end.
	 * Returns: The GSequenceIter at position pos
	 */
	public SequenceIter getIterAtPos(int pos);
	
	/**
	 * Adds a new item to the end of seq.
	 * Since 2.14
	 * Params:
	 * data =  the data for the new item
	 * Returns: an iterator pointing to the new item
	 */
	public SequenceIter append(void* data);
	
	/**
	 * Adds a new item to the front of seq
	 * Since 2.14
	 * Params:
	 * data =  the data for the new item
	 * Returns: an iterator pointing to the new item
	 */
	public SequenceIter prepend(void* data);
	
	/**
	 * Inserts a new item just before the item pointed to by iter.
	 * Since 2.14
	 * Params:
	 * iter =  a GSequenceIter
	 * data =  the data for the new item
	 * Returns: an iterator pointing to the new item
	 */
	public static SequenceIter insertBefore(SequenceIter iter, void* data);
	
	/**
	 * Moves the item pointed to by src to the position indicated by dest.
	 * After calling this function dest will point to the position immediately
	 * after src. It is allowed for src and dest to point into different
	 * sequences.
	 * Since 2.14
	 * Params:
	 * src =  a GSequenceIter pointing to the item to move
	 * dest =  a GSequenceIter pointing to the position to which
	 *  the item is moved.
	 */
	public static void move(SequenceIter src, SequenceIter dest);
	
	/**
	 * Swaps the items pointed to by a and b. It is allowed for a and b
	 * to point into difference sequences.
	 * Since 2.14
	 * Params:
	 * a =  a GSequenceIter
	 * b =  a GSequenceIter
	 */
	public static void swap(SequenceIter a, SequenceIter b);
	
	/**
	 * Inserts data into sequence using func to determine the new position.
	 * The sequence must already be sorted according to cmp_func; otherwise the
	 * new position of data is undefined.
	 * Since 2.14
	 * Params:
	 * data =  the data to insert
	 * cmpFunc =  the GCompareDataFunc used to compare items in the sequence. It
	 *  is called with two items of the seq and user_data. It should
	 *  return 0 if the items are equal, a negative value if the first
	 *  item comes before the second, and a positive value if the second
	 *  item comes before the first.
	 * cmpData =  user data passed to cmp_func.
	 * Returns: a GSequenceIter pointing to the new item.
	 */
	public SequenceIter insertSorted(void* data, GCompareDataFunc cmpFunc, void* cmpData);
	
	/**
	 * Like g_sequence_insert_sorted(), but uses
	 * a GSequenceIterCompareFunc instead of a GCompareDataFunc as
	 * the compare function.
	 * Since 2.14
	 * Params:
	 * data =  data for the new item
	 * iterCmp =  the GSequenceItercompare used to compare iterators in the
	 *  sequence. It is called with two iterators pointing into seq. It should
	 *  return 0 if the iterators are equal, a negative value if the first
	 *  iterator comes before the second, and a positive value if the second
	 *  iterator comes before the first.
	 * cmpData =  user data passed to cmp_func
	 * Returns: a GSequenceIter pointing to the new item
	 */
	public SequenceIter insertSortedIter(void* data, GSequenceIterCompareFunc iterCmp, void* cmpData);
	
	/**
	 * Moves the data pointed to a new position as indicated by cmp_func. This
	 * function should be called for items in a sequence already sorted according
	 * to cmp_func whenever some aspect of an item changes so that cmp_func
	 * may return different values for that item.
	 * Since 2.14
	 * Params:
	 * iter =  A GSequenceIter
	 * cmpFunc =  the GCompareDataFunc used to compare items in the sequence. It
	 *  is called with two items of the seq and user_data. It should
	 *  return 0 if the items are equal, a negative value if the first
	 *  item comes before the second, and a positive value if the second
	 *  item comes before the first.
	 * cmpData =  user data passed to cmp_func.
	 */
	public static void sortChanged(SequenceIter iter, GCompareDataFunc cmpFunc, void* cmpData);
	
	/**
	 * Like g_sequence_sort_changed(), but uses
	 * a GSequenceIterCompareFunc instead of a GCompareDataFunc as
	 * the compare function.
	 * Since 2.14
	 * Params:
	 * iter =  a GSequenceIter
	 * iterCmp =  the GSequenceItercompare used to compare iterators in the
	 *  sequence. It is called with two iterators pointing into seq. It should
	 *  return 0 if the iterators are equal, a negative value if the first
	 *  iterator comes before the second, and a positive value if the second
	 *  iterator comes before the first.
	 * cmpData =  user data passed to cmp_func
	 */
	public static void sortChangedIter(SequenceIter iter, GSequenceIterCompareFunc iterCmp, void* cmpData);
	
	/**
	 * Removes the item pointed to by iter. It is an error to pass the
	 * end iterator to this function.
	 * If the sequnce has a data destroy function associated with it, this
	 * function is called on the data for the removed item.
	 * Since 2.14
	 * Params:
	 * iter =  a GSequenceIter
	 */
	public static void remove(SequenceIter iter);
	
	/**
	 * Removes all items in the (begin, end) range.
	 * If the sequence has a data destroy function associated with it, this
	 * function is called on the data for the removed items.
	 * Since 2.14
	 * Params:
	 * begin =  a GSequenceIter
	 * end =  a GSequenceIter
	 */
	public static void removeRange(SequenceIter begin, SequenceIter end);
	
	/**
	 * Inserts the (begin, end) range at the destination pointed to by ptr.
	 * The begin and end iters must point into the same sequence. It is
	 * allowed for dest to point to a different sequence than the one pointed
	 * into by begin and end.
	 * If dest is NULL, the range indicated by begin and end is
	 * removed from the sequence. If dest iter points to a place within
	 * the (begin, end) range, the range does not move.
	 * Since 2.14
	 * Params:
	 * dest =  a GSequenceIter
	 * begin =  a GSequenceIter
	 * end =  a GSequenceIter
	 */
	public static void moveRange(SequenceIter dest, SequenceIter begin, SequenceIter end);
	
	/**
	 * Returns an iterator pointing to the position where data would
	 * be inserted according to cmp_func and cmp_data.
	 * Since 2.14
	 * Params:
	 * data =  data for the new item
	 * cmpFunc =  the GCompareDataFunc used to compare items in the sequence. It
	 *  is called with two items of the seq and user_data. It should
	 *  return 0 if the items are equal, a negative value if the first
	 *  item comes before the second, and a positive value if the second
	 *  item comes before the first.
	 * cmpData =  user data passed to cmp_func.
	 * Returns: an GSequenceIter pointing to the position where datawould have been inserted according to cmp_func and cmp_data.
	 */
	public SequenceIter search(void* data, GCompareDataFunc cmpFunc, void* cmpData);
	
	/**
	 * Like g_sequence_search(), but uses
	 * a GSequenceIterCompareFunc instead of a GCompareDataFunc as
	 * the compare function.
	 * Since 2.14
	 * Params:
	 * data =  data for the new item
	 * iterCmp =  the GSequenceIterCompare function used to compare iterators
	 *  in the sequence. It is called with two iterators pointing into seq.
	 *  It should return 0 if the iterators are equal, a negative value if the
	 *  first iterator comes before the second, and a positive value if the
	 *  second iterator comes before the first.
	 * cmpData =  user data passed to iter_cmp
	 * Returns: a GSequenceIter pointing to the position in seqwhere data would have been inserted according to iter_cmp and cmp_data.
	 */
	public SequenceIter searchIter(void* data, GSequenceIterCompareFunc iterCmp, void* cmpData);
	
	/**
	 * Returns the data that iter points to.
	 * Since 2.14
	 * Params:
	 * iter =  a GSequenceIter
	 * Returns: the data that iter points to
	 */
	public static void* get(SequenceIter iter);
	
	/**
	 * Changes the data for the item pointed to by iter to be data. If
	 * the sequence has a data destroy function associated with it, that
	 * function is called on the existing data that iter pointed to.
	 * Since 2.14
	 * Params:
	 * iter =  a GSequenceIter
	 * data =  new data for the item
	 */
	public static void set(SequenceIter iter, void* data);
	
	/**
	 * Finds an iterator somewhere in the range (begin, end). This
	 * iterator will be close to the middle of the range, but is not
	 * guaranteed to be exactly in the middle.
	 * The begin and end iterators must both point to the same sequence and
	 * begin must come before or be equal to end in the sequence.
	 * Since 2.14
	 * Params:
	 * begin =  a GSequenceIter
	 * end =  a GSequenceIter
	 * Returns: A GSequenceIter pointing somewhere in the(begin, end) range.
	 */
	public static SequenceIter rangeGetMidpoint(SequenceIter begin, SequenceIter end);
}
