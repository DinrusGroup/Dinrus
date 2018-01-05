module gtkD.gtk.PrintUnixDialog;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.Window;
private import gtkD.gtk.Printer;
private import gtkD.gtk.PageSetup;
private import gtkD.gtk.PrintSettings;



private import gtkD.gtk.Dialog;

/**
 * Description
 * GtkPrintUnixDialog implements a print dialog for platforms
 * which don't provide a native print dialog, like Unix. It can
 * be used very much like any other GTK+ dialog, at the cost of
 * the portability offered by the high-level printing API
 * In order to print something with GtkPrintUnixDialog, you need
 * to use gtk_print_unix_dialog_get_selected_printer() to obtain
 * a GtkPrinter object and use it to construct a GtkPrintJob using
 * gtk_print_job_new().
 * GtkPrintUnixDialog uses the following response values:
 * GTK_RESPONSE_OK
 * for the "Print" button
 * GTK_RESPONSE_APPLY
 * for the "Preview" button
 * GTK_RESPONSE_CANCEL
 * for the "Cancel" button
 * Printing support was added in GTK+ 2.10.
 * GtkPrintUnixDialog as GtkBuildable
 * The GtkPrintUnixDialog implementation of the GtkBuildable interface exposes its
 * notebook internal children with the name "notebook".
 * Example 49. A GtkPrintUnixDialog UI definition fragment.
 * <object class="GtkPrintUnixDialog" id="dialog1">
 *  <child internal-child="notebook">
 *  <object class="GtkNotebook" id="notebook">
 *  <child>
 *  <object class="GtkLabel" id="tabcontent">
 *  <property name="label">Content on notebook tab</property>
 *  </object>
 *  </child>
 *  <child type="tab">
 *  <object class="GtkLabel" id="tablabel">
 *  <property name="label">Tab label</property>
 *  </object>
 *  <packing>
 *  <property name="tab_expand">False</property>
 *  <property name="tab_fill">False</property>
 *  </packing>
 *  </child>
 *  </object>
 *  </child>
 * </object>
 */
public class PrintUnixDialog : Dialog
{
	
	/** the main Gtk struct */
	protected GtkPrintUnixDialog* gtkPrintUnixDialog;
	
	
	public GtkPrintUnixDialog* getPrintUnixDialogStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPrintUnixDialog* gtkPrintUnixDialog);
	
	/**
	 */
	
	/**
	 * Creates a new GtkPrintUnixDialog.
	 * Since 2.10
	 * Params:
	 * title =  Title of the dialog, or NULL
	 * parent =  Transient parent of the dialog, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, Window parent);
	
	/**
	 * Sets the page setup of the GtkPrintUnixDialog.
	 * Since 2.10
	 * Params:
	 * pageSetup =  a GtkPageSetup
	 */
	public void setPageSetup(PageSetup pageSetup);
	/**
	 * Gets the page setup that is used by the GtkPrintUnixDialog.
	 * Since 2.10
	 * Returns: the page setup of dialog.
	 */
	public PageSetup getPageSetup();
	
	/**
	 * Sets the current page number. If current_page is not -1, this enables
	 * the current page choice for the range of pages to print.
	 * Since 2.10
	 * Params:
	 * currentPage =  the current page number.
	 */
	public void setCurrentPage(int currentPage);
	
	/**
	 * Gets the current page of the GtkPrintDialog.
	 * Since 2.10
	 * Returns: the current page of dialog
	 */
	public int getCurrentPage();
	
	/**
	 * Sets the GtkPrintSettings for the GtkPrintUnixDialog. Typically,
	 * this is used to restore saved print settings from a previous print
	 * operation before the print dialog is shown.
	 * Since 2.10
	 * Params:
	 * settings =  a GtkPrintSettings, or NULL
	 */
	public void setPrintSettings(PrintSettings settings);
	
	/**
	 * Gets a new GtkPrintSettings object that represents the
	 * current values in the print dialog. Note that this creates a
	 * new object, and you need to unref it
	 * if don't want to keep it.
	 * Since 2.10
	 * Returns: a new GtkPrintSettings object with the values from dialog
	 */
	public PrintSettings getPrintSettings();
	
	/**
	 * Gets the currently selected printer.
	 * Since 2.10
	 * Returns: the currently selected printer
	 */
	public Printer getSelectedPrinter();
	
	/**
	 * Adds a custom tab to the print dialog.
	 * Since 2.10
	 * Params:
	 * child =  the widget to put in the custom tab
	 * tabLabel =  the widget to use as tab label
	 */
	public void addCustomTab(Widget child, Widget tabLabel);
	
	/**
	 * Sets whether the print dialog allows user to print a selection.
	 * Since 2.18
	 * Params:
	 * supportSelection =  TRUE to allow print selection
	 */
	public void setSupportSelection(int supportSelection);

	/**
	 * Gets the value of "support-selection" property.
	 * Since 2.18
	 * Returns: whether the application supports print of selection
	 */
	public int getSupportSelection();
	
	/**
	 * Sets whether a selection exists.
	 * Since 2.18
	 * Params:
	 * hasSelection =  TRUE indicates that a selection exists
	 */
	public void setHasSelection(int hasSelection);
	
	/**
	 * Gets the value of "has-selection" property.
	 * Since 2.18
	 * Returns: whether there is a selection
	 */
	public int getHasSelection();
	
	/**
	 * Embed page size combo box and orientation combo box into page setup page.
	 * Since 2.18
	 * Params:
	 * embed =  embed page setup selection
	 */
	public void setEmbedPageSetup(int embed);
	
	/**
	 * Gets the value of "embed-page-setup" property.
	 * Since 2.18
	 * Returns: whether there is a selection
	 */
	public int getEmbedPageSetup();
	
	/**
	 * Gets the page setup that is used by the GtkPrintUnixDialog.
	 * Since 2.18
	 * Returns: whether a page setup was set by user.
	 */
	public int getPageSetupSet();
	
	/**
	 * This lets you specify the printing capabilities your application
	 * supports. For instance, if you can handle scaling the output then
	 * you pass GTK_PRINT_CAPABILITY_SCALE. If you don't pass that, then
	 * the dialog will only let you select the scale if the printing
	 * system automatically handles scaling.
	 * Since 2.10
	 * Params:
	 * capabilities =  the printing capabilities of your application
	 */
	public void setManualCapabilities(GtkPrintCapabilities capabilities);
	
	/**
	 * Gets the value of "manual-capabilities" property.
	 * Since 2.18
	 * Returns: the printing capabilities
	 */
	public GtkPrintCapabilities getManualCapabilities();
}
