module gtkD.gda.DataModelList;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;
private import gtkD.gda.Value;
private import gtkD.gda.Row;



private import gtkD.gda.DataModel;

/**
 * Description
 */
public class DataModelList : DataModel
{
	
	/** the main Gtk struct */
	protected GdaDataModelList* gdaDataModelList;
	
	
	public GdaDataModelList* getDataModelListStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaDataModelList* gdaDataModelList);
	
	/**
	 */
	
	/**
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Params:
	 * list =  a list of strings.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ListG list);
	
	/**
	 * Inserts a row in the model, using value.
	 * Params:
	 * value =  a GdaValue which will be used to fill the row.
	 * Returns: the GdaRow which has been inserted, or NULL on failure.
	 */
	public Row appendValue(Value value);
}
