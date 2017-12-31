module gtkD.gio.UnixInputStream;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;





private import gtkD.gio.InputStream;

/**
 * Description
 * GUnixInputStream implements GInputStream for reading from a
 * UNIX file descriptor, including asynchronous operations. The file
 * descriptor must be selectable, so it doesn't work with opened files.
 * Note that <gio/gunixinputstream.h> belongs
 * to the UNIX-specific GIO interfaces, thus you have to use the
 * gio-unix-2.0.pc pkg-config file when using it.
 */
public class UnixInputStream : InputStream
{
	
	/** the main Gtk struct */
	protected GUnixInputStream* gUnixInputStream;
	
	
	public GUnixInputStream* getUnixInputStreamStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GUnixInputStream* gUnixInputStream);
	
	/**
	 */
	
	/**
	 * Creates a new GUnixInputStream for the given fd.
	 * If close_fd is TRUE, the file descriptor will be closed
	 * when the stream is closed.
	 * Params:
	 * fd =  a UNIX file descriptor
	 * closeFd =  TRUE to close the file descriptor when done
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int fd, int closeFd);
	
	/**
	 * Sets whether the file descriptor of stream shall be closed
	 * when the stream is closed.
	 * Since 2.20
	 * Params:
	 * closeFd =  TRUE to close the file descriptor when done
	 */
	public void setCloseFd(int closeFd);
	
	/**
	 * Returns whether the file descriptor of stream will be
	 * closed when the stream is closed.
	 * Since 2.20
	 * Returns: TRUE if the file descriptor is closed when done
	 */
	public int getCloseFd();
	
	/**
	 * Return the UNIX file descriptor that the stream reads from.
	 * Since 2.20
	 * Returns: The file descriptor of stream
	 */
	public int getFd();
}
