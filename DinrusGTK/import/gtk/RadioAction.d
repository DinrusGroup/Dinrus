module gtkD.gtk.RadioAction;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ListSG;



private import gtkD.gtk.ToggleAction;

/**
 * Description
 * A GtkRadioAction is similar to GtkRadioMenuItem. A number of radio
 * actions can be linked together so that only one may be active at any
 * one time.
 */
public class RadioAction : ToggleAction
{
	
	/** the main Gtk struct */
	protected GtkRadioAction* gtkRadioAction;
	
	
	public GtkRadioAction* getRadioActionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRadioAction* gtkRadioAction);
	
	/**
	 * Creates a new GtkRadioAction object. To add the action to
	 * a GtkActionGroup and set the accelerator for the action,
	 * call gtk_action_group_add_action_with_accel().
	 * Since 2.4
	 * Params:
	 * name =  A unique name for the action
	 * label =  The label displayed in menu items and on buttons, or NULL
	 * tooltip =  A tooltip for this action, or NULL
	 * stockId =  The stock icon to display in widgets representing this
	 *  action, or NULL
	 * value =  The value which gtk_radio_action_get_current_value() should
	 *  return if this action is selected.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string label, string tooltip, StockID stockId, int value);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(GtkRadioAction*, RadioAction)[] onChangedListeners;
	/**
	 * The ::changed signal is emitted on every member of a radio group when the
	 * active member is changed. The signal gets emitted after the ::activate signals
	 * for the previous and current active members.
	 * Since 2.4
	 */
	void addOnChanged(void delegate(GtkRadioAction*, RadioAction) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChanged(GtkRadioAction* actionStruct, GtkRadioAction* current, RadioAction radioAction);
	
	
	/**
	 * Creates a new GtkRadioAction object. To add the action to
	 * a GtkActionGroup and set the accelerator for the action,
	 * call gtk_action_group_add_action_with_accel().
	 * Since 2.4
	 * Params:
	 * name =  A unique name for the action
	 * label =  The label displayed in menu items and on buttons, or NULL
	 * tooltip =  A tooltip for this action, or NULL
	 * stockId =  The stock icon to display in widgets representing this
	 *  action, or NULL
	 * value =  The value which gtk_radio_action_get_current_value() should
	 *  return if this action is selected.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string label, string tooltip, string stockId, int value);
	
	/**
	 * Returns the list representing the radio group for this object.
	 * Note that the returned list is only valid until the next change
	 * to the group.
	 * Since 2.4
	 * Returns: the list representing the radio group for this object
	 */
	public ListSG getGroup();
	
	/**
	 * Sets the radio group for the radio action object.
	 * Since 2.4
	 * Params:
	 * group =  a list representing a radio group
	 */
	public void setGroup(ListSG group);
	
	/**
	 * Obtains the value property of the currently active member of
	 * the group to which action belongs.
	 * Since 2.4
	 * Returns: The value of the currently active group member
	 */
	public int getCurrentValue();
	
	/**
	 * Sets the currently active group member to the member with value
	 * property current_value.
	 * Since 2.10
	 * Params:
	 * currentValue =  the new value
	 */
	public void setCurrentValue(int currentValue);
}
