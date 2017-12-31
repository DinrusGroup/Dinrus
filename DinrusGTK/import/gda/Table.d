
module gtkD.gda.Table;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gda.DataModel;
private import gtkD.gda.FieldAttributes;



private import gtkD.gda.DataModelArray;

/**
 * Description
 */
public class Table : DataModelArray
{
	
	/** the main Gtk struct */
	protected GdaTable* gdaTable;
	
	
	public GdaTable* getTableStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaTable* gdaTable);
	
	/**
	 */
	
	/**
	 * Creates a new GdaTable object, which is an in-memory representation
	 * of an entire table. It is mainly used by the GdaXmlDatabase class,
	 * but you can also use it in your applications for whatever you may need
	 * it.
	 * Params:
	 * name =  name for the new table.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name);
	
	/**
	 * Creates a GdaTable object from the given GdaDataModel. This
	 * is very useful to maintain an in-memory copy of a given
	 * recordset obtained from a database. This is also used when
	 * exporting data to a GdaXmlDatabase object.
	 * Params:
	 * name =  name for the new table.
	 * model =  model to create the table from.
	 * addData =  whether to add model's data or not.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, DataModel model, int addData);
	
	/**
	 * Returns: the name of the given GdaTable.
	 */
	public string getName();
	
	/**
	 * Sets the name of the given GdaTable.
	 * Params:
	 * name =  new name for the table.
	 */
	public void setName(string name);
	
	/**
	 * Adds a field to the given GdaTable.
	 * Params:
	 * fa =  attributes for the new field.
	 */
	public void addField(FieldAttributes fa);
	
	/**
	 * Adds data in the given table from the given model.
	 * Params:
	 * model =  a GdaDataModel object.
	 */
	public void addDataFromModel(DataModel model);
}
