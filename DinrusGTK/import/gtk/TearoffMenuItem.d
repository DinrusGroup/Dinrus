module gtkD.gtk.TearoffMenuItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.MenuItem;

/**
 * Description
 * A GtkTearoffMenuItem is a special GtkMenuItem which is used to
 * tear off and reattach its menu.
 * When its menu is shown normally, the GtkTearoffMenuItem is drawn as a
 * dotted line indicating that the menu can be torn off. Activating it
 * causes its menu to be torn off and displayed in its own window
 * as a tearoff menu.
 * When its menu is shown as a tearoff menu, the GtkTearoffMenuItem is drawn
 * as a dotted line which has a left pointing arrow graphic indicating that
 * the tearoff menu can be reattached. Activating it will erase the tearoff
 * menu window.
 */
public class TearoffMenuItem : MenuItem
{
	
	/** the main Gtk struct */
	protected GtkTearoffMenuItem* gtkTearoffMenuItem;
	
	
	public GtkTearoffMenuItem* getTearoffMenuItemStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTearoffMenuItem* gtkTearoffMenuItem);
	
	/**
	 */
	
	/**
	 * Creates a new GtkTearoffMenuItem.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
