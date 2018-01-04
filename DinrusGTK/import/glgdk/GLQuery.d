module gtkD.glgdk.GLQuery;

public  import gtkD.gtkglc.glgdktypes;

private import gtkD.gtkglc.glgdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Display;




/**
 * Description
 */
public class GLQuery
{
	
	/**
	 */
	
	/**
	 * Indicates whether the window system supports the OpenGL extension
	 * (GLX, WGL, etc.).
	 * Returns: TRUE if OpenGL is supported, FALSE otherwise.
	 */
	public static int extension();
	
	/**
	 * Indicates whether the window system supports the OpenGL extension
	 * (GLX, WGL, etc.).
	 * Params:
	 * display =  the GdkDisplay where the query is sent to.
	 * Returns: TRUE if OpenGL is supported, FALSE otherwise.
	 */
	public static int extensionForDisplay(Display display);
	
	/**
	 * Returns the version numbers of the OpenGL extension to the window system.
	 * In the X Window System, it returns the GLX version.
	 * In the Microsoft Windows, it returns the Windows version.
	 * Params:
	 * major =  returns the major version number of the OpenGL extension.
	 * minor =  returns the minor version number of the OpenGL extension.
	 * Returns: FALSE if it fails, TRUE otherwise.
	 */
	public static int versio(out int major, out int minor);
	
	/**
	 * Returns the version numbers of the OpenGL extension to the window system.
	 * In the X Window System, it returns the GLX version.
	 * In the Microsoft Windows, it returns the Windows version.
	 * Params:
	 * display =  the GdkDisplay where the query is sent to.
	 * major =  returns the major version number of the OpenGL extension.
	 * minor =  returns the minor version number of the OpenGL extension.
	 * Returns: FALSE if it fails, TRUE otherwise.
	 */
	public static int versionForDisplay(Display display, out int major, out int minor);
	
	/**
	 * Determines whether a given OpenGL extension is supported.
	 * There must be a valid current rendering context to call
	 * gdk_gl_query_gl_extension().
	 * gdk_gl_query_gl_extension() returns information about OpenGL extensions
	 * only. This means that window system dependent extensions (for example,
	 * GLX extensions) are not reported by gdk_gl_query_gl_extension().
	 * Params:
	 * extension =  name of OpenGL extension.
	 * Returns: TRUE if the OpenGL extension is supported, FALSE if not  supported.
	 */
	public static int glExtension(string extension);
	
	/**
	 * Returns the address of the OpenGL, GLU, or GLX function.
	 * Params:
	 * procName =  function name.
	 * Returns: the address of the function named by proc_name.<<InitializationFrame Buffer Configuration>>
	 */
	public static GdkGLProc getProcAddress(string procName);
}
