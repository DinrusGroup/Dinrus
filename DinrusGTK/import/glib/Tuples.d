
module gtkD.glib.Tuples;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * A GRelation is a table of data which can be indexed on any number of fields,
 * rather like simple database tables. A GRelation contains a number of
 * records, called tuples. Each record contains a number of fields.
 * Records are not ordered, so it is not possible to find the record at a
 * particular index.
 * Note that GRelation tables are currently limited to 2 fields.
 * To create a GRelation, use g_relation_new().
 * To specify which fields should be indexed, use g_relation_index().
 * Note that this must be called before any tuples are added to the GRelation.
 * To add records to a GRelation use g_relation_insert().
 * To determine if a given record appears in a GRelation, use
 * g_relation_exists(). Note that fields are compared directly, so pointers
 * must point to the exact same position (i.e. different copies of the same
 * string will not match.)
 * To count the number of records which have a particular value in a given
 * field, use g_relation_count().
 * To get all the records which have a particular value in a given field,
 * use g_relation_select(). To access fields of the resulting records,
 * use g_tuples_index(). To free the resulting records use g_tuples_destroy().
 * To delete all records which have a particular value in a given field,
 * use g_relation_delete().
 * To destroy the GRelation, use g_relation_destroy().
 * To help debug GRelation objects, use g_relation_print().
 */
public class Tuples
{
	
	/** the main Gtk struct */
	protected GTuples* gTuples;
	
	
	public GTuples* getTuplesStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GTuples* gTuples);
	
	/**
	 */
	
	/**
	 * Frees the records which were returned by g_relation_select().
	 * This should always be called after g_relation_select() when you are
	 * finished with the records.
	 * The records are not removed from the GRelation.
	 */
	public void destroy();
	
	/**
	 * Gets a field from the records returned by g_relation_select().
	 * It returns the given field of the record at the given index.
	 * The returned value should not be changed.
	 * Params:
	 * index = the index of the record.
	 * field = the field to return.
	 * Returns:the field of the record.
	 */
	public void* index(int index, int field);
}
