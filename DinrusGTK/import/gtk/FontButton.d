module gtkD.gtk.FontButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;



private import gtkD.gtk.Button;

/**
 * Description
 * The GtkFontButton is a button which displays the currently selected font an allows to open a font selection
 * dialog to change the font. It is suitable widget for selecting a font in a preference dialog.
 */
public class FontButton : Button
{
	
	/** the main Gtk struct */
	protected GtkFontButton* gtkFontButton;
	
	
	public GtkFontButton* getFontButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFontButton* gtkFontButton);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(FontButton)[] onFontSetListeners;
	/**
	 * The ::font-set signal is emitted when the user selects a font.
	 * When handling this signal, use gtk_font_button_get_font_name()
	 * to find out which font was just selected.
	 * Note that this signal is only emitted when the user
	 * changes the font. If you need to react to programmatic font changes
	 * as well, use the notify::font-name signal.
	 * Since 2.4
	 * See Also
	 * GtkFontSelectionDialog, GtkColorButton.
	 */
	void addOnFontSet(void delegate(FontButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackFontSet(GtkFontButton* widgetStruct, FontButton fontButton);
	
	
	/**
	 * Creates a new font picker widget.
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new font picker widget.
	 * Since 2.4
	 * Params:
	 * fontname =  Name of font to display in font selection dialog
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string fontname);
	
	/**
	 * Sets or updates the currently-displayed font in font picker dialog.
	 * Since 2.4
	 * Params:
	 * fontname =  Name of font to display in font selection dialog
	 * Returns: Return value of gtk_font_selection_dialog_set_font_name() if thefont selection dialog exists, otherwise FALSE.
	 */
	public int setFontName(string fontname);
	
	/**
	 * Retrieves the name of the currently selected font. This name includes
	 * style and size information as well. If you want to render something
	 * with the font, use this string with pango_font_description_from_string() .
	 * If you're interested in peeking certain values (family name,
	 * style, size, weight) just query these properties from the
	 * PangoFontDescription object.
	 * Since 2.4
	 * Returns: an internal copy of the font name which must not be freed.
	 */
	public string getFontName();
	
	/**
	 * If show_style is TRUE, the font style will be displayed along with name of the selected font.
	 * Since 2.4
	 * Params:
	 * showStyle =  TRUE if font style should be displayed in label.
	 */
	public void setShowStyle(int showStyle);
	
	/**
	 * Returns whether the name of the font style will be shown in the label.
	 * Since 2.4
	 * Returns: whether the font style will be shown in the label.
	 */
	public int getShowStyle();
	
	/**
	 * If show_size is TRUE, the font size will be displayed along with the name of the selected font.
	 * Since 2.4
	 * Params:
	 * showSize =  TRUE if font size should be displayed in dialog.
	 */
	public void setShowSize(int showSize);
	
	/**
	 * Returns whether the font size will be shown in the label.
	 * Since 2.4
	 * Returns: whether the font size will be shown in the label.
	 */
	public int getShowSize();
	
	/**
	 * If use_font is TRUE, the font name will be written using the selected font.
	 * Since 2.4
	 * Params:
	 * useFont =  If TRUE, font name will be written using font chosen.
	 */
	public void setUseFont(int useFont);
	
	/**
	 * Returns whether the selected font is used in the label.
	 * Since 2.4
	 * Returns: whether the selected font is used in the label.
	 */
	public int getUseFont();
	
	/**
	 * If use_size is TRUE, the font name will be written using the selected size.
	 * Since 2.4
	 * Params:
	 * useSize =  If TRUE, font name will be written using the selected size.
	 */
	public void setUseSize(int useSize);
	
	/**
	 * Returns whether the selected size is used in the label.
	 * Since 2.4
	 * Returns: whether the selected size is used in the label.
	 */
	public int getUseSize();
	
	/**
	 * Sets the title for the font selection dialog.
	 * Since 2.4
	 * Params:
	 * title =  a string containing the font selection dialog title
	 */
	public void setTitle(string title);
	
	/**
	 * Retrieves the title of the font selection dialog.
	 * Since 2.4
	 * Returns: an internal copy of the title string which must not be freed.
	 */
	public string getTitle();
}
