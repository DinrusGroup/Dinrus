module gtkD.glib.URI;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * Functions for manipulating Universal Resource Identifiers (URIs) as
 * defined by
 * RFC 3986. It is highly recommended that you have read and
 * understand RFC 3986 for understanding this API.
 */
public class URI
{
	
	/**
	 */
	
	/**
	 * Since 2.16
	 * Params:
	 * uri =  a valid URI.
	 * Returns: The "Scheme" component of the URI, or NULL on error. The returned string should be freed when no longer needed.
	 */
	public static string parseScheme(string uri);
	
	/**
	 * Escapes a string for use in a URI.
	 * Normally all characters that are not "unreserved" (i.e. ASCII alphanumerical
	 * characters plus dash, dot, underscore and tilde) are escaped.
	 * But if you specify characters in reserved_chars_allowed they are not
	 * escaped. This is useful for the "reserved" characters in the URI
	 * specification, since those are allowed unescaped in some portions of
	 * a URI.
	 * Since 2.16
	 * Params:
	 * unescaped =  the unescaped input string.
	 * reservedCharsAllowed =  a string of reserved characters that are
	 *  allowed to be used.
	 * allowUtf8 =  TRUE if the result can include UTF-8 characters.
	 * Returns: an escaped version of unescaped. The returned string should be freed when no longer needed.
	 */
	public static string escapeString(string unescaped, string reservedCharsAllowed, int allowUtf8);
	
	/**
	 * Unescapes a whole escaped string.
	 * If any of the characters in illegal_characters or the character zero appears
	 * as an escaped character in escaped_string then that is an error and NULL
	 * will be returned. This is useful it you want to avoid for instance having a
	 * slash being expanded in an escaped path element, which might confuse pathname
	 * handling.
	 * Since 2.16
	 * Params:
	 * escapedString =  an escaped string to be unescaped.
	 * illegalCharacters =  an optional string of illegal characters not to be allowed.
	 * Returns: an unescaped version of escaped_string. The returned string should be freed when no longer needed.
	 */
	public static string unescapeString(string escapedString, string illegalCharacters);
	
	/**
	 * Unescapes a segment of an escaped string.
	 * If any of the characters in illegal_characters or the character zero appears
	 * as an escaped character in escaped_string then that is an error and NULL
	 * will be returned. This is useful it you want to avoid for instance having a
	 * slash being expanded in an escaped path element, which might confuse pathname
	 * handling.
	 * Since 2.16
	 * Params:
	 * escapedString =  a string.
	 * escapedStringEnd =  a string.
	 * illegalCharacters =  an optional string of illegal characters not to be allowed.
	 * Returns: an unescaped version of escaped_string or NULL on error.The returned string should be freed when no longer needed.
	 */
	public static string unescapeSegment(string escapedString, string escapedStringEnd, string illegalCharacters);
	
	/**
	 * Splits an URI list conforming to the text/uri-list
	 * mime type defined in RFC 2483 into individual URIs,
	 * discarding any comments. The URIs are not validated.
	 * Since 2.6
	 * Params:
	 * uriList =  an URI list
	 * Returns: a newly allocated NULL-terminated list of strings holding the individual URIs. The array should be freed with g_strfreev().
	 */
	public static string[] listExtractUris(string uriList);
}
