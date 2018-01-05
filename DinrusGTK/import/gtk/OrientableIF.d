module gtkD.gtk.OrientableIF;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * The GtkOrientable interface is implemented by all widgets that can be
 * oriented horizontally or vertically. Historically, such widgets have been
 * realized as subclasses of a common base class (e.g GtkBox/GtkHBox/GtkVBox
 * and GtkScale/GtkHScale/GtkVScale). GtkOrientable is more flexible in that
 * it allows the orientation to be changed at runtime, allowing the widgets
 * to 'flip'.
 * GtkOrientable was introduced in GTK+ 2.16.
 */
public interface OrientableIF
{
	
	
	public GtkOrientable* getOrientableTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	/**
	 * Retrieves the orientation of the orientable.
	 * Since 2.16
	 * Returns: the orientation of the orientable.
	 */
	public GtkOrientation getOrientation();
	
	/**
	 * Sets the orientation of the orientable.
	 * Since 2.16
	 * Params:
	 * orientation =  the orientable's new orientation.
	 */
	public void setOrientation(GtkOrientation orientation);
}
