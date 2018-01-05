module gtkD.gtk.RadioToolButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.ToolItem;
private import gtkD.glib.ListSG;



private import gtkD.gtk.ToggleToolButton;

/**
 * Description
 * A GtkRadioToolButton is a GtkToolItem that contains a radio button,
 * that is, a button that is part of a group of toggle buttons where only
 * one button can be active at a time.
 * Use gtk_radio_tool_button_new() to create a new
 * GtkRadioToolButton. use gtk_radio_tool_button_new_from_widget() to
 * create a new GtkRadioToolButton that is part of the same group as an
 * existing GtkRadioToolButton. Use
 * gtk_radio_tool_button_new_from_stock() or
 * gtk_radio_tool_button_new_from_widget_with_stock() to create a new
 * GtkRAdioToolButton containing a stock item.
 */
public class RadioToolButton : ToggleToolButton
{
	
	/** the main Gtk struct */
	protected GtkRadioToolButton* gtkRadioToolButton;
	
	
	public GtkRadioToolButton* getRadioToolButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRadioToolButton* gtkRadioToolButton);
	
	/**
	 */
	
	/**
	 * Creates a new GtkRadioToolButton, adding it to group.
	 * Since 2.4
	 * Params:
	 * group =  An existing radio button group, or NULL if you are creating a new group
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ListSG group);
	
	/**
	 * Creates a new GtkRadioToolButton, adding it to group.
	 * The new GtkRadioToolButton will contain an icon and label from the
	 * stock item indicated by stock_id.
	 * Since 2.4
	 * Params:
	 * group =  an existing radio button group, or NULL if you are creating a new group
	 * stockId =  the name of a stock item
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ListSG group, string stockId);
	
	/**
	 * Creates a new GtkRadioToolButton adding it to the same group as gruup
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GtkRadioToolButton adding it to the same group as group.
	 * The new GtkRadioToolButton will contain an icon and label from the
	 * stock item indicated by stock_id.
	 * Since 2.4
	 * Params:
	 * stockId =  the name of a stock item
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string stockId);
	
	/**
	 * Returns the radio button group button belongs to.
	 * Since 2.4
	 * Returns: The group button belongs to.
	 */
	public ListSG getGroup();
	
	/**
	 * Adds button to group, removing it from the group it belonged to before.
	 * Since 2.4
	 * Params:
	 * group =  an existing radio button group
	 */
	public void setGroup(ListSG group);
}
