module gtkD.gtk.FontSelection;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Font;
private import gtkD.gtk.Widget;
private import gtkD.pango.PgFontFace;
private import gtkD.pango.PgFontFamily;



private import gtkD.gtk.VBox;

/**
 * Description
 * The GtkFontSelection widget lists the available fonts, styles and sizes,
 * allowing the user to select a font.
 * It is used in the GtkFontSelectionDialog widget to provide a dialog box for
 * selecting fonts.
 * To set the font which is initially selected, use
 * gtk_font_selection_set_font_name().
 * To get the selected font use gtk_font_selection_get_font_name().
 * To change the text which is shown in the preview area, use
 * gtk_font_selection_set_preview_text().
 */
public class FontSelection : VBox
{
	
	/** the main Gtk struct */
	protected GtkFontSelection* gtkFontSelection;
	
	
	public GtkFontSelection* getFontSelectionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFontSelection* gtkFontSelection);
	
	/**
	 */
	
	/**
	 * Creates a new GtkFontSelection.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Warning
	 * gtk_font_selection_get_font has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_font_selection_get_font_name() instead.
	 * Gets the currently-selected font.
	 * Returns: A GdkFont.
	 */
	public Font getFont();
	
	/**
	 * Gets the currently-selected font name.
	 * Note that this can be a different string than what you set with
	 * gtk_font_selection_set_font_name(), as the font selection widget may
	 * normalize font names and thus return a string with a different structure.
	 * For example, "Helvetica Italic Bold 12" could be normalized to
	 * "Helvetica Bold Italic 12". Use pango_font_description_equal()
	 * if you want to compare two font descriptions.
	 * Returns: A string with the name of the current font, or NULL if  no font is selected. You must free this string with g_free().
	 */
	public string getFontName();
	
	/**
	 * Sets the currently-selected font.
	 * Note that the fontsel needs to know the screen in which it will appear
	 * for this to work; this can be guaranteed by simply making sure that the
	 * fontsel is inserted in a toplevel window before you call this function.
	 * Params:
	 * fontname =  a font name like "Helvetica 12" or "Times Bold 18"
	 * Returns: TRUE if the font could be set successfully; FALSE if no  such font exists or if the fontsel doesn't belong to a particular  screen yet.
	 */
	public int setFontName(string fontname);
	
	/**
	 * Gets the text displayed in the preview area.
	 * Returns: the text displayed in the preview area.  This string is owned by the widget and should not be  modified or freed
	 */
	public string getPreviewText();
	
	/**
	 * Sets the text displayed in the preview area.
	 * The text is used to show how the selected font looks.
	 * Params:
	 * text =  the text to display in the preview area
	 */
	public void setPreviewText(string text);
	
	/**
	 * Gets the PangoFontFace representing the selected font group
	 * details (i.e. family, slant, weight, width, etc).
	 * Since 2.14
	 * Returns: A PangoFontFace representing the selected font  group details. The returned object is owned by fontsel and must not be modified or freed.
	 */
	public PgFontFace getFace();
	
	/**
	 * This returns the GtkTreeView which lists all styles available for
	 * the selected font. For example, 'Regular', 'Bold', etc.
	 * Since 2.14
	 * Returns: A GtkWidget that is part of fontsel
	 */
	public Widget getFaceList();
	
	/**
	 * Gets the PangoFontFamily representing the selected font family.
	 * Since 2.14
	 * Returns: A PangoFontFamily representing the selected font family. Font families are a collection of font faces. The  returned object is owned by fontsel and must not be modified  or freed.
	 */
	public PgFontFamily getFamily();
	
	/**
	 * The selected font size.
	 * Since 2.14
	 * Returns: A n integer representing the selected font size,  or -1 if no font size is selected.
	 */
	public int getSize();
	
	/**
	 * This returns the GtkTreeView that lists font families, for
	 * example, 'Sans', 'Serif', etc.
	 * Since 2.14
	 * Returns: A GtkWidget that is part of fontsel
	 */
	public Widget getFamilyList();
	
	/**
	 * This returns the GtkEntry used to display the font as a preview.
	 * Since 2.14
	 * Returns: A GtkWidget that is part of fontsel
	 */
	public Widget getPreviewEntry();
	
	/**
	 * This returns the GtkEntry used to allow the user to edit the font
	 * number manually instead of selecting it from the list of font sizes.
	 * Since 2.14
	 * Returns: A GtkWidget that is part of fontsel
	 */
	public Widget getSizeEntry();
	
	/**
	 * This returns the GtkTreeeView used to list font sizes.
	 * Since 2.14
	 * Returns: A GtkWidget that is part of fontsel
	 */
	public Widget getSizeList();
}
