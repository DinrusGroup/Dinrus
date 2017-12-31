module gtkD.atk.ObjectFactory;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.atk.ObjectAtk;
private import gtkD.gobject.ObjectG;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * This class is the base object class for a factory used to create an
 * accessible object for a specific GType. The function
 * atk_registry_set_factory_type() is normally called to store
 * in the registry the factory type to be used to create an accessible of a
 * particular GType.
 */
public class ObjectFactory : ObjectG
{
	
	/** the main Gtk struct */
	protected AtkObjectFactory* atkObjectFactory;
	
	
	public AtkObjectFactory* getObjectFactoryStruct();	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkObjectFactory* atkObjectFactory);
	
	/**
	 */
	
	/**
	 * Provides an AtkObject that implements an accessibility interface
	 * on behalf of obj
	 * Params:
	 * obj =  a GObject
	 * Returns: an AtkObject that implements an accessibility interfaceon behalf of obj
	 */
	public ObjectAtk createAccessible(ObjectG obj);
	
	/**
	 * Gets the GType of the accessible which is created by the factory.
	 * Returns: the type of the accessible which is created by the factory.The value G_TYPE_INVALID is returned if no type if found.
	 */
	public GType getAccessibleType();
	
	/**
	 * Inform factory that it is no longer being used to create
	 * accessibles. When called, factory may need to inform
	 * AtkObjects which it has created that they need to be re-instantiated.
	 * Note: primarily used for runtime replacement of AtkObjectFactorys
	 * in object registries.
	 */
	public void invalidate();
}
