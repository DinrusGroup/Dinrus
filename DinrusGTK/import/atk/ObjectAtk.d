module gtkD.atk.ObjectAtk;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.atk.ObjectAtk;
private import gtkD.atk.RelationSet;
private import gtkD.atk.StateSet;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * This class is the primary class for accessibility support via
 * the Accessibility ToolKit (ATK). Objects which are instances
 * of AtkObject (or instances of AtkObject-derived types) are
 * queried for properties which relate basic (and generic) properties of a
 * UI component such as name and description. Instances of AtkObject
 * may also be queried as to whether they implement other ATK interfaces
 * (e.g. AtkAction, AtkComponent, etc.), as appropriate to the role
 * which a given UI component plays in a user interface.
 * All UI components in an application which provide useful
 * information or services to the user must provide corresponding
 * AtkObject instances on request (in GTK+, for instance, usually
 * on a call to #gtk_widget_get_accessible()), either via ATK support
 * built into the toolkit for the widget class or ancestor class, or in
 * the case of custom widgets, if the inherited AtkObject implementation
 * is insufficient, via instances of a new AtkObject subclass.
 */
public class ObjectAtk : ObjectG
{

	/** the main Gtk struct */
	protected AtkObject* atkObject;


	public AtkObject* getObjectAtkStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkObject* atkObject);

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(gpointer, ObjectAtk)[] onActiveDescendantChangedListeners;
	/**
	 * The "active-descendant-changed" signal is emitted by an object which has
	 * the state ATK_STATE_MANAGES_DESCENDANTS when the focus object in the
	 * object changes. For instance, a table will emit the signal when the cell
	 * in the table which has focus changes.
	 */
	void addOnActiveDescendantChanged(void delegate(gpointer, ObjectAtk) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackActiveDescendantChanged(AtkObject* atkobjectStruct, gpointer arg1, ObjectAtk objectAtk);


	void delegate(guint, gpointer, ObjectAtk)[] onChildrenChangedListeners;
	/**
	 * The signal "children-changed" is emitted when a child is added or
	 * removed form an object. It supports two details: "add" and "remove"
	 */
	void addOnChildrenChanged(void delegate(guint, gpointer, ObjectAtk) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackChildrenChanged(AtkObject* atkobjectStruct, guint arg1, gpointer arg2, ObjectAtk objectAtk);
	void delegate(gboolean, ObjectAtk)[] onFocusListeners;
	/**
	 * The signal "focus-event" is emitted when an object gains or loses focus.
	 */
	void addOnFocus(void delegate(gboolean, ObjectAtk) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackFocus(AtkObject* atkobjectStruct, gboolean arg1, ObjectAtk objectAtk);

	void delegate(gpointer, ObjectAtk)[] onPropertyChangeListeners;
	/**
	 * The signal "property-change" is emitted when an object's property
	 * value changes. The detail identifies the name of the property whose
	 * value has changed.
	 */
	void addOnPropertyChange(void delegate(gpointer, ObjectAtk) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPropertyChange(AtkObject* atkobjectStruct, gpointer arg1, ObjectAtk objectAtk);


	void delegate(string, gboolean, ObjectAtk)[] onStateChangeListeners;
	/**
	 * The "state-change" signal is emitted when an object's state changes.
	 * The detail value identifies the state type which has changed.
	 */
	void addOnStateChange(void delegate(string, gboolean, ObjectAtk) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackStateChange(AtkObject* atkobjectStruct, gchar* arg1, gboolean arg2, ObjectAtk objectAtk);

	void delegate(ObjectAtk)[] onVisibleDataChangedListeners;
	/**
	 * The "visible-data-changed" signal is emitted when the visual appearance of
	 * the object changed.
	 * See Also
	 * See also: AtkObjectFactory, AtkRegistry.
	 * ( GTK+ users see also GtkAccessible).
	 */
	void addOnVisibleDataChanged(void delegate(ObjectAtk) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackVisibleDataChanged(AtkObject* atkobjectStruct, ObjectAtk objectAtk);


	/**
	 * Registers the role specified by name.
	 * Params:
	 * name =  a character string describing the new role.
	 * Returns: an AtkRole for the new role.
	 */
	public static AtkRole roleRegister(string name);

	/**
	 * Gets a reference to an object's AtkObject implementation, if
	 * the object implements AtkObjectIface
	 * Params:
	 * implementor =  The GObject instance which should implement AtkImplementorIface
	 * if a non-null return value is required.
	 * Returns: a reference to an object's AtkObject implementation
	 */
	public static ObjectAtk implementorRefAccessible(AtkImplementor* implementor);

	/**
	 * Gets the accessible name of the accessible.
	 * Returns: a character string representing the accessible name of the object.
	 */
	public string getName();

	/**
	 * Gets the accessible description of the accessible.
	 * Returns: a character string representing the accessible descriptionof the accessible.
	 */
	public string getDescription();

	/**
	 * Gets the accessible parent of the accessible.
	 * Returns: a AtkObject representing the accessible parent of the accessible
	 */
	public ObjectAtk getParent();

	/**
	 * Gets the number of accessible children of the accessible.
	 * Returns: an integer representing the number of accessible childrenof the accessible.
	 */
	public int getNAccessibleChildren();

	/**
	 * Gets a reference to the specified accessible child of the object.
	 * The accessible children are 0-based so the first accessible child is
	 * at index 0, the second at index 1 and so on.
	 * Params:
	 * i =  a gint representing the position of the child, starting from 0
	 * Returns: an AtkObject representing the specified accessible childof the accessible.
	 */
	public ObjectAtk refAccessibleChild(int i);

	/**
	 * Gets the AtkRelationSet associated with the object.
	 * Returns: an AtkRelationSet representing the relation set of the object.
	 */
	public RelationSet refRelationSet();

	/**
	 * Warning
	 * atk_object_get_layer is deprecated and should not be used in newly-written code. Use atk_component_get_layer instead.
	 * Gets the layer of the accessible.
	 * Returns: an AtkLayer which is the layer of the accessible
	 */
	public AtkLayer getLayer();

	/**
	 * Warning
	 * atk_object_get_mdi_zorder is deprecated and should not be used in newly-written code. Use atk_component_get_mdi_zorder instead.
	 * Gets the zorder of the accessible. The value G_MININT will be returned
	 * if the layer of the accessible is not ATK_LAYER_MDI.
	 * Returns: a gint which is the zorder of the accessible, i.e. the depth at which the component is shown in relation to other components in the same container.
	 */
	public int getMdiZorder();

	/**
	 * Gets the role of the accessible.
	 * Returns: an AtkRole which is the role of the accessible
	 */
	public AtkRole getRole();

	/**
	 * Gets a reference to the state set of the accessible; the caller must
	 * unreference it when it is no longer needed.
	 * Returns: a reference to an AtkStateSet which is the stateset of the accessible
	 */
	public StateSet refStateSet();

	/**
	 * Gets the 0-based index of this accessible in its parent; returns -1 if the
	 * accessible does not have an accessible parent.
	 * Returns: an integer which is the index of the accessible in its parent
	 */
	public int getIndexInParent();

	/**
	 * Sets the accessible name of the accessible.
	 * Params:
	 * name =  a character string to be set as the accessible name
	 */
	public void setName(string name);

	/**
	 * Sets the accessible description of the accessible.
	 * Params:
	 * description =  a character string to be set as the accessible description
	 */
	public void setDescription(string description);

	/**
	 * Sets the accessible parent of the accessible.
	 * Params:
	 * parent =  an AtkObject to be set as the accessible parent
	 */
	public void setParent(ObjectAtk parent);

	/**
	 * Sets the role of the accessible.
	 * Params:
	 * role =  an AtkRole to be set as the role
	 */
	public void setRole(AtkRole role);

	/**
	 * Specifies a function to be called when a property changes value.
	 * Params:
	 * handler =  a function to be called when a property changes its value
	 * Returns: a guint which is the handler id used in atk_object_remove_property_change_handler()
	 */
	public uint connectPropertyChangeHandler(AtkPropertyChangeHandler* handler);

	/**
	 * Removes a property change handler.
	 * Params:
	 * handlerId =  a guint which identifies the handler to be removed.
	 */
	public void removePropertyChangeHandler(uint handlerId);

	/**
	 * Emits a state-change signal for the specified state.
	 * Params:
	 * state =  an AtkState whose state is changed
	 * value =  a gboolean which indicates whether the state is being set on or off
	 */
	public void notifyStateChange(AtkState state, int value);

	/**
	 * This function is called when implementing subclasses of AtkObject.
	 * It does initialization required for the new object. It is intended
	 * that this function should called only in the ..._new() functions used
	 * to create an instance of a subclass of AtkObject
	 * Params:
	 * data =  a gpointer which identifies the object for which the AtkObject was created.
	 */
	public void initialize(void* data);

	/**
	 * Adds a relationship of the specified type with the specified target.
	 * Params:
	 * relationship =  The AtkRelationType of the relation
	 * target =  The AtkObject which is to be the target of the relation.
	 * Returns:TRUE if the relationship is added.
	 */
	public int addRelationship(AtkRelationType relationship, ObjectAtk target);

	/**
	 * Removes a relationship of the specified type with the specified target.
	 * Params:
	 * relationship =  The AtkRelationType of the relation
	 * target =  The AtkObject which is the target of the relation to be removed.
	 * Returns:TRUE if the relationship is removed.
	 */
	public int removeRelationship(AtkRelationType relationship, ObjectAtk target);

	/**
	 * Get a list of properties applied to this object as a whole, as an AtkAttributeSet consisting of
	 * name-value pairs. As such these attributes may be considered weakly-typed properties or annotations,
	 * as distinct from strongly-typed object data available via other get/set methods.
	 * Not all objects have explicit "name-value pair" AtkAttributeSet properties.
	 * Since 1.12
	 * Returns: an AtkAttributeSet consisting of all explicit properties/annotations applied to the object, or an empty set if the object has no name-value pair attributes assigned to it.
	 */
	public AtkAttributeSet* getAttributes();

	/**
	 * Gets the description string describing the AtkRole role.
	 * Params:
	 * role =  The AtkRole whose name is required
	 * Returns: the string describing the AtkRole
	 */
	public static string roleGetName(AtkRole role);

	/**
	 * Gets the localized description string describing the AtkRole role.
	 * Params:
	 * role =  The AtkRole whose localized name is required
	 * Returns: the localized string describing the AtkRole
	 */
	public static string roleGetLocalizedName(AtkRole role);

	/**
	 * Get the AtkRole type corresponding to a rolew name.
	 * Params:
	 * name =  a string which is the (non-localized) name of an ATK role.
	 * Returns: the AtkRole enumerated type corresponding to the specifiedname, or ATK_ROLE_INVALID if no matching role is found.
	 */
	public static AtkRole roleForName(string name);
}
