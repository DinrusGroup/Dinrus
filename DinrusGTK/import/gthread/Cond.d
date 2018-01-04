module gtkD.gthread.Cond;

public  import gtkD.gtkc.gthreadtypes;

private import gtkD.gtkc.gthread;
private import gtkD.glib.ConstructionException;


private import gtkD.gthread.Mutex;
private import gtkD.glib.TimeVal;




/**
 * Description
 * Threads act almost like processes, but unlike processes all threads of
 * one process share the same memory. This is good, as it provides easy
 * communication between the involved threads via this shared memory, and
 * it is bad, because strange things (so called "Heisenbugs") might
 * happen if the program is not carefully designed. In particular, due to
 * the concurrent nature of threads, no assumptions on the order of
 * execution of code running in different threads can be made, unless
 * order is explicitly forced by the programmer through synchronization
 * primitives.
 * The aim of the thread related functions in GLib is to provide a
 * portable means for writing multi-threaded software. There are
 * primitives for mutexes to protect the access to portions of memory
 * (GMutex, GStaticMutex, G_LOCK_DEFINE, GStaticRecMutex and
 * GStaticRWLock). There are primitives for condition variables to allow
 * synchronization of threads (GCond). There are primitives
 * for thread-private data - data that every thread has a private instance of
 * (GPrivate, GStaticPrivate). Last but definitely not least there are
 * primitives to portably create and manage threads (GThread).
 * You must call g_thread_init() before executing any other GLib
 * functions (except g_mem_set_vtable()) in a GLib program if
 * g_thread_init() will be called at all. This is a requirement even if
 * no threads are in fact ever created by the process. It is enough that
 * g_thread_init() is called. If other GLib functions have been called
 * before that, the behaviour of the program is undefined. An exception
 * is g_mem_set_vtable() which may be called before g_thread_init().
 * Failing this requirement can lead to hangs or crashes, apparently more
 * easily on Windows than on Linux, for example.
 * Please note that if you call functions in some GLib-using library, in
 * particular those above the GTK+ stack, that library might well call
 * g_thread_init() itself, or call some other library that calls
 * g_thread_init(). Thus, if you use some GLib-based library that is
 * above the GTK+ stack, it is safest to call g_thread_init() in your
 * application's main() before calling any GLib functions or functions in
 * GLib-using libraries.
 * After calling g_thread_init(), GLib is completely
 * thread safe (all global data is automatically locked), but individual
 * data structure instances are not automatically locked for performance
 * reasons. So, for example you must coordinate accesses to the same
 * GHashTable from multiple threads. The two notable exceptions from
 * this rule are GMainLoop and GAsyncQueue,
 * which are threadsafe and needs no further
 * application-level locking to be accessed from multiple threads.
 * To help debugging problems in multithreaded applications, GLib supports
 * error-checking mutexes that will give you helpful error messages on
 * common problems. To use error-checking mutexes, define the symbol
 * G_ERRORCHECK_MUTEXES when compiling the application.
 */
public class Cond
{
	
	/** the main Gtk struct */
	protected GCond* gCond;
	
	
	public GCond* getCondStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GCond* gCond);

	/**
	 */
	
	/**
	 * Creates a new GCond. This function will abort, if g_thread_init()
	 * has not been called yet.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * If threads are waiting for cond, exactly one of them is woken up. It
	 * is good practice to hold the same lock as the waiting thread while
	 * calling this function, though not required.
	 * This function can be used even if g_thread_init() has not yet been called,
	 * and, in that case, will do nothing.
	 */
	public void signal();
	
	/**
	 * If threads are waiting for cond, all of them are woken up. It is good
	 * practice to lock the same mutex as the waiting threads, while calling
	 * this function, though not required.
	 * This function can be used even if g_thread_init() has not yet been called,
	 * and, in that case, will do nothing.
	 */
	public void broadcast();
	
	/**
	 * Waits until this thread is woken up on cond. The mutex is unlocked
	 * before falling asleep and locked again before resuming.
	 * This function can be used even if g_thread_init() has not yet been
	 * called, and, in that case, will immediately return.
	 * Params:
	 * mutex = a GMutex, that is currently locked.
	 */
	public void wait(Mutex mutex);
	
	/**
	 * Waits until this thread is woken up on cond, but not longer than
	 * until the time specified by abs_time. The mutex is
	 * unlocked before falling asleep and locked again before resuming.
	 * If abs_time is NULL, g_cond_timed_wait() acts like g_cond_wait().
	 * This function can be used even if g_thread_init() has not yet been
	 * called, and, in that case, will immediately return TRUE.
	 * To easily calculate abs_time a combination of g_get_current_time()
	 * and g_time_val_add() can be used.
	 * Params:
	 * mutex = a GMutex that is currently locked.
	 * absTime = a GTimeVal, determining the final time.
	 * Returns:%TRUE if cond was signalled, or FALSE on timeout.
	 */
	public int timedWait(Mutex mutex, TimeVal absTime);
	
	/**
	 * Destroys the GCond.
	 */
	public void free();
}
