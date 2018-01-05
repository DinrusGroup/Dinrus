module gtkD.gio.File;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gio.AppInfo;
private import gtkD.gio.AppInfoIF;
private import gtkD.gio.AsyncResultIF;
private import gtkD.gio.Cancellable;
private import gtkD.gio.FileAttributeInfoList;
private import gtkD.gio.FileEnumerator;
private import gtkD.gio.FileInfo;
private import gtkD.gio.FileInputStream;
private import gtkD.gio.FileIOStream;
private import gtkD.gio.FileMonitor;
private import gtkD.gio.FileOutputStream;
private import gtkD.gio.Mount;
private import gtkD.gio.MountIF;
private import gtkD.gio.MountOperation;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GFile is a high level abstraction for manipulating files on a
 * virtual file system. GFiles are lightweight, immutable
 * objects that do no I/O upon creation. It is necessary to understand that
 * GFile objects do not represent files, merely an identifier for a file. All
 * file content I/O is implemented as streaming operations (see GInputStream and
 * GOutputStream).
 * To construct a GFile, you can use:
 * g_file_new_for_path() if you have a path.
 * g_file_new_for_uri() if you have a URI.
 * g_file_new_for_commandline_arg() for a command line argument.
 * g_file_parse_name() from a utf8 string gotten from g_file_get_parse_name().
 * One way to think of a GFile is as an abstraction of a pathname. For normal
 * files the system pathname is what is stored internally, but as GFiles
 * are extensible it could also be something else that corresponds to a pathname
 * in a userspace implementation of a filesystem.
 * GFiles make up hierarchies of directories and files that correspond to the
 * files on a filesystem. You can move through the file system with GFile using
 * g_file_get_parent() to get an identifier for the parent directory, g_file_get_child()
 * to get a child within a directory, g_file_resolve_relative_path() to resolve a relative
 * path between two GFiles. There can be multiple hierarchies, so you may not
 * end up at the same root if you repeatedly call g_file_get_parent() on two different
 * files.
 * All GFiles have a basename (get with g_file_get_basename()). These names
 * are byte strings that are used to identify the file on the filesystem (relative to
 * its parent directory) and there is no guarantees that they have any particular charset
 * encoding or even make any sense at all. If you want to use filenames in a user
 * interface you should use the display name that you can get by requesting the
 * G_FILE_ATTRIBUTE_STANDARD_DISPLAY_NAME attribute with g_file_query_info().
 * This is guaranteed to be in utf8 and can be used in a user interface. But always
 * store the real basename or the GFile to use to actually access the file, because
 * there is no way to go from a display name to the actual name.
 * Using GFile as an identifier has the same weaknesses as using a path in that
 * there may be multiple aliases for the same file. For instance, hard or
 * soft links may cause two different GFiles to refer to the same file.
 * Other possible causes for aliases are: case insensitive filesystems, short
 * and long names on Fat/NTFS, or bind mounts in Linux. If you want to check if
 * two GFiles point to the same file you can query for the
 * G_FILE_ATTRIBUTE_ID_FILE attribute. Note that GFile does some trivial
 * canonicalization of pathnames passed in, so that trivial differences in the
 * path string used at creation (duplicated slashes, slash at end of path, "."
 * or ".." path segments, etc) does not create different GFiles.
 * Many GFile operations have both synchronous and asynchronous versions
 * to suit your application. Asynchronous versions of synchronous functions
 * simply have _async() appended to their function names. The asynchronous
 * I/O functions call a GAsyncReadyCallback which is then used to finalize
 * the operation, producing a GAsyncResult which is then passed to the
 * function's matching _finish() operation.
 * Some GFile operations do not have synchronous analogs, as they may
 * take a very long time to finish, and blocking may leave an application
 * unusable. Notable cases include:
 * g_file_mount_mountable() to mount a mountable file.
 * g_file_unmount_mountable_with_operation() to unmount a mountable file.
 * g_file_eject_mountable_with_operation() to eject a mountable file.
 * One notable feature of GFiles are entity tags, or "etags" for
 * short. Entity tags are somewhat like a more abstract version of the
 * traditional mtime, and can be used to quickly determine if the file has
 * been modified from the version on the file system. See the HTTP 1.1
 * specification
 * for HTTP Etag headers, which are a very similar concept.
 */
public class File : ObjectG
{
	
	/** the main Gtk struct */
	protected GFile* gFile;
	
	
	public GFile* getFileStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFile* gFile);
	/**
	 */
	
	/**
	 * Creates a GFile with the given argument from the command line. The value of
	 * arg can be either a URI, an absolute path or a relative path resolved
	 * relative to the current working directory.
	 * This operation never fails, but the returned object might not support any
	 * I/O operation if arg points to a malformed path.
	 * Params:
	 * arg =  a command line string.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string arg);
	
	/**
	 * Constructs a GFile with the given parse_name (i.e. something given by g_file_get_parse_name()).
	 * This operation never fails, but the returned object might not support any I/O
	 * operation if the parse_name cannot be parsed.
	 * Params:
	 * parseName =  a file name or path to be parsed.
	 * Returns: a new GFile.
	 */
	public static File parseName(string parseName);
	
	/**
	 * Duplicates a GFile handle. This operation does not duplicate
	 * the actual file or directory represented by the GFile; see
	 * g_file_copy() if attempting to copy a file.
	 * This call does no blocking i/o.
	 * Returns: a new GFile that is a duplicate of the given GFile.
	 */
	public File dup();
	
	/**
	 * Creates a hash value for a GFile.
	 * This call does no blocking i/o.
	 * Params:
	 * file =  gconstpointer to a GFile.
	 * Returns: 0 if file is not a valid GFile, otherwise an  integer that can be used as hash value for the GFile.  This function is intended for easily hashing a GFile to  add to a GHashTable or similar data structure.
	 */
	public static uint hash(void* file);
	
	/**
	 * Checks equality of two given GFiles. Note that two
	 * GFiles that differ can still refer to the same
	 * file on the filesystem due to various forms of filename
	 * aliasing.
	 * This call does no blocking i/o.
	 * Params:
	 * file2 =  the second GFile.
	 * Returns: TRUE if file1 and file2 are equal. FALSE if either is not a GFile.
	 */
	public int equal(File file2);
	
	/**
	 * Gets the base name (the last component of the path) for a given GFile.
	 * If called for the top level of a system (such as the filesystem root
	 * or a uri like sftp://host/) it will return a single directory separator
	 * (and on Windows, possibly a drive letter).
	 * The base name is a byte string (*not* UTF-8). It has no defined encoding
	 * or rules other than it may not contain zero bytes. If you want to use
	 * filenames in a user interface you should use the display name that you
	 * can get by requesting the G_FILE_ATTRIBUTE_STANDARD_DISPLAY_NAME
	 * attribute with g_file_query_info().
	 * This call does no blocking i/o.
	 * Returns: string containing the GFile's base name, or NULL  if given GFile is invalid. The returned string should be  freed with g_free() when no longer needed.
	 */
	public string getBasename();
	
	/**
	 * Gets the local pathname for GFile, if one exists.
	 * This call does no blocking i/o.
	 * Returns: string containing the GFile's path, or NULL if  no such path exists. The returned string should be  freed with g_free() when no longer needed.
	 */
	public string getPath();
	
	/**
	 * Gets the URI for the file.
	 * This call does no blocking i/o.
	 * Returns: a string containing the GFile's URI. The returned string should be freed with g_free() when no longer needed.
	 */
	public string getUri();
	
	/**
	 * Gets the parse name of the file.
	 * A parse name is a UTF-8 string that describes the
	 * file such that one can get the GFile back using
	 * g_file_parse_name().
	 * This is generally used to show the GFile as a nice
	 * full-pathname kind of string in a user interface,
	 * like in a location entry.
	 * For local files with names that can safely be converted
	 * to UTF8 the pathname is used, otherwise the IRI is used
	 * (a form of URI that allows UTF8 characters unescaped).
	 * This call does no blocking i/o.
	 * Returns: a string containing the GFile's parse name. The returned  string should be freed with g_free() when no longer needed.
	 */
	public string getParseName();
	
	/**
	 * Gets the parent directory for the file.
	 * If the file represents the root directory of the
	 * file system, then NULL will be returned.
	 * This call does no blocking i/o.
	 * Returns: a GFile structure to the parent of the given GFile or NULL if there is no parent.  Free the returned object with g_object_unref().
	 */
	public File getParent();
	
	/**
	 * Gets a child of file with basename equal to name.
	 * Note that the file with that specific name might not exist, but
	 * you can still have a GFile that points to it. You can use this
	 * for instance to create that file.
	 * This call does no blocking i/o.
	 * Params:
	 * name =  string containing the child's basename.
	 * Returns: a GFile to a child specified by name. Free the returned object with g_object_unref().
	 */
	public File getChild(string name);
	
	/**
	 * Gets the child of file for a given display_name (i.e. a UTF8
	 * version of the name). If this function fails, it returns NULL and error will be
	 * set. This is very useful when constructing a GFile for a new file
	 * and the user entered the filename in the user interface, for instance
	 * when you select a directory and type a filename in the file selector.
	 * This call does no blocking i/o.
	 * Params:
	 * displayName =  string to a possible child.
	 * Returns: a GFile to the specified child, or  NULL if the display name couldn't be converted.  Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public File getChildForDisplayName(string displayName);
	
	/**
	 * Checks whether file has the prefix specified by prefix. In other word,
	 * if the names of inital elements of files pathname match prefix.
	 * Only full pathname elements are matched, so a path like /foo is not
	 * considered a prefix of /foobar, only of /foo/bar.
	 * This call does no i/o, as it works purely on names. As such it can
	 * sometimes return FALSE even if file is inside a prefix (from a
	 * filesystem point of view), because the prefix of file is an alias
	 * of prefix.
	 * Params:
	 * prefix =  input GFile.
	 * Returns: TRUE if the files's parent, grandparent, etc is prefix.  FALSE otherwise.
	 */
	public int hasPrefix(File prefix);
	
	/**
	 * Gets the path for descendant relative to parent.
	 * This call does no blocking i/o.
	 * Params:
	 * descendant =  input GFile.
	 * Returns: string with the relative path from descendant  to parent, or NULL if descendant doesn't have parent as prefix.  The returned string should be freed with g_free() when no longer needed.
	 */
	public string getRelativePath(File descendant);
	
	/**
	 * Resolves a relative path for file to an absolute path.
	 * This call does no blocking i/o.
	 * Params:
	 * relativePath =  a given relative path string.
	 * Returns: GFile to the resolved path. NULL if relative_path  is NULL or if file is invalid. Free the returned object with g_object_unref().
	 */
	public File resolveRelativePath(string relativePath);
	
	/**
	 * Checks to see if a file is native to the platform.
	 * A native file s one expressed in the platform-native filename format,
	 * e.g. "C:\Windows" or "/usr/bin/". This does not mean the file is local,
	 * as it might be on a locally mounted remote filesystem.
	 * On some systems non-native files may be available using
	 * the native filesystem via a userspace filesystem (FUSE), in
	 * these cases this call will return FALSE, but g_file_get_path()
	 * will still return a native path.
	 * This call does no blocking i/o.
	 * Returns: TRUE if file is native.
	 */
	public int isNative();
	
	/**
	 * Checks to see if a GFile has a given URI scheme.
	 * This call does no blocking i/o.
	 * Params:
	 * uriScheme =  a string containing a URI scheme.
	 * Returns: TRUE if GFile's backend supports the given URI scheme, FALSE if URI scheme is NULL, not supported, or GFile is invalid.
	 */
	public int hasUriScheme(string uriScheme);
	
	/**
	 * Gets the URI scheme for a GFile.
	 * Returns: a string containing the URI scheme for the given  GFile. The returned string should be freed with g_free()  when no longer needed.
	 */
	public string getUriScheme();
	
	/**
	 * Opens a file for reading. The result is a GFileInputStream that
	 * can be used to read the contents of the file.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If the file does not exist, the G_IO_ERROR_NOT_FOUND error will be returned.
	 * If the file is a directory, the G_IO_ERROR_IS_DIRECTORY error will be returned.
	 * Other errors are possible too, and depend on what kind of filesystem the file is on.
	 * Params:
	 * cancellable =  a GCancellable
	 * Returns: GFileInputStream or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileInputStream read(Cancellable cancellable);
	
	/**
	 * Asynchronously opens file for reading.
	 * For more details, see g_file_read() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_read_finish() to get the result of the operation.
	 * Params:
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void readAsync(int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous file read operation started with
	 * g_file_read_async().
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: a GFileInputStream or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileInputStream readFinish(AsyncResultIF res);
	
	/**
	 * Gets an output stream for appending data to the file. If
	 * the file doesn't already exist it is created.
	 * By default files created are generally readable by everyone,
	 * but if you pass G_FILE_CREATE_PRIVATE in flags the file
	 * will be made readable only to the current user, to the level that
	 * is supported on the target filesystem.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Some file systems don't allow all file names, and may
	 * return an G_IO_ERROR_INVALID_FILENAME error.
	 * If the file is a directory the G_IO_ERROR_IS_DIRECTORY error will be
	 * returned. Other errors are possible too, and depend on what kind of
	 * filesystem the file is on.
	 * Params:
	 * flags =  a set of GFileCreateFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileOutputStream, or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileOutputStream appendTo(GFileCreateFlags flags, Cancellable cancellable);
	
	/**
	 * Creates a new file and returns an output stream for writing to it.
	 * The file must not already exist.
	 * By default files created are generally readable by everyone,
	 * but if you pass G_FILE_CREATE_PRIVATE in flags the file
	 * will be made readable only to the current user, to the level that
	 * is supported on the target filesystem.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If a file or directory with this name already exists the G_IO_ERROR_EXISTS
	 * error will be returned.
	 * Some file systems don't allow all file names, and may
	 * return an G_IO_ERROR_INVALID_FILENAME error, and if the name
	 * is to long G_IO_ERROR_FILENAME_TOO_LONG will be returned.
	 * Other errors are possible too, and depend on what kind of
	 * filesystem the file is on.
	 * Params:
	 * flags =  a set of GFileCreateFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileOutputStream for the newly created file, or  NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileOutputStream create(GFileCreateFlags flags, Cancellable cancellable);
	
	/**
	 * Returns an output stream for overwriting the file, possibly
	 * creating a backup copy of the file first. If the file doesn't exist,
	 * it will be created.
	 * This will try to replace the file in the safest way possible so
	 * that any errors during the writing will not affect an already
	 * existing copy of the file. For instance, for local files it
	 * may write to a temporary file and then atomically rename over
	 * the destination when the stream is closed.
	 * By default files created are generally readable by everyone,
	 * but if you pass G_FILE_CREATE_PRIVATE in flags the file
	 * will be made readable only to the current user, to the level that
	 * is supported on the target filesystem.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If you pass in a non-NULL etag value, then this value is
	 * compared to the current entity tag of the file, and if they differ
	 * an G_IO_ERROR_WRONG_ETAG error is returned. This generally means
	 * that the file has been changed since you last read it. You can get
	 * the new etag from g_file_output_stream_get_etag() after you've
	 * finished writing and closed the GFileOutputStream. When you load
	 * a new file you can use g_file_input_stream_query_info() to get
	 * the etag of the file.
	 * If make_backup is TRUE, this function will attempt to make a backup
	 * of the current file before overwriting it. If this fails a G_IO_ERROR_CANT_CREATE_BACKUP
	 * error will be returned. If you want to replace anyway, try again with
	 * make_backup set to FALSE.
	 * If the file is a directory the G_IO_ERROR_IS_DIRECTORY error will be returned,
	 * and if the file is some other form of non-regular file then a
	 * G_IO_ERROR_NOT_REGULAR_FILE error will be returned.
	 * Some file systems don't allow all file names, and may
	 * return an G_IO_ERROR_INVALID_FILENAME error, and if the name
	 * is to long G_IO_ERROR_FILENAME_TOO_LONG will be returned.
	 * Other errors are possible too, and depend on what kind of
	 * filesystem the file is on.
	 * Params:
	 * etag =  an optional entity tag for the
	 *  current GFile, or NULL to ignore.
	 * makeBackup =  TRUE if a backup should be created.
	 * flags =  a set of GFileCreateFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileOutputStream or NULL on error.  Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileOutputStream replace(string etag, int makeBackup, GFileCreateFlags flags, Cancellable cancellable);
	
	/**
	 * Asynchronously opens file for appending.
	 * For more details, see g_file_append_to() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_append_to_finish() to get the result of the operation.
	 * Params:
	 * flags =  a set of GFileCreateFlags.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void appendToAsync(GFileCreateFlags flags, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous file append operation started with
	 * g_file_append_to_async().
	 * Params:
	 * res =  GAsyncResult
	 * Returns: a valid GFileOutputStream or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileOutputStream appendToFinish(AsyncResultIF res);
	
	/**
	 * Asynchronously creates a new file and returns an output stream for writing to it.
	 * The file must not already exist.
	 * For more details, see g_file_create() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_create_finish() to get the result of the operation.
	 * Params:
	 * flags =  a set of GFileCreateFlags.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void createAsync(GFileCreateFlags flags, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	/**
	 * Finishes an asynchronous file create operation started with
	 * g_file_create_async().
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: a GFileOutputStream or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileOutputStream createFinish(AsyncResultIF res);
	
	/**
	 * Asynchronously overwrites the file, replacing the contents, possibly
	 * creating a backup copy of the file first.
	 * For more details, see g_file_replace() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_replace_finish() to get the result of the operation.
	 * Params:
	 * etag =  an entity tag for the
	 *  current GFile, or NULL to ignore.
	 * makeBackup =  TRUE if a backup should be created.
	 * flags =  a set of GFileCreateFlags.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void replaceAsync(string etag, int makeBackup, GFileCreateFlags flags, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous file replace operation started with
	 * g_file_replace_async().
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: a GFileOutputStream, or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileOutputStream replaceFinish(AsyncResultIF res);
	
	/**
	 * Gets the requested information about specified file. The result
	 * is a GFileInfo object that contains key-value attributes (such as
	 * the type or size of the file).
	 * The attribute value is a string that specifies the file attributes that
	 * should be gathered. It is not an error if it's not possible to read a particular
	 * requested attribute from a file - it just won't be set. attribute should
	 * be a comma-separated list of attribute or attribute wildcards. The wildcard "*"
	 * means all attributes, and a wildcard like "standard::*" means all attributes in the standard
	 * namespace. An example attribute query be "standard::*,owner::user".
	 * The standard attributes are available as defines, like G_FILE_ATTRIBUTE_STANDARD_NAME.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * For symlinks, normally the information about the target of the
	 * symlink is returned, rather than information about the symlink itself.
	 * However if you pass G_FILE_QUERY_INFO_NOFOLLOW_SYMLINKS in flags the
	 * information about the symlink itself will be returned. Also, for symlinks
	 * that point to non-existing files the information about the symlink itself
	 * will be returned.
	 * If the file does not exist, the G_IO_ERROR_NOT_FOUND error will be returned.
	 * Other errors are possible too, and depend on what kind of filesystem the file is on.
	 * Params:
	 * attributes =  an attribute query string.
	 * flags =  a set of GFileQueryInfoFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileInfo for the given file, or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfo(string attributes, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Asynchronously gets the requested information about specified file. The result
	 * is a GFileInfo object that contains key-value attributes (such as type or size
	 * for the file).
	 * For more details, see g_file_query_info() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_query_info_finish() to get the result of the operation.
	 * Params:
	 * attributes =  an attribute query string.
	 * flags =  a set of GFileQueryInfoFlags.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void queryInfoAsync(string attributes, GFileQueryInfoFlags flags, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous file info query.
	 * See g_file_query_info_async().
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: GFileInfo for given file or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileInfo queryInfoFinish(AsyncResultIF res);
	
	/**
	 * Utility function to check if a particular file exists. This is
	 * implemented using g_file_query_info() and as such does blocking I/O.
	 * Note that in many cases it is racy to first check for file existence
	 * and then execute something based on the outcome of that, because the
	 * file might have been created or removed in between the operations. The
	 * general approach to handling that is to not check, but just do the
	 * operation and handle the errors as they come.
	 * As an example of race-free checking, take the case of reading a file, and
	 * if it doesn't exist, creating it. There are two racy versions: read it, and
	 * on error create it; and: check if it exists, if not create it. These
	 * can both result in two processes creating the file (with perhaps a partially
	 * written file as the result). The correct approach is to always try to create
	 * the file with g_file_create() which will either atomically create the file
	 * or fail with a G_IO_ERROR_EXISTS error.
	 * However, in many cases an existence check is useful in a user
	 * interface, for instance to make a menu item sensitive/insensitive, so that
	 * you don't have to fool users that something is possible and then just show
	 * and error dialog. If you do this, you should make sure to also handle the
	 * errors that can happen due to races when you execute the operation.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the file exists (and can be detected without error), FALSE otherwise (or if cancelled).
	 */
	public int queryExists(Cancellable cancellable);
	
	/**
	 * Utility function to inspect the GFileType of a file. This is
	 * implemented using g_file_query_info() and as such does blocking I/O.
	 * The primary use case of this method is to check if a file is a regular file,
	 * directory, or symlink.
	 * Since 2.18
	 * Params:
	 * flags =  a set of GFileQueryInfoFlags passed to g_file_query_info().
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: The GFileType of the file and G_FILE_TYPE_UNKNOWN if the file does not exist
	 */
	public GFileType queryFileType(GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Similar to g_file_query_info(), but obtains information
	 * about the filesystem the file is on, rather than the file itself.
	 * For instance the amount of space available and the type of
	 * the filesystem.
	 * The attribute value is a string that specifies the file attributes that
	 * should be gathered. It is not an error if it's not possible to read a particular
	 * requested attribute from a file - it just won't be set. attribute should
	 * be a comma-separated list of attribute or attribute wildcards. The wildcard "*"
	 * means all attributes, and a wildcard like "fs:*" means all attributes in the fs
	 * namespace. The standard namespace for filesystem attributes is "fs".
	 * Common attributes of interest are G_FILE_ATTRIBUTE_FILESYSTEM_SIZE
	 * (the total size of the filesystem in bytes), G_FILE_ATTRIBUTE_FILESYSTEM_FREE (number of
	 * bytes available), and G_FILE_ATTRIBUTE_FILESYSTEM_TYPE (type of the filesystem).
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If the file does not exist, the G_IO_ERROR_NOT_FOUND error will be returned.
	 * Other errors are possible too, and depend on what kind of filesystem the file is on.
	 * Params:
	 * attributes =  an attribute query string.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileInfo or NULL if there was an error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileInfo queryFilesystemInfo(string attributes, Cancellable cancellable);
	
	/**
	 * Asynchronously gets the requested information about the filesystem
	 * that the specified file is on. The result is a GFileInfo object
	 * that contains key-value attributes (such as type or size for the
	 * file).
	 * For more details, see g_file_query_filesystem_info() which is the
	 * synchronous version of this call.
	 * When the operation is finished, callback will be called. You can
	 * then call g_file_query_info_finish() to get the result of the
	 * operation.
	 * Params:
	 * attributes =  an attribute query string.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void queryFilesystemInfoAsync(string attributes, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous filesystem info query. See
	 * g_file_query_filesystem_info_async().
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: GFileInfo for given file or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileInfo queryFilesystemInfoFinish(AsyncResultIF res);
	
	/**
	 * Returns the GAppInfo that is registered as the default
	 * application to handle the file specified by file.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GAppInfo if the handle was found, NULL if there were errors.When you are done with it, release it with g_object_unref()
	 * Throws: GException on failure.
	 */
	public AppInfoIF queryDefaultHandler(Cancellable cancellable);
	
	/**
	 * Gets a GMount for the GFile.
	 * If the GFileIface for file does not have a mount (e.g. possibly a
	 * remote share), error will be set to G_IO_ERROR_NOT_FOUND and NULL
	 * will be returned.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GMount where the file is located or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public MountIF findEnclosingMount(Cancellable cancellable);
	
	/**
	 * Asynchronously gets the mount for the file.
	 * For more details, see g_file_find_enclosing_mount() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_find_enclosing_mount_finish() to get the result of the operation.
	 * Params:
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void findEnclosingMountAsync(int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous find mount request.
	 * See g_file_find_enclosing_mount_async().
	 * Params:
	 * res =  a GAsyncResult
	 * Returns: GMount for given file or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public MountIF findEnclosingMountFinish(AsyncResultIF res);
	
	/**
	 * Gets the requested information about the files in a directory. The result
	 * is a GFileEnumerator object that will give out GFileInfo objects for
	 * all the files in the directory.
	 * The attribute value is a string that specifies the file attributes that
	 * should be gathered. It is not an error if it's not possible to read a particular
	 * requested attribute from a file - it just won't be set. attribute should
	 * be a comma-separated list of attribute or attribute wildcards. The wildcard "*"
	 * means all attributes, and a wildcard like "standard::*" means all attributes in the standard
	 * namespace. An example attribute query be "standard::*,owner::user".
	 * The standard attributes are available as defines, like G_FILE_ATTRIBUTE_STANDARD_NAME.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If the file does not exist, the G_IO_ERROR_NOT_FOUND error will be returned.
	 * If the file is not a directory, the G_FILE_ERROR_NOTDIR error will be returned.
	 * Other errors are possible too.
	 * Params:
	 * attributes =  an attribute query string.
	 * flags =  a set of GFileQueryInfoFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: A GFileEnumerator if successful, NULL on error.  Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileEnumerator enumerateChildren(string attributes, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Asynchronously gets the requested information about the files in a directory. The result
	 * is a GFileEnumerator object that will give out GFileInfo objects for
	 * all the files in the directory.
	 * For more details, see g_file_enumerate_children() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_enumerate_children_finish() to get the result of the operation.
	 * Params:
	 * attributes =  an attribute query string.
	 * flags =  a set of GFileQueryInfoFlags.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void enumerateChildrenAsync(string attributes, GFileQueryInfoFlags flags, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an async enumerate children operation.
	 * See g_file_enumerate_children_async().
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: a GFileEnumerator or NULL if an error occurred. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileEnumerator enumerateChildrenFinish(AsyncResultIF res);
	
	
	/**
	 * Renames file to the specified display name.
	 * The display name is converted from UTF8 to the correct encoding for the target
	 * filesystem if possible and the file is renamed to this.
	 * If you want to implement a rename operation in the user interface the edit name
	 * (G_FILE_ATTRIBUTE_STANDARD_EDIT_NAME) should be used as the initial value in the rename
	 * widget, and then the result after editing should be passed to g_file_set_display_name().
	 * On success the resulting converted filename is returned.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * displayName =  a string.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFile specifying what file was renamed to, or NULL  if there was an error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public File setDisplayName(string displayName, Cancellable cancellable);
	
	/**
	 * Asynchronously sets the display name for a given GFile.
	 * For more details, see g_file_set_display_name() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_set_display_name_finish() to get the result of the operation.
	 * Params:
	 * displayName =  a string.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void setDisplayNameAsync(string displayName, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes setting a display name started with
	 * g_file_set_display_name_async().
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: a GFile or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public File setDisplayNameFinish(AsyncResultIF res);
	
	/**
	 * Deletes a file. If the file is a directory, it will only be deleted if it
	 * is empty.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the file was deleted. FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int delet(Cancellable cancellable);
	
	/**
	 * Sends file to the "Trashcan", if possible. This is similar to
	 * deleting it, but the user can recover it before emptying the trashcan.
	 * Not all file systems support trashing, so this call can return the
	 * G_IO_ERROR_NOT_SUPPORTED error.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE on successful trash, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int trash(Cancellable cancellable);
	
	/**
	 * Copies the file source to the location specified by destination.
	 * Can not handle recursive copies of directories.
	 * If the flag G_FILE_COPY_OVERWRITE is specified an already
	 * existing destination file is overwritten.
	 * If the flag G_FILE_COPY_NOFOLLOW_SYMLINKS is specified then symlinks
	 * will be copied as symlinks, otherwise the target of the
	 * source symlink will be copied.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If progress_callback is not NULL, then the operation can be monitored by
	 * setting this to a GFileProgressCallback function. progress_callback_data
	 * will be passed to this function. It is guaranteed that this callback will
	 * be called after all data has been transferred with the total number of bytes
	 * copied during the operation.
	 * If the source file does not exist then the G_IO_ERROR_NOT_FOUND
	 * error is returned, independent on the status of the destination.
	 * If G_FILE_COPY_OVERWRITE is not specified and the target exists, then the
	 * error G_IO_ERROR_EXISTS is returned.
	 * If trying to overwrite a file over a directory the G_IO_ERROR_IS_DIRECTORY
	 * error is returned. If trying to overwrite a directory with a directory the
	 * G_IO_ERROR_WOULD_MERGE error is returned.
	 * If the source is a directory and the target does not exist, or G_FILE_COPY_OVERWRITE is
	 * specified and the target is a file, then the G_IO_ERROR_WOULD_RECURSE error
	 * is returned.
	 * If you are interested in copying the GFile object itself (not the on-disk
	 * file), see g_file_dup().
	 * Params:
	 * destination =  destination GFile
	 * flags =  set of GFileCopyFlags
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * progressCallback =  function to callback with progress information
	 * progressCallbackData =  user data to pass to progress_callback
	 * Returns: TRUE on success, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int copy(File destination, GFileCopyFlags flags, Cancellable cancellable, GFileProgressCallback progressCallback, void* progressCallbackData);
	
	/**
	 * Copies the file source to the location specified by destination
	 * asynchronously. For details of the behaviour, see g_file_copy().
	 * If progress_callback is not NULL, then that function that will be called
	 * just like in g_file_copy(), however the callback will run in the main loop,
	 * not in the thread that is doing the I/O operation.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_copy_finish() to get the result of the operation.
	 * Params:
	 * destination =  destination GFile
	 * flags =  set of GFileCopyFlags
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * progressCallback =  function to callback with progress information
	 * progressCallbackData =  user data to pass to progress_callback
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void copyAsync(File destination, GFileCopyFlags flags, int ioPriority, Cancellable cancellable, GFileProgressCallback progressCallback, void* progressCallbackData, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes copying the file started with
	 * g_file_copy_async().
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: a TRUE on success, FALSE on error.
	 * Throws: GException on failure.
	 */
	public int copyFinish(AsyncResultIF res);
	
	/**
	 * Tries to move the file or directory source to the location specified by destination.
	 * If native move operations are supported then this is used, otherwise a copy + delete
	 * fallback is used. The native implementation may support moving directories (for instance
	 * on moves inside the same filesystem), but the fallback code does not.
	 * If the flag G_FILE_COPY_OVERWRITE is specified an already
	 * existing destination file is overwritten.
	 * If the flag G_FILE_COPY_NOFOLLOW_SYMLINKS is specified then symlinks
	 * will be copied as symlinks, otherwise the target of the
	 * source symlink will be copied.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If progress_callback is not NULL, then the operation can be monitored by
	 * setting this to a GFileProgressCallback function. progress_callback_data
	 * will be passed to this function. It is guaranteed that this callback will
	 * be called after all data has been transferred with the total number of bytes
	 * copied during the operation.
	 * If the source file does not exist then the G_IO_ERROR_NOT_FOUND
	 * error is returned, independent on the status of the destination.
	 * If G_FILE_COPY_OVERWRITE is not specified and the target exists, then the
	 * error G_IO_ERROR_EXISTS is returned.
	 * If trying to overwrite a file over a directory the G_IO_ERROR_IS_DIRECTORY
	 * error is returned. If trying to overwrite a directory with a directory the
	 * G_IO_ERROR_WOULD_MERGE error is returned.
	 * If the source is a directory and the target does not exist, or G_FILE_COPY_OVERWRITE is
	 * specified and the target is a file, then the G_IO_ERROR_WOULD_RECURSE error
	 * may be returned (if the native move operation isn't available).
	 * Params:
	 * destination =  GFile pointing to the destination location.
	 * flags =  set of GFileCopyFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * progressCallback =  GFileProgressCallback function for updates.
	 * progressCallbackData =  gpointer to user data for the callback function.
	 * Returns: TRUE on successful move, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int move(File destination, GFileCopyFlags flags, Cancellable cancellable, GFileProgressCallback progressCallback, void* progressCallbackData);
	
	/**
	 * Creates a directory. Note that this will only create a child directory of
	 * the immediate parent directory of the path or URI given by the GFile. To
	 * recursively create directories, see g_file_make_directory_with_parents().
	 * This function will fail if the parent directory does not exist, setting
	 * error to G_IO_ERROR_NOT_FOUND. If the file system doesn't support creating
	 * directories, this function will fail, setting error to
	 * G_IO_ERROR_NOT_SUPPORTED.
	 * For a local GFile the newly created directory will have the default
	 * (current) ownership and permissions of the current process.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE on successful creation, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int makeDirectory(Cancellable cancellable);
	
	/**
	 * Creates a directory and any parent directories that may not exist similar to
	 * 'mkdir -p'. If the file system does not support creating directories, this
	 * function will fail, setting error to G_IO_ERROR_NOT_SUPPORTED.
	 * For a local GFile the newly created directories will have the default
	 * (current) ownership and permissions of the current process.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Since 2.18
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if all directories have been successfully created, FALSEotherwise.
	 * Throws: GException on failure.
	 */
	public int makeDirectoryWithParents(Cancellable cancellable);
	
	/**
	 * Creates a symbolic link.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * symlinkValue =  a string with the value of the new symlink.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE on the creation of a new symlink, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int makeSymbolicLink(string symlinkValue, Cancellable cancellable);
	
	/**
	 * Obtain the list of settable attributes for the file.
	 * Returns the type and full attribute name of all the attributes
	 * that can be set on this file. This doesn't mean setting it will always
	 * succeed though, you might get an access failure, or some specific
	 * file may not support a specific attribute.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileAttributeInfoList describing the settable attributes.When you are done with it, release it with g_file_attribute_info_list_unref()
	 * Throws: GException on failure.
	 */
	public FileAttributeInfoList querySettableAttributes(Cancellable cancellable);
	
	/**
	 * Obtain the list of attribute namespaces where new attributes
	 * can be created by a user. An example of this is extended
	 * attributes (in the "xattr" namespace).
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileAttributeInfoList describing the writable namespaces.When you are done with it, release it with g_file_attribute_info_list_unref()
	 * Throws: GException on failure.
	 */
	public FileAttributeInfoList queryWritableNamespaces(Cancellable cancellable);
	
	/**
	 * Sets an attribute in the file with attribute name attribute to value.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * attribute =  a string containing the attribute's name.
	 * type =  The type of the attribute
	 * valueP =  a pointer to the value (or the pointer itself if the type is a pointer type)
	 * flags =  a set of GFileQueryInfoFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the attribute was set, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int setAttribute(string attribute, GFileAttributeType type, void* valueP, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Tries to set all attributes in the GFileInfo on the target values,
	 * not stopping on the first error.
	 * If there is any error during this operation then error will be set to
	 * the first error. Error on particular fields are flagged by setting
	 * the "status" field in the attribute value to
	 * G_FILE_ATTRIBUTE_STATUS_ERROR_SETTING, which means you can also detect
	 * further errors.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * info =  a GFileInfo.
	 * flags =  GFileQueryInfoFlags
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if there was any error, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int setAttributesFromInfo(FileInfo info, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Asynchronously sets the attributes of file with info.
	 * For more details, see g_file_set_attributes_from_info() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_set_attributes_finish() to get the result of the operation.
	 * Params:
	 * info =  a GFileInfo.
	 * flags =  a GFileQueryInfoFlags.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback.
	 * userData =  a gpointer.
	 */
	public void setAttributesAsync(FileInfo info, GFileQueryInfoFlags flags, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes setting an attribute started in g_file_set_attributes_async().
	 * Params:
	 * result =  a GAsyncResult.
	 * info =  a GFileInfo.
	 * Returns: TRUE if the attributes were set correctly, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int setAttributesFinish(AsyncResultIF result, out FileInfo info);
	
	/**
	 * Sets attribute of type G_FILE_ATTRIBUTE_TYPE_STRING to value.
	 * If attribute is of a different type, this operation will fail.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * attribute =  a string containing the attribute's name.
	 * value =  a string containing the attribute's value.
	 * flags =  GFileQueryInfoFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the attribute was successfully set, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int setAttributeString(string attribute, string value, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Sets attribute of type G_FILE_ATTRIBUTE_TYPE_BYTE_STRING to value.
	 * If attribute is of a different type, this operation will fail,
	 * returning FALSE.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * attribute =  a string containing the attribute's name.
	 * value =  a string containing the attribute's new value.
	 * flags =  a GFileQueryInfoFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the attribute was successfully set to value in the file, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int setAttributeByteString(string attribute, string value, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Sets attribute of type G_FILE_ATTRIBUTE_TYPE_UINT32 to value.
	 * If attribute is of a different type, this operation will fail.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * attribute =  a string containing the attribute's name.
	 * value =  a guint32 containing the attribute's new value.
	 * flags =  a GFileQueryInfoFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the attribute was successfully set to value in the file, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int setAttributeUint32(string attribute, uint value, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Sets attribute of type G_FILE_ATTRIBUTE_TYPE_INT32 to value.
	 * If attribute is of a different type, this operation will fail.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * attribute =  a string containing the attribute's name.
	 * value =  a gint32 containing the attribute's new value.
	 * flags =  a GFileQueryInfoFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the attribute was successfully set to value in the file, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int setAttributeInt32(string attribute, int value, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Sets attribute of type G_FILE_ATTRIBUTE_TYPE_UINT64 to value.
	 * If attribute is of a different type, this operation will fail.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * attribute =  a string containing the attribute's name.
	 * value =  a guint64 containing the attribute's new value.
	 * flags =  a GFileQueryInfoFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the attribute was successfully set to value in the file, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int setAttributeUint64(string attribute, ulong value, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Sets attribute of type G_FILE_ATTRIBUTE_TYPE_INT64 to value.
	 * If attribute is of a different type, this operation will fail.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * attribute =  a string containing the attribute's name.
	 * value =  a guint64 containing the attribute's new value.
	 * flags =  a GFileQueryInfoFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the attribute was successfully set, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int setAttributeInt64(string attribute, long value, GFileQueryInfoFlags flags, Cancellable cancellable);
	
	/**
	 * Mounts a file of type G_FILE_TYPE_MOUNTABLE.
	 * Using mount_operation, you can request callbacks when, for instance,
	 * passwords are needed during authentication.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_mount_mountable_finish() to get the result of the operation.
	 * Params:
	 * flags =  flags affecting the operation
	 * mountOperation =  a GMountOperation, or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied, or NULL.
	 * userData =  the data to pass to callback function
	 */
	public void mountMountable(GMountMountFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes a mount operation. See g_file_mount_mountable() for details.
	 * Finish an asynchronous mount operation that was started
	 * with g_file_mount_mountable().
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: a GFile or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public File mountMountableFinish(AsyncResultIF result);
	
	/**
	 * Warning
	 * g_file_unmount_mountable has been deprecated since version 2.22 and should not be used in newly-written code. Use g_file_unmount_mountable_with_operation() instead.
	 * Unmounts a file of type G_FILE_TYPE_MOUNTABLE.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_unmount_mountable_finish() to get the result of the operation.
	 * Params:
	 * flags =  flags affecting the operation
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied, or NULL.
	 * userData =  the data to pass to callback function
	 */
	public void unmountMountable(GMountUnmountFlags flags, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);

	/**
	 * Warning
	 * g_file_unmount_mountable_finish has been deprecated since version 2.22 and should not be used in newly-written code. Use g_file_unmount_mountable_with_operation_finish() instead.
	 * Finishes an unmount operation, see g_file_unmount_mountable() for details.
	 * Finish an asynchronous unmount operation that was started
	 * with g_file_unmount_mountable().
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the operation finished successfully. FALSEotherwise.
	 * Throws: GException on failure.
	 */
	public int unmountMountableFinish(AsyncResultIF result);
	
	/**
	 * Unmounts a file of type G_FILE_TYPE_MOUNTABLE.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_unmount_mountable_finish() to get the result of the operation.
	 * Since 2.22
	 * Params:
	 * flags =  flags affecting the operation
	 * mountOperation =  a GMountOperation, or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied, or NULL.
	 * userData =  the data to pass to callback function
	 */
	public void unmountMountableWithOperation(GMountUnmountFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an unmount operation, see g_file_unmount_mountable_with_operation() for details.
	 * Finish an asynchronous unmount operation that was started
	 * with g_file_unmount_mountable_with_operation().
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the operation finished successfully. FALSEotherwise.
	 * Throws: GException on failure.
	 */
	public int unmountMountableWithOperationFinish(AsyncResultIF result);
	
	/**
	 * Warning
	 * g_file_eject_mountable has been deprecated since version 2.22 and should not be used in newly-written code. Use g_file_eject_mountable_with_operation() instead.
	 * Starts an asynchronous eject on a mountable.
	 * When this operation has completed, callback will be called with
	 * user_user data, and the operation can be finalized with
	 * g_file_eject_mountable_finish().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * flags =  flags affecting the operation
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied, or NULL.
	 * userData =  the data to pass to callback function
	 */
	public void ejectMountable(GMountUnmountFlags flags, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Warning
	 * g_file_eject_mountable_finish has been deprecated since version 2.22 and should not be used in newly-written code. Use g_file_eject_mountable_with_operation_finish() instead.
	 * Finishes an asynchronous eject operation started by
	 * g_file_eject_mountable().
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the file was ejected successfully. FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int ejectMountableFinish(AsyncResultIF result);
	
	/**
	 * Starts an asynchronous eject on a mountable.
	 * When this operation has completed, callback will be called with
	 * user_user data, and the operation can be finalized with
	 * g_file_eject_mountable_with_operation_finish().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Since 2.22
	 * Params:
	 * flags =  flags affecting the operation
	 * mountOperation =  a GMountOperation, or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied, or NULL.
	 * userData =  the data to pass to callback function
	 */
	public void ejectMountableWithOperation(GMountUnmountFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous eject operation started by
	 * g_file_eject_mountable_with_operation().
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the file was ejected successfully. FALSEotherwise.
	 * Throws: GException on failure.
	 */
	public int ejectMountableWithOperationFinish(AsyncResultIF result);
	
	/**
	 * Starts a file of type G_FILE_TYPE_MOUNTABLE.
	 * Using start_operation, you can request callbacks when, for instance,
	 * passwords are needed during authentication.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_mount_mountable_finish() to get the result of the operation.
	 * Since 2.22
	 * Params:
	 * flags =  flags affecting the operation
	 * startOperation =  a GMountOperation, or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied, or NULL.
	 * userData =  the data to pass to callback function
	 */
	public void startMountable(GDriveStartFlags flags, MountOperation startOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes a start operation. See g_file_start_mountable() for details.
	 * Finish an asynchronous start operation that was started
	 * with g_file_start_mountable().
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the operation finished successfully. FALSEotherwise.
	 * Throws: GException on failure.
	 */
	public int startMountableFinish(AsyncResultIF result);
	
	/**
	 * Stops a file of type G_FILE_TYPE_MOUNTABLE.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_stop_mountable_finish() to get the result of the operation.
	 * Since 2.22
	 * Params:
	 * flags =  flags affecting the operation
	 * mountOperation =  a GMountOperation, or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied, or NULL.
	 * userData =  the data to pass to callback function
	 */
	public void stopMountable(GMountUnmountFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an stop operation, see g_file_stop_mountable() for details.
	 * Finish an asynchronous stop operation that was started
	 * with g_file_stop_mountable().
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the operation finished successfully. FALSEotherwise.
	 * Throws: GException on failure.
	 */
	public int stopMountableFinish(AsyncResultIF result);
	
	/**
	 * Polls a file of type G_FILE_TYPE_MOUNTABLE.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_mount_mountable_finish() to get the result of the operation.
	 * Since 2.22
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied, or NULL.
	 * userData =  the data to pass to callback function
	 */
	public void pollMountable(Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes a poll operation. See g_file_poll_mountable() for details.
	 * Finish an asynchronous poll operation that was polled
	 * with g_file_poll_mountable().
	 * Since 2.22
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if the operation finished successfully. FALSEotherwise.
	 * Throws: GException on failure.
	 */
	public int pollMountableFinish(AsyncResultIF result);
	
	/**
	 * Starts a mount_operation, mounting the volume that contains the file location.
	 * When this operation has completed, callback will be called with
	 * user_user data, and the operation can be finalized with
	 * g_file_mount_enclosing_volume_finish().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * flags =  flags affecting the operation
	 * mountOperation =  a GMountOperation or NULL to avoid user interaction.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied, or NULL.
	 * userData =  the data to pass to callback function
	 */
	public void mountEnclosingVolume(GMountMountFlags flags, MountOperation mountOperation, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes a mount operation started by g_file_mount_enclosing_volume().
	 * Params:
	 * result =  a GAsyncResult.
	 * Returns: TRUE if successful. If an errorhas occurred, this function will return FALSE and set errorappropriately if present.
	 * Throws: GException on failure.
	 */
	public int mountEnclosingVolumeFinish(AsyncResultIF result);
	
	/**
	 * Obtains a directory monitor for the given file.
	 * This may fail if directory monitoring is not supported.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * flags =  a set of GFileMonitorFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileMonitor for the given file, or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileMonitor monitorDirectory(GFileMonitorFlags flags, Cancellable cancellable);
	
	/**
	 * Obtains a file monitor for the given file. If no file notification
	 * mechanism exists, then regular polling of the file is used.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * flags =  a set of GFileMonitorFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GFileMonitor for the given file, or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileMonitor monitorFile(GFileMonitorFlags flags, Cancellable cancellable);
	
	/**
	 * Obtains a file or directory monitor for the given file, depending
	 * on the type of the file.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Since 2.18
	 * Params:
	 * flags =  a set of GFileMonitorFlags
	 * cancellable =  optional GCancellable object, NULL to ignore
	 * Returns: a GFileMonitor for the given file, or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileMonitor monitor(GFileMonitorFlags flags, Cancellable cancellable);
	
	/**
	 * Loads the content of the file into memory. The data is always
	 * zero-terminated, but this is not included in the resultant length.
	 * The returned content should be freed with g_free() when no longer
	 * needed.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * contents =  a location to place the contents of the file.
	 * length =  a location to place the length of the contents of the file,
	 *  or NULL if the length is not needed
	 * etagOut =  a location to place the current entity tag for the file,
	 *  or NULL if the entity tag is not needed
	 * Returns: TRUE if the file's contents were successfully loaded.FALSE if there were errors.
	 * Throws: GException on failure.
	 */
	public int loadContents(Cancellable cancellable, out string contents, out uint length, out string etagOut);
	
	/**
	 * Starts an asynchronous load of the file's contents.
	 * For more details, see g_file_load_contents() which is
	 * the synchronous version of this call.
	 * When the load operation has completed, callback will be called
	 * with user data. To finish the operation, call
	 * g_file_load_contents_finish() with the GAsyncResult returned by
	 * the callback.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void loadContentsAsync(Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous load of the file's contents.
	 * The contents are placed in contents, and length is set to the
	 * size of the contents string. The content should be freed with
	 * g_free() when no longer needed. If etag_out is present, it will be
	 * set to the new entity tag for the file.
	 * Params:
	 * res =  a GAsyncResult.
	 * contents =  a location to place the contents of the file.
	 * length =  a location to place the length of the contents of the file,
	 *  or NULL if the length is not needed
	 * etagOut =  a location to place the current entity tag for the file,
	 *  or NULL if the entity tag is not needed
	 * Returns: TRUE if the load was successful. If FALSE and error is present, it will be set appropriately.
	 * Throws: GException on failure.
	 */
	public int loadContentsFinish(AsyncResultIF res, out string contents, out uint length, out string etagOut);
	
	/**
	 * Reads the partial contents of a file. A GFileReadMoreCallback should be
	 * used to stop reading from the file when appropriate, else this function
	 * will behave exactly as g_file_load_contents_async(). This operation
	 * can be finished by g_file_load_partial_contents_finish().
	 * Users of this function should be aware that user_data is passed to
	 * both the read_more_callback and the callback.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * Params:
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * readMoreCallback =  a GFileReadMoreCallback to receive partial data and to specify whether further data should be read.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to the callback functions.
	 */
	public void loadPartialContentsAsync(Cancellable cancellable, GFileReadMoreCallback readMoreCallback, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous partial load operation that was started
	 * with g_file_load_partial_contents_async(). The data is always
	 * zero-terminated, but this is not included in the resultant length.
	 * The returned content should be freed with g_free() when no longer
	 * needed.
	 * Params:
	 * res =  a GAsyncResult.
	 * contents =  a location to place the contents of the file.
	 * length =  a location to place the length of the contents of the file,
	 *  or NULL if the length is not needed
	 * etagOut =  a location to place the current entity tag for the file,
	 *  or NULL if the entity tag is not needed
	 * Returns: TRUE if the load was successful. If FALSE and error is present, it will be set appropriately.
	 * Throws: GException on failure.
	 */
	public int loadPartialContentsFinish(AsyncResultIF res, out string contents, out uint length, out string etagOut);
	
	/**
	 * Replaces the contents of file with contents of length bytes.
	 * If etag is specified (not NULL) any existing file must have that etag, or
	 * the error G_IO_ERROR_WRONG_ETAG will be returned.
	 * If make_backup is TRUE, this function will attempt to make a backup of file.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * The returned new_etag can be used to verify that the file hasn't changed the
	 * next time it is saved over.
	 * Params:
	 * contents =  a string containing the new contents for file.
	 * length =  the length of contents in bytes.
	 * etag =  the old entity tag
	 *  for the document, or NULL
	 * makeBackup =  TRUE if a backup should be created.
	 * flags =  a set of GFileCreateFlags.
	 * newEtag =  a location to a new entity tag
	 *  for the document. This should be freed with g_free() when no longer
	 *  needed, or NULL
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if successful. If an errorhas occurred, this function will return FALSE and set errorappropriately if present.
	 * Throws: GException on failure.
	 */
	public int replaceContents(string contents, uint length, string etag, int makeBackup, GFileCreateFlags flags, out string newEtag, Cancellable cancellable);
	
	/**
	 * Starts an asynchronous replacement of file with the given
	 * contents of length bytes. etag will replace the document's
	 * current entity tag.
	 * When this operation has completed, callback will be called with
	 * user_user data, and the operation can be finalized with
	 * g_file_replace_contents_finish().
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If make_backup is TRUE, this function will attempt to
	 * make a backup of file.
	 * Params:
	 * contents =  string of contents to replace the file with.
	 * length =  the length of contents in bytes.
	 * etag =  a new entity tag for the file, or NULL
	 * makeBackup =  TRUE if a backup should be created.
	 * flags =  a set of GFileCreateFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void replaceContentsAsync(string contents, uint length, string etag, int makeBackup, GFileCreateFlags flags, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous replace of the given file. See
	 * g_file_replace_contents_async(). Sets new_etag to the new entity
	 * tag for the document, if present.
	 * Params:
	 * res =  a GAsyncResult.
	 * newEtag =  a location of a new entity tag
	 *  for the document. This should be freed with g_free() when it is no
	 *  longer needed, or NULL
	 * Returns: TRUE on success, FALSE on failure.
	 * Throws: GException on failure.
	 */
	public int replaceContentsFinish(AsyncResultIF res, out string newEtag);
	
	/**
	 * Copies the file attributes from source to destination.
	 * Normally only a subset of the file attributes are copied,
	 * those that are copies in a normal file copy operation
	 * (which for instance does not include e.g. owner). However
	 * if G_FILE_COPY_ALL_METADATA is specified in flags, then
	 * all the metadata that is possible to copy is copied. This
	 * is useful when implementing move by copy + delete source.
	 * Params:
	 * destination =  a GFile to copy attributes to.
	 * flags =  a set of GFileCopyFlags.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: TRUE if the attributes were copied successfully, FALSE otherwise.
	 * Throws: GException on failure.
	 */
	public int copyAttributes(File destination, GFileCopyFlags flags, Cancellable cancellable);
	
	/**
	 * Creates a new file and returns a stream for reading and writing to it.
	 * The file must not already exist.
	 * By default files created are generally readable by everyone,
	 * but if you pass G_FILE_CREATE_PRIVATE in flags the file
	 * will be made readable only to the current user, to the level that
	 * is supported on the target filesystem.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If a file or directory with this name already exists the G_IO_ERROR_EXISTS
	 * error will be returned. Some file systems don't allow all file names,
	 * and may return an G_IO_ERROR_INVALID_FILENAME error, and if the name
	 * is too long, G_IO_ERROR_FILENAME_TOO_LONG will be returned. Other errors
	 * are possible too, and depend on what kind of filesystem the file is on.
	 * Note that in many non-local file cases read and write streams are not
	 * supported, so make sure you really need to do read and write streaming,
	 * rather than just opening for reading or writing.
	 * Since 2.22
	 * Params:
	 * flags =  a set of GFileCreateFlags
	 * cancellable =  optional GCancellable object, NULL to ignore
	 * Returns: a GFileIOStream for the newly created file, or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileIOStream createReadwrite(GFileCreateFlags flags, Cancellable cancellable);
	
	/**
	 * Asynchronously creates a new file and returns a stream for reading and
	 * writing to it. The file must not already exist.
	 * For more details, see g_file_create_readwrite() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then
	 * call g_file_create_readwrite_finish() to get the result of the operation.
	 * Since 2.22
	 * Params:
	 * flags =  a set of GFileCreateFlags
	 * ioPriority =  the I/O priority
	 *  of the request
	 * cancellable =  optional GCancellable object, NULL to ignore
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void createReadwriteAsync(GFileCreateFlags flags, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous file create operation started with
	 * g_file_create_readwrite_async().
	 * Since 2.22
	 * Params:
	 * res =  a GAsyncResult
	 * Returns: a GFileIOStream or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileIOStream createReadwriteFinish(AsyncResultIF res);
	
	/**
	 * Opens an existing file for reading and writing. The result is
	 * a GFileIOStream that can be used to read and write the contents of the file.
	 * If cancellable is not NULL, then the operation can be cancelled by
	 * triggering the cancellable object from another thread. If the operation
	 * was cancelled, the error G_IO_ERROR_CANCELLED will be returned.
	 * If the file does not exist, the G_IO_ERROR_NOT_FOUND error will be returned.
	 * If the file is a directory, the G_IO_ERROR_IS_DIRECTORY error will be returned.
	 * Other errors are possible too, and depend on what kind of filesystem the file is on.
	 * Note that in many non-local file cases read and write streams are not supported,
	 * so make sure you really need to do read and write streaming, rather than
	 * just opening for reading or writing.
	 * Since 2.22
	 * Params:
	 * cancellable =  a GCancellable
	 * Returns: GFileIOStream or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileIOStream openReadwrite(Cancellable cancellable);
	
	/**
	 * Asynchronously opens file for reading and writing.
	 * For more details, see g_file_open_readwrite() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then call
	 * g_file_open_readwrite_finish() to get the result of the operation.
	 * Since 2.22
	 * Params:
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void openReadwriteAsync(int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous file read operation started with
	 * g_file_open_readwrite_async().
	 * Since 2.22
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: a GFileIOStream or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileIOStream openReadwriteFinish(AsyncResultIF res);
	
	/**
	 * Returns an output stream for overwriting the file in readwrite mode,
	 * possibly creating a backup copy of the file first. If the file doesn't
	 * exist, it will be created.
	 * For details about the behaviour, see g_file_replace() which does the same
	 * thing but returns an output stream only.
	 * Note that in many non-local file cases read and write streams are not
	 * supported, so make sure you really need to do read and write streaming,
	 * rather than just opening for reading or writing.
	 * Since 2.22
	 * Params:
	 * etag =  an optional entity tag for the
	 *  current GFile, or NULL to ignore
	 * makeBackup =  TRUE if a backup should be created
	 * flags =  a set of GFileCreateFlags
	 * cancellable =  optional GCancellable object, NULL to ignore
	 * Returns: a GFileIOStream or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileIOStream replaceReadwrite(string etag, int makeBackup, GFileCreateFlags flags, Cancellable cancellable);
	
	/**
	 * Asynchronously overwrites the file in read-write mode, replacing the
	 * contents, possibly creating a backup copy of the file first.
	 * For more details, see g_file_replace_readwrite() which is
	 * the synchronous version of this call.
	 * When the operation is finished, callback will be called. You can then
	 * call g_file_replace_readwrite_finish() to get the result of the operation.
	 * Since 2.22
	 * Params:
	 * etag =  an entity tag for the
	 *  current GFile, or NULL to ignore.
	 * makeBackup =  TRUE if a backup should be created.
	 * flags =  a set of GFileCreateFlags.
	 * ioPriority =  the I/O priority
	 *  of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void replaceReadwriteAsync(string etag, int makeBackup, GFileCreateFlags flags, int ioPriority, Cancellable cancellable, GAsyncReadyCallback callback, void* userData);
	
	/**
	 * Finishes an asynchronous file replace operation started with
	 * g_file_replace_readwrite_async().
	 * Since 2.22
	 * Params:
	 * res =  a GAsyncResult.
	 * Returns: a GFileIOStream, or NULL on error. Free the returned object with g_object_unref().
	 * Throws: GException on failure.
	 */
	public FileIOStream replaceReadwriteFinish(AsyncResultIF res);
	
	/**
	 * Checks if file supports thread-default
	 * contexts. If this returns FALSE, you cannot perform
	 * asynchronous operations on file in a thread that has a
	 * thread-default context.
	 * Since 2.22
	 * Returns: Whether or not file supports thread-default contexts.
	 */
	public int supportsThreadContexts();
}
