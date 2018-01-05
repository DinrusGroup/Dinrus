module gtkD.pango.PgFontMetrics;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * Pango supports a flexible architecture where a
 * particular rendering architecture can supply an
 * implementation of fonts. The PangoFont structure
 * represents an abstract rendering-system-independent font.
 * Pango provides routines to list available fonts, and
 * to load a font of a given description.
 */
public class PgFontMetrics
{
	
	/** the main Gtk struct */
	protected PangoFontMetrics* pangoFontMetrics;
	
	
	public PangoFontMetrics* getPgFontMetricsStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoFontMetrics* pangoFontMetrics);
	
	/**
	 */
	
	/**
	 * Increase the reference count of a font metrics structure by one.
	 * Returns: metrics
	 */
	public PgFontMetrics doref();
	
	/**
	 * Decrease the reference count of a font metrics structure by one. If
	 * the result is zero, frees the structure and any associated
	 * memory.
	 */
	public void unref();
	
	/**
	 * Gets the ascent from a font metrics structure. The ascent is
	 * the distance from the baseline to the logical top of a line
	 * of text. (The logical top may be above or below the top of the
	 * actual drawn ink. It is necessary to lay out the text to figure
	 * where the ink will be.)
	 * Returns: the ascent, in Pango units.
	 */
	public int getAscent();
	
	/**
	 * Gets the descent from a font metrics structure. The descent is
	 * the distance from the baseline to the logical bottom of a line
	 * of text. (The logical bottom may be above or below the bottom of the
	 * actual drawn ink. It is necessary to lay out the text to figure
	 * where the ink will be.)
	 * Returns: the descent, in Pango units.
	 */
	public int getDescent();
	
	/**
	 * Gets the approximate character width for a font metrics structure.
	 * This is merely a representative value useful, for example, for
	 * determining the initial size for a window. Actual characters in
	 * text will be wider and narrower than this.
	 * Returns: the character width, in Pango units.
	 */
	public int getApproximateCharWidth();

	/**
	 * Gets the approximate digit width for a font metrics structure.
	 * This is merely a representative value useful, for example, for
	 * determining the initial size for a window. Actual digits in
	 * text can be wider or narrower than this, though this value
	 * is generally somewhat more accurate than the result of
	 * pango_font_metrics_get_approximate_char_width() for digits.
	 * Returns: the digit width, in Pango units.
	 */
	public int getApproximateDigitWidth();
	
	/**
	 * Gets the suggested thickness to draw for the underline.
	 * Since 1.6
	 * Returns: the suggested underline thickness, in Pango units.
	 */
	public int getUnderlineThickness();
	
	/**
	 * Gets the suggested position to draw the underline.
	 * The value returned is the distance above the
	 * baseline of the top of the underline. Since most fonts have
	 * underline positions beneath the baseline, this value is typically
	 * negative.
	 * Since 1.6
	 * Returns: the suggested underline position, in Pango units.
	 */
	public int getUnderlinePosition();
	
	/**
	 * Gets the suggested thickness to draw for the strikethrough.
	 * Since 1.6
	 * Returns: the suggested strikethrough thickness, in Pango units.
	 */
	public int getStrikethroughThickness();
	
	/**
	 * Gets the suggested position to draw the strikethrough.
	 * The value returned is the distance above the
	 * baseline of the top of the strikethrough.
	 * Since 1.6
	 * Returns: the suggested strikethrough position, in Pango units.
	 */
	public int getStrikethroughPosition();
}
