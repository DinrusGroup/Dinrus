module gtkD.glgdk.GLConfig;

public  import gtkD.gtkglc.glgdktypes;

private import gtkD.gtkglc.glgdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Screen;
private import gtkD.gdk.Colormap;
private import gtkD.gdk.Visual;

version(Rulada)
	private import tango.io.Stdout;

version(Dinrus)
	private import dinrus;

private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class GLConfig : ObjectG
{

	/** the main Gtk struct */
	protected GdkGLConfig* gdkGLConfig;


	public GdkGLConfig* getGLConfigStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkGLConfig* gdkGLConfig);

	/**
	 * Creates a mew OpenGL frame buffer configuration that match the specified display mode,
	 * or the fallback mode.
	 * Params:
	 *  mode = display mode bit mask.
	 *  fallback = Try this mode if first fails.
	 * Throws: ConstructionException if configuring GL fails
	 */
	this(GLConfigMode mode, GLConfigMode fallback);


	/**
	 */

	/**
	 * Returns an OpenGL frame buffer configuration that match the specified
	 * attributes.
	 * attrib_list is a int array that contains the attribute/value pairs.
	 * Available attributes are:
	 * GDK_GL_USE_GL, GDK_GL_BUFFER_SIZE, GDK_GL_LEVEL, GDK_GL_RGBA,
	 * GDK_GL_DOUBLEBUFFER, GDK_GL_STEREO, GDK_GL_AUX_BUFFERS,
	 * GDK_GL_RED_SIZE, GDK_GL_GREEN_SIZE, GDK_GL_BLUE_SIZE, GDK_GL_ALPHA_SIZE,
	 * GDK_GL_DEPTH_SIZE, GDK_GL_STENCIL_SIZE, GDK_GL_ACCUM_RED_SIZE,
	 * GDK_GL_ACCUM_GREEN_SIZE, GDK_GL_ACCUM_BLUE_SIZE, GDK_GL_ACCUM_ALPHA_SIZE.
	 * Params:
	 * attribList =  a list of attribute/value pairs. The last attribute must
	 *  be GDK_GL_ATTRIB_LIST_NONE.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int[] attribList);

	/**
	 * Returns an OpenGL frame buffer configuration that match the specified
	 * attributes.
	 * Params:
	 * screen =  target screen.
	 * attribList =  a list of attribute/value pairs. The last attribute must
	 *  be GDK_GL_ATTRIB_LIST_NONE.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Screen screen, int[] attribList);

	/**
	 * Returns an OpenGL frame buffer configuration that match the specified
	 * display mode.
	 * Params:
	 * mode =  display mode bit mask.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdkGLConfigMode mode);

	/**
	 * Returns an OpenGL frame buffer configuration that match the specified
	 * display mode.
	 * Params:
	 * screen =  target screen.
	 * mode =  display mode bit mask.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Screen screen, GdkGLConfigMode mode);

	/**
	 * Gets GdkScreen.
	 * Returns: the GdkScreen.
	 */
	public Screen getScreen();

	/**
	 * Gets information about a OpenGL frame buffer configuration.
	 * Params:
	 * attribute =  the attribute to be returned.
	 * value =  returns the requested value.
	 * Returns: TRUE if it succeeded, FALSE otherwise.
	 */
	public int getAttrib(int attribute, out int value);

	/**
	 * Gets the GdkColormap that is appropriate for the OpenGL frame buffer
	 * configuration.
	 * Returns: the appropriate GdkColormap.
	 */
	public Colormap getColormap();

	/**
	 * Gets the GdkVisual that is appropriate for the OpenGL frame buffer
	 * configuration.
	 * Returns: the appropriate GdkVisual.
	 */
	public Visual getVisual();

	/**
	 * Gets the color depth of the OpenGL-capable visual.
	 * Returns: number of bits per pixel
	 */
	public int getDepth();

	/**
	 * Gets the layer plane (level) of the frame buffer.
	 * Zero is the default frame buffer.
	 * Positive layer planes correspond to frame buffers that overlay the default
	 * buffer, and negative layer planes correspond to frame buffers that underlie
	 * the default frame buffer.
	 * Returns: layer plane.
	 */
	public int getLayerPlane();

	/**
	 * Gets the number of auxiliary color buffers.
	 * Returns: number of auxiliary color buffers.
	 */
	public int getNAuxBuffers();

	/**
	 * Gets the number of multisample buffers.
	 * Returns: number of multisample buffers.
	 */
	public int getNSampleBuffers();

	/**
	 * Returns whether the configured frame buffer is RGBA mode.
	 * Returns: TRUE if the configured frame buffer is RGBA mode, FALSE otherwise.
	 */
	public int isRgba();

	/**
	 * Returns whether the configuration supports the double-buffered visual.
	 * Returns: TRUE if the double-buffered visual is supported, FALSE otherwise.
	 */
	public int isDoubleBuffered();

	/**
	 * Returns whether the configuration supports the stereo visual.
	 * Returns: TRUE if the stereo visual is supported, FALSE otherwise.
	 */
	public int isStereo();

	/**
	 * Returns whether the configured color buffer has alpha bits.
	 * Returns: TRUE if the color buffer has alpha bits, FALSE otherwise.
	 */
	public int hasAlpha();

	/**
	 * Returns whether the configured frame buffer has depth buffer.
	 * Returns: TRUE if the frame buffer has depth buffer, FALSE otherwise.
	 */
	public int hasDepthBuffer();

	/**
	 * Returns whether the configured frame buffer has stencil buffer.
	 * Returns: TRUE if the frame buffer has stencil buffer, FALSE otherwise.
	 */
	public int hasStencilBuffer();

	/**
	 * Returns whether the configured frame buffer has accumulation buffer.
	 * Returns: TRUE if the frame buffer has accumulation buffer, FALSE otherwise.<<QueryRendering Context>>
	 */
	public int hasAccumBuffer();
}
