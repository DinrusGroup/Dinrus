module gtkD.gtk.ComboBoxEntry;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.Adjustment;



private import gtkD.gtk.ComboBox;

/**
 * Description
 * A GtkComboBoxEntry is a widget that allows the user to choose from a
 * list of valid choices or enter a different value. It is very similar
 * to a GtkComboBox, but it displays the selected value in an entry to
 * allow modifying it.
 * In contrast to a GtkComboBox, the underlying model of a GtkComboBoxEntry
 * must always have a text column (see gtk_combo_box_entry_set_text_column()),
 * and the entry will show the content of the text column in the selected row.
 * To get the text from the entry, use gtk_combo_box_get_active_text().
 * The changed signal will be emitted while typing into a GtkComboBoxEntry,
 * as well as when selecting an item from the GtkComboBoxEntry's list. Use
 * gtk_combo_box_get_active() or gtk_combo_box_get_active_iter() to discover
 * whether an item was actually selected from the list.
 * Connect to the activate signal of the GtkEntry (use gtk_bin_get_child())
 * to detect when the user actually finishes entering text.
 * The convenience API to construct simple text-only GtkComboBoxes
 * can also be used with GtkComboBoxEntrys which have been constructed
 * with gtk_combo_box_entry_new_text().
 * If you have special needs that go beyond a simple entry (e.g. input validation),
 * it is possible to replace the child entry by a different widget using
 * gtk_container_remove() and gtk_container_add().
 * GtkComboBoxEntry as GtkBuildable
 * Beyond the <attributes> support that is shared by all
 * GtkCellLayout implementation,
 * GtkComboBoxEntry makes the entry available in UI definitions as an internal
 * child with name "entry".
 */
public class ComboBoxEntry : ComboBox
{
	
	/** the main Gtk struct */
	protected GtkComboBoxEntry* gtkComboBoxEntry;
	
	
	public GtkComboBoxEntry* getComboBoxEntryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkComboBoxEntry* gtkComboBoxEntry);
	
	/**
	 * Creates a new GtkComboBoxEntry which has a GtkEntry as child. After
	 * construction, you should set a model using gtk_combo_box_set_model() and a
	 * text_column * using gtk_combo_box_entry_set_text_column().
	 * Since 2.4
	 * Returns:
	 *  A new GtkComboBoxEntry.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (bool text=true);
	
	/**
	 */
	
	/**
	 * Creates a new GtkComboBoxEntry which has a GtkEntry as child and a list
	 * of strings as popup. You can get the GtkEntry from a GtkComboBoxEntry
	 * using GTK_ENTRY (GTK_BIN (combo_box_entry)->child). To add and remove
	 * strings from the list, just modify model using its data manipulation
	 * API.
	 * Since 2.4
	 * Params:
	 * model =  A GtkTreeModel.
	 * textColumn =  A column in model to get the strings from.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (TreeModelIF model, int textColumn);
	
	/**
	 * Sets the model column which entry_box should use to get strings from
	 * to be text_column.
	 * Since 2.4
	 * Params:
	 * textColumn =  A column in model to get the strings from.
	 */
	public void setTextColumn(int textColumn);
	
	/**
	 * Returns the column which entry_box is using to get the strings from.
	 * Since 2.4
	 * Returns: A column in the data source model of entry_box.
	 */
	public int getTextColumn();
}
