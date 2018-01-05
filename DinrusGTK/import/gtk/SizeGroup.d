
module gtkD.gtk.SizeGroup;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.glib.ListSG;
private import gtkD.gtk.BuildableIF;
private import gtkD.gtk.BuildableT;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GtkSizeGroup provides a mechanism for grouping a number of widgets
 * together so they all request the same amount of space. This is
 * typically useful when you want a column of widgets to have the same
 * size, but you can't use a GtkTable widget.
 * In detail, the size requested for each widget in a GtkSizeGroup is
 * the maximum of the sizes that would have been requested for each
 * widget in the size group if they were not in the size group. The mode
 * of the size group (see gtk_size_group_set_mode()) determines whether
 * this applies to the horizontal size, the vertical size, or both sizes.
 * Note that size groups only affect the amount of space requested, not
 * the size that the widgets finally receive. If you want the widgets in
 * a GtkSizeGroup to actually be the same size, you need to pack them in
 * such a way that they get the size they request and not more. For
 * example, if you are packing your widgets into a table, you would not
 * include the GTK_FILL flag.
 * GtkSizeGroup objects are referenced by each widget in the size group,
 * so once you have added all widgets to a GtkSizeGroup, you can drop
 * the initial reference to the size group with g_object_unref(). If the
 * widgets in the size group are subsequently destroyed, then they will
 * be removed from the size group and drop their references on the size
 * group; when all widgets have been removed, the size group will be
 * freed.
 * Widgets can be part of multiple size groups; GTK+ will compute the
 * horizontal size of a widget from the horizontal requisition of all
 * widgets that can be reached from the widget by a chain of size groups
 * of type GTK_SIZE_GROUP_HORIZONTAL or GTK_SIZE_GROUP_BOTH, and the
 * vertical size from the vertical requisition of all widgets that can be
 * reached from the widget by a chain of size groups of type
 * GTK_SIZE_GROUP_VERTICAL or GTK_SIZE_GROUP_BOTH.
 * GtkSizeGroup as GtkBuildable
 * Size groups can be specified in a UI definition by placing an
 * <object> element with class="GtkSizeGroup"
 * somewhere in the UI definition. The widgets that belong to the
 * size group are specified by a <widgets> element that may
 * contain multiple <widget> elements, one for each member
 * of the size group. The name attribute gives the id of the widget.
 * Example 51. A UI definition fragment with GtkSizeGroup
 * <object class="GtkSizeGroup">
 *  <property name="mode">GTK_SIZE_GROUP_HORIZONTAL</property>
 *  <widgets>
 *  <widget name="radio1"/>
 *  <widget name="radio2"/>
 *  </widgets>
 * </object>
 */
public class SizeGroup : ObjectG, BuildableIF
{
	
	/** the main Gtk struct */
	protected GtkSizeGroup* gtkSizeGroup;
	
	
	public GtkSizeGroup* getSizeGroupStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSizeGroup* gtkSizeGroup);
	
	// add the Buildable capabilities
	mixin BuildableT!(GtkSizeGroup);
	
	/**
	 */
	
	/**
	 * Create a new GtkSizeGroup.
	 * Params:
	 * mode =  the mode for the new size group.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GtkSizeGroupMode mode);
	
	/**
	 * Sets the GtkSizeGroupMode of the size group. The mode of the size
	 * group determines whether the widgets in the size group should
	 * all have the same horizontal requisition (GTK_SIZE_GROUP_MODE_HORIZONTAL)
	 * all have the same vertical requisition (GTK_SIZE_GROUP_MODE_VERTICAL),
	 * or should all have the same requisition in both directions
	 * (GTK_SIZE_GROUP_MODE_BOTH).
	 * Params:
	 * mode =  the mode to set for the size group.
	 */
	public void setMode(GtkSizeGroupMode mode);
	
	/**
	 * Gets the current mode of the size group. See gtk_size_group_set_mode().
	 * Returns: the current mode of the size group.
	 */
	public GtkSizeGroupMode getMode();
	
	/**
	 * Sets whether unmapped widgets should be ignored when
	 * calculating the size.
	 * Since 2.8
	 * Params:
	 * ignoreHidden =  whether unmapped widgets should be ignored
	 *  when calculating the size
	 */
	public void setIgnoreHidden(int ignoreHidden);
	
	/**
	 * Returns if invisible widgets are ignored when calculating the size.
	 * Since 2.8
	 * Returns: TRUE if invisible widgets are ignored.
	 */
	public int getIgnoreHidden();
	
	/**
	 * Adds a widget to a GtkSizeGroup. In the future, the requisition
	 * of the widget will be determined as the maximum of its requisition
	 * and the requisition of the other widgets in the size group.
	 * Whether this applies horizontally, vertically, or in both directions
	 * depends on the mode of the size group. See gtk_size_group_set_mode().
	 * When the widget is destroyed or no longer referenced elsewhere, it will
	 * be removed from the size group.
	 * Params:
	 * widget =  the GtkWidget to add
	 */
	public void addWidget(Widget widget);
	
	/**
	 * Removes a widget from a GtkSizeGroup.
	 * Params:
	 * widget =  the GtkWidget to remove
	 */
	public void removeWidget(Widget widget);
	
	/**
	 * Returns the list of widgets associated with size_group.
	 * Since 2.10
	 * Returns: a GSList of widgets. The list is owned by GTK+  and should not be modified.
	 */
	public ListSG getWidgets();
}
