module gtkD.gtk.IconSet;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.IconSource;
private import gtkD.gdk.Pixbuf;
private import gtkD.gtk.Style;
private import gtkD.gtk.Widget;




/**
 * Description
 * Browse the available stock icons in the list of stock IDs found here. You can also use
 * the gtk-demo application for this purpose.
 *  An icon factory manages a collection of GtkIconSet; a GtkIconSet manages a
 *  set of variants of a particular icon (i.e. a GtkIconSet contains variants for
 *  different sizes and widget states). Icons in an icon factory are named by a
 *  stock ID, which is a simple string identifying the icon. Each GtkStyle has a
 *  list of GtkIconFactory derived from the current theme; those icon factories
 *  are consulted first when searching for an icon. If the theme doesn't set a
 *  particular icon, GTK+ looks for the icon in a list of default icon factories,
 *  maintained by gtk_icon_factory_add_default() and
 *  gtk_icon_factory_remove_default(). Applications with icons should add a default
 *  icon factory with their icons, which will allow themes to override the icons
 *  for the application.
 * To display an icon, always use gtk_style_lookup_icon_set() on the widget that
 * will display the icon, or the convenience function
 * gtk_widget_render_icon(). These functions take the theme into account when
 * looking up the icon to use for a given stock ID.
 * GtkIconFactory as GtkBuildable
 * GtkIconFactory supports a custom <sources> element, which
 * can contain multiple <source> elements.
 * The following attributes are allowed:
 * stock-id
 * The stock id of the source, a string.
 * This attribute is mandatory
 * filename
 * The filename of the source, a string.
 * This attribute is optional
 * icon-name
 * The icon name for the source, a string.
 * This attribute is optional.
 * size
 * Size of the icon, a GtkIconSize enum value.
 * This attribute is optional.
 * direction
 * Direction of the source, a GtkTextDirection enum value.
 * This attribute is optional.
 * state
 * State of the source, a GtkStateType enum value.
 * This attribute is optional.
 * Example 5. A GtkIconFactory UI definition fragment.
 * <object class="GtkIconFactory" id="iconfactory1">
 *  <sources>
 *  <source stock-id="apple-red" filename="apple-red.png"/>
 *  </sources>
 * </object>
 * <object class="GtkWindow" id="window1">
 *  <child>
 *  <object class="GtkButton" id="apple_button">
 *  <property name="label">apple-red</property>
 *  <property name="use-stock">True</property>
 *  </object>
 *  </child>
 * </object>
 */
public class IconSet
{
	
	/** the main Gtk struct */
	protected GtkIconSet* gtkIconSet;
	
	
	public GtkIconSet* getIconSetStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkIconSet* gtkIconSet);
	
	/**
	 */
	
	/**
	 * Icon sets have a list of GtkIconSource, which they use as base
	 * icons for rendering icons in different states and sizes. Icons are
	 * scaled, made to look insensitive, etc. in
	 * gtk_icon_set_render_icon(), but GtkIconSet needs base images to
	 * work with. The base images and when to use them are described by
	 * a GtkIconSource.
	 * This function copies source, so you can reuse the same source immediately
	 * without affecting the icon set.
	 * An example of when you'd use this function: a web browser's "Back
	 * to Previous Page" icon might point in a different direction in
	 * Hebrew and in English; it might look different when insensitive;
	 * and it might change size depending on toolbar mode (small/large
	 * icons). So a single icon set would contain all those variants of
	 * the icon, and you might add a separate source for each one.
	 * You should nearly always add a "default" icon source with all
	 * fields wildcarded, which will be used as a fallback if no more
	 * specific source matches. GtkIconSet always prefers more specific
	 * icon sources to more generic icon sources. The order in which you
	 * add the sources to the icon set does not matter.
	 * gtk_icon_set_new_from_pixbuf() creates a new icon set with a
	 * default icon source based on the given pixbuf.
	 * Params:
	 * source =  a GtkIconSource
	 */
	public void addSource(IconSource source);
	
	/**
	 * Copies icon_set by value.
	 * Returns: a new GtkIconSet identical to the first.
	 */
	public IconSet copy();

	/**
	 * Creates a new GtkIconSet. A GtkIconSet represents a single icon
	 * in various sizes and widget states. It can provide a GdkPixbuf
	 * for a given size and state on request, and automatically caches
	 * some of the rendered GdkPixbuf objects.
	 * Normally you would use gtk_widget_render_icon() instead of
	 * using GtkIconSet directly. The one case where you'd use
	 * GtkIconSet is to create application-specific icon sets to place in
	 * a GtkIconFactory.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GtkIconSet with pixbuf as the default/fallback
	 * source image. If you don't add any additional GtkIconSource to the
	 * icon set, all variants of the icon will be created from pixbuf,
	 * using scaling, pixelation, etc. as required to adjust the icon size
	 * or make the icon look insensitive/prelighted.
	 * Params:
	 * pixbuf =  a GdkPixbuf
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (Pixbuf pixbuf);
	
	/**
	 * Increments the reference count on icon_set.
	 * Returns: icon_set.
	 */
	public IconSet doref();
	
	/**
	 * Renders an icon using gtk_style_render_icon(). In most cases,
	 * gtk_widget_render_icon() is better, since it automatically provides
	 * most of the arguments from the current widget settings. This
	 * function never returns NULL; if the icon can't be rendered
	 * (perhaps because an image file fails to load), a default "missing
	 * image" icon will be returned instead.
	 * Params:
	 * style =  a GtkStyle associated with widget, or NULL
	 * direction =  text direction
	 * state =  widget state
	 * size =  icon size. A size of (GtkIconSize)-1
	 *  means render at the size of the source and don't scale.
	 * widget =  widget that will display the icon, or NULL.
	 *  The only use that is typically made of this
	 *  is to determine the appropriate GdkScreen.
	 * detail =  detail to pass to the theme engine, or NULL.
	 *  Note that passing a detail of anything but NULL
	 *  will disable caching.
	 * Returns: a GdkPixbuf to be displayed
	 */
	public Pixbuf renderIcon(Style style, GtkTextDirection direction, GtkStateType state, GtkIconSize size, Widget widget, string detail);
	
	/**
	 * Decrements the reference count on icon_set, and frees memory
	 * if the reference count reaches 0.
	 */
	public void unref();
	
	/**
	 * Obtains a list of icon sizes this icon set can render. The returned
	 * array must be freed with g_free().
	 * Params:
	 * sizes =  return location for array of sizes
	 */
	public void getSizes(out GtkIconSize[] sizes);
}
