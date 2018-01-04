module gtkD.gstreamer.Format;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Iterator;




/** the main Gtk struct */
protected GstFormat* gstFormat;


/**
 */

/**
 * Get a printable name for the given format. Do not modify or free.
 * Params:
 * format =  a GstFormat
 * Returns: a reference to the static name of the format or NULL ifthe format is unknown.
 */
public static string getName(GstFormat format);

/**
 * Get the unique quark for the given format.
 * Params:
 * format =  a GstFormat
 * Returns: the quark associated with the format or 0 if the formatis unknown.
 */
public static GQuark toQuark(GstFormat format);

/**
 * Create a new GstFormat based on the nick or return an
 * already registered format with that nick.
 * Params:
 * nick =  The nick of the new format
 * description =  The description of the new format
 * Returns: A new GstFormat or an already registered formatwith the same nick.MT safe.
 */
public static GstFormat register(string nick, string description);

/**
 * Return the format registered with the given nick.
 * Params:
 * nick =  The nick of the format
 * Returns: The format with nick or GST_FORMAT_UNDEFINEDif the format was not registered.
 */
public static GstFormat getByNick(string nick);

/**
 * See if the given format is inside the format array.
 * Params:
 * formats =  The format array to search
 * format =  the format to find
 * Returns: TRUE if the format is found inside the array
 */
public int formatsContains(GstFormat format);

/**
 * Get details about the given format.
 * Params:
 * format =  The format to get details of
 * Returns: The GstFormatDefinition for format or NULL on failure.MT safe.
 */
public static GstFormatDefinition* getDetails(GstFormat format);

/**
 * Iterate all the registered formats. The format definition is read
 * only.
 * Returns: A GstIterator of GstFormatDefinition.
 */
public static Iterator iterateDefinitions();

