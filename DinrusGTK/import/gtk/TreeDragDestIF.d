module gtkD.gtk.TreeDragDestIF;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreePath;




/**
 * Description
 * GTK+ supports Drag-and-Drop in tree views with a high-level and a low-level
 * API.
 * The low-level API consists of the GTK+ DND API, augmented by some treeview
 * utility functions: gtk_tree_view_set_drag_dest_row(),
 * gtk_tree_view_get_drag_dest_row(), gtk_tree_view_get_dest_row_at_pos(),
 * gtk_tree_view_create_row_drag_icon(), gtk_tree_set_row_drag_data() and
 * gtk_tree_get_row_drag_data(). This API leaves a lot of flexibility, but
 * nothing is done automatically, and implementing advanced features like
 * hover-to-open-rows or autoscrolling on top of this API is a lot of work.
 * On the other hand, if you write to the high-level API, then all the
 * bookkeeping of rows is done for you, as well as things like hover-to-open
 * and auto-scroll, but your models have to implement the
 * GtkTreeDragSource and GtkTreeDragDest interfaces.
 */
public interface TreeDragDestIF
{
	
	
	public GtkTreeDragDest* getTreeDragDestTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 * Sets selection data of target type GTK_TREE_MODEL_ROW. Normally used
	 * in a drag_data_get handler.
	 * Params:
	 * selectionData =  some GtkSelectionData
	 * treeModel =  a GtkTreeModel
	 * path =  a row in tree_model
	 * Returns: TRUE if the GtkSelectionData had the proper target type to allow us to set a tree row
	 */
	public static int setRowDragData(GtkSelectionData* selectionData, TreeModelIF treeModel, TreePath path);
	
	/**
	 * Obtains a tree_model and path from selection data of target type
	 * GTK_TREE_MODEL_ROW. Normally called from a drag_data_received handler.
	 * This function can only be used if selection_data originates from the same
	 * process that's calling this function, because a pointer to the tree model
	 * is being passed around. If you aren't in the same process, then you'll
	 * get memory corruption. In the GtkTreeDragDest drag_data_received handler,
	 * you can assume that selection data of type GTK_TREE_MODEL_ROW is
	 * in from the current process. The returned path must be freed with
	 * gtk_tree_path_free().
	 * Params:
	 * selectionData =  a GtkSelectionData
	 * treeModel =  a GtkTreeModel
	 * path =  row in tree_model
	 * Returns: TRUE if selection_data had target type GTK_TREE_MODEL_ROW and is otherwise valid
	 */
	public static int getRowDragData(GtkSelectionData* selectionData, GtkTreeModel** treeModel, GtkTreePath** path);
	
	/**
	 */
	
	/**
	 * Asks the GtkTreeDragDest to insert a row before the path dest,
	 * deriving the contents of the row from selection_data. If dest is
	 * outside the tree so that inserting before it is impossible, FALSE
	 * will be returned. Also, FALSE may be returned if the new row is
	 * not created for some model-specific reason. Should robustly handle
	 * a dest no longer found in the model!
	 * Params:
	 * dest =  row to drop in front of
	 * selectionData =  data to drop
	 * Returns: whether a new row was created before position dest
	 */
	public int dragDataReceived(TreePath dest, GtkSelectionData* selectionData);
	
	/**
	 * Determines whether a drop is possible before the given dest_path,
	 * at the same depth as dest_path. i.e., can we drop the data in
	 * selection_data at that location. dest_path does not have to
	 * exist; the return value will almost certainly be FALSE if the
	 * parent of dest_path doesn't exist, though.
	 * Params:
	 * destPath =  destination row
	 * selectionData =  the data being dragged
	 * Returns: TRUE if a drop is possible before dest_path
	 */
	public int rowDropPossible(TreePath destPath, GtkSelectionData* selectionData);
}
