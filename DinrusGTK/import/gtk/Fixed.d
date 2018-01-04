module gtkD.gtk.Fixed;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;



private import gtkD.gtk.Container;

/**
 * Description
 * The GtkFixed widget is a container which can place child widgets at fixed
 * positions and with fixed sizes, given in pixels. GtkFixed performs no
 * automatic layout management.
 * For most applications, you should not use this container! It keeps
 * you from having to learn about the other GTK+ containers, but it
 * results in broken applications.
 * With GtkFixed, the following things will result in truncated text,
 * overlapping widgets, and other display bugs:
 * Themes, which may change widget sizes.
 * Fonts other than the one you used to write the app will of
 * course change the size of widgets containing text; keep in mind that
 * users may use a larger font because of difficulty reading the default,
 * or they may be using Windows or the framebuffer port of GTK+, where
 * different fonts are available.
 * Translation of text into other languages changes its size. Also,
 * display of non-English text will use a different font in many cases.
 * In addition, the fixed widget can't properly be mirrored in
 * right-to-left languages such as Hebrew and Arabic. i.e. normally GTK+
 * will flip the interface to put labels to the right of the thing they
 * label, but it can't do that with GtkFixed. So your application will
 * not be usable in right-to-left languages.
 * Finally, fixed positioning makes it kind of annoying to add/remove GUI
 * elements, since you have to reposition all the other elements. This is
 * a long-term maintenance problem for your application.
 * If you know none of these things are an issue for your application,
 * and prefer the simplicity of GtkFixed, by all means use the
 * widget. But you should be aware of the tradeoffs.
 */
public class Fixed : Container
{
	
	/** the main Gtk struct */
	protected GtkFixed* gtkFixed;
	
	
	public GtkFixed* getFixedStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFixed* gtkFixed);
	
	/**
	 */
	
	/**
	 * Creates a new GtkFixed.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Adds a widget to a GtkFixed container at the given position.
	 * Params:
	 * widget = the widget to add.
	 * x = the horizontal position to place the widget at.
	 * y = the vertical position to place the widget at.
	 */
	public void put(Widget widget, int x, int y);
	
	/**
	 * Moves a child of a GtkFixed container to the given position.
	 * Params:
	 * widget = the child widget.
	 * x = the horizontal position to move the widget to.
	 * y = the vertical position to move the widget to.
	 */
	public void move(Widget widget, int x, int y);
	
	/**
	 * Gets whether the GtkFixed has its own GdkWindow.
	 * See gtk_fixed_set_has_window().
	 * Returns: TRUE if fixed has its own window.
	 */
	public int getHasWindow();
	
	/**
	 * Sets whether a GtkFixed widget is created with a separate
	 * GdkWindow for widget->window or not. (By default, it will be
	 * created with no separate GdkWindow). This function must be called
	 * while the GtkFixed is not realized, for instance, immediately after the
	 * window is created.
	 * This function was added to provide an easy migration path for
	 * older applications which may expect GtkFixed to have a separate window.
	 * Params:
	 * hasWindow =  TRUE if a separate window should be created
	 * Child Property Details
	 * The "x" child property
	 *  "x" gint : Read / Write
	 * X position of child widget.
	 * Default value: 0
	 */
	public void setHasWindow(int hasWindow);
}
