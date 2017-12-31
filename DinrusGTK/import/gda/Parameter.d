module gtkD.gda.Parameter;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.ObjectG;
private import gtkD.gda.Value;




/**
 * Description
 *  Parameters are the way clients have to send an unlimited number
 *  of arguments to the providers.
 */
public class Parameter
{
	
	/** the main Gtk struct */
	protected GdaParameter* gdaParameter;
	
	
	public GdaParameter* getParameterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaParameter* gdaParameter);
	
	/**
	 */
	
	/**
	 * Returns:
	 */
	public static GType getType();
	
	/**
	 * Creates a new GdaParameter object, which is usually used
	 * with GdaParameterList.
	 * Params:
	 * name =  name for the parameter being created.
	 * value =  a GdaValue for this parameter.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, Value value);
	
	/**
	 * Creates a new GdaParameter from a gboolean value.
	 * Params:
	 * name =  name for the parameter being created.
	 * value =  a boolean value.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, int value);
	
	/**
	 * Creates a new GdaParameter from a gdouble value.
	 * Params:
	 * name =  name for the parameter being created.
	 * value =  a gdouble value.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, double value);
	
	/**
	 * Creates a new GdaParameter from a GObject.
	 * Params:
	 * name =  name for the parameter being created.
	 * value =  a GObject value.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, ObjectG value);
	
	/**
	 * Creates a new GdaParameter from a string.
	 * Params:
	 * name =  name for the parameter being created.
	 * value =  string value.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string value);
	
	/**
	 * Creates a new GdaParameter from an existing one.
	 * Returns: a newly allocated GdaParameter with a copy of the data in param.
	 */
	public Parameter copy();
	
	/**
	 * Releases all memory occupied by the given GdaParameter.
	 */
	public void free();
	
	/**
	 * Returns: the name of the given GdaParameter.
	 */
	public string getName();
	
	/**
	 * Sets the name of the given GdaParameter.
	 * Params:
	 * name =  new name for the parameter.
	 */
	public void setName(string name);
	
	/**
	 * Returns: the value stored in the given param.
	 */
	public Value getValue();
	
	/**
	 * Stores the given value in the given param.
	 * Params:
	 * value =  a GdaValue.
	 */
	public void setValue(Value value);
}
