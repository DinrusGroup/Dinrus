module gtkD.gsv.SourceStyle;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;





private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class SourceStyle : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkSourceStyle* gtkSourceStyle;
	
	
	public GtkSourceStyle* getSourceStyleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSourceStyle* gtkSourceStyle);
	
	/**
	 */
	
	/**
	 * Creates a copy of style, that is a new GtkSourceStyle instance which
	 * has the same attributes set.
	 * Since 2.0
	 * Returns: copy of style, call g_object_unref() when you are done with it.
	 */
	public SourceStyle copy();
}
