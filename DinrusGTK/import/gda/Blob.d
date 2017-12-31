module gtkD.gda.Blob;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


/**
 * Description
 */
public class Blob
{
	
	/** the main Gtk struct */
	protected GdaBlob* gdaBlob;
	
	
	public GdaBlob* getBlobStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaBlob* gdaBlob);
	
	/**
	 */
	
	/**
	 * Opens an existing BLOB. The BLOB must be initialized by
	 * gda_connection_create_blob or obtained from a GdaValue.
	 * Params:
	 * mode =  see GdaBlobMode.
	 * Returns: 0 if everything's ok. In case of error, -1 is returned and theprovider should have added an error to the connection.
	 */
	public int open(GdaBlobMode mode);
	
	/**
	 * Reads a chunk of bytes from the BLOB into a user-provided location.
	 * Params:
	 * buf =  buffer to read the data into.
	 * size =  maximum number of bytes to read.
	 * bytesRead =  on return it will point to the number of bytes actually read.
	 * Returns: 0 if everything's ok. In case of error, -1 is returned and theprovider should have added an error to the connection.
	 */
	public int read(void* buf, int size, out int bytesRead);
	
	/**
	 * Writes a chunk of bytes from a user-provided location to the BLOB.
	 * Params:
	 * buf =  buffer to write the data from.
	 * size =  maximum number of bytes to read.
	 * bytesWritten =  on return it will point to the number of bytes actually written.
	 * Returns: 0 if everything's ok. In case of error, -1 is returned and theprovider should have added an error to the connection.
	 */
	public int write(void* buf, int size, out int bytesWritten);
	
	/**
	 * Sets the blob read/write position.
	 * Params:
	 * offset =  offset added to the position specified by whence.
	 * whence =  SEEK_SET, SEEK_CUR or SEEK_END with the same meaning as in fseek(3).
	 * Returns: the current position in the blob or < 0 in case of error. In caseof error the provider should have added an error to the connection.
	 */
	public int lseek(int offset, int whence);
	
	/**
	 * Closes the BLOB. After calling this function, blob should no longer be used.
	 * Returns: 0 if everything's ok. In case of error, -1 is returned and theprovider should have added an error to the connection.
	 */
	public int close();
	
	/**
	 * Removes the BLOB from the database. After calling this function, blob
	 * should no longer be used.
	 * Returns: 0 if everything's ok. In case of error, -1 is returned and theprovider should have added an error to the connection.
	 */
	public int remove();
	
	/**
	 * Let the provider free any internal data stored in blob. The user
	 * is still responsible for deallocating blob itself.
	 */
	public void freeData();
}
