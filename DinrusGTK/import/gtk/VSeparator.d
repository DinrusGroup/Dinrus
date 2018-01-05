module gtkD.gtk.VSeparator;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.Separator;

/**
 * Description
 * The GtkVSeparator widget is a vertical separator, used to group the
 * widgets within a window. It displays a vertical line with a shadow to
 * make it appear sunken into the interface.
 */
public class VSeparator : Separator
{
	
	/** the main Gtk struct */
	protected GtkVSeparator* gtkVSeparator;
	
	
	public GtkVSeparator* getVSeparatorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkVSeparator* gtkVSeparator);
	
	/**
	 */
	
	/**
	 * Creates a new GtkVSeparator.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
