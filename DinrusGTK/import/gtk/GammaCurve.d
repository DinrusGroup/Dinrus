module gtkD.gtk.GammaCurve;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.VBox;

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
 * The GtkGammaCurve widget is a variant of GtkCurve specifically for
 * editing gamma curves, which are used in graphics applications such as the
 * Gimp.
 * The GtkGammaCurve widget shows a curve which the user can edit with the
 * mouse just like a GtkCurve widget. On the right of the curve it also displays
 * 5 buttons, 3 of which change between the 3 curve modes (spline, linear and
 * free), and the other 2 set the curve to a particular gamma value, or reset it
 * to a straight line.
 */
public class GammaCurve : VBox
{
	
	/** the main Gtk struct */
	protected GtkGammaCurve* gtkGammaCurve;
	
	
	public GtkGammaCurve* getGammaCurveStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkGammaCurve* gtkGammaCurve);
	
	/**
	 */
	
	/**
	 * Creates a new GtkGammaCurve.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
