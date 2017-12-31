module gtkD.cairo.SvgSurface;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.cairo.Surface;

/**
 * Description
 * The SVG surface is used to render cairo graphics to
 * SVG files and is a multi-page vector surface backend.
 */
public class SvgSurface : Surface
{
	
	/** the main Gtk struct */
	protected cairo_surface_t* cairo_surface;
	
	
	public cairo_surface_t* getSvgSurfaceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_surface_t* cairo_surface);
	
	/**
	 */
	
	/**
	 * Creates a SVG surface of the specified size in points to be written
	 * to filename.
	 * Since 1.2
	 * Params:
	 * filename =  a filename for the SVG output (must be writable)
	 * widthInPoints =  width of the surface, in points (1 point == 1/72.0 inch)
	 * heightInPoints =  height of the surface, in points (1 point == 1/72.0 inch)
	 * Returns: a pointer to the newly created surface. The callerowns the surface and should call cairo_surface_destroy() when donewith it.This function always returns a valid pointer, but it will return apointer to a "nil" surface if an error such as out of memoryoccurs. You can use cairo_surface_status() to check for this.
	 */
	public static SvgSurface create(string filename, double widthInPoints, double heightInPoints);
	
	/**
	 * Creates a SVG surface of the specified size in points to be written
	 * incrementally to the stream represented by write_func and closure.
	 * Since 1.2
	 * Params:
	 * writeFunc =  a cairo_write_func_t to accept the output data
	 * closure =  the closure argument for write_func
	 * widthInPoints =  width of the surface, in points (1 point == 1/72.0 inch)
	 * heightInPoints =  height of the surface, in points (1 point == 1/72.0 inch)
	 * Returns: a pointer to the newly created surface. The callerowns the surface and should call cairo_surface_destroy() when donewith it.This function always returns a valid pointer, but it will return apointer to a "nil" surface if an error such as out of memoryoccurs. You can use cairo_surface_status() to check for this.
	 */
	public static SvgSurface createForStream(cairo_write_func_t writeFunc, void* closure, double widthInPoints, double heightInPoints);
	
	/**
	 * Restricts the generated SVG file to version. See cairo_svg_get_versions()
	 * for a list of available version values that can be used here.
	 * This function should only be called before any drawing operations
	 * have been performed on the given surface. The simplest way to do
	 * this is to call this function immediately after creating the
	 * surface.
	 * Since 1.2
	 * Params:
	 * version =  SVG version
	 */
	public void restrictToVersion(cairo_svg_version_t versio);
	
	/**
	 * Used to retrieve the list of supported versions. See
	 * cairo_svg_surface_restrict_to_version().
	 * Since 1.2
	 * Params:
	 * versions =  supported version list
	 */
	public static void getVersions(out cairo_svg_version_t[] versions);
	
	/**
	 * Get the string representation of the given version id. This function
	 * will return NULL if version isn't valid. See cairo_svg_get_versions()
	 * for a way to get the list of valid version ids.
	 * Since 1.2
	 * Params:
	 * version =  a version id
	 * Returns: the string associated to given version.
	 */
	public static string versionToString(cairo_svg_version_t versio);
}
