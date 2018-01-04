module gtkD.gtk.ColorButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gdk.Color;



private import gtkD.gtk.Button;

/**
 * Description
 * The GtkColorButton is a button which displays the currently selected color
 * an allows to open a color selection dialog to change the color. It is suitable
 * widget for selecting a color in a preference dialog.
 */
public class ColorButton : Button
{
	
	/** the main Gtk struct */
	protected GtkColorButton* gtkColorButton;
	
	
	public GtkColorButton* getColorButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkColorButton* gtkColorButton);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ColorButton)[] onColorSetListeners;
	/**
	 * The ::color-set signal is emitted when the user selects a color.
	 * When handling this signal, use gtk_color_button_get_color() and
	 * gtk_color_button_get_alpha() to find out which color was just selected.
	 * Note that this signal is only emitted when the user
	 * changes the color. If you need to react to programmatic color changes
	 * as well, use the notify::color signal.
	 * Since 2.4
	 * See Also
	 * GtkColorSelectionDialog, GtkFontButton
	 */
	void addOnColorSet(void delegate(ColorButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackColorSet(GtkColorButton* widgetStruct, ColorButton colorButton);
	
	
	/**
	 * Creates a new color button. This returns a widget in the form of
	 * a small button containing a swatch representing the current selected
	 * color. When the button is clicked, a color-selection dialog will open,
	 * allowing the user to select a color. The swatch will be updated to reflect
	 * the new color when the user finishes.
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new color button.
	 * Since 2.4
	 * Params:
	 * color =  A GdkColor to set the current color with.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Color color);
	
	/**
	 * Sets the current color to be color.
	 * Since 2.4
	 * Params:
	 * color =  A GdkColor to set the current color with.
	 */
	public void setColor(Color color);
	
	/**
	 * Sets color to be the current color in the GtkColorButton widget.
	 * Since 2.4
	 * Params:
	 * color =  a GdkColor to fill in with the current color.
	 */
	public void getColor(Color color);
	
	/**
	 * Sets the current opacity to be alpha.
	 * Since 2.4
	 * Params:
	 * alpha =  an integer between 0 and 65535.
	 */
	public void setAlpha(ushort alpha);
	
	/**
	 * Returns the current alpha value.
	 * Since 2.4
	 * Returns: an integer between 0 and 65535.
	 */
	public ushort getAlpha();
	
	/**
	 * Sets whether or not the color button should use the alpha channel.
	 * Since 2.4
	 * Params:
	 * useAlpha =  TRUE if color button should use alpha channel, FALSE if not.
	 */
	public void setUseAlpha(int useAlpha);
	
	/**
	 * Does the color selection dialog use the alpha channel?
	 * Since 2.4
	 * Returns: TRUE if the color sample uses alpha channel, FALSE if not.
	 */
	public int getUseAlpha();
	
	/**
	 * Sets the title for the color selection dialog.
	 * Since 2.4
	 * Params:
	 * title =  String containing new window title.
	 */
	public void setTitle(string title);
	
	/**
	 * Gets the title of the color selection dialog.
	 * Since 2.4
	 * Returns: An internal string, do not free the return value
	 */
	public string getTitle();
}
