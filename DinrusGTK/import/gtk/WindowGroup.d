module gtkD.gtk.WindowGroup;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;
private import gtkD.gtk.Window;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class WindowGroup : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkWindowGroup* gtkWindowGroup;
	
	
	public GtkWindowGroup* getWindowGroupStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkWindowGroup* gtkWindowGroup);
	
	/**
	 */
	
	/**
	 * Creates a new GtkWindowGroup object. Grabs added with
	 * gtk_grab_add() only affect windows within the same GtkWindowGroup.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Adds a window to a GtkWindowGroup.
	 * Params:
	 * window =  the GtkWindow to add
	 */
	public void addWindow(Window window);
	/**
	 * Removes a window from a GtkWindowGroup.
	 * Params:
	 * window =  the GtkWindow to remove
	 */
	public void removeWindow(Window window);
	
	/**
	 * Returns a list of the GtkWindows that belong to window_group.
	 * Since 2.14
	 * Returns: A newly-allocated list of windows inside the group.
	 */
	public ListG listWindows();
}
