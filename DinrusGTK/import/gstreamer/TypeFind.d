module gtkD.gstreamer.TypeFind;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Caps;
private import gtkD.gstreamer.Plugin;




/**
 * Description
 * The following functions allow you to detect the media type of an unknown
 * stream.
 * Last reviewed on 2005-11-09 (0.9.4)
 */
public class TypeFind
{
	
	/** the main Gtk struct */
	protected GstTypeFind* gstTypeFind;
	
	
	public GstTypeFind* getTypeFindStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstTypeFind* gstTypeFind);
	
	/**
	 */
	
	/**
	 * Returns the size bytes of the stream to identify beginning at offset. If
	 * offset is a positive number, the offset is relative to the beginning of the
	 * stream, if offset is a negative number the offset is relative to the end of
	 * the stream. The returned memory is valid until the typefinding function
	 * returns and must not be freed.
	 * Params:
	 * offset =  The offset
	 * size =  The number of bytes to return
	 * Returns: the requested data, or NULL if that data is not available.
	 */
	public ubyte* peek(long offset, uint size);
	
	/**
	 * If a GstTypeFindFunction calls this function it suggests the caps with the
	 * given probability. A GstTypeFindFunction may supply different suggestions
	 * in one call.
	 * It is up to the caller of the GstTypeFindFunction to interpret these values.
	 * Params:
	 * probability =  The probability in percent that the suggestion is right
	 * caps =  The fixed GstCaps to suggest
	 */
	public void suggest(uint probability, Caps caps);
	
	/**
	 * Get the length of the data stream.
	 * Returns: The length of the data stream, or 0 if it is not available.
	 */
	public ulong getLength();
	
	/**
	 * Registers a new typefind function to be used for typefinding. After
	 * registering this function will be available for typefinding.
	 * This function is typically called during an element's plugin initialization.
	 * Params:
	 * plugin =  A GstPlugin.
	 * name =  The name for registering
	 * rank =  The rank (or importance) of this typefind function
	 * func =  The GstTypeFindFunction to use
	 * extensions =  Optional extensions that could belong to this type
	 * possibleCaps =  Optionally the caps that could be returned when typefinding
	 *  succeeds
	 * data =  Optional user data. This user data must be available until the plugin
	 *  is unloaded.
	 * dataNotify =  a GDestroyNotify that will be called on data when the plugin
	 *  is unloaded.
	 * Returns: TRUE on success, FALSE otherwise
	 */
	public static int register(Plugin plugin, string name, uint rank, GstTypeFindFunction func, char** extensions, Caps possibleCaps, void* data, GDestroyNotify dataNotify);
}
