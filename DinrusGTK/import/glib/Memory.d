module gtkD.glib.Memory;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * These functions provide support for allocating and freeing memory.
 * Note
 * If any call to allocate memory fails, the application is terminated.
 * This also means that there is no need to check if the call succeeded.
 * Note
 * It's important to match g_malloc() with g_free(), plain malloc() with free(),
 * and (if you're using C++) new with delete and new[] with delete[]. Otherwise
 * bad things can happen, since these allocators may use different memory
 * pools (and new/delete call constructors and destructors). See also
 * g_mem_set_vtable().
 */
public class Memory
{
	
	/**
	 */
	
	/**
	 * Allocates n_bytes bytes of memory.
	 * If n_bytes is 0 it returns NULL.
	 * Params:
	 * nBytes = the number of bytes to allocate
	 * Returns:a pointer to the allocated memory
	 */
	public static void* malloc(uint nBytes);
	
	/**
	 * Allocates n_bytes bytes of memory, initialized to 0's.
	 * If n_bytes is 0 it returns NULL.
	 * Params:
	 * nBytes = the number of bytes to allocate
	 * Returns:a pointer to the allocated memory
	 */
	public static void* malloc0(uint nBytes);

	/**
	 * Reallocates the memory pointed to by mem, so that it now has space for
	 * n_bytes bytes of memory. It returns the new address of the memory, which may
	 * have been moved. mem may be NULL, in which case it's considered to
	 * have zero-length. n_bytes may be 0, in which case NULL will be returned
	 * and mem will be freed unless it is NULL.
	 * Params:
	 * mem = the memory to reallocate
	 * nBytes = new size of the memory in bytes
	 * Returns:the new address of the allocated memory
	 */
	public static void* realloc(void* mem, uint nBytes);
	
	/**
	 * Attempts to allocate n_bytes, and returns NULL on failure.
	 * Contrast with g_malloc(), which aborts the program on failure.
	 * Params:
	 * nBytes = number of bytes to allocate.
	 * Returns:the allocated memory, or NULL.
	 */
	public static void* tryMalloc(uint nBytes);
	
	/**
	 * Attempts to allocate n_bytes, initialized to 0's, and returns NULL on
	 * failure. Contrast with g_malloc0(), which aborts the program on failure.
	 * Since 2.8
	 * Params:
	 * nBytes = number of bytes to allocate
	 * Returns:the allocated memory, or NULL
	 */
	public static void* tryMalloc0(uint nBytes);
	
	/**
	 * Attempts to realloc mem to a new size, n_bytes, and returns NULL
	 * on failure. Contrast with g_realloc(), which aborts the program
	 * on failure. If mem is NULL, behaves the same as g_try_malloc().
	 * Params:
	 * mem = previously-allocated memory, or NULL.
	 * nBytes = number of bytes to allocate.
	 * Returns:the allocated memory, or NULL.
	 */
	public static void* tryRealloc(void* mem, uint nBytes);

	
	/**
	 * Frees the memory pointed to by mem.
	 * If mem is NULL it simply returns.
	 * Params:
	 * mem = the memory to free
	 */
	public static void free(void* mem);
	
	/**
	 * Allocates byte_size bytes of memory, and copies byte_size bytes into it
	 * from mem. If mem is NULL it returns NULL.
	 * Params:
	 * mem = the memory to copy.
	 * byteSize = the number of bytes to copy.
	 * Returns:a pointer to the newly-allocated copy of the memory, or NULL if memis NULL.
	 */
	public static void* memdup(void* mem, uint byteSize);
	
	/**
	 * Sets the GMemVTable to use for memory allocation. You can use this to provide
	 * custom memory allocation routines. This function must be called
	 * before using any other GLib functions. The vtable only needs to
	 * provide malloc(), realloc(), and free() functions; GLib can provide default
	 * implementations of the others. The malloc() and realloc() implementations
	 * should return NULL on failure, GLib will handle error-checking for you.
	 * vtable is copied, so need not persist after this function has been called.
	 * Params:
	 * vtable = table of memory allocation routines.
	 */
	public static void memSetVtable(GMemVTable* vtable);
	
	/**
	 * Checks whether the allocator used by g_malloc() is the system's
	 * malloc implementation. If it returns TRUE memory allocated with
	 * malloc() can be used interchangeable with memory allocated using g_malloc().
	 * This function is useful for avoiding an extra copy of allocated memory returned
	 * by a non-GLib-based API.
	 * A different allocator can be set using g_mem_set_vtable().
	 * Returns: if TRUE, malloc() and g_malloc() can be mixed.
	 */
	public static int memIsSystemMalloc();
	
	/**
	 * Outputs a summary of memory usage.
	 * It outputs the frequency of allocations of different sizes,
	 * the total number of bytes which have been allocated,
	 * the total number of bytes which have been freed,
	 * and the difference between the previous two values, i.e. the number of bytes
	 * still in use.
	 * Note that this function will not output anything unless you have
	 * previously installed the glib_mem_profiler_table with g_mem_set_vtable().
	 */
	public static void memProfile();
}
