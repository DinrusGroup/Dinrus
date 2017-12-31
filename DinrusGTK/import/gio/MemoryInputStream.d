
module gtkD.gio.MemoryInputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.SeekableT;
private import gtkD.gio.SeekableIF;



private import gtkD.gio.InputStream;

/**
 * Description
 * GMemoryInputStream is a class for using arbitrary
 * memory chunks as input for GIO streaming input operations.
 */
public class MemoryInputStream : InputStream, SeekableIF
{
	
	/** the main Gtk struct */
	protected GMemoryInputStream* gMemoryInputStream;
	
	
	public GMemoryInputStream* getMemoryInputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GMemoryInputStream* gMemoryInputStream);
	
	// add the Seekable capabilities
	mixin SeekableT!(GMemoryInputStream);
	
	/**
	 */
	
	/**
	 * Creates a new empty GMemoryInputStream.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GMemoryInputStream with data in memory of a given size.
	 * Params:
	 * data =  input data
	 * len =  length of the data, may be -1 if data is a nul-terminated string
	 * destroy =  function that is called to free data, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (void* data, int len, GDestroyNotify destroy);
	
	/**
	 * Appends data to data that can be read from the input stream
	 * Params:
	 * data =  input data
	 * len =  length of the data, may be -1 if data is a nul-terminated string
	 * destroy =  function that is called to free data, or NULL
	 */
	public void addData(void* data, int len, GDestroyNotify destroy);
}
