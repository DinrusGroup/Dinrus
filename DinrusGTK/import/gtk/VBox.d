module gtkD.gtk.VBox;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.Box;

/**
 * Description
 * GtkVBox is a container that organizes child widgets into a single column.
 * Use the GtkBox packing interface to determine the arrangement,
 * spacing, height, and alignment of GtkVBox children.
 * All children are allocated the same width.
 */
public class VBox : Box
{
	
	/** the main Gtk struct */
	protected GtkVBox* gtkVBox;
	
	
	public GtkVBox* getVBoxStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkVBox* gtkVBox);
	
	/**
	 */
	
	/**
	 * Creates a new GtkVBox.
	 * Params:
	 * homogeneous = %TRUE if all children are to be given equal space allotments.
	 * spacing = the number of pixels to place by default between children.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int homogeneous, int spacing);
}
