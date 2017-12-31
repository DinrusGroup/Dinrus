
module gtkD.gio.Volume;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.ObjectG;
private import gtkD.gio.VolumeT;
private import gtkD.gio.VolumeIF;




/**
 */
public class Volume : ObjectG, VolumeIF
{
	
	// Minimal implementation.
	mixin VolumeT!(GVolume);
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GVolume* gVolume);
	
	/**
	 */
}
