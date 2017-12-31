module gtkD.gio.IOSchedulerJob;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.Cancellable;




/**
 * Description
 * Schedules asynchronous I/O operations. GIOScheduler integrates
 * into the main event loop (GMainLoop) and may use threads if they
 * are available.
 * Each I/O operation has a priority, and the scheduler uses the priorities
 * to determine the order in which operations are executed. They are
 * not used to determine system-wide I/O scheduling.
 * Priorities are integers, with lower numbers indicating higher priority.
 * It is recommended to choose priorities between G_PRIORITY_LOW and
 * G_PRIORITY_HIGH, with G_PRIORITY_DEFAULT as a default.
 */
public class IOSchedulerJob
{
	
	/** the main Gtk struct */
	protected GIOSchedulerJob* gIOSchedulerJob;
	
	
	public GIOSchedulerJob* getIOSchedulerJobStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GIOSchedulerJob* gIOSchedulerJob);
	
	/**
	 */
	
	/**
	 * Schedules the I/O job to run.
	 * notify will be called on user_data after job_func has returned,
	 * regardless whether the job was cancelled or has run to completion.
	 * If cancellable is not NULL, it can be used to cancel the I/O job
	 * by calling g_cancellable_cancel() or by calling
	 * g_io_scheduler_cancel_all_jobs().
	 * Params:
	 * jobFunc =  a GIOSchedulerJobFunc.
	 * userData =  data to pass to job_func
	 * notify =  a GDestroyNotify for user_data, or NULL
	 * ioPriority =  the I/O priority
	 * of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 */
	public static void pushJob(GIOSchedulerJobFunc jobFunc, void* userData, GDestroyNotify notify, int ioPriority, Cancellable cancellable);
	
	/**
	 * Cancels all cancellable I/O jobs.
	 * A job is cancellable if a GCancellable was passed into
	 * g_io_scheduler_push_job().
	 */
	public static void cancelAllJobs();
	
	/**
	 * Used from an I/O job to send a callback to be run in the thread
	 * that the job was started from, waiting for the result (and thus
	 * blocking the I/O job).
	 * Params:
	 * func =  a GSourceFunc callback that will be called in the original thread
	 * userData =  data to pass to func
	 * notify =  a GDestroyNotify for user_data, or NULL
	 * Returns: The return value of func
	 */
	public int sendToMainloop(GSourceFunc func, void* userData, GDestroyNotify notify);
	
	/**
	 * Used from an I/O job to send a callback to be run asynchronously in
	 * the thread that the job was started from. The callback will be run
	 * when the main loop is available, but at that time the I/O job might
	 * have finished. The return value from the callback is ignored.
	 * Note that if you are passing the user_data from g_io_scheduler_push_job()
	 * on to this function you have to ensure that it is not freed before
	 * func is called, either by passing NULL as notify to
	 * g_io_scheduler_push_job() or by using refcounting for user_data.
	 * Params:
	 * func =  a GSourceFunc callback that will be called in the original thread
	 * userData =  data to pass to func
	 * notify =  a GDestroyNotify for user_data, or NULL
	 */
	public void sendToMainloopAsync(GSourceFunc func, void* userData, GDestroyNotify notify);
}
