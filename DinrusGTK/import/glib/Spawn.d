module gtkD.glib.Spawn;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.MainLoop;
private import gtkD.glib.Str;

version(Dinrus)
{

	private import thread;
	private import cidrus;
	private import text.Util;
}
version(Rulada)
{
	private import tango.core.Thread;
	private import tango.stdc.stdio;
	private import tango.text.Util;
	private import tango.stdc.string;
	alias FILE* фук;
}

/**
 * Description
 */
public class Spawn
{


	version(Rulada) alias splitLines splitlines;

	string workingDirectory = ".";
	string[] argv;
	string[] envp;
	GSpawnFlags flags = SpawnFlags.SEARCH_PATH;
	GSpawnChildSetupFunc childSetup;
	void* userData;
	GPid childPid;
	FILE* standardInput;
	FILE* standardOutput;
	FILE* standardError;
	GError* error;
	int stdIn;
	int stdOut;
	int stdErr;

	// for commandLineSync
	int exitStatus;
	char* strOutput;
	char* strError;

	alias bool delegate(Spawn) ChildWatch;
	ChildWatch externalWatch;

	/**
	 * Creates a Spawn for execution.
	 */
	public this(string program, string[] envp=null);

	/**
	 * Creates a Spawn for execution.
	 */
	public this(string[] program, string[] envp=null);

	/**
	 * Adds a delegate to be notified on the end of the child process.
	 * Params:
	 *    	dlg =
	 */
	public void addChildWatch(ChildWatch dlg);

	/**
	 * Closes all open streams and child process.
	 */
	public void close();

	/**
	 * Adds a parameter to the execution program
	 */
	public void addParm(string parm);

	/**
	 * Gets the last error message
	 */
	public string getLastError();

	version(Rulada)
	{
		version (Windows)
		extern (C) FILE*  fdopen(int, char*); //Generates linker error on linux.
		else
		private import tango.stdc.posix.stdio;
	}
	else version(D_Version2)
	{
		version (Windows)
		extern (C) FILE*  fdopen(int, char*); //Generates linker error on linux.
		else
		private import core.sys.posix.stdio;
	}

	/**
	 * Executes the prepared process
	 */
	public int execAsyncWithPipes(
	ChildWatch externalWatch = null,
	bool delegate(string) readOutput = null,
	bool delegate(string) readError = null );

	class ReadFile : Нить
	{
		bool delegate(string) read;
		фук file;

		int lineCount;

		this(фук file, bool delegate (string) read );

		version(druntime)
		{
			public int run();
		}
		else
		{
			public /*override*/ int run();
		}
	}

	private string readLine(фук stream, int max=4096);

	extern(C) static void childWatchCallback(int pid, int status, Spawn spawn);

	public bool endOfOutput();

	public bool endOfError();

	string getOutputString();

	string getErrorString();

	int getExitStatus();

	/**
	 * Executes a command synchronasly and
	 * optionally calls delegates for sysout, syserr and end of job
	 *
	 */
	public int commandLineSync(
	ChildWatch externalWatch = null,
	bool delegate(string) readOutput = null,
	bool delegate(string) readError = null );

	/**
	 */

	/**
	 * See g_spawn_async_with_pipes() for a full description; this function
	 * simply calls the g_spawn_async_with_pipes() without any pipes.
	 * You should call g_spawn_close_pid() on the returned child process
	 * reference when you don't need it any more.
	 * Note
	 * If you are writing a GTK+ application, and the program you
	 * are spawning is a graphical application, too, then you may
	 * want to use gdk_spawn_on_screen() instead to ensure that
	 * the spawned program opens its windows on the right screen.
	 * Note
	 *  Note that the returned child_pid on Windows is a
	 * handle to the child process and not its identifier. Process handles
	 * and process identifiers are different concepts on Windows.
	 * Params:
	 * workingDirectory =  child's current working directory, or NULL to inherit parent's
	 * argv =  child's argument vector
	 * envp =  child's environment, or NULL to inherit parent's
	 * flags =  flags from GSpawnFlags
	 * childSetup =  function to run in the child just before exec()
	 * userData =  user data for child_setup
	 * childPid =  return location for child process reference, or NULL
	 * Returns: TRUE on success, FALSE if error is set
	 * Throws: GException on failure.
	 */
	public static int async(string workingDirectory, string[] argv, string[] envp, GSpawnFlags flags, GSpawnChildSetupFunc childSetup, void* userData, GPid* childPid);

	/**
	 * Executes a child synchronously (waits for the child to exit before returning).
	 * All output from the child is stored in standard_output and standard_error,
	 * if those parameters are non-NULL. Note that you must set the
	 * G_SPAWN_STDOUT_TO_DEV_NULL and G_SPAWN_STDERR_TO_DEV_NULL flags when
	 * passing NULL for standard_output and standard_error.
	 * If exit_status is non-NULL, the exit status of the child is stored
	 * there as it would be returned by waitpid(); standard UNIX macros such
	 * as WIFEXITED() and WEXITSTATUS() must be used to evaluate the exit status.
	 * Note that this function call waitpid() even if exit_status is NULL, and
	 * does not accept the G_SPAWN_DO_NOT_REAP_CHILD flag.
	 * If an error occurs, no data is returned in standard_output,
	 * standard_error, or exit_status.
	 * This function calls g_spawn_async_with_pipes() internally; see that
	 * function for full details on the other parameters and details on
	 * how these functions work on Windows.
	 * Params:
	 * workingDirectory =  child's current working directory, or NULL to inherit parent's
	 * argv =  child's argument vector
	 * envp =  child's environment, or NULL to inherit parent's
	 * flags =  flags from GSpawnFlags
	 * childSetup =  function to run in the child just before exec()
	 * userData =  user data for child_setup
	 * standardOutput =  return location for child output, or NULL
	 * standardError =  return location for child error messages, or NULL
	 * exitStatus =  return location for child exit status, as returned by waitpid(), or NULL
	 * Returns: TRUE on success, FALSE if an error was set.
	 */
	public static int sync(string workingDirectory, string[] argv, string[] envp, GSpawnFlags flags, GSpawnChildSetupFunc childSetup, void* userData, out string standardOutput, out string standardError, out int exitStatus);

	/**
	 * A simple version of g_spawn_async() that parses a command line with
	 * g_shell_parse_argv() and passes it to g_spawn_async(). Runs a
	 * command line in the background. Unlike g_spawn_async(), the
	 * G_SPAWN_SEARCH_PATH flag is enabled, other flags are not. Note
	 * that G_SPAWN_SEARCH_PATH can have security implications, so
	 * consider using g_spawn_async() directly if appropriate. Possible
	 * errors are those from g_shell_parse_argv() and g_spawn_async().
	 * The same concerns on Windows apply as for g_spawn_command_line_sync().
	 * Params:
	 * commandLine =  a command line
	 * Returns: TRUE on success, FALSE if error is set.
	 * Throws: GException on failure.
	 */
	public static int commandLineAsync(string commandLine);

	/**
	 * A simple version of g_spawn_sync() with little-used parameters
	 * removed, taking a command line instead of an argument vector. See
	 * g_spawn_sync() for full details. command_line will be parsed by
	 * g_shell_parse_argv(). Unlike g_spawn_sync(), the G_SPAWN_SEARCH_PATH flag
	 * is enabled. Note that G_SPAWN_SEARCH_PATH can have security
	 * implications, so consider using g_spawn_sync() directly if
	 * appropriate. Possible errors are those from g_spawn_sync() and those
	 * from g_shell_parse_argv().
	 * If exit_status is non-NULL, the exit status of the child is stored there as
	 * it would be returned by waitpid(); standard UNIX macros such as WIFEXITED()
	 * and WEXITSTATUS() must be used to evaluate the exit status.
	 * On Windows, please note the implications of g_shell_parse_argv()
	 * parsing command_line. Parsing is done according to Unix shell rules, not
	 * Windows command interpreter rules.
	 * Space is a separator, and backslashes are
	 * special. Thus you cannot simply pass a command_line containing
	 * canonical Windows paths, like "c:\\program files\\app\\app.exe", as
	 * the backslashes will be eaten, and the space will act as a
	 * separator. You need to enclose such paths with single quotes, like
	 * "'c:\\program files\\app\\app.exe' 'e:\\folder\\argument.txt'".
	 * Params:
	 * commandLine =  a command line
	 * standardOutput =  return location for child output
	 * standardError =  return location for child errors
	 * exitStatus =  return location for child exit status, as returned by waitpid()
	 * Returns: TRUE on success, FALSE if an error was set
	 */
	public static int commandLineSync(string commandLine, out string standardOutput, out string standardError, out int exitStatus);

	/**
	 * On some platforms, notably Windows, the GPid type represents a resource
	 * which must be closed to prevent resource leaking. g_spawn_close_pid()
	 * is provided for this purpose. It should be used on all platforms, even
	 * though it doesn't do anything under UNIX.
	 * Params:
	 * pid =  The process reference to close
	 */
	public static void closePid(GPid pid);
}
