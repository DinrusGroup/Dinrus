module gtkD.glib.MappedFile;

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
public class MappedFile
{
	
	/** the main Gtk struct */
	protected GMappedFile* gMappedFile;
	
	
	public GMappedFile* getMappedFileStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GMappedFile* gMappedFile);
	
	/**
	 */
	
	/**
	 * Maps a file into memory. On UNIX, this is using the mmap() function.
	 * If writable is TRUE, the mapped buffer may be modified, otherwise
	 * it is an error to modify the mapped buffer. Modifications to the buffer
	 * are not visible to other processes mapping the same file, and are not
	 * written back to the file.
	 * Note that modifications of the underlying file might affect the contents
	 * of the GMappedFile. Therefore, mapping should only be used if the file
	 * will not be modified, or if all modifications of the file are done
	 * atomically (e.g. using g_file_set_contents()).
	 * Since 2.8
	 * Params:
	 * filename =  The path of the file to load, in the GLib filename encoding
	 * writable =  whether the mapping should be writable
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string filename, int writable);
	
	/**
	 * Increments the reference count of file by one. It is safe to call
	 * this function from any thread.
	 * Since 2.22
	 * Returns: the passed in GMappedFile.
	 */
	public MappedFile doref();
	
	/**
	 * Decrements the reference count of file by one. If the reference count
	 * drops to 0, unmaps the buffer of file and frees it.
	 * It is safe to call this function from any thread.
	 * Since 2.22
	 */
	public void unref();
	
	/**
	 * Warning
	 * g_mapped_file_free has been deprecated since version 2.22 and should not be used in newly-written code. Use g_mapped_file_unref() instead.
	 * This call existed before GMappedFile had refcounting and is currently
	 * exactly the same as g_mapped_file_unref().
	 * Since 2.8
	 */
	public void free();
	
	/**
	 * Returns the length of the contents of a GMappedFile.
	 * Since 2.8
	 * Returns: the length of the contents of file.
	 */
	public uint getLength();
	
	/**
	 * Returns the contents of a GMappedFile.
	 * Note that the contents may not be zero-terminated,
	 * even if the GMappedFile is backed by a text file.
	 * Since 2.8
	 * Returns: the contents of file.
	 */
	public string getContents();
}
