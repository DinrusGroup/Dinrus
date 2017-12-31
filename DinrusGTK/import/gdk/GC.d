module gtkD.gdk.GC;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Drawable;
private import gtkD.gdk.Screen;
private import gtkD.gdk.Color;
private import gtkD.gdk.Font;
private import gtkD.gdk.Pixmap;
private import gtkD.gdk.Bitmap;
private import gtkD.gdk.Rectangle;
private import gtkD.gdk.Region;
private import gtkD.gdk.Colormap;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * All drawing operations in GDK take a
 * graphics context (GC) argument.
 * A graphics context encapsulates information about
 * the way things are drawn, such as the foreground
 * color or line width. By using graphics contexts,
 * the number of arguments to each drawing call is
 * greatly reduced, and communication overhead is
 * minimized, since identical arguments do not need
 * to be passed repeatedly.
 * Most values of a graphics context can be set at
 * creation time by using gdk_gc_new_with_values(),
 * or can be set one-by-one using functions such
 * as gdk_gc_set_foreground(). A few of the values
 * in the GC, such as the dash pattern, can only
 * be set by the latter method.
 */
public class GC : ObjectG
{
	
	/** the main Gtk struct */
	protected GdkGC* gdkGC;
	
	
	public GdkGC* getGCStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkGC* gdkGC);
	
	/**
	 */
	
	/**
	 * Create a new graphics context with default values.
	 * Params:
	 * drawable =  a GdkDrawable. The created GC must always be used
	 *  with drawables of the same depth as this one.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Drawable drawable);
	
	/**
	 * Create a new GC with the given initial values.
	 * Params:
	 * drawable =  a GdkDrawable. The created GC must always be used
	 *  with drawables of the same depth as this one.
	 * values =  a structure containing initial values for the GC.
	 * valuesMask =  a bit mask indicating which fields in values
	 *  are set.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Drawable drawable, GdkGCValues* values, GdkGCValuesMask valuesMask);
	
	/**
	 * Gets the GdkScreen for which gc was created
	 * Since 2.2
	 * Returns: the GdkScreen for gc.
	 */
	public Screen getScreen();
	
	/**
	 * Warning
	 * gdk_gc_ref is deprecated and should not be used in newly-written code.
	 * Deprecated function; use g_object_ref() instead.
	 * Returns: the gc.
	 */
	public GC doref();
	
	/**
	 * Warning
	 * gdk_gc_unref is deprecated and should not be used in newly-written code. Use g_object_unref() instead.
	 * Decrement the reference count of gc.
	 */
	public void unref();
	
	/**
	 * Sets attributes of a graphics context in bulk. For each flag set in
	 * values_mask, the corresponding field will be read from values and
	 * set as the new value for gc. If you're only setting a few values
	 * on gc, calling individual "setter" functions is likely more
	 * convenient.
	 * Params:
	 * values =  struct containing the new values
	 * valuesMask =  mask indicating which struct fields are to be used
	 */
	public void setValues(GdkGCValues* values, GdkGCValuesMask valuesMask);
	
	/**
	 * Retrieves the current values from a graphics context. Note that
	 * only the pixel values of the values->foreground and values->background
	 * are filled, use gdk_colormap_query_color() to obtain the rgb values
	 * if you need them.
	 * Params:
	 * values =  the GdkGCValues structure in which to store the results.
	 */
	public void getValues(GdkGCValues* values);
	
	/**
	 * Sets the foreground color for a graphics context.
	 * Note that this function uses color->pixel, use
	 * gdk_gc_set_rgb_fg_color() to specify the foreground
	 * color as red, green, blue components.
	 * Params:
	 * color =  the new foreground color.
	 */
	public void setForeground(Color color);
	
	/**
	 * Sets the background color for a graphics context.
	 * Note that this function uses color->pixel, use
	 * gdk_gc_set_rgb_bg_color() to specify the background
	 * color as red, green, blue components.
	 * Params:
	 * color =  the new background color.
	 */
	public void setBackground(Color color);
	
	/**
	 * Set the foreground color of a GC using an unallocated color. The
	 * pixel value for the color will be determined using GdkRGB. If the
	 * colormap for the GC has not previously been initialized for GdkRGB,
	 * then for pseudo-color colormaps (colormaps with a small modifiable
	 * number of colors), a colorcube will be allocated in the colormap.
	 * Calling this function for a GC without a colormap is an error.
	 * Params:
	 * color =  an unallocated GdkColor.
	 */
	public void setRgbFgColor(Color color);
	
	/**
	 * Set the background color of a GC using an unallocated color. The
	 * pixel value for the color will be determined using GdkRGB. If the
	 * colormap for the GC has not previously been initialized for GdkRGB,
	 * then for pseudo-color colormaps (colormaps with a small modifiable
	 * number of colors), a colorcube will be allocated in the colormap.
	 * Calling this function for a GC without a colormap is an error.
	 * Params:
	 * color =  an unallocated GdkColor.
	 */
	public void setRgbBgColor(Color color);
	
	/**
	 * Warning
	 * gdk_gc_set_font is deprecated and should not be used in newly-written code.
	 * Sets the font for a graphics context. (Note that
	 * all text-drawing functions in GDK take a font
	 * argument; the value set here is used when that
	 * argument is NULL.)
	 * Params:
	 * font =  the new font.
	 */
	public void setFont(Font font);
	
	/**
	 * Determines how the current pixel values and the
	 * pixel values being drawn are combined to produce
	 * the final pixel values.
	 */
	public void setFunction(GdkFunction funct);
	
	/**
	 * Set the fill mode for a graphics context.
	 * Params:
	 * fill =  the new fill mode.
	 */
	public void setFill(GdkFill fill);
	
	/**
	 * Set a tile pixmap for a graphics context.
	 * This will only be used if the fill mode
	 * is GDK_TILED.
	 * Params:
	 * tile =  the new tile pixmap.
	 */
	public void setTile(Pixmap tile);
	
	/**
	 * Set the stipple bitmap for a graphics context. The
	 * stipple will only be used if the fill mode is
	 * GDK_STIPPLED or GDK_OPAQUE_STIPPLED.
	 * Params:
	 * stipple =  the new stipple bitmap.
	 */
	public void setStipple(Pixmap stipple);
	
	/**
	 * Set the origin when using tiles or stipples with
	 * the GC. The tile or stipple will be aligned such
	 * that the upper left corner of the tile or stipple
	 * will coincide with this point.
	 * Params:
	 * x =  the x-coordinate of the origin.
	 * y =  the y-coordinate of the origin.
	 */
	public void setTsOrigin(int x, int y);
	
	/**
	 * Sets the origin of the clip mask. The coordinates are
	 * interpreted relative to the upper-left corner of
	 * the destination drawable of the current operation.
	 * Params:
	 * x =  the x-coordinate of the origin.
	 * y =  the y-coordinate of the origin.
	 */
	public void setClipOrigin(int x, int y);
	
	/**
	 * Sets the clip mask for a graphics context from a bitmap.
	 * The clip mask is interpreted relative to the clip
	 * origin. (See gdk_gc_set_clip_origin()).
	 * Params:
	 * mask =  a bitmap.
	 */
	public void setClipMask(Bitmap mask);
	
	/**
	 * Sets the clip mask for a graphics context from a
	 * rectangle. The clip mask is interpreted relative to the clip
	 * origin. (See gdk_gc_set_clip_origin()).
	 * Params:
	 * rectangle =  the rectangle to clip to.
	 */
	public void setClipRectangle(Rectangle rectangle);
	
	/**
	 * Sets the clip mask for a graphics context from a region structure.
	 * The clip mask is interpreted relative to the clip origin. (See
	 * gdk_gc_set_clip_origin()).
	 * Params:
	 * region =  the GdkRegion.
	 */
	public void setClipRegion(Region region);
	
	/**
	 * Sets how drawing with this GC on a window will affect child
	 * windows of that window.
	 * Params:
	 * mode =  the subwindow mode.
	 */
	public void setSubwindow(GdkSubwindowMode mode);
	
	/**
	 * Sets whether copying non-visible portions of a drawable
	 * using this graphics context generate exposure events
	 * for the corresponding regions of the destination
	 * drawable. (See gdk_draw_drawable()).
	 * Params:
	 * exposures =  if TRUE, exposure events will be generated.
	 */
	public void setExposures(int exposures);
	
	/**
	 * Sets various attributes of how lines are drawn. See
	 * the corresponding members of GdkGCValues for full
	 * explanations of the arguments.
	 * Params:
	 * lineWidth =  the width of lines.
	 * lineStyle =  the dash-style for lines.
	 * capStyle =  the manner in which the ends of lines are drawn.
	 * joinStyle =  the in which lines are joined together.
	 */
	public void setLineAttributes(int lineWidth, GdkLineStyle lineStyle, GdkCapStyle capStyle, GdkJoinStyle joinStyle);
	
	/**
	 * Sets the way dashed-lines are drawn. Lines will be
	 * drawn with alternating on and off segments of the
	 * lengths specified in dash_list. The manner in
	 * which the on and off segments are drawn is determined
	 * by the line_style value of the GC. (This can
	 * be changed with gdk_gc_set_line_attributes().)
	 * The dash_offset defines the phase of the pattern,
	 * specifying how many pixels into the dash-list the pattern
	 * should actually begin.
	 * Params:
	 * dashOffset =  the phase of the dash pattern.
	 * dashList =  an array of dash lengths.
	 * n =  the number of elements in dash_list.
	 */
	public void setDashes(int dashOffset, byte[] dashList, int n);
	
	/**
	 * Copy the set of values from one graphics context
	 * onto another graphics context.
	 * Params:
	 * srcGc =  the source graphics context.
	 */
	public void copy(GC srcGc);
	
	/**
	 * Sets the colormap for the GC to the given colormap. The depth
	 * of the colormap's visual must match the depth of the drawable
	 * for which the GC was created.
	 * Params:
	 * colormap =  a GdkColormap
	 */
	public void setColormap(Colormap colormap);
	
	/**
	 * Retrieves the colormap for a given GC, if it exists.
	 * A GC will have a colormap if the drawable for which it was created
	 * has a colormap, or if a colormap was set explicitely with
	 * gdk_gc_set_colormap.
	 * Returns: the colormap of gc, or NULL if gc doesn't have one.
	 */
	public Colormap getColormap();
	
	/**
	 * Offset attributes such as the clip and tile-stipple origins
	 * of the GC so that drawing at x - x_offset, y - y_offset with
	 * the offset GC has the same effect as drawing at x, y with the original
	 * GC.
	 * Params:
	 * xOffset =  amount by which to offset the GC in the X direction
	 * yOffset =  amount by which to offset the GC in the Y direction
	 */
	public void offset(int xOffset, int yOffset);
}
