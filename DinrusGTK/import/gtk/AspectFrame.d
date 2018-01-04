module gtkD.gtk.AspectFrame;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gtk.Frame;

/**
 * Description
 * The GtkAspectFrame is useful when you want
 * pack a widget so that it can resize but always retains
 * the same aspect ratio. For instance, one might be
 * drawing a small preview of a larger image. GtkAspectFrame
 * derives from GtkFrame, so it can draw a label and
 * a frame around the child. The frame will be
 * "shrink-wrapped" to the size of the child.
 */
public class AspectFrame : Frame
{
	
	/** the main Gtk struct */
	protected GtkAspectFrame* gtkAspectFrame;
	
	
	public GtkAspectFrame* getAspectFrameStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkAspectFrame* gtkAspectFrame);
	
	/**
	 */
	
	/**
	 * Create a new GtkAspectFrame.
	 * Params:
	 * label = Label text.
	 * xalign = Horizontal alignment of the child within the allocation of
	 * the GtkAspectFrame. This ranges from 0.0 (left aligned)
	 * to 1.0 (right aligned)
	 * yalign = Vertical alignment of the child within the allocation of
	 * the GtkAspectFrame. This ranges from 0.0 (left aligned)
	 * to 1.0 (right aligned)
	 * ratio = The desired aspect ratio.
	 * obeyChild = If TRUE, ratio is ignored, and the aspect
	 *  ratio is taken from the requistion of the child.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label, float xalign, float yalign, float ratio, int obeyChild);
	
	/**
	 * Set parameters for an existing GtkAspectFrame.
	 * Params:
	 * xalign = Horizontal alignment of the child within the allocation of
	 * the GtkAspectFrame. This ranges from 0.0 (left aligned)
	 * to 1.0 (right aligned)
	 * yalign = Vertical alignment of the child within the allocation of
	 * the GtkAspectFrame. This ranges from 0.0 (left aligned)
	 * to 1.0 (right aligned)
	 * ratio = The desired aspect ratio.
	 * obeyChild = If TRUE, ratio is ignored, and the aspect
	 *  ratio is taken from the requistion of the child.
	 */
	public void set(float xalign, float yalign, float ratio, int obeyChild);
}
