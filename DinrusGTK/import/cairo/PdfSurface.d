module gtkD.cairo.PdfSurface;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.cairo.Surface;

/**
 * Description
 * The PDF surface is used to render cairo graphics to Adobe
 * PDF files and is a multi-page vector surface backend.
 */
public class PdfSurface : Surface
{
	
	/** the main Gtk struct */
	protected cairo_surface_t* cairo_surface;
	
	
	public cairo_surface_t* getPdfSurfaceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_surface_t* cairo_surface);
	
	/**
	 */
	
	/**
	 * Creates a PDF surface of the specified size in points to be written
	 * to filename.
	 * Since 1.2
	 * Params:
	 * filename =  a filename for the PDF output (must be writable)
	 * widthInPoints =  width of the surface, in points (1 point == 1/72.0 inch)
	 * heightInPoints =  height of the surface, in points (1 point == 1/72.0 inch)
	 * Returns: a pointer to the newly created surface. The callerowns the surface and should call cairo_surface_destroy() when donewith it.This function always returns a valid pointer, but it will return apointer to a "nil" surface if an error such as out of memoryoccurs. You can use cairo_surface_status() to check for this.
	 */
	public static PdfSurface create(string filename, double widthInPoints, double heightInPoints);
	
	/**
	 * Creates a PDF surface of the specified size in points to be written
	 * incrementally to the stream represented by write_func and closure.
	 * Since 1.2
	 * Params:
	 * writeFunc =  a cairo_write_func_t to accept the output data
	 * closure =  the closure argument for write_func
	 * widthInPoints =  width of the surface, in points (1 point == 1/72.0 inch)
	 * heightInPoints =  height of the surface, in points (1 point == 1/72.0 inch)
	 * Returns: a pointer to the newly created surface. The callerowns the surface and should call cairo_surface_destroy() when donewith it.This function always returns a valid pointer, but it will return apointer to a "nil" surface if an error such as out of memoryoccurs. You can use cairo_surface_status() to check for this.
	 */
	public static PdfSurface createForStream(cairo_write_func_t writeFunc, void* closure, double widthInPoints, double heightInPoints);
	
	/**
	 * Changes the size of a PDF surface for the current (and
	 * subsequent) pages.
	 * This function should only be called before any drawing operations
	 * have been performed on the current page. The simplest way to do
	 * this is to call this function immediately after creating the
	 * surface or immediately after completing a page with either
	 * cairo_show_page() or cairo_copy_page().
	 * Since 1.2
	 * Params:
	 * widthInPoints =  new surface width, in points (1 point == 1/72.0 inch)
	 * heightInPoints =  new surface height, in points (1 point == 1/72.0 inch)
	 */
	public void setSize(double widthInPoints, double heightInPoints);
}
