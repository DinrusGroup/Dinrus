module gtkD.atk.StateSet;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * An AtkStateSet determines a component's state set. It is composed of a set
 * of AtkStates.
 */
public class StateSet : ObjectG
{
	
	/** the main Gtk struct */
	protected AtkStateSet* atkStateSet;
	
	
	public AtkStateSet* getStateSetStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkStateSet* atkStateSet);
	
	/**
	 */
	
	/**
	 * Creates a new empty state set.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Checks whether the state set is empty, i.e. has no states set.
	 * Returns: TRUE if set has no states set, otherwise FALSE
	 */
	public int isEmpty();
	
	/**
	 * Add a new state for the specified type to the current state set if
	 * it is not already present.
	 * Params:
	 * type =  an AtkStateType
	 * Returns: TRUE if the state for type is not already in set.
	 */
	public int addState(AtkStateType type);
	
	/**
	 * Add the states for the specified types to the current state set.
	 * Params:
	 * types =  an array of AtkStateType
	 */
	public void addStates(AtkStateType[] types);
	
	/**
	 * Removes all states from the state set.
	 */
	public void clearStates();
	
	/**
	 * Checks whether the state for the specified type is in the specified set.
	 * Params:
	 * type =  an AtkStateType
	 * Returns: TRUE if type is the state type is in set.
	 */
	public int containsState(AtkStateType type);
	
	/**
	 * Checks whether the states for all the specified types are in the
	 * specified set.
	 * Params:
	 * types =  an array of AtkStateType
	 * Returns: TRUE if all the states for type are in set.
	 */
	public int containsStates(AtkStateType[] types);
	
	/**
	 * Removes the state for the specified type from the state set.
	 * Params:
	 * type =  an AtkType
	 * Returns: TRUE if type was the state type is in set.
	 */
	public int removeState(AtkStateType type);
	
	/**
	 * Constructs the intersection of the two sets, returning NULL if the
	 * intersection is empty.
	 * Params:
	 * compareSet =  another AtkStateSet
	 * Returns: a new AtkStateSet which is the intersection of the two sets.
	 */
	public StateSet andSets(StateSet compareSet);
	
	/**
	 * Constructs the union of the two sets.
	 * Params:
	 * compareSet =  another AtkStateSet
	 * Returns: a new AtkStateSet which is the union of the two sets,returning NULL is empty.
	 */
	public StateSet orSets(StateSet compareSet);
	
	/**
	 * Constructs the exclusive-or of the two sets, returning NULL is empty.
	 * The set returned by this operation contains the states in exactly
	 * one of the two sets.
	 * Params:
	 * compareSet =  another AtkStateSet
	 * Returns: a new AtkStateSet which contains the states which are in exactly one of the two sets.
	 */
	public StateSet xorSets(StateSet compareSet);
}
