module gtkD.gtk.Viewport;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.Adjustment;



private import gtkD.gtk.Bin;

/**
 * Description
 * The GtkViewport widget acts as an adaptor class, implementing
 * scrollability for child widgets that lack their own scrolling
 * capabilities. Use GtkViewport to scroll child widgets such as
 * GtkTable, GtkBox, and so on.
 * If a widget has native scrolling abilities, such as GtkTextView,
 * GtkTreeView or GtkIconview, it can be added to a GtkScrolledWindow
 * with gtk_container_add(). If a widget does not, you must first add the
 * widget to a GtkViewport, then add the viewport to the scrolled window.
 * The convenience function gtk_scrolled_window_add_with_viewport() does
 * exactly this, so you can ignore the presence of the viewport.
 */
public class Viewport : Bin
{
	
	/** the main Gtk struct */
	protected GtkViewport* gtkViewport;
	
	
	public GtkViewport* getViewportStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkViewport* gtkViewport);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Adjustment, Adjustment, Viewport)[] onSetScrollAdjustmentsListeners;
	/**
	 * Set the scroll adjustments for the viewport. Usually scrolled containers
	 * like GtkScrolledWindow will emit this signal to connect two instances
	 * of GtkScrollbar to the scroll directions of the GtkViewport.
	 * See Also
	 * GtkScrolledWindow, GtkAdjustment
	 */
	void addOnSetScrollAdjustments(void delegate(Adjustment, Adjustment, Viewport) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSetScrollAdjustments(GtkViewport* horizontalStruct, GtkAdjustment* vertical, GtkAdjustment* arg2, Viewport viewport);
	
	
	/**
	 * Creates a new GtkViewport with the given adjustments.
	 * Params:
	 * hadjustment =  horizontal adjustment.
	 * vadjustment =  vertical adjustment.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Adjustment hadjustment, Adjustment vadjustment);
	
	/**
	 * Returns the horizontal adjustment of the viewport.
	 * Returns: the horizontal adjustment of viewport.
	 */
	public Adjustment getHadjustment();
	
	/**
	 * Returns the vertical adjustment of the viewport.
	 * Returns: the vertical adjustment of viewport.
	 */
	public Adjustment getVadjustment();
	
	/**
	 * Sets the horizontal adjustment of the viewport.
	 * Params:
	 * adjustment =  a GtkAdjustment.
	 */
	public void setHadjustment(Adjustment adjustment);
	
	/**
	 * Sets the vertical adjustment of the viewport.
	 * Params:
	 * adjustment =  a GtkAdjustment.
	 */
	public void setVadjustment(Adjustment adjustment);
	
	/**
	 * Sets the shadow type of the viewport.
	 * Params:
	 * type =  the new shadow type.
	 */
	public void setShadowType(GtkShadowType type);
	
	/**
	 * Gets the shadow type of the GtkViewport. See
	 * gtk_viewport_set_shadow_type().
	 * Returns: the shadow type
	 */
	public GtkShadowType getShadowType();
}
