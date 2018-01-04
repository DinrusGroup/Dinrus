module gtkD.glib.QueueG;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;




/**
 * Description
 * The GQueue structure and its associated functions provide a standard
 * queue data structure. Internally, GQueue uses the same data structure as
 * GList to store elements.
 * The data contained in each element can be either integer values, by using one
 * of the
 * Type Conversion Macros,
 * or simply pointers to any type of data.
 * To create a new GQueue, use g_queue_new().
 * To initialize a statically-allocated GQueue, use G_QUEUE_INIT or
 * g_queue_init().
 * To add elements, use g_queue_push_head(), g_queue_push_head_link(),
 * g_queue_push_tail() and g_queue_push_tail_link().
 * To remove elements, use g_queue_pop_head() and g_queue_pop_tail().
 * To free the entire queue, use g_queue_free().
 */
public class QueueG
{
	
	/** the main Gtk struct */
	protected GQueue* gQueue;
	
	
	public GQueue* getQueueGStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GQueue* gQueue);
	
	/**
	 */
	
	/**
	 * Creates a new GQueue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Frees the memory allocated for the GQueue. Only call this function if
	 * queue was created with g_queue_new(). If queue elements contain
	 * dynamically-allocated memory, they should be freed first.
	 */
	public void free();
	
	/**
	 * A statically-allocated GQueue must be initialized with this function
	 * before it can be used. Alternatively you can initialize it with
	 * G_QUEUE_INIT. It is not necessary to initialize queues created with
	 * g_queue_new().
	 * Since 2.14
	 */
	public void init();
	
	/**
	 * Removes all the elements in queue. If queue elements contain
	 * dynamically-allocated memory, they should be freed first.
	 * Since 2.14
	 */
	public void clear();
	
	/**
	 * Returns TRUE if the queue is empty.
	 * Returns: TRUE if the queue is empty.
	 */
	public int isEmpty();
	
	/**
	 * Returns the number of items in queue.
	 * Since 2.4
	 * Returns: The number of items in queue.
	 */
	public uint getLength();
	
	/**
	 * Reverses the order of the items in queue.
	 * Since 2.4
	 */
	public void reverse();
	
	/**
	 * Copies a queue. Note that is a shallow copy. If the elements in the
	 * queue consist of pointers to data, the pointers are copied, but the
	 * actual data is not.
	 * Since 2.4
	 * Returns: A copy of queue
	 */
	public QueueG copy();
	
	/**
	 * Calls func for each element in the queue passing user_data to the
	 * function.
	 * Since 2.4
	 * Params:
	 * func =  the function to call for each element's data
	 * userData =  user data to pass to func
	 */
	public void foreac(GFunc func, void* userData);
	
	/**
	 * Finds the first link in queue which contains data.
	 * Since 2.4
	 * Params:
	 * data =  data to find
	 * Returns: The first link in queue which contains data.
	 */
	public ListG find(void* data);
	
	/**
	 * Finds an element in a GQueue, using a supplied function to find the
	 * desired element. It iterates over the queue, calling the given function
	 * which should return 0 when the desired element is found. The function
	 * takes two gconstpointer arguments, the GQueue element's data as the
	 * first argument and the given user data as the second argument.
	 * Since 2.4
	 * Params:
	 * data =  user data passed to func
	 * func =  a GCompareFunc to call for each element. It should return 0
	 * when the desired element is found
	 * Returns: The found link, or NULL if it wasn't found
	 */
	public ListG findCustom(void* data, GCompareFunc func);
	
	/**
	 * Sorts queue using compare_func.
	 * Since 2.4
	 * Params:
	 * compareFunc =  the GCompareDataFunc used to sort queue. This function
	 *  is passed two elements of the queue and should return 0 if they are
	 *  equal, a negative value if the first comes before the second, and
	 *  a positive value if the second comes before the first.
	 * userData =  user data passed to compare_func
	 */
	public void sort(GCompareDataFunc compareFunc, void* userData);
	
	/**
	 * Adds a new element at the head of the queue.
	 * Params:
	 * data =  the data for the new element.
	 */
	public void pushHead(void* data);
	
	/**
	 * Adds a new element at the tail of the queue.
	 * Params:
	 * data =  the data for the new element.
	 */
	public void pushTail(void* data);
	
	/**
	 * Inserts a new element into queue at the given position
	 * Since 2.4
	 * Params:
	 * data =  the data for the new element
	 * n =  the position to insert the new element. If n is negative or
	 *  larger than the number of elements in the queue, the element is
	 *  added to the end of the queue.
	 */
	public void pushNth(void* data, int n);
	
	/**
	 * Removes the first element of the queue.
	 * Returns: the data of the first element in the queue, or NULL if the queue is empty.
	 */
	public void* popHead();
	
	/**
	 * Removes the last element of the queue.
	 * Returns: the data of the last element in the queue, or NULL if the queue is empty.
	 */
	public void* popTail();
	
	/**
	 * Removes the n'th element of queue.
	 * Since 2.4
	 * Params:
	 * n =  the position of the element.
	 * Returns: the element's data, or NULL if n is off the end of queue.
	 */
	public void* popNth(uint n);
	
	/**
	 * Returns the first element of the queue.
	 * Returns: the data of the first element in the queue, or NULL if the queue is empty.
	 */
	public void* peekHead();
	
	/**
	 * Returns the last element of the queue.
	 * Returns: the data of the last element in the queue, or NULL if the queue is empty.
	 */
	public void* peekTail();
	
	/**
	 * Returns the n'th element of queue.
	 * Since 2.4
	 * Params:
	 * n =  the position of the element.
	 * Returns: The data for the n'th element of queue, or NULL if n is off the end of queue.
	 */
	public void* peekNth(uint n);
	
	/**
	 * Returns the position of the first element in queue which contains data.
	 * Since 2.4
	 * Params:
	 * data =  the data to find.
	 * Returns: The position of the first element in queue which contains data, or -1 if no element in queue contains data.
	 */
	public int index(void* data);
	
	/**
	 * Removes the first element in queue that contains data.
	 * Since 2.4
	 * Params:
	 * data =  data to remove.
	 */
	public void remove(void* data);
	
	/**
	 * Remove all elemeents in queue which contains data.
	 * Since 2.4
	 * Params:
	 * data =  data to remove
	 */
	public void removeAll(void* data);
	
	/**
	 * Inserts data into queue before sibling.
	 * sibling must be part of queue.
	 * Since 2.4
	 * Params:
	 * sibling =  a GList link that must be part of queue
	 * data =  the data to insert
	 */
	public void insertBefore(ListG sibling, void* data);
	
	/**
	 * Inserts data into queue after sibling
	 * sibling must be part of queue
	 * Since 2.4
	 * Params:
	 * sibling =  a GList link that must be part of queue
	 * data =  the data to insert
	 */
	public void insertAfter(ListG sibling, void* data);
	
	/**
	 * Inserts data into queue using func to determine the new position.
	 * Since 2.4
	 * Params:
	 * data =  the data to insert
	 * func =  the GCompareDataFunc used to compare elements in the queue. It is
	 *  called with two elements of the queue and user_data. It should
	 *  return 0 if the elements are equal, a negative value if the first
	 *  element comes before the second, and a positive value if the second
	 *  element comes before the first.
	 * userData =  user data passed to func.
	 */
	public void insertSorted(void* data, GCompareDataFunc func, void* userData);
	
	/**
	 * Adds a new element at the head of the queue.
	 * Params:
	 * link =  a single GList element, not a list with
	 *  more than one element.
	 */
	public void pushHeadLink(ListG link);
	
	/**
	 * Adds a new element at the tail of the queue.
	 * Params:
	 * link =  a single GList element, not a list with
	 *  more than one element.
	 */
	public void pushTailLink(ListG link);
	
	/**
	 * Inserts link into queue at the given position.
	 * Since 2.4
	 * Params:
	 * n =  the position to insert the link. If this is negative or larger than
	 *  the number of elements in queue, the link is added to the end of
	 *  queue.
	 * link =  the link to add to queue
	 */
	public void pushNthLink(int n, ListG link);
	
	/**
	 * Removes the first element of the queue.
	 * Returns: the GList element at the head of the queue, or NULL if the queue is empty.
	 */
	public ListG popHeadLink();
	
	/**
	 * Removes the last element of the queue.
	 * Returns: the GList element at the tail of the queue, or NULL if the queue is empty.
	 */
	public ListG popTailLink();
	
	/**
	 * Removes and returns the link at the given position.
	 * Since 2.4
	 * Params:
	 * n =  the link's position
	 * Returns: The n'th link, or NULL if n is off the end of queue.
	 */
	public ListG popNthLink(uint n);
	
	/**
	 * Returns the first link in queue
	 * Since 2.4
	 * Returns: the first link in queue, or NULL if queue is empty
	 */
	public ListG peekHeadLink();
	
	/**
	 * Returns the last link queue.
	 * Since 2.4
	 * Returns: the last link in queue, or NULL if queue is empty
	 */
	public ListG peekTailLink();
	
	/**
	 * Returns the link at the given position
	 * Since 2.4
	 * Params:
	 * n =  the position of the link
	 * Returns: The link at the n'th position, or NULL if n is off theend of the list
	 */
	public ListG peekNthLink(uint n);
	
	/**
	 * Returns the position of link_ in queue.
	 * Since 2.4
	 * Params:
	 * link =  A GList link
	 * Returns: The position of link_, or -1 if the link isnot part of queue
	 */
	public int linkIndex(ListG link);
	
	/**
	 * Unlinks link_ so that it will no longer be part of queue. The link is
	 * not freed.
	 * link_ must be part of queue,
	 * Since 2.4
	 * Params:
	 * link =  a GList link that must be part of queue
	 */
	public void unlink(ListG link);
	
	/**
	 * Removes link_ from queue and frees it.
	 * link_ must be part of queue.
	 * Since 2.4
	 * Params:
	 * link =  a GList link that must be part of queue
	 */
	public void deleteLink(ListG link);
}
