module gtkD.gsv.SourceMark;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gtk.TextMark;

/**
 * Description
 * A GtkSourceMark preserves a position in the text where you want to display
 * additional info. It is based on GtkTextMark and thus is still valid after the
 * text has changed though it may change it's position.
 * GtkSourceMarks are organised in categories which you have to set when you create
 * the mark. Each category can have a pixbuf and a priority associated using
 * gtk_source_view_set_mark_category_pixbuf and
 * gtk_source_view_set_mark_category_priority. The pixbuf will be displayed
 * in the margin at the line where the mark residents if the
 * "show-line-marks" property is set to TRUE. If there are multiple
 * marks in the same line, the pixbufs
 * will be drawn on top of each other. The mark with the highest priority will
 * be drawn on top.
 */
public class SourceMark : TextMark
{
	
	/** the main Gtk struct */
	protected GtkSourceMark* gtkSourceMark;
	
	
	public GtkSourceMark* getSourceMarkStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSourceMark* gtkSourceMark);
	
	/**
	 */
	
	/**
	 * Creates a text mark. Add it to a buffer using gtk_text_buffer_add_mark().
	 * If name is NULL, the mark is anonymous; otherwise, the mark can be retrieved
	 * by name using gtk_text_buffer_get_mark().
	 * Normally marks are created using the utility function
	 * gtk_source_buffer_create_mark().
	 * Since 2.2
	 * Params:
	 * name =  Name of the GtkSourceMark, can be NULL when not using a name
	 * category =  is used to classify marks according to common characteristics
	 * (e.g. all the marks representing a bookmark could belong to the "bookmark"
	 * category, or all the marks representing a compilation error could belong to
	 * "error" category).
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string category);
	
	/**
	 * Returns the mark category
	 * Since 2.2
	 * Returns: the category of the GtkSourceMark
	 */
	public string getCategory();
	
	/**
	 * Returns the next GtkSourceMark in the buffer or NULL if the mark
	 * was not added to a buffer. If there is no next mark, NULL will be returned.
	 * If category is NULL, looks for marks of any category
	 * Since 2.2
	 * Params:
	 * category =  a string specifying the mark category or NULL
	 * Returns: the next GtkSourceMark or NULL
	 */
	public SourceMark next(string category);
	
	/**
	 * Returns the previous GtkSourceMark in the buffer or NULL if the mark
	 * was not added to a buffer. If there is no previous mark, NULL is returned.
	 * If category is NULL, looks for marks of any category
	 * Since 2.2
	 * Params:
	 * category =  a string specifying the mark category or NULL
	 * Returns: the previous GtkSourceMark or NULL
	 */
	public SourceMark prev(string category);
}
