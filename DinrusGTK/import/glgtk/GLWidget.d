
module gtkD.glgtk.GLWidget;

public  import gtkD.gtkglc.glgtktypes;

private import gtkD.gtkglc.glgtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.glgdk.GLDrawable;
private import gtkD.glgdk.GLConfig;
private import gtkD.glgdk.GLContext;
private import gtkD.glgdk.GLWindow;




/**
 * Description
 * GtkGLExt is an extension to GTK which adds OpenGL capabilities to
 * GtkWidget. Its use is quite simple: use gtk_widget_set_gl_capability
 * to add OpenGL support to a widget, it will create a OpenGL drawable
 * (GdkGLDrawable) for the widget, which can be obtained via
 * gtk_widget_get_gl_drawable. OpenGL rendering context (GdkGLContext)
 * can also be obtained via gtk_widget_get_gl_context.
 * With GdkGLDrawable and GdkGLContext, gdk_gl_drawable_gl_begin and
 * gdk_gl_drawable_gl_end can be called, and OpenGL function calls can
 * be made between those two functions.
 */
public class GLWidget
{
	
	/**
	 * Gets the GL Frawable for (from???) the widget
	 * Params:
	 *  widget =
	 * Returns: a new GLDrawable
	 */
	static GLDrawable getGLDrawable(Widget widget);
	
	/**
	 */
	
	/**
	 * Set the OpenGL-capability to the widget.
	 * This function prepares the widget for its use with OpenGL.
	 * Params:
	 * widget =  the GtkWidget to be used as the rendering area.
	 * glconfig =  a GdkGLConfig.
	 * shareList =  the GdkGLContext with which to share display lists and texture
	 *  objects. NULL indicates that no sharing is to take place.
	 * direct =  whether rendering is to be done with a direct connection to
	 *  the graphics system.
	 * renderType =  GDK_GL_RGBA_TYPE or GDK_GL_COLOR_INDEX_TYPE (currently not
	 *  used).
	 * Returns: TRUE if it is successful, FALSE otherwise.
	 */
	public static int setGLCapability(Widget widget, GLConfig glconfig, GLContext shareList, int direct, int renderType);
	
	/**
	 * Returns whether the widget is OpenGL-capable.
	 * Params:
	 * widget =  a GtkWidget.
	 * Returns: TRUE if the widget is OpenGL-capable, FALSE otherwise.
	 */
	public static int isGLCapable(Widget widget);
	
	/**
	 * Returns the GdkGLConfig referred by the widget.
	 * Params:
	 * widget =  a GtkWidget.
	 * Returns: the GdkGLConfig.
	 */
	public static GLConfig getGLConfig(Widget widget);
	
	/**
	 * Creates a new GdkGLContext with the appropriate GdkGLDrawable
	 * for this widget. The GL context must be freed when you're
	 * finished with it. See also gtk_widget_get_gl_context().
	 * Params:
	 * widget =  a GtkWidget.
	 * shareList =  the GdkGLContext with which to share display lists and texture
	 *  objects. NULL indicates that no sharing is to take place.
	 * direct =  whether rendering is to be done with a direct connection to
	 *  the graphics system.
	 * renderType =  GDK_GL_RGBA_TYPE or GDK_GL_COLOR_INDEX_TYPE (currently not
	 *  used).
	 * Returns: the new GdkGLContext.
	 */
	public static GLContext createGLContext(Widget widget, GLContext shareList, int direct, int renderType);
	
	/**
	 * Returns the GdkGLContext with the appropriate GdkGLDrawable
	 * for this widget. Unlike the GL context returned by
	 * gtk_widget_create_gl_context(), this context is owned by the widget.
	 * GdkGLContext is needed for the function gdk_gl_drawable_begin,
	 * or for sharing display lists (see gtk_widget_set_gl_capability()).
	 * Params:
	 * widget =  a GtkWidget.
	 * Returns: the GdkGLContext.
	 */
	public static GLContext getGLContext(Widget widget);
	
	/**
	 * Returns the GdkGLWindow owned by the widget.
	 * Params:
	 * widget =  a GtkWidget.
	 * Returns: the GdkGLWindow.
	 */
	public static GLWindow getGLWindow(Widget widget);
}
