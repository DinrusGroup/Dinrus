module gtkD.gda.DataModelHash;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.gda.DataModel;
private import gtkD.gda.Value;
private import gtkD.gda.Row;



private import gtkD.gda.DataModel;

/**
 * Description
 * Unlike GdaDataModelArray, this data model implementation stores the GdaRow in
 * a hash table. So it only retrieves from the database backend exactly the
 * requested rows (while in GdaDataModelArray you have to retrieve all the rows
 * until the one requested).
 */
public class DataModelHash : DataModel
{
	
	/** the main Gtk struct */
	protected GdaDataModelHash* gdaDataModelHash;
	
	
	public GdaDataModelHash* getDataModelHashStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaDataModelHash* gdaDataModelHash);
	
	/**
	 */
	
	/**
	 * Params:
	 * cols =  number of columns for rows in this data model.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int cols);
	
	/**
	 * Retrieves the value at a specified column and row.
	 * Params:
	 * model =  the GdaDataModelHash to retrieve the value from.
	 * col =  column number (starting from 0).
	 * row =  row number (starting from 0).
	 * Returns: a pointer to a GdaValue.
	 */
	public static Value getValueAt(DataModel model, int col, int row);
	
	/**
	 * Frees all the rows inserted in model.
	 */
	public void clear();
	
	/**
	 * Sets the number of columns for rows inserted in this model.
	 * cols must be greater than or equal to 0.
	 * This function calls gda_data_model_hash_clear to free the
	 * existing rows if any.
	 * Params:
	 * cols =  the number of columns for rows inserted in model.
	 */
	public void setNColumns(int cols);
	
	/**
	 * Inserts a row in the model.
	 * Params:
	 * rownum =  the number of the row.
	 * row =  the row to insert. The model is responsible of freeing it!
	 */
	public void insertRow(int rownum, Row row);
	
	/**
	 * Retrieves a row from the underlying hash table.
	 * Params:
	 * model =  the GdaDataModelHash
	 * row =  row number
	 * Returns: a GdaRow or NULL if the requested row is not in the hash table.
	 */
	public static Row getRow(DataModel model, int row);
}
