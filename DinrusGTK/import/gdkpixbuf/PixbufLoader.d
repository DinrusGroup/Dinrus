module gtkD.gdkpixbuf.PixbufLoader;

public  import gtkD.gtkc.gdkpixbuftypes;

private import gtkD.gtkc.gdkpixbuf;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gdkpixbuf.PixbufFormat;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gdk.Pixbuf;
private import gtkD.gdkpixbuf.PixbufAnimation;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 *  GdkPixbufLoader provides a way for applications to drive the
 *  process of loading an image, by letting them send the image data
 *  directly to the loader instead of having the loader read the data
 *  from a file. Applications can use this functionality instead of
 *  gdk_pixbuf_new_from_file() or gdk_pixbuf_animation_new_from_file()
 *  when they need to parse image data in
 *  small chunks. For example, it should be used when reading an
 *  image from a (potentially) slow network connection, or when
 *  loading an extremely large file.
 *  To use GdkPixbufLoader to load an image, just create a new one,
 *  and call gdk_pixbuf_loader_write() to send the data to it. When
 *  done, gdk_pixbuf_loader_close() should be called to end the stream
 *  and finalize everything. The loader will emit three important
 *  signals throughout the process. The first, "size_prepared",
 *  will be called as soon as the image has enough information to
 *  determine the size of the image to be used. If you want to scale
 *  the image while loading it, you can call gdk_pixbuf_loader_set_size()
 *  in response to this signal.
 * The second signal, "area_prepared",
 *  will be called as soon as the pixbuf of the desired has been
 *  allocated. You can obtain it by calling gdk_pixbuf_loader_get_pixbuf().
 *  If you want to use it, simply ref it.
 *  In addition, no actual information will be passed in yet, so the
 *  pixbuf can be safely filled with any temporary graphics (or an
 *  initial color) as needed. You can also call
 *  gdk_pixbuf_loader_get_pixbuf() later and get the same pixbuf.
 *  The last signal, "area_updated" gets
 *  called every time a region is updated. This way you can update a
 *  partially completed image. Note that you do not know anything
 *  about the completeness of an image from the area updated. For
 *  example, in an interlaced image, you need to make several passes
 *  before the image is done loading.
 * Loading an animation
 *  Loading an animation is almost as easy as loading an
 *  image. Once the first "area_prepared" signal
 *  has been emitted, you can call gdk_pixbuf_loader_get_animation()
 *  to get the GdkPixbufAnimation struct and gdk_pixbuf_animation_get_iter()
 *  to get an GdkPixbufAnimationIter for displaying it.
 */
public class PixbufLoader : ObjectG
{
	
	/** the main Gtk struct */
	protected GdkPixbufLoader* gdkPixbufLoader;
	
	
	public GdkPixbufLoader* getPixbufLoaderStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkPixbufLoader* gdkPixbufLoader);
	
	/**
	 * Creates a new pixbuf loader object that always attempts to parse
	 * image data as if it were an image of type image_type or mime_type, instead of
	 * identifying the type automatically. Useful if you want an error if
	 * the image isn't the expected type, for loading image formats
	 * that can't be reliably identified by looking at the data, or if
	 * the user manually forces a specific type.
	 * Params:
	 *  type = name of the image format or mime to be loaded with the image
	 */
	public this (string type, bool isMimeType=false);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(PixbufLoader)[] onAreaPreparedListeners;
	/**
	 * This signal is emitted when the pixbuf loader has allocated the
	 * pixbuf in the desired size. After this signal is emitted,
	 * applications can call gdk_pixbuf_loader_get_pixbuf() to fetch
	 * the partially-loaded pixbuf.
	 *
	 */
	void addOnAreaPrepared(void delegate(PixbufLoader) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAreaPrepared(GdkPixbufLoader* loaderStruct, PixbufLoader pixbufLoader);
	
	void delegate(gint, gint, gint, gint, PixbufLoader)[] onAreaUpdatedListeners;
	/**
	 * This signal is emitted when a significant area of the image being
	 * loaded has been updated. Normally it means that a complete
	 * scanline has been read in, but it could be a different area as
	 * well. Applications can use this signal to know when to repaint
	 * areas of an image that is being loaded.
	 *
	 */
	void addOnAreaUpdated(void delegate(gint, gint, gint, gint, PixbufLoader) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAreaUpdated(GdkPixbufLoader* loaderStruct, gint x, gint y, gint width, gint height, PixbufLoader pixbufLoader);
	
	void delegate(PixbufLoader)[] onClosedListeners;
	/**
	 * This signal is emitted when gdk_pixbuf_loader_close() is called.
	 * It can be used by different parts of an application to receive
	 * notification when an image loader is closed by the code that
	 * drives it.
	 *
	 */
	void addOnClosed(void delegate(PixbufLoader) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackClosed(GdkPixbufLoader* loaderStruct, PixbufLoader pixbufLoader);
	
	void delegate(gint, gint, PixbufLoader)[] onSizePreparedListeners;
	/**
	 * This signal is emitted when the pixbuf loader has been fed the
	 * initial amount of data that is required to figure out the size
	 * of the image that it will create. Applications can call
	 * gdk_pixbuf_loader_set_size() in response to this signal to set
	 * the desired size to which the image should be scaled.
	 *
	 * See Also
	 *  gdk_pixbuf_new_from_file(), gdk_pixbuf_animation_new_from_file()
	 *
	 */
	void addOnSizePrepared(void delegate(gint, gint, PixbufLoader) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSizePrepared(GdkPixbufLoader* loaderStruct, gint width, gint height, PixbufLoader pixbufLoader);
	
	
	/**
	 * Creates a new pixbuf loader object.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Obtains the available information about the format of the
	 * currently loading image file.
	 * Since 2.2
	 * Returns: A GdkPixbufFormat or NULL. The return value is owned by GdkPixbuf and should not be freed.
	 */
	public PixbufFormat getFormat();
	
	/**
	 * This will cause a pixbuf loader to parse the next count bytes of
	 * an image. It will return TRUE if the data was loaded successfully,
	 * and FALSE if an error occurred. In the latter case, the loader
	 * will be closed, and will not accept further writes. If FALSE is
	 * returned, error will be set to an error from the GDK_PIXBUF_ERROR
	 * or G_FILE_ERROR domains.
	 * Params:
	 * buf =  Pointer to image data.
	 * Returns: TRUE if the write was successful, or FALSE if the loadercannot parse the buffer.
	 * Throws: GException on failure.
	 */
	public int write(char[] buf);
	
	/**
	 * Causes the image to be scaled while it is loaded. The desired
	 * image size can be determined relative to the original size of
	 * the image by calling gdk_pixbuf_loader_set_size() from a
	 * signal handler for the ::size-prepared signal.
	 * Attempts to set the desired image size are ignored after the
	 * emission of the ::size-prepared signal.
	 * Since 2.2
	 * Params:
	 * width =  The desired width of the image being loaded.
	 * height =  The desired height of the image being loaded.
	 */
	public void setSize(int width, int height);
	
	/**
	 * Queries the GdkPixbuf that a pixbuf loader is currently creating.
	 * In general it only makes sense to call this function after the
	 * "area-prepared" signal has been emitted by the loader; this means
	 * that enough data has been read to know the size of the image that
	 * will be allocated. If the loader has not received enough data via
	 * gdk_pixbuf_loader_write(), then this function returns NULL. The
	 * returned pixbuf will be the same in all future calls to the loader,
	 * so simply calling g_object_ref() should be sufficient to continue
	 * using it. Additionally, if the loader is an animation, it will
	 * return the "static image" of the animation
	 * (see gdk_pixbuf_animation_get_static_image()).
	 * Returns: The GdkPixbuf that the loader is creating, or NULL if notenough data has been read to determine how to create the image buffer.
	 */
	public Pixbuf getPixbuf();
	
	/**
	 * Queries the GdkPixbufAnimation that a pixbuf loader is currently creating.
	 * In general it only makes sense to call this function after the "area-prepared"
	 * signal has been emitted by the loader. If the loader doesn't have enough
	 * bytes yet (hasn't emitted the "area-prepared" signal) this function will
	 * return NULL.
	 * Returns: The GdkPixbufAnimation that the loader is loading, or NULL if not enough data has been read to determine the information.
	 */
	public PixbufAnimation getAnimation();
	
	/**
	 * Informs a pixbuf loader that no further writes with
	 * gdk_pixbuf_loader_write() will occur, so that it can free its
	 * internal loading structures. Also, tries to parse any data that
	 * hasn't yet been parsed; if the remaining data is partial or
	 * corrupt, an error will be returned. If FALSE is returned, error
	 * will be set to an error from the GDK_PIXBUF_ERROR or G_FILE_ERROR
	 * domains. If you're just cancelling a load rather than expecting it
	 * to be finished, passing NULL for error to ignore it is
	 * reasonable.
	 * Returns: TRUE if all image data written so far was successfully passed out via the update_area signalSignal DetailsThe "area-prepared" signalvoid user_function (GdkPixbufLoader *loader, gpointer user_data) : Run LastThis signal is emitted when the pixbuf loader has allocated thepixbuf in the desired size. After this signal is emitted, applications can call gdk_pixbuf_loader_get_pixbuf() to fetch the partially-loaded pixbuf.
	 * Throws: GException on failure.
	 */
	public int close();
}
