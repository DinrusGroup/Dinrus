module gtkD.gtk.EntryCompletion;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.TreeModel;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.CellLayoutIF;
private import gtkD.gtk.CellLayoutT;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GtkEntryCompletion is an auxiliary object to be used in conjunction with
 * GtkEntry to provide the completion functionality. It implements the
 * GtkCellLayout interface, to allow the user to add extra cells to the
 * GtkTreeView with completion matches.
 * "Completion functionality" means that when the user modifies the text
 * in the entry, GtkEntryCompletion checks which rows in the model match
 * the current content of the entry, and displays a list of matches.
 * By default, the matching is done by comparing the entry text
 * case-insensitively against the text column of the model (see
 * gtk_entry_completion_set_text_column()), but this can be overridden with
 * a custom match function (see gtk_entry_completion_set_match_func()).
 * When the user selects a completion, the content of the entry is updated.
 * By default, the content of the entry is replaced by the text column of the
 * model, but this can be overridden by connecting to the ::match-selected signal
 * and updating the entry in the signal handler. Note that you should return
 * TRUE from the signal handler to suppress the default behaviour.
 * To add completion functionality to an entry, use gtk_entry_set_completion().
 * In addition to regular completion matches, which will be inserted into the
 * entry when they are selected, GtkEntryCompletion also allows to display
 * "actions" in the popup window. Their appearance is similar to menuitems,
 * to differentiate them clearly from completion strings. When an action is
 * selected, the ::action-activated signal is emitted.
 */
public class EntryCompletion : ObjectG, CellLayoutIF
{
	
	/** the main Gtk struct */
	protected GtkEntryCompletion* gtkEntryCompletion;
	
	
	public GtkEntryCompletion* getEntryCompletionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkEntryCompletion* gtkEntryCompletion);
	
	// add the CellLayout capabilities
	mixin CellLayoutT!(GtkEntryCompletion);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(gint, EntryCompletion)[] onActionActivatedListeners;
	/**
	 * Gets emitted when an action is activated.
	 * Since 2.4
	 */
	void addOnActionActivated(void delegate(gint, EntryCompletion) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackActionActivated(GtkEntryCompletion* widgetStruct, gint index, EntryCompletion entryCompletion);
	
	bool delegate(TreeModelIF, GtkTreeIter*, EntryCompletion)[] onCursorOnMatchListeners;
	/**
	 * Gets emitted when a match from the cursor is on a match
	 * of the list.The default behaviour is to replace the contents
	 * of the entry with the contents of the text column in the row
	 * pointed to by iter.
	 * Since 2.12
	 */
	void addOnCursorOnMatch(bool delegate(TreeModelIF, GtkTreeIter*, EntryCompletion) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackCursorOnMatch(GtkEntryCompletion* widgetStruct, GtkTreeModel* model, GtkTreeIter* iter, EntryCompletion entryCompletion);
	
	bool delegate(string, EntryCompletion)[] onInsertPrefixListeners;
	/**
	 * Gets emitted when the inline autocompletion is triggered.
	 * The default behaviour is to make the entry display the
	 * whole prefix and select the newly inserted part.
	 * Applications may connect to this signal in order to insert only a
	 * smaller part of the prefix into the entry - e.g. the entry used in
	 * the GtkFileChooser inserts only the part of the prefix up to the
	 * next '/'.
	 * Since 2.6
	 */
	void addOnInsertPrefix(bool delegate(string, EntryCompletion) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackInsertPrefix(GtkEntryCompletion* widgetStruct, gchar* prefix, EntryCompletion entryCompletion);
	
	bool delegate(TreeModelIF, GtkTreeIter*, EntryCompletion)[] onMatchSelectedListeners;
	/**
	 * Gets emitted when a match from the list is selected.
	 * The default behaviour is to replace the contents of the
	 * entry with the contents of the text column in the row
	 * pointed to by iter.
	 * Since 2.4
	 */
	void addOnMatchSelected(bool delegate(TreeModelIF, GtkTreeIter*, EntryCompletion) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackMatchSelected(GtkEntryCompletion* widgetStruct, GtkTreeModel* model, GtkTreeIter* iter, EntryCompletion entryCompletion);
	
	
	/**
	 * Creates a new GtkEntryCompletion object.
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Gets the entry completion has been attached to.
	 * Since 2.4
	 * Returns: The entry completion has been attached to.
	 */
	public Widget getEntry();
	
	/**
	 * Sets the model for a GtkEntryCompletion. If completion already has
	 * a model set, it will remove it before setting the new model.
	 * If model is NULL, then it will unset the model.
	 * Since 2.4
	 * Params:
	 * model =  The GtkTreeModel.
	 */
	public void setModel(TreeModelIF model);

	/**
	 * Returns the model the GtkEntryCompletion is using as data source.
	 * Returns NULL if the model is unset.
	 * Since 2.4
	 * Returns: A GtkTreeModel, or NULL if none is currently being used.
	 */
	public TreeModelIF getModel();
	
	/**
	 * Sets the match function for completion to be func. The match function
	 * is used to determine if a row should or should not be in the completion
	 * list.
	 * Since 2.4
	 * Params:
	 * func =  The GtkEntryCompletionMatchFunc to use.
	 * funcData =  The user data for func.
	 * funcNotify =  Destroy notifier for func_data.
	 */
	public void setMatchFunc(GtkEntryCompletionMatchFunc func, void* funcData, GDestroyNotify funcNotify);
	
	/**
	 * Requires the length of the search key for completion to be at least
	 * length. This is useful for long lists, where completing using a small
	 * key takes a lot of time and will come up with meaningless results anyway
	 * (ie, a too large dataset).
	 * Since 2.4
	 * Params:
	 * length =  The minimum length of the key in order to start completing.
	 */
	public void setMinimumKeyLength(int length);
	
	/**
	 * Returns the minimum key length as set for completion.
	 * Since 2.4
	 * Returns: The currently used minimum key length.
	 */
	public int getMinimumKeyLength();
	
	/**
	 * Requests a completion operation, or in other words a refiltering of the
	 * current list with completions, using the current key. The completion list
	 * view will be updated accordingly.
	 * Since 2.4
	 */
	public void complete();
	
	/**
	 * Get the original text entered by the user that triggered
	 * the completion or NULL if there's no completion ongoing.
	 * Since 2.12
	 * Returns: the prefix for the current completion
	 */
	public string getCompletionPrefix();
	
	/**
	 * Requests a prefix insertion.
	 * Since 2.6
	 */
	public void insertPrefix();
	
	/**
	 * Inserts an action in completion's action item list at position index_
	 * with text text. If you want the action item to have markup, use
	 * gtk_entry_completion_insert_action_markup().
	 * Since 2.4
	 * Params:
	 * index =  The index of the item to insert.
	 * text =  Text of the item to insert.
	 */
	public void insertActionText(int index, string text);
	
	/**
	 * Inserts an action in completion's action item list at position index_
	 * with markup markup.
	 * Since 2.4
	 * Params:
	 * index =  The index of the item to insert.
	 * markup =  Markup of the item to insert.
	 */
	public void insertActionMarkup(int index, string markup);
	
	/**
	 * Deletes the action at index_ from completion's action list.
	 * Since 2.4
	 * Params:
	 * index =  The index of the item to Delete.
	 */
	public void deleteAction(int index);
	
	/**
	 * Convenience function for setting up the most used case of this code: a
	 * completion list with just strings. This function will set up completion
	 * to have a list displaying all (and just) strings in the completion list,
	 * and to get those strings from column in the model of completion.
	 * This functions creates and adds a GtkCellRendererText for the selected
	 * column. If you need to set the text column, but don't want the cell
	 * renderer, use g_object_set() to set the ::text_column property directly.
	 * Since 2.4
	 * Params:
	 * column =  The column in the model of completion to get strings from.
	 */
	public void setTextColumn(int column);
	
	/**
	 * Returns the column in the model of completion to get strings from.
	 * Since 2.6
	 * Returns: the column containing the strings
	 */
	public int getTextColumn();
	
	/**
	 * Sets whether the common prefix of the possible completions should
	 * be automatically inserted in the entry.
	 * Since 2.6
	 * Params:
	 * inlineCompletion =  TRUE to do inline completion
	 */
	public void setInlineCompletion(int inlineCompletion);
	
	/**
	 * Returns whether the common prefix of the possible completions should
	 * be automatically inserted in the entry.
	 * Since 2.6
	 * Returns: TRUE if inline completion is turned on
	 */
	public int getInlineCompletion();
	
	/**
	 * Sets whether it is possible to cycle through the possible completions
	 * inside the entry.
	 * Since 2.12
	 * Params:
	 * inlineSelection =  TRUE to do inline selection
	 */
	public void setInlineSelection(int inlineSelection);
	
	/**
	 * Returns TRUE if inline-selection mode is turned on.
	 * Since 2.12
	 * Returns: TRUE if inline-selection mode is on
	 */
	public int getInlineSelection();
	
	/**
	 * Sets whether the completions should be presented in a popup window.
	 * Since 2.6
	 * Params:
	 * popupCompletion =  TRUE to do popup completion
	 */
	public void setPopupCompletion(int popupCompletion);
	
	/**
	 * Returns whether the completions should be presented in a popup window.
	 * Since 2.6
	 * Returns: TRUE if popup completion is turned on
	 */
	public int getPopupCompletion();
	
	/**
	 * Sets whether the completion popup window will be resized to be the same
	 * width as the entry.
	 * Since 2.8
	 * Params:
	 * popupSetWidth =  TRUE to make the width of the popup the same as the entry
	 */
	public void setPopupSetWidth(int popupSetWidth);

	/**
	 * Returns whether the completion popup window will be resized to the
	 * width of the entry.
	 * Since 2.8
	 * Returns: TRUE if the popup window will be resized to the width of  the entry
	 */
	public int getPopupSetWidth();
	
	/**
	 * Sets whether the completion popup window will appear even if there is
	 * only a single match. You may want to set this to FALSE if you
	 * are using inline
	 * completion.
	 * Since 2.8
	 * Params:
	 * popupSingleMatch =  TRUE if the popup should appear even for a single
	 *  match
	 */
	public void setPopupSingleMatch(int popupSingleMatch);
	
	/**
	 * Returns whether the completion popup window will appear even if there is
	 * only a single match.
	 * Since 2.8
	 * Returns: TRUE if the popup window will appear regardless of the number of matches.
	 */
	public int getPopupSingleMatch();
}
