module gtkD.gtk.RecentChooserDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.Window;
private import gtkD.gtk.RecentManager;
private import gtkD.gtk.RecentChooserIF;
private import gtkD.gtk.RecentChooserT;



private import gtkD.gtk.Dialog;

/**
 * Description
 * GtkRecentChooserDialog is a dialog box suitable for displaying the recently
 * used documents. This widgets works by putting a GtkRecentChooserWidget inside
 * a GtkDialog. It exposes the GtkRecentChooserIface interface, so you can use
 * all the GtkRecentChooser functions on the recent chooser dialog as well as
 * those for GtkDialog.
 * Note that GtkRecentChooserDialog does not have any methods of its own.
 * Instead, you should use the functions that work on a GtkRecentChooser.
 * Example 57. Typical usage
 *  In the simplest of cases, you can use the following code to use
 *  a GtkRecentChooserDialog to select a recently used file:
 * GtkWidget *dialog;
 * dialog = gtk_recent_chooser_dialog_new ("Recent Documents",
 * 					parent_window,
 * 					GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL,
 * 					GTK_STOCK_OPEN, GTK_RESPONSE_ACCEPT,
 * 					NULL);
 * if (gtk_dialog_run (GTK_DIALOG (dialog)) == GTK_RESPONSE_ACCEPT)
 *  {
	 *  GtkRecentInfo *info;
	 *  info = gtk_recent_chooser_get_current_item (GTK_RECENT_CHOOSER (dialog));
	 *  open_file (gtk_recent_info_get_uri (info));
	 *  gtk_recent_info_unref (info);
 *  }
 * gtk_widget_destroy (dialog);
 * Recently used files are supported since GTK+ 2.10.
 */
public class RecentChooserDialog : Dialog, RecentChooserIF
{
	
	/** the main Gtk struct */
	protected GtkRecentChooserDialog* gtkRecentChooserDialog;
	
	
	public GtkRecentChooserDialog* getRecentChooserDialogStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkRecentChooserDialog* gtkRecentChooserDialog);
	
	// add the RecentChooser capabilities
	mixin RecentChooserT!(GtkRecentChooserDialog);
	
	/**
	 * Creates a new GtkRecentChooserDialog with a specified recent manager.
	 * This is useful if you have implemented your own recent manager, or if you
	 * have a customized instance of a GtkRecentManager object.
	 * Since 2.10
	 * Params:
	 *  title =  Title of the dialog, or null
	 *  parent =  Transient parent of the dialog, or null,
	 *  manager =  a GtkRecentManager, or null
	 *  buttonsText = text to go in the buttons
	 *  responses = response ID's for the buttons
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, Window parent, RecentManager manager,  string[] buttonsText=null, ResponseType[] responses=null );
	
	/**
	 * Creates a new GtkRecentChooserDialog with a specified recent manager.
	 * This is useful if you have implemented your own recent manager, or if you
	 * have a customized instance of a GtkRecentManager object.
	 * Since 2.10
	 * Params:
	 *  title =  Title of the dialog, or null
	 *  parent =  Transient parent of the dialog, or null,
	 *  manager =  a GtkRecentManager, or null
	 *  stockIDs = stockIDs of the buttons
	 *  responses = response ID's for the buttons
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, Window parent, RecentManager manager,  StockID[] stockIDs, ResponseType[] responses=null );
	
	/**
	 */
}
