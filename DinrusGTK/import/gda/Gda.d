module gtkD.gda.Gda;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.HashTable;
private import gtkD.glib.ListG;
private import gtkD.gda.ParameterList;




/**
 * Description
 */
public class Gda
{
	
	/**
	 * Initializes the GDA library.
	 * Params:
	 *  appId = name of the program.
	 *  version = revision number of the program.
	 *  args = args from main().
	 */
	public static void init(string appId, string versio, string[] args);
	
	/**
	 * Description
	 */
	
	/**
	 * Runs the GDA main loop, which is nothing more than the Bonobo main
	 * loop, but with internally added stuff specific for applications using
	 * libgtkD.gda.
	 * You can specify a function to be called after everything has been correctly
	 * initialized (that is, for initializing your own stuff).
	 * Params:
	 * initFunc =  function to be called when everything has been initialized.
	 * userData =  data to be passed to the init function.
	 */
	public static void mainRun(GdaInitFunc initFunc, void* userData);
	
	/**
	 * Exits the main loop.
	 */
	public static void mainQuit();
	
	/**
	 * Params:
	 * type =  Type to convert from.
	 * Returns: the string representing the given GdaValueType.This is not necessarily the same string used to describe the column type in a SQL statement.Use gda_connection_get_schema() with GDA_CONNECTION_SCHEMA_TYPES to get the actual types supported by the provider.
	 */
	public static string typeToString(GdaValueType type);
	
	/**
	 * Params:
	 * str =  the name of a GdaValueType, as returned by gda_type_to_string().
	 * Returns: the GdaValueType represented by the given str.
	 */
	public static GdaValueType typeFromString(string str);
	
	/**
	 * Creates a new list of strings, which contains all keys of a given hash
	 * table. After using it, you should free this list by calling g_list_free.
	 * Params:
	 * hashTable =  a hash table.
	 * Returns: a new GList.
	 */
	public static ListG stringHashToList(HashTable hashTable);
	
	/**
	 * Replaces the placeholders (:name) in the given SQL command with
	 * the values from the GdaParameterList specified as the params
	 * argument.
	 * Params:
	 * sql =  a SQL command containing placeholders for values.
	 * params =  a list of values for the placeholders.
	 * Returns: the SQL string with all placeholders replaced, or NULLon error. On success, the returned string must be freed by the callerwhen no longer needed.
	 */
	public static string sqlReplacePlaceholders(string sql, ParameterList params);
	
	/**
	 * Loads a file, specified by the given uri, and returns the file
	 * contents as a string.
	 * It is the caller's responsibility to free the returned value.
	 * Params:
	 * filename =  path for the file to be loaded.
	 * Returns: the file contents as a newly-allocated string, or NULLif there is an error.
	 */
	public static string fileLoad(string filename);
	
	/**
	 * Saves a chunk of data into a file.
	 * Params:
	 * filename =  path for the file to be saved.
	 * buffer =  contents of the file.
	 * len =  size of buffer.
	 * Returns: TRUE if successful, FALSE on error.
	 */
	public static int fileSave(string filename, string buffer, int len);
}
