module gtkD.gio.FilterInputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.InputStream;



private import gtkD.gio.InputStream;

/**
 * Description
 */
public class FilterInputStream : InputStream
{
	
	/** the main Gtk struct */
	protected GFilterInputStream* gFilterInputStream;
	
	
	public GFilterInputStream* getFilterInputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFilterInputStream* gFilterInputStream);
	
	/**
	 */
	
	/**
	 * Gets the base stream for the filter stream.
	 * Returns: a GInputStream.
	 */
	public InputStream getBaseStream();
	
	/**
	 * Returns whether the base stream will be closed when stream is
	 * closed.
	 * Returns: TRUE if the base stream will be closed.
	 */
	public int getCloseBaseStream();
	
	/**
	 * Sets whether the base stream will be closed when stream is closed.
	 * Params:
	 * closeBase =  TRUE to close the base stream.
	 */
	public void setCloseBaseStream(int closeBase);
}
