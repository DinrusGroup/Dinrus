module gtkD.gstreamer.Iterator;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * A GstIterator is used to retrieve multiple objects from another object in
 * a threadsafe way.
 * Various GStreamer objects provide access to their internal structures using
 * an iterator.
 * The basic use pattern of an iterator is as follows:
 * Example10.Using an iterator
 *  it = _get_iterator(object);
 *  done = FALSE;
 *  while (!done) {
	 *  switch (gst_iterator_next (it, item)) {
		 *  case GST_ITERATOR_OK:
		 *  ... use/change item here...
		 *  gst_object_unref (item);
		 *  break;
		 *  case GST_ITERATOR_RESYNC:
		 *  ...rollback changes to items...
		 *  gst_iterator_resync (it);
		 *  break;
		 *  case GST_ITERATOR_ERROR:
		 *  ...wrong parameter were given...
		 *  done = TRUE;
		 *  break;
		 *  case GST_ITERATOR_DONE:
		 *  done = TRUE;
		 *  break;
	 *  }
 *  }
 *  gst_iterator_free (it);
 * Last reviewed on 2005-11-09 (0.9.4)
 */
public class Iterator
{
	
	/** the main Gtk struct */
	protected GstIterator* gstIterator;
	
	
	public GstIterator* getIteratorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstIterator* gstIterator);
	
	/**
	 */
	
	/**
	 * Create a new iterator. This function is mainly used for objects
	 * implementing the next/resync/free function to iterate a data structure.
	 * For each item retrieved, the item function is called with the lock
	 * held. The free function is called when the iterator is freed.
	 * Params:
	 * size =  the size of the iterator structure
	 * type =  GType of children
	 * lock =  pointer to a GMutex.
	 * masterCookie =  pointer to a guint32 to protect the iterated object.
	 * next =  function to get next item
	 * item =  function to call on each item retrieved
	 * resync =  function to resync the iterator
	 * free =  function to free the iterator
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (uint size, GType type, GMutex* lock, uint* masterCookie, GstIteratorNextFunction next, GstIteratorItemFunction item, GstIteratorResyncFunction resync, GstIteratorFreeFunction free);
	
	/**
	 * Create a new iterator designed for iterating list.
	 * Params:
	 * type =  GType of elements
	 * lock =  pointer to a GMutex protecting the list.
	 * masterCookie =  pointer to a guint32 to protect the list.
	 * list =  pointer to the list
	 * owner =  object owning the list
	 * item =  function to call for each item
	 * free =  function to call when the iterator is freed
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GType type, GMutex* lock, uint* masterCookie, GList** list, void* owner, GstIteratorItemFunction item, GstIteratorDisposeFunction free);
	
	/**
	 * Get the next item from the iterator. For iterators that return
	 * refcounted objects, the returned object will have its refcount
	 * increased and should therefore be unreffed after usage.
	 * Params:
	 * elem =  pointer to hold next element
	 * Returns: The result of the iteration. Unref after usage if this isa refcounted object.MT safe.
	 */
	public GstIteratorResult next(void** elem);
	
	/**
	 * Resync the iterator. this function is mostly called
	 * after gst_iterator_next() returned GST_ITERATOR_RESYNC.
	 * MT safe.
	 */
	public void resync();
	
	/**
	 * Free the iterator.
	 * MT safe.
	 */
	public void free();
	
	/**
	 * Pushes other iterator onto it. All calls performed on it are
	 * forwarded tot other. If other returns GST_ITERATOR_DONE, it is
	 * popped again and calls are handled by it again.
	 * This function is mainly used by objects implementing the iterator
	 * next function to recurse into substructures.
	 * MT safe.
	 * Params:
	 * other =  The GstIterator to push
	 */
	public void push(Iterator other);
	
	/**
	 * Create a new iterator from an existing iterator. The new iterator
	 * will only return those elements that match the given compare function func.
	 * func should return 0 for elements that should be included
	 * in the iterator.
	 * When this iterator is freed, it will also be freed.
	 * Params:
	 * func =  the compare function to select elements
	 * userData =  user data passed to the compare function
	 * Returns: a new GstIterator.MT safe.
	 */
	public Iterator filter(GCompareFunc func, void* userData);
	
	/**
	 * Folds func over the elements of iter. That is to say, proc will be called
	 * as proc (object, ret, user_data) for each object in iter. The normal use
	 * of this procedure is to accumulate the results of operating on the objects in
	 * ret.
	 * This procedure can be used (and is used internally) to implement the foreach
	 * and find_custom operations.
	 * The fold will proceed as long as func returns TRUE. When the iterator has no
	 * more arguments, GST_ITERATOR_DONE will be returned. If func returns FALSE,
	 * the fold will stop, and GST_ITERATOR_OK will be returned. Errors or resyncs
	 * will cause fold to return GST_ITERATOR_ERROR or GST_ITERATOR_RESYNC as
	 * appropriate.
	 * The iterator will not be freed.
	 * Params:
	 * func =  the fold function
	 * ret =  the seed value passed to the fold function
	 * userData =  user data passed to the fold function
	 * Returns: A GstIteratorResult, as described above.MT safe.
	 */
	public GstIteratorResult fold(GstIteratorFoldFunction func, GValue* ret, void* userData);
	
	/**
	 * Iterate over all element of it and call the given function func for
	 * each element.
	 * Params:
	 * func =  the function to call for each element.
	 * userData =  user data passed to the function
	 * Returns: the result call to gst_iterator_fold(). The iterator will not befreed.MT safe.
	 */
	public GstIteratorResult foreac(GFunc func, void* userData);
	
	/**
	 * Find the first element in it that matches the compare function func.
	 * func should return 0 when the element is found.
	 * The iterator will not be freed.
	 * This function will return NULL if an error or resync happened to
	 * the iterator.
	 * Params:
	 * func =  the compare function to use
	 * userData =  user data passed to the compare function
	 * Returns: The element in the iterator that matches the comparefunction or NULL when no element matched.MT safe.
	 */
	public void* findCustom(GCompareFunc func, void* userData);
}
