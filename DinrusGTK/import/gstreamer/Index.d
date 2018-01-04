module gtkD.gstreamer.Index;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gstreamer.ObjectGst;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * GstIndex is used to generate a stream index of one or more elements
 * in a pipeline.
 */
public class Index : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstIndex* gstIndex;
	
	
	public GstIndex* getIndexStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstIndex* gstIndex);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(GstIndexEntry*, Index)[] onEntryAddedListeners;
	/**
	 * Is emitted when a new entry is added to the index.
	 * See Also
	 * GstIndexFactory
	 */
	void addOnEntryAdded(void delegate(GstIndexEntry*, Index) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackEntryAdded(GstIndex* gstindexStruct, GstIndexEntry* arg1, Index index);
	
	
	/**
	 * Create a new tileindex object
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Tell the index that the writer with the given id is done
	 * with this index and is not going to write any more entries
	 * to it.
	 * Params:
	 * id =  the writer that commited the index
	 */
	public void commit(int id);
	
	/**
	 * Get the id of the current group.
	 * Returns: the id of the current group.
	 */
	public int getGroup();
	
	/**
	 * Create a new group for the given index. It will be
	 * set as the current group.
	 * Returns: the id of the newly created group.
	 */
	public int newGroup();
	
	/**
	 * Set the current groupnumber to the given argument.
	 * Params:
	 * groupnum =  the groupnumber to set
	 * Returns: TRUE if the operation succeeded, FALSE if the groupdid not exist.
	 */
	public int setGroup(int groupnum);
	
	/**
	 * Set the certainty of the given index.
	 * Params:
	 * certainty =  the certainty to set
	 */
	public void setCertainty(GstIndexCertainty certainty);
	
	/**
	 * Get the certainty of the given index.
	 * Returns: the certainty of the index.
	 */
	public GstIndexCertainty getCertainty();
	
	/**
	 * Lets the app register a custom filter function so that
	 * it can select what entries should be stored in the index.
	 * Params:
	 * filter =  the filter to register
	 * userData =  data passed to the filter function
	 */
	public void setFilter(GstIndexFilter filter, void* userData);
	
	/**
	 * Lets the app register a custom filter function so that
	 * it can select what entries should be stored in the index.
	 * Params:
	 * filter =  the filter to register
	 * userData =  data passed to the filter function
	 * userDataDestroy =  function to call when user_data is unset
	 */
	public void setFilterFull(GstIndexFilter filter, void* userData, GDestroyNotify userDataDestroy);
	
	/**
	 * Lets the app register a custom function to map index
	 * ids to writer descriptions.
	 * Params:
	 * resolver =  the resolver to register
	 * userData =  data passed to the resolver function
	 */
	public void setResolver(GstIndexResolver resolver, void* userData);
	
	/**
	 * Before entries can be added to the index, a writer
	 * should obtain a unique id. The methods to add new entries
	 * to the index require this id as an argument.
	 * The application can implement a custom function to map the writer object
	 * to a string. That string will be used to register or look up an id
	 * in the index.
	 * Params:
	 * writer =  the GstObject to allocate an id for
	 * id =  a pointer to a gint to hold the id
	 * Returns: TRUE if the writer would be mapped to an id.
	 */
	public int getWriterId(ObjectGst writer, int* id);
	
	/**
	 * Adds a format entry into the index. This function is
	 * used to map dynamic GstFormat ids to their original
	 * format key.
	 * Params:
	 * id =  the id of the index writer
	 * format =  the format to add to the index
	 * Returns: a pointer to the newly added entry in the index.
	 */
	public GstIndexEntry* addFormat(int id, GstFormat format);
	
	/**
	 * Associate given format/value pairs with each other.
	 * Params:
	 * id =  the id of the index writer
	 * flags =  optinal flags for this entry
	 * n =  number of associations
	 * list =  list of associations
	 * Returns: a pointer to the newly added entry in the index.
	 */
	public GstIndexEntry* addAssociationv(int id, GstAssocFlags flags, int n, GstIndexAssociation* list);
	
	/**
	 * Add the given object to the index with the given key.
	 * This function is not yet implemented.
	 * Params:
	 * id =  the id of the index writer
	 * key =  a key for the object
	 * type =  the GType of the object
	 * object =  a pointer to the object to add
	 * Returns: a pointer to the newly added entry in the index.
	 */
	public GstIndexEntry* addObject(int id, string key, GType type, void* object);
	
	/**
	 * Add an id entry into the index.
	 * Params:
	 * id =  the id of the index writer
	 * description =  the description of the index writer
	 * Returns: a pointer to the newly added entry in the index.
	 */
	public GstIndexEntry* addId(int id, string description);
	
	/**
	 * Finds the given format/value in the index
	 * Params:
	 * id =  the id of the index writer
	 * method =  The lookup method to use
	 * flags =  Flags for the entry
	 * format =  the format of the value
	 * value =  the value to find
	 * Returns: the entry associated with the value or NULL if the value was not found.
	 */
	public GstIndexEntry* getAssocEntry(int id, GstIndexLookupMethod method, GstAssocFlags flags, GstFormat format, long value);
	
	/**
	 * Finds the given format/value in the index with the given
	 * compare function and user_data.
	 * Params:
	 * id =  the id of the index writer
	 * method =  The lookup method to use
	 * flags =  Flags for the entry
	 * format =  the format of the value
	 * value =  the value to find
	 * func =  the function used to compare entries
	 * userData =  user data passed to the compare function
	 * Returns: the entry associated with the value or NULL if the value was not found.
	 */
	public GstIndexEntry* getAssocEntryFull(int id, GstIndexLookupMethod method, GstAssocFlags flags, GstFormat format, long value, GCompareDataFunc func, void* userData);
	
	/**
	 * Copies an entry and returns the result.
	 * Params:
	 * entry =  the entry to copy
	 * Returns: a newly allocated GstIndexEntry.
	 */
	public static GstIndexEntry* entryCopy(GstIndexEntry* entry);
	
	/**
	 * Free the memory used by the given entry.
	 * Params:
	 * entry =  the entry to free
	 */
	public static void entryFree(GstIndexEntry* entry);
	
	/**
	 * Gets alternative formats associated with the indexentry.
	 * Params:
	 * entry =  the index to search
	 * format =  the format of the value the find
	 * value =  a pointer to store the value
	 * Returns: TRUE if there was a value associated with the givenformat.
	 */
	public static int entryAssocMap(GstIndexEntry* entry, GstFormat format, long* value);
}
