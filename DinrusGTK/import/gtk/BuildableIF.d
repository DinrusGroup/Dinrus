module gtkD.gtk.BuildableIF;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.ObjectG;
private import gtkD.gobject.Value;
private import gtkD.gtk.Builder;




/**
 * Description
 * In order to allow construction from a GtkBuilder
 * UI description, an object class must implement the
 * GtkBuildable interface. The interface includes methods for setting
 * names and properties of objects, parsing custom tags, constructing
 * child objects.
 * The GtkBuildable interface is implemented by all widgets and
 * many of the non-widget objects that are provided by GTK+. The
 * main user of this interface is GtkBuilder, there should be
 * very little need for applications to call any
 * gtk_buildable_... functions.
 */
public interface BuildableIF
{
	
	
	public GtkBuildable* getBuildableTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 */
	
	/**
	 * Sets the name of the buildable object.
	 * Since 2.12
	 * Params:
	 * name =  name to set
	 */
	public void buildableSetName(string name);
	
	/**
	 * Gets the name of the buildable object.
	 * GtkBuilder sets the name based on the the
	 * GtkBuilder UI definition
	 * used to construct the buildable.
	 * Since 2.12
	 * Returns: the name set with gtk_buildable_set_name()
	 */
	public string buildableGetName();
	
	/**
	 * Adds a child to buildable. type is an optional string
	 * describing how the child should be added.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 * child =  child to add
	 * type =  kind of child or NULL
	 */
	public void addChild(Builder builder, ObjectG child, string type);
	
	/**
	 * Sets the property name name to value on the buildable object.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 * name =  name of property
	 * value =  value of property
	 */
	public void setBuildableProperty(Builder builder, string name, Value value);
	
	/**
	 * Constructs a child of buildable with the name name.
	 * GtkBuilder calls this function if a "constructor" has been
	 * specified in the UI definition.
	 * Since 2.12
	 * Params:
	 * builder =  GtkBuilder used to construct this object
	 * name =  name of child to construct
	 * Returns: the constructed child
	 */
	public ObjectG constructChild(Builder builder, string name);
	
	/**
	 * This is called for each unknown element under <child>.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder used to construct this object
	 * child =  child object or NULL for non-child tags
	 * tagname =  name of tag
	 * parser =  a GMarkupParser structure to fill in
	 * data =  return location for user data that will be passed in
	 *  to parser functions
	 * Returns: TRUE if a object has a custom implementation, FALSE if it doesn't.
	 */
	public int customTagStart(Builder builder, ObjectG child, string tagname, GMarkupParser* parser, void** data);
	
	/**
	 * This is called at the end of each custom element handled by
	 * the buildable.
	 * Since 2.12
	 * Params:
	 * builder =  GtkBuilder used to construct this object
	 * child =  child object or NULL for non-child tags
	 * tagname =  name of tag
	 * data =  user data that will be passed in to parser functions
	 */
	public void customTagEnd(Builder builder, ObjectG child, string tagname, void** data);
	
	/**
	 * This is similar to gtk_buildable_parser_finished() but is
	 * called once for each custom tag handled by the buildable.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 * child =  child object or NULL for non-child tags
	 * tagname =  the name of the tag
	 * data =  user data created in custom_tag_start
	 */
	public void customFinished(Builder builder, ObjectG child, string tagname, void* data);
	
	/**
	 * Called when the builder finishes the parsing of a
	 * GtkBuilder UI definition.
	 * Note that this will be called once for each time
	 * gtk_builder_add_from_file() or gtk_builder_add_from_string()
	 * is called on a builder.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 */
	public void parserFinished(Builder builder);
	
	/**
	 * Get the internal child called childname of the buildable object.
	 * Since 2.12
	 * Params:
	 * builder =  a GtkBuilder
	 * childname =  name of child
	 * Returns: the internal child of the buildable object
	 */
	public ObjectG getInternalChild(Builder builder, string childname);
}
