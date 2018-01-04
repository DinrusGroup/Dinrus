module gtkD.glib.TrashStack;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * A GTrashStack is an efficient way to keep a stack of unused allocated
 * memory chunks. Each memory chunk is required to be large enough to hold
 * a gpointer. This allows the stack to be maintained without any space
 * overhead, since the stack pointers can be stored inside the memory chunks.
 * There is no function to create a GTrashStack. A NULL GTrashStack*
 * is a perfectly valid empty stack.
 */
public class TrashStack
{
	
	/** the main Gtk struct */
	protected GTrashStack* gTrashStack;
	
	
	public GTrashStack* getTrashStackStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GTrashStack* gTrashStack);
	
	/**
	 */
	
	/**
	 * Pushes a piece of memory onto a GTrashStack.
	 * Params:
	 * stackP = a pointer to a GTrashStack.
	 * dataP = the piece of memory to push on the stack.
	 */
	public static void push(GTrashStack** stackP, void* dataP);
	
	/**
	 * Pops a piece of memory off a GTrashStack.
	 * Params:
	 * stackP = a pointer to a GTrashStack.
	 * Returns:the element at the top of the stack.
	 */
	public static void* pop(GTrashStack** stackP);
	
	/**
	 * Returns the element at the top of a GTrashStack which may be NULL.
	 * Params:
	 * stackP = a pointer to a GTrashStack.
	 * Returns:the element at the top of the stack.
	 */
	public static void* peek(GTrashStack** stackP);
	
	/**
	 * Returns the height of a GTrashStack.
	 * Note that execution of this function is of O(N) complexity
	 * where N denotes the number of items on the stack.
	 * Params:
	 * stackP = a pointer to a GTrashStack.
	 * Returns:the height of the stack.
	 */
	public static uint height(GTrashStack** stackP);
}
