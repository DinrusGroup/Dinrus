module gtkD.glib.SequenceIter;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Sequence;




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
public class SequenceIter
{
	
	/** the main Gtk struct */
	protected GSequenceIter* gSequenceIter;
	
	
	public GSequenceIter* getSequenceIterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSequenceIter* gSequenceIter);
	
	/**
	 */
	
	/**
	 * Returns whether iter is the begin iterator
	 * Since 2.14
	 * Returns: whether iter is the begin iterator
	 */
	public int isBegin();
	
	/**
	 * Returns whether iter is the end iterator
	 * Since 2.14
	 * Returns: Whether iter is the end iterator.
	 */
	public int isEnd();
	
	/**
	 * Returns an iterator pointing to the next position after iter. If
	 * iter is the end iterator, the end iterator is returned.
	 * Since 2.14
	 * Returns: a GSequenceIter pointing to the next position after iter.
	 */
	public SequenceIter next();
	
	/**
	 * Returns an iterator pointing to the previous position before iter. If
	 * iter is the begin iterator, the begin iterator is returned.
	 * Since 2.14
	 * Returns: a GSequenceIter pointing to the previous position beforeiter.
	 */
	public SequenceIter prev();
	
	/**
	 * Returns the position of iter
	 * Since 2.14
	 * Returns: the position of iter
	 */
	public int getPosition();
	
	/**
	 * Returns the GSequenceIter which is delta positions away from iter.
	 * If iter is closer than -delta positions to the beginning of the sequence,
	 * the begin iterator is returned. If iter is closer than delta positions
	 * to the end of the sequence, the end iterator is returned.
	 * Since 2.14
	 * Params:
	 * delta =  A positive or negative number indicating how many positions away
	 *  from iter the returned GSequenceIter will be.
	 * Returns: a GSequenceIter which is delta positions away from iter.
	 */
	public SequenceIter move(int delta);
	
	/**
	 * Returns the GSequence that iter points into.
	 * Since 2.14
	 * Returns: the GSequence that iter points into.
	 */
	public Sequence getSequence();
	
	/**
	 * Returns a negative number if a comes before b, 0 if they are equal,
	 * and a positive number if a comes after b.
	 * The a and b iterators must point into the same sequence.
	 * Since 2.14
	 * Params:
	 * a =  a GSequenceIter
	 * b =  a GSequenceIter
	 * Returns: A negative number if a comes before b, 0 if they areequal, and a positive number if a comes after b.
	 */
	public int compare(SequenceIter b);
}
