module gtkD.gtk.IMMulticontext;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.IMContext;
private import gtkD.gtk.MenuShell;



private import gtkD.gtk.IMContext;

/**
 * Description
 */
public class IMMulticontext : IMContext
{
	
	/** the main Gtk struct */
	protected GtkIMMulticontext* gtkIMMulticontext;
	
	
	public GtkIMMulticontext* getIMMulticontextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkIMMulticontext* gtkIMMulticontext);
	
	/**
	 */
	
	/**
	 * Creates a new GtkIMMulticontext.
	 * Returns: a new GtkIMMulticontext.
	 */
	public static IMContext newIMMulticontext();
	
	/**
	 * Add menuitems for various available input methods to a menu;
	 * the menuitems, when selected, will switch the input method
	 * for the context and the global default input method.
	 * Params:
	 * menushell =  a GtkMenuShell
	 */
	public void appendMenuitems(MenuShell menushell);
	
	/**
	 * Gets the id of the currently active slave of the context.
	 * Since 2.16
	 * Returns: the id of the currently active slave
	 */
	public string getContextId();
	
	/**
	 * Sets the context id for context.
	 * This causes the currently active slave of context to be
	 * replaced by the slave corresponding to the new context id.
	 * Since 2.16
	 * Params:
	 * context =  a GtkIMMulticontext
	 * contextId =  the id to use
	 */
	public void setContextId(string contextId);
}
