module gtkD.gsv.SourceView;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gdk.Pixbuf;
private import gtkD.gdk.Color;
private import gtkD.gtk.TextIter;
private import gtkD.gsv.SourceGutter;
private import gtkD.gsv.SourceBuffer;
private import gtkD.gtkc.gtk;
private import gtkD.glib.Str;



private import gtkD.gtk.TextView;

/**
 * Description
 * GtkSourceView is the main object of the gtksourceview library. It provides
 * a text view which syntax highlighting, undo/redo and text marks. Use a
 * GtkSourceBuffer to display text with a GtkSourceView.
 */
public class SourceView : TextView
{
	
	/** the main Gtk struct */
	protected GtkSourceView* gtkSourceView;
	
	
	public GtkSourceView* getSourceViewStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSourceView* gtkSourceView);
	
	/**
	 * Returns the GtkSourceBuffer being displayed by this source view.
	 * The reference count on the buffer is not incremented; the caller
	 * of this function won't own a new reference.
	 * Returns:
	 *  a GtkSourceBuffer
	 */
	public override SourceBuffer getBuffer();
	
	
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(TextIter, gpointer, SourceView)[] onLineMarkActivatedListeners;
	/**
	 * Emitted when a line mark has been activated (for instance when there
	 * was a button press in the line marks gutter). You can use iter to
	 * determine on which line the activation took place.
	 */
	void addOnLineMarkActivated(void delegate(TextIter, gpointer, SourceView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackLineMarkActivated(GtkSourceView* viewStruct, GtkTextIter* iter, gpointer event, SourceView sourceView);
	
	void delegate(SourceView)[] onRedoListeners;
	/**
	 */
	void addOnRedo(void delegate(SourceView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackRedo(GtkSourceView* sourceviewStruct, SourceView sourceView);
	
	void delegate(SourceView)[] onUndoListeners;
	/**
	 */
	void addOnUndo(void delegate(SourceView) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackUndo(GtkSourceView* sourceviewStruct, SourceView sourceView);
	
	
	/**
	 * Creates a new GtkSourceView. An empty default buffer will be
	 * created for you. If you want to specify your own buffer, consider
	 * gtk_source_view_new_with_buffer().
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	/**
	 * Creates a new GtkSourceView widget displaying the buffer
	 * buffer. One buffer can be shared among many widgets.
	 * Params:
	 * buffer =  a GtkSourceBuffer.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (SourceBuffer buffer);
	
	/**
	 * If TRUE auto indentation of text is enabled.
	 * Params:
	 * enable =  whether to enable auto indentation.
	 */
	public void setAutoIndent(int enable);
	
	/**
	 * Returns whether auto indentation of text is enabled.
	 * Returns: TRUE if auto indentation is enabled.
	 */
	public int getAutoIndent();
	
	/**
	 * If TRUE, when the tab key is pressed and there is a selection, the
	 * selected text is indented of one level instead of being replaced with
	 * the \t characters. Shift+Tab unindents the selection.
	 * Since 1.8
	 * Params:
	 * enable =  whether to indent a block when tab is pressed.
	 */
	public void setIndentOnTab(int enable);
	
	/**
	 * Returns whether when the tab key is pressed the current selection
	 * should get indented instead of replaced with the \t character.
	 * Since 1.8
	 * Returns: TRUE if the selection is indented when tab is pressed.
	 */
	public int getIndentOnTab();
	
	/**
	 * Sets the number of spaces to use for each step of indent.
	 * If width is -1, the value of the GtkSourceView::tab-width property
	 * will be used.
	 * Params:
	 * width =  indent width in characters.
	 */
	public void setIndentWidth(int width);
	
	/**
	 * Returns the number of spaces to use for each step of indent.
	 * See gtk_source_view_set_indent_width() for details.
	 * Returns: indent width.
	 */
	public int getIndentWidth();

	/**
	 * If TRUE any tabulator character inserted is replaced by a group
	 * of space characters.
	 * Params:
	 * enable =  whether to insert spaces instead of tabs.
	 */
	public void setInsertSpacesInsteadOfTabs(int enable);
	
	/**
	 * Returns whether when inserting a tabulator character it should
	 * be replaced by a group of space characters.
	 * Returns: TRUE if spaces are inserted instead of tabs.
	 */
	public int getInsertSpacesInsteadOfTabs();
	
	/**
	 * Set the desired movement of the cursor when HOME and END keys
	 * are pressed.
	 * Params:
	 * smartHe =  the desired behavior among GtkSourceSmartHomeEndType.
	 */
	public void setSmartHomeEnd(GtkSourceSmartHomeEndType smartHe);
	
	/**
	 * Returns a GtkSourceSmartHomeEndType end value specifying
	 * how the cursor will move when HOME and END keys are pressed.
	 * Returns: a GtkSourceSmartHomeEndTypeend value.
	 */
	public GtkSourceSmartHomeEndType getSmartHomeEnd();
	
	/**
	 * Set the priority for the given mark category. When there are
	 * multiple marks on the same line, marks of categories with
	 * higher priorities will be drawn on top.
	 * Since 2.2
	 * Params:
	 * category =  a mark category.
	 * priority =  the priority for the category
	 */
	public void setMarkCategoryPriority(string category, int priority);
	
	/**
	 * Gets the priority which is associated with the given category.
	 * Since 2.2
	 * Params:
	 * category =  a mark category.
	 * Returns: the priority or if categoryexists but no priority was set, it defaults to 0.
	 */
	public int getMarkCategoryPriority(string category);
	
	/**
	 * Warning
	 * gtk_source_view_set_mark_category_pixbuf is deprecated and should not be used in newly-written code. Use gtk_source_view_set_mark_category_icon_from_pixbuf instead
	 * Associates a given pixbuf with a given mark category.
	 * If pixbuf is NULL, the pixbuf is unset.
	 * Since 2.2
	 * Params:
	 * category =  a mark category.
	 * pixbuf =  a GdkPixbuf or NULL.
	 */
	public void setMarkCategoryPixbuf(string category, Pixbuf pixbuf);
	
	/**
	 * Warning
	 * gtk_source_view_get_mark_category_pixbuf is deprecated and should not be used in newly-written code.
	 * Gets the pixbuf which is associated with the given mark category.
	 * Since 2.2
	 * Params:
	 * category =  a mark category.
	 * Returns: the associated GdkPixbuf, or NULL if not found.
	 */
	public Pixbuf getMarkCategoryPixbuf(string category);
	
	/**
	 * Sets the icon to be used for category to pixbuf.
	 * If pixbuf is NULL, the icon is unset.
	 * Since 2.8
	 * Params:
	 * category =  a mark category.
	 * pixbuf =  a GdkPixbuf or NULL.
	 */
	public void setMarkCategoryIconFromPixbuf(string category, Pixbuf pixbuf);
	
	/**
	 * Sets the icon to be used for category to the stock item stock_id.
	 * If stock_id is NULL, the icon is unset.
	 * Since 2.8
	 * Params:
	 * category =  a mark category.
	 * stockId =  the stock id or NULL.
	 */
	public void setMarkCategoryIconFromStock(string category, string stockId);
	
	/**
	 * Sets the icon to be used for category to the named theme item name.
	 * If name is NULL, the icon is unset.
	 * Since 2.8
	 * Params:
	 * category =  a mark category.
	 * name =  the themed icon name or NULL.
	 */
	public void setMarkCategoryIconFromIconName(string category, string name);
	
	/**
	 * Gets the background color associated with given category.
	 * Since 2.4
	 * Params:
	 * category =  a mark category.
	 * dest =  destination GdkColor structure to fill in.
	 * Returns: TRUE if background color for category was setand dest is set to a valid color, or FALSE otherwise.
	 */
	public int getMarkCategoryBackground(string category, Color dest);
	
	/**
	 * Sets given background color for mark category.
	 * If color is NULL, the background color is unset.
	 * Since 2.4
	 * Params:
	 * category =  a mark category.
	 * color =  background color or NULL to unset it.
	 */
	public void setMarkCategoryBackground(string category, Color color);
	
	/**
	 * Set a GtkSourceViewMarkTooltipFunc used to set tooltip on marks from the
	 * given mark category.
	 * If you also specified a function with
	 * gtk_source_view_set_mark_category_tooltip_markup_func() the markup
	 * variant takes precedence.
	 * static gchar *
	 * tooltip_func (GtkSourceMark *mark,
	 *  gpointer user_data)
	 * {
		 *  gchar *text;
		 *  text = get_tooltip_for_mark (mark, user_data);
		 *  return text;
	 * }
	 * ...
	 * GtkSourceView *view;
	 * gtk_source_view_set_mark_category_tooltip_func (view, "other-mark",
	 *  tooltip_func,
	 *  NULL, NULL);
	 * Since 2.8
	 * Params:
	 * category =  a mark category.
	 * func =  a GtkSourceViewMarkTooltipFunc or NULL.
	 * userData =  user data which will be passed to func.
	 * userDataNotify = a function to free the memory allocated for user_data
	 * or NULL if you do not want to supply such a function.
	 */
	public void setMarkCategoryTooltipFunc(string category, GtkSourceViewMarkTooltipFunc func, void* userData, GDestroyNotify userDataNotify);
	
	/**
	 * See gtk_source_view_set_mark_category_tooltip_func() for more information.
	 * Since 2.8
	 * Params:
	 * category =  a mark category.
	 * markupFunc =  a GtkSourceViewMarkTooltipFunc or NULL.
	 * userData =  user data which will be passed to func.
	 * userDataNotify = a function to free the memory allocated for user_data
	 * or NULL if you do not want to supply such a function.
	 */
	public void setMarkCategoryTooltipMarkupFunc(string category, GtkSourceViewMarkTooltipFunc markupFunc, void* userData, GDestroyNotify userDataNotify);
	
	/**
	 * If show is TRUE the current line is highlighted.
	 * Params:
	 * show =  whether to highlight the current line
	 */
	public void setHighlightCurrentLine(int show);
	
	/**
	 * Returns whether the current line is highlighted
	 * Returns: TRUE if the current line is highlighted.
	 */
	public int getHighlightCurrentLine();
	
	/**
	 * If TRUE line marks will be displayed beside the text.
	 * Since 2.2
	 * Params:
	 * show =  whether line marks should be displayed.
	 */
	public void setShowLineMarks(int show);
	
	/**
	 * Returns whether line marks are displayed beside the text.
	 * Since 2.2
	 * Returns: TRUE if the line marks are displayed.
	 */
	public int getShowLineMarks();
	
	/**
	 * If TRUE line numbers will be displayed beside the text.
	 * Params:
	 * show =  whether line numbers should be displayed.
	 */
	public void setShowLineNumbers(int show);
	
	/**
	 * Returns whether line numbers are displayed beside the text.
	 * Returns: TRUE if the line numbers are displayed.
	 */
	public int getShowLineNumbers();
	
	/**
	 * If TRUE a right margin is displayed
	 * Params:
	 * show =  whether to show a right margin.
	 */
	public void setShowRightMargin(int show);
	
	/**
	 * Returns whether a right margin is displayed.
	 * Returns: TRUE if the right margin is shown.
	 */
	public int getShowRightMargin();
	
	/**
	 * Sets the position of the right margin in the given view.
	 * Params:
	 * pos =  the width in characters where to position the right margin.
	 */
	public void setRightMarginPosition(uint pos);
	
	/**
	 * Gets the position of the right margin in the given view.
	 * Returns: the position of the right margin.
	 */
	public uint getRightMarginPosition();
	
	/**
	 * Sets the width of tabulation in characters.
	 * Params:
	 * width =  width of tab in characters.
	 */
	public void setTabWidth(uint width);
	
	/**
	 * Returns the width of tabulation in characters.
	 * Returns: width of tab.
	 */
	public uint getTabWidth();
	
	/**
	 * Set if and how the spaces should be visualized. Specifying flags as 0 will
	 * disable display of spaces.
	 * Params:
	 * flags =  GtkSourceDrawSpacesFlags specifing how white spaces should
	 * be displayed
	 */
	public void setDrawSpaces(GtkSourceDrawSpacesFlags flags);
	
	/**
	 * Returns the GtkSourceDrawSpacesFlags specifying if and how spaces
	 * should be displayed for this view.
	 * Returns: the GtkSourceDrawSpacesFlags, 0 if no spaces should be drawn.
	 */
	public GtkSourceDrawSpacesFlags getDrawSpaces();

	/**
	 * Returns the GtkSourceGutter object associated with window_type for view.
	 * Only GTK_TEXT_WINDOW_LEFT and GTK_TEXT_WINDOW_RIGHT are supported,
	 * respectively corresponding to the left and right gutter. The line numbers
	 * and mark category icons are rendered in the gutter corresponding to
	 * GTK_TEXT_WINDOW_LEFT.
	 * Since 2.8
	 * Params:
	 * windowType =  the gutter window type
	 * Returns: the GtkSourceGutter.
	 */
	public SourceGutter getGutter(GtkTextWindowType windowType);
}
