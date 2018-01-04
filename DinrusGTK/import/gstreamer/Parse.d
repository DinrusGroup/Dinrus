module gtkD.gstreamer.Parse;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.Quark;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gstreamer.Element;




/**
 * Description
 * These function allow to create a pipeline based on the syntax used in the
 * gst-launch utillity.
 */
public class Parse
{
	
	/**
	 * Get the error quark used by the parsing subsystem.
	 * Returns:
	 *  the quark of the parse errors.
	 */
	public static Quark errorQuark();
	
	/**
	 */
	
	/**
	 * Create a new pipeline based on command line syntax.
	 * Please note that you might get a return value that is not NULL even though
	 * the error is set. In this case there was a recoverable parsing error and you
	 * can try to play the pipeline.
	 * Params:
	 * pipelineDescription =  the command line describing the pipeline
	 * Returns: a new element on success, NULL on failure. If more than one toplevelelement is specified by the pipeline_description, all elements are put intoa GstPipeline, which than is returned.
	 * Throws: GException on failure.
	 */
	public static Element launch(string pipelineDescription);
	
	/**
	 * Create a new element based on command line syntax.
	 * error will contain an error message if an erroneuos pipeline is specified.
	 * An error does not mean that the pipeline could not be constructed.
	 * Params:
	 * argv =  null-terminated array of arguments
	 * Returns: a new element on success and NULL on failure.
	 * Throws: GException on failure.
	 */
	public static Element launchv(char** argv);
	
	/**
	 * This is a convenience wrapper around gst_parse_launch() to create a
	 * GstBin from a gst-launch-style pipeline description. See
	 * gst_parse_launch() and the gst-launch man page for details about the
	 * syntax. Ghost pads on the bin for unconnected source or sink pads
	 * within the bin can automatically be created (but only a maximum of
	 * one ghost pad for each direction will be created; if you expect
	 * multiple unconnected source pads or multiple unconnected sink pads
	 * and want them all ghosted, you will have to create the ghost pads
	 * yourself).
	 * Params:
	 * binDescription =  command line describing the bin
	 * ghostUnconnectedPads =  whether to automatically create ghost pads
	 *  for unconnected source or sink pads within
	 *  the bin
	 * Returns: a newly-created bin, or NULL if an error occurred.Since 0.10.3
	 * Throws: GException on failure.
	 */
	public static Element binFromDescription(string binDescription, int ghostUnconnectedPads);
}
