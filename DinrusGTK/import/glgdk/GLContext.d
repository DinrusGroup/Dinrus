module gtkD.glgdk.GLContext;

public  import gtkD.gtkglc.glgdktypes;

private import gtkD.gtkglc.glgdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glgdk.GLDrawable;
private import gtkD.glgdk.GLConfig;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class GLContext : ObjectG
{
	
	/** the main Gtk struct */
	protected GdkGLContext* gdkGLContext;
	
	
	public GdkGLContext* getGLContextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkGLContext* gdkGLContext);
	
	/**
	 */
	
	/**
	 * Creates a new OpenGL rendering context.
	 * Params:
	 * gldrawable =  a GdkGLDrawable.
	 * shareList =  the GdkGLContext with which to share display lists and texture
	 *  objects. NULL indicates that no sharing is to take place.
	 * direct =  whether rendering is to be done with a direct connection to
	 *  the graphics system.
	 * renderType =  GDK_GL_RGBA_TYPE or GDK_GL_COLOR_INDEX_TYPE (currently not
	 *  used).
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GLDrawable gldrawable, GLContext shareList, int direct, int renderType);
	
	/**
	 * Destroys the OpenGL resources associated with glcontext and
	 * decrements glcontext's reference count.
	 */
	public void destroy();
	
	/**
	 * Copy state from src rendering context to glcontext.
	 * mask contains the bitwise-OR of the same symbolic names that are passed to
	 * the glPushAttrib() function. You can use GL_ALL_ATTRIB_BITS to copy all the
	 * rendering state information.
	 * Params:
	 * src =  the source context.
	 * Returns: FALSE if it fails, TRUE otherwise.
	 */
	public int copy(GLContext src, ulong mask);
	
	/**
	 * Gets GdkGLDrawable to which the glcontext is bound.
	 * Returns: the GdkGLDrawable or NULL if no GdkGLDrawable is bound.
	 */
	public GLDrawable getGLDrawable();
	
	/**
	 * Gets GdkGLConfig with which the glcontext is configured.
	 * Returns: the GdkGLConfig.
	 */
	public GLConfig getGLConfig();
	
	/**
	 * Gets GdkGLContext with which the glcontext shares the display lists and
	 * texture objects.
	 * Returns: the GdkGLContext.
	 */
	public GLContext getShareList();
	
	/**
	 * Returns whether the glcontext is a direct rendering context.
	 * Returns: TRUE if the glcontext is a direct rendering contest.
	 */
	public int isDirect();
	
	/**
	 * Gets render_type of the glcontext.
	 * Returns: GDK_GL_RGBA_TYPE or GDK_GL_COLOR_INDEX_TYPE.
	 */
	public int getRenderType();
	
	/**
	 * Returns the current GdkGLContext.
	 * Returns: the current GdkGLContext or NULL if there is no current context.<<Frame Buffer ConfigurationRendering Surface>>
	 */
	public static GLContext getCurrent();
}
