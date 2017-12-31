
module gtkD.gio.DataOutputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.Cancellable;
private import gtkD.gio.OutputStream;



private import gtkD.gio.FilterOutputStream;

/**
 * Description
 * Data output stream implements GOutputStream and includes functions for
 * writing data directly to an output stream.
 */
public class DataOutputStream : FilterOutputStream
{
	
	/** the main Gtk struct */
	protected GDataOutputStream* gDataOutputStream;
	
	
	public GDataOutputStream* getDataOutputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GDataOutputStream* gDataOutputStream);
	
	/**
	 */
	
	/**
	 * Creates a new data output stream for base_stream.
	 * Params:
	 * baseStream =  a GOutputStream.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (OutputStream baseStream);
	
	/**
	 * Sets the byte order of the data output stream to order.
	 * Params:
	 * order =  a GDataStreamByteOrder.
	 */
	public void setByteOrder(GDataStreamByteOrder order);
	
	/**
	 * Gets the byte order for the stream.
	 * Returns: the GDataStreamByteOrder for the stream.
	 */
	public GDataStreamByteOrder getByteOrder();
	
	/**
	 * Puts a byte into the output stream.
	 * Params:
	 * data =  a guchar.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putByte(char data, Cancellable cancellable);
	
	/**
	 * Puts a signed 16-bit integer into the output stream.
	 * Params:
	 * data =  a gint16.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putInt16(short data, Cancellable cancellable);
	
	/**
	 * Puts an unsigned 16-bit integer into the output stream.
	 * Params:
	 * data =  a guint16.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putUint16(ushort data, Cancellable cancellable);
	
	/**
	 * Puts a signed 32-bit integer into the output stream.
	 * Params:
	 * data =  a gint32.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putInt32(int data, Cancellable cancellable);
	
	/**
	 * Puts an unsigned 32-bit integer into the stream.
	 * Params:
	 * data =  a guint32.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putUint32(uint data, Cancellable cancellable);
	
	/**
	 * Puts a signed 64-bit integer into the stream.
	 * Params:
	 * data =  a gint64.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putInt64(long data, Cancellable cancellable);
	
	/**
	 * Puts an unsigned 64-bit integer into the stream.
	 * Params:
	 * data =  a guint64.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if data was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putUint64(ulong data, Cancellable cancellable);
	
	/**
	 * Puts a string into the output stream.
	 * Params:
	 * str =  a string.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if string was successfully added to the stream.
	 * Throws: GException on failure.
	 */
	public int putString(string str, Cancellable cancellable);
}
