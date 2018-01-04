module gtkD.gtk.CellRendererToggle;

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
 * GtkCellRendererToggle renders a toggle button in a cell. The
 * button is drawn as a radio- or checkbutton, depending on the
 * radio
 * property. When activated, it emits the toggled signal.
 */
public class CellRendererToggle : CellRenderer
{
	
	/** the main Gtk struct */
	protected GtkCellRendererToggle* gtkCellRendererToggle;
	
	
	public GtkCellRendererToggle* getCellRendererToggleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCellRendererToggle* gtkCellRendererToggle);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(string, CellRendererToggle)[] onToggledListeners;
	/**
	 * The ::toggled signal is emitted when the cell is toggled.
	 */
	void addOnToggled(void delegate(string, CellRendererToggle) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggled(GtkCellRendererToggle* cellRendererStruct, gchar* path, CellRendererToggle cellRendererToggle);
	
	
	/**
	 * Creates a new GtkCellRendererToggle. Adjust rendering
	 * parameters using object properties. Object properties can be set
	 * globally (with g_object_set()). Also, with GtkTreeViewColumn, you
	 * can bind a property to a value in a GtkTreeModel. For example, you
	 * can bind the "active" property on the cell renderer to a boolean value
	 * in the model, thus causing the check button to reflect the state of
	 * the model.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Returns whether we're rendering radio toggles rather than checkboxes.
	 * Returns: TRUE if we're rendering radio toggles rather than checkboxes
	 */
	public int getRadio();
	
	/**
	 * If radio is TRUE, the cell renderer renders a radio toggle
	 * (i.e. a toggle in a group of mutually-exclusive toggles).
	 * If FALSE, it renders a check toggle (a standalone boolean option).
	 * This can be set globally for the cell renderer, or changed just
	 * before rendering each cell in the model (for GtkTreeView, you set
	 * up a per-row setting using GtkTreeViewColumn to associate model
	 * columns with cell renderer properties).
	 * Params:
	 * radio =  TRUE to make the toggle look like a radio button
	 */
	public void setRadio(int radio);
	
	/**
	 * Returns whether the cell renderer is active. See
	 * gtk_cell_renderer_toggle_set_active().
	 * Returns: TRUE if the cell renderer is active.
	 */
	public int getActive();
	
	/**
	 * Activates or deactivates a cell renderer.
	 * Params:
	 * setting =  the value to set.
	 */
	public void setActive(int setting);
	
	/**
	 * Returns whether the cell renderer is activatable. See
	 * gtk_cell_renderer_toggle_set_activatable().
	 * Since 2.18
	 * Returns: TRUE if the cell renderer is activatable.
	 */
	public int getActivatable();
	
	/**
	 * Makes the cell renderer activatable.
	 * Since 2.18
	 * Params:
	 * setting =  the value to set.
	 */
	public void setActivatable(int setting);
}
