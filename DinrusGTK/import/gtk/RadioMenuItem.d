module gtkD.gtk.RadioMenuItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ListSG;



private import gtkD.gtk.CheckMenuItem;

/**
 * Description
 * A radio menu item is a check menu item that belongs to a group. At each
 * instant exactly one of the radio menu items from a group is selected.
 * The group list does not need to be freed, as each GtkRadioMenuItem will
 * remove itself and its list item when it is destroyed.
 * The correct way to create a group of radio menu items is approximatively
 * this:
 * Example 32. How to create a group of radio menu items.
 * GSList *group = NULL;
 * GtkWidget *item;
 * gint i;
 * for (i = 0; i < 5; i++)
 * {
	 *  item = gtk_radio_menu_item_new_with_label (group, "This is an example");
	 *  group = gtk_radio_menu_item_get_group (GTK_RADIO_MENU_ITEM (item));
	 *  if (i == 1)
	 *  gtk_check_menu_item_set_active (GTK_CHECK_MENU_ITEM (item), TRUE);
 * }
 */
public class RadioMenuItem : CheckMenuItem
{
	
	/** the main Gtk struct */
	protected GtkRadioMenuItem* gtkRadioMenuItem;
	
	
	public GtkRadioMenuItem* getRadioMenuItemStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRadioMenuItem* gtkRadioMenuItem);
	
	/**
	 * Creates a new GtkRadioMenuItem whose child is a simple GtkLabel.
	 * The new GtkRadioMenuItem is added to the same group as group.
	 * If mnemonic is true the label will be
	 * created using gtk_label_new_with_mnemonic(), so underscores in label
	 * indicate the mnemonic for the menu item.
	 * Since 2.4
	 * Params:
	 *  group = an existing GtkRadioMenuItem
	 *  label = the text for the label
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (RadioMenuItem radioMenuItem, string label, bool mnemonic=true);
	
	/**
	 * Creates a new GtkRadioMenuItem whose child is a simple GtkLabel.
	 * Params:
	 *  group = the group to which the radio menu item is to be attached
	 *  label = the text for the label
	 *  mnemonic = if true the label
	 *  will be created using gtk_label_new_with_mnemonic(), so underscores
	 *  in label indicate the mnemonic for the menu item.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ListSG group, string label, bool mnemonic=true);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(RadioMenuItem)[] onGroupChangedListeners;
	/**
	 * See Also
	 * GtkMenuItem
	 * because a radio menu item is a menu item.
	 * GtkCheckMenuItem
	 * to know how to handle the check.
	 */
	void addOnGroupChanged(void delegate(RadioMenuItem) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackGroupChanged(GtkRadioMenuItem* radiomenuitemStruct, RadioMenuItem radioMenuItem);
	
	
	/**
	 * Creates a new GtkRadioMenuItem.
	 * Params:
	 * group = the group to which the radio menu item is to be attached
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ListSG group);
	
	/**
	 * Creates a new GtkRadioMenuItem adding it to the same group as group.
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets the group of a radio menu item, or changes it.
	 * Params:
	 * group = the new group.
	 */
	public void setGroup(ListSG group);
	
	/**
	 * Returns the group to which the radio menu item belongs, as a GList of
	 * GtkRadioMenuItem. The list belongs to GTK+ and should not be freed.
	 * Returns:the group of radio_menu_item.
	 */
	public ListSG getGroup();
}
