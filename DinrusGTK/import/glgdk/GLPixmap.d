module gtkD.glgdk.GLPixmap;

public  import gtkD.gtkglc.glgdktypes;

private import gtkD.gtkglc.glgdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glgdk.GLConfig;
private import gtkD.gdk.Pixmap;



private import gtkD.gdk.Drawable;

/**
 * Description
 */
public class GLPixmap : Drawable
{
	
	/** the main Gtk struct */
	protected GdkGLPixmap* gdkGLPixmap;
	
	
	public GdkGLPixmap* getGLPixmapStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkGLPixmap* gdkGLPixmap);
	
	/**
	 */
	
	/**
	 * Creates an off-screen rendering area.
	 * attrib_list is currently unused. This must be set to NULL or empty
	 * (first attribute of None). See GLX 1.3 spec.
	 * Params:
	 * glconfig =  a GdkGLConfig.
	 * pixmap =  the GdkPixmap to be used as the rendering area.
	 * attribList =  this must be set to NULL or empty (first attribute of None).
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GLConfig glconfig, Pixmap pixmap, int* attribList);
	
	/**
	 * Destroys the OpenGL resources associated with glpixmap and
	 * decrements glpixmap's reference count.
	 */
	public void destroy();
	
	/**
	 * Returns the GdkPixmap associated with glpixmap.
	 * Notice that GdkGLPixmap is not GdkPixmap, but another
	 * GdkDrawable which have an associated GdkPixmap.
	 * Returns: the GdkPixmap associated with glpixmap.
	 */
	public Pixmap getPixmap();
	
	/**
	 * Set the OpenGL-capability to the pixmap.
	 * This function creates a new GdkGLPixmap held by the pixmap.
	 * attrib_list is currently unused. This must be set to NULL or empty
	 * (first attribute of None).
	 * Params:
	 * pixmap =  the GdkPixmap to be used as the rendering area.
	 * glconfig =  a GdkGLConfig.
	 * attribList =  this must be set to NULL or empty (first attribute of None).
	 * Returns: the GdkGLPixmap used by the pixmap if it is successful, NULL otherwise.
	 */
	public static GLPixmap pixmapSetGLCapability(Pixmap pixmap, GLConfig glconfig, int* attribList);
	
	/**
	 * Unset the OpenGL-capability of the pixmap.
	 * This function destroys the GdkGLPixmap held by the pixmap.
	 * Params:
	 * pixmap =  a GdkPixmap.
	 */
	public static void pixmapUnsetGLCapability(Pixmap pixmap);
	
	/**
	 * Returns whether the pixmap is OpenGL-capable.
	 * Params:
	 * pixmap =  a GdkPixmap.
	 * Returns: TRUE if the pixmap is OpenGL-capable, FALSE otherwise.
	 */
	public static int pixmapIsGLCapable(Pixmap pixmap);
	
	/**
	 * Returns the GdkGLPixmap held by the pixmap.
	 * Params:
	 * pixmap =  a GdkPixmap.
	 * Returns: the GdkGLPixmap.
	 */
	public static GLPixmap pixmapGetGLPixmap(Pixmap pixmap);
}
