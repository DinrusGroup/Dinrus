module gtkD.gtk.TreeStore;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.TreeIter;
private import gtkD.gobject.Value;
private import gtkD.gtk.TreeNode;
private import gtkD.gdk.Pixbuf;;
private import gtkD.gobject.Value;;
private import gtkD.gtk.TreeModelT;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreeDragSourceT;
private import gtkD.gtk.TreeDragSourceIF;
private import gtkD.gtk.TreeDragDestT;
private import gtkD.gtk.TreeDragDestIF;
private import gtkD.gtk.TreeSortableT;
private import gtkD.gtk.TreeSortableIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The GtkTreeStore object is a list model for use with a GtkTreeView
 * widget. It implements the GtkTreeModel interface, and consequentialy,
 * can use all of the methods available there. It also implements the
 * GtkTreeSortable interface so it can be sorted by the view. Finally,
 * it also implements the tree drag and
 * drop interfaces.
 * GtkTreeStore as GtkBuildable
 * The GtkTreeStore implementation of the GtkBuildable interface allows
 * to specify the model columns with a <columns> element that may
 * contain multiple <column> elements, each specifying one model
 * column. The "type" attribute specifies the data type for the column.
 * Example 28. A UI Definition fragment for a tree store
 * <object class="GtkTreeStore">
 *  <columns>
 *  <column type="gchararray"/>
 *  <column type="gchararray"/>
 *  <column type="gint"/>
 *  </columns>
 * </object>
 */
public class TreeStore : ObjectG, TreeModelIF, TreeDragSourceIF, TreeDragDestIF, TreeSortableIF
{
	
	/** the main Gtk struct */
	protected GtkTreeStore* gtkTreeStore;
	
	
	public GtkTreeStore* getTreeStoreStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTreeStore* gtkTreeStore);
	
	// add the TreeModel capabilities
	mixin TreeModelT!(GtkTreeStore);
	
	// add the TreeDragSource capabilities
	mixin TreeDragSourceT!(GtkTreeStore);
	
	// add the TreeDragDest capabilities
	mixin TreeDragDestT!(GtkTreeStore);
	
	// add the TreeSortable capabilities
	mixin TreeSortableT!(GtkTreeStore);
	
	/**
	 * Creates a top level iteractor.
	 * I don't think lists have but the top level iteractor
	 */
	TreeIter createIter(TreeIter parent=null);
	
	/**
	 * Sets one value into one cells.
	 * \todo confirm we need to destroy the Value instance
	 * Params:
	 *  iter = the tree iteractor, effectivly the row
	 *  column = to column number to set
	 *  value = the value
	 */
	void setValue(TreeIter iter, int column, string value);
	
	/** */
	void setValue(TreeIter iter, int column, int value);
	
	
	
	/**
	 * \todo confirm we need to destroy the Value instance
	 */
	void setValue(TreeIter iter, int column, Pixbuf pixbuf);
	
	
	/**
	 * sets the values for one row
	 * Params:
	 *  iter = the row iteractor
	 *  columns = an arrays with the columns to set
	 *  values = an arrays with the values
	 */
	void set(TreeIter iter, int [] columns, char*[] values);
	
	/** */
	void set(TreeIter iter, int [] columns, string[] values);
	
	/**
	 * Sets an iteractor values from a tree node.
	 * This is the way to add a new row to the tree,
	 * the iteractor is either a top level iteractor created from createIter()
	 * or a nested iteractor created from append()
	 * Params:
	 *  iter = the iteractor to set
	 *  treeNode = the tree node
	 * See_Also: createIter(), append()
	 */
	void set(TreeIter iter, TreeNode treeNode);
	
	
	/**
	 * Creates and prepends a new row to tree_store. If parent is non-NULL, then it will prepend
	 * the new row before the first child of parent, otherwise it will prepend a row
	 * to the top level. iter will be changed to point to this new row. The row
	 * will be empty after this function is called. To fill in values, you need to
	 * call gtk_tree_store_set() or gtk_tree_store_set_value().
	 * Params:
	 *  parent = A valid GtkTreeIter, or NULL
	 */
	public TreeIter prepend(TreeIter parent);
	
	/**
	 * Creates and appends a new row to tree_store. If parent is non-NULL, then it will append the
	 * new row after the last child of parent, otherwise it will append a row to
	 * the top level. iter will be changed to point to this new row. The row will
	 * be empty after this function is called. To fill in values, you need to call
	 * gtk_tree_store_set() or gtk_tree_store_set_value().
	 * Params:
	 *  parent = A valid GtkTreeIter, or NULL
	 */
	public TreeIter append(TreeIter parent);
	
	/**
	 */
	
	/**
	 * Non vararg creation function. Used primarily by language bindings.
	 * Params:
	 * types =  an array of GType types for the columns, from first to last
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GType[] types);
	
	/**
	 * This function is meant primarily for GObjects that inherit from
	 * GtkTreeStore, and should only be used when constructing a new
	 * GtkTreeStore. It will not function after a row has been added,
	 * or a method on the GtkTreeModel interface is called.
	 * Params:
	 * types =  An array of GType types, one for each column
	 */
	public void setColumnTypes(GType[] types);
	
	/**
	 * Sets the data in the cell specified by iter and column.
	 * The type of value must be convertible to the type of the
	 * column.
	 * Params:
	 * iter =  A valid GtkTreeIter for the row being modified
	 * column =  column number to modify
	 * value =  new value for the cell
	 */
	public void setValue(TreeIter iter, int column, Value value);
	
	/**
	 * See gtk_tree_store_set(); this version takes a va_list for
	 * use by language bindings.
	 * Params:
	 * iter =  A valid GtkTreeIter for the row being modified
	 * varArgs =  va_list of column/value pairs
	 */
	public void setValist(TreeIter iter, void* varArgs);
	
	/**
	 * A variant of gtk_tree_store_set_valist() which takes
	 * the columns and values as two arrays, instead of varargs. This
	 * function is mainly intended for language bindings or in case
	 * the number of columns to change is not known until run-time.
	 * Since 2.12
	 * Params:
	 * iter =  A valid GtkTreeIter for the row being modified
	 * columns =  an array of column numbers
	 * values =  an array of GValues
	 */
	public void setValuesv(TreeIter iter, int[] columns, GValue[] values);
	
	/**
	 * Removes iter from tree_store. After being removed, iter is set to the
	 * next valid row at that level, or invalidated if it previously pointed to the
	 * last one.
	 * Params:
	 * iter =  A valid GtkTreeIter
	 * Returns: TRUE if iter is still valid, FALSE if not.
	 */
	public int remove(TreeIter iter);
	
	/**
	 * Creates a new row at position. If parent is non-NULL, then the row will be
	 * made a child of parent. Otherwise, the row will be created at the toplevel.
	 * If position is larger than the number of rows at that level, then the new
	 * row will be inserted to the end of the list. iter will be changed to point
	 * to this new row. The row will be empty after this function is called. To
	 * fill in values, you need to call gtk_tree_store_set() or
	 * gtk_tree_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the new row
	 * parent =  A valid GtkTreeIter, or NULL
	 * position =  position to insert the new row
	 */
	public void insert(TreeIter iter, TreeIter parent, int position);
	
	/**
	 * Inserts a new row before sibling. If sibling is NULL, then the row will
	 * be appended to parent 's children. If parent and sibling are NULL, then
	 * the row will be appended to the toplevel. If both sibling and parent are
	 * set, then parent must be the parent of sibling. When sibling is set,
	 * parent is optional.
	 * iter will be changed to point to this new row. The row will be empty after
	 * this function is called. To fill in values, you need to call
	 * gtk_tree_store_set() or gtk_tree_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the new row
	 * parent =  A valid GtkTreeIter, or NULL
	 * sibling =  A valid GtkTreeIter, or NULL
	 */
	public void insertBefore(TreeIter iter, TreeIter parent, TreeIter sibling);
	
	/**
	 * Inserts a new row after sibling. If sibling is NULL, then the row will be
	 * prepended to parent 's children. If parent and sibling are NULL, then
	 * the row will be prepended to the toplevel. If both sibling and parent are
	 * set, then parent must be the parent of sibling. When sibling is set,
	 * parent is optional.
	 * iter will be changed to point to this new row. The row will be empty after
	 * this function is called. To fill in values, you need to call
	 * gtk_tree_store_set() or gtk_tree_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the new row
	 * parent =  A valid GtkTreeIter, or NULL
	 * sibling =  A valid GtkTreeIter, or NULL
	 */
	public void insertAfter(TreeIter iter, TreeIter parent, TreeIter sibling);
	
	/**
	 * A variant of gtk_tree_store_insert_with_values() which takes
	 * the columns and values as two arrays, instead of varargs. This
	 * function is mainly intended for language bindings.
	 * Since 2.10
	 * Params:
	 * iter =  An unset GtkTreeIter to set the new row, or NULL.
	 * parent =  A valid GtkTreeIter, or NULL
	 * position =  position to insert the new row
	 * columns =  an array of column numbers
	 * values =  an array of GValues
	 */
	public void insertWithValuesv(TreeIter iter, TreeIter parent, int position, int[] columns, GValue[] values);
	
	/**
	 * Prepends a new row to tree_store. If parent is non-NULL, then it will prepend
	 * the new row before the first child of parent, otherwise it will prepend a row
	 * to the top level. iter will be changed to point to this new row. The row
	 * will be empty after this function is called. To fill in values, you need to
	 * call gtk_tree_store_set() or gtk_tree_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the prepended row
	 * parent =  A valid GtkTreeIter, or NULL
	 */
	public void prepend(TreeIter iter, TreeIter parent);
	
	/**
	 * Appends a new row to tree_store. If parent is non-NULL, then it will append the
	 * new row after the last child of parent, otherwise it will append a row to
	 * the top level. iter will be changed to point to this new row. The row will
	 * be empty after this function is called. To fill in values, you need to call
	 * gtk_tree_store_set() or gtk_tree_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the appended row
	 * parent =  A valid GtkTreeIter, or NULL
	 */
	public void append(TreeIter iter, TreeIter parent);
	
	/**
	 * Returns TRUE if iter is an ancestor of descendant. That is, iter is the
	 * parent (or grandparent or great-grandparent) of descendant.
	 * Params:
	 * iter =  A valid GtkTreeIter
	 * descendant =  A valid GtkTreeIter
	 * Returns: TRUE, if iter is an ancestor of descendant
	 */
	public int isAncestor(TreeIter iter, TreeIter descendant);
	
	/**
	 * Returns the depth of iter. This will be 0 for anything on the root level, 1
	 * for anything down a level, etc.
	 * Params:
	 * iter =  A valid GtkTreeIter
	 * Returns: The depth of iter
	 */
	public int iterDepth(TreeIter iter);
	
	/**
	 * Removes all rows from tree_store
	 */
	public void clear();
	
	/**
	 * WARNING: This function is slow. Only use it for debugging and/or testing
	 * purposes.
	 * Checks if the given iter is a valid iter for this GtkTreeStore.
	 * Since 2.2
	 * Params:
	 * iter =  A GtkTreeIter.
	 * Returns: TRUE if the iter is valid, FALSE if the iter is invalid.
	 */
	public int iterIsValid(TreeIter iter);
	
	/**
	 * Reorders the children of parent in tree_store to follow the order
	 * indicated by new_order. Note that this function only works with
	 * unsorted stores.
	 * Since 2.2
	 * Params:
	 * parent =  A GtkTreeIter.
	 * newOrder =  an array of integers mapping the new position of each child
	 *  to its old position before the re-ordering,
	 *  i.e. new_order[newpos] = oldpos.
	 */
	public void reorder(TreeIter parent, int[] newOrder);
	
	/**
	 * Swaps a and b in the same level of tree_store. Note that this function
	 * only works with unsorted stores.
	 * Since 2.2
	 * Params:
	 * a =  A GtkTreeIter.
	 * b =  Another GtkTreeIter.
	 */
	public void swap(TreeIter a, TreeIter b);
	
	/**
	 * Moves iter in tree_store to the position before position. iter and
	 * position should be in the same level. Note that this function only
	 * works with unsorted stores. If position is NULL, iter will be
	 * moved to the end of the level.
	 * Since 2.2
	 * Params:
	 * iter =  A GtkTreeIter.
	 * position =  A GtkTreeIter or NULL.
	 */
	public void moveBefore(TreeIter iter, TreeIter position);
	
	/**
	 * Moves iter in tree_store to the position after position. iter and
	 * position should be in the same level. Note that this function only
	 * works with unsorted stores. If position is NULL, iter will be moved
	 * to the start of the level.
	 * Since 2.2
	 * Params:
	 * iter =  A GtkTreeIter.
	 * position =  A GtkTreeIter.
	 */
	public void moveAfter(TreeIter iter, TreeIter position);
}
