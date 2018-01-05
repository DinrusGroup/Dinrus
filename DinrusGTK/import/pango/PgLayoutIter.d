module gtkD.pango.PgLayoutIter;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.pango.PgLayout;
private import gtkD.pango.PgLayoutLine;




/**
 * Description
 * While complete access to the layout capabilities of Pango is provided
 * using the detailed interfaces for itemization and shaping, using
 * that functionality directly involves writing a fairly large amount
 * of code. The objects and functions in this section provide a
 * high-level driver for formatting entire paragraphs of text
 * at once.
 */
public class PgLayoutIter
{
	
	/** the main Gtk struct */
	protected PangoLayoutIter* pangoLayoutIter;
	
	
	public PangoLayoutIter* getPgLayoutIterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoLayoutIter* pangoLayoutIter);
	
	/**
	 */
	
	/**
	 * Copies a PangLayoutIter.
	 * Since 1.20
	 * Returns: the newly allocated PangoLayoutIter, which should be freed with pango_layout_iter_free(), or NULL if iter was NULL.
	 */
	public PgLayoutIter copy();
	
	/**
	 * Frees an iterator that's no longer in use.
	 */
	public void free();
	
	/**
	 * Moves iter forward to the next run in visual order. If iter was
	 * already at the end of the layout, returns FALSE.
	 * Returns: whether motion was possible.
	 */
	public int nextRun();
	
	/**
	 * Moves iter forward to the next character in visual order. If iter was already at
	 * the end of the layout, returns FALSE.
	 * Returns: whether motion was possible.
	 */
	public int nextChar();
	
	/**
	 * Moves iter forward to the next cluster in visual order. If iter
	 * was already at the end of the layout, returns FALSE.
	 * Returns: whether motion was possible.
	 */
	public int nextCluster();
	
	/**
	 * Moves iter forward to the start of the next line. If iter is
	 * already on the last line, returns FALSE.
	 * Returns: whether motion was possible.
	 */
	public int nextLine();
	
	/**
	 * Determines whether iter is on the last line of the layout.
	 * Returns: TRUE if iter is on the last line.
	 */
	public int atLastLine();
	
	/**
	 * Gets the current byte index. Note that iterating forward by char
	 * moves in visual order, not logical order, so indexes may not be
	 * sequential. Also, the index may be equal to the length of the text
	 * in the layout, if on the NULL run (see pango_layout_iter_get_run()).
	 * Returns: current byte index.
	 */
	public int getIndex();
	
	/**
	 * Gets the Y position of the current line's baseline, in layout
	 * coordinates (origin at top left of the entire layout).
	 * Returns: baseline of current line.
	 */
	public int getBaseline();

	/**
	 * Gets the current run. When iterating by run, at the end of each
	 * line, there's a position with a NULL run, so this function can return
	 * NULL. The NULL run at the end of each line ensures that all lines have
	 * at least one run, even lines consisting of only a newline.
	 * Use the faster pango_layout_iter_get_run_readonly() if you do not plan
	 * to modify the contents of the run (glyphs, glyph widths, etc.).
	 * Returns: the current run.
	 */
	public PangoLayoutRun* getRun();
	
	/**
	 * Gets the current run. When iterating by run, at the end of each
	 * line, there's a position with a NULL run, so this function can return
	 * NULL. The NULL run at the end of each line ensures that all lines have
	 * at least one run, even lines consisting of only a newline.
	 * This is a faster alternative to pango_layout_iter_get_run(),
	 * but the user is not expected
	 * to modify the contents of the run (glyphs, glyph widths, etc.).
	 * Since 1.16
	 * Returns: the current run, that should not be modified.
	 */
	public PangoLayoutRun* getRunReadonly();

	/**
	 * Gets the current line.
	 * Use the faster pango_layout_iter_get_line_readonly() if you do not plan
	 * to modify the contents of the line (glyphs, glyph widths, etc.).
	 * Returns: the current line.
	 */
	public PgLayoutLine getLine();
	
	/**
	 * Gets the current line for read-only access.
	 * This is a faster alternative to pango_layout_iter_get_line(),
	 * but the user is not expected
	 * to modify the contents of the line (glyphs, glyph widths, etc.).
	 * Since 1.16
	 * Returns: the current line, that should not be modified.
	 */
	public PgLayoutLine getLineReadonly();
	
	/**
	 * Gets the layout associated with a PangoLayoutIter.
	 * Since 1.20
	 * Returns: the layout associated with iter.
	 */
	public PgLayout getLayout();
	
	/**
	 * Gets the extents of the current character, in layout coordinates
	 * (origin is the top left of the entire layout). Only logical extents
	 * can sensibly be obtained for characters; ink extents make sense only
	 * down to the level of clusters.
	 * Params:
	 * logicalRect =  rectangle to fill with logical extents
	 */
	public void getCharExtents(PangoRectangle* logicalRect);
	
	/**
	 * Gets the extents of the current cluster, in layout coordinates
	 * (origin is the top left of the entire layout).
	 * Params:
	 * inkRect =  rectangle to fill with ink extents, or NULL
	 * logicalRect =  rectangle to fill with logical extents, or NULL
	 */
	public void getClusterExtents(PangoRectangle* inkRect, PangoRectangle* logicalRect);
	
	/**
	 * Gets the extents of the current run in layout coordinates
	 * (origin is the top left of the entire layout).
	 * Params:
	 * inkRect =  rectangle to fill with ink extents, or NULL
	 * logicalRect =  rectangle to fill with logical extents, or NULL
	 */
	public void getRunExtents(PangoRectangle* inkRect, PangoRectangle* logicalRect);
	
	/**
	 * Divides the vertical space in the PangoLayout being iterated over
	 * between the lines in the layout, and returns the space belonging to
	 * the current line. A line's range includes the line's logical
	 * extents, plus half of the spacing above and below the line, if
	 * pango_layout_set_spacing() has been called to set layout spacing.
	 * The Y positions are in layout coordinates (origin at top left of the
	 * entire layout).
	 * Params:
	 * y0_ =  start of line
	 * y1_ =  end of line
	 */
	public void getLineYrange(out int y0_, out int y1_);
	
	/**
	 * Obtains the extents of the current line. ink_rect or logical_rect
	 * can be NULL if you aren't interested in them. Extents are in layout
	 * coordinates (origin is the top-left corner of the entire
	 * PangoLayout). Thus the extents returned by this function will be
	 * the same width/height but not at the same x/y as the extents
	 * returned from pango_layout_line_get_extents().
	 * Params:
	 * inkRect =  rectangle to fill with ink extents, or NULL
	 * logicalRect =  rectangle to fill with logical extents, or NULL
	 */
	public void getLineExtents(PangoRectangle* inkRect, PangoRectangle* logicalRect);
	
	/**
	 * Obtains the extents of the PangoLayout being iterated
	 * over. ink_rect or logical_rect can be NULL if you
	 * aren't interested in them.
	 * Params:
	 * inkRect =  rectangle to fill with ink extents, or NULL
	 * logicalRect =  rectangle to fill with logical extents, or NULL
	 */
	public void getLayoutExtents(PangoRectangle* inkRect, PangoRectangle* logicalRect);
}
