
module gtkD.pango.PgEngineLang;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;





private import gtkD.pango.PgEngine;

/**
 * Description
 * The language engines are rendering-system independent
 * engines that determine line, word, and character breaks for character strings.
 * These engines are used in pango_break().
 */
public class PgEngineLang : PgEngine
{
	
	/** the main Gtk struct */
	protected PangoEngineLang* pangoEngineLang;
	
	
	public PangoEngineLang* getPgEngineLangStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoEngineLang* pangoEngineLang);
	
	/**
	 */
}
