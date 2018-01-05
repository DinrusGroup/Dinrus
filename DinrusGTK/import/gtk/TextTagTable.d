module gtkD.gtk.TextTagTable;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.TextTag;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * You may wish to begin by reading the text widget
 * conceptual overview which gives an overview of all the objects and data
 * types related to the text widget and how they work together.
 */
public class TextTagTable : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkTextTagTable* gtkTextTagTable;
	
	
	public GtkTextTagTable* getTextTagTableStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTextTagTable* gtkTextTagTable);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(TextTag, TextTagTable)[] onTagAddedListeners;
	/**
	 */
	void addOnTagAdded(void delegate(TextTag, TextTagTable) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackTagAdded(GtkTextTagTable* texttagtableStruct, GtkTextTag* arg1, TextTagTable textTagTable);
	
	void delegate(TextTag, gboolean, TextTagTable)[] onTagChangedListeners;
	/**
	 */
	void addOnTagChanged(void delegate(TextTag, gboolean, TextTagTable) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackTagChanged(GtkTextTagTable* texttagtableStruct, GtkTextTag* arg1, gboolean arg2, TextTagTable textTagTable);
	
	void delegate(TextTag, TextTagTable)[] onTagRemovedListeners;
	/**
	 */
	void addOnTagRemoved(void delegate(TextTag, TextTagTable) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackTagRemoved(GtkTextTagTable* texttagtableStruct, GtkTextTag* arg1, TextTagTable textTagTable);
	
	
	/**
	 * Creates a new GtkTextTagTable. The table contains no tags by
	 * default.
	 * Returns: a new GtkTextTagTable
	 */
	public static TextTagTable tableNew();
	
	/**
	 * Add a tag to the table. The tag is assigned the highest priority
	 * in the table.
	 * tag must not be in a tag table already, and may not have
	 * the same name as an already-added tag.
	 * Params:
	 * table =  a GtkTextTagTable
	 * tag =  a GtkTextTag
	 */
	public void tableAdd(TextTag tag);
	
	/**
	 * Remove a tag from the table. This will remove the table's
	 * reference to the tag, so be careful - the tag will end
	 * up destroyed if you don't have a reference to it.
	 * Params:
	 * table =  a GtkTextTagTable
	 * tag =  a GtkTextTag
	 */
	public void tableRemove(TextTag tag);
	
	/**
	 * Look up a named tag.
	 * Params:
	 * table =  a GtkTextTagTable
	 * name =  name of a tag
	 * Returns: The tag, or NULL if none by that name is in the table.
	 */
	public TextTag tableLookup(string name);
	
	/**
	 * Calls func on each tag in table, with user data data.
	 * Note that the table may not be modified while iterating
	 * over it (you can't add/remove tags).
	 * Params:
	 * table =  a GtkTextTagTable
	 * func =  a function to call on each tag
	 * data =  user data
	 */
	public void tableForeach(GtkTextTagTableForeach func, void* data);
	
	/**
	 * Returns the size of the table (number of tags)
	 * Params:
	 * table =  a GtkTextTagTable
	 * Returns: number of tags in tableSignal DetailsThe "tag-added" signalvoid user_function (GtkTextTagTable *texttagtable, GtkTextTag *arg1, gpointer user_data) : Run Last
	 */
	public int tableGetSize();
}
