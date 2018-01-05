module gtkD.gtk.RecentChooserMenu;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.RecentManager;
private import gtkD.gtk.ActivatableT;
private import gtkD.gtk.ActivatableIF;
private import gtkD.gtk.RecentChooserIF;
private import gtkD.gtk.RecentChooserT;



private import gtkD.gtk.Menu;

/**
 * Description
 * GtkRecentChooserMenu is a widget suitable for displaying recently used files
 * inside a menu. It can be used to set a sub-menu of a GtkMenuItem using
 * gtk_menu_item_set_submenu(), or as the menu of a GtkMenuToolButton.
 * Note that GtkRecentChooserMenu does not have any methods of its own. Instead,
 * you should use the functions that work on a GtkRecentChooser.
 * Note also that GtkRecentChooserMenu does not support multiple filters, as it
 * has no way to let the user choose between them as the GtkRecentChooserWidget
 * and GtkRecentChooserDialog widgets do. Thus using gtk_recent_chooser_add_filter()
 * on a GtkRecentChooserMenu widget will yield the same effects as using
 * gtk_recent_chooser_set_filter(), replacing any currently set filter
 * with the supplied filter; gtk_recent_chooser_remove_filter() will remove
 * any currently set GtkRecentFilter object and will unset the current filter;
 * gtk_recent_chooser_list_filters() will return a list containing a single
 * GtkRecentFilter object.
 * Recently used files are supported since GTK+ 2.10.
 */
public class RecentChooserMenu : Menu, ActivatableIF, RecentChooserIF
{
	
	/** the main Gtk struct */
	protected GtkRecentChooserMenu* gtkRecentChooserMenu;
	
	
	public GtkRecentChooserMenu* getRecentChooserMenuStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRecentChooserMenu* gtkRecentChooserMenu);
	
	// add the Activatable capabilities
	mixin ActivatableT!(GtkRecentChooserMenu);
	
	// add the RecentChooser capabilities
	mixin RecentChooserT!(GtkRecentChooserMenu);
	
	/**
	 */
	
	/**
	 * Creates a new GtkRecentChooserMenu widget.
	 * This kind of widget shows the list of recently used resources as
	 * a menu, each item as a menu item. Each item inside the menu might
	 * have an icon, representing its MIME type, and a number, for mnemonic
	 * access.
	 * This widget implements the GtkRecentChooser interface.
	 * This widget creates its own GtkRecentManager object. See the
	 * gtk_recent_chooser_menu_new_for_manager() function to know how to create
	 * a GtkRecentChooserMenu widget bound to another GtkRecentManager object.
	 * Since 2.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GtkRecentChooserMenu widget using manager as
	 * the underlying recently used resources manager.
	 * This is useful if you have implemented your own recent manager,
	 * or if you have a customized instance of a GtkRecentManager
	 * object or if you wish to share a common GtkRecentManager object
	 * among multiple GtkRecentChooser widgets.
	 * Since 2.10
	 * Params:
	 * manager =  a GtkRecentManager
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (RecentManager manager);
	
	/**
	 * Returns the value set by gtk_recent_chooser_menu_set_show_numbers().
	 * Since 2.10
	 * Returns: TRUE if numbers should be shown.
	 */
	public int getShowNumbers();
	
	/**
	 * Sets whether a number should be added to the items of menu. The
	 * numbers are shown to provide a unique character for a mnemonic to
	 * be used inside ten menu item's label. Only the first the items
	 * get a number to avoid clashes.
	 * Since 2.10
	 * Params:
	 * showNumbers =  whether to show numbers
	 */
	public void setShowNumbers(int showNumbers);
}
