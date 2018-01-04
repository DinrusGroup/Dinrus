module gtkD.gtk.FileChooserWidget;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.FileChooserT;
private import gtkD.gtk.FileChooserIF;



private import gtkD.gtk.VBox;

/**
 * Description
 *  GtkFileChooserWidget is a widget suitable for selecting files.
 *  It is the main building block of a GtkFileChooserDialog. Most
 *  applications will only need to use the latter; you can use
 *  GtkFileChooserWidget as part of a larger window if you have
 *  special needs.
 *  Note that GtkFileChooserWidget does not have any methods of its
 *  own. Instead, you should use the functions that work on a
 *  GtkFileChooser.
 */
public class FileChooserWidget : VBox
{
	
	/** the main Gtk struct */
	protected GtkFileChooserWidget* gtkFileChooserWidget;
	
	
	public GtkFileChooserWidget* getFileChooserWidgetStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFileChooserWidget* gtkFileChooserWidget);
	
	// add the FileChooser capabilities
	mixin FileChooserT!(FileChooserWidget);
	
	/**
	 */
	
	/**
	 * Creates a new GtkFileChooserWidget. This is a file chooser widget that can
	 * be embedded in custom windows, and it is the same widget that is used by
	 * GtkFileChooserDialog.
	 * Since 2.4
	 * Params:
	 * action =  Open or save mode for the widget
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GtkFileChooserAction action);
	
	/**
	 * Warning
	 * gtk_file_chooser_widget_new_with_backend is deprecated and should not be used in newly-written code. 2.14
	 * Creates a new GtkFileChooserWidget with a specified backend. This is
	 * especially useful if you use gtk_file_chooser_set_local_only() to allow
	 * non-local files. This is a file chooser widget that can be embedded in
	 * custom windows and it is the same widget that is used by
	 * GtkFileChooserDialog.
	 * Since 2.4
	 * Params:
	 * action =  Open or save mode for the widget
	 * backend =  The name of the specific filesystem backend to use.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GtkFileChooserAction action, string backend);
}
