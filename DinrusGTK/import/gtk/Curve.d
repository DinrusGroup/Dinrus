module gtkD.gtk.Curve;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;




private import gtkD.gtk.DrawingArea;

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
 * The GtkCurve widget allows the user to edit a curve covering a range of
 * values. It is typically used to fine-tune color balances in graphics
 * applications like the Gimp.
 * The GtkCurve widget has 3 modes of operation - spline, linear and free.
 * In spline mode the user places points on the curve which are automatically
 * connected together into a smooth curve. In linear mode the user places points
 * on the curve which are connected by straight lines. In free mode the user can
 * draw the points of the curve freely, and they are not connected at all.
 */
public class Curve : DrawingArea
{
	
	/** the main Gtk struct */
	protected GtkCurve* gtkCurve;
	
	
	public GtkCurve* getCurveStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCurve* gtkCurve);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Curve)[] onCurveTypeChangedListeners;
	/**
	 * Emitted when the curve type has been changed.
	 * The curve type can be changed explicitly with a call to
	 * gtk_curve_set_curve_type(). It is also changed as a side-effect of
	 * calling gtk_curve_reset() or gtk_curve_set_gamma().
	 * See Also
	 * GtkGammaCurve
	 * a subclass for editing gamma curves.
	 */
	void addOnCurveTypeChanged(void delegate(Curve) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCurveTypeChanged(GtkCurve* curveStruct, Curve curve);
	
	
	/**
	 * Creates a new GtkCurve.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Resets the curve to a straight line from the minimum x and y values to the
	 * maximum x and y values (i.e. from the bottom-left to the top-right corners).
	 * The curve type is not changed.
	 */
	public void reset();
	
	/**
	 * Recomputes the entire curve using the given gamma value.
	 * A gamma value of 1 results in a straight line. Values greater than 1 result
	 * in a curve above the straight line. Values less than 1 result in a curve
	 * below the straight line. The curve type is changed to GTK_CURVE_TYPE_FREE.
	 * FIXME: Needs a more precise definition of gamma.
	 * Params:
	 * gamma = the gamma value.
	 */
	public void setGamma(float gamma);
	
	/**
	 * Sets the minimum and maximum x and y values of the curve.
	 * The curve is also reset with a call to gtk_curve_reset().
	 * Params:
	 * minX = the minimum x value.
	 * maxX = the maximum x value.
	 * minY = the minimum y value.
	 * maxY = the maximum y value.
	 */
	public void setRange(float minX, float maxX, float minY, float maxY);
	
	/**
	 * Returns a vector of points representing the curve.
	 * Params:
	 * veclen = the number of points to calculate.
	 * vector = returns the points.
	 */
	public void getVector(int veclen, float[] vector);
	
	/**
	 * Sets the vector of points on the curve.
	 * The curve type is set to GTK_CURVE_TYPE_FREE.
	 * Params:
	 * veclen = the number of points.
	 * vector = the points on the curve.
	 */
	public void setVector(int veclen, float[] vector);
	
	/**
	 * Sets the type of the curve. The curve will remain unchanged except when
	 * changing from a free curve to a linear or spline curve, in which case the
	 * curve will be changed as little as possible.
	 * Params:
	 * type = the type of the curve.
	 */
	public void setCurveType(GtkCurveType type);
}
