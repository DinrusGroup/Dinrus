module gtkD.gtk.PrintJob;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.cairo.Surface;
private import gtkD.gtk.Printer;
private import gtkD.gtk.PageSetup;
private import gtkD.gtk.PrintSettings;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkPrintJob object represents a job that is sent to a
 * printer. You only need to deal directly with print jobs if
 * you use the non-portable GtkPrintUnixDialog API.
 * Use gtk_print_job_get_surface() to obtain the cairo surface
 * onto which the pages must be drawn. Use gtk_print_job_send()
 * to send the finished job to the printer. If you don't use cairo
 * GtkPrintJob also supports printing of manually generated postscript,
 * via gtk_print_job_set_source_file().
 * Printing support was added in GTK+ 2.10.
 */
public class PrintJob : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkPrintJob* gtkPrintJob;
	
	
	public GtkPrintJob* getPrintJobStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPrintJob* gtkPrintJob);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(PrintJob)[] onStatusChangedListeners;
	/**
	 * Gets emitted when the status of a job changes. The signal handler
	 * can use gtk_print_job_get_status() to obtain the new status.
	 * Since 2.10
	 */
	void addOnStatusChanged(void delegate(PrintJob) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackStatusChanged(GtkPrintJob* jobStruct, PrintJob printJob);
	
	
	/**
	 * Creates a new GtkPrintJob.
	 * Since 2.10
	 * Params:
	 * title =  the job title
	 * printer =  a GtkPrinter
	 * settings =  a GtkPrintSettings
	 * pageSetup =  a GtkPageSetup
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string title, Printer printer, PrintSettings settings, PageSetup pageSetup);
	
	/**
	 * Gets the GtkPrintSettings of the print job.
	 * Since 2.10
	 * Returns: the settings of job
	 */
	public PrintSettings getSettings();

	/**
	 * Gets the GtkPrinter of the print job.
	 * Since 2.10
	 * Returns: the printer of job
	 */
	public Printer getPrinter();
	
	/**
	 * Gets the job title.
	 * Since 2.10
	 * Returns: the title of job
	 */
	public string getTitle();
	
	/**
	 * Gets the status of the print job.
	 * Since 2.10
	 * Returns: the status of job
	 */
	public GtkPrintStatus getStatus();
	
	/**
	 * Make the GtkPrintJob send an existing document to the
	 * printing system. The file can be in any format understood
	 * by the platforms printing system (typically PostScript,
	 * but on many platforms PDF may work too). See
	 * gtk_printer_accepts_pdf() and gtk_printer_accepts_ps().
	 * Since 2.10
	 * Params:
	 * filename =  the file to be printed
	 * Returns: FALSE if an error occurred
	 * Throws: GException on failure.
	 */
	public int setSourceFile(string filename);
	
	/**
	 * Gets a cairo surface onto which the pages of
	 * the print job should be rendered.
	 * Since 2.10
	 * Returns: the cairo surface of job
	 * Throws: GException on failure.
	 */
	public Surface getSurface();

	/**
	 * Sends the print job off to the printer.
	 * Since 2.10
	 * Params:
	 * callback =  function to call when the job completes or an error occurs
	 * userData =  user data that gets passed to callback
	 * dnotify =  destroy notify for user_data
	 */
	public void send(GtkPrintJobCompleteFunc callback, void* userData, GDestroyNotify dnotify);
	
	/**
	 * If track_status is TRUE, the print job will try to continue report
	 * on the status of the print job in the printer queues and printer. This
	 * can allow your application to show things like "out of paper" issues,
	 * and when the print job actually reaches the printer.
	 * This function is often implemented using some form of polling, so it should
	 * not be enabled unless needed.
	 * Since 2.10
	 * Params:
	 * trackStatus =  TRUE to track status after printing
	 */
	public void setTrackPrintStatus(int trackStatus);
	
	/**
	 * Returns wheter jobs will be tracked after printing.
	 * For details, see gtk_print_job_set_track_print_status().
	 * Since 2.10
	 * Returns: TRUE if print job status will be reported after printing
	 */
	public int getTrackPrintStatus();
}
