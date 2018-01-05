module gtkD.pango.PgEngineShape;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;





private import gtkD.pango.PgEngine;

/**
 * Description
 * The shape engines are rendering-system dependent
 * engines that convert character strings into glyph strings.
 * These engines are used in pango_shape().
 */
public class PgEngineShape : PgEngine
{
	
	/** the main Gtk struct */
	protected PangoEngineShape* pangoEngineShape;
	
	
	public PangoEngineShape* getPgEngineShapeStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoEngineShape* pangoEngineShape);
	
	/**
	 */
}
