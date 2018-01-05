module gtkD.gtk.TextChildAnchor;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ListG;




/**
 * Description
 * You may wish to begin by reading the text widget
 * conceptual overview which gives an overview of all the objects and data
 * types related to the text widget and how they work together.
 */
public class TextChildAnchor
{
	
	/** the main Gtk struct */
	protected GtkTextChildAnchor* gtkTextChildAnchor;
	
	
	public GtkTextChildAnchor* getTextChildAnchorStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTextChildAnchor* gtkTextChildAnchor);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(TextChildAnchor)[] onBackspaceListeners;
	/**
	 * The ::backspace signal is a
	 * keybinding signal
	 * which gets emitted when the user asks for it.
	 * The default bindings for this signal are
	 * Backspace and Shift-Backspace.
	 */
	void addOnBackspace(void delegate(TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackBackspace(GtkTextView* textViewStruct, TextChildAnchor textChildAnchor);
	
	void delegate(TextChildAnchor)[] onCopyClipboardListeners;
	/**
	 * The ::copy-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to copy the selection to the clipboard.
	 * The default bindings for this signal are
	 * Ctrl-c and Ctrl-Insert.
	 */
	void addOnCopyClipboard(void delegate(TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCopyClipboard(GtkTextView* textViewStruct, TextChildAnchor textChildAnchor);
	
	void delegate(TextChildAnchor)[] onCutClipboardListeners;
	/**
	 * The ::cut-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to cut the selection to the clipboard.
	 * The default bindings for this signal are
	 * Ctrl-x and Shift-Delete.
	 */
	void addOnCutClipboard(void delegate(TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCutClipboard(GtkTextView* textViewStruct, TextChildAnchor textChildAnchor);
	
	void delegate(GtkDeleteType, gint, TextChildAnchor)[] onDeleteFromCursorListeners;
	/**
	 * The ::delete-from-cursor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates a text deletion.
	 * If the type is GTK_DELETE_CHARS, GTK+ deletes the selection
	 * if there is one, otherwise it deletes the requested number
	 * of characters.
	 * The default bindings for this signal are
	 * Delete for deleting a character, Ctrl-Delete for
	 * deleting a word and Ctrl-Backspace for deleting a word
	 * backwords.
	 */
	void addOnDeleteFromCursor(void delegate(GtkDeleteType, gint, TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDeleteFromCursor(GtkTextView* textViewStruct, GtkDeleteType type, gint count, TextChildAnchor textChildAnchor);
	
	void delegate(string, TextChildAnchor)[] onInsertAtCursorListeners;
	/**
	 * The ::insert-at-cursor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates the insertion of a
	 * fixed string at the cursor.
	 * This signal has no default bindings.
	 */
	void addOnInsertAtCursor(void delegate(string, TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackInsertAtCursor(GtkTextView* textViewStruct, gchar* str, TextChildAnchor textChildAnchor);
	
	void delegate(GtkMovementStep, gint, gboolean, TextChildAnchor)[] onMoveCursorListeners;
	/**
	 * The ::move-cursor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates a cursor movement.
	 * If the cursor is not visible in text_view, this signal causes
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
	 * PageUp/PageDown keys move vertically by pages
	 * Ctrl-PageUp/PageDown keys move horizontally by pages
	 */
	void addOnMoveCursor(void delegate(GtkMovementStep, gint, gboolean, TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveCursor(GtkTextView* textViewStruct, GtkMovementStep step, gint count, gboolean extendSelection, TextChildAnchor textChildAnchor);
	
	void delegate(GtkScrollStep, gint, TextChildAnchor)[] onMoveViewportListeners;
	/**
	 * The ::move-viewport signal is a
	 * keybinding signal
	 * which can be bound to key combinations to allow the user
	 * to move the viewport, i.e. change what part of the text view
	 * is visible in a containing scrolled window.
	 * There are no default bindings for this signal.
	 */
	void addOnMoveViewport(void delegate(GtkScrollStep, gint, TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveViewport(GtkTextView* textViewStruct, GtkScrollStep step, gint count, TextChildAnchor textChildAnchor);
	
	void delegate(gint, gboolean, TextChildAnchor)[] onPageHorizontallyListeners;
	/**
	 * The ::page-horizontally signal is a
	 * keybinding signal
	 * which can be bound to key combinations to allow the user
	 * to initiate horizontal cursor movement by pages.
	 * This signal should not be used anymore, instead use the
	 * "move-cursor" signal with the GTK_MOVEMENT_HORIZONTAL_PAGES
	 * granularity.
	 */
	void addOnPageHorizontally(void delegate(gint, gboolean, TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPageHorizontally(GtkTextView* textViewStruct, gint count, gboolean extendSelection, TextChildAnchor textChildAnchor);
	
	void delegate(TextChildAnchor)[] onPasteClipboardListeners;
	/**
	 * The ::paste-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to paste the contents of the clipboard
	 * into the text view.
	 * The default bindings for this signal are
	 * Ctrl-v and Shift-Insert.
	 */
	void addOnPasteClipboard(void delegate(TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPasteClipboard(GtkTextView* textViewStruct, TextChildAnchor textChildAnchor);
	
	void delegate(GtkMenu*, TextChildAnchor)[] onPopulatePopupListeners;
	/**
	 * The ::populate-popup signal gets emitted before showing the
	 * context menu of the text view.
	 * If you need to add items to the context menu, connect
	 * to this signal and append your menuitems to the menu.
	 */
	void addOnPopulatePopup(void delegate(GtkMenu*, TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPopulatePopup(GtkTextView* entryStruct, GtkMenu* menu, TextChildAnchor textChildAnchor);
	
	void delegate(gboolean, TextChildAnchor)[] onSelectAllListeners;
	/**
	 * The ::select-all signal is a
	 * keybinding signal
	 * which gets emitted to select or unselect the complete
	 * contents of the text view.
	 * The default bindings for this signal are Ctrl-a and Ctrl-/
	 * for selecting and Shift-Ctrl-a and Ctrl-\ for unselecting.
	 */
	void addOnSelectAll(void delegate(gboolean, TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelectAll(GtkTextView* textViewStruct, gboolean select, TextChildAnchor textChildAnchor);
	
	void delegate(TextChildAnchor)[] onSetAnchorListeners;
	/**
	 * The ::set-anchor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates setting the "anchor"
	 * mark. The "anchor" mark gets placed at the same position as the
	 * "insert" mark.
	 * This signal has no default bindings.
	 */
	void addOnSetAnchor(void delegate(TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSetAnchor(GtkTextView* textViewStruct, TextChildAnchor textChildAnchor);
	
	void delegate(GtkAdjustment*, GtkAdjustment*, TextChildAnchor)[] onSetScrollAdjustmentsListeners;
	/**
	 * Set the scroll adjustments for the text view. Usually scrolled containers
	 * like GtkScrolledWindow will emit this signal to connect two instances
	 * of GtkScrollbar to the scroll directions of the GtkTextView.
	 */
	void addOnSetScrollAdjustments(void delegate(GtkAdjustment*, GtkAdjustment*, TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSetScrollAdjustments(GtkTextView* horizontalStruct, GtkAdjustment* vertical, GtkAdjustment* arg2, TextChildAnchor textChildAnchor);
	
	void delegate(TextChildAnchor)[] onToggleCursorVisibleListeners;
	/**
	 * The ::toggle-cursor-visible signal is a
	 * keybinding signal
	 * which gets emitted to toggle the visibility of the cursor.
	 * The default binding for this signal is F7.
	 */
	void addOnToggleCursorVisible(void delegate(TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggleCursorVisible(GtkTextView* textViewStruct, TextChildAnchor textChildAnchor);
	
	void delegate(TextChildAnchor)[] onToggleOverwriteListeners;
	/**
	 * The ::toggle-overwrite signal is a
	 * keybinding signal
	 * which gets emitted to toggle the overwrite mode of the text view.
	 * The default bindings for this signal is Insert.
	 * See Also
	 * GtkTextBuffer, GtkTextIter
	 */
	void addOnToggleOverwrite(void delegate(TextChildAnchor) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggleOverwrite(GtkTextView* textViewStruct, TextChildAnchor textChildAnchor);
	
	
	/**
	 * Creates a new GtkTextChildAnchor. Usually you would then insert
	 * it into a GtkTextBuffer with gtk_text_buffer_insert_child_anchor().
	 * To perform the creation and insertion in one step, use the
	 * convenience function gtk_text_buffer_create_child_anchor().
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Gets a list of all widgets anchored at this child anchor.
	 * The returned list should be freed with g_list_free().
	 * Returns: list of widgets anchored at anchor
	 */
	public ListG getWidgets();
	
	/**
	 * Determines whether a child anchor has been deleted from
	 * the buffer. Keep in mind that the child anchor will be
	 * unreferenced when removed from the buffer, so you need to
	 * hold your own reference (with g_object_ref()) if you plan
	 * to use this function — otherwise all deleted child anchors
	 * will also be finalized.
	 * Returns: TRUE if the child anchor has been deleted from its buffer
	 */
	public int getDeleted();
}
