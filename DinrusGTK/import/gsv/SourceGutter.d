module gtkD.gsv.SourceGutter;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gdk.Window;
private import gtkD.gtk.CellRenderer;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The GtkSourceGutter object represents the left and right gutters of the
 * text view. It is used by GtkSourceView to draw the line numbers and category
 * marks that might be present on a line. By packing additional GtkCellRenderer
 * objects in the gutter, you can extend the gutter by your own custom drawings.
 * The gutter works very much the same way as cells rendered in a GtkTreeView.
 * The concept is similar, with the exception that the gutter does not have an
 * underlying GtkTreeModel. Instead, you should use
 * gtk_source_gutter_set_cell_data_func to set a callback to fill in any
 * of the cell renderers properties, given the line for which the cell is to be
 * rendered. Renderers are inserted into the gutter at a certain position.
 * The builtin line number renderer is at position
 * GTK_SOURCE_VIEW_GUTTER_POSITION_LINES (-30) and the marks renderer is at
 * GTK_SOURCE_VIEW_GUTTER_POSITION_MARKS (-20). You can use these values to
 * position custom renderers accordingly.
 * The width of a cell renderer can be specified as either fixed (using
 * gtk_cell_renderer_set_fixed_size) or dynamic, in which case you
 * MUST set
 * gtk_source_gutter_set_cell_size_func. This callback is used to set the
 * properties of the renderer such that gtk_cell_renderer_get_size yields the
 * maximum width of the cell.
 */
public class SourceGutter : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkSourceGutter* gtkSourceGutter;
	
	
	public GtkSourceGutter* getSourceGutterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSourceGutter* gtkSourceGutter);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(CellRenderer, GtkTextIter*, gpointer, SourceGutter)[] onCellActivatedListeners;
	/**
	 * Emitted when a cell has been activated (for instance when there was
	 * a button press on the cell). The signal is only emitted for cells
	 * that have the activatable property set to TRUE.
	 */
	void addOnCellActivated(void delegate(CellRenderer, GtkTextIter*, gpointer, SourceGutter) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCellActivated(GtkSourceGutter* gutterStruct, GtkCellRenderer* renderer, GtkTextIter* iter, gpointer event, SourceGutter sourceGutter);
	
	bool delegate(CellRenderer, GtkTextIter*, GtkTooltip*, SourceGutter)[] onQueryTooltipListeners;
	/**
	 * Emitted when a tooltip is requested for a specific cell. Signal
	 * handlers can return TRUE to notify the tooltip has been handled.
	 */
	void addOnQueryTooltip(bool delegate(CellRenderer, GtkTextIter*, GtkTooltip*, SourceGutter) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackQueryTooltip(GtkSourceGutter* gutterStruct, GtkCellRenderer* renderer, GtkTextIter* iter, GtkTooltip* tooltip, SourceGutter sourceGutter);
	
	
	/**
	 * Get the GdkWindow of the gutter. The window will only be available when the
	 * gutter has at least one, non-zero width, cell renderer packed.
	 * Since 2.8
	 * Returns: the GdkWindow of the gutter, or NULL if the gutter has no window.
	 */
	public Window getWindow();
	
	/**
	 * Inserts renderer into gutter at position.
	 * Since 2.8
	 * Params:
	 * renderer =  a GtkCellRenderer
	 * position =  the renderers position
	 */
	public void insert(CellRenderer renderer, int position);
	
	/**
	 * Reorders renderer in gutter to new position.
	 * Since 2.8
	 * Params:
	 * renderer =  a GtkCellRenderer
	 * position =  the new renderer position
	 */
	public void reorder(CellRenderer renderer, int position);
	
	/**
	 * Removes renderer from gutter.
	 * Since 2.8
	 * Params:
	 * renderer =  a GtkCellRenderer
	 */
	public void remove(CellRenderer renderer);
	
	/**
	 * Sets the GtkSourceGutterDataFunc to use for renderer. This function is
	 * used to setup the cell renderer properties for rendering the current cell.
	 * Since 2.8
	 * Params:
	 * renderer =  a GtkCellRenderer
	 * func =  the GtkSourceGutterDataFunc to use
	 * funcData =  the user data for func
	 * destroy =  the destroy notification for func_data
	 */
	public void setCellDataFunc(CellRenderer renderer, GtkSourceGutterDataFunc func, void* funcData, GDestroyNotify destroy);
	
	/**
	 * Sets the GtkSourceGutterSizeFunc to use for renderer. This function is
	 * used to setup the cell renderer properties for measuring the maximum size
	 * of the cell.
	 * Since 2.8
	 * Params:
	 * renderer =  a GtkCellRenderer
	 * func =  the GtkSourceGutterSizeFunc to use
	 * funcData =  the user data for func
	 * destroy =  the destroy notification for func_data
	 */
	public void setCellSizeFunc(CellRenderer renderer, GtkSourceGutterSizeFunc func, void* funcData, GDestroyNotify destroy);
	
	/**
	 * Invalidates the drawable area of the gutter. You can use this to force a
	 * redraw of the gutter if something has changed and needs to be redrawn.
	 * Since 2.8
	 */
	public void queueDraw();
}
