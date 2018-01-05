module gtkD.pango.PgFontFamily;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.pango.PgFontFace;



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
public class PgFontFamily : ObjectG
{
	
	/** the main Gtk struct */
	protected PangoFontFamily* pangoFontFamily;
	
	
	public PangoFontFamily* getPgFontFamilyStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoFontFamily* pangoFontFamily);
	
	/**
	 */
	
	/**
	 * Gets the name of the family. The name is unique among all
	 * fonts for the font backend and can be used in a PangoFontDescription
	 * to specify that a face from this family is desired.
	 * Returns: the name of the family. This string is owned by the family object and must not be modified or freed.
	 */
	public string getName();
	
	/**
	 * A monospace font is a font designed for text display where the the
	 * characters form a regular grid. For Western languages this would
	 * mean that the advance width of all characters are the same, but
	 * this categorization also includes Asian fonts which include
	 * double-width characters: characters that occupy two grid cells.
	 * g_unichar_iswide() returns a result that indicates whether a
	 * character is typically double-width in a monospace font.
	 * The best way to find out the grid-cell size is to call
	 * pango_font_metrics_get_approximate_digit_width(), since the results
	 * of pango_font_metrics_get_approximate_char_width() may be affected
	 * by double-width characters.
	 * Since 1.4
	 * Returns: TRUE if the family is monospace.
	 */
	public int isMonospace();
	
	/**
	 * Lists the different font faces that make up family. The faces
	 * in a family share a common design, but differ in slant, weight,
	 * width and other aspects.
	 * Params:
	 * faces =  location to store an array of pointers to PangoFontFace
	 *  objects, or NULL. This array should be freed with g_free()
	 *  when it is no longer needed.
	 */
	public void listFaces(out PgFontFace[] faces);
}
