module gtkD.gtk.MountOperation;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gtk.Window;
private import gtkD.gdk.Screen;
private import gtkD.gio.MountOperation : GioMountOperation = MountOperation;




/**
 * Description
 * The functions and objects described here make working with GTK+ and
 * GIO more convenient. GtkMountOperation is needed when mounting volumes
 * and gtk_show_uri() is a convenient way to launch applications for URIs.
 * Another object that is worth mentioning in this context is
 * GdkAppLaunchContext, which provides visual feedback when lauching
 * applications.
 */
public class MountOperation : GioMountOperation
{
	
	/** the main Gtk struct */
	protected GtkMountOperation* gtkMountOperation;
	
	
	public GtkMountOperation* getGtkMountOperationStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkMountOperation* gtkMountOperation);
	
	/**
	 */
	
	/**
	 * Creates a new GtkMountOperation
	 * Since 2.14
	 * Params:
	 * parent =  transient parent of the window, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Window parent);
	
	/**
	 * Returns whether the GtkMountOperation is currently displaying
	 * a window.
	 * Since 2.14
	 * Returns: TRUE if op is currently displaying a window
	 */
	public int isShowing();
	
	/**
	 * Sets the transient parent for windows shown by the
	 * GtkMountOperation.
	 * Since 2.14
	 * Params:
	 * parent =  transient parent of the window, or NULL
	 */
	public void setParent(Window parent);
	
	/**
	 * Gets the transient parent used by the GtkMountOperation
	 * Since 2.14
	 * Returns: the transient parent for windows shown by op
	 */
	public Window getParent();
	
	/**
	 * Sets the screen to show windows of the GtkMountOperation on.
	 * Since 2.14
	 * Params:
	 * screen =  a GdkScreen
	 */
	public void setScreen(Screen screen);
	
	/**
	 * Gets the screen on which windows of the GtkMountOperation
	 * will be shown.
	 * Since 2.14
	 * Returns: the screen on which windows of op are shown
	 */
	public Screen getScreen();
	
	/**
	 * This is a convenience function for launching the default application
	 * to show the uri. The uri must be of a form understood by GIO. Typical
	 * examples are
	 * file:///home/gnome/pict.jpg
	 * http://www.gnome.org
	 * mailto:me@gnome.org
	 * Ideally the timestamp is taken from the event triggering
	 * the gtk_show_uri() call. If timestamp is not known you can take
	 * GDK_CURRENT_TIME.
	 * This function can be used as a replacement for gnome_vfs_url_show()
	 * and gnome_url_show().
	 * Since 2.14
	 * Params:
	 * screen =  screen to show the uri on or NULL for the default screen
	 * uri =  the uri to show
	 * timestamp =  a timestamp to prevent focus stealing.
	 * Returns: TRUE on success, FALSE on error.
	 * Throws: GException on failure.
	 */
	public static int showUri(Screen screen, string uri, uint timestamp);
}
