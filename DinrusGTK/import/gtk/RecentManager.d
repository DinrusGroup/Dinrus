module gtkD.gtk.RecentManager;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gdk.Screen;
private import gtkD.gtk.RecentInfo;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.ListG;



private import gtkD.gobject.ObjectG;

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
public class RecentManager : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkRecentManager* gtkRecentManager;
	
	
	public GtkRecentManager* getRecentManagerStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRecentManager* gtkRecentManager);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(RecentManager)[] onChangedListeners;
	/**
	 * Emitted when the current recently used resources manager changes its
	 * contents.
	 * Since 2.10
	 */
	void addOnChanged(void delegate(RecentManager) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChanged(GtkRecentManager* recentManagerStruct, RecentManager recentManager);
	
	
	/**
	 * Creates a new recent manager object. Recent manager objects are used to
	 * handle the list of recently used resources. A GtkRecentManager object
	 * monitors the recently used resources list, and emits the "changed" signal
	 * each time something inside the list changes.
	 * GtkRecentManager objects are expensive: be sure to create them only when
	 * needed. You should use gtk_recent_manager_get_default() instead.
	 * Since 2.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Gets a unique instance of GtkRecentManager, that you can share
	 * in your application without caring about memory management. The
	 * returned instance will be freed when you application terminates.
	 * Since 2.10
	 * Returns: A unique GtkRecentManager. Do not ref or unref it.
	 */
	public static RecentManager getDefault();
	
	/**
	 * Warning
	 * gtk_recent_manager_get_for_screen has been deprecated since version 2.12 and should not be used in newly-written code. This function has been deprecated and should
	 *  not be used in newly written code. Calling this function is
	 *  equivalent to calling gtk_recent_manager_get_default().
	 * Gets the recent manager object associated with screen; if this
	 * function has not previously been called for the given screen,
	 * a new recent manager object will be created and associated with
	 * the screen. Recent manager objects are fairly expensive to create,
	 * so using this function is usually a better choice than calling
	 * gtk_recent_manager_new() and setting the screen yourself; by using
	 * this function a single recent manager object will be shared between
	 * users.
	 * Since 2.10
	 * Params:
	 * screen =  a GdkScreen
	 * Returns: A unique GtkRecentManager associated with the given screen. This recent manager is associated to the with the screen and can be used as long as the screen is open. Do not ref or unref it.
	 */
	public static RecentManager getForScreen(Screen screen);
	
	/**
	 * Warning
	 * gtk_recent_manager_set_screen has been deprecated since version 2.12 and should not be used in newly-written code. This function has been deprecated and should
	 *  not be used in newly written code. Calling this function has
	 *  no effect.
	 * Sets the screen for a recent manager; the screen is used to
	 * track the user's currently configured recently used documents
	 * storage.
	 * Since 2.10
	 * Params:
	 * screen =  a GdkScreen
	 */
	public void setScreen(Screen screen);
	
	/**
	 * Adds a new resource, pointed by uri, into the recently used
	 * resources list.
	 * This function automatically retrieves some of the needed
	 * metadata and setting other metadata to common default values; it
	 * then feeds the data to gtk_recent_manager_add_full().
	 * See gtk_recent_manager_add_full() if you want to explicitly
	 * define the metadata for the resource pointed by uri.
	 * Since 2.10
	 * Params:
	 * uri =  a valid URI
	 * Returns: TRUE if the new item was successfully added to the recently used resources list
	 */
	public int addItem(string uri);
	
	/**
	 * Adds a new resource, pointed by uri, into the recently used
	 * resources list, using the metadata specified inside the GtkRecentData
	 * structure passed in recent_data.
	 * The passed URI will be used to identify this resource inside the
	 * list.
	 * In order to register the new recently used resource, metadata about
	 * the resource must be passed as well as the URI; the metadata is
	 * stored in a GtkRecentData structure, which must contain the MIME
	 * type of the resource pointed by the URI; the name of the application
	 * that is registering the item, and a command line to be used when
	 * launching the item.
	 * Optionally, a GtkRecentData structure might contain a UTF-8 string
	 * to be used when viewing the item instead of the last component of the
	 * URI; a short description of the item; whether the item should be
	 * considered private - that is, should be displayed only by the
	 * applications that have registered it.
	 * Since 2.10
	 * Params:
	 * uri =  a valid URI
	 * recentData =  metadata of the resource
	 * Returns: TRUE if the new item was successfully added to therecently used resources list, FALSE otherwise.
	 */
	public int addFull(string uri, GtkRecentData* recentData);
	
	/**
	 * Removes a resource pointed by uri from the recently used resources
	 * list handled by a recent manager.
	 * Since 2.10
	 * Params:
	 * uri =  the URI of the item you wish to remove
	 * Returns: TRUE if the item pointed by uri has been successfully removed by the recently used resources list, and FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int removeItem(string uri);
	
	/**
	 * Searches for a URI inside the recently used resources list, and
	 * returns a structure containing informations about the resource
	 * like its MIME type, or its display name.
	 * Since 2.10
	 * Params:
	 * uri =  a URI
	 * Returns: a GtkRecentInfo structure containing information about the resource pointed by uri, or NULL if the URI was not registered in the recently used resources list. Free with gtk_recent_info_unref().
	 * Throws: GException on failure.
	 */
	public RecentInfo lookupItem(string uri);
	
	/**
	 * Checks whether there is a recently used resource registered
	 * with uri inside the recent manager.
	 * Since 2.10
	 * Params:
	 * uri =  a URI
	 * Returns: TRUE if the resource was found, FALSE otherwise.
	 */
	public int hasItem(string uri);
	
	/**
	 * Changes the location of a recently used resource from uri to new_uri.
	 * Please note that this function will not affect the resource pointed
	 * by the URIs, but only the URI used in the recently used resources list.
	 * Since 2.10
	 * Params:
	 * uri =  the URI of a recently used resource
	 * newUri =  the new URI of the recently used resource, or NULL to
	 *  remove the item pointed by uri in the list
	 * Returns: TRUE on success.
	 * Throws: GException on failure.
	 */
	public int moveItem(string uri, string newUri);
	
	/**
	 * Gets the maximum number of items that the gtk_recent_manager_get_items()
	 * function should return.
	 * Since 2.10
	 * Returns: the number of items to return, or -1 for every item.
	 */
	public int getLimit();
	
	/**
	 * Sets the maximum number of item that the gtk_recent_manager_get_items()
	 * function should return. If limit is set to -1, then return all the
	 * items.
	 * Since 2.10
	 * Params:
	 * limit =  the maximum number of items to return, or -1.
	 */
	public void setLimit(int limit);
	
	/**
	 * Gets the list of recently used resources.
	 * Since 2.10
	 * Returns: a list of newly allocated GtkRecentInfo objects. Use gtk_recent_info_unref() on each item inside the list, and then free the list itself using g_list_free().
	 */
	public ListG getItems();
	
	/**
	 * Purges every item from the recently used resources list.
	 * Since 2.10
	 * Returns: the number of items that have been removed from the recently used resources list.
	 * Throws: GException on failure.
	 */
	public int purgeItems();
}
