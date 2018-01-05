module gtkD.gtk.Notebook;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Label;
private import gtkD.gtk.Widget;



private import gtkD.gtk.Container;

/**
 * Description
 * The GtkNotebook widget is a GtkContainer whose children are pages that
 * can be switched between using tab labels along one edge.
 * There are many configuration options for GtkNotebook. Among other
 * things, you can choose on which edge the tabs appear
 * (see gtk_notebook_set_tab_pos()), whether, if there are too many
 * tabs to fit the notebook should be made bigger or scrolling
 * arrows added (see gtk_notebook_set_scrollable), and whether there
 * will be a popup menu allowing the users to switch pages.
 * (see gtk_notebook_popup_enable(), gtk_notebook_popup_disable())
 * GtkNotebook as GtkBuildable
 * The GtkNoteboopk implementation of the GtkBuildable interface
 * supports placing children into tabs by specifying "tab" as the
 * "type" attribute of a <child> element. Note that the content
 * of the tab must be created before the tab can be filled.
 * A tab child can be specified without specifying a <child>
 * type attribute.
 * Example 43. A UI definition fragment with GtkNotebook
 * <object class="GtkNotebook">
 *  <child>
 *  <object class="GtkLabel" id="notebook-content">
 *  <property name="label">Content</property>
 *  </object>
 *  </child>
 *  <child type="tab">
 *  <object class="GtkLabel" id="notebook-tab">
 *  <property name="label">Tab</property>
 *  </object>
 *  </child>
 * </object>
 */
public class Notebook : Container
{
	
	/** the main Gtk struct */
	protected GtkNotebook* gtkNotebook;
	
	
	public GtkNotebook* getNotebookStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkNotebook* gtkNotebook);
	
	/** The GtkNotebookTab is not documented */
	public enum GtkNotebookTab
	{
		GTK_NOTEBOOK_TAB_FIRST,
		GTK_NOTEBOOK_TAB_LAST
	}
	alias GtkNotebookTab NotebookTab;
	
	/**
	 * Append a page with a widget and a text for a label
	 */
	public int appendPage(Widget child, string tabLabel);
	
	/** */
	void setCurrentPage(Widget child);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	bool delegate(gint, Notebook)[] onChangeCurrentPageListeners;
	/**
	 */
	void addOnChangeCurrentPage(bool delegate(gint, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackChangeCurrentPage(GtkNotebook* notebookStruct, gint arg1, Notebook notebook);
	
	GtkNotebook* delegate(Widget, gint, gint, Notebook)[] onCreateWindowListeners;
	/**
	 * The ::create-window signal is emitted when a detachable
	 * tab is dropped on the root window.
	 * A handler for this signal can create a window containing
	 * a notebook where the tab will be attached. It is also
	 * responsible for moving/resizing the window and adding the
	 * necessary properties to the notebook (e.g. the
	 * "group-id" ).
	 * The default handler uses the global window creation hook,
	 * if one has been set with gtk_notebook_set_window_creation_hook().
	 * Since 2.12
	 */
	void addOnCreateWindow(GtkNotebook* delegate(Widget, gint, gint, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCreateWindow(GtkNotebook* notebookStruct, GtkWidget* page, gint x, gint y, Notebook notebook);
	
	bool delegate(GtkNotebookTab, Notebook)[] onFocusTabListeners;
	/**
	 */
	void addOnFocusTab(bool delegate(GtkNotebookTab, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackFocusTab(GtkNotebook* notebookStruct, GtkNotebookTab arg1, Notebook notebook);
	
	void delegate(GtkDirectionType, Notebook)[] onMoveFocusOutListeners;
	/**
	 */
	void addOnMoveFocusOut(void delegate(GtkDirectionType, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveFocusOut(GtkNotebook* notebookStruct, GtkDirectionType arg1, Notebook notebook);
	
	void delegate(Widget, guint, Notebook)[] onPageAddedListeners;
	/**
	 * the ::page-added signal is emitted in the notebook
	 * right after a page is added to the notebook.
	 * Since 2.10
	 */
	void addOnPageAdded(void delegate(Widget, guint, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPageAdded(GtkNotebook* notebookStruct, GtkWidget* child, guint pageNum, Notebook notebook);
	
	void delegate(Widget, guint, Notebook)[] onPageRemovedListeners;
	/**
	 * the ::page-removed signal is emitted in the notebook
	 * right after a page is removed from the notebook.
	 * Since 2.10
	 */
	void addOnPageRemoved(void delegate(Widget, guint, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPageRemoved(GtkNotebook* notebookStruct, GtkWidget* child, guint pageNum, Notebook notebook);
	
	void delegate(Widget, guint, Notebook)[] onPageReorderedListeners;
	/**
	 * the ::page-reordered signal is emitted in the notebook
	 * right after a page has been reordered.
	 * Since 2.10
	 */
	void addOnPageReordered(void delegate(Widget, guint, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPageReordered(GtkNotebook* notebookStruct, GtkWidget* child, guint pageNum, Notebook notebook);
	
	bool delegate(GtkDirectionType, gboolean, Notebook)[] onReorderTabListeners;
	/**
	 */
	void addOnReorderTab(bool delegate(GtkDirectionType, gboolean, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackReorderTab(GtkNotebook* notebookStruct, GtkDirectionType arg1, gboolean arg2, Notebook notebook);
	
	bool delegate(gboolean, Notebook)[] onSelectPageListeners;
	/**
	 */
	void addOnSelectPage(bool delegate(gboolean, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackSelectPage(GtkNotebook* notebookStruct, gboolean arg1, Notebook notebook);
	
	void delegate(GtkNotebookPage*, guint, Notebook)[] onSwitchPageListeners;
	/**
	 * Emitted when the user or a function changes the current page.
	 * See Also
	 * GtkContainer
	 * For functions that apply to every GtkContainer
	 */
	void addOnSwitchPage(void delegate(GtkNotebookPage*, guint, Notebook) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSwitchPage(GtkNotebook* notebookStruct, GtkNotebookPage* page, guint pageNum, Notebook notebook);
	
	
	/**
	 * Creates a new GtkNotebook widget with no pages.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Appends a page to notebook.
	 * Params:
	 * child =  the GtkWidget to use as the contents of the page.
	 * tabLabel =  the GtkWidget to be used as the label for the page,
	 *  or NULL to use the default label, 'page N'.
	 * Returns: the index (starting from 0) of the appendedpage in the notebook, or -1 if function fails
	 */
	public int appendPage(Widget child, Widget tabLabel);
	
	/**
	 * Appends a page to notebook, specifying the widget to use as the
	 * label in the popup menu.
	 * Params:
	 * child =  the GtkWidget to use as the contents of the page.
	 * tabLabel =  the GtkWidget to be used as the label for the page,
	 *  or NULL to use the default label, 'page N'.
	 * menuLabel =  the widget to use as a label for the page-switch
	 *  menu, if that is enabled. If NULL, and tab_label
	 *  is a GtkLabel or NULL, then the menu label will be
	 *  a newly created label with the same text as tab_label;
	 *  If tab_label is not a GtkLabel, menu_label must be
	 *  specified if the page-switch menu is to be used.
	 * Returns: the index (starting from 0) of the appendedpage in the notebook, or -1 if function fails
	 */
	public int appendPageMenu(Widget child, Widget tabLabel, Widget menuLabel);
	
	/**
	 * Prepends a page to notebook.
	 * Params:
	 * child =  the GtkWidget to use as the contents of the page.
	 * tabLabel =  the GtkWidget to be used as the label for the page,
	 *  or NULL to use the default label, 'page N'.
	 * Returns: the index (starting from 0) of the prependedpage in the notebook, or -1 if function fails
	 */
	public int prependPage(Widget child, Widget tabLabel);
	
	/**
	 * Prepends a page to notebook, specifying the widget to use as the
	 * label in the popup menu.
	 * Params:
	 * child =  the GtkWidget to use as the contents of the page.
	 * tabLabel =  the GtkWidget to be used as the label for the page,
	 *  or NULL to use the default label, 'page N'.
	 * menuLabel =  the widget to use as a label for the page-switch
	 *  menu, if that is enabled. If NULL, and tab_label
	 *  is a GtkLabel or NULL, then the menu label will be
	 *  a newly created label with the same text as tab_label;
	 *  If tab_label is not a GtkLabel, menu_label must be
	 *  specified if the page-switch menu is to be used.
	 * Returns: the index (starting from 0) of the prependedpage in the notebook, or -1 if function fails
	 */
	public int prependPageMenu(Widget child, Widget tabLabel, Widget menuLabel);
	
	/**
	 * Insert a page into notebook at the given position.
	 * Params:
	 * child =  the GtkWidget to use as the contents of the page.
	 * tabLabel =  the GtkWidget to be used as the label for the page,
	 *  or NULL to use the default label, 'page N'.
	 * position =  the index (starting at 0) at which to insert the page,
	 *  or -1 to append the page after all other pages.
	 * Returns: the index (starting from 0) of the insertedpage in the notebook, or -1 if function fails
	 */
	public int insertPage(Widget child, Widget tabLabel, int position);
	
	/**
	 * Insert a page into notebook at the given position, specifying
	 * the widget to use as the label in the popup menu.
	 * Params:
	 * child =  the GtkWidget to use as the contents of the page.
	 * tabLabel =  the GtkWidget to be used as the label for the page,
	 *  or NULL to use the default label, 'page N'.
	 * menuLabel =  the widget to use as a label for the page-switch
	 *  menu, if that is enabled. If NULL, and tab_label
	 *  is a GtkLabel or NULL, then the menu label will be
	 *  a newly created label with the same text as tab_label;
	 *  If tab_label is not a GtkLabel, menu_label must be
	 *  specified if the page-switch menu is to be used.
	 * position =  the index (starting at 0) at which to insert the page,
	 *  or -1 to append the page after all other pages.
	 * Returns: the index (starting from 0) of the insertedpage in the notebook
	 */
	public int insertPageMenu(Widget child, Widget tabLabel, Widget menuLabel, int position);
	
	/**
	 * Removes a page from the notebook given its index
	 * in the notebook.
	 * Params:
	 * pageNum =  the index of a notebook page, starting
	 *  from 0. If -1, the last page will
	 *  be removed.
	 */
	public void removePage(int pageNum);
	
	/**
	 * Finds the index of the page which contains the given child
	 * widget.
	 * Params:
	 * child =  a GtkWidget
	 * Returns: the index of the page containing child, or -1 if child is not in the notebook.
	 */
	public int pageNum(Widget child);
	
	/**
	 * Switches to the next page. Nothing happens if the current page is
	 * the last page.
	 */
	public void nextPage();

	/**
	 * Switches to the previous page. Nothing happens if the current page
	 * is the first page.
	 */
	public void prevPage();

	/**
	 * Reorders the page containing child, so that it appears in position
	 * position. If position is greater than or equal to the number of
	 * children in the list or negative, child will be moved to the end
	 * of the list.
	 * Params:
	 * child =  the child to move
	 * position =  the new position, or -1 to move to the end
	 */
	public void reorderChild(Widget child, int position);
	
	/**
	 * Sets the edge at which the tabs for switching pages in the
	 * notebook are drawn.
	 * Params:
	 * pos =  the edge to draw the tabs at.
	 */
	public void setTabPos(GtkPositionType pos);
	
	/**
	 * Sets whether to show the tabs for the notebook or not.
	 * Params:
	 * showTabs =  TRUE if the tabs should be shown.
	 */
	public void setShowTabs(int showTabs);
	
	/**
	 * Sets whether a bevel will be drawn around the notebook pages.
	 * This only has a visual effect when the tabs are not shown.
	 * See gtk_notebook_set_show_tabs().
	 * Params:
	 * showBorder =  TRUE if a bevel should be drawn around the notebook.
	 */
	public void setShowBorder(int showBorder);
	
	/**
	 * Sets whether the tab label area will have arrows for scrolling if
	 * there are too many tabs to fit in the area.
	 * Params:
	 * scrollable =  TRUE if scroll arrows should be added
	 */
	public void setScrollable(int scrollable);

	/**
	 * Warning
	 * gtk_notebook_set_tab_border is deprecated and should not be used in newly-written code.
	 * Sets the width the border around the tab labels
	 * in a notebook. This is equivalent to calling
	 * gtk_notebook_set_tab_hborder (notebook, border_width) followed
	 * by gtk_notebook_set_tab_vborder (notebook, border_width).
	 * Params:
	 * borderWidth =  width of the border around the tab labels.
	 */
	public void setTabBorder(uint borderWidth);
	
	/**
	 * Enables the popup menu: if the user clicks with the right mouse button on
	 * the bookmarks, a menu with all the pages will be popped up.
	 */
	public void popupEnable();
	
	/**
	 * Disables the popup menu.
	 */
	public void popupDisable();
	
	/**
	 * Returns the page number of the current page.
	 * Returns: the index (starting from 0) of the currentpage in the notebook. If the notebook has no pages, then-1 will be returned.
	 */
	public int getCurrentPage();
	
	/**
	 * Retrieves the menu label widget of the page containing child.
	 * Params:
	 * child =  a widget contained in a page of notebook
	 * Returns: the menu label, or NULL if the notebook page does not have a menu label other than the default (the tab label).
	 */
	public Widget getMenuLabel(Widget child);
	
	/**
	 * Returns the child widget contained in page number page_num.
	 * Params:
	 * pageNum =  the index of a page in the notebook, or -1
	 *  to get the last page.
	 * Returns: the child widget, or NULL if page_num isout of bounds.
	 */
	public Widget getNthPage(int pageNum);
	
	/**
	 * Gets the number of pages in a notebook.
	 * Since 2.2
	 * Returns: the number of pages in the notebook.
	 */
	public int getNPages();
	
	/**
	 * Returns the tab label widget for the page child. NULL is returned
	 * if child is not in notebook or if no tab label has specifically
	 * been set for child.
	 * Params:
	 * child =  the page
	 * Returns: the tab label
	 */
	public Widget getTabLabel(Widget child);
	
	/**
	 * Query the packing attributes for the tab label of the page
	 * containing child.
	 * Params:
	 * child =  the page
	 * expand =  location to store the expand value (or NULL)
	 * fill =  location to store the fill value (or NULL)
	 * packType =  location to store the pack_type (or NULL)
	 */
	public void queryTabLabelPacking(Widget child, out int expand, out int fill, out GtkPackType packType);
	
	/**
	 * Warning
	 * gtk_notebook_set_homogeneous_tabs is deprecated and should not be used in newly-written code.
	 * Sets whether the tabs must have all the same size or not.
	 * Params:
	 * homogeneous =  TRUE if all tabs should be the same size.
	 */
	public void setHomogeneousTabs(int homogeneous);
	
	/**
	 * Changes the menu label for the page containing child.
	 * Params:
	 * child =  the child widget
	 * menuLabel =  the menu label, or NULL for default
	 */
	public void setMenuLabel(Widget child, Widget menuLabel);
	
	/**
	 * Creates a new label and sets it as the menu label of child.
	 * Params:
	 * child =  the child widget
	 * menuText =  the label text
	 */
	public void setMenuLabelText(Widget child, string menuText);
	
	/**
	 * Warning
	 * gtk_notebook_set_tab_hborder is deprecated and should not be used in newly-written code.
	 * Sets the width of the horizontal border of tab labels.
	 * Params:
	 * tabHborder =  width of the horizontal border of tab labels.
	 */
	public void setTabHborder(uint tabHborder);
	
	/**
	 * Changes the tab label for child. If NULL is specified
	 * for tab_label, then the page will have the label 'page N'.
	 * Params:
	 * child =  the page
	 * tabLabel =  the tab label widget to use, or NULL for default tab
	 *  label.
	 */
	public void setTabLabel(Widget child, Widget tabLabel);
	
	/**
	 * Sets the packing parameters for the tab label of the page
	 * containing child. See gtk_box_pack_start() for the exact meaning
	 * of the parameters.
	 * Params:
	 * child =  the child widget
	 * expand =  whether to expand the bookmark or not
	 * fill =  whether the bookmark should fill the allocated area or not
	 * packType =  the position of the bookmark
	 */
	public void setTabLabelPacking(Widget child, int expand, int fill, GtkPackType packType);
	
	/**
	 * Creates a new label and sets it as the tab label for the page
	 * containing child.
	 * Params:
	 * child =  the page
	 * tabText =  the label text
	 */
	public void setTabLabelText(Widget child, string tabText);
	
	/**
	 * Warning
	 * gtk_notebook_set_tab_vborder is deprecated and should not be used in newly-written code.
	 * Sets the width of the vertical border of tab labels.
	 * Params:
	 * tabVborder =  width of the vertical border of tab labels.
	 */
	public void setTabVborder(uint tabVborder);
	
	/**
	 * Sets whether the notebook tab can be reordered
	 * via drag and drop or not.
	 * Since 2.10
	 * Params:
	 * child =  a child GtkWidget
	 * reorderable =  whether the tab is reorderable or not.
	 */
	public void setTabReorderable(Widget child, int reorderable);
	
	/**
	 * Sets whether the tab can be detached from notebook to another
	 * notebook or widget.
	 * Note that 2 notebooks must share a common group identificator
	 * (see gtk_notebook_set_group_id()) to allow automatic tabs
	 * interchange between them.
	 * If you want a widget to interact with a notebook through DnD
	 * (i.e.: accept dragged tabs from it) it must be set as a drop
	 * destination and accept the target "GTK_NOTEBOOK_TAB". The notebook
	 * will fill the selection with a GtkWidget** pointing to the child
	 * widget that corresponds to the dropped tab.
	 *  static void
	 *  on_drop_zone_drag_data_received (GtkWidget *widget,
	 *  GdkDragContext *context,
	 *  gint x,
	 *  gint y,
	 *  GtkSelectionData *selection_data,
	 *  guint info,
	 *  guint time,
	 *  gpointer user_data)
	 *  {
		 *  GtkWidget *notebook;
		 *  GtkWidget **child;
		 *  notebook = gtk_drag_get_source_widget (context);
		 *  child = (void*) selection_data->data;
		 *  process_widget (*child);
		 *  gtk_container_remove (GTK_CONTAINER (notebook), *child);
	 *  }
	 * If you want a notebook to accept drags from other widgets,
	 * you will have to set your own DnD code to do it.
	 * Since 2.10
	 * Params:
	 * child =  a child GtkWidget
	 * detachable =  whether the tab is detachable or not
	 */
	public void setTabDetachable(Widget child, int detachable);
	
	/**
	 * Retrieves the text of the menu label for the page containing
	 *  child.
	 * Params:
	 * child =  the child widget of a page of the notebook.
	 * Returns: the text of the tab label, or NULL if the widget does not have a menu label other than the default menu label, or the menu label widget is not a GtkLabel. The string is owned by the widget and must not be freed.
	 */
	public string getMenuLabelText(Widget child);
	
	/**
	 * Returns whether the tab label area has arrows for scrolling. See
	 * gtk_notebook_set_scrollable().
	 * Returns: TRUE if arrows for scrolling are present
	 */
	public int getScrollable();
	
	/**
	 * Returns whether a bevel will be drawn around the notebook pages. See
	 * gtk_notebook_set_show_border().
	 * Returns: TRUE if the bevel is drawn
	 */
	public int getShowBorder();
	
	/**
	 * Returns whether the tabs of the notebook are shown. See
	 * gtk_notebook_set_show_tabs().
	 * Returns: TRUE if the tabs are shown
	 */
	public int getShowTabs();
	
	/**
	 * Retrieves the text of the tab label for the page containing
	 *  child.
	 * Params:
	 * child =  a widget contained in a page of notebook
	 * Returns: the text of the tab label, or NULL if the tab label widget is not a GtkLabel. The string is owned by the widget and must not be freed.
	 */
	public string getTabLabelText(Widget child);
	
	/**
	 * Gets the edge at which the tabs for switching pages in the
	 * notebook are drawn.
	 * Returns: the edge at which the tabs are drawn
	 */
	public GtkPositionType getTabPos();
	
	/**
	 * Gets whether the tab can be reordered via drag and drop or not.
	 * Since 2.10
	 * Params:
	 * child =  a child GtkWidget
	 * Returns: TRUE if the tab is reorderable.
	 */
	public int getTabReorderable(Widget child);
	
	/**
	 * Returns whether the tab contents can be detached from notebook.
	 * Since 2.10
	 * Params:
	 * child =  a child GtkWidget
	 * Returns: TRUE if the tab is detachable.
	 */
	public int getTabDetachable(Widget child);
	
	/**
	 * Switches to the page number page_num.
	 * Note that due to historical reasons, GtkNotebook refuses
	 * to switch to a page unless the child widget is visible.
	 * Therefore, it is recommended to show child widgets before
	 * adding them to a notebook.
	 * Params:
	 * pageNum =  index of the page to switch to, starting from 0.
	 *  If negative, the last page will be used. If greater
	 *  than the number of pages in the notebook, nothing
	 *  will be done.
	 */
	public void setCurrentPage(int pageNum);

	/**
	 * Warning
	 * gtk_notebook_set_group_id has been deprecated since version 2.12 and should not be used in newly-written code. use gtk_notebook_set_group() instead.
	 * Sets an group identificator for notebook, notebooks sharing
	 * the same group identificator will be able to exchange tabs
	 * via drag and drop. A notebook with group identificator -1 will
	 * not be able to exchange tabs with any other notebook.
	 * Since 2.10
	 * Params:
	 * groupId =  a group identificator, or -1 to unset it
	 */
	public void setGroupId(int groupId);
	
	/**
	 * Warning
	 * gtk_notebook_get_group_id has been deprecated since version 2.12 and should not be used in newly-written code. use gtk_notebook_get_group() instead.
	 * Gets the current group identificator for notebook.
	 * Since 2.10
	 * Returns: the group identificator, or -1 if none is set.
	 */
	public int getGroupId();

	/**
	 * Sets a group identificator pointer for notebook, notebooks sharing
	 * the same group identificator pointer will be able to exchange tabs
	 * via drag and drop. A notebook with a NULL group identificator will
	 * not be able to exchange tabs with any other notebook.
	 * Since 2.12
	 * Params:
	 * group =  a pointer to identify the notebook group, or NULL to unset it
	 */
	public void setGroup(void* group);
	
	/**
	 * Gets the current group identificator pointer for notebook.
	 * Since 2.12
	 * Returns: the group identificator, or NULL if none is set.
	 */
	public void* getGroup();
	
	/**
	 * Installs a global function used to create a window
	 * when a detached tab is dropped in an empty area.
	 * Since 2.10
	 * Params:
	 * func =  the GtkNotebookWindowCreationFunc, or NULL
	 * data =  user data for func
	 * destroy =  Destroy notifier for data, or NULL
	 */
	public static void setWindowCreationHook(GtkNotebookWindowCreationFunc func, void* data, GDestroyNotify destroy);
}
