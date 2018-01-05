module gtkD.gtk.Progress;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Adjustment;



private import gtkD.gtk.Widget;

/**
 * Description
 * A GtkProgress is the abstract base class used to derive
 * a GtkProgressBar which provides a visual representation of
 * the progress of a long running operation.
 */
public class Progress : Widget
{
	
	/** the main Gtk struct */
	protected GtkProgress* gtkProgress;
	
	
	public GtkProgress* getProgressStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkProgress* gtkProgress);
	
	/**
	 */
	
	/**
	 * Warning
	 * gtk_progress_set_show_text is deprecated and should not be used in newly-written code.
	 * Controls whether progress text is shown.
	 * Params:
	 * showText = a boolean indicating whether the progress text
	 * is shown.
	 */
	public void setShowText(int showText);
	
	/**
	 * Warning
	 * gtk_progress_set_text_alignment is deprecated and should not be used in newly-written code.
	 * Controls the alignment of the text within the progress bar area.
	 * Params:
	 * xAlign = a number between 0.0 and 1.0 indicating the horizontal
	 * alignment of the progress text within the GtkProgress.
	 * yAlign = a number between 0.0 and 1.0 indicating the vertical
	 * alignment of the progress text within the GtkProgress.
	 */
	public void setTextAlignment(float xAlign, float yAlign);
	
	/**
	 * Warning
	 * gtk_progress_set_format_string is deprecated and should not be used in newly-written code.
	 * Sets a format string used to display text indicating the
	 * Params:
	 * format = a string used to display progress text, or NULL
	 *  to restore to the default format.
	 */
	public void setFormatString(string format);
	
	/**
	 * Warning
	 * gtk_progress_set_adjustment is deprecated and should not be used in newly-written code.
	 * Associates a GtkAdjustment with the GtkProgress. A GtkAdjustment
	 * is used to represent the upper and lower bounds and the step interval
	 * of the underlying value for which progress is shown.
	 * Params:
	 * adjustment = the GtkAdjustment to be associated with the GtkProgress.
	 */
	public void setAdjustment(Adjustment adjustment);
	
	/**
	 * Warning
	 * gtk_progress_set_percentage is deprecated and should not be used in newly-written code.
	 * Sets the current percentage completion for the GtkProgress.
	 * Params:
	 * percentage = the percentage complete which must be between 0.0
	 * and 1.0.
	 */
	public void setPercentage(double percentage);
	
	/**
	 * Warning
	 * gtk_progress_set_value is deprecated and should not be used in newly-written code.
	 * Sets the value within the GtkProgress to an absolute value.
	 * The value must be within the valid range of values for the
	 * underlying GtkAdjustment.
	 * Params:
	 * value = the value indicating the current completed amount.
	 */
	public void setValue(double value);
	
	/**
	 * Warning
	 * gtk_progress_get_value is deprecated and should not be used in newly-written code.
	 * Returns the current progress complete value.
	 * Returns:the current progress complete value.
	 */
	public double getValue();
	
	/**
	 * Warning
	 * gtk_progress_set_activity_mode is deprecated and should not be used in newly-written code.
	 * A GtkProgress can be in one of two different modes: percentage
	 * mode (the default) and activity mode. In activity mode, the
	 * progress is simply indicated as activity rather than as a percentage
	 * complete.
	 * Params:
	 * activityMode = a boolean, TRUE for activity mode.
	 */
	public void setActivityMode(int activityMode);
	
	/**
	 * Warning
	 * gtk_progress_get_current_text is deprecated and should not be used in newly-written code.
	 * Returns the current text associated with the GtkProgress. This
	 * text is the based on the underlying format string after any substitutions
	 * are made.
	 * Returns:the text indicating the current progress.
	 */
	public string getCurrentText();
	
	/**
	 * Warning
	 * gtk_progress_get_text_from_value is deprecated and should not be used in newly-written code.
	 * Returns the text indicating the progress based on the supplied value.
	 * The current value for the GtkProgress remains unchanged.
	 * Params:
	 * value = an absolute progress value to use when formatting the progress text.
	 * Returns:a string indicating the progress.
	 */
	public string getTextFromValue(double value);
	
	/**
	 * Warning
	 * gtk_progress_get_current_percentage is deprecated and should not be used in newly-written code.
	 * Returns the current progress as a percentage.
	 * Returns:a number between 0.0 and 1.0 indicating the percentage complete.
	 */
	public double getCurrentPercentage();
	
	/**
	 * Warning
	 * gtk_progress_get_percentage_from_value is deprecated and should not be used in newly-written code.
	 * Returns the progress as a percentage calculated from the supplied
	 * absolute progress value.
	 * Params:
	 * value = an absolute progress value.
	 * Returns:a number between 0.0 and 1.0 indicating the percentage completerepresented by value.
	 */
	public double getPercentageFromValue(double value);
	
	/**
	 * Warning
	 * gtk_progress_configure is deprecated and should not be used in newly-written code.
	 * Allows the configuration of the minimum, maximum, and current values for
	 * the GtkProgress.
	 * Params:
	 * value = the current progress value.
	 * min = the minimum progress value.
	 * max = the maximum progress value.
	 */
	public void configure(double value, double min, double max);
}
