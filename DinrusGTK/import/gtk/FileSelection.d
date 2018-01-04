module gtkD.gtk.FileSelection;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gtk.Dialog;

/**
 * Description
 * GtkFileSelection has been superseded by the newer GtkFileChooser family
 * of widgets.
 * GtkFileSelection should be used to retrieve file or directory names from
 * the user. It will create a new dialog window containing a directory list,
 * and a file list corresponding to the current working directory. The filesystem
 * can be navigated using the directory list or the drop-down history menu.
 * Alternatively, the TAB key can be used to navigate using filename
 * completion - common in text based editors such as emacs and jed.
 * File selection dialogs are created with a call to gtk_file_selection_new().
 * The default filename can be set using gtk_file_selection_set_filename() and the selected filename retrieved using gtk_file_selection_get_filename().
 * Use gtk_file_selection_complete() to display files and directories
 * that match a given pattern. This can be used for example, to show only
 * *.txt files, or only files beginning with gtk*.
 * Simple file operations; create directory, delete file, and rename file, are available from buttons at the top of the dialog. These can be hidden using gtk_file_selection_hide_fileop_buttons() and shown again using gtk_file_selection_show_fileop_buttons().
 * Example 61. Getting a filename from the user.
 * /+* The file selection widget and the string to store the chosen filename +/
 * void store_filename (GtkWidget *widget, gpointer user_data) {
	 *  GtkWidget *file_selector = GTK_WIDGET (user_data);
	 *  const gchar *selected_filename;
	 *  selected_filename = gtk_file_selection_get_filename (GTK_FILE_SELECTION (file_selector));
	 *  g_print ("Selected filename: %s\n", selected_filename);
 * }
 * void create_file_selection (void) {
	 *  GtkWidget *file_selector;
	 *  /+* Create the selector +/
	 *  file_selector = gtk_file_selection_new ("Please select a file for editing.");
	 *  g_signal_connect (GTK_FILE_SELECTION (file_selector)->ok_button,
	 *  "clicked",
	 *  G_CALLBACK (store_filename),
	 *  file_selector);
	 *  /+* Ensure that the dialog box is destroyed when the user clicks a button. +/
	 *  g_signal_connect_swapped (GTK_FILE_SELECTION (file_selector)->ok_button,
	 *  "clicked",
	 *  G_CALLBACK (gtk_widget_destroy),
	 *  file_selector);
	 *  g_signal_connect_swapped (GTK_FILE_SELECTION (file_selector)->cancel_button,
	 *  "clicked",
	 *  G_CALLBACK (gtk_widget_destroy),
	 *  file_selector);
	 *  /+* Display that dialog +/
	 *  gtk_widget_show (file_selector);
 * }
 */
public class FileSelection : Dialog
{
	
	/** the main Gtk struct */
	protected GtkFileSelection* gtkFileSelection;
	
	
	public GtkFileSelection* getFileSelectionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFileSelection* gtkFileSelection);
	
	/**
	 */
	
	/**
	 * Warning
	 * gtk_file_selection_new is deprecated and should not be used in newly-written code. Use gtk_file_chooser_dialog_new() instead
	 * Creates a new file selection dialog box. By default it will contain a GtkTreeView of the application's current working directory, and a file listing. Operation buttons that allow the user to create a directory, delete files and rename files, are also present.
	 * Params:
	 * title = a message that will be placed in the file requestor's titlebar.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title);
	
	/**
	 * Warning
	 * gtk_file_selection_set_filename is deprecated and should not be used in newly-written code.
	 * Sets a default path for the file requestor. If filename includes a
	 * directory path, then the requestor will open with that path as its
	 * current working directory.
	 * This has the consequence that in order to open the requestor with a
	 * working directory and an empty filename, filename must have a trailing
	 * directory separator.
	 * The encoding of filename is preferred GLib file name encoding, which
	 * may not be UTF-8. See g_filename_from_utf8().
	 * Params:
	 * filename =  a string to set as the default file name.
	 */
	public void setFilename(string filename);
	
	/**
	 * Warning
	 * gtk_file_selection_get_filename is deprecated and should not be used in newly-written code.
	 * This function returns the selected filename in the GLib file name
	 * encoding. To convert to UTF-8, call g_filename_to_utf8(). The
	 * returned string points to a statically allocated buffer and should
	 * be copied if you plan to keep it around.
	 * If no file is selected then the selected directory path is returned.
	 * Returns: currently-selected filename in the on-disk encoding.
	 */
	public string getFilename();
	
	/**
	 * Warning
	 * gtk_file_selection_complete is deprecated and should not be used in newly-written code.
	 * Will attempt to match pattern to a valid filenames or subdirectories in the current directory. If a match can be made, the matched filename will appear in the text entry field of the file selection dialog.
	 * If a partial match can be made, the "Files" list will contain those
	 * file names which have been partially matched, and the "Folders"
	 * list those directories which have been partially matched.
	 * Params:
	 * pattern = a string of characters which may or may not match any filenames in the current directory.
	 */
	public void complete(string pattern);
	
	/**
	 * Warning
	 * gtk_file_selection_show_fileop_buttons is deprecated and should not be used in newly-written code.
	 * Shows the file operation buttons, if they have previously been hidden. The rest of the widgets in the dialog will be resized accordingly.
	 */
	public void showFileopButtons();
	
	/**
	 * Warning
	 * gtk_file_selection_hide_fileop_buttons is deprecated and should not be used in newly-written code.
	 * Hides the file operation buttons that normally appear at the top of the dialog. Useful if you wish to create a custom file selector, based on GtkFileSelection.
	 */
	public void hideFileopButtons();
	
	/**
	 * Warning
	 * gtk_file_selection_get_selections is deprecated and should not be used in newly-written code.
	 * Retrieves the list of file selections the user has made in the dialog box.
	 * This function is intended for use when the user can select multiple files
	 * in the file list.
	 * The filenames are in the GLib file name encoding. To convert to
	 * UTF-8, call g_filename_to_utf8() on each string.
	 * Returns: a newly-allocated NULL-terminated array of strings. Useg_strfreev() to free it.
	 */
	public string[] getSelections();
	
	/**
	 * Warning
	 * gtk_file_selection_set_select_multiple is deprecated and should not be used in newly-written code.
	 * Sets whether the user is allowed to select multiple files in the file list.
	 * Use gtk_file_selection_get_selections() to get the list of selected files.
	 * Params:
	 * selectMultiple =  whether or not the user is allowed to select multiple
	 * files in the file list.
	 */
	public void setSelectMultiple(int selectMultiple);
	
	/**
	 * Warning
	 * gtk_file_selection_get_select_multiple is deprecated and should not be used in newly-written code.
	 * Determines whether or not the user is allowed to select multiple files in
	 * the file list. See gtk_file_selection_set_select_multiple().
	 * Returns: TRUE if the user is allowed to select multiple files in thefile list
	 */
	public int getSelectMultiple();
}
