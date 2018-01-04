/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = glib-Strings.html
 * outPack = glib
 * outFile = StringG
 * strct   = GString
 * realStrct=
 * ctorStrct=
 * clss    = StringG
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_string_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * structWrap:
 * 	- GString* -> StringG
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.glib.StringG;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * A GString is similar to a standard C string, except that it grows
 * automatically as text is appended or inserted. Also, it stores the
 * length of the string, so can be used for binary data with embedded
 * nul bytes.
 */
public class StringG
{
	
	/** the main Gtk struct */
	protected GString* gString;
	
	
	public GString* getStringGStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GString* gString);
	
	/**
	 */
	
	/**
	 * Creates a new GString, initialized with the given string.
	 * Params:
	 * init =  the initial text to copy into the string
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string init);
	
	/**
	 * Creates a new GString with len bytes of the init buffer.
	 * Because a length is provided, init need not be nul-terminated,
	 * and can contain embedded nul bytes.
	 * Since this function does not stop at nul bytes, it is the caller's
	 * responsibility to ensure that init has at least len addressable
	 * bytes.
	 * Params:
	 * init =  initial contents of the string
	 * len =  length of init to use
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string init, int len);
	
	/**
	 * Creates a new GString, with enough space for dfl_size
	 * bytes. This is useful if you are going to add a lot of
	 * text to the string and don't want it to be reallocated
	 * too often.
	 * Params:
	 * dflSize =  the default size of the space allocated to
	 *  hold the string
	 * Returns: the new GString
	 */
	public static StringG sizedNew(uint dflSize);
	
	/**
	 * Copies the bytes from a string into a GString,
	 * destroying any previous contents. It is rather like
	 * the standard strcpy() function, except that you do not
	 * have to worry about having enough space to copy the string.
	 * Params:
	 * string =  the destination GString. Its current contents
	 *  are destroyed.
	 * rval =  the string to copy into string
	 * Returns: string
	 */
	public StringG assign(string rval);
	
	/**
	 * Writes a formatted string into a GString.
	 * This function is similar to g_string_printf() except that
	 * the arguments to the format string are passed as a va_list.
	 * Since 2.14
	 * Params:
	 * string =  a GString
	 * format =  the string format. See the printf() documentation
	 * args =  the parameters to insert into the format string
	 */
	public void vprintf(string format, void* args);
	
	/**
	 * Appends a formatted string onto the end of a GString.
	 * This function is similar to g_string_append_printf()
	 * except that the arguments to the format string are passed
	 * as a va_list.
	 * Since 2.14
	 * Params:
	 * string =  a GString
	 * format =  the string format. See the printf() documentation
	 * args =  the list of arguments to insert in the output
	 */
	public void appendVprintf(string format, void* args);
	
	/**
	 * Adds a string onto the end of a GString, expanding
	 * it if necessary.
	 * Params:
	 * string =  a GString
	 * val =  the string to append onto the end of string
	 * Returns: string
	 */
	public StringG append(string val);
	
	/**
	 * Adds a byte onto the end of a GString, expanding
	 * it if necessary.
	 * Params:
	 * c =  the byte to append onto the end of string
	 * Returns: string
	 */
	public StringG appendC(char c);
	
	/**
	 * Converts a Unicode character into UTF-8, and appends it
	 * to the string.
	 * Params:
	 * wc =  a Unicode character
	 * Returns: string
	 */
	public StringG appendUnichar(gunichar wc);
	
	/**
	 * Appends len bytes of val to string. Because len is
	 * provided, val may contain embedded nuls and need not
	 * be nul-terminated.
	 * Since this function does not stop at nul bytes, it is
	 * the caller's responsibility to ensure that val has at
	 * least len addressable bytes.
	 * Params:
	 * string =  a GString
	 * val =  bytes to append
	 * len =  number of bytes of val to use
	 * Returns: string
	 */
	public StringG appendLen(string val, int len);
	
	/**
	 * Appends unescaped to string, escaped any characters that
	 * are reserved in URIs using URI-style escape sequences.
	 * Since 2.16
	 * Params:
	 * string =  a GString
	 * unescaped =  a string
	 * reservedCharsAllowed =  a string of reserved characters allowed to be used
	 * allowUtf8 =  set TRUE if the escaped string may include UTF8 characters
	 * Returns: string
	 */
	public StringG appendUriEscaped(string unescaped, string reservedCharsAllowed, int allowUtf8);
	
	/**
	 * Adds a string on to the start of a GString,
	 * expanding it if necessary.
	 * Params:
	 * string =  a GString
	 * val =  the string to prepend on the start of string
	 * Returns: string
	 */
	public StringG prepend(string val);
	
	/**
	 * Adds a byte onto the start of a GString,
	 * expanding it if necessary.
	 * Params:
	 * c =  the byte to prepend on the start of the GString
	 * Returns: string
	 */
	public StringG prependC(char c);
	
	/**
	 * Converts a Unicode character into UTF-8, and prepends it
	 * to the string.
	 * Params:
	 * wc =  a Unicode character
	 * Returns: string
	 */
	public StringG prependUnichar(gunichar wc);
	
	/**
	 * Prepends len bytes of val to string.
	 * Because len is provided, val may contain
	 * embedded nuls and need not be nul-terminated.
	 * Since this function does not stop at nul bytes,
	 * it is the caller's responsibility to ensure that
	 * val has at least len addressable bytes.
	 * Params:
	 * string =  a GString
	 * val =  bytes to prepend
	 * len =  number of bytes in val to prepend
	 * Returns: string
	 */
	public StringG prependLen(string val, int len);
	
	/**
	 * Inserts a copy of a string into a GString,
	 * expanding it if necessary.
	 * Params:
	 * string =  a GString
	 * pos =  the position to insert the copy of the string
	 * val =  the string to insert
	 * Returns: string
	 */
	public StringG insert(int pos, string val);
	
	/**
	 * Inserts a byte into a GString, expanding it if necessary.
	 * Params:
	 * pos =  the position to insert the byte
	 * c =  the byte to insert
	 * Returns: string
	 */
	public StringG insertC(int pos, char c);
	
	/**
	 * Converts a Unicode character into UTF-8, and insert it
	 * into the string at the given position.
	 * Params:
	 * pos =  the position at which to insert character, or -1 to
	 *  append at the end of the string
	 * wc =  a Unicode character
	 * Returns: string
	 */
	public StringG insertUnichar(int pos, gunichar wc);
	
	/**
	 * Inserts len bytes of val into string at pos.
	 * Because len is provided, val may contain embedded
	 * nuls and need not be nul-terminated. If pos is -1,
	 * bytes are inserted at the end of the string.
	 * Since this function does not stop at nul bytes, it is
	 * the caller's responsibility to ensure that val has at
	 * least len addressable bytes.
	 * Params:
	 * string =  a GString
	 * pos =  position in string where insertion should
	 *  happen, or -1 for at the end
	 * val =  bytes to insert
	 * len =  number of bytes of val to insert
	 * Returns: string
	 */
	public StringG insertLen(int pos, string val, int len);
	
	/**
	 * Overwrites part of a string, lengthening it if necessary.
	 * Since 2.14
	 * Params:
	 * string =  a GString
	 * pos =  the position at which to start overwriting
	 * val =  the string that will overwrite the string starting at pos
	 * Returns: string
	 */
	public StringG overwrite(uint pos, string val);
	
	/**
	 * Overwrites part of a string, lengthening it if necessary.
	 * This function will work with embedded nuls.
	 * Since 2.14
	 * Params:
	 * string =  a GString
	 * pos =  the position at which to start overwriting
	 * val =  the string that will overwrite the string starting at pos
	 * len =  the number of bytes to write from val
	 * Returns: string
	 */
	public StringG overwriteLen(uint pos, string val, int len);
	
	/**
	 * Removes len bytes from a GString, starting at position pos.
	 * The rest of the GString is shifted down to fill the gap.
	 * Params:
	 * pos =  the position of the content to remove
	 * len =  the number of bytes to remove, or -1 to remove all
	 *  following bytes
	 * Returns: string
	 */
	public StringG erase(int pos, int len);
	
	/**
	 * Cuts off the end of the GString, leaving the first len bytes.
	 * Params:
	 * len =  the new size of string
	 * Returns: string
	 */
	public StringG truncate(uint len);
	
	/**
	 * Sets the length of a GString. If the length is less than
	 * the current length, the string will be truncated. If the
	 * length is greater than the current length, the contents
	 * of the newly added area are undefined. (However, as
	 * always, string->str[string->len] will be a nul byte.)
	 * Params:
	 * len =  the new length
	 * Returns: string
	 */
	public StringG setSize(uint len);
	
	/**
	 * Frees the memory allocated for the GString.
	 * If free_segment is TRUE it also frees the character data.
	 * Params:
	 * string =  a GString
	 * freeSegment =  if TRUE the actual character data is freed as well
	 * Returns: the character data of string  (i.e. NULL if free_segment is TRUE)
	 */
	public string free(int freeSegment);
	
	/**
	 * Warning
	 * g_string_up has been deprecated since version 2.2 and should not be used in newly-written code. This function uses the locale-specific
	 *  toupper() function, which is almost never the right thing.
	 *  Use g_string_ascii_up() or g_utf8_strup() instead.
	 * Converts a GString to uppercase.
	 * Returns: string
	 */
	public StringG up();
	
	/**
	 * Warning
	 * g_string_down has been deprecated since version 2.2 and should not be used in newly-written code. This function uses the locale-specific
	 *  tolower() function, which is almost never the right thing.
	 *  Use g_string_ascii_down() or g_utf8_strdown() instead.
	 * Converts a GString to lowercase.
	 * Returns: the GString.
	 */
	public StringG down();
	
	/**
	 * Creates a hash code for str; for use with GHashTable.
	 * Returns: hash code for str
	 */
	public uint hash();
	
	/**
	 * Compares two strings for equality, returning TRUE if they are equal.
	 * For use with GHashTable.
	 * Params:
	 * v =  a GString
	 * v2 =  another GString
	 * Returns: TRUE if they strings are the same length and contain the  same bytes
	 */
	public int equal(StringG v2);
}
