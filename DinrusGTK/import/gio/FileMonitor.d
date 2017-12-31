module gtkD.gio.FileMonitor;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gio.File;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Monitors a file or directory for changes.
 * To obtain a GFileMonitor for a file or directory, use
 * g_file_monitor(), g_file_monitor_file(), or
 * g_file_monitor_directory().
 * To get informed about changes to the file or directory you are
 * monitoring, connect to the "changed" signal. The
 * signal will be emitted in the thread-default main
 * context of the thread that the monitor was created in
 * (though if the global default main context is blocked, this may
 * cause notifications to be blocked even if the thread-default
 * context is still running).
 */
public class FileMonitor : ObjectG
{
	
	/** the main Gtk struct */
	protected GFileMonitor* gFileMonitor;
	
	
	public GFileMonitor* getFileMonitorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFileMonitor* gFileMonitor);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(File, File, GFileMonitorEvent, FileMonitor)[] onChangedListeners;
	/**
	 * Emitted when a file has been changed.
	 */
	void addOnChanged(void delegate(File, File, GFileMonitorEvent, FileMonitor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChanged(GFileMonitor* monitorStruct, GFile* file, GFile* otherFile, GFileMonitorEvent eventType, FileMonitor fileMonitor);
	
	
	/**
	 * Cancels a file monitor.
	 * Returns: TRUE if monitor was cancelled.
	 */
	public int cancel();
	
	/**
	 * Returns whether the monitor is canceled.
	 * Returns: TRUE if monitor is canceled. FALSE otherwise.
	 */
	public int isCancelled();
	
	/**
	 * Sets the rate limit to which the monitor will report
	 * consecutive change events to the same file.
	 * Params:
	 * limitMsecs =  a integer with the limit in milliseconds to
	 * poll for changes.
	 */
	public void setRateLimit(int limitMsecs);
	
	/**
	 * Emits the "changed" signal if a change
	 * has taken place. Should be called from file monitor
	 * implementations only.
	 * The signal will be emitted from an idle handler (in the thread-default main
	 * context).
	 * Params:
	 * child =  a GFile.
	 * otherFile =  a GFile.
	 * eventType =  a set of GFileMonitorEvent flags.
	 */
	public void emitEvent(File child, File otherFile, GFileMonitorEvent eventType);
}
