
module gtkD.gio.MountOperation;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.glib.ArrayG;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GMountOperation provides a mechanism for interacting with the user.
 * It can be used for authenticating mountable operations, such as loop
 * mounting files, hard drive partitions or server locations. It can
 * also be used to ask the user questions or show a list of applications
 * preventing unmount or eject operations from completing.
 * Note that GMountOperation is used for more than just GMount
 * objects – for example it is also used in g_drive_start() and
 * g_drive_stop().
 * Users should instantiate a subclass of this that implements all the
 * various callbacks to show the required dialogs, such as
 * GtkMountOperation. If no user interaction is desired (for example
 * when automounting filesystems at login time), usually NULL can be
 * passed, see each method taking a GMountOperation for details.
 */
public class MountOperation : ObjectG
{
	
	/** the main Gtk struct */
	protected GMountOperation* gMountOperation;
	
	
	public GMountOperation* getMountOperationStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GMountOperation* gMountOperation);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(MountOperation)[] onAbortedListeners;
	/**
	 * Emitted by the backend when e.g. a device becomes unavailable
	 * while a mount operation is in progress.
	 * Implementations of GMountOperation should handle this signal
	 * by dismissing open password dialogs.
	 * Since 2.20
	 */
	void addOnAborted(void delegate(MountOperation) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAborted(GMountOperation* arg0Struct, MountOperation mountOperation);
	
	void delegate(string, string, string, GAskPasswordFlags, MountOperation)[] onAskPasswordListeners;
	/**
	 * Emitted when a mount operation asks the user for a password.
	 * If the message contains a line break, the first line should be
	 * presented as a heading. For example, it may be used as the
	 * primary text in a GtkMessageDialog.
	 */
	void addOnAskPassword(void delegate(string, string, string, GAskPasswordFlags, MountOperation) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAskPassword(GMountOperation* opStruct, gchar* message, gchar* defaultUser, gchar* defaultDomain, GAskPasswordFlags flags, MountOperation mountOperation);
	
	void delegate(string, GStrv*, MountOperation)[] onAskQuestionListeners;
	/**
	 * Emitted when asking the user a question and gives a list of
	 * choices for the user to choose from.
	 * If the message contains a line break, the first line should be
	 * presented as a heading. For example, it may be used as the
	 * primary text in a GtkMessageDialog.
	 */
	void addOnAskQuestion(void delegate(string, GStrv*, MountOperation) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackAskQuestion(GMountOperation* opStruct, gchar* message, GStrv* choices, MountOperation mountOperation);
	
	void delegate(GMountOperationResult, MountOperation)[] onReplyListeners;
	/**
	 * Emitted when the user has replied to the mount operation.
	 */
	void addOnReply(void delegate(GMountOperationResult, MountOperation) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackReply(GMountOperation* opStruct, GMountOperationResult result, MountOperation mountOperation);
	
	void delegate(string, ArrayG, GStrv*, MountOperation)[] onShowProcessesListeners;
	/**
	 * Emitted when one or more processes are blocking an operation
	 * e.g. unmounting/ejecting a GMount or stopping a GDrive.
	 * Note that this signal may be emitted several times to update the
	 * list of blocking processes as processes close files. The
	 * application should only respond with g_mount_operation_reply() to
	 * the latest signal (setting "choice" to the choice
	 * the user made).
	 * If the message contains a line break, the first line should be
	 * presented as a heading. For example, it may be used as the
	 * primary text in a GtkMessageDialog.
	 * Since 2.22
	 */
	void addOnShowProcesses(void delegate(string, ArrayG, GStrv*, MountOperation) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackShowProcesses(GMountOperation* opStruct, gchar* message, GArray* processes, GStrv* choices, MountOperation mountOperation);
	
	
	/**
	 * Creates a new mount operation.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Get the user name from the mount operation.
	 * Returns: a string containing the user name.
	 */
	public string getUsername();
	
	/**
	 * Sets the user name within op to username.
	 * Params:
	 * username =  input username.
	 */
	public void setUsername(string username);
	
	/**
	 * Gets a password from the mount operation.
	 * Returns: a string containing the password within op.
	 */
	public string getPassword();
	
	/**
	 * Sets the mount operation's password to password.
	 * Params:
	 * password =  password to set.
	 */
	public void setPassword(string password);
	
	/**
	 * Check to see whether the mount operation is being used
	 * for an anonymous user.
	 * Returns: TRUE if mount operation is anonymous.
	 */
	public int getAnonymous();
	
	/**
	 * Sets the mount operation to use an anonymous user if anonymous is TRUE.
	 * Params:
	 * anonymous =  boolean value.
	 */
	public void setAnonymous(int anonymous);
	
	/**
	 * Gets the domain of the mount operation.
	 * Returns: a string set to the domain.
	 */
	public string getDomain();
	
	/**
	 * Sets the mount operation's domain.
	 * Params:
	 * domain =  the domain to set.
	 */
	public void setDomain(string domain);
	
	/**
	 * Gets the state of saving passwords for the mount operation.
	 * Returns: a GPasswordSave flag.
	 */
	public GPasswordSave getPasswordSave();
	
	/**
	 * Sets the state of saving passwords for the mount operation.
	 * Params:
	 * save =  a set of GPasswordSave flags.
	 */
	public void setPasswordSave(GPasswordSave save);
	
	/**
	 * Gets a choice from the mount operation.
	 * Returns: an integer containing an index of the user's choice from the choice's list, or 0.
	 */
	public int getChoice();
	
	/**
	 * Sets a default choice for the mount operation.
	 * Params:
	 * choice =  an integer.
	 */
	public void setChoice(int choice);
	
	/**
	 * Emits the "reply" signal.
	 * Params:
	 * result =  a GMountOperationResult
	 */
	public void reply(GMountOperationResult result);
}
