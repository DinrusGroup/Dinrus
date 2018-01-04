
module gtkD.gtk.Accessible;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.atk.ObjectAtk;

/**
 * Description
 */
public class Accessible : ObjectAtk
{
	
	/** the main Gtk struct */
	protected GtkAccessible* gtkAccessible;
	
	
	public GtkAccessible* getAccessibleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkAccessible* gtkAccessible);
	
	/**
	 */
	
	/**
	 * This function specifies the callback function to be called when the widget
	 * corresponding to a GtkAccessible is destroyed.
	 */
	public void connectWidgetDestroyed();
}
