module gtkD.pango.PgFont;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.pango.PgEngineShape;
private import gtkD.pango.PgFontDescription;
private import gtkD.pango.PgCoverage;
private import gtkD.pango.PgFontMetrics;
private import gtkD.pango.PgFontMap;
private import gtkD.pango.PgLanguage;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Pango supports a flexible architecture where a
 * particular rendering architecture can supply an
 * implementation of fonts. The PangoFont structure
 * represents an abstract rendering-system-independent font.
 * Pango provides routines to list available fonts, and
 * to load a font of a given description.
 */
public class PgFont : ObjectG
{
	
	/** the main Gtk struct */
	protected PangoFont* pangoFont;
	
	
	public PangoFont* getPgFontStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoFont* pangoFont);
	
	/**
	 */
	
	/**
	 * Finds the best matching shaper for a font for a particular
	 * language tag and character point.
	 * Params:
	 * language =  the language tag
	 * ch =  a Unicode character.
	 * Returns: the best matching shaper.
	 */
	public PgEngineShape findShaper(PgLanguage language, uint ch);
	
	/**
	 * Returns a description of the font, with font size set in points.
	 * Use pango_font_describe_with_absolute_size() if you want the font
	 * size in device units.
	 * Returns: a newly-allocated PangoFontDescription object.
	 */
	public PgFontDescription describe();
	
	/**
	 * Returns a description of the font, with absolute font size set
	 * (in device units). Use pango_font_describe() if you want the font
	 * size in points.
	 * Since 1.14
	 * Returns: a newly-allocated PangoFontDescription object.
	 */
	public PgFontDescription describeWithAbsoluteSize();
	
	/**
	 * Computes the coverage map for a given font and language tag.
	 * Params:
	 * language =  the language tag
	 * Returns: a newly-allocated PangoCoverage object.
	 */
	public PgCoverage getCoverage(PgLanguage language);
	
	/**
	 * Gets the logical and ink extents of a glyph within a font. The
	 * coordinate system for each rectangle has its origin at the
	 * base line and horizontal origin of the character with increasing
	 * coordinates extending to the right and down. The macros PANGO_ASCENT(),
	 * PANGO_DESCENT(), PANGO_LBEARING(), and PANGO_RBEARING() can be used to convert
	 * from the extents rectangle to more traditional font metrics. The units
	 * of the rectangles are in 1/PANGO_SCALE of a device unit.
	 * If font is NULL, this function gracefully sets some sane values in the
	 * output variables and returns.
	 * Params:
	 * glyph =  the glyph index
	 * inkRect =  rectangle used to store the extents of the glyph as drawn
	 *  or NULL to indicate that the result is not needed.
	 * logicalRect =  rectangle used to store the logical extents of the glyph
	 *  or NULL to indicate that the result is not needed.
	 */
	public void getGlyphExtents(PangoGlyph glyph, PangoRectangle* inkRect, PangoRectangle* logicalRect);
	
	/**
	 * Gets overall metric information for a font. Since the metrics may be
	 * substantially different for different scripts, a language tag can
	 * be provided to indicate that the metrics should be retrieved that
	 * correspond to the script(s) used by that language.
	 * If font is NULL, this function gracefully sets some sane values in the
	 * output variables and returns.
	 * Params:
	 * language =  language tag used to determine which script to get the metrics
	 *  for, or NULL to indicate to get the metrics for the entire
	 *  font.
	 * Returns: a PangoFontMetrics object. The caller must call pango_font_metrics_unref() when finished using the object.
	 */
	public PgFontMetrics getMetrics(PgLanguage language);
	
	/**
	 * Gets the font map for which the font was created.
	 * Note that the font maintains a weak reference
	 * to the font map, so if all references to font map are dropped, the font
	 * map will be finalized even if there are fonts created with the font
	 * map that are still alive. In that case this function will return NULL.
	 * It is the responsibility of the user to ensure that the font map is kept
	 * alive. In most uses this is not an issue as a PangoContext holds
	 * a reference to the font map.
	 * Since 1.10
	 * Returns: the PangoFontMap for the font, or NULL if font is NULL.
	 */
	public PgFontMap getFontMap();
}
