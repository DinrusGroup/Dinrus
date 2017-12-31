

module gtkD.gdk.Input;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * The functions in this section are used to establish
 * callbacks when some condition becomes true for
 * a file descriptor. They are currently just wrappers around
 * the IO Channel
 * facility.
 */
public class Input
{
	
	/**
	 */
	
	/**
	 * Warning
	 * gdk_input_add_full is deprecated and should not be used in newly-written code. Use g_io_add_watch_full() on a GIOChannel
	 * Establish a callback when a condition becomes true on
	 * a file descriptor.
	 * Params:
	 * source =  a file descriptor.
	 * condition =  the condition.
	 * data =  callback data passed to function.
	 * destroy =  callback function to call with data when the input
	 * handler is removed.
	 * Returns: a tag that can later be used as an argument togdk_input_remove().
	 */
	public static int addFull(int source, GdkInputCondition condition, GdkInputFunction funct, void* data, GDestroyNotify destroy);
	
	/**
	 * Warning
	 * gdk_input_add is deprecated and should not be used in newly-written code. Use g_io_add_watch() on a GIOChannel
	 * Establish a callback when a condition becomes true on
	 * a file descriptor.
	 * Params:
	 * source =  a file descriptor.
	 * condition =  the condition.
	 * data =  callback data passed to function.
	 * Returns: a tag that can later be used as an argument togdk_input_remove().
	 */
	public static int add(int source, GdkInputCondition condition, GdkInputFunction funct, void* data);
	
	/**
	 * Warning
	 * gdk_input_remove is deprecated and should not be used in newly-written code.
	 * Remove a callback added with gdk_input_add() or
	 * gdk_input_add_full().
	 * Params:
	 * tag = the tag returned when the callback was set up.
	 */
	public static void remove(int tag);
}
