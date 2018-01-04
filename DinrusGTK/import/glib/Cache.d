module gtkD.glib.Cache;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * A GCache allows sharing of complex data structures, in order to save
 * system resources.
 * GTK+ uses caches for GtkStyles and GdkGCs. These consume a lot of
 * resources, so a GCache is used to see if a GtkStyle or GdkGC with the
 * required properties already exists. If it does, then the existing
 * object is used instead of creating a new one.
 * GCache uses keys and values.
 * A GCache key describes the properties of a particular resource.
 * A GCache value is the actual resource.
 */
public class Cache
{
	
	/** the main Gtk struct */
	protected GCache* gCache;
	
	
	public GCache* getCacheStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GCache* gCache);
	
	/**
	 */
	
	/**
	 * Creates a new GCache.
	 * Params:
	 * valueNewFunc = a function to create a new object given a key.
	 * This is called by g_cache_insert() if an object with the given key
	 * does not already exist.
	 * valueDestroyFunc = a function to destroy an object. It is
	 * called by g_cache_remove() when the object is no longer needed (i.e. its
	 * reference count drops to 0).
	 * keyDupFunc = a function to copy a key. It is called by
	 * g_cache_insert() if the key does not already exist in the GCache.
	 * keyDestroyFunc = a function to destroy a key. It is
	 * called by g_cache_remove() when the object is no longer needed (i.e. its
	 * reference count drops to 0).
	 * hashKeyFunc = a function to create a hash value from a key.
	 * hashValueFunc = a function to create a hash value from a value.
	 * keyEqualFunc = a function to compare two keys. It should return TRUE if
	 * the two keys are equivalent.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GCacheNewFunc valueNewFunc, GCacheDestroyFunc valueDestroyFunc, GCacheDupFunc keyDupFunc, GCacheDestroyFunc keyDestroyFunc, GHashFunc hashKeyFunc, GHashFunc hashValueFunc, GEqualFunc keyEqualFunc);
	
	/**
	 * Gets the value corresponding to the given key, creating it if necessary.
	 * It first checks if the value already exists in the GCache, by using
	 * the key_equal_func function passed to g_cache_new().
	 * If it does already exist it is returned, and its reference count is increased
	 * by one.
	 * If the value does not currently exist, if is created by calling the
	 * value_new_func. The key is duplicated by calling
	 * key_dup_func and the duplicated key and value are inserted
	 * into the GCache.
	 * Params:
	 * key = a key describing a GCache object.
	 * Returns:a pointer to a GCache value.
	 */
	public void* insert(void* key);
	
	/**
	 * Decreases the reference count of the given value.
	 * If it drops to 0 then the value and its corresponding key are destroyed,
	 * using the value_destroy_func and key_destroy_func passed to g_cache_new().
	 * Params:
	 * value = the value to remove.
	 */
	public void remove(void* value);
	
	/**
	 * Frees the memory allocated for the GCache.
	 * Note that it does not destroy the keys and values which were contained in the
	 * GCache.
	 */
	public void destroy();
	
	/**
	 * Calls the given function for each of the keys in the GCache.
	 * Note
	 * func is passed three parameters, the value and key of a
	 * cache entry and the user_data. The order of value and key is different
	 * from the order in which g_hash_table_foreach() passes key-value pairs
	 * to its callback function !
	 * Params:
	 * func = the function to call with each GCache key.
	 * userData = user data to pass to the function.
	 */
	public void keyForeach(GHFunc func, void* userData);

	/**
	 * Warning
	 * g_cache_value_foreach has been deprecated since version 2.10 and should not be used in newly-written code. The reason is that it passes pointers to internal data
	 * structures to func; use g_cache_key_foreach() instead
	 * Calls the given function for each of the values in the GCache.
	 * Params:
	 * func = the function to call with each GCache value.
	 * userData = user data to pass to the function.
	 */
	public void valueForeach(GHFunc func, void* userData);
}
