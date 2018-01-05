module gtkD.pango.PgGlyphString;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.pango.PgFont;




/**
 * Description
 * pango_shape() produces a string of glyphs which
 * can be measured or drawn to the screen. The following
 * structures are used to store information about
 * glyphs.
 */
public class PgGlyphString
{
	
	/** the main Gtk struct */
	protected PangoGlyphString* pangoGlyphString;
	
	
	public PangoGlyphString* getPgGlyphStringStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoGlyphString* pangoGlyphString);
	
	/**
	 */
	
	/**
	 * Create a new PangoGlyphString.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Copy a glyph string and associated storage.
	 * Returns: the newly allocated PangoGlyphString, which should be freed with pango_glyph_string_free(), or NULL if string was NULL.
	 */
	public PgGlyphString copy();
	
	/**
	 * Resize a glyph string to the given length.
	 * Params:
	 * newLen =  the new length of the string.
	 */
	public void setSize(int newLen);
	
	/**
	 * Free a glyph string and associated storage.
	 */
	public void free();
	
	/**
	 * Compute the logical and ink extents of a glyph string. See the documentation
	 * for pango_font_get_glyph_extents() for details about the interpretation
	 * of the rectangles.
	 * Params:
	 * font =  a PangoFont
	 * inkRect =  rectangle used to store the extents of the glyph string as drawn
	 *  or NULL to indicate that the result is not needed.
	 * logicalRect =  rectangle used to store the logical extents of the glyph string
	 *  or NULL to indicate that the result is not needed.
	 */
	public void extents(PgFont font, PangoRectangle* inkRect, PangoRectangle* logicalRect);
	
	/**
	 * Computes the extents of a sub-portion of a glyph string. The extents are
	 * relative to the start of the glyph string range (the origin of their
	 * coordinate system is at the start of the range, not at the start of the entire
	 * glyph string).
	 * Params:
	 * start =  start index
	 * end =  end index (the range is the set of bytes with
	 * 	 indices such that start <= index < end)
	 * font =  a PangoFont
	 * inkRect =  rectangle used to store the extents of the glyph string range as drawn
	 *  or NULL to indicate that the result is not needed.
	 * logicalRect =  rectangle used to store the logical extents of the glyph string range
	 *  or NULL to indicate that the result is not needed.
	 */
	public void extentsRange(int start, int end, PgFont font, PangoRectangle* inkRect, PangoRectangle* logicalRect);
	
	/**
	 * Computes the logical width of the glyph string as can also be computed
	 * using pango_glyph_string_extents(). However, since this only computes the
	 * width, it's much faster. This is in fact only a convenience function that
	 * computes the sum of geometry.width for each glyph in the glyphs.
	 * Since 1.14
	 * Returns: the logical width of the glyph string.
	 */
	public int getWidth();
	
	/**
	 * Converts from character position to x position. (X position
	 * is measured from the left edge of the run). Character positions
	 * are computed by dividing up each cluster into equal portions.
	 * Params:
	 * text =  the text for the run
	 * length =  the number of bytes (not characters) in text.
	 * analysis =  the analysis information return from pango_itemize()
	 * index =  the byte index within text
	 * trailing =  whether we should compute the result for the beginning (FALSE)
	 *  or end (TRUE) of the character.
	 * xPos =  location to store result
	 */
	public void indexToX(string text, int length, PangoAnalysis* analysis, int index, int trailing, out int xPos);
	
	/**
	 * Convert from x offset to character position. Character positions
	 * are computed by dividing up each cluster into equal portions.
	 * In scripts where positioning within a cluster is not allowed
	 * (such as Thai), the returned value may not be a valid cursor
	 * position; the caller must combine the result with the logical
	 * attributes for the text to compute the valid cursor position.
	 * Params:
	 * text =  the text for the run
	 * length =  the number of bytes (not characters) in text.
	 * analysis =  the analysis information return from pango_itemize()
	 * xPos =  the x offset (in Pango units)
	 * index =  location to store calculated byte index within text
	 * trailing =  location to store a boolean indicating
	 *  whether the user clicked on the leading or trailing
	 *  edge of the character.
	 */
	public void xToIndex(string text, int length, PangoAnalysis* analysis, int xPos, out int index, out int trailing);
	
	/**
	 * Given a PangoGlyphString resulting from pango_shape() and the corresponding
	 * text, determine the screen width corresponding to each character. When
	 * multiple characters compose a single cluster, the width of the entire
	 * cluster is divided equally among the characters.
	 * See also pango_glyph_item_get_logical_widths().
	 * Params:
	 * text =  the text corresponding to the glyphs
	 * length =  the length of text, in bytes
	 * embeddingLevel =  the embedding level of the string
	 * logicalWidths =  an array whose length is the number of characters in
	 *  text (equal to g_utf8_strlen (text, length) unless
	 *  text has NUL bytes)
	 *  to be filled in with the resulting character widths.
	 */
	public void getLogicalWidths(string text, int length, int embeddingLevel, int* logicalWidths);
}
