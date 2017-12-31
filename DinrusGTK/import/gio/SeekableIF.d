
module gtkD.gio.SeekableIF;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.Cancellable;




/**
 * Description
 * GSeekable is implemented by streams (implementations of
 * GInputStream or GOutputStream) that support seeking.
 */
public interface SeekableIF
{
	
	
	public GSeekable* getSeekableTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	/**
	 * Tells the current position within the stream.
	 * Returns: the offset from the beginning of the buffer.
	 */
	public long tell();
	
	/**
	 * Tests if the stream supports the GSeekableIface.
	 * Returns: TRUE if seekable can be seeked. FALSE otherwise.
	 */
	public int canSeek();
	
	/**
	 * Seeks in the stream by the given offset, modified by type.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * offset =  a goffset.
	 * type =  a GSeekType.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if successful. If an error has occurred, this function will return FALSE and set error appropriately if present.
	 * Throws: GException on failure.
	 */
	public int seek(long offset, GSeekType type, Cancellable cancellable);
	
	/**
	 * Tests if the stream can be truncated.
	 * Returns: TRUE if the stream can be truncated, FALSE otherwise.
	 */
	public int canTruncate();
	
	/**
	 * Truncates a stream with a given offset.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned. If an
	 * operation was partially finished when the operation was cancelled the
	 * partial result will be returned, without an error.
	 * Params:
	 * offset =  a goffset.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if successful. If an error has occurred, this function will return FALSE and set error appropriately if present.
	 * Throws: GException on failure.
	 */
	public int truncate(long offset, Cancellable cancellable);
}
