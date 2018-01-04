module gtkD.gstreamer.ImplementsInterface;

public  import gtkD.gstreamerc.gstreamertypes;

private import gtkD.gstreamerc.gstreamer;
private import gtkD.glib.ConstructionException;

private import gtkD.gstreamer.Element;





/**
 * Description
 * Provides interface functionality on per instance basis and not per class
 * basis, which is the case for gtkD.gobject.
 */
public class ImplementsInterface
{
	
	/** the main Gtk struct */
	protected GstImplementsInterface* gstImplementsInterface;
	
	
	public GstImplementsInterface* getImplementsInterfaceStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GstImplementsInterface* gstImplementsInterface);
	
	/**
	 */
	
	/**
	 * Test whether the given element implements a certain interface of type
	 * iface_type, and test whether it is supported for this specific instance.
	 * Params:
	 * element =  GstElement to check for the implementation of the interface
	 * ifaceType =  (final) type of the interface which we want to be implemented
	 * Returns: whether or not the element implements the interface.
	 */
	public static int elementImplementsInterface(Element element, GType ifaceType);
	
	/**
	 * cast a given object to an interface type, and check whether this
	 * interface is supported for this specific instance.
	 * Params:
	 * from =  the object (any sort) from which to cast to the interface
	 * type =  the interface type to cast to
	 * Returns: a gpointer to the interface type
	 */
	public static void* implementsInterfaceCast(void* from, GType type);
	
	/**
	 * check a given object for an interface implementation, and check
	 * whether this interface is supported for this specific instance.
	 * Params:
	 * from =  the object (any sort) from which to check from for the interface
	 * type =  the interface type to check for
	 * Returns: whether or not the object implements the given interface
	 */
	public static int implementsInterfaceCheck(void* from, GType type);
}
