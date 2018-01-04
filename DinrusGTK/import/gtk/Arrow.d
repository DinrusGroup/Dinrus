module gtkD.gtk.Arrow;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.Misc;

/**
 * Description
 * GtkArrow should be used to draw simple arrows that need to point in
 * one of the four cardinal directions (up, down, left, or right). The
 * style of the arrow can be one of shadow in, shadow out, etched in, or
 * etched out. Note that these directions and style types may be
 * ammended in versions of Gtk to come.
 * GtkArrow will fill any space alloted to it, but since it is inherited
 * from GtkMisc, it can be padded and/or aligned, to fill exactly the
 * space the programmer desires.
 * Arrows are created with a call to gtk_arrow_new(). The direction or
 * style of an arrow can be changed after creation by using gtk_arrow_set().
 */
public class Arrow : Misc
{
	
	/** the main Gtk struct */
	protected GtkArrow* gtkArrow;
	
	
	public GtkArrow* getArrowStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkArrow* gtkArrow);
	
	/**
	 */
	
	/**
	 * Creates a new arrow widget.
	 * Params:
	 * arrowType = a valid GtkArrowType.
	 * shadowType = a valid GtkShadowType.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GtkArrowType arrowType, GtkShadowType shadowType);
	
	/**
	 * Sets the direction and style of the GtkArrow, arrow.
	 * Params:
	 * arrow = a widget of type GtkArrow.
	 * arrowType = a valid GtkArrowType.
	 * shadowType = a valid GtkShadowType.
	 */
	public void set(GtkArrowType arrowType, GtkShadowType shadowType);
}
