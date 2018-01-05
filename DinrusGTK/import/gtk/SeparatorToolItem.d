module gtkD.gtk.SeparatorToolItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.ToolItem;



private import gtkD.gtk.ToolItem;

/**
 * Description
 *  A GtkSeparatorItem is a GtkToolItem that separates groups of other
 *  GtkToolItems. Depending on the theme, a GtkSeparatorToolItem will
 *  often look like a vertical line on horizontally docked toolbars.
 * If the property "expand" is TRUE and the property "draw" is FALSE, a
 * GtkSeparatorToolItem will act as a "spring" that forces other items
 * to the ends of the toolbar.
 *  Use gtk_separator_tool_item_new() to create a new GtkSeparatorToolItem.
 */
public class SeparatorToolItem : ToolItem
{
	
	/** the main Gtk struct */
	protected GtkSeparatorToolItem* gtkSeparatorToolItem;
	
	
	public GtkSeparatorToolItem* getSeparatorToolItemStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSeparatorToolItem* gtkSeparatorToolItem);
	
	/**
	 */
	
	/**
	 * Create a new GtkSeparatorToolItem
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Whether item is drawn as a vertical line, or just blank.
	 * Setting this to FALSE along with gtk_tool_item_set_expand() is useful
	 * to create an item that forces following items to the end of the toolbar.
	 * Since 2.4
	 * Params:
	 * draw =  whether item is drawn as a vertical line
	 */
	public void setDraw(int draw);
	
	/**
	 * Returns whether item is drawn as a line, or just blank.
	 * See gtk_separator_tool_item_set_draw().
	 * Since 2.4
	 * Returns: TRUE if item is drawn as a line, or just blank.
	 */
	public int getDraw();
}
