module gtkD.gobject.ValueArray;

public  import gtkD.gtkc.gobjecttypes;

private import gtkD.gtkc.gobject;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.Value;




/**
 * Description
 * The prime purpose of a GValueArray is for it to be used as an
 * object property that holds an array of values. A GValueArray wraps
 * an array of GValue elements in order for it to be used as a boxed
 * type through G_TYPE_VALUE_ARRAY.
 */
public class ValueArray
{
	
	/** the main Gtk struct */
	protected GValueArray* gValueArray;
	
	
	public GValueArray* getValueArrayStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GValueArray* gValueArray);
	
	/**
	 */
	
	/**
	 * Return a pointer to the value at index_ containd in value_array.
	 * Params:
	 * index =  index of the value of interest
	 * Returns: pointer to a value at index_ in value_array
	 */
	public Value getNth(uint index);
	
	/**
	 * Allocate and initialize a new GValueArray, optionally preserve space
	 * for n_prealloced elements. New arrays always contain 0 elements,
	 * regardless of the value of n_prealloced.
	 * Params:
	 * nPrealloced =  number of values to preallocate space for
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (uint nPrealloced);
	
	/**
	 * Construct an exact copy of a GValueArray by duplicating all its
	 * contents.
	 * Returns: Newly allocated copy of GValueArray
	 */
	public ValueArray copy();
	
	/**
	 * Free a GValueArray including its contents.
	 */
	public void free();
	
	/**
	 * Insert a copy of value as last element of value_array.
	 * Params:
	 * value =  GValue to copy into GValueArray
	 * Returns: the GValueArray passed in as value_array
	 */
	public ValueArray append(Value value);
	
	/**
	 * Insert a copy of value as first element of value_array.
	 * Params:
	 * value =  GValue to copy into GValueArray
	 * Returns: the GValueArray passed in as value_array
	 */
	public ValueArray prepend(Value value);
	
	/**
	 * Insert a copy of value at specified position into value_array.
	 * Params:
	 * index =  insertion position, must be <= value_array->n_values
	 * value =  GValue to copy into GValueArray
	 * Returns: the GValueArray passed in as value_array
	 */
	public ValueArray insert(uint index, Value value);
	
	/**
	 * Remove the value at position index_ from value_array.
	 * Params:
	 * index =  position of value to remove, must be < value_array->n_values
	 * Returns: the GValueArray passed in as value_array
	 */
	public ValueArray remove(uint index);
	
	/**
	 * Sort value_array using compare_func to compare the elements accoring to
	 * the semantics of GCompareFunc.
	 * The current implementation uses Quick-Sort as sorting algorithm.
	 * Params:
	 * compareFunc =  function to compare elements
	 * Returns: the GValueArray passed in as value_array
	 */
	public ValueArray sort(GCompareFunc compareFunc);
	
	/**
	 * Sort value_array using compare_func to compare the elements accoring
	 * to the semantics of GCompareDataFunc.
	 * The current implementation uses Quick-Sort as sorting algorithm.
	 * Params:
	 * compareFunc =  function to compare elements
	 * userData =  extra data argument provided for compare_func
	 * Returns: the GValueArray passed in as value_array
	 */
	public ValueArray sortWithData(GCompareDataFunc compareFunc, void* userData);
}
