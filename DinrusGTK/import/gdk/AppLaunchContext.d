module gtkD.gdk.AppLaunchContext;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Display;
private import gtkD.gdk.Screen;
private import gtkD.gio.IconIF;




/**
 * Description
 * GdkAppLaunchContext is an implementation of GAppLaunchContext that
 * handles launching an application in a graphical context. It provides
 * startup notification and allows to launch applications on a specific
 * screen or workspace.
 * Example 9. Launching an application
 * GdkAppLaunchContext *context;
 * context = gdk_app_launch_context_new ();
 * gdk_app_launch_context_set_screen (my_screen);
 * gdk_app_launch_context_set_timestamp (event->time);
 * if (!g_app_info_launch_default_for_uri ("http://www.gtkD.gtk.org", context, error))
 *  g_warning ("Launching failed: %s\n", error->message);
 * g_object_unref (context);
 */
public class AppLaunchContext
{
	
	/** the main Gtk struct */
	protected GdkAppLaunchContext* gdkAppLaunchContext;
	
	
	public GdkAppLaunchContext* getAppLaunchContextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkAppLaunchContext* gdkAppLaunchContext);
	
	/**
	 */
	
	/**
	 * Creates a new GdkAppLaunchContext.
	 * Since 2.14
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets the display on which applications will be launched when
	 * using this context. See also gdk_app_launch_context_set_screen().
	 * Since 2.14
	 * Params:
	 * display =  a GdkDisplay
	 */
	public void setDisplay(Display display);
	
	/**
	 * Sets the screen on which applications will be launched when
	 * using this context. See also gdk_app_launch_context_set_display().
	 * If both screen and display are set, the screen takes priority.
	 * If neither screen or display are set, the default screen and
	 * display are used.
	 * Since 2.14
	 * Params:
	 * screen =  a GdkScreen
	 */
	public void setScreen(Screen screen);
	
	/**
	 * Sets the workspace on which applications will be launched when
	 * using this context when running under a window manager that
	 * supports multiple workspaces, as described in the
	 * Extended
	 * Window Manager Hints.
	 * When the workspace is not specified or desktop is set to -1,
	 * it is up to the window manager to pick one, typically it will
	 * be the current workspace.
	 * Since 2.14
	 * Params:
	 * desktop =  the number of a workspace, or -1
	 */
	public void setDesktop(int desktop);
	
	/**
	 * Sets the timestamp of context. The timestamp should ideally
	 * be taken from the event that triggered the launch.
	 * Window managers can use this information to avoid moving the
	 * focus to the newly launched application when the user is busy
	 * typing in another window. This is also known as 'focus stealing
	 * prevention'.
	 * Since 2.14
	 * Params:
	 * timestamp =  a timestamp
	 */
	public void setTimestamp(uint timestamp);
	
	/**
	 * Sets the icon for applications that are launched with this
	 * context.
	 * Window Managers can use this information when displaying startup
	 * notification.
	 * See also gdk_app_launch_context_set_icon_name().
	 * Since 2.14
	 * Params:
	 * icon =  a GIcon, or NULL
	 */
	public void setIcon(IconIF icon);
	
	/**
	 * Sets the icon for applications that are launched with this context.
	 * The icon_name will be interpreted in the same way as the Icon field
	 * in desktop files. See also gdk_app_launch_context_set_icon().
	 * If both icon and icon_name are set, the icon_name takes priority.
	 * If neither icon or icon_name is set, the icon is taken from either
	 * the file that is passed to launched application or from the GAppInfo
	 * for the launched application itself.
	 * Since 2.14
	 * Params:
	 * iconName =  an icon name, or NULL
	 */
	public void setIconName(string iconName);
}
