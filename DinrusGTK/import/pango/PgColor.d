module gtkD.pango.PgColor;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * Attributed text is used in a number of places in Pango. It
 * is used as the input to the itemization process and also when
 * creating a PangoLayout. The data types and functions in
 * this section are used to represent and manipulate sets
 * of attributes applied to a portion of text.
 */
public class PgColor
{
	
	/** the main Gtk struct */
	protected PangoColor* pangoColor;
	
	
	public PangoColor* getPgColorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoColor* pangoColor);
	
	/**
	 */
	
	/**
	 * Fill in the fields of a color from a string specification. The
	 * string can either one of a large set of standard names. (Taken
	 * from the X11 rgb.txt file), or it can be a hex value in the
	 * form '#rgb' '#rrggbb' '#rrrgggbbb' or '#rrrrggggbbbb' where
	 * 'r', 'g' and 'b' are hex digits of the red, green, and blue
	 * components of the color, respectively. (White in the four
	 * forms is '#fff' '#ffffff' '#fffffffff' and '#ffffffffffff')
	 * Params:
	 * spec =  a string specifying the new color
	 * Returns: TRUE if parsing of the specifier succeeded, otherwise false.
	 */
	public int parse(string spec);
	
	/**
	 * Creates a copy of src, which should be freed with
	 * pango_color_free(). Primarily used by language bindings,
	 * not that useful otherwise (since colors can just be copied
	 * by assignment in C).
	 * Returns: the newly allocated PangoColor, which should be freed with pango_color_free(), or NULL if src was NULL.
	 */
	public PgColor copy();
	
	/**
	 * Frees a color allocated by pango_color_copy().
	 */
	public void free();
	/**
	 * Returns a textual specification of color in the hexadecimal form
	 * #rrrrggggbbbb, where r,
	 * g and b are hex digits representing
	 * the red, green, and blue components respectively.
	 * Since 1.16
	 * Returns: a newly-allocated text string that must be freed with g_free().
	 */
	public override string toString();
}
