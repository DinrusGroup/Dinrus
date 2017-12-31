module gtkD.gda.DataSourceInfo;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;
private import gtkD.glib.Str;




/**
 * Description
 *  The functions in this section allow applications an easy access to the libgda
 *  configuration, thus making them able to access the list of data sources
 *  configured in the system, for instance.
 */
public class DataSourceInfo
{
	
	/** the main Gtk struct */
	protected GdaDataSourceInfo* gdaDataSourceInfo;
	
	
	public GdaDataSourceInfo* getDataSourceInfoStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaDataSourceInfo* gdaDataSourceInfo);
	
	/** */
	this (ListG glist) ;
	/** */
	string name() ;
	/** */
	string provider() ;
	/** */
	string cncString() ;
	/** */
	string description() ;
	/** */
	string username() ;
	/** */
	string password() ;

	/**
	 */

	/**
	 * Returns:
	 */
	public static GType infoGetType();

}
