module gtkD.gtk.VScrollbar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Adjustment;



private import gtkD.gtk.Scrollbar;

/**
 * Description
 * The GtkVScrollbar widget is a widget arranged vertically creating a
 * scrollbar. See GtkScrollbar for details on
 * scrollbars. GtkAdjustment pointers may be added to handle the
 * adjustment of the scrollbar or it may be left NULL in which case one
 * will be created for you. See GtkScrollbar for a description of what the
 * fields in an adjustment represent for a scrollbar.
 */
public class VScrollbar : Scrollbar
{
	
	/** the main Gtk struct */
	protected GtkVScrollbar* gtkVScrollbar;
	
	
	public GtkVScrollbar* getVScrollbarStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkVScrollbar* gtkVScrollbar);
	
	/**
	 */
	
	/**
	 * Creates a new vertical scrollbar.
	 * Params:
	 * adjustment =  the GtkAdjustment to use, or NULL to create a new adjustment
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Adjustment adjustment);
}
