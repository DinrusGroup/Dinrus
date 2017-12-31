module gtkD.gda.Select;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gda.DataModel;



private import gtkD.gda.DataModelArray;

/**
 * Description
 */
public class Select : DataModelArray
{
	
	/** the main Gtk struct */
	protected GdaSelect* gdaSelect;
	
	
	public GdaSelect* getSelectStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaSelect* gdaSelect);
	
	/**
	 */
	
	/**
	 * Creates a new GdaSelect object, which allows programs to filter
	 * GdaDataModel's based on a given SQL SELECT command.
	 * A GdaSelect is just another GdaDataModel-based class, so it
	 * can be used in the same way any other data model class is.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Adds a data model as a source of data for the GdaSelect object. When
	 * the select object is run (via gda_select_run), it will parse the SQL
	 * and get the required data from the source data models.
	 * Params:
	 * name =  name to identify the data model (usually a table name).
	 * source =  a GdaDataModel from which to get data.
	 */
	public void addSource(string name, DataModel source);
	
	/**
	 * Sets the SQL command to be used on the given GdaSelect object
	 * for filtering rows from the source data model (which is
	 * set with gda_select_set_source).
	 * Params:
	 * sql =  the SQL command to be used for filtering rows.
	 */
	public void setSql(string sql);
	
	/**
	 * Runs the query and fills in the GdaSelect object with the
	 * rows that matched the SQL command (which can be set with
	 * gda_select_set_sql) associated with this GdaSelect
	 * object.
	 * After calling this function, if everything is successful,
	 * the GdaSelect object will contain the matched rows, which
	 * can then be accessed like a normal GdaDataModel.
	 * Returns: TRUE if successful, FALSE if there was an error.
	 */
	public int run();
}
