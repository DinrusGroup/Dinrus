module gtkD.gtk.ImageMenuItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.AccelGroup;



private import gtkD.gtk.MenuItem;

/**
 * Description
 * A GtkImageMenuItem is a menu item which has an icon next to the text label.
 * Note that the user can disable display of menu icons, so make sure to still
 * fill in the text label.
 */
public class ImageMenuItem : MenuItem
{
	
	/** the main Gtk struct */
	protected GtkImageMenuItem* gtkImageMenuItem;
	
	
	public GtkImageMenuItem* getImageMenuItemStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkImageMenuItem* gtkImageMenuItem);
	
	/**
	 * Creates a new GtkImageMenuItem containing a label.
	 * If mnemonic it true the label
	 * will be created using gtk_label_new_with_mnemonic(), so underscores
	 * in label indicate the mnemonic for the menu item.
	 * Params:
	 *  label = the text of the menu item.
	 * Returns:
	 *  a new GtkImageMenuItem.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label, bool mnemonic=true);
	
	/**
	 * Creates a new GtkImageMenuItem containing the image and text from a
	 * stock item. Some stock ids have preprocessor macros like GTK_STOCK_OK
	 * and GTK_STOCK_APPLY.
	 * If you want this menu item to have changeable accelerators, then pass in
	 * NULL for accel_group. Next call gtk_menu_item_set_accel_path() with an
	 * appropriate path for the menu item, use gtk_stock_lookup() to look up the
	 * standard accelerator for the stock item, and if one is found, call
	 * gtk_accel_map_add_entry() to register it.
	 * Params:
	 * StockID = the name of the stock item
	 * accelGroup =  the GtkAccelGroup to add the menu items accelerator to,
	 *  or NULL.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (StockID stockID, AccelGroup accelGroup);
	
	/**
	 */
	
	/**
	 * Sets the image of image_menu_item to the given widget.
	 * Note that it depends on the show-menu-images setting whether
	 * the image will be displayed or not.
	 * Params:
	 * image =  a widget to set as the image for the menu item.
	 */
	public void setImage(Widget image);
	
	/**
	 * Gets the widget that is currently set as the image of image_menu_item.
	 * See gtk_image_menu_item_set_image().
	 * Returns: the widget set as image of image_menu_item.
	 */
	public Widget getImage();
	
	/**
	 * Creates a new GtkImageMenuItem with an empty label.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Checks whether the label set in the menuitem is used as a
	 * stock id to select the stock item for the item.
	 * Since 2.16
	 * Returns: TRUE if the label set in the menuitem is used as a stock id to select the stock item for the item
	 */
	public int getUseStock();
	
	/**
	 * If TRUE, the label set in the menuitem is used as a
	 * stock id to select the stock item for the item.
	 * Since 2.16
	 * Params:
	 * useStock =  TRUE if the menuitem should use a stock item
	 */
	public void setUseStock(int useStock);
	
	/**
	 * Returns whether the menu item will ignore the "gtk-menu-images"
	 * setting and always show the image, if available.
	 * Since 2.16
	 * Returns: TRUE if the menu item will always show the image
	 */
	public int getAlwaysShowImage();
	
	/**
	 * If TRUE, the menu item will ignore the "gtk-menu-images"
	 * setting and always show the image, if available.
	 * Use this property if the menuitem would be useless or hard to use
	 * without the image.
	 * Since 2.16
	 * Params:
	 * alwaysShow =  TRUE if the menuitem should always show the image
	 */
	public void setAlwaysShowImage(int alwaysShow);
	
	/**
	 * Specifies an accel_group to add the menu items accelerator to
	 * (this only applies to stock items so a stock item must already
	 * be set, make sure to call gtk_image_menu_item_set_use_stock()
	 * and gtk_menu_item_set_label() with a valid stock item first).
	 * If you want this menu item to have changeable accelerators then
	 * you shouldnt need this (see gtk_image_menu_item_new_from_stock()).
	 * Since 2.16
	 * Params:
	 * accelGroup =  the GtkAccelGroup
	 */
	public void setAccelGroup(AccelGroup accelGroup);
}
