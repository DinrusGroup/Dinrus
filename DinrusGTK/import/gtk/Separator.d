module gtkD.gtk.Separator;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.OrientableIF;
private import gtkD.gtk.OrientableT;



private import gtkD.gtk.Widget;

/**
 * Description
 * The GtkSeparator widget is an abstract class, used only for deriving the
 * subclasses GtkHSeparator and GtkVSeparator.
 */
public class Separator : Widget, OrientableIF
{
	
	/** the main Gtk struct */
	protected GtkSeparator* gtkSeparator;
	
	
	public GtkSeparator* getSeparatorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSeparator* gtkSeparator);
	
	// add the Orientable capabilities
	mixin OrientableT!(GtkSeparator);
	
	/**
	 */
}
