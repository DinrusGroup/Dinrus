module gtkD.gdk.Drawable;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Display;
private import gtkD.gdk.Screen;
private import gtkD.gdk.Visual;
private import gtkD.gdk.Colormap;
private import gtkD.gdk.Region;
private import gtkD.gdk.GC;
private import gtkD.gdk.Pixbuf;
private import gtkD.gdk.Color;
private import gtkD.gdk.Font;
private import gtkD.gdk.ImageGdk;
private import gtkD.pango.PgFont;
private import gtkD.pango.PgGlyphString;
private import gtkD.pango.PgMatrix;
private import gtkD.pango.PgLayout;
private import gtkD.pango.PgLayoutLine;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * These functions provide support for drawing points, lines, arcs and text
 * onto what are called 'drawables'. Drawables, as the name suggests, are things
 * which support drawing onto them, and are either GdkWindow or GdkPixmap
 * objects.
 * Many of the drawing operations take a GdkGC argument, which represents a
 * graphics context. This GdkGC contains a number of drawing attributes such
 * as foreground color, background color and line width, and is used to reduce
 * the number of arguments needed for each drawing operation. See the
 * Graphics Contexts section for
 * more information.
 * Some of the drawing operations take Pango data structures like PangoContext,
 * PangoLayout or PangoLayoutLine as arguments. If you're using GTK+, the ususal
 * way to obtain these structures is via gtk_widget_create_pango_context() or
 * gtk_widget_create_pango_layout().
 */
public class Drawable : ObjectG
{
	
	/** the main Gtk struct */
	protected GdkDrawable* gdkDrawable;
	
	
	public GdkDrawable* getDrawableStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkDrawable* gdkDrawable);
	
	/** */
	public void drawPixbuf(Pixbuf pixbuf, int destX, int destY);
	
	/** */
	public void drawPixbuf(GC gc, Pixbuf pixbuf, int destX, int destY);
	
	/**
	 */
	
	/**
	 * Warning
	 * gdk_drawable_ref is deprecated and should not be used in newly-written code.
	 * Deprecated equivalent of calling g_object_ref() on drawable.
	 * (Drawables were not objects in previous versions of GDK.)
	 * Returns: the same drawable passed in
	 */
	public Drawable doref();
	
	/**
	 * Warning
	 * gdk_drawable_unref is deprecated and should not be used in newly-written code.
	 * Deprecated equivalent of calling g_object_unref() on drawable.
	 */
	public void unref();
	
	/**
	 * Warning
	 * gdk_drawable_set_data is deprecated and should not be used in newly-written code.
	 * This function is equivalent to g_object_set_data(),
	 * the GObject variant should be used instead.
	 * Params:
	 * key =  name to store the data under
	 * data =  arbitrary data
	 * destroyFunc =  function to free data, or NULL
	 */
	public void setData(string key, void* data, GDestroyNotify destroyFunc);
	
	/**
	 * Warning
	 * gdk_drawable_get_data is deprecated and should not be used in newly-written code.
	 * Equivalent to g_object_get_data(); the GObject variant should be
	 * used instead.
	 * Params:
	 * key =  name the data was stored under
	 * Returns: the data stored at key
	 */
	public override void* getData(string key);
	
	/**
	 * Gets the GdkDisplay associated with a GdkDrawable.
	 * Since 2.2
	 * Returns: the GdkDisplay associated with drawable
	 */
	public Display getDisplay();
	
	/**
	 * Gets the GdkScreen associated with a GdkDrawable.
	 * Since 2.2
	 * Returns: the GdkScreen associated with drawable
	 */
	public Screen getScreen();
	
	/**
	 * Gets the GdkVisual describing the pixel format of drawable.
	 * Returns: a GdkVisual
	 */
	public Visual getVisual();
	
	/**
	 * Sets the colormap associated with drawable. Normally this will
	 * happen automatically when the drawable is created; you only need to
	 * use this function if the drawable-creating function did not have a
	 * way to determine the colormap, and you then use drawable operations
	 * that require a colormap. The colormap for all drawables and
	 * graphics contexts you intend to use together should match. i.e.
	 * when using a GdkGC to draw to a drawable, or copying one drawable
	 * to another, the colormaps should match.
	 * Params:
	 * colormap =  a GdkColormap
	 */
	public void setColormap(Colormap colormap);
	
	/**
	 * Gets the colormap for drawable, if one is set; returns
	 * NULL otherwise.
	 * Returns: the colormap, or NULL
	 */
	public Colormap getColormap();
	
	/**
	 * Obtains the bit depth of the drawable, that is, the number of bits
	 * that make up a pixel in the drawable's visual. Examples are 8 bits
	 * per pixel, 24 bits per pixel, etc.
	 * Returns: number of bits per pixel
	 */
	public int getDepth();
	
	/**
	 * Fills *width and *height with the size of drawable.
	 * width or height can be NULL if you only want the other one.
	 * On the X11 platform, if drawable is a GdkWindow, the returned
	 * size is the size reported in the most-recently-processed configure
	 * event, rather than the current size on the X server.
	 * Params:
	 * width =  location to store drawable's width, or NULL
	 * height =  location to store drawable's height, or NULL
	 */
	public void getSize(out int width, out int height);
	
	/**
	 * Computes the region of a drawable that potentially can be written
	 * to by drawing primitives. This region will not take into account
	 * the clip region for the GC, and may also not take into account
	 * other factors such as if the window is obscured by other windows,
	 * but no area outside of this region will be affected by drawing
	 * primitives.
	 * Returns: a GdkRegion. This must be freed with gdk_region_destroy() when you are done.
	 */
	public Region getClipRegion();
	
	/**
	 * Computes the region of a drawable that is potentially visible.
	 * This does not necessarily take into account if the window is
	 * obscured by other windows, but no area outside of this region
	 * is visible.
	 * Returns: a GdkRegion. This must be freed with gdk_region_destroy() when you are done.
	 */
	public Region getVisibleRegion();
	
	/**
	 * Draws a point, using the foreground color and other attributes of
	 * the GdkGC.
	 * Params:
	 * gc =  a GdkGC.
	 * x =  the x coordinate of the point.
	 * y =  the y coordinate of the point.
	 */
	public void drawPoint(GC gc, int x, int y);
	
	/**
	 * Draws a number of points, using the foreground color and other
	 * attributes of the GdkGC.
	 * Params:
	 * gc =  a GdkGC.
	 * points =  an array of GdkPoint structures.
	 */
	public void drawPoints(GC gc, GdkPoint[] points);
	
	/**
	 * Draws a line, using the foreground color and other attributes of
	 * the GdkGC.
	 * Params:
	 * gc =  a GdkGC.
	 * x1_ =  the x coordinate of the start point.
	 * y1_ =  the y coordinate of the start point.
	 * x2_ =  the x coordinate of the end point.
	 * y2_ =  the y coordinate of the end point.
	 */
	public void drawLine(GC gc, int x1_, int y1_, int x2_, int y2_);
	
	/**
	 * Draws a series of lines connecting the given points.
	 * The way in which joins between lines are draw is determined by the
	 * GdkCapStyle value in the GdkGC. This can be set with
	 * gdk_gc_set_line_attributes().
	 * Params:
	 * gc =  a GdkGC.
	 * points =  an array of GdkPoint structures specifying the endpoints of the
	 */
	public void drawLines(GC gc, GdkPoint[] points);
	
	/**
	 * Renders a rectangular portion of a pixbuf to a drawable. The destination
	 * drawable must have a colormap. All windows have a colormap, however, pixmaps
	 * only have colormap by default if they were created with a non-NULL window
	 * argument. Otherwise a colormap must be set on them with
	 * gdk_drawable_set_colormap().
	 * On older X servers, rendering pixbufs with an alpha channel involves round
	 * trips to the X server, and may be somewhat slow.
	 * If GDK is built with the Sun mediaLib library, the gdk_draw_pixbuf
	 * function is accelerated using mediaLib, which provides hardware
	 * acceleration on Intel, AMD, and Sparc chipsets. If desired, mediaLib
	 * support can be turned off by setting the GDK_DISABLE_MEDIALIB environment
	 * variable.
	 * Since 2.2
	 * Params:
	 * gc =  a GdkGC, used for clipping, or NULL
	 * pixbuf =  a GdkPixbuf
	 * srcX =  Source X coordinate within pixbuf.
	 * srcY =  Source Y coordinates within pixbuf.
	 * destX =  Destination X coordinate within drawable.
	 * destY =  Destination Y coordinate within drawable.
	 * width =  Width of region to render, in pixels, or -1 to use pixbuf width.
	 * height =  Height of region to render, in pixels, or -1 to use pixbuf height.
	 * dither =  Dithering mode for GdkRGB.
	 * xDither =  X offset for dither.
	 * yDither =  Y offset for dither.
	 */
	public void drawPixbuf(GC gc, Pixbuf pixbuf, int srcX, int srcY, int destX, int destY, int width, int height, GdkRgbDither dither, int xDither, int yDither);
	
	/**
	 * Draws a number of unconnected lines.
	 * Params:
	 * gc =  a GdkGC.
	 * segs =  an array of GdkSegment structures specifying the start and
	 *  end points of the lines to be drawn.
	 */
	public void drawSegments(GC gc, GdkSegment[] segs);
	
	/**
	 * Draws a rectangular outline or filled rectangle, using the foreground color
	 * and other attributes of the GdkGC.
	 * A rectangle drawn filled is 1 pixel smaller in both dimensions than a
	 * rectangle outlined. Calling
	 * gdk_draw_rectangle (window, gc, TRUE, 0, 0, 20, 20)
	 * results in a filled rectangle 20 pixels wide and 20 pixels high. Calling
	 * gdk_draw_rectangle (window, gc, FALSE, 0, 0, 20, 20)
	 * results in an outlined rectangle with corners at (0, 0), (0, 20), (20, 20),
	 * and (20, 0), which makes it 21 pixels wide and 21 pixels high.
	 * Note
	 * Params:
	 * gc =  a GdkGC.
	 * filled =  TRUE if the rectangle should be filled.
	 * x =  the x coordinate of the left edge of the rectangle.
	 * y =  the y coordinate of the top edge of the rectangle.
	 * width =  the width of the rectangle.
	 * height =  the height of the rectangle.
	 */
	public void drawRectangle(GC gc, int filled, int x, int y, int width, int height);
	
	/**
	 * Draws an arc or a filled 'pie slice'. The arc is defined by the bounding
	 * rectangle of the entire ellipse, and the start and end angles of the part
	 * of the ellipse to be drawn.
	 * Params:
	 * gc =  a GdkGC.
	 * filled =  TRUE if the arc should be filled, producing a 'pie slice'.
	 * x =  the x coordinate of the left edge of the bounding rectangle.
	 * y =  the y coordinate of the top edge of the bounding rectangle.
	 * width =  the width of the bounding rectangle.
	 * height =  the height of the bounding rectangle.
	 * angle1 =  the start angle of the arc, relative to the 3 o'clock position,
	 *  counter-clockwise, in 1/64ths of a degree.
	 * angle2 =  the end angle of the arc, relative to angle1, in 1/64ths
	 *  of a degree.
	 */
	public void drawArc(GC gc, int filled, int x, int y, int width, int height, int angle1, int angle2);
	
	/**
	 * Draws an outlined or filled polygon.
	 * Params:
	 * gc =  a GdkGC.
	 * filled =  TRUE if the polygon should be filled. The polygon is closed
	 *  automatically, connecting the last point to the first point if
	 *  necessary.
	 * points =  an array of GdkPoint structures specifying the points making
	 *  up the polygon.
	 */
	public void drawPolygon(GC gc, int filled, GdkPoint[] points);
	
	/**
	 * Draws a set of anti-aliased trapezoids. The trapezoids are
	 * combined using saturation addition, then drawn over the background
	 * as a set. This is low level functionality used internally to implement
	 * rotated underlines and backgrouds when rendering a PangoLayout and is
	 * likely not useful for applications.
	 * Since 2.6
	 * Params:
	 * gc =  a GdkGC
	 * trapezoids =  an array of GdkTrapezoid structures
	 */
	public void drawTrapezoids(GC gc, GdkTrapezoid[] trapezoids);
	
	/**
	 * This is a low-level function; 99% of text rendering should be done
	 * using gdk_draw_layout() instead.
	 * A glyph is a single image in a font. This function draws a sequence of
	 * glyphs. To obtain a sequence of glyphs you have to understand a
	 * lot about internationalized text handling, which you don't want to
	 * understand; thus, use gdk_draw_layout() instead of this function,
	 * gdk_draw_layout() handles the details.
	 * Params:
	 * gc =  a GdkGC
	 * font =  font to be used
	 * x =  X coordinate of baseline origin
	 * y =  Y coordinate of baseline origin
	 * glyphs =  the glyph string to draw
	 */
	public void drawGlyphs(GC gc, PgFont font, int x, int y, PgGlyphString glyphs);
	
	/**
	 * Renders a PangoGlyphString onto a drawable, possibly
	 * transforming the layed-out coordinates through a transformation
	 * matrix. Note that the transformation matrix for font is not
	 * changed, so to produce correct rendering results, the font
	 * must have been loaded using a PangoContext with an identical
	 * transformation matrix to that passed in to this function.
	 * See also gdk_draw_glyphs(), gdk_draw_layout().
	 * Since 2.6
	 * Params:
	 * gc =  a GdkGC
	 * matrix =  a PangoMatrix, or NULL to use an identity transformation
	 * font =  the font in which to draw the string
	 * x =  the x position of the start of the string (in Pango
	 *  units in user space coordinates)
	 * y =  the y position of the baseline (in Pango units
	 *  in user space coordinates)
	 * glyphs =  the glyph string to draw
	 */
	public void drawGlyphsTransformed(GC gc, PgMatrix matrix, PgFont font, int x, int y, PgGlyphString glyphs);
	
	/**
	 * Render a PangoLayoutLine onto an GDK drawable
	 * If the layout's PangoContext has a transformation matrix set, then
	 * x and y specify the position of the left edge of the baseline
	 * (left is in before-tranform user coordinates) in after-transform
	 * device coordinates.
	 * Params:
	 * gc =  base graphics to use
	 * x =  the x position of start of string (in pixels)
	 * y =  the y position of baseline (in pixels)
	 * line =  a PangoLayoutLine
	 */
	public void drawLayoutLine(GC gc, int x, int y, PgLayoutLine line);
	
	/**
	 * Render a PangoLayoutLine onto a GdkDrawable, overriding the
	 * layout's normal colors with foreground and/or background.
	 * foreground and background need not be allocated.
	 * If the layout's PangoContext has a transformation matrix set, then
	 * x and y specify the position of the left edge of the baseline
	 * (left is in before-tranform user coordinates) in after-transform
	 * device coordinates.
	 * Params:
	 * gc =  base graphics to use
	 * x =  the x position of start of string (in pixels)
	 * y =  the y position of baseline (in pixels)
	 * line =  a PangoLayoutLine
	 * foreground =  foreground override color, or NULL for none
	 * background =  background override color, or NULL for none
	 */
	public void drawLayoutLineWithColors(GC gc, int x, int y, PgLayoutLine line, Color foreground, Color background);
	
	/**
	 * Render a PangoLayout onto a GDK drawable
	 * If the layout's PangoContext has a transformation matrix set, then
	 * x and y specify the position of the top left corner of the
	 * bounding box (in device space) of the transformed layout.
	 * If you're using GTK+, the usual way to obtain a PangoLayout
	 * is gtk_widget_create_pango_layout().
	 * Params:
	 * gc =  base graphics context to use
	 * x =  the X position of the left of the layout (in pixels)
	 * y =  the Y position of the top of the layout (in pixels)
	 * layout =  a PangoLayout
	 */
	public void drawLayout(GC gc, int x, int y, PgLayout layout);
	
	/**
	 * Render a PangoLayout onto a GdkDrawable, overriding the
	 * layout's normal colors with foreground and/or background.
	 * foreground and background need not be allocated.
	 * If the layout's PangoContext has a transformation matrix set, then
	 * x and y specify the position of the top left corner of the
	 * bounding box (in device space) of the transformed layout.
	 * If you're using GTK+, the ususal way to obtain a PangoLayout
	 * is gtk_widget_create_pango_layout().
	 * Params:
	 * gc =  base graphics context to use
	 * x =  the X position of the left of the layout (in pixels)
	 * y =  the Y position of the top of the layout (in pixels)
	 * layout =  a PangoLayout
	 * foreground =  foreground override color, or NULL for none
	 * background =  background override color, or NULL for none
	 */
	public void drawLayoutWithColors(GC gc, int x, int y, PgLayout layout, Color foreground, Color background);
	
	/**
	 * Warning
	 * gdk_draw_string is deprecated and should not be used in newly-written code. Use gdk_draw_layout() instead.
	 * Draws a string of characters in the given font or fontset.
	 * Params:
	 * font =  a GdkFont.
	 * gc =  a GdkGC.
	 * x =  the x coordinate of the left edge of the text.
	 * y =  the y coordinate of the baseline of the text.
	 * string =  the string of characters to draw.
	 */
	public void drawString(Font font, GC gc, int x, int y, string string);
	
	/**
	 * Warning
	 * gdk_draw_text is deprecated and should not be used in newly-written code. Use gdk_draw_layout() instead.
	 * Draws a number of characters in the given font or fontset.
	 * Params:
	 * font =  a GdkFont.
	 * gc =  a GdkGC.
	 * x =  the x coordinate of the left edge of the text.
	 * y =  the y coordinate of the baseline of the text.
	 * text =  the characters to draw.
	 * textLength =  the number of characters of text to draw.
	 */
	public void drawText(Font font, GC gc, int x, int y, string text, int textLength);
	
	/**
	 * Warning
	 * gdk_draw_text_wc is deprecated and should not be used in newly-written code. Use gdk_draw_layout() instead.
	 * Draws a number of wide characters using the given font of fontset.
	 * If the font is a 1-byte font, the string is converted into 1-byte
	 * characters (discarding the high bytes) before output.
	 * Params:
	 * font =  a GdkFont.
	 * gc =  a GdkGC.
	 * x =  the x coordinate of the left edge of the text.
	 * y =  the y coordinate of the baseline of the text.
	 * text =  the wide characters to draw.
	 */
	public void drawTextWc(Font font, GC gc, int x, int y, GdkWChar[] text);
	
	/**
	 * Copies the width x height region of src at coordinates (xsrc,
	 * ysrc) to coordinates (xdest, ydest) in drawable.
	 * width and/or height may be given as -1, in which case the entire
	 * src drawable will be copied.
	 * Most fields in gc are not used for this operation, but notably the
	 * clip mask or clip region will be honored.
	 * The source and destination drawables must have the same visual and
	 * colormap, or errors will result. (On X11, failure to match
	 * visual/colormap results in a BadMatch error from the X server.)
	 * A common cause of this problem is an attempt to draw a bitmap to
	 * a color drawable. The way to draw a bitmap is to set the bitmap as
	 * the stipple on the GdkGC, set the fill mode to GDK_STIPPLED, and
	 * then draw the rectangle.
	 * Params:
	 * gc =  a GdkGC sharing the drawable's visual and colormap
	 * src =  the source GdkDrawable, which may be the same as drawable
	 * xsrc =  X position in src of rectangle to draw
	 * ysrc =  Y position in src of rectangle to draw
	 * xdest =  X position in drawable where the rectangle should be drawn
	 * ydest =  Y position in drawable where the rectangle should be drawn
	 * width =  width of rectangle to draw, or -1 for entire src width
	 * height =  height of rectangle to draw, or -1 for entire src height
	 */
	public void drawDrawable(GC gc, Drawable src, int xsrc, int ysrc, int xdest, int ydest, int width, int height);
	
	/**
	 * Draws a GdkImage onto a drawable.
	 * The depth of the GdkImage must match the depth of the GdkDrawable.
	 * Params:
	 * gc =  a GdkGC.
	 * image =  the GdkImage to draw.
	 * xsrc =  the left edge of the source rectangle within image.
	 * ysrc =  the top of the source rectangle within image.
	 * xdest =  the x coordinate of the destination within drawable.
	 * ydest =  the y coordinate of the destination within drawable.
	 * width =  the width of the area to be copied, or -1 to make the area
	 *  extend to the right edge of image.
	 * height =  the height of the area to be copied, or -1 to make the area
	 *  extend to the bottom edge of image.
	 */
	public void drawImage(GC gc, ImageGdk image, int xsrc, int ysrc, int xdest, int ydest, int width, int height);
	
	/**
	 * A GdkImage stores client-side image data (pixels). In contrast,
	 * GdkPixmap and GdkWindow are server-side
	 * objects. gdk_drawable_get_image() obtains the pixels from a
	 * server-side drawable as a client-side GdkImage. The format of a
	 * GdkImage depends on the GdkVisual of the current display, which
	 * makes manipulating GdkImage extremely difficult; therefore, in
	 * most cases you should use gdk_pixbuf_get_from_drawable() instead of
	 * this lower-level function. A GdkPixbuf contains image data in a
	 * canonicalized RGB format, rather than a display-dependent format.
	 * Of course, there's a convenience vs. speed tradeoff here, so you'll
	 * want to think about what makes sense for your application.
	 * x, y, width, and height define the region of drawable to
	 * obtain as an image.
	 * You would usually copy image data to the client side if you intend
	 * to examine the values of individual pixels, for example to darken
	 * an image or add a red tint. It would be prohibitively slow to
	 * make a round-trip request to the windowing system for each pixel,
	 * so instead you get all of them at once, modify them, then copy
	 * them all back at once.
	 * If the X server or other windowing system backend is on the local
	 * machine, this function may use shared memory to avoid copying
	 * the image data.
	 * If the source drawable is a GdkWindow and partially offscreen
	 * or obscured, then the obscured portions of the returned image
	 * will contain undefined data.
	 * Params:
	 * x =  x coordinate on drawable
	 * y =  y coordinate on drawable
	 * width =  width of region to get
	 * height =  height or region to get
	 * Returns: a GdkImage containing the contents of drawable
	 */
	public ImageGdk getImage(int x, int y, int width, int height);
	
	/**
	 * Copies a portion of drawable into the client side image structure
	 * image. If image is NULL, creates a new image of size width x height
	 * and copies into that. See gdk_drawable_get_image() for further details.
	 * Since 2.4
	 * Params:
	 * image =  a GdkDrawable, or NULL if a new image should be created.
	 * srcX =  x coordinate on drawable
	 * srcY =  y coordinate on drawable
	 * destX =  x coordinate within image. Must be 0 if image is NULL
	 * destY =  y coordinate within image. Must be 0 if image is NULL
	 * width =  width of region to get
	 * height =  height or region to get
	 * Returns: image, or a new a GdkImage containing the contents of drawable
	 */
	public ImageGdk copyToImage(ImageGdk image, int srcX, int srcY, int destX, int destY, int width, int height);
}
