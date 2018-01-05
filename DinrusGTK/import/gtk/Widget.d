module gtkD.gtk.Widget;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.atk.ObjectAtk;
private import gtkD.gtk.Action;
private import gtkD.gdk.Rectangle;
private import gtkD.gtk.AccelGroup;
private import gtkD.glib.ListG;
private import gtkD.gdk.Event;
private import gtkD.gdk.Window;
private import gtkD.gdk.Colormap;
private import gtkD.gdk.Visual;
private import gtkD.gtk.Style;
private import gtkD.gdk.Bitmap;
private import gtkD.gdk.Pixmap;
private import gtkD.gtk.RcStyle;
private import gtkD.gdk.Color;
private import gtkD.gdk.Pixbuf;
private import gtkD.gtk.Adjustment;
private import gtkD.gobject.ParamSpec;
private import gtkD.gdk.Region;
private import gtkD.gobject.Value;
private import gtkD.gtk.Settings;
private import gtkD.gtk.Clipboard;
private import gtkD.gdk.Display;
private import gtkD.gdk.Screen;
private import gtkD.gtkc.gdk;
private import gtkD.gdk.Cursor;
private import gtkD.pango.PgLayout;
private import gtkD.pango.PgContext;
private import gtkD.pango.PgFontDescription;
private import gtkD.gdk.Drawable;
private import gtkD.gtk.Tooltips;
private import gtkD.gobject.Type;
private import gtkD.gtk.BuildableIF;
private import gtkD.gtk.BuildableT;


version(Rulada) {
	private import tango.text.convert.Integer;
} else {
	private import stdrus;
}


private import gtkD.gtk.ObjectGtk;

/**
 * Description
 * GtkWidget introduces style
 * properties - these are basically object properties that are stored
 * not on the object, but in the style object associated to the widget. Style
 * properties are set in resource files.
 * This mechanism is used for configuring such things as the location of the
 * scrollbar arrows through the theme, giving theme authors more control over the
 * look of applications without the need to write a theme engine in C.
 * Use gtk_widget_class_install_style_property() to install style properties for
 * a widget class, gtk_widget_class_find_style_property() or
 * gtk_widget_class_list_style_properties() to get information about existing
 * style properties and gtk_widget_style_get_property(), gtk_widget_style_get() or
 * gtk_widget_style_get_valist() to obtain the value of a style property.
 * GtkWidget as GtkBuildable
 * The GtkWidget implementation of the GtkBuildable interface supports a
 * custom <accelerator> element, which has attributes named key,
 * modifiers and signal and allows to specify accelerators.
 * Example 54. A UI definition fragment specifying an accelerator
 * <object class="GtkButton">
 *  <accelerator key="q" modifiers="GDK_CONTROL_MASK" signal="clicked"/>
 * </object>
 * In addition to accelerators, GtkWidget also support a
 * custom <accessible> element, which supports actions and relations.
 * Properties on the accessible implementation of an object can be set by accessing the
 * internal child "accessible" of a GtkWidget.
 * Example 55. A UI definition fragment specifying an accessible
 * <object class="GtkButton" id="label1"/>
 *  <property name="label">I am a Label for a Button</property>
 * </object>
 * <object class="GtkButton" id="button1">
 *  <accessibility>
 *  <action action_name="click" translatable="yes">Click the button.</action>
 *  <relation target="label1" type="labelled-by"/>
 *  </accessibility>
 *  <child internal-child="accessible">
 *  <object class="AtkObject" id="a11y-button1">
 *  <property name="AtkObject::name">Clickable Button</property>
 *  </object>
 *  </child>
 * </object>
 */
public class Widget : ObjectGtk, BuildableIF
{

	/** the main Gtk struct */
	protected GtkWidget* gtkWidget;


	public GtkWidget* getWidgetStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkWidget* gtkWidget);

	// add the Buildable capabilities
	mixin BuildableT!(GtkWidget);

	public GtkWidgetClass* getWidgetClass();

	/** */
	public int getWidth();
	/** */
	public int getHeight();

	/**
	 * The widget's allocated size.
	 * Returns: the GtkAllocation for this widget
	 */
	public GtkAllocation getAllocation();

	/**
	 * Gets the drawable for this widget
	 * Returns:
	 * 		The drawable for this widget
	 * Deprecated: use getWindow().
	 */
	deprecated Drawable getDrawable();

	/**
	 * Gets the Window for this widget
	 * Returns:
	 * 		The window for this widget
	 */
	Window getWindow();

	/**
	 * Sets  the cursor.
	 * Params:
	 *  cursor = the new cursor
	 * Bugs: the cursor changes to the parent widget also
	 */
	void setCursor(Cursor cursor);

	/**
	 * Resets the cursor.
	 * don't know if this is implemented by GTK+. Seems that it's not
	 * Bugs: does nothing
	 */
	public void resetCursor();

	/**
	 * Modifies the font for this widget.
	 * This just calls modifyFont(new PgFontDescription(PgFontDescription.fromString(family ~ " " ~ size)));
	 */
	public void modifyFont(string family, int size);


	/**
	 * Sets this widget tooltip
	 * Deprecated: Since 2.12 use setTooltipText() or setTooltipMarkup()
	 * Params:
	 *  tipText = the tooltip
	 *  tipPrivate = a private text
	 */
	void setTooltip(string tipText, string tipPrivate);

	/** */
	public bool onEvent(GdkEvent* event);

	/** */
	public bool onButtonPressEvent(GdkEventButton* event);

	/** */
	public bool onButtonReleaseEvent(GdkEventButton* event);

	/** */
	public bool onScrollEvent(GdkEventScroll* event);

	/** */
	public bool onMotionNotifyEvent(GdkEventMotion* event);

	/** */
	public bool onDeleteEvent(GdkEventAny* event);

	/** */
	public bool onExposeEvent(GdkEventExpose* event);

	/** */
	public bool onKeyPressEvent(GdkEventKey* event);

	/** */
	public bool onKeyReleaseEvent(GdkEventKey* event);

	/** */
	public bool onEnterNotifyEvent(GdkEventCrossing* event);

	/** */
	public bool onLeaveNotifyEvent(GdkEventCrossing* event);

	/** */
	public bool onConfigureEvent(GdkEventConfigure* event);

	/** */
	public bool onFocusInEvent(GdkEventFocus* event);

	/** */
	public bool onFocusOutEvent(GdkEventFocus* event);

	/** */
	public bool onMapEvent(GdkEventAny* event);

	/** */
	public bool onUnmapEvent(GdkEventAny* event);

	/** */
	public bool onPropertyNotifyEvent(GdkEventProperty* event);

	/** */
	public bool onSelectionClearEvent(GdkEventSelection* event);

	/** */
	public bool onSelectionRequestEvent(GdkEventSelection* event);

	/** */
	public bool onSelectionNotifyEvent(GdkEventSelection* event);

	/** */
	public bool onProximityInEvent(GdkEventProximity* event);

	/** */
	public bool onProximityOutEvent(GdkEventProximity* event);

	/** */
	public bool onVisibilityNotifyEvent(GdkEventVisibility* event);

	/** */
	public bool onClientEvent(GdkEventClient* event);

	/** */
	public bool onNoExposeEvent(GdkEventAny* event);

	/** */
	public bool onWindowStateEvent(GdkEventWindowState* event);

	//get the addOnDestroy from ObjectGtk
	alias ObjectGtk.addOnDestroy addOnDestroy;

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(Widget)[] onAccelClosuresChangedListeners;
	/**
	 */
	void addOnAccelClosuresChanged(void delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAccelClosuresChanged(GtkWidget* widgetStruct, Widget widget);

	bool delegate(GdkEventButton*, Widget)[] onButtonPressListeners;
	/**
	 * The ::button-press-event signal will be emitted when a button
	 * (typically from a mouse) is pressed.
	 * To receive this signal, the GdkWindow associated to the
	 * widget needs to enable the GDK_BUTTON_PRESS_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnButtonPress(bool delegate(GdkEventButton*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackButtonPress(GtkWidget* widgetStruct, GdkEventButton* event, Widget widget);

	bool delegate(GdkEventButton*, Widget)[] onButtonReleaseListeners;
	/**
	 * The ::button-release-event signal will be emitted when a button
	 * (typically from a mouse) is released.
	 * To receive this signal, the GdkWindow associated to the
	 * widget needs to enable the GDK_BUTTON_RELEASE_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnButtonRelease(bool delegate(GdkEventButton*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackButtonRelease(GtkWidget* widgetStruct, GdkEventButton* event, Widget widget);

	bool delegate(guint, Widget)[] onCanActivateAccelListeners;
	/**
	 * Determines whether an accelerator that activates the signal
	 * identified by signal_id can currently be activated.
	 * This signal is present to allow applications and derived
	 * widgets to override the default GtkWidget handling
	 * for determining whether an accelerator can be activated.
	 */
	void addOnCanActivateAccel(bool delegate(guint, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackCanActivateAccel(GtkWidget* widgetStruct, guint signalId, Widget widget);

	void delegate(ParamSpec, Widget)[] onChildNotifyListeners;
	/**
	 * The ::child-notify signal is emitted for each
	 * child property that has
	 * changed on an object. The signal's detail holds the property name.
	 */
	void addOnChildNotify(void delegate(ParamSpec, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChildNotify(GtkWidget* widgetStruct, GParamSpec* pspec, Widget widget);

	bool delegate(GdkEventClient*, Widget)[] onClientListeners;
	/**
	 * The ::client-event will be emitted when the widget's window
	 * receives a message (via a ClientMessage event) from another
	 * application.
	 */
	void addOnClient(bool delegate(GdkEventClient*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackClient(GtkWidget* widgetStruct, GdkEventClient* event, Widget widget);

	void delegate(Widget)[] onCompositedChangedListeners;
	/**
	 * The ::composited-changed signal is emitted when the composited
	 * status of widgets screen changes.
	 * See gdk_screen_is_composited().
	 */
	void addOnCompositedChanged(void delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCompositedChanged(GtkWidget* widgetStruct, Widget widget);

	bool delegate(GdkEventConfigure*, Widget)[] onConfigureListeners;
	/**
	 * The ::configure-event signal will be emitted when the size, position or
	 * stacking of the widget's window has changed.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_STRUCTURE_MASK mask. GDK will enable this mask
	 * automatically for all new windows.
	 */
	void addOnConfigure(bool delegate(GdkEventConfigure*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackConfigure(GtkWidget* widgetStruct, GdkEventConfigure* event, Widget widget);

	bool delegate(Event, Widget)[] onDamageListeners;
	/**
	 * Emitted when a redirected window belonging to widget gets drawn into.
	 * The region/area members of the event shows what area of the redirected
	 * drawable was drawn into.
	 * Since 2.14
	 */
	void addOnDamage(bool delegate(Event, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackDamage(GtkWidget* widgetStruct, GdkEvent* event, Widget widget);

	bool delegate(Event, Widget)[] onDeleteListeners;
	/**
	 * The ::delete-event signal is emitted if a user requests that
	 * a toplevel window is closed. The default handler for this signal
	 * destroys the window. Connecting gtk_widget_hide_on_delete() to
	 * this signal will cause the window to be hidden instead, so that
	 * it can later be shown again without reconstructing it.
	 */
	void addOnDelete(bool delegate(Event, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackDelete(GtkWidget* widgetStruct, GdkEvent* event, Widget widget);

	bool delegate(Event, Widget)[] onDestroyListeners;
	/**
	 * The ::destroy-event signal is emitted when a GdkWindow is destroyed.
	 * You rarely get this signal, because most widgets disconnect themselves
	 * from their window before they destroy it, so no widget owns the
	 * window at destroy time.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_STRUCTURE_MASK mask. GDK will enable this mask
	 * automatically for all new windows.
	 */
	void addOnDestroy(bool delegate(Event, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackDestroy(GtkWidget* widgetStruct, GdkEvent* event, Widget widget);

	void delegate(GtkTextDirection, Widget)[] onDirectionChangedListeners;
	/**
	 * The ::direction-changed signal is emitted when the text direction
	 * of a widget changes.
	 */
	void addOnDirectionChanged(void delegate(GtkTextDirection, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDirectionChanged(GtkWidget* widgetStruct, GtkTextDirection previousDirection, Widget widget);

	void delegate(GdkDragContext*, Widget)[] onDragBeginListeners;
	/**
	 * The ::drag-begin signal is emitted on the drag source when a drag is
	 * started. A typical reason to connect to this signal is to set up a
	 * custom drag icon with gtk_drag_source_set_icon().
	 * Note that some widgets set up a drag icon in the default handler of
	 * this signal, so you may have to use g_signal_connect_after() to
	 * override what the default handler did.
	 */
	void addOnDragBegin(void delegate(GdkDragContext*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDragBegin(GtkWidget* widgetStruct, GdkDragContext* dragContext, Widget widget);

	void delegate(GdkDragContext*, Widget)[] onDragDataDeleteListeners;
	/**
	 * The ::drag-data-delete signal is emitted on the drag source when a drag
	 * with the action GDK_ACTION_MOVE is successfully completed. The signal
	 * handler is responsible for deleting the data that has been dropped. What
	 * "delete" means depends on the context of the drag operation.
	 */
	void addOnDragDataDelete(void delegate(GdkDragContext*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDragDataDelete(GtkWidget* widgetStruct, GdkDragContext* dragContext, Widget widget);

	void delegate(GdkDragContext*, GtkSelectionData*, guint, guint, Widget)[] onDragDataGetListeners;
	/**
	 * The ::drag-data-get signal is emitted on the drag source when the drop
	 * site requests the data which is dragged. It is the responsibility of
	 * the signal handler to fill data with the data in the format which
	 * is indicated by info. See gtk_selection_data_set() and
	 * gtk_selection_data_set_text().
	 */
	void addOnDragDataGet(void delegate(GdkDragContext*, GtkSelectionData*, guint, guint, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDragDataGet(GtkWidget* widgetStruct, GdkDragContext* dragContext, GtkSelectionData* data, guint info, guint time, Widget widget);

	void delegate(GdkDragContext*, gint, gint, GtkSelectionData*, guint, guint, Widget)[] onDragDataReceivedListeners;
	/**
	 * The ::drag-data-received signal is emitted on the drop site when the
	 * dragged data has been received. If the data was received in order to
	 * determine whether the drop will be accepted, the handler is expected
	 * to call gdk_drag_status() and not finish the drag.
	 * If the data was received in response to a "drag-drop" signal
	 * (and this is the last target to be received), the handler for this
	 * signal is expected to process the received data and then call
	 * gtk_drag_finish(), setting the success parameter depending on whether
	 * the data was processed successfully.
	 * The handler may inspect and modify drag_context->action before calling
	 * gtk_drag_finish(), e.g. to implement GDK_ACTION_ASK as shown in the
	 * void
	 * drag_data_received (GtkWidget *widget,
	 *  GdkDragContext *drag_context,
	 *  gint x,
	 *  gint y,
	 *  GtkSelectionData *data,
	 *  guint info,
	 *  guint time)
	 * {
		 *  if ((data->length >= 0)  (data->format == 8))
		 *  {
			 *  if (drag_context->action == GDK_ACTION_ASK)
			 *  {
				 *  GtkWidget *dialog;
				 *  gint response;
				 *
				 *  dialog = gtk_message_dialog_new (NULL,
				 *  GTK_DIALOG_MODAL |
				 *  GTK_DIALOG_DESTROY_WITH_PARENT,
				 *  GTK_MESSAGE_INFO,
				 *  GTK_BUTTONS_YES_NO,
				 *  "Move the data ?\n");
				 *  response = gtk_dialog_run (GTK_DIALOG (dialog));
				 *  gtk_widget_destroy (dialog);
				 *
				 *  if (response == GTK_RESPONSE_YES)
				 *  drag_context->action = GDK_ACTION_MOVE;
				 *  else
				 *  drag_context->action = GDK_ACTION_COPY;
			 *  }
			 *
			 *  gtk_drag_finish (drag_context, TRUE, FALSE, time);
			 *  return;
		 *  }
		 *
		 *  gtk_drag_finish (drag_context, FALSE, FALSE, time);
	 *  }
	 */
	void addOnDragDataReceived(void delegate(GdkDragContext*, gint, gint, GtkSelectionData*, guint, guint, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDragDataReceived(GtkWidget* widgetStruct, GdkDragContext* dragContext, gint x, gint y, GtkSelectionData* data, guint info, guint time, Widget widget);

	bool delegate(GdkDragContext*, gint, gint, guint, Widget)[] onDragDropListeners;
	/**
	 * The ::drag-drop signal is emitted on the drop site when the user drops
	 * the data onto the widget. The signal handler must determine whether
	 * the cursor position is in a drop zone or not. If it is not in a drop
	 * zone, it returns FALSE and no further processing is necessary.
	 * Otherwise, the handler returns TRUE. In this case, the handler must
	 * ensure that gtk_drag_finish() is called to let the source know that
	 * the drop is done. The call to gtk_drag_finish() can be done either
	 * directly or in a "drag-data-received" handler which gets
	 * triggered by calling gtk_drag_get_data() to receive the data for one
	 * or more of the supported targets.
	 */
	void addOnDragDrop(bool delegate(GdkDragContext*, gint, gint, guint, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackDragDrop(GtkWidget* widgetStruct, GdkDragContext* dragContext, gint x, gint y, guint time, Widget widget);

	void delegate(GdkDragContext*, Widget)[] onDragEndListeners;
	/**
	 * The ::drag-end signal is emitted on the drag source when a drag is
	 * finished. A typical reason to connect to this signal is to undo
	 * things done in "drag-begin".
	 */
	void addOnDragEnd(void delegate(GdkDragContext*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDragEnd(GtkWidget* widgetStruct, GdkDragContext* dragContext, Widget widget);

	bool delegate(GdkDragContext*, GtkDragResult, Widget)[] onDragFailedListeners;
	/**
	 * The ::drag-failed signal is emitted on the drag source when a drag has
	 * failed. The signal handler may hook custom code to handle a failed DND
	 * operation based on the type of error, it returns TRUE is the failure has
	 * been already handled (not showing the default "drag operation failed"
	 * animation), otherwise it returns FALSE.
	 * Since 2.12
	 */
	void addOnDragFailed(bool delegate(GdkDragContext*, GtkDragResult, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackDragFailed(GtkWidget* widgetStruct, GdkDragContext* dragContext, GtkDragResult result, Widget widget);

	void delegate(GdkDragContext*, guint, Widget)[] onDragLeaveListeners;
	/**
	 * The ::drag-leave signal is emitted on the drop site when the cursor
	 * leaves the widget. A typical reason to connect to this signal is to
	 * undo things done in "drag-motion", e.g. undo highlighting
	 * with gtk_drag_unhighlight()
	 */
	void addOnDragLeave(void delegate(GdkDragContext*, guint, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDragLeave(GtkWidget* widgetStruct, GdkDragContext* dragContext, guint time, Widget widget);

	bool delegate(GdkDragContext*, gint, gint, guint, Widget)[] onDragMotionListeners;
	/**
	 * The drag-motion signal is emitted on the drop site when the user
	 * moves the cursor over the widget during a drag. The signal handler
	 * must determine whether the cursor position is in a drop zone or not.
	 * If it is not in a drop zone, it returns FALSE and no further processing
	 * is necessary. Otherwise, the handler returns TRUE. In this case, the
	 * handler is responsible for providing the necessary information for
	 * displaying feedback to the user, by calling gdk_drag_status().
	 * If the decision whether the drop will be accepted or rejected can't be
	 * made based solely on the cursor position and the type of the data, the
	 * handler may inspect the dragged data by calling gtk_drag_get_data() and
	 * defer the gdk_drag_status() call to the "drag-data-received"
	 * handler. Note that you cannot not pass GTK_DEST_DEFAULT_DROP,
	 * GTK_DEST_DEFAULT_MOTION or GTK_DEST_DEFAULT_ALL to gtk_drag_dest_set()
	 * when using the drag-motion signal that way.
	 * Also note that there is no drag-enter signal. The drag receiver has to
	 * keep track of whether he has received any drag-motion signals since the
	 * last "drag-leave" and if not, treat the drag-motion signal as
	 * an "enter" signal. Upon an "enter", the handler will typically highlight
	 * the drop site with gtk_drag_highlight().
	 * static void
	 * drag_motion (GtkWidget *widget,
	 *  GdkDragContext *context,
	 *  gint x,
	 *  gint y,
	 *  guint time)
	 * {
		 *  GdkAtom target;
		 *
		 *  PrivateData *private_data = GET_PRIVATE_DATA (widget);
		 *
		 *  if (!private_data->drag_highlight)
		 *  {
			 *  private_data->drag_highlight = 1;
			 *  gtk_drag_highlight (widget);
		 *  }
		 *
		 *  target = gtk_drag_dest_find_target (widget, context, NULL);
		 *  if (target == GDK_NONE)
		 *  gdk_drag_status (context, 0, time);
		 *  else
		 *  {
			 *  private_data->pending_status = context->suggested_action;
			 *  gtk_drag_get_data (widget, context, target, time);
		 *  }
		 *
		 *  return TRUE;
	 * }
	 *
	 * static void
	 * drag_data_received (GtkWidget *widget,
	 *  GdkDragContext *context,
	 *  gint x,
	 *  gint y,
	 *  GtkSelectionData *selection_data,
	 *  guint info,
	 *  guint time)
	 * {
		 *  PrivateData *private_data = GET_PRIVATE_DATA (widget);
		 *
		 *  if (private_data->suggested_action)
		 *  {
			 *  private_data->suggested_action = 0;
			 *
			 *  /+* We are getting this data due to a request in drag_motion,
			 *  * rather than due to a request in drag_drop, so we are just
			 *  * supposed to call gdk_drag_status (), not actually paste in
			 *  * the data.
			 *  +/
			 *  str = gtk_selection_data_get_text (selection_data);
			 *  if (!data_is_acceptable (str))
			 *  gdk_drag_status (context, 0, time);
			 *  else
			 *  gdk_drag_status (context, private_data->suggested_action, time);
		 *  }
		 *  else
		 *  {
			 *  /+* accept the drop +/
		 *  }
	 * }
	 */
	void addOnDragMotion(bool delegate(GdkDragContext*, gint, gint, guint, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackDragMotion(GtkWidget* widgetStruct, GdkDragContext* dragContext, gint x, gint y, guint time, Widget widget);

	bool delegate(GdkEventCrossing*, Widget)[] onEnterNotifyListeners;
	/**
	 * The ::enter-notify-event will be emitted when the pointer enters
	 * the widget's window.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_ENTER_NOTIFY_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnEnterNotify(bool delegate(GdkEventCrossing*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackEnterNotify(GtkWidget* widgetStruct, GdkEventCrossing* event, Widget widget);


	bool delegate(Event, Widget)[] onListeners;
	/**
	 * The GTK+ main loop will emit three signals for each GDK event delivered
	 * to a widget: one generic ::event signal, another, more specific,
	 * signal that matches the type of event delivered (e.g.
	 * "key-press-event") and finally a generic
	 * "event-after" signal.
	 */
	void addOn(bool delegate(Event, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBack(GtkWidget* widgetStruct, GdkEvent* event, Widget widget);

	void delegate(Event, Widget)[] onEventAfterListeners;
	/**
	 * After the emission of the "event" signal and (optionally)
	 * the second more specific signal, ::event-after will be emitted
	 * regardless of the previous two signals handlers return values.
	 */
	void addOnEventAfter(void delegate(Event, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackEventAfter(GtkWidget* widgetStruct, GdkEvent* event, Widget widget);

	bool delegate(GdkEventExpose*, Widget)[] onExposeListeners;
	/**
	 * The ::expose-event signal is emitted when an area of a previously
	 * obscured GdkWindow is made visible and needs to be redrawn.
	 * GTK_NO_WINDOW widgets will get a synthesized event from their parent
	 * widget.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_EXPOSURE_MASK mask.
	 */
	void addOnExpose(bool delegate(GdkEventExpose*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackExpose(GtkWidget* widgetStruct, GdkEventExpose* event, Widget widget);

	bool delegate(GtkDirectionType, Widget)[] onFocusListeners;
	/**
	 */
	void addOnFocus(bool delegate(GtkDirectionType, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackFocus(GtkWidget* widgetStruct, GtkDirectionType arg1, Widget widget);

	bool delegate(GdkEventFocus*, Widget)[] onFocusInListeners;
	/**
	 * The ::focus-in-event signal will be emitted when the keyboard focus
	 * enters the widget's window.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_FOCUS_CHANGE_MASK mask.
	 */
	void addOnFocusIn(bool delegate(GdkEventFocus*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackFocusIn(GtkWidget* widgetStruct, GdkEventFocus* event, Widget widget);

	bool delegate(GdkEventFocus*, Widget)[] onFocusOutListeners;
	/**
	 * The ::focus-out-event signal will be emitted when the keyboard focus
	 * leaves the widget's window.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_FOCUS_CHANGE_MASK mask.
	 */
	void addOnFocusOut(bool delegate(GdkEventFocus*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackFocusOut(GtkWidget* widgetStruct, GdkEventFocus* event, Widget widget);

	bool delegate(Event, Widget)[] onGrabBrokenListeners;
	/**
	 * Emitted when a pointer or keyboard grab on a window belonging
	 * to widget gets broken.
	 * On X11, this happens when the grab window becomes unviewable
	 * (i.e. it or one of its ancestors is unmapped), or if the same
	 * application grabs the pointer or keyboard again.
	 * Since 2.8
	 */
	void addOnGrabBroken(bool delegate(Event, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackGrabBroken(GtkWidget* widgetStruct, GdkEvent* event, Widget widget);

	void delegate(Widget)[] onGrabFocusListeners;
	/**
	 */
	void addOnGrabFocus(void delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackGrabFocus(GtkWidget* widgetStruct, Widget widget);

	void delegate(gboolean, Widget)[] onGrabNotifyListeners;
	/**
	 * The ::grab-notify signal is emitted when a widget becomes
	 * shadowed by a GTK+ grab (not a pointer or keyboard grab) on
	 * another widget, or when it becomes unshadowed due to a grab
	 * being removed.
	 * A widget is shadowed by a gtk_grab_add() when the topmost
	 * grab widget in the grab stack of its window group is not
	 * its ancestor.
	 */
	void addOnGrabNotify(void delegate(gboolean, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackGrabNotify(GtkWidget* widgetStruct, gboolean wasGrabbed, Widget widget);

	void delegate(Widget)[] onHideListeners;
	/**
	 */
	void addOnHide(void delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackHide(GtkWidget* widgetStruct, Widget widget);

	void delegate(Widget, Widget)[] onHierarchyChangedListeners;
	/**
	 * The ::hierarchy-changed signal is emitted when the
	 * anchored state of a widget changes. A widget is
	 * anchored when its toplevel
	 * ancestor is a GtkWindow. This signal is emitted when
	 * a widget changes from un-anchored to anchored or vice-versa.
	 */
	void addOnHierarchyChanged(void delegate(Widget, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackHierarchyChanged(GtkWidget* widgetStruct, GtkWidget* previousToplevel, Widget widget);

	bool delegate(GdkEventKey*, Widget)[] onKeyPressListeners;
	/**
	 * The ::key-press-event signal is emitted when a key is pressed.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_KEY_PRESS_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnKeyPress(bool delegate(GdkEventKey*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackKeyPress(GtkWidget* widgetStruct, GdkEventKey* event, Widget widget);


	bool delegate(GdkEventKey*, Widget)[] onKeyReleaseListeners;
	/**
	 * The ::key-release-event signal is emitted when a key is pressed.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_KEY_RELEASE_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnKeyRelease(bool delegate(GdkEventKey*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackKeyRelease(GtkWidget* widgetStruct, GdkEventKey* event, Widget widget);

	bool delegate(GtkDirectionType, Widget)[] onKeynavFailedListeners;
	/**
	 * Gets emitted if keyboard navigation fails.
	 * See gtk_widget_keynav_failed() for details.
	 * Since 2.12
	 */
	void addOnKeynavFailed(bool delegate(GtkDirectionType, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackKeynavFailed(GtkWidget* widgetStruct, GtkDirectionType direction, Widget widget);

	bool delegate(GdkEventCrossing*, Widget)[] onLeaveNotifyListeners;
	/**
	 * The ::leave-notify-event will be emitted when the pointer leaves
	 * the widget's window.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_LEAVE_NOTIFY_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnLeaveNotify(bool delegate(GdkEventCrossing*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackLeaveNotify(GtkWidget* widgetStruct, GdkEventCrossing* event, Widget widget);

	void delegate(Widget)[] onMapListeners;
	/**
	 */
	void addOnMap(void delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMap(GtkWidget* widgetStruct, Widget widget);

	bool delegate(Event, Widget)[] onMapEventListeners;
	/**
	 * The ::map-event signal will be emitted when the widget's window is
	 * mapped. A window is mapped when it becomes visible on the screen.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_STRUCTURE_MASK mask. GDK will enable this mask
	 * automatically for all new windows.
	 */
	void addOnMapEvent(bool delegate(Event, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackMapEvent(GtkWidget* widgetStruct, GdkEvent* event, Widget widget);

	bool delegate(gboolean, Widget)[] onMnemonicActivateListeners;
	/**
	 */
	void addOnMnemonicActivate(bool delegate(gboolean, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackMnemonicActivate(GtkWidget* widgetStruct, gboolean arg1, Widget widget);

	bool delegate(GdkEventMotion*, Widget)[] onMotionNotifyListeners;
	/**
	 * The ::motion-notify-event signal is emitted when the pointer moves
	 * over the widget's GdkWindow.
	 * To receive this signal, the GdkWindow associated to the widget
	 * needs to enable the GDK_POINTER_MOTION_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnMotionNotify(bool delegate(GdkEventMotion*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackMotionNotify(GtkWidget* widgetStruct, GdkEventMotion* event, Widget widget);

	void delegate(GtkDirectionType, Widget)[] onMoveFocusListeners;
	/**
	 */
	void addOnMoveFocus(void delegate(GtkDirectionType, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveFocus(GtkWidget* widgetStruct, GtkDirectionType arg1, Widget widget);

	bool delegate(GdkEventNoExpose*, Widget)[] onNoExposeListeners;
	/**
	 * The ::no-expose-event will be emitted when the widget's window is
	 * drawn as a copy of another GdkDrawable (with gdk_draw_drawable() or
	 * gdk_window_copy_area()) which was completely unobscured. If the source
	 * window was partially obscured GdkEventExpose events will be generated
	 * for those areas.
	 */
	void addOnNoExpose(bool delegate(GdkEventNoExpose*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackNoExpose(GtkWidget* widgetStruct, GdkEventNoExpose* event, Widget widget);

	void delegate(GtkObject*, Widget)[] onParentSetListeners;
	/**
	 * The ::parent-set signal is emitted when a new parent
	 * has been set on a widget.
	 */
	void addOnParentSet(void delegate(GtkObject*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackParentSet(GtkWidget* widgetStruct, GtkObject* oldParent, Widget widget);

	bool delegate(Widget)[] onPopupMenuListeners;
	/**
	 * This signal gets emitted whenever a widget should pop up a context
	 * menu. This usually happens through the standard key binding mechanism;
	 * by pressing a certain key while a widget is focused, the user can cause
	 * the widget to pop up a menu. For example, the GtkEntry widget creates
	 * a menu with clipboard commands. See the section called “Implement GtkWidget::popup_menu”
	 * for an example of how to use this signal.
	 */
	void addOnPopupMenu(bool delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackPopupMenu(GtkWidget* widgetStruct, Widget widget);

	bool delegate(GdkEventProperty*, Widget)[] onPropertyNotifyListeners;
	/**
	 * The ::property-notify-event signal will be emitted when a property on
	 * the widget's window has been changed or deleted.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_PROPERTY_CHANGE_MASK mask.
	 */
	void addOnPropertyNotify(bool delegate(GdkEventProperty*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackPropertyNotify(GtkWidget* widgetStruct, GdkEventProperty* event, Widget widget);

	bool delegate(GdkEventProximity*, Widget)[] onProximityInListeners;
	/**
	 * To receive this signal the GdkWindow associated to the widget needs
	 * to enable the GDK_PROXIMITY_IN_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnProximityIn(bool delegate(GdkEventProximity*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackProximityIn(GtkWidget* widgetStruct, GdkEventProximity* event, Widget widget);

	bool delegate(GdkEventProximity*, Widget)[] onProximityOutListeners;
	/**
	 * To receive this signal the GdkWindow associated to the widget needs
	 * to enable the GDK_PROXIMITY_OUT_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnProximityOut(bool delegate(GdkEventProximity*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackProximityOut(GtkWidget* widgetStruct, GdkEventProximity* event, Widget widget);

	bool delegate(gint, gint, gboolean, GtkTooltip*, Widget)[] onQueryTooltipListeners;
	/**
	 * Emitted when "has-tooltip" is TRUE and the "gtk-tooltip-timeout"
	 * has expired with the cursor hovering "above" widget; or emitted when widget got
	 * focus in keyboard mode.
	 * Using the given coordinates, the signal handler should determine
	 * whether a tooltip should be shown for widget. If this is the case
	 * TRUE should be returned, FALSE otherwise. Note that if
	 * keyboard_mode is TRUE, the values of x and y are undefined and
	 * should not be used.
	 * The signal handler is free to manipulate tooltip with the therefore
	 * destined function calls.
	 * Since 2.12
	 */
	void addOnQueryTooltip(bool delegate(gint, gint, gboolean, GtkTooltip*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackQueryTooltip(GtkWidget* widgetStruct, gint x, gint y, gboolean keyboardMode, GtkTooltip* tooltip, Widget widget);

	void delegate(Widget)[] onRealizeListeners;
	/**
	 */
	void addOnRealize(void delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackRealize(GtkWidget* widgetStruct, Widget widget);

	void delegate(Screen, Widget)[] onScreenChangedListeners;
	/**
	 * The ::screen-changed signal gets emitted when the
	 * screen of a widget has changed.
	 */
	void addOnScreenChanged(void delegate(Screen, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackScreenChanged(GtkWidget* widgetStruct, GdkScreen* previousScreen, Widget widget);

	bool delegate(GdkEventScroll*, Widget)[] onScrollListeners;
	/**
	 * The ::scroll-event signal is emitted when a button in the 4 to 7
	 * range is pressed. Wheel mice are usually configured to generate
	 * button press events for buttons 4 and 5 when the wheel is turned.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_BUTTON_PRESS_MASK mask.
	 * This signal will be sent to the grab widget if there is one.
	 */
	void addOnScroll(bool delegate(GdkEventScroll*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackScroll(GtkWidget* widgetStruct, GdkEventScroll* event, Widget widget);

	bool delegate(GdkEventSelection*, Widget)[] onSelectionClearListeners;
	/**
	 * The ::selection-clear-event signal will be emitted when the
	 * the widget's window has lost ownership of a selection.
	 */
	void addOnSelectionClear(bool delegate(GdkEventSelection*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackSelectionClear(GtkWidget* widgetStruct, GdkEventSelection* event, Widget widget);

	void delegate(GtkSelectionData*, guint, guint, Widget)[] onSelectionGetListeners;
	/**
	 */
	void addOnSelectionGet(void delegate(GtkSelectionData*, guint, guint, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelectionGet(GtkWidget* widgetStruct, GtkSelectionData* data, guint info, guint time, Widget widget);

	bool delegate(GdkEventSelection*, Widget)[] onSelectionNotifyListeners;
	/**
	 */
	void addOnSelectionNotify(bool delegate(GdkEventSelection*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackSelectionNotify(GtkWidget* widgetStruct, GdkEventSelection* event, Widget widget);

	void delegate(GtkSelectionData*, guint, Widget)[] onSelectionReceivedListeners;
	/**
	 */
	void addOnSelectionReceived(void delegate(GtkSelectionData*, guint, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelectionReceived(GtkWidget* widgetStruct, GtkSelectionData* data, guint time, Widget widget);

	bool delegate(GdkEventSelection*, Widget)[] onSelectionRequestListeners;
	/**
	 * The ::selection-request-event signal will be emitted when
	 * another client requests ownership of the selection owned by
	 * the widget's window.
	 */
	void addOnSelectionRequest(bool delegate(GdkEventSelection*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackSelectionRequest(GtkWidget* widgetStruct, GdkEventSelection* event, Widget widget);

	void delegate(Widget)[] onShowListeners;
	/**
	 */
	void addOnShow(void delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackShow(GtkWidget* widgetStruct, Widget widget);

	bool delegate(GtkWidgetHelpType, Widget)[] onShowHelpListeners;
	/**
	 */
	void addOnShowHelp(bool delegate(GtkWidgetHelpType, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackShowHelp(GtkWidget* widgetStruct, GtkWidgetHelpType arg1, Widget widget);

	void delegate(GtkAllocation*, Widget)[] onSizeAllocateListeners;
	/**
	 */
	void addOnSizeAllocate(void delegate(GtkAllocation*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSizeAllocate(GtkWidget* widgetStruct, GtkAllocation* allocation, Widget widget);

	void delegate(GtkRequisition*, Widget)[] onSizeRequestListeners;
	/**
	 */
	void addOnSizeRequest(void delegate(GtkRequisition*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSizeRequest(GtkWidget* widgetStruct, GtkRequisition* requisition, Widget widget);

	void delegate(GtkStateType, Widget)[] onStateChangedListeners;
	/**
	 */
	void addOnStateChanged(void delegate(GtkStateType, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackStateChanged(GtkWidget* widgetStruct, GtkStateType state, Widget widget);

	void delegate(Style, Widget)[] onStyleSetListeners;
	/**
	 * The ::style-set signal is emitted when a new style has been set
	 * on a widget. Note that style-modifying functions like
	 * gtk_widget_modify_base() also cause this signal to be emitted.
	 */
	void addOnStyleSet(void delegate(Style, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackStyleSet(GtkWidget* widgetStruct, GtkStyle* previousStyle, Widget widget);

	void delegate(Widget)[] onUnmapListeners;
	/**
	 */
	void addOnUnmap(void delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackUnmap(GtkWidget* widgetStruct, Widget widget);

	bool delegate(Event, Widget)[] onUnmapEventListeners;
	/**
	 * The ::unmap-event signal will be emitted when the widget's window is
	 * unmapped. A window is unmapped when it becomes invisible on the screen.
	 * To receive this signal, the GdkWindow associated to the widget needs
	 * to enable the GDK_STRUCTURE_MASK mask. GDK will enable this mask
	 * automatically for all new windows.
	 */
	void addOnUnmapEvent(bool delegate(Event, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackUnmapEvent(GtkWidget* widgetStruct, GdkEvent* event, Widget widget);

	void delegate(Widget)[] onUnrealizeListeners;
	/**
	 */
	void addOnUnrealize(void delegate(Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackUnrealize(GtkWidget* widgetStruct, Widget widget);

	bool delegate(GdkEventVisibility*, Widget)[] onVisibilityNotifyListeners;
	/**
	 * The ::visibility-notify-event will be emitted when the widget's window
	 * is obscured or unobscured.
	 * To receive this signal the GdkWindow associated to the widget needs
	 * to enable the GDK_VISIBILITY_NOTIFY_MASK mask.
	 */
	void addOnVisibilityNotify(bool delegate(GdkEventVisibility*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackVisibilityNotify(GtkWidget* widgetStruct, GdkEventVisibility* event, Widget widget);

	bool delegate(GdkEventWindowState*, Widget)[] onWindowStateListeners;
	/**
	 * The ::window-state-event will be emitted when the state of the
	 * toplevel window associated to the widget changes.
	 * To receive this signal the GdkWindow associated to the widget
	 * needs to enable the GDK_STRUCTURE_MASK mask. GDK will enable
	 * this mask automatically for all new windows.
	 */
	void addOnWindowState(bool delegate(GdkEventWindowState*, Widget) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackWindowState(GtkWidget* widgetStruct, GdkEventWindowState* event, Widget widget);


	/**
	 * Warning
	 * gtk_widget_unref has been deprecated since version 2.12 and should not be used in newly-written code. Use g_object_unref() instead.
	 * Inverse of gtk_widget_ref(). Equivalent to g_object_unref().
	 */
	public override void unref();

	/**
	 * Destroys a widget. Equivalent to gtk_object_destroy(), except that
	 * you don't have to cast the widget to GtkObject. When a widget is
	 * destroyed, it will break any references it holds to other objects.
	 * If the widget is inside a container, the widget will be removed
	 * from the container. If the widget is a toplevel (derived from
	 * GtkWindow), it will be removed from the list of toplevels, and the
	 * reference GTK+ holds to it will be removed. Removing a
	 * widget from its container or the list of toplevels results in the
	 * widget being finalized, unless you've added additional references
	 * to the widget with g_object_ref().
	 * In most cases, only toplevel widgets (windows) require explicit
	 * destruction, because when you destroy a toplevel its children will
	 * be destroyed as well.
	 */
	public override void destroy();

	/**
	 * This function sets *widget_pointer to NULL if widget_pointer !=
	 * NULL. It's intended to be used as a callback connected to the
	 * "destroy" signal of a widget. You connect gtk_widget_destroyed()
	 * as a signal handler, and pass the address of your widget variable
	 * as user data. Then when the widget is destroyed, the variable will
	 * be set to NULL. Useful for example to avoid multiple copies
	 * of the same dialog.
	 * Params:
	 * widget =  a GtkWidget
	 * widgetPointer =  address of a variable that contains widget
	 */
	public void destroyed(inout Widget widgetPointer);

	/**
	 * This function is only for use in widget implementations.
	 * Should be called by implementations of the remove method
	 * on GtkContainer, to dissociate a child from the container.
	 */
	public void unparent();

	/**
	 * Flags a widget to be displayed. Any widget that isn't shown will
	 * not appear on the screen. If you want to show all the widgets in a
	 * container, it's easier to call gtk_widget_show_all() on the
	 * container, instead of individually showing the widgets.
	 * Remember that you have to show the containers containing a widget,
	 * in addition to the widget itself, before it will appear onscreen.
	 * When a toplevel container is shown, it is immediately realized and
	 * mapped; other shown widgets are realized and mapped when their
	 * toplevel container is realized and mapped.
	 */
	public void show();

	/**
	 * Shows a widget. If the widget is an unmapped toplevel widget
	 * (i.e. a GtkWindow that has not yet been shown), enter the main
	 * loop and wait for the window to actually be mapped. Be careful;
	 * because the main loop is running, anything can happen during
	 * this function.
	 */
	public void showNow();

	/**
	 * Reverses the effects of gtk_widget_show(), causing the widget to be
	 * hidden (invisible to the user).
	 */
	public void hide();

	/**
	 * Recursively shows a widget, and any child widgets (if the widget is
	 * a container).
	 */
	public void showAll();

	/**
	 * Recursively hides a widget and any child widgets.
	 */
	public void hideAll();

	/**
	 * This function is only for use in widget implementations. Causes
	 * a widget to be mapped if it isn't already.
	 */
	public void map();

	/**
	 * This function is only for use in widget implementations. Causes
	 * a widget to be unmapped if it's currently mapped.
	 */
	public void unmap();

	/**
	 * Creates the GDK (windowing system) resources associated with a
	 * widget. For example, widget->window will be created when a widget
	 * is realized. Normally realization happens implicitly; if you show
	 * a widget and all its parent containers, then the widget will be
	 * realized and mapped automatically.
	 * Realizing a widget requires all
	 * the widget's parent widgets to be realized; calling
	 * gtk_widget_realize() realizes the widget's parents in addition to
	 * widget itself. If a widget is not yet inside a toplevel window
	 * when you realize it, bad things will happen.
	 * This function is primarily used in widget implementations, and
	 * isn't very useful otherwise. Many times when you think you might
	 * need it, a better approach is to connect to a signal that will be
	 * called after the widget is realized automatically, such as
	 * GtkWidget::expose-event. Or simply g_signal_connect() to the
	 * GtkWidget::realize signal.
	 */
	public void realize();

	/**
	 * This function is only useful in widget implementations.
	 * Causes a widget to be unrealized (frees all GDK resources
	 * associated with the widget, such as widget->window).
	 */
	public void unrealize();

	/**
	 * Equivalent to calling gtk_widget_queue_draw_area() for the
	 * entire area of a widget.
	 */
	public void queueDraw();

	/**
	 * This function is only for use in widget implementations.
	 * Flags a widget to have its size renegotiated; should
	 * be called when a widget for some reason has a new size request.
	 * For example, when you change the text in a GtkLabel, GtkLabel
	 * queues a resize to ensure there's enough space for the new text.
	 */
	public void queueResize();

	/**
	 * This function works like gtk_widget_queue_resize(),
	 * except that the widget is not invalidated.
	 * Since 2.4
	 */
	public void queueResizeNoRedraw();

	/**
	 * Warning
	 * gtk_widget_draw is deprecated and should not be used in newly-written code.
	 * In GTK+ 1.2, this function would immediately render the
	 * region area of a widget, by invoking the virtual draw method of a
	 * widget. In GTK+ 2.0, the draw method is gone, and instead
	 * gtk_widget_draw() simply invalidates the specified region of the
	 * widget, then updates the invalid region of the widget immediately.
	 * Usually you don't want to update the region immediately for
	 * performance reasons, so in general gtk_widget_queue_draw_area() is
	 * a better choice if you want to draw a region of a widget.
	 * Params:
	 * area =  area to draw
	 */
	public void draw(Rectangle area);

	/**
	 * This function is typically used when implementing a GtkContainer
	 * subclass. Obtains the preferred size of a widget. The container
	 * uses this information to arrange its child widgets and decide what
	 * size allocations to give them with gtk_widget_size_allocate().
	 * You can also call this function from an application, with some
	 * caveats. Most notably, getting a size request requires the widget
	 * to be associated with a screen, because font information may be
	 * needed. Multihead-aware applications should keep this in mind.
	 * Also remember that the size request is not necessarily the size
	 * a widget will actually be allocated.
	 * See also gtk_widget_get_child_requisition().
	 * Params:
	 * requisition =  a GtkRequisition to be filled in
	 */
	public void sizeRequest(out GtkRequisition requisition);

	/**
	 * This function is only for use in widget implementations. Obtains
	 * widget->requisition, unless someone has forced a particular
	 * geometry on the widget (e.g. with gtk_widget_set_size_request()),
	 * in which case it returns that geometry instead of the widget's
	 * requisition.
	 * This function differs from gtk_widget_size_request() in that
	 * it retrieves the last size request value from widget->requisition,
	 * while gtk_widget_size_request() actually calls the "size_request" method
	 * on widget to compute the size request and fill in widget->requisition,
	 * and only then returns widget->requisition.
	 * Because this function does not call the "size_request" method, it
	 * can only be used when you know that widget->requisition is
	 * up-to-date, that is, gtk_widget_size_request() has been called
	 * since the last time a resize was queued. In general, only container
	 * implementations have this information; applications should use
	 * gtk_widget_size_request().
	 * Params:
	 * requisition =  a GtkRequisition to be filled in
	 */
	public void getChildRequisition(out GtkRequisition requisition);
	/**
	 * This function is only used by GtkContainer subclasses, to assign a size
	 * and position to their child widgets.
	 * Params:
	 * allocation =  position and size to be allocated to widget
	 */
	public void sizeAllocate(GtkAllocation* allocation);

	/**
	 * Installs an accelerator for this widget in accel_group that causes
	 * accel_signal to be emitted if the accelerator is activated.
	 * The accel_group needs to be added to the widget's toplevel via
	 * gtk_window_add_accel_group(), and the signal must be of type G_RUN_ACTION.
	 * Accelerators added through this function are not user changeable during
	 * runtime. If you want to support accelerators that can be changed by the
	 * user, use gtk_accel_map_add_entry() and gtk_widget_set_accel_path() or
	 * gtk_menu_item_set_accel_path() instead.
	 * Params:
	 * accelSignal =  widget signal to emit on accelerator activation
	 * accelGroup =  accel group for this widget, added to its toplevel
	 * accelKey =  GDK keyval of the accelerator
	 * accelMods =  modifier key combination of the accelerator
	 * accelFlags =  flag accelerators, e.g. GTK_ACCEL_VISIBLE
	 */
	public void addAccelerator(string accelSignal, AccelGroup accelGroup, uint accelKey, GdkModifierType accelMods, GtkAccelFlags accelFlags);

	/**
	 * Removes an accelerator from widget, previously installed with
	 * gtk_widget_add_accelerator().
	 * Params:
	 * accelGroup =  accel group for this widget
	 * accelKey =  GDK keyval of the accelerator
	 * accelMods =  modifier key combination of the accelerator
	 * Returns: whether an accelerator was installed and could be removed
	 */
	public int removeAccelerator(AccelGroup accelGroup, uint accelKey, GdkModifierType accelMods);

	/**
	 * Given an accelerator group, accel_group, and an accelerator path,
	 * accel_path, sets up an accelerator in accel_group so whenever the
	 * key binding that is defined for accel_path is pressed, widget
	 * will be activated. This removes any accelerators (for any
	 * accelerator group) installed by previous calls to
	 * gtk_widget_set_accel_path(). Associating accelerators with
	 * paths allows them to be modified by the user and the modifications
	 * to be saved for future use. (See gtk_accel_map_save().)
	 * This function is a low level function that would most likely
	 * be used by a menu creation system like GtkUIManager. If you
	 * use GtkUIManager, setting up accelerator paths will be done
	 * automatically.
	 * Even when you you aren't using GtkUIManager, if you only want to
	 * set up accelerators on menu items gtk_menu_item_set_accel_path()
	 * provides a somewhat more convenient interface.
	 * Note that accel_path string will be stored in a GQuark. Therefore, if you
	 * pass a static string, you can save some memory by interning it first with
	 * g_intern_static_string().
	 * Params:
	 * accelPath =  path used to look up the accelerator
	 * accelGroup =  a GtkAccelGroup.
	 */
	public void setAccelPath(string accelPath, AccelGroup accelGroup);

	/**
	 * Lists the closures used by widget for accelerator group connections
	 * with gtk_accel_group_connect_by_path() or gtk_accel_group_connect().
	 * The closures can be used to monitor accelerator changes on widget,
	 * by connecting to the GtkAccelGroup::accel-changed signal of the
	 * GtkAccelGroup of a closure which can be found out with
	 * gtk_accel_group_from_accel_closure().
	 * Returns: a newly allocated GList of closures
	 */
	public ListG listAccelClosures();

	/**
	 * Determines whether an accelerator that activates the signal
	 * identified by signal_id can currently be activated.
	 * This is done by emitting the "can-activate-accel"
	 * signal on widget; if the signal isn't overridden by a
	 * handler or in a derived widget, then the default check is
	 * that the widget must be sensitive, and the widget and all
	 * its ancestors mapped.
	 * Since 2.4
	 * Params:
	 * signalId =  the ID of a signal installed on widget
	 * Returns: TRUE if the accelerator can be activated.
	 */
	public int canActivateAccel(uint signalId);

	/**
	 * Rarely-used function. This function is used to emit
	 * the event signals on a widget (those signals should never
	 * be emitted without using this function to do so).
	 * If you want to synthesize an event though, don't use this function;
	 * instead, use gtk_main_do_event() so the event will behave as if
	 * it were in the event queue. Don't synthesize expose events; instead,
	 * use gdk_window_invalidate_rect() to invalidate a region of the
	 * window.
	 * Params:
	 * event =  a GdkEvent
	 * Returns: return from the event signal emission (TRUE if  the event was handled)
	 */
	public int event(Event event);

	/**
	 * For widgets that can be "activated" (buttons, menu items, etc.)
	 * this function activates them. Activation is what happens when you
	 * press Enter on a widget during key navigation. If widget isn't
	 * activatable, the function returns FALSE.
	 * Returns: TRUE if the widget was activatable
	 */
	public int activate();

	/**
	 * Moves a widget from one GtkContainer to another, handling reference
	 * count issues to avoid destroying the widget.
	 * Params:
	 * newParent =  a GtkContainer to move the widget into
	 */
	public void reparent(Widget newParent);

	/**
	 * Computes the intersection of a widget's area and area, storing
	 * the intersection in intersection, and returns TRUE if there was
	 * an intersection. intersection may be NULL if you're only
	 * interested in whether there was an intersection.
	 * Params:
	 * area =  a rectangle
	 * intersection =  rectangle to store intersection of widget and area
	 * Returns: TRUE if there was an intersection
	 */
	public int intersect(Rectangle area, Rectangle intersection);

	/**
	 * Determines if the widget is the focus widget within its
	 * toplevel. (This does not mean that the HAS_FOCUS flag is
	 * necessarily set; HAS_FOCUS will only be set if the
	 * toplevel widget additionally has the global input focus.)
	 * Returns: TRUE if the widget is the focus widget.
	 */
	public int isFocus()
	{
		// gboolean gtk_widget_is_focus (GtkWidget *widget);
		return gtk_widget_is_focus(gtkWidget);
	}

	/**
	 * Causes widget to have the keyboard focus for the GtkWindow it's
	 * inside. widget must be a focusable widget, such as a GtkEntry;
	 * something like GtkFrame won't work.
	 * More precisely, it must have the GTK_CAN_FOCUS flag set. Use
	 * gtk_widget_set_can_focus() to modify that flag.
	 */
	public void grabFocus();

	/**
	 * Causes widget to become the default widget. widget must have the
	 * GTK_CAN_DEFAULT flag set; typically you have to set this flag
	 * yourself by calling gtk_widget_set_can_default (widget,
	 * TRUE). The default widget is activated when
	 * the user presses Enter in a window. Default widgets must be
	 * activatable, that is, gtk_widget_activate() should affect them.
	 */
	public void grabDefault();

	/**
	 * Widgets can be named, which allows you to refer to them from a
	 * gtkrc file. You can apply a style to widgets with a particular name
	 * in the gtkrc file. See the documentation for gtkrc files (on the
	 * same page as the docs for GtkRcStyle).
	 * Note that widget names are separated by periods in paths (see
	 * gtk_widget_path()), so names with embedded periods may cause confusion.
	 * Params:
	 * name =  name for the widget
	 */
	public void setName(string name);

	/**
	 * Retrieves the name of a widget. See gtk_widget_set_name() for the
	 * significance of widget names.
	 * Returns: name of the widget. This string is owned by GTK+ andshould not be modified or freed
	 */
	public string getName();

	/**
	 * This function is for use in widget implementations. Sets the state
	 * of a widget (insensitive, prelighted, etc.) Usually you should set
	 * the state using wrapper functions such as gtk_widget_set_sensitive().
	 * Params:
	 * state =  new state for widget
	 */
	public void setState(GtkStateType state);

	/**
	 * Sets the sensitivity of a widget. A widget is sensitive if the user
	 * can interact with it. Insensitive widgets are "grayed out" and the
	 * user can't interact with them. Insensitive widgets are known as
	 * "inactive", "disabled", or "ghosted" in some other toolkits.
	 * Params:
	 * sensitive =  TRUE to make the widget sensitive
	 */
	public void setSensitive(int sensitive);

	/**
	 * This function is useful only when implementing subclasses of
	 * GtkContainer.
	 * Sets the container as the parent of widget, and takes care of
	 * some details such as updating the state and style of the child
	 * to reflect its new location. The opposite function is
	 * gtk_widget_unparent().
	 * Params:
	 * parent =  parent container
	 */
	public void setParent(Widget parent);

	/**
	 * Sets a non default parent window for widget.
	 * Params:
	 * parentWindow =  the new parent window.
	 */
	public void setParentWindow(Window parentWindow);

	/**
	 * Gets widget's parent window.
	 * Returns: the parent window of widget.
	 */
	public Window getParentWindow();

	/**
	 * Warning
	 * gtk_widget_set_uposition is deprecated and should not be used in newly-written code.
	 * Sets the position of a widget. The funny "u" in the name comes from
	 * the "user position" hint specified by the X Window System, and
	 * exists for legacy reasons. This function doesn't work if a widget
	 * is inside a container; it's only really useful on GtkWindow.
	 * Don't use this function to center dialogs over the main application
	 * window; most window managers will do the centering on your behalf
	 * if you call gtk_window_set_transient_for(), and it's really not
	 * possible to get the centering to work correctly in all cases from
	 * application code. But if you insist, use gtk_window_set_position()
	 * to set GTK_WIN_POS_CENTER_ON_PARENT, don't do the centering
	 * manually.
	 * Note that although x and y can be individually unset, the position
	 * is not honoured unless both x and y are set.
	 * Params:
	 * x =  x position; -1 to unset x; -2 to leave x unchanged
	 * y =  y position; -1 to unset y; -2 to leave y unchanged
	 */
	public void setUposition(int x, int y);

	/**
	 * Warning
	 * gtk_widget_set_usize has been deprecated since version 2.2 and should not be used in newly-written code. Use gtk_widget_set_size_request() instead.
	 * Sets the minimum size of a widget; that is, the widget's size
	 * request will be width by height. You can use this function to
	 * force a widget to be either larger or smaller than it is. The
	 * strange "usize" name dates from the early days of GTK+, and derives
	 * from X Window System terminology. In many cases,
	 * gtk_window_set_default_size() is a better choice for toplevel
	 * windows than this function; setting the default size will still
	 * allow users to shrink the window. Setting the usize will force them
	 * to leave the window at least as large as the usize. When dealing
	 * with window sizes, gtk_window_set_geometry_hints() can be a useful
	 * function as well.
	 * Note the inherent danger of setting any fixed size - themes,
	 * translations into other languages, different fonts, and user action
	 * can all change the appropriate size for a given widget. So, it's
	 * basically impossible to hardcode a size that will always be
	 * correct.
	 * Params:
	 * width =  minimum width, or -1 to unset
	 * height =  minimum height, or -1 to unset
	 */
	public void setUsize(int width, int height);

	/**
	 * Sets the event mask (see GdkEventMask) for a widget. The event
	 * mask determines which events a widget will receive. Keep in mind
	 * that different widgets have different default event masks, and by
	 * changing the event mask you may disrupt a widget's functionality,
	 * so be careful. This function must be called while a widget is
	 * unrealized. Consider gtk_widget_add_events() for widgets that are
	 * already realized, or if you want to preserve the existing event
	 * mask. This function can't be used with GTK_NO_WINDOW widgets;
	 * to get events on those widgets, place them inside a GtkEventBox
	 * and receive events on the event box.
	 * Params:
	 * events =  event mask
	 */
	public void setEvents(int events);

	/**
	 * Adds the events in the bitfield events to the event mask for
	 * widget. See gtk_widget_set_events() for details.
	 * Params:
	 * events =  an event mask, see GdkEventMask
	 */
	public void addEvents(int events);

	/**
	 * Sets the extension events mask to mode. See GdkExtensionMode
	 * and gdk_input_set_extension_events().
	 * Params:
	 * mode =  bitfield of extension events to receive
	 */
	public void setExtensionEvents(GdkExtensionMode mode);

	/**
	 * Retrieves the extension events the widget will receive; see
	 * gdk_input_set_extension_events().
	 * Returns: extension events for widget
	 */
	public GdkExtensionMode getExtensionEvents();

	/**
	 * This function returns the topmost widget in the container hierarchy
	 * widget is a part of. If widget has no parent widgets, it will be
	 * returned as the topmost widget. No reference will be added to the
	 * returned widget; it should not be unreferenced.
	 * Note the difference in behavior vs. gtk_widget_get_ancestor();
	 * gtk_widget_get_ancestor (widget, GTK_TYPE_WINDOW)
	 * would return
	 * NULL if widget wasn't inside a toplevel window, and if the
	 * window was inside a GtkWindow-derived widget which was in turn
	 * inside the toplevel GtkWindow. While the second case may
	 * seem unlikely, it actually happens when a GtkPlug is embedded
	 * inside a GtkSocket within the same application.
	 * To reliably find the toplevel GtkWindow, use
	 * gtk_widget_get_toplevel() and check if the TOPLEVEL flags
	 * is set on the result.
	 *  GtkWidget *toplevel = gtk_widget_get_toplevel (widget);
	 *  if (GTK_WIDGET_TOPLEVEL (toplevel))
	 *  {
		 *  /+* Perform action on toplevel. +/
	 *  }
	 * Returns: the topmost ancestor of widget, or widget itself  if there's no ancestor.
	 */
	public Widget getToplevel();

	/**
	 * Gets the first ancestor of widget with type widget_type. For example,
	 * gtk_widget_get_ancestor (widget, GTK_TYPE_BOX) gets
	 * the first GtkBox that's an ancestor of widget. No reference will be
	 * added to the returned widget; it should not be unreferenced. See note
	 * about checking for a toplevel GtkWindow in the docs for
	 * gtk_widget_get_toplevel().
	 * Note that unlike gtk_widget_is_ancestor(), gtk_widget_get_ancestor()
	 * considers widget to be an ancestor of itself.
	 * Params:
	 * widget =  a GtkWidget
	 * widgetType =  ancestor type
	 * Returns: the ancestor widget, or NULL if not found
	 */
	public Widget getAncestor(GType widgetType);

	/**
	 * Gets the colormap that will be used to render widget. No reference will
	 * be added to the returned colormap; it should not be unreferenced.
	 * Returns: the colormap used by widget
	 */
	public Colormap getColormap();
	/**
	 * Sets the colormap for the widget to the given value. Widget must not
	 * have been previously realized. This probably should only be used
	 * from an init() function (i.e. from the constructor
	 * for the widget).
	 * Params:
	 * colormap =  a colormap
	 */
	public void setColormap(Colormap colormap);

	/**
	 * Gets the visual that will be used to render widget.
	 * Returns: the visual for widget
	 */
	public Visual getVisual();

	/**
	 * Returns the event mask for the widget (a bitfield containing flags
	 * from the GdkEventMask enumeration). These are the events that the widget
	 * will receive.
	 * Returns: event mask for widget
	 */
	public int getEvents();
	/**
	 * Obtains the location of the mouse pointer in widget coordinates.
	 * Widget coordinates are a bit odd; for historical reasons, they are
	 * defined as widget->window coordinates for widgets that are not
	 * GTK_NO_WINDOW widgets, and are relative to widget->allocation.x,
	 * widget->allocation.y for widgets that are GTK_NO_WINDOW widgets.
	 * Params:
	 * x =  return location for the X coordinate, or NULL
	 * y =  return location for the Y coordinate, or NULL
	 */
	public void getPointer(out int x, out int y);

	/**
	 * Determines whether widget is somewhere inside ancestor, possibly with
	 * intermediate containers.
	 * Params:
	 * ancestor =  another GtkWidget
	 * Returns: TRUE if ancestor contains widget as a child,  grandchild, great grandchild, etc.
	 */
	public int isAncestor(Widget ancestor);

	/**
	 * Translate coordinates relative to src_widget's allocation to coordinates
	 * relative to dest_widget's allocations. In order to perform this
	 * operation, both widgets must be realized, and must share a common
	 * toplevel.
	 * Params:
	 * destWidget =  a GtkWidget
	 * srcX =  X position relative to src_widget
	 * srcY =  Y position relative to src_widget
	 * destX =  location to store X position relative to dest_widget
	 * destY =  location to store Y position relative to dest_widget
	 * Returns: FALSE if either widget was not realized, or there was no common ancestor. In this case, nothing is stored in *dest_x and *dest_y. Otherwise TRUE.
	 */
	public int translateCoordinates(Widget destWidget, int srcX, int srcY, out int destX, out int destY);

	/**
	 * Utility function; intended to be connected to the "delete-event"
	 * signal on a GtkWindow. The function calls gtk_widget_hide() on its
	 * argument, then returns TRUE. If connected to ::delete-event, the
	 * result is that clicking the close button for a window (on the
	 * window frame, top right corner usually) will hide but not destroy
	 * the window. By default, GTK+ destroys windows when ::delete-event
	 * is received.
	 * Returns: TRUE
	 */
	public int hideOnDelete();

	/**
	 * Sets the GtkStyle for a widget (widget->style). You probably don't
	 * want to use this function; it interacts badly with themes, because
	 * themes work by replacing the GtkStyle. Instead, use
	 * gtk_widget_modify_style().
	 * Params:
	 * style =  a GtkStyle, or NULL to remove the effect of a previous
	 *  gtk_widget_set_style() and go back to the default style
	 */
	public void setStyle(Style style);

	/**
	 * Ensures that widget has a style (widget->style). Not a very useful
	 * function; most of the time, if you want the style, the widget is
	 * realized, and realized widgets are guaranteed to have a style
	 * already.
	 */
	public void ensureStyle();

	/**
	 * Simply an accessor function that returns widget->style.
	 * Returns: the widget's GtkStyle
	 */
	public Style getStyle();

	/**
	 * Reset the styles of widget and all descendents, so when
	 * they are looked up again, they get the correct values
	 * for the currently loaded RC file settings.
	 * This function is not useful for applications.
	 */
	public void resetRcStyles();

	/**
	 * Pushes cmap onto a global stack of colormaps; the topmost
	 * colormap on the stack will be used to create all widgets.
	 * Remove cmap with gtk_widget_pop_colormap(). There's little
	 * reason to use this function.
	 * Params:
	 * cmap =  a GdkColormap
	 */
	public static void pushColormap(Colormap cmap);

	/**
	 * Removes a colormap pushed with gtk_widget_push_colormap().
	 */
	public static void popColormap();

	/**
	 * Sets the default colormap to use when creating widgets.
	 * gtk_widget_push_colormap() is a better function to use if
	 * you only want to affect a few widgets, rather than all widgets.
	 * Params:
	 * colormap =  a GdkColormap
	 */
	public static void setDefaultColormap(Colormap colormap);

	/**
	 * Returns the default style used by all widgets initially.
	 * Returns: the default style. This GtkStyle object is owned  by GTK+ and should not be modified or freed.
	 */
	public static Style getDefaultStyle();

	/**
	 * Obtains the default colormap used to create widgets.
	 * Returns: default widget colormap
	 */
	public static Colormap getDefaultColormap();

	/**
	 * Obtains the visual of the default colormap. Not really useful;
	 * used to be useful before gdk_colormap_get_visual() existed.
	 * Returns: visual of the default colormap
	 */
	public static Visual getDefaultVisual();

	/**
	 * Sets the reading direction on a particular widget. This direction
	 * controls the primary direction for widgets containing text,
	 * and also the direction in which the children of a container are
	 * packed. The ability to set the direction is present in order
	 * so that correct localization into languages with right-to-left
	 * reading directions can be done. Generally, applications will
	 * let the default reading direction present, except for containers
	 * where the containers are arranged in an order that is explicitely
	 * visual rather than logical (such as buttons for text justification).
	 * If the direction is set to GTK_TEXT_DIR_NONE, then the value
	 * set by gtk_widget_set_default_direction() will be used.
	 * Params:
	 * dir =  the new direction
	 */
	public void setDirection(GtkTextDirection dir);
	/**
	 * Gets the reading direction for a particular widget. See
	 * gtk_widget_set_direction().
	 * Returns: the reading direction for the widget.
	 */
	public GtkTextDirection getDirection();

	/**
	 * Sets the default reading direction for widgets where the
	 * direction has not been explicitly set by gtk_widget_set_direction().
	 * Params:
	 * dir =  the new default direction. This cannot be
	 *  GTK_TEXT_DIR_NONE.
	 */
	public static void setDefaultDirection(GtkTextDirection dir);

	/**
	 * Obtains the current default reading direction. See
	 * gtk_widget_set_default_direction().
	 * Returns: the current default direction.
	 */
	public static GtkTextDirection getDefaultDirection();

	/**
	 * Sets a shape for this widget's GDK window. This allows for
	 * transparent windows etc., see gdk_window_shape_combine_mask()
	 * for more information.
	 * Params:
	 * shapeMask =  shape to be added, or NULL to remove an existing shape
	 * offsetX =  X position of shape mask with respect to window
	 * offsetY =  Y position of shape mask with respect to window
	 */
	public void shapeCombineMask(Bitmap shapeMask, int offsetX, int offsetY);

	/**
	 * Sets an input shape for this widget's GDK window. This allows for
	 * windows which react to mouse click in a nonrectangular region, see
	 * gdk_window_input_shape_combine_mask() for more information.
	 * Since 2.10
	 * Params:
	 * shapeMask =  shape to be added, or NULL to remove an existing shape
	 * offsetX =  X position of shape mask with respect to window
	 * offsetY =  Y position of shape mask with respect to window
	 */
	public void inputShapeCombineMask(Bitmap shapeMask, int offsetX, int offsetY);
	/**
	 * Obtains the full path to widget. The path is simply the name of a
	 * widget and all its parents in the container hierarchy, separated by
	 * periods. The name of a widget comes from
	 * gtk_widget_get_name(). Paths are used to apply styles to a widget
	 * in gtkrc configuration files. Widget names are the type of the
	 * widget by default (e.g. "GtkButton") or can be set to an
	 * application-specific value with gtk_widget_set_name(). By setting
	 * the name of a widget, you allow users or theme authors to apply
	 * styles to that specific widget in their gtkrc
	 * file. path_reversed_p fills in the path in reverse order,
	 * i.e. starting with widget's name instead of starting with the name
	 * of widget's outermost ancestor.
	 * Params:
	 * pathLength =  location to store length of the path, or NULL
	 * path =  location to store allocated path string, or NULL
	 * pathReversed =  location to store allocated reverse path string, or NULL
	 */
	public void path(out uint pathLength, out string path, out string pathReversed);

	/**
	 * Same as gtk_widget_path(), but always uses the name of a widget's type,
	 * never uses a custom name set with gtk_widget_set_name().
	 * Params:
	 * pathLength =  location to store the length of the class path, or NULL
	 * path =  location to store the class path as an allocated string, or NULL
	 * pathReversed =  location to store the reverse class path as an allocated
	 *  string, or NULL
	 */
	public void classPath(out uint pathLength, out string path, out string pathReversed);

	/**
	 * Obtains the composite name of a widget.
	 * Returns: the composite name of widget, or NULL if widget is not a composite child. The string should be freed when it is no  longer needed.
	 */
	public string getCompositeName();

	/**
	 * Modifies style values on the widget. Modifications made using this
	 * technique take precedence over style values set via an RC file,
	 * however, they will be overriden if a style is explicitely set on
	 * the widget using gtk_widget_set_style(). The GtkRcStyle structure
	 * is designed so each field can either be set or unset, so it is
	 * possible, using this function, to modify some style values and
	 * leave the others unchanged.
	 * Note that modifications made with this function are not cumulative
	 * with previous calls to gtk_widget_modify_style() or with such
	 * functions as gtk_widget_modify_fg(). If you wish to retain
	 * previous values, you must first call gtk_widget_get_modifier_style(),
	 * make your modifications to the returned style, then call
	 * gtk_widget_modify_style() with that style. On the other hand,
	 * if you first call gtk_widget_modify_style(), subsequent calls
	 * to such functions gtk_widget_modify_fg() will have a cumulative
	 * effect with the initial modifications.
	 * Params:
	 * style =  the GtkRcStyle holding the style modifications
	 */
	public void modifyStyle(RcStyle style);

	/**
	 * Returns the current modifier style for the widget. (As set by
	 * gtk_widget_modify_style().) If no style has previously set, a new
	 * GtkRcStyle will be created with all values unset, and set as the
	 * modifier style for the widget. If you make changes to this rc
	 * style, you must call gtk_widget_modify_style(), passing in the
	 * returned rc style, to make sure that your changes take effect.
	 * Caution: passing the style back to gtk_widget_modify_style() will
	 * normally end up destroying it, because gtk_widget_modify_style() copies
	 * the passed-in style and sets the copy as the new modifier style,
	 * thus dropping any reference to the old modifier style. Add a reference
	 * to the modifier style if you want to keep it alive.
	 * Returns: the modifier style for the widget. This rc style is owned by the widget. If you want to keep a pointer to value this around, you must add a refcount using g_object_ref().
	 */
	public RcStyle getModifierStyle();

	/**
	 * Sets the foreground color for a widget in a particular state.
	 * All other style values are left untouched. See also
	 * gtk_widget_modify_style().
	 * Params:
	 * state =  the state for which to set the foreground color
	 * color =  the color to assign (does not need to be allocated),
	 *  or NULL to undo the effect of previous calls to
	 *  of gtk_widget_modify_fg().
	 */
	public void modifyFg(GtkStateType state, Color color);

	/**
	 * Sets the background color for a widget in a particular state.
	 * All other style values are left untouched. See also
	 * gtk_widget_modify_style().
	 * Note that "no window" widgets (which have the GTK_NO_WINDOW flag set)
	 * draw on their parent container's window and thus may not draw any
	 * background themselves. This is the case for e.g. GtkLabel. To modify
	 * the background of such widgets, you have to set the background color
	 * on their parent; if you want to set the background of a rectangular
	 * area around a label, try placing the label in a GtkEventBox widget
	 * and setting the background color on that.
	 * Params:
	 * state =  the state for which to set the background color
	 * color =  the color to assign (does not need to be allocated),
	 *  or NULL to undo the effect of previous calls to
	 *  of gtk_widget_modify_bg().
	 */
	public void modifyBg(GtkStateType state, Color color);

	/**
	 * Sets the text color for a widget in a particular state. All other
	 * style values are left untouched. The text color is the foreground
	 * color used along with the base color (see gtk_widget_modify_base())
	 * for widgets such as GtkEntry and GtkTextView. See also
	 * gtk_widget_modify_style().
	 * Params:
	 * state =  the state for which to set the text color
	 * color =  the color to assign (does not need to be allocated),
	 *  or NULL to undo the effect of previous calls to
	 *  of gtk_widget_modify_text().
	 */
	public void modifyText(GtkStateType state, Color color);

	/**
	 * Sets the base color for a widget in a particular state.
	 * All other style values are left untouched. The base color
	 * is the background color used along with the text color
	 * (see gtk_widget_modify_text()) for widgets such as GtkEntry
	 * and GtkTextView. See also gtk_widget_modify_style().
	 * Note that "no window" widgets (which have the GTK_NO_WINDOW flag set)
	 * draw on their parent container's window and thus may not draw any
	 * background themselves. This is the case for e.g. GtkLabel. To modify
	 * the background of such widgets, you have to set the base color on their
	 * parent; if you want to set the background of a rectangular area around
	 * a label, try placing the label in a GtkEventBox widget and setting
	 * the base color on that.
	 * Params:
	 * state =  the state for which to set the base color
	 * color =  the color to assign (does not need to be allocated),
	 *  or NULL to undo the effect of previous calls to
	 *  of gtk_widget_modify_base().
	 */
	public void modifyBase(GtkStateType state, Color color);

	/**
	 * Sets the font to use for a widget. All other style values are left
	 * untouched. See also gtk_widget_modify_style().
	 * Params:
	 * fontDesc =  the font description to use, or NULL to undo
	 *  the effect of previous calls to gtk_widget_modify_font().
	 */
	public void modifyFont(PgFontDescription fontDesc);

	/**
	 * Sets the cursor color to use in a widget, overriding the
	 * "cursor-color" and "secondary-cursor-color"
	 * style properties. All other style values are left untouched.
	 * See also gtk_widget_modify_style().
	 * Since 2.12
	 * Params:
	 * primary =  the color to use for primary cursor (does not need to be
	 *  allocated), or NULL to undo the effect of previous calls to
	 *  of gtk_widget_modify_cursor().
	 * secondary =  the color to use for secondary cursor (does not need to be
	 *  allocated), or NULL to undo the effect of previous calls to
	 *  of gtk_widget_modify_cursor().
	 */
	public void modifyCursor(Color primary, Color secondary);

	/**
	 * Creates a new PangoContext with the appropriate font map,
	 * font description, and base direction for drawing text for
	 * this widget. See also gtk_widget_get_pango_context().
	 * Returns: the new PangoContext
	 */
	public PgContext createPangoContext();

	/**
	 * Gets a PangoContext with the appropriate font map, font description,
	 * and base direction for this widget. Unlike the context returned
	 * by gtk_widget_create_pango_context(), this context is owned by
	 * the widget (it can be used until the screen for the widget changes
	 * or the widget is removed from its toplevel), and will be updated to
	 * match any changes to the widget's attributes.
	 * If you create and keep a PangoLayout using this context, you must
	 * deal with changes to the context by calling pango_layout_context_changed()
	 * on the layout in response to the "style-set" and
	 * "direction-changed" signals for the widget.
	 * Returns: the PangoContext for the widget.
	 */
	public PgContext getPangoContext();

	/**
	 * Creates a new PangoLayout with the appropriate font map,
	 * font description, and base direction for drawing text for
	 * this widget.
	 * If you keep a PangoLayout created in this way around, in order to
	 * notify the layout of changes to the base direction or font of this
	 * widget, you must call pango_layout_context_changed() in response to
	 * the "style-set" and "direction-changed" signals
	 * for the widget.
	 * Params:
	 * text =  text to set on the layout (can be NULL)
	 * Returns: the new PangoLayout
	 */
	public PgLayout createPangoLayout(string text);

	/**
	 * A convenience function that uses the theme engine and RC file
	 * settings for widget to look up stock_id and render it to
	 * a pixbuf. stock_id should be a stock icon ID such as
	 * GTK_STOCK_OPEN or GTK_STOCK_OK. size should be a size
	 * such as GTK_ICON_SIZE_MENU. detail should be a string that
	 * identifies the widget or code doing the rendering, so that
	 * theme engines can special-case rendering for that widget or code.
	 * The pixels in the returned GdkPixbuf are shared with the rest of
	 * the application and should not be modified. The pixbuf should be freed
	 * after use with g_object_unref().
	 * Params:
	 * stockId =  a stock ID
	 * size =  a stock size. A size of (GtkIconSize)-1 means render at
	 *  the size of the source and don't scale (if there are multiple
	 *  source sizes, GTK+ picks one of the available sizes).
	 * detail =  render detail to pass to theme engine
	 * Returns: a new pixbuf, or NULL if the stock ID wasn't known
	 */
	public Pixbuf renderIcon(string stockId, GtkIconSize size, string detail);

	/**
	 * Cancels the effect of a previous call to gtk_widget_push_composite_child().
	 */
	public static void popCompositeChild();

	/**
	 * Makes all newly-created widgets as composite children until
	 * the corresponding gtk_widget_pop_composite_child() call.
	 * A composite child is a child that's an implementation detail of the
	 * container it's inside and should not be visible to people using the
	 * container. Composite children aren't treated differently by GTK (but
	 * see gtk_container_foreach() vs. gtk_container_forall()), but e.g. GUI
	 * builders might want to treat them in a different way.
	 */
	public static void pushCompositeChild();

	/**
	 * Warning
	 * gtk_widget_queue_clear has been deprecated since version 2.2 and should not be used in newly-written code. Use gtk_widget_queue_draw() instead.
	 * This function does the same as gtk_widget_queue_draw().
	 */
	public void queueClear();

	/**
	 * Warning
	 * gtk_widget_queue_clear_area has been deprecated since version 2.2 and should not be used in newly-written code. Use gtk_widget_queue_draw_area() instead.
	 * This function is no longer different from
	 * gtk_widget_queue_draw_area(), though it once was. Now it just calls
	 * gtk_widget_queue_draw_area(). Originally
	 * gtk_widget_queue_clear_area() would force a redraw of the
	 * background for GTK_NO_WINDOW widgets, and
	 * gtk_widget_queue_draw_area() would not. Now both functions ensure
	 * the background will be redrawn.
	 * Params:
	 * x =  x coordinate of upper-left corner of rectangle to redraw
	 * y =  y coordinate of upper-left corner of rectangle to redraw
	 * width =  width of region to draw
	 * height =  height of region to draw
	 */
	public void queueClearArea(int x, int y, int width, int height);

	/**
	 * Invalidates the rectangular area of widget defined by x, y,
	 * width and height by calling gdk_window_invalidate_rect() on the
	 * widget's window and all its child windows. Once the main loop
	 * becomes idle (after the current batch of events has been processed,
	 * roughly), the window will receive expose events for the union of
	 * all regions that have been invalidated.
	 * Normally you would only use this function in widget
	 * implementations. You might also use it, or
	 * gdk_window_invalidate_rect() directly, to schedule a redraw of a
	 * GtkDrawingArea or some portion thereof.
	 * Frequently you can just call gdk_window_invalidate_rect() or
	 * gdk_window_invalidate_region() instead of this function. Those
	 * functions will invalidate only a single window, instead of the
	 * widget and all its children.
	 * The advantage of adding to the invalidated region compared to
	 * simply drawing immediately is efficiency; using an invalid region
	 * ensures that you only have to redraw one time.
	 * Params:
	 * x =  x coordinate of upper-left corner of rectangle to redraw
	 * y =  y coordinate of upper-left corner of rectangle to redraw
	 * width =  width of region to draw
	 * height =  height of region to draw
	 */
	public void queueDrawArea(int x, int y, int width, int height);

	/**
	 * Recursively resets the shape on this widget and its descendants.
	 */
	public void resetShapes();

	/**
	 * Sets whether the application intends to draw on the widget in
	 * an "expose-event" handler.
	 * This is a hint to the widget and does not affect the behavior of
	 * the GTK+ core; many widgets ignore this flag entirely. For widgets
	 * that do pay attention to the flag, such as GtkEventBox and GtkWindow,
	 * the effect is to suppress default themed drawing of the widget's
	 * background. (Children of the widget will still be drawn.) The application
	 * is then entirely responsible for drawing the widget background.
	 * Note that the background is still drawn when the widget is mapped.
	 * If this is not suitable (e.g. because you want to make a transparent
	 * Params:
	 * appPaintable =  TRUE if the application will paint on the widget
	 */
	public void setAppPaintable(int appPaintable);

	/**
	 * Widgets are double buffered by default; you can use this function
	 * to turn off the buffering. "Double buffered" simply means that
	 * gdk_window_begin_paint_region() and gdk_window_end_paint() are called
	 * automatically around expose events sent to the
	 * widget. gdk_window_begin_paint() diverts all drawing to a widget's
	 * window to an offscreen buffer, and gdk_window_end_paint() draws the
	 * buffer to the screen. The result is that users see the window
	 * update in one smooth step, and don't see individual graphics
	 * primitives being rendered.
	 * In very simple terms, double buffered widgets don't flicker,
	 * so you would only use this function to turn off double buffering
	 * if you had special needs and really knew what you were doing.
	 * Note: if you turn off double-buffering, you have to handle
	 * expose events, since even the clearing to the background color or
	 * pixmap will not happen automatically (as it is done in
	 * gdk_window_begin_paint()).
	 * Params:
	 * doubleBuffered =  TRUE to double-buffer a widget
	 */
	public void setDoubleBuffered(int doubleBuffered);

	/**
	 * Sets whether the entire widget is queued for drawing when its size
	 * allocation changes. By default, this setting is TRUE and
	 * the entire widget is redrawn on every size change. If your widget
	 * leaves the upper left unchanged when made bigger, turning this
	 * setting off will improve performance.
	 * Note that for NO_WINDOW widgets setting this flag to FALSE turns
	 * off all allocation on resizing: the widget will not even redraw if
	 * its position changes; this is to allow containers that don't draw
	 * anything to avoid excess invalidations. If you set this flag on a
	 * NO_WINDOW widget that does draw on widget->window,
	 * you are responsible for invalidating both the old and new allocation
	 * of the widget when the widget is moved and responsible for invalidating
	 * regions newly when the widget increases size.
	 * Params:
	 * redrawOnAllocate =  if TRUE, the entire widget will be redrawn
	 *  when it is allocated to a new size. Otherwise, only the
	 *  new portion of the widget will be redrawn.
	 */
	public void setRedrawOnAllocate(int redrawOnAllocate);

	/**
	 * Sets a widgets composite name. The widget must be
	 * a composite child of its parent; see gtk_widget_push_composite_child().
	 * Params:
	 * name =  the name to set
	 */
	public void setCompositeName(string name);

	/**
	 * For widgets that support scrolling, sets the scroll adjustments and
	 * returns TRUE. For widgets that don't support scrolling, does
	 * nothing and returns FALSE. Widgets that don't support scrolling
	 * can be scrolled by placing them in a GtkViewport, which does
	 * support scrolling.
	 * Params:
	 * hadjustment =  an adjustment for horizontal scrolling, or NULL
	 * vadjustment =  an adjustment for vertical scrolling, or NULL
	 * Returns: TRUE if the widget supports scrolling
	 */
	public int setScrollAdjustments(Adjustment hadjustment, Adjustment vadjustment);

	/**
	 * Emits the "mnemonic-activate" signal.
	 * The default handler for this signal activates the widget if
	 * group_cycling is FALSE, and just grabs the focus if group_cycling
	 * is TRUE.
	 * Params:
	 * groupCycling =  TRUE if there are other widgets with the same mnemonic
	 * Returns: TRUE if the signal has been handled
	 */
	public int mnemonicActivate(int groupCycling);

	/**
	 * Installs a style property on a widget class. The parser for the
	 * style property is determined by the value type of pspec.
	 * Params:
	 * klass =  a GtkWidgetClass
	 * pspec =  the GParamSpec for the property
	 */
	public static void classInstallStyleProperty(GtkWidgetClass* klass, ParamSpec pspec);

	/**
	 * Installs a style property on a widget class.
	 * Params:
	 * klass =  a GtkWidgetClass
	 * pspec =  the GParamSpec for the style property
	 * parser =  the parser for the style property
	 */
	public static void classInstallStylePropertyParser(GtkWidgetClass* klass, ParamSpec pspec, GtkRcPropertyParser parser);

	/**
	 * Finds a style property of a widget class by name.
	 * Since 2.2
	 * Params:
	 * klass =  a GtkWidgetClass
	 * propertyName =  the name of the style property to find
	 * Returns: the GParamSpec of the style property or NULL if class has no style property with that name.
	 */
	public static ParamSpec classFindStyleProperty(GtkWidgetClass* klass, string propertyName);

	/**
	 * Returns all style properties of a widget class.
	 * Since 2.2
	 * Params:
	 * klass =  a GtkWidgetClass
	 * Returns: an newly allocated array of GParamSpec*. The array must  be freed with g_free().
	 */
	public static ParamSpec[] classListStyleProperties(GtkWidgetClass* klass);

	/**
	 * Computes the intersection of a widget's area and region, returning
	 * the intersection. The result may be empty, use gdk_region_empty() to
	 * check.
	 * Params:
	 * region =  a GdkRegion, in the same coordinate system as
	 *  widget->allocation. That is, relative to widget->window
	 *  for NO_WINDOW widgets; relative to the parent window
	 *  of widget->window for widgets with their own window.
	 * Returns: A newly allocated region holding the intersection of widget and region. The coordinates of the return value are relative to widget->window for NO_WINDOW widgets, and relative to the parent window of widget->window for widgets with their own window.
	 */
	public Region regionIntersect(Region region);

	/**
	 * Very rarely-used function. This function is used to emit
	 * an expose event signals on a widget. This function is not
	 * normally used directly. The only time it is used is when
	 * propagating an expose event to a child NO_WINDOW widget, and
	 * that is normally done using gtk_container_propagate_expose().
	 * If you want to force an area of a window to be redrawn,
	 * use gdk_window_invalidate_rect() or gdk_window_invalidate_region().
	 * To cause the redraw to be done immediately, follow that call
	 * with a call to gdk_window_process_updates().
	 * Params:
	 * event =  a expose GdkEvent
	 * Returns: return from the event signal emission (TRUE if  the event was handled)
	 */
	public int sendExpose(Event event);

	/**
	 * Gets the value of a style property of widget.
	 * Params:
	 * propertyName =  the name of a style property
	 * value =  location to return the property value
	 */
	public void styleGetProperty(string propertyName, Value value);

	/**
	 * Non-vararg variant of gtk_widget_style_get(). Used primarily by language
	 * bindings.
	 * Params:
	 * firstPropertyName =  the name of the first property to get
	 * varArgs =  a va_list of pairs of property names and
	 *  locations to return the property values, starting with the location
	 *  for first_property_name.
	 */
	public void styleGetValist(string firstPropertyName, void* varArgs);

	/**
	 * Returns the accessible object that describes the widget to an
	 * assistive technology.
	 * If no accessibility library is loaded (i.e. no ATK implementation library is
	 * loaded via GTK_MODULES or via another application library,
	 * such as libgnome), then this AtkObject instance may be a no-op. Likewise,
	 * if no class-specific AtkObject implementation is available for the widget
	 * instance in question, it will inherit an AtkObject implementation from the
	 * first ancestor class for which such an implementation is defined.
	 * The documentation of the ATK
	 * library contains more information about accessible objects and their uses.
	 * Returns: the AtkObject associated with widget
	 */
	public ObjectAtk getAccessible();

	/**
	 * This function is used by custom widget implementations; if you're
	 * writing an app, you'd use gtk_widget_grab_focus() to move the focus
	 * to a particular widget, and gtk_container_set_focus_chain() to
	 * change the focus tab order. So you may want to investigate those
	 * functions instead.
	 * gtk_widget_child_focus() is called by containers as the user moves
	 * around the window using keyboard shortcuts. direction indicates
	 * what kind of motion is taking place (up, down, left, right, tab
	 * forward, tab backward). gtk_widget_child_focus() emits the
	 * "focus"" signal; widgets override the default handler
	 * for this signal in order to implement appropriate focus behavior.
	 * The default ::focus handler for a widget should return TRUE if
	 * moving in direction left the focus on a focusable location inside
	 * that widget, and FALSE if moving in direction moved the focus
	 * outside the widget. If returning TRUE, widgets normally
	 * call gtk_widget_grab_focus() to place the focus accordingly;
	 * if returning FALSE, they don't modify the current focus location.
	 * This function replaces gtk_container_focus() from GTK+ 1.2.
	 * It was necessary to check that the child was visible, sensitive,
	 * and focusable before calling gtk_container_focus().
	 * gtk_widget_child_focus() returns FALSE if the widget is not
	 * currently in a focusable state, so there's no need for those checks.
	 * Params:
	 * direction =  direction of focus movement
	 * Returns: TRUE if focus ended up inside widget
	 */
	public int childFocus(GtkDirectionType direction);

	/**
	 * Emits a "child-notify" signal for the
	 * child property child_property
	 * on widget.
	 * This is the analogue of g_object_notify() for child properties.
	 * Params:
	 * childProperty =  the name of a child property installed on the
	 *  class of widget's parent
	 */
	public void childNotify(string childProperty);

	/**
	 * Stops emission of "child-notify" signals on widget. The
	 * signals are queued until gtk_widget_thaw_child_notify() is called
	 * on widget.
	 * This is the analogue of g_object_freeze_notify() for child properties.
	 */
	public void freezeChildNotify();

	/**
	 * Gets the value set with gtk_widget_set_child_visible().
	 * If you feel a need to use this function, your code probably
	 * needs reorganization.
	 * This function is only useful for container implementations and
	 * never should be called by an application.
	 * Returns: TRUE if the widget is mapped with the parent.
	 */
	public int getChildVisible();

	/**
	 * Returns the parent container of widget.
	 * Returns: the parent container of widget, or NULL
	 */
	public Widget getParent();

	/**
	 * Gets the settings object holding the settings (global property
	 * settings, RC file information, etc) used for this widget.
	 * Note that this function can only be called when the GtkWidget
	 * is attached to a toplevel, since the settings object is specific
	 * to a particular GdkScreen.
	 * Returns: the relevant GtkSettings object
	 */
	public Settings getSettings();

	/**
	 * Returns the clipboard object for the given selection to
	 * be used with widget. widget must have a GdkDisplay
	 * associated with it, so must be attached to a toplevel
	 * window.
	 * Since 2.2
	 * Params:
	 * selection =  a GdkAtom which identifies the clipboard
	 *  to use. GDK_SELECTION_CLIPBOARD gives the
	 *  default clipboard. Another common value
	 *  is GDK_SELECTION_PRIMARY, which gives
	 *  the primary X selection.
	 * Returns: the appropriate clipboard object. If no clipboard already exists, a new one will be created. Once a clipboard object has been created, it is persistent for all time.
	 */
	public Clipboard getClipboard(GdkAtom selection);

	/**
	 * Get the GdkDisplay for the toplevel window associated with
	 * this widget. This function can only be called after the widget
	 * has been added to a widget hierarchy with a GtkWindow at the top.
	 * In general, you should only create display specific
	 * resources when a widget has been realized, and you should
	 * free those resources when the widget is unrealized.
	 * Since 2.2
	 * Returns: the GdkDisplay for the toplevel for this widget.
	 */
	public Display getDisplay();

	/**
	 * Get the root window where this widget is located. This function can
	 * only be called after the widget has been added to a widget
	 * hierarchy with GtkWindow at the top.
	 * The root window is useful for such purposes as creating a popup
	 * GdkWindow associated with the window. In general, you should only
	 * create display specific resources when a widget has been realized,
	 * and you should free those resources when the widget is unrealized.
	 * Since 2.2
	 * Returns: the GdkWindow root window for the toplevel for this widget.
	 */
	public Window getRootWindow();

	/**
	 * Get the GdkScreen from the toplevel window associated with
	 * this widget. This function can only be called after the widget
	 * has been added to a widget hierarchy with a GtkWindow
	 * at the top.
	 * In general, you should only create screen specific
	 * resources when a widget has been realized, and you should
	 * free those resources when the widget is unrealized.
	 * Since 2.2
	 * Returns: the GdkScreen for the toplevel for this widget.
	 */
	public Screen getScreen();

	/**
	 * Checks whether there is a GdkScreen is associated with
	 * this widget. All toplevel widgets have an associated
	 * screen, and all widgets added into a hierarchy with a toplevel
	 * window at the top.
	 * Since 2.2
	 * Returns: TRUE if there is a GdkScreen associcated with the widget.
	 */
	public int hasScreen();

	/**
	 * Gets the size request that was explicitly set for the widget using
	 * gtk_widget_set_size_request(). A value of -1 stored in width or
	 * height indicates that that dimension has not been set explicitly
	 * and the natural requisition of the widget will be used intead. See
	 * gtk_widget_set_size_request(). To get the size a widget will
	 * actually use, call gtk_widget_size_request() instead of
	 * this function.
	 * Params:
	 * width =  return location for width, or NULL
	 * height =  return location for height, or NULL
	 */
	public void getSizeRequest(out int width, out int height);

	/**
	 * Sets whether widget should be mapped along with its when its parent
	 * is mapped and widget has been shown with gtk_widget_show().
	 * The child visibility can be set for widget before it is added to
	 * a container with gtk_widget_set_parent(), to avoid mapping
	 * children unnecessary before immediately unmapping them. However
	 * it will be reset to its default state of TRUE when the widget
	 * is removed from a container.
	 * Note that changing the child visibility of a widget does not
	 * queue a resize on the widget. Most of the time, the size of
	 * a widget is computed from all visible children, whether or
	 * not they are mapped. If this is not the case, the container
	 * can queue a resize itself.
	 * This function is only useful for container implementations and
	 * never should be called by an application.
	 * Params:
	 * isVisible =  if TRUE, widget should be mapped along with its parent.
	 */
	public void setChildVisible(int isVisible);

	/**
	 * Sets the minimum size of a widget; that is, the widget's size
	 * request will be width by height. You can use this function to
	 * force a widget to be either larger or smaller than it normally
	 * would be.
	 * In most cases, gtk_window_set_default_size() is a better choice for
	 * toplevel windows than this function; setting the default size will
	 * still allow users to shrink the window. Setting the size request
	 * will force them to leave the window at least as large as the size
	 * request. When dealing with window sizes,
	 * gtk_window_set_geometry_hints() can be a useful function as well.
	 * Note the inherent danger of setting any fixed size - themes,
	 * translations into other languages, different fonts, and user action
	 * can all change the appropriate size for a given widget. So, it's
	 * basically impossible to hardcode a size that will always be
	 * correct.
	 * The size request of a widget is the smallest size a widget can
	 * accept while still functioning well and drawing itself correctly.
	 * However in some strange cases a widget may be allocated less than
	 * its requested size, and in many cases a widget may be allocated more
	 * space than it requested.
	 * If the size request in a given direction is -1 (unset), then
	 * the "natural" size request of the widget will be used instead.
	 * Widgets can't actually be allocated a size less than 1 by 1, but
	 * you can pass 0,0 to this function to mean "as small as possible."
	 * Params:
	 * width =  width widget should request, or -1 to unset
	 * height =  height widget should request, or -1 to unset
	 */
	public void setSizeRequest(int width, int height);

	/**
	 * Reverts the effect of a previous call to gtk_widget_freeze_child_notify().
	 * This causes all queued "child-notify" signals on widget to be
	 * emitted.
	 */
	public void thawChildNotify();

	/**
	 * Sets the "no-show-all" property, which determines whether
	 * calls to gtk_widget_show_all() and gtk_widget_hide_all() will affect
	 * this widget.
	 * This is mostly for use in constructing widget hierarchies with externally
	 * controlled visibility, see GtkUIManager.
	 * Since 2.4
	 * Params:
	 * noShowAll =  the new value for the "no-show-all" property
	 */
	public void setNoShowAll(int noShowAll);
	/**
	 * Returns the current value of the GtkWidget:no-show-all property,
	 * which determines whether calls to gtk_widget_show_all() and
	 * gtk_widget_hide_all() will affect this widget.
	 * Since 2.4
	 * Returns: the current value of the "no-show-all" property.
	 */
	public int getNoShowAll();

	/**
	 * Returns a newly allocated list of the widgets, normally labels, for
	 * which this widget is a the target of a mnemonic (see for example,
	 * gtk_label_set_mnemonic_widget()).
	 * The widgets in the list are not individually referenced. If you
	 * want to iterate through the list and perform actions involving
	 * callbacks that might destroy the widgets, you
	 * must call g_list_foreach (result,
	 * (GFunc)g_object_ref, NULL) first, and then unref all the
	 * widgets afterwards.
	 * Since 2.4
	 * Returns: the list of mnemonic labels; free this list with g_list_free() when you are done with it.
	 */
	public ListG listMnemonicLabels();

	/**
	 * Adds a widget to the list of mnemonic labels for
	 * this widget. (See gtk_widget_list_mnemonic_labels()). Note the
	 * list of mnemonic labels for the widget is cleared when the
	 * widget is destroyed, so the caller must make sure to update
	 * its internal state at this point as well, by using a connection
	 * to the "destroy" signal or a weak notifier.
	 * Since 2.4
	 * Params:
	 * label =  a GtkWidget that acts as a mnemonic label for widget
	 */
	public void addMnemonicLabel(Widget label);

	/**
	 * Removes a widget from the list of mnemonic labels for
	 * this widget. (See gtk_widget_list_mnemonic_labels()). The widget
	 * must have previously been added to the list with
	 * gtk_widget_add_mnemonic_label().
	 * Since 2.4
	 * Params:
	 * label =  a GtkWidget that was previously set as a mnemnic label for
	 *  widget with gtk_widget_add_mnemonic_label().
	 */
	public void removeMnemonicLabel(Widget label);

	/**
	 * Warning
	 * gtk_widget_get_action has been deprecated since version 2.16 and should not be used in newly-written code. Use gtk_activatable_get_related_action() instead.
	 * Returns the GtkAction that widget is a proxy for.
	 * See also gtk_action_get_proxies().
	 * Since 2.10
	 * Returns: the action that a widget is a proxy for, or NULL, if it is not attached to an action.
	 */
	public Action getAction();

	/**
	 * Whether widget can rely on having its alpha channel
	 * drawn correctly. On X11 this function returns whether a
	 * compositing manager is running for widget's screen.
	 * Please note that the semantics of this call will change
	 * in the future if used on a widget that has a composited
	 * window in its hierarchy (as set by gdk_window_set_composited()).
	 * Since 2.10
	 * Returns: TRUE if the widget can rely on its alphachannel being drawn correctly.
	 */
	public int isComposited();

	/**
	 * Notifies the user about an input-related error on this widget.
	 * If the "gtk-error-bell" setting is TRUE, it calls
	 * gdk_window_beep(), otherwise it does nothing.
	 * Note that the effect of gdk_window_beep() can be configured in many
	 * ways, depending on the windowing backend and the desktop environment
	 * or window manager that is used.
	 * Since 2.12
	 */
	public void errorBell();

	/**
	 * This function should be called whenever keyboard navigation within
	 * a single widget hits a boundary. The function emits the
	 * "keynav-failed" signal on the widget and its return
	 * value should be interpreted in a way similar to the return value of
	 * Since 2.12
	 * Params:
	 * direction =  direction of focus movement
	 * Returns: TRUE if stopping keyboard navigation is fine, FALSE if the emitting widget should try to handle the keyboard navigation attempt in its parent container(s).
	 */
	public int keynavFailed(GtkDirectionType direction);

	/**
	 * Gets the contents of the tooltip for widget.
	 * Since 2.12
	 * Returns: the tooltip text, or NULL. You should free the returned string with g_free() when done.
	 */
	public string getTooltipMarkup();

	/**
	 * Sets markup as the contents of the tooltip, which is marked up with
	 *  the Pango text markup language.
	 * This function will take care of setting GtkWidget:has-tooltip to TRUE
	 * and of the default handler for the GtkWidget::query-tooltip signal.
	 * See also the GtkWidget:tooltip-markup property and
	 * gtk_tooltip_set_markup().
	 * Since 2.12
	 * Params:
	 * markup =  the contents of the tooltip for widget, or NULL
	 */
	public void setTooltipMarkup(string markup);

	/**
	 * Gets the contents of the tooltip for widget.
	 * Since 2.12
	 * Returns: the tooltip text, or NULL. You should free the returned string with g_free() when done.
	 */
	public string getTooltipText();

	/**
	 * Sets text as the contents of the tooltip. This function will take
	 * care of setting GtkWidget:has-tooltip to TRUE and of the default
	 * handler for the GtkWidget::query-tooltip signal.
	 * See also the GtkWidget:tooltip-text property and gtk_tooltip_set_text().
	 * Since 2.12
	 * Params:
	 * text =  the contents of the tooltip for widget
	 */
	public void setTooltipText(string text);

	/**
	 * Returns the GtkWindow of the current tooltip. This can be the
	 * GtkWindow created by default, or the custom tooltip window set
	 * using gtk_widget_set_tooltip_window().
	 * Since 2.12
	 * Returns: The GtkWindow of the current tooltip.
	 */
	public GtkWindow* getTooltipWindow()
	{
		// GtkWindow * gtk_widget_get_tooltip_window (GtkWidget *widget);
		return gtk_widget_get_tooltip_window(gtkWidget);
	}

	/**
	 * Replaces the default, usually yellow, window used for displaying
	 * tooltips with custom_window. GTK+ will take care of showing and
	 * hiding custom_window at the right moment, to behave likewise as
	 * the default tooltip window. If custom_window is NULL, the default
	 * tooltip window will be used.
	 * If the custom window should have the default theming it needs to
	 * have the name "gtk-tooltip", see gtk_widget_set_name().
	 * Since 2.12
	 * Params:
	 * customWindow =  a GtkWindow, or NULL
	 */
	public void setTooltipWindow(GtkWindow* customWindow);

	/**
	 * Returns the current value of the has-tooltip property. See
	 * GtkWidget:has-tooltip for more information.
	 * Since 2.12
	 * Returns: current value of has-tooltip on widget.
	 */
	public int getHasTooltip();

	/**
	 * Sets the has-tooltip property on widget to has_tooltip. See
	 * GtkWidget:has-tooltip for more information.
	 * Since 2.12
	 * Params:
	 * hasTooltip =  whether or not widget has a tooltip.
	 */
	public void setHasTooltip(int hasTooltip);

	/**
	 * Triggers a tooltip query on the display where the toplevel of widget
	 * is located. See gtk_tooltip_trigger_tooltip_query() for more
	 * information.
	 * Since 2.12
	 */
	public void triggerTooltipQuery();

	/**
	 * Create a GdkPixmap of the contents of the widget and its children.
	 * Works even if the widget is obscured. The depth and visual of the
	 * resulting pixmap is dependent on the widget being snapshot and likely
	 * differs from those of a target widget displaying the pixmap.
	 * The function gdk_pixbuf_get_from_drawable() can be used to convert
	 * the pixmap to a visual independant representation.
	 * The snapshot area used by this function is the widget's allocation plus
	 * any extra space occupied by additional windows belonging to this widget
	 * (such as the arrows of a spin button).
	 * Thus, the resulting snapshot pixmap is possibly larger than the allocation.
	 * If clip_rect is non-NULL, the resulting pixmap is shrunken to
	 * match the specified clip_rect. The (x,y) coordinates of clip_rect are
	 * interpreted widget relative. If width or height of clip_rect are 0 or
	 * negative, the width or height of the resulting pixmap will be shrunken
	 * by the respective amount.
	 * For instance a clip_rect { +5, +5, -10, -10 } will
	 * chop off 5 pixels at each side of the snapshot pixmap.
	 * If non-NULL, clip_rect will contain the exact widget-relative snapshot
 * coordinates upon return. A clip_rect of { -1, -1, 0, 0 }
 * can be used to preserve the auto-grown snapshot area and use clip_rect
 * as a pure output parameter.
 * The returned pixmap can be NULL, if the resulting clip_area was empty.
 * Since 2.14
 * Params:
 * clipRect =  a GdkRectangle or NULL
 * Returns: GdkPixmap snapshot of the widget
 */
public Pixmap getSnapshot(Rectangle clipRect);

/**
 * Sets the widget's allocation. This should not be used
 * directly, but from within a widget's size_allocate method.
 * Since 2.18
 * Params:
 * allocation =  a pointer to a GtkAllocation to copy from
 */
public void setAllocation(inout GtkAllocation allocation);

/**
 * Determines whether the application intends to draw on the widget in
 * an "expose-event" handler.
 * See gtk_widget_set_app_paintable()
 * Since 2.18
 * Returns: TRUE if the widget is app paintable
 */
public int getAppPaintable();

/**
 * Determines whether widget can be a default widget. See
 * gtk_widget_set_can_default().
 * Since 2.18
 * Returns: TRUE if widget can be a default widget, FALSE otherwise
 */
public int getCanDefault();

/**
 * Specifies whether widget can be a default widget. See
 * gtk_widget_grab_default() for details about the meaning of
 * "default".
 * Since 2.18
 * Params:
 * canDefault =  whether or not widget can be a default widget.
 */
public void setCanDefault(int canDefault);

/**
 * Determines whether widget can own the input focus. See
 * gtk_widget_set_can_focus().
 * Since 2.18
 * Returns: TRUE if widget can own the input focus, FALSE otherwise
 */
public int getCanFocus();

/**
 * Specifies whether widget can own the input focus. See
 * gtk_widget_grab_focus() for actually setting the input focus on a
 * widget.
 * Since 2.18
 * Params:
 * canFocus =  whether or not widget can own the input focus.
 */
public void setCanFocus(int canFocus);

/**
 * Determines whether the widget is double buffered.
 * See gtk_widget_set_double_buffered()
 * Since 2.18
 * Returns: TRUE if the widget is double buffered
 */
public int getDoubleBuffered();

/**
 * Determines whether widget has a GdkWindow of its own. See
 * gtk_widget_set_has_window().
 * Since 2.18
 * Returns: TRUE if widget has a window, FALSE otherwise
 */
public int getHasWindow();

/**
 * Specifies whether widget has a GdkWindow of its own. Note that
 * all realized widgets have a non-NULL "window" pointer
 * (gtk_widget_get_window() never returns a NULL window when a widget
 * is realized), but for many of them it's actually the GdkWindow of
 * one of its parent widgets. Widgets that create a window for
 * themselves in GtkWidget::realize() however must announce this by
 * calling this function with has_window = TRUE.
 * This function should only be called by widget implementations,
 * and they should call it in their init() function.
 * Since 2.18
 * Params:
 * hasWindow =  whether or not widget has a window.
 */
public void setHasWindow(int hasWindow);

/**
 * Returns the widget's sensitivity (in the sense of returning
 * the value that has been set using gtk_widget_set_sensitive()).
 * The effective sensitivity of a widget is however determined by both its
 * own and its parent widget's sensitivity. See gtk_widget_is_sensitive().
 * Since 2.18
 * Returns: TRUE if the widget is sensitive
 */
public int getSensitive();

/**
 * Returns the widget's effective sensitivity, which means
 * it is sensitive itself and also its parent widget is sensntive
 * Since 2.18
 * Returns: TRUE if the widget is effectively sensitive
 */
public int isSensitive();

/**
 * Returns the widget's state. See gtk_widget_set_state().
 * Since 2.18
 * Returns: the state of widget.
 */
public GtkStateType getState();

/**
 * Determines whether the widget is visible. Note that this doesn't
 * take into account whether the widget's parent is also visible
 * or the widget is obscured in any way.
 * See gtk_widget_set_visible().
 * Since 2.18
 * Returns: TRUE if the widget is visible
 */
public int getVisible();

/**
 * Sets the visibility state of widget. Note that setting this to
 * TRUE doesn't mean the widget is actually viewable, see
 * gtk_widget_get_visible().
 * This function simply calls gtk_widget_show() or gtk_widget_hide()
 * but is nicer to use when the visibility of the widget depends on
 * some condition.
 * Since 2.18
 * Params:
 * visible =  whether the widget should be shown or not
 */
public void setVisible(int visible);

/**
 * Determines whether widget is the current default widget within its
 * toplevel. See gtk_widget_set_can_default().
 * Since 2.18
 * Returns: TRUE if widget is the current default widget within its toplevel, FALSE otherwise
 */
public int hasDefault();

/**
 * Determines if the widget has the global input focus. See
 * gtk_widget_is_focus() for the difference between having the global
 * input focus, and only having the focus within a toplevel.
 * Since 2.18
 * Returns: TRUE if the widget has the global input focus.
 */
public int hasFocus();

/**
 * Determines whether the widget is currently grabbing events, so it
 * is the only widget receiving input events (keyboard and mouse).
 * See also gtk_grab_add().
 * Since 2.18
 * Returns: TRUE if the widget is in the grab_widgets stack
 */
public int hasGrab();

/**
 * Determines whether widget can be drawn to. A widget can be drawn
 * to if it is mapped and visible.
 * Since 2.18
 * Returns: TRUE if widget is drawable, FALSE otherwise
 */
public int isDrawable();

/**
 * Determines whether widget is a toplevel widget. Currently only
 * GtkWindow and GtkInvisible are toplevel widgets. Toplevel
 * widgets have no parent widget.
 * Since 2.18
 * Returns: TRUE if widget is a toplevel, FALSE otherwise
 */
public int isToplevel();

/**
 * Sets a widget's window. This function should only be used in a
 * widget's GtkWidget::realize() implementation. The window passed is
 * usually either new window created with gdk_window_new(), or the
 * window of its parent widget as returned by
 * gtk_widget_get_parent_window().
 * Widgets must indicate whether they will create their own GdkWindow
 * by calling gtk_widget_set_has_window(). This is usually done in the
 * widget's init() function.
 * Since 2.18
 * Params:
 * window =  a GdkWindow
 */
public void setWindow(Window window);

/**
 * Specifies whether widget will be treated as the default widget
 * within its toplevel when it has the focus, even if another widget
 * is the default.
 * See gtk_widget_grab_default() for details about the meaning of
 * "default".
 * Since 2.18
 * Params:
 * receivesDefault =  whether or not widget can be a default widget.
 */
public void setReceivesDefault(int receivesDefault);

/**
 * Determines whether widget is alyways treated as default widget
 * withing its toplevel when it has the focus, even if another widget
 * is the default.
 * See gtk_widget_set_receives_default().
 * Since 2.18
 * Returns: TRUE if widget acts as default widget when focussed, FALSE otherwise
 */
public int getReceivesDefault();

/**
 * Copies a GtkRequisition.
 * Params:
 * requisition =  a GtkRequisition
 * Returns: a copy of requisition
 */
public static GtkRequisition* requisitionCopy(GtkRequisition* requisition);

/**
 * Frees a GtkRequisition.
 * Params:
 * requisition =  a GtkRequisition
 */
public static void requisitionFree(GtkRequisition* requisition);
}
