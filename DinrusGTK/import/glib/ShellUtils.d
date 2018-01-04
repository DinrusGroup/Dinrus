module gtkD.glib.ShellUtils;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;




/**
 * Description
 */
public class ShellUtils
{
	
	/**
	 * Parses a command line into an argument vector, in much the same way
	 * the shell would, but without many of the expansions the shell would
	 * perform (variable expansion, globs, operators, filename expansion,
	 * etc. are not supported). The results are defined to be the same as
	 * those you would get from a UNIX98 /bin/sh, as long as the input
	 * contains none of the unsupported shell expansions. If the input
	 * does contain such expansions, they are passed through
	 * literally. Possible errors are those from the G_SHELL_ERROR
	 * domain. Free the returned vector with g_strfreev().
	 * Params:
	 * commandLine =  command line to parse
	 * argcp =  return location for number of args
	 * argvp =  return location for array of args
	 * Returns: TRUE on success, FALSE if error set
	 * Throws: GException on failure.
	 */
	public static int parseArgv(string commandLine, out int argcp, out string[] argvp);
	
	/**
	 */
	
	/**
	 * Quotes a string so that the shell (/bin/sh) will interpret the
	 * quoted string to mean unquoted_string. If you pass a filename to
	 * the shell, for example, you should first quote it with this
	 * function. The return value must be freed with g_free(). The
	 * quoting style used is undefined (single or double quotes may be
	 * used).
	 * Params:
	 * unquotedString =  a literal string
	 * Returns: quoted string
	 */
	public static string quote(string unquotedString);
	
	/**
	 * Unquotes a string as the shell (/bin/sh) would. Only handles
	 * quotes; if a string contains file globs, arithmetic operators,
	 * variables, backticks, redirections, or other special-to-the-shell
	 * features, the result will be different from the result a real shell
	 * would produce (the variables, backticks, etc. will be passed
	 * through literally instead of being expanded). This function is
	 * guaranteed to succeed if applied to the result of
	 * g_shell_quote(). If it fails, it returns NULL and sets the
	 * error. The quoted_string need not actually contain quoted or
	 * escaped text; g_shell_unquote() simply goes through the string and
	 * unquotes/unescapes anything that the shell would. Both single and
	 * double quotes are handled, as are escapes including escaped
	 * newlines. The return value must be freed with g_free(). Possible
	 * errors are in the G_SHELL_ERROR domain.
	 * Shell quoting rules are a bit strange. Single quotes preserve the
	 * literal string exactly. escape sequences are not allowed; not even
	 * \' - if you want a ' in the quoted text, you have to do something
	 * like 'foo'\''bar'. Double quotes allow $, `, ", \, and newline to
	 * be escaped with backslash. Otherwise double quotes preserve things
	 * literally.
	 * Params:
	 * quotedString =  shell-quoted string
	 * Returns: an unquoted string
	 * Throws: GException on failure.
	 */
	public static string unquote(string quotedString);
}
