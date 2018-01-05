module gtkD.gtk.MenuBar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.gtk.Menu;;
private import gtkD.gtk.MenuItem;;



private import gtkD.gtk.MenuShell;

/**
 * Description
 * The GtkMenuBar is a subclass of GtkMenuShell which contains one to many GtkMenuItem. The result is a standard menu bar which can hold many menu items. GtkMenuBar allows for a shadow type to be set for aesthetic purposes. The shadow types are defined in the gtk_menu_bar_set_shadow_type function.
 */
public class MenuBar : MenuShell
{
	
	/** the main Gtk struct */
	protected GtkMenuBar* gtkMenuBar;
	
	
	public GtkMenuBar* getMenuBarStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkMenuBar* gtkMenuBar);
	
	/** */
	Menu append(string label, bool rightJustify=false);
	
	/** */
	public override void append(Widget widget);
	
	/**
	 */
	
	/**
	 * Creates the new GtkMenuBar
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets how items should be packed inside a menubar.
	 * Since 2.8
	 * Params:
	 * packDir =  a new GtkPackDirection
	 */
	public void setPackDirection(GtkPackDirection packDir);
	
	/**
	 * Retrieves the current pack direction of the menubar.
	 * See gtk_menu_bar_set_pack_direction().
	 * Since 2.8
	 * Returns: the pack direction
	 */
	public GtkPackDirection getPackDirection();
	
	/**
	 * Sets how widgets should be packed inside the children of a menubar.
	 * Since 2.8
	 * Params:
	 * childPackDir =  a new GtkPackDirection
	 */
	public void setChildPackDirection(GtkPackDirection childPackDir);
	
	/**
	 * Retrieves the current child pack direction of the menubar.
	 * See gtk_menu_bar_set_child_pack_direction().
	 * Since 2.8
	 * Returns: the child pack direction
	 */
	public GtkPackDirection getChildPackDirection();
}
