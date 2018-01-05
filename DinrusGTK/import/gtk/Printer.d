module gtkD.gtk.Printer;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.PageSetup;
private import gtkD.glib.ListG;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkPrinter object represents a printer. You only need to
 * deal directly with printers if you use the non-portable
 * GtkPrintUnixDialog API.
 * A GtkPrinter allows to get status information about the printer,
 * such as its description, its location, the number of queued jobs,
 * etc. Most importantly, a GtkPrinter object can be used to create
 * a GtkPrintJob object, which lets you print to the printer.
 * Printing support was added in GTK+ 2.10.
 */
public class Printer : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkPrinter* gtkPrinter;
	
	
	public GtkPrinter* getPrinterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPrinter* gtkPrinter);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(gboolean, Printer)[] onDetailsAcquiredListeners;
	/**
	 * Gets emitted in response to a request for detailed information
	 * about a printer from the print backend. The success parameter
	 * indicates if the information was actually obtained.
	 * Since 2.10
	 */
	void addOnDetailsAcquired(void delegate(gboolean, Printer) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDetailsAcquired(GtkPrinter* printerStruct, gboolean success, Printer printer);
	
	
	/**
	 * Creates a new GtkPrinter.
	 * Since 2.10
	 * Params:
	 * name =  the name of the printer
	 * backend =  a GtkPrintBackend
	 * virtual =  whether the printer is virtual
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, GtkPrintBackend* backend, int virtual);
	
	/**
	 * Returns the backend of the printer.
	 * Since 2.10
	 * Returns: the backend of printer
	 */
	public GtkPrintBackend* getBackend();
	
	/**
	 * Returns the name of the printer.
	 * Since 2.10
	 * Returns: the name of printer
	 */
	public string getName();
	
	/**
	 * Returns the state message describing the current state
	 * of the printer.
	 * Since 2.10
	 * Returns: the state message of printer
	 */
	public string getStateMessage();
	
	/**
	 * Gets the description of the printer.
	 * Since 2.10
	 * Returns: the description of printer
	 */
	public string getDescription();
	
	/**
	 * Returns a description of the location of the printer.
	 * Since 2.10
	 * Returns: the location of printer
	 */
	public string getLocation();
	
	/**
	 * Gets the name of the icon to use for the printer.
	 * Since 2.10
	 * Returns: the icon name for printer
	 */
	public string getIconName();
	
	/**
	 * Gets the number of jobs currently queued on the printer.
	 * Since 2.10
	 * Returns: the number of jobs on printer
	 */
	public int getJobCount();
	
	/**
	 * Returns whether the printer is currently active (i.e.
	 * accepts new jobs).
	 * Since 2.10
	 * Returns: TRUE if printer is active
	 */
	public int isActive();
	
	/**
	 * Returns whether the printer is currently paused.
	 * A paused printer still accepts jobs, but it is not
	 * printing them.
	 * Since 2.14
	 * Returns: TRUE if printer is paused
	 */
	public int isPaused();
	
	/**
	 * Returns whether the printer is accepting jobs
	 * Since 2.14
	 * Returns: TRUE if printer is accepting jobs
	 */
	public int isAcceptingJobs();
	
	/**
	 * Returns whether the printer is virtual (i.e. does not
	 * represent actual printer hardware, but something like
	 * a CUPS class).
	 * Since 2.10
	 * Returns: TRUE if printer is virtual
	 */
	public int isVirtual();
	
	/**
	 * Returns whether the printer is the default printer.
	 * Since 2.10
	 * Returns: TRUE if printer is the default
	 */
	public int isDefault();

	/**
	 * Returns whether the printer accepts input in
	 * PostScript format.
	 * Since 2.10
	 * Returns: TRUE if printer accepts PostScript
	 */
	public int acceptsPs();
	
	/**
	 * Returns whether the printer accepts input in
	 * PDF format.
	 * Since 2.10
	 * Returns: TRUE if printer accepts PDF
	 */
	public int acceptsPdf();
	
	/**
	 * Lists all the paper sizes printer supports.
	 * This will return and empty list unless the printer's details are
	 * available, see gtk_printer_has_details() and gtk_printer_request_details().
	 * Since 2.12
	 * Returns: a newly allocated list of newly allocated GtkPageSetup s.
	 */
	public ListG listPapers();
	
	/**
	 * Compares two printers.
	 * Since 2.10
	 * Params:
	 * a =  a GtkPrinter
	 * b =  another GtkPrinter
	 * Returns: 0 if the printer match, a negative value if a < b,  or a positive value if a > b
	 */
	public int compare(Printer b);
	
	/**
	 * Returns whether the printer details are available.
	 * Since 2.12
	 * Returns: TRUE if printer details are available
	 */
	public int hasDetails();
	
	/**
	 * Requests the printer details. When the details are available,
	 * the "details-acquired" signal will be emitted on printer.
	 * Since 2.12
	 */
	public void requestDetails();
	
	/**
	 * Returns the printer's capabilities.
	 * This is useful when you're using GtkPrintUnixDialog's manual-capabilities
	 * setting and need to know which settings the printer can handle and which
	 * you must handle yourself.
	 * This will return 0 unless the printer's details are available, see
	 * gtk_printer_has_details() and gtk_printer_request_details().
	 *  *
	 * Since 2.12
	 * Returns: the printer's capabilities
	 */
	public GtkPrintCapabilities getCapabilities();
	
	/**
	 * Returns default page size of printer.
	 * Since 2.13
	 * Returns: a newly allocated GtkPageSetup with default page size of the printer.
	 */
	public PageSetup getDefaultPageSize();
	
	/**
	 * Calls a function for all GtkPrinters.
	 * If func returns TRUE, the enumeration is stopped.
	 * Since 2.10
	 * Params:
	 * func =  a function to call for each printer
	 * data =  user data to pass to func
	 * destroy =  function to call if data is no longer needed
	 * wait =  if TRUE, wait in a recursive mainloop until
	 *  all printers are enumerated; otherwise return early
	 */
	public static void enumeratePrinters(GtkPrinterFunc func, void* data, GDestroyNotify destroy, int wait);
}
