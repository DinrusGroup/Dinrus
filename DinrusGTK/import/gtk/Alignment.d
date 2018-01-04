module gtkD.gtk.Alignment;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;



private import gtkD.gtk.Bin;

/**
 * Description
 * The GtkAlignment widget controls the alignment and size of its child widget.
 * It has four settings: xscale, yscale, xalign, and yalign.
 * The scale settings are used to specify how much the child widget should
 * expand to fill the space allocated to the GtkAlignment.
 * The values can range from 0 (meaning the child doesn't expand at all) to
 * 1 (meaning the child expands to fill all of the available space).
 * The align settings are used to place the child widget within the available
 * area. The values range from 0 (top or left) to 1 (bottom or right).
 * Of course, if the scale settings are both set to 1, the alignment settings
 * have no effect.
 */
public class Alignment : Bin
{
	
	/** the main Gtk struct */
	protected GtkAlignment* gtkAlignment;
	
	
	public GtkAlignment* getAlignmentStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkAlignment* gtkAlignment);
	
	/** */
	public static Alignment center(Widget widget);
	
	/** */
	public static Alignment north(Widget widget);
	
	/** */
	public static Alignment south(Widget widget);

	/** */
	public static Alignment east(Widget widget);
	
	/** */
	public static Alignment west(Widget widget);
	
	/** */
	public static Alignment northWest(Widget widget);
	
	/** */
	public static Alignment southWest(Widget widget);
	
	/** */
	public static Alignment northEast(Widget widget);
	
	/** */
	public static Alignment southEast(Widget widget);
	
	/**
	 */
	
	/**
	 * Creates a new GtkAlignment.
	 * Params:
	 * xalign = the horizontal alignment of the child widget, from 0 (left) to 1
	 * (right).
	 * yalign = the vertical alignment of the child widget, from 0 (top) to 1
	 * (bottom).
	 * xscale = the amount that the child widget expands horizontally to fill up
	 * unused space, from 0 to 1.
	 * A value of 0 indicates that the child widget should never expand.
	 * A value of 1 indicates that the child widget will expand to fill all of the
	 * space allocated for the GtkAlignment.
	 * yscale = the amount that the child widget expands vertically to fill up
	 * unused space, from 0 to 1. The values are similar to xscale.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (float xalign, float yalign, float xscale, float yscale);
	
	/**
	 * Sets the GtkAlignment values.
	 * Params:
	 * xalign = the horizontal alignment of the child widget, from 0 (left) to 1
	 * (right).
	 * yalign = the vertical alignment of the child widget, from 0 (top) to 1
	 * (bottom).
	 * xscale = the amount that the child widget expands horizontally to fill up
	 * unused space, from 0 to 1.
	 * A value of 0 indicates that the child widget should never expand.
	 * A value of 1 indicates that the child widget will expand to fill all of the
	 * space allocated for the GtkAlignment.
	 * yscale = the amount that the child widget expands vertically to fill up
	 * unused space, from 0 to 1. The values are similar to xscale.
	 */
	public void set(float xalign, float yalign, float xscale, float yscale);
	
	/**
	 * Gets the padding on the different sides of the widget.
	 * See gtk_alignment_set_padding().
	 * Since 2.4
	 * Params:
	 * paddingTop =  location to store the padding for the top of the widget, or NULL
	 * paddingBottom =  location to store the padding for the bottom of the widget, or NULL
	 * paddingLeft =  location to store the padding for the left of the widget, or NULL
	 * paddingRight =  location to store the padding for the right of the widget, or NULL
	 */
	public void getPadding(out uint paddingTop, out uint paddingBottom, out uint paddingLeft, out uint paddingRight);
	
	/**
	 * Sets the padding on the different sides of the widget.
	 * The padding adds blank space to the sides of the widget. For instance,
	 * this can be used to indent the child widget towards the right by adding
	 * padding on the left.
	 * Since 2.4
	 * Params:
	 * paddingTop =  the padding at the top of the widget
	 * paddingBottom =  the padding at the bottom of the widget
	 * paddingLeft =  the padding at the left of the widget
	 * paddingRight =  the padding at the right of the widget.
	 */
	public void setPadding(uint paddingTop, uint paddingBottom, uint paddingLeft, uint paddingRight);
}
