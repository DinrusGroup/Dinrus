module gtkD.gio.UnixFDMessage;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;



private import gtkD.gio.SocketControlMessage;

/**
 * Description
 * This GSocketControlMessage contains a list of file descriptors.
 * It may be sent using g_socket_send_message() and received using
 * g_socket_receive_message() over UNIX sockets (ie: sockets in the
 * G_SOCKET_ADDRESS_UNIX family).
 * For an easier way to send and receive file descriptors over
 * stream-oriented UNIX sockets, see g_unix_connection_send_fd() and
 * g_unix_connection_receive_fd().
 */
public class UnixFDMessage : SocketControlMessage
{
	
	/** the main Gtk struct */
	protected GUnixFDMessage* gUnixFDMessage;
	
	
	public GUnixFDMessage* getUnixFDMessageStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixFDMessage* gUnixFDMessage);
	
	/**
	 */
	
	/**
	 * Creates a new GUnixFDMessage containing no file descriptors.
	 * Since 2.22
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Adds a file descriptor to message.
	 * The file descriptor is duplicated using dup(). You keep your copy
	 * of the descriptor and the copy contained in message will be closed
	 * when message is finalized.
	 * A possible cause of failure is exceeding the per-process or
	 * system-wide file descriptor limit.
	 * Since 2.22
	 * Params:
	 * fd =  a valid open file descriptor
	 * Returns: TRUE in case of success, else FALSE (and error is set)
	 * Throws: GException on failure.
	 */
	public int appendFd(int fd);
	
	/**
	 * Returns the array of file descriptors that is contained in this
	 * object.
	 * After this call, the descriptors are no longer contained in
	 * message. Further calls will return an empty list (unless more
	 * descriptors have been added).
	 * The return result of this function must be freed with g_free().
	 * The caller is also responsible for closing all of the file
	 * descriptors.
	 * If length is non-NULL then it is set to the number of file
	 * descriptors in the returned array. The returned array is also
	 * terminated with -1.
	 * This function never returns NULL. In case there are no file
	 * descriptors contained in message, an empty array is returned.
	 * Since 2.22
	 * Returns: an array of file descriptors
	 */
	public int[] stealFds();
}
