module gtkD.gtk.HPaned;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;



private import gtkD.gtk.Paned;

/**
 * Description
 * The HPaned widget is a container widget with two
 * children arranged horizontally. The division between
 * the two panes is adjustable by the user by dragging
 * a handle. See GtkPaned for details.
 */
public class HPaned : Paned
{
	
	/** the main Gtk struct */
	protected GtkHPaned* gtkHPaned;
	
	
	public GtkHPaned* getHPanedStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkHPaned* gtkHPaned);
	
	/**
	 * Creates a new HPaned and adds two widgets as it's children
	 * Params:
	 *  child1 =
	 *  child2 =
	 */
	this(Widget child1, Widget child2);
	
	
	/**
	 */
	
	/**
	 * Create a new GtkHPaned
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
