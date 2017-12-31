module gtkD.gdk.ImageGdk;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Visual;
private import gtkD.gdk.Drawable;
private import gtkD.gdk.Colormap;




/**
 * Description
 * The GdkImage type represents an area for drawing graphics.
 * It has now been superceded to a large extent by the much more flexible
 * GdkRGB functions.
 * To create an empty GdkImage use gdk_image_new().
 * To create a GdkImage from bitmap data use gdk_image_new_bitmap().
 * To create an image from part of a GdkWindow use gdk_drawable_get_image().
 * The image can be manipulated with gdk_image_get_pixel() and
 * gdk_image_put_pixel(), or alternatively by changing the actual pixel data.
 * Though manipulating the pixel data requires complicated code to cope with
 * the different formats that may be used.
 * To draw a GdkImage in a GdkWindow or GdkPixmap use gdk_draw_image().
 * To destroy a GdkImage use gdk_image_destroy().
 */
public class ImageGdk
{
	
	/** the main Gtk struct */
	protected GdkImage* gdkImage;
	
	
	public GdkImage* getImageGdkStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkImage* gdkImage);
	
	/**
	 */
	
	/**
	 * Creates a new GdkImage.
	 * Params:
	 * type = the type of the GdkImage, one of GDK_IMAGE_NORMAL, GDK_IMAGE_SHARED
	 * and GDK_IMAGE_FASTEST. GDK_IMAGE_FASTEST is probably the best choice, since
	 * it will try creating a GDK_IMAGE_SHARED image first and if that fails it will
	 * then use GDK_IMAGE_NORMAL.
	 * visual = the GdkVisual to use for the image.
	 * width = the width of the image in pixels.
	 * height = the height of the image in pixels.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdkImageType type, Visual visual, int width, int height);
	
	/**
	 * Warning
	 * gdk_image_new_bitmap is deprecated and should not be used in newly-written code.
	 * Creates a new GdkImage with a depth of 1 from the given data.
	 * Warning
	 * THIS FUNCTION IS INCREDIBLY BROKEN. The passed-in data must
	 * be allocated by malloc() (NOT g_malloc()) and will be freed when the
	 * image is freed.
	 * Params:
	 * visual =  the GdkVisual to use for the image.
	 * data =  the pixel data.
	 * width =  the width of the image in pixels.
	 * height =  the height of the image in pixels.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Visual visual, void* data, int width, int height);
	
	/**
	 * Warning
	 * gdk_image_get is deprecated and should not be used in newly-written code.
	 * This is a deprecated wrapper for gdk_drawable_get_image();
	 * gdk_drawable_get_image() should be used instead. Or even better: in
	 * most cases gdk_pixbuf_get_from_drawable() is the most convenient
	 * choice.
	 * Params:
	 * drawable =  a GdkDrawable
	 * x =  x coordinate in window
	 * y =  y coordinate in window
	 * width =  width of area in window
	 * height =  height of area in window
	 * Returns: a new GdkImage or NULL
	 */
	public static ImageGdk get(Drawable drawable, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gdk_image_ref is deprecated and should not be used in newly-written code.
	 * Deprecated function; use g_object_ref() instead.
	 * Returns: the image
	 */
	public ImageGdk doref();
	
	/**
	 * Warning
	 * gdk_image_unref is deprecated and should not be used in newly-written code.
	 * Deprecated function; use g_object_unref() instead.
	 */
	public void unref();
	
	/**
	 * Retrieves the colormap for a given image, if it exists. An image
	 * will have a colormap if the drawable from which it was created has
	 * a colormap, or if a colormap was set explicitely with
	 * gdk_image_set_colormap().
	 * Returns: colormap for the image
	 */
	public Colormap getColormap();
	
	/**
	 * Sets the colormap for the image to the given colormap. Normally
	 * there's no need to use this function, images are created with the
	 * correct colormap if you get the image from a drawable. If you
	 * create the image from scratch, use the colormap of the drawable you
	 * intend to render the image to.
	 * Params:
	 * colormap =  a GdkColormap
	 */
	public void setColormap(Colormap colormap);
	
	/**
	 * Sets a pixel in a GdkImage to a given pixel value.
	 * Params:
	 * x = the x coordinate of the pixel to set.
	 * y = the y coordinate of the pixel to set.
	 * pixel = the pixel value to set.
	 */
	public void putPixel(int x, int y, uint pixel);
	
	/**
	 * Gets a pixel value at a specified position in a GdkImage.
	 * Params:
	 * x = the x coordinate of the pixel to get.
	 * y = the y coordinate of the pixel to get.
	 * Returns:the pixel value at the given position.
	 */
	public uint getPixel(int x, int y);
}
