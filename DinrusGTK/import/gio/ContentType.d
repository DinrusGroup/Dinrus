module gtkD.gio.ContentType;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gio.File;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;




/**
 * Description
 * A content type is a platform specific string that defines the type
 * of a file. On unix it is a mime type, on win32 it is an extension string
 * like ".doc", ".txt" or a percieved string like "audio". Such strings
 * can be looked up in the registry at HKEY_CLASSES_ROOT.
 */
public class ContentType
{
	
	/**
	 */
	
	/**
	 * Compares two content types for equality.
	 * Params:
	 * type1 =  a content type string.
	 * type2 =  a content type string.
	 * Returns: TRUE if the two strings are identical or equivalent,FALSE otherwise.
	 */
	public static int equals(string type1, string type2);
	
	/**
	 * Determines if type is a subset of supertype.
	 * Params:
	 * type =  a content type string.
	 * supertype =  a string.
	 * Returns: TRUE if type is a kind of supertype,FALSE otherwise.
	 */
	public static int isA(string type, string supertype);
	
	/**
	 * Checks if the content type is the generic "unknown" type.
	 * On unix this is the "application/octet-stream" mimetype,
	 * while on win32 it is "*".
	 * Params:
	 * type =  a content type string.
	 * Returns: TRUE if the type is the unknown type.
	 */
	public static int isUnknown(string type);
	
	/**
	 * Gets the human readable description of the content type.
	 * Params:
	 * type =  a content type string.
	 * Returns: a short description of the content type type.
	 */
	public static string getDescription(string type);

	/**
	 * Gets the mime-type for the content type. If one is registered
	 * Params:
	 * type =  a content type string.
	 * Returns: the registered mime-type for the given type, or NULL if unknown.
	 */
	public static string getMimeType(string type);
	
	/**
	 * Gets the icon for a content type.
	 * Params:
	 * type =  a content type string.
	 * Returns: GIcon corresponding to the content type.
	 */
	public static IconIF getIcon(string type);
	
	/**
	 * Checks if a content type can be executable. Note that for instance
	 * things like text files can be executables (i.e. scripts and batch files).
	 * Params:
	 * type =  a content type string.
	 * Returns: TRUE if the file type corresponds to a type thatcan be executable, FALSE otherwise.
	 */
	public static int canBeExecutable(string type);
	
	/**
	 * Tries to find a content type based on the mime type name.
	 * Since 2.18
	 * Params:
	 * mimeType =  a mime type string.
	 * Returns: Newly allocated string with content type or NULL when does not know.
	 */
	public static string fromMimeType(string mimeType);
	
	/**
	 * Guesses the content type based on example data. If the function is
	 * uncertain, result_uncertain will be set to TRUE. Either filename
	 * or data may be NULL, in which case the guess will be based solely
	 * on the other argument.
	 * Params:
	 * filename =  a string, or NULL
	 * data =  a stream of data, or NULL
	 * resultUncertain =  a flag indicating the certainty of the result
	 * Returns: a string indicating a guessed content type for the given data.
	 */
	public static string guess(string filename, char[] data, out int resultUncertain);
	
	/**
	 * Tries to guess the type of the tree with root root, by
	 * looking at the files it contains. The result is an array
	 * of content types, with the best guess coming first.
	 * The types returned all have the form x-content/foo, e.g.
	 * x-content/audio-cdda (for audio CDs) or x-content/image-dcf
	 * (for a camera memory card). See the shared-mime-info
	 * specification for more on x-content types.
	 * This function is useful in the implementation of g_mount_guess_content_type().
	 * Since 2.18
	 * Params:
	 * root =  the root of the tree to guess a type for
	 * Returns: an NULL-terminated array of zero or more content types, or NULL.  Free with g_strfreev()
	 */
	public static string[] guessForTree(File root);
	
	/**
	 * Gets a list of strings containing all the registered content types
	 * known to the system. The list and its data should be freed using
	 * g_list_foreach(list, g_free, NULL) and g_list_free(list)
	 * Returns: GList of the registered content types.
	 */
	public static ListG gContentTypesGetRegistered();
}
