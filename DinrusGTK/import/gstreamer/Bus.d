module gtkD.gstreamer.Bus;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gstreamer.Message;
private import gtkD.glib.Source;



private import gtkD.gstreamer.ObjectGst;

/**
 * Description
 * The GstBus is an object responsible for delivering GstMessages in
 * a first-in first-out way from the streaming threads to the application.
 * Since the application typically only wants to deal with delivery of these
 * messages from one thread, the GstBus will marshall the messages between
 * different threads. This is important since the actual streaming of media
 * is done in another thread than the application.
 * The GstBus provides support for GSource based notifications. This makes it
 * possible to handle the delivery in the glib mainloop.
 * The GSource callback function gst_bus_async_signal_func() can be used to
 * convert all bus messages into signal emissions.
 * A message is posted on the bus with the gst_bus_post() method. With the
 * gst_bus_peek() and gst_bus_pop() methods one can look at or retrieve a
 * previously posted message.
 * The bus can be polled with the gst_bus_poll() method. This methods blocks
 * up to the specified timeout value until one of the specified messages types
 * is posted on the bus. The application can then _pop() the messages from the
 * bus to handle them.
 * Alternatively the application can register an asynchronous bus function
 * using gst_bus_add_watch_full() or gst_bus_add_watch(). This function will
 * install a GSource in the default glib main loop and will deliver messages
 * a short while after they have been posted. Note that the main loop should
 * be running for the asynchronous callbacks.
 * It is also possible to get messages from the bus without any thread
 * marshalling with the gst_bus_set_sync_handler() method. This makes it
 * possible to react to a message in the same thread that posted the
 * message on the bus. This should only be used if the application is able
 * to deal with messages from different threads.
 * Every GstPipeline has one bus.
 * Note that a GstPipeline will set its bus into flushing state when changing
 * from READY to NULL state.
 * Last reviewed on 2006-03-12 (0.10.5)
 */
public class Bus : ObjectGst
{
	
	/** the main Gtk struct */
	protected GstBus* gstBus;
	
	
	public GstBus* getBusStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstBus* gstBus);
	
	/**
	 * Adds a bus watch to the default main context with the default priority.
	 * This function is used to receive asynchronous messages in the main loop.
	 * The watch can be removed using g_source_remove() or by returning FALSE
	 * from func.
	 * MT safe.
	 * Params:
	 *  dlg = A function to call when a message is received.
	 * Returns:
	 *  The event source id.
	 */
	public uint addWatch( bool delegate(Message) dlg );
	
	bool delegate(Message) onWatchListener;
	
	extern(C) static gboolean watchCallBack(GstBus* bus, GstMessage* msg, Bus bus_d );
	
	/**
	 * Use this for making an XOverlay.
	 * Sets the synchronous handler on the bus. The function will be called
	 * every time a new message is posted on the bus. Note that the function
	 * will be called in the same thread context as the posting object. This
	 * function is usually only called by the creator of the bus. Applications
	 * should handle messages asynchronously using the gst_bus watch and poll
	 * functions.
	 * You cannot replace an existing sync_handler. You can pass NULL to this
	 * function, which will clear the existing handler.
	 * Params:
	 *  dlg = The handler function to install
	 */
	public void setSyncHandler( GstBusSyncReply delegate(Message) dlg );
	
	GstBusSyncReply delegate(Message) onSyncHandlerListener;
	
	extern(C) static GstBusSyncReply syncHandlerCallBack(GstBus * bus, GstMessage * msg, Bus bus_d );
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Message, Bus)[] onMessageListeners;
	/**
	 * A message has been posted on the bus. This signal is emitted from a
	 * GSource added to the mainloop. this signal will only be emitted when
	 * there is a mainloop running.
	 */
	void addOnMessage(void delegate(Message, Bus) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMessage(GstBus* busStruct, GstMessage* message, Bus bus);
	
	void delegate(Message, Bus)[] onSyncMessageListeners;
	/**
	 * A message has been posted on the bus. This signal is emitted from the
	 * thread that posted the message so one has to be careful with locking.
	 * This signal will not be emitted by default, you have to set up
	 * gst_bus_sync_signal_handler() as a sync handler if you want this
	 * gst_bus_set_sync_handler (bus, gst_bus_sync_signal_handler, yourdata);
	 * See Also
	 * GstMessage, GstElement
	 */
	void addOnSyncMessage(void delegate(Message, Bus) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSyncMessage(GstBus* busStruct, GstMessage* message, Bus bus);
	
	
	/**
	 * Creates a new GstBus instance.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Post a message on the given bus. Ownership of the message
	 * is taken by the bus.
	 * Params:
	 * message =  The GstMessage to post
	 * Returns: TRUE if the message could be posted, FALSE if the bus is flushing.MT safe.
	 */
	public int post(Message message);
	
	/**
	 * Check if there are pending messages on the bus that
	 * should be handled.
	 * Returns: TRUE if there are messages on the bus to be handled, FALSE otherwise.MT safe.
	 */
	public int havePending();
	
	/**
	 * Peek the message on the top of the bus' queue. The message will remain
	 * on the bus' message queue. A reference is returned, and needs to be unreffed
	 * by the caller.
	 * Returns: The GstMessage that is on the bus, or NULL if the bus is empty.MT safe.
	 */
	public Message peek();
	
	/**
	 * Get a message from the bus.
	 * Returns: The GstMessage that is on the bus, or NULL if the bus is empty.The message is taken from the bus and needs to be unreffed withgst_message_unref() after usage.MT safe.
	 */
	public Message pop();
	
	/**
	 * Get a message from the bus, waiting up to the specified timeout.
	 * If timeout is 0, this function behaves like gst_bus_pop(). If timeout is
	 * GST_CLOCK_TIME_NONE, this function will block forever until a message was
	 * posted on the bus.
	 * Params:
	 * timeout =  a timeout
	 * Returns: The GstMessage that is on the bus after the specified timeoutor NULL if the bus is empty after the timeout expired.The message is taken from the bus and needs to be unreffed withgst_message_unref() after usage.MT safe.Since 0.10.12
	 */
	public Message timedPop(GstClockTime timeout);
	
	/**
	 * If flushing, flush out and unref any messages queued in the bus. Releases
	 * references to the message origin objects. Will flush future messages until
	 * gst_bus_set_flushing() sets flushing to FALSE.
	 * MT safe.
	 * Params:
	 * flushing =  whether or not to flush the bus
	 */
	public void setFlushing(int flushing);
	
	/**
	 * A helper GstBusSyncHandler that can be used to convert all synchronous
	 * messages into signals.
	 * Params:
	 * message =  the GstMessage received
	 * data =  user data
	 * Returns: GST_BUS_PASS
	 */
	public GstBusSyncReply syncSignalHandler(Message message, void* data);
	
	/**
	 * Create watch for this bus. The GSource will be dispatched whenever
	 * a message is on the bus. After the GSource is dispatched, the
	 * message is popped off the bus and unreffed.
	 * Returns: A GSource that can be added to a mainloop.
	 */
	public Source createWatch();
	
	/**
	 * Adds a bus watch to the default main context with the given priority.
	 * This function is used to receive asynchronous messages in the main loop.
	 * When func is called, the message belongs to the caller; if you want to
	 * keep a copy of it, call gst_message_ref() before leaving func.
	 * The watch can be removed using g_source_remove() or by returning FALSE
	 * from func.
	 * Params:
	 * priority =  The priority of the watch.
	 * func =  A function to call when a message is received.
	 * userData =  user data passed to func.
	 * notify =  the function to call when the source is removed.
	 * Returns: The event source id.MT safe.
	 */
	public uint addWatchFull(int priority, GstBusFunc func, void* userData, GDestroyNotify notify);
	
	/**
	 * Instructs GStreamer to stop emitting the "sync-message" signal for this bus.
	 * See gst_bus_enable_sync_message_emission() for more information.
	 * In the event that multiple pieces of code have called
	 * gst_bus_enable_sync_message_emission(), the sync-message emissions will only
	 * be stopped after all calls to gst_bus_enable_sync_message_emission() were
	 * "cancelled" by calling this function. In this way the semantics are exactly
	 * the same as gst_object_ref() that which calls enable should also call
	 * disable.
	 * MT safe.
	 */
	public void disableSyncMessageEmission();
	
	/**
	 * Instructs GStreamer to emit the "sync-message" signal after running the bus's
	 * sync handler. This function is here so that code can ensure that they can
	 * synchronously receive messages without having to affect what the bin's sync
	 * handler is.
	 * This function may be called multiple times. To clean up, the caller is
	 * responsible for calling gst_bus_disable_sync_message_emission() as many times
	 * as this function is called.
	 * While this function looks similar to gst_bus_add_signal_watch(), it is not
	 * exactly the same -- this function enables synchronous emission of
	 * signals when messages arrive; gst_bus_add_signal_watch() adds an idle callback
	 * to pop messages off the bus asynchronously. The sync-message signal
	 * comes from the thread of whatever object posted the message; the "message"
	 * signal is marshalled to the main thread via the main loop.
	 * MT safe.
	 */
	public void enableSyncMessageEmission();
	
	/**
	 * A helper GstBusFunc that can be used to convert all asynchronous messages
	 * into signals.
	 * Params:
	 * message =  the GstMessage received
	 * data =  user data
	 * Returns: TRUE
	 */
	public int asyncSignalFunc(Message message, void* data);
	
	/**
	 * Adds a bus signal watch to the default main context with the default
	 * priority.
	 * After calling this statement, the bus will emit the "message" signal for each
	 * message posted on the bus.
	 * This function may be called multiple times. To clean up, the caller is
	 * responsible for calling gst_bus_remove_signal_watch() as many times as this
	 * function is called.
	 * MT safe.
	 */
	public void addSignalWatch();
	
	/**
	 * Adds a bus signal watch to the default main context with the given priority.
	 * After calling this statement, the bus will emit the "message" signal for each
	 * message posted on the bus when the main loop is running.
	 * This function may be called multiple times. To clean up, the caller is
	 * responsible for calling gst_bus_remove_signal_watch() as many times as this
	 * function is called.
	 * MT safe.
	 * Params:
	 * priority =  The priority of the watch.
	 */
	public void addSignalWatchFull(int priority);
	
	/**
	 * Removes a signal watch previously added with gst_bus_add_signal_watch().
	 * MT safe.
	 */
	public void removeSignalWatch();
	
	/**
	 * Poll the bus for messages. Will block while waiting for messages to come.
	 * You can specify a maximum time to poll with the timeout parameter. If
	 * timeout is negative, this function will block indefinitely.
	 * All messages not in events will be popped off the bus and will be ignored.
	 * Because poll is implemented using the "message" signal enabled by
	 * gst_bus_add_signal_watch(), calling gst_bus_poll() will cause the "message"
	 * signal to be emitted for every message that poll sees. Thus a "message"
	 * signal handler will see the same messages that this function sees -- neither
	 * will steal messages from the other.
	 * This function will run a main loop from the default main context when
	 * polling.
	 * Params:
	 * events =  a mask of GstMessageType, representing the set of message types to
	 * poll for.
	 * timeout =  the poll timeout, as a GstClockTimeDiff, or -1 to poll indefinitely.
	 * Returns: The message that was received, or NULL if the poll timed out.The message is taken from the bus and needs to be unreffed withgst_message_unref() after usage.Signal DetailsThe "message" signalvoid user_function (GstBus *bus, GstMessage *message, gpointer user_data) : Run last / Has detailsA message has been posted on the bus. This signal is emitted from aGSource added to the mainloop. this signal will only be emitted whenthere is a mainloop running.
	 */
	public Message poll(GstMessageType events, GstClockTimeDiff timeout);
}
