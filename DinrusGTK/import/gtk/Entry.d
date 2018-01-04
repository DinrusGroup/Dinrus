module gtkD.gtk.Entry;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gdk.Pixbuf;
private import gtkD.gtk.Adjustment;
private import gtkD.gtk.Border;
private import gtkD.gtk.EntryBuffer;
private import gtkD.gtk.EntryCompletion;
private import gtkD.pango.PgLayout;
private import gtkD.gtk.EditableT;
private import gtkD.gtk.EditableIF;
private import gtkD.gtk.CellEditableT;
private import gtkD.gtk.CellEditableIF;



private import gtkD.gtk.Widget;

/**
 * Description
 * The GtkEntry widget is a single line text entry
 * widget. A fairly large set of key bindings are supported
 * by default. If the entered text is longer than the allocation
 * of the widget, the widget will scroll so that the cursor
 * position is visible.
 * When using an entry for passwords and other sensitive information,
 * it can be put into "password mode" using gtk_entry_set_visibility().
 * In this mode, entered text is displayed using a 'invisible' character.
 * By default, GTK+ picks the best invisible character that is available
 * in the current font, but it can be changed with
 * gtk_entry_set_invisible_char(). Since 2.16, GTK+ displays a warning
 * when Caps Lock or input methods might interfere with entering text in
 * a password entry. The warning can be turned off with the
 * "caps-lock-warning" property.
 * Since 2.16, GtkEntry has the ability to display progress or activity
 * information behind the text. To make an entry display such information,
 * use gtk_entry_set_progress_fraction() or gtk_entry_set_progress_pulse_step().
 * Additionally, GtkEntry can show icons at either side of the entry. These
 * icons can be activatable by clicking, can be set up as drag source and
 * can have tooltips. To add an icon, use gtk_entry_set_icon_from_gicon() or
 * one of the various other functions that set an icon from a stock id, an
 * icon name or a pixbuf. To trigger an action when the user clicks an icon,
 * connect to the "icon-press" signal. To allow DND operations
 * from an icon, use gtk_entry_set_icon_drag_source(). To set a tooltip on
 * an icon, use gtk_entry_set_icon_tooltip_text() or the corresponding function
 * for markup.
 * Note that functionality or information that is only available by clicking
 * on an icon in an entry may not be accessible at all to users which are not
 * able to use a mouse or other pointing device. It is therefore recommended
 * that any such functionality should also be available by other means, e.g.
 * via the context menu of the entry.
 */
public class Entry : Widget, EditableIF, CellEditableIF
{
	
	/** the main Gtk struct */
	protected GtkEntry* gtkEntry;
	
	
	public GtkEntry* getEntryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkEntry* gtkEntry);
	
	// add the Editable capabilities
	mixin EditableT!(GtkEntry);
	
	// add the CellEditable capabilities
	mixin CellEditableT!(GtkEntry);
	
	/** */
	public this (string text);
	
	/** */
	public this (string text, int max);
	
	/**
	 * Gets the stock id of action.
	 * Since 2.16
	 * Returns: the stock id
	 */
	public StockID getStockId(GtkEntryIconPosition iconPos);
	
	/**
	 * Sets the stock id on action
	 * Since 2.16
	 * Params:
	 * stockId =  the stock id
	 */
	public void setStockId(GtkEntryIconPosition iconPos, StockID stockId);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Entry)[] onActivateListeners;
	/**
	 * A keybinding signal
	 * which gets emitted when the user activates the entry.
	 * Applications should not connect to it, but may emit it with
	 * g_signal_emit_by_name() if they need to control activation
	 * programmatically.
	 * The default bindings for this signal are all forms of the Enter key.
	 */
	void addOnActivate(void delegate(Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackActivate(GtkEntry* entryStruct, Entry entry);
	
	void delegate(Entry)[] onBackspaceListeners;
	/**
	 * The ::backspace signal is a
	 * keybinding signal
	 * which gets emitted when the user asks for it.
	 * The default bindings for this signal are
	 * Backspace and Shift-Backspace.
	 */
	void addOnBackspace(void delegate(Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackBackspace(GtkEntry* entryStruct, Entry entry);
	
	void delegate(Entry)[] onCopyClipboardListeners;
	/**
	 * The ::copy-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to copy the selection to the clipboard.
	 * The default bindings for this signal are
	 * Ctrl-c and Ctrl-Insert.
	 */
	void addOnCopyClipboard(void delegate(Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCopyClipboard(GtkEntry* entryStruct, Entry entry);
	
	void delegate(Entry)[] onCutClipboardListeners;
	/**
	 * The ::cut-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to cut the selection to the clipboard.
	 * The default bindings for this signal are
	 * Ctrl-x and Shift-Delete.
	 */
	void addOnCutClipboard(void delegate(Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCutClipboard(GtkEntry* entryStruct, Entry entry);
	
	void delegate(GtkDeleteType, gint, Entry)[] onDeleteFromCursorListeners;
	/**
	 * The ::delete-from-cursor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates a text deletion.
	 * If the type is GTK_DELETE_CHARS, GTK+ deletes the selection
	 * if there is one, otherwise it deletes the requested number
	 * of characters.
	 * The default bindings for this signal are
	 * Delete for deleting a character and Ctrl-Delete for
	 * deleting a word.
	 */
	void addOnDeleteFromCursor(void delegate(GtkDeleteType, gint, Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDeleteFromCursor(GtkEntry* entryStruct, GtkDeleteType type, gint count, Entry entry);
	
	void delegate(GtkEntryIconPosition, GdkEvent*, Entry)[] onIconPressListeners;
	/**
	 * The ::icon-press signal is emitted when an activatable icon
	 * is clicked.
	 * Since 2.16
	 */
	void addOnIconPress(void delegate(GtkEntryIconPosition, GdkEvent*, Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackIconPress(GtkEntry* entryStruct, GtkEntryIconPosition iconPos, GdkEvent* event, Entry entry);
	
	void delegate(GtkEntryIconPosition, GdkEvent*, Entry)[] onIconReleaseListeners;
	/**
	 * The ::icon-release signal is emitted on the button release from a
	 * mouse click over an activatable icon.
	 * Since 2.16
	 */
	void addOnIconRelease(void delegate(GtkEntryIconPosition, GdkEvent*, Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackIconRelease(GtkEntry* entryStruct, GtkEntryIconPosition iconPos, GdkEvent* event, Entry entry);
	
	void delegate(string, Entry)[] onInsertAtCursorListeners;
	/**
	 * The ::insert-at-cursor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates the insertion of a
	 * fixed string at the cursor.
	 * This signal has no default bindings.
	 */
	void addOnInsertAtCursor(void delegate(string, Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackInsertAtCursor(GtkEntry* entryStruct, gchar* str, Entry entry);
	
	void delegate(GtkMovementStep, gint, gboolean, Entry)[] onMoveCursorListeners;
	/**
	 * The ::move-cursor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates a cursor movement.
	 * If the cursor is not visible in entry, this signal causes
	 * the viewport to be moved instead.
	 * Applications should not connect to it, but may emit it with
	 * g_signal_emit_by_name() if they need to control the cursor
	 * programmatically.
	 * The default bindings for this signal come in two variants,
	 * the variant with the Shift modifier extends the selection,
	 * the variant without the Shift modifer does not.
	 * There are too many key combinations to list them all here.
	 * Arrow keys move by individual characters/lines
	 * Ctrl-arrow key combinations move by words/paragraphs
	 * Home/End keys move to the ends of the buffer
	 */
	void addOnMoveCursor(void delegate(GtkMovementStep, gint, gboolean, Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveCursor(GtkEntry* entryStruct, GtkMovementStep step, gint count, gboolean extendSelection, Entry entry);
	
	void delegate(Entry)[] onPasteClipboardListeners;
	/**
	 * The ::paste-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to paste the contents of the clipboard
	 * into the text view.
	 * The default bindings for this signal are
	 * Ctrl-v and Shift-Insert.
	 */
	void addOnPasteClipboard(void delegate(Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPasteClipboard(GtkEntry* entryStruct, Entry entry);
	
	void delegate(GtkMenu*, Entry)[] onPopulatePopupListeners;
	/**
	 * The ::populate-popup signal gets emitted before showing the
	 * context menu of the entry.
	 * If you need to add items to the context menu, connect
	 * to this signal and append your menuitems to the menu.
	 */
	void addOnPopulatePopup(void delegate(GtkMenu*, Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPopulatePopup(GtkEntry* entryStruct, GtkMenu* menu, Entry entry);
	
	void delegate(Entry)[] onToggleOverwriteListeners;
	/**
	 * The ::toggle-overwrite signal is a
	 * keybinding signal
	 * which gets emitted to toggle the overwrite mode of the entry.
	 * The default bindings for this signal is Insert.
	 * See Also
	 * GtkTextView
	 * a widget for handling multi-line text entry.
	 * GtkEntryCompletion
	 * adds completion functionality to GtkEntry.
	 */
	void addOnToggleOverwrite(void delegate(Entry) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggleOverwrite(GtkEntry* entryStruct, Entry entry);
	
	
	/**
	 * Creates a new entry.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new entry with the specified text buffer.
	 * Since 2.18
	 * Params:
	 * buffer =  The buffer to use for the new GtkEntry.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (EntryBuffer buffer);
	
	/**
	 * Warning
	 * gtk_entry_new_with_max_length is deprecated and should not be used in newly-written code. Use gtk_entry_set_max_length() instead.
	 * Creates a new GtkEntry widget with the given maximum length.
	 * Params:
	 * max =  the maximum length of the entry, or 0 for no maximum.
	 *  (other than the maximum length of entries.) The value passed in will
	 *  be clamped to the range 0-65536.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int max);
	
	/**
	 * Get the GtkEntryBuffer object which holds the text for
	 * this widget.
	 * Since 2.18
	 * Returns: A GtkEntryBuffer object.
	 */
	public EntryBuffer getBuffer();
	
	/**
	 * Set the GtkEntryBuffer object which holds the text for
	 * this widget.
	 * Since 2.18
	 * Params:
	 * buffer =  a GtkEntryBuffer
	 */
	public void setBuffer(EntryBuffer buffer);
	
	/**
	 * Sets the text in the widget to the given
	 * value, replacing the current contents.
	 * See gtk_entry_buffer_set_text().
	 * Params:
	 * text =  the new text
	 */
	public void setText(string text);
	
	/**
	 * Warning
	 * gtk_entry_append_text has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_editable_insert_text() instead.
	 * Appends the given text to the contents of the widget.
	 * Params:
	 * text =  the text to append
	 */
	public void appendText(string text);
	
	/**
	 * Warning
	 * gtk_entry_prepend_text has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_editable_insert_text() instead.
	 * Prepends the given text to the contents of the widget.
	 * Params:
	 * text =  the text to prepend
	 */
	public void prependText(string text);
	
	/**
	 * Retrieves the contents of the entry widget.
	 * See also gtk_editable_get_chars().
	 * Returns: a pointer to the contents of the widget as a string. This string points to internally allocated storage in the widget and must not be freed, modified or stored.
	 */
	public string getText();
	
	/**
	 * Retrieves the current length of the text in
	 * entry.
	 * Since 2.14
	 * Returns: the current number of characters in GtkEntry, or 0 if there are none.
	 */
	public ushort getTextLength();
	
	/**
	 * Sets whether the contents of the entry are visible or not.
	 * When visibility is set to FALSE, characters are displayed
	 * as the invisible char, and will also appear that way when
	 * the text in the entry widget is copied elsewhere.
	 * By default, GTK+ picks the best invisible character available
	 * in the current font, but it can be changed with
	 * gtk_entry_set_invisible_char().
	 * Params:
	 * visible =  TRUE if the contents of the entry are displayed
	 *  as plaintext
	 */
	public void setVisibility(int visible);
	
	/**
	 * Sets the character to use in place of the actual text when
	 * gtk_entry_set_visibility() has been called to set text visibility
	 * to FALSE. i.e. this is the character used in "password mode" to
	 * show the user how many characters have been typed. By default, GTK+
	 * picks the best invisible char available in the current font. If you
	 * set the invisible char to 0, then the user will get no feedback
	 * at all; there will be no text on the screen as they type.
	 * Params:
	 * ch =  a Unicode character
	 */
	public void setInvisibleChar(gunichar ch);
	
	/**
	 * Unsets the invisible char previously set with
	 * gtk_entry_set_invisible_char(). So that the
	 * default invisible char is used again.
	 * Since 2.16
	 */
	public void unsetInvisibleChar();
	
	/**
	 * Sets the maximum allowed length of the contents of the widget. If
	 * the current contents are longer than the given length, then they
	 * will be truncated to fit.
	 * Params:
	 * max =  the maximum length of the entry, or 0 for no maximum.
	 *  (other than the maximum length of entries.) The value passed in will
	 *  be clamped to the range 0-65536.
	 */
	public void setMaxLength(int max);
	
	/**
	 * Retrieves the value set by gtk_entry_set_activates_default().
	 * Returns: TRUE if the entry will activate the default widget
	 */
	public int getActivatesDefault();
	
	/**
	 * Gets the value set by gtk_entry_set_has_frame().
	 * Returns: whether the entry has a beveled frame
	 */
	public int getHasFrame();
	
	/**
	 * This function returns the entry's "inner-border" property. See
	 * gtk_entry_set_inner_border() for more information.
	 * Since 2.10
	 * Returns: the entry's GtkBorder, or NULL if none was set.
	 */
	public Border getInnerBorder();
	
	/**
	 * Gets the value set by gtk_entry_set_width_chars().
	 * Returns: number of chars to request space for, or negative if unset
	 */
	public int getWidthChars();
	
	/**
	 * If setting is TRUE, pressing Enter in the entry will activate the default
	 * widget for the window containing the entry. This usually means that
	 * the dialog box containing the entry will be closed, since the default
	 * widget is usually one of the dialog buttons.
	 * (For experts: if setting is TRUE, the entry calls
	 * gtk_window_activate_default() on the window containing the entry, in
	 * the default handler for the "activate" signal.)
	 * Params:
	 * setting =  TRUE to activate window's default widget on Enter keypress
	 */
	public void setActivatesDefault(int setting);
	
	/**
	 * Sets whether the entry has a beveled frame around it.
	 * Params:
	 * setting =  new value
	 */
	public void setHasFrame(int setting);
	
	/**
	 * Sets entry's inner-border property to border, or clears it if NULL
	 * is passed. The inner-border is the area around the entry's text, but
	 * inside its frame.
	 * If set, this property overrides the inner-border style property.
	 * Overriding the style-provided border is useful when you want to do
	 * in-place editing of some text in a canvas or list widget, where
	 * pixel-exact positioning of the entry is important.
	 * Since 2.10
	 * Params:
	 * border =  a GtkBorder, or NULL
	 */
	public void setInnerBorder(Border border);
	
	/**
	 * Changes the size request of the entry to be about the right size
	 * for n_chars characters. Note that it changes the size
	 * request, the size can still be affected by
	 * how you pack the widget into containers. If n_chars is -1, the
	 * size reverts to the default entry size.
	 * Params:
	 * nChars =  width in chars
	 */
	public void setWidthChars(int nChars);
	
	/**
	 * Retrieves the character displayed in place of the real characters
	 * for entries with visibility set to false. See gtk_entry_set_invisible_char().
	 * Returns: the current invisible char, or 0, if the entry does not show invisible text at all.
	 */
	public gunichar getInvisibleChar();
	
	/**
	 * Sets the alignment for the contents of the entry. This controls
	 * the horizontal positioning of the contents when the displayed
	 * text is shorter than the width of the entry.
	 * Since 2.4
	 * Params:
	 * xalign =  The horizontal alignment, from 0 (left) to 1 (right).
	 *  Reversed for RTL layouts
	 */
	public void setAlignment(float xalign);
	
	/**
	 * Gets the value set by gtk_entry_set_alignment().
	 * Since 2.4
	 * Returns: the alignment
	 */
	public float getAlignment();
	
	/**
	 * Sets whether the text is overwritten when typing in the GtkEntry.
	 * Since 2.14
	 * Params:
	 * overwrite =  new value
	 */
	public void setOverwriteMode(int overwrite);
	
	/**
	 * Gets the value set by gtk_entry_set_overwrite_mode().
	 * Since 2.14
	 * Returns: whether the text is overwritten when typing.
	 */
	public int getOverwriteMode();
	
	/**
	 * Gets the PangoLayout used to display the entry.
	 * The layout is useful to e.g. convert text positions to
	 * pixel positions, in combination with gtk_entry_get_layout_offsets().
	 * The returned layout is owned by the entry and must not be
	 * modified or freed by the caller.
	 * Keep in mind that the layout text may contain a preedit string, so
	 * gtk_entry_layout_index_to_text_index() and
	 * gtk_entry_text_index_to_layout_index() are needed to convert byte
	 * indices in the layout to byte indices in the entry contents.
	 * Returns: the PangoLayout for this entry
	 */
	public PgLayout getLayout();
	
	/**
	 * Obtains the position of the PangoLayout used to render text
	 * in the entry, in widget coordinates. Useful if you want to line
	 * up the text in an entry with some other text, e.g. when using the
	 * entry to implement editable cells in a sheet widget.
	 * Also useful to convert mouse events into coordinates inside the
	 * PangoLayout, e.g. to take some action if some part of the entry text
	 * is clicked.
	 * Note that as the user scrolls around in the entry the offsets will
	 * change; you'll need to connect to the "notify::scroll-offset"
	 * signal to track this. Remember when using the PangoLayout
	 * functions you need to convert to and from pixels using
	 * PANGO_PIXELS() or PANGO_SCALE.
	 * Keep in mind that the layout text may contain a preedit string, so
	 * gtk_entry_layout_index_to_text_index() and
	 * gtk_entry_text_index_to_layout_index() are needed to convert byte
	 * indices in the layout to byte indices in the entry contents.
	 * Params:
	 * x =  location to store X offset of layout, or NULL
	 * y =  location to store Y offset of layout, or NULL
	 */
	public void getLayoutOffsets(out int x, out int y);
	
	/**
	 * Converts from a position in the entry contents (returned
	 * by gtk_entry_get_text()) to a position in the
	 * entry's PangoLayout (returned by gtk_entry_get_layout(),
	 * with text retrieved via pango_layout_get_text()).
	 * Params:
	 * layoutIndex =  byte index into the entry layout text
	 * Returns: byte index into the entry contents
	 */
	public int layoutIndexToTextIndex(int layoutIndex);
	
	/**
	 * Converts from a position in the entry's PangoLayout (returned by
	 * gtk_entry_get_layout()) to a position in the entry contents
	 * (returned by gtk_entry_get_text()).
	 * Params:
	 * textIndex =  byte index into the entry contents
	 * Returns: byte index into the entry layout text
	 */
	public int textIndexToLayoutIndex(int textIndex);
	
	/**
	 * Retrieves the maximum allowed length of the text in
	 * entry. See gtk_entry_set_max_length().
	 * Returns: the maximum allowed number of characters in GtkEntry, or 0 if there is no maximum.
	 */
	public int getMaxLength();
	
	/**
	 * Retrieves whether the text in entry is visible. See
	 * gtk_entry_set_visibility().
	 * Returns: TRUE if the text is currently visible
	 */
	public int getVisibility();

	/**
	 * Sets completion to be the auxiliary completion object to use with entry.
	 * All further configuration of the completion mechanism is done on
	 * completion using the GtkEntryCompletion API. Completion is disabled if
	 * completion is set to NULL.
	 * Since 2.4
	 * Params:
	 * completion =  The GtkEntryCompletion or NULL
	 */
	public void setCompletion(EntryCompletion completion);
	
	/**
	 * Returns the auxiliary completion object currently in use by entry.
	 * Since 2.4
	 * Returns: The auxiliary completion object currently in use by entry.
	 */
	public EntryCompletion getCompletion();
	
	/**
	 * Hooks up an adjustment to the cursor position in an entry, so that when
	 * the cursor is moved, the adjustment is scrolled to show that position.
	 * See gtk_scrolled_window_get_hadjustment() for a typical way of obtaining
	 * the adjustment.
	 * The adjustment has to be in pixel units and in the same coordinate system
	 * as the entry.
	 * Since 2.12
	 * Params:
	 * adjustment =  an adjustment which should be adjusted when the cursor
	 *  is moved, or NULL
	 */
	public void setCursorHadjustment(Adjustment adjustment);
	
	/**
	 * Retrieves the horizontal cursor adjustment for the entry.
	 * See gtk_entry_set_cursor_hadjustment().
	 * Since 2.12
	 * Returns: the horizontal cursor adjustment, or NULL  if none has been set.
	 */
	public Adjustment getCursorHadjustment();
	
	/**
	 * Causes the entry's progress indicator to "fill in" the given
	 * fraction of the bar. The fraction should be between 0.0 and 1.0,
	 * inclusive.
	 * Since 2.16
	 * Params:
	 * fraction =  fraction of the task that's been completed
	 */
	public void setProgressFraction(double fraction);
	
	/**
	 * Returns the current fraction of the task that's been completed.
	 * See gtk_entry_set_progress_fraction().
	 * Since 2.16
	 * Returns: a fraction from 0.0 to 1.0
	 */
	public double getProgressFraction();
	
	/**
	 * Sets the fraction of total entry width to move the progress
	 * bouncing block for each call to gtk_entry_progress_pulse().
	 * Since 2.16
	 * Params:
	 * fraction =  fraction between 0.0 and 1.0
	 */
	public void setProgressPulseStep(double fraction);
	
	/**
	 * Retrieves the pulse step set with gtk_entry_set_progress_pulse_step().
	 * Since 2.16
	 * Returns: a fraction from 0.0 to 1.0
	 */
	public double getProgressPulseStep();
	
	/**
	 * Indicates that some progress is made, but you don't know how much.
	 * Causes the entry's progress indicator to enter "activity mode,"
	 * where a block bounces back and forth. Each call to
	 * gtk_entry_progress_pulse() causes the block to move by a little bit
	 * (the amount of movement per pulse is determined by
	 * gtk_entry_set_progress_pulse_step()).
	 * Since 2.16
	 */
	public void progressPulse();
	
	/**
	 * Sets the icon shown in the specified position using a pixbuf.
	 * If pixbuf is NULL, no icon will be shown in the specified position.
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * pixbuf =  A GdkPixbuf, or NULL
	 */
	public void setIconFromPixbuf(GtkEntryIconPosition iconPos, Pixbuf pixbuf);
	
	/**
	 * Sets the icon shown in the entry at the specified position from
	 * a stock image.
	 * If stock_id is NULL, no icon will be shown in the specified position.
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * stockId =  The name of the stock item, or NULL
	 */
	public void setIconFromStock(GtkEntryIconPosition iconPos, string stockId);
	
	/**
	 * Sets the icon shown in the entry at the specified position
	 * from the current icon theme.
	 * If the icon name isn't known, a "broken image" icon will be displayed
	 * instead.
	 * If icon_name is NULL, no icon will be shown in the specified position.
	 * Since 2.16
	 * Params:
	 * iconPos =  The position at which to set the icon
	 * iconName =  An icon name, or NULL
	 */
	public void setIconFromIconName(GtkEntryIconPosition iconPos, string iconName);
	
	/**
	 * Sets the icon shown in the entry at the specified position
	 * from the current icon theme.
	 * If the icon isn't known, a "broken image" icon will be displayed
	 * instead.
	 * If icon is NULL, no icon will be shown in the specified position.
	 * Since 2.16
	 * Params:
	 * iconPos =  The position at which to set the icon
	 * icon =  The icon to set, or NULL
	 */
	public void setIconFromGicon(GtkEntryIconPosition iconPos, IconIF icon);
	
	/**
	 * Gets the type of representation being used by the icon
	 * to store image data. If the icon has no image data,
	 * the return value will be GTK_IMAGE_EMPTY.
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * Returns: image representation being used
	 */
	public GtkImageType getIconStorageType(GtkEntryIconPosition iconPos);
	
	/**
	 * Retrieves the image used for the icon.
	 * Unlike the other methods of setting and getting icon data, this
	 * method will work regardless of whether the icon was set using a
	 * GdkPixbuf, a GIcon, a stock item, or an icon name.
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * Returns: A GdkPixbuf, or NULL if no icon is set for this position.
	 */
	public Pixbuf getIconPixbuf(GtkEntryIconPosition iconPos);
	
	/**
	 * Retrieves the stock id used for the icon, or NULL if there is
	 * no icon or if the icon was set by some other method (e.g., by
	 * pixbuf, icon name or gicon).
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * Returns: A stock id, or NULL if no icon is set or if the icon wasn't set from a stock id
	 */
	public string getIconStock(GtkEntryIconPosition iconPos);
	
	/**
	 * Retrieves the icon name used for the icon, or NULL if there is
	 * no icon or if the icon was set by some other method (e.g., by
	 * pixbuf, stock or gicon).
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * Returns: An icon name, or NULL if no icon is set or if the icon wasn't set from an icon name
	 */
	public string getIconName(GtkEntryIconPosition iconPos);
	
	/**
	 * Retrieves the GIcon used for the icon, or NULL if there is
	 * no icon or if the icon was set by some other method (e.g., by
	 * stock, pixbuf, or icon name).
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * Returns: A GIcon, or NULL if no icon is set or if the icon is not a GIcon
	 */
	public IconIF getIconGicon(GtkEntryIconPosition iconPos);
	
	/**
	 * Sets whether the icon is activatable.
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * activatable =  TRUE if the icon should be activatable
	 */
	public void setIconActivatable(GtkEntryIconPosition iconPos, int activatable);
	
	/**
	 * Returns whether the icon is activatable.
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * Returns: TRUE if the icon is activatable.
	 */
	public int getIconActivatable(GtkEntryIconPosition iconPos);
	
	/**
	 * Sets the sensitivity for the specified icon.
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * sensitive =  Specifies whether the icon should appear
	 *  sensitive or insensitive
	 */
	public void setIconSensitive(GtkEntryIconPosition iconPos, int sensitive);
	
	/**
	 * Returns whether the icon appears sensitive or insensitive.
	 * Since 2.16
	 * Params:
	 * iconPos =  Icon position
	 * Returns: TRUE if the icon is sensitive.
	 */
	public int getIconSensitive(GtkEntryIconPosition iconPos);

	/**
	 * Finds the icon at the given position and return its index.
	 * If x, y doesn't lie inside an icon, -1 is returned.
	 * This function is intended for use in a "query-tooltip"
	 * signal handler.
	 * Since 2.16
	 * Params:
	 * x =  the x coordinate of the position to find
	 * y =  the y coordinate of the position to find
	 * Returns: the index of the icon at the given position, or -1
	 */
	public int getIconAtPos(int x, int y);
	
	/**
	 * Sets tooltip as the contents of the tooltip for the icon
	 * at the specified position.
	 * Use NULL for tooltip to remove an existing tooltip.
	 * See also gtk_widget_set_tooltip_text() and
	 * gtk_entry_set_icon_tooltip_markup().
	 * Since 2.16
	 * Params:
	 * iconPos =  the icon position
	 * tooltip =  the contents of the tooltip for the icon, or NULL
	 */
	public void setIconTooltipText(GtkEntryIconPosition iconPos, string tooltip);
	
	/**
	 * Gets the contents of the tooltip on the icon at the specified
	 * position in entry.
	 * Since 2.16
	 * Params:
	 * iconPos =  the icon position
	 * Returns: the tooltip text, or NULL. Free the returned string with g_free() when done.
	 */
	public string getIconTooltipText(GtkEntryIconPosition iconPos);
	
	/**
	 * Sets tooltip as the contents of the tooltip for the icon at
	 * the specified position. tooltip is assumed to be marked up with
	 * the Pango text markup language.
	 * Use NULL for tooltip to remove an existing tooltip.
	 * See also gtk_widget_set_tooltip_markup() and
	 * gtk_enty_set_icon_tooltip_text().
	 * Since 2.16
	 * Params:
	 * iconPos =  the icon position
	 * tooltip =  the contents of the tooltip for the icon, or NULL
	 */
	public void setIconTooltipMarkup(GtkEntryIconPosition iconPos, string tooltip);
	
	/**
	 * Gets the contents of the tooltip on the icon at the specified
	 * position in entry.
	 * Since 2.16
	 * Params:
	 * iconPos =  the icon position
	 * Returns: the tooltip text, or NULL. Free the returned string with g_free() when done.
	 */
	public string getIconTooltipMarkup(GtkEntryIconPosition iconPos);

	/**
	 * Sets up the icon at the given position so that GTK+ will start a drag
	 * operation when the user clicks and drags the icon.
	 * To handle the drag operation, you need to connect to the usual
	 * "drag-data-get" (or possibly "drag-data-delete")
	 * signal, and use gtk_entry_get_current_icon_drag_source() in
	 * your signal handler to find out if the drag was started from
	 * an icon.
	 * By default, GTK+ uses the icon as the drag icon. You can use the
	 * "drag-begin" signal to set a different icon. Note that you
	 * have to use g_signal_connect_after() to ensure that your signal handler
	 * gets executed after the default handler.
	 * Since 2.16
	 * Params:
	 * iconPos =  icon position
	 * targetList =  the targets (data formats) in which the data can be provided
	 * actions =  a bitmask of the allowed drag actions
	 */
	public void setIconDragSource(GtkEntryIconPosition iconPos, GtkTargetList* targetList, GdkDragAction actions);
	
	/**
	 * Returns the index of the icon which is the source of the current
	 * DND operation, or -1.
	 * This function is meant to be used in a "drag-data-get"
	 * callback.
	 * Since 2.16
	 * Returns: index of the icon which is the source of the current DND operation, or -1.
	 */
	public int getCurrentIconDragSource();
}
