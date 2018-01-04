module gtkD.glgdk.GLDrawable;

public  import gtkD.gtkglc.glgdktypes;

private import gtkD.gtkglc.glgdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glgdk.GLContext;
private import gtkD.glgdk.GLConfig;




/**
 * Description
 */
public class GLDrawable
{
	
	/** the main Gtk struct */
	protected GdkGLDrawable* gdkGLDrawable;
	
	
	public GdkGLDrawable* getGLDrawableStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkGLDrawable* gdkGLDrawable);
	
	/**
	 */
	
	/**
	 * Attach an OpenGL rendering context to a gldrawable.
	 * Params:
	 * glcontext =  a GdkGLContext.
	 * Returns: TRUE if it is successful, FALSE otherwise.
	 */
	public int makeCurrent(GLContext glcontext);
	
	/**
	 * Returns whether the gldrawable supports the double-buffered visual.
	 * Returns: TRUE if the double-buffered visual is supported, FALSE otherwise.
	 */
	public int isDoubleBuffered();
	
	/**
	 * Exchange front and back buffers.
	 */
	public void swapBuffers();
	
	/**
	 * Complete OpenGL execution prior to subsequent GDK drawing calls.
	 */
	public void waitGl();
	
	/**
	 * Complete GDK drawing execution prior to subsequent OpenGL calls.
	 */
	public void waitGdk();
	
	/**
	 * Delimits the begining of the OpenGL execution.
	 * Params:
	 * glcontext =  a GdkGLContext.
	 * Returns: TRUE if it is successful, FALSE otherwise.
	 */
	public int glBegin(GLContext glcontext);
	
	/**
	 * Delimits the end of the OpenGL execution.
	 */
	public void glEnd();
	
	/**
	 * Gets GdkGLConfig with which the gldrawable is configured.
	 * Returns: the GdkGLConfig.
	 */
	public GLConfig getGLConfig();
	
	/**
	 * Fills *width and *height with the size of GL drawable.
	 * width or height can be NULL if you only want the other one.
	 * Params:
	 * width =  location to store drawable's width, or NULL.
	 * height =  location to store drawable's height, or NULL.
	 */
	public void getSize(out int width, out int height);
	
	/**
	 * Returns the current GdkGLDrawable.
	 * Returns: the current GdkGLDrawable or NULL if there is no current drawable.<<Rendering ContextOpenGL Pixmap>>
	 */
	public static GLDrawable getCurrent();
}
