module gtkD.gio.LoadableIconT;

public  import gtkD.gtkc.giotypes;

public import gtkD.gtkc.gio;
public import gtkD.glib.ConstructionException;


public import gtkD.glib.Str;
public import gtkD.glib.ErrorG;
public import gtkD.glib.GException;
public import gtkD.gio.AsyncResultIF;
public import gtkD.gio.Cancellable;
public import gtkD.gio.InputStream;




/**
 * Description
 * Extends the GIcon interface and adds the ability to
 * load icons from streams.
 */
public template LoadableIconT(TStruct)
{
	
	/** the main Gtk struct */
	protected GLoadableIcon* gLoadableIcon;
	
	
	public GLoadableIcon* getLoadableIconTStruct()
	{
		return cast(GLoadableIcon*)getStruct();
	}
	
	
	/**
	 */
	
	/**
	 * Loads a loadable icon. For the asynchronous version of this function,
	 * see g_loadable_icon_load_async().
	 * Params:
	 * size =  an integer.
	 * type =  a location to store the type of the loaded icon, NULL to ignore.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * Returns: a GInputStream to read the icon from.
	 * Throws: GException on failure.
	 */
	public InputStream load(int size, out string type, Cancellable cancellable)
	{
		// GInputStream * g_loadable_icon_load (GLoadableIcon *icon,  int size,  char **type,  GCancellable *cancellable,  GError **error);
		char* outtype = null;
		GError* err = null;
		
		auto p = g_loadable_icon_load(getLoadableIconTStruct(), size, &outtype, (cancellable is null) ? null : cancellable.getCancellableStruct(), &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		type = Str.toString(outtype);
		if(p is null)
		{
			return null;
		}
		return new InputStream(cast(GInputStream*) p);
	}
	
	/**
	 * Loads an icon asynchronously. To finish this function, see
	 * g_loadable_icon_load_finish(). For the synchronous, blocking
	 * version of this function, see g_loadable_icon_load().
	 * Params:
	 * size =  an integer.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 * callback =  a GAsyncReadyCallback to call when the request is satisfied
	 * userData =  the data to pass to callback function
	 */
	public void loadAsync(int size, Cancellable cancellable, GAsyncReadyCallback callback, void* userData)
	{
		// void g_loadable_icon_load_async (GLoadableIcon *icon,  int size,  GCancellable *cancellable,  GAsyncReadyCallback callback,  gpointer user_data);
		g_loadable_icon_load_async(getLoadableIconTStruct(), size, (cancellable is null) ? null : cancellable.getCancellableStruct(), callback, userData);
	}
	
	/**
	 * Finishes an asynchronous icon load started in g_loadable_icon_load_async().
	 * Params:
	 * res =  a GAsyncResult.
	 * type =  a location to store the type of the loaded icon, NULL to ignore.
	 * Returns: a GInputStream to read the icon from.
	 * Throws: GException on failure.
	 */
	public InputStream loadFinish(AsyncResultIF res, out string type)
	{
		// GInputStream * g_loadable_icon_load_finish (GLoadableIcon *icon,  GAsyncResult *res,  char **type,  GError **error);
		char* outtype = null;
		GError* err = null;
		
		auto p = g_loadable_icon_load_finish(getLoadableIconTStruct(), (res is null) ? null : res.getAsyncResultTStruct(), &outtype, &err);
		
		if (err !is null)
		{
			throw new GException( new ErrorG(err) );
		}
		
		type = Str.toString(outtype);
		if(p is null)
		{
			return null;
		}
		return new InputStream(cast(GInputStream*) p);
	}
}
