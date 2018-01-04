module gtkD.gstreamer.Segment;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * This helper structure holds the relevant values for tracking the region of
 * interest in a media file, called a segment.
 * The structure can be used for two purposes:
 * performing seeks (handling seek events)
 * tracking playback regions (handling newsegment events)
 * The segment is usually configured by the application with a seek event which
 * is propagated upstream and eventually handled by an element that performs the seek.
 * The configured segment is then propagated back downstream with a newsegment event.
 * This information is then used to clip media to the segment boundaries.
 * A segment structure is initialized with gst_segment_init(), which takes a GstFormat
 * that will be used as the format of the segment values. The segment will be configured
 * with a start value of 0 and a stop/duration of -1, which is undefined. The default
 * rate and applied_rate is 1.0.
 * If the segment is used for managing seeks, the segment duration should be set with
 * gst_segment_set_duration(). The public duration field contains the duration of the
 * segment. When using the segment for seeking, the start and time members should
 * normally be left to their default 0 value. The stop position is left to -1 unless
 * explicitly configured to a different value after a seek event.
 * The current position in the segment should be set with the gst_segment_set_last_stop().
 * The public last_stop field contains the last set stop position in the segment.
 * For elements that perform seeks, the current segment should be updated with the
 * gst_segment_set_seek() and the values from the seek event. This method will update
 * all the segment fields. The last_pos field will contain the new playback position.
 * If the cur_type was different from GST_SEEK_TYPE_NONE, playback continues from
 * the last_pos position, possibly with updated flags or rate.
 * For elements that want to use GstSegment to track the playback region, use
 * gst_segment_set_newsegment() to update the segment fields with the information from
 * the newsegment event. The gst_segment_clip() method can be used to check and clip
 * the media data to the segment boundaries.
 * For elements that want to synchronize to the pipeline clock, gst_segment_to_running_time()
 * can be used to convert a timestamp to a value that can be used to synchronize
 * to the clock. This function takes into account all accumulated segments as well as
 * any rate or applied_rate conversions.
 * For elements that need to perform operations on media data in stream_time,
 * gst_segment_to_stream_time() can be used to convert a timestamp and the segment
 * info to stream time (which is always between 0 and the duration of the stream).
 * Last reviewed on 2006-05-03 (0.10.6)
 */
public class Segment
{
	
	/** the main Gtk struct */
	protected GstSegment* gstSegment;
	
	
	public GstSegment* getSegmentStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstSegment* gstSegment);
	
	/**
	 */
	
	/**
	 * Clip the given start and stop values to the segment boundaries given
	 * in segment. start and stop are compared and clipped to segment
	 * start and stop values.
	 * If the function returns FALSE, start and stop are known to fall
	 * outside of segment and clip_start and clip_stop are not updated.
	 * When the function returns TRUE, clip_start and clip_stop will be
	 * updated. If clip_start or clip_stop are different from start or stop
	 * respectively, the region fell partially in the segment.
	 * Params:
	 * format =  the format of the segment.
	 * start =  the start position in the segment
	 * stop =  the stop position in the segment
	 * clipStart =  the clipped start position in the segment
	 * clipStop =  the clipped stop position in the segment
	 * Returns: TRUE if the given start and stop times fall partially or  completely in segment, FALSE if the values are completely outside  of the segment.
	 */
	public int clip(GstFormat format, long start, long stop, long* clipStart, long* clipStop);
	
	/**
	 * The start/last_stop positions are set to 0 and the stop/duration
	 * fields are set to -1 (unknown). The default rate of 1.0 and no
	 * flags are set.
	 * Initialize segment to its default values.
	 * Params:
	 * format =  the format of the segment.
	 */
	public void init(GstFormat format);
	
	/**
	 * Allocate a new GstSegment structure and initialize it using
	 * gst_segment_init().
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Free the allocated segment segment.
	 */
	public void free();
	
	/**
	 * Set the duration of the segment to duration. This function is mainly
	 * used by elements that perform seeking and know the total duration of the
	 * segment.
	 * This field should be set to allow seeking requests relative to the
	 * duration.
	 * Params:
	 * format =  the format of the segment.
	 * duration =  the duration of the segment info or -1 if unknown.
	 */
	public void setDuration(GstFormat format, long duration);
	
	/**
	 * Set the last observed stop position in the segment to position.
	 * This field should be set to allow seeking requests relative to the
	 * current playing position.
	 * Params:
	 * format =  the format of the segment.
	 * position =  the position
	 */
	public void setLastStop(GstFormat format, long position);
	
	/**
	 * Update the segment structure with the field values of a new segment event and
	 * with a default applied_rate of 1.0.
	 * Params:
	 * segment =  a GstSegment structure.
	 * update =  flag indicating a new segment is started or updated
	 * rate =  the rate of the segment.
	 * format =  the format of the segment.
	 * start =  the new start value
	 * stop =  the new stop value
	 * time =  the new stream time
	 * Since 0.10.6
	 */
	public void setNewsegment(int update, double rate, GstFormat format, long start, long stop, long time);
	
	/**
	 * Update the segment structure with the field values of a new segment event.
	 * Params:
	 * segment =  a GstSegment structure.
	 * update =  flag indicating a new segment is started or updated
	 * rate =  the rate of the segment.
	 * appliedRate =  the applied rate of the segment.
	 * format =  the format of the segment.
	 * start =  the new start value
	 * stop =  the new stop value
	 * time =  the new stream time
	 */
	public void setNewsegmentFull(int update, double rate, double appliedRate, GstFormat format, long start, long stop, long time);
	
	/**
	 * Update the segment structure with the field values of a seek event (see
	 * gst_event_new_seek()).
	 * After calling this method, the segment field last_stop and time will
	 * contain the requested new position in the segment. The new requested
	 * position in the segment depends on rate and start_type and stop_type.
	 * For positive rate, the new position in the segment is the new segment
	 * start field when it was updated with a start_type different from
	 * GST_SEEK_TYPE_NONE. If no update was performed on segment start position
	 * (GST_SEEK_TYPE_NONE), start is ignored and segment last_stop is
	 * unmodified.
	 * For negative rate, the new position in the segment is the new segment
	 * stop field when it was updated with a stop_type different from
	 * GST_SEEK_TYPE_NONE. If no stop was previously configured in the segment, the
	 * duration of the segment will be used to update the stop position.
	 * If no update was performed on segment stop position (GST_SEEK_TYPE_NONE),
	 * stop is ignored and segment last_stop is unmodified.
	 * The applied rate of the segment will be set to 1.0 by default.
	 * If the caller can apply a rate change, it should update segment
	 * rate and applied_rate after calling this function.
	 * update will be set to TRUE if a seek should be performed to the segment
	 * last_stop field. This field can be FALSE if, for example, only the rate
	 * has been changed but not the playback position.
	 * Params:
	 * rate =  the rate of the segment.
	 * format =  the format of the segment.
	 * flags =  the seek flags for the segment
	 * startType =  the seek method
	 * start =  the seek start value
	 * stopType =  the seek method
	 * stop =  the seek stop value
	 * update =  boolean holding whether last_stop was updated.
	 */
	public void setSeek(double rate, GstFormat format, GstSeekFlags flags, GstSeekType startType, long start, GstSeekType stopType, long stop, int* update);
	
	/**
	 * Translate position to the total running time using the currently configured
	 * and previously accumulated segments. Position is a value between segment
	 * start and stop time.
	 * This function is typically used by elements that need to synchronize to the
	 * global clock in a pipeline. The runnning time is a constantly increasing value
	 * starting from 0. When gst_segment_init() is called, this value will reset to
	 * 0.
	 * This function returns -1 if the position is outside of segment start and stop.
	 * Params:
	 * format =  the format of the segment.
	 * position =  the position in the segment
	 * Returns: the position as the total running time or -1 when an invalid positionwas given.
	 */
	public long toRunningTime(GstFormat format, long position);
	
	/**
	 * Translate position to stream time using the currently configured
	 * segment. The position value must be between segment start and
	 * stop value.
	 * This function is typically used by elements that need to operate on
	 * the stream time of the buffers it receives, such as effect plugins.
	 * In those use cases, position is typically the buffer timestamp or
	 * clock time that one wants to convert to the stream time.
	 * The stream time is always between 0 and the total duration of the
	 * media stream.
	 * Params:
	 * format =  the format of the segment.
	 * position =  the position in the segment
	 * Returns: the position in stream_time or -1 when an invalid positionwas given.
	 */
	public long toStreamTime(GstFormat format, long position);
}
