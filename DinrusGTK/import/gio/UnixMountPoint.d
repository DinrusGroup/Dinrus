module gtkD.gio.UnixMountPoint;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;




/**
 * Description
 * Routines for managing mounted UNIX mount points and paths.
 * Note that <gio/gunixmounts.h> belongs to the
 * UNIX-specific GIO interfaces, thus you have to use the
 * gio-unix-2.0.pc pkg-config file when using it.
 */
public class UnixMountPoint
{
	
	/** the main Gtk struct */
	protected GUnixMountPoint* gUnixMountPoint;
	
	
	public GUnixMountPoint* getUnixMountPointStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixMountPoint* gUnixMountPoint);
	
	/**
	 */
	
	/**
	 * Frees a unix mount point.
	 */
	public void free();
	
	/**
	 * Compares two unix mount points.
	 * Params:
	 * mount2 =  a GUnixMount.
	 * Returns: 1, 0 or -1 if mount1 is greater than, equal to,or less than mount2, respectively.
	 */
	public int compare(UnixMountPoint mount2);
	
	/**
	 * Gets the mount path for a unix mount point.
	 * Returns: a string containing the mount path.
	 */
	public string getMountPath();
	
	/**
	 * Gets the device path for a unix mount point.
	 * Returns: a string containing the device path.
	 */
	public string getDevicePath();
	
	/**
	 * Gets the file system type for the mount point.
	 * Returns: a string containing the file system type.
	 */
	public string getFsType();
	
	/**
	 * Checks if a unix mount point is read only.
	 * Returns: TRUE if a mount point is read only.
	 */
	public int isReadonly();
	
	/**
	 * Checks if a unix mount point is mountable by the user.
	 * Returns: TRUE if the mount point is user mountable.
	 */
	public int isUserMountable();
	
	/**
	 * Checks if a unix mount point is a loopback device.
	 * Returns: TRUE if the mount point is a loopback. FALSE otherwise.
	 */
	public int isLoopback();
	
	/**
	 * Guesses the icon of a Unix mount point.
	 * Returns: a GIcon
	 */
	public IconIF guessIcon();
	
	/**
	 * Guesses the name of a Unix mount point.
	 * The result is a translated string.
	 * Returns: A newly allocated string that must  be freed with g_free()
	 */
	public string guessName();
	
	/**
	 * Guesses whether a Unix mount point can be ejected.
	 * Returns: TRUE if mount_point is deemed to be ejectable.
	 */
	public int guessCanEject();
}
