
module gtkD.glib.Relation;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Tuples;




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
public class Relation
{
	
	/** the main Gtk struct */
	protected GRelation* gRelation;
	
	
	public GRelation* getRelationStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GRelation* gRelation);
	
	/**
	 * Outputs information about all records in a GRelation, as well as the indexes.
	 * It is for debugging.
	 */
	version(Rulada)
	{
		public void print();
	}
	else version(D_Version2)
	{
		public void print();
	}
	else
	{
		public override void print();
	}
	
	/**
	 */
	
	/**
	 * Creates a new GRelation with the given number of fields.
	 * Note that currently the number of fields must be 2.
	 * Params:
	 * fields = the number of fields.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (int fields);
	
	/**
	 * Creates an index on the given field.
	 * Note that this must be called before any records are added to the GRelation.
	 * Params:
	 * field = the field to index, counting from 0.
	 * hashFunc = a function to produce a hash value from the field data.
	 * keyEqualFunc = a function to compare two values of the given field.
	 */
	public void index(int field, GHashFunc hashFunc, GEqualFunc keyEqualFunc);
	
	/**
	 * Returns the number of tuples in a GRelation that have the given value
	 * in the given field.
	 * Params:
	 * key = the value to compare with.
	 * field = the field of each record to match.
	 * Returns:the number of matches.
	 */
	public int count(void* key, int field);
	
	/**
	 * Returns all of the tuples which have the given key in the given field.
	 * Use g_tuples_index() to access the returned records.
	 * The returned records should be freed with g_tuples_destroy().
	 * Params:
	 * key = the value to compare with.
	 * field = the field of each record to match.
	 * Returns:the records (tuples) that matched.
	 */
	public Tuples select(void* key, int field);
	
	/**
	 * Deletes any records from a GRelation that have the given key value in
	 * the given field.
	 * Params:
	 * key = the value to compare with.
	 * field = the field of each record to match.
	 * Returns:the number of records deleted.
	 */
	public int delet(void* key, int field);
	
	/**
	 * Destroys the GRelation, freeing all memory allocated.
	 * However, it does not free memory allocated for the
	 * tuple data, so you should free that first if appropriate.
	 */
	public void destroy();
}
