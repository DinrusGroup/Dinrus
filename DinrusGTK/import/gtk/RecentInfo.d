module gtkD.gtk.RecentInfo;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gdk.Pixbuf;




/**
 * Description
 * GtkRecentManager provides a facility for adding, removing and
 * looking up recently used files. Each recently used file is
 * identified by its URI, and has meta-data associated to it, like
 * the names and command lines of the applications that have
 * registered it, the number of time each application has registered
 * the same file, the mime type of the file and whether the file
 * should be displayed only by the applications that have
 * registered it.
 * The GtkRecentManager acts like a database of all the recently
 * used files. You can create new GtkRecentManager objects, but
 * it is more efficient to use the standard recent manager for
 * the GdkScreen so that informations about the recently used
 * files is shared with other people using them. In case the
 * default screen is being used, adding a new recently used
 * file is as simple as:
 * GtkRecentManager *manager;
 * manager = gtk_recent_manager_get_default ();
 * gtk_recent_manager_add_item (manager, file_uri);
 * While looking up a recently used file is as simple as:
 * GtkRecentManager *manager;
 * GtkRecentInfo *info;
 * GError *error = NULL;
 * manager = gtk_recent_manager_get_default ();
 * info = gtk_recent_manager_lookup_item (manager, file_uri, error);
 * if (error)
 *  {
	 *  g_warning ("Could not find the file: %s", error->message);
	 *  g_error_free (error);
 *  }
 * else
 *  {
	 *  /+* Use the info object +/
	 *  gtk_recent_info_unref (info);
 *  }
 * Recently used files are supported since GTK+ 2.10.
 */
public class RecentInfo
{
	
	/** the main Gtk struct */
	protected GtkRecentInfo* gtkRecentInfo;
	
	
	public GtkRecentInfo* getRecentInfoStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRecentInfo* gtkRecentInfo);
	
	/**
	 */
	
	/**
	 * Increases the reference count of recent_info by one.
	 * Since 2.10
	 * Returns: the recent info object with its reference count increased by one.
	 */
	public RecentInfo doref();
	
	/**
	 * Decreases the reference count of info by one. If the reference
	 * count reaches zero, info is deallocated, and the memory freed.
	 * Since 2.10
	 */
	public void unref();
	
	/**
	 * Gets the URI of the resource.
	 * Since 2.10
	 * Returns: the URI of the resource. The returned string is owned by the recent manager, and should not be freed.
	 */
	public string getUri();
	
	/**
	 * Gets the name of the resource. If none has been defined, the basename
	 * of the resource is obtained.
	 * Since 2.10
	 * Returns: the display name of the resource. The returned string is owned by the recent manager, and should not be freed.
	 */
	public string getDisplayName();
	
	/**
	 * Gets the (short) description of the resource.
	 * Since 2.10
	 * Returns: the description of the resource. The returned string is owned by the recent manager, and should not be freed.
	 */
	public string getDescription();
	
	/**
	 * Gets the MIME type of the resource.
	 * Since 2.10
	 * Returns: the MIME type of the resource. The returned string is owned by the recent manager, and should not be freed.
	 */
	public string getMimeType();
	
	/**
	 * Gets the timestamp (seconds from system's Epoch) when the resource
	 * was added to the recently used resources list.
	 * Since 2.10
	 * Returns: the number of seconds elapsed from system's Epoch when the resource was added to the list, or -1 on failure.
	 */
	public uint getAdded();
	
	/**
	 * Gets the timestamp (seconds from system's Epoch) when the resource
	 * was last modified.
	 * Since 2.10
	 * Returns: the number of seconds elapsed from system's Epoch when the resource was last modified, or -1 on failure.
	 */
	public uint getModified();
	
	/**
	 * Gets the timestamp (seconds from system's Epoch) when the resource
	 * was last visited.
	 * Since 2.10
	 * Returns: the number of seconds elapsed from system's Epoch when the resource was last visited, or -1 on failure.
	 */
	public uint getVisited();
	
	/**
	 * Gets the value of the "private" flag. Resources in the recently used
	 * list that have this flag set to TRUE should only be displayed by the
	 * applications that have registered them.
	 * Since 2.10
	 * Returns: TRUE if the private flag was found, FALSE otherwise.
	 */
	public int getPrivateHint();
	
	/**
	 * Gets the data regarding the application that has registered the resource
	 * pointed by info.
	 * If the command line contains any escape characters defined inside the
	 * storage specification, they will be expanded.
	 * Since 2.10
	 * Params:
	 * appName =  the name of the application that has registered this item
	 * appExec =  return location for the string containing the command line
	 * count =  return location for the number of times this item was registered
	 * time =  return location for the timestamp this item was last registered
	 *  for this application
	 * Returns: TRUE if an application with app_name has registered this resource inside the recently used list, or FALSE otherwise. The app_exec string is owned by the GtkRecentInfo and should not be modified or freed
	 */
	public int getApplicationInfo(string appName, out string appExec, out uint count, out uint time);
	
	/**
	 * Retrieves the list of applications that have registered this resource.
	 * Since 2.10
	 * Returns: a newly allocated NULL-terminated array of strings. Use g_strfreev() to free it.
	 */
	public string[] getApplications();
	
	/**
	 * Gets the name of the last application that have registered the
	 * recently used resource represented by info.
	 * Since 2.10
	 * Returns: an application name. Use g_free() to free it.
	 */
	public string lastApplication();
	
	/**
	 * Returns all groups registered for the recently used item info. The
	 * array of returned group names will be NULL terminated, so length might
	 * optionally be NULL.
	 * Since 2.10
	 * Returns: a newly allocated NULL terminated array of strings. Use g_strfreev() to free it.
	 */
	public string[] getGroups();
	
	/**
	 * Checks whether group_name appears inside the groups registered for the
	 * recently used item info.
	 * Since 2.10
	 * Params:
	 * groupName =  name of a group
	 * Returns: TRUE if the group was found.
	 */
	public int hasGroup(string groupName);
	
	/**
	 * Checks whether an application registered this resource using app_name.
	 * Since 2.10
	 * Params:
	 * appName =  a string containing an application name
	 * Returns: TRUE if an application with name app_name was found, FALSE otherwise.
	 */
	public int hasApplication(string appName);
	
	/**
	 * Retrieves the icon of size size associated to the resource MIME type.
	 * Since 2.10
	 * Params:
	 * size =  the size of the icon in pixels
	 * Returns: a GdkPixbuf containing the icon, or NULL. Use g_object_unref() when finished using the icon.
	 */
	public Pixbuf getIcon(int size);
	
	/**
	 * Computes a valid UTF-8 string that can be used as the name of the item in a
	 * menu or list. For example, calling this function on an item that refers to
	 * "file:///foo/bar.txt" will yield "bar.txt".
	 * Since 2.10
	 * Returns: A newly-allocated string in UTF-8 encoding; free it with g_free().
	 */
	public string getShortName();
	
	/**
	 * Gets a displayable version of the resource's URI. If the resource
	 * is local, it returns a local path; if the resource is not local,
	 * it returns the UTF-8 encoded content of gtk_recent_info_get_uri().
	 * Since 2.10
	 * Returns: a newly allocated UTF-8 string containing the resource's URI or NULL. Use g_free() when done using it.
	 */
	public string getUriDisplay();
	
	/**
	 * Gets the number of days elapsed since the last update of the resource
	 * pointed by info.
	 * Since 2.10
	 * Returns: a positive integer containing the number of days elapsed since the time this resource was last modified.
	 */
	public int getAge();
	
	/**
	 * Checks whether the resource is local or not by looking at the
	 * scheme of its URI.
	 * Since 2.10
	 * Returns: TRUE if the resource is local.
	 */
	public int isLocal();
	
	/**
	 * Checks whether the resource pointed by info still exists. At
	 * the moment this check is done only on resources pointing to local files.
	 * Since 2.10
	 * Returns: TRUE if the resource exists
	 */
	public int exists();
	
	/**
	 * Checks whether two GtkRecentInfo structures point to the same
	 * resource.
	 * Since 2.10
	 * Params:
	 * infoB =  a GtkRecentInfo
	 * Returns: TRUE if both GtkRecentInfo structures point to se same resource, FALSE otherwise.
	 */
	public int match(RecentInfo infoB);
}
