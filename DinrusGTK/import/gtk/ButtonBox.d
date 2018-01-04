module gtkD.gtk.ButtonBox;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.gtk.Button;
private import gtkD.gtk.HButtonBox;
private import gtkD.gtk.VButtonBox;



private import gtkD.gtk.Box;

/**
 * Description
 * The primary purpose of this class is to keep track of the various properties
 * of GtkHButtonBox and GtkVButtonBox widgets.
 * gtk_button_box_get_child_size() retrieves the minimum width and height
 * for widgets in a given button box. gtk_button_box_set_child_size()
 * allows those properties to be changed.
 * The internal padding of buttons can be retrieved and changed per button box using
 * gtk_button_box_get_child_ipadding() and gtk_button_box_set_child_ipadding()
 * respectively.
 * gtk_button_box_get_spacing() and gtk_button_box_set_spacing() retrieve and
 * change default number of pixels between buttons, respectively.
 * gtk_button_box_get_layout() and gtk_button_box_set_layout() retrieve and alter the method
 * used to spread the buttons in a button box across the container, respectively.
 * The main purpose of GtkButtonBox is to make sure the children have all the same size.
 * Therefore it ignores the homogeneous property which it inherited from GtkBox, and always
 * behaves as if homogeneous was TRUE.
 */
public class ButtonBox : Box
{
	
	/** the main Gtk struct */
	protected GtkButtonBox* gtkButtonBox;
	
	
	public GtkButtonBox* getButtonBoxStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkButtonBox* gtkButtonBox);
	
	/** */
	static ButtonBox createActionBox(
	void delegate(Button) onClicked,
	StockID[] stocks,
	string[] actions,
	bool vertical=false
	);
	
	/** */
	static ButtonBox createOkBox(void delegate(Button) onClicked);
	
	/** */
	static ButtonBox createOkCancelBox(void delegate(Button) onClicked);

	/**
	 */
	
	/**
	 * Retrieves the method being used to arrange the buttons in a button box.
	 * Returns:the method used to layout buttons in widget.
	 */
	public GtkButtonBoxStyle getLayout();
	
	/**
	 * Warning
	 * gtk_button_box_get_child_size is deprecated and should not be used in newly-written code. Use the style properties
	 * "child-min-width/-height" instead.
	 * Retrieves the current width and height of all child widgets in a button box.
	 * min_width and min_height are filled with those values, respectively.
	 * Params:
	 * minWidth = the width of the buttons contained by widget.
	 * minHeight = the height of the buttons contained by widget.
	 */
	public void getChildSize(out int minWidth, out int minHeight);
	
	/**
	 * Warning
	 * gtk_button_box_get_child_ipadding is deprecated and should not be used in newly-written code. Use the style properties
	 *  "child-internal-pad-x"
	 *  and
	 *  "child-internal-pad-y"
	 *  instead.
	 * Gets the default number of pixels that pad the buttons in a given button box.
	 * Params:
	 * ipadX = the horizontal padding used by buttons in widget.
	 * ipadY = the vertical padding used by buttons in widget.
	 */
	public void getChildIpadding(out int ipadX, out int ipadY);
	
	/**
	 * Returns whether child should appear in a secondary group of children.
	 * Since 2.4
	 * Params:
	 * child =  a child of widget
	 * Returns: whether child should appear in a secondary group of children.
	 */
	public int getChildSecondary(Widget child);
	
	/**
	 * Changes the way buttons are arranged in their container.
	 * Params:
	 * layoutStyle = the new layout style.
	 */
	public void setLayout(GtkButtonBoxStyle layoutStyle);
	
	/**
	 * Warning
	 * gtk_button_box_set_child_size is deprecated and should not be used in newly-written code. Use the style properties
	 *  "child-min-width"
	 *  and
	 *  "child-min-height"
	 *  instead.
	 * Sets a new default size for the children of a given button box.
	 * Params:
	 * minWidth = a default width for buttons in widget
	 * minHeight = a default height for buttons in widget
	 */
	public void setChildSize(int minWidth, int minHeight);
	
	/**
	 * Warning
	 * gtk_button_box_set_child_ipadding is deprecated and should not be used in newly-written code. Use the style properties
	 * "child-internal-pad-x/-y" instead.
	 * Changes the amount of internal padding used by all buttons in a given button
	 * box.
	 * Params:
	 * ipadX = the horizontal padding that should be used by each button in widget.
	 * ipadY = the vertical padding that should be used by each button in widget.
	 */
	public void setChildIpadding(int ipadX, int ipadY);
	
	/**
	 * Sets whether child should appear in a secondary group of children.
	 * A typical use of a secondary child is the help button in a dialog.
	 * This group appears after the other children if the style
	 * is GTK_BUTTONBOX_START, GTK_BUTTONBOX_SPREAD or
	 * GTK_BUTTONBOX_EDGE, and before the other children if the style
	 * is GTK_BUTTONBOX_END. For horizontal button boxes, the definition
	 * of before/after depends on direction of the widget (see
	 * gtk_widget_set_direction()). If the style is GTK_BUTTONBOX_START
	 * or GTK_BUTTONBOX_END, then the secondary children are aligned at
	 * the other end of the button box from the main children. For the
	 * other styles, they appear immediately next to the main children.
	 * Params:
	 * child =  a child of widget
	 * isSecondary =  if TRUE, the child appears in a secondary group of the
	 *  button box.
	 */
	public void setChildSecondary(Widget child, int isSecondary);
}
