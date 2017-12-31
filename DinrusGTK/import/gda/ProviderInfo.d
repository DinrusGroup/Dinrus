
module gtkD.gda.ProviderInfo;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;




/**
 * Description
 *  The functions in this section allow applications an easy access to the libgda
 *  configuration, thus making them able to access the list of data sources
 *  configured in the system, for instance.
 */
public class ProviderInfo
{
	
	/** the main Gtk struct */
	protected GdaProviderInfo* gdaProviderInfo;
	
	
	public GdaProviderInfo* getProviderInfoStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaProviderInfo* gdaProviderInfo);
	
	/** */
	this (ListG glist) ;
	/** */
string id() ;
/** */
string location() ;
/** */
string description() ;
/** */
ListG gda_params();

/**
 */

/**
 * Returns:
 */
public static GType infoGetType();

/**
 * Creates a new GdaProviderInfo structure from an existing one.
 * Returns: a newly allocated GdaProviderInfo with contains a copy of information in src.
 */
public ProviderInfo infoCopy();

/**
 * Deallocates all memory associated to the given GdaProviderInfo.
 */
public void infoFree();
}
