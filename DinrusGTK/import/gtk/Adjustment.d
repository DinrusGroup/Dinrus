module gtkD.gtk.Adjustment;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.ObjectGtk;



private import gtkD.gtk.ObjectGtk;

/**
 * Description
 * The GtkAdjustment object represents a value which has an associated lower
 * and upper bound, together with step and page increments, and a page size.
 * It is used within several GTK+ widgets, including
 * GtkSpinButton, GtkViewport, and GtkRange (which is a base class for
 * GtkHScrollbar, GtkVScrollbar, GtkHScale, and GtkVScale).
 * The GtkAdjustment object does not update the value itself. Instead
 * it is left up to the owner of the GtkAdjustment to control the value.
 * The owner of the GtkAdjustment typically calls the
 * gtk_adjustment_value_changed() and gtk_adjustment_changed() functions
 * after changing the value and its bounds. This results in the emission of the
 * "value_changed" or "changed" signal respectively.
 */
public class Adjustment : ObjectGtk
{
	
	/** the main Gtk struct */
	protected GtkAdjustment* gtkAdjustment;
	
	
	public GtkAdjustment* getAdjustmentStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkAdjustment* gtkAdjustment);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Adjustment)[] onChangedListeners;
	/**
	 * Emitted when one or more of the GtkAdjustment fields have been changed,
	 * other than the value field.
	 */
	void addOnChanged(void delegate(Adjustment) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChanged(GtkAdjustment* adjustmentStruct, Adjustment adjustment);
		
	void delegate(Adjustment)[] onValueChangedListeners;
	/**
	 * Emitted when the GtkAdjustment value field has been changed.
	 */
	void addOnValueChanged(void delegate(Adjustment) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackValueChanged(GtkAdjustment* adjustmentStruct, Adjustment adjustment);
	
	
	/**
	 * Creates a new GtkAdjustment.
	 * Params:
	 * value = the initial value.
	 * lower = the minimum value.
	 * upper = the maximum value.
	 * stepIncrement = the step increment.
	 * pageIncrement = the page increment.
	 * pageSize = the page size.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (double value, double lower, double upper, double stepIncrement, double pageIncrement, double pageSize);
	/**
	 * Gets the current value of the adjustment. See
	 * gtk_adjustment_set_value().
	 * Returns: The current value of the adjustment.
	 */
	public double getValue();
	
	/**
	 * Sets the GtkAdjustment value. The value is clamped to lie between
	 * adjustment->lower and
	 * adjustment->upper.
	 * Note that for adjustments which are used in a GtkScrollbar, the effective
	 * range of allowed values goes from adjustment->lower to
	 * adjustment->upper - adjustment->page_size.
	 * Params:
	 * value = the new value.
	 */
	public void setValue(double value);
	
	/**
	 * Updates the GtkAdjustment value to ensure that the range between lower
	 * and upper is in the current page (i.e. between value and value +
	 * page_size).
	 * If the range is larger than the page size, then only the start of it will
	 * be in the current page.
	 * A "changed" signal will be emitted if the value is changed.
	 * Params:
	 * lower = the lower value.
	 * upper = the upper value.
	 */
	public void clampPage(double lower, double upper);
	
	/**
	 * Emits a "changed" signal from the GtkAdjustment.
	 * This is typically called by the owner of the GtkAdjustment after it has
	 * changed any of the GtkAdjustment fields other than the value.
	 */
	public void changed();
	
	/**
	 * Emits a "value_changed" signal from the GtkAdjustment.
	 * This is typically called by the owner of the GtkAdjustment after it has
	 * changed the GtkAdjustment value field.
	 */
	public void valueChanged();
	
	/**
	 * Sets all properties of the adjustment at once.
	 * Use this function to avoid multiple emissions of the "changed"
	 * signal. See gtk_adjustment_set_lower() for an alternative way
	 * of compressing multiple emissions of "changed" into one.
	 * Since 2.14
	 * Params:
	 * value =  the new value
	 * lower =  the new minimum value
	 * upper =  the new maximum value
	 * stepIncrement =  the new step increment
	 * pageIncrement =  the new page increment
	 * pageSize =  the new page size
	 */
	public void configure(double value, double lower, double upper, double stepIncrement, double pageIncrement, double pageSize);
	
	/**
	 * Retrieves the minimum value of the adjustment.
	 * Since 2.14
	 * Returns: The current minimum value of the adjustment.
	 */
	public double getLower();
	
	/**
	 * Retrieves the page increment of the adjustment.
	 * Since 2.14
	 * Returns: The current page increment of the adjustment.
	 */
	public double getPageIncrement();
	
	/**
	 * Retrieves the page size of the adjustment.
	 * Since 2.14
	 * Returns: The current page size of the adjustment.
	 */
	public double getPageSize();
	
	/**
	 * Retrieves the step increment of the adjustment.
	 * Since 2.14
	 * Returns: The current step increment of the adjustment.
	 */
	public double getStepIncrement();
	
	/**
	 * Retrieves the maximum value of the adjustment.
	 * Since 2.14
	 * Returns: The current maximum value of the adjustment.
	 */
	public double getUpper();
	
	/**
	 * Sets the minimum value of the adjustment.
	 * When setting multiple adjustment properties via their individual
	 * setters, multiple "changed" signals will be emitted. However, since
	 * the emission of the "changed" signal is tied to the emission of the
	 * "GObject::notify" signals of the changed properties, it's possible
	 * to compress the "changed" signals into one by calling
	 * g_object_freeze_notify() and g_object_thaw_notify() around the
	 * calls to the individual setters.
	 * Alternatively, using a single g_object_set() for all the properties
	 * to change, or using gtk_adjustment_configure() has the same effect
	 * of compressing "changed" emissions.
	 * Since 2.14
	 * Params:
	 * lower =  the new minimum value
	 */
	public void setLower(double lower);
	
	/**
	 * Sets the page increment of the adjustment.
	 * See gtk_adjustment_set_lower() about how to compress multiple
	 * emissions of the "changed" signal when setting multiple adjustment
	 * properties.
	 * Since 2.14
	 * Params:
	 * pageIncrement =  the new page increment
	 */
	public void setPageIncrement(double pageIncrement);
	
	/**
	 * Sets the page size of the adjustment.
	 * See gtk_adjustment_set_lower() about how to compress multiple
	 * emissions of the "changed" signal when setting multiple adjustment
	 * properties.
	 * Since 2.14
	 * Params:
	 * pageSize =  the new page size
	 */
	public void setPageSize(double pageSize);
	
	/**
	 * Sets the step increment of the adjustment.
	 * See gtk_adjustment_set_lower() about how to compress multiple
	 * emissions of the "changed" signal when setting multiple adjustment
	 * properties.
	 * Since 2.14
	 * Params:
	 * stepIncrement =  the new step increment
	 */
	public void setStepIncrement(double stepIncrement);
	
	/**
	 * Sets the maximum value of the adjustment.
	 * Note that values will be restricted by
	 * upper - page-size if the page-size
	 * property is nonzero.
	 * See gtk_adjustment_set_lower() about how to compress multiple
	 * emissions of the "changed" signal when setting multiple adjustment
	 * properties.
	 * Since 2.14
	 * Params:
	 * upper =  the new maximum value
	 */
	public void setUpper(double upper);
}
