module gtkD.gtk.Misc;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.Widget;

/**
 * Description
 * The GtkMisc widget is an abstract widget which is not useful itself, but
 * is used to derive subclasses which have alignment and padding attributes.
 * The horizontal and vertical padding attributes allows extra space to be
 * added around the widget.
 * The horizontal and vertical alignment attributes enable the widget to be
 * positioned within its allocated area. Note that if the widget is added to
 * a container in such a way that it expands automatically to fill its
 * allocated area, the alignment settings will not alter the widgets position.
 */
public class Misc : Widget
{
	
	/** the main Gtk struct */
	protected GtkMisc* gtkMisc;
	
	
	public GtkMisc* getMiscStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkMisc* gtkMisc);
	
	/**
	 */
	
	/**
	 * Sets the alignment of the widget.
	 * Params:
	 * xalign = the horizontal alignment, from 0 (left) to 1 (right).
	 * yalign = the vertical alignment, from 0 (top) to 1 (bottom).
	 */
	public void setAlignment(float xalign, float yalign);
	
	/**
	 * Sets the amount of space to add around the widget.
	 * Params:
	 * xpad = the amount of space to add on the left and right of the widget,
	 * in pixels.
	 * ypad = the amount of space to add on the top and bottom of the widget,
	 * in pixels.
	 */
	public void setPadding(int xpad, int ypad);
	
	/**
	 * Gets the X and Y alignment of the widget within its allocation.
	 * See gtk_misc_set_alignment().
	 * Params:
	 * xalign =  location to store X alignment of misc, or NULL
	 * yalign =  location to store Y alignment of misc, or NULL
	 */
	public void getAlignment(out float xalign, out float yalign);
	
	/**
	 * Gets the padding in the X and Y directions of the widget.
	 * See gtk_misc_set_padding().
	 * Params:
	 * xpad =  location to store padding in the X direction, or NULL
	 * ypad =  location to store padding in the Y direction, or NULL
	 */
	public void getPadding(out int xpad, out int ypad);
}
