
module gtkD.glib.Str;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.StringG;


version(Rulada) {
	private import tango.stdc.stdio;
	private import tango.stdc.string;

	version = druntime;
} else version(D_Version2) {
	private import std.c.stdio;
	private import core.stdc.string;

	version = druntime;
}
version(Dinrus)
 {
	private import cidrus;
}



/**
 * Description
 * This section describes a number of utility functions for creating,
 * duplicating, and manipulating strings.
 * Note that the functions g_printf(), g_fprintf(), g_sprintf(), g_snprintf(),
 * g_vprintf(), g_vfprintf(), g_vsprintf() and g_vsnprintf() are declared in
 * the header gprintf.h which is not
 * included in gtkD.glib.h (otherwise using
 * gtkD.glib.h would drag in stdio.h), so
 * you'll have to explicitly include <glib/gprintf.h>
 * in order to use the GLib printf() functions.
 * While you may use the printf() functions to format UTF-8 strings, notice that
 * the precision of a %Ns parameter is interpreted as the
 * number of bytes, not characters to print.
 * On top of that, the GNU libc implementation of the printf() functions has the "feature"
 * that it checks that the string given for the %Ns parameter
 * consists of a whole number of characters in the current encoding. So, unless you
 * are sure you are always going to be in an UTF-8 locale or your know your text is restricted
 * to ASCII, avoid using %Ns.
 * If your intention is to format strings for a certain number of columns, then
 * %Ns is not a correct solution anyway, since it fails to take
 * wide characters (see g_unichar_iswide()) into account.
 */
public class Str
{

	const static char[10] digits    = "0123456789";			/// 0..9

	/*************************************************
	 * Convert C-style 0 terminated string s to char[] string.
	 * copied from phobos
	 */
	public static string toString(char *s);

	/*********************************
	 * Convert array of chars s[] to a C-style 0 terminated string.
	 * copied from phobos
	 */
	public static char* toStringz(string s);

	/** */
	public static char** toStringzArray(string[] args);

	/** */
	public static string[] toStringArray(char** args);

	/** */
	public static string toString(bool b);

	/** */
	public static char[] toString(char c);

	/** */
	public static string toString(ubyte ub) ;
	/** */
	public static string toString(ushort us);

	/** */
	public static string toString(uint u);

	/** */
	public static string toString(ulong u);

	/** */
	public static string toString(byte b) ;
	/** */
	public static string toString(short s) ;

	/** */
	public static string toString(int i);

	/**
	 */

	/**
	 * Duplicates a string. If str is NULL it returns NULL.
	 * The returned string should be freed with g_free()
	 * when no longer needed.
	 * Params:
	 * str =  the string to duplicate
	 * Returns: a newly-allocated copy of str
	 */
	public static string strdup(string str);

	/**
	 * Duplicates the first n bytes of a string, returning a newly-allocated
	 * buffer n + 1 bytes long which will always be nul-terminated.
	 * If str is less than n bytes long the buffer is padded with nuls.
	 * If str is NULL it returns NULL.
	 * The returned value should be freed when no longer needed.
	 * Note
	 * To copy a number of characters from a UTF-8 encoded string, use
	 * g_utf8_strncpy() instead.
	 * Params:
	 * str =  the string to duplicate
	 * n =  the maximum number of bytes to copy from str
	 * Returns: a newly-allocated buffer containing the first n bytes  of str, nul-terminated
	 */
	public static string strndup(string str, uint n);

	/**
	 * Copies NULL-terminated array of strings. The copy is a deep copy;
	 * the new array should be freed by first freeing each string, then
	 * the array itself. g_strfreev() does this for you. If called
	 * on a NULL value, g_strdupv() simply returns NULL.
	 * Params:
	 * strArray =  NULL-terminated array of strings.
	 * Returns: a new NULL-terminated array of strings.
	 */
	public static string[] strdupv(string[] strArray);

	/**
	 * Creates a new string length bytes long filled with fill_char.
	 * The returned string should be freed when no longer needed.
	 * Params:
	 * length =  the length of the new string
	 * fillChar =  the byte to fill the string with
	 * Returns: a newly-allocated string filled the fill_char
	 */
	public static string strnfill(uint length, char fillChar);

	/**
	 * Copies a nul-terminated string into the dest buffer, include the
	 * trailing nul, and return a pointer to the trailing nul byte.
	 * This is useful for concatenating multiple strings together
	 * without having to repeatedly scan for the end.
	 * Params:
	 * dest =  destination buffer.
	 * src =  source string.
	 * Returns: a pointer to trailing nul byte.
	 */
	public static string stpcpy(string dest, string src);

	/**
	 * Searches the string haystack for the first occurrence
	 * of the string needle, limiting the length of the search
	 * to haystack_len.
	 * Params:
	 * haystack =  a string.
	 * haystackLen =  the maximum length of haystack. Note that -1 is
	 * a valid length, if haystack is nul-terminated, meaning it will
	 * search through the whole string.
	 * needle =  the string to search for.
	 * Returns: a pointer to the found occurrence, or NULL if not found.
	 */
	public static string strstrLen(string haystack, int haystackLen, string needle);

	/**
	 * Searches the string haystack for the last occurrence
	 * of the string needle.
	 * Params:
	 * haystack =  a nul-terminated string.
	 * needle =  the nul-terminated string to search for.
	 * Returns: a pointer to the found occurrence, or NULL if not found.
	 */
	public static string strrstr(string haystack, string needle);

	/**
	 * Searches the string haystack for the last occurrence
	 * of the string needle, limiting the length of the search
	 * to haystack_len.
	 * Params:
	 * haystack =  a nul-terminated string.
	 * haystackLen =  the maximum length of haystack.
	 * needle =  the nul-terminated string to search for.
	 * Returns: a pointer to the found occurrence, or NULL if not found.
	 */
	public static string strrstrLen(string haystack, int haystackLen, string needle);

	/**
	 * Looks whether the string str begins with prefix.
	 * Since 2.2
	 * Params:
	 * str =  a nul-terminated string.
	 * prefix =  the nul-terminated prefix to look for.
	 * Returns: TRUE if str begins with prefix, FALSE otherwise.
	 */
	public static int strHasPrefix(string str, string prefix);

	/**
	 * Looks whether the string str ends with suffix.
	 * Since 2.2
	 * Params:
	 * str =  a nul-terminated string.
	 * suffix =  the nul-terminated suffix to look for.
	 * Returns: TRUE if str end with suffix, FALSE otherwise.
	 */
	public static int strHasSuffix(string str, string suffix);

	/**
	 * Compares str1 and str2 like strcmp(). Handles NULL
	 * gracefully by sorting it before non-NULL strings.
	 * Since 2.16
	 * Params:
	 * str1 =  a C string or NULL
	 * str2 =  another C string or NULL
	 * Returns: -1, 0 or 1, if str1 is <, == or > than str2.
	 */
	public static int strcmp0(string str1, string str2);

	/**
	 * Portability wrapper that calls strlcpy() on systems which have it,
	 * and emulates strlcpy() otherwise. Copies src to dest; dest is
	 * guaranteed to be nul-terminated; src must be nul-terminated;
	 * dest_size is the buffer size, not the number of chars to copy.
	 * At most dest_size - 1 characters will be copied. Always nul-terminates
	 * (unless dest_size == 0). This function does not
	 * allocate memory. Unlike strncpy(), this function doesn't pad dest (so
	 * it's often faster). It returns the size of the attempted result,
	 * strlen (src), so if retval >= dest_size, truncation occurred.
	 * Note
	 * Caveat: strlcpy() is supposedly more secure than
	 * strcpy() or strncpy(), but if you really want to avoid screwups,
	 * g_strdup() is an even better idea.
	 * Params:
	 * dest =  destination buffer
	 * src =  source buffer
	 * destSize =  length of dest in bytes
	 * Returns: length of src
	 */
	public static uint strlcpy(string dest, string src, uint destSize);

	/**
	 * Portability wrapper that calls strlcat() on systems which have it,
	 * and emulates it otherwise. Appends nul-terminated src string to dest,
	 * guaranteeing nul-termination for dest. The total size of dest won't
	 * exceed dest_size.
	 * At most dest_size - 1 characters will be copied.
	 * Unlike strncat, dest_size is the full size of dest, not the space left over.
	 * This function does NOT allocate memory.
	 * This always NUL terminates (unless siz == 0 or there were no NUL characters
	 * in the dest_size characters of dest to start with).
	 * Params:
	 * dest =  destination buffer, already containing one nul-terminated string
	 * src =  source buffer
	 * destSize =  length of dest buffer in bytes (not length of existing string
	 *  inside dest)
	 * Returns:size of attempted result, which isMIN (dest_size, strlen (original dest)) + strlen (src),so if retval >= dest_size, truncation occurred.NoteCaveat: this is supposedly a more secure alternative to strcat() or strncat(), but for real security g_strconcat() is harder to mess up.
	 */
	public static uint strlcat(string dest, string src, uint destSize);

	/**
	 * Similar to the standard C vsprintf() function but safer, since it
	 * calculates the maximum space required and allocates memory to hold
	 * the result. The returned string should be freed with g_free() when
	 * no longer needed.
	 * See also g_vasprintf(), which offers the same functionality, but
	 * additionally returns the length of the allocated string.
	 * Params:
	 * format =  a standard printf() format string, but notice
	 *  string precision pitfalls
	 * args =  the list of parameters to insert into the format string
	 * Returns: a newly-allocated string holding the result
	 */
	public static string strdupVprintf(string format, void* args);

	/**
	 * An implementation of the standard vprintf() function which supports
	 * positional parameters, as specified in the Single Unix Specification.
	 * Since 2.2
	 * Params:
	 * format =  a standard printf() format string, but notice
	 *  string precision pitfalls.
	 * args =  the list of arguments to insert in the output.
	 * Returns: the number of bytes printed.
	 */
	public static int vprintf(string format, void* args);

	/**
	 * An implementation of the standard fprintf() function which supports
	 * positional parameters, as specified in the Single Unix Specification.
	 * Since 2.2
	 * Params:
	 * file =  the stream to write to.
	 * format =  a standard printf() format string, but notice
	 *  string precision pitfalls.
	 * args =  the list of arguments to insert in the output.
	 * Returns: the number of bytes printed.
	 */
	public static int vfprintf(FILE* file, string format, void* args);

	/**
	 * An implementation of the standard vsprintf() function which supports
	 * positional parameters, as specified in the Single Unix Specification.
	 * Since 2.2
	 * Params:
	 * string =  the buffer to hold the output.
	 * format =  a standard printf() format string, but notice
	 *  string precision pitfalls.
	 * args =  the list of arguments to insert in the output.
	 * Returns: the number of bytes printed.
	 */
	public static int vsprintf(string string, string format, void* args);

	/**
	 * A safer form of the standard vsprintf() function. The output is guaranteed
	 * to not exceed n characters (including the terminating nul character), so
	 * it is easy to ensure that a buffer overflow cannot occur.
	 * See also g_strdup_vprintf().
	 * In versions of GLib prior to 1.2.3, this function may return -1 if the
	 * output was truncated, and the truncated string may not be nul-terminated.
	 * In versions prior to 1.3.12, this function returns the length of the output
	 * string.
	 * The return value of g_vsnprintf() conforms to the vsnprintf() function
	 * as standardized in ISO C99. Note that this is different from traditional
	 * vsnprintf(), which returns the length of the output string.
	 * The format string may contain positional parameters, as specified in
	 * the Single Unix Specification.
	 * Params:
	 * string =  the buffer to hold the output.
	 * n =  the maximum number of bytes to produce (including the
	 *  terminating nul character).
	 * format =  a standard printf() format string, but notice
	 *  string precision pitfalls.
	 * args =  the list of arguments to insert in the output.
	 * Returns: the number of bytes which would be produced if the buffer  was large enough.
	 */
	public static int vsnprintf(string string, uint n, string format, void* args);

	/**
	 * An implementation of the GNU vasprintf() function which supports
	 * positional parameters, as specified in the Single Unix Specification.
	 * This function is similar to g_vsprintf(), except that it allocates a
	 * string to hold the output, instead of putting the output in a buffer
	 * you allocate in advance.
	 * Since 2.4
	 * Params:
	 * string =  the return location for the newly-allocated string.
	 * format =  a standard printf() format string, but notice
	 *  string precision pitfalls.
	 * args =  the list of arguments to insert in the output.
	 * Returns: the number of bytes printed.
	 */
	public static int vasprintf(out string string, string format, void* args);

	/**
	 * Calculates the maximum space needed to store the output of the sprintf()
	 * function.
	 * Params:
	 * format = the format string. See the printf() documentation.
	 * args = the parameters to be inserted into the format string.
	 * Returns:the maximum space needed to store the formatted string.
	 */
	public static uint printfStringUpperBound(string format, void* args);

	/**
	 * Determines whether a character is alphanumeric.
	 * Unlike the standard C library isalnum() function, this only
	 * recognizes standard ASCII letters and ignores the locale, returning
	 * FALSE for all non-ASCII characters. Also unlike the standard
	 * library function, this takes a char, not an int,
	 * so don't call it on EOF but no need to cast to guchar before passing a
	 * possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII alphanumeric character
	 */
	public static int asciiIsalnum(char c);

	/**
	 * Determines whether a character is alphabetic (i.e. a letter).
	 * Unlike the standard C library isalpha() function, this only
	 * recognizes standard ASCII letters and ignores the locale, returning
	 * FALSE for all non-ASCII characters. Also unlike the standard
	 * library function, this takes a char, not an int,
	 * so don't call it on EOF but no need to cast to guchar before passing a
	 * possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII alphabetic character
	 */
	public static int asciiIsalpha(char c);

	/**
	 * Determines whether a character is a control character.
	 * Unlike the standard C library iscntrl() function, this only
	 * recognizes standard ASCII control characters and ignores the locale,
	 * returning FALSE for all non-ASCII characters. Also unlike the standard
	 * library function, this takes a char, not an int,
	 * so don't call it on EOF but no need to cast to guchar before passing a
	 * possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII control character.
	 */
	public static int asciiIscntrl(char c);

	/**
	 * Determines whether a character is digit (0-9).
	 * Unlike the standard C library isdigit() function,
	 * this takes a char, not an int, so don't call it
	 * on EOF but no need to cast to guchar before passing a possibly
	 * non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII digit.
	 */
	public static int asciiIsdigit(char c);

	/**
	 * Determines whether a character is a printing character and not a space.
	 * Unlike the standard C library isgraph() function,
	 * this only recognizes standard ASCII characters and ignores the locale,
	 * returning FALSE for all non-ASCII characters. Also unlike the standard
	 * library function, this takes a char, not an int,
	 * so don't call it on EOF but no need to cast to guchar before passing a
	 * possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII printing character other than space.
	 */
	public static int asciiIsgraph(char c);

	/**
	 * Determines whether a character is an ASCII lower case letter.
	 * Unlike the standard C library islower() function,
	 * this only recognizes standard ASCII letters and ignores the locale,
	 * returning FALSE for all non-ASCII characters. Also unlike the standard
	 * library function, this takes a char, not an int,
	 * so don't call it on EOF but no need to worry about casting to guchar
	 * before passing a possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII lower case letter
	 */
	public static int asciiIslower(char c);

	/**
	 * Determines whether a character is a printing character.
	 * Unlike the standard C library isprint() function,
	 * this only recognizes standard ASCII characters and ignores the locale,
	 * returning FALSE for all non-ASCII characters. Also unlike the standard
	 * library function, this takes a char, not an int,
	 * so don't call it on EOF but no need to cast to guchar before passing a
	 * possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII printing character.
	 */
	public static int asciiIsprint(char c);

	/**
	 * Determines whether a character is a punctuation character.
	 * Unlike the standard C library ispunct() function,
	 * this only recognizes standard ASCII letters and ignores the locale,
	 * returning FALSE for all non-ASCII characters. Also unlike the standard
	 * library function, this takes a char, not an int,
	 * so don't call it on EOF but no need to cast to guchar before passing a
	 * possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII punctuation character.
	 */
	public static int asciiIspunct(char c);

	/**
	 * Determines whether a character is a white-space character.
	 * Unlike the standard C library isspace() function,
	 * this only recognizes standard ASCII white-space and ignores the locale,
	 * returning FALSE for all non-ASCII characters. Also unlike the standard
	 * library function, this takes a char, not an int,
	 * so don't call it on EOF but no need to cast to guchar before passing a
	 * possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII white-space character
	 */
	public static int asciiIsspace(char c);

	/**
	 * Determines whether a character is an ASCII upper case letter.
	 * Unlike the standard C library isupper() function,
	 * this only recognizes standard ASCII letters and ignores the locale,
	 * returning FALSE for all non-ASCII characters. Also unlike the standard
	 * library function, this takes a char, not an int,
	 * so don't call it on EOF but no need to worry about casting to guchar
	 * before passing a possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII upper case letter
	 */
	public static int asciiIsupper(char c);

	/**
	 * Determines whether a character is a hexadecimal-digit character.
	 * Unlike the standard C library isxdigit() function,
	 * this takes a char, not an int, so
	 * don't call it on EOF but no need to cast to guchar before passing a
	 * possibly non-ASCII character in.
	 * Params:
	 * c = any character
	 * Returns:%TRUE if c is an ASCII hexadecimal-digit character.
	 */
	public static int asciiIsxdigit(char c);

	/**
	 * Determines the numeric value of a character as a decimal
	 * digit. Differs from g_unichar_digit_value() because it takes
	 * a char, so there's no worry about sign extension if characters
	 * are signed.
	 * Params:
	 * c =  an ASCII character.
	 * Returns: If c is a decimal digit (according tog_ascii_isdigit()), its numeric value. Otherwise, -1.
	 */
	public static int asciiDigitValue(char c);

	/**
	 * Determines the numeric value of a character as a hexidecimal
	 * digit. Differs from g_unichar_xdigit_value() because it takes
	 * a char, so there's no worry about sign extension if characters
	 * are signed.
	 * Params:
	 * c =  an ASCII character.
	 * Returns: If c is a hex digit (according tog_ascii_isxdigit()), its numeric value. Otherwise, -1.
	 */
	public static int asciiXdigitValue(char c);

	/**
	 * Compare two strings, ignoring the case of ASCII characters.
	 * Unlike the BSD strcasecmp() function, this only recognizes standard
	 * ASCII letters and ignores the locale, treating all non-ASCII
	 * bytes as if they are not letters.
	 * This function should be used only on strings that are known to be
	 * in encodings where the bytes corresponding to ASCII letters always
	 * represent themselves. This includes UTF-8 and the ISO-8859-*
	 * charsets, but not for instance double-byte encodings like the
	 * Windows Codepage 932, where the trailing bytes of double-byte
	 * characters include all ASCII letters. If you compare two CP932
	 * strings using this function, you will get false matches.
	 * Params:
	 * s1 =  string to compare with s2.
	 * s2 =  string to compare with s1.
	 * Returns: 0 if the strings match, a negative value if s1 < s2,  or a positive value if s1 > s2.
	 */
	public static int asciiStrcasecmp(string s1, string s2);

	/**
	 * Compare s1 and s2, ignoring the case of ASCII characters and any
	 * characters after the first n in each string.
	 * Unlike the BSD strcasecmp() function, this only recognizes standard
	 * ASCII letters and ignores the locale, treating all non-ASCII
	 * characters as if they are not letters.
	 * The same warning as in g_ascii_strcasecmp() applies: Use this
	 * function only on strings known to be in encodings where bytes
	 * corresponding to ASCII letters always represent themselves.
	 * Params:
	 * s1 =  string to compare with s2.
	 * s2 =  string to compare with s1.
	 * n =  number of characters to compare.
	 * Returns: 0 if the strings match, a negative value if s1 < s2,  or a positive value if s1 > s2.
	 */
	public static int asciiStrncasecmp(string s1, string s2, uint n);

	/**
	 * Converts all lower case ASCII letters to upper case ASCII letters.
	 * Params:
	 * str =  a string.
	 * len =  length of str in bytes, or -1 if str is nul-terminated.
	 * Returns: a newly allocated string, with all the lower case characters in str converted to upper case, with semantics that exactly match g_ascii_toupper(). (Note that this is unlike the old g_strup(), which modified the string in place.)
	 */
	public static string asciiStrup(string str, int len);

	/**
	 * Converts all upper case ASCII letters to lower case ASCII letters.
	 * Params:
	 * str =  a string.
	 * len =  length of str in bytes, or -1 if str is nul-terminated.
	 * Returns: a newly-allocated string, with all the upper case characters in str converted to lower case, with semantics that exactly match g_ascii_tolower(). (Note that this is unlike the old g_strdown(), which modified the string in place.)
	 */
	public static string asciiStrdown(string str, int len);

	/**
	 * Convert a character to ASCII lower case.
	 * Unlike the standard C library tolower() function, this only
	 * recognizes standard ASCII letters and ignores the locale, returning
	 * all non-ASCII characters unchanged, even if they are lower case
	 * letters in a particular character set. Also unlike the standard
	 * library function, this takes and returns a char, not an int, so
	 * don't call it on EOF but no need to worry about casting to guchar
	 * before passing a possibly non-ASCII character in.
	 * Params:
	 * c =  any character.
	 * Returns: the result of converting c to lower case. If c is not an ASCII upper case letter, c is returned unchanged.
	 */
	public static char asciiTolower(char c);

	/**
	 * Convert a character to ASCII upper case.
	 * Unlike the standard C library toupper() function, this only
	 * recognizes standard ASCII letters and ignores the locale, returning
	 * all non-ASCII characters unchanged, even if they are upper case
	 * letters in a particular character set. Also unlike the standard
	 * library function, this takes and returns a char, not an int, so
	 * don't call it on EOF but no need to worry about casting to guchar
	 * before passing a possibly non-ASCII character in.
	 * Params:
	 * c =  any character.
	 * Returns: the result of converting c to upper case. If c is not an ASCII lower case letter, c is returned unchanged.
	 */
	public static char asciiToupper(char c);
	
	/**
	 * Converts all lower case ASCII letters to upper case ASCII letters.
	 * Params:
	 * string =  a GString
	 * Returns: passed-in string pointer, with all the lower case characters converted to upper case in place, with semantics that exactly match g_ascii_toupper().
	 */
	public static StringG stringAsciiUp(StringG string);

	/**
	 * Converts all upper case ASCII letters to lower case ASCII letters.
	 * Params:
	 * string =  a GString
	 * Returns: passed-in string pointer, with all the upper case characters converted to lower case in place, with semantics that exactly match g_ascii_tolower().
	 */
	public static StringG stringAsciiDown(StringG string);

	/**
	 * Warning
	 * g_strup has been deprecated since version 2.2 and should not be used in newly-written code. This function is totally broken for the reasons discussed
	 * in the g_strncasecmp() docs - use g_ascii_strup() or g_utf8_strup() instead.
	 * Converts a string to upper case.
	 * Params:
	 * string =  the string to convert.
	 * Returns: the string
	 */
	public static string strup(string string);

	/**
	 * Warning
	 * g_strdown has been deprecated since version 2.2 and should not be used in newly-written code. This function is totally broken for the reasons discussed
	 * in the g_strncasecmp() docs - use g_ascii_strdown() or g_utf8_strdown()
	 * instead.
	 * Converts a string to lower case.
	 * Params:
	 * string =  the string to convert.
	 * Returns: the string
	 */
	public static string strdown(string string);

	/**
	 * Warning
	 * g_strcasecmp has been deprecated since version 2.2 and should not be used in newly-written code. See g_strncasecmp() for a discussion of why this function
	 *  is deprecated and how to replace it.
	 * A case-insensitive string comparison, corresponding to the standard
	 * strcasecmp() function on platforms which support it.
	 * Params:
	 * s1 =  a string.
	 * s2 =  a string to compare with s1.
	 * Returns: 0 if the strings match, a negative value if s1 < s2,  or a positive value if s1 > s2.
	 */
	public static int strcasecmp(string s1, string s2);

	/**
	 * Warning
	 * g_strncasecmp has been deprecated since version 2.2 and should not be used in newly-written code. The problem with g_strncasecmp() is that it does the
	 * comparison by calling toupper()/tolower(). These functions are
	 * locale-specific and operate on single bytes. However, it is impossible
	 * to handle things correctly from an I18N standpoint by operating on
	 * bytes, since characters may be multibyte. Thus g_strncasecmp() is
	 * broken if your string is guaranteed to be ASCII, since it's
	 * locale-sensitive, and it's broken if your string is localized, since
	 * it doesn't work on many encodings at all, including UTF-8, EUC-JP,
	 * etc.
	 * There are therefore two replacement functions: g_ascii_strncasecmp(),
	 * which only works on ASCII and is not locale-sensitive, and
	 * g_utf8_casefold(), which is good for case-insensitive sorting of UTF-8.
	 * A case-insensitive string comparison, corresponding to the standard
	 * strncasecmp() function on platforms which support it.
	 * It is similar to g_strcasecmp() except it only compares the first n
	 * characters of the strings.
	 * Params:
	 * s1 =  a string.
	 * s2 =  a string to compare with s1.
	 * n =  the maximum number of characters to compare.
	 * Returns: 0 if the strings match, a negative value if s1 < s2,  or a positive value if s1 > s2.
	 */
	public static int strncasecmp(string s1, string s2, uint n);

	/**
	 * Reverses all of the bytes in a string. For example,
	 * g_strreverse ("abcdef") will result
	 * in "fedcba".
	 * Note that g_strreverse() doesn't work on UTF-8 strings
	 * containing multibyte characters. For that purpose, use
	 * g_utf8_strreverse().
	 * Params:
	 * string =  the string to reverse
	 * Returns: the same pointer passed in as string
	 */
	public static string strreverse(string string);

	/**
	 * Converts a string to a gint64 value.
	 * This function behaves like the standard strtoll() function
	 * does in the C locale. It does this without actually
	 * changing the current locale, since that would not be
	 * Нить-safe.
	 * This function is typically used when reading configuration
	 * files or other non-user input that should be locale independent.
	 * To handle input from the user you should normally use the
	 * locale-sensitive system strtoll() function.
	 * If the correct value would cause overflow, G_MAXINT64 or G_MININT64
	 * is returned, and ERANGE is stored in errno. If the base is
	 * outside the valid range, zero is returned, and EINVAL is stored
	 * in errno. If the string conversion fails, zero is returned, and
	 * endptr returns nptr (if endptr is non-NULL).
	 * Since 2.12
	 * Params:
	 * nptr =  the string to convert to a numeric value.
	 * endptr =  if non-NULL, it returns the character after
	 *  the last character used in the conversion.
	 * base =  to be used for the conversion, 2..36 or 0
	 * Returns: the gint64 value or zero on error.
	 */
	public static long asciiStrtoll(string nptr, out string endptr, uint base);

	/**
	 * Converts a string to a guint64 value.
	 * This function behaves like the standard strtoull() function
	 * does in the C locale. It does this without actually
	 * changing the current locale, since that would not be
	 * Нить-safe.
	 * This function is typically used when reading configuration
	 * files or other non-user input that should be locale independent.
	 * To handle input from the user you should normally use the
	 * locale-sensitive system strtoull() function.
	 * If the correct value would cause overflow, G_MAXUINT64
	 * is returned, and ERANGE is stored in errno. If the base is
	 * outside the valid range, zero is returned, and EINVAL is stored
	 * in errno. If the string conversion fails, zero is returned, and
	 * endptr returns nptr (if endptr is non-NULL).
	 * Since 2.2
	 * Params:
	 * nptr =  the string to convert to a numeric value.
	 * endptr =  if non-NULL, it returns the character after
	 *  the last character used in the conversion.
	 * base =  to be used for the conversion, 2..36 or 0
	 * Returns: the guint64 value or zero on error.
	 */
	public static ulong asciiStrtoull(string nptr, out string endptr, uint base);

	/**
	 * Converts a string to a gdouble value.
	 * This function behaves like the standard strtod() function
	 * does in the C locale. It does this without actually changing
	 * the current locale, since that would not be Нить-safe.
	 * A limitation of the implementation is that this function
	 * will still accept localized versions of infinities and NANs.
	 * This function is typically used when reading configuration
	 * files or other non-user input that should be locale independent.
	 * To handle input from the user you should normally use the
	 * locale-sensitive system strtod() function.
	 * To convert from a gdouble to a string in a locale-insensitive
	 * way, use g_ascii_dtostr().
	 * If the correct value would cause overflow, plus or minus HUGE_VAL
	 * is returned (according to the sign of the value), and ERANGE is
	 * stored in errno. If the correct value would cause underflow,
	 * zero is returned and ERANGE is stored in errno.
	 * This function resets errno before calling strtod() so that
	 * you can reliably detect overflow and underflow.
	 * Params:
	 * nptr =  the string to convert to a numeric value.
	 * endptr =  if non-NULL, it returns the character after
	 *  the last character used in the conversion.
	 * Returns: the gdouble value.
	 */
	public static double asciiStrtod(string nptr, out string endptr);

	/**
	 * Converts a gdouble to a string, using the '.' as
	 * decimal point.
	 * This functions generates enough precision that converting
	 * the string back using g_ascii_strtod() gives the same machine-number
	 * (on machines with IEEE compatible 64bit doubles). It is
	 * guaranteed that the size of the resulting string will never
	 * be larger than G_ASCII_DTOSTR_BUF_SIZE bytes.
	 * Params:
	 * buffer =  A buffer to place the resulting string in
	 * bufLen =  The length of the buffer.
	 * d =  The gdouble to convert
	 * Returns: The pointer to the buffer with the converted string.
	 */
	public static string asciiDtostr(string buffer, int bufLen, double d);

	/**
	 * Converts a gdouble to a string, using the '.' as
	 * decimal point. To format the number you pass in
	 * a printf()-style format string. Allowed conversion
	 * specifiers are 'e', 'E', 'f', 'F', 'g' and 'G'.
	 * If you just want to want to serialize the value into a
	 * string, use g_ascii_dtostr().
	 * Params:
	 * buffer =  A buffer to place the resulting string in
	 * bufLen =  The length of the buffer.
	 * format =  The printf()-style format to use for the
	 *  code to use for converting.
	 * d =  The gdouble to convert
	 * Returns: The pointer to the buffer with the converted string.
	 */
	public static string asciiFormatd(string buffer, int bufLen, string format, double d);

	/**
	 * Converts a string to a gdouble value.
	 * It calls the standard strtod() function to handle the conversion, but
	 * if the string is not completely converted it attempts the conversion
	 * again with g_ascii_strtod(), and returns the best match.
	 * This function should seldomly be used. The normal situation when reading
	 * numbers not for human consumption is to use g_ascii_strtod(). Only when
	 * you know that you must expect both locale formatted and C formatted numbers
	 * should you use this. Make sure that you don't pass strings such as comma
	 * separated lists of values, since the commas may be interpreted as a decimal
	 * point in some locales, causing unexpected results.
	 * Params:
	 * nptr =  the string to convert to a numeric value.
	 * endptr =  if non-NULL, it returns the character after
	 *  the last character used in the conversion.
	 * Returns: the gdouble value.
	 */
	public static double strtod(string nptr, out string endptr);

	/**
	 * Removes leading whitespace from a string, by moving the rest of the
	 * characters forward.
	 * This function doesn't allocate or reallocate any memory; it modifies string
	 * in place. The pointer to string is returned to allow the nesting of functions.
	 * Also see g_strchomp() and g_strstrip().
	 * Params:
	 * string = a string to remove the leading whitespace from.
	 * Returns:@string.
	 */
	public static string strchug(string string);

	/**
	 * Removes trailing whitespace from a string.
	 * This function doesn't allocate or reallocate any memory; it modifies string in
	 * place. The pointer to string is returned to allow the nesting of functions.
	 * Also see g_strchug() and g_strstrip().
	 * Params:
	 * string = a string to remove the trailing whitespace from.
	 * Returns:@string.
	 */
	public static string strchomp(string string);

	/**
	 * Converts any delimiter characters in string to new_delimiter.
	 * Any characters in string which are found in delimiters are changed
	 * to the new_delimiter character. Modifies string in place, and returns
	 * string itself, not a copy. The return value is to allow nesting such as
	 * g_ascii_strup (g_strdelimit (str, "abc", '?')).
	 * Params:
	 * string = the string to convert.
	 * delimiters = a string containing the current delimiters, or NULL to use the
	 * standard delimiters defined in G_STR_DELIMITERS.
	 * newDelimiter = the new delimiter character.
	 * Returns:@string.
	 */
	public static string strdelimit(string string, string delimiters, char newDelimiter);

	/**
	 * Escapes the special characters '\b', '\f', '\n', '\r', '\t', '\' and
	 * '"' in the string source by inserting a '\' before
	 * them. Additionally all characters in the range 0x01-0x1F (everything
	 * below SPACE) and in the range 0x7F-0xFF (all non-ASCII chars) are
	 * replaced with a '\' followed by their octal representation. Characters
	 * supplied in exceptions are not escaped.
	 * g_strcompress() does the reverse conversion.
	 * Params:
	 * source = a string to escape.
	 * exceptions = a string of characters not to escape in source.
	 * Returns:a newly-allocated copy of source with certaincharacters escaped. See above.
	 */
	public static string strescape(string source, string exceptions);

	/**
	 * Replaces all escaped characters with their one byte equivalent. It
	 * does the reverse conversion of g_strescape().
	 * Params:
	 * source = a string to compress.
	 * Returns:a newly-allocated copy of source with all escaped character compressed.
	 */
	public static string strcompress(string source);

	/**
	 * For each character in string, if the character is not in valid_chars,
	 * replaces the character with substitutor. Modifies string in place,
	 * and return string itself, not a copy. The return value is to allow
	 * nesting such as g_ascii_strup (g_strcanon (str, "abc", '?')).
	 * Params:
	 * string = a nul-terminated array of bytes.
	 * validChars = bytes permitted in string.
	 * substitutor = replacement character for disallowed bytes.
	 * Returns:@string.
	 */
	public static string strcanon(string string, string validChars, char substitutor);

	/**
	 * Splits a string into a maximum of max_tokens pieces, using the given
	 * delimiter. If max_tokens is reached, the remainder of string is appended
	 * to the last token.
	 * As a special case, the result of splitting the empty string "" is an empty
	 * vector, not a vector containing a single string. The reason for this
	 * special case is that being able to represent a empty vector is typically
	 * more useful than consistent handling of empty elements. If you do need
	 * to represent empty elements, you'll need to check for the empty string
	 * before calling g_strsplit().
	 * Params:
	 * string =  a string to split.
	 * delimiter =  a string which specifies the places at which to split the string.
	 *  The delimiter is not included in any of the resulting strings, unless
	 *  max_tokens is reached.
	 * maxTokens =  the maximum number of pieces to split string into. If this is
	 *  less than 1, the string is split completely.
	 * Returns: a newly-allocated NULL-terminated array of strings. Use  g_strfreev() to free it.
	 */
	public static string[] strsplit(string string, string delimiter, int maxTokens);

	/**
	 * Splits string into a number of tokens not containing any of the characters
	 * in delimiter. A token is the (possibly empty) longest string that does not
	 * contain any of the characters in delimiters. If max_tokens is reached, the
	 * remainder is appended to the last token.
	 * For example the result of g_strsplit_set ("abc:def/ghi", ":/", -1) is a
	 * NULL-terminated vector containing the three strings "abc", "def",
	 * and "ghi".
	 * The result if g_strsplit_set (":def/ghi:", ":/", -1) is a NULL-terminated
	 * vector containing the four strings "", "def", "ghi", and "".
	 * As a special case, the result of splitting the empty string "" is an empty
	 * vector, not a vector containing a single string. The reason for this
	 * special case is that being able to represent a empty vector is typically
	 * more useful than consistent handling of empty elements. If you do need
	 * to represent empty elements, you'll need to check for the empty string
	 * before calling g_strsplit_set().
	 * Note that this function works on bytes not characters, so it can't be used
	 * to delimit UTF-8 strings for anything but ASCII characters.
	 * Since 2.4
	 * Params:
	 * string =  The string to be tokenized
	 * delimiters =  A nul-terminated string containing bytes that are used
	 *  to split the string.
	 * maxTokens =  The maximum number of tokens to split string into.
	 *  If this is less than 1, the string is split completely
	 * Returns: a newly-allocated NULL-terminated array of strings. Use  g_strfreev() to free it.
	 */
	public static string[] strsplitSet(string string, string delimiters, int maxTokens);

	/**
	 * Frees a NULL-terminated array of strings, and the array itself.
	 * If called on a NULL value, g_strfreev() simply returns.
	 * Params:
	 * strArray =  a NULL-terminated array of strings to free.
	 */
	public static void strfreev(string[] strArray);

	/**
	 * Joins a number of strings together to form one long string, with the
	 * optional separator inserted between each of them. The returned string
	 * should be freed with g_free().
	 * Params:
	 * separator =  a string to insert between each of the strings, or NULL
	 * strArray =  a NULL-terminated array of strings to join
	 * Returns: a newly-allocated string containing all of the strings joined together, with separator between them
	 */
	public static string strjoinv(string separator, string[] strArray);

	/**
	 * Returns the length of the given NULL-terminated
	 * string array str_array.
	 * Since 2.6
	 * Params:
	 * strArray =  a NULL-terminated array of strings.
	 * Returns: length of str_array.
	 */
	public static uint strvLength(string[] strArray);

	/**
	 * Returns a string corresponding to the given error code, e.g.
	 * "no such process". You should use this function in preference to
	 * strerror(), because it returns a string in UTF-8 encoding, and since
	 * not all platforms support the strerror() function.
	 * Params:
	 * errnum =  the system error number. See the standard C errno
	 *  documentation
	 * Returns: a UTF-8 string describing the error code. If the error code  is unknown, it returns "unknown error (<code>)". The string  can only be used until the next call to g_strerror()
	 */
	public static string strerror(int errnum);

	/**
	 * Returns a string describing the given signal, e.g. "Segmentation fault".
	 * You should use this function in preference to strsignal(), because it
	 * returns a string in UTF-8 encoding, and since not all platforms support
	 * the strsignal() function.
	 * Params:
	 * signum =  the signal number. See the signal
	 *  documentation
	 * Returns: a UTF-8 string describing the signal. If the signal is unknown, it returns "unknown signal (<signum>)". The string can only be  used until the next call to g_strsignal()
	 */
	public static string strsignal(int signum);
}
