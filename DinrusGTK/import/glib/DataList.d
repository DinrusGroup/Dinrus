module gtkD.glib.DataList;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * Keyed data lists provide lists of arbitrary data elements which can be accessed
 * either with a string or with a GQuark corresponding to the
 * string.
 * The GQuark methods are quicker, since the strings have to be converted to
 * GQuarks anyway.
 * Data lists are used for associating arbitrary data with
 * GObjects, using g_object_set_data() and related functions.
 * To create a datalist, use g_datalist_init().
 * To add data elements to a datalist use g_datalist_id_set_data(),
 * g_datalist_id_set_data_full(), g_datalist_set_data()
 * and g_datalist_set_data_full().
 * To get data elements from a datalist use g_datalist_id_get_data() and
 * g_datalist_get_data().
 * To iterate over all data elements in a datalist use g_datalist_foreach() (not thread-safe).
 * To remove data elements from a datalist use g_datalist_id_remove_data() and
 * g_datalist_remove_data().
 * To remove all data elements from a datalist, use g_datalist_clear().
 */
public class DataList
{
	
	/** the main Gtk struct */
	protected GData* gData;
	
	
	public GData* getDataListStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GData* gData);
	
	/**
	 */
	
	/**
	 * Resets the datalist to NULL.
	 * It does not free any memory or call any destroy functions.
	 * Params:
	 * datalist = a pointer to a pointer to a datalist.
	 */
	public static void init(GData** datalist);
	
	/**
	 * Sets the data corresponding to the given GQuark id, and the function to
	 * be called when the element is removed from the datalist.
	 * Any previous data with the same key is removed, and its
	 * destroy function is called.
	 * Params:
	 * datalist = a datalist.
	 * keyId = the GQuark to identify the data element.
	 * data = the data element or NULL to remove any previous element
	 * corresponding to key_id.
	 * destroyFunc = the function to call when the data element is removed. This
	 * function will be called with the data element and can be used to free any
	 * memory allocated for it. If data is NULL, then destroy_func must
	 * also be NULL.
	 */
	public static void idSetDataFull(GData** datalist, GQuark keyId, void* data, GDestroyNotify destroyFunc);
	
	/**
	 * Retrieves the data element corresponding to key_id.
	 * Params:
	 * datalist = a datalist.
	 * keyId = the GQuark identifying a data element.
	 * Returns:the data element, or NULL if it is not found.
	 */
	public static void* idGetData(GData** datalist, GQuark keyId);
	
	/**
	 * Removes an element, without calling its destroy notification function.
	 * Params:
	 * datalist = a datalist.
	 * keyId = the GQuark identifying a data element.
	 * Returns:the data previously stored at key_id, or NULL if none.
	 */
	public static void* idRemoveNoNotify(GData** datalist, GQuark keyId);
	
	/**
	 * Calls the given function for each data element of the datalist.
	 * The function is called with each data element's GQuark id and data,
	 * together with the given user_data parameter.
	 * Note that this function is NOT thread-safe. So unless datalist
	 * can be protected from any modifications during invocation of this
	 * function, it should not be called.
	 * Params:
	 * datalist = a datalist.
	 * func = the function to call for each data element.
	 * userData = user data to pass to the function.
	 */
	public static void foreac(GData** datalist, GDataForeachFunc func, void* userData);
	
	/**
	 * Frees all the data elements of the datalist.
	 * The data elements' destroy functions are called if they have been set.
	 * Params:
	 * datalist = a datalist.
	 */
	public static void clear(GData** datalist);
	
	/**
	 * Turns on flag values for a data list. This function is used
	 * to keep a small number of boolean flags in an object with
	 * a data list without using any additional space. It is
	 * not generally useful except in circumstances where space
	 * is very tight. (It is used in the base GObject type, for
	 * example.)
	 * Since 2.8
	 * Params:
	 * datalist =  pointer to the location that holds a list
	 * flags =  the flags to turn on. The values of the flags are
	 *  restricted by G_DATALIST_FLAGS_MASK (currently
	 *  3; giving two possible boolean flags).
	 *  A value for flags that doesn't fit within the mask is
	 *  an error.
	 */
	public static void setFlags(GData** datalist, uint flags);
	
	/**
	 * Turns off flag values for a data list. See g_datalist_unset_flags()
	 * Since 2.8
	 * Params:
	 * datalist =  pointer to the location that holds a list
	 * flags =  the flags to turn off. The values of the flags are
	 *  restricted by G_DATALIST_FLAGS_MASK (currently
	 *  3: giving two possible boolean flags).
	 *  A value for flags that doesn't fit within the mask is
	 *  an error.
	 */
	public static void unsetFlags(GData** datalist, uint flags);
	
	/**
	 * Gets flags values packed in together with the datalist.
	 * See g_datalist_set_flags().
	 * Since 2.8
	 * Params:
	 * datalist =  pointer to the location that holds a list
	 * Returns: the flags of the datalist
	 */
	public static uint getFlags(GData** datalist);
}
