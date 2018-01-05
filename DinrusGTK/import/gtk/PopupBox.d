module gtkD.gtk.PopupBox;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.MessageDialog;;
private import gtkD.gtk.Window;;




/**
 */
public class PopupBox
{
	
	/**
	 * Create an information popup dialog.
	 * Params:
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static void information(string message, string title);
	
	/**
	 * Create an information popup dialog.
	 * Params:
	 *  parent = The parent window of this popup dialog
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static void information(Window parent, string message, string title);
	
	
	/**
	 * Create an error popup dialog.
	 * Params:
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static void error(string message, string title);
	
	/**
	 * Create an error popup dialog.
	 * Params:
	 *  parent = The parent window of this popup dialog
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static void error(Window parent, string message, string title);
	
	
	
	/**
	 * Create an 'yes' or 'no' popup dialog.
	 * Params:
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static bool yesNo(string message, string title);
	
	/**
	 * Create an 'yes' or 'no' popup dialog.
	 * Params:
	 *  parent = The parent window of this popup dialog
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static bool yesNo(Window parent, string message, string title);
	
	
	/**
	 * Create an 'yes', 'no' or 'cancel' popup dialog.
	 * Params:
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static ResponseType yesNoCancel(string message, string title);
	
	/**
	 * Create an 'yes', 'no' or 'cancel' popup dialog.
	 * Params:
	 *  parent = The parent window of this popup dialog
	 *  message = The message to show on the dialog
	 *  title = The title of the dialog
	 */
	public static ResponseType yesNoCancel(Window parent, string message, string title);
	
	/**
	 */
}
