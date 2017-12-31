
module gtkD.gdk.Region;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Rectangle;




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
public class Region
{
	
	/** the main Gtk struct */
	protected GdkRegion* gdkRegion;
	
	
	public GdkRegion* getRegionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkRegion* gdkRegion);
	
	/**
	 */
	
	/**
	 * Creates a new empty GdkRegion.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GdkRegion using the polygon defined by a
	 * number of points.
	 * Params:
	 * points =  an array of GdkPoint structs
	 * fillRule =  specifies which pixels are included in the region when the
	 *  polygon overlaps itself.
	 * Returns: a new GdkRegion based on the given polygon
	 */
	public static Region polygon(GdkPoint[] points, GdkFillRule fillRule);
	
	/**
	 * Copies region, creating an identical new region.
	 * Returns: a new region identical to region
	 */
	public Region copy();
	
	/**
	 * Creates a new region containing the area rectangle.
	 * Params:
	 * rectangle =  a GdkRectangle
	 * Returns: a new region
	 */
	public static Region rectangle(Rectangle rectangle);
	
	/**
	 * Destroys a GdkRegion.
	 */
	public void destroy();
	
	/**
	 * Obtains the smallest rectangle which includes the entire GdkRegion.
	 * Params:
	 * rectangle =  return location for the clipbox
	 */
	public void getClipbox(Rectangle rectangle);
	
	/**
	 * Obtains the area covered by the region as a list of rectangles.
	 * The array returned in rectangles must be freed with g_free().
	 * Params:
	 * rectangles =  return location for an array of rectangles
	 */
	public void getRectangles(out GdkRectangle[] rectangles);
	
	/**
	 * Finds out if the GdkRegion is empty.
	 * Returns: TRUE if region is empty.
	 */
	public int empty();
	
	/**
	 * Finds out if the two regions are the same.
	 * Params:
	 * region2 =  a GdkRegion
	 * Returns: TRUE if region1 and region2 are equal.
	 */
	public int equal(Region region2);
	
	/**
	 * Finds out if a regions is the same as a rectangle.
	 * Since 2.18
	 * Params:
	 * rectangle =  a GdkRectangle
	 * Returns: TRUE if region and rectangle are equal.
	 */
	public int rectEqual(Rectangle rectangle);
	
	/**
	 * Finds out if a point is in a region.
	 * Params:
	 * x =  the x coordinate of a point
	 * y =  the y coordinate of a point
	 * Returns: TRUE if the point is in region.
	 */
	public int pointIn(int x, int y);
	
	/**
	 * Tests whether a rectangle is within a region.
	 * Params:
	 * rectangle =  a GdkRectangle.
	 * Returns: GDK_OVERLAP_RECTANGLE_IN, GDK_OVERLAP_RECTANGLE_OUT, or GDK_OVERLAP_RECTANGLE_PART, depending on whether the rectangle is inside, outside, or partly inside the GdkRegion, respectively.
	 */
	public GdkOverlapType rectIn(Rectangle rectangle);
	
	/**
	 * Moves a region the specified distance.
	 * Params:
	 * dx =  the distance to move the region horizontally
	 * dy =  the distance to move the region vertically
	 */
	public void offset(int dx, int dy);
	
	/**
	 * Resizes a region by the specified amount.
	 * Positive values shrink the region. Negative values expand it.
	 * Params:
	 * dx =  the number of pixels to shrink the region horizontally
	 * dy =  the number of pixels to shrink the region vertically
	 */
	public void shrink(int dx, int dy);
	
	/**
	 * Sets the area of region to the union of the areas of region and
	 * rect. The resulting area is the set of pixels contained in
	 * either region or rect.
	 * Params:
	 * rect =  a GdkRectangle.
	 */
	public void unionWithRect(Rectangle rect);

	/**
	 * Sets the area of source1 to the intersection of the areas of source1
	 * and source2. The resulting area is the set of pixels contained in
	 * both source1 and source2.
	 * Params:
	 * source2 =  another GdkRegion
	 */
	public void intersect(Region source2);
	
	/**
	 * Sets the area of source1 to the union of the areas of source1 and
	 * source2. The resulting area is the set of pixels contained in
	 * either source1 or source2.
	 * Params:
	 * source2 =  a GdkRegion
	 */
	public void unio(Region source2);
	
	/**
	 * Subtracts the area of source2 from the area source1. The resulting
	 * area is the set of pixels contained in source1 but not in source2.
	 * Params:
	 * source2 =  another GdkRegion
	 */
	public void subtract(Region source2);
	
	/**
	 * Sets the area of source1 to the exclusive-OR of the areas of source1
	 * and source2. The resulting area is the set of pixels contained in one
	 * or the other of the two sources but not in both.
	 * Params:
	 * source2 =  another GdkRegion
	 */
	public void xor(Region source2);
	
	/**
	 * Calls a function on each span in the intersection of region and spans.
	 * Params:
	 * spans =  an array of GdkSpans
	 * sorted =  TRUE if spans is sorted wrt. the y coordinate
	 * data =  data to pass to function
	 */
	public void spansIntersectForeach(GdkSpan[] spans, int sorted, GdkSpanFunc funct, void* data);
}
