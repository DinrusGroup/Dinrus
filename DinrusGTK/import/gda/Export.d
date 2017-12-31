module gtkD.gda.Export;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gda.Connection;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class Export : ObjectG
{
	
	/** the main Gtk struct */
	protected GdaExport* gdaExport;
	
	
	public GdaExport* getExportStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaExport* gdaExport);
	
	/**
	 */
	
	/**
	 * Creates a new GdaExport object, which allows you to easily add
	 * exporting functionality to your programs.
	 * It works by first having a GdaConnection object associated
	 * to it, and then allowing you to retrieve information about all
	 * the objects present in the database, and also to add/remove
	 * those objects from a list of selected objects.
	 * When you're done, you just run the export (gda_export_run), first
	 * connecting to the different signals that will let you be
	 * informed of the export process progress.
	 * Params:
	 * cnc =  a GdaConnection object.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Connection cnc);
	
	/**
	 * Returns a list of all tables that exist in the GdaConnection
	 * being used by the given GdaExport object. This function is
	 * useful when you're building, for example, a list for the user
	 * to select which tables he/she wants in the export process.
	 * You are responsible to free the returned value yourself.
	 * Returns: a GList containing the names of all the tables.
	 */
	public ListG getTables();
	
	/**
	 * Returns a list with the names of all the currently selected objects
	 * in the given GdaExport object.
	 * You are responsible to free the returned value yourself.
	 * Returns: a GList containing the names of the selected tables.
	 */
	public ListG getSelectedTables();
	
	/**
	 * Adds the given table to the list of selected tables.
	 * Params:
	 * table =  name of the table.
	 */
	public void selectTable(string table);
	
	/**
	 * Adds all the tables contained in the given list to the list of
	 * selected tables.
	 * Params:
	 * list =  list of tables to be selected.
	 */
	public void selectTableList(ListG list);
	
	/**
	 * Removes the given table name from the list of selected tables.
	 * Params:
	 * table =  name of the table.
	 */
	public void unselectTable(string table);
	
	/**
	 * Starts the execution of the given export object. This means that, after
	 * calling this function, your application will lose control about the export
	 * process and will only receive notifications via the class signals.
	 * Params:
	 * flags =  execution flags.
	 */
	public void run(GdaExportFlags flags);
	
	/**
	 * Stops execution of the given export object.
	 */
	public void stop();
	
	/**
	 * Returns: the GdaConnection object associated with the given GdaExport.
	 */
	public Connection getConnection();
	
	/**
	 * Associates the given GdaConnection with the given GdaExport.
	 * Params:
	 * cnc =  a GdaConnection object.
	 */
	public void setConnection(Connection cnc);
}
