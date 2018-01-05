module gtkD.gtk.MenuToolButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.ToolItem;
private import gtkD.gtk.Widget;
private import gtkD.gtk.Tooltips;
private import gtkD.gtk.Menu;



private import gtkD.gtk.ToolButton;

/**
 * Description
 *  A GtkMenuToolButton is a GtkToolItem that contains a button and
 *  a small additional button with an arrow. When clicked, the arrow
 *  button pops up a dropdown menu.
 *  Use gtk_menu_tool_button_new() to create a new
 *  GtkMenuToolButton. Use gtk_menu_tool_button_new_from_stock() to
 *  create a new GtkMenuToolButton containing a stock item.
 */
public class MenuToolButton : ToolButton
{
	
	/** the main Gtk struct */
	protected GtkMenuToolButton* gtkMenuToolButton;
	
	
	public GtkMenuToolButton* getMenuToolButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkMenuToolButton* gtkMenuToolButton);
	
	/**
	 * Creates a new GtkMenuToolButton using icon_widget as icon and
	 * label as label.
	 * Since 2.6
	 * Params:
	 *  iconWidget = a widget that will be used as icon widget, or NULL
	 *  label = a string that will be used as label, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(Widget iconWidget, string label);
	
	/**
	 * Creates a new GtkMenuToolButton.
	 * The new GtkMenuToolButton will contain an icon and label from
	 * the stock item indicated by stockID.
	 * Since 2.6
	 * Params:
	 * stockID = the name of a stock item
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this(StockID stockId);
	
	/**
	 * Gets the GtkMenu associated with GtkMenuToolButton.
	 * Since 2.6
	 * Params:
	 *  button = a GtkMenuToolButton
	 * Returns:
	 *  the GtkMenu associated with GtkMenuToolButton
	 */
	public Menu getMenu();
	
	/**
	 * Sets the toolTip for the arrow
	 * Deprecated: Since 2.12 use Widget.setArrowTooltipText() or Widget.setArrowTooltipMarkup()
	 * Params:
	 *    	tipText =
	 *    	tipPrivate =
	 */
	public void setArrowTooltip(string tipText, string tipPrivate);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(MenuToolButton)[] onShowMenuListeners;
	/**
	 * The ::show-menu signal is emitted before the menu is shown.
	 * It can be used to populate the menu on demand, using
	 * gtk_menu_tool_button_get_menu().
	 * Note that even if you populate the menu dynamically in this way,
	 * you must set an empty menu on the GtkMenuToolButton beforehand,
	 * since the arrow is made insensitive if the menu is not set.
	 * See Also
	 *
	 * GtkToolbar, GtkToolButton
	 * The toolbar widget
	 *  The parent class of GtkMenuToolButton. The properties
	 *  "label_widget", "label", "icon_widget", and "stock_id" on
	 *  GtkToolButton determine the label and icon used on
	 *  GtkMenuToolButtons.
	 *
	 */
	void addOnShowMenu(void delegate(MenuToolButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackShowMenu(GtkMenuToolButton* buttonStruct, MenuToolButton menuToolButton);
	
	
	/**
	 * Sets the GtkMenu that is popped up when the user clicks on the arrow.
	 * If menu is NULL, the arrow button becomes insensitive.
	 * Since 2.6
	 * Params:
	 * menu =  the GtkMenu associated with GtkMenuToolButton
	 */
	public void setMenu(Widget menu);
	
	/**
	 * Warning
	 * gtk_menu_tool_button_set_arrow_tooltip has been deprecated since version 2.12 and should not be used in newly-written code. Use gtk_menu_tool_button_set_arrow_tooltip_text()
	 * instead.
	 * Sets the GtkTooltips object to be used for arrow button which
	 * pops up the menu. See gtk_tool_item_set_tooltip() for setting
	 * a tooltip on the whole GtkMenuToolButton.
	 * Since 2.6
	 * Params:
	 * tooltips =  the GtkTooltips object to be used
	 * tipText =  text to be used as tooltip text for tool_item
	 * tipPrivate =  text to be used as private tooltip text
	 */
	public void setArrowTooltip(Tooltips tooltips, string tipText, string tipPrivate);
	
	/**
	 * Sets the tooltip text to be used as tooltip for the arrow button which
	 * pops up the menu. See gtk_tool_item_set_tooltip() for setting a tooltip
	 * on the whole GtkMenuToolButton.
	 * Since 2.12
	 * Params:
	 * text =  text to be used as tooltip text for button's arrow button
	 */
	public void setArrowTooltipText(string text);
	
	/**
	 * Sets the tooltip markup text to be used as tooltip for the arrow button
	 * which pops up the menu. See gtk_tool_item_set_tooltip() for setting a
	 * tooltip on the whole GtkMenuToolButton.
	 * Since 2.12
	 * Params:
	 * markup =  markup text to be used as tooltip text for button's arrow button
	 */
	public void setArrowTooltipMarkup(string markup);
}
