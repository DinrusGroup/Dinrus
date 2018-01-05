module gtkD.gtk.EntryBuffer;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The GtkEntryBuffer class contains the actual text displayed in a
 * GtkEntry widget.
 * A single GtkEntryBuffer object can be shared by multiple GtkEntry
 * widgets which will then share the same text content, but not the cursor
 * position, visibility attributes, icon etc.
 * GtkEntryBuffer may be derived from. Such a derived class might allow
 * text to be stored in an alternate location, such as non-pageable memory,
 * useful in the case of important passwords. Or a derived class could
 * integrate with an application's concept of undo/redo.
 */
public class EntryBuffer : ObjectG
{

	/** the main Gtk struct */
	protected GtkEntryBuffer* gtkEntryBuffer;


	public GtkEntryBuffer* getEntryBufferStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkEntryBuffer* gtkEntryBuffer);

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(guint, guint, EntryBuffer)[] onDeletedTextListeners;
	/**
	 */
	void addOnDeletedText(void delegate(guint, guint, EntryBuffer) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDeletedText(GtkEntryBuffer* entrybufferStruct, guint arg1, guint arg2, EntryBuffer entryBuffer);

	void delegate(guint, string, guint, EntryBuffer)[] onInsertedTextListeners;
	/**
	 */
	void addOnInsertedText(void delegate(guint, string, guint, EntryBuffer) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackInsertedText(GtkEntryBuffer* entrybufferStruct, guint arg1, gchar* arg2, guint arg3, EntryBuffer entryBuffer);


	/**
	 * Create a new GtkEntryBuffer object.
	 * Optionally, specify initial text to set in the buffer.
	 * Since 2.18
	 * Params:
	 * initialChars =  initial buffer text, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (char[] initialChars);

	/**
	 * Retrieves the contents of the buffer.
	 * The memory pointer returned by this call will not change
	 * unless this object emits a signal, or is finalized.
	 * Since 2.18
	 * Returns: a pointer to the contents of the widget as a string. This string points to internally allocated storage in the buffer and must not be freed, modified or stored.
	 */
	public string getText();

	/**
	 * Sets the text in the buffer.
	 * This is roughly equivalent to calling gtk_entry_buffer_delete_text()
	 * and gtk_entry_buffer_insert_text().
	 * Note that n_chars is in characters, not in bytes.
	 * Since 2.18
	 * Params:
	 * chars =  the new text
	 */
	public void setText(char[] chars);

	/**
	 * Retrieves the length in bytes of the buffer.
	 * See gtk_entry_buffer_get_length().
	 * Since 2.18
	 * Returns: The byte length of the buffer.
	 */
	public uint getBytes();

	/**
	 * Retrieves the length in characters of the buffer.
	 * Since 2.18
	 * Returns: The number of characters in the buffer.
	 */
	public uint getLength();

	/**
	 * Retrieves the maximum allowed length of the text in
	 * buffer. See gtk_entry_buffer_set_max_length().
	 * Since 2.18
	 * Returns: the maximum allowed number of characters in GtkEntryBuffer, or 0 if there is no maximum.
	 */
	public int getMaxLength();

	/**
	 * Sets the maximum allowed length of the contents of the buffer. If
	 * the current contents are longer than the given length, then they
	 * will be truncated to fit.
	 * Since 2.18
	 * Params:
	 * maxLength =  the maximum length of the entry buffer, or 0 for no maximum.
	 *  (other than the maximum length of entries.) The value passed in will
	 *  be clamped to the range 0-65536.
	 */
	public void setMaxLength(int maxLength);

	/**
	 * Inserts n_chars characters of chars into the contents of the
	 * buffer, at position position.
	 * If n_chars is negative, then characters from chars will be inserted
	 * until a null-terminator is found. If position or n_chars are out of
	 * bounds, or the maximum buffer text length is exceeded, then they are
	 * coerced to sane values.
	 * Note that the position and length are in characters, not in bytes.
	 * Since 2.18
	 * Params:
	 * position =  the position at which to insert text.
	 * chars =  the text to insert into the buffer.
	 * Returns: The number of characters actually inserted.
	 */
	public uint insertText(uint position, char[] chars);

	/**
	 * Deletes a sequence of characters from the buffer. n_chars characters are
	 * deleted starting at position. If n_chars is negative, then all characters
	 * until the end of the text are deleted.
	 * If position or n_chars are out of bounds, then they are coerced to sane
	 * values.
	 * Note that the positions are specified in characters, not bytes.
	 * Since 2.18
	 * Params:
	 * position =  position at which to delete text
	 * nChars =  number of characters to delete
	 * Returns: The number of characters deleted.
	 */
	public uint deleteText(uint position, int nChars);

	/**
	 * Used when subclassing GtkEntryBuffer
	 * Since 2.18
	 * Params:
	 * position =  position at which text was deleted
	 * nChars =  number of characters deleted
	 */
	public void emitDeletedText(uint position, uint nChars);

	/**
	 * Used when subclassing GtkEntryBuffer
	 * Since 2.18
	 * Params:
	 * position =  position at which text was inserted
	 * chars =  text that was inserted
	 */
	public void emitInsertedText(uint position, char[] chars);
}
