module gtkD.gtk.TextView;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.TextBuffer;
private import gtkD.gtk.TextMark;
private import gtkD.gtk.TextIter;
private import gtkD.gdk.Rectangle;
private import gtkD.gtk.Widget;
private import gtkD.pango.PgTabArray;
private import gtkD.gtk.TextAttributes;
private import gtkD.gdk.Window;
private import gtkD.gtk.TextChildAnchor;
private import gtkD.glib.ListG;



private import gtkD.gtk.Container;

/**
 * Description
 * You may wish to begin by reading the text widget
 * conceptual overview which gives an overview of all the objects and data
 * types related to the text widget and how they work together.
 */
public class TextView : Container
{
	
	/** the main Gtk struct */
	protected GtkTextView* gtkTextView;
	
	
	public GtkTextView* getTextViewStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTextView* gtkTextView);
	
	/**
	 * Get the text line at the pixel y
	 */
	string getLineTextAt(gint y);
	
	/**
	 * Simply appends some on the cursor position
	 * Params:
	 *  text = the text to append
	 */
	void insertText(string text);
	
	/**
	 * Simply appends some text to this view
	 * Params:
	 *  text = the text to append
	 */
	void appendText(string text, bool ensureVisible=true);
	
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(TextView)[] onBackspaceListeners;
	/**
	 * The ::backspace signal is a
	 * keybinding signal
	 * which gets emitted when the user asks for it.
	 * The default bindings for this signal are
	 * Backspace and Shift-Backspace.
	 */
	void addOnBackspace(void delegate(TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackBackspace(GtkTextView* textViewStruct, TextView textView);
	
	void delegate(TextView)[] onCopyClipboardListeners;
	/**
	 * The ::copy-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to copy the selection to the clipboard.
	 * The default bindings for this signal are
	 * Ctrl-c and Ctrl-Insert.
	 */
	void addOnCopyClipboard(void delegate(TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCopyClipboard(GtkTextView* textViewStruct, TextView textView);
	
	void delegate(TextView)[] onCutClipboardListeners;
	/**
	 * The ::cut-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to cut the selection to the clipboard.
	 * The default bindings for this signal are
	 * Ctrl-x and Shift-Delete.
	 */
	void addOnCutClipboard(void delegate(TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCutClipboard(GtkTextView* textViewStruct, TextView textView);
	
	void delegate(GtkDeleteType, gint, TextView)[] onDeleteFromCursorListeners;
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
	void addOnDeleteFromCursor(void delegate(GtkDeleteType, gint, TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDeleteFromCursor(GtkTextView* textViewStruct, GtkDeleteType type, gint count, TextView textView);
	
	void delegate(string, TextView)[] onInsertAtCursorListeners;
	/**
	 * The ::insert-at-cursor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates the insertion of a
	 * fixed string at the cursor.
	 * This signal has no default bindings.
	 */
	void addOnInsertAtCursor(void delegate(string, TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackInsertAtCursor(GtkTextView* textViewStruct, gchar* str, TextView textView);
	
	void delegate(GtkMovementStep, gint, gboolean, TextView)[] onMoveCursorListeners;
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
	void addOnMoveCursor(void delegate(GtkMovementStep, gint, gboolean, TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveCursor(GtkTextView* textViewStruct, GtkMovementStep step, gint count, gboolean extendSelection, TextView textView);
	
	void delegate(GtkScrollStep, gint, TextView)[] onMoveViewportListeners;
	/**
	 * The ::move-viewport signal is a
	 * keybinding signal
	 * which can be bound to key combinations to allow the user
	 * to move the viewport, i.e. change what part of the text view
	 * is visible in a containing scrolled window.
	 * There are no default bindings for this signal.
	 */
	void addOnMoveViewport(void delegate(GtkScrollStep, gint, TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveViewport(GtkTextView* textViewStruct, GtkScrollStep step, gint count, TextView textView);
	
	void delegate(gint, gboolean, TextView)[] onPageHorizontallyListeners;
	/**
	 * The ::page-horizontally signal is a
	 * keybinding signal
	 * which can be bound to key combinations to allow the user
	 * to initiate horizontal cursor movement by pages.
	 * This signal should not be used anymore, instead use the
	 * "move-cursor" signal with the GTK_MOVEMENT_HORIZONTAL_PAGES
	 * granularity.
	 */
	void addOnPageHorizontally(void delegate(gint, gboolean, TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPageHorizontally(GtkTextView* textViewStruct, gint count, gboolean extendSelection, TextView textView);
	
	void delegate(TextView)[] onPasteClipboardListeners;
	/**
	 * The ::paste-clipboard signal is a
	 * keybinding signal
	 * which gets emitted to paste the contents of the clipboard
	 * into the text view.
	 * The default bindings for this signal are
	 * Ctrl-v and Shift-Insert.
	 */
	void addOnPasteClipboard(void delegate(TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPasteClipboard(GtkTextView* textViewStruct, TextView textView);
	
	void delegate(GtkMenu*, TextView)[] onPopulatePopupListeners;
	/**
	 * The ::populate-popup signal gets emitted before showing the
	 * context menu of the text view.
	 * If you need to add items to the context menu, connect
	 * to this signal and append your menuitems to the menu.
	 */
	void addOnPopulatePopup(void delegate(GtkMenu*, TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPopulatePopup(GtkTextView* entryStruct, GtkMenu* menu, TextView textView);
	
	void delegate(gboolean, TextView)[] onSelectAllListeners;
	/**
	 * The ::select-all signal is a
	 * keybinding signal
	 * which gets emitted to select or unselect the complete
	 * contents of the text view.
	 * The default bindings for this signal are Ctrl-a and Ctrl-/
	 * for selecting and Shift-Ctrl-a and Ctrl-\ for unselecting.
	 */
	void addOnSelectAll(void delegate(gboolean, TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelectAll(GtkTextView* textViewStruct, gboolean select, TextView textView);
	
	void delegate(TextView)[] onSetAnchorListeners;
	/**
	 * The ::set-anchor signal is a
	 * keybinding signal
	 * which gets emitted when the user initiates setting the "anchor"
	 * mark. The "anchor" mark gets placed at the same position as the
	 * "insert" mark.
	 * This signal has no default bindings.
	 */
	void addOnSetAnchor(void delegate(TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSetAnchor(GtkTextView* textViewStruct, TextView textView);
	
	void delegate(GtkAdjustment*, GtkAdjustment*, TextView)[] onSetScrollAdjustmentsListeners;
	/**
	 * Set the scroll adjustments for the text view. Usually scrolled containers
	 * like GtkScrolledWindow will emit this signal to connect two instances
	 * of GtkScrollbar to the scroll directions of the GtkTextView.
	 */
	void addOnSetScrollAdjustments(void delegate(GtkAdjustment*, GtkAdjustment*, TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSetScrollAdjustments(GtkTextView* horizontalStruct, GtkAdjustment* vertical, GtkAdjustment* arg2, TextView textView);
	
	void delegate(TextView)[] onToggleCursorVisibleListeners;
	/**
	 * The ::toggle-cursor-visible signal is a
	 * keybinding signal
	 * which gets emitted to toggle the visibility of the cursor.
	 * The default binding for this signal is F7.
	 */
	void addOnToggleCursorVisible(void delegate(TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggleCursorVisible(GtkTextView* textViewStruct, TextView textView);
	
	void delegate(TextView)[] onToggleOverwriteListeners;
	/**
	 * The ::toggle-overwrite signal is a
	 * keybinding signal
	 * which gets emitted to toggle the overwrite mode of the text view.
	 * The default bindings for this signal is Insert.
	 * See Also
	 * GtkTextBuffer, GtkTextIter
	 */
	void addOnToggleOverwrite(void delegate(TextView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackToggleOverwrite(GtkTextView* textViewStruct, TextView textView);
	
	
	/**
	 * Creates a new GtkTextView. If you don't call gtk_text_view_set_buffer()
	 * before using the text view, an empty default buffer will be created
	 * for you. Get the buffer with gtk_text_view_get_buffer(). If you want
	 * to specify your own buffer, consider gtk_text_view_new_with_buffer().
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a new GtkTextView widget displaying the buffer
	 * buffer. One buffer can be shared among many widgets.
	 * buffer may be NULL to create a default buffer, in which case
	 * this function is equivalent to gtk_text_view_new(). The
	 * text view adds its own reference count to the buffer; it does not
	 * take over an existing reference.
	 * Params:
	 * buffer =  a GtkTextBuffer
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (TextBuffer buffer);
	
	/**
	 * Sets buffer as the buffer being displayed by text_view. The previous
	 * buffer displayed by the text view is unreferenced, and a reference is
	 * added to buffer. If you owned a reference to buffer before passing it
	 * to this function, you must remove that reference yourself; GtkTextView
	 * will not "adopt" it.
	 * Params:
	 * buffer =  a GtkTextBuffer
	 */
	public void setBuffer(TextBuffer buffer);
	
	/**
	 * Returns the GtkTextBuffer being displayed by this text view.
	 * The reference count on the buffer is not incremented; the caller
	 * of this function won't own a new reference.
	 * Returns: a GtkTextBuffer
	 */
	public TextBuffer getBuffer();
	
	/**
	 * Scrolls text_view so that mark is on the screen in the position
	 * indicated by xalign and yalign. An alignment of 0.0 indicates
	 * left or top, 1.0 indicates right or bottom, 0.5 means center.
	 * If use_align is FALSE, the text scrolls the minimal distance to
	 * get the mark onscreen, possibly not scrolling at all. The effective
	 * screen for purposes of this function is reduced by a margin of size
	 * within_margin.
	 * Params:
	 * mark =  a GtkTextMark
	 * withinMargin =  margin as a [0.0,0.5) fraction of screen size
	 * useAlign =  whether to use alignment arguments (if FALSE, just
	 *  get the mark onscreen)
	 * xalign =  horizontal alignment of mark within visible area
	 * yalign =  vertical alignment of mark within visible area
	 */
	public void scrollToMark(TextMark mark, double withinMargin, int useAlign, double xalign, double yalign);
	
	/**
	 * Scrolls text_view so that iter is on the screen in the position
	 * indicated by xalign and yalign. An alignment of 0.0 indicates
	 * left or top, 1.0 indicates right or bottom, 0.5 means center.
	 * If use_align is FALSE, the text scrolls the minimal distance to
	 * get the mark onscreen, possibly not scrolling at all. The effective
	 * screen for purposes of this function is reduced by a margin of size
	 * within_margin.
	 * Note that this function uses the currently-computed height of the
	 * lines in the text buffer. Line heights are computed in an idle
	 * handler; so this function may not have the desired effect if it's
	 * called before the height computations. To avoid oddness, consider
	 * using gtk_text_view_scroll_to_mark() which saves a point to be
	 * scrolled to after line validation.
	 * Params:
	 * iter =  a GtkTextIter
	 * withinMargin =  margin as a [0.0,0.5) fraction of screen size
	 * useAlign =  whether to use alignment arguments (if FALSE,
	 *  just get the mark onscreen)
	 * xalign =  horizontal alignment of mark within visible area
	 * yalign =  vertical alignment of mark within visible area
	 * Returns: TRUE if scrolling occurred
	 */
	public int scrollToIter(TextIter iter, double withinMargin, int useAlign, double xalign, double yalign);
	
	/**
	 * Scrolls text_view the minimum distance such that mark is contained
	 * within the visible area of the widget.
	 * Params:
	 * mark =  a mark in the buffer for text_view
	 */
	public void scrollMarkOnscreen(TextMark mark);
	
	/**
	 * Moves a mark within the buffer so that it's
	 * located within the currently-visible text area.
	 * Params:
	 * mark =  a GtkTextMark
	 * Returns: TRUE if the mark moved (wasn't already onscreen)
	 */
	public int moveMarkOnscreen(TextMark mark);
	
	/**
	 * Moves the cursor to the currently visible region of the
	 * buffer, it it isn't there already.
	 * Returns: TRUE if the cursor had to be moved.
	 */
	public int placeCursorOnscreen();
	
	/**
	 * Fills visible_rect with the currently-visible
	 * region of the buffer, in buffer coordinates. Convert to window coordinates
	 * with gtk_text_view_buffer_to_window_coords().
	 * Params:
	 * visibleRect =  rectangle to fill
	 */
	public void getVisibleRect(Rectangle visibleRect);
	
	/**
	 * Gets a rectangle which roughly contains the character at iter.
	 * The rectangle position is in buffer coordinates; use
	 * gtk_text_view_buffer_to_window_coords() to convert these
	 * coordinates to coordinates for one of the windows in the text view.
	 * Params:
	 * iter =  a GtkTextIter
	 * location =  bounds of the character at iter
	 */
	public void getIterLocation(TextIter iter, Rectangle location);
	
	/**
	 * Gets the GtkTextIter at the start of the line containing
	 * the coordinate y. y is in buffer coordinates, convert from
	 * window coordinates with gtk_text_view_window_to_buffer_coords().
	 * If non-NULL, line_top will be filled with the coordinate of the top
	 * edge of the line.
	 * Params:
	 * targetIter =  a GtkTextIter
	 * y =  a y coordinate
	 * lineTop =  return location for top coordinate of the line
	 */
	public void getLineAtY(TextIter targetIter, int y, out int lineTop);

	/**
	 * Gets the y coordinate of the top of the line containing iter,
	 * and the height of the line. The coordinate is a buffer coordinate;
	 * convert to window coordinates with gtk_text_view_buffer_to_window_coords().
	 * Params:
	 * iter =  a GtkTextIter
	 * y =  return location for a y coordinate
	 * height =  return location for a height
	 */
	public void getLineYrange(TextIter iter, out int y, out int height);
	
	/**
	 * Retrieves the iterator at buffer coordinates x and y. Buffer
	 * coordinates are coordinates for the entire buffer, not just the
	 * currently-displayed portion. If you have coordinates from an
	 * event, you have to convert those to buffer coordinates with
	 * gtk_text_view_window_to_buffer_coords().
	 * Params:
	 * iter =  a GtkTextIter
	 * x =  x position, in buffer coordinates
	 * y =  y position, in buffer coordinates
	 */
	public void getIterAtLocation(TextIter iter, int x, int y);
	
	/**
	 * Retrieves the iterator pointing to the character at buffer
	 * coordinates x and y. Buffer coordinates are coordinates for
	 * the entire buffer, not just the currently-displayed portion.
	 * If you have coordinates from an event, you have to convert
	 * those to buffer coordinates with
	 * gtk_text_view_window_to_buffer_coords().
	 * Note that this is different from gtk_text_view_get_iter_at_location(),
	 * which returns cursor locations, i.e. positions between
	 * characters.
	 * Since 2.6
	 * Params:
	 * iter =  a GtkTextIter
	 * trailing =  if non-NULL, location to store an integer indicating where
	 *  in the grapheme the user clicked. It will either be
	 *  zero, or the number of characters in the grapheme.
	 *  0 represents the trailing edge of the grapheme.
	 * x =  x position, in buffer coordinates
	 * y =  y position, in buffer coordinates
	 */
	public void getIterAtPosition(TextIter iter, out int trailing, int x, int y);
	
	/**
	 * Converts coordinate (buffer_x, buffer_y) to coordinates for the window
	 * win, and stores the result in (window_x, window_y).
	 * Note that you can't convert coordinates for a nonexisting window (see
	 * gtk_text_view_set_border_window_size()).
	 * Params:
	 * win =  a GtkTextWindowType except GTK_TEXT_WINDOW_PRIVATE
	 * bufferX =  buffer x coordinate
	 * bufferY =  buffer y coordinate
	 * windowX =  window x coordinate return location
	 * windowY =  window y coordinate return location
	 */
	public void bufferToWindowCoords(GtkTextWindowType win, int bufferX, int bufferY, out int windowX, out int windowY);
	
	/**
	 * Converts coordinates on the window identified by win to buffer
	 * coordinates, storing the result in (buffer_x,buffer_y).
	 * Note that you can't convert coordinates for a nonexisting window (see
	 * gtk_text_view_set_border_window_size()).
	 * Params:
	 * win =  a GtkTextWindowType except GTK_TEXT_WINDOW_PRIVATE
	 * windowX =  window x coordinate
	 * windowY =  window y coordinate
	 * bufferX =  buffer x coordinate return location
	 * bufferY =  buffer y coordinate return location
	 */
	public void windowToBufferCoords(GtkTextWindowType win, int windowX, int windowY, out int bufferX, out int bufferY);
	
	/**
	 * Retrieves the GdkWindow corresponding to an area of the text view;
	 * possible windows include the overall widget window, child windows
	 * on the left, right, top, bottom, and the window that displays the
	 * text buffer. Windows are NULL and nonexistent if their width or
	 * height is 0, and are nonexistent before the widget has been
	 * realized.
	 * Params:
	 * win =  window to get
	 * Returns: a GdkWindow, or NULL
	 */
	public Window getWindow(GtkTextWindowType win);
	
	/**
	 * Usually used to find out which window an event corresponds to.
	 * If you connect to an event signal on text_view, this function
	 * should be called on event->window to
	 * see which window it was.
	 * Params:
	 * window =  a window type
	 * Returns: the window type.
	 */
	public GtkTextWindowType getWindowType(Window window);
	
	/**
	 * Sets the width of GTK_TEXT_WINDOW_LEFT or GTK_TEXT_WINDOW_RIGHT,
	 * or the height of GTK_TEXT_WINDOW_TOP or GTK_TEXT_WINDOW_BOTTOM.
	 * Automatically destroys the corresponding window if the size is set
	 * to 0, and creates the window if the size is set to non-zero. This
	 * function can only be used for the "border windows," it doesn't work
	 * with GTK_TEXT_WINDOW_WIDGET, GTK_TEXT_WINDOW_TEXT, or
	 * GTK_TEXT_WINDOW_PRIVATE.
	 * Params:
	 * type =  window to affect
	 * size =  width or height of the window
	 */
	public void setBorderWindowSize(GtkTextWindowType type, int size);
	
	/**
	 * Gets the width of the specified border window. See
	 * gtk_text_view_set_border_window_size().
	 * Params:
	 * type =  window to return size from
	 * Returns: width of window
	 */
	public int getBorderWindowSize(GtkTextWindowType type);
	
	/**
	 * Moves the given iter forward by one display (wrapped) line.
	 * A display line is different from a paragraph. Paragraphs are
	 * separated by newlines or other paragraph separator characters.
	 * Display lines are created by line-wrapping a paragraph. If
	 * wrapping is turned off, display lines and paragraphs will be the
	 * same. Display lines are divided differently for each view, since
	 * they depend on the view's width; paragraphs are the same in all
	 * views, since they depend on the contents of the GtkTextBuffer.
	 * Params:
	 * iter =  a GtkTextIter
	 * Returns: TRUE if iter was moved and is not on the end iterator
	 */
	public int forwardDisplayLine(TextIter iter);
	
	/**
	 * Moves the given iter backward by one display (wrapped) line.
	 * A display line is different from a paragraph. Paragraphs are
	 * separated by newlines or other paragraph separator characters.
	 * Display lines are created by line-wrapping a paragraph. If
	 * wrapping is turned off, display lines and paragraphs will be the
	 * same. Display lines are divided differently for each view, since
	 * they depend on the view's width; paragraphs are the same in all
	 * views, since they depend on the contents of the GtkTextBuffer.
	 * Params:
	 * iter =  a GtkTextIter
	 * Returns: TRUE if iter was moved and is not on the end iterator
	 */
	public int backwardDisplayLine(TextIter iter);
	
	/**
	 * Moves the given iter forward to the next display line end.
	 * A display line is different from a paragraph. Paragraphs are
	 * separated by newlines or other paragraph separator characters.
	 * Display lines are created by line-wrapping a paragraph. If
	 * wrapping is turned off, display lines and paragraphs will be the
	 * same. Display lines are divided differently for each view, since
	 * they depend on the view's width; paragraphs are the same in all
	 * views, since they depend on the contents of the GtkTextBuffer.
	 * Params:
	 * iter =  a GtkTextIter
	 * Returns: TRUE if iter was moved and is not on the end iterator
	 */
	public int forwardDisplayLineEnd(TextIter iter);
	
	/**
	 * Moves the given iter backward to the next display line start.
	 * A display line is different from a paragraph. Paragraphs are
	 * separated by newlines or other paragraph separator characters.
	 * Display lines are created by line-wrapping a paragraph. If
	 * wrapping is turned off, display lines and paragraphs will be the
	 * same. Display lines are divided differently for each view, since
	 * they depend on the view's width; paragraphs are the same in all
	 * views, since they depend on the contents of the GtkTextBuffer.
	 * Params:
	 * iter =  a GtkTextIter
	 * Returns: TRUE if iter was moved and is not on the end iterator
	 */
	public int backwardDisplayLineStart(TextIter iter);
	
	/**
	 * Determines whether iter is at the start of a display line.
	 * See gtk_text_view_forward_display_line() for an explanation of
	 * display lines vs. paragraphs.
	 * Params:
	 * iter =  a GtkTextIter
	 * Returns: TRUE if iter begins a wrapped line
	 */
	public int startsDisplayLine(TextIter iter);
	
	/**
	 * Move the iterator a given number of characters visually, treating
	 * it as the strong cursor position. If count is positive, then the
	 * new strong cursor position will be count positions to the right of
	 * the old cursor position. If count is negative then the new strong
	 * cursor position will be count positions to the left of the old
	 * cursor position.
	 * In the presence of bi-directional text, the correspondence
	 * between logical and visual order will depend on the direction
	 * of the current run, and there may be jumps when the cursor
	 * is moved off of the end of a run.
	 * Params:
	 * iter =  a GtkTextIter
	 * count =  number of characters to move (negative moves left,
	 *  positive moves right)
	 * Returns: TRUE if iter moved and is not on the end iterator
	 */
	public int moveVisually(TextIter iter, int count);
	
	/**
	 * Adds a child widget in the text buffer, at the given anchor.
	 * Params:
	 * child =  a GtkWidget
	 * anchor =  a GtkTextChildAnchor in the GtkTextBuffer for text_view
	 */
	public void addChildAtAnchor(Widget child, TextChildAnchor anchor);
	
	/**
	 * Adds a child at fixed coordinates in one of the text widget's
	 * windows. The window must have nonzero size (see
	 * gtk_text_view_set_border_window_size()). Note that the child
	 * coordinates are given relative to the GdkWindow in question, and
	 * that these coordinates have no sane relationship to scrolling. When
	 * placing a child in GTK_TEXT_WINDOW_WIDGET, scrolling is
	 * irrelevant, the child floats above all scrollable areas. But when
	 * placing a child in one of the scrollable windows (border windows or
	 * text window), you'll need to compute the child's correct position
	 * in buffer coordinates any time scrolling occurs or buffer changes
	 * occur, and then call gtk_text_view_move_child() to update the
	 * child's position. Unfortunately there's no good way to detect that
	 * scrolling has occurred, using the current API; a possible hack
	 * would be to update all child positions when the scroll adjustments
	 * change or the text buffer changes. See bug 64518 on
	 * bugzilla.gnome.org for status of fixing this issue.
	 * Params:
	 * child =  a GtkWidget
	 * whichWindow =  which window the child should appear in
	 * xpos =  X position of child in window coordinates
	 * ypos =  Y position of child in window coordinates
	 */
	public void addChildInWindow(Widget child, GtkTextWindowType whichWindow, int xpos, int ypos);

	/**
	 * Updates the position of a child, as for gtk_text_view_add_child_in_window().
	 * Params:
	 * child =  child widget already added to the text view
	 * xpos =  new X position in window coordinates
	 * ypos =  new Y position in window coordinates
	 */
	public void moveChild(Widget child, int xpos, int ypos);
	
	/**
	 * Sets the line wrapping for the view.
	 * Params:
	 * wrapMode =  a GtkWrapMode
	 */
	public void setWrapMode(GtkWrapMode wrapMode);
	
	/**
	 * Gets the line wrapping for the view.
	 * Returns: the line wrap setting
	 */
	public GtkWrapMode getWrapMode();
	
	/**
	 * Sets the default editability of the GtkTextView. You can override
	 * this default setting with tags in the buffer, using the "editable"
	 * attribute of tags.
	 * Params:
	 * setting =  whether it's editable
	 */
	public void setEditable(int setting);
	
	/**
	 * Returns the default editability of the GtkTextView. Tags in the
	 * buffer may override this setting for some ranges of text.
	 * Returns: whether text is editable by default
	 */
	public int getEditable();
	
	/**
	 * Toggles whether the insertion point is displayed. A buffer with no editable
	 * text probably shouldn't have a visible cursor, so you may want to turn
	 * the cursor off.
	 * Params:
	 * setting =  whether to show the insertion cursor
	 */
	public void setCursorVisible(int setting);
	
	/**
	 * Find out whether the cursor is being displayed.
	 * Returns: whether the insertion mark is visible
	 */
	public int getCursorVisible();
	
	/**
	 * Changes the GtkTextView overwrite mode.
	 * Since 2.4
	 * Params:
	 * overwrite =  TRUE to turn on overwrite mode, FALSE to turn it off
	 */
	public void setOverwrite(int overwrite);
	
	/**
	 * Returns whether the GtkTextView is in overwrite mode or not.
	 * Since 2.4
	 * Returns: whether text_view is in overwrite mode or not.
	 */
	public int getOverwrite();
	
	/**
	 * Sets the default number of blank pixels above paragraphs in text_view.
	 * Tags in the buffer for text_view may override the defaults.
	 * Params:
	 * pixelsAboveLines =  pixels above paragraphs
	 */
	public void setPixelsAboveLines(int pixelsAboveLines);
	
	/**
	 * Gets the default number of pixels to put above paragraphs.
	 * Returns: default number of pixels above paragraphs
	 */
	public int getPixelsAboveLines();
	
	/**
	 * Sets the default number of pixels of blank space
	 * to put below paragraphs in text_view. May be overridden
	 * by tags applied to text_view's buffer.
	 * Params:
	 * pixelsBelowLines =  pixels below paragraphs
	 */
	public void setPixelsBelowLines(int pixelsBelowLines);

	/**
	 * Gets the value set by gtk_text_view_set_pixels_below_lines().
	 * Returns: default number of blank pixels below paragraphs
	 */
	public int getPixelsBelowLines();
	
	/**
	 * Sets the default number of pixels of blank space to leave between
	 * display/wrapped lines within a paragraph. May be overridden by
	 * tags in text_view's buffer.
	 * Params:
	 * pixelsInsideWrap =  default number of pixels between wrapped lines
	 */
	public void setPixelsInsideWrap(int pixelsInsideWrap);
	
	/**
	 * Gets the value set by gtk_text_view_set_pixels_inside_wrap().
	 * Returns: default number of pixels of blank space between wrapped lines
	 */
	public int getPixelsInsideWrap();
	
	/**
	 * Sets the default justification of text in text_view.
	 * Tags in the view's buffer may override the default.
	 * Params:
	 * justification =  justification
	 */
	public void setJustification(GtkJustification justification);
	
	/**
	 * Gets the default justification of paragraphs in text_view.
	 * Tags in the buffer may override the default.
	 * Returns: default justification
	 */
	public GtkJustification getJustification();
	
	/**
	 * Sets the default left margin for text in text_view.
	 * Tags in the buffer may override the default.
	 * Params:
	 * leftMargin =  left margin in pixels
	 */
	public void setLeftMargin(int leftMargin);
	
	/**
	 * Gets the default left margin size of paragraphs in the text_view.
	 * Tags in the buffer may override the default.
	 * Returns: left margin in pixels
	 */
	public int getLeftMargin();
	
	/**
	 * Sets the default right margin for text in the text view.
	 * Tags in the buffer may override the default.
	 * Params:
	 * rightMargin =  right margin in pixels
	 */
	public void setRightMargin(int rightMargin);
	
	/**
	 * Gets the default right margin for text in text_view. Tags
	 * in the buffer may override the default.
	 * Returns: right margin in pixels
	 */
	public int getRightMargin();

	/**
	 * Sets the default indentation for paragraphs in text_view.
	 * Tags in the buffer may override the default.
	 * Params:
	 * indent =  indentation in pixels
	 */
	public void setIndent(int indent);
	
	/**
	 * Gets the default indentation of paragraphs in text_view.
	 * Tags in the view's buffer may override the default.
	 * The indentation may be negative.
	 * Returns: number of pixels of indentation
	 */
	public int getIndent();
	
	/**
	 * Sets the default tab stops for paragraphs in text_view.
	 * Tags in the buffer may override the default.
	 * Params:
	 * tabs =  tabs as a PangoTabArray
	 */
	public void setTabs(PgTabArray tabs);
	
	/**
	 * Gets the default tabs for text_view. Tags in the buffer may
	 * override the defaults. The returned array will be NULL if
	 * "standard" (8-space) tabs are used. Free the return value
	 * with pango_tab_array_free().
	 * Returns: copy of default tab array, or NULL if "standard"  tabs are used; must be freed with pango_tab_array_free().
	 */
	public PgTabArray getTabs();
	
	/**
	 * Sets the behavior of the text widget when the Tab key is pressed.
	 * If accepts_tab is TRUE, a tab character is inserted. If accepts_tab
	 * is FALSE the keyboard focus is moved to the next widget in the focus
	 * chain.
	 * Since 2.4
	 * Params:
	 * acceptsTab =  TRUE if pressing the Tab key should insert a tab
	 *  character, FALSE, if pressing the Tab key should move the
	 *  keyboard focus.
	 */
	public void setAcceptsTab(int acceptsTab);

	/**
	 * Returns whether pressing the Tab key inserts a tab characters.
	 * gtk_text_view_set_accepts_tab().
	 * Since 2.4
	 * Returns: TRUE if pressing the Tab key inserts a tab character,  FALSE if pressing the Tab key moves the keyboard focus.
	 */
	public int getAcceptsTab();
	
	/**
	 * Obtains a copy of the default text attributes. These are the
	 * attributes used for text unless a tag overrides them.
	 * You'd typically pass the default attributes in to
	 * gtk_text_iter_get_attributes() in order to get the
	 * attributes in effect at a given text position.
	 * The return value is a copy owned by the caller of this function,
	 * and should be freed.
	 * Returns: a new GtkTextAttributes
	 */
	public TextAttributes getDefaultAttributes();
}
