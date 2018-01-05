module gtkD.atk.Selection;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.atk.ObjectAtk;




/**
 * Description
 * AtkSelection should be implemented by UI components with children which
 * are exposed by atk_object_ref_child and atk_object_get_n_children, if
 * the use of the parent UI component ordinarily involves selection of one
 * or more of the objects corresponding to those AtkObject children - for
 * example, selectable lists.
 * Note that other types of "selection" (for instance text selection) are
 * accomplished a other ATK interfaces - AtkSelection is limited to the
 * selection/deselection of children.
 */
public class Selection
{

	/** the main Gtk struct */
	protected AtkSelection* atkSelection;


	public AtkSelection* getSelectionStruct();


	/** the main Gtk struct as a void* */
	protected void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkSelection* atkSelection);

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(Selection)[] onSelectionChangedListeners;
	/**
	 * The "selection-changed" signal is emitted by an object which implements
	 * AtkSelection interface when the selection changes.
	 * See Also
	 * AtkText
	 */
	void addOnSelectionChanged(void delegate(Selection) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelectionChanged(AtkSelection* atkselectionStruct, Selection selection);



	/**
	 * Adds the specified accessible child of the object to the
	 * object's selection.
	 * Params:
	 * i =  a gint specifying the child index.
	 * Returns: TRUE if success, FALSE otherwise.
	 */
	public int addSelection(int i);

	/**
	 * Clears the selection in the object so that no children in the object
	 * are selected.
	 * Returns: TRUE if success, FALSE otherwise.
	 */
	public int clearSelection();

	/**
	 * Gets a reference to the accessible object representing the specified
	 * selected child of the object.
	 * Note: callers should not rely on NULL or on a zero value for
	 * indication of whether AtkSelectionIface is implemented, they should
	 * use type checking/interface checking macros or the
	 * atk_get_accessible_value() convenience method.
	 * Params:
	 * i =  a gint specifying the index in the selection set. (e.g. the
	 * ith selection as opposed to the ith child).
	 * Returns: an AtkObject representing the selected accessible , or NULLif selection does not implement this interface.
	 */
	public ObjectAtk refSelection(int i);

	/**
	 * Gets the number of accessible children currently selected.
	 * Note: callers should not rely on NULL or on a zero value for
	 * indication of whether AtkSelectionIface is implemented, they should
	 * use type checking/interface checking macros or the
	 * atk_get_accessible_value() convenience method.
	 * Returns: a gint representing the number of items selected, or 0if selection does not implement this interface.
	 */
	public int getSelectionCount();

	/**
	 * Determines if the current child of this object is selected
	 * Note: callers should not rely on NULL or on a zero value for
	 * indication of whether AtkSelectionIface is implemented, they should
	 * use type checking/interface checking macros or the
	 * atk_get_accessible_value() convenience method.
	 * Params:
	 * i =  a gint specifying the child index.
	 * Returns: a gboolean representing the specified child is selected, or 0if selection does not implement this interface.
	 */
	public int isChildSelected(int i);

	/**
	 * Removes the specified child of the object from the object's selection.
	 * Params:
	 * i =  a gint specifying the index in the selection set. (e.g. the
	 * ith selection as opposed to the ith child).
	 * Returns: TRUE if success, FALSE otherwise.
	 */
	public int removeSelection(int i);

	/**
	 * Causes every child of the object to be selected if the object
	 * supports multiple selections.
	 * Returns: TRUE if success, FALSE otherwise.Signal DetailsThe "selection-changed" signalvoid user_function (AtkSelection *atkselection, gpointer user_data) : Run LastThe "selection-changed" signal is emitted by an object which implementsAtkSelection interface when the selection changes.
	 */
	public int selectAllSelection();
}
