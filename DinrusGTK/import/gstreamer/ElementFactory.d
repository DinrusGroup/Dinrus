module gtkD.gstreamer.ElementFactory;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Element;
private import gtkD.gstreamer.Plugin;
private import gtkD.gstreamer.Caps;
private import gtkD.glib.ListG;



private import gtkD.gstreamer.PluginFeature;

/**
 * Description
 * GstElementFactory is used to create instances of elements. A
 * GstElementfactory can be added to a GstPlugin as it is also a
 * GstPluginFeature.
 * Use the gst_element_factory_find() and gst_element_factory_create()
 * functions to create element instances or use gst_element_factory_make() as a
 * convenient shortcut.
 * The following code example shows you how to create a GstFileSrc element.
 * Example6.Using an element factory
 *  include <gst/gst.h>
 *  GstElement *src;
 *  GstElementFactory *srcfactory;
 *  gst_init(argc,argv);
 *  srcfactory = gst_element_factory_find("filesrc");
 *  g_return_if_fail(srcfactory != NULL);
 *  src = gst_element_factory_create(srcfactory,"src");
 *  g_return_if_fail(src != NULL);
 *  ...
 * Last reviewed on 2005-11-23 (0.9.5)
 */
public class ElementFactory : PluginFeature
{
	
	/** the main Gtk struct */
	protected GstElementFactory* gstElementFactory;
	
	
	public GstElementFactory* getElementFactoryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstElementFactory* gstElementFactory);
	
	/**
	 * Create a new element of the type defined by the given element factory.
	 * The element will receive a guaranteed unique name,
	 * consisting of the element factory name and a number.
	 * Params:
	 *  factoryname = a named factory to instantiate
	 * Returns:
	 *  new GstElement or NULL if unable to create element
	 */
	public static Element make( string factoryname );
	
	/**
	 */
	
	/**
	 * Create a new elementfactory capable of instantiating objects of the
	 * type and add the factory to plugin.
	 * Params:
	 * plugin =  GstPlugin to register the element with
	 * name =  name of elements of this type
	 * rank =  rank of element (higher rank means more importance when autoplugging)
	 * type =  GType of element to register
	 * Returns: TRUE, if the registering succeeded, FALSE on error
	 */
	public static int register(Plugin plugin, string name, uint rank, GType type);
	
	/**
	 * Search for an element factory of the given name. Refs the returned
	 * element factory; caller is responsible for unreffing.
	 * Params:
	 * name =  name of factory to find
	 * Returns: GstElementFactory if found, NULL otherwise
	 */
	public static ElementFactory find(string name);
	
	/**
	 * Get the GType for elements managed by this factory. The type can
	 * only be retrieved if the element factory is loaded, which can be
	 * assured with gst_plugin_feature_load().
	 * Returns: the GType for elements managed by this factory or 0 ifthe factory is not loaded.
	 */
	public GType getElementType();
	
	/**
	 * Gets the longname for this factory
	 * Returns: the longname
	 */
	public string getLongname();
	
	/**
	 * Gets the class for this factory.
	 * Returns: the class
	 */
	public string getKlass();
	
	/**
	 * Gets the description for this factory.
	 * Returns: the description
	 */
	public string getDescription();
	
	/**
	 * Gets the author for this factory.
	 * Returns: the author
	 */
	public string getAuthor();
	
	/**
	 * Gets the number of pad_templates in this factory.
	 * Returns: the number of pad_templates
	 */
	public uint getNumPadTemplates();
	
	/**
	 * Gets the type of URIs the element supports or GST_URI_UNKNOWN if none.
	 * Returns: type of URIs this element supports
	 */
	public int getUriType();
	
	/**
	 * Gets a NULL-terminated array of protocols this element supports or NULL if
	 * no protocols are supported. You may not change the contents of the returned
	 * array, as it is still owned by the element factory. Use g_strdupv() to
	 * make a copy of the protocol string array if you need to.
	 * Returns: the supported protocols or NULL
	 */
	public string[] getUriProtocols();
	
	/**
	 * Create a new element of the type defined by the given elementfactory.
	 * It will be given the name supplied, since all elements require a name as
	 * their first argument.
	 * Params:
	 * name =  name of new element
	 * Returns: new GstElement or NULL if the element couldn't be created
	 */
	public Element create(string name);
	
	/**
	 * Create a new element of the type defined by the given element factory.
	 * If name is NULL, then the element will receive a guaranteed unique name,
	 * consisting of the element factory name and a number.
	 * If name is given, it will be given the name supplied.
	 * Params:
	 * factoryname =  a named factory to instantiate
	 * name =  name of new element
	 * Returns: new GstElement or NULL if unable to create element
	 */
	public static Element make(string factoryname, string name);
	
	/**
	 * Checks if the factory can sink the given capability.
	 * Params:
	 * caps =  the caps to check
	 * Returns: true if it can sink the capabilities
	 */
	public int canSinkCaps(Caps caps);
	
	/**
	 * Checks if the factory can source the given capability.
	 * Params:
	 * caps =  the caps to check
	 * Returns: true if it can src the capabilities
	 */
	public int canSrcCaps(Caps caps);
	
	/**
	 * Gets the GList of GstStaticPadTemplate for this factory.
	 * Returns: the padtemplates
	 */
	public ListG getStaticPadTemplates();
}
