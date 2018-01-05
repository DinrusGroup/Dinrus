
module gtkD.gtk.ProgressBar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Adjustment;



private import gtkD.gtk.Progress;

/**
 * Description
 * The GtkProgressBar is typically used to display the progress of a long
 * running operation. It provides a visual clue that processing
 * is underway. The GtkProgressBar can be used in two different
 * modes: percentage mode and activity mode.
 * When an application can determine how much work needs to take place
 * (e.g. read a fixed number of bytes from a file) and can monitor its
 * progress, it can use the GtkProgressBar in percentage mode and the user
 * sees a growing bar indicating the percentage of the work that has
 * been completed. In this mode, the application is required to call
 * gtk_progress_bar_set_fraction() periodically to update the progress bar.
 * When an application has no accurate way of knowing the amount of work
 * to do, it can use the GtkProgressBar in activity mode, which shows activity
 * by a block moving back and forth within the progress area. In this mode,
 * the application is required to call gtk_progress_bar_pulse() perodically
 * to update the progress bar.
 * There is quite a bit of flexibility provided to control the appearance
 * of the GtkProgressBar. Functions are provided to control the
 * orientation of the bar, optional text can be displayed along with
 * the bar, and the step size used in activity mode can be set.
 * Note
 * The GtkProgressBar/GtkProgress API in GTK 1.2 was bloated, needlessly complex
 * and hard to use properly. Therefore GtkProgress has been deprecated
 * completely and the GtkProgressBar API has been reduced to the following 10
 * functions: gtk_progress_bar_new(), gtk_progress_bar_pulse(),
 * gtk_progress_bar_set_text(), gtk_progress_bar_set_fraction(),
 * gtk_progress_bar_set_pulse_step(), gtk_progress_bar_set_orientation(),
 * gtk_progress_bar_get_text(), gtk_progress_bar_get_fraction(),
 * gtk_progress_bar_get_pulse_step(), gtk_progress_bar_get_orientation().
 * These have been grouped at the beginning of this section, followed by
 * a large chunk of deprecated 1.2 compatibility functions.
 */
public class ProgressBar : Progress
{
	
	/** the main Gtk struct */
	protected GtkProgressBar* gtkProgressBar;
	
	
	public GtkProgressBar* getProgressBarStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkProgressBar* gtkProgressBar);
	
	/**
	 */
	
	/**
	 * Creates a new GtkProgressBar.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Indicates that some progress is made, but you don't know how much.
	 * Causes the progress bar to enter "activity mode," where a block
	 * bounces back and forth. Each call to gtk_progress_bar_pulse()
	 * causes the block to move by a little bit (the amount of movement
	 * per pulse is determined by gtk_progress_bar_set_pulse_step()).
	 */
	public void pulse();
	
	/**
	 * Causes the given text to appear superimposed on the progress bar.
	 * Params:
	 * text =  a UTF-8 string, or NULL
	 */
	public void setText(string text);
	
	/**
	 * Causes the progress bar to "fill in" the given fraction
	 * of the bar. The fraction should be between 0.0 and 1.0,
	 * inclusive.
	 * Params:
	 * fraction =  fraction of the task that's been completed
	 */
	public void setFraction(double fraction);
	
	/**
	 * Sets the fraction of total progress bar length to move the
	 * bouncing block for each call to gtk_progress_bar_pulse().
	 * Params:
	 * fraction =  fraction between 0.0 and 1.0
	 */
	public void setPulseStep(double fraction);
	
	/**
	 * Causes the progress bar to switch to a different orientation
	 * (left-to-right, right-to-left, top-to-bottom, or bottom-to-top).
	 * Params:
	 * orientation =  orientation of the progress bar
	 */
	public void setOrientation(GtkProgressBarOrientation orientation);
	
	/**
	 * Sets the mode used to ellipsize (add an ellipsis: "...") the text
	 * if there is not enough space to render the entire string.
	 * Since 2.6
	 * Params:
	 * mode =  a PangoEllipsizeMode
	 */
	public void setEllipsize(PangoEllipsizeMode mode);
	
	/**
	 * Retrieves the text displayed superimposed on the progress bar,
	 * if any, otherwise NULL. The return value is a reference
	 * to the text, not a copy of it, so will become invalid
	 * if you change the text in the progress bar.
	 * Returns: text, or NULL; this string is owned by the widgetand should not be modified or freed.
	 */
	public string getText();
	
	/**
	 * Returns the current fraction of the task that's been completed.
	 * Returns: a fraction from 0.0 to 1.0
	 */
	public double getFraction();
	
	/**
	 * Retrieves the pulse step set with gtk_progress_bar_set_pulse_step()
	 * Returns: a fraction from 0.0 to 1.0
	 */
	public double getPulseStep();
	
	/**
	 * Retrieves the current progress bar orientation.
	 * Returns: orientation of the progress bar
	 */
	public GtkProgressBarOrientation getOrientation();
	
	/**
	 * Returns the ellipsizing position of the progressbar.
	 * See gtk_progress_bar_set_ellipsize().
	 * Since 2.6
	 * Returns: PangoEllipsizeMode
	 */
	public PangoEllipsizeMode getEllipsize();
	
	/**
	 * Warning
	 * gtk_progress_bar_new_with_adjustment is deprecated and should not be used in newly-written code.
	 * Creates a new GtkProgressBar with an associated GtkAdjustment.
	 * Params:
	 * adjustment = a GtkAdjustment.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Adjustment adjustment);
	
	/**
	 * Warning
	 * gtk_progress_bar_set_bar_style is deprecated and should not be used in newly-written code.
	 * Sets the style of the GtkProgressBar. The default style is
	 * GTK_PROGRESS_CONTINUOUS.
	 * Params:
	 * style = a GtkProgressBarStyle value indicating the desired style.
	 */
	public void setBarStyle(GtkProgressBarStyle style);
	
	/**
	 * Warning
	 * gtk_progress_bar_set_discrete_blocks is deprecated and should not be used in newly-written code.
	 * Sets the number of blocks that the progress bar is divided into
	 * when the style is GTK_PROGRESS_DISCRETE.
	 * Params:
	 * blocks = number of individual blocks making up the bar.
	 */
	public void setDiscreteBlocks(uint blocks);
	
	/**
	 * Warning
	 * gtk_progress_bar_set_activity_step is deprecated and should not be used in newly-written code.
	 * Sets the step value used when the progress bar is in activity
	 * mode. The step is the amount by which the progress is incremented
	 * each iteration.
	 * Params:
	 * step = the amount which the progress is incremented in activity
	 * mode.
	 */
	public void setActivityStep(uint step);
	
	/**
	 * Warning
	 * gtk_progress_bar_set_activity_blocks is deprecated and should not be used in newly-written code.
	 * Sets the number of blocks used when the progress bar is in activity
	 * mode. Larger numbers make the visible block smaller.
	 * Params:
	 * blocks = number of blocks which can fit within the progress bar area.
	 */
	public void setActivityBlocks(uint blocks);
	
	/**
	 * Warning
	 * gtk_progress_bar_update is deprecated and should not be used in newly-written code.
	 * This function is deprecated. Please use gtk_progress_set_value() or
	 * gtk_progress_set_percentage() instead.
	 * Params:
	 * percentage = the new percent complete value.
	 */
	public void update(double percentage);
}
