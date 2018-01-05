module gtkD.pango.PgRenderer;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.pango.PgColor;
private import gtkD.pango.PgFont;
private import gtkD.pango.PgGlyphItem;
private import gtkD.pango.PgGlyphString;
private import gtkD.pango.PgLayout;
private import gtkD.pango.PgLayoutLine;
private import gtkD.pango.PgMatrix;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * PangoRenderer is a base class that contains the necessary logic for
 * rendering a PangoLayout or PangoLayoutLine. By subclassing
 * PangoRenderer and overriding operations such as draw_glyphs and
 * draw_rectangle, renderers for particular font backends and
 * destinations can be created.
 */
public class PgRenderer : ObjectG
{
	
	/** the main Gtk struct */
	protected PangoRenderer* pangoRenderer;
	
	
	public PangoRenderer* getPgRendererStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoRenderer* pangoRenderer);
	
	/**
	 */
	
	/**
	 * Draws layout with the specified PangoRenderer.
	 * Since 1.8
	 * Params:
	 * layout =  a PangoLayout
	 * x =  X position of left edge of baseline, in user space coordinates
	 *  in Pango units.
	 * y =  Y position of left edge of baseline, in user space coordinates
	 *  in Pango units.
	 */
	public void drawLayout(PgLayout layout, int x, int y);
	
	/**
	 * Draws line with the specified PangoRenderer.
	 * Since 1.8
	 * Params:
	 * line =  a PangoLayoutLine
	 * x =  X position of left edge of baseline, in user space coordinates
	 *  in Pango units.
	 * y =  Y position of left edge of baseline, in user space coordinates
	 *  in Pango units.
	 */
	public void drawLayoutLine(PgLayoutLine line, int x, int y);
	
	/**
	 * Draws the glyphs in glyphs with the specified PangoRenderer.
	 * Since 1.8
	 * Params:
	 * font =  a PangoFont
	 * glyphs =  a PangoGlyphString
	 * x =  X position of left edge of baseline, in user space coordinates
	 *  in Pango units.
	 * y =  Y position of left edge of baseline, in user space coordinates
	 *  in Pango units.
	 */
	public void drawGlyphs(PgFont font, PgGlyphString glyphs, int x, int y);
	
	/**
	 * Draws the glyphs in glyph_item with the specified PangoRenderer,
	 * embedding the text associated with the glyphs in the output if the
	 * output format supports it (PDF for example).
	 * Note that text is the start of the text for layout, which is then
	 * indexed by glyph_item->item->offset.
	 * If text is NULL, this simply calls pango_renderer_draw_glyphs().
	 * The default implementation of this method simply falls back to
	 * pango_renderer_draw_glyphs().
	 * Since 1.22
	 * Params:
	 * text =  the UTF-8 text that glyph_item refers to, or NULL
	 * glyphItem =  a PangoGlyphItem
	 * x =  X position of left edge of baseline, in user space coordinates
	 *  in Pango units.
	 * y =  Y position of left edge of baseline, in user space coordinates
	 *  in Pango units.
	 */
	public void drawGlyphItem(string text, PgGlyphItem glyphItem, int x, int y);
	
	/**
	 * Draws an axis-aligned rectangle in user space coordinates with the
	 * specified PangoRenderer.
	 * This should be called while renderer is already active. Use
	 * pango_renderer_activate() to activate a renderer.
	 * Since 1.8
	 * Params:
	 * part =  type of object this rectangle is part of
	 * x =  X position at which to draw rectangle, in user space coordinates in Pango units
	 * y =  Y position at which to draw rectangle, in user space coordinates in Pango units
	 * width =  width of rectangle in Pango units in user space coordinates
	 * height =  height of rectangle in Pango units in user space coordinates
	 */
	public void drawRectangle(PangoRenderPart part, int x, int y, int width, int height);

	/**
	 * Draw a squiggly line that approximately covers the given rectangle
	 * in the style of an underline used to indicate a spelling error.
	 * (The width of the underline is rounded to an integer number
	 * of up/down segments and the resulting rectangle is centered
	 * in the original rectangle)
	 * This should be called while renderer is already active. Use
	 * pango_renderer_activate() to activate a renderer.
	 * Since 1.8
	 * Params:
	 * x =  X coordinate of underline, in Pango units in user coordinate system
	 * y =  Y coordinate of underline, in Pango units in user coordinate system
	 * width =  width of underline, in Pango units in user coordinate system
	 * height =  height of underline, in Pango units in user coordinate system
	 */
	public void drawErrorUnderline(int x, int y, int width, int height);
	
	/**
	 * Draws a trapezoid with the parallel sides aligned with the X axis
	 * using the given PangoRenderer; coordinates are in device space.
	 * Since 1.8
	 * Params:
	 * part =  type of object this trapezoid is part of
	 * y1_ =  Y coordinate of top of trapezoid
	 * x11 =  X coordinate of left end of top of trapezoid
	 * x21 =  X coordinate of right end of top of trapezoid
	 * y2 =  Y coordinate of bottom of trapezoid
	 * x12 =  X coordinate of left end of bottom of trapezoid
	 * x22 =  X coordinate of right end of bottom of trapezoid
	 */
	public void drawTrapezoid(PangoRenderPart part, double y1_, double x11, double x21, double y2, double x12, double x22);
	
	/**
	 * Draws a single glyph with coordinates in device space.
	 * Since 1.8
	 * Params:
	 * font =  a PangoFont
	 * glyph =  the glyph index of a single glyph
	 * x =  X coordinate of left edge of baseline of glyph
	 * y =  Y coordinate of left edge of baseline of glyph
	 */
	public void drawGlyph(PgFont font, PangoGlyph glyph, double x, double y);
	
	/**
	 * Does initial setup before rendering operations on renderer.
	 * pango_renderer_deactivate() should be called when done drawing.
	 * Calls such as pango_renderer_draw_layout() automatically
	 * activate the layout before drawing on it. Calls to
	 * pango_renderer_activate() and pango_renderer_deactivate() can
	 * be nested and the renderer will only be initialized and
	 * deinitialized once.
	 * Since 1.8
	 */
	public void activate();
	
	/**
	 * Cleans up after rendering operations on renderer. See
	 * docs for pango_renderer_activate().
	 * Since 1.8
	 */
	public void deactivate();
	
	/**
	 * Informs Pango that the way that the rendering is done
	 * for part has changed in a way that would prevent multiple
	 * pieces being joined together into one drawing call. For
	 * instance, if a subclass of PangoRenderer was to add a stipple
	 * option for drawing underlines, it needs to call
	 * pango_renderer_part_changed (render, PANGO_RENDER_PART_UNDERLINE);
	 * When the stipple changes or underlines with different stipples
	 * might be joined together. Pango automatically calls this for
	 * changes to colors. (See pango_renderer_set_color())
	 * Since 1.8
	 * Params:
	 * part =  the part for which rendering has changed.
	 */
	public void partChanged(PangoRenderPart part);

	/**
	 * Sets the color for part of the rendering.
	 * Since 1.8
	 * Params:
	 * part =  the part to change the color of
	 * color =  the new color or NULL to unset the current color
	 */
	public void setColor(PangoRenderPart part, PgColor color);
	
	/**
	 * Gets the current rendering color for the specified part.
	 * Since 1.8
	 * Params:
	 * part =  the part to get the color for
	 * Returns: the color for the specified part, or NULL if it hasn't been set and should be inherited from the environment.
	 */
	public PgColor getColor(PangoRenderPart part);
	
	/**
	 * Sets the transformation matrix that will be applied when rendering.
	 * Since 1.8
	 * Params:
	 * matrix =  a PangoMatrix, or NULL to unset any existing matrix.
	 *  (No matrix set is the same as setting the identity matrix.)
	 */
	public void setMatrix(PgMatrix matrix);
	
	/**
	 * Gets the transformation matrix that will be applied when
	 * rendering. See pango_renderer_set_matrix().
	 * Since 1.8
	 * Returns: the matrix, or NULL if no matrix has been set (which is the same as the identity matrix). The returned matrix is owned by Pango and must not be modified or freed.
	 */
	public PgMatrix getMatrix();
	
	/**
	 * Gets the layout currently being rendered using renderer.
	 * Calling this function only makes sense from inside a subclass's
	 * methods, like in its draw_shape() for example.
	 * The returned layout should not be modified while still being
	 * rendered.
	 * Since 1.20
	 * Returns: the layout, or NULL if no layout is being rendered using renderer at this time.
	 */
	public PgLayout getLayout();
	
	/**
	 * Gets the layout line currently being rendered using renderer.
	 * Calling this function only makes sense from inside a subclass's
	 * methods, like in its draw_shape() for example.
	 * The returned layout line should not be modified while still being
	 * rendered.
	 * Since 1.20
	 * Returns: the layout line, or NULL if no layout line is being rendered using renderer at this time.
	 */
	public PgLayoutLine getLayoutLine();
}
