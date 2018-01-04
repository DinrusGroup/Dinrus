module gtkD.gtk.CellEditable;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.ObjectG;
private import gtkD.gtk.CellEditableT;
private import gtkD.gtk.CellEditableIF;




/**
 */
public class CellEditable : ObjectG, CellEditableIF
{
	
	// Minimal implementation.
	mixin CellEditableT!(GtkCellEditable);
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCellEditable* gtkCellEditable);
	
	/**
	 */
}
