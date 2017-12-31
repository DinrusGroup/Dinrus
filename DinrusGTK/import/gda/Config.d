module gtkD.gda.Config;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gda.DataModel;
private import gtkD.gda.DataSourceInfo;
private import gtkD.gda.ProviderInfo;




/**
 * Description
 *  The functions in this section allow applications an easy access to the libgda
 *  configuration, thus making them able to access the list of data sources
 *  configured in the system, for instance.
 */
public class Config
{
	
	/**
	 */
	
	/**
	 * Gets the value of the specified configuration entry as a string. You
	 * are then responsible to free the returned string.
	 * Params:
	 * path =  path to the configuration entry.
	 * Returns: the value stored at the given entry.
	 */
	public static string getString(string path);
	
	/**
	 * Gets the value of the specified configuration entry as an integer.
	 * Params:
	 * path =  path to the configuration entry.
	 * Returns: the value stored at the given entry.
	 */
	public static int getInt(string path);
	
	/**
	 * Gets the value of the specified configuration entry as a float.
	 * Params:
	 * path =  path to the configuration entry.
	 * Returns: the value stored at the given entry.
	 */
	public static double getFloat(string path);
	
	/**
	 * Gets the value of the specified configuration entry as a boolean.
	 * Params:
	 * path =  path to the configuration entry.
	 * Returns: the value stored at the given entry.
	 */
	public static int getBoolean(string path);
	
	/**
	 * Sets the given configuration entry to contain a string.
	 * Params:
	 * path =  path to the configuration entry.
	 * newValue =  new value.
	 */
	public static void setString(string path, string newValue);
	
	/**
	 * Sets the given configuration entry to contain an integer.
	 * Params:
	 * path =  path to the configuration entry.
	 * newValue =  new value.
	 */
	public static void setInt(string path, int newValue);

	/**
	 * Sets the given configuration entry to contain a float.
	 * Params:
	 * path =  path to the configuration entry.
	 * newValue =  new value.
	 */
	public static void setFloat(string path, double newValue);
	
	/**
	 * Sets the given configuration entry to contain a boolean.
	 * Params:
	 * path =  path to the configuration entry.
	 * newValue =  new value.
	 */
	public static void setBoolean(string path, int newValue);
	
	/**
	 * Removes the given section from the configuration database.
	 * Params:
	 * path =  path to the configuration section.
	 */
	public static void removeSection(string path);
	
	/**
	 * Removes the given entry from the configuration database.
	 * If the section is empty, also remove the section.
	 * Params:
	 * path =  path to the configuration entry.
	 */
	public static void removeKey(string path);
	
	/**
	 * Checks whether the given section exists in the configuration
	 * system.
	 * Params:
	 * path =  path to the configuration section.
	 * Returns: TRUE if the section exists, FALSE otherwise.
	 */
	public static int hasSection(string path);
	
	/**
	 * Checks whether the given key exists in the configuration system.
	 * Params:
	 * path =  path to the configuration key.
	 * Returns: TRUE if the entry exists, FALSE otherwise.
	 */
	public static int hasKey(string path);
	
	/**
	 * Returns a GList containing the names of all the sections available
	 * under the given root directory.
	 * To free the returned value, you can use gda_config_free_list.
	 * Params:
	 * path =  path for root dir.
	 * Returns: a list containing all the section names.
	 */
	public static ListG listSections(string path);
	
	/**
	 * Returns a list of all keys that exist under the given path.
	 * To free the returned value, you can use gda_config_free_list.
	 * Params:
	 * path =  path for root dir.
	 * Returns: a list containing all the key names.
	 */
	public static ListG listKeys(string path);
	
	/**
	 * Gets a string representing the type of the value of the given key.
	 * The caller is responsible of freeing the returned value.
	 * Params:
	 * path =  path to the configuration key.
	 * Returns: NULL if not found. Otherwise: "string", "float", "long", "bool".
	 */
	public static string getType(string path);
	
	/**
	 * Frees all memory used by the given GList, which must be the return value
	 * from either gda_config_list_sections and gda_config_list_keys.
	 * Params:
	 * list =  list to be freed.
	 */
	public static void freeList(ListG list);
	
	/**
	 * Installs a configuration listener, which is a callback function
	 * which will be called every time a change occurs on a given
	 * configuration entry.
	 * Params:
	 * path =  configuration path to listen to.
	 * func =  callback function.
	 * userData =  data to be passed to the callback function.
	 * Returns: the ID of the listener, which you will need forcalling gda_config_remove_listener. If an error occurs,0 is returned.
	 */
	public static uint addListener(string path, GdaConfigListenerFunc func, void* userData);
	
	/**
	 * Removes a configuration listener previously installed with
	 * gda_config_add_listener, given its ID.
	 * Params:
	 * id =  the ID of the listener to remove.
	 */
	public static void removeListener(uint id);
	
	/**
	 * Returns a list of all providers currently installed in
	 * the system. Each of the nodes in the returned GList
	 * is a GdaProviderInfo. To free the returned list,
	 * call the gda_config_free_provider_list function.
	 * Returns: a GList of GdaProviderInfo structures.
	 */
	public static ListG getProviderList();
	
	/**
	 * Frees a list of GdaProviderInfo structures.
	 * Params:
	 * list =  the list to be freed.
	 */
	public static void freeProviderList(ListG list);
	
	/**
	 * Gets a GdaProviderInfo structure from the provider list given its name.
	 * Params:
	 * name =  name of the provider to search for.
	 * Returns: a GdaProviderInfo structure, if found, or NULL if not found.
	 */
	public static ProviderInfo getProviderByName(string name);
	
	/**
	 * Fills and returns a new GdaDataModel object using information from all
	 * providers which are currently installed in the system.
	 * Rows are separated in 3 columns:
	 * 'Id', 'Location' and 'Description'.
	 * Returns: a new GdaDataModel object.
	 */
	public static DataModel getProviderModel();
	
	/**
	 * Creates a new GdaDataSourceInfo structure from an existing one.
	 * Params:
	 * src =  data source information to get a copy from.
	 * Returns: a newly allocated GdaDataSourceInfo with contains a copy of information in src.
	 */
	public static DataSourceInfo copyDataSourceInfo(DataSourceInfo src);
	
	/**
	 * Deallocates all memory associated to the given GdaDataSourceInfo.
	 * Params:
	 * info =  data source information to free.
	 */
	public static void freeDataSourceInfo(DataSourceInfo info);
	
	/**
	 * Returns a list of all data sources currently configured in the system.
	 * Each of the nodes in the returned GList is a GdaDataSourceInfo.
	 * To free the returned list, call the gda_config_free_data_source_list
	 * function.
	 * Returns: a GList of GdaDataSourceInfo structures.
	 */
	public static ListG getDataSourceList();
	
	/**
	 * Gets a GdaDataSourceInfo structure from the data source list given its
	 * name.
	 * Params:
	 * name =  name of the data source to search for.
	 * Returns: a GdaDataSourceInfo structure, if found, or NULL if not found.
	 */
	public static DataSourceInfo findDataSource(string name);
	
	/**
	 * Frees a list of GdaDataSourceInfo structures.
	 * Params:
	 * list =  the list to be freed.
	 */
	public static void freeDataSourceList(ListG list);
	
	/**
	 * Fills and returns a new GdaDataModel object using information from all
	 * data sources which are currently configured in the system.
	 * Rows are separated in 6 columns:
	 * 'Name', 'Provider', 'Connection string', 'Description', 'Username' and
	 * 'Password'.
	 * Returns: a new GdaDataModel object.
	 */
	public static DataModel getDataSourceModel();
	
	/**
	 * Adds a new data source (or update an existing one) to the GDA
	 * configuration, based on the parameters given.
	 * Params:
	 * name =  name for the data source to be saved.
	 * provider =  provider ID for the new data source.
	 * cncString =  connection string for the new data source.
	 * description =  description for the new data source.
	 * username =  user name for the new data source.
	 * password =  password to use when authenticating username.
	 */
	public static void saveDataSource(string name, string provider, string cncString, string description, string username, string password);
	
	/**
	 * Saves a data source in the libgda configuration given a
	 * GdaDataSourceInfo structure containing all the information
	 * about the data source.
	 * Params:
	 * dsnInfo =  a GdaDataSourceInfo structure.
	 */
	public static void saveDataSourceInfo(DataSourceInfo dsnInfo);
	
	/**
	 * Removes the given data source from the GDA configuration.
	 * Params:
	 * name =  name for the data source to be removed.
	 */
	public static void removeDataSource(string name);
}
