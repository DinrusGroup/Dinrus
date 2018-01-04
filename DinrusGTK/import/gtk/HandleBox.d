module gtkD.gtk.HandleBox;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;




private import gtkD.gtk.Bin;

/**
 * Description
 * The GtkHandleBox widget allows a portion of a window to be "torn
 * off". It is a bin widget which displays its child and a handle that
 * the user can drag to tear off a separate window (the float
 * window) containing the child widget. A thin
 * ghost is drawn in the original location of the
 * handlebox. By dragging the separate window back to its original
 * location, it can be reattached.
 * When reattaching, the ghost and float window, must be aligned
 * along one of the edges, the snap edge.
 * This either can be specified by the application programmer
 * explicitely, or GTK+ will pick a reasonable default based
 * on the handle position.
 * To make detaching and reattaching the handlebox as minimally confusing
 * as possible to the user, it is important to set the snap edge so that
 * the snap edge does not move when the handlebox is deattached. For
 * instance, if the handlebox is packed at the bottom of a VBox, then
 * when the handlebox is detached, the bottom edge of the handlebox's
 * allocation will remain fixed as the height of the handlebox shrinks,
 * so the snap edge should be set to GTK_POS_BOTTOM.
 */
public class HandleBox : Bin
{
	
	/** the main Gtk struct */
	protected GtkHandleBox* gtkHandleBox;
	
	
	public GtkHandleBox* getHandleBoxStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkHandleBox* gtkHandleBox);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(GtkWidget*, HandleBox)[] onChildAttachedListeners;
	/**
	 * This signal is emitted when the contents of the
	 * handlebox are reattached to the main window.
	 */
	void addOnChildAttached(void delegate(GtkWidget*, HandleBox) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChildAttached(GtkHandleBox* handleboxStruct, GtkWidget* widget, HandleBox handleBox);
	
	void delegate(GtkWidget*, HandleBox)[] onChildDetachedListeners;
	/**
	 * This signal is emitted when the contents of the
	 * handlebox are detached from the main window.
	 */
	void addOnChildDetached(void delegate(GtkWidget*, HandleBox) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChildDetached(GtkHandleBox* handleboxStruct, GtkWidget* widget, HandleBox handleBox);
	
	
	/**
	 * Create a new handle box.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets the type of shadow to be drawn around the border
	 * of the handle box.
	 * Params:
	 * type = the shadow type.
	 */
	public void setShadowType(GtkShadowType type);
	
	/**
	 * Sets the side of the handlebox where the handle is drawn.
	 * Params:
	 * position = the side of the handlebox where the handle should be drawn.
	 */
	public void setHandlePosition(GtkPositionType position);
	
	/**
	 * Sets the snap edge of a handlebox. The snap edge is
	 * the edge of the detached child that must be aligned
	 * with the corresponding edge of the "ghost" left
	 * behind when the child was detached to reattach
	 * the torn-off window. Usually, the snap edge should
	 * be chosen so that it stays in the same place on
	 * the screen when the handlebox is torn off.
	 * If the snap edge is not set, then an appropriate value
	 * will be guessed from the handle position. If the
	 * handle position is GTK_POS_RIGHT or GTK_POS_LEFT,
	 * then the snap edge will be GTK_POS_TOP, otherwise
	 * it will be GTK_POS_LEFT.
	 * Params:
	 * edge = the snap edge, or -1 to unset the value; in which
	 * case GTK+ will try to guess an appropriate value
	 * in the future.
	 */
	public void setSnapEdge(GtkPositionType edge);
	
	/**
	 * Gets the handle position of the handle box. See
	 * gtk_handle_box_set_handle_position().
	 * Returns: the current handle position.
	 */
	public GtkPositionType getHandlePosition();
	
	/**
	 * Gets the type of shadow drawn around the handle box. See
	 * gtk_handle_box_set_shadow_type().
	 * Returns: the type of shadow currently drawn around the handle box.
	 */
	public GtkShadowType getShadowType();
	
	/**
	 * Gets the edge used for determining reattachment of the handle box. See
	 * gtk_handle_box_set_snap_edge().
	 * Returns: the edge used for determining reattachment, or (GtkPositionType)-1 if this is determined (as per default) from the handle position.
	 */
	public GtkPositionType getSnapEdge();
	
	/**
	 * Whether the handlebox's child is currently detached.
	 * Since 2.14
	 * Returns: TRUE if the child is currently detached, otherwise FALSE
	 */
	public int getChildDetached();
}
