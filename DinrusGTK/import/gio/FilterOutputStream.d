
module gtkD.gio.FilterOutputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.OutputStream;



private import gtkD.gio.OutputStream;

/**
 * Description
 */
public class FilterOutputStream : OutputStream
{
	
	/** the main Gtk struct */
	protected GFilterOutputStream* gFilterOutputStream;
	
	
	public GFilterOutputStream* getFilterOutputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFilterOutputStream* gFilterOutputStream);
	
	/**
	 */
	
	/**
	 * Gets the base stream for the filter stream.
	 * Returns: a GOutputStream.
	 */
	public OutputStream getBaseStream();
	
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
