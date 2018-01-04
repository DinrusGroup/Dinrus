module gtkD.gstreamer.Task;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * GstTask is used by GstElement and GstPad to provide the data passing
 * threads in a GstPipeline.
 * A GstPad will typically start a GstTask to push or pull data to/from the
 * peer pads. Most source elements start a GstTask to push data. In some cases
 * a demuxer element can start a GstTask to pull data from a peer element. This
 * is typically done when the demuxer can perform random access on the upstream
 * peer element for improved performance.
 * Although convenience functions exist on GstPad to start/pause/stop tasks, it
 * might sometimes be needed to create a GstTask manually if it is not related to
 * a GstPad.
 * Before the GstTask can be run, it needs a GStaticRecMutex that can be set with
 * gst_task_set_lock().
 * The task can be started, paused and stopped with gst_task_start(), gst_task_pause()
 * and gst_task_stop() respectively.
 * A GstTask will repeadedly call the GstTaskFunction with the user data
 * that was provided when creating the task with gst_task_create(). Before calling
 * the function it will acquire the provided lock.
 * Stopping a task with gst_task_stop() will not immediatly make sure the task is
 * not running anymore. Use gst_task_join() to make sure the task is completely
 * stopped and the thread is stopped.
 * After creating a GstTask, use gst_object_unref() to free its resources. This can
 * only be done it the task is not running anymore.
 * Last reviewed on 2006-02-13 (0.10.4)
 */
public class Task : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstTask* gstTask;
	
	
	public GstTask* getTaskStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstTask* gstTask);
	
	/**
	 */
	
	/**
	 * Wait for all tasks to be stopped. This is mainly used internally
	 * to ensure proper cleanup of internal datastructures in testsuites.
	 * MT safe.
	 */
	public static void cleanupAll();
	
	/**
	 * Create a new Task that will repeadedly call the provided func
	 * with data as a parameter. Typically the task will run in
	 * a new thread.
	 * The function cannot be changed after the task has been created. You
	 * must create a new GstTask to change the function.
	 * Params:
	 * func =  The GstTaskFunction to use
	 * data =  User data to pass to func
	 * Returns: A new GstTask.MT safe.
	 */
	public static Task create(GstTaskFunction func, void* data);
	
	/**
	 * Get the current state of the task.
	 * Returns: The GstTaskState of the taskMT safe.
	 */
	public GstTaskState getState();
	
	/**
	 * Joins task. After this call, it is safe to unref the task
	 * and clean up the lock set with gst_task_set_lock().
	 * The task will automatically be stopped with this call.
	 * This function cannot be called from within a task function as this
	 * would cause a deadlock. The function will detect this and print a
	 * g_warning.
	 * Returns: TRUE if the task could be joined.MT safe.
	 */
	public int join();
	
	/**
	 * Pauses task. This method can also be called on a task in the
	 * stopped state, in which case a thread will be started and will remain
	 * in the paused state. This function does not wait for the task to complete
	 * the paused state.
	 * Returns: TRUE if the task could be paused.MT safe.
	 */
	public int pause();
	
	/**
	 * Set the mutex used by the task. The mutex will be acquired before
	 * calling the GstTaskFunction.
	 * This function has to be called before calling gst_task_pause() or
	 * gst_task_start().
	 * MT safe.
	 * Params:
	 * mutex =  The GMutex to use
	 */
	public void setLock(GStaticRecMutex* mutex);
	
	/**
	 * Starts task. The task must have a lock associated with it using
	 * gst_task_set_lock() or thsi function will return FALSE.
	 * Returns: TRUE if the task could be started.MT safe.
	 */
	public int start();
	
	/**
	 * Stops task. This method merely schedules the task to stop and
	 * will not wait for the task to have completely stopped. Use
	 * gst_task_join() to stop and wait for completion.
	 * Returns: TRUE if the task could be stopped.MT safe.
	 */
	public int stop();
}
