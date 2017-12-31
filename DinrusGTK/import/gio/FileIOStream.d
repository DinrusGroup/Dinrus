module gtkD.gio.FileIOStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.FileInfo;
private import gtkD.gio.SeekableT;
private import gtkD.gio.SeekableIF;



private import gtkD.gio.IOStream;

/**
 * Description
 * GFileIOStream provides io streams that both read and write to the same
 * file handle.
 * GFileIOStream implements GSeekable, which allows the io
 * stream to jump to arbitrary positions in the file and to truncate
 * the file, provided the filesystem of the file supports these
 * operations.
 * To find the position of a file io stream, use
 * g_seekable_tell().
 * To find out if a file io stream supports seeking, use g_seekable_can_seek().
 * To position a file io stream, use g_seekable_seek().
 * To find out if a file io stream supports truncating, use
 * g_seekable_can_truncate(). To truncate a file io
 * stream, use g_seekable_truncate().
 * The default implementation of all the GFileIOStream operations
 * and the implementation of GSeekable just call into the same operations
 * on the output stream.
 */
public class FileIOStream : IOStream, SeekableIF
{
	
	/** the main Gtk struct */
	protected GFileIOStream* gFileIOStream;
	
	
	public GFileIOStream* getFileIOStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFileIOStream* gFileIOStream);
	
	// add the Seekable capabilities
	mixin SeekableT!(GFileIOStream);
	
	/**
	 */
	
	/**
	 * Gets the entity tag for the file when it has been written.
	 * This must be called after the stream has been written
	 * and closed, as the etag can change while writing.
	 * Since 2.22
	 * Returns: the entity tag for the stream.
	 */
	public string getEtag();
	
	/**
	 * Queries a file io stream for the given attributes.
	 * This function blocks while querying the stream. For the asynchronous
	 * version of this function, see g_file_io_stream_query_info_async().
	 * While the stream is blocked, the stream will set the pending flag
	 * internally, and any other operations on the stream will fail with
	 * G_IO_ERROR_PENDING.
	 * Can fail if the stream was already closed (with error being set to
	 * G_IO_ERROR_CLOSED), the stream has pending operations (with error being
	 * set to G_IO_ERROR_PENDING), or if querying info is not supported for
	 * the stream's interface (with error being set to G_IO_ERROR_NOT_SUPPORTED). I
	 * all cases of failure, NULL will be returned.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be set, and NULL will
	 * be returned.
	 * Since 2.22
	 * Params:
	 * attributes =  a file attribute query string.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileInfo for the stream, or NULL on error.
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfo(string attributes, Cancellable cancellable);
	
	/**
	 * Asynchronously queries the stream for a GFileInfo. When completed,
	 * callback will be called with a GAsyncResult which can be used to
	 * finish the operation with g_file_io_stream_query_info_finish().
	 * For the synchronous version of this function, see
	 * g_file_io_stream_query_info().
	 * Since 2.22
	 * Params:
	 * attributes =  a file attribute query string.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void queryInfoAsync(string attributes, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finalizes the asynchronous query started
	 * by g_file_io_stream_query_info_async().
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: A GFileInfo for the finished query.
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfoFinish(AsyncResultIF result);
}
