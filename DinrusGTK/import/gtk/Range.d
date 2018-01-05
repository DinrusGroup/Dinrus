module gtkD.gtk.Range;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.Adjustment;
private import gtkD.gtk.OrientableIF;
private import gtkD.gtk.OrientableT;



private import gtkD.gtk.Widget;

/**
 * Description
 * GtkRange is the common base class for widgets which visualize an
 * adjustment, e.g scales or scrollbars.
 * Apart from signals for monitoring the parameters of the adjustment,
 * GtkRange provides properties and methods for influencing the sensitivity
 * of the "steppers". It also provides properties and methods for setting a
 * "fill level" on range widgets. See gtk_range_set_fill_level().
 */
public class Range : Widget, OrientableIF
{
	
	/** the main Gtk struct */
	protected GtkRange* gtkRange;
	
	
	public GtkRange* getRangeStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRange* gtkRange);
	
	// add the Orientable capabilities
	mixin OrientableT!(GtkRange);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(gdouble, Range)[] onAdjustBoundsListeners;
	/**
	 */
	void addOnAdjustBounds(void delegate(gdouble, Range) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAdjustBounds(GtkRange* rangeStruct, gdouble arg1, Range range);
	
	bool delegate(GtkScrollType, gdouble, Range)[] onChangeValueListeners;
	/**
	 * The ::change-value signal is emitted when a scroll action is
	 * performed on a range. It allows an application to determine the
	 * type of scroll event that occurred and the resultant new value.
	 * The application can handle the event itself and return TRUE to
	 * prevent further processing. Or, by returning FALSE, it can pass
	 * the event to other handlers until the default GTK+ handler is
	 * reached.
	 * The value parameter is unrounded. An application that overrides
	 * the ::change-value signal is responsible for clamping the value to
	 * the desired number of decimal digits; the default GTK+ handler
	 * clamps the value based on range->round_digits.
	 * It is not possible to use delayed update policies in an overridden
	 * ::change-value handler.
	 * Since 2.6
	 */
	void addOnChangeValue(bool delegate(GtkScrollType, gdouble, Range) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackChangeValue(GtkRange* rangeStruct, GtkScrollType scroll, gdouble value, Range range);
	
	void delegate(GtkScrollType, Range)[] onMoveSliderListeners;
	/**
	 * Virtual function that moves the slider. Used for keybindings.
	 */
	void addOnMoveSlider(void delegate(GtkScrollType, Range) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveSlider(GtkRange* rangeStruct, GtkScrollType step, Range range);
	
	void delegate(Range)[] onValueChangedListeners;
	/**
	 * Emitted when the range value changes.
	 */
	void addOnValueChanged(void delegate(Range) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackValueChanged(GtkRange* rangeStruct, Range range);
	
	
	/**
	 * Gets the current position of the fill level indicator.
	 * Since 2.12
	 * Returns: The current fill level
	 */
	public double getFillLevel();
	
	/**
	 * Gets whether the range is restricted to the fill level.
	 * Since 2.12
	 * Returns: TRUE if range is restricted to the fill level.
	 */
	public int getRestrictToFillLevel();
	
	/**
	 * Gets whether the range displays the fill level graphically.
	 * Since 2.12
	 * Returns: TRUE if range shows the fill level.
	 */
	public int getShowFillLevel();
	
	/**
	 * Set the new position of the fill level indicator.
	 * The "fill level" is probably best described by its most prominent
	 * use case, which is an indicator for the amount of pre-buffering in
	 * a streaming media player. In that use case, the value of the range
	 * would indicate the current play position, and the fill level would
	 * be the position up to which the file/stream has been downloaded.
	 * This amount of prebuffering can be displayed on the range's trough
	 * and is themeable separately from the trough. To enable fill level
	 * display, use gtk_range_set_show_fill_level(). The range defaults
	 * to not showing the fill level.
	 * Additionally, it's possible to restrict the range's slider position
	 * to values which are smaller than the fill level. This is controller
	 * by gtk_range_set_restrict_to_fill_level() and is by default
	 * enabled.
	 * Since 2.12
	 * Params:
	 * fillLevel =  the new position of the fill level indicator
	 */
	public void setFillLevel(double fillLevel);
	
	/**
	 * Sets whether the slider is restricted to the fill level. See
	 * gtk_range_set_fill_level() for a general description of the fill
	 * level concept.
	 * Since 2.12
	 * Params:
	 * restrictToFillLevel =  Whether the fill level restricts slider movement.
	 */
	public void setRestrictToFillLevel(int restrictToFillLevel);
	
	/**
	 * Sets whether a graphical fill level is show on the trough. See
	 * gtk_range_set_fill_level() for a general description of the fill
	 * level concept.
	 * Since 2.12
	 * Params:
	 * showFillLevel =  Whether a fill level indicator graphics is shown.
	 */
	public void setShowFillLevel(int showFillLevel);
	
	/**
	 * Get the GtkAdjustment which is the "model" object for GtkRange.
	 * See gtk_range_set_adjustment() for details.
	 * The return value does not have a reference added, so should not
	 * be unreferenced.
	 * Returns: a GtkAdjustment
	 */
	public Adjustment getAdjustment();
	
	/**
	 * Sets the update policy for the range. GTK_UPDATE_CONTINUOUS means that
	 * anytime the range slider is moved, the range value will change and the
	 * value_changed signal will be emitted. GTK_UPDATE_DELAYED means that
	 * the value will be updated after a brief timeout where no slider motion
	 * occurs, so updates are spaced by a short time rather than
	 * continuous. GTK_UPDATE_DISCONTINUOUS means that the value will only
	 * be updated when the user releases the button and ends the slider
	 * drag operation.
	 * Params:
	 * policy =  update policy
	 */
	public void setUpdatePolicy(GtkUpdateType policy);
	
	/**
	 * Sets the adjustment to be used as the "model" object for this range
	 * widget. The adjustment indicates the current range value, the
	 * minimum and maximum range values, the step/page increments used
	 * for keybindings and scrolling, and the page size. The page size
	 * is normally 0 for GtkScale and nonzero for GtkScrollbar, and
	 * indicates the size of the visible area of the widget being scrolled.
	 * The page size affects the size of the scrollbar slider.
	 * Params:
	 * adjustment =  a GtkAdjustment
	 */
	public void setAdjustment(Adjustment adjustment);
	
	/**
	 * Gets the value set by gtk_range_set_inverted().
	 * Returns: TRUE if the range is inverted
	 */
	public int getInverted();
	
	/**
	 * Ranges normally move from lower to higher values as the
	 * slider moves from top to bottom or left to right. Inverted
	 * ranges have higher values at the top or on the right rather than
	 * on the bottom or left.
	 * Params:
	 * setting =  TRUE to invert the range
	 */
	public void setInverted(int setting);
	
	/**
	 * Gets the update policy of range. See gtk_range_set_update_policy().
	 * Returns: the current update policy
	 */
	public GtkUpdateType getUpdatePolicy();
	
	/**
	 * Gets the current value of the range.
	 * Returns: current value of the range.
	 */
	public double getValue();
	
	/**
	 * Sets the step and page sizes for the range.
	 * The step size is used when the user clicks the GtkScrollbar
	 * arrows or moves GtkScale via arrow keys. The page size
	 * is used for example when moving via Page Up or Page Down keys.
	 * Params:
	 * step =  step size
	 * page =  page size
	 */
	public void setIncrements(double step, double page);
	
	/**
	 * Sets the allowable values in the GtkRange, and clamps the range
	 * value to be between min and max. (If the range has a non-zero
	 * page size, it is clamped between min and max - page-size.)
	 * Params:
	 * min =  minimum range value
	 * max =  maximum range value
	 */
	public void setRange(double min, double max);
	
	/**
	 * Sets the current value of the range; if the value is outside the
	 * minimum or maximum range values, it will be clamped to fit inside
	 * them. The range emits the "value-changed" signal if the
	 * value changes.
	 * Params:
	 * value =  new value of the range
	 */
	public void setValue(double value);
	
	/**
	 * Sets the sensitivity policy for the stepper that points to the
	 * 'lower' end of the GtkRange's adjustment.
	 * Since 2.10
	 * Params:
	 * sensitivity =  the lower stepper's sensitivity policy.
	 */
	public void setLowerStepperSensitivity(GtkSensitivityType sensitivity);
	
	/**
	 * Gets the sensitivity policy for the stepper that points to the
	 * 'lower' end of the GtkRange's adjustment.
	 * Since 2.10
	 * Returns: The lower stepper's sensitivity policy.
	 */
	public GtkSensitivityType getLowerStepperSensitivity();
	
	/**
	 * Sets the sensitivity policy for the stepper that points to the
	 * 'upper' end of the GtkRange's adjustment.
	 * Since 2.10
	 * Params:
	 * sensitivity =  the upper stepper's sensitivity policy.
	 */
	public void setUpperStepperSensitivity(GtkSensitivityType sensitivity);
	
	/**
	 * Gets the sensitivity policy for the stepper that points to the
	 * 'upper' end of the GtkRange's adjustment.
	 * Since 2.10
	 * Returns: The upper stepper's sensitivity policy.
	 */
	public GtkSensitivityType getUpperStepperSensitivity();
	
	/**
	 * Gets the value set by gtk_range_set_flippable().
	 * Since 2.18
	 * Returns: TRUE if the range is flippable
	 */
	public int getFlippable();
	
	/**
	 * If a range is flippable, it will switch its direction if it is
	 * horizontal and its direction is GTK_TEXT_DIR_RTL.
	 * See gtk_widget_get_direction().
	 * Since 2.18
	 * Params:
	 * flippable =  TRUE to make the range flippable
	 */
	public void setFlippable(int flippable);
}
