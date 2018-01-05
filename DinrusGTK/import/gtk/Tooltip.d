module gtkD.gtk.Tooltip;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Pixbuf;
private import gtkD.gdk.Display;
private import gtkD.gdk.Rectangle;
private import gtkD.gtk.Widget;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GtkTooltip belongs to the new tooltips API that was
 * introduced in GTK+ 2.12 and which deprecates the old
 * GtkTooltips API.
 * Basic tooltips can be realized simply by using gtk_widget_set_tooltip_text()
 * or gtk_widget_set_tooltip_markup() without any explicit tooltip object.
 * When you need a tooltip with a little more fancy contents, like
 * adding an image, or you want the tooltip to have different contents
 * per GtkTreeView row or cell, you will have to do a little more work:
 * Set the "has-tooltip" property to TRUE, this will
 * make GTK+ monitor the widget for motion and related events
 * which are needed to determine when and where to show a tooltip.
 * Connect to the "query-tooltip" signal. This signal
 * will be emitted when a tooltip is supposed to be shown. One
 * of the arguments passed to the signal handler is a GtkTooltip
 * object. This is the object that we are about to display as a
 * tooltip, and can be manipulated in your callback using functions
 * like gtk_tooltip_set_icon(). There are functions for setting
 * the tooltip's markup, setting an image from a stock icon, or
 * even putting in a custom widget.
 * Return TRUE from your query-tooltip handler. This causes
 * the tooltip to be show. If you return FALSE, it will not be shown.
 * In the probably rare case where you want to have even more control
 * over the tooltip that is about to be shown, you can set your own
 * GtkWindow which will be used as tooltip window. This works as
 * follows:
 * Set "has-tooltip" and connect to "query-tooltip" as
 * before.
 * Use gtk_widget_set_tooltip_window() to set a GtkWindow created
 * by you as tooltip window.
 * In the ::query-tooltip callback you can access your window
 * using gtk_widget_get_tooltip_window() and manipulate as you
 * wish. The semantics of the return value are exactly as before,
 * return TRUE to show the window, FALSE to not show it.
 */
public class Tooltip : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkTooltip* gtkTooltip;
	
	
	public GtkTooltip* getTooltipStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTooltip* gtkTooltip);
	
	/**
	 */
	
	/**
	 * Sets the text of the tooltip to be markup, which is marked up
	 * with the Pango text markup language.
	 * If markup is NULL, the label will be hidden.
	 * Since 2.12
	 * Params:
	 * markup =  a markup string (see Pango markup format) or NULL
	 */
	public void setMarkup(string markup);
	
	/**
	 * Sets the text of the tooltip to be text. If text is NULL, the label
	 * will be hidden. See also gtk_tooltip_set_markup().
	 * Since 2.12
	 * Params:
	 * text =  a text string or NULL
	 */
	public void setText(string text);
	
	/**
	 * Sets the icon of the tooltip (which is in front of the text) to be
	 * pixbuf. If pixbuf is NULL, the image will be hidden.
	 * Since 2.12
	 * Params:
	 * pixbuf =  a GdkPixbuf, or NULL
	 */
	public void setIcon(Pixbuf pixbuf);
	
	/**
	 * Sets the icon of the tooltip (which is in front of the text) to be
	 * the stock item indicated by stock_id with the size indicated
	 * by size. If stock_id is NULL, the image will be hidden.
	 * Since 2.12
	 * Params:
	 * stockId =  a stock id, or NULL
	 * size =  a stock icon size
	 */
	public void setIconFromStock(string stockId, GtkIconSize size);
	
	/**
	 * Sets the icon of the tooltip (which is in front of the text) to be
	 * the icon indicated by icon_name with the size indicated
	 * by size. If icon_name is NULL, the image will be hidden.
	 * Since 2.14
	 * Params:
	 * iconName =  an icon name, or NULL
	 * size =  a stock icon size
	 */
	public void setIconFromIconName(string iconName, GtkIconSize size);
	
	/**
	 * Replaces the widget packed into the tooltip with
	 * custom_widget. custom_widget does not get destroyed when the tooltip goes
	 * away.
	 * By default a box with a GtkImage and GtkLabel is embedded in
	 * the tooltip, which can be configured using gtk_tooltip_set_markup()
	 * and gtk_tooltip_set_icon().
	 * Since 2.12
	 * Params:
	 * customWidget =  a GtkWidget, or NULL to unset the old custom widget.
	 */
	public void setCustom(Widget customWidget);
	
	/**
	 * Triggers a new tooltip query on display, in order to update the current
	 * visible tooltip, or to show/hide the current tooltip. This function is
	 * useful to call when, for example, the state of the widget changed by a
	 * key press.
	 * Since 2.12
	 * Params:
	 * display =  a GdkDisplay
	 */
	public static void triggerTooltipQuery(Display display);
	
	/**
	 * Sets the area of the widget, where the contents of this tooltip apply,
	 * to be rect (in widget coordinates). This is especially useful for
	 * properly setting tooltips on GtkTreeView rows and cells, GtkIconViews,
	 * etc.
	 * For setting tooltips on GtkTreeView, please refer to the convenience
	 * functions for this: gtk_tree_view_set_tooltip_row() and
	 * gtk_tree_view_set_tooltip_cell().
	 * Since 2.12
	 * Params:
	 * rect =  a GdkRectangle
	 */
	public void setTipArea(Rectangle rect);
}
