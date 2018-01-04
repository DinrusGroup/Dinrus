module gtkD.glib.StringCompletion;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;
private import gtkD.glib.Str;




/**
 * Description
 * GCompletion provides support for automatic completion of a string using
 * any group of target strings. It is typically used for file name completion
 * as is common in many UNIX shells.
 * A GCompletion is created using g_completion_new().
 * Target items are added and removed with
 * g_completion_add_items(), g_completion_remove_items() and
 * g_completion_clear_items().
 * A completion attempt is requested with g_completion_complete() or
 * g_completion_complete_utf8().
 * When no longer needed, the GCompletion is freed with g_completion_free().
 * Items in the completion can be simple strings (e.g. filenames),
 * or pointers to arbitrary data structures. If data structures are used
 * you must provide a GCompletionFunc in g_completion_new(),
 * which retrieves the item's string from the data structure.
 * You can change the way in which strings are compared by setting
 * a different GCompletionStrncmpFunc in g_completion_set_compare().
 */
public class StringCompletion
{
	
	/** the main Gtk struct */
	protected GCompletion* gCompletion;
	
	
	public GCompletion* getStringCompletionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GCompletion* gCompletion);
	
	/**
	 */
	
	/**
	 * Creates a new GCompletion.
	 * Params:
	 * func = the function to be called to return the string representing an item
	 * in the GCompletion, or NULL if strings are going to be used as the
	 * GCompletion items.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GCompletionFunc func);
	
	/**
	 * Adds items to the GCompletion.
	 * Params:
	 * items = the list of items to add.
	 */
	public void addItems(ListG items);
	
	/**
	 * Removes items from a GCompletion.
	 * Params:
	 * items = the items to remove.
	 */
	public void removeItems(ListG items);
	
	/**
	 * Removes all items from the GCompletion.
	 */
	public void clearItems();
	
	/**
	 * Attempts to complete the string prefix using the GCompletion target items.
	 * Params:
	 * prefix = the prefix string, typically typed by the user, which is compared
	 * with each of the items.
	 * newPrefix = if non-NULL, returns the longest prefix which is common to all
	 * items that matched prefix, or NULL if no items matched prefix.
	 * This string should be freed when no longer needed.
	 * Returns:the list of items whose strings begin with prefix. This shouldnot be changed.
	 */
	public ListG complete(string prefix, out string newPrefix);
	
	/**
	 * Attempts to complete the string prefix using the GCompletion target items.
	 * In contrast to g_completion_complete(), this function returns the largest common
	 * prefix that is a valid UTF-8 string, omitting a possible common partial
	 * character.
	 * You should use this function instead of g_completion_complete() if your
	 * items are UTF-8 strings.
	 * Since 2.4
	 * Params:
	 * prefix =  the prefix string, typically used by the user, which is compared
	 *  with each of the items
	 * newPrefix =  if non-NULL, returns the longest prefix which is common to all
	 *  items that matched prefix, or NULL if no items matched prefix.
	 *  This string should be freed when no longer needed.
	 * Returns: the list of items whose strings begin with prefix. This shouldnot be changed.
	 */
	public ListG completeUtf8(string prefix, out string newPrefix);
	
	/**
	 * Sets the function to use for string comparisons. The default
	 * string comparison function is strncmp().
	 * Params:
	 * cmp = a GCompletion.
	 * strncmpFunc = the string comparison function.
	 */
	public void setCompare(GCompletionStrncmpFunc strncmpFunc);
	
	/**
	 * Frees all memory used by the GCompletion.
	 */
	public void free();
}
