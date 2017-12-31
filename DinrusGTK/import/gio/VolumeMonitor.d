module gtkD.gio.VolumeMonitor;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gio.Drive;
private import gtkD.gio.DriveIF;
private import gtkD.gio.Mount;
private import gtkD.gio.MountIF;
private import gtkD.gio.Volume;
private import gtkD.gio.VolumeIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GVolumeMonitor is for listing the user interesting devices and volumes
 * on the computer. In other words, what a file selector or file manager
 * would show in a sidebar.
 * GVolumeMonitor is not thread-default-context
 * aware, and so should not be used other than from the main
 * thread, with no thread-default-context active.
 */
public class VolumeMonitor : ObjectG
{
	
	/** the main Gtk struct */
	protected GVolumeMonitor* gVolumeMonitor;
	
	
	public GVolumeMonitor* getVolumeMonitorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GVolumeMonitor* gVolumeMonitor);
	
	/**
	 * Gets the volume monitor used by gtkD.gio.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this();
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(DriveIF, VolumeMonitor)[] onDriveChangedListeners;
	/**
	 * Emitted when a drive changes.
	 */
	void addOnDriveChanged(void delegate(DriveIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDriveChanged(GVolumeMonitor* volumeMonitorStruct, GDrive* drive, VolumeMonitor volumeMonitor);
	
	void delegate(DriveIF, VolumeMonitor)[] onDriveConnectedListeners;
	/**
	 * Emitted when a drive is connected to the system.
	 */
	void addOnDriveConnected(void delegate(DriveIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDriveConnected(GVolumeMonitor* volumeMonitorStruct, GDrive* drive, VolumeMonitor volumeMonitor);
	
	void delegate(DriveIF, VolumeMonitor)[] onDriveDisconnectedListeners;
	/**
	 * Emitted when a drive is disconnected from the system.
	 */
	void addOnDriveDisconnected(void delegate(DriveIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDriveDisconnected(GVolumeMonitor* volumeMonitorStruct, GDrive* drive, VolumeMonitor volumeMonitor);
	
	void delegate(DriveIF, VolumeMonitor)[] onDriveEjectButtonListeners;
	/**
	 * Emitted when the eject button is pressed on drive.
	 * Since 2.18
	 */
	void addOnDriveEjectButton(void delegate(DriveIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDriveEjectButton(GVolumeMonitor* volumeMonitorStruct, GDrive* drive, VolumeMonitor volumeMonitor);
	
	void delegate(DriveIF, VolumeMonitor)[] onDriveStopButtonListeners;
	/**
	 * Emitted when the stop button is pressed on drive.
	 * Since 2.22
	 */
	void addOnDriveStopButton(void delegate(DriveIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDriveStopButton(GVolumeMonitor* volumeMonitorStruct, GDrive* drive, VolumeMonitor volumeMonitor);
	
	void delegate(MountIF, VolumeMonitor)[] onMountAddedListeners;
	/**
	 * Emitted when a mount is added.
	 */
	void addOnMountAdded(void delegate(MountIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMountAdded(GVolumeMonitor* volumeMonitorStruct, GMount* mount, VolumeMonitor volumeMonitor);
	
	void delegate(MountIF, VolumeMonitor)[] onMountChangedListeners;
	/**
	 * Emitted when a mount changes.
	 */
	void addOnMountChanged(void delegate(MountIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMountChanged(GVolumeMonitor* volumeMonitorStruct, GMount* mount, VolumeMonitor volumeMonitor);
	
	void delegate(MountIF, VolumeMonitor)[] onMountPreUnmountListeners;
	/**
	 * Emitted when a mount is about to be removed.
	 */
	void addOnMountPreUnmount(void delegate(MountIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMountPreUnmount(GVolumeMonitor* volumeMonitorStruct, GMount* mount, VolumeMonitor volumeMonitor);
	
	void delegate(MountIF, VolumeMonitor)[] onMountRemovedListeners;
	/**
	 * Emitted when a mount is removed.
	 */
	void addOnMountRemoved(void delegate(MountIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMountRemoved(GVolumeMonitor* volumeMonitorStruct, GMount* mount, VolumeMonitor volumeMonitor);
	
	void delegate(VolumeIF, VolumeMonitor)[] onVolumeAddedListeners;
	/**
	 * Emitted when a mountable volume is added to the system.
	 */
	void addOnVolumeAdded(void delegate(VolumeIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackVolumeAdded(GVolumeMonitor* volumeMonitorStruct, GVolume* volume, VolumeMonitor volumeMonitor);
	
	void delegate(VolumeIF, VolumeMonitor)[] onVolumeChangedListeners;
	/**
	 * Emitted when mountable volume is changed.
	 */
	void addOnVolumeChanged(void delegate(VolumeIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackVolumeChanged(GVolumeMonitor* volumeMonitorStruct, GVolume* volume, VolumeMonitor volumeMonitor);
	
	void delegate(VolumeIF, VolumeMonitor)[] onVolumeRemovedListeners;
	/**
	 * Emitted when a mountable volume is removed from the system.
	 * See Also
	 * #GFileMonitor
	 */
	void addOnVolumeRemoved(void delegate(VolumeIF, VolumeMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackVolumeRemoved(GVolumeMonitor* volumeMonitorStruct, GVolume* volume, VolumeMonitor volumeMonitor);
	
	
	/**
	 * Gets a list of drives connected to the system.
	 * The returned list should be freed with g_list_free(), after
	 * its elements have been unreffed with g_object_unref().
	 * Returns: a GList of connected GDrive objects.
	 */
	public ListG getConnectedDrives();
	
	/**
	 * Gets a list of the volumes on the system.
	 * The returned list should be freed with g_list_free(), after
	 * its elements have been unreffed with g_object_unref().
	 * Returns: a GList of GVolume objects.
	 */
	public ListG getVolumes();
	
	/**
	 * Gets a list of the mounts on the system.
	 * The returned list should be freed with g_list_free(), after
	 * its elements have been unreffed with g_object_unref().
	 * Returns: a GList of GMount objects.
	 */
	public ListG getMounts();
	
	/**
	 * Warning
	 * g_volume_monitor_adopt_orphan_mount has been deprecated since version 2.20 and should not be used in newly-written code. Instead of using this function, GVolumeMonitor
	 * implementations should instead create shadow mounts with the URI of
	 * the mount they intend to adopt. See the proxy volume monitor in
	 * gvfs for an example of this. Also see g_mount_is_shadowed(),
	 * g_mount_shadow() and g_mount_unshadow() functions.
	 * This function should be called by any GVolumeMonitor
	 * implementation when a new GMount object is created that is not
	 * associated with a GVolume object. It must be called just before
	 * emitting the mount_added signal.
	 * If the return value is not NULL, the caller must associate the
	 * returned GVolume object with the GMount. This involves returning
	 * it in its g_mount_get_volume() implementation. The caller must
	 * also listen for the "removed" signal on the returned object
	 * and give up its reference when handling that signal
	 * Similary, if implementing g_volume_monitor_adopt_orphan_mount(),
	 * the implementor must take a reference to mount and return it in
	 * its g_volume_get_mount() implemented. Also, the implementor must
	 * listen for the "unmounted" signal on mount and give up its
	 * reference upon handling that signal.
	 * There are two main use cases for this function.
	 * One is when implementing a user space file system driver that reads
	 * blocks of a block device that is already represented by the native
	 * volume monitor (for example a CD Audio file system driver). Such
	 * a driver will generate its own GMount object that needs to be
	 * assoicated with the GVolume object that represents the volume.
	 * The other is for implementing a GVolumeMonitor whose sole purpose
	 * is to return GVolume objects representing entries in the users
	 * "favorite servers" list or similar.
	 * Params:
	 * mount =  a GMount object to find a parent for
	 * Returns: the GVolume object that is the parent for mount or NULLif no wants to adopt the GMount.
	 */
	public static VolumeIF adoptOrphanMount(MountIF mount);
	
	/**
	 * Finds a GMount object by its UUID (see g_mount_get_uuid())
	 * Params:
	 * uuid =  the UUID to look for
	 * Returns: a GMount or NULL if no such mount is available. Free the returned object with g_object_unref().
	 */
	public MountIF getMountForUuid(string uuid);
	
	/**
	 * Finds a GVolume object by its UUID (see g_volume_get_uuid())
	 * Params:
	 * uuid =  the UUID to look for
	 * Returns: a GVolume or NULL if no such volume is available. Free the returned object with g_object_unref().Signal DetailsThe "drive-changed" signalvoid user_function (GVolumeMonitor *volume_monitor, GDrive *drive, gpointer user_data) : Run LastEmitted when a drive changes.
	 */
	public VolumeIF getVolumeForUuid(string uuid);
}
