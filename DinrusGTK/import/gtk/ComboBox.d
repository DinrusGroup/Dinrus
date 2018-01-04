module gtkD.gtk.ComboBox;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.atk.ObjectAtk;
private import gtkD.glib.Str;
private import gtkD.gtk.TreeModel;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreeIter;
private import gtkD.gtk.CellLayoutIF;
private import gtkD.gtk.CellLayoutT;
private import gtkD.gtk.CellEditableT;
private import gtkD.gtk.CellEditableIF;



private import gtkD.gtk.Bin;

/**
 * Description
 * A GtkComboBox is a widget that allows the user to choose from a
 * list of valid choices. The GtkComboBox displays the selected
 * choice. When activated, the GtkComboBox displays a popup
 * which allows the user to make a new choice. The style in which
 * the selected value is displayed, and the style of the popup is
 * determined by the current theme. It may be similar to a GtkOptionMenu,
 * or similar to a Windows-style combo box.
 * Unlike its predecessors GtkCombo and GtkOptionMenu, the GtkComboBox
 * uses the model-view pattern; the list of valid choices is specified in the
 * form of a tree model, and the display of the choices can be adapted to
 * the data in the model by using cell renderers, as you would in a tree view.
 * This is possible since GtkComboBox implements the GtkCellLayout interface.
 * The tree model holding the valid choices is not restricted to a flat list,
 * it can be a real tree, and the popup will reflect the tree structure.
 * In addition to the model-view API, GtkComboBox offers a simple API which
 * is suitable for text-only combo boxes, and hides the complexity of managing
 * the data in a model. It consists of the functions gtk_combo_box_new_text(),
 * gtk_combo_box_append_text(), gtk_combo_box_insert_text(),
 * gtk_combo_box_prepend_text(), gtk_combo_box_remove_text() and
 * gtk_combo_box_get_active_text().
 */
public class ComboBox : Bin, CellLayoutIF, CellEditableIF
{
	
	/** the main Gtk struct */
	protected GtkComboBox* gtkComboBox;
	
	
	public GtkComboBox* getComboBoxStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkComboBox* gtkComboBox);
	
	private int count = 0;
	public int maxCount = 0;
	
	
	// add the CellLayout capabilities
	mixin CellLayoutT!(GtkComboBox);
	
	// add the CellEditable capabilities
	mixin CellEditableT!(GtkComboBox);
	
	/**
	 * Creates a new empty GtkComboBox.
	 * If text is true then
	 * constructs a new text combo box, which is a
	 * GtkComboBox just displaying strings. If you use this function to create
	 * a text combo box, you should only manipulate its data source with the
	 * following convenience functions: gtk_combo_box_append_text(),
	 * gtk_combo_box_insert_text(), gtk_combo_box_prepend_text() and
	 * gtk_combo_box_remove_text().
	 * Since 2.4
	 * Returns:
	 *  A new GtkComboBox.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (bool text=true);
	
	/** */
	public void setActiveText(string text, bool insert=false);
	
	/** */
	int getIndex(string text);
	
	/** */
	void prependOrReplaceText(string text);
	
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(ComboBox)[] onChangedListeners;
	/**
	 * The changed signal is emitted when the active
	 * item is changed. The can be due to the user selecting
	 * a different item from the list, or due to a
	 * call to gtk_combo_box_set_active_iter().
	 * It will also be emitted while typing into a GtkComboBoxEntry,
	 * as well as when selecting an item from the GtkComboBoxEntry's list.
	 * Since 2.4
	 */
	void addOnChanged(void delegate(ComboBox) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChanged(GtkComboBox* widgetStruct, ComboBox comboBox);
	
	void delegate(GtkScrollType, ComboBox)[] onMoveActiveListeners;
	/**
	 * The ::move-active signal is a
	 * keybinding signal
	 * which gets emitted to move the active selection.
	 * Since 2.12
	 */
	void addOnMoveActive(void delegate(GtkScrollType, ComboBox) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveActive(GtkComboBox* widgetStruct, GtkScrollType scrollType, ComboBox comboBox);
	
	bool delegate(ComboBox)[] onPopdownListeners;
	/**
	 * The ::popdown signal is a
	 * keybinding signal
	 * which gets emitted to popdown the combo box list.
	 * The default bindings for this signal are Alt+Up and Escape.
	 * Since 2.12
	 */
	void addOnPopdown(bool delegate(ComboBox) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackPopdown(GtkComboBox* buttonStruct, ComboBox comboBox);
	
	void delegate(ComboBox)[] onPopupListeners;
	/**
	 * The ::popup signal is a
	 * keybinding signal
	 * which gets emitted to popup the combo box list.
	 * The default binding for this signal is Alt+Down.
	 * Since 2.12
	 * See Also
	 * GtkComboBoxEntry, GtkTreeModel, GtkCellRenderer
	 */
	void addOnPopup(void delegate(ComboBox) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPopup(GtkComboBox* widgetStruct, ComboBox comboBox);
	
	
	/**
	 * Creates a new GtkComboBox with the model initialized to model.
	 * Since 2.4
	 * Params:
	 * model =  A GtkTreeModel.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (TreeModelIF model);
	
	/**
	 * Returns the wrap width which is used to determine the number of columns
	 * for the popup menu. If the wrap width is larger than 1, the combo box
	 * is in table mode.
	 * Since 2.6
	 * Returns: the wrap width.
	 */
	public int getWrapWidth();

	/**
	 * Sets the wrap width of combo_box to be width. The wrap width is basically
	 * the preferred number of columns when you want the popup to be layed out
	 * in a table.
	 * Since 2.4
	 * Params:
	 * width =  Preferred number of columns
	 */
	public void setWrapWidth(int width);
	
	/**
	 * Returns the column with row span information for combo_box.
	 * Since 2.6
	 * Returns: the row span column.
	 */
	public int getRowSpanColumn();
	
	/**
	 * Sets the column with row span information for combo_box to be row_span.
	 * The row span column contains integers which indicate how many rows
	 * an item should span.
	 * Since 2.4
	 * Params:
	 * rowSpan =  A column in the model passed during construction.
	 */
	public void setRowSpanColumn(int rowSpan);
	
	/**
	 * Returns the column with column span information for combo_box.
	 * Since 2.6
	 * Returns: the column span column.
	 */
	public int getColumnSpanColumn();
	
	/**
	 * Sets the column with column span information for combo_box to be
	 * column_span. The column span column contains integers which indicate
	 * how many columns an item should span.
	 * Since 2.4
	 * Params:
	 * columnSpan =  A column in the model passed during construction
	 */
	public void setColumnSpanColumn(int columnSpan);
	
	/**
	 * Returns the index of the currently active item, or -1 if there's no
	 * active item. If the model is a non-flat treemodel, and the active item
	 * is not an immediate child of the root of the tree, this function returns
	 * gtk_tree_path_get_indices (path)[0], where
	 * path is the GtkTreePath of the active item.
	 * Since 2.4
	 * Returns: An integer which is the index of the currently active item,  or -1 if there's no active item.
	 */
	public int getActive();
	
	/**
	 * Sets the active item of combo_box to be the item at index.
	 * Since 2.4
	 * Params:
	 * index =  An index in the model passed during construction, or -1 to have
	 * no active item
	 */
	public void setActive(int index);
	
	/**
	 * Sets iter to point to the current active item, if it exists.
	 * Since 2.4
	 * Params:
	 * iter =  The uninitialized GtkTreeIter
	 * Returns: TRUE, if iter was set
	 */
	public int getActiveIter(TreeIter iter);
	
	/**
	 * Sets the current active item to be the one referenced by iter.
	 * iter must correspond to a path of depth one.
	 * Since 2.4
	 * Params:
	 * iter =  The GtkTreeIter
	 */
	public void setActiveIter(TreeIter iter);
	
	/**
	 * Returns the GtkTreeModel which is acting as data source for combo_box.
	 * Since 2.4
	 * Returns: A GtkTreeModel which was passed during construction.
	 */
	public TreeModelIF getModel();
	
	/**
	 * Sets the model used by combo_box to be model. Will unset a previously set
	 * model (if applicable). If model is NULL, then it will unset the model.
	 * Note that this function does not clear the cell renderers, you have to
	 * call gtk_cell_layout_clear() yourself if you need to set up different
	 * cell renderers for the new model.
	 * Since 2.4
	 * Params:
	 * model =  A GtkTreeModel
	 */
	public void setModel(TreeModelIF model);
	
	/**
	 * Appends string to the list of strings stored in combo_box. Note that
	 * you can only use this function with combo boxes constructed with
	 * gtk_combo_box_new_text().
	 * Since 2.4
	 * Params:
	 * text =  A string
	 */
	public void appendText(string text);
	
	/**
	 * Inserts string at position in the list of strings stored in combo_box.
	 * Note that you can only use this function with combo boxes constructed
	 * with gtk_combo_box_new_text().
	 * Since 2.4
	 * Params:
	 * position =  An index to insert text
	 * text =  A string
	 */
	public void insertText(int position, string text);
	
	/**
	 * Prepends string to the list of strings stored in combo_box. Note that
	 * you can only use this function with combo boxes constructed with
	 * gtk_combo_box_new_text().
	 * Since 2.4
	 * Params:
	 * text =  A string
	 */
	public void prependText(string text);
	
	/**
	 * Removes the string at position from combo_box. Note that you can only use
	 * this function with combo boxes constructed with gtk_combo_box_new_text().
	 * Since 2.4
	 * Params:
	 * position =  Index of the item to remove
	 */
	public void removeText(int position);
	
	/**
	 * Returns the currently active string in combo_box or NULL if none
	 * is selected. Note that you can only use this function with combo
	 * boxes constructed with gtk_combo_box_new_text() and with
	 * GtkComboBoxEntrys.
	 * Since 2.6
	 * Returns: a newly allocated string containing the currently active text. Must be freed with g_free().
	 */
	public string getActiveText();
	
	/**
	 * Pops up the menu or dropdown list of combo_box.
	 * This function is mostly intended for use by accessibility technologies;
	 * applications should have little use for it.
	 * Since 2.4
	 */
	public void popup();
	
	/**
	 * Hides the menu or dropdown list of combo_box.
	 * This function is mostly intended for use by accessibility technologies;
	 * applications should have little use for it.
	 * Since 2.4
	 */
	public void popdown();
	
	/**
	 * Gets the accessible object corresponding to the combo box's popup.
	 * This function is mostly intended for use by accessibility technologies;
	 * applications should have little use for it.
	 * Since 2.6
	 * Returns: the accessible object corresponding to the combo box's popup.
	 */
	public ObjectAtk getPopupAccessible();
	
	/**
	 * Returns the current row separator function.
	 * Since 2.6
	 * Returns: the current row separator function.
	 */
	public GtkTreeViewRowSeparatorFunc getRowSeparatorFunc();
	
	/**
	 * Sets the row separator function, which is used to determine
	 * whether a row should be drawn as a separator. If the row separator
	 * function is NULL, no separators are drawn. This is the default value.
	 * Since 2.6
	 * Params:
	 * func =  a GtkTreeViewRowSeparatorFunc
	 * data =  user data to pass to func, or NULL
	 * destroy =  destroy notifier for data, or NULL
	 */
	public void setRowSeparatorFunc(GtkTreeViewRowSeparatorFunc func, void* data, GDestroyNotify destroy);
	
	/**
	 * Sets whether the popup menu should have a tearoff
	 * menu item.
	 * Since 2.6
	 * Params:
	 * addTearoffs =  TRUE to add tearoff menu items
	 */
	public void setAddTearoffs(int addTearoffs);
	
	/**
	 * Gets the current value of the :add-tearoffs property.
	 * Returns: the current value of the :add-tearoffs property.
	 */
	public int getAddTearoffs();
	
	/**
	 * Sets the menu's title in tearoff mode.
	 * Since 2.10
	 * Params:
	 * title =  a title for the menu in tearoff mode
	 */
	public void setTitle(string title);
	
	/**
	 * Gets the current title of the menu in tearoff mode. See
	 * gtk_combo_box_set_add_tearoffs().
	 * Since 2.10
	 * Returns: the menu's title in tearoff mode. This is an internal copy of thestring which must not be freed.
	 */
	public string getTitle();
	
	/**
	 * Sets whether the combo box will grab focus when it is clicked with
	 * the mouse. Making mouse clicks not grab focus is useful in places
	 * like toolbars where you don't want the keyboard focus removed from
	 * the main area of the application.
	 * Since 2.6
	 * Params:
	 * focusOnClick =  whether the combo box grabs focus when clicked
	 *  with the mouse
	 */
	public void setFocusOnClick(int focusOnClick);
	
	/**
	 * Returns whether the combo box grabs focus when it is clicked
	 * with the mouse. See gtk_combo_box_set_focus_on_click().
	 * Since 2.6
	 * Returns: TRUE if the combo box grabs focus when it is  clicked with the mouse.
	 */
	public int getFocusOnClick();
	
	/**
	 * Sets whether the dropdown button of the combo box should be
	 * always sensitive (GTK_SENSITIVITY_ON), never sensitive (GTK_SENSITIVITY_OFF)
	 * or only if there is at least one item to display (GTK_SENSITIVITY_AUTO).
	 * Since 2.14
	 * Params:
	 * sensitivity =  specify the sensitivity of the dropdown button
	 */
	public void setButtonSensitivity(GtkSensitivityType sensitivity);
	
	/**
	 * Returns whether the combo box sets the dropdown button
	 * sensitive or not when there are no items in the model.
	 * Since 2.14
	 * Returns: GTK_SENSITIVITY_ON if the dropdown button is sensitive when the model is empty, GTK_SENSITIVITY_OFF if the button is always insensitive or GTK_SENSITIVITY_AUTO if it is only sensitive as long as the model has one item to be selected.
	 */
	public GtkSensitivityType getButtonSensitivity();
}
