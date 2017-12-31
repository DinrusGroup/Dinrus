module gtkD.gda.DataModelArray;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;





private import gtkD.gda.DataModel;

/**
 * Description
 */
public class DataModelArray : DataModel
{
	
	/** the main Gtk struct */
	protected GdaDataModelArray* gdaDataModelArray;
	
	
	public GdaDataModelArray* getDataModelArrayStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaDataModelArray* gdaDataModelArray);
	
	/**
	 */
	
	/**
	 * Params:
	 * cols =  number of columns for rows in this data model.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int cols);
	
	/**
	 * Sets the number of columns for rows inserted in this model.
	 * cols must be greated than or equal to 0.
	 * Params:
	 * cols =  number of columns for rows this data model should use.
	 */
	public void setNColumns(int cols);
	
	/**
	 * Frees all the rows inserted in model.
	 */
	public void clear();
}
