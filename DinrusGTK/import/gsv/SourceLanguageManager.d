module gtkD.gsv.SourceLanguageManager;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gsv.SourceLanguage;
private import gtkD.gsv.SourceLanguageManager;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GtkSourceLanguageManager is an object which processes language description
 * files and creates and stores GtkSourceLanguage objects, and provides API to
 * access them.
 * Use gtk_source_language_manager_get_default() to retrieve the default
 * instance of GtkSourceLanguageManager, and gtk_source_language_manager_guess_language()
 * to get a GtkSourceLanguage for given file name and content type.
 */
public class SourceLanguageManager : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkSourceLanguageManager* gtkSourceLanguageManager;
	
	
	public GtkSourceLanguageManager* getSourceLanguageManagerStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSourceLanguageManager* gtkSourceLanguageManager);
	
	/**
	 */
	
	/**
	 * Creates a new language manager. If you do not need more than one language
	 * manager or a private language manager instance then use
	 * gtk_source_language_manager_get_default() instead.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Returns the default GtkSourceLanguageManager instance.
	 * Returns: a GtkSourceLanguageManager. Return value is ownedby GtkSourceView library and must not be unref'ed.
	 */
	public static SourceLanguageManager getDefault();
	
	/**
	 * Sets the list of directories where the lm looks for
	 * language files.
	 * If dirs is NULL, the search path is reset to default.
	 * Note
	 *  At the moment this function can be called only before the
	 *  language files are loaded for the first time. In practice
	 *  to set a custom search path for a GtkSourceLanguageManager,
	 *  you have to call this function right after creating it.
	 * Params:
	 * dirs =  a NULL-terminated array of strings or NULL.
	 */
	public void setSearchPath(string[] dirs);
	
	/**
	 * Gets the list directories where lm looks for language files.
	 * Returns: NULL-terminated array containg a list of language files directories.The array is owned by lm and must not be modified.
	 */
	public string[] getSearchPath();
	
	/**
	 * Returns the ids of the available languages.
	 * Returns: a NULL-terminated array of string containing the ids of theavailable languages or NULL if no language is available. The arrayis owned by lm and must not be modified.
	 */
	public string[] getLanguageIds();
	
	/**
	 * Gets the GtkSourceLanguage identified by the given id in the language
	 * manager.
	 * Params:
	 * id =  a language id.
	 * Returns: a GtkSourceLanguage, or NULL if there is no languageidentified by the given id. Return value is owned by lm and should notbe freed.
	 */
	public SourceLanguage getLanguage(string id);
	
	/**
	 * Picks a GtkSourceLanguage for given file name and content type,
	 * according to the information in lang files. Either filename or
	 * Since 2.4
	 * Params:
	 * filename =  a filename in Glib filename encoding, or NULL.
	 * contentType =  a content type (as in GIO API), or NULL.
	 * Returns: a GtkSourceLanguage, or NULL if there is no suitable languagefor given filename and/or content_type. Return value is owned by lmand should not be freed.
	 */
	public SourceLanguage guessLanguage(string filename, string contentType);
}
