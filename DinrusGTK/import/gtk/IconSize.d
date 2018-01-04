module gtkD.gtk.IconSize;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Settings;




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
public class IconSize
{
	
	/**
	 */
	
	/**
	 * Obtains the pixel size of a semantic icon size, possibly
	 * modified by user preferences for the default GtkSettings.
	 * (See gtk_icon_size_lookup_for_settings().)
	 * Normally size would be
	 * GTK_ICON_SIZE_MENU, GTK_ICON_SIZE_BUTTON, etc. This function
	 * isn't normally needed, gtk_widget_render_icon() is the usual
	 * way to get an icon for rendering, then just look at the size of
	 * the rendered pixbuf. The rendered pixbuf may not even correspond to
	 * the width/height returned by gtk_icon_size_lookup(), because themes
	 * are free to render the pixbuf however they like, including changing
	 * the usual size.
	 * Params:
	 * size =  an icon size
	 * width =  location to store icon width
	 * height =  location to store icon height
	 * Returns: TRUE if size was a valid size
	 */
	public static int lookup(GtkIconSize size, out int width, out int height);
	
	/**
	 * Obtains the pixel size of a semantic icon size, possibly
	 * modified by user preferences for a particular
	 * GtkSettings. Normally size would be
	 * GTK_ICON_SIZE_MENU, GTK_ICON_SIZE_BUTTON, etc. This function
	 * isn't normally needed, gtk_widget_render_icon() is the usual
	 * way to get an icon for rendering, then just look at the size of
	 * the rendered pixbuf. The rendered pixbuf may not even correspond to
	 * the width/height returned by gtk_icon_size_lookup(), because themes
	 * are free to render the pixbuf however they like, including changing
	 * the usual size.
	 * Since 2.2
	 * Params:
	 * settings =  a GtkSettings object, used to determine
	 *  which set of user preferences to used.
	 * size =  an icon size
	 * width =  location to store icon width
	 * height =  location to store icon height
	 * Returns: TRUE if size was a valid size
	 */
	public static int lookupForSettings(Settings settings, GtkIconSize size, out int width, out int height);
	
	/**
	 * Registers a new icon size, along the same lines as GTK_ICON_SIZE_MENU,
	 * etc. Returns the integer value for the size.
	 * Params:
	 * name =  name of the icon size
	 * width =  the icon width
	 * height =  the icon height
	 * Returns: integer value representing the size
	 */
	public static GtkIconSize register(string name, int width, int height);
	
	/**
	 * Registers alias as another name for target.
	 * So calling gtk_icon_size_from_name() with alias as argument
	 * will return target.
	 * Params:
	 * target =  an existing icon size
	 */
	public static void registerAlias(string alia, GtkIconSize target);
	
	/**
	 * Looks up the icon size associated with name.
	 * Params:
	 * name =  the name to look up.
	 * Returns: the icon size with the given name.
	 */
	public static GtkIconSize fromName(string name);
	
	/**
	 * Gets the canonical name of the given icon size. The returned string
	 * is statically allocated and should not be freed.
	 * Params:
	 * size =  a GtkIconSize.
	 * Returns: the name of the given icon size.
	 */
	public static string getName(GtkIconSize size);
}
