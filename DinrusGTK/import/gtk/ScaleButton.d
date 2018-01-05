module gtkD.gtk.ScaleButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.Adjustment;
private import gtkD.gtk.OrientableIF;
private import gtkD.gtk.OrientableT;



private import gtkD.gtk.Button;

/**
 * Description
 * GtkScaleButton provides a button which pops up a scale widget.
 * This kind of widget is commonly used for volume controls in multimedia
 * applications, and GTK+ provides a GtkVolumeButton subclass that
 * is tailored for this use case.
 */
public class ScaleButton : Button, OrientableIF
{
	
	/** the main Gtk struct */
	protected GtkScaleButton* gtkScaleButton;
	
	
	public GtkScaleButton* getScaleButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkScaleButton* gtkScaleButton);
	
	// add the Orientable capabilities
	mixin OrientableT!(GtkScaleButton);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ScaleButton)[] onPopdownListeners;
	/**
	 * The ::popdown signal is a
	 * keybinding signal
	 * which gets emitted to popdown the scale widget.
	 * The default binding for this signal is Escape.
	 * Since 2.12
	 */
	void addOnPopdown(void delegate(ScaleButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPopdown(GtkScaleButton* buttonStruct, ScaleButton scaleButton);
	
	void delegate(ScaleButton)[] onPopupListeners;
	/**
	 * The ::popup signal is a
	 * keybinding signal
	 * which gets emitted to popup the scale widget.
	 * The default bindings for this signal are Space, Enter and Return.
	 * Since 2.12
	 */
	void addOnPopup(void delegate(ScaleButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPopup(GtkScaleButton* buttonStruct, ScaleButton scaleButton);
	
	void delegate(gdouble, ScaleButton)[] onValueChangedListeners;
	/**
	 * The ::value-changed signal is emitted when the value field has
	 * changed.
	 * Since 2.12
	 */
	void addOnValueChanged(void delegate(gdouble, ScaleButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackValueChanged(GtkScaleButton* buttonStruct, gdouble value, ScaleButton scaleButton);
	
	
	/**
	 * Creates a GtkScaleButton, with a range between min and max, with
	 * a stepping of step.
	 * Since 2.12
	 * Params:
	 * size =  a stock icon size
	 * min =  the minimum value of the scale (usually 0)
	 * max =  the maximum value of the scale (usually 100)
	 * step =  the stepping of value when a scroll-wheel event,
	 *  or up/down arrow event occurs (usually 2)
	 * icons =  a NULL-terminated array of icon names, or NULL if
	 *  you want to set the list later with gtk_scale_button_set_icons()
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GtkIconSize size, double min, double max, double step, string[] icons);
	
	/**
	 * Sets the GtkAdjustment to be used as a model
	 * for the GtkScaleButton's scale.
	 * See gtk_range_set_adjustment() for details.
	 * Since 2.12
	 * Params:
	 * adjustment =  a GtkAdjustment
	 */
	public void setAdjustment(Adjustment adjustment);
	
	/**
	 * Sets the icons to be used by the scale button.
	 * For details, see the "icons" property.
	 * Since 2.12
	 * Params:
	 * icons =  a NULL-terminated array of icon names
	 */
	public void setIcons(string[] icons);
	
	/**
	 * Sets the current value of the scale; if the value is outside
	 * the minimum or maximum range values, it will be clamped to fit
	 * inside them. The scale button emits the "value-changed"
	 * signal if the value changes.
	 * Since 2.12
	 * Params:
	 * value =  new value of the scale button
	 */
	public void setValue(double value);
	
	/**
	 * Gets the GtkAdjustment associated with the GtkScaleButton's scale.
	 * See gtk_range_get_adjustment() for details.
	 * Since 2.12
	 * Returns: the adjustment associated with the scale
	 */
	public Adjustment getAdjustment();
	
	/**
	 * Gets the current value of the scale button.
	 * Since 2.12
	 * Returns: current value of the scale button
	 */
	public double getValue();

	/**
	 * Retrieves the popup of the GtkScaleButton.
	 * Since 2.14
	 * Returns: the popup of the GtkScaleButton
	 */
	public Widget getPopup();
	
	/**
	 * Retrieves the plus button of the GtkScaleButton.
	 * Since 2.14
	 * Returns: the plus button of the GtkScaleButton.
	 */
	public Widget getPlusButton();
	
	/**
	 * Retrieves the minus button of the GtkScaleButton.
	 * Since 2.14
	 * Returns: the minus button of the GtkScaleButton.
	 */
	public Widget getMinusButton();
	
	/**
	 * Warning
	 * gtk_scale_button_set_orientation has been deprecated since version 2.16 and should not be used in newly-written code. Use gtk_orientable_set_orientation() instead.
	 * Sets the orientation of the GtkScaleButton's popup window.
	 * Since 2.14
	 * Params:
	 * orientation =  the new orientation
	 */
	public void setOrientation(GtkOrientation orientation);
	
	/**
	 * Warning
	 * gtk_scale_button_get_orientation has been deprecated since version 2.16 and should not be used in newly-written code. Use gtk_orientable_get_orientation() instead.
	 * Gets the orientation of the GtkScaleButton's popup window.
	 * Since 2.14
	 * Returns: the GtkScaleButton's orientation.
	 */
	public GtkOrientation getOrientation();
}
