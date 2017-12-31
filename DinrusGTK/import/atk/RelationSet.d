module gtkD.atk.RelationSet;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.atk.ObjectAtk;
private import gtkD.atk.Relation;
private import gtkD.glib.PtrArray;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The AtkRelationSet held by an object establishes its relationships with
 * objects beyond the normal "parent/child" hierarchical relationships that all
 * user interface objects have. AtkRelationSets establish whether objects are
 * labelled or controlled by other components, share group membership with other
 * components (for instance within a radio-button group), or share content which
 * "flows" between them, among other types of possible relationships.
 */
public class RelationSet : ObjectG
{
	
	/** the main Gtk struct */
	protected AtkRelationSet* atkRelationSet;
	
	
	public AtkRelationSet* getRelationSetStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkRelationSet* atkRelationSet);
	
	/**
	 */
	
	/**
	 * Creates a new empty relation set.
	 * Returns: a new AtkRelationSet
	 */
	public static AtkRelationSet* atkRelationSetNew();
	
	/**
	 * Determines whether the relation set contains a relation that matches the
	 * specified type.
	 * Params:
	 * relationship =  an AtkRelationType
	 * Returns: TRUE if relationship is the relationship type of a relationin set, FALSE otherwise
	 */
	public int atkRelationSetContains(AtkRelationType relationship);
	
	/**
	 * Removes a relation from the relation set.
	 * This function unref's the AtkRelation so it will be deleted unless there
	 * is another reference to it.
	 * Params:
	 * relation =  an AtkRelation
	 */
	public void atkRelationSetRemove(Relation relation);
	
	/**
	 * Add a new relation to the current relation set if it is not already
	 * present.
	 * This function ref's the AtkRelation so the caller of this function
	 * should unref it to ensure that it will be destroyed when the AtkRelationSet
	 * is destroyed.
	 * Params:
	 * relation =  an AtkRelation
	 */
	public void atkRelationSetAdd(Relation relation);
	
	/**
	 * Determines the number of relations in a relation set.
	 * Returns: an integer representing the number of relations in the set.
	 */
	public int atkRelationSetGetNRelations();
	
	/**
	 * Determines the relation at the specified position in the relation set.
	 * Params:
	 * i =  a gint representing a position in the set, starting from 0.
	 * Returns: a AtkRelation, which is the relation at position i in the set.
	 */
	public Relation atkRelationSetGetRelation(int i);
	
	/**
	 * Finds a relation that matches the specified type.
	 * Params:
	 * relationship =  an AtkRelationType
	 * Returns: an AtkRelation, which is a relation matching the specified type.
	 */
	public Relation atkRelationSetGetRelationByType(AtkRelationType relationship);
	
	/**
	 * Add a new relation of the specified type with the specified target to
	 * the current relation set if the relation set does not contain a relation
	 * of that type. If it is does contain a relation of that typea the target
	 * is added to the relation.
	 * Since 1.9
	 * Params:
	 * relationship =  an AtkRelationType
	 * target =  an AtkObject
	 */
	public void atkRelationSetAddRelationByType(AtkRelationType relationship, ObjectAtk target);
}
