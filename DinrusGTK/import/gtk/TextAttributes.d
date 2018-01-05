module gtkD.gtk.TextAttributes;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.TextAttributes;




/**
 * Description
 * You may wish to begin by reading the text widget
 * conceptual overview which gives an overview of all the objects and data
 * types related to the text widget and how they work together.
 * Tags should be in the GtkTextTagTable for a given GtkTextBuffer
 * before using them with that buffer.
 * gtk_text_buffer_create_tag() is the best way to create tags.
 * See gtk-demo for numerous examples.
 * The "invisible" property was not implemented for GTK+ 2.0; it's
 * planned to be implemented in future releases.
 */
public class TextAttributes
{
	
	/** the main Gtk struct */
	protected GtkTextAttributes* gtkTextAttributes;
	
	
	public GtkTextAttributes* getTextAttributesStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTextAttributes* gtkTextAttributes);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	bool delegate(GObject*, GdkEvent*, GtkTextIter*, TextAttributes)[] onListeners;
	/**
	 * The ::event signal is emitted when an event occurs on a region of the
	 * buffer marked with this tag.
	 */
	void addOn(bool delegate(GObject*, GdkEvent*, GtkTextIter*, TextAttributes) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBack(GtkTextTag* tagStruct, GObject* object, GdkEvent* event, GtkTextIter* iter, TextAttributes textAttributes);
	
	
	/**
	 * Creates a GtkTextAttributes, which describes
	 * a set of properties on some text.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Copies src and returns a new GtkTextAttributes.
	 * Returns: a copy of src
	 */
	public TextAttributes copy();
	
	/**
	 * Copies the values from src to dest so that dest has the same values
	 * as src. Frees existing values in dest.
	 * Params:
	 * dest =  another GtkTextAttributes
	 */
	public void copyValues(TextAttributes dest);
	
	/**
	 * Decrements the reference count on values, freeing the structure
	 * if the reference count reaches 0.
	 */
	public void unref();
	
	/**
	 * Increments the reference count on values.
	 * Returns: the GtkTextAttributes that were passed in
	 */
	public TextAttributes doref();
}
