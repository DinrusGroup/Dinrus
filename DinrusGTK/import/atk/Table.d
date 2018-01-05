module gtkD.atk.Table;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.atk.ObjectAtk;
private import gtkD.glib.Str;




/**
 * Description
 * AtkTable should be implemented by components which present elements
 * ordered via rows and columns. It may also be used to present
 * tree-structured information if the nodes of the trees can be said to
 * contain multiple "columns". Individual elements of an AtkTable are
 * typically referred to as "cells", and these cells are exposed by
 * AtkTable as child AtkObjects of the AtkTable. Both row/column and
 * child-index-based access to these children is provided.
 * Children of AtkTable are frequently "lightweight" objects, that is,
 * they may not have backing widgets in the host UI toolkit. They are
 * therefore often transient.
 * Since tables are often very complex, AtkTable includes provision for
 * offering simplified summary information, as well as row and column
 * headers and captions. Headers and captions are AtkObjects which may
 * implement other interfaces (AtkText, AtkImage, etc.) as appropriate.
 * AtkTable summaries may themselves be (simplified) AtkTables, etc.
 */
public class Table
{

	/** the main Gtk struct */
	protected AtkTable* atkTable;


	public AtkTable* getTableStruct();


	/** the main Gtk struct as a void* */
	protected void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkTable* atkTable);

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(gint, gint, Table)[] onColumnDeletedListeners;
	/**
	 * The "column-deleted" signal is emitted by an object which implements the
	 * AtkTable interface when a column is deleted.
	 */
	void addOnColumnDeleted(void delegate(gint, gint, Table) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackColumnDeleted(AtkTable* atktableStruct, gint arg1, gint arg2, Table table);


	void delegate(gint, gint, Table)[] onColumnInsertedListeners;
	/**
	 * The "column-inserted" signal is emitted by an object which implements the
	 * AtkTable interface when a column is inserted.
	 */
	void addOnColumnInserted(void delegate(gint, gint, Table) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackColumnInserted(AtkTable* atktableStruct, gint arg1, gint arg2, Table table);


	void delegate(Table)[] onColumnReorderedListeners;
	/**
	 * The "column-reordered" signal is emitted by an object which implements the
	 * AtkTable interface when the columns are reordered.
	 */
	void addOnColumnReordered(void delegate(Table) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackColumnReordered(AtkTable* atktableStruct, Table table);


	void delegate(Table)[] onModelChangedListeners;
	/**
	 * The "model-changed" signal is emitted by an object which implements the
	 * AtkTable interface when the model displayed by the table changes.
	 */
	void addOnModelChanged(void delegate(Table) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackModelChanged(AtkTable* atktableStruct, Table table);


	void delegate(gint, gint, Table)[] onRowDeletedListeners;
	/**
	 * The "row-deleted" signal is emitted by an object which implements the
	 * AtkTable interface when a column is inserted.
	 */
	void addOnRowDeleted(void delegate(gint, gint, Table) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackRowDeleted(AtkTable* atktableStruct, gint arg1, gint arg2, Table table);

	void delegate(gint, gint, Table)[] onRowInsertedListeners;
	/**
	 * The "row-inserted" signal is emitted by an object which implements the
	 * AtkTable interface when a column is inserted.
	 */
	void addOnRowInserted(void delegate(gint, gint, Table) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackRowInserted(AtkTable* atktableStruct, gint arg1, gint arg2, Table table);

	void delegate(Table)[] onRowReorderedListeners;
	/**
	 * The "row-reordered" signal is emitted by an object which implements the
	 * AtkTable interface when the columns are reordered.
	 * See Also
	 * AtkObject, ATK_STATE_TRANSIENT
	 */
	void addOnRowReordered(void delegate(Table) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackRowReordered(AtkTable* atktableStruct, Table table);


	/**
	 * Get a reference to the table cell at row, column.
	 * Params:
	 * row =  a gint representing a row in table
	 * column =  a gint representing a column in table
	 * Returns: a AtkObject* representing the referred to accessible
	 */
	public ObjectAtk refAt(int row, int column);

	/**
	 * Gets a gint representing the index at the specified row and column.
	 * Params:
	 * row =  a gint representing a row in table
	 * column =  a gint representing a column in table
	 * Returns: a gint representing the index at specified position.The value -1 is returned if the object at row,column is not a childof table or table does not implement this interface.
	 */
	public int getIndexAt(int row, int column);

	/**
	 * Gets a gint representing the column at the specified index_.
	 * Params:
	 * index =  a gint representing an index in table
	 * Returns: a gint representing the column at the specified index,or -1 if the table does not implement this interface
	 */
	public int getColumnAtIndex(int index);

	/**
	 * Gets a gint representing the row at the specified index_.
	 * Params:
	 * index =  a gint representing an index in table
	 * Returns: a gint representing the row at the specified index,or -1 if the table does not implement this interface
	 */
	public int getRowAtIndex(int index);

	/**
	 * Gets the number of columns in the table.
	 * Returns: a gint representing the number of columns, or 0if value does not implement this interface.
	 */
	public int getNColumns();

	/**
	 * Gets the number of rows in the table.
	 * Returns: a gint representing the number of rows, or 0if value does not implement this interface.
	 */
	public int getNRows();

	/**
	 * Gets the number of columns occupied by the accessible object
	 * at the specified row and column in the table.
	 * Params:
	 * row =  a gint representing a row in table
	 * column =  a gint representing a column in table
	 * Returns: a gint representing the column extent at specified position, or 0if value does not implement this interface.
	 */
	public int getColumnExtentAt(int row, int column);

	/**
	 * Gets the number of rows occupied by the accessible object
	 * at a specified row and column in the table.
	 * Params:
	 * row =  a gint representing a row in table
	 * column =  a gint representing a column in table
	 * Returns: a gint representing the row extent at specified position, or 0if value does not implement this interface.
	 */
	public int getRowExtentAt(int row, int column);

	/**
	 * Gets the caption for the table.
	 * Returns: a AtkObject* representing the table caption, or NULLif value does not implement this interface.
	 */
	public ObjectAtk getCaption();

	/**
	 * Gets the description text of the specified column in the table
	 * Params:
	 * column =  a gint representing a column in table
	 * Returns: a gchar* representing the column description, or NULLif value does not implement this interface.
	 */
	public string getColumnDescription(int column);

	/**
	 * Gets the description text of the specified row in the table
	 * Params:
	 * row =  a gint representing a row in table
	 * Returns: a gchar* representing the row description, or NULLif value does not implement this interface.
	 */
	public string getRowDescription(int row);

	/**
	 * Gets the column header of a specified column in an accessible table.
	 * Params:
	 * column =  a gint representing a column in the table
	 * Returns: a AtkObject* representing the specified column header, orNULL if value does not implement this interface.
	 */
	public ObjectAtk getColumnHeader(int column);

	/**
	 * Gets the row header of a specified row in an accessible table.
	 * Params:
	 * row =  a gint representing a row in the table
	 * Returns: a AtkObject* representing the specified row header, orNULL if value does not implement this interface.
	 */
	public ObjectAtk getRowHeader(int row);

	/**
	 * Gets the summary description of the table.
	 * Returns: a AtkObject* representing a summary description of the table,or zero if value does not implement this interface.
	 */
	public ObjectAtk getSummary();

	/**
	 * Sets the caption for the table.
	 * Params:
	 * caption =  a AtkObject representing the caption to set for table
	 */
	public void setCaption(ObjectAtk caption);

	/**
	 * Sets the description text for the specified row of table.
	 * Params:
	 * row =  a gint representing a row in table
	 * description =  a gchar representing the description text
	 * to set for the specified row of table
	 */
	public void setRowDescription(int row, string description);

	/**
	 * Sets the description text for the specified column of the table.
	 * Params:
	 * column =  a gint representing a column in table
	 * description =  a gchar representing the description text
	 * to set for the specified column of the table
	 */
	public void setColumnDescription(int column, string description);

	/**
	 * Sets the specified row header to header.
	 * Params:
	 * row =  a gint representing a row in table
	 * header =  an AtkTable
	 */
	public void setRowHeader(int row, ObjectAtk header);

	/**
	 * Sets the specified column header to header.
	 * Params:
	 * column =  a gint representing a column in table
	 * header =  an AtkTable
	 */
	public void setColumnHeader(int column, ObjectAtk header);

	/**
	 * Sets the summary description of the table.
	 * Params:
	 * accessible =  an AtkObject representing the summary description
	 * to set for table
	 */
	public void setSummary(ObjectAtk accessible);

	/**
	 * Gets the selected columns of the table by initializing **selected with
	 * the selected column numbers. This array should be freed by the caller.
	 * Params:
	 * selected =  a gint** that is to contain the selected columns numbers
	 * Returns: a gint representing the number of selected columns,or 0 if value does not implement this interface.
	 */
	public int getSelectedColumns(out int[] selected);

	/**
	 * Gets the selected rows of the table by initializing **selected with
	 * the selected row numbers. This array should be freed by the caller.
	 * Params:
	 * selected =  a gint** that is to contain the selected row numbers
	 * Returns: a gint representing the number of selected rows,or zero if value does not implement this interface.
	 */
	public int getSelectedRows(out int[] selected);

	/**
	 * Gets a boolean value indicating whether the specified column
	 * is selected
	 * Params:
	 * column =  a gint representing a column in table
	 * Returns: a gboolean representing if the column is selected, or 0if value does not implement this interface.
	 */
	public int isColumnSelected(int column);

	/**
	 * Gets a boolean value indicating whether the specified row
	 * is selected
	 * Params:
	 * row =  a gint representing a row in table
	 * Returns: a gboolean representing if the row is selected, or 0if value does not implement this interface.
	 */
	public int isRowSelected(int row);

	/**
	 * Gets a boolean value indicating whether the accessible object
	 * at the specified row and column is selected
	 * Params:
	 * row =  a gint representing a row in table
	 * column =  a gint representing a column in table
	 * Returns: a gboolean representing if the cell is selected, or 0if value does not implement this interface.
	 */
	public int isSelected(int row, int column);

	/**
	 * Adds the specified column to the selection.
	 * Params:
	 * column =  a gint representing a column in table
	 * Returns: a gboolean representing if the column was successfully added to the selection, or 0 if value does not implement this interface.
	 */
	public int addColumnSelection(int column);

	/**
	 * Adds the specified row to the selection.
	 * Params:
	 * row =  a gint representing a row in table
	 * Returns: a gboolean representing if row was successfully added to selection,or 0 if value does not implement this interface.
	 */
	public int addRowSelection(int row);

	/**
	 * Adds the specified column to the selection.
	 * Params:
	 * column =  a gint representing a column in table
	 * Returns: a gboolean representing if the column was successfully removed fromthe selection, or 0 if value does not implement this interface.
	 */
	public int removeColumnSelection(int column);

	/**
	 * Removes the specified row from the selection.
	 * Params:
	 * row =  a gint representing a row in table
	 * Returns: a gboolean representing if the row was successfully removed fromthe selection, or 0 if value does not implement this interface.Signal DetailsThe "column-deleted" signalvoid user_function (AtkTable *atktable, gint arg1, gint arg2, gpointer user_data) : Run LastThe "column-deleted" signal is emitted by an object which implements theAtkTable interface when a column is deleted.
	 */
	public int removeRowSelection(int row);
}
