module gtkD.gio.BufferedOutputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.OutputStream;



private import gtkD.gio.FilterOutputStream;

/**
 * Description
 * Buffered output stream implements GFilterOutputStream and provides
 * for buffered writes.
 * By default, GBufferedOutputStream's buffer size is set at 4 kilobytes.
 * To create a buffered output stream, use g_buffered_output_stream_new(),
 * or g_buffered_output_stream_new_sized() to specify the buffer's size
 * at construction.
 * To get the size of a buffer within a buffered input stream, use
 * g_buffered_output_stream_get_buffer_size(). To change the size of a
 * buffered output stream's buffer, use
 * g_buffered_output_stream_set_buffer_size(). Note that the buffer's
 * size cannot be reduced below the size of the data within the buffer.
 */
public class BufferedOutputStream : FilterOutputStream
{
	
	/** the main Gtk struct */
	protected GBufferedOutputStream* gBufferedOutputStream;
	
	
	public GBufferedOutputStream* getBufferedOutputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GBufferedOutputStream* gBufferedOutputStream);
	
	/**
	 */
	
	/**
	 * Creates a new buffered output stream for a base stream.
	 * Params:
	 * baseStream =  a GOutputStream.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (OutputStream baseStream);
	
	/**
	 * Creates a new buffered output stream with a given buffer size.
	 * Params:
	 * baseStream =  a GOutputStream.
	 * size =  a gsize.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (OutputStream baseStream, uint size);
	
	/**
	 * Gets the size of the buffer in the stream.
	 * Returns: the current size of the buffer.
	 */
	public uint getBufferSize();
	
	/**
	 * Sets the size of the internal buffer to size.
	 * Params:
	 * size =  a gsize.
	 */
	public void setBufferSize(uint size);

	/**
	 * Checks if the buffer automatically grows as data is added.
	 * Returns: TRUE if the stream's buffer automatically grows,FALSE otherwise.
	 */
	public int getAutoGrow();
	
	/**
	 * Sets whether or not the stream's buffer should automatically grow.
	 * If auto_grow is true, then each write will just make the buffer
	 * larger, and you must manually flush the buffer to actually write out
	 * the data to the underlying stream.
	 * Params:
	 * autoGrow =  a gboolean.
	 */
	public void setAutoGrow(int autoGrow);
}
