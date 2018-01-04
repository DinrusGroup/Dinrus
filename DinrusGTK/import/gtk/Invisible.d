module gtkD.gtk.Invisible;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Screen;



private import gtkD.gtk.Widget;

/**
 * Description
 * The GtkInvisible widget is used internally in GTK+, and is probably not
 * very useful for application developers.
 * It is used for reliable pointer grabs and selection handling in the code
 * for drag-and-drop.
 */
public class Invisible : Widget
{
	
	/** the main Gtk struct */
	protected GtkInvisible* gtkInvisible;
	
	
	public GtkInvisible* getInvisibleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkInvisible* gtkInvisible);
	
	/**
	 */
	
	/**
	 * Creates a new GtkInvisible.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GtkInvisible object for a specified screen
	 * Since 2.2
	 * Params:
	 * screen =  a GdkScreen which identifies on which
	 *  the new GtkInvisible will be created.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Screen screen);
	
	/**
	 * Sets the GdkScreen where the GtkInvisible object will be displayed.
	 * Since 2.2
	 * Params:
	 * screen =  a GdkScreen.
	 */
	public void setScreen(Screen screen);
	
	/**
	 * Returns the GdkScreen object associated with invisible
	 * Since 2.2
	 * Returns: the associated GdkScreen.
	 */
	public override Screen getScreen();
}
