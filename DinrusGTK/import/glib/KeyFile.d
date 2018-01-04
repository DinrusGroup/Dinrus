module gtkD.glib.KeyFile;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.Str;




/**
 * Description
 * GKeyFile lets you parse, edit or create files containing groups of
 * key-value pairs, which we call key files for
 * lack of a better name. Several freedesktop.org specifications use
 * key files now, e.g the
 * Desktop
 * Entry Specification and the
 * Icon
 * Theme Specification.
 * The syntax of key files is described in detail in the
 * Desktop
 * Entry Specification, here is a quick summary: Key files
 * consists of groups of key-value pairs, interspersed with comments.
 * # this is just an example
 * # there can be comments before the first group
 * [First Group]
 * Name=Key File Example\tthis value shows\nescaping
 * # localized strings are stored in multiple key-value pairs
 * Welcome=Hello
 * Welcome[de]=Hallo
 * Welcome[fr_FR]=Bonjour
 * Welcome[it]=Ciao
 * Welcome[be@latin]=Hello
 * [Another Group]
 * Numbers=2;20;-200;0
 * Booleans=true;false;true;true
 * Lines beginning with a '#' and blank lines are considered comments.
 * Groups are started by a header line containing the group name enclosed
 * in '[' and ']', and ended implicitly by the start of the next group or
 * the end of the file. Each key-value pair must be contained in a group.
 * Key-value pairs generally have the form key=value,
 * with the exception of localized strings, which have the form
 * key[locale]=value, with a locale identifier of the form
 * lang_COUNTRYMODIFIER where COUNTRY and
 * MODIFIER are optional. Space before and after the
 * '=' character are ignored. Newline, tab, carriage return and backslash
 * characters in value are escaped as \n, \t, \r, and \\, respectively.
 * To preserve leading spaces in values, these can also be escaped as \s.
 * Key files can store strings (possibly with localized variants), integers,
 * booleans and lists of these. Lists are separated by a separator character,
 * typically ';' or ','. To use the list separator character in a value in
 * a list, it has to be escaped by prefixing it with a backslash.
 * This syntax is obviously inspired by the .ini
 * files commonly met on Windows, but there are some important differences:
 * .ini files use the ';' character to begin comments,
 *  key files use the '#' character.
 * Key files do not allow for ungrouped keys meaning only comments can precede the first group.
 * Key files are always encoded in UTF-8.
 * Key and Group names are case-sensitive, for example a group called
 * [GROUP] is a different group from [group].
 * .ini files don't have a strongly typed boolean entry type, they only
 * have GetProfileInt. In GKeyFile only
 * true and false (in lower case) are allowed.
 * Note that in contrast to the
 * Desktop
 * Entry Specification, groups in key files may contain the same
 * key multiple times; the last entry wins. Key files may also contain
 * multiple groups with the same name; they are merged together.
 * Another difference is that keys and group names in key files are not
 * restricted to ASCII characters.
 */
public class KeyFile
{
	
	/** the main Gtk struct */
	protected GKeyFile* gKeyFile;
	
	
	public GKeyFile* getKeyFileStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GKeyFile* gKeyFile);
	
	/**
	 * This function looks for a key file named file in the paths
	 * specified in search_dirs, loads the file into key_file and
	 * returns the file's full path in full_path. If the file could not
	 * be loaded then an error is set to either a GFileError or
	 * GKeyFileError.
	 * Since 2.14
	 * Params:
	 * file =  a relative path to a filename to open and parse
	 * searchDirs =  NULL-terminated array of directories to search
	 * fullPath =  return location for a string containing the full path
	 *  of the file, or NULL
	 * flags =  flags from GKeyFileFlags
	 * Returns: TRUE if a key file could be loaded, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int loadFromDirs(string file, string[] searchDirs, out string fullPath, GKeyFileFlags flags);
	
	/**
	 */
	
	/**
	 * Creates a new empty GKeyFile object. Use
	 * g_key_file_load_from_file(), g_key_file_load_from_data(),
	 * g_key_file_load_from_dirs() or g_key_file_load_from_data_dirs() to
	 * read an existing key file.
	 * Since 2.6
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Frees a GKeyFile.
	 * Since 2.6
	 */
	public void free();
	
	/**
	 * Sets the character which is used to separate
	 * values in lists. Typically ';' or ',' are used
	 * as separators. The default list separator is ';'.
	 * Since 2.6
	 * Params:
	 * separator =  the separator
	 */
	public void setListSeparator(char separator);
	
	/**
	 * Loads a key file into an empty GKeyFile structure.
	 * If the file could not be loaded then error is set to
	 * either a GFileError or GKeyFileError.
	 * Since 2.6
	 * Params:
	 * file =  the path of a filename to load, in the GLib filename encoding
	 * flags =  flags from GKeyFileFlags
	 * Returns: TRUE if a key file could be loaded, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int loadFromFile(string file, GKeyFileFlags flags);
	
	/**
	 * Loads a key file from memory into an empty GKeyFile structure.
	 * If the object cannot be created then error is set to a GKeyFileError.
	 * Since 2.6
	 * Params:
	 * data =  key file loaded in memory
	 * length =  the length of data in bytes
	 * flags =  flags from GKeyFileFlags
	 * Returns: TRUE if a key file could be loaded, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int loadFromData(string data, uint length, GKeyFileFlags flags);
	
	/**
	 * This function looks for a key file named file in the paths
	 * returned from g_get_user_data_dir() and g_get_system_data_dirs(),
	 * loads the file into key_file and returns the file's full path in
	 * full_path. If the file could not be loaded then an error is
	 * set to either a GFileError or GKeyFileError.
	 * Since 2.6
	 * Params:
	 * file =  a relative path to a filename to open and parse
	 * fullPath =  return location for a string containing the full path
	 *  of the file, or NULL
	 * flags =  flags from GKeyFileFlags
	 * Returns: TRUE if a key file could be loaded, FALSE othewise
	 * Throws: GException on failure.
	 */
	public int loadFromDataDirs(string file, out string fullPath, GKeyFileFlags flags);
	
	/**
	 * This function outputs key_file as a string.
	 * Note that this function never reports an error,
	 * so it is safe to pass NULL as error.
	 * Since 2.6
	 * Params:
	 * length =  return location for the length of the
	 *  returned string, or NULL
	 * Returns: a newly allocated string holding the contents of the GKeyFile
	 * Throws: GException on failure.
	 */
	public string toData(out uint length);
	
	/**
	 * Returns the name of the start group of the file.
	 * Since 2.6
	 * Returns: The start group of the key file.
	 */
	public string getStartGroup();
	
	/**
	 * Returns all groups in the key file loaded with key_file.
	 * The array of returned groups will be NULL-terminated, so
	 * length may optionally be NULL.
	 * Since 2.6
	 * Params:
	 * length =  return location for the number of returned groups, or NULL
	 * Returns: a newly-allocated NULL-terminated array of strings.  Use g_strfreev() to free it.
	 */
	public string[] getGroups(out uint length);
	
	/**
	 * Returns all keys for the group name group_name. The array of
	 * returned keys will be NULL-terminated, so length may
	 * optionally be NULL. In the event that the group_name cannot
	 * be found, NULL is returned and error is set to
	 * G_KEY_FILE_ERROR_GROUP_NOT_FOUND.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * length =  return location for the number of keys returned, or NULL
	 * Returns: a newly-allocated NULL-terminated array of strings.  Use g_strfreev() to free it.
	 * Throws: GException on failure.
	 */
	public string[] getKeys(string groupName, out uint length);
	
	/**
	 * Looks whether the key file has the group group_name.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * Returns: TRUE if group_name is a part of key_file, FALSEotherwise.
	 */
	public int hasGroup(string groupName);
	
	/**
	 * Looks whether the key file has the key key in the group
	 * group_name.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key name
	 * Returns: TRUE if key is a part of group_name, FALSEotherwise.
	 * Throws: GException on failure.
	 */
	public int hasKey(string groupName, string key);
	
	/**
	 * Returns the raw value associated with key under group_name.
	 * Use g_key_file_get_string() to retrieve an unescaped UTF-8 string.
	 * In the event the key cannot be found, NULL is returned and
	 * error is set to G_KEY_FILE_ERROR_KEY_NOT_FOUND. In the
	 * event that the group_name cannot be found, NULL is returned
	 * and error is set to G_KEY_FILE_ERROR_GROUP_NOT_FOUND.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * Returns: a newly allocated string or NULL if the specified  key cannot be found.
	 * Throws: GException on failure.
	 */
	public string getValue(string groupName, string key);
	
	/**
	 * Returns the string value associated with key under group_name.
	 * Unlike g_key_file_get_value(), this function handles escape sequences
	 * like \s.
	 * In the event the key cannot be found, NULL is returned and
	 * error is set to G_KEY_FILE_ERROR_KEY_NOT_FOUND. In the
	 * event that the group_name cannot be found, NULL is returned
	 * and error is set to G_KEY_FILE_ERROR_GROUP_NOT_FOUND.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * Returns: a newly allocated string or NULL if the specified  key cannot be found.
	 * Throws: GException on failure.
	 */
	public string getString(string groupName, string key);
	
	/**
	 * Returns the value associated with key under group_name
	 * translated in the given locale if available. If locale is
	 * NULL then the current locale is assumed.
	 * If key cannot be found then NULL is returned and error is set
	 * to G_KEY_FILE_ERROR_KEY_NOT_FOUND. If the value associated
	 * with key cannot be interpreted or no suitable translation can
	 * be found then the untranslated value is returned.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * locale =  a locale identifier or NULL
	 * Returns: a newly allocated string or NULL if the specified  key cannot be found.
	 * Throws: GException on failure.
	 */
	public string getLocaleString(string groupName, string key, string locale);
	
	/**
	 * Returns the value associated with key under group_name as a
	 * boolean.
	 * If key cannot be found then FALSE is returned and error is set
	 * to G_KEY_FILE_ERROR_KEY_NOT_FOUND. Likewise, if the value
	 * associated with key cannot be interpreted as a boolean then FALSE
	 * is returned and error is set to G_KEY_FILE_ERROR_INVALID_VALUE.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * Returns: the value associated with the key as a boolean,  or FALSE if the key was not found or could not be parsed.
	 * Throws: GException on failure.
	 */
	public int getBoolean(string groupName, string key);
	
	/**
	 * Returns the value associated with key under group_name as an
	 * integer.
	 * If key cannot be found then 0 is returned and error is set to
	 * G_KEY_FILE_ERROR_KEY_NOT_FOUND. Likewise, if the value associated
	 * with key cannot be interpreted as an integer then 0 is returned
	 * and error is set to G_KEY_FILE_ERROR_INVALID_VALUE.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * Returns: the value associated with the key as an integer, or 0 if the key was not found or could not be parsed.
	 * Throws: GException on failure.
	 */
	public int getInteger(string groupName, string key);
	
	/**
	 * Returns the value associated with key under group_name as a
	 * double. If group_name is NULL, the start_group is used.
	 * If key cannot be found then 0.0 is returned and error is set to
	 * G_KEY_FILE_ERROR_KEY_NOT_FOUND. Likewise, if the value associated
	 * with key cannot be interpreted as a double then 0.0 is returned
	 * and error is set to G_KEY_FILE_ERROR_INVALID_VALUE.
	 * Since 2.12
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * Returns: the value associated with the key as a double, or 0.0 if the key was not found or could not be parsed.
	 * Throws: GException on failure.
	 */
	public double getDouble(string groupName, string key);
	
	/**
	 * Returns the values associated with key under group_name.
	 * In the event the key cannot be found, NULL is returned and
	 * error is set to G_KEY_FILE_ERROR_KEY_NOT_FOUND. In the
	 * event that the group_name cannot be found, NULL is returned
	 * and error is set to G_KEY_FILE_ERROR_GROUP_NOT_FOUND.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * length =  return location for the number of returned strings, or NULL
	 * Returns: a NULL-terminated string array or NULL if the specified  key cannot be found. The array should be freed with g_strfreev().
	 * Throws: GException on failure.
	 */
	public string[] getStringList(string groupName, string key, out uint length);
	
	/**
	 * Returns the values associated with key under group_name
	 * translated in the given locale if available. If locale is
	 * NULL then the current locale is assumed.
	 * If key cannot be found then NULL is returned and error is set
	 * to G_KEY_FILE_ERROR_KEY_NOT_FOUND. If the values associated
	 * with key cannot be interpreted or no suitable translations
	 * can be found then the untranslated values are returned. The
	 * returned array is NULL-terminated, so length may optionally
	 * be NULL.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * locale =  a locale identifier or NULL
	 * length =  return location for the number of returned strings or NULL
	 * Returns: a newly allocated NULL-terminated string array or NULL if the key isn't found. The string array should be freed with g_strfreev().
	 * Throws: GException on failure.
	 */
	public string[] getLocaleStringList(string groupName, string key, string locale, out uint length);
	
	/**
	 * Returns the values associated with key under group_name as
	 * booleans.
	 * If key cannot be found then NULL is returned and error is set to
	 * G_KEY_FILE_ERROR_KEY_NOT_FOUND. Likewise, if the values associated
	 * with key cannot be interpreted as booleans then NULL is returned
	 * and error is set to G_KEY_FILE_ERROR_INVALID_VALUE.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * Returns: the values associated with the key as a list of booleans, or NULL if the key was not found or could not be parsed.
	 * Throws: GException on failure.
	 */
	public int[] getBooleanList(string groupName, string key);
	
	/**
	 * Returns the values associated with key under group_name as
	 * integers.
	 * If key cannot be found then NULL is returned and error is set to
	 * G_KEY_FILE_ERROR_KEY_NOT_FOUND. Likewise, if the values associated
	 * with key cannot be interpreted as integers then NULL is returned
	 * and error is set to G_KEY_FILE_ERROR_INVALID_VALUE.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * Returns: the values associated with the key as a list of integers, or NULL if the key was not found or could not be parsed.
	 * Throws: GException on failure.
	 */
	public int[] getIntegerList(string groupName, string key);
	
	/**
	 * Returns the values associated with key under group_name as
	 * doubles.
	 * If key cannot be found then NULL is returned and error is set to
	 * G_KEY_FILE_ERROR_KEY_NOT_FOUND. Likewise, if the values associated
	 * with key cannot be interpreted as doubles then NULL is returned
	 * and error is set to G_KEY_FILE_ERROR_INVALID_VALUE.
	 * Since 2.12
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * Returns: the values associated with the key as a list of doubles, or NULL if the key was not found or could not be parsed.
	 * Throws: GException on failure.
	 */
	public double[] getDoubleList(string groupName, string key);
	
	/**
	 * Retrieves a comment above key from group_name.
	 * If key is NULL then comment will be read from above
	 * group_name. If both key and group_name are NULL, then
	 * comment will be read from above the first group in the file.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name, or NULL
	 * key =  a key
	 * Returns: a comment that should be freed with g_free()
	 * Throws: GException on failure.
	 */
	public string getComment(string groupName, string key);
	
	/**
	 * Associates a new value with key under group_name.
	 * If key cannot be found then it is created. If group_name cannot
	 * be found then it is created. To set an UTF-8 string which may contain
	 * characters that need escaping (such as newlines or spaces), use
	 * g_key_file_set_string().
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * value =  a string
	 */
	public void setValue(string groupName, string key, string value);
	
	/**
	 * Associates a new string value with key under group_name.
	 * If key cannot be found then it is created.
	 * If group_name cannot be found then it is created.
	 * Unlike g_key_file_set_value(), this function handles characters
	 * that need escaping, such as newlines.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * string =  a string
	 */
	public void setString(string groupName, string key, string string);
	
	/**
	 * Associates a string value for key and locale under group_name.
	 * If the translation for key cannot be found then it is created.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * locale =  a locale identifier
	 * string =  a string
	 */
	public void setLocaleString(string groupName, string key, string locale, string string);
	
	/**
	 * Associates a new boolean value with key under group_name.
	 * If key cannot be found then it is created.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * value =  TRUE or FALSE
	 */
	public void setBoolean(string groupName, string key, int value);
	
	/**
	 * Associates a new integer value with key under group_name.
	 * If key cannot be found then it is created.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * value =  an integer value
	 */
	public void setInteger(string groupName, string key, int value);
	
	/**
	 * Associates a new double value with key under group_name.
	 * If key cannot be found then it is created.
	 * Since 2.12
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * value =  an double value
	 */
	public void setDouble(string groupName, string key, double value);
	
	/**
	 * Associates a list of string values for key under group_name.
	 * If key cannot be found then it is created.
	 * If group_name cannot be found then it is created.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * list =  an array of string values
	 * length =  number of string values in list
	 */
	public void setStringList(string groupName, string key, char*[] list, uint length);
	
	/**
	 * Associates a list of string values for key and locale under
	 * group_name. If the translation for key cannot be found then
	 * it is created.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * locale =  a locale identifier
	 * list =  a NULL-terminated array of locale string values
	 * length =  the length of list
	 */
	public void setLocaleStringList(string groupName, string key, string locale, char*[] list, uint length);
	
	/**
	 * Associates a list of boolean values with key under group_name.
	 * If key cannot be found then it is created.
	 * If group_name is NULL, the start_group is used.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * list =  an array of boolean values
	 * length =  length of list
	 */
	public void setBooleanList(string groupName, string key, int[] list, uint length);
	
	/**
	 * Associates a list of integer values with key under group_name.
	 * If key cannot be found then it is created.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * list =  an array of integer values
	 * length =  number of integer values in list
	 */
	public void setIntegerList(string groupName, string key, int[] list, uint length);
	
	/**
	 * Associates a list of double values with key under
	 * group_name. If key cannot be found then it is created.
	 * Since 2.12
	 * Params:
	 * groupName =  a group name
	 * key =  a key
	 * list =  an array of double values
	 * length =  number of double values in list
	 */
	public void setDoubleList(string groupName, string key, double[] list, uint length);
	
	/**
	 * Places a comment above key from group_name.
	 * If key is NULL then comment will be written above group_name.
	 * If both key and group_name are NULL, then comment will be
	 * written above the first group in the file.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name, or NULL
	 * key =  a key
	 * comment =  a comment
	 * Returns: TRUE if the comment was written, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int setComment(string groupName, string key, string comment);
	
	/**
	 * Removes the specified group, group_name,
	 * from the key file.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * Returns: TRUE if the group was removed, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int removeGroup(string groupName);
	
	/**
	 * Removes key in group_name from the key file.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name
	 * key =  a key name to remove
	 * Returns: TRUE if the key was removed, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int removeKey(string groupName, string key);
	
	/**
	 * Removes a comment above key from group_name.
	 * If key is NULL then comment will be removed above group_name.
	 * If both key and group_name are NULL, then comment will
	 * be removed above the first group in the file.
	 * Since 2.6
	 * Params:
	 * groupName =  a group name, or NULL
	 * key =  a key
	 * Returns: TRUE if the comment was removed, FALSE otherwise
	 * Throws: GException on failure.
	 */
	public int removeComment(string groupName, string key);
}
