module gtkD.pango.PgTabArray;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * Functions in this section are used to deal with PangoTabArray objects
 * that can be used to set tab stop positions in a PangoLayout.
 */
public class PgTabArray
{
	
	/** the main Gtk struct */
	protected PangoTabArray* pangoTabArray;
	
	
	public PangoTabArray* getPgTabArrayStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoTabArray* pangoTabArray);
	
	/**
	 */
	
	/**
	 * Creates an array of initial_size tab stops. Tab stops are specified in
	 * pixel units if positions_in_pixels is TRUE, otherwise in Pango
	 * units. All stops are initially at position 0.
	 * Params:
	 * initialSize =  Initial number of tab stops to allocate, can be 0
	 * positionsInPixels =  whether positions are in pixel units
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int initialSize, int positionsInPixels);
	
	/**
	 * Copies a PangoTabArray
	 * Returns: the newly allocated PangoTabArray, which should be freed with pango_tab_array_free().
	 */
	public PgTabArray copy();
	
	/**
	 * Frees a tab array and associated resources.
	 */
	public void free();
	
	/**
	 * Gets the number of tab stops in tab_array.
	 * Returns: the number of tab stops in the array.
	 */
	public int getSize();
	
	/**
	 * Resizes a tab array. You must subsequently initialize any tabs that
	 * were added as a result of growing the array.
	 * Params:
	 * newSize =  new size of the array
	 */
	public void resize(int newSize);

	/**
	 * Sets the alignment and location of a tab stop.
	 * alignment must always be PANGO_TAB_LEFT in the current
	 * implementation.
	 * Params:
	 * tabIndex =  the index of a tab stop
	 * alignment =  tab alignment
	 * location =  tab location in Pango units
	 */
	public void setTab(int tabIndex, PangoTabAlign alignment, int location);
	
	/**
	 * Gets the alignment and position of a tab stop.
	 * Params:
	 * tabIndex =  tab stop index
	 * alignment =  location to store alignment, or NULL
	 * location =  location to store tab position, or NULL
	 */
	public void getTab(int tabIndex, out PangoTabAlign alignment, out int location);
	
	/**
	 * If non-NULL, alignments and locations are filled with allocated
	 * arrays of length pango_tab_array_get_size(). You must free the
	 * returned array.
	 * Params:
	 * alignments =  location to store an array of tab stop alignments, or NULL
	 * locations =  location to store an array of tab positions, or NULL
	 */
	public void getTabs(out PangoTabAlign[] alignments, out int[] locations);
	
	/**
	 * Returns TRUE if the tab positions are in pixels, FALSE if they are
	 * in Pango units.
	 * Returns: whether positions are in pixels.
	 */
	public int getPositionsInPixels();
}
