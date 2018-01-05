module gtkD.pango.PgFontset;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.pango.PgFont;
private import gtkD.pango.PgFontMetrics;



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
public class PgFontset : ObjectG
{
	
	/** the main Gtk struct */
	protected PangoFontset* pangoFontset;
	
	
	public PangoFontset* getPgFontsetStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoFontset* pangoFontset);
	
	/**
	 */
	
	/**
	 * Returns the font in the fontset that contains the best glyph for the
	 * Unicode character wc.
	 * Params:
	 * wc =  a Unicode character
	 * Returns: a PangoFont. The caller must call g_object_unref when finished with the font.
	 */
	public PgFont getFont(uint wc);
	
	/**
	 * Get overall metric information for the fonts in the fontset.
	 * Returns: a PangoFontMetrics object. The caller must call pango_font_metrics_unref() when finished using the object.
	 */
	public PgFontMetrics getMetrics();
	
	/**
	 * Iterates through all the fonts in a fontset, calling func for
	 * each one. If func returns TRUE, that stops the iteration.
	 * Since 1.4
	 * Params:
	 * func =  Callback function
	 * data =  data to pass to the callback function
	 */
	public void foreac(PangoFontsetForeachFunc func, void* data);
}
