module gtkD.atk.Util;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.atk.ObjectAtk;
private import gtkD.glib.Str;




/**
 * Description
 * A set of ATK utility functions which are used to support event registration of
 * various types, and obtaining the 'root' accessible of a process and
 * information about the current ATK implementation and toolkit version.
 */
public class Util
{
	
	/**
	 */
	
	/**
	 * Adds the specified function to the list of functions to be called
	 * when an object receives focus.
	 * Params:
	 * focusTracker =  Function to be added to the list of functions to be called
	 * when an object receives focus.
	 * Returns: added focus tracker id, or 0 on failure.
	 */
	public static uint addFocusTracker(AtkEventListener focusTracker);
	
	/**
	 * Removes the specified focus tracker from the list of functions
	 * to be called when any object receives focus.
	 * Params:
	 * trackerId =  the id of the focus tracker to remove
	 */
	public static void removeFocusTracker(uint trackerId);
	
	/**
	 * Specifies the function to be called for focus tracker initialization.
	 * This function should be called by an implementation of the
	 * ATK interface if any specific work needs to be done to enable
	 * focus tracking.
	 * Params:
	 * init =  Function to be called for focus tracker initialization
	 */
	public static void focusTrackerInit(AtkEventListenerInit init);
	
	/**
	 * Cause the focus tracker functions which have been specified to be
	 * executed for the object.
	 * Params:
	 * object =  an AtkObject
	 */
	public static void focusTrackerNotify(ObjectAtk object);
	
	/**
	 * Adds the specified function to the list of functions to be called
	 * when an event of type event_type occurs.
	 * Params:
	 * listener =  the listener to notify
	 * eventType =  the type of event for which notification is requested
	 * Returns: added event listener id, or 0 on failure.
	 */
	public static uint addGlobalEventListener(GSignalEmissionHook listener, string eventType);
	
	/**
	 * Removes the specified event listener
	 * Params:
	 * listenerId =  the id of the event listener to remove
	 */
	public static void removeGlobalEventListener(uint listenerId);
	
	/**
	 * Adds the specified function to the list of functions to be called
	 *  when a key event occurs. The data element will be passed to the
	 *  AtkKeySnoopFunc (listener) as the func_data param, on notification.
	 * Params:
	 * listener =  the listener to notify
	 * data =  a gpointer that points to a block of data that should be sent to the registered listeners,
	 *  along with the event notification, when it occurs.
	 * Returns: added event listener id, or 0 on failure.
	 */
	public static uint addKeyEventListener(AtkKeySnoopFunc listener, void* data);
	
	/**
	 * Removes the specified event listener
	 * Params:
	 * listenerId =  the id of the event listener to remove
	 */
	public static void removeKeyEventListener(uint listenerId);
	
	/**
	 * Gets the root accessible container for the current application.
	 * Returns: the root accessible container for the current application
	 */
	public static ObjectAtk getRoot();
	
	/**
	 * Gets the currently focused object.
	 * Since 1.6
	 * Returns: the currently focused object for the current application
	 */
	public static ObjectAtk getFocusObject();
	
	/**
	 * Gets name string for the GUI toolkit implementing ATK for this application.
	 * Returns: name string for the GUI toolkit implementing ATK for this application
	 */
	public static string getToolkitName();
	
	/**
	 * Gets version string for the GUI toolkit implementing ATK for this application.
	 * Returns: version string for the GUI toolkit implementing ATK for this application
	 */
	public static string getToolkitVersion();
}
