module gtkD.gtk.PageSetupUnixDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.Window;
private import gtkD.gtk.PageSetup;
private import gtkD.gtk.PrintSettings;



private import gtkD.gtk.Dialog;

/**
 * Description
 * GtkPageSetupUnixDialog implements a page setup dialog for platforms
 * which don't provide a native page setup dialog, like Unix. It can
 * be used very much like any other GTK+ dialog, at the cost of
 * the portability offered by the high-level printing API
 * Printing support was added in GTK+ 2.10.
 */
public class PageSetupUnixDialog : Dialog
{
	
	/** the main Gtk struct */
	protected GtkPageSetupUnixDialog* gtkPageSetupUnixDialog;
	
	
	public GtkPageSetupUnixDialog* getPageSetupUnixDialogStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPageSetupUnixDialog* gtkPageSetupUnixDialog);
	
	/**
	 */
	
	/**
	 * Creates a new page setup dialog.
	 * Since 2.10
	 * Params:
	 * title =  the title of the dialog, or NULL
	 * parent =  transient parent of the dialog, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, Window parent);
	
	/**
	 * Sets the GtkPageSetup from which the page setup
	 * dialog takes its values.
	 * Since 2.10
	 * Params:
	 * pageSetup =  a GtkPageSetup
	 */
	public void setPageSetup(PageSetup pageSetup);
	
	/**
	 * Gets the currently selected page setup from the dialog.
	 * Since 2.10
	 * Returns: the current page setup
	 */
	public PageSetup getPageSetup();
	
	/**
	 * Sets the GtkPrintSettings from which the page setup dialog
	 * takes its values.
	 * Since 2.10
	 * Params:
	 * printSettings =  a GtkPrintSettings
	 */
	public void setPrintSettings(PrintSettings printSettings);
	
	/**
	 * Gets the current print settings from the dialog.
	 * Since 2.10
	 * Returns: the current print settings
	 */
	public PrintSettings getPrintSettings();
}
