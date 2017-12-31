
module gtkD.gio.UnixMountMonitor;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;




private import gtkD.gobject.ObjectG;

/**
 * Description
 * Routines for managing mounted UNIX mount points and paths.
 * Note that <gio/gunixmounts.h> belongs to the
 * UNIX-specific GIO interfaces, thus you have to use the
 * gio-unix-2.0.pc pkg-config file when using it.
 */
public class UnixMountMonitor : ObjectG
{
	
	/** the main Gtk struct */
	protected GUnixMountMonitor* gUnixMountMonitor;
	
	
	public GUnixMountMonitor* getUnixMountMonitorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixMountMonitor* gUnixMountMonitor);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(UnixMountMonitor)[] onMountpointsChangedListeners;
	/**
	 * Emitted when the unix mount points have changed.
	 */
	void addOnMountpointsChanged(void delegate(UnixMountMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMountpointsChanged(GUnixMountMonitor* monitorStruct, UnixMountMonitor unixMountMonitor);
	
	void delegate(UnixMountMonitor)[] onMountsChangedListeners;
	/**
	 * Emitted when the unix mounts have changed.
	 */
	void addOnMountsChanged(void delegate(UnixMountMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMountsChanged(GUnixMountMonitor* monitorStruct, UnixMountMonitor unixMountMonitor);
	
	
	/**
	 * Gets a new GUnixMountMonitor. The default rate limit for which the
	 * monitor will report consecutive changes for the mount and mount
	 * point entry files is the default for a GFileMonitor. Use
	 * g_unix_mount_monitor_set_rate_limit() to change this.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets the rate limit to which the mount_monitor will report
	 * consecutive change events to the mount and mount point entry files.
	 * Since 2.18
	 * Params:
	 * limitMsec =  a integer with the limit in milliseconds to
	 *  poll for changes.
	 */
	public void setRateLimit(int limitMsec);
}
