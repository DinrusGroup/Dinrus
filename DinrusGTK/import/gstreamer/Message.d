module gtkD.gstreamer.Message;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.Quark;
private import gtkD.gstreamer.Structure;
private import gtkD.gstreamer.ObjectGst;
private import gtkD.gstreamer.Clock;
private import gtkD.glib.ErrorG;
private import gtkD.gstreamer.TagList;




/**
 * Description
 * Messages are implemented as a subclass of GstMiniObject with a generic
 * GstStructure as the content. This allows for writing custom messages without
 * requiring an API change while allowing a wide range of different types
 * of messages.
 * Messages are posted by objects in the pipeline and are passed to the
 * application using the GstBus.
 * The basic use pattern of posting a message on a GstBus is as follows:
 * Example11.Posting a GstMessage
 *  gst_bus_post (bus, gst_message_new_eos());
 * A GstElement usually posts messages on the bus provided by the parent
 * container using gst_element_post_message().
 * Last reviewed on 2005-11-09 (0.9.4)
 */
public class Message
{
	
	/** the main Gtk struct */
	protected GstMessage* gstMessage;
	
	
	public GstMessage* getMessageStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstMessage* gstMessage);
	
	/**
	 * Get the type of the message.
	 */
	public GstMessageType type();
	
	/**
	 * Get the src (the element that originated the message) of the message.
	 */
	public ObjectGst src();
	
	/**
	 * Get the structure.
	 */
	public Structure structure();
	
	/**
	 * Extracts the tag list from the GstMessage. The tag list returned in the
	 * output argument is a copy; the caller must free it when done.
	 * MT safe.
	 * Params:
	 *  tagList = Return location for the tag-list.
	 */
	/*public void parseTag(GstTagList** tagList)
	{
		// void gst_message_parse_tag (GstMessage *message,  GstTagList **tag_list);
		gst_message_parse_tag(gstMessage, tagList);
	}*/
	public TagList parseTag();
	
	//I'm not so sure about the following:
	/**
	 * Get the unique quark for the given message type.
	 * Params:
	 *  type = the message type
	 * Returns:
	 *  the quark associated with the message type
	 */
	public static Quark typeToQuark(GstMessageType type);
	
	/**
	 * Create a new element-specific message. This is meant as a generic way of
	 * allowing one-way communication from an element to an application, for example
	 * "the firewire cable was unplugged". The format of the message should be
	 * documented in the element's documentation. The structure field can be NULL.
	 * MT safe.
	 * Params:
	 *  src = The object originating the message.
	 *  structure = The structure for the message. The message will take ownership of
	 *  the structure.
	 * Returns:
	 *  The new element message.
	 */
	public static Message newElement(ObjectGst src, Structure structure);
	
	/**
	 * Create a new clock message. This message is posted whenever the
	 * pipeline selectes a new clock for the pipeline.
	 * MT safe.
	 * Params:
	 *  src = The object originating the message.
	 *  clock = the new selected clock
	 * Returns:
	 *  The new new clock message.
	 */
	public static Message newNewClock(ObjectGst src, Clock clock);
	
	/**
	 * Create a new segment done message. This message is posted by elements that
	 * finish playback of a segment as a result of a segment seek. This message
	 * is received by the application after all elements that posted a segment_start
	 * have posted the segment_done.
	 * MT safe.
	 * Params:
	 *  src = The object originating the message.
	 *  format = The format of the position being done
	 *  position = The position of the segment being done
	 * Returns:
	 *  The new segment done message.
	 */
	public static Message newSegmentDone(ObjectGst src, GstFormat format, long position);
	
	/**
	 * Create a new segment message. This message is posted by elements that
	 * start playback of a segment as a result of a segment seek. This message
	 * is not received by the application but is used for maintenance reasons in
	 * container elements.
	 * MT safe.
	 * Params:
	 *  src = The object originating the message.
	 *  format = The format of the position being played
	 *  position = The position of the segment being played
	 * Returns:
	 *  The new segment start message.
	 */
	public static Message newSegmentStart(ObjectGst src, GstFormat format, long position);
	
	/**
	 * Create a new warning message. The message will make copies of error and
	 * debug.
	 * MT safe.
	 * Params:
	 *  src = The object originating the message.
	 *  error = The GError for this message.
	 *  debug = A debugging string for something or other.
	 * Returns:
	 *  The new warning message.
	 */
	public static Message newWarning(ObjectGst src, ErrorG error, string dbug);
	
	/**
	 * Create a state dirty message. This message is posted whenever an element
	 * changed its state asynchronously and is used internally to update the
	 * states of container objects.
	 * MT safe.
	 * Params:
	 *  src = the object originating the message
	 * Returns:
	 *  The new state dirty message.
	 */
	public static Message newStateDirty(ObjectGst src);
	
	/**
	 * Create a new eos message. This message is generated and posted in
	 * the sink elements of a GstBin. The bin will only forward the EOS
	 * message to the application if all sinks have posted an EOS message.
	 * MT safe.
	 * Params:
	 *  src = The object originating the message.
	 * Returns:
	 *  The new eos message.
	 */
	public static Message newEOS(ObjectGst src);
	
	/**
	 * Create a new error message. The message will copy error and
	 * debug. This message is posted by element when a fatal event
	 * occured. The pipeline will probably (partially) stop. The application
	 * receiving this message should stop the pipeline.
	 * MT safe.
	 * Params:
	 *  src = The object originating the message.
	 *  error = The GError for this message.
	 *  debug = A debugging string for something or other.
	 * Returns:
	 *  The new error message.
	 */
	public static Message newError(ObjectGst src, ErrorG error, string dbug);
	
	/**
	 * Create a new info message. The message will make copies of error and
	 * debug.
	 * MT safe.
	 * Since 0.10.12
	 * Params:
	 *  src = The object originating the message.
	 *  error = The GError for this message.
	 *  debug = A debugging string for something or other.
	 * Returns:
	 *  The new info message.
	 */
	public static Message newInfo(ObjectGst src, ErrorG error, string dbug);
	
	/**
	 */
	
	/**
	 * Get a printable name for the given message type. Do not modify or free.
	 * Params:
	 * type =  the message type
	 * Returns: a reference to the static name of the message.
	 */
	public static string typeGetName(GstMessageType type);
	
	/**
	 * Access the structure of the message.
	 * Returns: The structure of the message. The structure is stillowned by the message, which means that you should not free it andthat the pointer becomes invalid when you free the message.MT safe.
	 */
	public Structure getStructure();
	
	/**
	 * Create a new application-typed message. GStreamer will never create these
	 * messages; they are a gift from us to you. Enjoy.
	 * Params:
	 * src =  The object originating the message.
	 * structure =  The structure for the message. The message will take ownership of
	 * the structure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectGst src, Structure structure);
	
	/**
	 * Create a clock provide message. This message is posted whenever an
	 * element is ready to provide a clock or lost its ability to provide
	 * a clock (maybe because it paused or became EOS).
	 * This message is mainly used internally to manage the clock
	 * selection.
	 * Params:
	 * src =  The object originating the message.
	 * clock =  The clock it provides
	 * ready =  TRUE if the sender can provide a clock
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectGst src, Clock clock, int ready);
	
	/**
	 * Create a clock lost message. This message is posted whenever the
	 * clock is not valid anymore.
	 * If this message is posted by the pipeline, the pipeline will
	 * select a new clock again when it goes to PLAYING. It might therefore
	 * be needed to set the pipeline to PAUSED and PLAYING again.
	 * Params:
	 * src =  The object originating the message.
	 * clock =  the clock that was lost
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectGst src, Clock clock);
	
	/**
	 * Create a new custom-typed message. This can be used for anything not
	 * handled by other message-specific functions to pass a message to the
	 * app. The structure field can be NULL.
	 * Params:
	 * type =  The GstMessageType to distinguish messages
	 * src =  The object originating the message.
	 * structure =  The structure for the message. The message will take ownership of
	 * the structure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GstMessageType type, ObjectGst src, Structure structure);
	
	/**
	 * Create a state change message. This message is posted whenever an element
	 * changed its state.
	 * Params:
	 * src =  the object originating the message
	 * oldstate =  the previous state
	 * newstate =  the new (current) state
	 * pending =  the pending (target) state
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectGst src, GstState oldstate, GstState newstate, GstState pending);
	
	/**
	 * Create a new tag message. The message will take ownership of the tag list.
	 * The message is posted by elements that discovered a new taglist.
	 * Params:
	 * src =  The object originating the message.
	 * tagList =  The tag list for the message.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectGst src, TagList tagList);
	
	/**
	 * Create a new buffering message. This message can be posted by an element that
	 * needs to buffer data before it can continue processing. percent should be a
	 * value between 0 and 100. A value of 100 means that the buffering completed.
	 * When percent is < 100 the application should PAUSE a PLAYING pipeline. When
	 * percent is 100, the application can set the pipeline (back) to PLAYING.
	 * The application must be prepared to receive BUFFERING messages in the
	 * PREROLLING state and may only set the pipeline to PLAYING after receiving a
	 * message with percent set to 100, which can happen after the pipeline
	 * completed prerolling.
	 * Params:
	 * src =  The object originating the message.
	 * percent =  The buffering percent
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectGst src, int percent);
	
	/**
	 * Create a new duration message. This message is posted by elements that
	 * know the duration of a stream in a specific format. This message
	 * is received by bins and is used to calculate the total duration of a
	 * pipeline. Elements may post a duration message with a duration of
	 * GST_CLOCK_TIME_NONE to indicate that the duration has changed and the
	 * cached duration should be discarded. The new duration can then be
	 * retrieved via a query.
	 * Params:
	 * src =  The object originating the message.
	 * format =  The format of the duration
	 * duration =  The new duration
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectGst src, GstFormat format, long duration);
	
	/**
	 * This message can be posted by elements when their latency requirements have
	 * changed.
	 * Params:
	 * src =  The object originating the message.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectGst src);
	
	/**
	 * Extracts the lost clock from the GstMessage.
	 * The clock object returned remains valid until the message is freed.
	 * MT safe.
	 * Params:
	 * clock =  A pointer to hold the lost clock
	 */
	public void parseClockLost(GstClock** clock);
	
	/**
	 * Extracts the clock and ready flag from the GstMessage.
	 * The clock object returned remains valid until the message is freed.
	 * MT safe.
	 * Params:
	 * clock =  A pointer to hold a clock object.
	 * ready =  A pointer to hold the ready flag.
	 */
	public void parseClockProvide(GstClock** clock, int* ready);
	
	/**
	 * Extracts the GError and debug string from the GstMessage. The values returned
	 * in the output arguments are copies; the caller must free them when done.
	 * MT safe.
	 * Params:
	 * gerror =  Location for the GError
	 * dbug =  Location for the debug message, or NULL
	 */
	public void parseError(out GError* gerror, out string dbug);
	
	/**
	 * Extracts the GError and debug string from the GstMessage. The values returned
	 * in the output arguments are copies; the caller must free them when done.
	 * MT safe.
	 * Params:
	 * gerror =  Location for the GError
	 * dbug =  Location for the debug message, or NULL
	 * Since 0.10.12
	 */
	public void parseInfo(out GError* gerror, out string dbug);
	
	/**
	 * Extracts the new clock from the GstMessage.
	 * The clock object returned remains valid until the message is freed.
	 * MT safe.
	 * Params:
	 * clock =  A pointer to hold the selected new clock
	 */
	public void parseNewClock(GstClock** clock);
	
	/**
	 * Extracts the position and format from the segment start message.
	 * MT safe.
	 * Params:
	 * format =  Result location for the format, or NULL
	 * position =  Result location for the position, or NULL
	 */
	public void parseSegmentDone(GstFormat* format, long* position);
	
	/**
	 * Extracts the position and format from the segment start message.
	 * MT safe.
	 * Params:
	 * format =  Result location for the format, or NULL
	 * position =  Result location for the position, or NULL
	 */
	public void parseSegmentStart(GstFormat* format, long* position);
	
	/**
	 * Extracts the old and new states from the GstMessage.
	 * MT safe.
	 * Params:
	 * oldstate =  the previous state, or NULL
	 * newstate =  the new (current) state, or NULL
	 * pending =  the pending (target) state, or NULL
	 */
	public void parseStateChanged(GstState* oldstate, GstState* newstate, GstState* pending);
	
	/**
	 * Extracts the buffering percent from the GstMessage. see also
	 * gst_message_new_buffering().
	 * Params:
	 * percent =  Return location for the percent.
	 * Since 0.10.11
	 * MT safe.
	 */
	public void parseBuffering(int* percent);
	
	/**
	 * Extracts the GError and debug string from the GstMessage. The values returned
	 * in the output arguments are copies; the caller must free them when done.
	 * MT safe.
	 * Params:
	 * gerror =  Location for the GError
	 * dbug =  Location for the debug message, or NULL
	 */
	public void parseWarning(out GError* gerror, out string dbug);
	
	/**
	 * Extracts the duration and format from the duration message. The duration
	 * might be GST_CLOCK_TIME_NONE, which indicates that the duration has
	 * changed. Applications should always use a query to retrieve the duration
	 * of a pipeline.
	 * MT safe.
	 * Params:
	 * format =  Result location for the format, or NULL
	 * duration =  Result location for the duration, or NULL
	 */
	public void parseDuration(GstFormat* format, long* duration);
	
	/**
	 * Convenience macro to increase the reference count of the message.
	 * Returns: msg (for convenience when doing assignments)
	 */
	public Message doref();
}
