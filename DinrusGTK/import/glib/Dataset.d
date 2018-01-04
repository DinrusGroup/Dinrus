
module gtkD.glib.Dataset;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * Datasets associate groups of data elements with particular memory locations.
 * These are useful if you need to associate data with a structure returned
 * from an external library. Since you cannot modify the structure, you use
 * its location in memory as the key into a dataset, where you can associate
 * any number of data elements with it.
 * There are two forms of most of the dataset functions.
 * The first form uses strings to identify the data elements associated with
 * a location. The second form uses GQuark identifiers, which are created
 * with a call to g_quark_from_string() or g_quark_from_static_string().
 * The second form is quicker, since it does not require looking up the string
 * in the hash table of GQuark identifiers.
 * There is no function to create a dataset. It is automatically created as
 * soon as you add elements to it.
 * To add data elements to a dataset use g_dataset_id_set_data(),
 * g_dataset_id_set_data_full(), g_dataset_set_data()
 * and g_dataset_set_data_full().
 * To get data elements from a dataset use g_dataset_id_get_data() and
 * g_dataset_get_data().
 * To iterate over all data elements in a dataset use g_dataset_foreach() (not thread-safe).
 * To remove data elements from a dataset use g_dataset_id_remove_data() and
 * g_dataset_remove_data().
 * To destroy a dataset, use g_dataset_destroy().
 */
public class Dataset
{
	
	/**
	 */
	
	/**
	 * Sets the data element associated with the given GQuark id, and also the
	 * function to call when the data element is destroyed.
	 * Any previous data with the same key is removed, and its
	 * destroy function is called.
	 * Params:
	 * datasetLocation = the location identifying the dataset.
	 * keyId = the GQuark id to identify the data element.
	 * data = the data element.
	 * destroyFunc = the function to call when the data element is removed. This
	 * function will be called with the data element and can be used to free any
	 * memory allocated for it.
	 */
	public static void idSetDataFull(void* datasetLocation, GQuark keyId, void* data, GDestroyNotify destroyFunc);
	
	/**
	 * Gets the data element corresponding to a GQuark.
	 * Params:
	 * datasetLocation = the location identifying the dataset.
	 * keyId = the GQuark id to identify the data element.
	 * Returns:the data element corresponding to the GQuark, or NULL if it isnot found.
	 */
	public static void* idGetData(void* datasetLocation, GQuark keyId);
	
	/**
	 * Removes an element, without calling its destroy notification function.
	 * Params:
	 * datasetLocation = the location identifying the dataset.
	 * keyId = the GQuark ID identifying the data element.
	 * Returns:the data previously stored at key_id, or NULL if none.
	 */
	public static void* idRemoveNoNotify(void* datasetLocation, GQuark keyId);
	
	/**
	 * Calls the given function for each data element which is associated with the
	 * given location.
	 * Note that this function is NOT thread-safe. So unless datalist
	 * can be protected from any modifications during invocation of this
	 * function, it should not be called.
	 * Params:
	 * datasetLocation = the location identifying the dataset.
	 * func = the function to call for each data element.
	 * userData = user data to pass to the function.
	 */
	public static void foreac(void* datasetLocation, GDataForeachFunc func, void* userData);
	
	/**
	 * Destroys the dataset, freeing all memory allocated, and calling any
	 * destroy functions set for data elements.
	 * Params:
	 * datasetLocation = the location identifying the dataset.
	 */
	public static void destroy(void* datasetLocation);
}
