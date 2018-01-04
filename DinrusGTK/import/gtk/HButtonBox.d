module gtkD.gtk.HButtonBox;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;





private import gtkD.gtk.ButtonBox;

/**
 * Description
 * A button box should be used to provide a consistent layout of buttons
 * throughout your application. The layout/spacing can be altered by the
 * programmer, or if desired, by the user to alter the 'feel' of a
 * program to a small degree.
 * A GtkHButtonBox is created with gtk_hbutton_box_new(). Buttons are
 * packed into a button box the same way widgets are added to any other
 * container, using gtk_container_add(). You can also use
 * gtk_box_pack_start() or gtk_box_pack_end(), but for button boxes both
 * these functions work just like gtk_container_add(), ie., they pack the
 * button in a way that depends on the current layout style and on
 * whether the button has had gtk_button_box_set_child_secondary() called
 * on it.
 * The spacing between buttons can be set with gtk_box_set_spacing(). The
 * arrangement and layout of the buttons can be changed with
 * gtk_button_box_set_layout().
 */
public class HButtonBox : ButtonBox
{
	
	/** the main Gtk struct */
	protected GtkHButtonBox* gtkHButtonBox;
	
	
	public GtkHButtonBox* getHButtonBoxStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkHButtonBox* gtkHButtonBox);
	
	/**
	 * Creates a new HButtonBox and sets comon parameters
	 */
	static ButtonBox createActionBox();
	
	
	/**
	 */
	
	/**
	 * Creates a new horizontal button box.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Warning
	 * gtk_hbutton_box_get_spacing_default is deprecated and should not be used in newly-written code.
	 * Retrieves the current default spacing for horizontal button boxes. This is the number of pixels
	 * to be placed between the buttons when they are arranged.
	 * Returns:the default number of pixels between buttons.
	 */
	public static int getSpacingDefault();
	
	/**
	 * Warning
	 * gtk_hbutton_box_get_layout_default is deprecated and should not be used in newly-written code.
	 * Retrieves the current layout used to arrange buttons in button box widgets.
	 * Returns:the current GtkButtonBoxStyle.
	 */
	public static GtkButtonBoxStyle getLayoutDefault();
	
	/**
	 * Warning
	 * gtk_hbutton_box_set_spacing_default is deprecated and should not be used in newly-written code.
	 * Changes the default spacing that is placed between widgets in an
	 * horizontal button box.
	 * Params:
	 * spacing = an integer value.
	 */
	public static void setSpacingDefault(int spacing);
	
	/**
	 * Warning
	 * gtk_hbutton_box_set_layout_default is deprecated and should not be used in newly-written code.
	 * Sets a new layout mode that will be used by all button boxes.
	 * Params:
	 * layout = a new GtkButtonBoxStyle.
	 */
	public static void setLayoutDefault(GtkButtonBoxStyle layout);
}
