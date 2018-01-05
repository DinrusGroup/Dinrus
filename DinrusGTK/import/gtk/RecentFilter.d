module gtkD.gtk.RecentFilter;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gtk.ObjectGtk;

/**
 * Description
 * A GtkRecentFilter can be used to restrict the files being shown
 * in a GtkRecentChooser. Files can be filtered based on their name
 * (with gtk_recent_filter_add_pattern()), on their mime type (with
 * gtk_file_filter_add_mime_type()), on the application that has
 * registered them (with gtk_recent_filter_add_application()), or by
 * a custom filter function (with gtk_recent_filter_add_custom()).
 * Filtering by mime type handles aliasing and subclassing of mime
 * types; e.g. a filter for text/plain also matches a file with mime
 * type application/rtf, since application/rtf is a subclass of text/plain.
 * Note that GtkRecentFilter allows wildcards for the subtype of a
 * mime type, so you can e.g. filter for image/+*.
 * Normally, filters are used by adding them to a GtkRecentChooser,
 * see gtk_recent_chooser_add_filter(), but it is also possible to
 * manually use a filter on a file with gtk_recent_filter_filter().
 * Recently used files are supported since GTK+ 2.10.
 */
public class RecentFilter : ObjectGtk
{
	
	/** the main Gtk struct */
	protected GtkRecentFilter* gtkRecentFilter;
	
	
	public GtkRecentFilter* getRecentFilterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRecentFilter* gtkRecentFilter);
	
	/**
	 */
	
	/**
	 * Creates a new GtkRecentFilter with no rules added to it.
	 * Such filter does not accept any recently used resources, so is not
	 * particularly useful until you add rules with
	 * gtk_recent_filter_add_pattern(), gtk_recent_filter_add_mime_type(),
	 * gtk_recent_filter_add_application(), gtk_recent_filter_add_age().
	 * Since 2.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Gets the human-readable name for the filter.
	 * See gtk_recent_filter_set_name().
	 * Since 2.10
	 * Returns: the name of the filter, or NULL. The returned string is owned by the filter object and should not be freed.
	 */
	public string getName();
	
	/**
	 * Sets the human-readable name of the filter; this is the string
	 * that will be displayed in the recently used resources selector
	 * user interface if there is a selectable list of filters.
	 * Since 2.10
	 * Params:
	 * name =  then human readable name of filter
	 */
	public void setName(string name);
	
	/**
	 * Adds a rule that allows resources based on their registered MIME type.
	 * Since 2.10
	 * Params:
	 * mimeType =  a MIME type
	 */
	public void addMimeType(string mimeType);
	
	/**
	 * Adds a rule that allows resources based on a pattern matching their
	 * display name.
	 * Since 2.10
	 * Params:
	 * pattern =  a file pattern
	 */
	public void addPattern(string pattern);
	
	/**
	 * Adds a rule allowing image files in the formats supported
	 * by GdkPixbuf.
	 * Since 2.10
	 */
	public void addPixbufFormats();
	
	/**
	 * Adds a rule that allows resources based on the name of the application
	 * that has registered them.
	 * Since 2.10
	 * Params:
	 * application =  an application name
	 */
	public void addApplication(string application);
	
	/**
	 * Adds a rule that allows resources based on the name of the group
	 * to which they belong
	 * Since 2.10
	 * Params:
	 * group =  a group name
	 */
	public void addGroup(string group);
	
	/**
	 * Adds a rule that allows resources based on their age - that is, the number
	 * of days elapsed since they were last modified.
	 * Since 2.10
	 * Params:
	 * days =  number of days
	 */
	public void addAge(int days);
	
	/**
	 * Adds a rule to a filter that allows resources based on a custom callback
	 * function. The bitfield needed which is passed in provides information
	 * about what sorts of information that the filter function needs;
	 * this allows GTK+ to avoid retrieving expensive information when
	 * it isn't needed by the filter.
	 * Since 2.10
	 * Params:
	 * needed =  bitfield of flags indicating the information that the custom
	 *  filter function needs.
	 * func =  callback function; if the function returns TRUE, then
	 *  the file will be displayed.
	 * data =  data to pass to func
	 * dataDestroy =  function to call to free data when it is no longer needed.
	 */
	public void addCustom(GtkRecentFilterFlags needed, GtkRecentFilterFunc func, void* data, GDestroyNotify dataDestroy);
	
	/**
	 * Gets the fields that need to be filled in for the structure
	 * passed to gtk_recent_filter_filter()
	 * This function will not typically be used by applications; it
	 * is intended principally for use in the implementation of
	 * GtkRecentChooser.
	 * Since 2.10
	 * Returns: bitfield of flags indicating needed fields when calling gtk_recent_filter_filter()
	 */
	public GtkRecentFilterFlags getNeeded();
	
	/**
	 * Tests whether a file should be displayed according to filter.
	 * The GtkRecentFilterInfo structure filter_info should include
	 * the fields returned from gtk_recent_filter_get_needed().
	 * This function will not typically be used by applications; it
	 * is intended principally for use in the implementation of
	 * GtkRecentChooser.
	 * Since 2.10
	 * Params:
	 * filter =  a GtkRecentFilter
	 * filterInfo =  a GtkRecentFilterInfo structure containing information
	 *  about a recently used resource
	 * Returns: TRUE if the file should be displayed
	 */
	public int filter(GtkRecentFilterInfo* filterInfo);
}
