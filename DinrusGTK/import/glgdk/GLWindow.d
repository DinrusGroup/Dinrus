
module gtkD.glgdk.GLWindow;

public  import gtkD.gtkglc.glgdktypes;

private import gtkD.gtkglc.glgdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glgdk.GLConfig;
private import gtkD.gdk.Window;



private import gtkD.gdk.Drawable;

/**
 * Description
 */
public class GLWindow : Drawable
{
	
	/** the main Gtk struct */
	protected GdkGLWindow* gdkGLWindow;
	
	
	public GdkGLWindow* getGLWindowStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkGLWindow* gdkGLWindow);
	
	/**
	 */
	
	/**
	 * Creates an on-screen rendering area.
	 * attrib_list is currently unused. This must be set to NULL or empty
	 * (first attribute of None). See GLX 1.3 spec.
	 * Params:
	 * glconfig =  a GdkGLConfig.
	 * window =  the GdkWindow to be used as the rendering area.
	 * attribList =  this must be set to NULL or empty (first attribute of None).
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GLConfig glconfig, Window window, int* attribList);
	
	/**
	 * Destroys the OpenGL resources associated with glwindow and
	 * decrements glwindow's reference count.
	 */
	public void destroy();
	
	/**
	 * Returns the GdkWindow associated with glwindow.
	 * Notice that GdkGLWindow is not GdkWindow, but another
	 * GdkDrawable which have an associated GdkWindow.
	 * Returns: the GdkWindow associated with glwindow.
	 */
	public Window getWindow();
	
	/**
	 * Set the OpenGL-capability to the window.
	 * This function creates a new GdkGLWindow held by the window.
	 * attrib_list is currently unused. This must be set to NULL or empty
	 * (first attribute of None).
	 * Params:
	 * window =  the GdkWindow to be used as the rendering area.
	 * glconfig =  a GdkGLConfig.
	 * attribList =  this must be set to NULL or empty (first attribute of None).
	 * Returns: the GdkGLWindow used by the window if it is successful, NULL otherwise.
	 */
	public static GLWindow gdkWindowSetGLCapability(Window window, GLConfig glconfig, int* attribList);
	
	/**
	 * Unset the OpenGL-capability of the window.
	 * This function destroys the GdkGLWindow held by the window.
	 * Params:
	 * window =  a GdkWindow.
	 */
	public static void gdkWindowUnsetGLCapability(Window window);
	
	/**
	 * Returns whether the window is OpenGL-capable.
	 * Params:
	 * window =  a GdkWindow.
	 * Returns: TRUE if the window is OpenGL-capable, FALSE otherwise.
	 */
	public static int gdkWindowIsGLCapable(Window window);
	
	/**
	 * Returns the GdkGLWindow held by the window.
	 * Params:
	 * window =  a GdkWindow.
	 * Returns: the GdkGLWindow.
	 */
	public static GLWindow gdkWindowGetGLWindow(Window window);
}
