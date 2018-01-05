module gtkD.pango.PgFontFace;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.pango.PgFontDescription;



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
public class PgFontFace : ObjectG
{
	
	/** the main Gtk struct */
	protected PangoFontFace* pangoFontFace;
	
	
	public PangoFontFace* getPgFontFaceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoFontFace* pangoFontFace);
	
	/**
	 */
	
	/**
	 * Gets a name representing the style of this face among the
	 * different faces in the PangoFontFamily for the face. This
	 * name is unique among all faces in the family and is suitable
	 * for displaying to users.
	 * Returns: the face name for the face. This string is owned by the face object and must not be modified or freed.
	 */
	public string getFaceName();
	
	/**
	 * List the available sizes for a font. This is only applicable to bitmap
	 * fonts. For scalable fonts, stores NULL at the location pointed to by
	 * sizes and 0 at the location pointed to by n_sizes. The sizes returned
	 * are in Pango units and are sorted in ascending order.
	 * Since 1.4
	 * Params:
	 * sizes =  location to store a pointer to an array of int. This array
	 *  should be freed with g_free().
	 */
	public void listSizes(out int[] sizes);
	
	/**
	 * Returns the family, style, variant, weight and stretch of
	 * a PangoFontFace. The size field of the resulting font description
	 * will be unset.
	 * Returns: a newly-created PangoFontDescription structure holding the description of the face. Use pango_font_description_free() to free the result.
	 */
	public PgFontDescription describe();
	
	/**
	 * Returns whether a PangoFontFace is synthesized by the underlying
	 * font rendering engine from another face, perhaps by shearing, emboldening,
	 * or lightening it.
	 * Since 1.18
	 * Returns: whether face is synthesized.
	 */
	public int isSynthesized();
}
