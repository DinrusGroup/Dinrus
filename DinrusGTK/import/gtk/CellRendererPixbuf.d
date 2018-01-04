module gtkD.gtk.CellRendererPixbuf;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.CellRenderer;



private import gtkD.gtk.CellRenderer;

/**
 * Description
 * A GtkCellRendererPixbuf can be used to render an image in a cell. It allows to render
 * either a given GdkPixbuf (set via the
 * pixbuf property) or a stock icon
 * (set via the stock-id property).
 * To support the tree view, GtkCellRendererPixbuf also supports rendering two alternative
 * pixbufs, when the is-expander property
 * is TRUE. If the is-expanded property
 * is TRUE and the
 * pixbuf-expander-open
 * property is set to a pixbuf, it renders that pixbuf, if the
 * is-expanded property is FALSE and
 * the
 * pixbuf-expander-closed
 * property is set to a pixbuf, it renders that one.
 */
public class CellRendererPixbuf : CellRenderer
{
	
	/** the main Gtk struct */
	protected GtkCellRendererPixbuf* gtkCellRendererPixbuf;
	
	
	public GtkCellRendererPixbuf* getCellRendererPixbufStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCellRendererPixbuf* gtkCellRendererPixbuf);
	
	/**
	 */
	
	/**
	 * Creates a new GtkCellRendererPixbuf. Adjust rendering
	 * parameters using object properties. Object properties can be set
	 * globally (with g_object_set()). Also, with GtkTreeViewColumn, you
	 * can bind a property to a value in a GtkTreeModel. For example, you
	 * can bind the "pixbuf" property on the cell renderer to a pixbuf value
	 * in the model, thus rendering a different image in each row of the
	 * GtkTreeView.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
