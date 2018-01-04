
module gtkD.gstreamer.GhostPad;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Pad;




/**
 * Description
 * GhostPads are useful when organizing pipelines with GstBin like elements.
 * The idea here is to create hierarchical element graphs. The bin element
 * contains a sub-graph. Now one would like to treat the bin-element like other
 * GstElements. This is where GhostPads come into play. A GhostPad acts as a
 * proxy for another pad. Thus the bin can have sink and source ghost-pads that
 * are associated with sink and source pads of the child elements.
 * If the target pad is known at creation time, gst_ghost_pad_new() is the
 * function to use to get a ghost-pad. Otherwise one can use gst_ghost_pad_new_no_target()
 * to create the ghost-pad and use gst_ghost_pad_set_target() to establish the
 * association later on.
 * Note that GhostPads add overhead to the data processing of a pipeline.
 * Last reviewed on 2005-11-18 (0.9.5)
 */
public class GhostPad : Pad
{
	
	/** the main Gtk struct */
	protected GstGhostPad* gstGhostPad;
	
	
	public GstGhostPad* getGhostPadStruct();

	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstGhostPad* gstGhostPad);
	
	/**
	 * Create a new ghostpad with target as the target. The direction and
	 * padtemplate will be taken from the target pad.
	 * Will ref the target.
	 * Params:
	 *  name = the name of the new pad, or NULL to assign a default name.
	 *  target = the pad to ghost.
	 * Returns:
	 *  a new GstPad, or NULL in case of an error.
	 */
	public this(string name, Pad target);
	
	/**
	 */
	
	/**
	 * Create a new ghostpad without a target with the given direction.
	 * A target can be set on the ghostpad later with the
	 * gst_ghost_pad_set_target() function.
	 * The created ghostpad will not have a padtemplate.
	 * Params:
	 * name =  the name of the new pad, or NULL to assign a default name.
	 * dir =  the direction of the ghostpad
	 * Returns: a new GstPad, or NULL in case of an error.
	 */
	public static Pad newNoTarget(string name, GstPadDirection dir);
	
	/**
	 * Create a new ghostpad with target as the target. The direction will be taken
	 * from the target pad. The template used on the ghostpad will be template.
	 * Will ref the target.
	 * Params:
	 * name =  the name of the new pad, or NULL to assign a default name.
	 * target =  the pad to ghost.
	 * templ =  the GstPadTemplate to use on the ghostpad.
	 * Returns: a new GstPad, or NULL in case of an error.Since 0.10.10
	 */
	public static Pad newFromTemplate(string name, Pad target, GstPadTemplate* templ);
	
	/**
	 * Create a new ghostpad based on templ, without setting a target. The
	 * direction will be taken from the templ.
	 * Params:
	 * name =  the name of the new pad, or NULL to assign a default name.
	 * templ =  the GstPadTemplate to create the ghostpad from.
	 * Returns: a new GstPad, or NULL in case of an error.Since 0.10.10
	 */
	public static Pad newNoTargetFromTemplate(string name, GstPadTemplate* templ);
	
	/**
	 * Set the new target of the ghostpad gpad. Any existing target
	 * is unlinked and links to the new target are established.
	 * Params:
	 * newtarget =  the new pad target
	 * Returns: TRUE if the new target could be set. This function can return FALSEwhen the internal pads could not be linked.
	 */
	public int setTarget(Pad newtarget);
	
	/**
	 * Get the target pad of gpad. Unref target pad after usage.
	 * Returns: the target GstPad, can be NULL if the ghostpadhas no target set. Unref target pad after usage.
	 */
	public Pad getTarget();
}
