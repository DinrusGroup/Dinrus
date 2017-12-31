
module gtkD.atk.Action;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * AtkAction should be implemented by instances of AtkObject classes with
 * which the user can interact directly, i.e. buttons, checkboxes,
 * scrollbars, e.g. components which are not "passive"
 * providers of UI information.
 * Exceptions: when the user interaction is already covered by
 * another appropriate interface such as AtkEditableText (insert/delete
 * test, etc.) or AtkValue (set value) then these actions should not be
 * exposed by AtkAction as well.
 * Also note that the AtkAction API is limited in that parameters may not
 * be passed to the object being activated; thus the action must be
 * self-contained and specifiable via only a single "verb". Concrete
 * examples include "press", "release", "click" for buttons, "drag"
 * (meaning initiate drag) and "drop" for drag sources and drop targets,
 * etc.
 * Though most UI interactions on components should be invocable via
 * keyboard as well as mouse, there will generally be a close mapping
 * between "mouse actions" that are possible on a component and the
 * AtkActions. Where mouse and keyboard actions are redundant in effect,
 * AtkAction should expose only one action rather than exposing redundant
 * actions if possible. By convention we have been using "mouse centric"
 * terminology for AtkAction names.
 */
public class Action
{
	
	/** the main Gtk struct */
	protected AtkAction* atkAction;
	
	
	public AtkAction* getActionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkAction* atkAction);
	
	/**
	 */
	
	/**
	 * Perform the specified action on the object.
	 * Params:
	 * i =  the action index corresponding to the action to be performed
	 * Returns: TRUE if success, FALSE otherwise
	 */
	public int doAction(int i);
	
	/**
	 * Gets the number of accessible actions available on the object.
	 * If there are more than one, the first one is considered the
	 * "default" action of the object.
	 * Returns: a the number of actions, or 0 if action does notimplement this interface.
	 */
	public int getNActions();
	
	/**
	 * Returns a description of the specified action of the object.
	 * Params:
	 * i =  the action index corresponding to the action to be performed
	 * Returns:a description string, or NULLif action does not implement this interface.
	 */
	public string getDescription(int i);
	
	/**
	 * Returns a non-localized string naming the specified action of the
	 * object. This name is generally not descriptive of the end result
	 * of the action, but instead names the 'interaction type' which the
	 * object supports. By convention, the above strings should be used to
	 * represent the actions which correspond to the common point-and-click
	 * interaction techniques of the same name: i.e.
	 * "click", "press", "release", "drag", "drop", "popup", etc.
	 * The "popup" action should be used to pop up a context menu for the
	 * object, if one exists.
	 * For technical reasons, some toolkits cannot guarantee that the
	 * reported action is actually 'bound' to a nontrivial user event;
	 * i.e. the result of some actions via atk_action_do_action() may be
	 * NIL.
	 * Params:
	 * i =  the action index corresponding to the action to be performed
	 * Returns:a name string, or NULLif action does not implement this interface.
	 */
	public string getName(int i);
	
	/**
	 * Returns the localized name of the specified action of the object.
	 * Params:
	 * i =  the action index corresponding to the action to be performed
	 * Returns:a name string, or NULLif action does not implement this interface.
	 */
	public string getLocalizedName(int i);
	
	/**
	 * Returns a keybinding associated with this action, if one exists.
	 * The returned string is in the format "<a>;<b>;<c>"
	 * (i.e. semicolon-delimited), where <a> is the keybinding which
	 * activates the object if it is presently enabled onscreen,
	 * <b> corresponds to the keybinding or sequence of keys
	 * which invokes the action even if the relevant element is not
	 * currently posted on screen (for instance, for a menu item it
	 * posts the parent menus before invoking). The last token in the
	 * above string, if non-empty, represents a keyboard shortcut which
	 * invokes the same action without posting the component or its
	 * enclosing menus or dialogs.
	 * Params:
	 * i =  the action index corresponding to the action to be performed
	 * Returns:a string representing the available keybindings, or NULLif there is no keybinding for this action.
	 */
	public string getKeybinding(int i);
	
	/**
	 * Sets a description of the specified action of the object.
	 * Params:
	 * i =  the action index corresponding to the action to be performed
	 * desc =  the description to be assigned to this action
	 * Returns: a gboolean representing if the description was successfully set;
	 */
	public int setDescription(int i, string desc);
}
