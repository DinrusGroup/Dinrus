module gtkD.gtk.VRuler;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.Ruler;

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
 * The VRuler widget is a widget arranged vertically creating a ruler that is
 * utilized around other widgets such as a text widget. The ruler is used to show
 * the location of the mouse on the window and to show the size of the window in
 * specified units. The available units of measurement are GTK_PIXELS, GTK_INCHES
 * and GTK_CENTIMETERS. GTK_PIXELS is the default.
 * rulers.
 */
public class VRuler : Ruler
{
	
	/** the main Gtk struct */
	protected GtkVRuler* gtkVRuler;
	
	
	public GtkVRuler* getVRulerStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkVRuler* gtkVRuler);
	
	/**
	 */
	
	/**
	 * Creates a new vertical ruler
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
