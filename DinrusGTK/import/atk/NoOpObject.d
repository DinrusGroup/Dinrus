module gtkD.atk.NoOpObject;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.atk.ObjectAtk;
private import gtkD.gobject.ObjectG;



private import gtkD.atk.ObjectAtk;

/**
 * Description
 * An AtkNoOpObject is an AtkObject which purports to implement all ATK
 * interfaces. It is the type of AtkObject which is created if an accessible
 * object is requested for an object type for which no factory type is specified.
 */
public class NoOpObject : ObjectAtk
{
	
	/** the main Gtk struct */
	protected AtkNoOpObject* atkNoOpObject;
	
	
	public AtkNoOpObject* getNoOpObjectStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkNoOpObject* atkNoOpObject);
	
	/**
	 */
	
	/**
	 * Provides a default (non-functioning stub) AtkObject.
	 * Application maintainers should not use this method.
	 * Params:
	 * obj =  a GObject
	 * Returns: a default (non-functioning stub) AtkObject
	 */
	public static ObjectAtk newNoOpObject(ObjectG obj);
}
