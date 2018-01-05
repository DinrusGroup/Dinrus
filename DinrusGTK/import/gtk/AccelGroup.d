module gtkD.gtk.AccelGroup;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gobject.Closure;
private import gtkD.gobject.ObjectG;
private import gtkD.gtk.AccelGroup;
private import gtkD.glib.ListSG;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkAccelGroup represents a group of keyboard accelerators,
 * typically attached to a toplevel GtkWindow (with
 * gtk_window_add_accel_group()). Usually you won't need to create a
 * GtkAccelGroup directly; instead, when using GtkItemFactory, GTK+
 * automatically sets up the accelerators for your menus in the item
 * factory's GtkAccelGroup.
 * Note that accelerators are different from
 * mnemonics. Accelerators are shortcuts for
 * activating a menu item; they appear alongside the menu item they're a
 * shortcut for. For example "Ctrl+Q" might appear alongside the "Quit"
 * menu item. Mnemonics are shortcuts for GUI elements such as text
 * entries or buttons; they appear as underlined characters. See
 * gtk_label_new_with_mnemonic(). Menu items can have both accelerators
 * and mnemonics, of course.
 */
public class AccelGroup : ObjectG
{

	/** the main Gtk struct */
	protected GtkAccelGroup* gtkAccelGroup;


	public GtkAccelGroup* getAccelGroupStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkAccelGroup* gtkAccelGroup);

	/**
	 */
	int[char[]] connectedSignals;

	bool delegate(ObjectG, guint, GdkModifierType, AccelGroup)[] onAccelActivateListeners;
	/**
	 * The accel-activate signal is an implementation detail of
	 * GtkAccelGroup and not meant to be used by applications.
	 */
	void addOnAccelActivate(bool delegate(ObjectG, guint, GdkModifierType, AccelGroup) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static gboolean callBackAccelActivate(GtkAccelGroup* accelGroupStruct, GObject* acceleratable, guint keyval, GdkModifierType modifier, AccelGroup accelGroup);

	void delegate(guint, GdkModifierType, Closure, AccelGroup)[] onAccelChangedListeners;
	/**
	 * The accel-changed signal is emitted when a GtkAccelGroupEntry
	 * is added to or removed from the accel group.
	 * Widgets like GtkAccelLabel which display an associated
	 * accelerator should connect to this signal, and rebuild
	 * their visual representation if the accel_closure is theirs.
	 * See Also
	 * gtk_window_add_accel_group(), gtk_accel_map_change_entry(),
	 * gtk_item_factory_new(), gtk_label_new_with_mnemonic()
	 */
	void addOnAccelChanged(void delegate(guint, GdkModifierType, Closure, AccelGroup) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAccelChanged(GtkAccelGroup* accelGroupStruct, guint keyval, GdkModifierType modifier, GClosure* accelClosure, AccelGroup accelGroup);


	/**
	 * Creates a new GtkAccelGroup.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();

	/**
	 * Installs an accelerator in this group. When accel_group is being activated
	 * in response to a call to gtk_accel_groups_activate(), closure will be
	 * invoked if the accel_key and accel_mods from gtk_accel_groups_activate()
	 * match those of this connection.
	 * The signature used for the closure is that of GtkAccelGroupActivate.
	 * Note that, due to implementation details, a single closure can only be
	 * connected to one accelerator group.
	 * Params:
	 * accelKey =  key value of the accelerator
	 * accelMods =  modifier combination of the accelerator
	 * accelFlags =  a flag mask to configure this accelerator
	 * closure =  closure to be executed upon accelerator activation
	 */
	public void connect(uint accelKey, GdkModifierType accelMods, GtkAccelFlags accelFlags, Closure closure);

	/**
	 * Installs an accelerator in this group, using an accelerator path to look
	 * up the appropriate key and modifiers (see gtk_accel_map_add_entry()).
	 * When accel_group is being activated in response to a call to
	 * gtk_accel_groups_activate(), closure will be invoked if the accel_key and
	 * accel_mods from gtk_accel_groups_activate() match the key and modifiers
	 * for the path.
	 * The signature used for the closure is that of GtkAccelGroupActivate.
	 * Note that accel_path string will be stored in a GQuark. Therefore, if you
	 * pass a static string, you can save some memory by interning it first with
	 * g_intern_static_string().
	 * Params:
	 * accelPath =  path used for determining key and modifiers.
	 * closure =  closure to be executed upon accelerator activation
	 */
	public void connectByPath(string accelPath, Closure closure);

	/**
	 * Removes an accelerator previously installed through
	 * gtk_accel_group_connect().
	 * Params:
	 * closure =  the closure to remove from this accelerator group
	 * Returns: TRUE if the closure was found and got disconnected
	 */
	public int disconnect(Closure closure);

	/**
	 * Removes an accelerator previously installed through
	 * gtk_accel_group_connect().
	 * Params:
	 * accelKey =  key value of the accelerator
	 * accelMods =  modifier combination of the accelerator
	 * Returns: TRUE if there was an accelerator which could be  removed, FALSE otherwise
	 */
	public int disconnectKey(uint accelKey, GdkModifierType accelMods);

	/**
	 * Queries an accelerator group for all entries matching accel_key and
	 * accel_mods.
	 * Params:
	 * accelKey =  key value of the accelerator
	 * accelMods =  modifier combination of the accelerator
	 * Returns: an array of n_entries GtkAccelGroupEntry elements, or NULL. The array is owned by GTK+ and must not be freed.
	 */
	public GtkAccelGroupEntry[] query(uint accelKey, GdkModifierType accelMods);

	/**
	 * Finds the first accelerator in accel_group
	 * that matches accel_key and accel_mods, and
	 * activates it.
	 * Params:
	 * accelQuark =  the quark for the accelerator name
	 * acceleratable =  the GObject, usually a GtkWindow, on which
	 *  to activate the accelerator.
	 * accelKey =  accelerator keyval from a key event
	 * accelMods =  keyboard state mask from a key event
	 * Returns: TRUE if an accelerator was activated and handled this keypress
	 */
	public int activate(GQuark accelQuark, ObjectG acceleratable, uint accelKey, GdkModifierType accelMods);

	/**
	 * Locks the given accelerator group.
	 * Locking an acelerator group prevents the accelerators contained
	 * within it to be changed during runtime. Refer to
	 * gtk_accel_map_change_entry() about runtime accelerator changes.
	 * If called more than once, accel_group remains locked until
	 * gtk_accel_group_unlock() has been called an equivalent number
	 * of times.
	 */
	public void lock();

	/**
	 * Undoes the last call to gtk_accel_group_lock() on this accel_group.
	 */
	public void unlock();

	/**
	 * Locks are added and removed using gtk_accel_group_lock() and
	 * gtk_accel_group_unlock().
	 * Since 2.14
	 * Returns: TRUE if there are 1 or more locks on the accel_group,FALSE otherwise.
	 */
	public int getIsLocked();

	/**
	 * Finds the GtkAccelGroup to which closure is connected;
	 * see gtk_accel_group_connect().
	 * Params:
	 * closure =  a GClosure
	 * Returns: the GtkAccelGroup to which closure is connected, or NULL.
	 */
	public static AccelGroup fromAccelClosure(Closure closure);

	/**
	 * Gets a GdkModifierType representing the mask for this
	 * accel_group. For example, GDK_CONTROL_MASK, GDK_SHIFT_MASK, etc.
	 * Since 2.14
	 * Returns: the modifier mask for this accel group.
	 */
	public GdkModifierType getModifierMask();

	/**
	 * Finds the first accelerator in any GtkAccelGroup attached
	 * to object that matches accel_key and accel_mods, and
	 * activates that accelerator.
	 * Params:
	 * object =  the GObject, usually a GtkWindow, on which
	 *  to activate the accelerator.
	 * accelKey =  accelerator keyval from a key event
	 * accelMods =  keyboard state mask from a key event
	 * Returns: TRUE if an accelerator was activated and handled this keypress
	 */
	public static int accelGroupsActivate(ObjectG object, uint accelKey, GdkModifierType accelMods);

	/**
	 * Gets a list of all accel groups which are attached to object.
	 * Params:
	 * object =  a GObject, usually a GtkWindow
	 * Returns: a list of all accel groups which are attached to object
	 */
	public static ListSG accelGroupsFromObject(ObjectG object);

	/**
	 * Finds the first entry in an accelerator group for which
	 * find_func returns TRUE and returns its GtkAccelKey.
	 * Params:
	 * findFunc =  a function to filter the entries of accel_group with
	 * data =  data to pass to find_func
	 * Returns: the key of the first entry passing find_func. The key is owned by GTK+ and must not be freed.
	 */
	public GtkAccelKey* find(GtkAccelGroupFindFunc findFunc, void* data);

	/**
	 * Determines whether a given keyval and modifier mask constitute
	 * a valid keyboard accelerator. For example, the GDK_a keyval
	 * plus GDK_CONTROL_MASK is valid - this is a "Ctrl+a" accelerator.
	 * But, you can't, for instance, use the GDK_Control_L keyval
	 * as an accelerator.
	 * Params:
	 * keyval =  a GDK keyval
	 * modifiers =  modifier mask
	 * Returns: TRUE if the accelerator is valid
	 */
	public static int acceleratorValid(uint keyval, GdkModifierType modifiers);

	/**
	 * Parses a string representing an accelerator. The
	 * format looks like "<Control>a" or "<Shift><Alt>F1" or
	 * "<Release>z" (the last one is for key release).
	 * The parser is fairly liberal and allows lower or upper case,
	 * and also abbreviations such as "<Ctl>" and "<Ctrl>".
	 * If the parse fails, accelerator_key and accelerator_mods will
	 * be set to 0 (zero).
	 * Params:
	 * accelerator =  string representing an accelerator
	 * acceleratorKey =  return location for accelerator keyval
	 * acceleratorMods =  return location for accelerator modifier mask
	 */
	public static void acceleratorParse(string accelerator, out uint acceleratorKey, out GdkModifierType acceleratorMods);

	/**
	 * Converts an accelerator keyval and modifier mask
	 * into a string parseable by gtk_accelerator_parse().
	 * For example, if you pass in GDK_q and GDK_CONTROL_MASK,
	 * this function returns "<Control>q".
	 * If you need to display accelerators in the user interface,
	 * see gtk_accelerator_get_label().
	 * Params:
	 * acceleratorKey =  accelerator keyval
	 * acceleratorMods =  accelerator modifier mask
	 * Returns: a newly-allocated accelerator name
	 */
	public static string acceleratorName(uint acceleratorKey, GdkModifierType acceleratorMods);

	/**
	 * Converts an accelerator keyval and modifier mask into a string
	 * which can be used to represent the accelerator to the user.
	 * Since 2.6
	 * Params:
	 * acceleratorKey =  accelerator keyval
	 * acceleratorMods =  accelerator modifier mask
	 * Returns: a newly-allocated string representing the accelerator.
	 */
	public static string acceleratorGetLabel(uint acceleratorKey, GdkModifierType acceleratorMods);

	/**
	 * Sets the modifiers that will be considered significant for keyboard
	 * accelerators. The default mod mask is GDK_CONTROL_MASK |
	 * GDK_SHIFT_MASK | GDK_MOD1_MASK | GDK_SUPER_MASK |
	 * GDK_HYPER_MASK | GDK_META_MASK, that is, Control, Shift, Alt,
	 * Super, Hyper and Meta. Other modifiers will by default be ignored
	 * by GtkAccelGroup.
	 * You must include at least the three modifiers Control, Shift
	 * and Alt in any value you pass to this function.
	 * The default mod mask should be changed on application startup,
	 * before using any accelerator groups.
	 * Params:
	 * defaultModMask =  accelerator modifier mask
	 */
	public static void acceleratorSetDefaultModMask(GdkModifierType defaultModMask);

	/**
	 * Gets the value set by gtk_accelerator_set_default_mod_mask().
	 * Returns: the default accelerator modifier mask
	 */
	public static uint acceleratorGetDefaultModMask();
}
