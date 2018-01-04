
module gtkD.glib.MainContext;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Source;
private import gtkD.gthread.Cond;
private import gtkD.gthread.Mutex;




/**
 * Description
 *  The main event loop manages all the available sources of events for
 *  GLib and GTK+ applications. These events can come from any number of
 *  different types of sources such as file descriptors (plain files,
 *  pipes or sockets) and timeouts. New types of event sources can also
 *  be added using g_source_attach().
 *  To allow multiple independent sets of sources to be handled in
 *  different threads, each source is associated with a GMainContext.
 *  A GMainContext can only be running in a single thread, but
 *  sources can be added to it and removed from it from other threads.
 *  Each event source is assigned a priority. The default priority,
 *  G_PRIORITY_DEFAULT, is 0. Values less than 0 denote higher
 *  priorities. Values greater than 0 denote lower priorities. Events
 *  from high priority sources are always processed before events from
 *  lower priority sources.
 *  Idle functions can also be added, and assigned a priority. These will
 *  be run whenever no events with a higher priority are ready to be
 *  processed.
 *  The GMainLoop data type represents a main event loop. A GMainLoop
 *  is created with g_main_loop_new(). After adding the initial event sources,
 *  g_main_loop_run() is called. This continuously checks for new events from
 *  each of the event sources and dispatches them. Finally, the
 *  processing of an event from one of the sources leads to a call to
 *  g_main_loop_quit() to exit the main loop, and g_main_loop_run() returns.
 *  It is possible to create new instances of GMainLoop recursively.
 *  This is often used in GTK+ applications when showing modal dialog
 *  boxes. Note that event sources are associated with a particular
 *  GMainContext, and will be checked and dispatched for all main
 *  loops associated with that GMainContext.
 *  GTK+ contains wrappers of some of these functions, e.g. gtk_main(),
 *  gtk_main_quit() and gtk_events_pending().
 * Creating new sources types
 *  One of the unusual features of the GTK+ main loop functionality
 *  is that new types of event source can be created and used in
 *  addition to the builtin type of event source. A new event source
 *  type is used for handling GDK events. A new source type is
 *  created by deriving from the GSource
 *  structure. The derived type of source is represented by a
 *  structure that has the GSource structure as a first element,
 *  and other elements specific to the new source type. To create
 *  an instance of the new source type, call g_source_new() passing
 *  in the size of the derived structure and a table of functions.
 *  These GSourceFuncs determine the behavior of the new source
 *  types.
 *  New source types basically interact with the main context
 *  in two ways. Their prepare function in GSourceFuncs can set
 *  a timeout to determine the maximum amount of time that the
 *  main loop will sleep before checking the source again. In
 *  addition, or as well, the source can add file descriptors to
 *  the set that the main context checks using g_source_add_poll().
 * <hr>
 * Customizing the main loop iteration
 *  Single iterations of a GMainContext can be run with
 *  g_main_context_iteration(). In some cases, more detailed control
 *  of exactly how the details of the main loop work is desired,
 *  for instance, when integrating the GMainLoop with an external
 *  main loop. In such cases, you can call the component functions
 *  of g_main_context_iteration() directly. These functions
 *  are g_main_context_prepare(), g_main_context_query(),
 *  g_main_context_check() and g_main_context_dispatch().
 *  The operation of these functions can best be seen in terms
 *  of a state diagram, as shown in Figure 1, “States of a Main Context”.
 * Figure 1. States of a Main Context
 */
public class MainContext
{
	
	/** the main Gtk struct */
	protected GMainContext* gMainContext;
	
	
	public GMainContext* getMainContextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GMainContext* gMainContext);
	
	/**
	 */
	
	/**
	 * Creates a new GMainContext structure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Increases the reference count on a GMainContext object by one.
	 * Returns: the context that was passed in (since 2.6)
	 */
	public MainContext doref();
	
	/**
	 * Decreases the reference count on a GMainContext object by one. If
	 * the result is zero, free the context and free all associated memory.
	 */
	public void unref();
	
	/**
	 * Returns the global default main context. This is the main context
	 * used for main loop functions when a main loop is not explicitly
	 * specified, and corresponds to the "main" main loop. See also
	 * g_main_context_get_thread_default().
	 * Returns: the global default main context.
	 */
	public static MainContext defaulx();

	/**
	 * Runs a single iteration for the given main loop. This involves
	 * checking to see if any event sources are ready to be processed,
	 * then if no events sources are ready and may_block is TRUE, waiting
	 * for a source to become ready, then dispatching the highest priority
	 * events sources that are ready. Otherwise, if may_block is FALSE
	 * sources are not waited to become ready, only those highest priority
	 * events sources will be dispatched (if any), that are ready at this
	 * given moment without further waiting.
	 * Note that even when may_block is TRUE, it is still possible for
	 * g_main_context_iteration() to return FALSE, since the the wait may
	 * be interrupted for other reasons than an event source becoming ready.
	 * Params:
	 * mayBlock =  whether the call may block.
	 * Returns: TRUE if events were dispatched.
	 */
	public int iteration(int mayBlock);
	
	/**
	 * Checks if any sources have pending events for the given context.
	 * Returns: TRUE if events are pending.
	 */
	public int pending();
	
	/**
	 * Finds a GSource given a pair of context and ID.
	 * Params:
	 * sourceId =  the source ID, as returned by g_source_get_id().
	 * Returns: the GSource if found, otherwise, NULL
	 */
	public Source findSourceById(uint sourceId);
	
	/**
	 * Finds a source with the given user data for the callback. If
	 * multiple sources exist with the same user data, the first
	 * one found will be returned.
	 * Params:
	 * userData =  the user_data for the callback.
	 * Returns: the source, if one was found, otherwise NULL
	 */
	public Source findSourceByUserData(void* userData);
	
	/**
	 * Finds a source with the given source functions and user data. If
	 * multiple sources exist with the same source function and user data,
	 * the first one found will be returned.
	 * Params:
	 * funcs =  the source_funcs passed to g_source_new().
	 * userData =  the user data from the callback.
	 * Returns: the source, if one was found, otherwise NULL
	 */
	public Source findSourceByFuncsUserData(GSourceFuncs* funcs, void* userData);
	
	/**
	 * If context is currently waiting in a poll(), interrupt
	 * the poll(), and continue the iteration process.
	 */
	public void wakeup();
	
	/**
	 * Tries to become the owner of the specified context.
	 * If some other thread is the owner of the context,
	 * returns FALSE immediately. Ownership is properly
	 * recursive: the owner can require ownership again
	 * and will release ownership when g_main_context_release()
	 * is called as many times as g_main_context_acquire().
	 * You must be the owner of a context before you
	 * can call g_main_context_prepare(), g_main_context_query(),
	 * g_main_context_check(), g_main_context_dispatch().
	 * Returns: TRUE if the operation succeeded, and this thread is now the owner of context.
	 */
	public int acquire();
	
	/**
	 * Releases ownership of a context previously acquired by this thread
	 * with g_main_context_acquire(). If the context was acquired multiple
	 * times, the ownership will be released only when g_main_context_release()
	 * is called as many times as it was acquired.
	 */
	public void release();
	
	/**
	 * Determines whether this thread holds the (recursive)
	 * ownership of this GMaincontext. This is useful to
	 * know before waiting on another thread that may be
	 * blocking to get ownership of context.
	 * Since 2.10
	 * Returns: TRUE if current thread is owner of context.
	 */
	public int isOwner();
	
	/**
	 * Tries to become the owner of the specified context,
	 * as with g_main_context_acquire(). But if another thread
	 * is the owner, atomically drop mutex and wait on cond until
	 * that owner releases ownership or until cond is signaled, then
	 * try again (once) to become the owner.
	 * Params:
	 * cond =  a condition variable
	 * mutex =  a mutex, currently held
	 * Returns: TRUE if the operation succeeded, and this thread is now the owner of context.
	 */
	public int wait(Cond cond, Mutex mutex);
	
	/**
	 * Prepares to poll sources within a main loop. The resulting information
	 * for polling is determined by calling g_main_context_query().
	 * Params:
	 * priority =  location to store priority of highest priority
	 *  source already ready.
	 * Returns: TRUE if some source is ready to be dispatched prior to polling.
	 */
	public int prepare(out int priority);
	
	/**
	 * Determines information necessary to poll this main loop.
	 * Params:
	 * maxPriority =  maximum priority source to check
	 * timeout =  location to store timeout to be used in polling
	 * fds =  location to store GPollFD records that need to be polled.
	 * nFds =  length of fds.
	 * Returns: the number of records actually stored in fds, or, if more than n_fds records need to be stored, the number of records that need to be stored.
	 */
	public int query(int maxPriority, out int timeout, GPollFD* fds, int nFds);
	
	/**
	 * Passes the results of polling back to the main loop.
	 * Params:
	 * maxPriority =  the maximum numerical priority of sources to check
	 * fds =  array of GPollFD's that was passed to the last call to
	 *  g_main_context_query()
	 * nFds =  return value of g_main_context_query()
	 * Returns: TRUE if some sources are ready to be dispatched.
	 */
	public int check(int maxPriority, GPollFD* fds, int nFds);
	
	/**
	 * Dispatches all pending sources.
	 */
	public void dispatch();
	
	/**
	 * Sets the function to use to handle polling of file descriptors. It
	 * will be used instead of the poll() system call
	 * (or GLib's replacement function, which is used where
	 * poll() isn't available).
	 * This function could possibly be used to integrate the GLib event
	 * loop with an external event loop.
	 * Params:
	 * func =  the function to call to poll all file descriptors
	 */
	public void setPollFunc(GPollFunc func);
	
	/**
	 * Gets the poll function set by g_main_context_set_poll_func().
	 * Returns: the poll function
	 */
	public GPollFunc getPollFunc();
	
	/**
	 * Adds a file descriptor to the set of file descriptors polled for
	 * this context. This will very seldomly be used directly. Instead
	 * a typical event source will use g_source_add_poll() instead.
	 * Params:
	 * fd =  a GPollFD structure holding information about a file
	 *  descriptor to watch.
	 * priority =  the priority for this file descriptor which should be
	 *  the same as the priority used for g_source_attach() to ensure that the
	 *  file descriptor is polled whenever the results may be needed.
	 */
	public void addPoll(GPollFD* fd, int priority);
	
	/**
	 * Removes file descriptor from the set of file descriptors to be
	 * polled for a particular context.
	 * Params:
	 * fd =  a GPollFD descriptor previously added with g_main_context_add_poll()
	 */
	public void removePoll(GPollFD* fd);

	/**
	 * Gets the thread-default GMainContext for this thread. Asynchronous
	 * operations that want to be able to be run in contexts other than
	 * the default one should call this method to get a GMainContext to
	 * add their GSources to. (Note that even in single-threaded
	 * programs applications may sometimes want to temporarily push a
	 * non-default context, so it is not safe to assume that this will
	 * always return NULL if threads are not initialized.)
	 * Since 2.22
	 * Returns: the thread-default GMainContext, or NULL if thethread-default context is the global default context.
	 */
	public static MainContext getThreadDefault();
	
	/**
	 * Acquires context and sets it as the thread-default context for the
	 * current thread. This will cause certain asynchronous operations
	 * (such as most gio-based I/O) which are
	 * started in this thread to run under context and deliver their
	 * results to its main loop, rather than running under the global
	 * default context in the main thread. Note that calling this function
	 * changes the context returned by
	 * g_main_context_get_thread_default(), not the
	 * one returned by g_main_context_default(), so it does not affect the
	 * context used by functions like g_idle_add().
	 * Normally you would call this function shortly after creating a new
	 * thread, passing it a GMainContext which will be run by a
	 * GMainLoop in that thread, to set a new default context for all
	 * async operations in that thread. (In this case, you don't need to
	 * ever call g_main_context_pop_thread_default().) In some cases
	 * however, you may want to schedule a single operation in a
	 * non-default context, or temporarily use a non-default context in
	 * the main thread. In that case, you can wrap the call to the
	 * asynchronous operation inside a
	 * g_main_context_push_thread_default() /
	 * g_main_context_pop_thread_default() pair, but it is up to you to
	 * ensure that no other asynchronous operations accidentally get
	 * started while the non-default context is active.
	 * Beware that libraries that predate this function may not correctly
	 * handle being used from a thread with a thread-default context. Eg,
	 * see g_file_supports_thread_contexts().
	 * Since 2.22
	 */
	public void pushThreadDefault();
	
	/**
	 * Pops context off the thread-default context stack (verifying that
	 * it was on the top of the stack).
	 * Since 2.22
	 */
	public void popThreadDefault();
}
