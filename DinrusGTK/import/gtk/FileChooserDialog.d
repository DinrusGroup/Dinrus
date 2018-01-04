module gtkD.gtk.FileChooserDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Window;
private import gtkD.gtk.FileChooserT;
private import gtkD.gtk.FileChooserIF;



private import gtkD.gtk.Dialog;

/**
 * Description
 *  GtkFileChooserDialog is a dialog box suitable for use with
 *  "File/Open" or "File/Save as" commands. This widget works by
 *  putting a GtkFileChooserWidget inside a GtkDialog. It exposes
 *  the GtkFileChooserIface interface, so you can use all of the
 *  GtkFileChooser functions on the file chooser dialog as well as
 *  those for GtkDialog.
 *  Note that GtkFileChooserDialog does not have any methods of its
 *  own. Instead, you should use the functions that work on a
 *  GtkFileChooser.
 * Example 42. Typical usage
 * 	In the simplest of cases, you can the following code to use
 * 	GtkFileChooserDialog to select a file for opening:
 * GtkWidget *dialog;
 * dialog = gtk_file_chooser_dialog_new ("Open File",
 * 				 parent_window,
 * 				 GTK_FILE_CHOOSER_ACTION_OPEN,
 * 				 GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
 * 				 GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
 * 				 NULL);
 * if (gtk_dialog_run (GTK_DIALOG (dialog)) == GTK_RESPONSE_ACCEPT)
 *  {
	 *  char *filename;
	 *  filename = gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (dialog));
	 *  open_file (filename);
	 *  g_free (filename);
 *  }
 * gtk_widget_destroy (dialog);
 *  To use a dialog for saving, you can use this:
 * GtkWidget *dialog;
 * dialog = gtk_file_chooser_dialog_new ("Save File",
 * 				 parent_window,
 * 				 GTK_FILE_CHOOSER_ACTION_SAVE,
 * 				 GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
 * 				 GTK_STOCK_SAVE, GTK_RESPONSE_ACCEPT,
 * 				 NULL);
 * gtk_file_chooser_set_do_overwrite_confirmation (GTK_FILE_CHOOSER (dialog), TRUE);
 * if (user_edited_a_new_document)
 *  {
	 *  gtk_file_chooser_set_current_folder (GTK_FILE_CHOOSER (dialog), default_folder_for_saving);
	 *  gtk_file_chooser_set_current_name (GTK_FILE_CHOOSER (dialog), "Untitled document");
 *  }
 * else
 *  gtk_file_chooser_set_filename (GTK_FILE_CHOOSER (dialog), filename_for_existing_document);
 * if (gtk_dialog_run (GTK_DIALOG (dialog)) == GTK_RESPONSE_ACCEPT)
 *  {
	 *  char *filename;
	 *  filename = gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (dialog));
	 *  save_to_file (filename);
	 *  g_free (filename);
 *  }
 * gtk_widget_destroy (dialog);
 * Response Codes
 *  GtkFileChooserDialog inherits from GtkDialog, so buttons that
 *  go in its action area have response codes such as
 *  GTK_RESPONSE_ACCEPT and GTK_RESPONSE_CANCEL. For example, you
 *  could call gtk_file_chooser_dialog_new() as follows:
 * GtkWidget *dialog;
 * dialog = gtk_file_chooser_dialog_new ("Open File",
 * 				 parent_window,
 * 				 GTK_FILE_CHOOSER_ACTION_OPEN,
 * 				 GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
 * 				 GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
 * 				 NULL);
 *  This will create buttons for "Cancel" and "Open" that use stock
 *  response identifiers from GtkResponseType. For most dialog
 *  boxes you can use your own custom response codes rather than the
 *  ones in GtkResponseType, but GtkFileChooserDialog assumes that
 *  its "accept"-type action, e.g. an "Open" or "Save" button,
 *  will have one of the following response
 *  codes:
 * GTK_RESPONSE_ACCEPT
 * GTK_RESPONSE_OK
 * GTK_RESPONSE_YES
 * GTK_RESPONSE_APPLY
 *  This is because GtkFileChooserDialog must intercept responses
 *  and switch to folders if appropriate, rather than letting the
 *  dialog terminate — the implementation uses these known
 *  response codes to know which responses can be blocked if
 *  appropriate.
 * Note
 * 	To summarize, make sure you use a stock response
 * 	code when you use GtkFileChooserDialog to ensure
 * 	proper operation.
 */
public class FileChooserDialog : Dialog, FileChooserIF
{
	
	/** the main Gtk struct */
	protected GtkFileChooserDialog* gtkFileChooserDialog;
	
	
	public GtkFileChooserDialog* getFileChooserDialogStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFileChooserDialog* gtkFileChooserDialog);
	
	// add the FileChooser capabilities
	mixin FileChooserT!(GtkFileChooserDialog);
	
	/**
	 * Creates a new GtkFileChooserDialog. This function is analogous to
	 * gtk_dialog_new_with_buttons().
	 * Since 2.4
	 * Params:
	 *  title = Title of the dialog, or NULL
	 *  parent = Transient parent of the dialog, or NULL
	 *  action = Open or save mode for the dialog
	 *  buttonsText = text to go in the buttons
	 *  responses = response ID's for the buttons
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	this(string title, Window parent, FileChooserAction action,  string[] buttonsText=null, ResponseType[] responses=null);
	
	/**
	 * Creates a new GtkFileChooserDialog with a specified backend. This is
	 * especially useful if you use gtk_file_chooser_set_local_only() to allow
	 * non-local files and you use a more expressive vfs, such as gnome-vfs,
	 * to load files.
	 * Since 2.4
	 * Params:
	 *  title = Title of the dialog, or NULL
	 *  parent = Transient parent of the dialog, or NULL
	 *  action = Open or save mode for the dialog
	 *  backend = The name of the specific filesystem backend to use.
	 *  buttonsText = text to go in the buttons
	 *  responses = response ID's for the buttons
	 * See_Also:
	 *  GtkFileChooser, GtkDialog
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, Window parent, GtkFileChooserAction action, string backend,  string[] buttonsText=null, ResponseType[] responses=null);
	
	/**
	 */
}
