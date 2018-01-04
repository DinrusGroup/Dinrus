
module gtkD.glib.Node;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * The GNode struct and its associated functions provide a N-ary tree data
 * structure, where nodes in the tree can contain arbitrary data.
 * To create a new tree use g_node_new().
 * To insert a node into a tree use g_node_insert(), g_node_insert_before(),
 * g_node_append() and g_node_prepend().
 * To create a new node and insert it into a tree use g_node_insert_data(),
 * g_node_insert_data_before(), g_node_append_data() and g_node_prepend_data().
 * To reverse the children of a node use g_node_reverse_children().
 * To find a node use g_node_get_root(), g_node_find(), g_node_find_child(),
 * g_node_child_index(), g_node_child_position(),
 * g_node_first_child(), g_node_last_child(),
 * g_node_nth_child(), g_node_first_sibling(), g_node_prev_sibling(),
 * g_node_next_sibling() or g_node_last_sibling().
 * To get information about a node or tree use G_NODE_IS_LEAF(),
 * G_NODE_IS_ROOT(), g_node_depth(), g_node_n_nodes(), g_node_n_children(),
 * g_node_is_ancestor() or g_node_max_height().
 * To traverse a tree, calling a function for each node visited in the
 * traversal, use g_node_traverse() or g_node_children_foreach().
 * To remove a node or subtree from a tree use g_node_unlink() or
 * g_node_destroy().
 */
public class Node
{
	
	/** the main Gtk struct */
	protected GNode* gNode;
	
	
	public GNode* getNodeStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GNode* gNode);
	
	/**
	 */
	
	/**
	 * Creates a new GNode containing the given data.
	 * Used to create the first node in a tree.
	 * Params:
	 * data =  the data of the new node
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (void* data);
	
	/**
	 * Recursively copies a GNode (but does not deep-copy the data inside the
	 * nodes, see g_node_copy_deep() if you need that).
	 * Returns: a new GNode containing the same data pointers
	 */
	public Node copy();
	
	/**
	 * Recursively copies a GNode and its data.
	 * Since 2.4
	 * Params:
	 * copyFunc =  the function which is called to copy the data inside each node,
	 *  or NULL to use the original data.
	 * data =  data to pass to copy_func
	 * Returns: a new GNode containing copies of the data in node.
	 */
	public Node copyDeep(GCopyFunc copyFunc, void* data);
	
	/**
	 * Inserts a GNode beneath the parent at the given position.
	 * Params:
	 * position =  the position to place node at, with respect to its siblings
	 *  If position is -1, node is inserted as the last child of parent
	 * node =  the GNode to insert
	 * Returns: the inserted GNode
	 */
	public Node insert(int position, Node node);
	
	/**
	 * Inserts a GNode beneath the parent before the given sibling.
	 * Params:
	 * sibling =  the sibling GNode to place node before.
	 *  If sibling is NULL, the node is inserted as the last child of parent.
	 * node =  the GNode to insert
	 * Returns: the inserted GNode
	 */
	public Node insertBefore(Node sibling, Node node);
	
	/**
	 * Inserts a GNode beneath the parent after the given sibling.
	 * Params:
	 * sibling =  the sibling GNode to place node after.
	 *  If sibling is NULL, the node is inserted as the first child of parent.
	 * node =  the GNode to insert
	 * Returns: the inserted GNode
	 */
	public Node insertAfter(Node sibling, Node node);
	
	/**
	 * Inserts a GNode as the first child of the given parent.
	 * Params:
	 * node =  the GNode to insert
	 * Returns: the inserted GNode
	 */
	public Node prepend(Node node);
	
	/**
	 * Reverses the order of the children of a GNode.
	 * (It doesn't change the order of the grandchildren.)
	 */
	public void reverseChildren();
	
	/**
	 * Traverses a tree starting at the given root GNode.
	 * It calls the given function for each node visited.
	 * The traversal can be halted at any point by returning TRUE from func.
	 * Params:
	 * order =  the order in which nodes are visited - G_IN_ORDER,
	 *  G_PRE_ORDER, G_POST_ORDER, or G_LEVEL_ORDER.
	 * flags =  which types of children are to be visited, one of
	 *  G_TRAVERSE_ALL, G_TRAVERSE_LEAVES and G_TRAVERSE_NON_LEAVES
	 * maxDepth =  the maximum depth of the traversal. Nodes below this
	 *  depth will not be visited. If max_depth is -1 all nodes in
	 *  the tree are visited. If depth is 1, only the root is visited.
	 *  If depth is 2, the root and its children are visited. And so on.
	 * func =  the function to call for each visited GNode
	 * data =  user data to pass to the function
	 */
	public void traverse(GTraverseType order, GTraverseFlags flags, int maxDepth, GNodeTraverseFunc func, void* data);
	
	/**
	 * Calls a function for each of the children of a GNode.
	 * Note that it doesn't descend beneath the child nodes.
	 * Params:
	 * flags =  which types of children are to be visited, one of
	 *  G_TRAVERSE_ALL, G_TRAVERSE_LEAVES and G_TRAVERSE_NON_LEAVES
	 * func =  the function to call for each visited node
	 * data =  user data to pass to the function
	 */
	public void childrenForeach(GTraverseFlags flags, GNodeForeachFunc func, void* data);
	
	/**
	 * Gets the root of a tree.
	 * Returns: the root of the tree
	 */
	public Node getRoot();
	
	/**
	 * Finds a GNode in a tree.
	 * Params:
	 * order =  the order in which nodes are visited - G_IN_ORDER,
	 *  G_PRE_ORDER, G_POST_ORDER, or G_LEVEL_ORDER
	 * flags =  which types of children are to be searched, one of
	 *  G_TRAVERSE_ALL, G_TRAVERSE_LEAVES and G_TRAVERSE_NON_LEAVES
	 * data =  the data to find
	 * Returns: the found GNode, or NULL if the data is not found
	 */
	public Node find(GTraverseType order, GTraverseFlags flags, void* data);
	
	/**
	 * Finds the first child of a GNode with the given data.
	 * Params:
	 * flags =  which types of children are to be searched, one of
	 *  G_TRAVERSE_ALL, G_TRAVERSE_LEAVES and G_TRAVERSE_NON_LEAVES
	 * data =  the data to find
	 * Returns: the found child GNode, or NULL if the data is not found
	 */
	public Node findChild(GTraverseFlags flags, void* data);
	
	/**
	 * Gets the position of the first child of a GNode
	 * which contains the given data.
	 * Params:
	 * data =  the data to find
	 * Returns: the index of the child of node which contains  data, or -1 if the data is not found
	 */
	public int childIndex(void* data);
	
	/**
	 * Gets the position of a GNode with respect to its siblings.
	 * child must be a child of node. The first child is numbered 0,
	 * the second 1, and so on.
	 * Params:
	 * child =  a child of node
	 * Returns: the position of child with respect to its siblings
	 */
	public int childPosition(Node child);
	
	/**
	 * Gets the last child of a GNode.
	 * Returns: the last child of node, or NULL if node has no children
	 */
	public Node lastChild();
	
	/**
	 * Gets a child of a GNode, using the given index.
	 * The first child is at index 0. If the index is
	 * too big, NULL is returned.
	 * Params:
	 * n =  the index of the desired child
	 * Returns: the child of node at index n
	 */
	public Node nthChild(uint n);
	
	/**
	 * Gets the first sibling of a GNode.
	 * This could possibly be the node itself.
	 * Returns: the first sibling of node
	 */
	public Node firstSibling();
	
	/**
	 * Gets the last sibling of a GNode.
	 * This could possibly be the node itself.
	 * Returns: the last sibling of node
	 */
	public Node lastSibling();
	
	/**
	 * Gets the depth of a GNode.
	 * If node is NULL the depth is 0. The root node has a depth of 1.
	 * For the children of the root node the depth is 2. And so on.
	 * Returns: the depth of the GNode
	 */
	public uint depth();
	
	/**
	 * Gets the number of nodes in a tree.
	 * Params:
	 * flags =  which types of children are to be counted, one of
	 *  G_TRAVERSE_ALL, G_TRAVERSE_LEAVES and G_TRAVERSE_NON_LEAVES
	 * Returns: the number of nodes in the tree
	 */
	public uint nNodes(GTraverseFlags flags);
	
	/**
	 * Gets the number of children of a GNode.
	 * Returns: the number of children of node
	 */
	public uint nChildren();
	
	/**
	 * Returns TRUE if node is an ancestor of descendant.
	 * This is true if node is the parent of descendant,
	 * or if node is the grandparent of descendant etc.
	 * Params:
	 * descendant =  a GNode
	 * Returns: TRUE if node is an ancestor of descendant
	 */
	public int isAncestor(Node descendant);
	
	/**
	 * Gets the maximum height of all branches beneath a GNode.
	 * This is the maximum distance from the GNode to all leaf nodes.
	 * If root is NULL, 0 is returned. If root has no children,
	 * 1 is returned. If root has children, 2 is returned. And so on.
	 * Returns: the maximum height of the tree beneath root
	 */
	public uint maxHeight();
	
	/**
	 * Unlinks a GNode from a tree, resulting in two separate trees.
	 */
	public void unlink();
	
	/**
	 * Removes root and its children from the tree, freeing any memory
	 * allocated.
	 */
	public void destroy();
	
	/**
	 * Warning
	 * g_node_push_allocator has been deprecated since version 2.10 and should not be used in newly-written code. It does nothing, since GNode has been converted
	 *  to the slice allocator
	 * Sets the allocator to use to allocate GNode elements.
	 * Use g_node_pop_allocator() to restore the previous allocator.
	 * Note that this function is not available if GLib has been compiled
	 * with --disable-mem-pools
	 * Params:
	 * dummy = the GAllocator to use when allocating GNode elements.
	 */
	public static void pushAllocator(void* dummy);
	
	/**
	 * Warning
	 * g_node_pop_allocator has been deprecated since version 2.10 and should not be used in newly-written code. It does nothing, since GNode has been converted
	 *  to the slice allocator
	 * Restores the previous GAllocator, used when allocating GNode elements.
	 * Note that this function is not available if GLib has been compiled
	 * with --disable-mem-pools
	 */
	public static void popAllocator();
}
