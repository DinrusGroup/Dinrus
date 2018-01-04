
module gtkD.glib.Timer;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * GTimer records a start time, and counts microseconds elapsed since that time.
 * This is done somewhat differently on different platforms, and can be tricky to
 * get exactly right, so GTimer provides a portable/convenient interface.
 * Note
 * GTimer uses a higher-quality clock when thread support is available.
 * Therefore, calling g_thread_init() while timers are running may lead to
 * unreliable results. It is best to call g_thread_init() before starting
 * any timers, if you are using threads at all.
 */
public class Timer
{
	
	/** the main Gtk struct */
	protected GTimer* gTimer;
	
	
	public GTimer* getTimerStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GTimer* gTimer);
	
	/**
	 */
	
	/**
	 * Creates a new timer, and starts timing (i.e. g_timer_start() is implicitly
	 * called for you).
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Marks a start time, so that future calls to g_timer_elapsed() will report the
	 * time since g_timer_start() was called. g_timer_new() automatically marks the
	 * start time, so no need to call g_timer_start() immediately after creating the
	 * timer.
	 */
	public void start();
	
	/**
	 * Marks an end time, so calls to g_timer_elapsed() will return the difference
	 * between this end time and the start time.
	 */
	public void stop();
	
	/**
	 * Resumes a timer that has previously been stopped with g_timer_stop().
	 * g_timer_stop() must be called before using this function.
	 * Since 2.4
	 */
	public void continu();
	
	/**
	 * If timer has been started but not stopped, obtains the time since the timer was
	 * started. If timer has been stopped, obtains the elapsed time between the time
	 * it was started and the time it was stopped. The return value is the number of
	 * seconds elapsed, including any fractional part. The microseconds
	 * out parameter is essentially useless.
	 * Warning
	 * Calling initialization functions, in particular g_thread_init(),
	 * while a timer is running will cause invalid return values from this function.
	 * Params:
	 * microseconds = return location for the fractional part of seconds elapsed,
	 *  in microseconds (that is, the total number of microseconds elapsed, modulo
	 *  1000000), or NULL
	 * Returns:seconds elapsed as a floating point value, including  any fractional part.
	 */
	public double elapsed(out uint microseconds);
	
	/**
	 * This function is useless; it's fine to call g_timer_start() on an
	 * already-started timer to reset the start time, so g_timer_reset() serves no
	 * purpose.
	 */
	public void reset();
	
	/**
	 * Destroys a timer, freeing associated resources.
	 */
	public void destroy();
}
