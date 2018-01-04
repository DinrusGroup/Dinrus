module gtkD.gstreamer.Structure;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.Value;




/**
 * Description
 * A GstStructure is a collection of key/value pairs. The keys are expressed
 * as GQuarks and the values can be of any GType.
 * In addition to the key/value pairs, a GstStructure also has a name.
 * GstStructure is used by various GStreamer subsystems to store information
 * in a flexible and extensible way. A GstStructure does not have a refcount
 * because it usually is part of a higher level object such as GstCaps. It
 * provides a means to enforce mutability using the refcount of the parent
 * with the gst_structure_set_parent_refcount() method.
 * A GstStructure can be created with gst_structure_empty_new() or
 * gst_structure_new(), which both take a name and an optional set of
 * key/value pairs along with the types of the values.
 * Field values can be changed with gst_structure_set_value() or
 * gst_structure_set().
 * Field values can be retrieved with gst_structure_get_value() or the more
 * convenient gst_structure_get_*() functions.
 * Fields can be removed with gst_structure_remove_field() or
 * gst_structure_remove_fields().
 * Last reviewed on 2005-11-09 (0.9.4)
 */
public class Structure
{
	
	/** the main Gtk struct */
	protected GstStructure* gstStructure;
	
	
	public GstStructure* getStructureStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstStructure* gstStructure);
	
	/**
	 */
	
	/**
	 * Creates a new, empty GstStructure with the given name.
	 * Params:
	 * name =  name of new structure
	 * Returns: a new, empty GstStructure
	 */
	public static Structure emptyNew(string name);
	
	/**
	 * Creates a new, empty GstStructure with the given name as a GQuark.
	 * Params:
	 * quark =  name of new structure
	 * Returns: a new, empty GstStructure
	 */
	public static Structure idEmptyNew(GQuark quark);
	
	/**
	 * Creates a new GstStructure with the given name. Structure fields
	 * are set according to the varargs in a manner similar to
	 * gst_structure_new.
	 * Params:
	 * name =  name of new structure
	 * firstfield =  name of first field to set
	 * varargs =  variable argument list
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string firstfield, void* varargs);
	
	/**
	 * Duplicates a GstStructure and all its fields and values.
	 * Returns: a new GstStructure.
	 */
	public Structure copy();
	
	/**
	 * Frees a GstStructure and all its fields and values. The structure must not
	 * have a parent when this function is called.
	 */
	public void free();
	
	/**
	 * Get the name of structure as a string.
	 * Returns: the name of the structure.
	 */
	public string getName();
	
	/**
	 * Checks if the structure has the given name
	 * Params:
	 * name =  structure name to check for
	 * Returns: TRUE if name matches the name of the structure.
	 */
	public int hasName(string name);
	
	/**
	 * Sets the name of the structure to the given name. The string
	 * provided is copied before being used.
	 * Params:
	 * name =  the new name of the structure
	 */
	public void setName(string name);
	
	/**
	 * Get the name of structure as a GQuark.
	 * Returns: the quark representing the name of the structure.
	 */
	public GQuark getNameId();
	
	/**
	 * Get the value of the field with GQuark field.
	 * Params:
	 * field =  the GQuark of the field to get
	 * Returns: the GValue corresponding to the field with the given name identifier.
	 */
	public Value idGetValue(GQuark field);
	
	/**
	 * Sets the field with the given GQuark field to value. If the field
	 * does not exist, it is created. If the field exists, the previous
	 * value is replaced and freed.
	 * Params:
	 * field =  a GQuark representing a field
	 * value =  the new value of the field
	 */
	public void idSetValue(GQuark field, Value value);
	
	/**
	 * Get the value of the field with name fieldname.
	 * Params:
	 * fieldname =  the name of the field to get
	 * Returns: the GValue corresponding to the field with the given name.
	 */
	public Value getValue(string fieldname);
	
	/**
	 * Sets the field with the given name field to value. If the field
	 * does not exist, it is created. If the field exists, the previous
	 * value is replaced and freed.
	 * Params:
	 * fieldname =  the name of the field to set
	 * value =  the new value of the field
	 */
	public void setValue(string fieldname, Value value);
	
	/**
	 * va_list form of gst_structure_set().
	 * Params:
	 * fieldname =  the name of the field to set
	 * varargs =  variable arguments
	 */
	public void setValist(string fieldname, void* varargs);
	
	/**
	 * va_list form of gst_structure_id_set().
	 * Params:
	 * fieldname =  the name of the field to set
	 * varargs =  variable arguments
	 * Since 0.10.10
	 */
	public void idSetValist(GQuark fieldname, void* varargs);
	
	/**
	 * Removes the field with the given name. If the field with the given
	 * name does not exist, the structure is unchanged.
	 * Params:
	 * fieldname =  the name of the field to remove
	 */
	public void removeField(string fieldname);
	
	/**
	 * va_list form of gst_structure_remove_fields().
	 * Params:
	 * fieldname =  the name of the field to remove
	 * varargs =  NULL-terminated list of more fieldnames to remove
	 */
	public void removeFieldsValist(string fieldname, void* varargs);
	
	/**
	 * Removes all fields in a GstStructure.
	 */
	public void removeAllFields();
	
	/**
	 * Finds the field with the given name, and returns the type of the
	 * value it contains. If the field is not found, G_TYPE_INVALID is
	 * returned.
	 * Params:
	 * fieldname =  the name of the field
	 * Returns: the GValue of the field
	 */
	public GType getFieldType(string fieldname);
	
	/**
	 * Calls the provided function once for each field in the GstStructure. The
	 * function must not modify the fields. Also see gst_structure_map_in_place().
	 * Params:
	 * func =  a function to call for each field
	 * userData =  private data
	 * Returns: TRUE if the supplied function returns TRUE For each of the fields,FALSE otherwise.
	 */
	public int foreac(GstStructureForeachFunc func, void* userData);
	
	/**
	 * Get the number of fields in the structure.
	 * Returns: the number of fields in the structure
	 */
	public int nFields();
	
	/**
	 * Check if structure contains a field named fieldname.
	 * Params:
	 * fieldname =  the name of a field
	 * Returns: TRUE if the structure contains a field with the given name
	 */
	public int hasField(string fieldname);
	
	/**
	 * Check if structure contains a field named fieldname and with GType type.
	 * Params:
	 * fieldname =  the name of a field
	 * type =  the type of a value
	 * Returns: TRUE if the structure contains a field with the given name and type
	 */
	public int hasFieldTyped(string fieldname, GType type);
	
	/**
	 * Sets the boolean pointed to by value corresponding to the value of the
	 * given field. Caller is responsible for making sure the field exists
	 * and has the correct type.
	 * Params:
	 * fieldname =  the name of a field
	 * value =  a pointer to a gboolean to set
	 * Returns: TRUE if the value could be set correctly. If there was no fieldwith fieldname or the existing field did not contain a boolean, thisfunction returns FALSE.
	 */
	public int getBoolean(string fieldname, int* value);
	
	/**
	 * Sets the int pointed to by value corresponding to the value of the
	 * given field. Caller is responsible for making sure the field exists
	 * and has the correct type.
	 * Params:
	 * fieldname =  the name of a field
	 * value =  a pointer to an int to set
	 * Returns:with fieldname or the existing field did not contain an int, this functionReturns:FALSE.
	 */
	public int getInt(string fieldname, int* value);
	
	/**
	 * Sets the GstFourcc pointed to by value corresponding to the value of the
	 * given field. Caller is responsible for making sure the field exists
	 * and has the correct type.
	 * Params:
	 * fieldname =  the name of a field
	 * value =  a pointer to a GstFourcc to set
	 * Returns:with fieldname or the existing field did not contain a fourcc, this functionReturns:FALSE.
	 */
	public int getFourcc(string fieldname, uint* value);
	
	/**
	 * Sets the double pointed to by value corresponding to the value of the
	 * given field. Caller is responsible for making sure the field exists
	 * and has the correct type.
	 * Params:
	 * fieldname =  the name of a field
	 * value =  a pointer to a GstFourcc to set
	 * Returns: TRUE if the value could be set correctly. If there was no fieldwith fieldname or the existing field did not contain a double, this function returns FALSE.
	 */
	public int getDouble(string fieldname, double* value);
	
	/**
	 * Finds the field corresponding to fieldname, and returns the string
	 * contained in the field's value. Caller is responsible for making
	 * sure the field exists and has the correct type.
	 * The string should not be modified, and remains valid until the next
	 * call to a gst_structure_*() function with the given structure.
	 * Params:
	 * fieldname =  the name of a field
	 * Returns: a pointer to the string or NULL when the field did not existor did not contain a string.
	 */
	public string getString(string fieldname);

	/**
	 * Sets the date pointed to by value corresponding to the date of the
	 * given field. Caller is responsible for making sure the field exists
	 * and has the correct type.
	 * Params:
	 * fieldname =  the name of a field
	 * value =  a pointer to a GDate to set
	 * Returns:with fieldname or the existing field did not contain a data, this functionReturns:FALSE.
	 */
	public int getDate(string fieldname, GDate** value);
	
	/**
	 * Sets the clock time pointed to by value corresponding to the clock time
	 * of the given field. Caller is responsible for making sure the field exists
	 * and has the correct type.
	 * Params:
	 * fieldname =  the name of a field
	 * value =  a pointer to a GstClockTime to set
	 * Returns: TRUE if the value could be set correctly. If there was no fieldwith fieldname or the existing field did not contain a GstClockTime, this function returns FALSE.
	 */
	public int getClockTime(string fieldname, GstClockTime* value);
	
	/**
	 * Sets the int pointed to by value corresponding to the value of the
	 * given field. Caller is responsible for making sure the field exists,
	 * has the correct type and that the enumtype is correct.
	 * Params:
	 * fieldname =  the name of a field
	 * enumtype =  the enum type of a field
	 * value =  a pointer to an int to set
	 * Returns: TRUE if the value could be set correctly. If there was no fieldwith fieldname or the existing field did not contain an enum of the giventype, this function returns FALSE.
	 */
	public int getEnum(string fieldname, GType enumtype, int* value);
	
	/**
	 * Sets the integers pointed to by value_numerator and value_denominator
	 * corresponding to the value of the given field. Caller is responsible
	 * for making sure the field exists and has the correct type.
	 * Params:
	 * fieldname =  the name of a field
	 * valueNumerator =  a pointer to an int to set
	 * valueDenominator =  a pointer to an int to set
	 * Returns: TRUE if the values could be set correctly. If there was no fieldwith fieldname or the existing field did not contain a GstFraction, this function returns FALSE.
	 */
	public int getFraction(string fieldname, int* valueNumerator, int* valueDenominator);
	
	/**
	 * Calls the provided function once for each field in the GstStructure. In
	 * contrast to gst_structure_foreach(), the function may modify but not delete the
	 * fields. The structure must be mutable.
	 * Params:
	 * func =  a function to call for each field
	 * userData =  private data
	 * Returns: TRUE if the supplied function returns TRUE For each of the fields,FALSE otherwise.
	 */
	public int mapInPlace(GstStructureMapFunc func, void* userData);
	
	/**
	 * Get the name of the given field number, counting from 0 onwards.
	 * Params:
	 * index =  the index to get the name of
	 * Returns: the name of the given field number
	 */
	public string nthFieldName(uint index);

	/**
	 * Sets the parent_refcount field of GstStructure. This field is used to
	 * determine whether a structure is mutable or not. This function should only be
	 * called by code implementing parent objects of GstStructure, as described in
	 * the MT Refcounting section of the design documents.
	 * Params:
	 * refcount =  a pointer to the parent's refcount
	 */
	public void setParentRefcount(int* refcount);
	
	/**
	 * Converts structure to a human-readable string representation.
	 * Returns: a pointer to string allocated by g_malloc(). g_free() afterusage.
	 */
	public string toString();
	
	/**
	 * Creates a GstStructure from a string representation.
	 * If end is not NULL, a pointer to the place inside the given string
	 * where parsing ended will be returned.
	 * Params:
	 * string =  a string representation of a GstStructure.
	 * end =  pointer to store the end of the string in.
	 * Returns: a new GstStructure or NULL when the string could notbe parsed. Free after usage.
	 */
	public static Structure fromString(string string, char** end);
	
	/**
	 * Fixates a GstStructure by changing the given field to the nearest
	 * integer to target that is a subset of the existing field.
	 * Params:
	 * fieldName =  a field in structure
	 * target =  the target value of the fixation
	 * Returns: TRUE if the structure could be fixated
	 */
	public int fixateFieldNearestInt(string fieldName, int target);
	
	/**
	 * Fixates a GstStructure by changing the given field to the nearest
	 * double to target that is a subset of the existing field.
	 * Params:
	 * fieldName =  a field in structure
	 * target =  the target value of the fixation
	 * Returns: TRUE if the structure could be fixated
	 */
	public int fixateFieldNearestDouble(string fieldName, double target);
	
	/**
	 * Fixates a GstStructure by changing the given field to the nearest
	 * fraction to target_numerator/target_denominator that is a subset
	 * of the existing field.
	 * Params:
	 * fieldName =  a field in structure
	 * targetNumerator =  The numerator of the target value of the fixation
	 * targetDenominator =  The denominator of the target value of the fixation
	 * Returns: TRUE if the structure could be fixated
	 */
	public int fixateFieldNearestFraction(string fieldName, int targetNumerator, int targetDenominator);
	
	/**
	 * Fixates a GstStructure by changing the given field_name field to the given
	 * target boolean if that field is not fixed yet.
	 * Params:
	 * fieldName =  a field in structure
	 * target =  the target value of the fixation
	 * Returns: TRUE if the structure could be fixated
	 */
	public int fixateFieldBoolean(string fieldName, int target);
}
