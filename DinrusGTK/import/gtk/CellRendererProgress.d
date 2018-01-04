module gtkD.gtk.CellRendererProgress;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.CellRenderer;



private import gtkD.gtk.CellRenderer;

/**
 * Description
 * GtkCellRendererProgress renders a numeric value as a progress par in a cell.
 * Additionally, it can display a text on top of the progress bar.
 * The GtkCellRendererProgress cell renderer was added in GTK+ 2.6.
 */
public class CellRendererProgress : CellRenderer
{
	
	/** the main Gtk struct */
	protected GtkCellRendererProgress* gtkCellRendererProgress;
	
	
	public GtkCellRendererProgress* getCellRendererProgressStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCellRendererProgress* gtkCellRendererProgress);
	
	/**
	 */
	
	/**
	 * Creates a new GtkCellRendererProgress.
	 * Since 2.6
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
