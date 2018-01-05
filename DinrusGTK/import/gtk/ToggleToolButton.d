module gtkD.gtk.ToggleToolButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.ToolItem;



private import gtkD.gtk.ToolButton;

/**
 * Description
 *  A GtkToggleToolButton is a GtkToolItem that contains a toggle
 *  button.
 *  Use gtk_toggle_tool_button_new() to create a new
 *  GtkToggleToolButton. Use gtk_toggle_tool_button_new_from_stock() to
 *  create a new GtkToggleToolButton containing a stock item.
 */
public class ToggleToolButton : ToolButton
{
	
	/** the main Gtk struct */
	protected GtkToggleToolButton* gtkToggleToolButton;
	
	
	public GtkToggleToolButton* getToggleToolButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkToggleToolButton* gtkToggleToolButton);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ToggleToolButton)[] onToggledListeners;
	/**
	 * Emitted whenever the toggle tool button changes state.
	 * See Also
	 *
	 * GtkToolbar, GtkToolButton, GtkSeparatorToolItem
	 * The toolbar widget
	 *  The parent class of GtkToggleToolButton. The properties
	 *  "label_widget", "label", "icon_widget", and "stock_id" on
	 *  GtkToolButton determine the label and icon used on
	 *  GtkToggleToolButtons.
	 *
	 * A subclass of GtkToolItem that separates groups of
	 *  items on a toolbar.
	 *
	 */
	void addOnToggled(void delegate(ToggleToolButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggled(GtkToggleToolButton* toggleToolButtonStruct, ToggleToolButton toggleToolButton);
	
	
	/**
	 * Returns a new GtkToggleToolButton
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GtkToggleToolButton containing the image and text from a
	 * stock item. Some stock ids have preprocessor macros like GTK_STOCK_OK
	 * and GTK_STOCK_APPLY.
	 * It is an error if stock_id is not a name of a stock item.
	 * Since 2.4
	 * Params:
	 * stockId =  the name of the stock item
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string stockId);
	
	/**
	 * Sets the status of the toggle tool button. Set to TRUE if you
	 * want the GtkToggleButton to be 'pressed in', and FALSE to raise it.
	 * This action causes the toggled signal to be emitted.
	 * Since 2.4
	 * Params:
	 * isActive =  whether button should be active
	 */
	public void setActive(int isActive);
	
	/**
	 * Queries a GtkToggleToolButton and returns its current state.
	 * Returns TRUE if the toggle button is pressed in and FALSE if it is raised.
	 * Since 2.4
	 * Returns: TRUE if the toggle tool button is pressed in, FALSE if not
	 */
	public int getActive();
}
