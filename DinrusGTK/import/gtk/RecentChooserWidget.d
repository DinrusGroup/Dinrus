
module gtkD.gtk.RecentChooserWidget;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.gtk.RecentManager;
private import gtkD.gtk.RecentChooserIF;
private import gtkD.gtk.RecentChooserT;



private import gtkD.gtk.VBox;

/**
 * Description
 * GtkRecentChooserWidget is a widget suitable for selecting recently used
 * files. It is the main building block of a GtkRecentChooserDialog. Most
 * applications will only need to use the latter; you can use
 * GtkRecentChooserWidget as part of a larger window if you have special needs.
 * Note that GtkRecentChooserWidget does not have any methods of its own.
 * Instead, you should use the functions that work on a GtkRecentChooser.
 * Recently used files are supported since GTK+ 2.10.
 */
public class RecentChooserWidget : VBox, RecentChooserIF
{
	
	/** the main Gtk struct */
	protected GtkRecentChooserWidget* gtkRecentChooserWidget;
	
	
	public GtkRecentChooserWidget* getRecentChooserWidgetStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRecentChooserWidget* gtkRecentChooserWidget);
	
	// add the RecentChooser capabilities
	mixin RecentChooserT!(GtkRecentChooserWidget);
	
	/**
	 */
	
	/**
	 * Creates a new GtkRecentChooserWidget object. This is an embeddable widget
	 * used to access the recently used resources list.
	 * Since 2.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GtkRecentChooserWidget with a specified recent manager.
	 * This is useful if you have implemented your own recent manager, or if you
	 * have a customized instance of a GtkRecentManager object.
	 * Since 2.10
	 * Params:
	 * manager =  a GtkRecentManager
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (RecentManager manager);
}
