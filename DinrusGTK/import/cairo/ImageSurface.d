module gtkD.cairo.ImageSurface;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.cairo.Surface;

/**
 * Description
 * Image surfaces provide the ability to render to memory buffers
 * either allocated by cairo or by the calling code. The supported
 * image formats are those defined in cairo_format_t.
 */
public class ImageSurface : Surface
{
	
	/** the main Gtk struct */
	protected cairo_surface_t* cairo_surface;
	
	
	public cairo_surface_t* getImageSurfaceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_surface_t* cairo_surface);
	
	/**
	 * Description
	 * The PNG functions allow reading PNG images into image surfaces, and writing
	 * any surface to a PNG file.
	 */
	
	/**
	 * This function provides a stride value that will respect all
	 * alignment requirements of the accelerated image-rendering code
	 * Since 1.6
	 * Params:
	 * format =  A cairo_format_t value
	 * width =  The desired width of an image surface to be created.
	 * Returns: the appropriate stride to use given the desiredformat and width, or -1 if either the format is invalid or the widthtoo large.
	 */
	public static int formatStrideForWidth(cairo_format_t format, int width);
	
	/**
	 * Creates an image surface of the specified format and
	 * dimensions. Initially the surface contents are all
	 * 0. (Specifically, within each pixel, each color or alpha channel
	 * belonging to format will be 0. The contents of bits within a pixel,
	 * but not belonging to the given format are undefined).
	 * Params:
	 * format =  format of pixels in the surface to create
	 * width =  width of the surface, in pixels
	 * height =  height of the surface, in pixels
	 * Returns: a pointer to the newly created surface. The callerowns the surface and should call cairo_surface_destroy() when donewith it.This function always returns a valid pointer, but it will return apointer to a "nil" surface if an error such as out of memoryoccurs. You can use cairo_surface_status() to check for this.
	 */
	public static ImageSurface create(cairo_format_t format, int width, int height);
	
	/**
	 * Creates an image surface for the provided pixel data. The output
	 * buffer must be kept around until the cairo_surface_t is destroyed
	 * or cairo_surface_finish() is called on the surface. The initial
	 * contents of buffer will be used as the initial image contents; you
	 * must explicitly clear the buffer, using, for example,
	 * cairo_rectangle() and cairo_fill() if you want it cleared.
	 * Note that the stride may be larger than
	 * width*bytes_per_pixel to provide proper alignment for each pixel
	 * and row. This alignment is required to allow high-performance rendering
	 * within gtkD.cairo. The correct way to obtain a legal stride value is to
	 * call cairo_format_stride_for_width() with the desired format and
	 * maximum image width value, and the use the resulting stride value
	 * to allocate the data and to create the image surface. See
	 * cairo_format_stride_for_width() for example code.
	 * Params:
	 * data =  a pointer to a buffer supplied by the application in which
	 *  to write contents. This pointer must be suitably aligned for any
	 *  kind of variable, (for example, a pointer returned by malloc).
	 * format =  the format of pixels in the buffer
	 * width =  the width of the image to be stored in the buffer
	 * height =  the height of the image to be stored in the buffer
	 * stride =  the number of bytes between the start of rows in the
	 *  buffer as allocated. This value should always be computed by
	 *  cairo_format_stride_for_width() before allocating the data
	 *  buffer.
	 * Returns: a pointer to the newly created surface. The callerowns the surface and should call cairo_surface_destroy() when donewith it.This function always returns a valid pointer, but it will return apointer to a "nil" surface in the case of an error such as out ofmemory or an invalid stride value. In case of invalid stride valuethe error status of the returned surface will beCAIRO_STATUS_INVALID_STRIDE. You can usecairo_surface_status() to check for this.See cairo_surface_set_user_data() for a means of attaching adestroy-notification fallback to the surface if necessary.
	 */
	public static ImageSurface createForData(ubyte* data, cairo_format_t format, int width, int height, int stride);
	
	/**
	 * Get a pointer to the data of the image surface, for direct
	 * inspection or modification.
	 * Since 1.2
	 * Returns: a pointer to the image data of this surface or NULLif surface is not an image surface.
	 */
	public ubyte* getData();
	
	/**
	 * Get the format of the surface.
	 * Since 1.2
	 * Returns: the format of the surface
	 */
	public cairo_format_t getFormat();
	
	/**
	 * Get the width of the image surface in pixels.
	 * Returns: the width of the surface in pixels.
	 */
	public int getWidth();
	
	/**
	 * Get the height of the image surface in pixels.
	 * Returns: the height of the surface in pixels.
	 */
	public int getHeight();
	
	/**
	 * Get the stride of the image surface in bytes
	 * Since 1.2
	 * Returns: the stride of the image surface in bytes (or 0 ifsurface is not an image surface). The stride is the distance inbytes from the beginning of one row of the image data to thebeginning of the next row.
	 */
	public int getStride();
	
	/**
	 * Creates a new image surface and initializes the contents to the
	 * given PNG file.
	 * Params:
	 * filename =  name of PNG file to load
	 * Returns: a new cairo_surface_t initialized with the contentsof the PNG file, or a "nil" surface if any error occurred. A nilsurface can be checked for with cairo_surface_status(surface) which
	 */
	public static ImageSurface createFromPng(string filename);
	
	/**
	 * Creates a new image surface from PNG data read incrementally
	 * via the read_func function.
	 * Params:
	 * readFunc =  function called to read the data of the file
	 * closure =  data to pass to read_func.
	 * Returns: a new cairo_surface_t initialized with the contentsof the PNG file or NULL if the data read is not a valid PNG image ormemory could not be allocated for the operation.
	 */
	public static ImageSurface createFromPngStream(cairo_read_func_t readFunc, void* closure);
	
	/**
	 * Writes the contents of surface to a new file filename as a PNG
	 * image.
	 * Params:
	 * filename =  the name of a file to write to
	 * Returns: CAIRO_STATUS_SUCCESS if the PNG file was writtensuccessfully. Otherwise, CAIRO_STATUS_NO_MEMORY if memory could notbe allocated for the operation orCAIRO_STATUS_SURFACE_TYPE_MISMATCH if the surface does not havepixel contents, or CAIRO_STATUS_WRITE_ERROR if an I/O error occurswhile attempting to write the file.
	 */
	public cairo_status_t writeToPng(string filename);
	
	/**
	 * Writes the image surface to the write function.
	 * Params:
	 * writeFunc =  a cairo_write_func_t
	 * closure =  closure data for the write function
	 * Returns: CAIRO_STATUS_SUCCESS if the PNG file was writtensuccessfully. Otherwise, CAIRO_STATUS_NO_MEMORY is returned ifmemory could not be allocated for the operation,CAIRO_STATUS_SURFACE_TYPE_MISMATCH if the surface does not havepixel contents.
	 */
	public cairo_status_t writeToPngStream(cairo_write_func_t writeFunc, void* closure);
}
