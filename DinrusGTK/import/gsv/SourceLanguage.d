module gtkD.gsv.SourceLanguage;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GtkSourceLanguage encapsulates syntax and highlighting styles for a
 * particular language. Use GtkSourceLanguageManager to obtain a
 * GtkSourceLanguage instance, and gtk_source_buffer_set_language()
 * to apply it to a GtkSourceBuffer.
 */
public class SourceLanguage : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkSourceLanguage* gtkSourceLanguage;
	
	
	public GtkSourceLanguage* getSourceLanguageStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSourceLanguage* gtkSourceLanguage);
	
	/**
	 */
	
	/**
	 * Returns the ID of the language. The ID is not locale-dependent.
	 * Returns: the ID of language.The returned string is owned by language and should not be freedor modified.
	 */
	public string gtkSourceLanguageGetId();
	
	/**
	 * Returns the localized name of the language.
	 * Returns: the name of language.The returned string is owned by language and should not be freedor modified.
	 */
	public string gtkSourceLanguageGetName();
	
	/**
	 * Returns the localized section of the language.
	 * Each language belong to a section (ex. HTML belogs to the
	 * Markup section).
	 * Returns: the section of language.The returned string is owned by language and should not be freedor modified.
	 */
	public string gtkSourceLanguageGetSection();
	
	/**
	 * Returns whether the language should be hidden from the user.
	 * Returns: TRUE if the language should be hidden, FALSE otherwise.
	 */
	public int gtkSourceLanguageGetHidden();
	
	/**
	 * Params:
	 * name =  metadata property name.
	 * Returns: value of property name stored in the metadata of languageor NULL if language doesn't contain that metadata property.The returned string is owned by language and should not be freedor modified.
	 */
	public string gtkSourceLanguageGetMetadata(string name);
	
	/**
	 * Returns the mime types associated to this language. This is just
	 * an utility wrapper around gtk_source_language_get_metadata() to
	 * retrieve the "mimetypes" metadata property and split it into an
	 * array.
	 * Returns: a newly-allocated NULL terminated array containingthe mime types or NULL if no mime types are found.The returned array must be freed with g_strfreev().
	 */
	public string[] gtkSourceLanguageGetMimeTypes();
	
	/**
	 * Returns the globs associated to this language. This is just
	 * an utility wrapper around gtk_source_language_get_metadata() to
	 * retrieve the "globs" metadata property and split it into an array.
	 * Returns: a newly-allocated NULL terminated array containingthe globs or NULL if no globs are found.The returned array must be freed with g_strfreev().
	 */
	public string[] gtkSourceLanguageGetGlobs();
	
	/**
	 * Returns the name of the style with ID style_id defined by this language.
	 * Params:
	 * styleId =  a style ID
	 * Returns: the name of the style with ID style_id defined by this language orNULL if the style has no name or there is no style with ID style_id definedby this language. The returned string is owned by the language and mustnot be modified.
	 */
	public string gtkSourceLanguageGetStyleName(string styleId);
	
	/**
	 * Returns the ids of the styles defined by this language.
	 * Returns: a NULL terminated array containingids of the styles defined by this language or NULL if no style isdefined. The returned array must be freed with g_strfreev().
	 */
	public string[] gtkSourceLanguageGetStyleIds();
}
