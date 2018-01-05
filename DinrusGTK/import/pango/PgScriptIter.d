
module gtkD.pango.PgScriptIter;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * The functions in this section are used to identify the writing
 * system, or script of individual characters
 * and of ranges within a larger text string.
 */
public class PgScriptIter
{
	
	/** the main Gtk struct */
	protected PangoScriptIter* pangoScriptIter;
	
	
	public PangoScriptIter* getPgScriptIterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoScriptIter* pangoScriptIter);
	
	/**
	 */
	
	/**
	 * Create a new PangoScriptIter, used to break a string of
	 * Unicode into runs by text. No copy is made of text, so
	 * the caller needs to make sure it remains valid until
	 * the iterator is freed with pango_script_iter_free().
	 * Since 1.4
	 * Params:
	 * text =  a UTF-8 string
	 * length =  length of text, or -1 if text is nul-terminated.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string text, int length);
	
	/**
	 * Gets information about the range to which iter currently points.
	 * The range is the set of locations p where *start <= p < *end.
	 * (That is, it doesn't include the character stored at *end)
	 * Since 1.4
	 * Params:
	 * start =  location to store start position of the range, or NULL
	 * end =  location to store end position of the range, or NULL
	 * script =  location to store script for range, or NULL
	 */
	public void getRange(out string start, out string end, out PangoScript script);
	
	/**
	 * Advances a PangoScriptIter to the next range. If iter
	 * is already at the end, it is left unchanged and FALSE
	 * is returned.
	 * Since 1.4
	 * Returns: TRUE if iter was successfully advanced.
	 */
	public int next();
	
	/**
	 * Frees a PangoScriptIter created with pango_script_iter_new().
	 * Since 1.4
	 */
	public void free();
}
