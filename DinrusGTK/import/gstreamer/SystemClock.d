module gtkD.gstreamer.SystemClock;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Clock;



private import gtkD.gstreamer.Clock;

/**
 * Description
 * The GStreamer core provides a GstSystemClock based on the system time.
 * Asynchronous callbacks are scheduled from an internal thread.
 * Clock implementors are encouraged to subclass this systemclock as it
 * implements the async notification.
 * Subclasses can however override all of the important methods for sync and
 * async notifications to implement their own callback methods or blocking
 * wait operations.
 * Last reviewed on 2006-03-08 (0.10.4)
 */
public class SystemClock : Clock
{
	
	/** the main Gtk struct */
	protected GstSystemClock* gstSystemClock;
	
	
	public GstSystemClock* getSystemClockStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstSystemClock* gstSystemClock);
	
	/**
	 */
	
	/**
	 * Get a handle to the default system clock. The refcount of the
	 * clock will be increased so you need to unref the clock after
	 * usage.
	 * Returns: the default clock.MT safe.
	 */
	public static Clock obtain();
}
