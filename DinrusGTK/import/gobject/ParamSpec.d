
module gtkD.gobject.ParamSpec;

public  import gtkD.gtkc.gobjecttypes;

private import gtkD.gtkc.gobject;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.Value;
private import gtkD.glib.ListG;




/**
 * Description
 * GParamSpec is an object structure that encapsulates the metadata
 * required to specify parameters, such as e.g. GObject properties.
 * Parameter names need to start with a letter (a-z or A-Z). Subsequent
 * characters can be letters, numbers or a '-'.
 * All other characters are replaced by a '-' during construction.
 * The result of this replacement is called the canonical name of the
 * parameter.
 */
public class ParamSpec
{

	/** the main Gtk struct */
	protected GParamSpec* gParamSpec;


	public GParamSpec* getParamSpecStruct();


	/** the main Gtk struct as a void* */
	protected void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GParamSpec* gParamSpec);

	/**
	 */

	/**
	 * Increments the reference count of pspec.
	 * Returns: the GParamSpec that was passed into this function
	 */
	public ParamSpec doref();

	/**
	 * Decrements the reference count of a pspec.
	 */
	public void unref();

	/**
	 * The initial reference count of a newly created GParamSpec is 1,
	 * even though no one has explicitly called g_param_spec_ref() on it
	 * yet. So the initial reference count is flagged as "floating", until
	 * someone calls g_param_spec_ref (pspec); g_param_spec_sink
	 * (pspec); in sequence on it, taking over the initial
	 * reference count (thus ending up with a pspec that has a reference
	 * count of 1 still, but is not flagged "floating" anymore).
	 */
	public void sink();

	/**
	 * Convenience function to ref and sink a GParamSpec.
	 * Since 2.10
	 * Returns: the GParamSpec that was passed into this function
	 */
	public ParamSpec refSink();

	/**
	 * Sets value to its default value as specified in pspec.
	 * Params:
	 * value =  a GValue of correct type for pspec
	 */
	public void gParamValueSetDefault(Value value);

	/**
	 * Checks whether value contains the default value as specified in pspec.
	 * Params:
	 * value =  a GValue of correct type for pspec
	 * Returns: whether value contains the canonical default for this pspec
	 */
	public int gParamValueDefaults(Value value);

	/**
	 * Ensures that the contents of value comply with the specifications
	 * set out by pspec. For example, a GParamSpecInt might require
	 * that integers stored in value may not be smaller than -42 and not be
	 * greater than +42. If value contains an integer outside of this range,
	 * it is modified accordingly, so the resulting value will fit into the
	 * range -42 .. +42.
	 * Params:
	 * value =  a GValue of correct type for pspec
	 * Returns: whether modifying value was necessary to ensure validity
	 */
	public int gParamValueValidate(Value value);

	/**
	 * Transforms src_value into dest_value if possible, and then
	 * validates dest_value, in order for it to conform to pspec. If
	 * strict_validation is TRUE this function will only succeed if the
	 * transformed dest_value complied to pspec without modifications.
	 * See also g_value_type_transformable(), g_value_transform() and
	 * g_param_value_validate().
	 * Params:
	 * srcValue =  souce GValue
	 * destValue =  destination GValue of correct type for pspec
	 * strictValidation =  TRUE requires dest_value to conform to pspec
	 * without modifications
	 * Returns: TRUE if transformation and validation were successful, FALSE otherwise and dest_value is left untouched.
	 */
	public int gParamValueConvert(Value srcValue, Value destValue, int strictValidation);

	/**
	 * Compares value1 with value2 according to pspec, and return -1, 0 or +1,
	 * if value1 is found to be less than, equal to or greater than value2,
	 * respectively.
	 * Params:
	 * value1 =  a GValue of correct type for pspec
	 * value2 =  a GValue of correct type for pspec
	 * Returns: -1, 0 or +1, for a less than, equal to or greater than result
	 */
	public int gParamValuesCmp(Value value1, Value value2);

	/**
	 * Get the name of a GParamSpec.
	 * Returns: the name of pspec.
	 */
	public string getName();

	/**
	 * Get the nickname of a GParamSpec.
	 * Returns: the nickname of pspec.
	 */
	public string getNick();

	/**
	 * Get the short description of a GParamSpec.
	 * Returns: the short description of pspec.
	 */
	public string getBlurb();

	/**
	 * Gets back user data pointers stored via g_param_spec_set_qdata().
	 * Params:
	 * quark =  a GQuark, naming the user data pointer
	 * Returns: the user data pointer set, or NULL
	 */
	public void* getQdata(GQuark quark);

	/**
	 * Sets an opaque, named pointer on a GParamSpec. The name is
	 * specified through a GQuark (retrieved e.g. via
	 * g_quark_from_static_string()), and the pointer can be gotten back
	 * from the pspec with g_param_spec_get_qdata(). Setting a
	 * previously set user data pointer, overrides (frees) the old pointer
	 * set, using NULL as pointer essentially removes the data stored.
	 * Params:
	 * quark =  a GQuark, naming the user data pointer
	 * data =  an opaque user data pointer
	 */
	public void setQdata(GQuark quark, void* data);

	/**
	 * This function works like g_param_spec_set_qdata(), but in addition,
	 * a void (*destroy) (gpointer) function may be
	 * specified which is called with data as argument when the pspec is
	 * finalized, or the data is being overwritten by a call to
	 * g_param_spec_set_qdata() with the same quark.
	 * Params:
	 * quark =  a GQuark, naming the user data pointer
	 * data =  an opaque user data pointer
	 * destroy =  function to invoke with data as argument, when data needs to
	 *  be freed
	 */
	public void setQdataFull(GQuark quark, void* data, GDestroyNotify destroy);

	/**
	 * Gets back user data pointers stored via g_param_spec_set_qdata()
	 * and removes the data from pspec without invoking its destroy()
	 * function (if any was set). Usually, calling this function is only
	 * required to update user data pointers with a destroy notifier.
	 * Params:
	 * quark =  a GQuark, naming the user data pointer
	 * Returns: the user data pointer set, or NULL
	 */
	public void* stealQdata(GQuark quark);

	/**
	 * If the paramspec redirects operations to another paramspec,
	 * returns that paramspec. Redirect is used typically for
	 * providing a new implementation of a property in a derived
	 * type while preserving all the properties from the parent
	 * type. Redirection is established by creating a property
	 * of type GParamSpecOverride. See g_object_class_override_property()
	 * for an example of the use of this capability.
	 * Since 2.4
	 * Returns: paramspec to which requests on this paramspec should be redirected, or NULL if none.
	 */
	public ParamSpec getRedirectTarget();

	/**
	 * Creates a new GParamSpec instance.
	 * A property name consists of segments consisting of ASCII letters and
	 * digits, separated by either the '-' or '_' character. The first
	 * character of a property name must be a letter. Names which violate these
	 * rules lead to undefined behaviour.
	 * When creating and looking up a GParamSpec, either separator can be
	 * used, but they cannot be mixed. Using '-' is considerably more
	 * efficient and in fact required when using property names as detail
	 * strings for signals.
	 * Beyond the name, GParamSpecs have two more descriptive
	 * strings associated with them, the nick, which should be suitable
	 * for use as a label for the property in a property editor, and the
	 * blurb, which should be a somewhat longer description, suitable for
	 * e.g. a tooltip. The nick and blurb should ideally be localized.
	 * Params:
	 * paramType =  the GType for the property; must be derived from G_TYPE_PARAM
	 * name =  the canonical name of the property
	 * nick =  the nickname of the property
	 * blurb =  a short description of the property
	 * flags =  a combination of GParamFlags
	 * Returns: a newly allocated GParamSpec instance
	 */
	public static void* internal(GType paramType, string name, string nick, string blurb, GParamFlags flags);

	/**
	 * Registers name as the name of a new static type derived from
	 * G_TYPE_PARAM. The type system uses the information contained in
	 * the GParamSpecTypeInfo structure pointed to by info to manage the
	 * GParamSpec type and its instances.
	 * Params:
	 * name =  0-terminated string used as the name of the new GParamSpec type.
	 * pspecInfo =  The GParamSpecTypeInfo for this GParamSpec type.
	 * Returns: The new type identifier.
	 */
	public static GType gParamTypeRegisterStatic(string name, GParamSpecTypeInfo* pspecInfo);
}
