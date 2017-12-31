module gtkD.gdk.Display;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gdk.Screen;
private import gtkD.glib.ListG;
private import gtkD.gdk.Event;
private import gtkD.gdk.Window;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GdkDisplay objects purpose are two fold:
 * To grab/ungrab keyboard focus and mouse pointer
 * To manage and provide information about the GdkScreen(s)
 * 		available for this GdkDisplay
 *  GdkDisplay objects are the GDK representation of the X Display which can be
 *  described as a workstation consisting of a keyboard a pointing
 *  device (such as a mouse) and one or more screens.
 *  It is used to open and keep track of various GdkScreen objects currently
 *  instanciated by the application. It is also used to grab and release the keyboard
 *  and the mouse pointer.
 */
public class Display : ObjectG
{
	
	/** the main Gtk struct */
	protected GdkDisplay* gdkDisplay;
	
	
	public GdkDisplay* getDisplayStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkDisplay* gdkDisplay);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(gboolean, Display)[] onClosedListeners;
	/**
	 * The ::closed signal is emitted when the connection to the windowing
	 * system for display is closed.
	 * Since 2.2
	 */
	void addOnClosed(void delegate(gboolean, Display) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackClosed(GdkDisplay* displayStruct, gboolean isError, Display display);
	
	
	/**
	 * Opens a display.
	 * Since 2.2
	 * Params:
	 * displayName =  the name of the display to open
	 * Returns: a GdkDisplay, or NULL if the display could not be opened.
	 */
	public static Display open(string displayName);
	
	/**
	 * Gets the default GdkDisplay. This is a convenience
	 * function for
	 * gdk_display_manager_get_default_display (gdk_display_manager_get()).
	 * Since 2.2
	 * Returns: a GdkDisplay, or NULL if there is no default display.
	 */
	public static Display getDefault();
	
	/**
	 * Gets the name of the display.
	 * Since 2.2
	 * Returns: a string representing the display name. This string is ownedby GDK and should not be modified or freed.
	 */
	public string getName();
	
	/**
	 * Gets the number of screen managed by the display.
	 * Since 2.2
	 * Returns: number of screens.
	 */
	public int getNScreens();
	
	/**
	 * Returns a screen object for one of the screens of the display.
	 * Since 2.2
	 * Params:
	 * screenNum =  the screen number
	 * Returns: the GdkScreen object
	 */
	public Screen getScreen(int screenNum);
	
	/**
	 * Get the default GdkScreen for display.
	 * Since 2.2
	 * Returns: the default GdkScreen object for display
	 */
	public Screen getDefaultScreen();
	
	/**
	 * Release any pointer grab.
	 * Since 2.2
	 * Params:
	 * time =  a timestap (e.g. GDK_CURRENT_TIME).
	 */
	public void pointerUngrab(uint time);
	
	/**
	 * Release any keyboard grab
	 * Since 2.2
	 * Params:
	 * time =  a timestap (e.g GDK_CURRENT_TIME).
	 */
	public void keyboardUngrab(uint time);
	
	/**
	 * Test if the pointer is grabbed.
	 * Since 2.2
	 * Returns: TRUE if an active X pointer grab is in effect
	 */
	public int pointerIsGrabbed();
	
	/**
	 * Emits a short beep on display
	 * Since 2.2
	 */
	public void beep();
	
	/**
	 * Flushes any requests queued for the windowing system and waits until all
	 * requests have been handled. This is often used for making sure that the
	 * display is synchronized with the current state of the program. Calling
	 * gdk_display_sync() before gdk_error_trap_pop() makes sure that any errors
	 * generated from earlier requests are handled before the error trap is
	 * removed.
	 * This is most useful for X11. On windowing systems where requests are
	 * handled synchronously, this function will do nothing.
	 * Since 2.2
	 */
	public void sync();
	
	/**
	 * Flushes any requests queued for the windowing system; this happens automatically
	 * when the main loop blocks waiting for new events, but if your application
	 * is drawing without returning control to the main loop, you may need
	 * to call this function explicitely. A common case where this function
	 * needs to be called is when an application is executing drawing commands
	 * from a thread other than the thread where the main loop is running.
	 * This is most useful for X11. On windowing systems where requests are
	 * handled synchronously, this function will do nothing.
	 * Since 2.4
	 */
	public void flush();
	
	/**
	 * Closes the connection to the windowing system for the given display,
	 * and cleans up associated resources.
	 * Since 2.2
	 */
	public void close();
	
	/**
	 * Returns the list of available input devices attached to display.
	 * The list is statically allocated and should not be freed.
	 * Since 2.2
	 * Returns: a list of GdkDevice
	 */
	public ListG listDevices();
	
	/**
	 * Gets the next GdkEvent to be processed for display, fetching events from the
	 * windowing system if necessary.
	 * Since 2.2
	 * Returns: the next GdkEvent to be processed, or NULL if no eventsare pending. The returned GdkEvent should be freed with gdk_event_free().
	 */
	public Event getEvent();
	
	/**
	 * Gets a copy of the first GdkEvent in the display's event queue, without
	 * removing the event from the queue. (Note that this function will
	 * not get more events from the windowing system. It only checks the events
	 * that have already been moved to the GDK event queue.)
	 * Since 2.2
	 * Returns: a copy of the first GdkEvent on the event queue, or NULL if no events are in the queue. The returned GdkEvent should be freed withgdk_event_free().
	 */
	public Event peekEvent();
	
	/**
	 * Appends a copy of the given event onto the front of the event
	 * queue for display.
	 * Since 2.2
	 * Params:
	 * event =  a GdkEvent.
	 */
	public void putEvent(Event event);
	
	/**
	 * Adds a filter to be called when X ClientMessage events are received.
	 * See gdk_window_add_filter() if you are interested in filtering other
	 * types of events.
	 * Since 2.2
	 * Params:
	 * messageType =  the type of ClientMessage events to receive.
	 *  This will be checked against the message_type field
	 *  of the XClientMessage event struct.
	 * func =  the function to call to process the event.
	 * data =  user data to pass to func.
	 */
	public void addClientMessageFilter(GdkAtom messageType, GdkFilterFunc func, void* data);
	
	/**
	 * Sets the double click time (two clicks within this time interval
	 * count as a double click and result in a GDK_2BUTTON_PRESS event).
	 * Applications should not set this, it is a global
	 * user-configured setting.
	 * Since 2.2
	 * Params:
	 * msec =  double click time in milliseconds (thousandths of a second)
	 */
	public void setDoubleClickTime(uint msec);
	
	/**
	 * Sets the double click distance (two clicks within this distance
	 * count as a double click and result in a GDK_2BUTTON_PRESS event).
	 * See also gdk_display_set_double_click_time().
	 * Applications should not set this, it is a global
	 * user-configured setting.
	 * Since 2.4
	 * Params:
	 * distance =  distance in pixels
	 */
	public void setDoubleClickDistance(uint distance);
	
	/**
	 * Gets the current location of the pointer and the current modifier
	 * mask for a given display.
	 * Since 2.2
	 * Params:
	 * screen =  location to store the screen that the
	 *  cursor is on, or NULL.
	 * x =  location to store root window X coordinate of pointer, or NULL.
	 * y =  location to store root window Y coordinate of pointer, or NULL.
	 * mask =  location to store current modifier mask, or NULL
	 */
	public void getPointer(out Screen screen, out int x, out int y, out GdkModifierType mask);
	
	/**
	 * Obtains the window underneath the mouse pointer, returning the location
	 * of the pointer in that window in win_x, win_y for screen. Returns NULL
	 * if the window under the mouse pointer is not known to GDK (for example,
	 * belongs to another application).
	 * Since 2.2
	 * Params:
	 * winX =  return location for x coordinate of the pointer location relative
	 *  to the window origin, or NULL
	 * winY =  return location for y coordinate of the pointer location relative
	 *   to the window origin, or NULL
	 * Returns: the window under the mouse pointer, or NULL
	 */
	public Window getWindowAtPointer(out int winX, out int winY);
	
	/**
	 * This function allows for hooking into the operation
	 * of getting the current location of the pointer on a particular
	 * display. This is only useful for such low-level tools as an
	 * event recorder. Applications should never have any
	 * reason to use this facility.
	 * Since 2.2
	 * Params:
	 * newHooks =  a table of pointers to functions for getting
	 *  quantities related to the current pointer position,
	 *  or NULL to restore the default table.
	 * Returns: the previous pointer hook table
	 */
	public GdkDisplayPointerHooks* setPointerHooks(GdkDisplayPointerHooks* newHooks);
	
	/**
	 * Warps the pointer of display to the point x,y on
	 * the screen screen, unless the pointer is confined
	 * to a window by a grab, in which case it will be moved
	 * as far as allowed by the grab. Warping the pointer
	 * creates events as if the user had moved the mouse
	 * instantaneously to the destination.
	 * Note that the pointer should normally be under the
	 * control of the user. This function was added to cover
	 * some rare use cases like keyboard navigation support
	 * for the color picker in the GtkColorSelectionDialog.
	 * Since 2.8
	 * Params:
	 * screen =  the screen of display to warp the pointer to
	 * x =  the x coordinate of the destination
	 * y =  the y coordinate of the destination
	 */
	public void warpPointer(Screen screen, int x, int y);
	
	/**
	 * Returns TRUE if multicolored cursors are supported
	 * on display. Otherwise, cursors have only a forground
	 * and a background color.
	 * Since 2.4
	 * Returns: whether cursors can have multiple colors.
	 */
	public int supportsCursorColor();
	
	/**
	 * Returns TRUE if cursors can use an 8bit alpha channel
	 * on display. Otherwise, cursors are restricted to bilevel
	 * alpha (i.e. a mask).
	 * Since 2.4
	 * Returns: whether cursors can have alpha channels.
	 */
	public int supportsCursorAlpha();
	
	/**
	 * Returns the default size to use for cursors on display.
	 * Since 2.4
	 * Returns: the default cursor size.
	 */
	public uint getDefaultCursorSize();
	
	/**
	 * Gets the maximal size to use for cursors on display.
	 * Since 2.4
	 * Params:
	 * width =  the return location for the maximal cursor width
	 * height =  the return location for the maximal cursor height
	 */
	public void getMaximalCursorSize(out uint width, out uint height);
	
	/**
	 * Returns the default group leader window for all toplevel windows
	 * on display. This window is implicitly created by GDK.
	 * See gdk_window_set_group().
	 * Since 2.4
	 * Returns: The default group leader window for display
	 */
	public Window getDefaultGroup();
	
	/**
	 * Returns whether GdkEventOwnerChange events will be
	 * sent when the owner of a selection changes.
	 * Since 2.6
	 * Returns: whether GdkEventOwnerChange events will  be sent.
	 */
	public int supportsSelectionNotification();
	
	/**
	 * Request GdkEventOwnerChange events for ownership changes
	 * of the selection named by the given atom.
	 * Since 2.6
	 * Params:
	 * selection =  the GdkAtom naming the selection for which
	 *  ownership change notification is requested
	 * Returns: whether GdkEventOwnerChange events will  be sent.
	 */
	public int requestSelectionNotification(GdkAtom selection);
	
	/**
	 * Returns whether the speicifed display supports clipboard
	 * persistance; i.e. if it's possible to store the clipboard data after an
	 * application has quit. On X11 this checks if a clipboard daemon is
	 * running.
	 * Since 2.6
	 * Returns: TRUE if the display supports clipboard persistance.
	 */
	public int supportsClipboardPersistence();
	
	/**
	 * Issues a request to the clipboard manager to store the
	 * clipboard data. On X11, this is a special program that works
	 * according to the freedesktop clipboard specification, available at
	 * http://www.freedesktop.org/Standards/clipboard-manager-spec.
	 * Since 2.6
	 * Params:
	 * clipboardWindow =  a GdkWindow belonging to the clipboard owner
	 * time =  a timestamp
	 * targets = 	 an array of targets that should be saved, or NULL
	 *  if all available targets should be saved.
	 */
	public void storeClipboard(Window clipboardWindow, uint time, GdkAtom[] targets);
	
	/**
	 * Returns TRUE if gdk_window_shape_combine_mask() can
	 * be used to create shaped windows on display.
	 * Since 2.10
	 * Returns: TRUE if shaped windows are supported
	 */
	public int supportsShapes();
	
	/**
	 * Returns TRUE if gdk_window_input_shape_combine_mask() can
	 * be used to modify the input shape of windows on display.
	 * Since 2.10
	 * Returns: TRUE if windows with modified input shape are supported
	 */
	public int supportsInputShapes();
	
	/**
	 * Returns TRUE if gdk_window_set_composited() can be used
	 * to redirect drawing on the window using compositing.
	 * Currently this only works on X11 with XComposite and
	 * XDamage extensions available.
	 * Since 2.12
	 * Signal Details
	 * The "closed" signal
	 * void user_function (GdkDisplay *display,
	 *  gboolean is_error,
	 *  gpointer user_data) : Run Last
	 * The ::closed signal is emitted when the connection to the windowing
	 * system for display is closed.
	 * Since 2.2
	 * Returns: TRUE if windows may be composited.
	 */
	public int supportsComposite();
}
