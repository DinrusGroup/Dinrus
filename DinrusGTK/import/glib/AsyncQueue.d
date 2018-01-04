
module gtkD.glib.AsyncQueue;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.TimeVal;




/**
 * Description
 * Often you need to communicate between different threads. In general
 * it's safer not to do this by shared memory, but by explicit message
 * passing. These messages only make sense asynchronously for
 * multi-threaded applications though, as a synchronous operation could as
 * well be done in the same thread.
 * Asynchronous queues are an exception from most other GLib data
 * structures, as they can be used simultaneously from multiple threads
 * without explicit locking and they bring their own builtin reference
 * counting. This is because the nature of an asynchronous queue is that
 * it will always be used by at least 2 concurrent threads.
 * For using an asynchronous queue you first have to create one with
 * g_async_queue_new(). A newly-created queue will get the reference
 * count 1. Whenever another thread is creating a new reference of (that
 * is, pointer to) the queue, it has to increase the reference count
 * (using g_async_queue_ref()). Also, before removing this reference, the
 * reference count has to be decreased (using
 * g_async_queue_unref()). After that the queue might no longer exist so
 * you must not access it after that point.
 * A thread, which wants to send a message to that queue simply calls
 * g_async_queue_push() to push the message to the queue.
 * A thread, which is expecting messages from an asynchronous queue
 * simply calls g_async_queue_pop() for that queue. If no message is
 * available in the queue at that point, the thread is now put to sleep
 * until a message arrives. The message will be removed from the queue
 * and returned. The functions g_async_queue_try_pop() and
 * g_async_queue_timed_pop() can be used to only check for the presence
 * of messages or to only wait a certain time for messages respectively.
 * For almost every function there exist two variants, one that locks the
 * queue and one that doesn't. That way you can hold the queue lock
 * (acquire it with g_async_queue_lock() and release it with
 * g_async_queue_unlock()) over multiple queue accessing
 * instructions. This can be necessary to ensure the integrity of the
 * queue, but should only be used when really necessary, as it can make
 * your life harder if used unwisely. Normally you should only use the
 * locking function variants (those without the suffix _unlocked)
 */
public class AsyncQueue
{
	
	/** the main Gtk struct */
	protected GAsyncQueue* gAsyncQueue;
	
	
	public GAsyncQueue* getAsyncQueueStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GAsyncQueue* gAsyncQueue);
	
	/**
	 */
	
	/**
	 * Creates a new asynchronous queue with the initial reference count of 1.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new asynchronous queue with an initial reference count of 1 and
	 * sets up a destroy notify function that is used to free any remaining
	 * queue items when the queue is destroyed after the final unref.
	 * Since 2.16
	 * Params:
	 * itemFreeFunc =  function to free queue elements
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GDestroyNotify itemFreeFunc);
	
	/**
	 * Increases the reference count of the asynchronous queue by 1. You
	 * do not need to hold the lock to call this function.
	 * Returns: the queue that was passed in (since 2.6)
	 */
	public AsyncQueue doref();
	
	/**
	 * Decreases the reference count of the asynchronous queue by 1. If
	 * the reference count went to 0, the queue will be destroyed and the
	 * memory allocated will be freed. So you are not allowed to use the
	 * queue afterwards, as it might have disappeared. You do not need to
	 * hold the lock to call this function.
	 */
	public void unref();
	
	/**
	 * Pushes the data into the queue. data must not be NULL.
	 * Params:
	 * data =  data to push into the queue.
	 */
	public void push(void* data);
	
	/**
	 * Inserts data into queue using func to determine the new
	 * position.
	 * This function requires that the queue is sorted before pushing on
	 * new elements.
	 * This function will lock queue before it sorts the queue and unlock
	 * it when it is finished.
	 * For an example of func see g_async_queue_sort().
	 * Since 2.10
	 * Params:
	 * data =  the data to push into the queue
	 * func =  the GCompareDataFunc is used to sort queue. This function
	 *  is passed two elements of the queue. The function should return
	 *  0 if they are equal, a negative value if the first element
	 *  should be higher in the queue or a positive value if the first
	 *  element should be lower in the queue than the second element.
	 * userData =  user data passed to func.
	 */
	public void pushSorted(void* data, GCompareDataFunc func, void* userData);
	
	/**
	 * Pops data from the queue. This function blocks until data become
	 * available.
	 * Returns: data from the queue.
	 */
	public void* pop();
	
	/**
	 * Tries to pop data from the queue. If no data is available, NULL is
	 * returned.
	 * Returns: data from the queue or NULL, when no data isavailable immediately.
	 */
	public void* tryPop();
	
	/**
	 * Pops data from the queue. If no data is received before end_time,
	 * NULL is returned.
	 * To easily calculate end_time a combination of g_get_current_time()
	 * and g_time_val_add() can be used.
	 * Params:
	 * endTime =  a GTimeVal, determining the final time.
	 * Returns: data from the queue or NULL, when no data isreceived before end_time.
	 */
	public void* timedPop(TimeVal endTime);
	
	/**
	 * Returns the length of the queue, negative values mean waiting
	 * threads, positive values mean available entries in the
	 * queue. Actually this function returns the number of data items in
	 * the queue minus the number of waiting threads. Thus a return value
	 * of 0 could mean 'n' entries in the queue and 'n' thread waiting.
	 * That can happen due to locking of the queue or due to
	 * scheduling.
	 * Returns: the length of the queue.
	 */
	public int length();
	
	/**
	 * Sorts queue using func.
	 * This function will lock queue before it sorts the queue and unlock
	 * it when it is finished.
	 * If you were sorting a list of priority numbers to make sure the
	 * Since 2.10
	 * Params:
	 * func =  the GCompareDataFunc is used to sort queue. This
	 *  function is passed two elements of the queue. The function
	 *  should return 0 if they are equal, a negative value if the
	 *  first element should be higher in the queue or a positive
	 *  value if the first element should be lower in the queue than
	 *  the second element.
	 * userData =  user data passed to func
	 */
	public void sort(GCompareDataFunc func, void* userData);
	
	/**
	 * Acquires the queue's lock. After that you can only call the
	 * g_async_queue_*_unlocked() function variants on that
	 * queue. Otherwise it will deadlock.
	 */
	public void lock();
	
	/**
	 * Releases the queue's lock.
	 */
	public void unlock();

	/**
	 * Warning
	 * g_async_queue_ref_unlocked is deprecated and should not be used in newly-written code.
	 * Increases the reference count of the asynchronous queue by 1.
	 * Deprecated: Since 2.8, reference counting is done atomically
	 * so g_async_queue_ref() can be used regardless of the queue's
	 * lock.
	 */
	public void refUnlocked();
	
	/**
	 * Warning
	 * g_async_queue_unref_and_unlock is deprecated and should not be used in newly-written code.
	 * Decreases the reference count of the asynchronous queue by 1 and
	 * releases the lock. This function must be called while holding the
	 * queue's lock. If the reference count went to 0, the queue will be
	 * destroyed and the memory allocated will be freed.
	 * Deprecated: Since 2.8, reference counting is done atomically
	 * so g_async_queue_unref() can be used regardless of the queue's
	 * lock.
	 */
	public void unrefAndUnlock();
	
	/**
	 * Pushes the data into the queue. data must not be NULL. This
	 * function must be called while holding the queue's lock.
	 * Params:
	 * data =  data to push into the queue.
	 */
	public void pushUnlocked(void* data);
	
	/**
	 * Inserts data into queue using func to determine the new
	 * position.
	 * This function requires that the queue is sorted before pushing on
	 * new elements.
	 * This function is called while holding the queue's lock.
	 * For an example of func see g_async_queue_sort().
	 * Since 2.10
	 * Params:
	 * data =  the data to push into the queue
	 * func =  the GCompareDataFunc is used to sort queue. This function
	 *  is passed two elements of the queue. The function should return
	 *  0 if they are equal, a negative value if the first element
	 *  should be higher in the queue or a positive value if the first
	 *  element should be lower in the queue than the second element.
	 * userData =  user data passed to func.
	 */
	public void pushSortedUnlocked(void* data, GCompareDataFunc func, void* userData);
	
	/**
	 * Pops data from the queue. This function blocks until data become
	 * available. This function must be called while holding the queue's
	 * lock.
	 * Returns: data from the queue.
	 */
	public void* popUnlocked();

	/**
	 * Tries to pop data from the queue. If no data is available, NULL is
	 * returned. This function must be called while holding the queue's
	 * lock.
	 * Returns: data from the queue or NULL, when no data isavailable immediately.
	 */
	public void* tryPopUnlocked();
	
	/**
	 * Pops data from the queue. If no data is received before end_time,
	 * NULL is returned. This function must be called while holding the
	 * queue's lock.
	 * To easily calculate end_time a combination of g_get_current_time()
	 * and g_time_val_add() can be used.
	 * Params:
	 * endTime =  a GTimeVal, determining the final time.
	 * Returns: data from the queue or NULL, when no data isreceived before end_time.
	 */
	public void* timedPopUnlocked(TimeVal endTime);
	
	/**
	 * Returns the length of the queue, negative values mean waiting
	 * threads, positive values mean available entries in the
	 * queue. Actually this function returns the number of data items in
	 * the queue minus the number of waiting threads. Thus a return value
	 * of 0 could mean 'n' entries in the queue and 'n' thread waiting.
	 * That can happen due to locking of the queue or due to
	 * scheduling. This function must be called while holding the queue's
	 * lock.
	 * Returns: the length of the queue.
	 */
	public int lengthUnlocked();
	
	/**
	 * Sorts queue using func.
	 * This function is called while holding the queue's lock.
	 * Since 2.10
	 * Params:
	 * func =  the GCompareDataFunc is used to sort queue. This
	 *  function is passed two elements of the queue. The function
	 *  should return 0 if they are equal, a negative value if the
	 *  first element should be higher in the queue or a positive
	 *  value if the first element should be lower in the queue than
	 *  the second element.
	 * userData =  user data passed to func
	 */
	public void sortUnlocked(GCompareDataFunc func, void* userData);
}
