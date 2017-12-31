module gtkD.gio.Icon;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.ObjectG;
private import gtkD.gio.IconT;
private import gtkD.gio.IconIF;




/**
 */
public class Icon : ObjectG, IconIF
{
	
	// Minimal implementation.
	mixin IconT!(GIcon);
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GIcon* gIcon);
	
	/**
	 */
}
