module gtkD.glib.Allocator;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * Prior to 2.10, GAllocator was used as an efficient way to allocate
 * small pieces of memory for use with the GList, GSList and GNode data
 * structures. Since 2.10, it has been completely replaced by the
 * slice allocator and deprecated.
 */
public class Allocator
{
	
	/** the main Gtk struct */
	protected GAllocator* gAllocator;
	
	
	public GAllocator* getAllocatorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GAllocator* gAllocator);
	
	/**
	 */
	
	/**
	 * Warning
	 * g_allocator_new has been deprecated since version 2.10 and should not be used in newly-written code. Use the slice allocator
	 * instead
	 * Creates a new GAllocator.
	 * Params:
	 * name = the name of the GAllocator. This name is used to set the name of the
	 * GMemChunk used by the GAllocator, and is only used for debugging.
	 * nPreallocs = the number of elements in each block of memory allocated.
	 * Larger blocks mean less calls to g_malloc(), but some memory may be wasted.
	 * (GLib uses 128 elements per block by default.) The value must be between 1
	 * and 65535.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, uint nPreallocs);
	
	/**
	 * Warning
	 * g_allocator_free has been deprecated since version 2.10 and should not be used in newly-written code. Use the slice allocator
	 * instead
	 * Frees all of the memory allocated by the GAllocator.
	 */
	public void free();
}
