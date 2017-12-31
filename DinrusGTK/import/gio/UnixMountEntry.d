
module gtkD.gio.UnixMountEntry;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;




/**
 * Description
 * Routines for managing mounted UNIX mount points and paths.
 * Note that <gio/gunixmounts.h> belongs to the
 * UNIX-specific GIO interfaces, thus you have to use the
 * gio-unix-2.0.pc pkg-config file when using it.
 */
public class UnixMountEntry
{
	
	/** the main Gtk struct */
	protected GUnixMountEntry* gUnixMountEntry;
	
	
	public GUnixMountEntry* getUnixMountEntryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixMountEntry* gUnixMountEntry);
	
	/**
	 */
	
	/**
	 * Frees a unix mount.
	 */
	public void free();
	
	/**
	 * Compares two unix mounts.
	 * Params:
	 * mount2 =  second GUnixMountEntry to compare.
	 * Returns: 1, 0 or -1 if mount1 is greater than, equal to,or less than mount2, respectively.
	 */
	public int compare(UnixMountEntry mount2);
	
	/**
	 * Gets the mount path for a unix mount.
	 * Returns: the mount path for mount_entry.
	 */
	public string getMountPath();
	
	/**
	 * Gets the device path for a unix mount.
	 * Returns: a string containing the device path.
	 */
	public string getDevicePath();
	
	/**
	 * Gets the filesystem type for the unix mount.
	 * Returns: a string containing the file system type.
	 */
	public string getFsType();
	
	/**
	 * Checks if a unix mount is mounted read only.
	 * Returns: TRUE if mount_entry is read only.
	 */
	public int isReadonly();
	
	/**
	 * Checks if a unix mount is a system path.
	 * Returns: TRUE if the unix mount is for a system path.
	 */
	public int isSystemInternal();
	
	/**
	 * Guesses the icon of a Unix mount.
	 * Returns: a GIcon
	 */
	public IconIF guessIcon();
	
	/**
	 * Guesses the name of a Unix mount.
	 * The result is a translated string.
	 * Returns: A newly allocated string that must be freed with g_free()
	 */
	public string guessName();
	
	/**
	 * Guesses whether a Unix mount can be ejected.
	 * Returns: TRUE if mount_entry is deemed to be ejectable.
	 */
	public int guessCanEject();
	
	/**
	 * Guesses whether a Unix mount should be displayed in the UI.
	 * Returns: TRUE if mount_entry is deemed to be displayable.
	 */
	public int guessShouldDisplay();
	
	/**
	 * Gets a GList of strings containing the unix mount points.
	 * If time_read is set, it will be filled with the mount timestamp,
	 * allowing for checking if the mounts have changed with
	 * g_unix_mounts_points_changed_since().
	 * Params:
	 * timeRead =  guint64 to contain a timestamp.
	 * Returns: a GList of the UNIX mountpoints.
	 */
	public static ListG pointsGet(ulong* timeRead);
	
	/**
	 * Gets a GList of strings containing the unix mounts.
	 * If time_read is set, it will be filled with the mount
	 * timestamp, allowing for checking if the mounts have changed
	 * with g_unix_mounts_changed_since().
	 * Params:
	 * timeRead =  guint64 to contain a timestamp.
	 * Returns: a GList of the UNIX mounts.
	 */
	public static ListG mountsGet(inout ulong timeRead);
	
	/**
	 * Gets a GUnixMountEntry for a given mount path. If time_read
	 * is set, it will be filled with a unix timestamp for checking
	 * if the mounts have changed since with g_unix_mounts_changed_since().
	 * Params:
	 * mountPath =  path for a possible unix mount.
	 * timeRead =  guint64 to contain a timestamp.
	 * Returns: a GUnixMount.
	 */
	public static UnixMountEntry at(string mountPath, inout ulong timeRead);
	
	/**
	 * Checks if the unix mounts have changed since a given unix time.
	 * Params:
	 * time =  guint64 to contain a timestamp.
	 * Returns: TRUE if the mounts have changed since time.
	 */
	public static int mountsChangedSince(ulong time);
	
	/**
	 * Checks if the unix mount points have changed since a given unix time.
	 * Params:
	 * time =  guint64 to contain a timestamp.
	 * Returns: TRUE if the mount points have changed since time.
	 */
	public static int pointsChangedSince(ulong time);
	
	/**
	 * Determines if mount_path is considered an implementation of the
	 * OS. This is primarily used for hiding mountable and mounted volumes
	 * that only are used in the OS and has little to no relevance to the
	 * casual user.
	 * Params:
	 * mountPath =  a mount path, e.g. /media/disk
	 *  or /usr
	 * Returns: TRUE if mount_path is considered an implementation detail  of the OS.Signal DetailsThe "mountpoints-changed" signalvoid user_function (GUnixMountMonitor *monitor, gpointer user_data) : Run LastEmitted when the unix mount points have changed.
	 */
	public static int isMountPathSystemInternal(string mountPath);
}
