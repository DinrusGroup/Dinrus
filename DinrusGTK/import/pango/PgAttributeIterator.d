module gtkD.pango.PgAttributeIterator;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.pango.PgAttribute;
private import gtkD.pango.PgFontDescription;
private import gtkD.pango.PgLanguage;
private import gtkD.glib.ListSG;




/**
 * Description
 * Attributed text is used in a number of places in Pango. It
 * is used as the input to the itemization process and also when
 * creating a PangoLayout. The data types and functions in
 * this section are used to represent and manipulate sets
 * of attributes applied to a portion of text.
 */
public class PgAttributeIterator
{
	
	/** the main Gtk struct */
	protected PangoAttrIterator* pangoAttrIterator;
	
	
	public PangoAttrIterator* getPgAttributeIteratorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoAttrIterator* pangoAttrIterator);
	
	/**
	 */
	
	/**
	 * Copy a PangoAttrIterator
	 * Returns: the newly allocated PangoAttrIterator, which should be freed with pango_attr_iterator_destroy().
	 */
	public PgAttributeIterator copy();
	
	/**
	 * Advance the iterator until the next change of style.
	 * Returns: FALSE if the iterator is at the end of the list, otherwise TRUE
	 */
	public int next();
	
	/**
	 * Get the range of the current segment. Note that the
	 * stored return values are signed, not unsigned like
	 * the values in PangoAttribute. To deal with this API
	 * oversight, stored return values that wouldn't fit into
	 * a signed integer are clamped to G_MAXINT.
	 * Params:
	 * start =  location to store the start of the range
	 * end =  location to store the end of the range
	 */
	public void range(out int start, out int end);
	
	/**
	 * Find the current attribute of a particular type at the iterator
	 * location. When multiple attributes of the same type overlap,
	 * the attribute whose range starts closest to the current location
	 * is used.
	 * Params:
	 * type =  the type of attribute to find.
	 * Returns: the current attribute of the given type, or NULL if no attribute of that type applies to the current location.
	 */
	public PgAttribute get(PangoAttrType type);
	
	/**
	 * Get the font and other attributes at the current iterator position.
	 * Params:
	 * desc =  a PangoFontDescription to fill in with the current values.
	 *  The family name in this structure will be set using
	 *  pango_font_description_set_family_static() using values from
	 *  an attribute in the PangoAttrList associated with the iterator,
	 * language =  if non-NULL, location to store language tag for item, or NULL
	 *  if none is found.
	 * extraAttrs = element type Pango.Attribute): (transfer full. element type Pango.Attribute): (transfer full.
	 */
	public void getFont(PgFontDescription desc, out PgLanguage language, out ListSG extraAttrs);
	
	/**
	 * Gets a list of all attributes at the current position of the
	 * iterator.
	 * Since 1.2
	 * Returns:element-type Pango.Attribute): (transfer full. element-type Pango.Attribute): (transfer full.
	 */
	public ListSG getAttrs();
	
	/**
	 * Destroy a PangoAttrIterator and free all associated memory.
	 */
	public void destroy();
}
