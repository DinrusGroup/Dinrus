
module gtkD.gio.DesktopAppInfo;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.KeyFile;
private import gtkD.gio.AppInfo;
private import gtkD.gio.AppInfoIF;
private import gtkD.gio.AppInfoT;
private import gtkD.gio.AppInfoIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GDesktopAppInfo is an implementation of GAppInfo based on
 * desktop files.
 * Note that <gio/gdesktopappinfo.h> belongs to
 * the UNIX-specific GIO interfaces, thus you have to use the
 * gio-unix-2.0.pc pkg-config file when using it.
 */
public class DesktopAppInfo : ObjectG, AppInfoIF
{
	
	/** the main Gtk struct */
	protected GDesktopAppInfo* gDesktopAppInfo;
	
	
	public GDesktopAppInfo* getDesktopAppInfoStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GDesktopAppInfo* gDesktopAppInfo);
	
	// add the AppInfo capabilities
	mixin AppInfoT!(GDesktopAppInfo);
	
	public static DesktopAppInfo createFromFilename(string filename);
	
	/**
	 */
	
	/**
	 * Creates a new GDesktopAppInfo.
	 * Since 2.18
	 * Params:
	 * keyFile =  an opened GKeyFile
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (KeyFile keyFile);
	
	/**
	 * Creates a new GDesktopAppInfo based on a desktop file id.
	 * A desktop file id is the basename of the desktop file, including the
	 * .desktop extension. GIO is looking for a desktop file with this name
	 * in the applications subdirectories of the XDG data
	 * directories (i.e. the directories specified in the
	 * XDG_DATA_HOME and XDG_DATA_DIRS environment
	 * variables). GIO also supports the prefix-to-subdirectory mapping that is
	 * described in the Menu Spec
	 * (i.e. a desktop id of kde-foo.desktop will match
	 * /usr/share/applications/kde/foo.desktop).
	 * Params:
	 * desktopId =  the desktop file id
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string desktopId);
	
	/**
	 * A desktop file is hidden if the Hidden key in it is
	 * set to True.
	 * Returns: TRUE if hidden, FALSE otherwise.
	 */
	public int getIsHidden();
	
	/**
	 * Sets the name of the desktop that the application is running in.
	 * This is used by g_app_info_should_show() to evaluate the
	 * OnlyShowIn and NotShowIn
	 * desktop entry fields.
	 * The Desktop
	 * Params:
	 * desktopEnv =  a string specifying what desktop this is
	 */
	public static void setDesktopEnv(string desktopEnv);
	
	/**
	 * Gets the default application for launching applications
	 * using this URI scheme for a particular GDesktopAppInfoLookup
	 * implementation.
	 * The GDesktopAppInfoLookup interface and this function is used
	 * to implement g_app_info_get_default_for_uri_scheme() backends
	 * in a GIO module. There is no reason for applications to use it
	 * directly. Applications should use g_app_info_get_default_for_uri_scheme().
	 * Params:
	 * lookup =  a GDesktopAppInfoLookup
	 * uriScheme =  a string containing a URI scheme.
	 * Returns: GAppInfo for given uri_scheme or NULL on error.
	 */
	public static AppInfoIF lookupGetDefaultForUriScheme(GDesktopAppInfoLookup* lookup, string uriScheme);
}
