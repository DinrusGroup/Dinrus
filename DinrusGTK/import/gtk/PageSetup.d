module gtkD.gtk.PageSetup;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.PaperSize;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.KeyFile;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkPageSetup object stores the page size, orientation and margins.
 * The idea is that you can get one of these from the page setup dialog
 * and then pass it to the GtkPrintOperation when printing.
 * The benefit of splitting this out of the GtkPrintSettings is that
 * these affect the actual layout of the page, and thus need to be set
 * long before user prints.
 * The margins specified in this object are the "print margins", i.e. the
 * parts of the page that the printer cannot print on. These are different
 * from the layout margins that a word processor uses; they are typically
 * used to determine the minimal size for the layout
 * margins.
 * To obtain a GtkPageSetup use gtk_page_setup_new()
 * to get the defaults, or use gtk_print_run_page_setup_dialog() to show
 * the page setup dialog and receive the resulting page setup.
 * Example 48. A page setup dialog
 * static GtkPrintSettings *settings = NULL;
 * static GtkPageSetup *page_setup = NULL;
 * static void
 * do_page_setup (void)
 * {
	 *  GtkPageSetup *new_page_setup;
	 *  if (settings == NULL)
	 *  settings = gtk_print_settings_new ();
	 *  new_page_setup = gtk_print_run_page_setup_dialog (GTK_WINDOW (main_window),
	 *  page_setup, settings);
	 *  if (page_setup)
	 *  g_object_unref (page_setup);
	 *  page_setup = new_page_setup;
 * }
 * Printing support was added in GTK+ 2.10.
 */
public class PageSetup : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkPageSetup* gtkPageSetup;
	
	
	public GtkPageSetup* getPageSetupStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPageSetup* gtkPageSetup);
	
	/**
	 */
	
	/**
	 * Creates a new GtkPageSetup.
	 * Since 2.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Copies a GtkPageSetup.
	 * Since 2.10
	 * Returns: a copy of other
	 */
	public PageSetup copy();
	
	/**
	 * Gets the page orientation of the GtkPageSetup.
	 * Since 2.10
	 * Returns: the page orientation
	 */
	public GtkPageOrientation getOrientation();
	
	/**
	 * Sets the page orientation of the GtkPageSetup.
	 * Since 2.10
	 * Params:
	 * orientation =  a GtkPageOrientation value
	 */
	public void setOrientation(GtkPageOrientation orientation);
	
	/**
	 * Gets the paper size of the GtkPageSetup.
	 * Since 2.10
	 * Returns: the paper size
	 */
	public PaperSize getPaperSize();
	
	/**
	 * Sets the paper size of the GtkPageSetup without
	 * changing the margins. See
	 * gtk_page_setup_set_paper_size_and_default_margins().
	 * Since 2.10
	 * Params:
	 * size =  a GtkPaperSize
	 */
	public void setPaperSize(PaperSize size);
	
	/**
	 * Gets the top margin in units of unit.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the top margin
	 */
	public double getTopMargin(GtkUnit unit);
	
	/**
	 * Sets the top margin of the GtkPageSetup.
	 * Since 2.10
	 * Params:
	 * margin =  the new top margin in units of unit
	 * unit =  the units for margin
	 */
	public void setTopMargin(double margin, GtkUnit unit);
	
	/**
	 * Gets the bottom margin in units of unit.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the bottom margin
	 */
	public double getBottomMargin(GtkUnit unit);
	
	/**
	 * Sets the bottom margin of the GtkPageSetup.
	 * Since 2.10
	 * Params:
	 * margin =  the new bottom margin in units of unit
	 * unit =  the units for margin
	 */
	public void setBottomMargin(double margin, GtkUnit unit);
	
	/**
	 * Gets the left margin in units of unit.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the left margin
	 */
	public double getLeftMargin(GtkUnit unit);
	
	/**
	 * Sets the left margin of the GtkPageSetup.
	 * Since 2.10
	 * Params:
	 * margin =  the new left margin in units of unit
	 * unit =  the units for margin
	 */
	public void setLeftMargin(double margin, GtkUnit unit);
	
	/**
	 * Gets the right margin in units of unit.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the right margin
	 */
	public double getRightMargin(GtkUnit unit);
	
	/**
	 * Sets the right margin of the GtkPageSetup.
	 * Since 2.10
	 * Params:
	 * margin =  the new right margin in units of unit
	 * unit =  the units for margin
	 */
	public void setRightMargin(double margin, GtkUnit unit);
	
	/**
	 * Sets the paper size of the GtkPageSetup and modifies
	 * the margins according to the new paper size.
	 * Since 2.10
	 * Params:
	 * size =  a GtkPaperSize
	 */
	public void setPaperSizeAndDefaultMargins(PaperSize size);
	
	/**
	 * Returns the paper width in units of unit.
	 * Note that this function takes orientation, but
	 * not margins into consideration.
	 * See gtk_page_setup_get_page_width().
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the paper width.
	 */
	public double getPaperWidth(GtkUnit unit);
	
	/**
	 * Returns the paper height in units of unit.
	 * Note that this function takes orientation, but
	 * not margins into consideration.
	 * See gtk_page_setup_get_page_height().
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the paper height.
	 */
	public double getPaperHeight(GtkUnit unit);
	
	/**
	 * Returns the page width in units of unit.
	 * Note that this function takes orientation and
	 * margins into consideration.
	 * See gtk_page_setup_get_paper_width().
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the page width.
	 */
	public double getPageWidth(GtkUnit unit);
	
	/**
	 * Returns the page height in units of unit.
	 * Note that this function takes orientation and
	 * margins into consideration.
	 * See gtk_page_setup_get_paper_height().
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the page height.
	 */
	public double getPageHeight(GtkUnit unit);
	
	/**
	 * Reads the page setup from the file file_name. Returns a
	 * new GtkPageSetup object with the restored page setup,
	 * or NULL if an error occurred. See gtk_page_setup_to_file().
	 * Since 2.12
	 * Params:
	 * fileName =  the filename to read the page setup from
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string fileName);
	
	/**
	 * Reads the page setup from the group group_name in the key file
	 * key_file. Returns a new GtkPageSetup object with the restored
	 * page setup, or NULL if an error occurred.
	 * Since 2.12
	 * Params:
	 * keyFile =  the GKeyFile to retrieve the page_setup from
	 * groupName =  the name of the group in the key_file to read, or NULL
	 *  to use the default name "Page Setup"
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (KeyFile keyFile, string groupName);
	
	/**
	 * Reads the page setup from the file file_name.
	 * See gtk_page_setup_to_file().
	 * Since 2.14
	 * Params:
	 * fileName =  the filename to read the page setup from
	 * Returns: TRUE on success
	 * Throws: GException on failure.
	 */
	public int loadFile(string fileName);
	
	/**
	 * Reads the page setup from the group group_name in the key file
	 * key_file.
	 * Since 2.14
	 * Params:
	 * keyFile =  the GKeyFile to retrieve the page_setup from
	 * groupName =  the name of the group in the key_file to read, or NULL
	 *  to use the default name "Page Setup"
	 * Returns: TRUE on success
	 * Throws: GException on failure.
	 */
	public int loadKeyFile(KeyFile keyFile, string groupName);
	
	/**
	 * This function saves the information from setup to file_name.
	 * Since 2.12
	 * Params:
	 * fileName =  the file to save to
	 * Returns: TRUE on success
	 * Throws: GException on failure.
	 */
	public int toFile(string fileName);
	
	/**
	 * This function adds the page setup from setup to key_file.
	 * Since 2.12
	 * Params:
	 * keyFile =  the GKeyFile to save the page setup to
	 * groupName =  the group to add the settings to in key_file,
	 *  or NULL to use the default name "Page Setup"
	 */
	public void toKeyFile(KeyFile keyFile, string groupName);
}
