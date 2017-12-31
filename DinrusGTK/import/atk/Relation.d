module gtkD.atk.Relation;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.atk.ObjectAtk;
private import gtkD.glib.PtrArray;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * An AtkRelation describes a relation between an object and one or more
 * other objects. The actual relations that an object has with other objects
 * are defined as an AtkRelationSet, which is a set of AtkRelations.
 */
public class Relation : ObjectG
{
	
	/** the main Gtk struct */
	protected AtkRelation* atkRelation;
	
	
	public AtkRelation* getRelationStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkRelation* atkRelation);
	
	/**
	 */
	
	/**
	 * Associate name with a new AtkRelationType
	 * Params:
	 * name =  a name string
	 * Returns: an AtkRelationType associated with name
	 */
	public static AtkRelationType typeRegister(string name);
	
	/**
	 * Gets the description string describing the AtkRelationType type.
	 * Params:
	 * type =  The AtkRelationType whose name is required
	 * Returns: the string describing the AtkRelationType
	 */
	public static string typeGetName(AtkRelationType type);
	
	/**
	 * Get the AtkRelationType type corresponding to a relation name.
	 * Params:
	 * name =  a string which is the (non-localized) name of an ATK relation type.
	 * Returns: the AtkRelationType enumerated type corresponding to the specified name, or ATK_RELATION_NULL if no matching relation type is found.
	 */
	public static AtkRelationType typeForName(string name);
	
	/**
	 * Create a new relation for the specified key and the specified list
	 * of targets. See also atk_object_add_relationship().
	 * Params:
	 * targets =  an array of pointers to AtkObjects
	 * relationship =  an AtkRelationType with which to create the new
	 *  AtkRelation
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectAtk[] targets, AtkRelationType relationship);
	
	/**
	 * Gets the type of relation
	 * Returns: the type of relation
	 */
	public AtkRelationType getRelationType();
	
	/**
	 * Gets the target list of relation
	 * Returns: the target list of relation
	 */
	public PtrArray getTarget();
	
	/**
	 * Adds the specified AtkObject to the target for the relation, if it is
	 * not already present. See also atk_object_add_relationship().
	 * Since 1.9
	 * Params:
	 * target =  an AtkObject
	 */
	public void addTarget(ObjectAtk target);
}
