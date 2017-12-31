module gtkD.gio.Vfs;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gio.File;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Entry point for using GIO functionality.
 */
public class Vfs : ObjectG
{
	
	/** the main Gtk struct */
	protected GVfs* gVfs;
	
	
	public GVfs* getVfsStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GVfs* gVfs);
	
	/**
	 */
	
	/**
	 * Gets a GFile for path.
	 * Params:
	 * path =  a string containing a VFS path.
	 * Returns: a GFile.  Free the returned object with g_object_unref().
	 */
	public File getFileForPath(string path);
	
	/**
	 * Gets a GFile for uri.
	 * This operation never fails, but the returned object
	 * might not support any I/O operation if the URI
	 * is malformed or if the URI scheme is not supported.
	 * Params:
	 * uri =  a string containing a URI
	 * Returns: a GFile.  Free the returned object with g_object_unref().
	 */
	public File getFileForUri(string uri);
	
	/**
	 * This operation never fails, but the returned object might
	 * not support any I/O operations if the parse_name cannot
	 * be parsed by the GVfs module.
	 * Params:
	 * parseName =  a string to be parsed by the VFS module.
	 * Returns: a GFile for the given parse_name. Free the returned object with g_object_unref().
	 */
	public File parseName(string parseName);
	
	/**
	 * Gets the default GVfs for the system.
	 * Returns: a GVfs.
	 */
	public static Vfs getDefault();
	
	/**
	 * Gets the local GVfs for the system.
	 * Returns: a GVfs.
	 */
	public static Vfs getLocal();
	
	/**
	 * Checks if the VFS is active.
	 * Returns: TRUE if construction of the vfs was successful and it is now active.
	 */
	public int isActive();
	
	/**
	 * Gets a list of URI schemes supported by vfs.
	 * Returns: a NULL-terminated array of strings. The returned array belongs to GIO and must  not be freed or modified.
	 */
	public string[] getSupportedUriSchemes();
}
