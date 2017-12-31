module gtkD.gio.Mount;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.ObjectG;
private import gtkD.gio.MountT;
private import gtkD.gio.MountIF;




/**
 */
public class Mount : ObjectG, MountIF
{
	
	// Minimal implementation.
	mixin MountT!(GMount);
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GMount* gMount);
	
	/**
	 */
}
