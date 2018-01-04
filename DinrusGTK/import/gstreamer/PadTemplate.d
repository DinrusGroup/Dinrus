module gtkD.gstreamer.PadTemplate;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gstreamer.Pad;
private import gtkD.gstreamer.Caps;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * Padtemplates describe the possible media types a pad or an elementfactory can
 * handle. This allows for both inspection of handled types before loading the
 * element plugin as well as identifying pads on elements that are not yet
 * created (request or sometimes pads).
 * Pad and PadTemplates have GstCaps attached to it to describe the media type
 * they are capable of dealing with. gst_pad_template_get_caps() or
 * GST_PAD_TEMPLATE_CAPS() are used to get the caps of a padtemplate. It's not
 * possible to modify the caps of a padtemplate after creation.
 * PadTemplates have a GstPadPresence property which identifies the lifetime
 * of the pad and that can be retrieved with GST_PAD_TEMPLATE_PRESENCE(). Also
 * the direction of the pad can be retrieved from the GstPadTemplate with
 * GST_PAD_TEMPLATE_DIRECTION().
 * The GST_PAD_TEMPLATE_NAME_TEMPLATE() is important for GST_PAD_REQUEST pads
 * because it has to be used as the name in the gst_element_request_pad_by_name()
 * call to instantiate a pad from this template.
 * Padtemplates can be created with gst_pad_template_new() or with
 * gst_static_pad_template_get(), which creates a GstPadTemplate from a
 * GstStaticPadTemplate that can be filled with the
 * convenient GST_STATIC_PAD_TEMPLATE() macro.
 * A padtemplate can be used to create a pad (see gst_pad_new_from_template()
 * or gst_pad_new_from_static_template()) or to add to an element class
 * (see gst_element_class_add_pad_template()).
 * The following code example shows the code to create a pad from a padtemplate.
 * Example12.Create a pad from a padtemplate
 *  GstStaticPadTemplate my_template =
 *  GST_STATIC_PAD_TEMPLATE (
 *  "sink", // the name of the pad
 *  GST_PAD_SINK, // the direction of the pad
 *  GST_PAD_ALWAYS, // when this pad will be present
 *  GST_STATIC_CAPS ( // the capabilities of the padtemplate
 *  "audio/x-raw-int, "
 *  "channels = (int) [ 1, 6 ]"
 *  )
 *  )
 *  void
 *  my_method (void)
 *  {
	 *  GstPad *pad;
	 *  pad = gst_pad_new_from_static_template (my_template, "sink");
	 *  ...
 *  }
 * The following example shows you how to add the padtemplate to an
 * element class, this is usually done in the base_init of the class:
 *  static void
 *  my_element_base_init (gpointer g_class)
 *  {
	 *  GstElementClass *gstelement_class = GST_ELEMENT_CLASS (g_class);
	 *  gst_element_class_add_pad_template (gstelement_class,
	 *  gst_static_pad_template_get (my_template));
 *  }
 * Last reviewed on 2006-02-14 (0.10.3)
 */
public class PadTemplate : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstPadTemplate* gstPadTemplate;
	
	
	public GstPadTemplate* getPadTemplateStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstPadTemplate* gstPadTemplate);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Pad, PadTemplate)[] onPadCreatedListeners;
	/**
	 * This signal is fired when an element creates a pad from this template.
	 * See Also
	 * GstPad, GstElementFactory
	 */
	void addOnPadCreated(void delegate(Pad, PadTemplate) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPadCreated(GstPadTemplate* padTemplateStruct, GstPad* pad, PadTemplate padTemplate);
	
	
	/**
	 * Converts a GstStaticPadTemplate into a GstPadTemplate.
	 * Params:
	 * padTemplate =  the static pad template
	 * Returns: a new GstPadTemplate.
	 */
	public static PadTemplate staticPadTemplateGet(GstStaticPadTemplate* padTemplate);
	
	/**
	 * Gets the capabilities of the static pad template.
	 * Params:
	 * templ =  a GstStaticPadTemplate to get capabilities of.
	 * Returns: the GstCaps of the static pad template. If you need to keep areference to the caps, take a ref (see gst_caps_ref()).
	 */
	public static Caps staticPadTemplateGetCaps(GstStaticPadTemplate* templ);
	
	/**
	 * Creates a new pad template with a name according to the given template
	 * and with the given arguments. This functions takes ownership of the provided
	 * caps, so be sure to not use them afterwards.
	 * Params:
	 * nameTemplate =  the name template.
	 * direction =  the GstPadDirection of the template.
	 * presence =  the GstPadPresence of the pad.
	 * caps =  a GstCaps set for the template. The caps are taken ownership of.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string nameTemplate, GstPadDirection direction, GstPadPresence presence, Caps caps);
	
	/**
	 * Gets the capabilities of the pad template.
	 * Returns: the GstCaps of the pad template. If you need to keep a reference tothe caps, take a ref (see gst_caps_ref()).Signal DetailsThe "pad-created" signalvoid user_function (GstPadTemplate *pad_template, GstPad *pad, gpointer user_data) : Run lastThis signal is fired when an element creates a pad from this template.
	 */
	public Caps getCaps();
}
