module gtkD.gtk.Selections;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Display;
private import gtkD.gtk.Widget;
private import gtkD.gdk.Display;
private import gtkD.gdk.Pixbuf;
private import gtkD.gtk.TextBuffer;




/**
 * Description
 * The selection mechanism provides the basis for different types
 * of communication between processes. In particular, drag and drop and
 * GtkClipboard work via selections. You will very seldom or
 * never need to use most of the functions in this section directly;
 * GtkClipboard provides a nicer interface to the same functionality.
 * Some of the datatypes defined this section are used in
 * the GtkClipboard and drag-and-drop API's as well. The
 * GtkTargetEntry structure and GtkTargetList objects represent
 * lists of data types that are supported when sending or
 * receiving data. The GtkSelectionData object is used to
 * store a chunk of data along with the data type and other
 * associated information.
 */
public class Selections
{
	
	/**
	 */
	
	/**
	 * Claims ownership of a given selection for a particular widget,
	 * or, if widget is NULL, release ownership of the selection.
	 * Params:
	 * widget =  a GtkWidget, or NULL.
	 * selection =  an interned atom representing the selection to claim
	 * time =  timestamp with which to claim the selection
	 * Returns: TRUE if the operation succeeded
	 */
	public static int ownerSet(Widget widget, GdkAtom selection, uint time);
	
	/**
	 * Claim ownership of a given selection for a particular widget, or,
	 * if widget is NULL, release ownership of the selection.
	 * Since 2.2
	 * Params:
	 * display =  the Gdkdisplay where the selection is set
	 * widget =  new selection owner (a GdkWidget), or NULL.
	 * selection =  an interned atom representing the selection to claim.
	 * time =  timestamp with which to claim the selection
	 * Returns: TRUE if the operation succeeded
	 */
	public static int ownerSetForDisplay(Display display, Widget widget, GdkAtom selection, uint time);
	
	/**
	 * Appends a specified target to the list of supported targets for a
	 * given widget and selection.
	 * Params:
	 * widget =  a GtkTarget
	 * selection =  the selection
	 * target =  target to add.
	 * info =  A unsigned integer which will be passed back to the application.
	 */
	public static void addTarget(Widget widget, GdkAtom selection, GdkAtom target, uint info);
	
	/**
	 * Prepends a table of targets to the list of supported targets
	 * for a given widget and selection.
	 * Params:
	 * widget =  a GtkWidget
	 * selection =  the selection
	 * targets =  a table of targets to add
	 */
	public static void addTargets(Widget widget, GdkAtom selection, GtkTargetEntry[] targets);
	
	/**
	 * Remove all targets registered for the given selection for the
	 * widget.
	 * Params:
	 * widget =  a GtkWidget
	 * selection =  an atom representing a selection
	 */
	public static void clearTargets(Widget widget, GdkAtom selection);
	
	/**
	 * Requests the contents of a selection. When received,
	 * a "selection-received" signal will be generated.
	 * Params:
	 * widget =  The widget which acts as requestor
	 * selection =  Which selection to get
	 * target =  Form of information desired (e.g., STRING)
	 * time =  Time of request (usually of triggering event)
	 *  In emergency, you could use GDK_CURRENT_TIME
	 * Returns: TRUE if requested succeeded. FALSE if we could not process request. (e.g., there was already a request in process for this widget).
	 */
	public static int convert(Widget widget, GdkAtom selection, GdkAtom target, uint time);

	/**
	 * Stores new data into a GtkSelectionData object. Should
	 * only be called from a selection handler callback.
	 * Zero-terminates the stored data.
	 * Params:
	 * selectionData =  a pointer to a GtkSelectionData structure.
	 * type =  the type of selection data
	 * format =  format (number of bits in a unit)
	 * data =  pointer to the data (will be copied)
	 */
	public static void dataSet(GtkSelectionData* selectionData, GdkAtom type, int format, char[] data);
	
	/**
	 * Sets the contents of the selection from a UTF-8 encoded string.
	 * The string is converted to the form determined by
	 * selection_data->target.
	 * Params:
	 * selectionData =  a GtkSelectionData
	 * str =  a UTF-8 string
	 * len =  the length of str, or -1 if str is nul-terminated.
	 * Returns: TRUE if the selection was successfully set, otherwise FALSE.
	 */
	public static int dataSetText(GtkSelectionData* selectionData, string str, int len);
	
	/**
	 * Gets the contents of the selection data as a UTF-8 string.
	 * Params:
	 * selectionData =  a GtkSelectionData
	 * Returns: if the selection data contained a recognized text type and it could be converted to UTF-8, a newly allocated string containing the converted text, otherwise NULL. If the result is non-NULL it must be freed with g_free().
	 */
	public static char* dataGetText(GtkSelectionData* selectionData);
	
	/**
	 * Sets the contents of the selection from a GdkPixbuf
	 * The pixbuf is converted to the form determined by
	 * selection_data->target.
	 * Since 2.6
	 * Params:
	 * selectionData =  a GtkSelectionData
	 * pixbuf =  a GdkPixbuf
	 * Returns: TRUE if the selection was successfully set, otherwise FALSE.
	 */
	public static int dataSetPixbuf(GtkSelectionData* selectionData, Pixbuf pixbuf);
	
	/**
	 * Gets the contents of the selection data as a GdkPixbuf.
	 * Since 2.6
	 * Params:
	 * selectionData =  a GtkSelectionData
	 * Returns: if the selection data contained a recognized image type and it could be converted to a GdkPixbuf, a  newly allocated pixbuf is returned, otherwise NULL. If the result is non-NULL it must be freed with g_object_unref().
	 */
	public static Pixbuf dataGetPixbuf(GtkSelectionData* selectionData);
	
	/**
	 * Sets the contents of the selection from a list of URIs.
	 * The string is converted to the form determined by
	 * selection_data->target.
	 * Since 2.6
	 * Params:
	 * selectionData =  a GtkSelectionData
	 * uris =  a NULL-terminated array of strings holding URIs
	 * Returns: TRUE if the selection was successfully set, otherwise FALSE.
	 */
	public static int dataSetUris(GtkSelectionData* selectionData, string[] uris);
	
	/**
	 * Gets the contents of the selection data as array of URIs.
	 * Since 2.6
	 * Params:
	 * selectionData =  a GtkSelectionData
	 * Returns: if the selection data contains a list of URIs, a newly allocated NULL-terminated string array containing the URIs, otherwise NULL. If the result is  non-NULL it must be freed with g_strfreev().
	 */
	public static string[] dataGetUris(GtkSelectionData* selectionData);
	
	/**
	 * Gets the contents of selection_data as an array of targets.
	 * This can be used to interpret the results of getting
	 * the standard TARGETS target that is always supplied for
	 * any selection.
	 * Params:
	 * selectionData =  a GtkSelectionData object
	 * targets =  location to store an array of targets. The result
	 *  stored here must be freed with g_free().
	 * Returns: TRUE if selection_data contains a valid array of targets, otherwise FALSE.
	 */
	public static int dataGetTargets(GtkSelectionData* selectionData, out GdkAtom[] targets);
	
	/**
	 * Given a GtkSelectionData object holding a list of targets,
	 * determines if any of the targets in targets can be used to
	 * provide a GdkPixbuf.
	 * Since 2.6
	 * Params:
	 * selectionData =  a GtkSelectionData object
	 * writable =  whether to accept only targets for which GTK+ knows
	 *  how to convert a pixbuf into the format
	 * Returns: TRUE if selection_data holds a list of targets, and a suitable target for images is included, otherwise FALSE.
	 */
	public static int dataTargetsIncludeImage(GtkSelectionData* selectionData, int writable);
	
	/**
	 * Given a GtkSelectionData object holding a list of targets,
	 * determines if any of the targets in targets can be used to
	 * provide text.
	 * Params:
	 * selectionData =  a GtkSelectionData object
	 * Returns: TRUE if selection_data holds a list of targets, and a suitable target for text is included, otherwise FALSE.
	 */
	public static int dataTargetsIncludeText(GtkSelectionData* selectionData);
	
	/**
	 * Given a GtkSelectionData object holding a list of targets,
	 * determines if any of the targets in targets can be used to
	 * provide a list or URIs.
	 * Since 2.10
	 * Params:
	 * selectionData =  a GtkSelectionData object
	 * Returns: TRUE if selection_data holds a list of targets, and a suitable target for URI lists is included, otherwise FALSE.
	 */
	public static int dataTargetsIncludeUri(GtkSelectionData* selectionData);
	
	/**
	 * Given a GtkSelectionData object holding a list of targets,
	 * determines if any of the targets in targets can be used to
	 * provide rich text.
	 * Since 2.10
	 * Params:
	 * selectionData =  a GtkSelectionData object
	 * buffer =  a GtkTextBuffer
	 * Returns: TRUE if selection_data holds a list of targets, and a suitable target for rich text is included, otherwise FALSE.
	 */
	public static int dataTargetsIncludeRichText(GtkSelectionData* selectionData, TextBuffer buffer);
	
	/**
	 * Retrieves the selection GdkAtom of the selection data.
	 * Since 2.16
	 * Params:
	 * selectionData =  a pointer to a GtkSelectionData structure.
	 * Returns: the selection GdkAtom of the selection data.
	 */
	public static GdkAtom dataGetSelection(GtkSelectionData* selectionData);
	
	/**
	 * Retrieves the raw data of the selection.
	 * Since 2.14
	 * Params:
	 * selectionData =  a pointer to a GtkSelectionData structure.
	 * Returns: the raw data of the selection.
	 */
	public static char* dataGetData(GtkSelectionData* selectionData);
	
	/**
	 * Retrieves the length of the raw data of the selection.
	 * Since 2.14
	 * Params:
	 * selectionData =  a pointer to a GtkSelectionData structure.
	 * Returns: the length of the data of the selection.
	 */
	public static int dataGetLength(GtkSelectionData* selectionData);

	/**
	 * Retrieves the data type of the selection.
	 * Since 2.14
	 * Params:
	 * selectionData =  a pointer to a GtkSelectionData structure.
	 * Returns: the data type of the selection.
	 */
	public static GdkAtom dataGetDataType(GtkSelectionData* selectionData);
	
	/**
	 * Retrieves the display of the selection.
	 * Since 2.14
	 * Params:
	 * selectionData =  a pointer to a GtkSelectionData structure.
	 * Returns: the display of the selection.
	 */
	public static Display dataGetDisplay(GtkSelectionData* selectionData);
	
	/**
	 * Retrieves the format of the selection.
	 * Since 2.14
	 * Params:
	 * selectionData =  a pointer to a GtkSelectionData structure.
	 * Returns: the format of the selection.
	 */
	public static int dataGetFormat(GtkSelectionData* selectionData);
	
	/**
	 * Retrieves the target of the selection.
	 * Since 2.14
	 * Params:
	 * selectionData =  a pointer to a GtkSelectionData structure.
	 * Returns: the target of the selection.
	 */
	public static GdkAtom dataGetTarget(GtkSelectionData* selectionData);
	
	/**
	 * Removes all handlers and unsets ownership of all
	 * selections for a widget. Called when widget is being
	 * destroyed. This function will not generally be
	 * called by applications.
	 * Params:
	 * widget =  a GtkWidget
	 */
	public static void removeAll(Widget widget);
	
	/**
	 * Warning
	 * gtk_selection_clear has been deprecated since version 2.4 and should not be used in newly-written code. Instead of calling this function, chain up from
	 * your selection-clear-event handler. Calling this function
	 * from any other context is illegal.
	 * The default handler for the "selection-clear-event"
	 * signal.
	 * Since 2.2
	 * Params:
	 * widget =  a GtkWidget
	 * event =  the event
	 * Returns: TRUE if the event was handled, otherwise false
	 */
	public static int clear(Widget widget, GdkEventSelection* event);
	
	/**
	 * Makes a copy of a GtkSelectionData structure and its data.
	 * Params:
	 * data =  a pointer to a GtkSelectionData structure.
	 * Returns: a pointer to a copy of data.
	 */
	public static GtkSelectionData* dataCopy(GtkSelectionData* data);
	
	/**
	 * Frees a GtkSelectionData structure returned from
	 * gtk_selection_data_copy().
	 * Params:
	 * data =  a pointer to a GtkSelectionData structure.
	 */
	public static void dataFree(GtkSelectionData* data);
}
