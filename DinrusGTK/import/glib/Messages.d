module gtkD.glib.Messages;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * These functions provide support for outputting messages.
 * The g_return family of macros (g_return_if_fail(),
 * g_return_val_if_fail(), g_return_if_reached(), g_return_val_if_reached())
 * should only be used for programming errors, a typical use case is
 * checking for invalid parameters at the beginning of a public function.
 * They should not be used if you just mean "if (error) return", they
 * should only be used if you mean "if (bug in program) return".
 * The program behavior is generally considered undefined after one of these
 * checks fails. They are not intended for normal control flow, only to
 * give a perhaps-helpful warning before giving up.
 */
public class Messages
{
	
	/**
	 */
	
	/**
	 * Sets the print handler.
	 * Any messages passed to g_print() will be output via the new handler.
	 * The default handler simply outputs the message to stdout.
	 * By providing your own handler you can redirect the output, to a GTK+
	 * widget or a log file for example.
	 * Params:
	 * func = the new print handler.
	 * Returns:the old print handler.
	 */
	public static GPrintFunc setPrintHandler(GPrintFunc func);
	
	/**
	 * Sets the handler for printing error messages.
	 * Any messages passed to g_printerr() will be output via the new handler.
	 * The default handler simply outputs the message to stderr.
	 * By providing your own handler you can redirect the output, to a GTK+
	 * widget or a log file for example.
	 * Params:
	 * func = the new error message handler.
	 * Returns:the old error message handler.
	 */
	public static GPrintFunc setPrinterrHandler(GPrintFunc func);
	
	/**
	 * Prompts the user with [E]xit, [H]alt, show [S]tack trace or [P]roceed.
	 * This function is intended to be used for debugging use only. The following
	 * example shows how it can be used together with the g_log() functions.
	 * #include <gtkD.glib.h>
	 * static void
	 * log_handler (const gchar *log_domain,
	 * 	 GLogLevelFlags log_level,
	 * 	 const gchar *message,
	 * 	 gpointer user_data)
	 * {
		 *  g_log_default_handler (log_domain, log_level, message, user_data);
		 *  g_on_error_query (MY_PROGRAM_NAME);
	 * }
	 * int main (int argc, char *argv[])
	 * {
		 *  g_log_set_handler (MY_LOG_DOMAIN,
		 * 		 G_LOG_LEVEL_WARNING |
		 *  G_LOG_LEVEL_ERROR |
		 *  G_LOG_LEVEL_CRITICAL,
		 * 		 log_handler,
		 * 		 NULL);
		 *  /+* ... +/
		 * If [E]xit is selected, the application terminates with a call to
		 * _exit(0).
		 * If [H]alt is selected, the application enters an infinite loop.
		 * The infinite loop can only be stopped by killing the application,
		 * or by setting glib_on_error_halt to FALSE (possibly via a debugger).
		 * If [S]tack trace is selected, g_on_error_stack_trace() is called. This
		 * invokes gdb, which attaches to the current process and shows a stack trace.
		 * The prompt is then shown again.
		 * If [P]roceed is selected, the function returns.
		 * This function may cause different actions on non-UNIX platforms.
		 * Params:
		 * prgName = the program name, needed by gdb for the [S]tack trace option.
		 * If prg_name is NULL, g_get_prgname() is called to get the program name
		 * (which will work correctly if gdk_init() or gtk_init() has been called).
		 */
		public static void onErrorQuery(string prgName);
		
		/**
		 * Invokes gdb, which attaches to the current process and shows a stack trace.
		 * Called by g_on_error_query() when the [S]tack trace option is selected.
		 * This function may cause different actions on non-UNIX platforms.
		 * Params:
		 * prgName = the program name, needed by gdb for the [S]tack trace option.
		 * If prg_name is NULL, g_get_prgname() is called to get the program name
		 * (which will work correctly if gdk_init() or gtk_init() has been called).
		 */
		public static void onErrorStackTrace(string prgName);
}
