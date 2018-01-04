module gtkD.gthread.StaticMutex;

public  import gtkD.gtkc.gthreadtypes;

private import gtkD.gtkc.gthread;
private import gtkD.glib.ConstructionException;


private import gtkD.gthread.Mutex;




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
public class StaticMutex
{
	
	/** the main Gtk struct */
	protected GStaticMutex* gStaticMutex;
	
	
	public GStaticMutex* getStaticMutexStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GStaticMutex* gStaticMutex);
	
	/**
	 * Creates a new initialized StaticMutex.
	 */
	public this ();
	
	/**
	 */
	
	/**
	 * Initializes mutex. Alternatively you can initialize it with
	 * G_STATIC_MUTEX_INIT.
	 */
	public void init();
	
	/**
	 * Works like g_mutex_lock(), but for a GStaticMutex.
	 */
	public void lock();
	
	/**
	 * Works like g_mutex_trylock(), but for a GStaticMutex.
	 * Returns:%TRUE, if the GStaticMutex could be locked.
	 */
	public int trylock();

	/**
	 * Works like g_mutex_unlock(), but for a GStaticMutex.
	 */
	public void unlock();
	
	/**
	 * For some operations (like g_cond_wait()) you must have a GMutex
	 * instead of a GStaticMutex. This function will return the
	 * corresponding GMutex for mutex.
	 * Returns:the GMutex corresponding to mutex.
	 */
	public Mutex getMutex();
	
	/**
	 * Releases all resources allocated to mutex.
	 * You don't have to call this functions for a GStaticMutex with an
	 * unbounded lifetime, i.e. objects declared 'static', but if you have a
	 * GStaticMutex as a member of a structure and the structure is freed,
	 * you should also free the GStaticMutex.
	 * Note
	 * Calling g_static_mutex_free() on a locked mutex may result in undefined behaviour.
	 */
	public void free();
}
