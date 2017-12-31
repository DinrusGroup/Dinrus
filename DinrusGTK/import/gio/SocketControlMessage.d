module gtkD.gio.SocketControlMessage;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;





private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GSocketControlMessage is a special-purpose utility message that
 * can be sent to or received from a GSocket. These types of
 * messages are often called "ancillary data".
 * The message can represent some sort of special instruction to or
 * information from the socket or can represent a special kind of
 * transfer to the peer (for example, sending a file description over
 * a UNIX socket).
 * These messages are sent with g_socket_send_message() and received
 * with g_socket_receive_message().
 * To extend the set of control message that can be sent, subclass this
 * class and override the get_size, get_level, get_type and serialize
 * methods.
 * To extend the set of control messages that can be received, subclass
 * this class and implement the deserialize method. Also, make sure your
 * class is registered with the GType typesystem before calling
 * g_socket_receive_message() to read such a message.
 */
public class SocketControlMessage : ObjectG
{
	
	/** the main Gtk struct */
	protected GSocketControlMessage* gSocketControlMessage;
	
	
	public GSocketControlMessage* getSocketControlMessageStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GSocketControlMessage* gSocketControlMessage);
	
	/**
	 */
	
	/**
	 * Tries to deserialize a socket control message of a given
	 * level and type. This will ask all known (to GType) subclasses
	 * of GSocketControlMessage if they can understand this kind
	 * of message and if so deserialize it into a GSocketControlMessage.
	 * If there is no implementation for this kind of control message, NULL
	 * will be returned.
	 * Since 2.22
	 * Params:
	 * level =  a socket level
	 * type =  a socket control message type for the given level
	 * size =  the size of the data in bytes
	 * data =  pointer to the message data
	 * Returns: the deserialized message or NULL
	 */
	public static SocketControlMessage deserialize(int level, int type, uint size, void* data);
	
	/**
	 * Returns the "level" (i.e. the originating protocol) of the control message.
	 * This is often SOL_SOCKET.
	 * Since 2.22
	 * Returns: an integer describing the level
	 */
	public int getLevel();
	
	/**
	 * Returns the protocol specific type of the control message.
	 * For instance, for UNIX fd passing this would be SCM_RIGHTS.
	 * Since 2.22
	 * Returns: an integer describing the type of control message
	 */
	public int getMsgType();

	/**
	 * Returns the space required for the control message, not including
	 * headers or alignment.
	 * Since 2.22
	 * Returns: The number of bytes required.
	 */
	public uint getSize();
	
	/**
	 * Converts the data in the message to bytes placed in the
	 * message.
	 * data is guaranteed to have enough space to fit the size
	 * returned by g_socket_control_message_get_size() on this
	 * object.
	 * Since 2.22
	 * Params:
	 * data =  A buffer to write data to
	 */
	public void serialize(void* data);
}
