module gtkD.gdkpixbuf.PixbufFormat;

public  import gtkD.gtkc.gdkpixbuftypes;

private import gtkD.gtkc.gdkpixbuf;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Pixbuf;
private import gtkD.glib.ListSG;
private import gtkD.glib.Str;




/**
 * Description
 * If gdk-pixbuf has been compiled with GModule support, it can be extended by
 * modules which can load (and perhaps also save) new image and animation
 * formats. Each loadable module must export a
 * GdkPixbufModuleFillInfoFunc function named fill_info and
 * a GdkPixbufModuleFillVtableFunc function named
 * fill_vtable.
 * In order to make format-checking work before actually loading the modules
 * (which may require dlopening image libraries), modules export their
 * signatures (and other information) via the fill_info
 * function. An external utility, gdk-pixbuf-query-loaders,
 * uses this to create a text file containing a list of all available loaders and
 * their signatures. This file is then read at runtime by gdk-pixbuf to obtain
 * the list of available loaders and their signatures.
 * Modules may only implement a subset of the functionality available via
 * GdkPixbufModule. If a particular functionality is not implemented, the
 * fill_vtable function will simply not set the corresponding
 * function pointers of the GdkPixbufModule structure. If a module supports
 * incremental loading (i.e. provides begin_load, stop_load and
 * load_increment), it doesn't have to implement load, since gdk-pixbuf can
 * supply a generic load implementation wrapping the incremental loading.
 * Installing a module is a two-step process:
 * copy the module file(s) to the loader directory (normally
 * libdir/gtk-2.0/version/loaders,
 * unless overridden by the environment variable
 * GDK_PIXBUF_MODULEDIR)
 * call gdk-pixbuf-query-loaders to update the
 * module file (normally
 * sysconfdir/gtk-2.0/gdk-pixbuf.loaders,
 * unless overridden by the environment variable
 * GDK_PIXBUF_MODULE_FILE)
 * The gdk-pixbuf interfaces needed for implementing modules are contained in
 * gdk-pixbuf-io.h (and
 * gdk-pixbuf-animation.h if the module supports animations).
 * They are not covered by the same stability guarantees as the regular
 * gdk-pixbuf API. To underline this fact, they are protected by
 * #ifdef GDK_PIXBUF_ENABLE_BACKEND.
 */
public class PixbufFormat
{
	
	/** the main Gtk struct */
	protected GdkPixbufFormat* gdkPixbufFormat;
	
	
	public GdkPixbufFormat* getPixbufFormatStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkPixbufFormat* gdkPixbufFormat);
	
	/**
	 * Description
	 *  The gdk-pixbuf library provides a simple mechanism for loading
	 *  an image from a file in synchronous fashion. This means that the
	 *  library takes control of the application while the file is being
	 *  loaded; from the user's point of view, the application will block
	 *  until the image is done loading.
	 *  This interface can be used by applications in which blocking is
	 *  acceptable while an image is being loaded. It can also be used to
	 *  load small images in general. Applications that need progressive
	 *  loading can use the GdkPixbufLoader functionality instead.
	 */
	
	/**
	 * Attaches a key/value pair as an option to a GdkPixbuf. If key already
	 * exists in the list of options attached to pixbuf, the new value is
	 * ignored and FALSE is returned.
	 * Since 2.2
	 * Params:
	 * pixbuf =  a GdkPixbuf
	 * key =  a nul-terminated string.
	 * value =  a nul-terminated string.
	 * Returns: TRUE on success.
	 */
	public static int gdkPixbufSetOption(Pixbuf pixbuf, string key, string value);
	
	/**
	 * Obtains the available information about the image formats supported
	 * by GdkPixbuf.
	 * Since 2.2
	 * Returns: A list of GdkPixbufFormats describing the supported image formats. The list should be freed when it is no longer needed, but the structures themselves are owned by GdkPixbuf and should not be freed.
	 */
	public static ListSG gdkPixbufGetFormats();
	
	/**
	 * Returns the name of the format.
	 * Since 2.2
	 * Returns: the name of the format.
	 */
	public string getName();
	
	/**
	 * Returns a description of the format.
	 * Since 2.2
	 * Returns: a description of the format.
	 */
	public string getDescription();
	
	/**
	 * Returns the mime types supported by the format.
	 * Since 2.2
	 * Returns: a NULL-terminated array of mime types which must be freed with g_strfreev() when it is no longer needed.
	 */
	public string[] getMimeTypes();
	
	/**
	 * Returns the filename extensions typically used for files in the
	 * given format.
	 * Since 2.2
	 * Returns: a NULL-terminated array of filename extensions which must befreed with g_strfreev() when it is no longer needed.
	 */
	public string[] getExtensions();
	
	/**
	 * Returns whether pixbufs can be saved in the given format.
	 * Since 2.2
	 * Returns: whether pixbufs can be saved in the given format.
	 */
	public int isWritable();
	
	/**
	 * Returns whether this image format is scalable. If a file is in a
	 * scalable format, it is preferable to load it at the desired size,
	 * rather than loading it at the default size and scaling the
	 * resulting pixbuf to the desired size.
	 * Since 2.6
	 * Returns: whether this image format is scalable.
	 */
	public int isScalable();
	
	/**
	 * Returns whether this image format is disabled. See
	 * gdk_pixbuf_format_set_disabled().
	 * Since 2.6
	 * Returns: whether this image format is disabled.
	 */
	public int isDisabled();
	
	/**
	 * Disables or enables an image format. If a format is disabled,
	 * gdk-pixbuf won't use the image loader for this format to load
	 * images. Applications can use this to avoid using image loaders
	 * with an inappropriate license, see gdk_pixbuf_format_get_license().
	 * Since 2.6
	 * Params:
	 * disabled =  TRUE to disable the format format
	 */
	public void setDisabled(int disabled);
	
	/**
	 * Returns information about the license of the image loader for the format. The
	 * returned string should be a shorthand for a wellknown license, e.g. "LGPL",
	 * "GPL", "QPL", "GPL/QPL", or "other" to indicate some other license. This
	 * string should be freed with g_free() when it's no longer needed.
	 * Since 2.6
	 * Returns: a string describing the license of format.
	 */
	public string getLicense();
	
	/**
	 * Parses an image file far enough to determine its format and size.
	 * Since 2.4
	 * Params:
	 * filename =  The name of the file to identify.
	 * width =  Return location for the width of the image, or NULL
	 * height =  Return location for the height of the image, or NULL
	 * Returns: A GdkPixbufFormat describing the image format of the file  or NULL if the image format wasn't recognized. The return value  is owned by GdkPixbuf and should not be freed.
	 */
	public static PixbufFormat getFileInfo(string filename, out int width, out int height);
}
