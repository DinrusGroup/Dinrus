
module gtkD.gio.AsyncResultIF;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gobject.ObjectG;




/**
 * Description
 * Provides a base class for implementing asynchronous function results.
 * Asynchronous operations are broken up into two separate operations
 * which are chained together by a GAsyncReadyCallback. To begin
 * an asynchronous operation, provide a GAsyncReadyCallback to the
 * asynchronous function. This callback will be triggered when the
 * operation has completed, and will be passed a GAsyncResult instance
 * filled with the details of the operation's success or failure, the
 * object the asynchronous function was started for and any error codes
 * returned. The asynchronous callback function is then expected to call
 * the corresponding "_finish()" function with the object the function
 * was called for, and the GAsyncResult instance, and optionally,
 * an error to grab any error conditions that may have occurred.
 * The purpose of the "_finish()" function is to take the generic
 * result of type GAsyncResult and return the specific result
 * that the operation in question yields (e.g. a GFileEnumerator for
 * a "enumerate children" operation). If the result or error status
 * of the operation is not needed, there is no need to call the
 * "_finish()" function, GIO will take care of cleaning up the
 * result and error information after the GAsyncReadyCallback
 * returns. It is also allowed to take a reference to the GAsyncResult and
 * call "_finish()" later.
 * Example of a typical asynchronous operation flow:
 * void _theoretical_frobnitz_async (Theoretical *t,
 *  GCancellable *c,
 *  GAsyncReadyCallback *cb,
 *  gpointer u);
 * gboolean _theoretical_frobnitz_finish (Theoretical *t,
 *  GAsyncResult *res,
 *  GError **e);
 * static void
 * frobnitz_result_func (GObject *source_object,
 * 		 GAsyncResult *res,
 * 		 gpointer user_data)
 * {
	 *  gboolean success = FALSE;
	 *  success = _theoretical_frobnitz_finish (source_object, res, NULL);
	 *  if (success)
	 *  g_printf ("Hurray!\n");
	 *  else
	 *  g_printf ("Uh oh!\n");
	 *  /+* ... +/
 * }
 * int main (int argc, void *argv[])
 * {
	 *  /+* ... +/
	 *  _theoretical_frobnitz_async (theoretical_data,
	 *  NULL,
	 *  frobnitz_result_func,
	 *  NULL);
	 *  /+* ... +/
 * }
 * The callback for an asynchronous operation is called only once, and is
 * always called, even in the case of a cancelled operation. On cancellation
 * the result is a G_IO_ERROR_CANCELLED error.
 * Some ascynchronous operations are implemented using synchronous calls. These
 * are run in a separate thread, if GThread has been initialized, but otherwise they
 * are sent to the Main Event Loop and processed in an idle function. So, if you
 * truly need asynchronous operations, make sure to initialize GThread.
 */
public interface AsyncResultIF
{
	
	
	public GAsyncResult* getAsyncResultTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	/**
	 * Gets the user data from a GAsyncResult.
	 * Returns: the user data for res.
	 */
	public void* getUserData();
	
	/**
	 * Gets the source object from a GAsyncResult.
	 * Returns: a new reference to the source object for the res, or NULL if there is none.
	 */
	public ObjectG getSourceObject();
}
