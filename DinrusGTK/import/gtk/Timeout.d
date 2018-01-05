module gtkD.gtk.Timeout;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * Before using GTK+, you need to initialize it; initialization connects
 * to the window system display, and parses some standard command line
 * arguments. The gtk_init() function initializes GTK+. gtk_init() exits
 * the application if errors occur; to avoid this, use gtk_init_check().
 * gtk_init_check() allows you to recover from a failed GTK+
 * initialization - you might start up your application in text mode instead.
 * Like all GUI toolkits, GTK+ uses an event-driven programming
 * model. When the user is doing nothing, GTK+ sits in the
 * main loop and waits for input. If the user
 * performs some action - say, a mouse click - then the main loop "wakes
 * up" and delivers an event to GTK+. GTK+ forwards the event to one or
 * more widgets.
 * When widgets receive an event, they frequently emit one or more
 * signals. Signals notify your program that
 * "something interesting happened" by invoking functions you've
 * connected to the signal with g_signal_connect(). Functions connected
 * to a signal are often termed callbacks.
 * When your callbacks are invoked, you would typically take some action
 * - for example, when an Open button is clicked you might display a
 * GtkFileSelectionDialog. After a callback finishes, GTK+ will return
 * to the main loop and await more user input.
 * Example 2. Typical main function for a GTK+ application
 * int
 * main (int argc, char **argv)
 * {
	 *  /+* Initialize i18n support +/
	 *  gtk_set_locale ();
	 *  /+* Initialize the widget set +/
	 *  gtk_init (argc, argv);
	 *  /+* Create the main window +/
	 *  mainwin = gtk_window_new (GTK_WINDOW_TOPLEVEL);
	 *  /+* Set up our GUI elements +/
	 *  ...
	 *  /+* Show the application window +/
	 *  gtk_widget_show_all (mainwin);
	 *  /+* Enter the main event loop, and wait for user interaction +/
	 *  gtk_main ();
	 *  /+* The user lost interest +/
	 *  return 0;
 * }
 * It's OK to use the GLib main loop directly instead of gtk_main(),
 * though it involves slightly more typing. See GMainLoop in the GLib
 * documentation.
 */
public class Timeout
{
	
	/** Holds all timeout delegates */
	bool delegate()[] timeoutListeners;
	/** our gtk timeout ID */
	uint timeoutID;
	
	
	/**
	 * Creates a new timeout cycle.
	 * Params:
	 *    	interval = 	the timeout in milieconds
	 *    	delegate() = 	the delegate to be executed
	 *    	fireNow = 	When true the delegate will be executed emmidiatly
	 */
	this(uint interval, bool delegate() dlg, bool fireNow=false);
	
	/** */
	public void stop();
	
	/**
	 * Removes the timeout from gtk
	 */
	~this();
	
	/**
	 * Adds a new delegate to this timeout cycle
	 * Params:
	 *    	dlg =
	 *    	fireNow =
	 */
	public void addListener(bool delegate() dlg, bool fireNow=false);
	
	/**
	 * The callback execution from glib
	 * Params:
	 *    	timeout =
	 * Returns:
	 */
	extern(C) static bool timeoutCallback(Timeout timeout);
	
	/**
	 * Executes all delegates on the execution list
	 * Returns:
	 */
	private bool callAllListeners();
	
	/**
	 */
	
	/**
	 * Warning
	 * gtk_timeout_add_full has been deprecated since version 2.4 and should not be used in newly-written code. Use g_timeout_add_full() instead.
	 * Registers a function to be called periodically. The function will be called
	 * repeatedly after interval milliseconds until it returns FALSE at which
	 * point the timeout is destroyed and will not be called again.
	 * Params:
	 * interval = The time between calls to the function, in milliseconds
	 * 	(1/1000ths of a second.)
	 * marshal = The marshaller to use instead of the function (if non-NULL).
	 * data = The data to pass to the function.
	 * destroy = Function to call when the timeout is destroyed or NULL.
	 * Returns:A unique id for the event source.
	 */
	public static uint addFull(uint interval, GtkFunction funct, GtkCallbackMarshal marshal, void* data, GDestroyNotify destroy);
	
	/**
	 * Warning
	 * gtk_timeout_add has been deprecated since version 2.4 and should not be used in newly-written code. Use g_timeout_add() instead.
	 * Registers a function to be called periodically. The function will be called
	 * repeatedly after interval milliseconds until it returns FALSE at which
	 * point the timeout is destroyed and will not be called again.
	 * Params:
	 * interval = The time between calls to the function, in milliseconds
	 * 	(1/1000ths of a second.)
	 * data = The data to pass to the function.
	 * Returns:A unique id for the event source.
	 */
	public static uint add(uint interval, GtkFunction funct, void* data);
	
	/**
	 * Warning
	 * gtk_timeout_remove has been deprecated since version 2.4 and should not be used in newly-written code. Use g_source_remove() instead.
	 * Removes the given timeout destroying all information about it.
	 * Params:
	 * timeoutHandlerId = The identifier returned when installing the timeout.
	 */
	public static void remove(uint timeoutHandlerId);
}
