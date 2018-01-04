module gtkD.gstreamer.GError;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 */

/**
 * Get a string describing the error message in the current locale.
 * Params:
 * domain =  the GStreamer error domain this error belongs to.
 * code =  the error code belonging to the domain.
 * Returns: a newly allocated string describing the error message in thecurrent locale.
 */
public static string errorGetMessage(GQuark domain, int code);

