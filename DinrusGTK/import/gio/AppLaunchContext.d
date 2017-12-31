module gtkD.gio.AppLaunchContext;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gio.AppInfoIF;




/**
 */
public class AppLaunchContext
{
	
	/** the main Gtk struct */
	protected GAppLaunchContext* gAppLaunchContext;
	
	
	public GAppLaunchContext* getAppLaunchContextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GAppLaunchContext* gAppLaunchContext);
	
	/**
	 */
}
