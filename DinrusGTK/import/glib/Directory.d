
module gtkD.glib.Directory;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;




/**
 * Description
 * There is a group of functions which wrap the common POSIX functions
 * dealing with filenames (g_open(), g_rename(), g_mkdir(), g_stat(),
 * g_unlink(), g_remove(), g_fopen(), g_freopen()). The point of these
 * wrappers is to make it possible to handle file names with any Unicode
 * characters in them on Windows without having to use ifdefs and the
 * wide character API in the application code.
 * The pathname argument should be in the GLib file name encoding. On
 * POSIX this is the actual on-disk encoding which might correspond to
 * the locale settings of the process (or the
 * G_FILENAME_ENCODING environment variable), or not.
 * On Windows the GLib file name encoding is UTF-8. Note that the
 * Microsoft C library does not use UTF-8, but has separate APIs for
 * current system code page and wide characters (UTF-16). The GLib
 * wrappers call the wide character API if present (on modern Windows
 * systems), otherwise convert to/from the system code page.
 * Another group of functions allows to open and read directories
 * in the GLib file name encoding. These are g_dir_open(),
 * g_dir_read_name(), g_dir_rewind(), g_dir_close().
 */
public class Directory
{
	
	/** the main Gtk struct */
	protected GDir* gDir;
	
	
	public GDir* getDirectoryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GDir* gDir);
	
	/**
	 */
	
	/**
	 * Opens a directory for reading. The names of the files in the
	 * directory can then be retrieved using g_dir_read_name().
	 * Params:
	 * path =  the path to the directory you are interested in. On Unix
	 *  in the on-disk encoding. On Windows in UTF-8
	 * flags =  Currently must be set to 0. Reserved for future use.
	 * Returns: a newly allocated GDir on success, NULL on failure. If non-NULL, you must free the result with g_dir_close() when you are finished with it.
	 * Throws: GException on failure.
	 */
	public static Directory open(string path, uint flags);
	
	/**
	 * Retrieves the name of the next entry in the directory. The '.' and
	 * '..' entries are omitted. On Windows, the returned name is in
	 * UTF-8. On Unix, it is in the on-disk encoding.
	 * Returns: The entry's name or NULL if there are no  more entries. The return value is owned by GLib and must not be modified or freed.
	 */
	public string readName();
	
	/**
	 * Resets the given directory. The next call to g_dir_read_name()
	 * will return the first entry again.
	 */
	public void rewind();
	
	/**
	 * Closes the directory and deallocates all related resources.
	 */
	public void close();
}
