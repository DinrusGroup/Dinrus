module gtkD.gtk.ToggleAction;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;



private import gtkD.gtk.Action;

/**
 * Description
 * A GtkToggleAction corresponds roughly to a GtkCheckMenuItem. It has an
 * "active" state specifying whether the action has been checked or not.
 */
public class ToggleAction : Action
{
	
	/** the main Gtk struct */
	protected GtkToggleAction* gtkToggleAction;
	
	
	public GtkToggleAction* getToggleActionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkToggleAction* gtkToggleAction);
	
	/**
	 * Creates a new GtkToggleAction object. To add the action to
	 * a GtkActionGroup and set the accelerator for the action,
	 * call gtk_action_group_add_action_with_accel().
	 * Since 2.4
	 * Params:
	 * name =  A unique name for the action
	 * label =  The label displayed in menu items and on buttons, or NULL
	 * tooltip =  A tooltip for the action, or NULL
	 * stockId =  The stock icon to display in widgets representing the
	 *  action, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string label, string tooltip, StockID stockId);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ToggleAction)[] onToggledListeners;
	/**
	 */
	void addOnToggled(void delegate(ToggleAction) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggled(GtkToggleAction* toggleactionStruct, ToggleAction toggleAction);
	
	
	/**
	 * Creates a new GtkToggleAction object. To add the action to
	 * a GtkActionGroup and set the accelerator for the action,
	 * call gtk_action_group_add_action_with_accel().
	 * Since 2.4
	 * Params:
	 * name =  A unique name for the action
	 * label =  The label displayed in menu items and on buttons, or NULL
	 * tooltip =  A tooltip for the action, or NULL
	 * stockId =  The stock icon to display in widgets representing the
	 *  action, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string label, string tooltip, string stockId);
	
	/**
	 * Emits the "toggled" signal on the toggle action.
	 * Since 2.4
	 */
	public void toggled();
	
	/**
	 * Sets the checked state on the toggle action.
	 * Since 2.4
	 * Params:
	 * isActive =  whether the action should be checked or not
	 */
	public void setActive(int isActive);
	
	/**
	 * Returns the checked state of the toggle action.
	 * Since 2.4
	 * Returns: the checked state of the toggle action
	 */
	public int getActive();
	
	/**
	 * Sets whether the action should have proxies like a radio action.
	 * Since 2.4
	 * Params:
	 * drawAsRadio =  whether the action should have proxies like a radio
	 *  action
	 */
	public void setDrawAsRadio(int drawAsRadio);
	
	/**
	 * Returns whether the action should have proxies like a radio action.
	 * Since 2.4
	 * Returns: whether the action should have proxies like a radio action.
	 */
	public int getDrawAsRadio();
}
