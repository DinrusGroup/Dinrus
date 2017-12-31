module gtkD.gio.FilenameCompleter;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Completes partial file and directory names given a partial string by
 * looking in the file system for clues. Can return a list of possible
 * completion strings for widget implementations.
 */
public class FilenameCompleter : ObjectG
{
	
	/** the main Gtk struct */
	protected GFilenameCompleter* gFilenameCompleter;
	
	
	public GFilenameCompleter* getFilenameCompleterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFilenameCompleter* gFilenameCompleter);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(FilenameCompleter)[] onGotCompletionDataListeners;
	/**
	 * Emitted when the file name completion information comes available.
	 */
	void addOnGotCompletionData(void delegate(FilenameCompleter) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackGotCompletionData(GFilenameCompleter* arg0Struct, FilenameCompleter filenameCompleter);
	
	
	/**
	 * Creates a new filename completer.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Obtains a completion for initial_text from completer.
	 * Params:
	 * initialText =  text to be completed.
	 * Returns: a completed string, or NULL if no completion exists.  This string is not owned by GIO, so remember to g_free() it  when finished.
	 */
	public string getCompletionSuffix(string initialText);
	
	/**
	 * Gets an array of completion strings for a given initial text.
	 * Params:
	 * initialText =  text to be completed.
	 * Returns: array of strings with possible completions for initial_text.This array must be freed by g_strfreev() when finished.
	 */
	public string[] getCompletions(string initialText);
	
	/**
	 * If dirs_only is TRUE, completer will only
	 * complete directory names, and not file names.
	 * Params:
	 * dirsOnly =  a gboolean.
	 * Signal Details
	 * The "got-completion-data" signal
	 * void user_function (GFilenameCompleter *arg0,
	 *  gpointer user_data) : Run Last
	 * Emitted when the file name completion information comes available.
	 */
	public void setDirsOnly(int dirsOnly);
}
