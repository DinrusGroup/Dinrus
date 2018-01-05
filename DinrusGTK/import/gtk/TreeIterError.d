module gtkD.gtk.TreeIterError;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;






/**
 */
public class TreeIterError : Exception
{
	
	/**
	 * A TreeIter error.
	 * thrown<br>
	 * - trying to access a method that requires a tree model and the tree model was never set
	 */
	public this(string method, string message);
	
	/**
	 */
}
