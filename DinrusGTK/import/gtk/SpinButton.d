module gtkD.gtk.SpinButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.Widget;
private import gtkD.gtk.Adjustment;



private import gtkD.gtk.Entry;

/**
 * Description
 * A GtkSpinButton is an ideal way to allow the user to set the value of some
 * attribute. Rather than having to directly type a number into a GtkEntry,
 * GtkSpinButton allows the user to click on one of two arrows to increment or
 * decrement the displayed value. A value can still be typed in, with the bonus
 * that it can be checked to ensure it is in a given range.
 * The main properties of a GtkSpinButton are through a GtkAdjustment. See the
 * GtkAdjustment section for more details about an adjustment's properties.
 * Example 17. Using a GtkSpinButton to get an integer.
 * /+* Provides a function to retrieve an integer value from a GtkSpinButton
 *  * and creates a spin button to model percentage values.
 *  +/
 * gint grab_int_value (GtkSpinButton *a_spinner, gpointer user_data) {
	 *  return gtk_spin_button_get_value_as_int (a_spinner);
 * }
 * void create_integer_spin_button (void) {
	 *  GtkWidget *window, *spinner;
	 *  GtkAdjustment *spinner_adj;
	 *  spinner_adj = (GtkAdjustment *) gtk_adjustment_new (50.0, 0.0, 100.0, 1.0, 5.0, 5.0);
	 *  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
	 *  gtk_container_set_border_width (GTK_CONTAINER (window), 5);
	 *  /+* creates the spinner, with no decimal places +/
	 *  spinner = gtk_spin_button_new (spinner_adj, 1.0, 0);
	 *  gtk_container_add (GTK_CONTAINER (window), spinner);
	 *  gtk_widget_show_all (window);
	 *  return;
 * }
 * Example 18. Using a GtkSpinButton to get a floating point value.
 * /+* Provides a function to retrieve a floating point value from a
 *  * GtkSpinButton, and creates a high precision spin button.
 *  +/
 * gfloat grab_int_value (GtkSpinButton *a_spinner, gpointer user_data) {
	 *  return gtk_spin_button_get_value (a_spinner);
 * }
 * void create_floating_spin_button (void) {
	 *  GtkWidget *window, *spinner;
	 *  GtkAdjustment *spinner_adj;
	 *  spinner_adj = (GtkAdjustment *) gtk_adjustment_new (2.500, 0.0, 5.0, 0.001, 0.1, 0.1);
	 *  window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
	 *  gtk_container_set_border_width (GTK_CONTAINER (window), 5);
	 *  /+* creates the spinner, with three decimal places +/
	 *  spinner = gtk_spin_button_new (spinner_adj, 0.001, 3);
	 *  gtk_container_add (GTK_CONTAINER (window), spinner);
	 *  gtk_widget_show_all (window);
	 *  return;
 * }
 */
public class SpinButton : Entry
{
	
	/** the main Gtk struct */
	protected GtkSpinButton* gtkSpinButton;
	
	
	public GtkSpinButton* getSpinButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSpinButton* gtkSpinButton);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(GtkScrollType, SpinButton)[] onChangeValueListeners;
	/**
	 */
	void addOnChangeValue(void delegate(GtkScrollType, SpinButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChangeValue(GtkSpinButton* spinbuttonStruct, GtkScrollType arg1, SpinButton spinButton);
	
	gint delegate(gpointer, SpinButton)[] onInputListeners;
	/**
	 */
	void addOnInput(gint delegate(gpointer, SpinButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackInput(GtkSpinButton* spinbuttonStruct, gpointer arg1, SpinButton spinButton);
	
	bool delegate(SpinButton)[] onOutputListeners;
	/**
	 * The ::output signal can be used to change to formatting
	 * of the value that is displayed in the spin buttons entry.
	 * /+* show leading zeros +/
	 * static gboolean
	 * on_output (GtkSpinButton *spin,
	 *  gpointer data)
	 * {
		 *  GtkAdjustment *adj;
		 *  gchar *text;
		 *  int value;
		 *  adj = gtk_spin_button_get_adjustment (spin);
		 *  value = (int)gtk_adjustment_get_value (adj);
		 *  text = g_strdup_printf ("%02d", value);
		 *  gtk_entry_set_text (GTK_ENTRY (spin), text);
		 *  g_free (text);
		 *
		 *  return TRUE;
	 * }
	 */
	void addOnOutput(bool delegate(SpinButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackOutput(GtkSpinButton* spinButtonStruct, SpinButton spinButton);
	
	void delegate(SpinButton)[] onValueChangedListeners;
	/**
	 */
	void addOnValueChanged(void delegate(SpinButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackValueChanged(GtkSpinButton* spinbuttonStruct, SpinButton spinButton);
	
	void delegate(SpinButton)[] onWrappedListeners;
	/**
	 * The wrapped signal is emitted right after the spinbutton wraps
	 * from its maximum to minimum value or vice-versa.
	 * Since 2.10
	 * See Also
	 * GtkEntry
	 * retrieve text rather than numbers.
	 */
	void addOnWrapped(void delegate(SpinButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackWrapped(GtkSpinButton* spinbuttonStruct, SpinButton spinButton);
	
	
	/**
	 * Changes the properties of an existing spin button. The adjustment, climb rate, and number of decimal places are all changed accordingly, after this function call.
	 * Params:
	 * adjustment = a GtkAdjustment.
	 * climbRate = the new climb rate.
	 * digits = the number of decimal places to display in the spin button.
	 */
	public void configure(Adjustment adjustment, double climbRate, uint digits);
	
	/**
	 * Creates a new GtkSpinButton.
	 * Params:
	 * adjustment = the GtkAdjustment object that this spin button should use.
	 * climbRate = specifies how much the spin button changes when an arrow is clicked on.
	 * digits = the number of decimal places to display.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Adjustment adjustment, double climbRate, uint digits);
	
	/**
	 * This is a convenience constructor that allows creation of a numeric
	 * GtkSpinButton without manually creating an adjustment. The value is
	 * initially set to the minimum value and a page increment of 10 * step
	 * is the default. The precision of the spin button is equivalent to the
	 * precision of step.
	 * Note that the way in which the precision is derived works best if step
	 * is a power of ten. If the resulting precision is not suitable for your
	 * needs, use gtk_spin_button_set_digits() to correct it.
	 * Params:
	 * min =  Minimum allowable value
	 * max =  Maximum allowable value
	 * step =  Increment added or subtracted by spinning the widget
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (double min, double max, double step);
	
	/**
	 * Replaces the GtkAdjustment associated with spin_button.
	 * Params:
	 * adjustment =  a GtkAdjustment to replace the existing adjustment
	 */
	public void setAdjustment(Adjustment adjustment);
	
	/**
	 * Get the adjustment associated with a GtkSpinButton
	 * Returns: the GtkAdjustment of spin_button
	 */
	public Adjustment getAdjustment();
	
	/**
	 * Set the precision to be displayed by spin_button. Up to 20 digit precision
	 * is allowed.
	 * Params:
	 * digits =  the number of digits after the decimal point to be displayed for the spin button's value
	 */
	public void setDigits(uint digits);
	
	/**
	 * Sets the step and page increments for spin_button. This affects how
	 * quickly the value changes when the spin button's arrows are activated.
	 * Params:
	 * step =  increment applied for a button 1 press.
	 * page =  increment applied for a button 2 press.
	 */
	public void setIncrements(double step, double page);
	
	/**
	 * Sets the minimum and maximum allowable values for spin_button
	 * Params:
	 * min =  minimum allowable value
	 * max =  maximum allowable value
	 */
	public void setRange(double min, double max);
	
	/**
	 * Get the value spin_button represented as an integer.
	 * Returns: the value of spin_button
	 */
	public int getValueAsInt();
	
	/**
	 * Set the value of spin_button.
	 * Params:
	 * value =  the new value
	 */
	public void setValue(double value);
	
	/**
	 * Sets the update behavior of a spin button. This determines whether the
	 * spin button is always updated or only when a valid value is set.
	 * Params:
	 * policy =  a GtkSpinButtonUpdatePolicy value
	 */
	public void setUpdatePolicy(GtkSpinButtonUpdatePolicy policy);
	
	/**
	 * Sets the flag that determines if non-numeric text can be typed into
	 * the spin button.
	 * Params:
	 * numeric =  flag indicating if only numeric entry is allowed.
	 */
	public void setNumeric(int numeric);
	
	/**
	 * Increment or decrement a spin button's value in a specified direction
	 * by a specified amount.
	 * Params:
	 * direction =  a GtkSpinType indicating the direction to spin.
	 * increment =  step increment to apply in the specified direction.
	 */
	public void spin(GtkSpinType direction, double increment);
	
	/**
	 * Sets the flag that determines if a spin button value wraps around to the
	 * opposite limit when the upper or lower limit of the range is exceeded.
	 * Params:
	 * wrap =  a flag indicating if wrapping behavior is performed.
	 */
	public void setWrap(int wrap);
	
	/**
	 * Sets the policy as to whether values are corrected to the nearest step
	 * increment when a spin button is activated after providing an invalid value.
	 * Params:
	 * snapToTicks =  a flag indicating if invalid values should be corrected.
	 */
	public void setSnapToTicks(int snapToTicks);
	
	/**
	 * Manually force an update of the spin button.
	 */
	public void update();
	
	/**
	 * Fetches the precision of spin_button. See gtk_spin_button_set_digits().
	 * Returns: the current precision
	 */
	public uint getDigits();
	
	/**
	 * Gets the current step and page the increments used by spin_button. See
	 * gtk_spin_button_set_increments().
	 * Params:
	 * step =  location to store step increment, or NULL
	 * page =  location to store page increment, or NULL
	 */
	public void getIncrements(out double step, out double page);
	
	/**
	 * Returns whether non-numeric text can be typed into the spin button.
	 * See gtk_spin_button_set_numeric().
	 * Returns: TRUE if only numeric text can be entered
	 */
	public int getNumeric();
	
	/**
	 * Gets the range allowed for spin_button. See
	 * gtk_spin_button_set_range().
	 * Params:
	 * min =  location to store minimum allowed value, or NULL
	 * max =  location to store maximum allowed value, or NULL
	 */
	public void getRange(out double min, out double max);
	
	/**
	 * Returns whether the values are corrected to the nearest step. See
	 * gtk_spin_button_set_snap_to_ticks().
	 * Returns: TRUE if values are snapped to the nearest step.
	 */
	public int getSnapToTicks();
	
	/**
	 * Gets the update behavior of a spin button. See
	 * gtk_spin_button_set_update_policy().
	 * Returns: the current update policy
	 */
	public GtkSpinButtonUpdatePolicy getUpdatePolicy();
	
	/**
	 * Get the value in the spin_button.
	 * Returns: the value of spin_button
	 */
	public double getValue();
	
	/**
	 * Returns whether the spin button's value wraps around to the
	 * opposite limit when the upper or lower limit of the range is
	 * exceeded. See gtk_spin_button_set_wrap().
	 * Returns: TRUE if the spin button wraps around
	 */
	public int getWrap();
}
