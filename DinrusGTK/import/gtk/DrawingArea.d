module gtkD.gtk.DrawingArea;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.Widget;

/**
 * Description
 * The GtkDrawingArea widget is used for creating custom user interface
 * elements. It's essentially a blank widget; you can draw on
 * widget->window. After creating a drawing area,
 * the application may want to connect to:
 *  Mouse and button press signals to respond to input from
 *  the user. (Use gtk_widget_add_events() to enable events
 *  you wish to receive.)
 *  The "realize" signal to take any necessary actions
 *  when the widget is instantiated on a particular display.
 *  (Create GDK resources in response to this signal.)
 *  The "configure_event" signal to take any necessary actions
 *  when the widget changes size.
 *  The "expose_event" signal to handle redrawing the
 *  contents of the widget.
 * The following code portion demonstrates using a drawing
 * area to display a circle in the normal widget foreground
 * color.
 * Note that GDK automatically clears the exposed area
 * to the background color before sending the expose event, and
 * that drawing is implicitly clipped to the exposed area.
 * Example 50. Simple GtkDrawingArea usage.
 * gboolean
 * expose_event_callback (GtkWidget *widget, GdkEventExpose *event, gpointer data)
 * {
	 *  gdk_draw_arc (widget->window,
	 *  widget->style->fg_gc[GTK_WIDGET_STATE (widget)],
	 *  TRUE,
	 *  0, 0, widget->allocation.width, widget->allocation.height,
	 *  0, 64 * 360);
	 *  return TRUE;
 * }
 * [...]
 *  GtkWidget *drawing_area = gtk_drawing_area_new ();
 *  gtk_widget_set_size_request (drawing_area, 100, 100);
 *  g_signal_connect (G_OBJECT (drawing_area), "expose_event",
 *  G_CALLBACK (expose_event_callback), NULL);
 * Expose events are normally delivered when a drawing area first comes
 * onscreen, or when it's covered by another window and then uncovered
 * (exposed). You can also force an expose event by adding to the "damage
 * region" of the drawing area's window; gtk_widget_queue_draw_area() and
 * gdk_window_invalidate_rect() are equally good ways to do this. You'll
 * then get an expose event for the invalid region.
 * The available routines for drawing are documented on the GDK Drawing Primitives page.
 * See also gdk_draw_pixbuf() for drawing a GdkPixbuf.
 * To receive mouse events on a drawing area, you will need to enable
 * them with gtk_widget_add_events(). To receive keyboard events, you
 * will need to set the GTK_CAN_FOCUS flag on the drawing area, and
 * should probably draw some user-visible indication that the drawing
 * area is focused. Use the GTK_HAS_FOCUS() macro in your expose event
 * handler to decide whether to draw the focus indicator. See
 * gtk_paint_focus() for one way to draw focus.
 */
public class DrawingArea : Widget
{
	
	/** the main Gtk struct */
	protected GtkDrawingArea* gtkDrawingArea;
	
	
	public GtkDrawingArea* getDrawingAreaStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkDrawingArea* gtkDrawingArea);
	
	/**
	 * Create a new DrawingArea and sets the SizeRequest
	 * Params:
	 *    	width =
	 *    	height =
	 */
	this(int width, int height);
	
	
	/**
	 */
	
	/**
	 * Creates a new drawing area.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Warning
	 * gtk_drawing_area_size is deprecated and should not be used in newly-written code. Use gtk_widget_set_size_request() instead.
	 * Sets the size that the drawing area will request
	 * in response to a "size_request" signal. The
	 * drawing area may actually be allocated a size
	 * larger than this depending on how it is packed
	 * within the enclosing containers.
	 * Params:
	 * width = the width to request
	 * height = the height to request
	 */
	public void size(int width, int height);
}
