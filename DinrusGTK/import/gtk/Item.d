module gtkD.gtk.Item;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;




private import gtkD.gtk.Bin;

/**
 * Description
 * The GtkItem widget is an abstract base class for GtkMenuItem, GtkListItem
 * and GtkTreeItem.
 */
public class Item : Bin
{
	
	/** the main Gtk struct */
	protected GtkItem* gtkItem;
	
	
	public GtkItem* getItemStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkItem* gtkItem);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Item)[] onDeselectListeners;
	/**
	 * Emitted when the item is deselected.
	 */
	void addOnDeselect(void delegate(Item) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDeselect(GtkItem* itemStruct, Item item);
	
	void delegate(Item)[] onSelectListeners;
	/**
	 * Emitted when the item is selected.
	 */
	void addOnSelect(void delegate(Item) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelect(GtkItem* itemStruct, Item item);
	
	void delegate(Item)[] onToggleListeners;
	/**
	 * Emitted when the item is toggled.
	 */
	void addOnToggle(void delegate(Item) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggle(GtkItem* itemStruct, Item item);
	
	
	/**
	 * Emits the "select" signal on the given item.
	 */
	public void select();
	
	/**
	 * Emits the "deselect" signal on the given item.
	 */
	public void deselect();
	
	/**
	 * Emits the "toggle" signal on the given item.
	 */
	public void toggle();
}
