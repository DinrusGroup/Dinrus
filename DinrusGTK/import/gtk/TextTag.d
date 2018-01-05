module gtkD.gtk.TextTag;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gobject.ObjectG;
private import gtkD.gdk.Event;
private import gtkD.gtk.TextIter;



private import gtkD.gobject.ObjectG;

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
public class TextTag : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkTextTag* gtkTextTag;
	
	
	public GtkTextTag* getTextTagStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTextTag* gtkTextTag);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	bool delegate(ObjectG, Event, TextIter, TextTag)[] onListeners;
	/**
	 * The ::event signal is emitted when an event occurs on a region of the
	 * buffer marked with this tag.
	 */
	void addOn(bool delegate(ObjectG, Event, TextIter, TextTag) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBack(GtkTextTag* tagStruct, GObject* object, GdkEvent* event, GtkTextIter* iter, TextTag textTag);
	
	
	/**
	 * Creates a GtkTextTag. Configure the tag using object arguments,
	 * i.e. using g_object_set().
	 * Params:
	 * name =  tag name, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name);
	
	/**
	 * Get the tag priority.
	 * Returns: The tag's priority.
	 */
	public int getPriority();
	
	/**
	 * Sets the priority of a GtkTextTag. Valid priorities are
	 * start at 0 and go to one less than gtk_text_tag_table_get_size().
	 * Each tag in a table has a unique priority; setting the priority
	 * of one tag shifts the priorities of all the other tags in the
	 * table to maintain a unique priority for each tag. Higher priority
	 * tags "win" if two tags both set the same text attribute. When adding
	 * a tag to a tag table, it will be assigned the highest priority in
	 * the table by default; so normally the precedence of a set of tags
	 * is the order in which they were added to the table, or created with
	 * gtk_text_buffer_create_tag(), which adds the tag to the buffer's table
	 * automatically.
	 * Params:
	 * priority =  the new priority
	 */
	public void setPriority(int priority);
	
	/**
	 * Emits the "event" signal on the GtkTextTag.
	 * Params:
	 * eventObject =  object that received the event, such as a widget
	 * event =  the event
	 * iter =  location where the event was received
	 * Returns: result of signal emission (whether the event was handled)
	 */
	public int event(ObjectG eventObject, Event event, TextIter iter);
}
