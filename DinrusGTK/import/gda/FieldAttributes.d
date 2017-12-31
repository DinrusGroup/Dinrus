module gtkD.gda.FieldAttributes;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gda.Value;




/**
 * Description
 */
public class FieldAttributes
{
	
	/** the main Gtk struct */
	protected GdaFieldAttributes* gdaFieldAttributes;
	
	
	public GdaFieldAttributes* getFieldAttributesStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaFieldAttributes* gdaFieldAttributes);
	
	/**
	 */
	
	/**
	 * Returns:
	 */
	public static GType getType();
	
	/**
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GdaFieldAttributes object from an existing one.
	 * Returns: a newly allocated GdaFieldAttributes with a copy of the datain fa.
	 */
	public FieldAttributes copy();
	
	/**
	 * Deallocates all memory associated to the given GdaFieldAttributes object.
	 */
	public void free();
	
	/**
	 * Tests whether two field attributes are equal.
	 * Params:
	 * rhs =  another GdaFieldAttributes
	 * Returns: TRUE if the field attributes contain the same information.
	 */
	public int equal(FieldAttributes rhs);
	
	/**
	 * Returns: the defined size of fa.
	 */
	public int getDefinedSize();
	
	/**
	 * Sets the defined size of a GdaFieldAttributes.
	 * Params:
	 * size =  the defined size we want to set.
	 */
	public void setDefinedSize(int size);
	
	/**
	 * Returns: the name of fa.
	 */
	public string getName();
	
	/**
	 * Sets the name of fa to name.
	 * Params:
	 * name =  the new name of fa.
	 */
	public void setName(string name);
	
	/**
	 * Returns: the name of the table to which this field belongs.
	 */
	public string getTable();
	
	/**
	 * Sets the name of the table to which the given field belongs.
	 * Params:
	 * table =  table name.
	 */
	public void setTable(string table);
	
	/**
	 * Returns: fa's caption.
	 */
	public string getCaption();
	
	/**
	 * Sets fa's caption.
	 * Params:
	 * caption =  caption.
	 */
	public void setCaption(string caption);
	
	/**
	 * Returns: the number of decimals of fa.
	 */
	public int getScale();
	
	/**
	 * Sets the scale of fa to scale.
	 * Params:
	 * scale =  number of decimals.
	 */
	public void setScale(int scale);
	
	/**
	 * Returns: the type of fa.
	 */
	public GdaValueType getGdatype();
	
	/**
	 * Sets the type of fa to type.
	 * Params:
	 * type =  the new type of fa.
	 */
	public void setGdatype(GdaValueType type);
	
	/**
	 * Gets the 'allow null' flag of the given field attributes.
	 * Returns: whether the given field allows null values or not (TRUE or FALSE).
	 */
	public int getAllowNull();
	
	/**
	 * Sets the 'allow null' flag of the given field attributes.
	 * Params:
	 * allow =  whether the given field should allows null values or not.
	 */
	public void setAllowNull(int allow);
	
	/**
	 * Returns: whether if the given field is a primary key (TRUE or FALSE).
	 */
	public int getPrimaryKey();
	
	/**
	 * Sets the 'primary key' flag of the given field attributes.
	 * Params:
	 * pk =  whether if the given field should be a primary key.
	 */
	public void setPrimaryKey(int pk);
	
	/**
	 * Returns: whether if the given field is an unique key (TRUE or FALSE).
	 */
	public int getUniqueKey();
	
	/**
	 * Sets the 'unique key' flag of the given field attributes.
	 * Params:
	 * uk =  whether if the given field should be an unique key.
	 */
	public void setUniqueKey(int uk);
	
	/**
	 * Returns: fa's references.
	 */
	public string getReferences();
	
	/**
	 * Sets fa's references.
	 * Params:
	 * ref =  references.
	 */
	public void setReferences(string doref);
	
	/**
	 * Returns: whether the given field is an auto incremented one (TRUE or FALSE).
	 */
	public int getAutoIncrement();
	
	/**
	 * Sets the auto increment flag for the given field.
	 * Params:
	 * isAuto =  auto increment status.
	 */
	public void setAutoIncrement(int isAuto);
	
	/**
	 * Returns: the position of the field the attributes refer to in thecontaining data model.
	 */
	public int getPosition();
	
	/**
	 * Sets the position of the field the attributes refer to in the containing
	 * data model.
	 * Params:
	 * position =  the wanted position of the field in the containing data model.
	 */
	public void setPosition(int position);
	
	/**
	 * Params:
	 * fa =  a GdaFieldAttributes.
	 * Returns: fa's default value, as a GdaValue object.
	 */
	public Value getDefaultValue();
	
	/**
	 * Sets fa's default GdaValue.
	 * Params:
	 * fa =  a GdaFieldAttributes.
	 * defaultValue =  default GdaValue for the field
	 */
	public void setDefaultValue(Value defaultValue);
}
