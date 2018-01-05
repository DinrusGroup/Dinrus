module gtkD.gtk.ScrolledWindow;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.Widget;
private import gtkD.gtk.Adjustment;



private import gtkD.gtk.Bin;

/**
 * Description
 * GtkScrolledWindow is a GtkBin subclass: it's a container
 * the accepts a single child widget. GtkScrolledWindow adds scrollbars
 * to the child widget and optionally draws a beveled frame around the
 * child widget.
 * The scrolled window can work in two ways. Some widgets have native
 * scrolling support; these widgets have "slots" for GtkAdjustment
 * objects.
 * [5]
 * Widgets with native scroll support include GtkTreeView, GtkTextView,
 * and GtkLayout.
 * For widgets that lack native scrolling support, the GtkViewport
 * widget acts as an adaptor class, implementing scrollability for child
 * widgets that lack their own scrolling capabilities. Use GtkViewport
 * to scroll child widgets such as GtkTable, GtkBox, and so on.
 * If a widget has native scrolling abilities, it can be added to the
 * GtkScrolledWindow with gtk_container_add(). If a widget does not, you
 * must first add the widget to a GtkViewport, then add the GtkViewport
 * to the scrolled window. The convenience function
 * gtk_scrolled_window_add_with_viewport() does exactly this, so you can
 * ignore the presence of the viewport.
 * The position of the scrollbars is controlled by the scroll
 * adjustments. See GtkAdjustment for the fields in an adjustment - for
 * GtkScrollbar, used by GtkScrolledWindow, the "value" field
 * represents the position of the scrollbar, which must be between the
 * "lower" field and "upper - page_size." The "page_size" field
 * represents the size of the visible scrollable area. The
 * "step_increment" and "page_increment" fields are used when the user
 * asks to step down (using the small stepper arrows) or page down (using
 * for example the PageDown key).
 * If a GtkScrolledWindow doesn't behave quite as you would like, or
 * doesn't have exactly the right layout, it's very possible to set up
 * your own scrolling with GtkScrollbar and for example a GtkTable.
 */
public class ScrolledWindow : Bin
{
	
	/** the main Gtk struct */
	protected GtkScrolledWindow* gtkScrolledWindow;
	
	
	public GtkScrolledWindow* getScrolledWindowStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkScrolledWindow* gtkScrolledWindow);
	
	/** */
	public this();
	
	/** */
	public this(Widget widget);
	
	/**
	 * Creates a new scrolled window. The two arguments are the scrolled
	 * window's adjustments; these will be shared with the scrollbars and the
	 * child widget to keep the bars in sync with the child. Usually you want
	 * to pass NULL for the adjustments, which will cause the scrolled window
	 * to create them for you.
	 * Params:
	 *  hadjustment = Horizontal adjustment.
	 *  vadjustment = Vertical adjustment.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Adjustment hadjustment, Adjustment vadjustment);
	
	/**
	 * Creates a new Scrolled window and set the policy type
	 * Params:
	 *  hPolicy = the horizontal policy
	 *  vPolicy = the vertical policy
	 */
	this(PolicyType hPolicy, PolicyType vPolicy);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(GtkDirectionType, ScrolledWindow)[] onMoveFocusOutListeners;
	/**
	 */
	void addOnMoveFocusOut(void delegate(GtkDirectionType, ScrolledWindow) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveFocusOut(GtkScrolledWindow* scrolledwindowStruct, GtkDirectionType arg1, ScrolledWindow scrolledWindow);
	
	bool delegate(GtkScrollType, gboolean, ScrolledWindow)[] onScrollChildListeners;
	/**
	 * See Also
	 * GtkViewport, GtkAdjustment, GtkWidgetClass
	 * [5] The scrolled window installs GtkAdjustment objects in
	 * the child window's slots using the set_scroll_adjustments_signal,
	 * found in GtkWidgetClass. (Conceptually, these widgets implement a
	 * "Scrollable" interface; because GTK+ 1.2 lacked interface support in
	 * the object system, this interface is hackily implemented as a signal
	 * in GtkWidgetClass. The GTK+ 2.0 object system would allow a clean
	 * implementation, but it wasn't worth breaking the
	 * API.)
	 */
	void addOnScrollChild(bool delegate(GtkScrollType, gboolean, ScrolledWindow) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackScrollChild(GtkScrolledWindow* scrolledwindowStruct, GtkScrollType arg1, gboolean arg2, ScrolledWindow scrolledWindow);
	
	
	/**
	 * Returns the horizontal scrollbar's adjustment, used to connect the
	 * horizontal scrollbar to the child widget's horizontal scroll
	 * functionality.
	 * Returns: the horizontal GtkAdjustment
	 */
	public Adjustment getHadjustment();
	
	/**
	 * Returns the vertical scrollbar's adjustment, used to connect the
	 * vertical scrollbar to the child widget's vertical scroll
	 * functionality.
	 * Returns: the vertical GtkAdjustment
	 */
	public Adjustment getVadjustment();
	
	/**
	 * Returns the horizontal scrollbar of scrolled_window.
	 * Since 2.8
	 * Returns: the horizontal scrollbar of the scrolled window, or  NULL if it does not have one.
	 */
	public Widget getHscrollbar();
	
	/**
	 * Returns the vertical scrollbar of scrolled_window.
	 * Since 2.8
	 * Returns: the vertical scrollbar of the scrolled window, or NULL if it does not have one.
	 */
	public Widget getVscrollbar();
	
	/**
	 * Sets the scrollbar policy for the horizontal and vertical scrollbars.
	 * The policy determines when the scrollbar should appear; it is a value
	 * from the GtkPolicyType enumeration. If GTK_POLICY_ALWAYS, the
	 * scrollbar is always present; if GTK_POLICY_NEVER, the scrollbar is
	 * never present; if GTK_POLICY_AUTOMATIC, the scrollbar is present only
	 * if needed (that is, if the slider part of the bar would be smaller
	 * than the trough - the display is larger than the page size).
	 * Params:
	 * hscrollbarPolicy =  policy for horizontal bar
	 * vscrollbarPolicy =  policy for vertical bar
	 */
	public void setPolicy(GtkPolicyType hscrollbarPolicy, GtkPolicyType vscrollbarPolicy);
	
	/**
	 * Used to add children without native scrolling capabilities. This
	 * is simply a convenience function; it is equivalent to adding the
	 * unscrollable child to a viewport, then adding the viewport to the
	 * scrolled window. If a child has native scrolling, use
	 * gtk_container_add() instead of this function.
	 * The viewport scrolls the child by moving its GdkWindow, and takes
	 * the size of the child to be the size of its toplevel GdkWindow.
	 * This will be very wrong for most widgets that support native scrolling;
	 * for example, if you add a widget such as GtkTreeView with a viewport,
	 * the whole widget will scroll, including the column headings. Thus,
	 * widgets with native scrolling support should not be used with the
	 * GtkViewport proxy.
	 * A widget supports scrolling natively if the
	 * set_scroll_adjustments_signal field in GtkWidgetClass is non-zero,
	 * i.e. has been filled in with a valid signal identifier.
	 * Params:
	 * child =  the widget you want to scroll
	 */
	public void addWithViewport(Widget child);
	
	/**
	 * Sets the placement of the contents with respect to the scrollbars
	 * for the scrolled window.
	 * The default is GTK_CORNER_TOP_LEFT, meaning the child is
	 * in the top left, with the scrollbars underneath and to the right.
	 * Other values in GtkCornerType are GTK_CORNER_TOP_RIGHT,
	 * GTK_CORNER_BOTTOM_LEFT, and GTK_CORNER_BOTTOM_RIGHT.
	 * See also gtk_scrolled_window_get_placement() and
	 * gtk_scrolled_window_unset_placement().
	 * Params:
	 * windowPlacement =  position of the child window
	 */
	public void setPlacement(GtkCornerType windowPlacement);
	
	/**
	 * Unsets the placement of the contents with respect to the scrollbars
	 * for the scrolled window. If no window placement is set for a scrolled
	 * window, it obeys the "gtk-scrolled-window-placement" XSETTING.
	 * See also gtk_scrolled_window_set_placement() and
	 * gtk_scrolled_window_get_placement().
	 * Since 2.10
	 */
	public void unsetPlacement();
	
	/**
	 * Changes the type of shadow drawn around the contents of
	 * scrolled_window.
	 * Params:
	 * type =  kind of shadow to draw around scrolled window contents
	 */
	public void setShadowType(GtkShadowType type);
	
	/**
	 * Sets the GtkAdjustment for the horizontal scrollbar.
	 * Params:
	 * hadjustment =  horizontal scroll adjustment
	 */
	public void setHadjustment(Adjustment hadjustment);
	
	/**
	 * Sets the GtkAdjustment for the vertical scrollbar.
	 * Params:
	 * vadjustment =  vertical scroll adjustment
	 */
	public void setVadjustment(Adjustment vadjustment);
	
	/**
	 * Gets the placement of the contents with respect to the scrollbars
	 * for the scrolled window. See gtk_scrolled_window_set_placement().
	 * Returns: the current placement value.See also gtk_scrolled_window_set_placement() andgtk_scrolled_window_unset_placement().
	 */
	public GtkCornerType getPlacement();
	
	/**
	 * Retrieves the current policy values for the horizontal and vertical
	 * scrollbars. See gtk_scrolled_window_set_policy().
	 * Params:
	 * hscrollbarPolicy =  location to store the policy for the horizontal
	 *  scrollbar, or NULL.
	 * vscrollbarPolicy =  location to store the policy for the vertical
	 *  scrollbar, or NULL.
	 */
	public void getPolicy(out GtkPolicyType hscrollbarPolicy, out GtkPolicyType vscrollbarPolicy);
	
	/**
	 * Gets the shadow type of the scrolled window. See
	 * gtk_scrolled_window_set_shadow_type().
	 * Returns: the current shadow type
	 */
	public GtkShadowType getShadowType();
}
