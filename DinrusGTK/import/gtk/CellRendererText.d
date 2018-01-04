module gtkD.gtk.CellRendererText;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.CellRenderer;



private import gtkD.gtk.CellRenderer;

/**
 * Description
 * A GtkCellRendererText renders a given text in its cell, using the font, color and
 * style information provided by its properties. The text will be ellipsized if it is
 * too long and the ellipsize
 * property allows it.
 * If the mode is GTK_CELL_RENDERER_MODE_EDITABLE,
 * the GtkCellRendererText allows to edit its text using an entry.
 */
public class CellRendererText : CellRenderer
{
	
	/** the main Gtk struct */
	protected GtkCellRendererText* gtkCellRendererText;
	
	
	public GtkCellRendererText* getCellRendererTextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCellRendererText* gtkCellRendererText);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(string, string, CellRendererText)[] onEditedListeners;
	/**
	 * This signal is emitted after renderer has been edited.
	 * It is the responsibility of the application to update the model
	 * and store new_text at the position indicated by path.
	 */
	void addOnEdited(void delegate(string, string, CellRendererText) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackEdited(GtkCellRendererText* rendererStruct, gchar* path, gchar* newText, CellRendererText cellRendererText);
	
	
	/**
	 * Creates a new GtkCellRendererText. Adjust how text is drawn using
	 * object properties. Object properties can be
	 * set globally (with g_object_set()). Also, with GtkTreeViewColumn,
	 * you can bind a property to a value in a GtkTreeModel. For example,
	 * you can bind the "text" property on the cell renderer to a string
	 * value in the model, thus rendering a different string in each row
	 * of the GtkTreeView
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets the height of a renderer to explicitly be determined by the "font" and
	 * "y_pad" property set on it. Further changes in these properties do not
	 * affect the height, so they must be accompanied by a subsequent call to this
	 * function. Using this function is unflexible, and should really only be used
	 * if calculating the size of a cell is too slow (ie, a massive number of cells
	 * displayed). If number_of_rows is -1, then the fixed height is unset, and
	 * the height is determined by the properties again.
	 * Params:
	 * numberOfRows =  Number of rows of text each cell renderer is allocated, or -1
	 */
	public void setFixedHeightFromFont(int numberOfRows);
}
