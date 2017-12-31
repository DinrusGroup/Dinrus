module gtkD.gio.AppInfo;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.ObjectG;
private import gtkD.gio.AppInfoT;
private import gtkD.gio.AppInfoIF;




/**
 */
public class AppInfo : ObjectG, AppInfoIF
{
	
	// Minimal implementation.
	mixin AppInfoT!(GAppInfo);
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GAppInfo* gAppInfo);
	
	/**
	 */
}
