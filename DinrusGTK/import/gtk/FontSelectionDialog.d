module gtkD.gtk.FontSelectionDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Font;
private import gtkD.gtk.Widget;



private import gtkD.gtk.Dialog;

/**
 * Description
 * The GtkFontSelectionDialog widget is a dialog box for selecting a font.
 * To set the font which is initially selected, use
 * gtk_font_selection_dialog_set_font_name().
 * To get the selected font use gtk_font_selection_dialog_get_font_name().
 * To change the text which is shown in the preview area, use
 * gtk_font_selection_dialog_set_preview_text().
 * GtkFontSelectionDialog as GtkBuildable
 * The GtkFontSelectionDialog implementation of the GtkBuildable interface
 * exposes the embedded GtkFontSelection as internal child with the
 * name "font_selection". It also exposes the buttons with the names
 * "ok_button", "cancel_button" and "apply_button".
 */
public class FontSelectionDialog : Dialog
{
	
	/** the main Gtk struct */
	protected GtkFontSelectionDialog* gtkFontSelectionDialog;
	
	
	public GtkFontSelectionDialog* getFontSelectionDialogStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFontSelectionDialog* gtkFontSelectionDialog);
	
	/**
	 */
	
	/**
	 * Creates a new GtkFontSelectionDialog.
	 * Params:
	 * title =  the title of the dialog window
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title);
	
	/**
	 * Warning
	 * gtk_font_selection_dialog_get_font has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_font_selection_dialog_get_font_name() instead.
	 * Gets the currently-selected font.
	 * Returns: the GdkFont from the GtkFontSelection for the currently selected font in the dialog, or NULL if no font is selected
	 */
	public Font getFont();
	
	/**
	 * Gets the currently-selected font name.
	 * Note that this can be a different string than what you set with
	 * gtk_font_selection_dialog_set_font_name(), as the font selection widget
	 * may normalize font names and thus return a string with a different
	 * structure. For example, "Helvetica Italic Bold 12" could be normalized
	 * to "Helvetica Bold Italic 12". Use pango_font_description_equal()
	 * if you want to compare two font descriptions.
	 * Returns: A string with the name of the current font, or NULL if no  font is selected. You must free this string with g_free().
	 */
	public string getFontName();
	
	/**
	 * Sets the currently selected font.
	 * Params:
	 * fontname =  a font name like "Helvetica 12" or "Times Bold 18"
	 * Returns: TRUE if the font selected in fsd is now the fontname specified, FALSE otherwise.
	 */
	public int setFontName(string fontname);
	
	/**
	 * Gets the text displayed in the preview area.
	 * Returns: the text displayed in the preview area.  This string is owned by the widget and should not be  modified or freed
	 */
	public string getPreviewText();
	
	/**
	 * Sets the text displayed in the preview area.
	 * Params:
	 * text =  the text to display in the preview area
	 */
	public void setPreviewText(string text);
	
	/**
	 * Warning
	 * gtk_font_selection_dialog_get_apply_button has been deprecated since version 2.16 and should not be used in newly-written code. Don't use this function.
	 * Obtains a button. The button doesn't have any function.
	 * Since 2.14
	 * Returns: a GtkWidget
	 */
	public Widget getApplyButton();
	
	/**
	 * Gets the 'Cancel' button.
	 * Since 2.14
	 * Returns: the GtkWidget used in the dialog for the 'Cancel' button.
	 */
	public Widget getCancelButton();
	
	/**
	 * Gets the 'OK' button.
	 * Since 2.14
	 * Returns: the GtkWidget used in the dialog for the 'OK' button.
	 */
	public Widget getOkButton();
}
