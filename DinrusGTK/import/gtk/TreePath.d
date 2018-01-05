
module gtkD.gtk.TreePath;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;




/**
 * Description
 * The GtkTreeModel interface defines a generic tree interface for use by
 * the GtkTreeView widget. It is an abstract interface, and is designed
 * to be usable with any appropriate data structure. The programmer just
 * has to implement this interface on their own data type for it to be
 * viewable by a GtkTreeView widget.
 * The model is represented as a hierarchical tree of strongly-typed,
 * columned data. In other words, the model can be seen as a tree where
 * every node has different values depending on which column is being
 * queried. The type of data found in a column is determined by using the
 * GType system (ie. G_TYPE_INT, GTK_TYPE_BUTTON, G_TYPE_POINTER, etc.).
 * The types are homogeneous per column across all nodes. It is important
 * to note that this interface only provides a way of examining a model and
 * observing changes. The implementation of each individual model decides
 * how and if changes are made.
 * In order to make life simpler for programmers who do not need to write
 * their own specialized model, two generic models are provided — the
 * GtkTreeStore and the GtkListStore. To use these, the developer simply
 * pushes data into these models as necessary. These models provide the
 * data structure as well as all appropriate tree interfaces. As a result,
 * implementing drag and drop, sorting, and storing data is trivial. For
 * the vast majority of trees and lists, these two models are sufficient.
 * Models are accessed on a node/column level of granularity. One can
 * query for the value of a model at a certain node and a certain column
 * on that node. There are two structures used to reference a particular
 * node in a model. They are the GtkTreePath and the GtkTreeIter
 * [4]
 * Most of the interface consists of operations on a GtkTreeIter.
 * A path is essentially a potential node. It is a location on a model
 * that may or may not actually correspond to a node on a specific model.
 * The GtkTreePath struct can be converted into either an array of
 * unsigned integers or a string. The string form is a list of numbers
 * separated by a colon. Each number refers to the offset at that level.
 * Thus, the path “0” refers to the root node and the path
 * “2:4” refers to the fifth child of the third node.
 * By contrast, a GtkTreeIter is a reference to a specific node on a
 * specific model. It is a generic struct with an integer and three
 * generic pointers. These are filled in by the model in a model-specific
 * way. One can convert a path to an iterator by calling
 * gtk_tree_model_get_iter(). These iterators are the primary way of
 * accessing a model and are similar to the iterators used by
 * GtkTextBuffer. They are generally statically allocated on the stack and
 * only used for a short time. The model interface defines a set of
 * operations using them for navigating the model.
 * It is expected that models fill in the iterator with private data. For
 * example, the GtkListStore model, which is internally a simple linked
 * list, stores a list node in one of the pointers. The GtkTreeModelSort
 * stores an array and an offset in two of the pointers. Additionally,
 * there is an integer field. This field is generally filled with a unique
 * stamp per model. This stamp is for catching errors resulting from using
 * invalid iterators with a model.
 * The lifecycle of an iterator can be a little confusing at first.
 * Iterators are expected to always be valid for as long as the model is
 * unchanged (and doesn't emit a signal). The model is considered to own
 * all outstanding iterators and nothing needs to be done to free them from
 * the user's point of view. Additionally, some models guarantee that an
 * iterator is valid for as long as the node it refers to is valid (most
 * notably the GtkTreeStore and GtkListStore). Although generally
 * uninteresting, as one always has to allow for the case where iterators
 * do not persist beyond a signal, some very important performance
 * enhancements were made in the sort model. As a result, the
 * GTK_TREE_MODEL_ITERS_PERSIST flag was added to indicate this behavior.
 * To help show some common operation of a model, some examples are
 * provided. The first example shows three ways of getting the iter at the
 * location “3:2:5”. While the first method shown is easier,
 * the second is much more common, as you often get paths from callbacks.
 * Example 20. Acquiring a GtkTreeIter
 * /+* Three ways of getting the iter pointing to the location
 *  +/
 * {
	 *  GtkTreePath *path;
	 *  GtkTreeIter iter;
	 *  GtkTreeIter parent_iter;
	 *  /+* get the iterator from a string +/
	 *  gtk_tree_model_get_iter_from_string (model, iter, "3:2:5");
	 *  /+* get the iterator from a path +/
	 *  path = gtk_tree_path_new_from_string ("3:2:5");
	 *  gtk_tree_model_get_iter (model, iter, path);
	 *  gtk_tree_path_free (path);
	 *  /+* walk the tree to find the iterator +/
	 *  gtk_tree_model_iter_nth_child (model, iter, NULL, 3);
	 *  parent_iter = iter;
	 *  gtk_tree_model_iter_nth_child (model, iter, parent_iter, 2);
	 *  parent_iter = iter;
	 *  gtk_tree_model_iter_nth_child (model, iter, parent_iter, 5);
 * }
 * This second example shows a quick way of iterating through a list and
 * getting a string and an integer from each row. The
 * populate_model function used below is not shown, as
 * it is specific to the GtkListStore. For information on how to write
 * such a function, see the GtkListStore documentation.
 * Example 21. Reading data from a GtkTreeModel
 * enum
 * {
	 *  STRING_COLUMN,
	 *  INT_COLUMN,
	 *  N_COLUMNS
 * };
 * {
	 *  GtkTreeModel *list_store;
	 *  GtkTreeIter iter;
	 *  gboolean valid;
	 *  gint row_count = 0;
	 *  /+* make a new list_store +/
	 *  list_store = gtk_list_store_new (N_COLUMNS, G_TYPE_STRING, G_TYPE_INT);
	 *  /+* Fill the list store with data +/
	 *  populate_model (list_store);
	 *  /+* Get the first iter in the list +/
	 *  valid = gtk_tree_model_get_iter_first (list_store, iter);
	 *  while (valid)
	 *  {
		 *  /+* Walk through the list, reading each row +/
		 *  gchar *str_data;
		 *  gint int_data;
		 *  /+* Make sure you terminate calls to gtk_tree_model_get()
		 *  * with a '-1' value
		 *  +/
		 *  gtk_tree_model_get (list_store, iter,
		 *  STRING_COLUMN, str_data,
		 *  INT_COLUMN, int_data,
		 *  -1);
		 *  /+* Do something with the data +/
		 *  g_print ("Row %d: (%s,%d)\n", row_count, str_data, int_data);
		 *  g_free (str_data);
		 *  row_count ++;
		 *  valid = gtk_tree_model_iter_next (list_store, iter);
	 *  }
 * }
 */
public class TreePath
{
	
	/** the main Gtk struct */
	protected GtkTreePath* gtkTreePath;
	
	
	public GtkTreePath* getTreePathStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTreePath* gtkTreePath);
	
	/**
	 * Creates a new GtkTreePath. This structure refers to a row.
	 * Params:
	 * firstRow = if true this is the string representation of this path is "0"
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (bool firstRow=false);
	
	/**
	 */
	
	/**
	 * Creates a new GtkTreePath initialized to path. path is expected to be a
	 * colon separated list of numbers. For example, the string "10:4:0" would
	 * create a path of depth 3 pointing to the 11th child of the root node, the 5th
	 * child of that 11th child, and the 1st child of that 5th child. If an invalid
	 * path string is passed in, NULL is returned.
	 * Params:
	 * path =  The string representation of a path.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string path);
	
	/**
	 * Generates a string representation of the path. This string is a ':'
	 * separated list of numbers. For example, "4:10:0:3" would be an acceptable return value for this string.
	 * Returns: A newly-allocated string. Must be freed with g_free().
	 */
	public override string toString();
	
	/**
	 * Appends a new index to a path. As a result, the depth of the path is
	 * increased.
	 * Params:
	 * index =  The index.
	 */
	public void appendIndex(int index);
	
	/**
	 * Prepends a new index to a path. As a result, the depth of the path is
	 * increased.
	 * Params:
	 * index =  The index.
	 */
	public void prependIndex(int index);
	
	/**
	 * Returns the current depth of path.
	 * Returns: The depth of path
	 */
	public int getDepth();
	
	/**
	 * Returns the current indices of path. This is an array of integers, each
	 * representing a node in a tree. This value should not be freed.
	 * Returns: The current indices, or NULL.
	 */
	public int[] getIndices();
	
	/**
	 * Frees path.
	 */
	public void free();
	
	/**
	 * Creates a new GtkTreePath as a copy of path.
	 * Returns: A new GtkTreePath.
	 */
	public TreePath copy();
	
	/**
	 * Compares two paths. If a appears before b in a tree, then -1 is returned.
	 * If b appears before a, then 1 is returned. If the two nodes are equal,
	 * then 0 is returned.
	 * Params:
	 * a =  A GtkTreePath.
	 * b =  A GtkTreePath to compare with.
	 * Returns: The relative positions of a and b
	 */
	public int compare(TreePath b);
	
	/**
	 * Moves the path to point to the next node at the current depth.
	 */
	public void next();
	
	/**
	 * Moves the path to point to the previous node at the current depth,
	 * if it exists.
	 * Returns: TRUE if path has a previous node, and the move was made.
	 */
	public int prev();
	
	/**
	 * Moves the path to point to its parent node, if it has a parent.
	 * Returns: TRUE if path has a parent, and the move was made.
	 */
	public int up();
	
	/**
	 * Moves path to point to the first child of the current path.
	 */
	public void down();
	
	/**
	 * Returns TRUE if descendant is a descendant of path.
	 * Params:
	 * descendant =  another GtkTreePath
	 * Returns: TRUE if descendant is contained inside path
	 */
	public int isAncestor(TreePath descendant);
	
	/**
	 * Returns TRUE if path is a descendant of ancestor.
	 * Params:
	 * ancestor =  another GtkTreePath
	 * Returns: TRUE if ancestor contains path somewhere below it
	 */
	public int isDescendant(TreePath ancestor);
}
