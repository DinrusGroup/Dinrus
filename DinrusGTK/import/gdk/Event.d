module gtkD.gdk.Event;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Window;
private import gtkD.gdk.Display;
private import gtkD.gdk.Screen;
private import gtkD.gobject.Value;




/**
 * Description
 * This section describes functions dealing with events from the window system.
 * In GTK+ applications the events are handled automatically in
 * gtk_main_do_event() and passed on to the appropriate widgets, so these
 * functions are rarely needed. Though some of the fields in the
 * Event Structures are useful.
 */
public class Event
{
	
	/** the main Gtk struct */
	protected GdkEvent* gdkEvent;
	
	
	public GdkEvent* getEventStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkEvent* gdkEvent);
	
	/** */
	public static bool isDoubleClick(GdkEventButton* eventButton, int buttonNumber=1);
	
	/** */
	public static bool isTripleClick(GdkEventButton* eventButton, int buttonNumber=1);
	
	/**
	 */
	
	/**
	 * Checks if any events are ready to be processed for any display.
	 * Returns: TRUE if any events are pending.
	 */
	public static int gdkEventsPending();
	
	/**
	 * If there is an event waiting in the event queue of some open
	 * display, returns a copy of it. See gdk_display_peek_event().
	 * Returns: a copy of the first GdkEvent on some event queue, or NULL if noevents are in any queues. The returned GdkEvent should be freed withgdk_event_free().
	 */
	public static Event peek();
	
	/**
	 * Checks all open displays for a GdkEvent to process,to be processed
	 * on, fetching events from the windowing system if necessary.
	 * See gdk_display_get_event().
	 * Returns: the next GdkEvent to be processed, or NULL if no eventsare pending. The returned GdkEvent should be freed with gdk_event_free().
	 */
	public static Event get();
	
	/**
	 * Warning
	 * gdk_event_get_graphics_expose is deprecated and should not be used in newly-written code. 2.18
	 * Waits for a GraphicsExpose or NoExpose event from the X server.
	 * This is used in the GtkText and GtkCList widgets in GTK+ to make sure any
	 * GraphicsExpose events are handled before the widget is scrolled.
	 * Params:
	 * window =  the GdkWindow to wait for the events for.
	 * Returns: a GdkEventExpose if a GraphicsExpose was received, or NULL if aNoExpose event was received.
	 */
	public static Event getGraphicsExpose(Window window);
	
	/**
	 * Appends a copy of the given event onto the front of the event
	 * queue for event->any.window's display, or the default event
	 * queue if event->any.window is NULL. See gdk_display_put_event().
	 */
	public void put();
	
	/**
	 * Creates a new event of the given type. All fields are set to 0.
	 * Since 2.2
	 * Params:
	 * type =  a GdkEventType
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdkEventType type);
	
	/**
	 * Copies a GdkEvent, copying or incrementing the reference count of the
	 * resources associated with it (e.g. GdkWindow's and strings).
	 * Returns: a copy of event. The returned GdkEvent should be freed withgdk_event_free().
	 */
	public Event copy();
	
	/**
	 * Frees a GdkEvent, freeing or decrementing any resources associated with it.
	 * Note that this function should only be called with events returned from
	 * functions such as gdk_event_peek(), gdk_event_get(),
	 * gdk_event_get_graphics_expose() and gdk_event_copy().
	 */
	public void free();
	
	/**
	 * Returns the time stamp from event, if there is one; otherwise
	 * returns GDK_CURRENT_TIME. If event is NULL, returns GDK_CURRENT_TIME.
	 * Returns: time stamp field from event
	 */
	public uint getTime();
	
	/**
	 * If the event contains a "state" field, puts that field in state. Otherwise
	 * stores an empty state (0). Returns TRUE if there was a state field
	 * in the event. event may be NULL, in which case it's treated
	 * as if the event had no state field.
	 * Params:
	 * state =  return location for state
	 * Returns: TRUE if there was a state field in the event
	 */
	public int getState(out GdkModifierType state);
	
	/**
	 * Extract the axis value for a particular axis use from
	 * an event structure.
	 * Params:
	 * axisUse =  the axis use to look for
	 * value =  location to store the value found
	 * Returns: TRUE if the specified axis was found, otherwise FALSE
	 */
	public int getAxis(GdkAxisUse axisUse, out double value);
	
	/**
	 * Extract the event window relative x/y coordinates from an event.
	 * Params:
	 * xWin =  location to put event window x coordinate
	 * yWin =  location to put event window y coordinate
	 * Returns: TRUE if the event delivered event window coordinates
	 */
	public int getCoords(out double xWin, out double yWin);
	
	/**
	 * Extract the root window relative x/y coordinates from an event.
	 * Params:
	 * xRoot =  location to put root window x coordinate
	 * yRoot =  location to put root window y coordinate
	 * Returns: TRUE if the event delivered root window coordinates
	 */
	public int getRootCoords(out double xRoot, out double yRoot);
	
	/**
	 * Request more motion notifies if event is a motion notify hint event.
	 * This function should be used instead of gdk_window_get_pointer() to
	 * request further motion notifies, because it also works for extension
	 * events where motion notifies are provided for devices other than the
	 * core pointer. Coordinate extraction, processing and requesting more
	 * Since 2.12
	 * Params:
	 * event =  a valid GdkEvent
	 */
	public static void requestMotions(GdkEventMotion* event);
	
	/**
	 * Sets the function to call to handle all events from GDK.
	 * Note that GTK+ uses this to install its own event handler, so it is
	 * usually not useful for GTK+ applications. (Although an application
	 * can call this function then call gtk_main_do_event() to pass
	 * events to GTK+.)
	 * Params:
	 * func =  the function to call to handle events from GDK.
	 * data =  user data to pass to the function.
	 * notify =  the function to call when the handler function is removed, i.e. when
	 *  gdk_event_handler_set() is called with another event handler.
	 */
	public static void handlerSet(GdkEventFunc func, void* data, GDestroyNotify notify);
	
	/**
	 * Sends an X ClientMessage event to a given window (which must be
	 * on the default GdkDisplay.)
	 * This could be used for communicating between different applications,
	 * though the amount of data is limited to 20 bytes.
	 * Params:
	 * winid =  the window to send the X ClientMessage event to.
	 * Returns: non-zero on success.
	 */
	public int sendClientMessage(GdkNativeWindow winid);
	
	/**
	 * On X11, sends an X ClientMessage event to a given window. On
	 * Windows, sends a message registered with the name
	 * GDK_WIN32_CLIENT_MESSAGE.
	 * This could be used for communicating between different
	 * applications, though the amount of data is limited to 20 bytes on
	 * X11, and to just four bytes on Windows.
	 * Since 2.2
	 * Params:
	 * display =  the GdkDisplay for the window where the message is to be sent.
	 * event =  the GdkEvent to send, which should be a GdkEventClient.
	 * winid =  the window to send the client message to.
	 * Returns: non-zero on success.
	 */
	public static int sendClientMessageForDisplay(Display display, Event event, GdkNativeWindow winid);
	
	/**
	 * Sends an X ClientMessage event to all toplevel windows on the default
	 * GdkScreen.
	 * Toplevel windows are determined by checking for the WM_STATE property, as
	 * described in the Inter-Client Communication Conventions Manual (ICCCM).
	 * If no windows are found with the WM_STATE property set, the message is sent
	 * to all children of the root window.
	 */
	public void sendClientmessageToall();
	
	/**
	 * Adds a filter to the default display to be called when X ClientMessage events
	 * are received. See gdk_display_add_client_message_filter().
	 * Params:
	 * messageType =  the type of ClientMessage events to receive. This will be
	 *  checked against the message_type field of the
	 *  XClientMessage event struct.
	 * func =  the function to call to process the event.
	 * data =  user data to pass to func.
	 */
	public static void gdkAddClientMessageFilter(GdkAtom messageType, GdkFilterFunc func, void* data);
	
	/**
	 * Gets whether event debugging output is enabled.
	 * Returns: TRUE if event debugging output is enabled.
	 */
	public static int gdkGetShowEvents();
	
	/**
	 * Sets whether a trace of received events is output.
	 * Note that GTK+ must be compiled with debugging (that is,
	 * configured using the --enable-debug option)
	 * to use this option.
	 * Params:
	 * showEvents =  TRUE to output event debugging information.
	 */
	public static void gdkSetShowEvents(int showEvents);
	
	/**
	 * Sets the screen for event to screen. The event must
	 * have been allocated by GTK+, for instance, by
	 * gdk_event_copy().
	 * Since 2.2
	 * Params:
	 * screen =  a GdkScreen
	 */
	public void setScreen(Screen screen);
	
	/**
	 * Returns the screen for the event. The screen is
	 * typically the screen for event->any.window, but
	 * for events such as mouse events, it is the screen
	 * where the pointer was when the event occurs -
	 * that is, the screen which has the root window
	 * to which event->motion.x_root and
	 * event->motion.y_root are relative.
	 * Since 2.2
	 * Returns: the screen for the event
	 */
	public Screen getScreen();
	
	/**
	 * Obtains a desktop-wide setting, such as the double-click time,
	 * for the default screen. See gdk_screen_get_setting().
	 * Params:
	 * name =  the name of the setting.
	 * value =  location to store the value of the setting.
	 * Returns: TRUE if the setting existed and a value was stored in value, FALSE otherwise.
	 */
	public static int gdkSettingGet(string name, Value value);
}
