
module gtkD.gio.Drive;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.ObjectG;
private import gtkD.gio.DriveT;
private import gtkD.gio.DriveIF;




/**
 */
public class Drive : ObjectG, DriveIF
{
	
	// Minimal implementation.
	mixin DriveT!(GDrive);
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GDrive* gDrive);
	
	/**
	 */
}
