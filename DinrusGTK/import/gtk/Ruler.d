module gtkD.gtk.Ruler;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.OrientableIF;
private import gtkD.gtk.OrientableT;



private import gtkD.gtk.Widget;

/**
 * Description
 * Note
 *  This widget is considered too specialized/little-used for
 *  GTK+, and will in the future be moved to some other package. If
 *  your application needs this widget, feel free to use it, as the
 *  widget does work and is useful in some applications; it's just not
 *  of general interest. However, we are not accepting new features for
 *  the widget, and it will eventually move out of the GTK+
 *  distribution.
 * The GTKRuler widget is a base class for horizontal and vertical rulers. Rulers
 * are used to show the mouse pointer's location in a window. The ruler can either
 * be horizontal or vertical on the window. Within the ruler a small triangle
 * indicates the location of the mouse relative to the horizontal or vertical
 * ruler. See GtkHRuler to learn how to create a new horizontal ruler. See
 * GtkVRuler to learn how to create a new vertical ruler.
 */
public class Ruler : Widget, OrientableIF
{
	
	/** the main Gtk struct */
	protected GtkRuler* gtkRuler;
	
	
	public GtkRuler* getRulerStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRuler* gtkRuler);
	
	// add the Orientable capabilities
	mixin OrientableT!(GtkRuler);
	
	/**
	 */
	
	/**
	 * This calls the GTKMetricType to set the ruler to units defined. Available units
	 * are GTK_PIXELS, GTK_INCHES, or GTK_CENTIMETERS. The default unit of measurement
	 * is GTK_PIXELS.
	 * Params:
	 * metric = the unit of measurement
	 */
	public void setMetric(GtkMetricType metric);
	
	/**
	 * This sets the range of the ruler.
	 * Params:
	 * lower =  the lower limit of the ruler
	 * upper =  the upper limit of the ruler
	 * position =  the mark on the ruler
	 * maxSize =  the maximum size of the ruler used when calculating the space to
	 * leave for the text
	 */
	public void setRange(double lower, double upper, double position, double maxSize);
	
	/**
	 * Gets the units used for a GtkRuler. See gtk_ruler_set_metric().
	 * Returns: the units currently used for ruler
	 */
	public GtkMetricType getMetric();
	
	/**
	 * Retrieves values indicating the range and current position of a GtkRuler.
	 * See gtk_ruler_set_range().
	 * Params:
	 * lower =  location to store lower limit of the ruler, or NULL
	 * upper =  location to store upper limit of the ruler, or NULL
	 * position =  location to store the current position of the mark on the ruler, or NULL
	 * maxSize =  location to store the maximum size of the ruler used when calculating
	 *  the space to leave for the text, or NULL.
	 */
	public void getRange(out double lower, out double upper, out double position, out double maxSize);
}
