module gtkD.gtk.Settings;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Settings;
private import gtkD.gdk.Screen;
private import gtkD.gobject.ParamSpec;
private import gtkD.glib.StringG;
private import gtkD.gobject.Value;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GtkSettings provide a mechanism to share global settings between applications.
 * On the X window system, this sharing is realized by an XSettings
 * manager that is usually part of the desktop environment, along with utilities
 * that let the user change these settings. In the absence of an Xsettings manager,
 * settings can also be specified in RC files.
 * Applications can override system-wide settings with gtk_settings_set_string_property(),
 * gtk_settings_set_long_property(), etc. This should be restricted to special
 * cases though; GtkSettings are not meant as an application configuration
 * facility. When doing so, you need to be aware that settings that are specific
 * to individual widgets may not be available before the widget type has been
 * realized at least once. The following example demonstrates a way to do this:
 *  gtk_init (argc, argv);
 *  /+* make sure the type is realized +/
 *  g_type_class_unref (g_type_class_ref (GTK_TYPE_IMAGE_MENU_ITEM));
 *  g_object_set (gtk_settings_get_default (), "gtk-menu-images", FALSE, NULL);
 * There is one GtkSettings instance per screen. It can be obtained with
 * gtk_settings_get_for_screen(), but in many cases, it is more convenient
 * to use gtk_widget_get_settings(). gtk_settings_get_default() returns the
 * GtkSettings instance for the default screen.
 */
public class Settings : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkSettings* gtkSettings;
	
	
	public GtkSettings* getSettingsStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSettings* gtkSettings);
	
	/**
	 */
	
	/**
	 * Gets the GtkSettings object for the default GDK screen, creating
	 * it if necessary. See gtk_settings_get_for_screen().
	 * Returns: a GtkSettings object. If there is no default screen, then returns NULL.
	 */
	public static Settings getDefault();
	
	/**
	 * Gets the GtkSettings object for screen, creating it if necessary.
	 * Since 2.2
	 * Params:
	 * screen =  a GdkScreen.
	 * Returns: a GtkSettings object.
	 */
	public static Settings getForScreen(Screen screen);
	
	/**
	 * Params:
	 */
	public static void installProperty(ParamSpec pspec);
	
	/**
	 * Params:
	 */
	public static void installPropertyParser(ParamSpec pspec, GtkRcPropertyParser parser);
	
	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses a
	 * color given either by its name or in the form
	 * { red, green, blue } where red, green and
	 * blue are integers between 0 and 65535 or floating-point numbers
	 * between 0 and 1.
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold GdkColor values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting GdkColor.
	 */
	public static int rcPropertyParseColor(ParamSpec pspec, StringG gstring, Value propertyValue);

	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses a single
	 * enumeration value.
	 * The enumeration value can be specified by its name, its nickname or
	 * its numeric value. For consistency with flags parsing, the value
	 * may be surrounded by parentheses.
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold enum values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting GEnumValue.
	 */
	public static int rcPropertyParseEnum(ParamSpec pspec, StringG gstring, Value propertyValue);
	
	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses flags.
	 * Flags can be specified by their name, their nickname or
	 * numerically. Multiple flags can be specified in the form
	 * "( flag1 | flag2 | ... )".
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold flags values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting flags value.
	 */
	public static int rcPropertyParseFlags(ParamSpec pspec, StringG gstring, Value propertyValue);
	
	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses a
	 * requisition in the form
	 * "{ width, height }" for integers width and height.
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold boxed values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting GtkRequisition.
	 */
	public static int rcPropertyParseRequisition(ParamSpec pspec, StringG gstring, Value propertyValue);
	
	/**
	 * A GtkRcPropertyParser for use with gtk_settings_install_property_parser()
	 * or gtk_widget_class_install_style_property_parser() which parses
	 * borders in the form
	 * "{ left, right, top, bottom }" for integers
	 * left, right, top and bottom.
	 * Params:
	 * pspec =  a GParamSpec
	 * gstring =  the GString to be parsed
	 * propertyValue =  a GValue which must hold boxed values.
	 * Returns: TRUE if gstring could be parsed and property_valuehas been set to the resulting GtkBorder.
	 */
	public static int rcPropertyParseBorder(ParamSpec pspec, StringG gstring, Value propertyValue);
	
	/**
	 * Params:
	 */
	public void setPropertyValue(string name, GtkSettingsValue* svalue);
	
	/**
	 * Params:
	 */
	public void setStringProperty(string name, string vString, string origin);
	
	/**
	 * Params:
	 */
	public void setLongProperty(string name, int vLong, string origin);
	
	/**
	 * Params:
	 */
	public void setDoubleProperty(string name, double vDouble, string origin);
}
