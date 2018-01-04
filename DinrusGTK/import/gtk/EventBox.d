module gtkD.gtk.EventBox;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.Bin;

/**
 * Description
 * The GtkEventBox widget is a subclass of GtkBin which also has its own window.
 * It is useful since it allows you to catch events for widgets which do not
 * have their own window.
 */
public class EventBox : Bin
{
	
	/** the main Gtk struct */
	protected GtkEventBox* gtkEventBox;
	
	
	public GtkEventBox* getEventBoxStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkEventBox* gtkEventBox);
	
	/**
	 */
	
	/**
	 * Creates a new GtkEventBox.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Set whether the event box window is positioned above the windows of its child,
	 * as opposed to below it. If the window is above, all events inside the
	 * event box will go to the event box. If the window is below, events
	 * in windows of child widgets will first got to that widget, and then
	 * to its parents.
	 * The default is to keep the window below the child.
	 * Since 2.4
	 * Params:
	 * aboveChild =  TRUE if the event box window is above the windows of its child
	 */
	public void setAboveChild(int aboveChild);
	
	/**
	 * Returns whether the event box window is above or below the
	 * windows of its child. See gtk_event_box_set_above_child() for
	 * details.
	 * Since 2.4
	 * Returns: TRUE if the event box window is above the windowof its child.
	 */
	public int getAboveChild();
	
	/**
	 * Set whether the event box uses a visible or invisible child
	 * window. The default is to use visible windows.
	 * In an invisible window event box, the window that the
	 * event box creates is a GDK_INPUT_ONLY window, which
	 * means that it is invisible and only serves to receive
	 * events.
	 * A visible window event box creates a visible (GDK_INPUT_OUTPUT)
	 * window that acts as the parent window for all the widgets
	 * contained in the event box.
	 * You should generally make your event box invisible if
	 * you just want to trap events. Creating a visible window
	 * may cause artifacts that are visible to the user, especially
	 * if the user is using a theme with gradients or pixmaps.
	 * The main reason to create a non input-only event box is if
	 * you want to set the background to a different color or
	 * draw on it.
	 * Note
	 * There is one unexpected issue for an invisible event box that has its
	 * window below the child. (See gtk_event_box_set_above_child().)
	 * Since the input-only window is not an ancestor window of any windows
	 * that descendent widgets of the event box create, events on these
	 * windows aren't propagated up by the windowing system, but only by GTK+.
	 * The practical effect of this is if an event isn't in the event
	 * mask for the descendant window (see gtk_widget_add_events()),
	 * it won't be received by the event box.
	 * This problem doesn't occur for visible event boxes, because in
	 * that case, the event box window is actually the ancestor of the
	 * descendant windows, not just at the same place on the screen.
	 * Since 2.4
	 * Params:
	 * visibleWindow =  boolean value
	 */
	public void setVisibleWindow(int visibleWindow);
	
	/**
	 * Returns whether the event box has a visible window.
	 * See gtk_event_box_set_visible_window() for details.
	 * Since 2.4
	 * Returns: TRUE if the event box window is visible
	 */
	public int getVisibleWindow();
}
