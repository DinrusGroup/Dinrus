module gtkD.gtk.CellView;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Pixbuf;
private import gtkD.gtk.TreeModel;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreePath;
private import gtkD.gdk.Color;
private import gtkD.glib.ListG;
private import gtkD.gtk.CellLayoutIF;
private import gtkD.gtk.CellLayoutT;



private import gtkD.gtk.Widget;

/**
 * Description
 * A GtkCellView displays a single row of a GtkTreeModel, using
 * cell renderers just like GtkTreeView. GtkCellView doesn't support
 * some of the more complex features of GtkTreeView, like cell editing
 * and drag and drop.
 */
public class CellView : Widget, CellLayoutIF
{
	
	/** the main Gtk struct */
	protected GtkCellView* gtkCellView;
	
	
	public GtkCellView* getCellViewStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCellView* gtkCellView);
	
	// add the CellLayout capabilities
	mixin CellLayoutT!(GtkCellView);
	
	/**
	 * Creates a new GtkCellView widget, adds a GtkCellRendererText
	 * to it, and makes its show text.
	 * If markup is true the text can be marked up with the Pango text
	 * markup language.
	 * Since 2.6
	 * Params:
	 *  text = the text to display in the cell view
	 * Returns:
	 *  A newly created GtkCellView widget.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string text, bool markup=true);
	/**
	 */
	
	/**
	 * Creates a new GtkCellView widget.
	 * Since 2.6
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GtkCellView widget, adds a GtkCellRendererPixbuf
	 * to it, and makes its show pixbuf.
	 * Since 2.6
	 * Params:
	 * pixbuf =  the image to display in the cell view
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Pixbuf pixbuf);
	
	/**
	 * Sets the model for cell_view. If cell_view already has a model
	 * set, it will remove it before setting the new model. If model is
	 * NULL, then it will unset the old model.
	 * Since 2.6
	 * Params:
	 * model =  a GtkTreeModel
	 */
	public void setModel(TreeModelIF model);
	
	/**
	 * Returns the model for cell_view. If no model is used NULL is
	 * returned.
	 * Since 2.16
	 * Returns: a GtkTreeModel used or NULL
	 */
	public TreeModelIF getModel();
	
	/**
	 * Sets the row of the model that is currently displayed
	 * by the GtkCellView. If the path is unset, then the
	 * contents of the cellview "stick" at their last value;
	 * this is not normally a desired result, but may be
	 * a needed intermediate state if say, the model for
	 * the GtkCellView becomes temporarily empty.
	 * Since 2.6
	 * Params:
	 * path =  a GtkTreePath or NULL to unset.
	 */
	public void setDisplayedRow(TreePath path);
	
	/**
	 * Returns a GtkTreePath referring to the currently
	 * displayed row. If no row is currently displayed,
	 * NULL is returned.
	 * Since 2.6
	 * Returns: the currently displayed row or NULL
	 */
	public TreePath getDisplayedRow();
	
	/**
	 * Sets requisition to the size needed by cell_view to display
	 * the model row pointed to by path.
	 * Since 2.6
	 * Params:
	 * path =  a GtkTreePath
	 * requisition =  return location for the size
	 * Returns: TRUE
	 */
	public int getSizeOfRow(TreePath path, out GtkRequisition requisition);
	
	/**
	 * Sets the background color of view.
	 * Since 2.6
	 * Params:
	 * color =  the new background color
	 */
	public void setBackgroundColor(Color color);
	
	/**
	 * Warning
	 * gtk_cell_view_get_cell_renderers has been deprecated since version 2.18 and should not be used in newly-written code. use gtk_cell_layout_get_cells() instead.
	 * Returns the cell renderers which have been added to cell_view.
	 * Since 2.6
	 * Returns: a list of cell renderers. The list, but not the renderers has been newly allocated and should be freed with g_list_free() when no longer needed.
	 */
	public ListG getCellRenderers();
}
