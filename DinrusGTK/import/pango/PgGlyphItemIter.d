module gtkD.pango.PgGlyphItemIter;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.pango.PgGlyphItem;




/**
 * Description
 * pango_shape() produces a string of glyphs which
 * can be measured or drawn to the screen. The following
 * structures are used to store information about
 * glyphs.
 */
public class PgGlyphItemIter
{
	
	/** the main Gtk struct */
	protected PangoGlyphItemIter* pangoGlyphItemIter;
	
	
	public PangoGlyphItemIter* getPgGlyphItemIterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoGlyphItemIter* pangoGlyphItemIter);
	
	/**
	 */
	
	/**
	 * Make a shallow copy of an existing PangoGlyphItemIter structure.
	 * Since 1.22
	 * Returns: the newly allocated PangoGlyphItemIter, which should be freed with pango_glyph_item_iter_free(), or NULL if orig was NULL.
	 */
	public PgGlyphItemIter copy();
	
	/**
	 * Frees a PangoGlyphItemIter created by pango_glyph_item_iter_copy().
	 * Since 1.22
	 */
	public void free();
	
	/**
	 * Initializes a PangoGlyphItemIter structure to point to the
	 * first cluster in a glyph item.
	 * See PangoGlyphItemIter for details of cluster orders.
	 * Since 1.22
	 * Params:
	 * glyphItem =  the glyph item to iterate over
	 * text =  text corresponding to the glyph item
	 * Returns: FALSE if there are no clusters in the glyph item
	 */
	public int initStart(PgGlyphItem glyphItem, string text);
	
	/**
	 * Initializes a PangoGlyphItemIter structure to point to the
	 * last cluster in a glyph item.
	 * See PangoGlyphItemIter for details of cluster orders.
	 * Since 1.22
	 * Params:
	 * glyphItem =  the glyph item to iterate over
	 * text =  text corresponding to the glyph item
	 * Returns: FALSE if there are no clusters in the glyph item
	 */
	public int initEnd(PgGlyphItem glyphItem, string text);
	
	/**
	 * Advances the iterator to the next cluster in the glyph item.
	 * See PangoGlyphItemIter for details of cluster orders.
	 * Since 1.22
	 * Returns: TRUE if the iterator was advanced, FALSE if we were already on the last cluster.
	 */
	public int nextCluster();
	
	/**
	 * Moves the iterator to the preceding cluster in the glyph item.
	 * See PangoGlyphItemIter for details of cluster orders.
	 * Since 1.22
	 * Returns: TRUE if the iterator was moved, FALSE if we were already on the first cluster.
	 */
	public int prevCluster();
}
