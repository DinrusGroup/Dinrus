module gtkD.gio.Cancellable;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GCancellable is a thread-safe operation cancellation stack used
 * throughout GIO to allow for cancellation of synchronous and
 * asynchronous operations.
 */
public class Cancellable : ObjectG
{
	
	/** the main Gtk struct */
	protected GCancellable* gCancellable;
	
	
	public GCancellable* getCancellableStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GCancellable* gCancellable);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Cancellable)[] onCancelledListeners;
	/**
	 * Emitted when the operation has been cancelled.
	 * Can be used by implementations of cancellable operations. If the
	 * operation is cancelled from another thread, the signal will be
	 * emitted in the thread that cancelled the operation, not the
	 * thread that is running the operation.
	 * Note that disconnecting from this signal (or any signal) in a
	 * multi-threaded program is prone to race conditions. For instance
	 * it is possible that a signal handler may be invoked even
	 * after a call to
	 * g_signal_handler_disconnect() for that handler has already
	 * returned.
	 * There is also a problem when cancellation happen
	 * right before connecting to the signal. If this happens the
	 * signal will unexpectedly not be emitted, and checking before
	 * connecting to the signal leaves a race condition where this is
	 * still happening.
	 * In order to make it safe and easy to connect handlers there
	 * are two helper functions: g_cancellable_connect() and
	 * g_cancellable_disconnect() which protect against problems
	 * like this.
	 *  /+* Make sure we don't do any unnecessary work if already cancelled +/
	 *  if (g_cancellable_set_error_if_cancelled (cancellable))
	 *  return;
	 *  /+* Set up all the data needed to be able to
	 *  * handle cancellation of the operation +/
	 *  my_data = my_data_new (...);
	 *  id = 0;
	 *  if (cancellable)
	 *  id = g_cancellable_connect (cancellable,
	 *  			 G_CALLBACK (cancelled_handler)
	 *  			 data, NULL);
	 *  /+* cancellable operation here... +/
	 *  g_cancellable_disconnect (cancellable, id);
	 *  /+* cancelled_handler is never called after this, it
	 *  * is now safe to free the data +/
	 *  my_data_free (my_data);
	 * Note that the cancelled signal is emitted in the thread that
	 * the user cancelled from, which may be the main thread. So, the
	 * cancellable signal should not do something that can block.
	 */
	void addOnCancelled(void delegate(Cancellable) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCancelled(GCancellable* cancellableStruct, Cancellable cancellable);
	
	
	/**
	 * Creates a new GCancellable object.
	 * Applications that want to start one or more operations
	 * that should be cancellable should create a GCancellable
	 * and pass it to the operations.
	 * One GCancellable can be used in multiple consecutive
	 * operations, but not in multiple concurrent operations.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Checks if a cancellable job has been cancelled.
	 * Returns: TRUE if cancellable is cancelled, FALSE if called with NULL or if item is not cancelled.
	 */
	public int isCancelled();
	
	/**
	 * If the cancellable is cancelled, sets the error to notify
	 * that the operation was cancelled.
	 * Returns: TRUE if cancellable was cancelled, FALSE if it was not.
	 */
	public int setErrorIfCancelled();
	
	/**
	 * Gets the file descriptor for a cancellable job. This can be used to
	 * implement cancellable operations on Unix systems. The returned fd will
	 * turn readable when cancellable is cancelled.
	 * You are not supposed to read from the fd yourself, just check for
	 * readable status. Reading to unset the readable status is done
	 * with g_cancellable_reset().
	 * After a successful return from this function, you should use
	 * g_cancellable_release_fd() to free up resources allocated for
	 * the returned file descriptor.
	 * See also g_cancellable_make_pollfd().
	 * Returns: A valid file descriptor. -1 if the file descriptor is not supported, or on errors.
	 */
	public int getFd();
	
	/**
	 * Creates a GPollFD corresponding to cancellable; this can be passed
	 * to g_poll() and used to poll for cancellation. This is useful both
	 * for unix systems without a native poll and for portability to
	 * windows.
	 * When this function returns TRUE, you should use
	 * g_cancellable_release_fd() to free up resources allocated for the
	 * pollfd. After a FALSE return, do not call g_cancellable_release_fd().
	 * If this function returns FALSE, either no cancellable was given or
	 * resource limits prevent this function from allocating the necessary
	 * structures for polling. (On Linux, you will likely have reached
	 * the maximum number of file descriptors.) The suggested way to handle
	 * these cases is to ignore the cancellable.
	 * You are not supposed to read from the fd yourself, just check for
	 * readable status. Reading to unset the readable status is done
	 * with g_cancellable_reset().
	 * Since 2.22
	 * Params:
	 * pollfd =  a pointer to a GPollFD
	 * Returns: TRUE if pollfd was successfully initialized, FALSE on  failure to prepare the cancellable.
	 */
	public int makePollfd(GPollFD* pollfd);
	
	/**
	 * Releases a resources previously allocated by g_cancellable_get_fd()
	 * or g_cancellable_make_pollfd().
	 * For compatibility reasons with older releases, calling this function
	 * is not strictly required, the resources will be automatically freed
	 * when the cancellable is finalized. However, the cancellable will
	 * block scarce file descriptors until it is finalized if this function
	 * is not called. This can cause the application to run out of file
	 * descriptors when many GCancellables are used at the same time.
	 * Since 2.22
	 */
	public void releaseFd();
	
	/**
	 * Gets the top cancellable from the stack.
	 * Returns: a GCancellable from the top of the stack, or NULLif the stack is empty.
	 */
	public static Cancellable getCurrent();
	
	/**
	 * Pops cancellable off the cancellable stack (verifying that cancellable
	 * is on the top of the stack).
	 */
	public void popCurrent();
	
	/**
	 * Pushes cancellable onto the cancellable stack. The current
	 * cancllable can then be recieved using g_cancellable_get_current().
	 * This is useful when implementing cancellable operations in
	 * code that does not allow you to pass down the cancellable object.
	 * This is typically called automatically by e.g. GFile operations,
	 * so you rarely have to call this yourself.
	 */
	public void pushCurrent();
	
	/**
	 * Resets cancellable to its uncancelled state.
	 */
	public void reset();
	
	/**
	 * Convenience function to connect to the "cancelled"
	 * signal. Also handles the race condition that may happen
	 * if the cancellable is cancelled right before connecting.
	 * callback is called at most once, either directly at the
	 * time of the connect if cancellable is already cancelled,
	 * or when cancellable is cancelled in some thread.
	 * data_destroy_func will be called when the handler is
	 * disconnected, or immediately if the cancellable is already
	 * cancelled.
	 * See "cancelled" for details on how to use this.
	 * Since 2.22
	 * Params:
	 * callback =  The GCallback to connect.
	 * data =  Data to pass to callback.
	 * dataDestroyFunc =  Free function for data or NULL.
	 * Returns: The id of the signal handler or 0 if cancellable has already been cancelled.
	 */
	public uint connect(GCallback callback, void* data, GDestroyNotify dataDestroyFunc);
	
	/**
	 * Disconnects a handler from an cancellable instance similar to
	 * g_signal_handler_disconnect() but ensures that once this
	 * function returns the handler will not run anymore in any thread.
	 * This avoids a race condition where a thread cancels at the
	 * same time as the cancellable operation is finished and the
	 * signal handler is removed. See "cancelled" for
	 * details on how to use this.
	 * If cancellable is NULL or handler_id is 0 this function does
	 * nothing.
	 * Since 2.22
	 * Params:
	 * handlerId =  Handler id of the handler to be disconnected, or 0.
	 */
	public void disconnect(uint handlerId);
	
	/**
	 * Will set cancellable to cancelled, and will emit the
	 * "cancelled" signal. (However, see the warning about
	 * race conditions in the documentation for that signal if you are
	 * planning to connect to it.)
	 * This function is thread-safe. In other words, you can safely call
	 * it from a thread other than the one running the operation that was
	 * passed the cancellable.
	 * The convention within gio is that cancelling an asynchronous
	 * operation causes it to complete asynchronously. That is, if you
	 * cancel the operation from the same thread in which it is running,
	 * then the operation's GAsyncReadyCallback will not be invoked until
	 * the application returns to the main loop.
	 */
	public void cancel();
}
