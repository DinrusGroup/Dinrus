module gtkD.gtk.IconSource;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Pixbuf;




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
public class IconSource
{
	
	/** the main Gtk struct */
	protected GtkIconSource* gtkIconSource;
	
	
	public GtkIconSource* getIconSourceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkIconSource* gtkIconSource);
	
	/**
	 */
	
	/**
	 * Creates a copy of source; mostly useful for language bindings.
	 * Returns: a new GtkIconSource
	 */
	public IconSource copy();
	
	/**
	 * Frees a dynamically-allocated icon source, along with its
	 * filename, size, and pixbuf fields if those are not NULL.
	 */
	public void free();
	
	/**
	 * Obtains the text direction this icon source applies to. The return
	 * value is only useful/meaningful if the text direction is not
	 * wildcarded.
	 * Returns: text direction this source matches
	 */
	public GtkTextDirection getDirection();
	
	/**
	 * Gets the value set by gtk_icon_source_set_direction_wildcarded().
	 * Returns: TRUE if this icon source is a base for any text direction variant
	 */
	public int getDirectionWildcarded();
	
	/**
	 * Retrieves the source filename, or NULL if none is set. The
	 * filename is not a copy, and should not be modified or expected to
	 * persist beyond the lifetime of the icon source.
	 * Returns: image filename. This string must not be modifiedor freed.
	 */
	public string getFilename();
	
	/**
	 * Retrieves the source pixbuf, or NULL if none is set.
	 * In addition, if a filename source is in use, this
	 * function in some cases will return the pixbuf from
	 * loaded from the filename. This is, for example, true
	 * for the GtkIconSource passed to the GtkStyle::render_icon()
	 * virtual function. The reference count on the pixbuf is
	 * not incremented.
	 * Returns: source pixbuf
	 */
	public Pixbuf getPixbuf();
	
	/**
	 * Retrieves the source icon name, or NULL if none is set. The
	 * icon_name is not a copy, and should not be modified or expected to
	 * persist beyond the lifetime of the icon source.
	 * Returns: icon name. This string must not be modified or freed.
	 */
	public string getIconName();
	
	/**
	 * Obtains the icon size this source applies to. The return value
	 * is only useful/meaningful if the icon size is not wildcarded.
	 * Returns: icon size this source matches.
	 */
	public GtkIconSize getSize();
	
	/**
	 * Gets the value set by gtk_icon_source_set_size_wildcarded().
	 * Returns: TRUE if this icon source is a base for any icon size variant
	 */
	public int getSizeWildcarded();
	
	/**
	 * Obtains the widget state this icon source applies to. The return
	 * value is only useful/meaningful if the widget state is not
	 * wildcarded.
	 * Returns: widget state this source matches
	 */
	public GtkStateType getState();
	
	/**
	 * Gets the value set by gtk_icon_source_set_state_wildcarded().
	 * Returns: TRUE if this icon source is a base for any widget state variant
	 */
	public int getStateWildcarded();
	
	/**
	 * Creates a new GtkIconSource. A GtkIconSource contains a GdkPixbuf (or
	 * image filename) that serves as the base image for one or more of the
	 * icons in a GtkIconSet, along with a specification for which icons in the
	 * icon set will be based on that pixbuf or image file. An icon set contains
	 * a set of icons that represent "the same" logical concept in different states,
	 * different global text directions, and different sizes.
	 * So for example a web browser's "Back to Previous Page" icon might
	 * point in a different direction in Hebrew and in English; it might
	 * look different when insensitive; and it might change size depending
	 * on toolbar mode (small/large icons). So a single icon set would
	 * contain all those variants of the icon. GtkIconSet contains a list
	 * of GtkIconSource from which it can derive specific icon variants in
	 * the set.
	 * In the simplest case, GtkIconSet contains one source pixbuf from
	 * which it derives all variants. The convenience function
	 * gtk_icon_set_new_from_pixbuf() handles this case; if you only have
	 * one source pixbuf, just use that function.
	 * If you want to use a different base pixbuf for different icon
	 * variants, you create multiple icon sources, mark which variants
	 * they'll be used to create, and add them to the icon set with
	 * gtk_icon_set_add_source().
	 * By default, the icon source has all parameters wildcarded. That is,
	 * the icon source will be used as the base icon for any desired text
	 * direction, widget state, or icon size.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets the text direction this icon source is intended to be used
	 * with.
	 * Setting the text direction on an icon source makes no difference
	 * if the text direction is wildcarded. Therefore, you should usually
	 * call gtk_icon_source_set_direction_wildcarded() to un-wildcard it
	 * in addition to calling this function.
	 * Params:
	 * direction =  text direction this source applies to
	 */
	public void setDirection(GtkTextDirection direction);
	
	/**
	 * If the text direction is wildcarded, this source can be used
	 * as the base image for an icon in any GtkTextDirection.
	 * If the text direction is not wildcarded, then the
	 * text direction the icon source applies to should be set
	 * with gtk_icon_source_set_direction(), and the icon source
	 * will only be used with that text direction.
	 * GtkIconSet prefers non-wildcarded sources (exact matches) over
	 * wildcarded sources, and will use an exact match when possible.
	 * Params:
	 * setting =  TRUE to wildcard the text direction
	 */
	public void setDirectionWildcarded(int setting);
	
	/**
	 * Sets the name of an image file to use as a base image when creating
	 * icon variants for GtkIconSet. The filename must be absolute.
	 * Params:
	 * filename =  image file to use
	 */
	public void setFilename(string filename);

	/**
	 * Sets a pixbuf to use as a base image when creating icon variants
	 * for GtkIconSet.
	 * Params:
	 * pixbuf =  pixbuf to use as a source
	 */
	public void setPixbuf(Pixbuf pixbuf);
	
	/**
	 * Sets the name of an icon to look up in the current icon theme
	 * to use as a base image when creating icon variants for GtkIconSet.
	 * Params:
	 * iconName =  name of icon to use
	 */
	public void setIconName(string iconName);
	
	/**
	 * Sets the icon size this icon source is intended to be used
	 * with.
	 * Setting the icon size on an icon source makes no difference
	 * if the size is wildcarded. Therefore, you should usually
	 * call gtk_icon_source_set_size_wildcarded() to un-wildcard it
	 * in addition to calling this function.
	 * Params:
	 * size =  icon size this source applies to
	 */
	public void setSize(GtkIconSize size);
	
	/**
	 * If the icon size is wildcarded, this source can be used as the base
	 * image for an icon of any size. If the size is not wildcarded, then
	 * the size the source applies to should be set with
	 * gtk_icon_source_set_size() and the icon source will only be used
	 * with that specific size.
	 * GtkIconSet prefers non-wildcarded sources (exact matches) over
	 * wildcarded sources, and will use an exact match when possible.
	 * GtkIconSet will normally scale wildcarded source images to produce
	 * an appropriate icon at a given size, but will not change the size
	 * of source images that match exactly.
	 * Params:
	 * setting =  TRUE to wildcard the widget state
	 */
	public void setSizeWildcarded(int setting);
	
	/**
	 * Sets the widget state this icon source is intended to be used
	 * with.
	 * Setting the widget state on an icon source makes no difference
	 * if the state is wildcarded. Therefore, you should usually
	 * call gtk_icon_source_set_state_wildcarded() to un-wildcard it
	 * in addition to calling this function.
	 * Params:
	 * state =  widget state this source applies to
	 */
	public void setState(GtkStateType state);
	
	/**
	 * If the widget state is wildcarded, this source can be used as the
	 * base image for an icon in any GtkStateType. If the widget state
	 * is not wildcarded, then the state the source applies to should be
	 * set with gtk_icon_source_set_state() and the icon source will
	 * only be used with that specific state.
	 * GtkIconSet prefers non-wildcarded sources (exact matches) over
	 * wildcarded sources, and will use an exact match when possible.
	 * GtkIconSet will normally transform wildcarded source images to
	 * produce an appropriate icon for a given state, for example
	 * lightening an image on prelight, but will not modify source images
	 * that match exactly.
	 * Params:
	 * setting =  TRUE to wildcard the widget state
	 */
	public void setStateWildcarded(int setting);
}
