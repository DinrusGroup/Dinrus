module gtkD.gtk.Bin;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;



private import gtkD.gtk.Container;

/**
 * Description
 * The GtkBin widget is a container with just one child.
 * It is not very useful itself, but it is useful for deriving subclasses,
 * since it provides common code needed for handling a single child widget.
 * Many GTK+ widgets are subclasses of GtkBin, including GtkWindow, GtkButton,
 * GtkFrame, GtkHandleBox, and GtkScrolledWindow.
 */
public class Bin : Container
{
	
	/** the main Gtk struct */
	protected GtkBin* gtkBin;
	
	
	public GtkBin* getBinStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkBin* gtkBin);
	
	/**
	 */
	
	/**
	 * Gets the child of the GtkBin, or NULL if the bin contains
	 * no child widget. The returned widget does not have a reference
	 * added, so you do not need to unref it.
	 * Returns: pointer to child of the GtkBin
	 */
	public Widget getChild();
}
