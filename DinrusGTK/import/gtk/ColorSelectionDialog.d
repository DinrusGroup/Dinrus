
module gtkD.gtk.ColorSelectionDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;



private import gtkD.gtk.Dialog;

/**
 * Description
 * The GtkColorSelectionDialog provides a standard dialog which
 * allows the user to select a color much like the GtkFileSelection
 * provides a standard dialog for file selection.
 * GtkColorSelectionDialog as GtkBuildable
 * The GtkColorSelectionDialog implementation of the GtkBuildable interface
 * exposes the embedded GtkColorSelection as internal child with the
 * name "color_selection". It also exposes the buttons with the names
 * "ok_button", "cancel_button" and "help_button".
 */
public class ColorSelectionDialog : Dialog
{
	
	/** the main Gtk struct */
	protected GtkColorSelectionDialog* gtkColorSelectionDialog;
	
	
	public GtkColorSelectionDialog* getColorSelectionDialogStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkColorSelectionDialog* gtkColorSelectionDialog);
	
	/**
	 */
	
	/**
	 * Creates a new GtkColorSelectionDialog.
	 * Params:
	 * title = a string containing the title text for the dialog.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title);
	
	/**
	 * Retrieves the GtkColorSelection widget embedded in the dialog.
	 * Since 2.14
	 * Returns: the embedded GtkColorSelection
	 */
	public Widget getColorSelection();
}
