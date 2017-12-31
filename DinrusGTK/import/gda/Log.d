module gtkD.gda.Log;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 */
public class Log
{
	
	/*
	 * Logs the given message in the GDA log file.
	 */
	void message(string msg);
	
	/*
	 * Logs the given error in the GDA log file.
	 */
	void error(string err);
	
	/**
	 */
	
	/**
	 * Enables GDA logs.
	 */
	public static void enable();
	
	/**
	 * Disables GDA logs.
	 */
	public static void disable();
	
	/**
	 * Returns: whether GDA logs are enabled (TRUE or FALSE).
	 */
	public static int isEnabled();
}
