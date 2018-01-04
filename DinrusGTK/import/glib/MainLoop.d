module gtkD.glib.MainLoop;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.MainContext;
private import gtkD.glib.Source;




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
public class MainLoop
{
	
	/** the main Gtk struct */
	protected GMainLoop* gMainLoop;
	
	
	public GMainLoop* getMainLoopStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GMainLoop* gMainLoop);
	
	/**
	 */
	
	/**
	 * Creates a new GMainLoop structure.
	 * Params:
	 * context =  a GMainContext (if NULL, the default context will be used).
	 * isRunning =  set to TRUE to indicate that the loop is running. This
	 * is not very important since calling g_main_loop_run() will set this to
	 * TRUE anyway.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (MainContext context, int isRunning);
	
	/**
	 * Increases the reference count on a GMainLoop object by one.
	 * Returns: loop
	 */
	public MainLoop doref();
	
	/**
	 * Decreases the reference count on a GMainLoop object by one. If
	 * the result is zero, free the loop and free all associated memory.
	 */
	public void unref();
	
	/**
	 * Runs a main loop until g_main_loop_quit() is called on the loop.
	 * If this is called for the thread of the loop's GMainContext,
	 * it will process events from the loop, otherwise it will
	 * simply wait.
	 */
	public void run();
	
	/**
	 * Stops a GMainLoop from running. Any calls to g_main_loop_run()
	 * for the loop will return.
	 * Note that sources that have already been dispatched when
	 * g_main_loop_quit() is called will still be executed.
	 */
	public void quit();
	
	/**
	 * Checks to see if the main loop is currently being run via g_main_loop_run().
	 * Returns: TRUE if the mainloop is currently being run.
	 */
	public int isRunning();
	
	/**
	 * Returns the GMainContext of loop.
	 * Returns: the GMainContext of loop
	 */
	public MainContext getContext();
	
	/**
	 * Returns the depth of the stack of calls to
	 * g_main_context_dispatch() on any GMainContext in the current thread.
	 *  That is, when called from the toplevel, it gives 0. When
	 * called from within a callback from g_main_context_iteration()
	 * (or g_main_loop_run(), etc.) it returns 1. When called from within
	 * a callback to a recursive call to g_main_context_iterate(),
	 * it returns 2. And so forth.
	 * Returns: The main loop recursion level in the current thread
	 */
	public static int mainDepth();
	
	/**
	 * Returns the currently firing source for this thread.
	 * Since 2.12
	 * Returns: The currently firing source or NULL.
	 */
	public static Source mainCurrentSource();
	
	/**
	 * Polls fds, as with the poll() system call, but portably. (On
	 * systems that don't have poll(), it is emulated using select().)
	 * This is used internally by GMainContext, but it can be called
	 * directly if you need to block until a file descriptor is ready, but
	 * don't want to run the full main loop.
	 * Each element of fds is a GPollFD describing a single file
	 * descriptor to poll. The fd field indicates the file descriptor,
	 * and the events field indicates the events to poll for. On return,
	 * the revents fields will be filled with the events that actually
	 * occurred.
	 * On POSIX systems, the file descriptors in fds can be any sort of
	 * file descriptor, but the situation is much more complicated on
	 * Windows. If you need to use g_poll() in code that has to run on
	 * Windows, the easiest solution is to construct all of your
	 * GPollFDs with g_io_channel_win32_make_pollfd().
	 * Since 2.20
	 * Params:
	 * fds =  file descriptors to poll
	 * timeout =  amount of time to wait, in milliseconds, or -1 to wait forever
	 * Returns: the number of entries in fds whose revents fieldswere filled in, or 0 if the operation timed out, or -1 on error orif the call was interrupted.
	 */
	public static int poll(GPollFD[] fds, int timeout);
}
