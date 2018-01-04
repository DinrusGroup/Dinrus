module gtkD.gtk.InputDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.Button;



private import gtkD.gtk.Dialog;

/**
 * Description
 *  NOTE this widget is considered too specialized/little-used for
 *  GTK+, and will in the future be moved to some other package. If
 *  your application needs this widget, feel free to use it, as the
 *  widget does work and is useful in some applications; it's just not
 *  of general interest. However, we are not accepting new features for
 *  the widget, and it will eventually move out of the GTK+
 *  distribution.
 * GtkInputDialog displays a dialog which allows the user
 * to configure XInput extension devices. For each
 * device, they can control the mode of the device
 * (disabled, screen-relative, or window-relative),
 * the mapping of axes to coordinates, and the
 * mapping of the devices macro keys to key press
 * events.
 * GtkInputDialog contains two buttons to which
 * the application can connect; one for closing
 * the dialog, and one for saving the changes.
 * No actions are bound to these by default.
 * The changes that the user makes take effect
 * immediately.
 */
public class InputDialog : Dialog
{
	
	/** the main Gtk struct */
	protected GtkInputDialog* gtkInputDialog;
	
	
	public GtkInputDialog* getInputDialogStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkInputDialog* gtkInputDialog);
	
	Button getCloseButton();
	
	Button getSaveButton();
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(GdkDevice*, InputDialog)[] onDisableDeviceListeners;
	/**
	 * This signal is emitted when the user changes the
	 * mode of a device from a GDK_MODE_SCREEN or GDK_MODE_WINDOW
	 * to GDK_MODE_ENABLED.
	 */
	void addOnDisableDevice(void delegate(GdkDevice*, InputDialog) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDisableDevice(GtkInputDialog* inputdialogStruct, GdkDevice* deviceid, InputDialog inputDialog);
	
	void delegate(GdkDevice*, InputDialog)[] onEnableDeviceListeners;
	/**
	 * This signal is emitted when the user changes the
	 * mode of a device from GDK_MODE_DISABLED to a
	 * GDK_MODE_SCREEN or GDK_MODE_WINDOW.
	 */
	void addOnEnableDevice(void delegate(GdkDevice*, InputDialog) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackEnableDevice(GtkInputDialog* inputdialogStruct, GdkDevice* deviceid, InputDialog inputDialog);
	
	
	/**
	 * Creates a new GtkInputDialog.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
