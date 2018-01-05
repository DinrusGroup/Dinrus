module gtkD.gstreamer.Element;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtkc.gobject;
private import gtkD.gstreamer.Pad;
private import gtkD.gstreamer.Clock;
private import gtkD.gstreamer.Caps;
private import gtkD.gstreamer.Iterator;
private import gtkD.gstreamer.Index;
private import gtkD.gstreamer.TagList;
private import gtkD.gstreamer.Message;
private import gtkD.gstreamer.Query;
private import gtkD.gstreamer.Event;
private import gtkD.gstreamer.Bus;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * GstElement is the abstract base class needed to construct an element that
 * can be used in a GStreamer pipeline. Please refer to the plugin writers
 * guide for more information on creating GstElement subclasses.
 * The name of a GstElement can be get with gst_element_get_name() and set with
 * gst_element_set_name(). For speed, GST_ELEMENT_NAME() can be used in the
 * core when using the appropriate locking. Do not use this in plug-ins or
 * applications in order to retain ABI compatibility.
 * All elements have pads (of the type GstPad). These pads link to pads on
 * other elements. GstBuffer flow between these linked pads.
 * A GstElement has a GList of GstPad structures for all their input (or sink)
 * and output (or source) pads.
 * Core and plug-in writers can add and remove pads with gst_element_add_pad()
 * and gst_element_remove_pad().
 * A pad of an element can be retrieved by name with gst_element_get_pad().
 * An iterator of all pads can be retrieved with gst_element_iterate_pads().
 * Elements can be linked through their pads.
 * If the link is straightforward, use the gst_element_link()
 * convenience function to link two elements, or gst_element_link_many()
 * for more elements in a row.
 * Use gst_element_link_filtered() to link two elements constrained by
 * a specified set of GstCaps.
 * For finer control, use gst_element_link_pads() and
 * gst_element_link_pads_filtered() to specify the pads to link on
 * each element by name.
 * Each element has a state (see GstState). You can get and set the state
 * of an element with gst_element_get_state() and gst_element_set_state().
 * To get a string representation of a GstState, use
 * gst_element_state_get_name().
 * You can get and set a GstClock on an element using gst_element_get_clock()
 * and gst_element_set_clock().
 * Some elements can provide a clock for the pipeline if
 * gst_element_provides_clock() returns TRUE. With the
 * gst_element_provide_clock() method one can retrieve the clock provided by
 * such an element.
 * Not all elements require a clock to operate correctly. If
 * gst_element_requires_clock() returns TRUE, a clock should be set on the
 * element with gst_element_set_clock().
 * Note that clock slection and distribution is normally handled by the
 * toplevel GstPipeline so the clock functions are only to be used in very
 * specific situations.
 * Last reviewed on 2006-03-12 (0.10.5)
 */
public class Element : ObjectGst
{

	/** the main Gtk struct */
	protected GstElement* gstElement;


	public GstElement* getElementStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstElement* gstElement);

	/**
	 * Queries an element for the stream position.
	 * This is a convenience function for gstreamerD.
	 * Returns:
	 *  The current position in nanoseconds - GstFormat.TIME.
	 */
	public long queryPosition();

	/**
	 * Queries an element for the stream duration.
	 * This is a convenience function for gstreamerD.
	 * Returns:
	 *  The duration in nanoseconds - GstFormat.TIME.
	 */
	public long queryDuration();

	/**
	 *	This set's the filename for a filesrc element.
	 */
	public void location( string set );

	/**
	 * Set the caps property of an Element.
	 */
	void caps( Caps cp );

	/**
	 * For your convenience in gstreamerD: you can seek to the
	 * position of the pipeline measured in time_nanoseconds.
	 */
	public int seek( ulong time_nanoseconds ) ;

	/**
	 * Get's all the pads from an element in a Pad[]. FIXME: This a hackish mess.
	 */
	public Pad[] pads();

	//HANDEDIT: This is a way to add disconnectOnPadAdded
	//There still doesn't seem to be a way to put it
	//there automatically...
	/*
	protected uint padAddedHandlerId;
	void delegate(Pad, Element)[] onPadAddedListeners;
	void addOnPadAdded(void delegate(Pad, Element) dlg)
	{
		if ( !("pad-added" in connectedSignals) )
		{
			padAddedHandlerId = Signals.connectData(
			getStruct(),
			"pad-added",
			cast(GCallback)&callBackPadAdded,
			cast(void*)this,
			null,
			cast(ConnectFlags)0);
			connectedSignals["pad-added"] = 1;
		}
		onPadAddedListeners ~= dlg;
	}
	extern(C) static void callBackPadAdded(GstElement* gstelementStruct, GObject* newPad, Element element)
	{
		bit consumed = false;

		foreach ( void delegate(Pad, Element) dlg ; element.onPadAddedListeners )
		{
			dlg(new Pad(newPad), element);
		}

		return consumed;
	}
	void disconnectOnPadAdded()
	{
		if( "pad-added" in connectedSignals )
		{
			Signals.handlerDisconnect( getStruct(), padAddedHandlerId );
			padAddedHandlerId = 0;
			connectedSignals["pad-added"] = 0;
			onPadAddedListeners = null;
		}
	}
	 */

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(Element)[] onNoMorePadsListeners;
	/**
	 * This signals that the element will not generate more dynamic pads.
	 */
	void addOnNoMorePads(void delegate(Element) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackNoMorePads(GstElement* gstelementStruct, Element element);

	void delegate(Pad, Element)[] onPadAddedListeners;
	/**
	 * a new GstPad has been added to the element.
	 */
	void addOnPadAdded(void delegate(Pad, Element) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPadAdded(GstElement* gstelementStruct, GObject* newPad, Element element);

	void delegate(Pad, Element)[] onPadRemovedListeners;
	/**
	 * a GstPad has been removed from the element
	 * See Also
	 * GstElementFactory, GstPad
	 */
	void addOnPadRemoved(void delegate(Pad, Element) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPadRemoved(GstElement* gstelementStruct, GObject* oldPad, Element element);



	/**
	 * Adds a padtemplate to an element class. This is mainly used in the _base_init
	 * functions of classes.
	 * Params:
	 * klass =  the GstElementClass to add the pad template to.
	 * templ =  a GstPadTemplate to add to the element class.
	 */
	public static void classAddPadTemplate(GstElementClass* klass, GstPadTemplate* templ);

	/**
	 * Retrieves a padtemplate from element_class with the given name.
	 * Note
	 * If you use this function in the GInstanceInitFunc of an object class
	 * that has subclasses, make sure to pass the g_class parameter of the
	 * GInstanceInitFunc here.
	 * Params:
	 * elementClass =  a GstElementClass to get the pad template of.
	 * name =  the name of the GstPadTemplate to get.
	 * Returns: the GstPadTemplate with the given name, or NULL if none was found.No unreferencing is necessary.
	 */
	public static GstPadTemplate* classGetPadTemplate(GstElementClass* elementClass, string name);

	/**
	 * Retrieves a list of the pad templates associated with element_class. The
	 * list must not be modified by the calling code.
	 * Note
	 * If you use this function in the GInstanceInitFunc of an object class
	 * that has subclasses, make sure to pass the g_class parameter of the
	 * GInstanceInitFunc here.
	 * Params:
	 * elementClass =  a GstElementClass to get pad templates of.
	 * Returns: the GList of padtemplates.
	 */
	public static GList* classGetPadTemplateList(GstElementClass* elementClass);

	/**
	 * Sets the detailed information for a GstElementClass.
	 * Note
	 * This function is for use in _base_init functions only.
	 * The details are copied.
	 * Params:
	 * klass =  class to set details for
	 * details =  details to set
	 */
	public static void classSetDetails(GstElementClass* klass, GstElementDetails* details);

	/**
	 * Adds a pad (link point) to element. pad's parent will be set to element;
	 * see gst_object_set_parent() for refcounting information.
	 * Pads are not automatically activated so elements should perform the needed
	 * steps to activate the pad in case this pad is added in the PAUSED or PLAYING
	 * state. See gst_pad_set_active() for more information about activating pads.
	 * The pad and the element should be unlocked when calling this function.
	 * This function will emit the GstElement::pad-added signal on the element.
	 * Params:
	 * pad =  the GstPad to add to the element.
	 * Returns: TRUE if the pad could be added. This function can fail whena pad with the same name already existed or the pad already had anotherparent.MT safe.
	 */
	public int addPad(Pad pad);

	/**
	 * Retrieves a pad from element by name. Tries gst_element_get_static_pad()
	 * first, then gst_element_get_request_pad().
	 * Note
	 * Usage of this function is not recommended as it is unclear if the reference
	 * to the result pad should be released with gst_object_unref() in case of a static pad
	 * or gst_element_release_request_pad() in case of a request pad.
	 * Params:
	 * name =  the name of the pad to retrieve.
	 * Returns: the GstPad if found, otherwise NULL. Unref or Release after usage,depending on the type of the pad.
	 */
	public Pad getPad(string name);

	/**
	 * Creates a pad for each pad template that is always available.
	 * This function is only useful during object intialization of
	 * subclasses of GstElement.
	 */
	public void createAllPads();

	/**
	 * Looks for an unlinked pad to which the given pad can link. It is not
	 * guaranteed that linking the pads will work, though it should work in most
	 * cases.
	 * Params:
	 * pad =  the GstPad to find a compatible one for.
	 * caps =  the GstCaps to use as a filter.
	 * Returns: the GstPad to which a link can be made, or NULL if one cannot befound.
	 */
	public Pad getCompatiblePad(Pad pad, Caps caps);

	/**
	 * Retrieves a pad template from element that is compatible with compattempl.
	 * Pads from compatible templates can be linked together.
	 * Params:
	 * compattempl =  the GstPadTemplate to find a compatible template for.
	 * Returns: a compatible GstPadTemplate, or NULL if none was found. Nounreferencing is necessary.
	 */
	public GstPadTemplate* getCompatiblePadTemplate(GstPadTemplate* compattempl);

	/**
	 * Retrieves a pad from the element by name. This version only retrieves
	 * request pads. The pad should be released with
	 * gst_element_release_request_pad().
	 * Params:
	 * name =  the name of the request GstPad to retrieve.
	 * Returns: requested GstPad if found, otherwise NULL. Release after usage.
	 */
	public Pad getRequestPad(string name);

	/**
	 * Retrieves a pad from element by name. This version only retrieves
	 * already-existing (i.e. 'static') pads.
	 * Params:
	 * name =  the name of the static GstPad to retrieve.
	 * Returns: the requested GstPad if found, otherwise NULL. unref afterusage.MT safe.
	 */
	public Pad getStaticPad(string name);

	/**
	 * Use this function to signal that the element does not expect any more pads
	 * to show up in the current pipeline. This function should be called whenever
	 * pads have been added by the element itself. Elements with GST_PAD_SOMETIMES
	 * pad templates use this in combination with autopluggers to figure out that
	 * the element is done initializing its pads.
	 * This function emits the GstElement::no-more-pads signal.
	 * MT safe.
	 */
	public void noMorePads();

	/**
	 * Makes the element free the previously requested pad as obtained
	 * with gst_element_get_request_pad().
	 * MT safe.
	 * Params:
	 * pad =  the GstPad to release.
	 */
	public void releaseRequestPad(Pad pad);

	/**
	 * Removes pad from element. pad will be destroyed if it has not been
	 * referenced elsewhere using gst_object_unparent().
	 * This function is used by plugin developers and should not be used
	 * by applications. Pads that were dynamically requested from elements
	 * with gst_element_get_request_pad() should be released with the
	 * gst_element_release_request_pad() function instead.
	 * Pads are not automatically deactivated so elements should perform the needed
	 * steps to deactivate the pad in case this pad is removed in the PAUSED or
	 * PLAYING state. See gst_pad_set_active() for more information about
	 * deactivating pads.
	 * The pad and the element should be unlocked when calling this function.
	 * This function will emit the GstElement::pad-removed signal on the element.
	 * Params:
	 * pad =  the GstPad to remove from the element.
	 * Returns: TRUE if the pad could be removed. Can return FALSE if thepad does not belong to the provided element.MT safe.
	 */
	public int removePad(Pad pad);

	/**
	 * Retrieves an iterattor of element's pads. The iterator should
	 * be freed after usage.
	 * Returns: the GstIterator of GstPad. Unref each pad after use.MT safe.
	 */
	public Iterator iteratePads();

	/**
	 * Retrieves an iterator of element's sink pads.
	 * Returns: the GstIterator of GstPad. Unref each pad after use.MT safe.
	 */
	public Iterator iterateSinkPads();

	/**
	 * Retrieves an iterator of element's source pads.
	 * Returns: the GstIterator of GstPad. Unref each pad after use.MT safe.
	 */
	public Iterator iterateSrcPads();

	/**
	 * Links src to dest. The link must be from source to
	 * destination; the other direction will not be tried. The function looks for
	 * existing pads that aren't linked yet. It will request new pads if necessary.
	 * If multiple links are possible, only one is established.
	 * Make sure you have added your elements to a bin or pipeline with
	 * gst_bin_add() before trying to link them.
	 * Params:
	 * dest =  the GstElement containing the destination pad.
	 * Returns: TRUE if the elements could be linked, FALSE otherwise.
	 */
	public int link(Element dest);

	/**
	 * Unlinks all source pads of the source element with all sink pads
	 * of the sink element to which they are linked.
	 * Params:
	 * dest =  the sink GstElement to unlink.
	 */
	public void unlink(Element dest);

	/**
	 * Links the two named pads of the source and destination elements.
	 * Side effect is that if one of the pads has no parent, it becomes a
	 * child of the parent of the other element. If they have different
	 * parents, the link fails.
	 * Params:
	 * src =  a GstElement containing the source pad.
	 * srcpadname =  the name of the GstPad in source element or NULL for any pad.
	 * dest =  the GstElement containing the destination pad.
	 * destpadname =  the name of the GstPad in destination element,
	 * or NULL for any pad.
	 * Returns: TRUE if the pads could be linked, FALSE otherwise.
	 */
	public int linkPads(string srcpadname, Element dest, string destpadname);

	/**
	 * Unlinks the two named pads of the source and destination elements.
	 * Params:
	 * src =  a GstElement containing the source pad.
	 * srcpadname =  the name of the GstPad in source element.
	 * dest =  a GstElement containing the destination pad.
	 * destpadname =  the name of the GstPad in destination element.
	 */
	public void unlinkPads(string srcpadname, Element dest, string destpadname);

	/**
	 * Links the two named pads of the source and destination elements. Side effect
	 * is that if one of the pads has no parent, it becomes a child of the parent of
	 * the other element. If they have different parents, the link fails. If caps
	 * is not NULL, makes sure that the caps of the link is a subset of caps.
	 * Params:
	 * src =  a GstElement containing the source pad.
	 * srcpadname =  the name of the GstPad in source element or NULL for any pad.
	 * dest =  the GstElement containing the destination pad.
	 * destpadname =  the name of the GstPad in destination element or NULL for any pad.
	 * filter =  the GstCaps to filter the link, or NULL for no filter.
	 * Returns: TRUE if the pads could be linked, FALSE otherwise.
	 */
	public int linkPadsFiltered(string srcpadname, Element dest, string destpadname, Caps filter);

	/**
	 * Links src to dest using the given caps as filtercaps.
	 * The link must be from source to
	 * destination; the other direction will not be tried. The function looks for
	 * existing pads that aren't linked yet. It will request new pads if necessary.
	 * If multiple links are possible, only one is established.
	 * Make sure you have added your elements to a bin or pipeline with
	 * gst_bin_add() before trying to link them.
	 * Params:
	 * dest =  the GstElement containing the destination pad.
	 * filter =  the GstCaps to filter the link, or NULL for no filter.
	 * Returns: TRUE if the pads could be linked, FALSE otherwise.
	 */
	public int linkFiltered(Element dest, Caps filter);

	/**
	 * Set the base time of an element. See gst_element_get_base_time().
	 * MT safe.
	 * Params:
	 * time =  the base time to set.
	 */
	public void setBaseTime(GstClockTime time);

	/**
	 * Returns the base time of the element. The base time is the
	 * absolute time of the clock when this element was last put to
	 * PLAYING. Subtracting the base time from the clock time gives
	 * the stream time of the element.
	 * Returns: the base time of the element.MT safe.
	 */
	public GstClockTime getBaseTime();

	/**
	 * Sets the bus of the element. Increases the refcount on the bus.
	 * For internal use only, unless you're testing elements.
	 * MT safe.
	 * Params:
	 * bus =  the GstBus to set.
	 */
	public void setBus(Bus bus);

	/**
	 * Returns the bus of the element.
	 * Returns: the element's GstBus. unref after usage.MT safe.
	 */
	public Bus getBus();

	/**
	 * Retrieves the factory that was used to create this element.
	 * Returns: the GstElementFactory used for creating this element.no refcounting is needed.
	 */
	public GstElementFactory* getFactory();

	/**
	 * Set index on the element. The refcount of the index
	 * will be increased, any previously set index is unreffed.
	 * MT safe.
	 * Params:
	 * index =  a GstIndex.
	 */
	public void setIndex(Index index);

	/**
	 * Gets the index from the element.
	 * Returns: a GstIndex or NULL when no index was set on theelement. unref after usage.MT safe.
	 */
	public Index getIndex();

	/**
	 * Queries if the element can be indexed.
	 * Returns: TRUE if the element can be indexed.MT safe.
	 */
	public int isIndexable();

	/**
	 * Query if the element requires a clock.
	 * Returns: TRUE if the element requires a clockMT safe.
	 */
	public int requiresClock();

	/**
	 * Sets the clock for the element. This function increases the
	 * refcount on the clock. Any previously set clock on the object
	 * is unreffed.
	 * Params:
	 * clock =  the GstClock to set for the element.
	 * Returns: TRUE if the element accepted the clock. An element can refuse aclock when it, for example, is not able to slave its internal clock to theclock or when it requires a specific clock to operate.MT safe.
	 */
	public int setClock(Clock clock);

	/**
	 * Gets the currently configured clock of the element. This is the clock as was
	 * last set with gst_element_set_clock().
	 * Returns: the GstClock of the element. unref after usage.MT safe.
	 */
	public Clock getClock();

	/**
	 * Query if the element provides a clock. A GstClock provided by an
	 * element can be used as the global GstClock for the pipeline.
	 * An element that can provide a clock is only required to do so in the PAUSED
	 * state, this means when it is fully negotiated and has allocated the resources
	 * to operate the clock.
	 * Returns: TRUE if the element provides a clockMT safe.
	 */
	public int providesClock();

	/**
	 * Get the clock provided by the given element.
	 * Note
	 * An element is only required to provide a clock in the PAUSED
	 * state. Some elements can provide a clock in other states.
	 * Returns: the GstClock provided by the element or NULLif no clock could be provided. Unref after usage.MT safe.
	 */
	public Clock provideClock();

	/**
	 * Sets the state of the element. This function will try to set the
	 * requested state by going through all the intermediary states and calling
	 * the class's state change function for each.
	 * This function can return GST_STATE_CHANGE_ASYNC, in which case the
	 * element will perform the remainder of the state change asynchronously in
	 * another thread.
	 * An application can use gst_element_get_state() to wait for the completion
	 * of the state change or it can wait for a state change message on the bus.
	 * Params:
	 * state =  the element's new GstState.
	 * Returns: Result of the state change using GstStateChangeReturn.MT safe.
	 */
	public GstStateChangeReturn setState(GstState state);

	/**
	 * Gets the state of the element.
	 * For elements that performed an ASYNC state change, as reported by
	 * gst_element_set_state(), this function will block up to the
	 * specified timeout value for the state change to complete.
	 * If the element completes the state change or goes into
	 * an error, this function returns immediately with a return value of
	 * GST_STATE_CHANGE_SUCCESS or GST_STATE_CHANGE_FAILURE respectively.
	 * For elements that did not return GST_STATE_CHANGE_ASYNC, this function
	 * returns the current and pending state immediately.
	 * This function returns GST_STATE_CHANGE_NO_PREROLL if the element
	 * successfully changed its state but is not able to provide data yet.
	 * This mostly happens for live sources that only produce data in the PLAYING
	 * state. While the state change return is equivalent to
	 * GST_STATE_CHANGE_SUCCESS, it is returned to the application to signal that
	 * some sink elements might not be able to complete their state change because
	 * an element is not producing data to complete the preroll. When setting the
	 * element to playing, the preroll will complete and playback will start.
	 * Params:
	 * state =  a pointer to GstState to hold the state. Can be NULL.
	 * pending =  a pointer to GstState to hold the pending state.
	 *  Can be NULL.
	 * timeout =  a GstClockTime to specify the timeout for an async
	 *  state change or GST_CLOCK_TIME_NONE for infinite timeout.
	 * Returns: GST_STATE_CHANGE_SUCCESS if the element has no more pending state and the last state change succeeded, GST_STATE_CHANGE_ASYNC if the element is still performing a state change or GST_STATE_CHANGE_FAILURE if the last state change failed.MT safe.
	 */
	public GstStateChangeReturn getState(GstState* state, GstState* pending, GstClockTime timeout);

	/**
	 * Locks the state of an element, so state changes of the parent don't affect
	 * this element anymore.
	 * MT safe.
	 * Params:
	 * lockedState =  TRUE to lock the element's state
	 * Returns: TRUE if the state was changed, FALSE if bad parameters were givenor the elements state-locking needed no change.
	 */
	public int setLockedState(int lockedState);

	/**
	 * Checks if the state of an element is locked.
	 * If the state of an element is locked, state changes of the parent don't
	 * affect the element.
	 * This way you can leave currently unused elements inside bins. Just lock their
	 * state before changing the state from GST_STATE_NULL.
	 * MT safe.
	 * Returns: TRUE, if the element's state is locked.
	 */
	public int isLockedState();

	/**
	 * Abort the state change of the element. This function is used
	 * by elements that do asynchronous state changes and find out
	 * something is wrong.
	 * This function should be called with the STATE_LOCK held.
	 * MT safe.
	 */
	public void abortState();

	/**
	 * Commit the state change of the element and proceed to the next
	 * pending state if any. This function is used
	 * by elements that do asynchronous state changes.
	 * The core will normally call this method automatically when an
	 * element returned GST_STATE_CHANGE_SUCCESS from the state change function.
	 * If after calling this method the element still has not reached
	 * the pending state, the next state change is performed.
	 * This method is used internally and should normally not be called by plugins
	 * or applications.
	 * Params:
	 * ret =  The previous state return value
	 * Returns: The result of the commit state change. MT safe.
	 */
	public GstStateChangeReturn continueState(GstStateChangeReturn ret);

	/**
	 * Brings the element to the lost state. The current state of the
	 * element is copied to the pending state so that any call to
	 * gst_element_get_state() will return GST_STATE_CHANGE_ASYNC.
	 * This is mostly used for elements that lost their preroll buffer
	 * in the GST_STATE_PAUSED state after a flush, they become GST_STATE_PAUSED
	 * again if a new preroll buffer is queued.
	 * This function can only be called when the element is currently
	 * not in error or an async state change.
	 * This function is used internally and should normally not be called from
	 * plugins or applications.
	 * MT safe.
	 */
	public void lostState();

	/**
	 * Gets a string representing the given state.
	 * Params:
	 * state =  a GstState to get the name of.
	 * Returns: a string with the name of the state.
	 */
	public static string stateGetName(GstState state);

	/**
	 * Gets a string representing the given state change result.
	 * Params:
	 * stateRet =  a GstStateChangeReturn to get the name of.
	 * Returns: a string with the name of the state change result.
	 */
	public static string stateChangeReturnGetName(GstStateChangeReturn stateRet);

	/**
	 * Tries to change the state of the element to the same as its parent.
	 * If this function returns FALSE, the state of element is undefined.
	 * Returns: TRUE, if the element's state could be synced to the parent's state.MT safe.
	 */
	public int syncStateWithParent();

	/**
	 * Posts a message to the bus that new tags were found, and pushes an event
	 * to all sourcepads. Takes ownership of the list.
	 * This is a utility method for elements. Applications should use the
	 * GstTagSetter interface.
	 * Params:
	 * list =  list of tags.
	 */
	public void foundTags(TagList list);

	/**
	 * Posts a message to the bus that new tags were found and pushes the
	 * tags as event. Takes ownership of the list.
	 * This is a utility method for elements. Applications should use the
	 * GstTagSetter interface.
	 * Params:
	 * pad =  pad on which to push tag-event.
	 * list =  the taglist to post on the bus and create event from.
	 */
	public void foundTagsForPad(Pad pad, TagList list);

	/**
	 * Post an error, warning or info message on the bus from inside an element.
	 * type must be of GST_MESSAGE_ERROR, GST_MESSAGE_WARNING or
	 * GST_MESSAGE_INFO.
	 * MT safe.
	 * Params:
	 * type =  the GstMessageType
	 * domain =  the GStreamer GError domain this message belongs to
	 * code =  the GError code belonging to the domain
	 * text =  an allocated text string to be used as a replacement for the
	 *  default message connected to code, or NULL
	 * dbug =  an allocated debug message to be used as a replacement for the
	 *  default debugging information, or NULL
	 * file =  the source code file where the error was generated
	 * funct =  the source code function where the error was generated
	 * line =  the source code line where the error was generated
	 */
	public void messageFull(GstMessageType type, GQuark domain, int code, string text, string dbug, string file, string funct, int line);

	/**
	 * Post a message on the element's GstBus. This function takes ownership of the
	 * message; if you want to access the message after this call, you should add an
	 * additional reference before calling.
	 * Params:
	 * message =  a GstMessage to post
	 * Returns: TRUE if the message was successfully posted. The function returnsFALSE if the element did not have a bus.MT safe.
	 */
	public int postMessage(Message message);

	/**
	 * Get an array of query types from the element.
	 * If the element doesn't implement a query types function,
	 * the query will be forwarded to the peer of a random linked sink pad.
	 * Returns: An array of GstQueryType elements that should notbe freed or modified.MT safe.
	 */
	public GstQueryType* getQueryTypes();

	/**
	 * Performs a query on the given element.
	 * For elements that don't implement a query handler, this function
	 * forwards the query to a random srcpad or to the peer of a
	 * random linked sinkpad of this element.
	 * Params:
	 * query =  the GstQuery.
	 * Returns: TRUE if the query could be performed.MT safe.
	 */
	public int query(Query query);

	/**
	 * Queries an element to convert src_val in src_format to dest_format.
	 * Params:
	 * srcFormat =  a GstFormat to convert from.
	 * srcVal =  a value to convert.
	 * destFormat =  a pointer to the GstFormat to convert to.
	 * destVal =  a pointer to the result.
	 * Returns: TRUE if the query could be performed.
	 */
	public int queryConvert(GstFormat srcFormat, long srcVal, GstFormat* destFormat, long* destVal);

	/**
	 * Queries an element for the stream position.
	 * Params:
	 * format =  a pointer to the GstFormat asked for.
	 *  On return contains the GstFormat used.
	 * cur =  A location in which to store the current position, or NULL.
	 * Returns: TRUE if the query could be performed.
	 */
	public int queryPosition(GstFormat* format, long* cur);

	/**
	 * Queries an element for the total stream duration.
	 * Params:
	 * format =  a pointer to the GstFormat asked for.
	 *  On return contains the GstFormat used.
	 * duration =  A location in which to store the total duration, or NULL.
	 * Returns: TRUE if the query could be performed.
	 */
	public int queryDuration(GstFormat* format, long* duration);

	/**
	 * Sends an event to an element. If the element doesn't implement an
	 * event handler, the event will be pushed on a random linked sink pad for
	 * upstream events or a random linked source pad for downstream events.
	 * This function takes owership of the provided event so you should
	 * gst_event_ref() it if you want to reuse the event after this call.
	 * Params:
	 * event =  the GstEvent to send to the element.
	 * Returns: TRUE if the event was handled.MT safe.
	 */
	public int sendEvent(Event event);

	/**
	 * Simple API to perform a seek on the given element, meaning it just seeks
	 * to the given position relative to the start of the stream. For more complex
	 * operations like segment seeks (e.g. for looping) or changing the playback
	 * rate or seeking relative to the last configured playback segment you should
	 * use gst_element_seek().
	 * In a completely prerolled PAUSED or PLAYING pipeline, seeking is always
	 * guaranteed to return TRUE on a seekable media type or FALSE when the media
	 * type is certainly not seekable (such as a live stream).
	 * Some elements allow for seeking in the READY state, in this
	 * case they will store the seek event and execute it when they are put to
	 * PAUSED. If the element supports seek in READY, it will always return TRUE when
	 * it receives the event in the READY state.
	 * Params:
	 * format =  a GstFormat to execute the seek in, such as GST_FORMAT_TIME
	 * seekFlags =  seek options
	 * seekPos =  position to seek to (relative to the start); if you are doing
	 *  a seek in GST_FORMAT_TIME this value is in nanoseconds -
	 *  multiply with GST_SECOND to convert seconds to nanoseconds or
	 *  with GST_MSECOND to convert milliseconds to nanoseconds.
	 * Returns: TRUE if the seek operation succeeded (the seek might not always beexecuted instantly though)Since 0.10.7
	 */
	public int seekSimple(GstFormat format, GstSeekFlags seekFlags, long seekPos);

	/**
	 * Sends a seek event to an element. See gst_event_new_seek() for the details of
	 * the parameters. The seek event is sent to the element using
	 * gst_element_send_event().
	 * Params:
	 * rate =  The new playback rate
	 * format =  The format of the seek values
	 * flags =  The optional seek flags.
	 * curType =  The type and flags for the new current position
	 * cur =  The value of the new current position
	 * stopType =  The type and flags for the new stop position
	 * stop =  The value of the new stop position
	 * Returns: TRUE if the event was handled.MT safe.Signal DetailsThe "no-more-pads" signalvoid user_function (GstElement *gstelement, gpointer user_data) : Run lastThis signals that the element will not generate more dynamic pads.
	 */
	public int seek(double rate, GstFormat format, GstSeekFlags flags, GstSeekType curType, long cur, GstSeekType stopType, long stop);
}
