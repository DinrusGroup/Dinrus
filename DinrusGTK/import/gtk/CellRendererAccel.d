module gtkD.gtk.CellRendererAccel;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.CellRenderer;



private import gtkD.gtk.CellRendererText;

/**
 * Description
 * GtkCellRendererAccel displays a keyboard accelerator (i.e. a
 * key combination like <Control>-a). If the cell renderer is editable, the
 * accelerator can be changed by simply typing the new combination.
 * The GtkCellRendererAccel cell renderer was added in GTK+ 2.10.
 */
public class CellRendererAccel : CellRendererText
{

	/** the main Gtk struct */
	protected GtkCellRendererAccel* gtkCellRendererAccel;


	public GtkCellRendererAccel* getCellRendererAccelStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCellRendererAccel* gtkCellRendererAccel);

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(string, CellRendererAccel)[] onAccelClearedListeners;
	/**
	 * Gets emitted when the user has removed the accelerator.
	 * Since 2.10
	 */
	void addOnAccelCleared(void delegate(string, CellRendererAccel) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAccelCleared(GtkCellRendererAccel* accelStruct, gchar* pathString, CellRendererAccel cellRendererAccel);

	void delegate(string, guint, GdkModifierType, guint, CellRendererAccel)[] onAccelEditedListeners;
	/**
	 * Gets emitted when the user has selected a new accelerator.
	 * Since 2.10
	 */
	void addOnAccelEdited(void delegate(string, guint, GdkModifierType, guint, CellRendererAccel) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAccelEdited(GtkCellRendererAccel* accelStruct, gchar* pathString, guint accelKey, GdkModifierType accelMods, guint hardwareKeycode, CellRendererAccel cellRendererAccel);


	/**
	 * Creates a new GtkCellRendererAccel.
	 * Since 2.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
