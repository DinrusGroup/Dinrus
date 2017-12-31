module gtkD.gdk.DragContext;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Window;
private import gtkD.gdk.Screen;
private import gtkD.glib.ListG;
private import gtkD.gdk.Display;




/**
 * Description
 * These functions provide a low level interface for drag and drop.
 * The X backend of GDK supports both the Xdnd and Motif drag and drop protocols
 * transparently, the Win32 backend supports the WM_DROPFILES protocol.
 * GTK+ provides a higher level abstraction based on top of these functions,
 * and so they are not normally needed in GTK+ applications.
 * See the Drag and Drop section of
 * the GTK+ documentation for more information.
 */
public class DragContext
{
	
	/** the main Gtk struct */
	protected GdkDragContext* gdkDragContext;
	
	
	public GdkDragContext* getDragContextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkDragContext* gdkDragContext);
	
	/**
	 */
	
	/**
	 * Returns the selection atom for the current source window.
	 * Returns: the selection atom.
	 */
	public GdkAtom gdkDragGetSelection();
	
	/**
	 * Aborts a drag without dropping.
	 * This function is called by the drag source.
	 * Params:
	 * time =  the timestamp for this operation.
	 */
	public void gdkDragAbort(uint time);
	
	/**
	 * Accepts or rejects a drop.
	 * This function is called by the drag destination in response
	 * to a drop initiated by the drag source.
	 * Params:
	 * ok =  TRUE if the drop is accepted.
	 * time =  the timestamp for this operation.
	 */
	public void gdkDropReply(int ok, uint time);
	
	/**
	 * Creates a new GdkDragContext.
	 * Returns: the newly created GdkDragContext.
	 */
	public static DragContext gdkDragContextNew();
	
	/**
	 * Drops on the current destination.
	 * This function is called by the drag source.
	 * Params:
	 * time =  the timestamp for this operation.
	 */
	public void gdkDragDrop(uint time);
	
	/**
	 * Finds the destination window and DND protocol to use at the
	 * given pointer position.
	 * This function is called by the drag source to obtain the
	 * dest_window and protocol parameters for gdk_drag_motion().
	 * Params:
	 * dragWindow =  a window which may be at the pointer position, but
	 *  should be ignored, since it is put up by the drag source as an icon.
	 * xRoot =  the x position of the pointer in root coordinates.
	 * yRoot =  the y position of the pointer in root coordinates.
	 * destWindow =  location to store the destination window in.
	 * protocol =  location to store the DND protocol in.
	 */
	public void gdkDragFindWindow(Window dragWindow, int xRoot, int yRoot, out Window destWindow, out GdkDragProtocol protocol);
	
	/**
	 * Finds the destination window and DND protocol to use at the
	 * given pointer position.
	 * This function is called by the drag source to obtain the
	 * dest_window and protocol parameters for gdk_drag_motion().
	 * Since 2.2
	 * Params:
	 * dragWindow =  a window which may be at the pointer position, but
	 * should be ignored, since it is put up by the drag source as an icon.
	 * screen =  the screen where the destination window is sought.
	 * xRoot =  the x position of the pointer in root coordinates.
	 * yRoot =  the y position of the pointer in root coordinates.
	 * destWindow =  location to store the destination window in.
	 * protocol =  location to store the DND protocol in.
	 */
	public void gdkDragFindWindowForScreen(Window dragWindow, Screen screen, int xRoot, int yRoot, out Window destWindow, out GdkDragProtocol protocol);
	
	/**
	 * Warning
	 * gdk_drag_context_ref is deprecated and should not be used in newly-written code.
	 * Deprecated function; use g_object_ref() instead.
	 */
	public void gdkDragContextRef();
	
	/**
	 * Starts a drag and creates a new drag context for it.
	 * This function is called by the drag source.
	 * Params:
	 * window =  the source window for this drag.
	 * targets =  the list of offered targets.
	 * Returns: a newly created GdkDragContext.
	 */
	public static DragContext gdkDragBegin(Window window, ListG targets);
	
	/**
	 * Updates the drag context when the pointer moves or the
	 * set of actions changes.
	 * This function is called by the drag source.
	 * Params:
	 * destWindow =  the new destination window, obtained by
	 *  gdk_drag_find_window().
	 * protocol =  the DND protocol in use, obtained by gdk_drag_find_window().
	 * xRoot =  the x position of the pointer in root coordinates.
	 * yRoot =  the y position of the pointer in root coordinates.
	 * suggestedAction =  the suggested action.
	 * possibleActions =  the possible actions.
	 * time =  the timestamp for this operation.
	 * Returns: FIXME
	 */
	public int gdkDragMotion(Window destWindow, GdkDragProtocol protocol, int xRoot, int yRoot, GdkDragAction suggestedAction, GdkDragAction possibleActions, uint time);
	
	/**
	 * Ends the drag operation after a drop.
	 * This function is called by the drag destination.
	 * Params:
	 * success =  TRUE if the data was successfully received.
	 * time =  the timestamp for this operation.
	 */
	public void gdkDropFinish(int success, uint time);
	
	/**
	 * Finds out the DND protocol supported by a window.
	 * Params:
	 * xid =  the windowing system id of the destination window.
	 * protocol =  location where the supported DND protocol is returned.
	 * Returns: the windowing system specific id for the window where the drop should happen. This may be xid or the id of a proxy window, or zero if xid doesn't support Drag and Drop.
	 */
	public static GdkNativeWindow gdkDragGetProtocol(GdkNativeWindow xid, out GdkDragProtocol protocol);
	
	/**
	 * Finds out the DND protocol supported by a window.
	 * Since 2.2
	 * Params:
	 * display =  the GdkDisplay where the destination window resides
	 * xid =  the windowing system id of the destination window.
	 * protocol =  location where the supported DND protocol is returned.
	 * Returns: the windowing system id of the window where the drop should happen. This  may be xid or the id of a proxy window, or zero if xid doesn't support Drag and Drop.
	 */
	public static GdkNativeWindow gdkDragGetProtocolForDisplay(Display display, GdkNativeWindow xid, out GdkDragProtocol protocol);
	
	/**
	 * Warning
	 * gdk_drag_context_unref is deprecated and should not be used in newly-written code.
	 * Deprecated function; use g_object_unref() instead.
	 */
	public void gdkDragContextUnref();
	
	/**
	 * Selects one of the actions offered by the drag source.
	 * This function is called by the drag destination in response to
	 * gdk_drag_motion() called by the drag source.
	 * Params:
	 * action =  the selected action which will be taken when a drop happens,
	 *  or 0 to indicate that a drop will not be accepted.
	 * time =  the timestamp for this operation.
	 */
	public void gdkDragStatus(GdkDragAction action, uint time);
	
	/**
	 * Returns whether the dropped data has been successfully
	 * transferred. This function is intended to be used while
	 * handling a GDK_DROP_FINISHED event, its return value is
	 * meaningless at other times.
	 * Since 2.6
	 * Returns: TRUE if the drop was successful.
	 */
	public int gdkDragDropSucceeded();
}
