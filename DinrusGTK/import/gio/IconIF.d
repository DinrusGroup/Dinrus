module gtkD.gio.IconIF;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;




/**
 * Description
 * GIcon is a very minimal interface for icons. It provides functions
 * for checking the equality of two icons, hashing of icons and
 * serializing an icon to and from strings.
 * GIcon does not provide the actual pixmap for the icon as this is out
 * of GIO's scope, however implementations of GIcon may contain the name
 * of an icon (see GThemedIcon), or the path to an icon (see GLoadableIcon).
 * To obtain a hash of a GIcon, see g_icon_hash().
 * To check if two GIcons are equal, see g_icon_equal().
 * For serializing a GIcon, use g_icon_to_string() and
 * g_icon_new_for_string().
 * If your application or library provides one or more GIcon
 * implementations you need to ensure that each GType is registered
 * with the type system prior to calling g_icon_new_for_string().
 */
public interface IconIF
{
	
	
	public GIcon* getIconTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	/**
	 * Gets a hash for an icon.
	 * Params:
	 * icon =  gconstpointer to an icon object.
	 * Returns: a guint containing a hash for the icon, suitable for use in a GHashTable or similar data structure.
	 */
	public static uint hash(void* icon);
	
	/**
	 * Checks if two icons are equal.
	 * Params:
	 * icon2 =  pointer to the second GIcon.
	 * Returns: TRUE if icon1 is equal to icon2. FALSE otherwise.
	 */
	public int equal(GIcon* icon2);
	
	/**
	 * Generates a textual representation of icon that can be used for
	 * serialization such as when passing icon to a different process or
	 * saving it to persistent storage. Use g_icon_new_for_string() to
	 * get icon back from the returned string.
	 * The encoding of the returned string is proprietary to GIcon except
	 * in the following two cases
	 *  If icon is a GFileIcon, the returned string is a native path
	 *  (such as /path/to/my icon.png) without escaping
	 *  if the GFile for icon is a native file. If the file is not
	 *  native, the returned string is the result of g_file_get_uri()
	 *  (such as sftp://path/to/my%20icon.png).
	 *  If icon is a GThemedIcon with exactly one name, the encoding is
	 *  simply the name (such as network-server).
	 * Since 2.20
	 * Returns: An allocated NUL-terminated UTF8 string or NULL if icon can'tbe serialized. Use g_free() to free.
	 */
	public string toString();
}
