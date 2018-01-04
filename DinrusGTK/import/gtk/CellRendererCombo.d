module gtkD.gtk.CellRendererCombo;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.CellRenderer;
private import gtkD.gtk.TreeIter;



private import gtkD.gtk.CellRendererText;

/**
 * Description
 * GtkCellRendererCombo renders text in a cell like GtkCellRendererText from
 * which it is derived. But while GtkCellRendererText offers a simple entry to
 * edit the text, GtkCellRendererCombo offers a GtkComboBox or GtkComboBoxEntry
 * widget to edit the text. The values to display in the combo box are taken from
 * the tree model specified in the
 * model property.
 * The combo cell renderer takes care of adding a text cell renderer to the combo
 * box and sets it to display the column specified by its
 * text-column
 * property. Further properties of the comnbo box can be set in a handler for the
 * editing-started signal.
 * The GtkCellRendererCombo cell renderer was added in GTK+ 2.6.
 */
public class CellRendererCombo : CellRendererText
{
	
	/** the main Gtk struct */
	protected GtkCellRendererCombo* gtkCellRendererCombo;
	
	
	public GtkCellRendererCombo* getCellRendererComboStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCellRendererCombo* gtkCellRendererCombo);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(string, TreeIter, CellRendererCombo)[] onChangedListeners;
	/**
	 * This signal is emitted each time after the user selected an item in
	 * the combo box, either by using the mouse or the arrow keys. Contrary
	 * to GtkComboBox, GtkCellRendererCombo::changed is not emitted for
	 * changes made to a selected item in the entry. The argument new_iter
	 * corresponds to the newly selected item in the combo box and it is relative
	 * to the GtkTreeModel set via the model property on GtkCellRendererCombo.
	 * Note that as soon as you change the model displayed in the tree view,
	 * the tree view will immediately cease the editing operating. This
	 * means that you most probably want to refrain from changing the model
	 * until the combo cell renderer emits the edited or editing_canceled signal.
	 * Since 2.14
	 */
	void addOnChanged(void delegate(string, TreeIter, CellRendererCombo) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChanged(GtkCellRendererCombo* comboStruct, gchar* pathString, GtkTreeIter* newIter, CellRendererCombo cellRendererCombo);
	
	
	/**
	 * Creates a new GtkCellRendererCombo.
	 * Adjust how text is drawn using object properties.
	 * Object properties can be set globally (with g_object_set()).
	 * Also, with GtkTreeViewColumn, you can bind a property to a value
	 * in a GtkTreeModel. For example, you can bind the "text" property
	 * on the cell renderer to a string value in the model, thus rendering
	 * a different string in each row of the GtkTreeView.
	 * Since 2.6
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
