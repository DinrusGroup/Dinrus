module gtkD.gtk.Border;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;





/**
 * Description
 */
public class Border
{

	/** the main Gtk struct */
	protected GtkBorder* gtkBorder;


	public GtkBorder* getBorderStruct();


	/** the main Gtk struct as a void* */
	protected void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkBorder* gtkBorder);

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(Border)[] onRealizeListeners;
	/**
	 * Emitted when the style has been initialized for a particular
	 * colormap and depth. Connecting to this signal is probably seldom
	 * useful since most of the time applications and widgets only
	 * deal with styles that have been already realized.
	 * Since 2.4
	 */
	void addOnRealize(void delegate(Border) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackRealize(GtkStyle* styleStruct, Border border);


	void delegate(Border)[] onUnrealizeListeners;
	/**
	 * Emitted when the aspects of the style specific to a particular colormap
	 * and depth are being cleaned up. A connection to this signal can be useful
	 * if a widget wants to cache objects like a GdkGC as object data on GtkStyle.
	 * This signal provides a convenient place to free such cached objects.
	 * Since 2.4
	 */
	void addOnUnrealize(void delegate(Border) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackUnrealize(GtkStyle* styleStruct, Border border);


	/**
	 * Allocates a new GtkBorder structure and initializes its elements to zero.
	 * Since 2.14
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();

	/**
	 * Copies a GtkBorder structure.
	 * Returns: a copy of border_.
	 */
	public Border copy();

	/**
	 * Frees a GtkBorder structure.
	 */
	public void free();
}
