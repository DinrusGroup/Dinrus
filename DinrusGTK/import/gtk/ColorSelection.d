module gtkD.gtk.ColorSelection;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gdk.Color;



private import gtkD.gtk.VBox;

/**
 * Description
 * The GtkColorSelection is a widget that is used to select
 * a color. It consists of a color wheel and number of sliders
 * and entry boxes for color parameters such as hue, saturation,
 * value, red, green, blue, and opacity. It is found on the standard
 * color selection dialog box GtkColorSelectionDialog.
 */
public class ColorSelection : VBox
{
	
	/** the main Gtk struct */
	protected GtkColorSelection* gtkColorSelection;
	
	
	public GtkColorSelection* getColorSelectionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkColorSelection* gtkColorSelection);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ColorSelection)[] onColorChangedListeners;
	/**
	 * This signal is emitted when the color changes in the GtkColorSelection
	 * according to its update policy.
	 */
	void addOnColorChanged(void delegate(ColorSelection) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackColorChanged(GtkColorSelection* colorselectionStruct, ColorSelection colorSelection);
	
	
	/**
	 * Creates a new GtkColorSelection.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Warning
	 * gtk_color_selection_set_update_policy is deprecated and should not be used in newly-written code.
	 * Sets the policy controlling when the color_changed signals are emitted.
	 * Params:
	 * policy = a GtkUpdateType value indicating the desired policy.
	 */
	public void setUpdatePolicy(GtkUpdateType policy);
	
	/**
	 * Sets the colorsel to use or not use opacity.
	 * Params:
	 * hasOpacity =  TRUE if colorsel can set the opacity, FALSE otherwise.
	 */
	public void setHasOpacityControl(int hasOpacity);
	
	/**
	 * Determines whether the colorsel has an opacity control.
	 * Returns: TRUE if the colorsel has an opacity control. FALSE if it does't.
	 */
	public int getHasOpacityControl();
	
	/**
	 * Shows and hides the palette based upon the value of has_palette.
	 * Params:
	 * hasPalette =  TRUE if palette is to be visible, FALSE otherwise.
	 */
	public void setHasPalette(int hasPalette);
	
	/**
	 * Determines whether the color selector has a color palette.
	 * Returns: TRUE if the selector has a palette. FALSE if it hasn't.
	 */
	public int getHasPalette();
	
	/**
	 * Returns the current alpha value.
	 * Returns: an integer between 0 and 65535.
	 */
	public ushort getCurrentAlpha();
	
	/**
	 * Sets the current opacity to be alpha. The first time this is called, it will
	 * also set the original opacity to be alpha too.
	 * Params:
	 * alpha =  an integer between 0 and 65535.
	 */
	public void setCurrentAlpha(ushort alpha);
	
	/**
	 * Sets color to be the current color in the GtkColorSelection widget.
	 * Params:
	 * color =  a GdkColor to fill in with the current color.
	 */
	public void getCurrentColor(Color color);
	
	/**
	 * Sets the current color to be color. The first time this is called, it will
	 * also set the original color to be color too.
	 * Params:
	 * color =  A GdkColor to set the current color with.
	 */
	public void setCurrentColor(Color color);
	
	/**
	 * Returns the previous alpha value.
	 * Returns: an integer between 0 and 65535.
	 */
	public ushort getPreviousAlpha();
	
	/**
	 * Sets the 'previous' alpha to be alpha. This function should be called with
	 * some hesitations, as it might seem confusing to have that alpha change.
	 * Params:
	 * alpha =  an integer between 0 and 65535.
	 */
	public void setPreviousAlpha(ushort alpha);
	
	/**
	 * Fills color in with the original color value.
	 * Params:
	 * color =  a GdkColor to fill in with the original color value.
	 */
	public void getPreviousColor(Color color);
	
	/**
	 * Sets the 'previous' color to be color. This function should be called with
	 * some hesitations, as it might seem confusing to have that color change.
	 * Calling gtk_color_selection_set_current_color() will also set this color the first
	 * time it is called.
	 * Params:
	 * color =  a GdkColor to set the previous color with.
	 */
	public void setPreviousColor(Color color);
	
	/**
	 * Gets the current state of the colorsel.
	 * Returns: TRUE if the user is currently dragging a color around, and FALSEif the selection has stopped.
	 */
	public int isAdjusting();
	
	/**
	 * Parses a color palette string; the string is a colon-separated
	 * list of color names readable by gdk_color_parse().
	 * Params:
	 * str =  a string encoding a color palette.
	 * colors =  return location for allocated array of GdkColor.
	 * Returns: TRUE if a palette was successfully parsed.
	 */
	public static int paletteFromString(string str, out GdkColor[] colors);
	
	/**
	 * Encodes a palette as a string, useful for persistent storage.
	 * Params:
	 * colors =  an array of colors.
	 * nColors =  length of the array.
	 * Returns: allocated string encoding the palette.
	 */
	public static string paletteToString(Color colors, int nColors);
	
	/**
	 * Warning
	 * gtk_color_selection_set_change_palette_hook has been deprecated since version 2.4 and should not be used in newly-written code. This function does not work in multihead environments.
	 *  Use gtk_color_selection_set_change_palette_with_screen_hook() instead.
	 * Installs a global function to be called whenever the user tries to
	 * modify the palette in a color selection. This function should save
	 * the new palette contents, and update the GtkSettings property
	 * "gtk-color-palette" so all GtkColorSelection widgets will be modified.
	 * Params:
	 * func =  a function to call when the custom palette needs saving.
	 * Returns: the previous change palette hook (that was replaced).
	 */
	public static GtkColorSelectionChangePaletteFunc setChangePaletteHook(GtkColorSelectionChangePaletteFunc func);
	
	/**
	 * Installs a global function to be called whenever the user tries to
	 * modify the palette in a color selection. This function should save
	 * the new palette contents, and update the GtkSettings property
	 * "gtk-color-palette" so all GtkColorSelection widgets will be modified.
	 * Since 2.2
	 * Params:
	 * func =  a function to call when the custom palette needs saving.
	 * Returns: the previous change palette hook (that was replaced).
	 */
	public static GtkColorSelectionChangePaletteWithScreenFunc setChangePaletteWithScreenHook(GtkColorSelectionChangePaletteWithScreenFunc func);
	
	/**
	 * Warning
	 * gtk_color_selection_set_color has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_color_selection_set_current_color() instead.
	 * Sets the current color to be color. The first time this is called, it will
	 * also set the original color to be color too.
	 * Params:
	 * color =  an array of 4 doubles specifying the red, green, blue and opacity
	 *  to set the current color to.
	 */
	public void setColor(double[] color);
	
	/**
	 * Warning
	 * gtk_color_selection_get_color is deprecated and should not be used in newly-written code. Use gtk_color_selection_get_current_color() instead.
	 * Sets color to be the current color in the GtkColorSelection widget.
	 * Params:
	 * color =  an array of 4 gdouble to fill in with the current color.
	 */
	public void getColor(double[] color);
}
