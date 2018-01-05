module gtkD.gtk.TreeSelection;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.TreeView;
private import gtkD.gtk.TreeModel;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreeIter;
private import gtkD.glib.ListG;
private import gtkD.gtk.TreePath;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreeIter;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The GtkTreeSelection object is a helper object to manage the selection
 * for a GtkTreeView widget. The GtkTreeSelection object is
 * automatically created when a new GtkTreeView widget is created, and
 * cannot exist independentally of this widget. The primary reason the
 * GtkTreeSelection objects exists is for cleanliness of code and API.
 * That is, there is no conceptual reason all these functions could not be
 * methods on the GtkTreeView widget instead of a separate function.
 * The GtkTreeSelection object is gotten from a GtkTreeView by calling
 * gtk_tree_view_get_selection(). It can be manipulated to check the
 * selection status of the tree, as well as select and deselect individual
 * rows. Selection is done completely view side. As a result, multiple
 * views of the same model can have completely different selections.
 * Additionally, you cannot change the selection of a row on the model that
 * is not currently displayed by the view without expanding its parents
 * first.
 * One of the important things to remember when monitoring the selection of
 * a view is that the "changed" signal is mostly a hint. That is, it may
 * only emit one signal when a range of rows is selected. Additionally, it
 * may on occasion emit a ::changed signal when nothing has happened
 * (mostly as a result of programmers calling select_row on an already
 * selected row).
 */
public class TreeSelection : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkTreeSelection* gtkTreeSelection;
	
	
	public GtkTreeSelection* getTreeSelectionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTreeSelection* gtkTreeSelection);
	
	/**
	 * Returns an TreeIter set to the currently selected node if selection
	 * is set to GTK_SELECTION_SINGLE or GTK_SELECTION_BROWSE.
	 * This function will not work if you use selection is GTK_SELECTION_MULTIPLE.
	 * Returns: A TreeIter for the selected node.
	 */
	public TreeIter getSelected();
	
	/**
	 * Creates a list of path of all selected rows. Additionally, if you are
	 * planning on modifying the model after calling this function, you may
	 * want to convert the returned list into a list of GtkTreeRowReferences.
	 * To do this, you can use gtk_tree_row_reference_new().
	 * To free the return value, use:
	 * g_list_foreach (list, gtk_tree_path_free, NULL);
	 * g_list_free (list);
	 * Since 2.2
	 * Params:
	 *  model = A pointer to set to the GtkTreeModel, or NULL.
	 * Returns:
	 *  A GList containing a GtkTreePath for each selected row.
	 */
	TreePath[] getSelectedRows(out TreeModelIF model);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(TreeSelection)[] onChangedListeners;
	/**
	 * Emitted whenever the selection has (possibly) changed. Please note that
	 * this signal is mostly a hint. It may only be emitted once when a range
	 * of rows are selected, and it may occasionally be emitted when nothing
	 * has happened.
	 * See Also
	 * GtkTreeView, GtkTreeViewColumn, GtkTreeDnd, GtkTreeMode, GtkTreeSortable, GtkTreeModelSort, GtkListStore, GtkTreeStore, GtkCellRenderer, GtkCellEditable, GtkCellRendererPixbuf, GtkCellRendererText, GtkCellRendererToggle
	 */
	void addOnChanged(void delegate(TreeSelection) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChanged(GtkTreeSelection* treeselectionStruct, TreeSelection treeSelection);
	
	
	/**
	 * Sets the selection mode of the selection. If the previous type was
	 * GTK_SELECTION_MULTIPLE, then the anchor is kept selected, if it was
	 * previously selected.
	 * Params:
	 * type =  The selection mode
	 */
	public void setMode(GtkSelectionMode type);
	
	/**
	 * Gets the selection mode for selection. See
	 * gtk_tree_selection_set_mode().
	 * Returns: the current selection mode
	 */
	public GtkSelectionMode getMode();
	
	/**
	 * Sets the selection function. If set, this function is called before any node
	 * is selected or unselected, giving some control over which nodes are selected.
	 * The select function should return TRUE if the state of the node may be toggled,
	 * and FALSE if the state of the node should be left unchanged.
	 * Params:
	 * func =  The selection function.
	 * data =  The selection function's data.
	 * destroy =  The destroy function for user data. May be NULL.
	 */
	public void setSelectFunction(GtkTreeSelectionFunc func, void* data, GDestroyNotify destroy);
	
	/**
	 * Returns the current selection function.
	 * Since 2.14
	 * Returns: The function.
	 */
	public GtkTreeSelectionFunc getSelectFunction();
	
	/**
	 * Returns the user data for the selection function.
	 * Returns: The user data.
	 */
	public void* getUserData();
	
	/**
	 * Returns the tree view associated with selection.
	 * Returns: A GtkTreeView
	 */
	public TreeView getTreeView();
	
	/**
	 * Sets iter to the currently selected node if selection is set to
	 * GTK_SELECTION_SINGLE or GTK_SELECTION_BROWSE. iter may be NULL if you
	 * just want to test if selection has any selected nodes. model is filled
	 * with the current model as a convenience. This function will not work if you
	 * use selection is GTK_SELECTION_MULTIPLE.
	 * Params:
	 * model =  A pointer to set to the GtkTreeModel, or NULL.
	 * iter =  The GtkTreeIter, or NULL.
	 * Returns: TRUE, if there is a selected node.
	 */
	public int getSelected(out TreeModelIF model, TreeIter iter);
	
	/**
	 * Calls a function for each selected node. Note that you cannot modify
	 * the tree or selection from within this function. As a result,
	 * gtk_tree_selection_get_selected_rows() might be more useful.
	 * Params:
	 * func =  The function to call for each selected node.
	 * data =  user data to pass to the function.
	 */
	public void selectedForeach(GtkTreeSelectionForeachFunc func, void* data);
	
	/**
	 * Returns the number of rows that have been selected in tree.
	 * Since 2.2
	 * Returns: The number of rows selected.
	 */
	public int countSelectedRows();
	
	/**
	 * Select the row at path.
	 * Params:
	 * path =  The GtkTreePath to be selected.
	 */
	public void selectPath(TreePath path);
	
	/**
	 * Unselects the row at path.
	 * Params:
	 * path =  The GtkTreePath to be unselected.
	 */
	public void unselectPath(TreePath path);
	/**
	 * Returns TRUE if the row pointed to by path is currently selected. If path
	 * does not point to a valid location, FALSE is returned
	 * Params:
	 * path =  A GtkTreePath to check selection on.
	 * Returns: TRUE if path is selected.
	 */
	public int pathIsSelected(TreePath path);
	
	/**
	 * Selects the specified iterator.
	 * Params:
	 * iter =  The GtkTreeIter to be selected.
	 */
	public void selectIter(TreeIter iter);
	
	/**
	 * Unselects the specified iterator.
	 * Params:
	 * iter =  The GtkTreeIter to be unselected.
	 */
	public void unselectIter(TreeIter iter);
	
	/**
	 * Returns TRUE if the row at iter is currently selected.
	 * Params:
	 * iter =  A valid GtkTreeIter
	 * Returns: TRUE, if iter is selected
	 */
	public int iterIsSelected(TreeIter iter);

	/**
	 * Selects all the nodes. selection must be set to GTK_SELECTION_MULTIPLE
	 * mode.
	 */
	public void selectAll();
	
	/**
	 * Unselects all the nodes.
	 */
	public void unselectAll();
	
	/**
	 * Selects a range of nodes, determined by start_path and end_path inclusive.
	 * selection must be set to GTK_SELECTION_MULTIPLE mode.
	 * Params:
	 * startPath =  The initial node of the range.
	 * endPath =  The final node of the range.
	 */
	public void selectRange(TreePath startPath, TreePath endPath);
	
	/**
	 * Unselects a range of nodes, determined by start_path and end_path
	 * inclusive.
	 * Since 2.2
	 * Signal Details
	 * The "changed" signal
	 * void user_function (GtkTreeSelection *treeselection,
	 *  gpointer user_data) : Run First
	 * Emitted whenever the selection has (possibly) changed. Please note that
	 * this signal is mostly a hint. It may only be emitted once when a range
	 * of rows are selected, and it may occasionally be emitted when nothing
	 * has happened.
	 * Params:
	 * startPath =  The initial node of the range.
	 * endPath =  The initial node of the range.
	 */
	public void unselectRange(TreePath startPath, TreePath endPath);
}
