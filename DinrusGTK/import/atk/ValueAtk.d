module gtkD.atk.ValueAtk;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.Value;




/**
 * Description
 * AtkValue should be implemented for components which either display a
 * value from a bounded range, or which allow the user to specify a value
 * from a bounded range, or both. For instance, most sliders and range
 * controls, as well as dials, should have AtkObject representations which
 * implement AtkValue on the component's behalf. AtKValues may be
 * read-only, in which case attempts to alter the value return FALSE to
 * indicate failure.
 */
public class ValueAtk
{
	
	/** the main Gtk struct */
	protected AtkValue* atkValue;
	
	
	public AtkValue* getValueAtkStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkValue* atkValue);
	
	/**
	 */
	
	/**
	 * Gets the value of this object.
	 * Params:
	 * value =  a GValue representing the current accessible value
	 */
	public void getCurrentValue(Value value);
	
	/**
	 * Gets the maximum value of this object.
	 * Params:
	 * value =  a GValue representing the maximum accessible value
	 */
	public void getMaximumValue(Value value);
	
	/**
	 * Gets the minimum value of this object.
	 * Params:
	 * value =  a GValue representing the minimum accessible value
	 */
	public void getMinimumValue(Value value);
	
	/**
	 * Sets the value of this object.
	 * Params:
	 * value =  a GValue which is the desired new accessible value.
	 * Returns: TRUE if new value is successfully set, FALSE otherwise.
	 */
	public int setCurrentValue(Value value);
	
	/**
	 * Gets the minimum increment by which the value of this object may be changed. If zero,
	 * the minimum increment is undefined, which may mean that it is limited only by the
	 * floating point precision of the platform.
	 * Since 1.12
	 * Params:
	 * value =  a GValue representing the minimum increment by which the accessible value may be changed
	 */
	public void getMinimumIncrement(Value value);
}
