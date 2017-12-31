
module gtkD.gdk.Screen;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.cairo.FontOption;
private import gtkD.gdk.Screen;
private import gtkD.gdk.Colormap;
private import gtkD.gdk.Visual;
private import gtkD.gdk.Window;
private import gtkD.gdk.Display;
private import gtkD.glib.ListG;
private import gtkD.gdk.Rectangle;
private import gtkD.gdk.Event;
private import gtkD.gobject.Value;



private import gtkD.gobject.ObjectG;

/**
 * Description
 *  GdkScreen objects are the GDK representation of a physical screen. It is used
 *  throughout GDK and GTK+ to specify which screen the top level windows
 *  are to be displayed on.
 *  It is also used to query the screen specification and default settings such as
 *  the default colormap (gdk_screen_get_default_colormap()),
 *  the screen width (gdk_screen_get_width()), etc.
 * Note that a screen may consist of multiple monitors which are merged to
 * form a large screen area.
 */
public class Screen : ObjectG
{
	
	/** the main Gtk struct */
	protected GdkScreen* gdkScreen;
	
	
	public GdkScreen* getScreenStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkScreen* gdkScreen);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Screen)[] onCompositedChangedListeners;
	/**
	 * The ::composited-changed signal is emitted when the composited
	 * status of the screen changes
	 * Since 2.10
	 */
	void addOnCompositedChanged(void delegate(Screen) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCompositedChanged(GdkScreen* screenStruct, Screen screen);
	
	void delegate(Screen)[] onMonitorsChangedListeners;
	/**
	 * The ::monitors-changed signal is emitted when the number, size
	 * or position of the monitors attached to the screen change.
	 * Only for X for now. Future implementations for Win32 and
	 * OS X may be a possibility.
	 * Since 2.14
	 */
	void addOnMonitorsChanged(void delegate(Screen) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMonitorsChanged(GdkScreen* screenStruct, Screen screen);
	
	void delegate(Screen)[] onSizeChangedListeners;
	/**
	 * The ::size-changed signal is emitted when the pixel width or
	 * height of a screen changes.
	 * Since 2.2
	 */
	void addOnSizeChanged(void delegate(Screen) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSizeChanged(GdkScreen* screenStruct, Screen screen);
	
	
	/**
	 * Gets the default screen for the default display. (See
	 * gdk_display_get_default()).
	 * Since 2.2
	 * Returns: a GdkScreen, or NULL if there is no default display.
	 */
	public static Screen getDefault();
	
	/**
	 * Gets the default colormap for screen.
	 * Since 2.2
	 * Returns: the default GdkColormap.
	 */
	public Colormap getDefaultColormap();
	
	/**
	 * Sets the default colormap for screen.
	 * Since 2.2
	 * Params:
	 * colormap =  a GdkColormap
	 */
	public void setDefaultColormap(Colormap colormap);
	
	/**
	 * Gets the system's default colormap for screen
	 * Since 2.2
	 * Returns: the default colormap for screen.
	 */
	public Colormap getSystemColormap();
	
	/**
	 * Get the system's default visual for screen.
	 * This is the visual for the root window of the display.
	 * The return value should not be freed.
	 * Since 2.2
	 * Returns: the system visual
	 */
	public Visual getSystemVisual();
	
	/**
	 * Gets the preferred colormap for rendering image data on screen.
	 * Not a very useful function; historically, GDK could only render RGB
	 * image data to one colormap and visual, but in the current version
	 * it can render to any colormap and visual. So there's no need to
	 * call this function.
	 * Since 2.2
	 * Returns: the preferred colormap
	 */
	public Colormap getRgbColormap();
	
	/**
	 * Gets a "preferred visual" chosen by GdkRGB for rendering image data
	 * on screen. In previous versions of
	 * GDK, this was the only visual GdkRGB could use for rendering. In
	 * current versions, it's simply the visual GdkRGB would have chosen as
	 * the optimal one in those previous versions. GdkRGB can now render to
	 * drawables with any visual.
	 * Since 2.2
	 * Returns: The GdkVisual chosen by GdkRGB.
	 */
	public Visual getRgbVisual();
	
	/**
	 * Gets a colormap to use for creating windows or pixmaps with an
	 * alpha channel. The windowing system on which GTK+ is running
	 * may not support this capability, in which case NULL will
	 * be returned. Even if a non-NULL value is returned, its
	 * possible that the window's alpha channel won't be honored
	 * when displaying the window on the screen: in particular, for
	 * X an appropriate windowing manager and compositing manager
	 * must be running to provide appropriate display.
	 * This functionality is not implemented in the Windows backend.
	 * For setting an overall opacity for a top-level window, see
	 * gdk_window_set_opacity().
	 * Since 2.8
	 * Returns: a colormap to use for windows with an alpha channel or NULL if the capability is not available.
	 */
	public Colormap getRgbaColormap();
	
	/**
	 * Gets a visual to use for creating windows or pixmaps with an
	 * alpha channel. See the docs for gdk_screen_get_rgba_colormap()
	 * for caveats.
	 * Since 2.8
	 * Returns: a visual to use for windows with an alpha channel or NULL if the capability is not available.
	 */
	public Visual getRgbaVisual();
	
	/**
	 * Returns whether windows with an RGBA visual can reasonably
	 * be expected to have their alpha channel drawn correctly on
	 * the screen.
	 * On X11 this function returns whether a compositing manager is
	 * compositing screen.
	 * Since 2.10
	 * Returns: Whether windows with RGBA visuals can reasonably beexpected to have their alpha channels drawn correctly on the screen.
	 */
	public int isComposited();

	/**
	 * Gets the root window of screen.
	 * Since 2.2
	 * Returns: the root window
	 */
	public Window getRootWindow();
	
	/**
	 * Gets the display to which the screen belongs.
	 * Since 2.2
	 * Returns: the display to which screen belongs
	 */
	public Display getDisplay();
	/**
	 * Gets the index of screen among the screens in the display
	 * to which it belongs. (See gdk_screen_get_display())
	 * Since 2.2
	 * Returns: the index
	 */
	public int getNumber();
	
	/**
	 * Gets the width of screen in pixels
	 * Since 2.2
	 * Returns: the width of screen in pixels.
	 */
	public int getWidth();
	
	/**
	 * Gets the height of screen in pixels
	 * Since 2.2
	 * Returns: the height of screen in pixels.
	 */
	public int getHeight();
	
	/**
	 * Gets the width of screen in millimeters.
	 * Note that on some X servers this value will not be correct.
	 * Since 2.2
	 * Returns: the width of screen in millimeters.
	 */
	public int getWidthMm();
	
	/**
	 * Returns the height of screen in millimeters.
	 * Note that on some X servers this value will not be correct.
	 * Since 2.2
	 * Returns: the heigth of screen in millimeters.
	 */
	public int getHeightMm();
	
	/**
	 * Lists the available visuals for the specified screen.
	 * A visual describes a hardware image data format.
	 * For example, a visual might support 24-bit color, or 8-bit color,
	 * and might expect pixels to be in a certain format.
	 * Call g_list_free() on the return value when you're finished with it.
	 * Since 2.2
	 * Returns: a list of visuals; the list must be freed, but not its contents
	 */
	public ListG listVisuals();
	
	/**
	 * Obtains a list of all toplevel windows known to GDK on the screen screen.
	 * A toplevel window is a child of the root window (see
	 * gdk_get_default_root_window()).
	 * The returned list should be freed with g_list_free(), but
	 * its elements need not be freed.
	 * Since 2.2
	 * Returns: list of toplevel windows, free with g_list_free()
	 */
	public ListG getToplevelWindows();
	
	/**
	 * Determines the name to pass to gdk_display_open() to get
	 * a GdkDisplay with this screen as the default screen.
	 * Since 2.2
	 * Returns: a newly allocated string, free with g_free()
	 */
	public string makeDisplayName();
	
	/**
	 * Returns the number of monitors which screen consists of.
	 * Since 2.2
	 * Returns: number of monitors which screen consists of.
	 */
	public int getNMonitors();
	
	/**
	 * Retrieves the GdkRectangle representing the size and position of
	 * the individual monitor within the entire screen area.
	 * Note that the size of the entire screen area can be retrieved via
	 * gdk_screen_get_width() and gdk_screen_get_height().
	 * Since 2.2
	 * Params:
	 * monitorNum =  the monitor number.
	 * dest =  a GdkRectangle to be filled with the monitor geometry
	 */
	public void getMonitorGeometry(int monitorNum, Rectangle dest);
	
	/**
	 * Returns the monitor number in which the point (x,y) is located.
	 * Since 2.2
	 * Params:
	 * x =  the x coordinate in the virtual screen.
	 * y =  the y coordinate in the virtual screen.
	 * Returns: the monitor number in which the point (x,y) lies, or a monitor close to (x,y) if the point is not in any monitor.
	 */
	public int getMonitorAtPoint(int x, int y);
	
	/**
	 * Returns the number of the monitor in which the largest area of the
	 * bounding rectangle of window resides.
	 * Since 2.2
	 * Params:
	 * window =  a GdkWindow
	 * Returns: the monitor number in which most of window is located, or if window does not intersect any monitors, a monitor, close to window.
	 */
	public int getMonitorAtWindow(Window window);
	
	/**
	 * Gets the height in millimeters of the specified monitor.
	 * Since 2.14
	 * Params:
	 * monitorNum =  number of the monitor
	 * Returns: the height of the monitor, or -1 if not available
	 */
	public int getMonitorHeightMm(int monitorNum);
	
	/**
	 * Gets the width in millimeters of the specified monitor, if available.
	 * Since 2.14
	 * Params:
	 * monitorNum =  number of the monitor
	 * Returns: the width of the monitor, or -1 if not available
	 */
	public int getMonitorWidthMm(int monitorNum);
	
	/**
	 * Returns the output name of the specified monitor.
	 * Usually something like VGA, DVI, or TV, not the actual
	 * product name of the display device.
	 * Since 2.14
	 * Params:
	 * monitorNum =  number of the monitor
	 * Returns: a newly-allocated string containing the name of the monitor, or NULL if the name cannot be determined
	 */
	public string getMonitorPlugName(int monitorNum);
	
	/**
	 * On X11, sends an X ClientMessage event to all toplevel windows on
	 * screen.
	 * Toplevel windows are determined by checking for the WM_STATE property,
	 * as described in the Inter-Client Communication Conventions Manual (ICCCM).
	 * If no windows are found with the WM_STATE property set, the message is
	 * sent to all children of the root window.
	 * On Windows, broadcasts a message registered with the name
	 * GDK_WIN32_CLIENT_MESSAGE to all top-level windows. The amount of
	 * data is limited to one long, i.e. four bytes.
	 * Since 2.2
	 * Params:
	 * event =  the GdkEvent.
	 */
	public void broadcastClientMessage(Event event);
	
	/**
	 * Retrieves a desktop-wide setting such as double-click time
	 * for the GdkScreen screen.
	 * FIXME needs a list of valid settings here, or a link to
	 * more information.
	 * Since 2.2
	 * Params:
	 * name =  the name of the setting
	 * value =  location to store the value of the setting
	 * Returns: TRUE if the setting existed and a value was stored in value, FALSE otherwise.
	 */
	public int getSetting(string name, Value value);
	
	/**
	 * Gets any options previously set with gdk_screen_set_font_options().
	 * Since 2.10
	 * Returns: the current font options, or NULL if no default font options have been set.
	 */
	public FontOption getFontOptions();
	
	/**
	 * Sets the default font options for the screen. These
	 * options will be set on any PangoContext's newly created
	 * with gdk_pango_context_get_for_screen(). Changing the
	 * default set of font options does not affect contexts that
	 * have already been created.
	 * Since 2.10
	 * Params:
	 * options =  a cairo_font_options_t, or NULL to unset any
	 *  previously set default font options.
	 */
	public void setFontOptions(FontOption options);
	
	/**
	 * Gets the resolution for font handling on the screen; see
	 * gdk_screen_set_resolution() for full details.
	 * Since 2.10
	 * Returns: the current resolution, or -1 if no resolutionhas been set.
	 */
	public double getResolution();
	
	/**
	 * Sets the resolution for font handling on the screen. This is a
	 * scale factor between points specified in a PangoFontDescription
	 * and cairo units. The default value is 96, meaning that a 10 point
	 * font will be 13 units high. (10 * 96. / 72. = 13.3).
	 * Since 2.10
	 * Params:
	 * dpi =  the resolution in "dots per inch". (Physical inches aren't actually
	 *  involved; the terminology is conventional.)
	 */
	public void setResolution(double dpi);
	
	/**
	 * Returns the screen's currently active window.
	 * On X11, this is done by inspecting the _NET_ACTIVE_WINDOW property
	 * on the root window, as described in the Extended Window
	 * Manager Hints. If there is no currently currently active
	 * window, or the window manager does not support the
	 * _NET_ACTIVE_WINDOW hint, this function returns NULL.
	 * On other platforms, this function may return NULL, depending on whether
	 * it is implementable on that platform.
	 * The returned window should be unrefed using g_object_unref() when
	 * no longer needed.
	 * Since 2.10
	 * Returns: the currently active window, or NULL.
	 */
	public Window getActiveWindow();
	
	/**
	 * Returns a GList of GdkWindows representing the current
	 * window stack.
	 * On X11, this is done by inspecting the _NET_CLIENT_LIST_STACKING
	 * property on the root window, as described in the Extended Window
	 * Manager Hints. If the window manager does not support the
	 * _NET_CLIENT_LIST_STACKING hint, this function returns NULL.
	 * On other platforms, this function may return NULL, depending on whether
	 * it is implementable on that platform.
	 * The returned list is newly allocated and owns references to the
	 * windows it contains, so it should be freed using g_list_free() and
	 * its windows unrefed using g_object_unref() when no longer needed.
	 * Since 2.10
	 * Returns: a list of GdkWindows for the current window stack, or NULL.
	 */
	public ListG getWindowStack();
	
	/**
	 * Like g_spawn_async(), except the child process is spawned in such
	 * an environment that on calling gdk_display_open() it would be
	 * returned a GdkDisplay with screen as the default screen.
	 * This is useful for applications which wish to launch an application
	 * on a specific screen.
	 * Since 2.4
	 * Params:
	 * workingDirectory =  child's current working directory, or NULL to
	 *  inherit parent's
	 * argv =  child's argument vector
	 * envp =  child's environment, or NULL to inherit parent's
	 * flags =  flags from GSpawnFlags
	 * childSetup =  function to run in the child just before exec()
	 * userData =  user data for child_setup
	 * childPid =  return location for child process ID, or NULL
	 * Returns: TRUE on success, FALSE if error is set
	 * Throws: GException on failure.
	 */
	public int gdkSpawnOnScreen(string workingDirectory, string[] argv, string[] envp, GSpawnFlags flags, GSpawnChildSetupFunc childSetup, void* userData, out int childPid);
	
	/**
	 * Like g_spawn_async_with_pipes(), except the child process is
	 * spawned in such an environment that on calling gdk_display_open()
	 * it would be returned a GdkDisplay with screen as the default
	 * screen.
	 * This is useful for applications which wish to launch an application
	 * on a specific screen.
	 * Since 2.4
	 * Params:
	 * workingDirectory =  child's current working directory, or NULL to
	 *  inherit parent's
	 * argv =  child's argument vector
	 * envp =  child's environment, or NULL to inherit parent's
	 * flags =  flags from GSpawnFlags
	 * childSetup =  function to run in the child just before exec()
	 * userData =  user data for child_setup
	 * childPid =  return location for child process ID, or NULL
	 * standardInput =  return location for file descriptor to write to
	 *  child's stdin, or NULL
	 * standardOutput =  return location for file descriptor to read child's
	 *  stdout, or NULL
	 * standardError =  return location for file descriptor to read child's
	 *  stderr, or NULL
	 * Returns: TRUE on success, FALSE if an error was set
	 */
	public int gdkSpawnOnScreenWithPipes(string workingDirectory, string[] argv, string[] envp, GSpawnFlags flags, GSpawnChildSetupFunc childSetup, void* userData, out int childPid, out int standardInput, out int standardOutput, out int standardError);
	/**
	 * Like g_spawn_command_line_async(), except the child process is
	 * spawned in such an environment that on calling gdk_display_open()
	 * it would be returned a GdkDisplay with screen as the default
	 * screen.
	 * This is useful for applications which wish to launch an application
	 * on a specific screen.
	 * Since 2.4
	 * Params:
	 * commandLine =  a command line
	 * Returns: TRUE on success, FALSE if error is set.
	 * Throws: GException on failure.
	 */
	public int gdkSpawnCommandLineOnScreen(string commandLine);
}
