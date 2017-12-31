module gtkD.gdkpixbuf.PixbufSimpleAnimation;

public  import gtkD.gtkc.gdkpixbuftypes;

private import gtkD.gtkc.gdkpixbuf;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Pixbuf;



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
public class PixbufSimpleAnimation : ObjectG
{
	
	/** the main Gtk struct */
	protected GdkPixbufSimpleAnim* gdkPixbufSimpleAnim;
	
	
	public GdkPixbufSimpleAnim* getPixbufSimpleAnimationStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkPixbufSimpleAnim* gdkPixbufSimpleAnim);
	
	/**
	 */
	
	/**
	 * Creates a new, empty animation.
	 * Since 2.8
	 * Params:
	 * width =  the width of the animation
	 * height =  the height of the animation
	 * rate =  the speed of the animation, in frames per second
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int width, int height, float rate);
	
	/**
	 * Adds a new frame to animation. The pixbuf must
	 * have the dimensions specified when the animation
	 * was constructed.
	 * Since 2.8
	 * Params:
	 * pixbuf =  the pixbuf to add
	 */
	public void addFrame(Pixbuf pixbuf);
	
	/**
	 * Sets whether animation should loop indefinitely when it reaches the end.
	 * Since 2.18
	 * Params:
	 * loop =  whether to loop the animation
	 */
	public void setLoop(int loop);
	
	/**
	 * Gets whether animation should loop indefinitely when it reaches the end.
	 * Since 2.18
	 * Returns: TRUE if the animation loops forever, FALSE otherwise
	 */
	public int getLoop();
}
