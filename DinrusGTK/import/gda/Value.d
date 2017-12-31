
module gtkD.gda.Value;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.ObjectG;




/**
 * Description
 */
public class Value
{
	
	/** the main Gtk struct */
	protected GdaValue* gdaValue;
	
	
	public GdaValue* getValueStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaValue* gdaValue);
	
	/** */
	public this (bool val);
	
	/**
	 */
	
	/**
	 * Returns:
	 */
	public static GType getGtype();
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_NULL.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_BIGINT with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (long val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_BIGUINT with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ulong val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_BINARY with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * size =  the size of the memory pool pointer to by val.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (void* val, int size);
	
	/**
	 * Params:
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdaBlob* val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_DATE with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdaDate* val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_DOUBLE with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (double val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_GEOMETRIC_POINT with value
	 * val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdaGeometricPoint* val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_GOBJECT with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectG val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_INTEGER with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_LIST with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdaValueList* val);
	
	/**
	 * Params:
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdaMoney* val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_NUMERIC with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdaNumeric* val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_SINGLE with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (float val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_SMALLINT with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (short val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_SMALLUINT with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ushort val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_STRING with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_TIME with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdaTime* val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_TIMESTAMP with value val.
	 * Params:
	 * val =  value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdaTimestamp* val);
	
	/**
	 * Makes a new GdaValue of type GDA_VALUE_TYPE_TYPE with value val.
	 * Params:
	 * val =  Value to set for the new GdaValue.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GdaValueType val);
	
	/**
	 * Makes a new GdaValue of type type from its string representation.
	 * Params:
	 * asString =  stringified representation of the value.
	 * type =  the new value type.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string asString, GdaValueType type);
	
	/**
	 * Creates a GdaValue from a XML representation of it. That XML
	 * Params:
	 * node =  a XML node representing the value.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (xmlNodePtr node);
	
	/**
	 * Deallocates all memory associated to a GdaValue.
	 */
	public void free();
	
	/**
	 * Retrieves the type of the given value.
	 * Returns: the GdaValueType of the value.
	 */
	public GdaValueType getType();
	
	/**
	 * Tests if a given value is of type GDA_VALUE_TYPE_NULL.
	 * Returns: a boolean that says whether or not value is of typeGDA_VALUE_TYPE_NULL.
	 */
	public int isNull();
	
	/**
	 * Gets whether the value stored in the given GdaValue is of
	 * numeric type or not.
	 * Returns: TRUE if a number, FALSE otherwise.
	 */
	public int isNumber();
	
	/**
	 * Creates a new GdaValue from an existing one.
	 * Returns: a newly allocated GdaValue with a copy of the data in value.
	 */
	public Value copy();
	
	/**
	 * Gets the value stored in value.
	 * Returns: the value contained in value.
	 */
	public long getBigint();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setBigint(long val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public ulong getBiguint();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setBiguint(ulong val);
	
	/**
	 * Params:
	 * size =  holder for length of data.
	 * Returns: the value stored in value.
	 */
	public void* getBinary(int* size);
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 * size =  the size of the memory pool pointed to by val.
	 */
	public void setBinary(void* val, int size);
	
	/**
	 * Returns: the value stored in value.
	 */
	public GdaBlob* getBlob();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setBlob(GdaBlob* val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public int getBoolean();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setBoolean(int val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public GdaDate* getDate();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setDate(GdaDate* val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public double getDouble();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setDouble(double val);

	/**
	 * Returns: the value stored in value.
	 */
	public GdaGeometricPoint* getGeometricPoint();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setGeometricPoint(GdaGeometricPoint* val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public ObjectG getGobject();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setGobject(ObjectG val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public int getInteger();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setInteger(int val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public GdaValueList* getList();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setList(GdaValueList* val);
	
	/**
	 * Sets the type of value to GDA_VALUE_TYPE_NULL.
	 */
	public void setNull();
	
	/**
	 * Returns: the value stored in value.
	 */
	public GdaMoney* getMoney();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setMoney(GdaMoney* val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public GdaNumeric* getNumeric();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setNumeric(GdaNumeric* val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public float getSingle();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setSingle(float val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public short getSmallint();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setSmallint(short val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public ushort getSmalluint();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setSmalluint(ushort val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public string getString();
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */

	public void setString(string val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public GdaTime* getTime();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setTime(GdaTime* val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public GdaTimestamp* getTimestamp();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setTimestamp(GdaTimestamp* val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public char getTinyint();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setTinyint(char val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public char getTinyuint();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setTinyuint(char val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public uint getUinteger();
	
	/**
	 * Stores val into value.
	 * Params:
	 * val =  value to be stored in value.
	 */
	public void setUinteger(uint val);
	
	/**
	 * Returns: the value stored in value.
	 */
	public GdaValueType getVtype();
	
	/**
	 * Stores type into value.
	 * Params:
	 * type =  value to be stored in value.
	 */
	public void setVtype(GdaValueType type);
	
	/**
	 * Stores the value data from its string representation as type.
	 * Params:
	 * asString =  the stringified representation of the value.
	 * type =  the type of the value
	 * Returns: TRUE if the value has been properly converted to type fromits string representation. FALSE otherwise.
	 */
	public int setFromString(string asString, GdaValueType type);
	
	/**
	 * Sets the value of a GdaValue from another GdaValue. This
	 * is different from gda_value_copy, which creates a new GdaValue.
	 * gda_value_set_from_value, on the other hand, copies the contents
	 * of copy into value, which must already be allocated.
	 * Params:
	 * from =  the value to copy from.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int setFromValue(Value from);

	
	/**
	 * Compares two values of the same type.
	 * Params:
	 * value2 =  the other GdaValue to be compared to value1.
	 * Returns: if both values have the same type, returns 0 if both containthe same value, an integer less than 0 if value1 is less than value2 oran integer greater than 0 if value1 is greater than value2.
	 */
	public int compare(Value value2);
	
	/**
	 * Converts a GdaValue to its string representation as indicated by this
	 * Returns: a string formatted according to the printf() style indicated inthe preceding table. Free the value with a g_free() when you've finishedusing it.
	 */
	public string stringify();
	
	/**
	 * Serializes the given GdaValue to a XML node string.
	 * Returns: the XML node. Once not needed anymore, you should free it.
	 */
	public xmlNodePtr toXml();
}
