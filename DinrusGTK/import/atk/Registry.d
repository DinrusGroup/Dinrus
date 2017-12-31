module gtkD.atk.Registry;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.atk.ObjectFactory;
private import gtkD.atk.Registry;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The AtkRegistry is normally used to create appropriate ATK "peers" for user
 * interface components. Application developers usually need only interact with
 * the AtkRegistry by associating appropriate ATK implementation classes with
 * GObject classes via the atk_registry_set_factory_type call, passing the
 * appropriate GType for application custom widget classes.
 */
public class Registry : ObjectG
{
	
	/** the main Gtk struct */
	protected AtkRegistry* atkRegistry;
	
	
	public AtkRegistry* getRegistryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkRegistry* atkRegistry);
	
	/**
	 */
	
	/**
	 * Params:
	 * type =  an AtkObject type
	 * factoryType =  an AtkObjectFactory type to associate with type. Must
	 * implement AtkObject appropriate for type.
	 */
	public void setFactoryType(GType type, GType factoryType);
	
	/**
	 * Provides a GType indicating the AtkObjectFactory subclass
	 * associated with type.
	 * Params:
	 * type =  a GType with which to look up the associated AtkObjectFactory
	 * subclass
	 * Returns: a GType associated with type type
	 */
	public GType getFactoryType(GType type);
	
	/**
	 * Gets an AtkObjectFactory appropriate for creating AtkObjects
	 * appropriate for type.
	 * Params:
	 * type =  a GType with which to look up the associated AtkObjectFactory
	 * Returns: an AtkObjectFactory appropriate for creating AtkObjectsappropriate for type.
	 */
	public ObjectFactory getFactory(GType type);
	
	/**
	 * Gets a default implementation of the AtkObjectFactory/type
	 * registry.
	 * Note: For most toolkit maintainers, this will be the correct
	 * registry for registering new AtkObject factories. Following
	 * a call to this function, maintainers may call atk_registry_set_factory_type()
	 * to associate an AtkObjectFactory subclass with the GType of objects
	 * for whom accessibility information will be provided.
	 * Returns: a default implementation of the AtkObjectFactory/typeregistry
	 */
	public static Registry atkGetDefaultRegistry();
}
