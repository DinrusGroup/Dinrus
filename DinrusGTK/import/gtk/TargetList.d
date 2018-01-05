module gtkD.gtk.TargetList;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


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
public class TargetList
{
	
	/** the main Gtk struct */
	protected GtkTargetList* gtkTargetList;
	
	
	public GtkTargetList* getTargetListStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTargetList* gtkTargetList);
	
	/**
	 */
	
	/**
	 * Creates a new GtkTargetList from an array of GtkTargetEntry.
	 * Params:
	 * targets =  Pointer to an array of GtkTargetEntry
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GtkTargetEntry[] targets);
	
	/**
	 * Increases the reference count of a GtkTargetList by one.
	 * Returns: the passed in GtkTargetList.
	 */
	public TargetList doref();
	
	/**
	 * Decreases the reference count of a GtkTargetList by one.
	 * If the resulting reference count is zero, frees the list.
	 */
	public void unref();
	
	/**
	 * Appends another target to a GtkTargetList.
	 * Params:
	 * target =  the interned atom representing the target
	 * flags =  the flags for this target
	 * info =  an ID that will be passed back to the application
	 */
	public void add(GdkAtom target, uint flags, uint info);
	
	/**
	 * Prepends a table of GtkTargetEntry to a target list.
	 * Params:
	 * targets =  the table of GtkTargetEntry
	 */
	public void addTable(GtkTargetEntry[] targets);
	
	/**
	 * Appends the text targets supported by GtkSelection to
	 * the target list. All targets are added with the same info.
	 * Since 2.6
	 * Params:
	 * info =  an ID that will be passed back to the application
	 */
	public void addTextTargets(uint info);
	
	/**
	 * Appends the image targets supported by GtkSelection to
	 * the target list. All targets are added with the same info.
	 * Since 2.6
	 * Params:
	 * info =  an ID that will be passed back to the application
	 * writable =  whether to add only targets for which GTK+ knows
	 *  how to convert a pixbuf into the format
	 */
	public void addImageTargets(uint info, int writable);
	
	/**
	 * Appends the URI targets supported by GtkSelection to
	 * the target list. All targets are added with the same info.
	 * Since 2.6
	 * Params:
	 * info =  an ID that will be passed back to the application
	 */
	public void addUriTargets(uint info);
	
	/**
	 * Appends the rich text targets registered with
	 * gtk_text_buffer_register_serialize_format() or
	 * gtk_text_buffer_register_deserialize_format() to the target list. All
	 * targets are added with the same info.
	 * Since 2.10
	 * Params:
	 * info =  an ID that will be passed back to the application
	 * deserializable =  if TRUE, then deserializable rich text formats
	 *  will be added, serializable formats otherwise.
	 * buffer =  a GtkTextBuffer.
	 */
	public void addRichTextTargets(uint info, int deserializable, TextBuffer buffer);
	
	/**
	 * Removes a target from a target list.
	 * Params:
	 * target =  the interned atom representing the target
	 */
	public void remove(GdkAtom target);
	
	/**
	 * Looks up a given target in a GtkTargetList.
	 * Params:
	 * target =  an interned atom representing the target to search for
	 * info =  a pointer to the location to store application info for target,
	 *  or NULL
	 * Returns: TRUE if the target was found, otherwise FALSE
	 */
	public int find(GdkAtom target, out uint info);
	
	/**
	 * This function frees a target table as returned by
	 * gtk_target_table_new_from_list()
	 * Since 2.10
	 * Params:
	 * targets =  a GtkTargetEntry array
	 * nTargets =  the number of entries in the array
	 */
	public static void gtkTargetTableFree(GtkTargetEntry[] targets, int nTargets);
	
	/**
	 * This function creates an GtkTargetEntry array that contains the
	 * same targets as the passed list. The returned table is newly
	 * allocated and should be freed using gtk_target_table_free() when no
	 * longer needed.
	 * Since 2.10
	 * Returns: the new table.
	 */
	public GtkTargetEntry[] gtkTargetTableNewFromList();
	
	/**
	 * Determines if any of the targets in targets can be used to
	 * provide a GdkPixbuf.
	 * Since 2.10
	 * Params:
	 * targets =  an array of GdkAtoms
	 * writable =  whether to accept only targets for which GTK+ knows
	 *  how to convert a pixbuf into the format
	 * Returns: TRUE if targets include a suitable target for images, otherwise FALSE.
	 */
	public static int gtkTargetsIncludeImage(GdkAtom[] targets, int writable);
	
	/**
	 * Determines if any of the targets in targets can be used to
	 * provide text.
	 * Since 2.10
	 * Params:
	 * targets =  an array of GdkAtoms
	 * Returns: TRUE if targets include a suitable target for text, otherwise FALSE.
	 */
	public static int gtkTargetsIncludeText(GdkAtom[] targets);

	/**
	 * Determines if any of the targets in targets can be used to
	 * provide an uri list.
	 * Since 2.10
	 * Params:
	 * targets =  an array of GdkAtoms
	 * Returns: TRUE if targets include a suitable target for uri lists, otherwise FALSE.
	 */
	public static int gtkTargetsIncludeUri(GdkAtom[] targets);
	
	/**
	 * Determines if any of the targets in targets can be used to
	 * provide rich text.
	 * Since 2.10
	 * Params:
	 * targets =  an array of GdkAtoms
	 * buffer =  a GtkTextBuffer
	 * Returns: TRUE if targets include a suitable target for rich text, otherwise FALSE.
	 */
	public static int gtkTargetsIncludeRichText(GdkAtom[] targets, TextBuffer buffer);
}
