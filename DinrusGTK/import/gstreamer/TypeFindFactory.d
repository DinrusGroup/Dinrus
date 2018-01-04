module gtkD.gstreamer.TypeFindFactory;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.gstreamer.TypeFind;
private import gtkD.gstreamer.Caps;



private import gtkD.gstreamer.PluginFeature;

/**
 * Description
 * These functions allow querying informations about registered typefind
 * functions. How to create and register these functions is described in
 * the section
 * "Writing typefind functions".
 * Example14.how to write a simple typefinder
 *  typedef struct {
	 *  guint8 *data;
	 *  guint size;
	 *  guint probability;
	 *  GstCaps *data;
	 *  } MyTypeFind;
	 *  static void
	 *  my_peek (gpointer data, gint64 offset, guint size)
	 *  {
		 *  MyTypeFind *find = (MyTypeFind *) data;
		 *  if (offset >= 0  offset + size <= find->size) {
			 *  return find->data + offset;
		 *  }
		 *  return NULL;
	 *  }
	 *  static void
	 *  my_suggest (gpointer data, guint probability, GstCaps *caps)
	 *  {
		 *  MyTypeFind *find = (MyTypeFind *) data;
		 *  if (probability > find->probability) {
			 *  find->probability = probability;
			 *  gst_caps_replace (find->caps, caps);
		 *  }
	 *  }
	 *  static GstCaps *
	 *  find_type (guint8 *data, guint size)
	 *  {
		 *  GList *walk, *type_list;
	 *  MyTypeFind find = {data, size, 0, NULL};
 *  GstTypeFind gst_find = {my_peek, my_suggest, find, };
 *  walk = type_list = gst_type_find_factory_get_list();
 *  while (walk) {
	 *  GstTypeFindFactory *factory = GST_TYPE_FIND_FACTORY (walk->data);
	 *  walk = g_list_next (walk)
	 *  gst_type_find_factory_call_function (factory, gst_find);
 *  }
 *  g_list_free (type_list);
 *  return find.caps;
 *  };
 * The above example shows how to write a very simple typefinder that
 * identifies the given data. You can get quite a bit more complicated than
 * that though.
 * Last reviewed on 2005-11-09 (0.9.4)
 */
public class TypeFindFactory : PluginFeature
{
	
	/** the main Gtk struct */
	protected GstTypeFindFactory* gstTypeFindFactory;
	
	
	public GstTypeFindFactory* getTypeFindFactoryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstTypeFindFactory* gstTypeFindFactory);
	
	/**
	 */
	
	/**
	 * Gets the list of all registered typefind factories. You must free the
	 * list using g_list_free.
	 * Returns: the list of all registered GstTypeFindFactory.
	 */
	public static ListG getList();
	
	/**
	 * Gets the extensions associated with a GstTypeFindFactory. The returned
	 * array should not be changed. If you need to change stuff in it, you should
	 * copy it using g_stdupv(). This function may return NULL to indicate
	 * a 0-length list.
	 * Returns: a NULL-terminated array of extensions associated with this factory
	 */
	public string[] getExtensions();
	
	/**
	 * Gets the GstCaps associated with a typefind factory.
	 * Returns: The GstCaps associated with this factory
	 */
	public Caps getCaps();
	
	/**
	 * Calls the GstTypeFindFunction associated with this factory.
	 * Params:
	 * find =  A properly setup GstTypeFind entry. The get_data and suggest_type
	 *  members must be set.
	 */
	public void callFunction(TypeFind find);
}
