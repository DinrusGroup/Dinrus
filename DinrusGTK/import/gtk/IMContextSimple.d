module gtkD.gtk.IMContextSimple;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.IMContext;



private import gtkD.gtk.IMContext;

/**
 * Description
 */
public class IMContextSimple : IMContext
{
	
	/** the main Gtk struct */
	protected GtkIMContextSimple* gtkIMContextSimple;
	
	
	public GtkIMContextSimple* getIMContextSimpleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkIMContextSimple* gtkIMContextSimple);
	
	/**
	 */
	
	/**
	 * Creates a new GtkIMContextSimple.
	 * Returns: a new GtkIMContextSimple.
	 */
	public static IMContext newIMContextSimple();
	
	/**
	 * Adds an additional table to search to the input context.
	 * Each row of the table consists of max_seq_len key symbols
	 * followed by two guint16 interpreted as the high and low
	 * words of a gunicode value. Tables are searched starting
	 * from the last added.
	 * The table must be sorted in dictionary order on the
	 * numeric value of the key symbol fields. (Values beyond
	 * the length of the sequence should be zero.)
	 * Params:
	 * data =  the table
	 * maxSeqLen =  Maximum length of a sequence in the table
	 *  (cannot be greater than GTK_MAX_COMPOSE_LEN)
	 */
	public void addTable(ushort[] data, int maxSeqLen);
}
