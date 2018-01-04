module gtkD.glib.StringGChunk;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * String chunks are used to store groups of strings.
 * Memory is allocated in blocks, and as strings are added to the GStringChunk
 * they are copied into the next free position in a block. When a block is
 * full a new block is allocated.
 * When storing a large number of strings, string chunks are more efficient
 * than using g_strdup() since fewer calls to malloc() are needed, and less
 * memory is wasted in memory allocation overheads.
 * By adding strings with g_string_chunk_insert_const() it is also possible
 * to remove duplicates.
 * To create a new GStringChunk use g_string_chunk_new().
 * To add strings to a GStringChunk use g_string_chunk_insert().
 * To add strings to a GStringChunk, but without duplicating strings which are
 * already in the GStringChunk, use g_string_chunk_insert_const().
 * To free the entire GStringChunk use g_string_chunk_free().
 * It is not possible to free individual strings.
 */
public class StringGChunk
{
	
	/** the main Gtk struct */
	protected GStringChunk* gStringChunk;
	
	
	public GStringChunk* getStringGChunkStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GStringChunk* gStringChunk);
	
	/**
	 */
	
	/**
	 * Creates a new GStringChunk.
	 * Params:
	 * size =  the default size of the blocks of memory which are
	 *  allocated to store the strings. If a particular string
	 *  is larger than this default size, a larger block of
	 *  memory will be allocated for it.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (uint size);
	
	/**
	 * Adds a copy of string to the GStringChunk.
	 * It returns a pointer to the new copy of the string
	 * in the GStringChunk. The characters in the string
	 * can be changed, if necessary, though you should not
	 * change anything after the end of the string.
	 * Unlike g_string_chunk_insert_const(), this function
	 * does not check for duplicates. Also strings added
	 * with g_string_chunk_insert() will not be searched
	 * by g_string_chunk_insert_const() when looking for
	 * duplicates.
	 * Params:
	 * string =  the string to add
	 * Returns: a pointer to the copy of string within  the GStringChunk
	 */
	public string insert(string string);
	
	/**
	 * Adds a copy of string to the GStringChunk, unless the same
	 * string has already been added to the GStringChunk with
	 * g_string_chunk_insert_const().
	 * This function is useful if you need to copy a large number
	 * of strings but do not want to waste space storing duplicates.
	 * But you must remember that there may be several pointers to
	 * the same string, and so any changes made to the strings
	 * should be done very carefully.
	 * Note that g_string_chunk_insert_const() will not return a
	 * pointer to a string added with g_string_chunk_insert(), even
	 * if they do match.
	 * Params:
	 * string =  the string to add
	 * Returns: a pointer to the new or existing copy of string within the GStringChunk
	 */
	public string insertConst(string string);
	
	/**
	 * Adds a copy of the first len bytes of string to the GStringChunk.
	 * The copy is nul-terminated.
	 * Since this function does not stop at nul bytes, it is the caller's
	 * responsibility to ensure that string has at least len addressable
	 * bytes.
	 * The characters in the returned string can be changed, if necessary,
	 * though you should not change anything after the end of the string.
	 * Since 2.4
	 * Params:
	 * string =  bytes to insert
	 * len =  number of bytes of string to insert, or -1 to insert a
	 *  nul-terminated string
	 * Returns: a pointer to the copy of string within the GStringChunk
	 */
	public string insertLen(string string, int len);

	/**
	 * Frees all strings contained within the GStringChunk.
	 * After calling g_string_chunk_clear() it is not safe to
	 * access any of the strings which were contained within it.
	 * Since 2.14
	 */
	public void clear();
	
	/**
	 * Frees all memory allocated by the GStringChunk.
	 * After calling g_string_chunk_free() it is not safe to
	 * access any of the strings which were contained within it.
	 */
	public void free();
}
