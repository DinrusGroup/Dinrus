module gtkD.gdkpixbuf.PixbufAnimation;

public  import gtkD.gtkc.gdkpixbuftypes;

private import gtkD.gtkc.gdkpixbuf;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gdkpixbuf.PixbufAnimationIter;
private import gtkD.glib.TimeVal;
private import gtkD.gdk.Pixbuf;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 *  The gdk-pixbuf library provides a simple mechanism to load and represent
 *  animations. An animation is conceptually a series of frames to be displayed
 *  over time. Each frame is the same size. The animation may not be represented
 *  as a series of frames internally; for example, it may be stored as a
 *  sprite and instructions for moving the sprite around a background. To display
 *  an animation you don't need to understand its representation, however; you just
 *  ask gdk-pixbuf what should be displayed at a given point in time.
 */
public class PixbufAnimation : ObjectG
{
	
	/** the main Gtk struct */
	protected GdkPixbufAnimation* gdkPixbufAnimation;
	
	
	public GdkPixbufAnimation* getPixbufAnimationStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkPixbufAnimation* gdkPixbufAnimation);
	
	/**
	 */
	
	/**
	 * Creates a new animation by loading it from a file. The file format is
	 * detected automatically. If the file's format does not support multi-frame
	 * images, then an animation with a single frame will be created. Possible errors
	 * are in the GDK_PIXBUF_ERROR and G_FILE_ERROR domains.
	 * Params:
	 * filename =  Name of file to load, in the GLib file name encoding
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string filename);
	
	/**
	 * Warning
	 * gdk_pixbuf_animation_ref is deprecated and should not be used in newly-written code. Use g_object_ref().
	 * Adds a reference to an animation.
	 * Returns: The same as the animation argument.
	 */
	public PixbufAnimation doref();
	
	/**
	 * Warning
	 * gdk_pixbuf_animation_unref is deprecated and should not be used in newly-written code. Use g_object_unref().
	 * Removes a reference from an animation.
	 */
	public void unref();
	
	/**
	 * Queries the width of the bounding box of a pixbuf animation.
	 * Returns: Width of the bounding box of the animation.
	 */
	public int getWidth()
	{
		// int gdk_pixbuf_animation_get_width (GdkPixbufAnimation *animation);
		return gdk_pixbuf_animation_get_width(gdkPixbufAnimation);
	}
	
	/**
	 * Queries the height of the bounding box of a pixbuf animation.
	 * Returns: Height of the bounding box of the animation.
	 */
	public int getHeight();
	
	/**
	 * Get an iterator for displaying an animation. The iterator provides
	 * the frames that should be displayed at a given time.
	 * It should be freed after use with g_object_unref().
	 * start_time would normally come from g_get_current_time(), and
	 * marks the beginning of animation playback. After creating an
	 * iterator, you should immediately display the pixbuf returned by
	 * gdk_pixbuf_animation_iter_get_pixbuf(). Then, you should install a
	 * timeout (with g_timeout_add()) or by some other mechanism ensure
	 * that you'll update the image after
	 * gdk_pixbuf_animation_iter_get_delay_time() milliseconds. Each time
	 * the image is updated, you should reinstall the timeout with the new,
	 * possibly-changed delay time.
	 * As a shortcut, if start_time is NULL, the result of
	 * g_get_current_time() will be used automatically.
	 * To update the image (i.e. possibly change the result of
	 * gdk_pixbuf_animation_iter_get_pixbuf() to a new frame of the animation),
	 * call gdk_pixbuf_animation_iter_advance().
	 * If you're using GdkPixbufLoader, in addition to updating the image
	 * after the delay time, you should also update it whenever you
	 * receive the area_updated signal and
	 * gdk_pixbuf_animation_iter_on_currently_loading_frame() returns
	 * TRUE. In this case, the frame currently being fed into the loader
	 * has received new data, so needs to be refreshed. The delay time for
	 * a frame may also be modified after an area_updated signal, for
	 * example if the delay time for a frame is encoded in the data after
	 * the frame itself. So your timeout should be reinstalled after any
	 * area_updated signal.
	 * A delay time of -1 is possible, indicating "infinite."
	 * Params:
	 * startTime =  time when the animation starts playing
	 * Returns: an iterator to move over the animation
	 */
	public PixbufAnimationIter getIter(TimeVal startTime);
	
	/**
	 * If you load a file with gdk_pixbuf_animation_new_from_file() and it turns
	 * out to be a plain, unanimated image, then this function will return
	 * TRUE. Use gdk_pixbuf_animation_get_static_image() to retrieve
	 * the image.
	 * Returns: TRUE if the "animation" was really just an image
	 */
	public int isStaticImage();
	
	/**
	 * If an animation is really just a plain image (has only one frame),
	 * this function returns that image. If the animation is an animation,
	 * this function returns a reasonable thing to display as a static
	 * unanimated image, which might be the first frame, or something more
	 * sophisticated. If an animation hasn't loaded any frames yet, this
	 * function will return NULL.
	 * Returns: unanimated image representing the animation
	 */
	public Pixbuf getStaticImage();
}
