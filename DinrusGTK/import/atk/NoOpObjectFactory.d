module gtkD.atk.NoOpObjectFactory;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;





private import gtkD.atk.ObjectFactory;

/**
 * Description
 * The AtkObjectFactory which creates an AtkNoOpObject. An instance of this is
 * created by an AtkRegistry if no factory type has not been specified to
 * create an accessible object of a particular type.
 */
public class NoOpObjectFactory : ObjectFactory
{
	
	/** the main Gtk struct */
	protected AtkNoOpObjectFactory* atkNoOpObjectFactory;
	
	
	public AtkNoOpObjectFactory* getNoOpObjectFactoryStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkNoOpObjectFactory* atkNoOpObjectFactory);
	
	/**
	 */
	
	/**
	 * Creates an instance of an AtkObjectFactory which generates primitive
	 * (non-functioning) AtkObjects.
	 * Returns: an instance of an AtkObjectFactory
	 */
	public static AtkObjectFactory* newNoOpObjectFactory();
}
