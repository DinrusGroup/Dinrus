module gtkD.gtk.TreeViewColumn;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.CellRenderer;
private import gtkD.glib.ListG;
private import gtkD.gtk.Widget;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreeIter;
private import gtkD.gdk.Rectangle;
private import gtkD.glib.Str;
private import gtkD.gtk.CellLayoutIF;
private import gtkD.gtk.CellLayoutT;



private import gtkD.gtk.ObjectGtk;

/**
 * Description
 * The GtkTreeViewColumn object represents a visible column in a GtkTreeView widget.
 * It allows to set properties of the column header, and functions as a holding pen for
 * the cell renderers which determine how the data in the column is displayed.
 * Please refer to the tree widget conceptual overview
 * for an overview of all the objects and data types related to the tree widget and how
 * they work together.
 */
public class TreeViewColumn : ObjectGtk, CellLayoutIF
{
	
	/** the main Gtk struct */
	protected GtkTreeViewColumn* gtkTreeViewColumn;
	
	
	public GtkTreeViewColumn* getTreeViewColumnStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTreeViewColumn* gtkTreeViewColumn);
	
	// add the CellLayout capabilities
	mixin CellLayoutT!(GtkTreeViewColumn);
	
	/**
	 * Creates a new Tree view column
	 * Params:
	 *  header = th column header text
	 *  renderer = the rederer for the column cells
	 *  type = the type of data to be displayed (shouldn't this be on the renderer?)
	 *  column = the column number
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	this(string header, CellRenderer renderer, string type, int column);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(TreeViewColumn)[] onClickedListeners;
	/**
	 * See Also
	 * GtkTreeView, GtkTreeSelection, GtkTreeDnd, GtkTreeMode, GtkTreeSortable, GtkTreeModelSort, GtkListStore, GtkTreeStore, GtkCellRenderer, GtkCellEditable, GtkCellRendererPixbuf, GtkCellRendererText, GtkCellRendererToggle
	 */
	void addOnClicked(void delegate(TreeViewColumn) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackClicked(GtkTreeViewColumn* treeviewcolumnStruct, TreeViewColumn treeViewColumn);
	
	
	/**
	 * Creates a new GtkTreeViewColumn.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Packs the cell into the beginning of the column. If expand is FALSE, then
	 * the cell is allocated no more space than it needs. Any unused space is divided
	 * evenly between cells for which expand is TRUE.
	 * Params:
	 * cell =  The GtkCellRenderer.
	 * expand =  TRUE if cell is to be given extra space allocated to tree_column.
	 */
	public void packStart(CellRenderer cell, int expand);
	
	/**
	 * Adds the cell to end of the column. If expand is FALSE, then the cell
	 * is allocated no more space than it needs. Any unused space is divided
	 * evenly between cells for which expand is TRUE.
	 * Params:
	 * cell =  The GtkCellRenderer.
	 * expand =  TRUE if cell is to be given extra space allocated to tree_column.
	 */
	public void packEnd(CellRenderer cell, int expand);
	
	/**
	 * Unsets all the mappings on all renderers on the tree_column.
	 */
	public void clear();
	
	/**
	 * Warning
	 * gtk_tree_view_column_get_cell_renderers has been deprecated since version 2.18 and should not be used in newly-written code. use gtk_cell_layout_get_cells() instead.
	 * Returns a newly-allocated GList of all the cell renderers in the column,
	 * in no particular order. The list must be freed with g_list_free().
	 * Returns: A list of GtkCellRenderers
	 */
	public ListG getCellRenderers();
	
	/**
	 * Adds an attribute mapping to the list in tree_column. The column is the
	 * column of the model to get a value from, and the attribute is the
	 * parameter on cell_renderer to be set from the value. So for example
	 * if column 2 of the model contains strings, you could have the
	 * "text" attribute of a GtkCellRendererText get its values from
	 * column 2.
	 * Params:
	 * cellRenderer =  the GtkCellRenderer to set attributes on
	 * attribute =  An attribute on the renderer
	 * column =  The column position on the model to get the attribute from.
	 */
	public void addAttribute(CellRenderer cellRenderer, string attribute, int column);
	
	/**
	 * Sets the GtkTreeViewColumnFunc to use for the column. This
	 * function is used instead of the standard attributes mapping for
	 * setting the column value, and should set the value of tree_column's
	 * cell renderer as appropriate. func may be NULL to remove an
	 * older one.
	 * Params:
	 * cellRenderer =  A GtkCellRenderer
	 * func =  The GtkTreeViewColumnFunc to use.
	 * funcData =  The user data for func.
	 * destroy =  The destroy notification for func_data
	 */
	public void setCellDataFunc(CellRenderer cellRenderer, GtkTreeCellDataFunc func, void* funcData, GDestroyNotify destroy);
	
	/**
	 * Clears all existing attributes previously set with
	 * gtk_tree_view_column_set_attributes().
	 * Params:
	 * cellRenderer =  a GtkCellRenderer to clear the attribute mapping on.
	 */
	public void clearAttributes(CellRenderer cellRenderer);
	
	/**
	 * Sets the spacing field of tree_column, which is the number of pixels to
	 * place between cell renderers packed into it.
	 * Params:
	 * spacing =  distance between cell renderers in pixels.
	 */
	public void setSpacing(int spacing);
	
	/**
	 * Returns the spacing of tree_column.
	 * Returns: the spacing of tree_column.
	 */
	public int getSpacing();
	
	/**
	 * Sets the visibility of tree_column.
	 * Params:
	 * visible =  TRUE if the tree_column is visible.
	 */
	public void setVisible(int visible);
	
	/**
	 * Returns TRUE if tree_column is visible.
	 * Returns: whether the column is visible or not. If it is visible, thenthe tree will show the column.
	 */
	public int getVisible();
	
	/**
	 * If resizable is TRUE, then the user can explicitly resize the column by
	 * grabbing the outer edge of the column button. If resizable is TRUE and
	 * sizing mode of the column is GTK_TREE_VIEW_COLUMN_AUTOSIZE, then the sizing
	 * mode is changed to GTK_TREE_VIEW_COLUMN_GROW_ONLY.
	 * Params:
	 * resizable =  TRUE, if the column can be resized
	 */
	public void setResizable(int resizable);

	/**
	 * Returns TRUE if the tree_column can be resized by the end user.
	 * Returns: TRUE, if the tree_column can be resized.
	 */
	public int getResizable();
	
	/**
	 * Sets the growth behavior of tree_column to type.
	 * Params:
	 * type =  The GtkTreeViewColumnSizing.
	 */
	public void setSizing(GtkTreeViewColumnSizing type);
	
	/**
	 * Returns the current type of tree_column.
	 * Returns: The type of tree_column.
	 */
	public GtkTreeViewColumnSizing getSizing();

	/**
	 * Returns the current size of tree_column in pixels.
	 * Returns: The current width of tree_column.
	 */
	public int getWidth();
	
	/**
	 * Gets the fixed width of the column. This value is only meaning may not be
	 * the actual width of the column on the screen, just what is requested.
	 * Returns: the fixed width of the column
	 */
	public int getFixedWidth();
	
	/**
	 * Sets the size of the column in pixels. This is meaningful only if the sizing
	 * type is GTK_TREE_VIEW_COLUMN_FIXED. The size of the column is clamped to
	 * the min/max width for the column. Please note that the min/max width of the
	 * column doesn't actually affect the "fixed_width" property of the widget, just
	 * the actual size when displayed.
	 * Params:
	 * fixedWidth =  The size to set tree_column to. Must be greater than 0.
	 */
	public void setFixedWidth(int fixedWidth);
	
	/**
	 * Sets the minimum width of the tree_column. If min_width is -1, then the
	 * minimum width is unset.
	 * Params:
	 * minWidth =  The minimum width of the column in pixels, or -1.
	 */
	public void setMinWidth(int minWidth);
	
	/**
	 * Returns the minimum width in pixels of the tree_column, or -1 if no minimum
	 * width is set.
	 * Returns: The minimum width of the tree_column.
	 */
	public int getMinWidth();
	
	/**
	 * Sets the maximum width of the tree_column. If max_width is -1, then the
	 * maximum width is unset. Note, the column can actually be wider than max
	 * width if it's the last column in a view. In this case, the column expands to
	 * fill any extra space.
	 * Params:
	 * maxWidth =  The maximum width of the column in pixels, or -1.
	 */
	public void setMaxWidth(int maxWidth);
	
	/**
	 * Returns the maximum width in pixels of the tree_column, or -1 if no maximum
	 * width is set.
	 * Returns: The maximum width of the tree_column.
	 */
	public int getMaxWidth();
	
	/**
	 * Emits the "clicked" signal on the column. This function will only work if
	 * tree_column is clickable.
	 */
	public void clicked();

	/**
	 * Sets the title of the tree_column. If a custom widget has been set, then
	 * this value is ignored.
	 * Params:
	 * title =  The title of the tree_column.
	 */
	public void setTitle(string title);
	
	/**
	 * Returns the title of the widget.
	 * Returns: the title of the column. This string should not bemodified or freed.
	 */
	public string getTitle();
	
	/**
	 * Sets the column to take available extra space. This space is shared equally
	 * amongst all columns that have the expand set to TRUE. If no column has this
	 * option set, then the last column gets all extra space. By default, every
	 * column is created with this FALSE.
	 * Since 2.4
	 * Params:
	 * expand =  TRUE if the column should take available extra space, FALSE if not
	 */
	public void setExpand(int expand);
	
	/**
	 * Return TRUE if the column expands to take any available space.
	 * Since 2.4
	 * Returns: TRUE, if the column expands
	 */
	public int getExpand();
	
	/**
	 * Sets the header to be active if active is TRUE. When the header is active,
	 * then it can take keyboard focus, and can be clicked.
	 * Params:
	 * clickable =  TRUE if the header is active.
	 */
	public void setClickable(int clickable);
	
	/**
	 * Returns TRUE if the user can click on the header for the column.
	 * Returns: TRUE if user can click the column header.
	 */
	public int getClickable();
	
	/**
	 * Sets the widget in the header to be widget. If widget is NULL, then the
	 * header button is set with a GtkLabel set to the title of tree_column.
	 * Params:
	 * widget =  A child GtkWidget, or NULL.
	 */
	public void setWidget(Widget widget);
	
	/**
	 * Returns the GtkWidget in the button on the column header. If a custom
	 * widget has not been set then NULL is returned.
	 * Returns: The GtkWidget in the column header, or NULL
	 */
	public Widget getWidget();
	
	/**
	 * Sets the alignment of the title or custom widget inside the column header.
	 * The alignment determines its location inside the button -- 0.0 for left, 0.5
	 * for center, 1.0 for right.
	 * Params:
	 * xalign =  The alignment, which is between [0.0 and 1.0] inclusive.
	 */
	public void setAlignment(float xalign);
	
	/**
	 * Returns the current x alignment of tree_column. This value can range
	 * between 0.0 and 1.0.
	 * Returns: The current alignent of tree_column.
	 */
	public float getAlignment();
	
	/**
	 * If reorderable is TRUE, then the column can be reordered by the end user
	 * dragging the header.
	 * Params:
	 * reorderable =  TRUE, if the column can be reordered.
	 */
	public void setReorderable(int reorderable);
	
	/**
	 * Returns TRUE if the tree_column can be reordered by the user.
	 * Returns: TRUE if the tree_column can be reordered by the user.
	 */
	public int getReorderable();
	
	/**
	 * Sets the logical sort_column_id that this column sorts on when this column
	 * is selected for sorting. Doing so makes the column header clickable.
	 * Params:
	 * sortColumnId =  The sort_column_id of the model to sort on.
	 */
	public void setSortColumnId(int sortColumnId);
	
	/**
	 * Gets the logical sort_column_id that the model sorts on when this
	 * column is selected for sorting.
	 * See gtk_tree_view_column_set_sort_column_id().
	 * Returns: the current sort_column_id for this column, or -1 if this column can't be used for sorting.
	 */
	public int getSortColumnId();
	
	/**
	 * Call this function with a setting of TRUE to display an arrow in
	 * the header button indicating the column is sorted. Call
	 * gtk_tree_view_column_set_sort_order() to change the direction of
	 * the arrow.
	 * Params:
	 * setting =  TRUE to display an indicator that the column is sorted
	 */
	public void setSortIndicator(int setting);
	
	/**
	 * Gets the value set by gtk_tree_view_column_set_sort_indicator().
	 * Returns: whether the sort indicator arrow is displayed
	 */
	public int getSortIndicator();
	
	/**
	 * Changes the appearance of the sort indicator.
	 * This does not actually sort the model. Use
	 * gtk_tree_view_column_set_sort_column_id() if you want automatic sorting
	 * support. This function is primarily for custom sorting behavior, and should
	 * be used in conjunction with gtk_tree_sortable_set_sort_column() to do
	 * that. For custom models, the mechanism will vary.
	 * The sort indicator changes direction to indicate normal sort or reverse sort.
	 * Note that you must have the sort indicator enabled to see anything when
	 * calling this function; see gtk_tree_view_column_set_sort_indicator().
	 * Params:
	 * order =  sort order that the sort indicator should indicate
	 */
	public void setSortOrder(GtkSortType order);
	
	/**
	 * Gets the value set by gtk_tree_view_column_set_sort_order().
	 * Returns: the sort order the sort indicator is indicating
	 */
	public GtkSortType getSortOrder();
	
	/**
	 * Sets the cell renderer based on the tree_model and iter. That is, for
	 * every attribute mapping in tree_column, it will get a value from the set
	 * column on the iter, and use that value to set the attribute on the cell
	 * renderer. This is used primarily by the GtkTreeView.
	 * Params:
	 * treeModel =  The GtkTreeModel to to get the cell renderers attributes from.
	 * iter =  The GtkTreeIter to to get the cell renderer's attributes from.
	 * isExpander =  TRUE, if the row has children
	 * isExpanded =  TRUE, if the row has visible children
	 */
	public void cellSetCellData(TreeModelIF treeModel, TreeIter iter, int isExpander, int isExpanded);
	
	/**
	 * Obtains the width and height needed to render the column. This is used
	 * primarily by the GtkTreeView.
	 * Params:
	 * cellArea =  The area a cell in the column will be allocated, or NULL
	 * xOffset =  location to return x offset of a cell relative to cell_area, or NULL
	 * yOffset =  location to return y offset of a cell relative to cell_area, or NULL
	 * width =  location to return width needed to render a cell, or NULL
	 * height =  location to return height needed to render a cell, or NULL
	 */
	public void cellGetSize(Rectangle cellArea, out int xOffset, out int yOffset, out int width, out int height);
	
	/**
	 * Obtains the horizontal position and size of a cell in a column. If the
	 * cell is not found in the column, start_pos and width are not changed and
	 * FALSE is returned.
	 * Params:
	 * cellRenderer =  a GtkCellRenderer
	 * startPos =  return location for the horizontal position of cell within
	 *  tree_column, may be NULL
	 * width =  return location for the width of cell, may be NULL
	 * Returns: TRUE if cell belongs to tree_column.
	 */
	public int cellGetPosition(CellRenderer cellRenderer, out int startPos, out int width);
	
	/**
	 * Returns TRUE if any of the cells packed into the tree_column are visible.
	 * For this to be meaningful, you must first initialize the cells with
	 * gtk_tree_view_column_cell_set_cell_data()
	 * Returns: TRUE, if any of the cells packed into the tree_column are currently visible
	 */
	public int cellIsVisible();

	/**
	 * Sets the current keyboard focus to be at cell, if the column contains
	 * 2 or more editable and activatable cells.
	 * Since 2.2
	 * Params:
	 * cell =  A GtkCellRenderer
	 */
	public void focusCell(CellRenderer cell);
	
	/**
	 * Flags the column, and the cell renderers added to this column, to have
	 * their sizes renegotiated.
	 * Since 2.8
	 */
	public void queueResize();
	
	/**
	 * Returns the GtkTreeView wherein tree_column has been inserted. If
	 * column is currently not inserted in any tree view, NULL is
	 * returned.
	 * Since 2.12
	 * Returns: The tree view wherein column has been inserted if any, NULL otherwise.
	 */
	public Widget getTreeView();
}
