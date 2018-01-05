module gtkD.gtk.Table;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;



private import gtkD.gtk.Container;

/**
 * Description
 * The GtkTable functions allow the programmer to arrange widgets in rows and
 * columns, making it easy to align many widgets next to each other,
 * horizontally and vertically.
 * Tables are created with a call to gtk_table_new(), the size of which can
 * later be changed with gtk_table_resize().
 * Widgets can be added to a table using gtk_table_attach() or the more
 * convenient (but slightly less flexible) gtk_table_attach_defaults().
 * To alter the space next to a specific row, use gtk_table_set_row_spacing(),
 * and for a column, gtk_table_set_col_spacing().
 * The gaps between all rows or columns can be changed by calling
 * gtk_table_set_row_spacings() or gtk_table_set_col_spacings() respectively.
 * gtk_table_set_homogeneous(), can be used to set whether all cells in the
 * table will resize themselves to the size of the largest widget in the table.
 */
public class Table : Container
{
	
	/** the main Gtk struct */
	protected GtkTable* gtkTable;
	
	
	public GtkTable* getTableStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTable* gtkTable);
	
	int row;
	int col;
	int maxRows;
	int maxCols;
	
	public AttachOptions defaultXOption = AttachOptions.SHRINK;
	public AttachOptions defaultYOption = AttachOptions.SHRINK;
	
	/**
	 * Removes all children and resizes the table to 1,1
	 */
	override void removeAll();
	
	/**
	 * Used to create a new table widget. An initial size must be given by
	 * specifying how many rows and columns the table should have, although
	 * this can be changed later with gtk_table_resize(). rows and columns
	 * must both be in the range 0 .. 65535.
	 * Params:
	 *  rows = The number of rows the new table should have.
	 *  columns = The number of columns the new table should have.
	 *  homogeneous = If set to TRUE, all table cells are resized to the size of the cell
	 *  containing the largest widget.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (uint rows, uint columns, int homogeneous);
	
	
	/**
	 * Attach a new widget creating a new row if necessary
	 */
	void attach(Widget child);
	
	/**
	 */
	
	/**
	 * If you need to change a table's size after it has been created, this function allows you to do so.
	 * Params:
	 * rows = The new number of rows.
	 * columns = The new number of columns.
	 */
	public void resize(uint rows, uint columns);
	
	/**
	 * Adds a widget to a table. The number of 'cells' that a widget will occupy is
	 * specified by left_attach, right_attach, top_attach and bottom_attach.
	 * These each represent the leftmost, rightmost, uppermost and lowest column
	 * and row numbers of the table. (Columns and rows are indexed from zero).
	 * Params:
	 * child = The widget to add.
	 * leftAttach = the column number to attach the left side of a child widget to.
	 * rightAttach = the column number to attach the right side of a child widget to.
	 * topAttach = the row number to attach the top of a child widget to.
	 * bottomAttach = the row number to attach the bottom of a child widget to.
	 * xoptions = Used to specify the properties of the child widget when the table is resized.
	 * yoptions = The same as xoptions, except this field determines behaviour of vertical resizing.
	 * xpadding = An integer value specifying the padding on the left and right of the widget being added to the table.
	 * ypadding = The amount of padding above and below the child widget.
	 */
	public void attach(Widget child, uint leftAttach, uint rightAttach, uint topAttach, uint bottomAttach, GtkAttachOptions xoptions, GtkAttachOptions yoptions, uint xpadding, uint ypadding);
	
	/**
	 * As there are many options associated with gtk_table_attach(), this convenience function provides the programmer with a means to add children to a table with identical padding and expansion options. The values used for the GtkAttachOptions are GTK_EXPAND | GTK_FILL, and the padding is set to 0.
	 * Params:
	 * widget = The child widget to add.
	 * leftAttach = The column number to attach the left side of the child widget to.
	 * rightAttach = The column number to attach the right side of the child widget to.
	 * topAttach = The row number to attach the top of the child widget to.
	 * bottomAttach = The row number to attach the bottom of the child widget to.
	 */
	public void attachDefaults(Widget widget, uint leftAttach, uint rightAttach, uint topAttach, uint bottomAttach);
	
	/**
	 * Changes the space between a given table row and the subsequent row.
	 * Params:
	 * row = row number whose spacing will be changed.
	 * spacing = number of pixels that the spacing should take up.
	 */
	public void setRowSpacing(uint row, uint spacing);
	
	/**
	 * Alters the amount of space between a given table column and the following
	 * column.
	 * Params:
	 * column = the column whose spacing should be changed.
	 * spacing = number of pixels that the spacing should take up.
	 */
	public void setColSpacing(uint column, uint spacing);
	
	/**
	 * Sets the space between every row in table equal to spacing.
	 * Params:
	 * spacing = the number of pixels of space to place between every row in the table.
	 */
	public void setRowSpacings(uint spacing);
	
	/**
	 * Sets the space between every column in table equal to spacing.
	 * Params:
	 * spacing = the number of pixels of space to place between every column in the table.
	 */
	public void setColSpacings(uint spacing);
	
	/**
	 * Changes the homogenous property of table cells, ie. whether all cells are an equal size or not.
	 * Params:
	 * homogeneous = Set to TRUE to ensure all table cells are the same size. Set
	 * to FALSE if this is not your desired behaviour.
	 */
	public void setHomogeneous(int homogeneous);
	
	/**
	 * Gets the default row spacing for the table. This is
	 * the spacing that will be used for newly added rows.
	 * (See gtk_table_set_row_spacings())
	 * Returns: the default row spacing
	 */
	public uint getDefaultRowSpacing();
	
	/**
	 * Returns whether the table cells are all constrained to the same
	 * width and height. (See gtk_table_set_homogenous())
	 * Returns: TRUE if the cells are all constrained to the same size
	 */
	public int getHomogeneous();
	
	/**
	 * Gets the amount of space between row row, and
	 * row row + 1. See gtk_table_set_row_spacing().
	 * Params:
	 * row =  a row in the table, 0 indicates the first row
	 * Returns: the row spacing
	 */
	public uint getRowSpacing(uint row);
	
	/**
	 * Gets the amount of space between column col, and
	 * column col + 1. See gtk_table_set_col_spacing().
	 * Params:
	 * column =  a column in the table, 0 indicates the first column
	 * Returns: the column spacing
	 */
	public uint getColSpacing(uint column);
	
	/**
	 * Gets the default column spacing for the table. This is
	 * the spacing that will be used for newly added columns.
	 * (See gtk_table_set_col_spacings())
	 * Returns: the default column spacing
	 */
	public uint getDefaultColSpacing();
}
