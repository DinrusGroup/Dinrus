module gtkD.glib.Idle;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


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
public class Idle
{
	
	/** Holds all idle delegates */
	bool delegate()[] idleListeners;
	/** our idle ID */
	uint idleID;
	
	/**
	 * Creates a new idle cycle.
	 * Params:
	 *    	interval = the idle in milieconds
	 *    	dlg = the delegate to be executed
	 *    	fireNow = When true the delegate will be executed emmidiatly
	 */
	this(bool delegate() dlg, bool fireNow=false);
	
	/**
	 * Creates a new idle cycle.
	 * Params:
	 *    	dlg = the delegate to be executed
	 *      priority = Priority for the idle function
	 *    	fireNow = When true the delegate will be executed emmidiatly
	 */
	this(bool delegate() dlg, GPriority priority, bool fireNow=false);
	
	/** */
	public void stop();
	
	/**
	 * Removes the idle from gtk
	 */
	~this();
	
	/**
	 * Adds a new delegate to this idle cycle
	 * Params:
	 *    	dlg =
	 *    	fireNow =
	 */
	public void addListener(bool delegate() dlg, bool fireNow=false);
	
	/**
	 * The callback execution from glib
	 * Params:
	 *    	idle =
	 * Returns:
	 */
	extern(C) static bool idleCallback(Idle idle);
	
	/**
	 * Executes all delegates on the execution list
	 * Returns:
	 */
	private bool callAllListeners();
	
	/**
	 */
	
	/**
	 * Creates a new idle source.
	 * The source will not initially be associated with any GMainContext
	 * and must be added to one with g_source_attach() before it will be
	 * executed. Note that the default priority for idle sources is
	 * G_PRIORITY_DEFAULT_IDLE, as compared to other sources which
	 * have a default priority of G_PRIORITY_DEFAULT.
	 * Returns: the newly-created idle source
	 */
	public static Source sourceNew();
	
	/**
	 * Adds a function to be called whenever there are no higher priority
	 * events pending to the default main loop. The function is given the
	 * default idle priority, G_PRIORITY_DEFAULT_IDLE. If the function
	 * returns FALSE it is automatically removed from the list of event
	 * sources and will not be called again.
	 * This internally creates a main loop source using g_idle_source_new()
	 * and attaches it to the main loop context using g_source_attach().
	 * You can do these steps manually if you need greater control.
	 * Params:
	 * data =  data to pass to function.
	 * Returns: the ID (greater than 0) of the event source.
	 */
	public static uint add(GSourceFunc funct, void* data);
	
	/**
	 * Adds a function to be called whenever there are no higher priority
	 * events pending. If the function returns FALSE it is automatically
	 * removed from the list of event sources and will not be called again.
	 * This internally creates a main loop source using g_idle_source_new()
	 * and attaches it to the main loop context using g_source_attach().
	 * You can do these steps manually if you need greater control.
	 * Params:
	 * priority =  the priority of the idle source. Typically this will be in the
	 *  range between G_PRIORITY_DEFAULT_IDLE and G_PRIORITY_HIGH_IDLE.
	 * data =  data to pass to function
	 * notify =  function to call when the idle is removed, or NULL
	 * Returns: the ID (greater than 0) of the event source.
	 */
	public static uint addFull(int priority, GSourceFunc funct, void* data, GDestroyNotify notify);
	
	/**
	 * Removes the idle function with the given data.
	 * Params:
	 * data =  the data for the idle source's callback.
	 * Returns: TRUE if an idle source was found and removed.
	 */
	public static int removeByData(void* data);
}
