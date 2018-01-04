module gtkD.gtk.InfoBar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.HBox;;
private import gtkD.gtk.VButtonBox;



private import gtkD.gtk.HBox;

/**
 * Description
 * GtkInfoBar is a widget that can be used to show messages to
 * the user without showing a dialog. It is often temporarily shown
 * at the top or bottom of a document. In contrast to GtkDialog, which
 * has a horizontal action area at the bottom, GtkInfoBar has a
 * vertical action area at the side.
 * The API of GtkInfoBar is very similar to GtkDialog, allowing you
 * to add buttons to the action area with gtk_info_bar_add_button() or
 * gtk_info_bar_new_with_buttons(). The sensitivity of action widgets
 * can be controlled with gtk_info_bar_set_response_sensitive().
 * To add widgets to the main content area of a GtkInfoBar, use
 * gtk_info_bar_get_content_area() and add your widgets to the container.
 * Similar to GtkMessageDialog, the contents of a GtkInfoBar can by
 * classified as error message, warning, informational message, etc,
 * by using gtk_info_bar_set_message_type(). GTK+ uses the message type
 * to determine the background color of the message area.
 * Example 14. Simple GtkInfoBar usage.
 * /+* set up info bar +/
 * info_bar = gtk_info_bar_new ();
 * gtk_widget_set_no_show_all (info_bar, TRUE);
 * message_label = gtk_label_new ("");
 * gtk_widget_show (message_label);
 * content_area = gtk_info_bar_get_content_area (GTK_INFO_BAR (info_bar));
 * gtk_container_add (GTK_CONTAINER (content_area), message_label);
 * gtk_info_bar_add_button (GTK_INFO_BAR (info_bar),
 *  GTK_STOCK_OK, GTK_RESPONSE_OK);
 * g_signal_connect (info_bar, "response",
 *  G_CALLBACK (gtk_widget_hide), NULL);
 * gtk_table_attach (GTK_TABLE (table),
 *  info_bar,
 *  0, 1, 2, 3,
 *  GTK_EXPAND | GTK_FILL, 0,
 *  0, 0);
 * /+* ... +/
 * /+* show an error message +/
 * gtk_label_set_text (GTK_LABEL (message_label), error_message);
 * gtk_info_bar_set_message_type (GTK_INFO_BAR (info_bar),
 *  GTK_MESSAGE_ERROR);
 * gtk_widget_show (info_bar);
 * GtkInfoBar as GtkBuildable
 * The GtkInfoBar implementation of the GtkBuildable interface exposes
 * the content area and action area as internal children with the names
 * "content_area" and "action_area".
 * GtkInfoBar supports a custom <action-widgets> element, which
 * can contain multiple <action-widget> elements. The "response"
 * attribute specifies a numeric response, and the content of the element
 * is the id of widget (which should be a child of the dialogs action_area).
 */
public class InfoBar : HBox
{
	
	/** the main Gtk struct */
	protected GtkInfoBar* gtkInfoBar;
	
	
	public GtkInfoBar* getInfoBarStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkInfoBar* gtkInfoBar);
	
	/** */
	public this(string[] buttonsText, ResponseType[] responses);
	
	/** */
	public this(StockID[] stockIDs, ResponseType[] responses);
	
	/** */
	public Widget addButton(StockID stockID, int responseId);
	
	/** */
	public void addButtons(string[] buttonsText, ResponseType[] responses);
	
	/** */
	public void addButtons(StockID[] stockIDs, ResponseType[] responses);
	
	/**
	 * Returns the action area of info_bar.
	 * Since 2.18
	 * Returns: the action area.
	 */
	public VButtonBox getActionArea();
	
	/**
	 * Returns the content area of info_bar.
	 * Since 2.18
	 * Returns: the content area.
	 */
	public HBox getContentArea();
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(InfoBar)[] onCloseListeners;
	/**
	 * The ::close signal is a
	 * keybinding signal
	 * which gets emitted when the user uses a keybinding to dismiss
	 * the info bar.
	 * The default binding for this signal is the Escape key.
	 * Since 2.18
	 */
	void addOnClose(void delegate(InfoBar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackClose(GtkInfoBar* arg0Struct, InfoBar infoBar);
	
	void delegate(gint, InfoBar)[] onResponseListeners;
	/**
	 * Emitted when an action widget is clicked or the application programmer
	 * calls gtk_dialog_response(). The response_id depends on which action
	 * widget was clicked.
	 * Since 2.18
	 * See Also
	 * #GtkStatusbar, GtkMessageDialog
	 */
	void addOnResponse(void delegate(gint, InfoBar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackResponse(GtkInfoBar* infoBarStruct, gint responseId, InfoBar infoBar);
	
	
	/**
	 * Creates a new GtkInfoBar object.
	 * Since 2.18
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Add an activatable widget to the action area of a GtkInfoBar,
	 * connecting a signal handler that will emit the "response"
	 * signal on the message area when the widget is activated. The widget
	 * is appended to the end of the message areas action area.
	 * Since 2.18
	 * Params:
	 * child =  an activatable widget
	 * responseId =  response ID for child
	 */
	public void addActionWidget(Widget child, int responseId);
	
	/**
	 * Adds a button with the given text (or a stock button, if button_text
	 * is a stock ID) and sets things up so that clicking the button will emit
	 * the "response" signal with the given response_id. The button is appended
	 * to the end of the info bars's action area. The button widget is
	 * returned, but usually you don't need it.
	 * Since 2.18
	 * Params:
	 * buttonText =  text of button, or stock ID
	 * responseId =  response ID for the button
	 * Returns: the button widget that was added
	 */
	public Widget addButton(string buttonText, int responseId);
	
	/**
	 * Calls gtk_widget_set_sensitive (widget, setting) for each
	 * widget in the info bars's action area with the given response_id.
	 * A convenient way to sensitize/desensitize dialog buttons.
	 * Since 2.18
	 * Params:
	 * responseId =  a response ID
	 * setting =  TRUE for sensitive
	 */
	public void setResponseSensitive(int responseId, int setting);
	
	/**
	 * Sets the last widget in the info bar's action area with
	 * the given response_id as the default widget for the dialog.
	 * Pressing "Enter" normally activates the default widget.
	 * Since 2.18
	 * Params:
	 * responseId =  a response ID
	 */
	public void setDefaultResponse(int responseId);
	
	/**
	 * Emits the 'response' signal with the given response_id.
	 * Since 2.18
	 * Params:
	 * responseId =  a response ID
	 */
	public void response(int responseId);
	
	/**
	 * Sets the message type of the message area.
	 * GTK+ uses this type to determine what color to use
	 * when drawing the message area.
	 * Since 2.18
	 * Params:
	 * messageType =  a GtkMessageType
	 */
	public void setMessageType(GtkMessageType messageType);
	
	/**
	 * Returns the message type of the message area.
	 * Since 2.18
	 * Returns: the message type of the message area.
	 */
	public GtkMessageType getMessageType();
}
