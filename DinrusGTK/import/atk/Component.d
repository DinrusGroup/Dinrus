
module gtkD.atk.Component;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.atk.ObjectAtk;




/**
 * Description
 * AtkComponent should be implemented by most if not all UI elements with
 * an actual on-screen presence, i.e. components which can be said to have
 * a screen-coordinate bounding box. Virtually all widgets will need to
 * have AtkComponent implementations provided for their corresponding
 * AtkObject class. In short, only UI elements which are *not* GUI
 * elements will omit this ATK interface.
 * A possible exception might be textual information with a transparent
 * background, in which case text glyph bounding box information is
 * provided by AtkText.
 */
public class Component
{
	
	/** the main Gtk struct */
	protected AtkComponent* atkComponent;
	
	
	public AtkComponent* getComponentStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkComponent* atkComponent);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(AtkRectangle*, Component)[] onBoundsChangedListeners;
	/**
	 * The 'bounds-changed" signal is emitted when the bposition or size of the
	 * a component changes.
	 */
	void addOnBoundsChanged(void delegate(AtkRectangle*, Component) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackBoundsChanged(AtkComponent* atkcomponentStruct, AtkRectangle* arg1, Component component);
	
	
	/**
	 * Add the specified handler to the set of functions to be called
	 * when this object receives focus events (in or out). If the handler is
	 * already added it is not added again
	 * Params:
	 * handler =  The AtkFocusHandler to be attached to component
	 * Returns: a handler id which can be used in atk_component_remove_focus_handleror zero if the handler was already added.
	 */
	public uint addFocusHandler(AtkFocusHandler handler);
	
	/**
	 * Checks whether the specified point is within the extent of the component.
	 * Params:
	 * x =  x coordinate
	 * y =  y coordinate
	 * coordType =  specifies whether the coordinates are relative to the screen
	 * or to the components top level window
	 * Returns: TRUE or FALSE indicating whether the specified point is withinthe extent of the component or not
	 */
	public int contains(int x, int y, AtkCoordType coordType);
	
	/**
	 * Gets the rectangle which gives the extent of the component.
	 * Params:
	 * x =  address of gint to put x coordinate
	 * y =  address of gint to put y coordinate
	 * width =  address of gint to put width
	 * height =  address of gint to put height
	 * coordType =  specifies whether the coordinates are relative to the screen
	 * or to the components top level window
	 */
	public void getExtents(out int x, out int y, out int width, out int height, AtkCoordType coordType);
	
	/**
	 * Gets the layer of the component.
	 * Returns: an AtkLayer which is the layer of the component
	 */
	public AtkLayer getLayer();
	
	/**
	 * Gets the zorder of the component. The value G_MININT will be returned
	 * if the layer of the component is not ATK_LAYER_MDI or ATK_LAYER_WINDOW.
	 * Returns: a gint which is the zorder of the component, i.e. the depth at which the component is shown in relation to other components in the same container.
	 */
	public int getMdiZorder();
	
	/**
	 * Gets the position of component in the form of
	 * a point specifying component's top-left corner.
	 * Params:
	 * x =  address of gint to put x coordinate position
	 * y =  address of gint to put y coordinate position
	 * coordType =  specifies whether the coordinates are relative to the screen
	 * or to the components top level window
	 */
	public void getPosition(out int x, out int y, AtkCoordType coordType);
	
	/**
	 * Gets the size of the component in terms of width and height.
	 * Params:
	 * width =  address of gint to put width of component
	 * height =  address of gint to put height of component
	 */
	public void getSize(out int width, out int height);
	
	/**
	 * Grabs focus for this component.
	 * Returns: TRUE if successful, FALSE otherwise.
	 */
	public int grabFocus();
	
	/**
	 * Gets a reference to the accessible child, if one exists, at the
	 * coordinate point specified by x and y.
	 * Params:
	 * x =  x coordinate
	 * y =  y coordinate
	 * coordType =  specifies whether the coordinates are relative to the screen
	 * or to the components top level window
	 * Returns: a reference to the accessible child, if one exists
	 */
	public ObjectAtk refAccessibleAtPoint(int x, int y, AtkCoordType coordType);
	
	/**
	 * Remove the handler specified by handler_id from the list of
	 * functions to be executed when this object receives focus events
	 * (in or out).
	 * Params:
	 * handlerId =  the handler id of the focus handler to be removed
	 * from component
	 */
	public void removeFocusHandler(uint handlerId);
	
	/**
	 * Sets the extents of component.
	 * Params:
	 * x =  x coordinate
	 * y =  y coordinate
	 * width =  width to set for component
	 * height =  height to set for component
	 * coordType =  specifies whether the coordinates are relative to the screen
	 * or to the components top level window
	 * Returns: TRUE or FALSE whether the extents were set or not
	 */
	public int setExtents(int x, int y, int width, int height, AtkCoordType coordType);
	
	/**
	 * Sets the postition of component.
	 * Params:
	 * x =  x coordinate
	 * y =  y coordinate
	 * coordType =  specifies whether the coordinates are relative to the screen
	 * or to the components top level window
	 * Returns: TRUE or FALSE whether or not the position was set or not
	 */
	public int setPosition(int x, int y, AtkCoordType coordType);
	
	/**
	 * Set the size of the component in terms of width and height.
	 * Params:
	 * width =  width to set for component
	 * height =  height to set for component
	 * Returns: TRUE or FALSE whether the size was set or not
	 */
	public int setSize(int width, int height);
	
	/**
	 * Returns the alpha value (i.e. the opacity) for this
	 * component, on a scale from 0 (fully transparent) to 1.0
	 * (fully opaque).
	 * Since 1.12
	 * Signal Details
	 * The "bounds-changed" signal
	 * void user_function (AtkComponent *atkcomponent,
	 *  AtkRectangle *arg1,
	 *  gpointer user_data) : Run Last
	 * The 'bounds-changed" signal is emitted when the bposition or size of the
	 * a component changes.
	 * Returns: An alpha value from 0 to 1.0, inclusive.
	 */
	public double getAlpha();
}
