module gtkD.gda.DataModel;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gda.FieldAttributes;
private import gtkD.gda.Row;
private import gtkD.gda.Value;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class DataModel : ObjectG
{
	
	/** the main Gtk struct */
	protected GdaDataModel* gdaDataModel;
	
	
	public GdaDataModel* getDataModelStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaDataModel* gdaDataModel);
	
	/** */
	this (ListG glist) ;
	
	/**
	 */
	
	/**
	 * Notifies listeners of the given data model object of changes
	 * in the underlying data. Listeners usually will connect
	 * themselves to the "changed" signal in the GdaDataModel
	 * class, thus being notified of any new data being appended
	 * or removed from the data model.
	 */
	public void changed();
	
	/**
	 * Emits the 'row_inserted' and 'changed' signals on model.
	 * Params:
	 * row =  row number.
	 */
	public void rowInserted(int row);
	
	/**
	 * Emits the 'row_updated' and 'changed' signals on model.
	 * Params:
	 * row =  row number.
	 */
	public void rowUpdated(int row);
	
	/**
	 * Emits the 'row_removed' and 'changed' signal on model.
	 * Params:
	 * row =  row number.
	 */
	public void rowRemoved(int row);
	
	/**
	 * Emits the 'column_inserted' and 'changed' signals on model.
	 * Params:
	 * col =  column number.
	 */
	public void columnInserted(int col);
	
	/**
	 * Emits the 'column_updated' and 'changed' signals on model.
	 * Params:
	 * col =  column number.
	 */
	public void columnUpdated(int col);
	
	/**
	 * Emits the 'column_removed' and 'changed' signal on model.
	 * Params:
	 * col =  column number.
	 */
	public void columnRemoved(int col);
	
	/**
	 * Disables notifications of changes on the given data model. To
	 * re-enable notifications again, you should call the
	 * gda_data_model_thaw function.
	 */
	public void freeze();
	
	/**
	 * Re-enables notifications of changes on the given data model.
	 */
	public void thaw();
	
	/**
	 * Returns: the number of rows in the given data model.
	 */
	public int getNRows();
	
	/**
	 * Returns: the number of columns in the given data model.
	 */
	public int getNColumns();
	
	/**
	 * Queries the underlying data model implementation for a description
	 * of a given column. That description is returned in the form of
	 * a GdaFieldAttributes structure, which contains all the information
	 * about the given column in the data model.
	 * Params:
	 * col =  column number.
	 * Returns: the description of the column.
	 */
	public FieldAttributes describeColumn(int col);
	
	/**
	 * Params:
	 * col =  column number.
	 * Returns: the title for the given column in a data model object.
	 */
	public string getColumnTitle(int col);
	
	/**
	 * Sets the title of the given col in model.
	 * Params:
	 * col =  column number
	 * title =  title for the given column.
	 */
	public void setColumnTitle(int col, string title);
	
	/**
	 * Gets the position of a column on the data model, based on
	 * the column's title.
	 * Params:
	 * title =  column title.
	 * Returns: the position of the column in the data model, or -1if the column could not be found.
	 */
	public int getColumnPosition(string title);
	
	/**
	 * Retrieves a given row from a data model.
	 * Params:
	 * row =  row number.
	 * Returns: a GdaRow object.
	 */
	public Row getRow(int row);
	
	/**
	 * Retrieves the data stored in the given position (identified by
	 * the col and row parameters) on a data model.
	 * This is the main function for accessing data in a model.
	 * Params:
	 * col =  column number.
	 * row =  row number.
	 * Returns: a GdaValue containing the value stored in the givenposition, or NULL on error (out-of-bound position, etc).
	 */
	public Value getValueAt(int col, int row);
	
	/**
	 * Checks whether the given data model can be updated or not.
	 * Returns: TRUE if it can be updated, FALSE if not.
	 */
	public int isUpdatable();
	
	/**
	 * Appends a row to the given data model.
	 * Params:
	 * values =  GList of GdaValue* representing the row to add. The
	 *  length must match model's column count. These GdaValue
	 *  are value-copied. The user is still responsible for freeing them.
	 * Returns: the added row.
	 */
	public Row appendRow(ListG values);
	
	/**
	 * Removes a row from the data model. This results in the underlying
	 * database row being removed in the database.
	 * Params:
	 * row =  the GdaRow to be removed.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int removeRow(Row row);
	
	/**
	 * Updates a row data model. This results in the underlying
	 * database row's values being changed.
	 * Params:
	 * row =  the GdaRow to be updated.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int updateRow(Row row);
	
	/**
	 * Appends a column to the given data model. If successful, the position of
	 * the new column in the data model is set on col, and you can grab it using
	 * gda_field_attributes_get_position.
	 * Params:
	 * attrs =  a GdaFieldAttributes describing the column to add.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int appendColumn(FieldAttributes attrs);
	
	/**
	 * Updates a column in the given data model. This results in the underlying
	 * database row's values being changed.
	 * Params:
	 * col =  the column to be updated.
	 * attrs =  attributes for the column.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int updateColumn(int col, FieldAttributes attrs);
	
	/**
	 * Removes a column from the data model. This means that all values attached to this
	 * column in the data model will be destroyed in the underlying database.
	 * Params:
	 * col =  the column to be removed.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int removeColumn(int col);
	
	/**
	 * Calls the specified callback function for each row in the data model.
	 * This will just traverse all rows, and call the given callback
	 * function for each of them.
	 * Params:
	 * func =  callback function.
	 * userData =  context data for the callback function.
	 */
	public void foreac(GdaDataModelForeachFunc func, void* userData);
	
	/**
	 * Checks whether this data model is in updating mode or not. Updating
	 * mode is set to TRUE when gda_data_model_begin_update has been
	 * called successfully, and is not set back to FALSE until either
	 * gda_data_model_cancel_update or gda_data_model_end_update have
	 * been called.
	 * Returns: TRUE if updating mode, FALSE otherwise.
	 */
	public int hasChanged();
	
	/**
	 * Starts update of this data model. This function should be the
	 * first called when modifying the data model.
	 * Returns: TRUE on success, FALSE if there was an error.
	 */
	public int beginUpdate();
	
	/**
	 * Cancels update of this data model. This means that all changes
	 * will be discarded, and the old data put back in the model.
	 * Returns: TRUE on success, FALSE if there was an error.
	 */
	public int cancelUpdate();
	
	/**
	 * Approves all modifications and send them to the underlying
	 * data source/store.
	 * Returns: TRUE on success, FALSE if there was an error.
	 */
	public int endUpdate();
	
	/**
	 * Converts the given model into a comma-separated series of rows.
	 * Returns: the representation of the model. You should free thisstring when you no longer need it.
	 */
	public string toCommaSeparated();
	
	/**
	 * Converts the given model into a tab-separated series of rows.
	 * Returns: the representation of the model. You should free thisstring when you no longer need it.
	 */
	public string toTabSeparated();
	
	/**
	 * Converts the given model into a XML representation.
	 * Params:
	 * standalone =  whether ...
	 * Returns: the representation of the model. You should free thisstring when you no longer need it.
	 */
	public string toXml(int standalone);
	
	/**
	 * Converts a GdaDataModel into a xmlNodePtr (as used in libxml).
	 * Params:
	 * name =  name to use for the XML resulting table.
	 * Returns: a xmlNodePtr representing the whole data model.
	 */
	public xmlNodePtr toXmlNode(string name);
	
	/**
	 * Adds the data from a XML node to the given data model.
	 * Params:
	 * node =  a XML node representing a lt;datagt; XML node.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int addDataFromXmlNode(xmlNodePtr node);
	
	/**
	 * Gets the text of command that generated this data model.
	 * Returns: a string with the command issued.
	 */
	public string getCommandText();
	
	/**
	 * Sets the command text of the given model.
	 * Params:
	 * txt =  the command text.
	 */
	public void setCommandText(string txt);
	
	/**
	 * Gets the type of command that generated this data model.
	 * Returns: a GdaCommandType.
	 */
	public GdaCommandType getCommandType();
	
	/**
	 * Sets the type of command that generated this data model.
	 * Params:
	 * type =  the type of the command (one of GdaCommandType)
	 */
	public void setCommandType(GdaCommandType type);
}
