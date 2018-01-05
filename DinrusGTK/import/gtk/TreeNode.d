
module gtkD.gtk.TreeNode;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;






/**
 * TreeNode interface
 */
public interface TreeNode
{
	string getNodeValue(int column);
	int columnCount();
}

/**
 */

