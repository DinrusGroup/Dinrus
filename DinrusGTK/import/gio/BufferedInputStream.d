
module gtkD.gio.BufferedInputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.InputStream;



private import gtkD.gio.FilterInputStream;

/**
 * Description
 * Buffered input stream implements GFilterInputStream and provides
 * for buffered reads.
 * By default, GBufferedInputStream's buffer size is set at 4 kilobytes.
 * To create a buffered input stream, use g_buffered_input_stream_new(),
 * or g_buffered_input_stream_new_sized() to specify the buffer's size at
 * construction.
 * To get the size of a buffer within a buffered input stream, use
 * g_buffered_input_stream_get_buffer_size(). To change the size of a
 * buffered input stream's buffer, use
 * g_buffered_input_stream_set_buffer_size(). Note that the buffer's size
 * cannot be reduced below the size of the data within the buffer.
 */
public class BufferedInputStream : FilterInputStream
{
	
	/** the main Gtk struct */
	protected GBufferedInputStream* gBufferedInputStream;
	
	
	public GBufferedInputStream* getBufferedInputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GBufferedInputStream* gBufferedInputStream);
	
	/**
	 */
	
	/**
	 * Creates a new GInputStream from the given base_stream, with
	 * a buffer set to the default size (4 kilobytes).
	 * Params:
	 * baseStream =  a GInputStream.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (InputStream baseStream);
	
	/**
	 * Creates a new GBufferedInputStream from the given base_stream,
	 * with a buffer set to size.
	 * Params:
	 * baseStream =  a GInputStream.
	 * size =  a gsize.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (InputStream baseStream, uint size);
	
	/**
	 * Gets the size of the input buffer.
	 * Returns: the current buffer size.
	 */
	public uint getBufferSize();
	
	/**
	 * Sets the size of the internal buffer of stream to size, or to the
	 * size of the contents of the buffer. The buffer can never be resized
	 * smaller than its current contents.
	 * Params:
	 * size =  a gsize.
	 */
	public void setBufferSize(uint size);
	
	/**
	 * Gets the size of the available data within the stream.
	 * Returns: size of the available stream.
	 */
	public uint getAvailable();
	
	/**
	 * Returns the buffer with the currently available bytes. The returned
	 * buffer must not be modified and will become invalid when reading from
	 * the stream or filling the buffer.
	 * Params:
	 * count =  a gsize to get the number of bytes available in the buffer.
	 * Returns: read-only buffer
	 */
	public void* peekBuffer(out uint count);
	
	/**
	 * Peeks in the buffer, copying data of size count into buffer,
	 * offset offset bytes.
	 * Params:
	 * buffer =  a pointer to an allocated chunk of memory.
	 * offset =  a gsize.
	 * count =  a gsize.
	 * Returns: a gsize of the number of bytes peeked, or -1 on error.
	 */
	public uint peek(void* buffer, uint offset, uint count);
	
	/**
	 * Tries to read count bytes from the stream into the buffer.
	 * Will block during this read.
	 * If count is zero, returns zero and does nothing. A value of count
	 * larger than G_MAXSSIZE will cause a G_IO_ERROR_INVALID_ARGUMENT error.
	 * On success, the number of bytes read into the buffer is returned.
	 * It is not an error if this is not the same as the requested size, as it
	 * can happen e.g. near the end of a file. Zero is returned on end of file
	 * (or if count is zero), but never otherwise.
	 * If count is -1 then the attempted read size is equal to the number of
	 * bytes that are required to fill the buffer.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned. If an
	 * operation was partially finished when the operation was cancelled the
	 * partial result will be returned, without an error.
	 * On error -1 is returned and error is set accordingly.
	 * For the asynchronous, non-blocking, version of this function, see
	 * g_buffered_input_stream_fill_async().
	 * Params:
	 * count =  the number of bytes that will be read from the stream.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: the number of bytes read into stream's buffer, up to count,  or -1 on error.
	 * Throws: GException on failure.
	 */
	public int fill(int count, Cancellable cancellable);
	
	/**
	 * Reads data into stream's buffer asynchronously, up to count size.
	 * io_priority can be used to prioritize reads. For the synchronous
	 * version of this function, see g_buffered_input_stream_fill().
	 * If count is -1 then the attempted read size is equal to the number
	 * of bytes that are required to fill the buffer.
	 * Params:
	 * count =  the number of bytes that will be read from the stream.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object
	 * callback =  a GAsyncReadyCallback.
	 * userData =  a gpointer.
	 */
	public void fillAsync(int count, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous read.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a gssize of the read stream, or -1 on an error.
	 * Throws: GException on failure.
	 */
	public int fillFinish(AsyncResultIF result);
	
	/**
	 * Tries to read a single byte from the stream or the buffer. Will block
	 * during this read.
	 * On success, the byte read from the stream is returned. On end of stream
	 * -1 is returned but it's not an exceptional error and error is not set.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned. If an
	 * operation was partially finished when the operation was cancelled the
	 * partial result will be returned, without an error.
	 * On error -1 is returned and error is set accordingly.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: the byte read from the stream, or -1 on end of stream or error.
	 * Throws: GException on failure.
	 */
	public int readByte(Cancellable cancellable);
}
