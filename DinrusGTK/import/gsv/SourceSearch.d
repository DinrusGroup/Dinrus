module gtkD.gsv.SourceSearch;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.TextIter;
private import gtkD.glib.Str;




/**
 * Description
 */
public class SourceSearch
{
	
	/**
	 */
	
	/**
	 * Same as gtk_text_iter_backward_search(), but supports case insensitive
	 * searching.
	 * Params:
	 * iter =  a GtkTextIter where the search begins.
	 * str =  search string.
	 * flags =  bitmask of flags affecting the search.
	 * matchStart =  return location for start of match, or %NULL.
	 * matchEnd =  return location for end of match, or %NULL.
	 * limit =  location of last possible match_start, or %NULL for start of buffer.
	 * Returns: whether a match was found.
	 */
	public static int backwardSearch(TextIter iter, string str, GtkSourceSearchFlags flags, TextIter matchStart, TextIter matchEnd, TextIter limit);
	
	/**
	 * Searches forward for str. Any match is returned by setting
	 * match_start to the first character of the match and match_end to the
	 * first character after the match. The search will not continue past
	 * limit. Note that a search is a linear or O(n) operation, so you
	 * may wish to use limit to avoid locking up your UI on large
	 * buffers.
	 * If the GTK_SOURCE_SEARCH_VISIBLE_ONLY flag is present, the match may
	 * have invisible text interspersed in str. i.e. str will be a
	 * possibly-noncontiguous subsequence of the matched range. similarly,
	 * if you specify GTK_SOURCE_SEARCH_TEXT_ONLY, the match may have
	 * pixbufs or child widgets mixed inside the matched range. If these
	 * flags are not given, the match must be exact; the special 0xFFFC
	 * character in str will match embedded pixbufs or child widgets.
	 * If you specify the GTK_SOURCE_SEARCH_CASE_INSENSITIVE flag, the text will
	 * be matched regardless of what case it is in.
	 * Same as gtk_text_iter_forward_search(), but supports case insensitive
	 * searching.
	 * Params:
	 * iter =  start of search.
	 * str =  a search string.
	 * flags =  flags affecting how the search is done.
	 * matchStart =  return location for start of match, or %NULL.
	 * matchEnd =  return location for end of match, or %NULL.
	 * limit =  bound for the search, or %NULL for the end of the buffer.
	 * Returns: whether a match was found.
	 */
	public static int forwardSearch(TextIter iter, string str, GtkSourceSearchFlags flags, TextIter matchStart, TextIter matchEnd, TextIter limit);
}
