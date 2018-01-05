module gtkD.gtk.RecentAction;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.RecentManager;



private import gtkD.gtk.Action;

/**
 * Description
 * A GtkRecentAction represents a list of recently used files, which
 * can be shown by widgets such as GtkRecentChooserDialog or
 * GtkRecentChooserMenu.
 * To construct a submenu showing recently used files, use a GtkRecentAction
 * as the action for a <menuitem>. To construct a menu toolbutton showing
 * the recently used files in the popup menu, use a GtkRecentAction as the
 * action for a <toolitem> element.
 */
public class RecentAction : Action
{
	
	/** the main Gtk struct */
	protected GtkRecentAction* gtkRecentAction;
	
	
	public GtkRecentAction* getRecentActionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRecentAction* gtkRecentAction);
	
	/**
	 * Creates a new GtkRecentAction object. To add the action to
	 * a GtkActionGroup and set the accelerator for the action,
	 * call gtk_action_group_add_action_with_accel().
	 * Since 2.12
	 * Params:
	 * name =  a unique name for the action
	 * label =  the label displayed in menu items and on buttons, or NULL
	 * tooltip =  a tooltip for the action, or NULL
	 * stockID =  the stock icon to display in widgets representing the
	 *  action, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string label, string tooltip, StockID stockID);
	
	/**
	 * Creates a new GtkRecentAction object. To add the action to
	 * a GtkActionGroup and set the accelerator for the action,
	 * call gtk_action_group_add_action_with_accel().
	 * Since 2.12
	 * Params:
	 * name =  a unique name for the action
	 * label =  the label displayed in menu items and on buttons, or NULL
	 * tooltip =  a tooltip for the action, or NULL
	 * stockID =  the stock icon to display in widgets representing the
	 *  action, or NULL
	 * manager =  a GtkRecentManager, or NULL for using the default
	 *  GtkRecentManager
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string label, string tooltip, StockID stockID, RecentManager manager);
	
	/**
	 */
	
	/**
	 * Returns the value set by gtk_recent_chooser_menu_set_show_numbers().
	 * Since 2.12
	 * Returns: TRUE if numbers should be shown.
	 */
	public int getShowNumbers();
	
	/**
	 * Sets whether a number should be added to the items shown by the
	 * widgets representing action. The numbers are shown to provide
	 * a unique character for a mnemonic to be used inside the menu item's
	 * label. Only the first ten items get a number to avoid clashes.
	 * Since 2.12
	 * Params:
	 * showNumbers =  TRUE if the shown items should be numbered
	 */
	public void setShowNumbers(int showNumbers);
}
