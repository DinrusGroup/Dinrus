
module gtkD.gtk.CheckMenuItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;



private import gtkD.gtk.MenuItem;

/**
 * Description
 * A GtkCheckMenuItem is a menu item that maintains the state of a boolean
 * value in addition to a GtkMenuItem's usual role in activating application
 * code.
 * A check box indicating the state of the boolean value is displayed
 * at the left side of the GtkMenuItem. Activating the GtkMenuItem
 * toggles the value.
 */
public class CheckMenuItem : MenuItem
{
	
	/** the main Gtk struct */
	protected GtkCheckMenuItem* gtkCheckMenuItem;
	
	
	public GtkCheckMenuItem* getCheckMenuItemStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCheckMenuItem* gtkCheckMenuItem);
	
	/**
	 * Creates a new GtkCheckMenuItem with a label.
	 * Params:
	 *  label = the string to use for the label.
	 *  mnemonic = if true the label
	 *  will be created using gtk_label_new_with_mnemonic(), so underscores
	 *  in label indicate the mnemonic for the menu item.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label, bool mnemonic=true);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(CheckMenuItem)[] onToggledListeners;
	/**
	 * This signal is emitted when the state of the check box is changed.
	 * A signal handler can examine the active
	 * field of the GtkCheckMenuItem struct to discover the new state.
	 */
	void addOnToggled(void delegate(CheckMenuItem) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggled(GtkCheckMenuItem* checkmenuitemStruct, CheckMenuItem checkMenuItem);
	
	
	/**
	 * Creates a new GtkCheckMenuItem.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Returns whether the check menu item is active. See
	 * gtk_check_menu_item_set_active().
	 * Returns: TRUE if the menu item is checked.
	 */
	public int getActive();
	
	/**
	 * Sets the active state of the menu item's check box.
	 * Params:
	 * isActive = boolean value indicating whether the check box is active.
	 */
	public void setActive(int isActive);
	
	/**
	 * Warning
	 * gtk_check_menu_item_set_show_toggle is deprecated and should not be used in newly-written code.
	 * Controls whether the check box is shown at all times.
	 * Normally the check box is shown only when it is active or while the
	 * menu item is selected.
	 * Params:
	 * always = boolean value indicating whether to always show the check box.
	 */
	public void setShowToggle(int always);
	
	/**
	 * Emits the GtkCheckMenuItem::toggled signal.
	 */
	public void toggled();
	
	/**
	 * Retrieves the value set by gtk_check_menu_item_set_inconsistent().
	 * Returns: TRUE if inconsistent
	 */
	public int getInconsistent();
	
	/**
	 * If the user has selected a range of elements (such as some text or
	 * spreadsheet cells) that are affected by a boolean setting, and the
	 * current values in that range are inconsistent, you may want to
	 * display the check in an "in between" state. This function turns on
	 * "in between" display. Normally you would turn off the inconsistent
	 * state again if the user explicitly selects a setting. This has to be
	 * done manually, gtk_check_menu_item_set_inconsistent() only affects
	 * visual appearance, it doesn't affect the semantics of the widget.
	 * Params:
	 * setting =  TRUE to display an "inconsistent" third state check
	 */
	public void setInconsistent(int setting);
	
	/**
	 * Sets whether check_menu_item is drawn like a GtkRadioMenuItem
	 * Since 2.4
	 * Params:
	 * drawAsRadio =  whether check_menu_item is drawn like a GtkRadioMenuItem
	 */
	public void setDrawAsRadio(int drawAsRadio);
	
	/**
	 * Returns whether check_menu_item looks like a GtkRadioMenuItem
	 * Since 2.4
	 * Returns: Whether check_menu_item looks like a GtkRadioMenuItem
	 */
	public int getDrawAsRadio();
}
