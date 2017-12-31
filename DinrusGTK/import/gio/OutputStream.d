module gtkD.gio.OutputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.InputStream;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GOutputStream has functions to write to a stream (g_output_stream_write()),
 * to close a stream (g_output_stream_close()) and to flush pending writes
 * (g_output_stream_flush()).
 * To copy the content of an input stream to an output stream without
 * manually handling the reads and writes, use g_output_stream_splice().
 * All of these functions have async variants too.
 */
public class OutputStream : ObjectG
{
	
	/** the main Gtk struct */
	protected GOutputStream* gOutputStream;
	
	
	public GOutputStream* getOutputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GOutputStream* gOutputStream);
	
	/**
	 */
	
	/**
	 * Tries to write count bytes from buffer into the stream. Will block
	 * during the operation.
	 * If count is zero returns zero and does nothing. A value of count
	 * larger than G_MAXSSIZE will cause a G_IO_ERROR_INVALID_ARGUMENT error.
	 * On success, the number of bytes written to the stream is returned.
	 * It is not an error if this is not the same as the requested size, as it
	 * can happen e.g. on a partial i/o error, or if there is not enough
	 * storage in the stream. All writes either block until at least one byte
	 * is written, so zero is never returned (unless count is zero).
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned. If an
	 * operation was partially finished when the operation was cancelled the
	 * partial result will be returned, without an error.
	 * On error -1 is returned and error is set accordingly.
	 * Params:
	 * buffer =  the buffer containing the data to write.
	 * count =  the number of bytes to write
	 * cancellable =  optional cancellable object
	 * Returns: Number of bytes written, or -1 on error
	 * Throws: GException on failure.
	 */
	public int write(void* buffer, uint count, Cancellable cancellable);
	
	/**
	 * Tries to write count bytes from buffer into the stream. Will block
	 * during the operation.
	 * This function is similar to g_output_stream_write(), except it tries to
	 * write as many bytes as requested, only stopping on an error.
	 * On a successful write of count bytes, TRUE is returned, and bytes_written
	 * is set to count.
	 * If there is an error during the operation FALSE is returned and error
	 * is set to indicate the error status, bytes_written is updated to contain
	 * the number of bytes written into the stream before the error occurred.
	 * Params:
	 * buffer =  the buffer containing the data to write.
	 * count =  the number of bytes to write
	 * bytesWritten =  location to store the number of bytes that was
	 *  written to the stream
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE on success, FALSE if there was an error
	 * Throws: GException on failure.
	 */
	public int writeAll(void* buffer, uint count, uint* bytesWritten, Cancellable cancellable);
	
	/**
	 * Splices an input stream into an output stream.
	 * Params:
	 * source =  a GInputStream.
	 * flags =  a set of GOutputStreamSpliceFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a gssize containing the size of the data spliced, or -1 if an error occurred.
	 * Throws: GException on failure.
	 */
	public int splice(InputStream source, GOutputStreamSpliceFlags flags, Cancellable cancellable);
	
	/**
	 * Flushed any outstanding buffers in the stream. Will block during
	 * the operation. Closing the stream will implicitly cause a flush.
	 * This function is optional for inherited classes.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional cancellable object
	 * Returns: TRUE on success, FALSE on error
	 * Throws: GException on failure.
	 */
	public int flush(Cancellable cancellable);
	
	/**
	 * Closes the stream, releasing resources related to it.
	 * Once the stream is closed, all other operations will return G_IO_ERROR_CLOSED.
	 * Closing a stream multiple times will not return an error.
	 * Closing a stream will automatically flush any outstanding buffers in the
	 * stream.
	 * Streams will be automatically closed when the last reference
	 * is dropped, but you might want to call this function to make sure
	 * resources are released as early as possible.
	 * Some streams might keep the backing store of the stream (e.g. a file descriptor)
	 * open after the stream is closed. See the documentation for the individual
	 * stream for details.
	 * On failure the first error that happened will be reported, but the close
	 * operation will finish as much as possible. A stream that failed to
	 * close will still return G_IO_ERROR_CLOSED for all operations. Still, it
	 * is important to check and report the error to the user, otherwise
	 * there might be a loss of data as all data might not be written.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Cancelling a close will still leave the stream closed, but there some streams
	 * can use a faster close that doesn't block to e.g. check errors. On
	 * cancellation (as with any error) there is no guarantee that all written
	 * data will reach the target.
	 * Params:
	 * cancellable =  optional cancellable object
	 * Returns: TRUE on success, FALSE on failure
	 * Throws: GException on failure.
	 */
	public int close(Cancellable cancellable);
	
	/**
	 * Request an asynchronous write of count bytes from buffer into
	 * the stream. When the operation is finished callback will be called.
	 * You can then call g_output_stream_write_finish() to get the result of the
	 * operation.
	 * During an async request no other sync and async calls are allowed,
	 * and will result in G_IO_ERROR_PENDING errors.
	 * A value of count larger than G_MAXSSIZE will cause a
	 * G_IO_ERROR_INVALID_ARGUMENT error.
	 * On success, the number of bytes written will be passed to the
	 * callback. It is not an error if this is not the same as the
	 * requested size, as it can happen e.g. on a partial I/O error,
	 * but generally we try to write as many bytes as requested.
	 * Any outstanding I/O request with higher priority (lower numerical
	 * value) will be executed before an outstanding request with lower
	 * priority. Default priority is G_PRIORITY_DEFAULT.
	 * The asyncronous methods have a default fallback that uses threads
	 * to implement asynchronicity, so they are optional for inheriting
	 * classes. However, if you override one you must override all.
	 * For the synchronous, blocking version of this function, see
	 * g_output_stream_write().
	 * Params:
	 * buffer =  the buffer containing the data to write.
	 * count =  the number of bytes to write
	 * ioPriority =  the io priority of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void writeAsync(void* buffer, uint count, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes a stream write operation.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a gssize containing the number of bytes written to the stream.
	 * Throws: GException on failure.
	 */
	public int writeFinish(AsyncResultIF result);
	
	/**
	 * Splices a stream asynchronously.
	 * When the operation is finished callback will be called.
	 * You can then call g_output_stream_splice_finish() to get the
	 * result of the operation.
	 * For the synchronous, blocking version of this function, see
	 * g_output_stream_splice().
	 * Params:
	 * source =  a GInputStream.
	 * flags =  a set of GOutputStreamSpliceFlags.
	 * ioPriority =  the io priority of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback.
	 * userData =  user data passed to callback.
	 */
	public void spliceAsync(InputStream source, GOutputStreamSpliceFlags flags, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous stream splice operation.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a gssize of the number of bytes spliced.
	 * Throws: GException on failure.
	 */
	public int spliceFinish(AsyncResultIF result);
	
	/**
	 * Flushes a stream asynchronously.
	 * For behaviour details see g_output_stream_flush().
	 * When the operation is finished callback will be
	 * called. You can then call g_output_stream_flush_finish() to get the
	 * result of the operation.
	 * Params:
	 * ioPriority =  the io priority of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void flushAsync(int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes flushing an output stream.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if flush operation suceeded, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int flushFinish(AsyncResultIF result);
	
	/**
	 * Requests an asynchronous close of the stream, releasing resources
	 * related to it. When the operation is finished callback will be
	 * called. You can then call g_output_stream_close_finish() to get
	 * the result of the operation.
	 * For behaviour details see g_output_stream_close().
	 * The asyncronous methods have a default fallback that uses threads
	 * to implement asynchronicity, so they are optional for inheriting
	 * classes. However, if you override one you must override all.
	 * Params:
	 * ioPriority =  the io priority of the request.
	 * cancellable =  optional cancellable object
	 * callback =  callback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void closeAsync(int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Closes an output stream.
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if stream was successfully closed, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int closeFinish(AsyncResultIF result);
	
	/**
	 * Checks if an output stream has already been closed.
	 * Returns: TRUE if stream is closed. FALSE otherwise.
	 */
	public int isClosed();
	
	/**
	 * Checks if an ouput stream has pending actions.
	 * Returns: TRUE if stream has pending actions.
	 */
	public int hasPending();
	
	/**
	 * Sets stream to have actions pending. If the pending flag is
	 * already set or stream is closed, it will return FALSE and set
	 * error.
	 * Returns: TRUE if pending was previously unset and is now set.
	 * Throws: GException on failure.
	 */
	public int setPending();
	
	/**
	 * Clears the pending flag on stream.
	 */
	public void clearPending();
}
