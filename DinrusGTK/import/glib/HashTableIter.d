module gtkD.glib.HashTableIter;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.HashTable;




/**
 * Description
 * A GHashTable provides associations between keys and values which
 * is optimized so that given a key, the associated value can be found
 * very quickly.
 * Note that neither keys nor values are copied when inserted into the
 * GHashTable, so they must exist for the lifetime of the GHashTable.
 * This means that the use of static strings is OK, but temporary
 * strings (i.e. those created in buffers and those returned by GTK+ widgets)
 * should be copied with g_strdup() before being inserted.
 * If keys or values are dynamically allocated, you must be careful to ensure
 * that they are freed when they are removed from the GHashTable, and also
 * when they are overwritten by new insertions into the GHashTable.
 * It is also not advisable to mix static strings and dynamically-allocated
 * strings in a GHashTable, because it then becomes difficult to determine
 * whether the string should be freed.
 * To create a GHashTable, use g_hash_table_new().
 * To insert a key and value into a GHashTable, use g_hash_table_insert().
 * To lookup a value corresponding to a given key, use g_hash_table_lookup()
 * and g_hash_table_lookup_extended().
 * To remove a key and value, use g_hash_table_remove().
 * To call a function for each key and value pair use g_hash_table_foreach()
 * or use a iterator to iterate over the key/value pairs in the hash table, see
 * GHashTableIter.
 * To destroy a GHashTable use g_hash_table_destroy().
 */
public class HashTableIter
{
	
	/** the main Gtk struct */
	protected GHashTableIter* gHashTableIter;
	
	
	public GHashTableIter* getHashTableIterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GHashTableIter* gHashTableIter);
	
	/**
	 */
	
	/**
	 * Initializes a key/value pair iterator and associates it with
	 * hash_table. Modifying the hash table after calling this function
	 * invalidates the returned iterator.
	 * GHashTableIter iter;
	 * gpointer key, value;
	 * g_hash_table_iter_init (iter, hash_table);
	 * while (g_hash_table_iter_next (iter, key, value))
	 *  {
		 *  /+* do something with key and value +/
	 *  }
	 * Since 2.16
	 * Params:
	 * hashTable =  a GHashTable.
	 */
	public void init(HashTable hashTable);
	
	/**
	 * Advances iter and retrieves the key and/or value that are now
	 * pointed to as a result of this advancement. If FALSE is returned,
	 * key and value are not set, and the iterator becomes invalid.
	 * Since 2.16
	 * Params:
	 * key =  a location to store the key, or NULL.
	 * value =  a location to store the value, or NULL.
	 * Returns: FALSE if the end of the GHashTable has been reached.
	 */
	public int next(void** key, void** value);
	
	/**
	 * Returns the GHashTable associated with iter.
	 * Since 2.16
	 * Returns: the GHashTable associated with iter.
	 */
	public HashTable getHashTable();
	
	/**
	 * Removes the key/value pair currently pointed to by the iterator
	 * from its associated GHashTable. Can only be called after
	 * g_hash_table_iter_next() returned TRUE, and cannot be called more
	 * than once for the same key/value pair.
	 * If the GHashTable was created using g_hash_table_new_full(), the
	 * key and value are freed using the supplied destroy functions, otherwise
	 * you have to make sure that any dynamically allocated values are freed
	 * yourself.
	 * Since 2.16
	 */
	public void remove();
	
	/**
	 * Removes the key/value pair currently pointed to by the iterator
	 * from its associated GHashTable, without calling the key and value
	 * destroy functions. Can only be called after
	 * g_hash_table_iter_next() returned TRUE, and cannot be called more
	 * than once for the same key/value pair.
	 * Since 2.16
	 */
	public void steal();
}
