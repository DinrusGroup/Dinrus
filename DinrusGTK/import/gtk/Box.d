module gtkD.gtk.Box;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.gtk.OrientableIF;
private import gtkD.gtk.OrientableT;



private import gtkD.gtk.Container;

/**
 * Description
 * GtkBox is an abstract widget which encapsulates functionality for a
 * particular kind of container, one that organizes a variable number of
 * widgets into a rectangular area. GtkBox has a number of derived
 * classes, e.g. GtkHBox and GtkVBox.
 * The rectangular area of a GtkBox is organized into either a single row
 * or a single column of child widgets depending upon whether the box is
 * of type GtkHBox or GtkVBox, respectively. Thus, all children of a
 * GtkBox are allocated one dimension in common, which is the height of a
 * row, or the width of a column.
 * GtkBox uses a notion of packing. Packing refers to
 * adding widgets with reference to a particular position in a
 * GtkContainer. For a GtkBox, there are two reference positions: the
 * start and the end of the box.
 * For a GtkVBox, the start is defined as the top of the box and the end is
 * defined as the bottom. For a GtkHBox the start is defined as the
 * left side and the end is defined as the right side.
 * Use repeated calls to gtk_box_pack_start() to pack widgets into a
 * GtkBox from start to end. Use gtk_box_pack_end() to add widgets from
 * end to start. You may intersperse these calls and add widgets from
 * both ends of the same GtkBox.
 * Use gtk_box_pack_start_defaults() or gtk_box_pack_end_defaults()
 * to pack widgets into a GtkBox if you do not need to specify the
 * "expand", "fill", or "padding" child properties
 * for the child to be added.
 * Because GtkBox is a GtkContainer, you may also use
 * gtk_container_add() to insert widgets into the box, and they will be
 * packed as if with gtk_box_pack_start_defaults(). Use
 * gtk_container_remove() to remove widgets from the GtkBox.
 * Use gtk_box_set_homogeneous() to specify whether or not all children
 * of the GtkBox are forced to get the same amount of space.
 * Use gtk_box_set_spacing() to determine how much space will be
 * minimally placed between all children in the GtkBox.
 * Use gtk_box_reorder_child() to move a GtkBox child to a different
 * place in the box.
 * Use gtk_box_set_child_packing() to reset the "expand",
 * "fill" and "padding" child properties.
 * Use gtk_box_query_child_packing() to query these fields.
 */
public class Box : Container, OrientableIF
{
	
	/** the main Gtk struct */
	protected GtkBox* gtkBox;
	
	
	public GtkBox* getBoxStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkBox* gtkBox);
	
	// add the Orientable capabilities
	mixin OrientableT!(GtkBox);
	
	/**
	 */
	
	/**
	 * Adds child to box, packed with reference to the start of box.
	 * The child is packed after any other child packed with reference
	 * to the start of box.
	 * Params:
	 * child =  the GtkWidget to be added to box
	 * expand =  TRUE if the new child is to be given extra space allocated to
	 * box. The extra space will be divided evenly between all children of
	 * box that use this option
	 * fill =  TRUE if space given to child by the expand option is
	 *  actually allocated to child, rather than just padding it. This
	 *  parameter has no effect if expand is set to FALSE. A child is
	 *  always allocated the full height of a GtkHBox and the full width
	 *  of a GtkVBox. This option affects the other dimension
	 * padding =  extra space in pixels to put between this child and its
	 *  neighbors, over and above the global amount specified by
	 *  "spacing" property. If child is a widget at one of the
	 *  reference ends of box, then padding pixels are also put between
	 *  child and the reference edge of box
	 */
	public void packStart(Widget child, int expand, int fill, uint padding);
	
	/**
	 * Adds child to box, packed with reference to the end of box.
	 * The child is packed after (away from end of) any other child
	 * packed with reference to the end of box.
	 * Params:
	 * child =  the GtkWidget to be added to box
	 * expand =  TRUE if the new child is to be given extra space allocated
	 *  to box. The extra space will be divided evenly between all children
	 *  of box that use this option
	 * fill =  TRUE if space given to child by the expand option is
	 *  actually allocated to child, rather than just padding it. This
	 *  parameter has no effect if expand is set to FALSE. A child is
	 *  always allocated the full height of a GtkHBox and the full width
	 *  of a GtkVBox. This option affects the other dimension
	 * padding =  extra space in pixels to put between this child and its
	 *  neighbors, over and above the global amount specified by
	 *  "spacing" property. If child is a widget at one of the
	 *  reference ends of box, then padding pixels are also put between
	 *  child and the reference edge of box
	 */
	public void packEnd(Widget child, int expand, int fill, uint padding);
	
	/**
	 * Warning
	 * gtk_box_pack_start_defaults has been deprecated since version 2.14 and should not be used in newly-written code. Use gtk_box_pack_start()
	 * Adds widget to box, packed with reference to the start of box.
	 * The child is packed after any other child packed with reference
	 * to the start of box.
	 * Parameters for how to pack the child widget, "expand",
	 * "fill" and "padding", are given their default
	 * values, TRUE, TRUE, and 0, respectively.
	 * Params:
	 * widget =  the GtkWidget to be added to box
	 */
	public void packStartDefaults(Widget widget);
	
	/**
	 * Warning
	 * gtk_box_pack_end_defaults has been deprecated since version 2.14 and should not be used in newly-written code. Use gtk_box_pack_end()
	 * Adds widget to box, packed with reference to the end of box.
	 * The child is packed after any other child packed with reference
	 * to the start of box.
	 * Parameters for how to pack the child widget, "expand",
	 * "fill" and "padding", are given their default
	 * values, TRUE, TRUE, and 0, respectively.
	 * Params:
	 * widget =  the GtkWidget to be added to box
	 */
	public void packEndDefaults(Widget widget);
	
	/**
	 * Returns whether the box is homogeneous (all children are the
	 * same size). See gtk_box_set_homogeneous().
	 * Returns: TRUE if the box is homogeneous.
	 */
	public int getHomogeneous();
	
	/**
	 * Sets the "homogeneous" property of box, controlling
	 * whether or not all children of box are given equal space
	 * in the box.
	 * Params:
	 * homogeneous =  a boolean value, TRUE to create equal allotments,
	 *  FALSE for variable allotments
	 */
	public void setHomogeneous(int homogeneous);
	
	/**
	 * Gets the value set by gtk_box_set_spacing().
	 * Returns: spacing between children
	 */
	public int getSpacing();
	
	/**
	 * Sets the "spacing" property of box, which is the
	 * number of pixels to place between children of box.
	 * Params:
	 * spacing =  the number of pixels to put between children
	 */
	public void setSpacing(int spacing);
	
	/**
	 * Moves child to a new position in the list of box children.
	 * The list is the children field of
	 * GtkBox, and contains both widgets packed GTK_PACK_START
	 * as well as widgets packed GTK_PACK_END, in the order that these
	 * widgets were added to box.
	 * A widget's position in the box children list determines where
	 * the widget is packed into box. A child widget at some position
	 * in the list will be packed just after all other widgets of the
	 * same packing type that appear earlier in the list.
	 * Params:
	 * child =  the GtkWidget to move
	 * position =  the new position for child in the list of children
	 *  of box, starting from 0. If negative, indicates the end of
	 *  the list
	 */
	public void reorderChild(Widget child, int position);
	
	/**
	 * Obtains information about how child is packed into box.
	 * Params:
	 * child =  the GtkWidget of the child to query
	 * expand =  pointer to return location for "expand" child property
	 * fill =  pointer to return location for "fill" child property
	 * padding =  pointer to return location for "padding" child property
	 * packType =  pointer to return location for "pack-type" child property
	 */
	public void queryChildPacking(Widget child, out int expand, out int fill, out uint padding, out GtkPackType packType);
	
	/**
	 * Sets the way child is packed into box.
	 * Params:
	 * child =  the GtkWidget of the child to set
	 * expand =  the new value of the "expand" child property
	 * fill =  the new value of the "fill" child property
	 * padding =  the new value of the "padding" child property
	 * packType =  the new value of the "pack-type" child property
	 */
	public void setChildPacking(Widget child, int expand, int fill, uint padding, GtkPackType packType);
}
