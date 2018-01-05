module gtkD.gtk.Scrollbar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.Range;

/**
 * Description
 * The GtkScrollbar widget is an abstract base class for GtkHScrollbar and
 * GtkVScrollbar. It is not very useful in itself.
 * The position of the thumb in a scrollbar is controlled by the scroll
 * adjustments. See GtkAdjustment for the fields in an adjustment - for
 * GtkScrollbar, the "value" field represents the position of the
 * scrollbar, which must be between the "lower" field and "upper -
 * page_size." The "page_size" field represents the size of the visible
 * scrollable area. The "step_increment" and "page_increment" fields are
 * used when the user asks to step down (using the small stepper arrows)
 * or page down (using for example the PageDown key).
 */
public class Scrollbar : Range
{
	
	/** the main Gtk struct */
	protected GtkScrollbar* gtkScrollbar;
	
	
	public GtkScrollbar* getScrollbarStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkScrollbar* gtkScrollbar);
	
	/**
	 */
}
