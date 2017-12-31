module gtkD.gio.FileInputStream;

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



private import gtkD.gio.InputStream;

/**
 * Description
 * GFileInputStream provides input streams that take their
 * content from a file.
 * GFileInputStream implements GSeekable, which allows the input
 * stream to jump to arbitrary positions in the file, provided the
 * filesystem of the file allows it. To find the position of a file
 * input stream, use g_seekable_tell(). To find out if a file input
 * stream supports seeking, use g_seekable_stream_can_seek().
 * To position a file input stream, use g_seekable_seek().
 */
public class FileInputStream : InputStream, SeekableIF
{
	
	/** the main Gtk struct */
	protected GFileInputStream* gFileInputStream;
	
	
	public GFileInputStream* getFileInputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFileInputStream* gFileInputStream);
	
	// add the Seekable capabilities
	mixin SeekableT!(GFileInputStream);
	
	/**
	 */
	
	/**
	 * Queries a file input stream the given attributes. This function blocks
	 * while querying the stream. For the asynchronous (non-blocking) version
	 * of this function, see g_file_input_stream_query_info_async(). While the
	 * stream is blocked, the stream will set the pending flag internally, and
	 * any other operations on the stream will fail with G_IO_ERROR_PENDING.
	 * Params:
	 * attributes =  a file attribute query string.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileInfo, or NULL on error.
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfo(string attributes, Cancellable cancellable);
	
	/**
	 * Queries the stream information asynchronously.
	 * When the operation is finished callback will be called.
	 * You can then call g_file_input_stream_query_info_finish()
	 * to get the result of the operation.
	 * For the synchronous version of this function,
	 * see g_file_input_stream_query_info().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be set
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
	 * Finishes an asynchronous info query operation.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: GFileInfo.
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfoFinish(AsyncResultIF result);
}
