module gtkD.gtk.VScale;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Adjustment;



private import gtkD.gtk.Scale;

/**
 * Description
 * The GtkVScale widget is used to allow the user to select a value using
 * a vertical slider. To create one, use gtk_hscale_new_with_range().
 * The position to show the current value, and the number of decimal places
 * shown can be set using the parent GtkScale class's functions.
 */
public class VScale : Scale
{
	
	/** the main Gtk struct */
	protected GtkVScale* gtkVScale;
	
	
	public GtkVScale* getVScaleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkVScale* gtkVScale);
	
	/**
	 */
	
	/**
	 * Creates a new GtkVScale.
	 * Params:
	 * adjustment = the GtkAdjustment which sets the range of the scale.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Adjustment adjustment);
	
	/**
	 * Creates a new vertical scale widget that lets the user input a
	 * number between min and max (including min and max) with the
	 * increment step. step must be nonzero; it's the distance the
	 * slider moves when using the arrow keys to adjust the scale value.
	 * Note that the way in which the precision is derived works best if step
	 * is a power of ten. If the resulting precision is not suitable for your
	 * needs, use gtk_scale_set_digits() to correct it.
	 * Params:
	 * min =  minimum value
	 * max =  maximum value
	 * step =  step increment (tick size) used with keyboard shortcuts
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (double min, double max, double step);
}
