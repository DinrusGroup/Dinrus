module gtkD.pango.PgCoverage;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * It is often necessary in Pango to determine if a particular font can
 * represent a particular character, and also how well it can represent
 * that character. The PangoCoverage is a data structure that is used
 * to represent that information.
 */
public class PgCoverage
{
	
	/** the main Gtk struct */
	protected PangoCoverage* pangoCoverage;
	
	
	public PangoCoverage* getPgCoverageStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoCoverage* pangoCoverage);
	
	/**
	 */
	
	/**
	 * Create a new PangoCoverage
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Increase the reference count on the PangoCoverage by one
	 * Returns: coverage
	 */
	public PgCoverage doref();
	
	/**
	 * Decrease the reference count on the PangoCoverage by one.
	 * If the result is zero, free the coverage and all associated memory.
	 */
	public void unref();
	
	/**
	 * Copy an existing PangoCoverage. (This function may now be unnecessary
	 * since we refcount the structure. File a bug if you use it.)
	 * Returns: the newly allocated PangoCoverage, with a reference count of one, which should be freed with pango_coverage_unref().
	 */
	public PgCoverage copy();
	
	/**
	 * Determine whether a particular index is covered by coverage
	 * Params:
	 * index =  the index to check
	 * Returns: the coverage level of coverage for character index_.
	 */
	public PangoCoverageLevel get(int index);
	
	/**
	 * Set the coverage for each index in coverage to be the max (better)
	 * value of the current coverage for the index and the coverage for
	 * the corresponding index in other.
	 * Params:
	 * other =  another PangoCoverage
	 */
	public void max(PgCoverage other);
	
	/**
	 * Modify a particular index within coverage
	 * Params:
	 * index =  the index to modify
	 * level =  the new level for index_
	 */
	public void set(int index, PangoCoverageLevel level);
	
	/**
	 * Convert a PangoCoverage structure into a flat binary format
	 * Params:
	 * bytes =  location to store result (must be freed with g_free())
	 */
	public void toBytes(out char[] bytes);
	
	/**
	 * Convert data generated from pango_converage_to_bytes() back
	 * to a PangoCoverage
	 * Params:
	 * bytes =  binary data representing a PangoCoverage
	 * Returns: a newly allocated PangoCoverage, or NULL if the data was invalid.
	 */
	public static PgCoverage fromBytes(char[] bytes);
}
