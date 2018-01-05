module gtkD.gtk.SeparatorMenuItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.MenuItem;

/**
 * Description
 * The GtkSeparatorMenuItem is a separator used to group
 * items within a menu. It displays a horizontal line with a shadow to
 * make it appear sunken into the interface.
 */
public class SeparatorMenuItem : MenuItem
{
	
	/** the main Gtk struct */
	protected GtkSeparatorMenuItem* gtkSeparatorMenuItem;
	
	
	public GtkSeparatorMenuItem* getSeparatorMenuItemStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSeparatorMenuItem* gtkSeparatorMenuItem);
	
	/**
	 */
	
	/**
	 * Creates a new GtkSeparatorMenuItem.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
