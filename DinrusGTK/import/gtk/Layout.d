module gtkD.gtk.Layout;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gdk.Window;
private import gtkD.gtk.Adjustment;
private import gtkD.gtk.Widget;



private import gtkD.gtk.Container;

/**
 * Description
 * GtkLayout is similar to GtkDrawingArea in that it's a "blank slate"
 * and doesn't do anything but paint a blank background by default. It's
 * different in that it supports scrolling natively (you can add it to a
 * GtkScrolledWindow), and it can contain child widgets, since it's a
 * GtkContainer. However if you're just going to draw, a GtkDrawingArea
 * is a better choice since it has lower overhead.
 * When handling expose events on a GtkLayout, you must draw to
 * GTK_LAYOUT (layout)->bin_window, rather than to
 * GTK_WIDGET (layout)->window, as you would for a drawing
 * area.
 */
public class Layout : Container
{
	
	/** the main Gtk struct */
	protected GtkLayout* gtkLayout;
	
	
	public GtkLayout* getLayoutStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkLayout* gtkLayout);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Adjustment, Adjustment, Layout)[] onSetScrollAdjustmentsListeners;
	/**
	 * Set the scroll adjustments for the layout. Usually scrolled containers
	 * like GtkScrolledWindow will emit this signal to connect two instances
	 * of GtkScrollbar to the scroll directions of the GtkLayout.
	 * See Also
	 * GtkDrawingArea, GtkScrolledWindow
	 */
	void addOnSetScrollAdjustments(void delegate(Adjustment, Adjustment, Layout) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSetScrollAdjustments(GtkLayout* horizontalStruct, GtkAdjustment* vertical, GtkAdjustment* arg2, Layout layout);
	
	
	/**
	 * Creates a new GtkLayout. Unless you have a specific adjustment
	 * you'd like the layout to use for scrolling, pass NULL for
	 * hadjustment and vadjustment.
	 * Params:
	 * hadjustment =  horizontal scroll adjustment, or NULL
	 * vadjustment =  vertical scroll adjustment, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Adjustment hadjustment, Adjustment vadjustment);
	
	/**
	 * Adds child_widget to layout, at position (x,y).
	 * layout becomes the new parent container of child_widget.
	 * Params:
	 * childWidget =  child widget
	 * x =  X position of child widget
	 * y =  Y position of child widget
	 */
	public void put(Widget childWidget, int x, int y);

	/**
	 * Moves a current child of layout to a new position.
	 * Params:
	 * childWidget =  a current child of layout
	 * x =  X position to move to
	 * y =  Y position to move to
	 */
	public void move(Widget childWidget, int x, int y);
	
	/**
	 * Sets the size of the scrollable area of the layout.
	 * Params:
	 * width =  width of entire scrollable area
	 * height =  height of entire scrollable area
	 */
	public void setSize(uint width, uint height);
	
	/**
	 * Gets the size that has been set on the layout, and that determines
	 * the total extents of the layout's scrollbar area. See
	 * gtk_layout_set_size().
	 * Params:
	 * width =  location to store the width set on layout, or NULL
	 * height =  location to store the height set on layout, or NULL
	 */
	public void getSize(out uint width, out uint height);
	
	/**
	 * Warning
	 * gtk_layout_freeze is deprecated and should not be used in newly-written code.
	 * This is a deprecated function, it doesn't do anything useful.
	 */
	public void freeze();
	
	/**
	 * Warning
	 * gtk_layout_thaw is deprecated and should not be used in newly-written code.
	 * This is a deprecated function, it doesn't do anything useful.
	 */
	public void thaw();
	
	/**
	 * This function should only be called after the layout has been
	 * placed in a GtkScrolledWindow or otherwise configured for
	 * scrolling. It returns the GtkAdjustment used for communication
	 * between the horizontal scrollbar and layout.
	 * See GtkScrolledWindow, GtkScrollbar, GtkAdjustment for details.
	 * Returns: horizontal scroll adjustment
	 */
	public Adjustment getHadjustment();
	
	/**
	 * This function should only be called after the layout has been
	 * placed in a GtkScrolledWindow or otherwise configured for
	 * scrolling. It returns the GtkAdjustment used for communication
	 * between the vertical scrollbar and layout.
	 * See GtkScrolledWindow, GtkScrollbar, GtkAdjustment for details.
	 * Returns: vertical scroll adjustment
	 */
	public Adjustment getVadjustment();
	
	/**
	 * Sets the horizontal scroll adjustment for the layout.
	 * See GtkScrolledWindow, GtkScrollbar, GtkAdjustment for details.
	 * Params:
	 * adjustment =  new scroll adjustment
	 */
	public void setHadjustment(Adjustment adjustment);
	
	/**
	 * Sets the vertical scroll adjustment for the layout.
	 * See GtkScrolledWindow, GtkScrollbar, GtkAdjustment for details.
	 * Params:
	 * adjustment =  new scroll adjustment
	 */
	public void setVadjustment(Adjustment adjustment);
	
	/**
	 * Retrieve the bin window of the layout used for drawing operations.
	 * Since 2.14
	 * Returns: a GdkWindow
	 */
	public Window getBinWindow();
}
