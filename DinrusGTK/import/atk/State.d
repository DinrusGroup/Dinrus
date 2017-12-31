module gtkD.atk.State;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * An AtkState describes a component's particular state. The actual state of
 * an component is described by its AtkStateSet, which is a set of AtkStates.
 */
public class State
{
	
	/**
	 */
	
	/**
	 * Register a new object state.
	 * Params:
	 * name =  a character string describing the new state.
	 * Returns: an AtkState value for the new state.
	 */
	public static AtkStateType typeRegister(string name);
	
	/**
	 * Gets the description string describing the AtkStateType type.
	 * Params:
	 * type =  The AtkStateType whose name is required
	 * Returns: the string describing the AtkStateType
	 */
	public static string typeGetName(AtkStateType type);
	
	/**
	 * Gets the AtkStateType corresponding to the description string name.
	 * Params:
	 * name =  a character string state name
	 * Returns: an AtkStateType corresponding to name
	 */
	public static AtkStateType typeForName(string name);
}
