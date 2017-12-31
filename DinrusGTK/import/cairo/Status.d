module gtkD.cairo.Status;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * Cairo uses a single status type to represent all kinds of errors. A status
 * value of CAIRO_STATUS_SUCCESS represents no error and has an integer value
 * of zero. All other status values represent an error.
 * Cairo's error handling is designed to be easy to use and safe. All major
 * cairo objects retain an error status internally which
 * can be queried anytime by the users using cairo*_status() calls. In
 * the mean time, it is safe to call all cairo functions normally even if the
 * underlying object is in an error status. This means that no error handling
 * code is required before or after each individual cairo function call.
 */
public class Status
{
	
	/**
	 */
	
	/**
	 * Provides a human-readable description of a cairo_status_t.
	 * Params:
	 * status =  a cairo status
	 * Returns: a string representation of the status
	 */
	public static string oString(cairo_status_t status);
	
	/**
	 * Resets all static data within cairo to its original state,
	 * (ie. identical to the state at the time of program invocation). For
	 * example, all caches within cairo will be flushed empty.
	 * This function is intended to be useful when using memory-checking
	 * tools such as valgrind. When valgrind's memcheck analyzes a
	 * cairo-using program without a call to cairo_debug_reset_static_data(),
	 * it will report all data reachable via cairo's static objects as
	 * "still reachable". Calling cairo_debug_reset_static_data() just prior
	 * to program termination will make it easier to get squeaky clean
	 * reports from valgrind.
	 * WARNING: It is only safe to call this function when there are no
	 * active cairo objects remaining, (ie. the appropriate destroy
	 * functions have been called as necessary). If there are active cairo
	 * objects, this call is likely to cause a crash, (eg. an assertion
	 * failure due to a hash table being destroyed when non-empty).
	 */
	public static void debugResetStaticData();
}
