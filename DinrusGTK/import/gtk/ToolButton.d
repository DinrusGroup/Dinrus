module gtkD.gtk.ToolButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.ToolItem;
private import gtkD.gtk.Widget;



private import gtkD.gtk.ToolItem;

/**
 * Description
 * GtkToolButtons are GtkToolItems containing buttons.
 * Use gtk_tool_button_new() to create a new GtkToolButton. Use
 * gtk_tool_button_new_with_stock() to create a GtkToolButton
 * containing a stock item.
 * The label of a GtkToolButton is determined by the properties
 * "label-widget", "label", and "stock-id". If "label-widget" is
 * non-NULL, then that widget is used as the label. Otherwise, if
 * "label" is non-NULL, that string is used as the label. Otherwise, if
 * "stock-id" is non-NULL, the label is determined by the stock
 * item. Otherwise, the button does not have a label.
 * The icon of a GtkToolButton is determined by the properties
 * "icon-widget" and "stock-id". If "icon-widget" is non-NULL, then
 * that widget is used as the icon. Otherwise, if "stock-id" is
 * non-NULL, the icon is determined by the stock item. Otherwise,
 * the button does not have a icon.
 */
public class ToolButton : ToolItem
{
	
	/** the main Gtk struct */
	protected GtkToolButton* gtkToolButton;
	
	
	public GtkToolButton* getToolButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkToolButton* gtkToolButton);
	
	/** An arbitrary string to be used by the application */
	private string action;
	
	/** */
	public void setActionName(string action);
	
	/** */
	public string getActionName();
	
	/** */
	public this (StockID stockID);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ToolButton)[] onClickedListeners;
	/**
	 * This signal is emitted when the tool button is clicked with the mouse
	 * or activated with the keyboard.
	 * See Also
	 * GtkToolbar
	 * The toolbar widget
	 * GtkMenuToolButton
	 * A subclass of GtkToolButton that displays on
	 *  the toolbar a button with an additional dropdown
	 *  menu
	 * GtkToggleToolButton
	 * A subclass of GtkToolButton that displays toggle
	 *  buttons on the toolbar
	 * GtkRadioToolButton
	 * A subclass of GtkToolButton that displays radio
	 *  buttons on the toolbar
	 * GtkSeparatorToolItem
	 * A subclass of GtkToolItem that separates groups of
	 *  items on a toolbar
	 */
	void addOnClicked(void delegate(ToolButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackClicked(GtkToolButton* toolbuttonStruct, ToolButton toolButton);
	
	
	/**
	 * Creates a new GtkToolButton using icon_widget as icon and label as
	 * label.
	 * Since 2.4
	 * Params:
	 * iconWidget =  a widget that will be used as icon widget, or NULL
	 * label =  a string that will be used as label, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Widget iconWidget, string label);
	
	/**
	 * Creates a new GtkToolButton containing the image and text from a
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
	 * Sets label as the label used for the tool button. The "label" property
	 * only has an effect if not overridden by a non-NULL "label_widget" property.
	 * If both the "label_widget" and "label" properties are NULL, the label
	 * is determined by the "stock_id" property. If the "stock_id" property is also
	 * NULL, button will not have a label.
	 * Since 2.4
	 * Params:
	 * label =  a string that will be used as label, or NULL.
	 */
	public void setLabel(string label);
	
	/**
	 * Returns the label used by the tool button, or NULL if the tool button
	 * doesn't have a label. or uses a the label from a stock item. The returned
	 * string is owned by GTK+, and must not be modified or freed.
	 * Since 2.4
	 * Returns: The label, or NULL
	 */
	public string getLabel();
	
	/**
	 * If set, an underline in the label property indicates that the next character
	 * should be used for the mnemonic accelerator key in the overflow menu. For
	 * example, if the label property is "_Open" and use_underline is TRUE,
	 * the label on the tool button will be "Open" and the item on the overflow
	 * menu will have an underlined 'O'.
	 * Labels shown on tool buttons never have mnemonics on them; this property
	 * only affects the menu item on the overflow menu.
	 * Since 2.4
	 * Params:
	 * useUnderline =  whether the button label has the form "_Open"
	 */
	public void setUseUnderline(int useUnderline);
	
	/**
	 * Returns whether underscores in the label property are used as mnemonics
	 * on menu items on the overflow menu. See gtk_tool_button_set_use_underline().
	 * Since 2.4
	 * Returns: TRUE if underscores in the label property are used asmnemonics on menu items on the overflow menu.
	 */
	public int getUseUnderline();
	
	/**
	 * Sets the name of the stock item. See gtk_tool_button_new_from_stock().
	 * The stock_id property only has an effect if not
	 * overridden by non-NULL "label" and "icon_widget" properties.
	 * Since 2.4
	 * Params:
	 * stockId =  a name of a stock item, or NULL
	 */
	public void setStockId(string stockId);
	
	/**
	 * Returns the name of the stock item. See gtk_tool_button_set_stock_id().
	 * The returned string is owned by GTK+ and must not be freed or modifed.
	 * Since 2.4
	 * Returns: the name of the stock item for button.
	 */
	public string getStockId();
	
	/**
	 * Sets the icon for the tool button from a named themed icon.
	 * See the docs for GtkIconTheme for more details.
	 * The "icon_name" property only has an effect if not
	 * overridden by non-NULL "label", "icon_widget" and "stock_id"
	 * properties.
	 * Since 2.8
	 * Params:
	 * iconName =  the name of the themed icon
	 */
	public void setIconName(string iconName);
	
	/**
	 * Returns the name of the themed icon for the tool button,
	 * see gtk_tool_button_set_icon_name().
	 * Since 2.8
	 * Returns: the icon name or NULL if the tool button hasno themed icon
	 */
	public string getIconName();
	
	/**
	 * Sets icon as the widget used as icon on button. If icon_widget is
	 * NULL the icon is determined by the "stock_id" property. If the
	 * "stock_id" property is also NULL, button will not have an icon.
	 * Since 2.4
	 * Params:
	 * iconWidget =  the widget used as icon, or NULL
	 */
	public void setIconWidget(Widget iconWidget);
	
	/**
	 * Return the widget used as icon widget on button. See
	 * gtk_tool_button_set_icon_widget().
	 * Since 2.4
	 * Returns: The widget used as icon on button, or NULL.
	 */
	public Widget getIconWidget();
	
	/**
	 * Sets label_widget as the widget that will be used as the label
	 * for button. If label_widget is NULL the "label" property is used
	 * as label. If "label" is also NULL, the label in the stock item
	 * determined by the "stock_id" property is used as label. If
	 * "stock_id" is also NULL, button does not have a label.
	 * Since 2.4
	 * Params:
	 * labelWidget =  the widget used as label, or NULL
	 */
	public void setLabelWidget(Widget labelWidget);
	
	/**
	 * Returns the widget used as label on button. See
	 * gtk_tool_button_set_label_widget().
	 * Since 2.4
	 * Returns: The widget used as label on button, or NULL.
	 */
	public Widget getLabelWidget();
}
