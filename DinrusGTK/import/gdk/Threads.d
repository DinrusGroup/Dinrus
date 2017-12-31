
module gtkD.gdk.Threads;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;






/**
 */

/**
 * Initializes GDK so that it can be used from multiple threads
 * in conjunction with gdk_threads_enter() and gdk_threads_leave().
 * g_thread_init() must be called previous to this function.
 * This call must be made before any use of the main loop from
 * GTK+; to be safe, call it before gtk_init().
 */
public static void gdkThreadsInit();

/**
 * This macro marks the beginning of a critical section in which GDK and
 * GTK+ functions can be called safely and without causing race
 * conditions. Only one thread at a time can be in such a critial
 * section.
 */
public static void gdkThreadsEnter();

/**
 * Leaves a critical region begun with gdk_threads_enter().
 */
public static void gdkThreadsLeave();

/**
 * Allows the application to replace the standard method that
 * GDK uses to protect its data structures. Normally, GDK
 * creates a single GMutex that is locked by gdk_threads_enter(),
 * and released by gdk_threads_leave(); using this function an
 * application provides, instead, a function enter_fn that is
 * called by gdk_threads_enter() and a function leave_fn that is
 * called by gdk_threads_leave().
 * The functions must provide at least same locking functionality
 * as the default implementation, but can also do extra application
 * specific processing.
 * As an example, consider an application that has its own recursive
 * lock that when held, holds the GTK+ lock as well. When GTK+ unlocks
 * the GTK+ lock when entering a recursive main loop, the application
 * must temporarily release its lock as well.
 * Most threaded GTK+ apps won't need to use this method.
 * This method must be called before gdk_threads_init(), and cannot
 * be called multiple times.
 * Since 2.4
 * Params:
 * enterFn =  function called to guard GDK
 * leaveFn =  function called to release the guard
 */
public static void gdkThreadsSetLockFunctions(GCallback enterFn, GCallback leaveFn);

/**
 * A wrapper for the common usage of gdk_threads_add_idle_full()
 * assigning the default priority, G_PRIORITY_DEFAULT_IDLE.
 * See gdk_threads_add_idle_full().
 * Since 2.12
 * Params:
 * data =  data to pass to function
 * Returns: the ID (greater than 0) of the event source.
 */
public static uint gdkThreadsAddIdle(GSourceFunc funct, void* data);

/**
 * Adds a function to be called whenever there are no higher priority
 * events pending. If the function returns FALSE it is automatically
 * removed from the list of event sources and will not be called again.
 * This variant of g_idle_add_full() calls function with the GDK lock
 * held. It can be thought of a MT-safe version for GTK+ widgets for the
 * following use case, where you have to worry about idle_callback()
 * running in thread A and accessing self after it has been finalized
 * Since 2.12
 * Params:
 * priority =  the priority of the idle source. Typically this will be in the
 *  range btweeen G_PRIORITY_DEFAULT_IDLE and G_PRIORITY_HIGH_IDLE
 * data =  data to pass to function
 * notify =  function to call when the idle is removed, or NULL
 * Returns: the ID (greater than 0) of the event source.
 */
public static uint gdkThreadsAddIdleFull(int priority, GSourceFunc funct, void* data, GDestroyNotify notify);

/**
 * A wrapper for the common usage of gdk_threads_add_timeout_full()
 * assigning the default priority, G_PRIORITY_DEFAULT.
 * See gdk_threads_add_timeout_full().
 * Since 2.12
 * Params:
 * interval =  the time between calls to the function, in milliseconds
 *  (1/1000ths of a second)
 * data =  data to pass to function
 * Returns: the ID (greater than 0) of the event source.
 */
public static uint gdkThreadsAddTimeout(uint interval, GSourceFunc funct, void* data);

/**
 * Sets a function to be called at regular intervals holding the GDK lock,
 * with the given priority. The function is called repeatedly until it
 * returns FALSE, at which point the timeout is automatically destroyed
 * and the function will not be called again. The notify function is
 * called when the timeout is destroyed. The first call to the
 * function will be at the end of the first interval.
 * Note that timeout functions may be delayed, due to the processing of other
 * event sources. Thus they should not be relied on for precise timing.
 * After each call to the timeout function, the time of the next
 * timeout is recalculated based on the current time and the given interval
 * (it does not try to 'catch up' time lost in delays).
 * This variant of g_timeout_add_full() can be thought of a MT-safe version
 * Since 2.12
 * Params:
 * priority =  the priority of the timeout source. Typically this will be in the
 *  range between G_PRIORITY_DEFAULT_IDLE and G_PRIORITY_HIGH_IDLE.
 * interval =  the time between calls to the function, in milliseconds
 *  (1/1000ths of a second)
 * data =  data to pass to function
 * notify =  function to call when the timeout is removed, or NULL
 * Returns: the ID (greater than 0) of the event source.
 */
public static uint gdkThreadsAddTimeoutFull(int priority, uint interval, GSourceFunc funct, void* data, GDestroyNotify notify);

/**
 * A wrapper for the common usage of gdk_threads_add_timeout_seconds_full()
 * assigning the default priority, G_PRIORITY_DEFAULT.
 * For details, see gdk_threads_add_timeout_full().
 * Since 2.14
 * Params:
 * interval =  the time between calls to the function, in seconds
 * data =  data to pass to function
 * Returns: the ID (greater than 0) of the event source.
 */
public static uint gdkThreadsAddTimeoutSeconds(uint interval, GSourceFunc funct, void* data);

/**
 * A variant of gdk_threads_add_timout_full() with second-granularity.
 * See g_timeout_add_seconds_full() for a discussion of why it is
 * a good idea to use this function if you don't need finer granularity.
 * Since 2.14
 * Params:
 * priority =  the priority of the timeout source. Typically this will be in the
 *  range between G_PRIORITY_DEFAULT_IDLE and G_PRIORITY_HIGH_IDLE.
 * interval =  the time between calls to the function, in seconds
 * data =  data to pass to function
 * notify =  function to call when the timeout is removed, or NULL
 * Returns: the ID (greater than 0) of the event source.
 */
public static uint gdkThreadsAddTimeoutSecondsFull(int priority, uint interval, GSourceFunc funct, void* data, GDestroyNotify notify);

