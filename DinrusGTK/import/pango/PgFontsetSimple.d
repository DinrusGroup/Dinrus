module gtkD.pango.PgFontsetSimple;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.pango.PgLanguage;
private import gtkD.pango.PgFont;
private import gtkD.pango.PgFontset;



private import gtkD.pango.PgFontset;

/**
 * Description
 * Pango supports a flexible architecture where a
 * particular rendering architecture can supply an
 * implementation of fonts. The PangoFont structure
 * represents an abstract rendering-system-independent font.
 * Pango provides routines to list available fonts, and
 * to load a font of a given description.
 */
public class PgFontsetSimple : PgFontset
{
	
	/** the main Gtk struct */
	protected PangoFontsetSimple* pangoFontsetSimple;
	
	
	public PangoFontsetSimple* getPgFontsetSimpleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoFontsetSimple* pangoFontsetSimple);
	
	/**
	 */
	
	/**
	 * Creates a new PangoFontsetSimple for the given language.
	 * Params:
	 * language =  a PangoLanguage tag
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (PgLanguage language);
	
	/**
	 * Adds a font to the fontset.
	 * Params:
	 * font =  a PangoFont.
	 */
	public void append(PgFont font);
	
	/**
	 * Returns the number of fonts in the fontset.
	 * Returns: the size of fontset.
	 */
	public int size();
}
