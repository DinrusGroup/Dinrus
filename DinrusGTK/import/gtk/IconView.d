module gtkD.gtk.IconView;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.TreeModel;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreePath;
private import gtkD.gtk.CellRenderer;
private import gtkD.gtk.Tooltip;
private import gtkD.gtk.TreeIter;
private import gtkD.glib.ListG;
private import gtkD.gdk.Pixmap;
private import gtkD.gtk.CellLayoutIF;
private import gtkD.gtk.CellLayoutT;



private import gtkD.gtk.Container;

/**
 * Description
 * GtkIconView provides an alternative view on a list model.
 * It displays the model as a grid of icons with labels. Like
 * GtkTreeView, it allows to select one or multiple items
 * (depending on the selection mode, see gtk_icon_view_set_selection_mode()).
 * In addition to selection with the arrow keys, GtkIconView supports
 * rubberband selection, which is controlled by dragging the pointer.
 */
public class IconView : Container, CellLayoutIF
{
	
	/** the main Gtk struct */
	protected GtkIconView* gtkIconView;
	
	
	public GtkIconView* getIconViewStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkIconView* gtkIconView);
	
	// add the CellLayout capabilities
	mixin CellLayoutT!(GtkIconView);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	bool delegate(IconView)[] onActivateCursorItemListeners;
	/**
	 * A keybinding signal
	 * which gets emitted when the user activates the currently
	 * focused item.
	 * Applications should not connect to it, but may emit it with
	 * g_signal_emit_by_name() if they need to control activation
	 * programmatically.
	 * The default bindings for this signal are Space, Return and Enter.
	 */
	void addOnActivateCursorItem(bool delegate(IconView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackActivateCursorItem(GtkIconView* iconviewStruct, IconView iconView);
	
	void delegate(TreePath, IconView)[] onItemActivatedListeners;
	/**
	 * The ::item-activated signal is emitted when the method
	 * gtk_icon_view_item_activated() is called or the user double
	 * clicks an item. It is also emitted when a non-editable item
	 * is selected and one of the keys: Space, Return or Enter is
	 * pressed.
	 */
	void addOnItemActivated(void delegate(TreePath, IconView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackItemActivated(GtkIconView* iconviewStruct, GtkTreePath* path, IconView iconView);
	
	bool delegate(GtkMovementStep, gint, IconView)[] onMoveCursorListeners;
	/**
	 * The ::move-cursor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates a cursor movement.
	 * Applications should not connect to it, but may emit it with
	 * g_signal_emit_by_name() if they need to control the cursor
	 * programmatically.
	 * The default bindings for this signal include
	 * Arrow keys which move by individual steps
	 * Home/End keys which move to the first/last item
	 * PageUp/PageDown which move by "pages"
	 * All of these will extend the selection when combined with
	 * the Shift modifier.
	 */
	void addOnMoveCursor(bool delegate(GtkMovementStep, gint, IconView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackMoveCursor(GtkIconView* iconviewStruct, GtkMovementStep step, gint count, IconView iconView);
	
	void delegate(IconView)[] onSelectAllListeners;
	/**
	 * A keybinding signal
	 * which gets emitted when the user selects all items.
	 * Applications should not connect to it, but may emit it with
	 * g_signal_emit_by_name() if they need to control selection
	 * programmatically.
	 * The default binding for this signal is Ctrl-a.
	 */
	void addOnSelectAll(void delegate(IconView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelectAll(GtkIconView* iconviewStruct, IconView iconView);
	
	void delegate(IconView)[] onSelectCursorItemListeners;
	/**
	 * A keybinding signal
	 * which gets emitted when the user selects the item that is currently
	 * focused.
	 * Applications should not connect to it, but may emit it with
	 * g_signal_emit_by_name() if they need to control selection
	 * programmatically.
	 * There is no default binding for this signal.
	 */
	void addOnSelectCursorItem(void delegate(IconView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelectCursorItem(GtkIconView* iconviewStruct, IconView iconView);
	
	void delegate(IconView)[] onSelectionChangedListeners;
	/**
	 * The ::selection-changed signal is emitted when the selection
	 * (i.e. the set of selected items) changes.
	 */
	void addOnSelectionChanged(void delegate(IconView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelectionChanged(GtkIconView* iconviewStruct, IconView iconView);
	
	void delegate(GtkAdjustment*, GtkAdjustment*, IconView)[] onSetScrollAdjustmentsListeners;
	/**
	 * Set the scroll adjustments for the icon view. Usually scrolled containers
	 * like GtkScrolledWindow will emit this signal to connect two instances
	 * of GtkScrollbar to the scroll directions of the GtkIconView.
	 */
	void addOnSetScrollAdjustments(void delegate(GtkAdjustment*, GtkAdjustment*, IconView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSetScrollAdjustments(GtkIconView* horizontalStruct, GtkAdjustment* vertical, GtkAdjustment* arg2, IconView iconView);
	
	void delegate(IconView)[] onToggleCursorItemListeners;
	/**
	 * A keybinding signal
	 * which gets emitted when the user toggles whether the currently
	 * focused item is selected or not. The exact effect of this
	 * depend on the selection mode.
	 * Applications should not connect to it, but may emit it with
	 * g_signal_emit_by_name() if they need to control selection
	 * programmatically.
	 * There is no default binding for this signal is Ctrl-Space.
	 */
	void addOnToggleCursorItem(void delegate(IconView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggleCursorItem(GtkIconView* iconviewStruct, IconView iconView);
	
	void delegate(IconView)[] onUnselectAllListeners;
	/**
	 * A keybinding signal
	 * which gets emitted when the user unselects all items.
	 * Applications should not connect to it, but may emit it with
	 * g_signal_emit_by_name() if they need to control selection
	 * programmatically.
	 * The default binding for this signal is Ctrl-Shift-a.
	 */
	void addOnUnselectAll(void delegate(IconView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackUnselectAll(GtkIconView* iconviewStruct, IconView iconView);
	
	
	/**
	 * Creates a new GtkIconView widget
	 * Since 2.6
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GtkIconView widget with the model model.
	 * Since 2.6
	 * Params:
	 * model =  The model.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (TreeModelIF model);
	
	/**
	 * Sets the model for a GtkIconView.
	 * If the icon_view already has a model set, it will remove
	 * it before setting the new model. If model is NULL, then
	 * it will unset the old model.
	 * Since 2.6
	 * Params:
	 * model =  The model.
	 */
	public void setModel(TreeModelIF model);
	
	/**
	 * Returns the model the GtkIconView is based on. Returns NULL if the
	 * model is unset.
	 * Since 2.6
	 * Returns: A GtkTreeModel, or NULL if none is currently being used.
	 */
	public TreeModelIF getModel();
	
	/**
	 * Sets the column with text for icon_view to be column. The text
	 * column must be of type G_TYPE_STRING.
	 * Since 2.6
	 * Params:
	 * column =  A column in the currently used model, or -1 to display no text
	 */
	public void setTextColumn(int column);
	
	/**
	 * Returns the column with text for icon_view.
	 * Since 2.6
	 * Returns: the text column, or -1 if it's unset.
	 */
	public int getTextColumn();
	
	/**
	 * Sets the column with markup information for icon_view to be
	 * column. The markup column must be of type G_TYPE_STRING.
	 * If the markup column is set to something, it overrides
	 * the text column set by gtk_icon_view_set_text_column().
	 * Since 2.6
	 * Params:
	 * column =  A column in the currently used model, or -1 to display no text
	 */
	public void setMarkupColumn(int column);
	
	/**
	 * Returns the column with markup text for icon_view.
	 * Since 2.6
	 * Returns: the markup column, or -1 if it's unset.
	 */
	public int getMarkupColumn();
	
	/**
	 * Sets the column with pixbufs for icon_view to be column. The pixbuf
	 * column must be of type GDK_TYPE_PIXBUF
	 * Since 2.6
	 * Params:
	 * column =  A column in the currently used model, or -1 to disable
	 */
	public void setPixbufColumn(int column);
	
	/**
	 * Returns the column with pixbufs for icon_view.
	 * Since 2.6
	 * Returns: the pixbuf column, or -1 if it's unset.
	 */
	public int getPixbufColumn();
	
	/**
	 * Finds the path at the point (x, y), relative to bin_window coordinates.
	 * See gtk_icon_view_get_item_at_pos(), if you are also interested in
	 * the cell at the specified position.
	 * See gtk_icon_view_convert_widget_to_bin_window_coords() for converting
	 * widget coordinates to bin_window coordinates.
	 * Since 2.6
	 * Params:
	 * x =  The x position to be identified
	 * y =  The y position to be identified
	 * Returns: The GtkTreePath corresponding to the icon or NULLif no icon exists at that position.
	 */
	public TreePath getPathAtPos(int x, int y);
	
	/**
	 * Finds the path at the point (x, y), relative to bin_window coordinates.
	 * In contrast to gtk_icon_view_get_path_at_pos(), this function also
	 * obtains the cell at the specified position. The returned path should
	 * be freed with gtk_tree_path_free().
	 * See gtk_icon_view_convert_widget_to_bin_window_coords() for converting
	 * widget coordinates to bin_window coordinates.
	 * Since 2.8
	 * Params:
	 * x =  The x position to be identified
	 * y =  The y position to be identified
	 * path =  Return location for the path, or NULL
	 * cell =  Return location for the renderer responsible for the cell
	 *  at (x, y), or NULL
	 * Returns: TRUE if an item exists at the specified position
	 */
	public int getItemAtPos(int x, int y, out TreePath path, out CellRenderer cell);
	
	/**
	 * Converts widget coordinates to coordinates for the bin_window,
	 * as expected by e.g. gtk_icon_view_get_path_at_pos().
	 * Since 2.12
	 * Params:
	 * wx =  X coordinate relative to the widget
	 * wy =  Y coordinate relative to the widget
	 * bx =  return location for bin_window X coordinate
	 * by =  return location for bin_window Y coordinate
	 */
	public void convertWidgetToBinWindowCoords(int wx, int wy, out int bx, out int by);
	
	/**
	 * Sets the current keyboard focus to be at path, and selects it. This is
	 * useful when you want to focus the user's attention on a particular item.
	 * If cell is not NULL, then focus is given to the cell specified by
	 * it. Additionally, if start_editing is TRUE, then editing should be
	 * started in the specified cell.
	 * This function is often followed by gtk_widget_grab_focus
	 * (icon_view) in order to give keyboard focus to the widget.
	 * Please note that editing can only happen when the widget is realized.
	 * Since 2.8
	 * Params:
	 * path =  A GtkTreePath
	 * cell =  One of the cell renderers of icon_view, or NULL
	 * startEditing =  TRUE if the specified cell should start being edited.
	 */
	public void setCursor(TreePath path, CellRenderer cell, int startEditing);
	
	/**
	 * Fills in path and cell with the current cursor path and cell.
	 * If the cursor isn't currently set, then *path will be NULL.
	 * If no cell currently has focus, then *cell will be NULL.
	 * The returned GtkTreePath must be freed with gtk_tree_path_free().
	 * Since 2.8
	 * Params:
	 * path =  Return location for the current cursor path, or NULL
	 * cell =  Return location the current focus cell, or NULL
	 * Returns: TRUE if the cursor is set.
	 */
	public int getCursor(out TreePath path, out CellRenderer cell);
	
	/**
	 * Calls a function for each selected icon. Note that the model or
	 * selection cannot be modified from within this function.
	 * Since 2.6
	 * Params:
	 * func =  The funcion to call for each selected icon.
	 * data =  User data to pass to the function.
	 */
	public void selectedForeach(GtkIconViewForeachFunc func, void* data);
	
	/**
	 * Sets the selection mode of the icon_view.
	 * Since 2.6
	 * Params:
	 * mode =  The selection mode
	 */
	public void setSelectionMode(GtkSelectionMode mode);
	
	/**
	 * Gets the selection mode of the icon_view.
	 * Since 2.6
	 * Returns: the current selection mode
	 */
	public GtkSelectionMode getSelectionMode();
	
	/**
	 * Sets the ::orientation property which determines whether the labels
	 * are drawn beside the icons instead of below.
	 * Since 2.6
	 * Params:
	 * orientation =  the relative position of texts and icons
	 */
	public void setOrientation(GtkOrientation orientation);
	
	/**
	 * Returns the value of the ::orientation property which determines
	 * whether the labels are drawn beside the icons instead of below.
	 * Since 2.6
	 * Returns: the relative position of texts and icons
	 */
	public GtkOrientation getOrientation();
	
	/**
	 * Sets the ::columns property which determines in how
	 * many columns the icons are arranged. If columns is
	 * -1, the number of columns will be chosen automatically
	 * to fill the available area.
	 * Since 2.6
	 * Params:
	 * columns =  the number of columns
	 */
	public void setColumns(int columns);
	
	/**
	 * Returns the value of the ::columns property.
	 * Since 2.6
	 * Returns: the number of columns, or -1
	 */
	public int getColumns();
	
	/**
	 * Sets the ::item-width property which specifies the width
	 * to use for each item. If it is set to -1, the icon view will
	 * automatically determine a suitable item size.
	 * Since 2.6
	 * Params:
	 * itemWidth =  the width for each item
	 */
	public void setItemWidth(int itemWidth);
	
	/**
	 * Returns the value of the ::item-width property.
	 * Since 2.6
	 * Returns: the width of a single item, or -1
	 */
	public int getItemWidth();
	
	/**
	 * Sets the ::spacing property which specifies the space
	 * which is inserted between the cells (i.e. the icon and
	 * the text) of an item.
	 * Since 2.6
	 * Params:
	 * spacing =  the spacing
	 */
	public void setSpacing(int spacing);
	
	/**
	 * Returns the value of the ::spacing property.
	 * Since 2.6
	 * Returns: the space between cells
	 */
	public int getSpacing();
	
	/**
	 * Sets the ::row-spacing property which specifies the space
	 * which is inserted between the rows of the icon view.
	 * Since 2.6
	 * Params:
	 * rowSpacing =  the row spacing
	 */
	public void setRowSpacing(int rowSpacing);
	
	/**
	 * Returns the value of the ::row-spacing property.
	 * Since 2.6
	 * Returns: the space between rows
	 */
	public int getRowSpacing();
	
	/**
	 * Sets the ::column-spacing property which specifies the space
	 * which is inserted between the columns of the icon view.
	 * Since 2.6
	 * Params:
	 * columnSpacing =  the column spacing
	 */
	public void setColumnSpacing(int columnSpacing);
	
	/**
	 * Returns the value of the ::column-spacing property.
	 * Since 2.6
	 * Returns: the space between columns
	 */
	public int getColumnSpacing();
	
	/**
	 * Sets the ::margin property which specifies the space
	 * which is inserted at the top, bottom, left and right
	 * of the icon view.
	 * Since 2.6
	 * Params:
	 * margin =  the margin
	 */
	public void setMargin(int margin);
	
	/**
	 * Returns the value of the ::margin property.
	 * Since 2.6
	 * Returns: the space at the borders
	 */
	public int getMargin();
	/**
	 * Sets the ::item-padding property which specifies the padding
	 * around each of the icon view's items.
	 * Since 2.18
	 * Params:
	 */
	public void setItemPadding(int itemPadding);
	
	/**
	 * Returns the value of the ::item-padding property.
	 * Since 2.18
	 * Returns: the padding around items
	 */
	public int getItemPadding();
	
	/**
	 * Selects the row at path.
	 * Since 2.6
	 * Params:
	 * path =  The GtkTreePath to be selected.
	 */
	public void selectPath(TreePath path);
	
	/**
	 * Unselects the row at path.
	 * Since 2.6
	 * Params:
	 * path =  The GtkTreePath to be unselected.
	 */
	public void unselectPath(TreePath path);
	
	/**
	 * Returns TRUE if the icon pointed to by path is currently
	 * selected. If path does not point to a valid location, FALSE is returned.
	 * Since 2.6
	 * Params:
	 * path =  A GtkTreePath to check selection on.
	 * Returns: TRUE if path is selected.
	 */
	public int pathIsSelected(TreePath path);
	
	/**
	 * Creates a list of paths of all selected items. Additionally, if you are
	 * planning on modifying the model after calling this function, you may
	 * want to convert the returned list into a list of GtkTreeRowReferences.
	 * To do this, you can use gtk_tree_row_reference_new().
	 * Since 2.6
	 * Returns: A GList containing a GtkTreePath for each selected row.
	 */
	public ListG getSelectedItems();
	
	/**
	 * Selects all the icons. icon_view must has its selection mode set
	 * to GTK_SELECTION_MULTIPLE.
	 * Since 2.6
	 */
	public void selectAll();
	
	/**
	 * Unselects all the icons.
	 * Since 2.6
	 */
	public void unselectAll();
	
	/**
	 * Activates the item determined by path.
	 * Since 2.6
	 * Params:
	 * path =  The GtkTreePath to be activated
	 */
	public void itemActivated(TreePath path);
	
	/**
	 * Moves the alignments of icon_view to the position specified by path.
	 * row_align determines where the row is placed, and col_align determines
	 * where column is placed. Both are expected to be between 0.0 and 1.0.
	 * 0.0 means left/top alignment, 1.0 means right/bottom alignment, 0.5 means
	 * center.
	 * If use_align is FALSE, then the alignment arguments are ignored, and the
	 * tree does the minimum amount of work to scroll the item onto the screen.
	 * This means that the item will be scrolled to the edge closest to its current
	 * position. If the item is currently visible on the screen, nothing is done.
	 * This function only works if the model is set, and path is a valid row on
	 * the model. If the model changes before the icon_view is realized, the
	 * centered path will be modified to reflect this change.
	 * Since 2.8
	 * Params:
	 * path =  The path of the item to move to.
	 * useAlign =  whether to use alignment arguments, or FALSE.
	 * rowAlign =  The vertical alignment of the item specified by path.
	 * colAlign =  The horizontal alignment of the item specified by path.
	 */
	public void scrollToPath(TreePath path, int useAlign, float rowAlign, float colAlign);
	
	/**
	 * Sets start_path and end_path to be the first and last visible path.
	 * Note that there may be invisible paths in between.
	 * Both paths should be freed with gtk_tree_path_free() after use.
	 * Since 2.8
	 * Params:
	 * startPath =  Return location for start of region, or NULL
	 * endPath =  Return location for end of region, or NULL
	 * Returns: TRUE, if valid paths were placed in start_path and end_path
	 */
	public int getVisibleRange(out TreePath startPath, out TreePath endPath);
	
	/**
	 * Sets the tip area of tooltip to be the area covered by the item at path.
	 * See also gtk_icon_view_set_tooltip_column() for a simpler alternative.
	 * See also gtk_tooltip_set_tip_area().
	 * Since 2.12
	 * Params:
	 * tooltip =  a GtkTooltip
	 * path =  a GtkTreePath
	 */
	public void setTooltipItem(Tooltip tooltip, TreePath path);
	
	/**
	 * Sets the tip area of tooltip to the area which cell occupies in
	 * the item pointed to by path. See also gtk_tooltip_set_tip_area().
	 * See also gtk_icon_view_set_tooltip_column() for a simpler alternative.
	 * Since 2.12
	 * Params:
	 * tooltip =  a GtkTooltip
	 * path =  a GtkTreePath
	 * cell =  a GtkCellRenderer or NULL
	 */
	public void setTooltipCell(Tooltip tooltip, TreePath path, CellRenderer cell);
	
	/**
	 * This function is supposed to be used in a "query-tooltip"
	 * signal handler for GtkIconView. The x, y and keyboard_tip values
	 * which are received in the signal handler, should be passed to this
	 * function without modification.
	 * The return value indicates whether there is an icon view item at the given
	 * coordinates (TRUE) or not (FALSE) for mouse tooltips. For keyboard
	 * tooltips the item returned will be the cursor item. When TRUE, then any of
	 * model, path and iter which have been provided will be set to point to
	 * that row and the corresponding model. x and y will always be converted
	 * to be relative to icon_view's bin_window if keyboard_tooltip is FALSE.
	 * Since 2.12
	 * Params:
	 * x =  the x coordinate (relative to widget coordinates)
	 * y =  the y coordinate (relative to widget coordinates)
	 * keyboardTip =  whether this is a keyboard tooltip or not
	 * model =  a pointer to receive a GtkTreeModel or NULL
	 * path =  a pointer to receive a GtkTreePath or NULL
	 * iter =  a pointer to receive a GtkTreeIter or NULL
	 * Returns: whether or not the given tooltip context points to a item
	 */
	public int getTooltipContext(int* x, int* y, int keyboardTip, out TreeModelIF model, out TreePath path, TreeIter iter);
	
	/**
	 * If you only plan to have simple (text-only) tooltips on full items, you
	 * can use this function to have GtkIconView handle these automatically
	 * for you. column should be set to the column in icon_view's model
	 * containing the tooltip texts, or -1 to disable this feature.
	 * When enabled, "has-tooltip" will be set to TRUE and
	 * icon_view will connect a "query-tooltip" signal handler.
	 * Since 2.12
	 * Params:
	 * column =  an integer, which is a valid column number for icon_view's model
	 */
	public void setTooltipColumn(int column);
	
	/**
	 * Returns the column of icon_view's model which is being used for
	 * displaying tooltips on icon_view's rows.
	 * Since 2.12
	 * Returns: the index of the tooltip column that is currently beingused, or -1 if this is disabled.
	 */
	public int getTooltipColumn();
	
	/**
	 * Turns icon_view into a drag source for automatic DND. Calling this
	 * method sets "reorderable" to FALSE.
	 * Since 2.8
	 * Params:
	 * startButtonMask =  Mask of allowed buttons to start drag
	 * targets =  the table of targets that the drag will support
	 * actions =  the bitmask of possible actions for a drag from this
	 *  widget
	 */
	public void enableModelDragSource(GdkModifierType startButtonMask, GtkTargetEntry[] targets, GdkDragAction actions);
	
	/**
	 * Turns icon_view into a drop destination for automatic DND. Calling this
	 * method sets "reorderable" to FALSE.
	 * Since 2.8
	 * Params:
	 * targets =  the table of targets that the drag will support
	 * actions =  the bitmask of possible actions for a drag to this
	 *  widget
	 */
	public void enableModelDragDest(GtkTargetEntry[] targets, GdkDragAction actions);
	
	/**
	 * Undoes the effect of gtk_icon_view_enable_model_drag_source(). Calling this
	 * method sets "reorderable" to FALSE.
	 * Since 2.8
	 */
	public void unsetModelDragSource();
	
	/**
	 * Undoes the effect of gtk_icon_view_enable_model_drag_dest(). Calling this
	 * method sets "reorderable" to FALSE.
	 * Since 2.8
	 */
	public void unsetModelDragDest();
	
	/**
	 * This function is a convenience function to allow you to reorder models that
	 * support the GtkTreeDragSourceIface and the GtkTreeDragDestIface. Both
	 * GtkTreeStore and GtkListStore support these. If reorderable is TRUE, then
	 * the user can reorder the model by dragging and dropping rows. The
	 * developer can listen to these changes by connecting to the model's
	 * row_inserted and row_deleted signals. The reordering is implemented by setting up
	 * the icon view as a drag source and destination. Therefore, drag and
	 * drop can not be used in a reorderable view for any other purpose.
	 * This function does not give you any degree of control over the order -- any
	 * reordering is allowed. If more control is needed, you should probably
	 * handle drag and drop manually.
	 * Since 2.8
	 * Params:
	 * reorderable =  TRUE, if the list of items can be reordered.
	 */
	public void setReorderable(int reorderable);
	
	/**
	 * Retrieves whether the user can reorder the list via drag-and-drop.
	 * See gtk_icon_view_set_reorderable().
	 * Since 2.8
	 * Returns: TRUE if the list can be reordered.
	 */
	public int getReorderable();
	
	/**
	 * Sets the item that is highlighted for feedback.
	 * Since 2.8
	 * Params:
	 * path =  The path of the item to highlight, or NULL.
	 * pos =  Specifies where to drop, relative to the item
	 */
	public void setDragDestItem(TreePath path, GtkIconViewDropPosition pos);
	
	/**
	 * Gets information about the item that is highlighted for feedback.
	 * Since 2.8
	 * Params:
	 * path =  Return location for the path of the highlighted item, or NULL.
	 * pos =  Return location for the drop position, or NULL
	 */
	public void getDragDestItem(out TreePath path, out GtkIconViewDropPosition pos);
	
	/**
	 * Determines the destination item for a given position.
	 * Since 2.8
	 * Params:
	 * dragX =  the position to determine the destination item for
	 * dragY =  the position to determine the destination item for
	 * path =  Return location for the path of the item, or NULL.
	 * pos =  Return location for the drop position, or NULL
	 * Returns: whether there is an item at the given position.
	 */
	public int getDestItemAtPos(int dragX, int dragY, out TreePath path, out GtkIconViewDropPosition pos);
	
	/**
	 * Creates a GdkPixmap representation of the item at path.
	 * This image is used for a drag icon.
	 * Since 2.8
	 * Params:
	 * path =  a GtkTreePath in icon_view
	 * Returns: a newly-allocated pixmap of the drag icon.
	 */
	public Pixmap createDragIcon(TreePath path);
}
