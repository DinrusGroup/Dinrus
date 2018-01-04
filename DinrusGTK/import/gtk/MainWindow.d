module gtkD.gtk.MainWindow;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.gtk.Window;
private import gtkD.gtk.Main;
private import gtkD.gdk.Event;




/**
 * A top Level window that will stop the main event cycle when it's closed.
 * Closing the last of the windows of class "MainWindow" will end the application.
 */
public class MainWindow : Window
{
	
	private static int countTotalMainWindows = 0;
	
	/**
	 * Creates a new MainWindow with a title
	 */
	public this(string title);
	
	/**
	 * Executed when the user tries to close the window
	 * Returns: true to refuse to close the window
	 */
	protected bool windowDelete(Event event, Widget widget);
	
	/**
	 * Allows the application to close and decide if it can exit
	 * Params:
	 *  code = the code reason to exit
	 *  force = if true the application must expect to be closed even against it's will
	 * Returns: false to refuse to exit
	 */
	protected bool exit(int code, bool force);
}

/**
 */

