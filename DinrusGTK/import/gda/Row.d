module gtkD.gda.Row;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gda.Value;
private import gtkD.gda.DataModel;




/**
 * Description
 */
public class Row
{
	
	/** the main Gtk struct */
	protected GdaRow* gdaRow;
	
	
	public GdaRow* getRowStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaRow* gdaRow);
	
	/**
	 */
	
	/**
	 * Returns:
	 */
	public static GType getType();
	
	/**
	 * Creates a GdaRow which can hold count GdaValue.
	 * Params:
	 * model =  the GdaDataModel this row belongs to.
	 * count =  number of GdaValue in the new GdaRow.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (DataModel model, int count);
	
	/**
	 * Creates a GdaRow from a list of GdaValue's. These GdaValue's are
	 * value-copied and the user are still resposible for freeing them.
	 * Params:
	 * model =  a GdaDataModel.
	 * values =  a list of GdaValue's.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (DataModel model, GList* values);
	
	/**
	 * Creates a new GdaRow from an existing one.
	 * Returns: a newly allocated GdaRow with a copy of the data in row.
	 */
	public Row copy();
	
	/**
	 * Deallocates all memory associated to a GdaRow.
	 */
	public void free();
	
	/**
	 * Gets the GdaDataModel the given GdaRow belongs to.
	 * Returns: a GdaDataModel.
	 */
	public DataModel getModel();
	
	/**
	 * Gets the number of the given row, that is, its position in its containing
	 * data model.
	 * Returns: the row number, or -1 if there was an error.
	 */
	public int getNumber();
	
	/**
	 * Sets the row number for the given row.
	 * Params:
	 * number =  the new row number.
	 */
	public void setNumber(int number);
	
	/**
	 * Returns the unique identifier for this row. This identifier is
	 * assigned by the different providers, to uniquely identify
	 * rows returned to clients. If there is no ID, this means that
	 * the row has not been created by a provider, or that it the
	 * provider cannot identify it (ie, modifications to it won't
	 * take place into the database).
	 * Returns: the unique identifier for this row.
	 */
	public string getId();
	
	/**
	 * Assigns a new identifier to the given row. This function is
	 * usually called by providers.
	 * Params:
	 * id =  new identifier for the row.
	 */
	public void setId(string id);
	
	/**
	 * Gets a pointer to a GdaValue stored in a GdaRow.
	 * This is a pointer to the internal array of values. Don't try to free
	 * or modify it!
	 * Params:
	 * num =  field index.
	 * Returns: a pointer to the GdaValue in the position num of row.
	 */
	public Value getValue(int num);
	
	/**
	 * Returns: the number of columns that the row has.
	 */
	public int getLength();
}
