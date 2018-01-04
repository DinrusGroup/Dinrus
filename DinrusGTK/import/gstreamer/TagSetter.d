module gtkD.gstreamer.TagSetter;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.TagList;




/**
 * Description
 * Element interface that allows setting of media metadata.
 * Elements that support changing a stream's metadata will implement this
 * interface. Examples of such elements are 'vorbisenc', 'theoraenc' and
 * 'id3v2mux'.
 * If you just want to retrieve metadata in your application then all you
 * need to do is watch for tag messages on your pipeline's bus. This
 * interface is only for setting metadata, not for extracting it. To set tags
 * from the application, find tagsetter elements and set tags using e.g.
 * gst_tag_setter_merge_tags() or gst_tag_setter_add_tags(). The application
 * should do that before the element goes to GST_STATE_PAUSED.
 * Elements implementing the GstTagSetter interface often have to merge
 * any tags received from upstream and the tags set by the application via
 * the interface. This can be done like this:
 * GstTagMergeMode merge_mode;
 * const GstTagList *application_tags;
 * const GstTagList *event_tags;
 * GstTagSetter *tagsetter;
 * GstTagList *result;
 * tagsetter = GST_TAG_SETTER (element);
 * merge_mode = gst_tag_setter_get_tag_merge_mode (tagsetter);
 * tagsetter_tags = gst_tag_setter_get_tag_list (tagsetter);
 * event_tags = (const GstTagList *) element->event_tags;
 * GST_LOG_OBJECT (tagsetter, "merging tags, merge mode = d", merge_mode);
 * GST_LOG_OBJECT (tagsetter, "event tags: %" GST_PTR_FORMAT, event_tags);
 * GST_LOG_OBJECT (tagsetter, "set tags: %" GST_PTR_FORMAT, application_tags);
 * result = gst_tag_list_merge (application_tags, event_tags, merge_mode);
 * GST_LOG_OBJECT (tagsetter, "final tags: %" GST_PTR_FORMAT, result);
 * Last reviewed on 2006-05-18 (0.10.6)
 */
public class TagSetter
{
	
	/** the main Gtk struct */
	protected GstTagSetter* gstTagSetter;
	
	
	public GstTagSetter* getTagSetterStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstTagSetter* gstTagSetter);
	
	/**
	 */
	
	/**
	 * Merges the given list into the setter's list using the given mode.
	 * Params:
	 * list =  a tag list to merge from
	 * mode =  the mode to merge with
	 */
	public void mergeTags(TagList list, GstTagMergeMode mode);
	
	/**
	 * Adds the given tag / value pairs on the setter using the given merge mode.
	 * The list must be terminated with NULL.
	 * Params:
	 * mode =  the mode to use
	 * tag =  tag to set
	 * varArgs =  tag / value pairs to set
	 */
	public void addTagValist(GstTagMergeMode mode, string tag, void* varArgs);
	
	/**
	 * Adds the given tag / GValue pairs on the setter using the given merge mode.
	 * The list must be terminated with NULL.
	 * Params:
	 * mode =  the mode to use
	 * tag =  tag to set
	 * varArgs =  tag / GValue pairs to set
	 */
	public void addTagValistValues(GstTagMergeMode mode, string tag, void* varArgs);
	
	/**
	 * Returns the current list of tags the setter uses. The list should not be
	 * modified or freed.
	 * Returns: a current snapshot of the taglist used in the setter or NULL if none is used.
	 */
	public TagList getTagList();
	
	/**
	 * Sets the given merge mode that is used for adding tags from events to tags
	 * specified by this interface. The default is GST_TAG_MERGE_KEEP, which keeps
	 * the tags set with this interface and discards tags from events.
	 * Params:
	 * mode =  The mode with which tags are added
	 */
	public void setTagMergeMode(GstTagMergeMode mode);
	
	/**
	 * Queries the mode by which tags inside the setter are overwritten by tags
	 * from events
	 * Returns: the merge mode used inside the element.
	 */
	public GstTagMergeMode getTagMergeMode();
}
