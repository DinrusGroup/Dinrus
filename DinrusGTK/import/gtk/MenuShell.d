module gtkD.gtk.MenuShell;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.Widget;



private import gtkD.gtk.Container;

/**
 * Description
 * A GtkMenuShell is the abstract base class used to derive the
 * GtkMenu and GtkMenuBar subclasses.
 * A GtkMenuShell is a container of GtkMenuItem objects arranged in a
 * list which can be navigated, selected, and activated by the user to perform
 * application functions. A GtkMenuItem can have a submenu associated with it,
 * allowing for nested hierarchical menus.
 */
public class MenuShell : Container
{
	
	/** the main Gtk struct */
	protected GtkMenuShell* gtkMenuShell;
	
	
	public GtkMenuShell* getMenuShellStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkMenuShell* gtkMenuShell);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(gboolean, MenuShell)[] onActivateCurrentListeners;
	/**
	 * An action signal that activates the current menu item within the menu
	 * shell.
	 */
	void addOnActivateCurrent(void delegate(gboolean, MenuShell) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackActivateCurrent(GtkMenuShell* menushellStruct, gboolean forceHide, MenuShell menuShell);
	
	void delegate(MenuShell)[] onCancelListeners;
	/**
	 * An action signal which cancels the selection within the menu shell.
	 * Causes the GtkMenuShell::selection-done signal to be emitted.
	 */
	void addOnCancel(void delegate(MenuShell) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCancel(GtkMenuShell* menushellStruct, MenuShell menuShell);
	
	void delegate(GtkDirectionType, MenuShell)[] onCycleFocusListeners;
	/**
	 */
	void addOnCycleFocus(void delegate(GtkDirectionType, MenuShell) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackCycleFocus(GtkMenuShell* menushellStruct, GtkDirectionType arg1, MenuShell menuShell);
	
	void delegate(MenuShell)[] onDeactivateListeners;
	/**
	 * This signal is emitted when a menu shell is deactivated.
	 */
	void addOnDeactivate(void delegate(MenuShell) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDeactivate(GtkMenuShell* menushellStruct, MenuShell menuShell);
	
	void delegate(GtkMenuDirectionType, MenuShell)[] onMoveCurrentListeners;
	/**
	 * An action signal which moves the current menu item in the direction
	 * specified by direction.
	 */
	void addOnMoveCurrent(void delegate(GtkMenuDirectionType, MenuShell) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMoveCurrent(GtkMenuShell* menushellStruct, GtkMenuDirectionType direction, MenuShell menuShell);
	
	bool delegate(gint, MenuShell)[] onMoveSelectedListeners;
	/**
	 * The ::move-selected signal is emitted to move the selection to
	 * another item.
	 * Since 2.12
	 */
	void addOnMoveSelected(bool delegate(gint, MenuShell) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackMoveSelected(GtkMenuShell* menuShellStruct, gint distance, MenuShell menuShell);
	
	void delegate(MenuShell)[] onSelectionDoneListeners;
	/**
	 * This signal is emitted when a selection has been completed within a menu
	 * shell.
	 */
	void addOnSelectionDone(void delegate(MenuShell) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackSelectionDone(GtkMenuShell* menushellStruct, MenuShell menuShell);
	
	
	/**
	 * Adds a new GtkMenuItem to the end of the menu shell's item list.
	 * Params:
	 * child = The GtkMenuItem to add.
	 */
	public void append(Widget child);
	
	/**
	 * Adds a new GtkMenuItem to the beginning of the menu shell's item list.
	 * Params:
	 * child = The GtkMenuItem to add.
	 */
	public void prepend(Widget child);
	
	/**
	 * Adds a new GtkMenuItem to the menu shell's item list at the position
	 * indicated by position.
	 * Params:
	 * child = The GtkMenuItem to add.
	 * position = The position in the item list where child is added.
	 * Positions are numbered from 0 to n-1.
	 */
	public void insert(Widget child, int position);
	
	/**
	 * Deactivates the menu shell. Typically this results in the menu shell
	 * being erased from the screen.
	 */
	public void deactivate();
	
	/**
	 * Selects the menu item from the menu shell.
	 * Params:
	 * menuItem = The GtkMenuItem to select.
	 */
	public void selectItem(Widget menuItem);

	/**
	 * Select the first visible or selectable child of the menu shell;
	 * don't select tearoff items unless the only item is a tearoff
	 * item.
	 * Since 2.2
	 * Params:
	 * searchSensitive =  if TRUE, search for the first selectable
	 *  menu item, otherwise select nothing if
	 *  the first item isn't sensitive. This
	 *  should be FALSE if the menu is being
	 *  popped up initially.
	 */
	public void selectFirst(int searchSensitive);
	
	/**
	 * Deselects the currently selected item from the menu shell, if any.
	 */
	public void deselect();
	
	/**
	 * Activates the menu item within the menu shell.
	 * Params:
	 * menuItem = The GtkMenuItem to activate.
	 * forceDeactivate = If TRUE, force the deactivation of the menu shell
	 * after the menu item is activated.
	 */
	public void activateItem(Widget menuItem, int forceDeactivate);
	
	/**
	 * Cancels the selection within the menu shell.
	 * Since 2.4
	 */
	public void cancel();
	
	/**
	 * If take_focus is TRUE (the default) the menu shell will take the keyboard
	 * focus so that it will receive all keyboard events which is needed to enable
	 * keyboard navigation in menus.
	 * Setting take_focus to FALSE is useful only for special applications
	 * like virtual keyboard implementations which should not take keyboard
	 * focus.
	 * The take_focus state of a menu or menu bar is automatically propagated
	 * to submenus whenever a submenu is popped up, so you don't have to worry
	 * about recursively setting it for your entire menu hierarchy. Only when
	 * programmatically picking a submenu and popping it up manually, the
	 * take_focus property of the submenu needs to be set explicitely.
	 * Since 2.8
	 * Params:
	 * takeFocus =  TRUE if the menu shell should take the keyboard focus on popup.
	 */
	public void setTakeFocus(int takeFocus);
	
	/**
	 * Returns TRUE if the menu shell will take the keyboard focus on popup.
	 * Since 2.8
	 * Returns: TRUE if the menu shell will take the keyboard focus on popup.
	 */
	public int getTakeFocus();
}
