module gtkD.gtk.ListStore;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.TreeModel;
private import gtkD.glib.Str;
private import gtkD.gtk.TreeIter;
private import gtkD.gobject.Value;
private import gtkD.gtk.BuildableIF;
private import gtkD.gtk.BuildableT;
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
 * The GtkListStore object is a list model for use with a GtkTreeView
 * widget. It implements the GtkTreeModel interface, and consequentialy,
 * can use all of the methods available there. It also implements the
 * GtkTreeSortable interface so it can be sorted by the view.
 * Finally, it also implements the tree drag and
 * drop interfaces.
 * The GtkListStore can accept most GObject types as a column type, though
 * it can't accept all custom types. Internally, it will keep a copy of
 * data passed in (such as a string or a boxed pointer). Columns that
 * accept GObjects are handled a little differently. The
 * GtkListStore will keep a reference to the object instead of copying the
 * value. As a result, if the object is modified, it is up to the
 * application writer to call gtk_tree_model_row_changed to emit the
 * "row_changed" signal. This most commonly affects lists with
 * GdkPixbufs stored.
 * Example 26. Creating a simple list store.
 * enum {
	 *  COLUMN_STRING,
	 *  COLUMN_INT,
	 *  COLUMN_BOOLEAN,
	 *  N_COLUMNS
 * };
 * {
	 *  GtkListStore *list_store;
	 *  GtkTreePath *path;
	 *  GtkTreeIter iter;
	 *  gint i;
	 *  list_store = gtk_list_store_new (N_COLUMNS,
	 *  G_TYPE_STRING,
	 *  G_TYPE_INT,
	 *  G_TYPE_BOOLEAN);
	 *  for (i = 0; i < 10; i++)
	 *  {
		 *  gchar *some_data;
		 *  some_data = get_some_data (i);
		 *  /+* Add a new row to the model +/
		 *  gtk_list_store_append (list_store, iter);
		 *  gtk_list_store_set (list_store, iter,
		 *  COLUMN_STRING, some_data,
		 *  COLUMN_INT, i,
		 *  COLUMN_BOOLEAN, FALSE,
		 *  -1);
		 *  /+* As the store will keep a copy of the string internally, we
		 *  * free some_data.
		 *  +/
		 *  g_free (some_data);
	 *  }
	 *  /+* Modify a particular row +/
	 *  path = gtk_tree_path_new_from_string ("4");
	 *  gtk_tree_model_get_iter (GTK_TREE_MODEL (list_store),
	 *  iter,
	 *  path);
	 *  gtk_tree_path_free (path);
	 *  gtk_list_store_set (list_store, iter,
	 *  COLUMN_BOOLEAN, TRUE,
	 *  -1);
 * }
 * Performance Considerations
 * Internally, the GtkListStore was implemented with a linked list with a
 * tail pointer prior to GTK+ 2.6. As a result, it was fast at data
 * insertion and deletion, and not fast at random data access. The
 * GtkListStore sets the GTK_TREE_MODEL_ITERS_PERSIST flag, which means
 * that GtkTreeIters can be cached while the row exists. Thus, if
 * access to a particular row is needed often and your code is expected to
 * run on older versions of GTK+, it is worth keeping the iter around.
 * It is important to note that only the methods
 * gtk_list_store_insert_with_values() and gtk_list_store_insert_with_valuesv()
 * are atomic, in the sense that the row is being appended to the store and the
 * values filled in in a single operation with regard to GtkTreeModel signaling.
 * In contrast, using e.g. gtk_list_store_append() and then gtk_list_store_set()
 * will first create a row, which triggers the "row-inserted" signal
 * on GtkListStore. The row, however, is still empty, and any signal handler
 * connecting to "row-inserted" on this particular store should be prepared
 * for the situation that the row might be empty. This is especially important
 * if you are wrapping the GtkListStore inside a GtkTreeModelFilter and are
 * using a GtkTreeModelFilterVisibleFunc. Using any of the non-atomic operations
 * to append rows to the GtkListStore will cause the
 * GtkTreeModelFilterVisibleFunc to be visited with an empty row first; the
 * function must be prepared for that.
 * <hr>
 * GtkListStore as GtkBuildable
 * The GtkListStore implementation of the GtkBuildable interface allows
 * to specify the model columns with a <columns> element that may
 * contain multiple <column> elements, each specifying one model
 * column. The "type" attribute specifies the data type for the column.
 * Additionally, it is possible to specify content for the list store
 * in the UI definition, with the <data> element. It can contain
 * multiple <row> elements, each specifying to content for one
 * row of the list model. Inside a <row>, the <col> elements
 * specify the content for individual cells.
 * Note that it is probably more common to define your models
 * in the code, and one might consider it a layering violation
 * to specify the content of a list store in a UI definition,
 * data, not presentation,
 * and common wisdom is to separate the two, as far as possible.
 * Example 27. A UI Definition fragment for a list store
 * <object class="GtkListStore">
 *  <columns>
 *  <column type="gchararray"/>
 *  <column type="gchararray"/>
 *  <column type="gint"/>
 *  </columns>
 *  <data>
 *  <row>
 *  <col id="0">John</col>
 *  <col id="1">Doe</col>
 *  <col id="2">25</col>
 *  </row>
 *  <row>
 *  <col id="0">Johan</col>
 *  <col id="1">Dahlin</col>
 *  <col id="2">50</col>
 *  </row>
 *  </data>
 * </object>
 */
public class ListStore : ObjectG, BuildableIF, TreeModelIF, TreeDragSourceIF, TreeDragDestIF, TreeSortableIF
{
	
	/** the main Gtk struct */
	protected GtkListStore* gtkListStore;
	
	
	public GtkListStore* getListStoreStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkListStore* gtkListStore);
	
	// add the Buildable capabilities
	mixin BuildableT!(GtkListStore);
	
	// add the TreeModel capabilities
	mixin TreeModelT!(GtkListStore);
	
	// add the TreeDragSource capabilities
	mixin TreeDragSourceT!(GtkListStore);
	
	// add the TreeDragDest capabilities
	mixin TreeDragDestT!(GtkListStore);
	
	// add the TreeSortable capabilities
	mixin TreeSortableT!(GtkListStore);
	
	/**
	 * Creates a top level iteractor.
	 * I don't think lists have but the top level iteractor
	 */
	TreeIter createIter();
	
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
	
	/** */
	void setValue(TreeIter iter, int column, string value);
	
	/** */
	void setValue(TreeIter iter, int column, int value);
	
	/**
	 */
	
	/**
	 * Non-vararg creation function. Used primarily by language bindings.
	 * Params:
	 * types =  an array of GType types for the columns, from first to last
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GType[] types);
	
	/**
	 * This function is meant primarily for GObjects that inherit from GtkListStore,
	 * and should only be used when constructing a new GtkListStore. It will not
	 * function after a row has been added, or a method on the GtkTreeModel
	 * interface is called.
	 * Params:
	 * types =  An array length n of GTypes
	 */
	public void setColumnTypes(GType[] types);
	
	/**
	 * See gtk_list_store_set(); this version takes a va_list for use by language
	 * bindings.
	 * Params:
	 * iter =  A valid GtkTreeIter for the row being modified
	 * varArgs =  va_list of column/value pairs
	 */
	public void setValist(TreeIter iter, void* varArgs);
	
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
	 * A variant of gtk_list_store_set_valist() which
	 * takes the columns and values as two arrays, instead of
	 * varargs. This function is mainly intended for
	 * language-bindings and in case the number of columns to
	 * change is not known until run-time.
	 * Since 2.12
	 * Params:
	 * iter =  A valid GtkTreeIter for the row being modified
	 * columns =  an array of column numbers
	 * values =  an array of GValues
	 */
	public void setValuesv(TreeIter iter, int[] columns, GValue[] values);
	
	/**
	 * Removes the given row from the list store. After being removed,
	 * iter is set to be the next valid row, or invalidated if it pointed
	 * to the last row in list_store.
	 * Params:
	 * iter =  A valid GtkTreeIter
	 * Returns: TRUE if iter is valid, FALSE if not.
	 */
	public int remove(TreeIter iter);
	
	/**
	 * Creates a new row at position. iter will be changed to point to this new
	 * row. If position is larger than the number of rows on the list, then the
	 * new row will be appended to the list. The row will be empty after this
	 * function is called. To fill in values, you need to call
	 * gtk_list_store_set() or gtk_list_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the new row
	 * position =  position to insert the new row
	 */
	public void insert(TreeIter iter, int position);
	
	/**
	 * Inserts a new row before sibling. If sibling is NULL, then the row will
	 * be appended to the end of the list. iter will be changed to point to this
	 * new row. The row will be empty after this function is called. To fill in
	 * values, you need to call gtk_list_store_set() or gtk_list_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the new row
	 * sibling =  A valid GtkTreeIter, or NULL
	 */
	public void insertBefore(TreeIter iter, TreeIter sibling);
	
	/**
	 * Inserts a new row after sibling. If sibling is NULL, then the row will be
	 * prepended to the beginning of the list. iter will be changed to point to
	 * this new row. The row will be empty after this function is called. To fill
	 * in values, you need to call gtk_list_store_set() or gtk_list_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the new row
	 * sibling =  A valid GtkTreeIter, or NULL
	 */
	public void insertAfter(TreeIter iter, TreeIter sibling);
	
	/**
	 * A variant of gtk_list_store_insert_with_values() which
	 * takes the columns and values as two arrays, instead of
	 * varargs. This function is mainly intended for
	 * language-bindings.
	 * Since 2.6
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the new row, or NULL.
	 * position =  position to insert the new row
	 * columns =  an array of column numbers
	 * values =  an array of GValues
	 */
	public void insertWithValuesv(TreeIter iter, int position, int[] columns, GValue[] values);
	
	/**
	 * Prepends a new row to list_store. iter will be changed to point to this new
	 * row. The row will be empty after this function is called. To fill in
	 * values, you need to call gtk_list_store_set() or gtk_list_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the prepend row
	 */
	public void prepend(TreeIter iter);
	
	/**
	 * Appends a new row to list_store. iter will be changed to point to this new
	 * row. The row will be empty after this function is called. To fill in
	 * values, you need to call gtk_list_store_set() or gtk_list_store_set_value().
	 * Params:
	 * iter =  An unset GtkTreeIter to set to the appended row
	 */
	public void append(TreeIter iter);
	
	/**
	 * Removes all rows from the list store.
	 */
	public void clear();
	
	/**
	 * Warning
	 * This function is slow. Only use it for debugging and/or testing
	 * purposes.
	 * Checks if the given iter is a valid iter for this GtkListStore.
	 * Since 2.2
	 * Params:
	 * iter =  A GtkTreeIter.
	 * Returns: TRUE if the iter is valid, FALSE if the iter is invalid.
	 */
	public int iterIsValid(TreeIter iter);
	
	/**
	 * Reorders store to follow the order indicated by new_order. Note that
	 * this function only works with unsorted stores.
	 * Since 2.2
	 * Params:
	 * newOrder =  an array of integers mapping the new position of each child
	 *  to its old position before the re-ordering,
	 *  i.e. new_order[newpos] = oldpos.
	 */
	public void reorder(int[] newOrder);
	
	/**
	 * Swaps a and b in store. Note that this function only works with
	 * unsorted stores.
	 * Since 2.2
	 * Params:
	 * a =  A GtkTreeIter.
	 * b =  Another GtkTreeIter.
	 */
	public void swap(TreeIter a, TreeIter b);
	
	/**
	 * Moves iter in store to the position before position. Note that this
	 * function only works with unsorted stores. If position is NULL, iter
	 * will be moved to the end of the list.
	 * Since 2.2
	 * Params:
	 * iter =  A GtkTreeIter.
	 * position =  A GtkTreeIter, or NULL.
	 */
	public void moveBefore(TreeIter iter, TreeIter position);
	
	/**
	 * Moves iter in store to the position after position. Note that this
	 * function only works with unsorted stores. If position is NULL, iter
	 * will be moved to the start of the list.
	 * Since 2.2
	 * Params:
	 * iter =  A GtkTreeIter.
	 * position =  A GtkTreeIter or NULL.
	 */
	public void moveAfter(TreeIter iter, TreeIter position);
}
