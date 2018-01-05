module gtkD.gtk.TreeModelFilter;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.TreeModel;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreePath;
private import gtkD.gtk.TreeIter;
private import gtkD.gtk.TreeModelT;
private import gtkD.gtk.TreeDragSourceT;
private import gtkD.gtk.TreeDragSourceIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkTreeModelFilter is a tree model which wraps another tree model,
 * and can do the following things:
 * Filter specific rows, based on data from a "visible column", a column
 * storing booleans indicating whether the row should be filtered or not,
 * or based on the return value of a "visible function", which gets a
 * model, iter and user_data and returns a boolean indicating whether the
 * row should be filtered or not.
 * Modify the "appearance" of the model, using a modify function.
 * This is extremely powerful and allows for just changing
 * some values and also for creating a completely different model based on
 * the given child model.
 * Set a different root node, also known as a "virtual root". You can pass in
 * a GtkTreePath indicating the root node for the filter at construction time.
 */
public class TreeModelFilter : ObjectG, TreeModelIF, TreeDragSourceIF
{
	
	/** the main Gtk struct */
	protected GtkTreeModelFilter* gtkTreeModelFilter;
	
	
	public GtkTreeModelFilter* getTreeModelFilterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTreeModelFilter* gtkTreeModelFilter);
	
	// add the TreeModel capabilities
	mixin TreeModelT!(GtkTreeModelFilter);
	
	// add the TreeDragSource capabilities
	mixin TreeDragSourceT!(GtkTreeModelFilter);
	
	/**
	 */
	
	/**
	 * Creates a new GtkTreeModel, with child_model as the child_model
	 * and root as the virtual root.
	 * Since 2.4
	 * Params:
	 * childModel =  A GtkTreeModel.
	 * root =  A GtkTreePath or NULL.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (TreeModelIF childModel, TreePath root);
	
	/**
	 * Sets the visible function used when filtering the filter to be func. The
	 * function should return TRUE if the given row should be visible and
	 * FALSE otherwise.
	 * If the condition calculated by the function changes over time (e.g. because
	 * it depends on some global parameters), you must call
	 * gtk_tree_model_filter_refilter() to keep the visibility information of
	 * the model uptodate.
	 * Note that func is called whenever a row is inserted, when it may still be
	 * empty. The visible function should therefore take special care of empty
	 * rows, like in the example below.
	 * static gboolean
	 * visible_func (GtkTreeModel *model,
	 *  GtkTreeIter *iter,
	 *  gpointer data)
	 * {
		 *  /+* Visible if row is non-empty and first column is "HI" +/
		 *  gchar *str;
		 *  gboolean visible = FALSE;
		 *  gtk_tree_model_get (model, iter, 0, str, -1);
		 *  if (str  strcmp (str, "HI") == 0)
		 *  visible = TRUE;
		 *  g_free (str);
		 *  return visible;
	 * }
	 * Since 2.4
	 * Params:
	 * func =  A GtkTreeModelFilterVisibleFunc, the visible function.
	 * data =  User data to pass to the visible function, or NULL.
	 * destroy =  Destroy notifier of data, or NULL.
	 */
	public void setVisibleFunc(GtkTreeModelFilterVisibleFunc func, void* data, GDestroyNotify destroy);
	
	/**
	 * With the n_columns and types parameters, you give an array of column
	 * types for this model (which will be exposed to the parent model/view).
	 * The func, data and destroy parameters are for specifying the modify
	 * function. The modify function will get called for each
	 * data access, the goal of the modify function is to return the data which
	 * should be displayed at the location specified using the parameters of the
	 * modify function.
	 * Since 2.4
	 * Params:
	 * types =  The GTypes of the columns.
	 * func =  A GtkTreeModelFilterModifyFunc
	 * data =  User data to pass to the modify function, or NULL.
	 * destroy =  Destroy notifier of data, or NULL.
	 */
	public void setModifyFunc(GType[] types, GtkTreeModelFilterModifyFunc func, void* data, GDestroyNotify destroy);
	
	/**
	 * Sets column of the child_model to be the column where filter should
	 * look for visibility information. columns should be a column of type
	 * G_TYPE_BOOLEAN, where TRUE means that a row is visible, and FALSE
	 * if not.
	 * Since 2.4
	 * Params:
	 * column =  A gint which is the column containing the visible information.
	 */
	public void setVisibleColumn(int column);
	
	/**
	 * Returns a pointer to the child model of filter.
	 * Since 2.4
	 * Returns: A pointer to a GtkTreeModel.
	 */
	public TreeModelIF getModel();
	
	/**
	 * Sets filter_iter to point to the row in filter that corresponds to the
	 * row pointed at by child_iter. If filter_iter was not set, FALSE is
	 * returned.
	 * Since 2.4
	 * Params:
	 * filter =  A GtkTreeModelFilter.
	 * filterIter =  An uninitialized GtkTreeIter.
	 * childIter =  A valid GtkTreeIter pointing to a row on the child model.
	 * Returns: TRUE, if filter_iter was set, i.e. if child_iter is avalid iterator pointing to a visible row in child model.
	 */
	public int convertChildIterToIter(TreeIter filterIter, TreeIter childIter);
	
	/**
	 * Sets child_iter to point to the row pointed to by filter_iter.
	 * Since 2.4
	 * Params:
	 * filter =  A GtkTreeModelFilter.
	 * childIter =  An uninitialized GtkTreeIter.
	 * filterIter =  A valid GtkTreeIter pointing to a row on filter.
	 */
	public void convertIterToChildIter(TreeIter childIter, TreeIter filterIter);
	
	/**
	 * Converts child_path to a path relative to filter. That is, child_path
	 * points to a path in the child model. The rerturned path will point to the
	 * same row in the filtered model. If child_path isn't a valid path on the
	 * child model or points to a row which is not visible in filter, then NULL
	 * is returned.
	 * Since 2.4
	 * Params:
	 * childPath =  A GtkTreePath to convert.
	 * Returns: A newly allocated GtkTreePath, or NULL.
	 */
	public TreePath convertChildPathToPath(TreePath childPath);
	
	/**
	 * Converts filter_path to a path on the child model of filter. That is,
	 * filter_path points to a location in filter. The returned path will
	 * point to the same location in the model not being filtered. If filter_path
	 * does not point to a location in the child model, NULL is returned.
	 * Since 2.4
	 * Params:
	 * filter =  A GtkTreeModelFilter.
	 * filterPath =  A GtkTreePath to convert.
	 * Returns: A newly allocated GtkTreePath, or NULL.
	 */
	public TreePath convertPathToChildPath(TreePath filterPath);
	
	/**
	 * Emits ::row_changed for each row in the child model, which causes
	 * the filter to re-evaluate whether a row is visible or not.
	 * Since 2.4
	 * Params:
	 * filter =  A GtkTreeModelFilter.
	 */
	public void refilter();
	
	/**
	 * This function should almost never be called. It clears the filter
	 * of any cached iterators that haven't been reffed with
	 * gtk_tree_model_ref_node(). This might be useful if the child model
	 * being filtered is static (and doesn't change often) and there has been
	 * a lot of unreffed access to nodes. As a side effect of this function,
	 * all unreffed iters will be invalid.
	 * Since 2.4
	 */
	public void clearCache();
}
