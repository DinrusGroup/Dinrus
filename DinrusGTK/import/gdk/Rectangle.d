
module gtkD.gdk.Rectangle;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * GDK provides the GdkPoint, GdkRectangle, GdkRegion and GdkSpan data types
 * for representing pixels and sets of pixels on the screen.
 * GdkPoint is a simple structure containing an x and y coordinate of a point.
 * GdkRectangle is a structure holding the position and size of a rectangle.
 * The intersection of two rectangles can be computed with
 * gdk_rectangle_intersect(). To find the union of two rectangles use
 * gdk_rectangle_union().
 * GdkRegion is an opaque data type holding a set of arbitrary pixels, and is
 * usually used for clipping graphical operations (see gdk_gc_set_clip_region()).
 * GdkSpan is a structure holding a spanline. A spanline is a horizontal line that
 * is one pixel wide. It is mainly used when rasterizing other graphics primitives.
 * It can be intersected to regions by using gdk_region_spans_intersect_foreach().
 */
public class Rectangle
{
	
	/** the main Gtk struct */
	protected GdkRectangle* gdkRectangle;
	
	
	public GdkRectangle* getRectangleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkRectangle* gdkRectangle);
	
	/**
	 */
	
	/**
	 * Calculates the intersection of two rectangles. It is allowed for
	 * dest to be the same as either src1 or src2. If the rectangles
	 * do not intersect, dest's width and height is set to 0 and its x
	 * and y values are undefined. If you are only interested in whether
	 * the rectangles intersect, but not in the intersecting area itself,
	 * pass NULL for dest.
	 * Params:
	 * src2 =  a GdkRectangle
	 * dest =  return location for the intersection of src1 and src2, or NULL
	 * Returns: TRUE if the rectangles intersect.
	 */
	public int intersect(Rectangle src2, Rectangle dest);

	/**
	 * Calculates the union of two rectangles.
	 * The union of rectangles src1 and src2 is the smallest rectangle which
	 * includes both src1 and src2 within it.
	 * It is allowed for dest to be the same as either src1 or src2.
	 * Params:
	 * src2 =  a GdkRectangle
	 * dest =  return location for the union of src1 and src2
	 */
	public void unio(Rectangle src2, Rectangle dest);
}
