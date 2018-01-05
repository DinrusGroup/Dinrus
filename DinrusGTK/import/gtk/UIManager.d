module gtkD.gtk.UIManager;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.gtk.ActionGroup;
private import gtkD.glib.ListG;
private import gtkD.gtk.AccelGroup;
private import gtkD.gtk.Widget;
private import gtkD.glib.ListSG;
private import gtkD.gtk.Action;
private import gtkD.gtk.BuildableIF;
private import gtkD.gtk.BuildableT;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkUIManager constructs a user interface (menus and toolbars) from
 * one or more UI definitions, which reference actions from one or more
 * action groups.
 * UI Definitions
 * The UI definitions are specified in an XML format which can be
 * roughly described by the following DTD.
 * Do not confuse the GtkUIManager UI Definitions described here with
 * the similarly named GtkBuilder UI
 * Definitions.
 * <!ELEMENT ui (menubar|toolbar|popup|accelerator)* >
 * <!ELEMENT menubar (menuitem|separator|placeholder|menu)* >
 * <!ELEMENT menu (menuitem|separator|placeholder|menu)* >
 * <!ELEMENT popup (menuitem|separator|placeholder|menu)* >
 * <!ELEMENT toolbar (toolitem|separator|placeholder)* >
 * <!ELEMENT placeholder (menuitem|toolitem|separator|placeholder|menu)* >
 * <!ELEMENT menuitem EMPTY >
 * <!ELEMENT toolitem (menu?) >
 * <!ELEMENT separator EMPTY >
 * <!ELEMENT accelerator EMPTY >
 * <!ATTLIST menubar name num;IMPLIED
 *  action num;IMPLIED >
 * <!ATTLIST toolbar name num;IMPLIED
 *  action num;IMPLIED >
 * <!ATTLIST popup name num;IMPLIED
 *  action num;IMPLIED
 *  accelerators (true|false) num;IMPLIED >
 * <!ATTLIST placeholder name num;IMPLIED
 *  action num;IMPLIED >
 * <!ATTLIST separator name num;IMPLIED
 *  action num;IMPLIED
 *  expand (true|false) num;IMPLIED >
 * <!ATTLIST menu name num;IMPLIED
 *  action num;REQUIRED
 *  position (top|bot) num;IMPLIED >
 * <!ATTLIST menuitem name num;IMPLIED
 *  action num;REQUIRED
 *  position (top|bot) num;IMPLIED >
 * <!ATTLIST toolitem name num;IMPLIED
 *  action num;REQUIRED
 *  position (top|bot) num;IMPLIED >
 * <!ATTLIST accelerator name num;IMPLIED
 *  action num;REQUIRED >
 * There are some additional restrictions beyond those specified in the
 * DTD, e.g. every toolitem must have a toolbar in its anchestry and
 * every menuitem must have a menubar or popup in its anchestry. Since
 * a GMarkup parser is used to parse the UI description, it must not only
 * be valid XML, but valid GMarkup.
 * If a name is not specified, it defaults to the action. If an action is
 * not specified either, the element name is used. The name and action
 * attributes must not contain '/' characters after parsing (since that
 * would mess up path lookup) and must be usable as XML attributes when
 * enclosed in doublequotes, thus they must not '"' characters or references
 * to the quot; entity.
 * Example 33. A UI definition
 * <ui>
 *  <menubar>
 *  <menu name="FileMenu" action="FileMenuAction">
 *  <menuitem name="New" action="New2Action" />
 *  <placeholder name="FileMenuAdditions" />
 *  </menu>
 *  <menu name="JustifyMenu" action="JustifyMenuAction">
 *  <menuitem name="Left" action="justify-left"/>
 *  <menuitem name="Centre" action="justify-center"/>
 *  <menuitem name="Right" action="justify-right"/>
 *  <menuitem name="Fill" action="justify-fill"/>
 *  </menu>
 *  </menubar>
 *  <toolbar action="toolbar1">
 *  <placeholder name="JustifyToolItems">
 *  <separator/>
 *  <toolitem name="Left" action="justify-left"/>
 *  <toolitem name="Centre" action="justify-center"/>
 *  <toolitem name="Right" action="justify-right"/>
 *  <toolitem name="Fill" action="justify-fill"/>
 *  <separator/>
 *  </placeholder>
 *  </toolbar>
 * </ui>
 * The constructed widget hierarchy is very similar to the element tree
 * of the XML, with the exception that placeholders are merged into their
 * parents. The correspondence of XML elements to widgets should be
 * almost obvious:
 * menubar
 * a GtkMenuBar
 * toolbar
 * a GtkToolbar
 * popup
 * a toplevel GtkMenu
 * menu
 * a GtkMenu attached to a menuitem
 * menuitem
 * a GtkMenuItem subclass, the exact type depends on the
 * action
 * toolitem
 * a GtkToolItem subclass, the exact type depends on the
 * action. Note that toolitem elements may contain a menu element, but only
 * if their associated action specifies a GtkMenuToolButton as proxy.
 * separator
 * a GtkSeparatorMenuItem or
 * GtkSeparatorToolItem
 * accelerator
 * a keyboard accelerator
 * The "position" attribute determines where a constructed widget is positioned
 * wrt. to its siblings in the partially constructed tree. If it is
 * "top", the widget is prepended, otherwise it is appended.
 * <hr>
 * UI Merging
 * The most remarkable feature of GtkUIManager is that it can overlay a set
 * of menuitems and toolitems over another one, and demerge them later.
 * Merging is done based on the names of the XML elements. Each element is
 * identified by a path which consists of the names of its anchestors, separated
 * by slashes. For example, the menuitem named "Left" in the example above
 * has the path /ui/menubar/JustifyMenu/Left and the
 * toolitem with the same name has path
 * /ui/toolbar1/JustifyToolItems/Left.
 * <hr>
 * Accelerators
 * Every action has an accelerator path. Accelerators are installed together with
 * menuitem proxies, but they can also be explicitly added with <accelerator>
 * elements in the UI definition. This makes it possible to have accelerators for
 * actions even if they have no visible proxies.
 * <hr>
 * Smart Separators
 * The separators created by GtkUIManager are "smart", i.e. they do not show up
 * in the UI unless they end up between two visible menu or tool items. Separators
 * which are located at the very beginning or end of the menu or toolbar
 * containing them, or multiple separators next to each other, are hidden. This
 * is a useful feature, since the merging of UI elements from multiple sources
 * can make it hard or impossible to determine in advance whether a separator
 * will end up in such an unfortunate position.
 * For separators in toolbars, you can set expand="true" to
 * turn them from a small, visible separator to an expanding, invisible one.
 * Toolitems following an expanding separator are effectively right-aligned.
 * <hr>
 * Empty Menus
 * Submenus pose similar problems to separators inconnection with merging. It is
 * impossible to know in advance whether they will end up empty after merging.
 * GtkUIManager offers two ways to treat empty submenus:
 * make them disappear by hiding the menu item they're attached to
 * add an insensitive "Empty" item
 * The behaviour is chosen based on the "hide_if_empty" property of the action
 * to which the submenu is associated.
 * <hr>
 * GtkUIManager as GtkBuildable
 * The GtkUIManager implementation of the GtkBuildable interface accepts
 * GtkActionGroup objects as <child> elements in UI definitions.
 * A GtkUIManager UI definition as described above can be embedded in
 * an GtkUIManager <object> element in a GtkBuilder UI definition.
 * The widgets that are constructed by a GtkUIManager can be embedded in
 * other parts of the constructed user interface with the help of the
 * "constructor" attribute. See the example below.
 * Example 34. An embedded GtkUIManager UI definition
 * <object class="GtkUIManager" id="uiman">
 *  <child>
 *  <object class="GtkActionGroup" id="actiongroup">
 *  <child>
 *  <object class="GtkAction" id="file">
 *  <property name="label">_File</property>
 *  </object>
 *  </child>
 *  </object>
 *  </child>
 *  <ui>
 *  <menubar name="menubar1">
 *  <menu action="file">
 *  </menu>
 *  </menubar>
 *  </ui>
 * </object>
 * <object class="GtkWindow" id="main-window">
 *  <child>
 *  <object class="GtkMenuBar" id="menubar1" constructor="uiman"/>
 *  </child>
 * </object>
 */
public class UIManager : ObjectG, BuildableIF
{
	
	/** the main Gtk struct */
	protected GtkUIManager* gtkUIManager;
	
	
	public GtkUIManager* getUIManagerStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkUIManager* gtkUIManager);
	
	// add the Buildable capabilities
	mixin BuildableT!(GtkUIManager);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(UIManager)[] onActionsChangedListeners;
	/**
	 * The "actions-changed" signal is emitted whenever the set of actions
	 * changes.
	 * Since 2.4
	 */
	void addOnActionsChanged(void delegate(UIManager) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackActionsChanged(GtkUIManager* mergeStruct, UIManager uIManager);
	
	void delegate(Widget, UIManager)[] onAddWidgetListeners;
	/**
	 * The add_widget signal is emitted for each generated menubar and toolbar.
	 * It is not emitted for generated popup menus, which can be obtained by
	 * gtk_ui_manager_get_widget().
	 * Since 2.4
	 */
	void addOnAddWidget(void delegate(Widget, UIManager) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAddWidget(GtkUIManager* mergeStruct, GtkWidget* widget, UIManager uIManager);
	
	void delegate(Action, Widget, UIManager)[] onConnectProxyListeners;
	/**
	 * The connect_proxy signal is emitted after connecting a proxy to
	 * an action in the group.
	 * This is intended for simple customizations for which a custom action
	 * class would be too clumsy, e.g. showing tooltips for menuitems in the
	 * statusbar.
	 * Since 2.4
	 */
	void addOnConnectProxy(void delegate(Action, Widget, UIManager) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackConnectProxy(GtkUIManager* uimanagerStruct, GtkAction* action, GtkWidget* proxy, UIManager uIManager);
	
	void delegate(Action, Widget, UIManager)[] onDisconnectProxyListeners;
	/**
	 * The disconnect_proxy signal is emitted after disconnecting a proxy
	 * from an action in the group.
	 * Since 2.4
	 */
	void addOnDisconnectProxy(void delegate(Action, Widget, UIManager) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDisconnectProxy(GtkUIManager* uimanagerStruct, GtkAction* action, GtkWidget* proxy, UIManager uIManager);
	
	void delegate(Action, UIManager)[] onPostActivateListeners;
	/**
	 * The post_activate signal is emitted just after the action
	 * is activated.
	 * This is intended for applications to get notification
	 * just after any action is activated.
	 * Since 2.4
	 */
	void addOnPostActivate(void delegate(Action, UIManager) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPostActivate(GtkUIManager* uimanagerStruct, GtkAction* action, UIManager uIManager);
	
	void delegate(Action, UIManager)[] onPreActivateListeners;
	/**
	 * The pre_activate signal is emitted just before the action
	 * is activated.
	 * This is intended for applications to get notification
	 * just before any action is activated.
	 * Since 2.4
	 * See Also
	 * GtkBuilder
	 */
	void addOnPreActivate(void delegate(Action, UIManager) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPreActivate(GtkUIManager* uimanagerStruct, GtkAction* action, UIManager uIManager);
	
	
	/**
	 * Creates a new ui manager object.
	 * Since 2.4
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets the "add_tearoffs" property, which controls whether menus
	 * generated by this GtkUIManager will have tearoff menu items.
	 * Note that this only affects regular menus. Generated popup
	 * menus never have tearoff menu items.
	 * Since 2.4
	 * Params:
	 * addTearoffs =  whether tearoff menu items are added
	 */
	public void setAddTearoffs(int addTearoffs);
	
	/**
	 * Returns whether menus generated by this GtkUIManager
	 * will have tearoff menu items.
	 * Since 2.4
	 * Returns: whether tearoff menu items are added
	 */
	public int getAddTearoffs();
	
	/**
	 * Inserts an action group into the list of action groups associated
	 * with self. Actions in earlier groups hide actions with the same
	 * name in later groups.
	 * Since 2.4
	 * Params:
	 * actionGroup =  the action group to be inserted
	 * pos =  the position at which the group will be inserted.
	 */
	public void insertActionGroup(ActionGroup actionGroup, int pos);

	/**
	 * Removes an action group from the list of action groups associated
	 * with self.
	 * Since 2.4
	 * Params:
	 * actionGroup =  the action group to be removed
	 */
	public void removeActionGroup(ActionGroup actionGroup);
	
	/**
	 * Returns the list of action groups associated with self.
	 * Since 2.4
	 * Returns: a GList of action groups. The list is owned by GTK+  and should not be modified.
	 */
	public ListG getActionGroups();
	
	/**
	 * Returns the GtkAccelGroup associated with self.
	 * Since 2.4
	 * Returns: the GtkAccelGroup.
	 */
	public AccelGroup getAccelGroup();
	
	/**
	 * Looks up a widget by following a path.
	 * The path consists of the names specified in the XML description of the UI.
	 * separated by '/'. Elements which don't have a name or action attribute in
	 * the XML (e.g. <popup>) can be addressed by their XML element name
	 * (e.g. "popup"). The root element ("/ui") can be omitted in the path.
	 * Note that the widget found by following a path that ends in a <menu>
	 * element is the menuitem to which the menu is attached, not the menu itself.
	 * Also note that the widgets constructed by a ui manager are not tied to
	 * the lifecycle of the ui manager. If you add the widgets returned by this
	 * function to some container or explicitly ref them, they will survive the
	 * destruction of the ui manager.
	 * Since 2.4
	 * Params:
	 * path =  a path
	 * Returns: the widget found by following the path, or NULL if no widget was found.
	 */
	public Widget getWidget(string path);
	
	/**
	 * Obtains a list of all toplevel widgets of the requested types.
	 * Since 2.4
	 * Params:
	 * types =  specifies the types of toplevel widgets to include. Allowed
	 *  types are GTK_UI_MANAGER_MENUBAR, GTK_UI_MANAGER_TOOLBAR and
	 *  GTK_UI_MANAGER_POPUP.
	 * Returns: a newly-allocated GSList of all toplevel widgets of therequested types. Free the returned list with g_slist_free().
	 */
	public ListSG getToplevels(GtkUIManagerItemType types);
	
	/**
	 * Looks up an action by following a path. See gtk_ui_manager_get_widget()
	 * for more information about paths.
	 * Since 2.4
	 * Params:
	 * path =  a path
	 * Returns: the action whose proxy widget is found by following the path,  or NULL if no widget was found.
	 */
	public Action getAction(string path);
	
	/**
	 * Parses a string containing a UI definition and
	 * merges it with the current contents of self. An enclosing <ui>
	 * element is added if it is missing.
	 * Since 2.4
	 * Params:
	 * buffer =  the string to parse
	 * length =  the length of buffer (may be -1 if buffer is nul-terminated)
	 * Returns: The merge id for the merged UI. The merge id can be used to unmerge the UI with gtk_ui_manager_remove_ui(). If an error occurred, the return value is 0.
	 * Throws: GException on failure.
	 */
	public uint addUiFromString(string buffer, int length);
	
	/**
	 * Parses a file containing a UI definition and
	 * merges it with the current contents of self.
	 * Since 2.4
	 * Params:
	 * filename =  the name of the file to parse
	 * Returns: The merge id for the merged UI. The merge id can be used to unmerge the UI with gtk_ui_manager_remove_ui(). If an error occurred, the return value is 0.
	 * Throws: GException on failure.
	 */
	public uint addUiFromFile(string filename);
	
	/**
	 * Returns an unused merge id, suitable for use with
	 * gtk_ui_manager_add_ui().
	 * Since 2.4
	 * Returns: an unused merge id.
	 */
	public uint newMergeId();
	
	/**
	 * Adds a UI element to the current contents of self.
	 * If type is GTK_UI_MANAGER_AUTO, GTK+ inserts a menuitem, toolitem or
	 * separator if such an element can be inserted at the place determined by
	 * path. Otherwise type must indicate an element that can be inserted at
	 * the place determined by path.
	 * If path points to a menuitem or toolitem, the new element will be inserted
	 * before or after this item, depending on top.
	 * Since 2.4
	 * Params:
	 * mergeId =  the merge id for the merged UI, see gtk_ui_manager_new_merge_id()
	 * path =  a path
	 * name =  the name for the added UI element
	 * action =  the name of the action to be proxied, or NULL to add a separator
	 * type =  the type of UI element to add.
	 * top =  if TRUE, the UI element is added before its siblings, otherwise it
	 *  is added after its siblings.
	 */
	public void addUi(uint mergeId, string path, string name, string action, GtkUIManagerItemType type, int top);
	
	/**
	 * Unmerges the part of selfs content identified by merge_id.
	 * Since 2.4
	 * Params:
	 * mergeId =  a merge id as returned by gtk_ui_manager_add_ui_from_string()
	 */
	public void removeUi(uint mergeId);
	
	/**
	 * Creates a UI definition of the merged UI.
	 * Since 2.4
	 * Returns: A newly allocated string containing an XML representation of the merged UI.
	 */
	public string getUi();
	
	/**
	 * Makes sure that all pending updates to the UI have been completed.
	 * This may occasionally be necessary, since GtkUIManager updates the
	 * UI in an idle function. A typical example where this function is
	 * useful is to enforce that the menubar and toolbar have been added to
	 * Since 2.4
	 */
	public void ensureUpdate();
}
