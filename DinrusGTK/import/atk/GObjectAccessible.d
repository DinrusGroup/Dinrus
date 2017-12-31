module gtkD.atk.GObjectAccessible;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.atk.ObjectAtk;
private import gtkD.gobject.ObjectG;



private import gtkD.atk.ObjectAtk;

/**
 * Description
 * This object class is derived from AtkObject. It can be used as a basis for
 * implementing accessible objects for GObjects which are not derived from
 * GtkWidget. One example of its use is in providing an accessible object
 * for GnomeCanvasItem in the GAIL library.
 */
public class GObjectAccessible : ObjectAtk
{
	
	/** the main Gtk struct */
	protected AtkGObjectAccessible* atkGObjectAccessible;
	
	
	public AtkGObjectAccessible* getGObjectAccessibleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkGObjectAccessible* atkGObjectAccessible);
	
	/**
	 */
	
	/**
	 * Gets the accessible object for the specified obj.
	 * Params:
	 * obj =  a GObject
	 * Returns: a AtkObject which is the accessible object for the obj
	 */
	public static ObjectAtk forObject(ObjectG obj);
	
	/**
	 * Gets the GObject for which obj is the accessible object.
	 * Returns: a GObject which is the object for which obj is the accessible object
	 */
	public ObjectG getObject();
}
