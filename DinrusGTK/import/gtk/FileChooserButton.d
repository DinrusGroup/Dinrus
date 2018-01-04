module gtkD.gtk.FileChooserButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.FileChooserT;
private import gtkD.gtk.FileChooserIF;



private import gtkD.gtk.HBox;

/**
 * Description
 * The GtkFileChooserButton is a widget that lets the user select a
 * file. It implements the GtkFileChooser interface. Visually, it is a
 * file name with a button to bring up a GtkFileChooserDialog.
 * The user can then use that dialog to change the file associated with
 * that button. This widget does not support setting the "select-multiple"
 * property to TRUE.
 * Example 41. Create a button to let the user select a file in /etc
 * {
	 *  GtkWidget *button;
	 *  button = gtk_file_chooser_button_new (_("Select a file"),
	 *  GTK_FILE_CHOOSER_ACTION_OPEN);
	 *  gtk_file_chooser_set_current_folder (GTK_FILE_CHOOSER (button),
	 *  "/etc");
 * }
 * The GtkFileChooserButton supports the GtkFileChooserActions GTK_FILE_CHOOSER_ACTION_OPEN and GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER.
 * Important
 * The GtkFileChooserButton will ellipsize the label,
 * and thus will thus request little horizontal space. To give the button
 * more space, you should call gtk_widget_size_request(),
 * gtk_file_chooser_button_set_width_chars(), or pack the button in
 * such a way that other interface elements give space to the widget.
 */
public class FileChooserButton : HBox, FileChooserIF
{
	
	/** the main Gtk struct */
	protected GtkFileChooserButton* gtkFileChooserButton;
	
	
	public GtkFileChooserButton* getFileChooserButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFileChooserButton* gtkFileChooserButton);
	
	// add the FileChooser capabilities
	mixin FileChooserT!(GtkFileChooserButton);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(FileChooserButton)[] onFileSetListeners;
	/**
	 * The ::file-set signal is emitted when the user selects a file.
	 * Note that this signal is only emitted when the user
	 * changes the file.
	 * Since 2.12
	 * See Also
	 * GtkFileChooserDialog
	 */
	void addOnFileSet(void delegate(FileChooserButton) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackFileSet(GtkFileChooserButton* widgetStruct, FileChooserButton fileChooserButton);
	
	
	/**
	 * Creates a new file-selecting button widget.
	 * Since 2.6
	 * Params:
	 * title =  the title of the browse dialog.
	 * action =  the open mode for the widget.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, GtkFileChooserAction action);
	
	/**
	 * Warning
	 * gtk_file_chooser_button_new_with_backend has been deprecated since version 2.14 and should not be used in newly-written code. Use gtk_file_chooser_button_new() instead.
	 * Creates a new file-selecting button widget using backend.
	 * Since 2.6
	 * Params:
	 * title =  the title of the browse dialog.
	 * action =  the open mode for the widget.
	 * backend =  the name of the GtkFileSystem backend to use.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, GtkFileChooserAction action, string backend);
	
	/**
	 * Creates a GtkFileChooserButton widget which uses dialog as its
	 * file-picking window.
	 * Note that dialog must be a GtkDialog (or subclass) which
	 * implements the GtkFileChooser interface and must not have
	 * GTK_DIALOG_DESTROY_WITH_PARENT set.
	 * Also note that the dialog needs to have its confirmative button
	 * added with response GTK_RESPONSE_ACCEPT or GTK_RESPONSE_OK in
	 * order for the button to take over the file selected in the dialog.
	 * Since 2.6
	 * Params:
	 * dialog =  the widget to use as dialog
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Widget dialog);
	
	/**
	 * Retrieves the title of the browse dialog used by button. The returned value
	 * should not be modified or freed.
	 * Since 2.6
	 * Returns: a pointer to the browse dialog's title.
	 */
	public string getTitle();
	
	/**
	 * Modifies the title of the browse dialog used by button.
	 * Since 2.6
	 * Params:
	 * title =  the new browse dialog title.
	 */
	public void setTitle(string title);

	/**
	 * Retrieves the width in characters of the button widget's entry and/or label.
	 * Since 2.6
	 * Returns: an integer width (in characters) that the button will use to size itself.
	 */
	public int getWidthChars();
	
	/**
	 * Sets the width (in characters) that button will use to n_chars.
	 * Since 2.6
	 * Params:
	 * nChars =  the new width, in characters.
	 */
	public void setWidthChars(int nChars);
	
	/**
	 * Returns whether the button grabs focus when it is clicked with the mouse.
	 * See gtk_file_chooser_button_set_focus_on_click().
	 * Since 2.10
	 * Returns: TRUE if the button grabs focus when it is clicked with the mouse.
	 */
	public int getFocusOnClick();
	
	/**
	 * Sets whether the button will grab focus when it is clicked with the mouse.
	 * Making mouse clicks not grab focus is useful in places like toolbars where
	 * you don't want the keyboard focus removed from the main area of the
	 * application.
	 * Since 2.10
	 * Params:
	 * focusOnClick =  whether the button grabs focus when clicked with the mouse
	 */
	public void setFocusOnClick(int focusOnClick);
}
