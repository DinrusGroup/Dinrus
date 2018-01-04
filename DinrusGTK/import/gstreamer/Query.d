module gtkD.gstreamer.Query;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gstreamer.Structure;




/**
 * Description
 * GstQuery functions are used to register a new query types to the gstreamer
 * core.
 * Query types can be used to perform queries on pads and elements.
 * Queries can be created using the gst_query_new_xxx() functions.
 * Query values can be set using gst_query_set_xxx(), and parsed using
 * gst_query_parse_xxx() helpers.
 * The following example shows how to query the duration of a pipeline:
 * Example13.Query duration on a pipeline
 *  GstQuery *query;
 *  gboolean res;
 *  query = gst_query_new_duration (GST_FORMAT_TIME);
 *  res = gst_element_query (pipeline, query);
 *  if (res) {
	 *  gint64 duration;
	 *  gst_query_parse_duration (query, NULL, duration);
	 *  g_print ("duration = %"GST_TIME_FORMAT, GST_TIME_ARGS (duration));
 *  }
 *  else {
	 *  g_print ("duration query failed...");
 *  }
 *  gst_query_unref (query);
 * Last reviewed on 2006-02-14 (0.10.4)
 */
public class Query
{
	
	/** the main Gtk struct */
	protected GstQuery* gstQuery;
	
	
	public GstQuery* getQueryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstQuery* gstQuery);
	
	/**
	 * Constructs a new query stream position query object. Use gst_query_unref()
	 * when done with it. A position query is used to query the current position
	 * of playback in the streams, in some format.
	 * Params:
	 *  format = the default GstFormat for the new query
	 * Returns:
	 *  A GstQuery
	 */
	public static Query newPosition(GstFormat format);

		/**
	 * Constructs a new stream duration query object to query in the given format.
	 * Use gst_query_unref() when done with it. A duration query will give the
	 * total length of the stream.
	 * Params:
	 *  format = the GstFormat for this duration query
	 * Returns:
	 *  A GstQuery
	 */
	public static Query newDuration(GstFormat format);

		/**
	 * Constructs a new query object for querying seeking properties of
	 * the stream.
	 * Params:
	 *  format = the default GstFormat for the new query
	 * Returns:
	 *  A GstQuery
	 */
	public static Query newSeeking(GstFormat format);

		/**
	 * Constructs a new query object for querying formats of
	 * the stream.
	 * Since 0.10.4
	 * Returns:
	 *  A GstQuery
	 */
	public static Query newFormats();

		/**
	 * Constructs a new segment query object. Use gst_query_unref()
	 * when done with it. A segment query is used to discover information about the
	 * currently configured segment for playback.
	 * Params:
	 *  format = the GstFormat for the new query
	 * Returns:
	 *  a GstQuery
	 */
	public static Query newSegment(GstFormat format);
	
	/**
	 */
	
	/**
	 * Get a printable name for the given query type. Do not modify or free.
	 * Params:
	 * query =  the query type
	 * Returns: a reference to the static name of the query.
	 */
	public static string typeGetName(GstQueryType query);
	
	/**
	 * Get the unique quark for the given query type.
	 * Params:
	 * query =  the query type
	 * Returns: the quark associated with the query type
	 */
	public static GQuark typeToQuark(GstQueryType query);
	
	/**
	 * Create a new GstQueryType based on the nick or return an
	 * already registered query with that nick
	 * Params:
	 * nick =  The nick of the new query
	 * description =  The description of the new query
	 * Returns: A new GstQueryType or an already registered querywith the same nick.
	 */
	public static GstQueryType typeRegister(string nick, string description);
	
	/**
	 * Get the query type registered with nick.
	 * Params:
	 * nick =  The nick of the query
	 * Returns: The query registered with nick or GST_QUERY_NONEif the query was not registered.
	 */
	public static GstQueryType typeGetByNick(string nick);
	
	/**
	 * See if the given GstQueryType is inside the types query types array.
	 * Params:
	 * types =  The query array to search
	 * type =  the GstQueryType to find
	 * Returns: TRUE if the type is found inside the array
	 */
	public static int typesContains(GstQueryType* types, GstQueryType type);
	
	/**
	 * Get details about the given GstQueryType.
	 * Params:
	 * type =  a GstQueryType
	 * Returns: The GstQueryTypeDefinition for type or NULL on failure.
	 */
	public static GstQueryTypeDefinition* typeGetDetails(GstQueryType type);
	
	/**
	 * Get a GstIterator of all the registered query types. The definitions
	 * iterated over are read only.
	 * Returns: A GstIterator of GstQueryTypeDefinition.
	 */
	public static GstIterator* typeIterateDefinitions();
	
	/**
	 * Constructs a new custom application query object. Use gst_query_unref()
	 * when done with it.
	 * Params:
	 * type =  the query type
	 * structure =  a structure for the query
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GstQueryType type, Structure structure);
	
	/**
	 * Get the structure of a query.
	 * Returns: The GstStructure of the query. The structure is still ownedby the query and will therefore be freed when the query is unreffed.
	 */
	public Structure getStructure();
	
	/**
	 * Constructs a new convert query object. Use gst_query_unref()
	 * when done with it. A convert query is used to ask for a conversion between
	 * one format and another.
	 * Params:
	 * srcFormat =  the source GstFormat for the new query
	 * value =  the value to convert
	 * destFormat =  the target GstFormat
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GstFormat srcFormat, long value, GstFormat destFormat);
	
	/**
	 * Answer a convert query by setting the requested values.
	 * Params:
	 * srcFormat =  the source GstFormat
	 * srcValue =  the source value
	 * destFormat =  the destination GstFormat
	 * destValue =  the destination value
	 */
	public void setConvert(GstFormat srcFormat, long srcValue, GstFormat destFormat, long destValue);
	
	/**
	 * Parse a convert query answer. Any of src_format, src_value, dest_format,
	 * and dest_value may be NULL, in which case that value is omitted.
	 * Params:
	 * srcFormat =  the storage for the GstFormat of the source value, or NULL
	 * srcValue =  the storage for the source value, or NULL
	 * destFormat =  the storage for the GstFormat of the destination value, or NULL
	 * destValue =  the storage for the destination value, or NULL
	 */
	public void parseConvert(GstFormat* srcFormat, long* srcValue, GstFormat* destFormat, long* destValue);
	
	/**
	 * Answer a position query by setting the requested value in the given format.
	 * Params:
	 * format =  the requested GstFormat
	 * cur =  the position to set
	 */
	public void setPosition(GstFormat format, long cur);
	
	/**
	 * Parse a position query, writing the format into format, and the position
	 * into cur, if the respective parameters are non-NULL.
	 * Params:
	 * format =  the storage for the GstFormat of the position values (may be NULL)
	 * cur =  the storage for the current position (may be NULL)
	 */
	public void parsePosition(GstFormat* format, long* cur);
	
	/**
	 * Answer a duration query by setting the requested value in the given format.
	 * Params:
	 * format =  the GstFormat for the duration
	 * duration =  the duration of the stream
	 */
	public void setDuration(GstFormat format, long duration);
	
	/**
	 * Parse a duration query answer. Write the format of the duration into format,
	 * and the value into duration, if the respective variables are non-NULL.
	 * Params:
	 * format =  the storage for the GstFormat of the duration value, or NULL.
	 * duration =  the storage for the total duration, or NULL.
	 */
	public void parseDuration(GstFormat* format, long* duration);
	
	/**
	 * Constructs a new latency query object.
	 * Use gst_query_unref() when done with it. A latency query is usually performed
	 * by sinks to compensate for additional latency introduced by elements in the
	 * pipeline.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Parse a latency query answer.
	 * Params:
	 * live =  storage for live or NULL
	 * minLatency =  the storage for the min latency or NULL
	 * maxLatency =  the storage for the max latency or NULL
	 * Since 0.10.12
	 */
	public void parseLatency(int* live, GstClockTime* minLatency, GstClockTime* maxLatency);
	
	/**
	 * Answer a latency query by setting the requested values in the given format.
	 * Params:
	 * live =  if there is a live element upstream
	 * minLatency =  the minimal latency of the live element
	 * maxLatency =  the maximal latency of the live element
	 * Since 0.10.12
	 */
	public void setLatency(int live, GstClockTime minLatency, GstClockTime maxLatency);
	
	/**
	 * Set the seeking query result fields in query.
	 * Params:
	 * format =  the format to set for the segment_start and segment_end values
	 * seekable =  the seekable flag to set
	 * segmentStart =  the segment_start to set
	 * segmentEnd =  the segment_end to set
	 */
	public void setSeeking(GstFormat format, int seekable, long segmentStart, long segmentEnd);
	
	/**
	 * Parse a seeking query, writing the format into format, and
	 * other results into the passed parameters, if the respective parameters
	 * are non-NULL
	 * Params:
	 * format =  the format to set for the segment_start and segment_end values
	 * seekable =  the seekable flag to set
	 * segmentStart =  the segment_start to set
	 * segmentEnd =  the segment_end to set
	 */
	public void parseSeeking(GstFormat* format, int* seekable, long* segmentStart, long* segmentEnd);
	
	/**
	 * Set the formats query result fields in query. The number of formats passed
	 * in the formats array must be equal to n_formats.
	 * Params:
	 * nFormats =  the number of formats to set.
	 * formats =  An array containing n_formats GstFormat values.
	 * Since 0.10.4
	 */
	public void setFormatsv(int nFormats, GstFormat* formats);
	
	/**
	 * Parse the number of formats in the formats query.
	 * Params:
	 * nFormats =  the number of formats in this query.
	 * Since 0.10.4
	 */
	public void parseFormatsLength(uint* nFormats);
	
	/**
	 * Parse the format query and retrieve the nth format from it into
	 * format. If the list contains less elements than nth, format will be
	 * set to GST_FORMAT_UNDEFINED.
	 * Params:
	 * nth =  the nth format to retrieve.
	 * format =  a pointer to store the nth format
	 * Since 0.10.4
	 */
	public void parseFormatsNth(uint nth, GstFormat* format);
	
	/**
	 * Answer a segment query by setting the requested values. The normal
	 * playback segment of a pipeline is 0 to duration at the default rate of
	 * 1.0. If a seek was performed on the pipeline to play a different
	 * segment, this query will return the range specified in the last seek.
	 * start_value and stop_value will respectively contain the configured
	 * playback range start and stop values expressed in format.
	 * The values are always between 0 and the duration of the media and
	 * start_value <= stop_value. rate will contain the playback rate. For
	 * negative rates, playback will actually happen from stop_value to
	 * start_value.
	 * Params:
	 * rate =  the rate of the segment
	 * format =  the GstFormat of the segment values (start_value and stop_value)
	 * startValue =  the start value
	 * stopValue =  the stop value
	 */
	public void setSegment(double rate, GstFormat format, long startValue, long stopValue);
	
	/**
	 * Parse a segment query answer. Any of rate, format, start_value, and
	 * stop_value may be NULL, which will cause this value to be omitted.
	 * See gst_query_set_segment() for an explanation of the function arguments.
	 * Params:
	 * rate =  the storage for the rate of the segment, or NULL
	 * format =  the storage for the GstFormat of the values, or NULL
	 * startValue =  the storage for the start value, or NULL
	 * stopValue =  the storage for the stop value, or NULL
	 */
	public void parseSegment(double* rate, GstFormat* format, long* startValue, long* stopValue);
}
