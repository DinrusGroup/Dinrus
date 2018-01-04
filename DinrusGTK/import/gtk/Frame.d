module gtkD.gtk.Frame;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;



private import gtkD.gtk.Bin;

/**
 * Description
 * The frame widget is a Bin that surrounds its child
 * with a decorative frame and an optional label.
 * If present, the label is drawn in a gap in the
 * top side of the frame. The position of the
 * label can be controlled with gtk_frame_set_label_align().
 * GtkFrame as GtkBuildable
 * The GtkFrame implementation of the GtkBuildable interface
 * supports placing a child in the label position by specifying
 * "label" as the "type" attribute of a <child> element.
 * A normal content child can be specified without specifying
 * a <child> type attribute.
 * Example 45. A UI definition fragment with GtkFrame
 * <object class="GtkFrame">
 *  <child type="label">
 *  <object class="GtkLabel" id="frame-label"/>
 *  </child>
 *  <child>
 *  <object class="GtkEntry" id="frame-content"/>
 *  </child>
 * </object>
 */
public class Frame : Bin
{
	
	/** the main Gtk struct */
	protected GtkFrame* gtkFrame;
	
	
	public GtkFrame* getFrameStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkFrame* gtkFrame);
	
	/**
	 * Creates frame with label and set it's child widget
	 */
	public this(Widget widget, string label);
	
	/**
	 */
	
	/**
	 * Creates a new GtkFrame, with optional label label.
	 * If label is NULL, the label is omitted.
	 * Params:
	 * label =  the text to use as the label of the frame
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label);
	
	/**
	 * Sets the text of the label. If label is NULL,
	 * the current label is removed.
	 * Params:
	 * label =  the text to use as the label of the frame
	 */
	public void setLabel(string label);

	/**
	 * Sets the label widget for the frame. This is the widget that
	 * will appear embedded in the top edge of the frame as a
	 * title.
	 * Params:
	 * labelWidget =  the new label widget
	 */
	public void setLabelWidget(Widget labelWidget);
	
	/**
	 * Sets the alignment of the frame widget's label. The
	 * default values for a newly created frame are 0.0 and 0.5.
	 * Params:
	 * xalign =  The position of the label along the top edge
	 *  of the widget. A value of 0.0 represents left alignment;
	 *  1.0 represents right alignment.
	 * yalign =  The y alignment of the label. A value of 0.0 aligns under
	 *  the frame; 1.0 aligns above the frame. If the values are exactly
	 *  0.0 or 1.0 the gap in the frame won't be painted because the label
	 *  will be completely above or below the frame.
	 */
	public void setLabelAlign(float xalign, float yalign);
	
	/**
	 * Sets the shadow type for frame.
	 * Params:
	 * type =  the new GtkShadowType
	 */
	public void setShadowType(GtkShadowType type);
	
	/**
	 * If the frame's label widget is a GtkLabel, returns the
	 * text in the label widget. (The frame will have a GtkLabel
	 * for the label widget if a non-NULL argument was passed
	 * to gtk_frame_new().)
	 * Returns: the text in the label, or NULL if there was no label widget or the lable widget was not a GtkLabel. This string is owned by GTK+ and must not be modified or freed.
	 */
	public string getLabel();
	
	/**
	 * Retrieves the X and Y alignment of the frame's label. See
	 * gtk_frame_set_label_align().
	 * Params:
	 * xalign =  location to store X alignment of frame's label, or NULL
	 * yalign =  location to store X alignment of frame's label, or NULL
	 */
	public void getLabelAlign(out float xalign, out float yalign);
	
	/**
	 * Retrieves the label widget for the frame. See
	 * gtk_frame_set_label_widget().
	 * Returns: the label widget, or NULL if there is none.
	 */
	public Widget getLabelWidget();
	
	/**
	 * Retrieves the shadow type of the frame. See
	 * gtk_frame_set_shadow_type().
	 * Returns: the current shadow type of the frame.
	 */
	public GtkShadowType getShadowType();
}
