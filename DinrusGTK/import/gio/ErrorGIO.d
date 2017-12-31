
module gtkD.gio.ErrorGIO;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * Contains helper functions for reporting errors to the user.
 */
public class ErrorGIO
{
	
	/**
	 */
	
	/**
	 * Converts errno.h error codes into GIO error codes.
	 * Params:
	 * errNo =  Error number as defined in errno.h.
	 * Returns: GIOErrorEnum value for the given errno.h error number.
	 */
	public static GIOErrorEnum fromErrno(int errNo);
}
