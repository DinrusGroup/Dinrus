module gtkD.gtk.StockItem;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.StockItem;
private import gtkD.glib.ListSG;




/**
 * Description
 * Stock items represent commonly-used menu or toolbar items such as
 * "Open" or "Exit". Each stock item is identified by a stock ID;
 * stock IDs are just strings, but macros such as GTK_STOCK_OPEN are
 * provided to avoid typing mistakes in the strings.
 * Applications can register their own stock items in addition to those
 * built-in to GTK+.
 * Each stock ID can be associated with a GtkStockItem, which contains
 * the user-visible label, keyboard accelerator, and translation domain
 * of the menu or toolbar item; and/or with an icon stored in a
 * GtkIconFactory. See GtkIconFactory for
 * more information on stock icons. The connection between a
 * GtkStockItem and stock icons is purely conventional (by virtue of
 * using the same stock ID); it's possible to register a stock item but
 * no icon, and vice versa. Stock icons may have a RTL variant which gets
 * used for right-to-left locales.
 */
public class StockItem
{
	
	/** the main Gtk struct */
	protected GtkStockItem* gtkStockItem;
	
	
	public GtkStockItem* getStockItemStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkStockItem* gtkStockItem);
	
	/**
	 */
	
	/**
	 * Registers each of the stock items in items. If an item already
	 * exists with the same stock ID as one of the items, the old item
	 * gets replaced. The stock items are copied, so GTK+ does not hold
	 * any pointer into items and items can be freed. Use
	 * gtk_stock_add_static() if items is persistent and GTK+ need not
	 * copy the array.
	 * Params:
	 * nItems =  number of GtkStockItem in items
	 */
	public void add(uint nItems);
	
	/**
	 * Same as gtk_stock_add(), but doesn't copy items, so
	 * items must persist until application exit.
	 * Params:
	 * nItems =  number of items
	 */
	public void addStatic(uint nItems);
	
	/**
	 * Copies a stock item, mostly useful for language bindings and not in applications.
	 * Params:
	 * item =  a GtkStockItem
	 * Returns: a new GtkStockItem
	 */
	public StockItem itemCopy();
	
	/**
	 * Frees a stock item allocated on the heap, such as one returned by
	 * gtk_stock_item_copy(). Also frees the fields inside the stock item,
	 * if they are not NULL.
	 * Params:
	 * item =  a GtkStockItem
	 */
	public void itemFree();
	
	/**
	 * Retrieves a list of all known stock IDs added to a GtkIconFactory
	 * or registered with gtk_stock_add(). The list must be freed with g_slist_free(),
	 * and each string in the list must be freed with g_free().
	 * Returns: a list of known stock IDs
	 */
	public static ListSG listIds();
	
	/**
	 * Fills item with the registered values for stock_id, returning TRUE
	 * if stock_id was known.
	 * Params:
	 * stockId =  a stock item name
	 * item =  stock item to initialize with values
	 * Returns: TRUE if item was initialized
	 */
	public static int lookup(string stockId, StockItem item);
	
	/**
	 * Sets a function to be used for translating the label of
	 * a stock item.
	 * If no function is registered for a translation domain,
	 * g_dgettext() is used.
	 * The function is used for all stock items whose
	 * translation_domain matches domain. Note that it is possible
	 * to use strings different from the actual gettext translation domain
	 * of your application for this, as long as your GtkTranslateFunc uses
	 * the correct domain when calling dgettext(). This can be useful, e.g.
	 * Since 2.8
	 * Params:
	 * domain =  the translation domain for which func shall be used
	 * func =  a GtkTranslateFunc
	 * data =  data to pass to func
	 * notify =  a GDestroyNotify that is called when data is
	 *  no longer needed
	 */
	public static void setTranslateFunc(string domain, GtkTranslateFunc func, void* data, GDestroyNotify notify);
}
