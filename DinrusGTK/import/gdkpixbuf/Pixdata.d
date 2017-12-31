module gtkD.gdkpixbuf.Pixdata;

public  import gtkD.gtkc.gdkpixbuftypes;

private import gtkD.gtkc.gdkpixbuf;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Pixbuf;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.StringG;
private import gtkD.glib.Str;




/**
 * Description
 * Using GdkPixdata, images can be compiled into an application,
 * making it unnecessary to refer to external image files at runtime.
 * gdk-pixbuf includes a utility named gdk-pixbuf-csource, which
 * can be used to convert image files into GdkPixdata structures suitable
 * for inclusion in C sources. To convert the GdkPixdata structures back
 * into GdkPixbufs, use gdk_pixbuf_from_pixdata.
 */
public class Pixdata
{
	
	/** the main Gtk struct */
	protected GdkPixdata* gdkPixdata;
	
	
	public GdkPixdata* getPixdataStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkPixdata* gdkPixdata);
	
	/**
	 */
	
	/**
	 * Converts a GdkPixbuf to a GdkPixdata. If use_rle is TRUE, the
	 * pixel data is run-length encoded into newly-allocated memory and a
	 * pointer to that memory is returned.
	 * Params:
	 * pixbuf =  the data to fill pixdata with.
	 * useRle =  whether to use run-length encoding for the pixel data.
	 * Returns: If ure_rle is TRUE, a pointer to the newly-allocated memory  for the run-length encoded pixel data, otherwise NULL.
	 */
	public void* fromPixbuf(Pixbuf pixbuf, int useRle);
	
	/**
	 * Converts a GdkPixdata to a GdkPixbuf. If copy_pixels is TRUE or
	 * if the pixel data is run-length-encoded, the pixel data is copied into
	 * newly-allocated memory; otherwise it is reused.
	 * Params:
	 * copyPixels =  whether to copy raw pixel data; run-length encoded
	 *  pixel data is always copied.
	 * Returns: a new GdkPixbuf.
	 * Throws: GException on failure.
	 */
	public Pixbuf gdkPixbufFromPixdata(int copyPixels);
	
	/**
	 * Serializes a GdkPixdata structure into a byte stream.
	 * The byte stream consists of a straightforward writeout of the
	 * GdkPixdata fields in network byte order, plus the pixel_data
	 * bytes the structure points to.
	 * Returns: A newly-allocated string containing the serializedGdkPixdata structure.
	 */
	public ubyte[] serialize();
	
	/**
	 * Deserializes (reconstruct) a GdkPixdata structure from a byte stream.
	 * The byte stream consists of a straightforward writeout of the
	 * GdkPixdata fields in network byte order, plus the pixel_data
	 * bytes the structure points to.
	 * The pixdata contents are reconstructed byte by byte and are checked
	 * for validity. This function may fail with GDK_PIXBUF_CORRUPT_IMAGE
	 * or GDK_PIXBUF_ERROR_UNKNOWN_TYPE.
	 * Params:
	 * stream =  stream of bytes containing a serialized GdkPixdata structure.
	 * Returns: Upon successful deserialization TRUE is returned,FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int deserialize(ubyte[] stream);
	
	/**
	 * Generates C source code suitable for compiling images directly
	 * into programs.
	 * GTK+ ships with a program called gdk-pixbuf-csource
	 * which offers a command line interface to this function.
	 * Params:
	 * name =  used for naming generated data structures or macros.
	 * dumpType =  a GdkPixdataDumpType determining the kind of C
	 *  source to be generated.
	 * Returns: a newly-allocated string containing the C source form of pixdata.
	 */
	public StringG toCsource(string name, GdkPixdataDumpType dumpType);
}
