module gtkD.gobject.Value;

public  import gtkD.gtkc.gobjecttypes;

private import gtkD.gtkc.gobject;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.ParamSpec;
private import gtkD.gdk.Pixbuf;




/**
 * Description
 * The GValue structure is basically a variable container that consists
 * of a type identifier and a specific value of that type.
 * The type identifier within a GValue structure always determines the
 * type of the associated value.
 * To create a undefined GValue structure, simply create a zero-filled
 * GValue structure. To initialize the GValue, use the g_value_init()
 * function. A GValue cannot be used until it is initialized.
 * The basic type operations (such as freeing and copying) are determined
 * by the GTypeValueTable associated with the type ID stored in the GValue.
 * Other GValue operations (such as converting values between types) are
 * provided by this interface.
 * The code in the example program below demonstrates GValue's
 * features.
 * #include <glib-object.h>
 * static void
 * int2string (const GValue *src_value,
 *  GValue *dest_value)
 * {
	 *  if (g_value_get_int (src_value) == 42)
	 *  g_value_set_static_string (dest_value, "An important number");
	 *  else
	 *  g_value_set_static_string (dest_value, "What's that?");
 * }
 * int
 * main (int argc,
 *  char *argv[])
 * {
	 *  /+* GValues must start zero-filled +/
 *  GValue a = {0};
 *  GValue b = {0};
 *  const gchar *message;
 *  g_type_init ();
 *  /+* The GValue starts empty +/
 *  g_assert (!G_VALUE_HOLDS_STRING (a));
 *  /+* Put a string in it +/
 *  g_value_init (a, G_TYPE_STRING);
 *  g_assert (G_VALUE_HOLDS_STRING (a));
 *  g_value_set_static_string (a, "Hello, world!");
 *  g_printf ("%s\n", g_value_get_string (a));
 *  /+* Reset it to its pristine state +/
 *  g_value_unset (a);
 *  /+* It can then be reused for another type +/
 *  g_value_init (a, G_TYPE_INT);
 *  g_value_set_int (a, 42);
 *  /+* Attempt to transform it into a GValue of type STRING +/
 *  g_value_init (b, G_TYPE_STRING);
 *  /+* An INT is transformable to a STRING +/
 *  g_assert (g_value_type_transformable (G_TYPE_INT, G_TYPE_STRING));
 *  g_value_transform (a, b);
 *  g_printf ("%s\n", g_value_get_string (b));
 *  /+* Attempt to transform it again using a custom transform function +/
 *  g_value_register_transform_func (G_TYPE_INT, G_TYPE_STRING, int2string);
 *  g_value_transform (a, b);
 *  g_printf ("%s\n", g_value_get_string (b));
 *  return 0;
 * }
 */
public class Value
{
	
	/** the main Gtk struct */
	protected GValue* gValue;
	
	
	public GValue* getValueStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GValue* gValue);
	
	/** */
	public this();
	
	/** */
	this(Pixbuf pixbuf);
	
	/** */
	this(string value);
	
	/** */
	this(int value);
	
	/** */
	this(float value);
	
	/** */
	this(double value);
	
	/**
	 * Initializes value with the default value of type.
	 * Params:
	 *  value = A zero-filled (uninitialized) GValue structure.
	 *  g_type = Type the GValue should hold values of.
	 * Returns:
	 *  the GValue structure that has been passed in
	 */
	public Value init(GType gType);
	
	/**
	 * Clears the current value in value and resets it to the default value
	 * (as if the value had just been initialized).
	 * Params:
	 *  value = An initialized GValue structure.
	 * Returns:
	 *  the GValue structure that has been passed in
	 */
	public Value reset();
	
	
	
	/**
	 * Description
	 * GValue provides an abstract container structure which can be
	 * copied, transformed and compared while holding a value of any
	 * (derived) type, which is registered as a GType with a
	 * GTypeValueTable in its GTypeInfo structure. Parameter
	 * specifications for most value types can be created as GParamSpec
	 * derived instances, to implement e.g. GObject properties which
	 * operate on GValue containers.
	 * Parameter names need to start with a letter (a-z or A-Z). Subsequent
	 * characters can be letters, numbers or a '-'.
	 * All other characters are replaced by a '-' during construction.
	 */
	
	/**
	 * Copies the value of src_value into dest_value.
	 * Params:
	 * destValue =  An initialized GValue structure of the same type as src_value.
	 */
	public void copy(Value destValue);
	
	/**
	 * Clears the current value in value and "unsets" the type,
	 * this releases all resources associated with this GValue.
	 * An unset value is the same as an uninitialized (zero-filled)
	 * GValue structure.
	 */
	public void unset();
	
	/**
	 * Sets value from an instantiatable type via the
	 * value_table's collect_value() function.
	 */
	public void setInstance(void* instanc);
	
	/**
	 * Determines if value will fit inside the size of a pointer value.
	 * This is an internal function introduced mainly for C marshallers.
	 * Returns: TRUE if value will fit inside a pointer value.
	 */
	public int fitsPointer();
	
	/**
	 * Return the value contents as pointer. This function asserts that
	 * g_value_fits_pointer() returned TRUE for the passed in value.
	 * This is an internal function introduced mainly for C marshallers.
	 * Returns: TRUE if value will fit inside a pointer value.
	 */
	public void* peekPointer();
	
	/**
	 * Returns whether a GValue of type src_type can be copied into
	 * a GValue of type dest_type.
	 * Params:
	 * srcType =  source type to be copied.
	 * destType =  destination type for copying.
	 * Returns: TRUE if g_value_copy() is possible with src_type and dest_type.
	 */
	public static int typeCompatible(GType srcType, GType destType);
	
	/**
	 * Check whether g_value_transform() is able to transform values
	 * of type src_type into values of type dest_type.
	 * Params:
	 * srcType =  Source type.
	 * destType =  Target type.
	 * Returns: TRUE if the transformation is possible, FALSE otherwise.
	 */
	public static int typeTransformable(GType srcType, GType destType);
	
	/**
	 * Tries to cast the contents of src_value into a type appropriate
	 * to store in dest_value, e.g. to transform a G_TYPE_INT value
	 * into a G_TYPE_FLOAT value. Performing transformations between
	 * value types might incur precision lossage. Especially
	 * transformations into strings might reveal seemingly arbitrary
	 * results and shouldn't be relied upon for production code (such
	 * as rcfile value or object property serialization).
	 * Params:
	 * destValue =  Target value.
	 * Returns: Whether a transformation rule was found and could be applied. Upon failing transformations, dest_value is left untouched.
	 */
	public int transform(Value destValue);
	
	/**
	 * Registers a value transformation function for use in g_value_transform().
	 * A previously registered transformation function for src_type and dest_type
	 * will be replaced.
	 * Params:
	 * srcType =  Source type.
	 * destType =  Target type.
	 * transformFunc =  a function which transforms values of type src_type
	 *  into value of type dest_type
	 */
	public static void registerTransformFunc(GType srcType, GType destType, GValueTransform transformFunc);
	
	/**
	 * Return a newly allocated string, which describes the contents of a
	 * GValue. The main purpose of this function is to describe GValue
	 * contents for debugging output, the way in which the contents are
	 * described may change between different GLib versions.
	 * Returns: Newly allocated string.
	 */
	public string gStrdupValueContents();
	
	/**
	 * Creates a new GParamSpecBoolean instance specifying a G_TYPE_BOOLEAN
	 * property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecBoolean(string name, string nick, string blurb, int defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_BOOLEAN GValue to v_boolean.
	 * Params:
	 * vBoolean =  boolean value to be set
	 */
	public void setBoolean(int vBoolean);
	
	/**
	 * Get the contents of a G_TYPE_BOOLEAN GValue.
	 * Returns: boolean contents of value
	 */
	public int getBoolean();
	
	/**
	 * Creates a new GParamSpecChar instance specifying a G_TYPE_CHAR property.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecChar(string name, string nick, string blurb, byte minimum, byte maximum, byte defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_CHAR GValue to v_char.
	 * Params:
	 * vChar =  character value to be set
	 */
	public void setChar(char vChar);
	
	/**
	 * Get the contents of a G_TYPE_CHAR GValue.
	 * Returns: character contents of value
	 */
	public char getChar();
	
	/**
	 * Creates a new GParamSpecUChar instance specifying a G_TYPE_UCHAR property.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecUchar(string name, string nick, string blurb, ubyte minimum, ubyte maximum, ubyte defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_UCHAR GValue to v_uchar.
	 * Params:
	 * vUchar =  unsigned character value to be set
	 */
	public void setUchar(char vUchar);
	
	/**
	 * Get the contents of a G_TYPE_UCHAR GValue.
	 * Returns: unsigned character contents of value
	 */
	public char getUchar();
	
	/**
	 * Creates a new GParamSpecInt instance specifying a G_TYPE_INT property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecInt(string name, string nick, string blurb, int minimum, int maximum, int defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_INT GValue to v_int.
	 * Params:
	 * vInt =  integer value to be set
	 */
	public void setInt(int vInt);
	
	/**
	 * Get the contents of a G_TYPE_INT GValue.
	 * Returns: integer contents of value
	 */
	public int getInt();
	
	/**
	 * Creates a new GParamSpecUInt instance specifying a G_TYPE_UINT property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecUint(string name, string nick, string blurb, uint minimum, uint maximum, uint defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_UINT GValue to v_uint.
	 * Params:
	 * vUint =  unsigned integer value to be set
	 */
	public void setUint(uint vUint);
	
	/**
	 * Get the contents of a G_TYPE_UINT GValue.
	 * Returns: unsigned integer contents of value
	 */
	public uint getUint();
	
	/**
	 * Creates a new GParamSpecLong instance specifying a G_TYPE_LONG property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecLong(string name, string nick, string blurb, int minimum, int maximum, int defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_LONG GValue to v_long.
	 * Params:
	 * vLong =  long integer value to be set
	 */
	public void setLong(int vLong);
	
	/**
	 * Get the contents of a G_TYPE_LONG GValue.
	 * Returns: long integer contents of value
	 */
	public int getLong();
	
	/**
	 * Creates a new GParamSpecULong instance specifying a G_TYPE_ULONG
	 * property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecUlong(string name, string nick, string blurb, uint minimum, uint maximum, uint defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_ULONG GValue to v_ulong.
	 * Params:
	 * vUlong =  unsigned long integer value to be set
	 */
	public void setUlong(uint vUlong);
	
	/**
	 * Get the contents of a G_TYPE_ULONG GValue.
	 * Returns: unsigned long integer contents of value
	 */
	public uint getUlong();
	
	/**
	 * Creates a new GParamSpecInt64 instance specifying a G_TYPE_INT64 property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecInt64(string name, string nick, string blurb, long minimum, long maximum, long defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_INT64 GValue to v_int64.
	 * Params:
	 * vInt64 =  64bit integer value to be set
	 */
	public void setInt64(long vInt64);
	
	/**
	 * Get the contents of a G_TYPE_INT64 GValue.
	 * Returns: 64bit integer contents of value
	 */
	public long getInt64();
	
	/**
	 * Creates a new GParamSpecUInt64 instance specifying a G_TYPE_UINT64
	 * property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecUint64(string name, string nick, string blurb, ulong minimum, ulong maximum, ulong defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_UINT64 GValue to v_uint64.
	 * Params:
	 * vUint64 =  unsigned 64bit integer value to be set
	 */
	public void setUint64(ulong vUint64);
	
	/**
	 * Get the contents of a G_TYPE_UINT64 GValue.
	 * Returns: unsigned 64bit integer contents of value
	 */
	public ulong getUint64();
	
	/**
	 * Creates a new GParamSpecFloat instance specifying a G_TYPE_FLOAT property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecFloat(string name, string nick, string blurb, float minimum, float maximum, float defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_FLOAT GValue to v_float.
	 * Params:
	 * vFloat =  float value to be set
	 */
	public void setFloat(float vFloat);
	
	/**
	 * Get the contents of a G_TYPE_FLOAT GValue.
	 * Returns: float contents of value
	 */
	public float getFloat();
	
	/**
	 * Creates a new GParamSpecDouble instance specifying a G_TYPE_DOUBLE
	 * property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * minimum =  minimum value for the property specified
	 * maximum =  maximum value for the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecDouble(string name, string nick, string blurb, double minimum, double maximum, double defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_DOUBLE GValue to v_double.
	 * Params:
	 * vDouble =  double value to be set
	 */
	public void setDouble(double vDouble);
	
	/**
	 * Get the contents of a G_TYPE_DOUBLE GValue.
	 * Returns: double contents of value
	 */
	public double getDouble();
	
	/**
	 * Creates a new GParamSpecEnum instance specifying a G_TYPE_ENUM
	 * property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * enumType =  a GType derived from G_TYPE_ENUM
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecEnum(string name, string nick, string blurb, GType enumType, int defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_ENUM GValue to v_enum.
	 * Params:
	 * vEnum =  enum value to be set
	 */
	public void setEnum(int vEnum);
	
	/**
	 * Get the contents of a G_TYPE_ENUM GValue.
	 * Returns: enum contents of value
	 */
	public int getEnum();
	
	/**
	 * Creates a new GParamSpecFlags instance specifying a G_TYPE_FLAGS
	 * property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * flagsType =  a GType derived from G_TYPE_FLAGS
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecFlags(string name, string nick, string blurb, GType flagsType, uint defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_FLAGS GValue to v_flags.
	 * Params:
	 * vFlags =  flags value to be set
	 */
	public void setFlags(uint vFlags);
	
	/**
	 * Get the contents of a G_TYPE_FLAGS GValue.
	 * Returns: flags contents of value
	 */
	public uint getFlags();
	
	/**
	 * Creates a new GParamSpecString instance.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecString(string name, string nick, string blurb, string defaultValue, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_STRING GValue to v_string.
	 * Params:
	 * vString =  caller-owned string to be duplicated for the GValue
	 */
	public void setString(string vString);
	
	/**
	 * Set the contents of a G_TYPE_STRING GValue to v_string.
	 * The string is assumed to be static, and is thus not duplicated
	 * when setting the GValue.
	 * Params:
	 * vString =  static string to be set
	 */
	public void setStaticString(string vString);
	
	/**
	 * Sets the contents of a G_TYPE_STRING GValue to v_string.
	 * Since 2.4
	 * Params:
	 * vString =  string to take ownership of
	 */
	public void takeString(string vString);
	
	/**
	 * Warning
	 * g_value_set_string_take_ownership has been deprecated since version 2.4 and should not be used in newly-written code. Use g_value_take_string() instead.
	 * This is an internal function introduced mainly for C marshallers.
	 * Params:
	 * vString =  duplicated unowned string to be set
	 */
	public void setStringTakeOwnership(string vString);
	
	/**
	 * Get the contents of a G_TYPE_STRING GValue.
	 * Returns: string content of value
	 */
	public string getString();
	
	/**
	 * Get a copy the contents of a G_TYPE_STRING GValue.
	 * Returns: a newly allocated copy of the string content of value
	 */
	public string dupString();
	
	/**
	 * Creates a new GParamSpecParam instance specifying a G_TYPE_PARAM
	 * property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * paramType =  a GType derived from G_TYPE_PARAM
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecParam(string name, string nick, string blurb, GType paramType, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_PARAM GValue to param.
	 * Params:
	 * param =  the GParamSpec to be set
	 */
	public void setParam(ParamSpec param);
	
	/**
	 * Sets the contents of a G_TYPE_PARAM GValue to param and takes
	 * over the ownership of the callers reference to param; the caller
	 * doesn't have to unref it any more.
	 * Since 2.4
	 * Params:
	 * param =  the GParamSpec to be set
	 */
	public void takeParam(ParamSpec param);
	
	/**
	 * Warning
	 * g_value_set_param_take_ownership has been deprecated since version 2.4 and should not be used in newly-written code. Use g_value_take_param() instead.
	 * This is an internal function introduced mainly for C marshallers.
	 * Params:
	 * param =  the GParamSpec to be set
	 */
	public void setParamTakeOwnership(ParamSpec param);
	
	/**
	 * Get the contents of a G_TYPE_PARAM GValue.
	 * Returns: GParamSpec content of value
	 */
	public ParamSpec getParam();
	
	/**
	 * Get the contents of a G_TYPE_PARAM GValue, increasing its
	 * reference count.
	 * Returns: GParamSpec content of value, should be unreferenced when no longer needed.
	 */
	public ParamSpec dupParam();
	
	/**
	 * Creates a new GParamSpecBoxed instance specifying a G_TYPE_BOXED
	 * derived property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * boxedType =  G_TYPE_BOXED derived type of this property
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecBoxed(string name, string nick, string blurb, GType boxedType, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_BOXED derived GValue to v_boxed.
	 * Params:
	 * vBoxed =  boxed value to be set
	 */
	public void setBoxed(void* vBoxed);
	
	/**
	 * Set the contents of a G_TYPE_BOXED derived GValue to v_boxed.
	 * The boxed value is assumed to be static, and is thus not duplicated
	 * when setting the GValue.
	 * Params:
	 * vBoxed =  static boxed value to be set
	 */
	public void setStaticBoxed(void* vBoxed);
	
	/**
	 * Sets the contents of a G_TYPE_BOXED derived GValue to v_boxed
	 * and takes over the ownership of the callers reference to v_boxed;
	 * the caller doesn't have to unref it any more.
	 * Since 2.4
	 * Params:
	 * vBoxed =  duplicated unowned boxed value to be set
	 */
	public void takeBoxed(void* vBoxed);
	
	/**
	 * Warning
	 * g_value_set_boxed_take_ownership has been deprecated since version 2.4 and should not be used in newly-written code. Use g_value_take_boxed() instead.
	 * This is an internal function introduced mainly for C marshallers.
	 * Params:
	 * vBoxed =  duplicated unowned boxed value to be set
	 */
	public void setBoxedTakeOwnership(void* vBoxed);
	
	/**
	 * Get the contents of a G_TYPE_BOXED derived GValue.
	 * Returns: boxed contents of value
	 */
	public void* getBoxed();
	
	/**
	 * Get the contents of a G_TYPE_BOXED derived GValue. Upon getting,
	 * the boxed value is duplicated and needs to be later freed with
	 * g_boxed_free(), e.g. like: g_boxed_free (G_VALUE_TYPE (value),
	 * return_value);
	 * Returns: boxed contents of value
	 */
	public void* dupBoxed();
	
	/**
	 * Creates a new GParamSpecPoiner instance specifying a pointer property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecPointer(string name, string nick, string blurb, GParamFlags flags);
	
	/**
	 * Set the contents of a pointer GValue to v_pointer.
	 * Params:
	 * vPointer =  pointer value to be set
	 */
	public void setPointer(void* vPointer);
	
	/**
	 * Get the contents of a pointer GValue.
	 * Returns: pointer contents of value
	 */
	public void* getPointer();
	
	/**
	 * Creates a new GParamSpecBoxed instance specifying a G_TYPE_OBJECT
	 * derived property.
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * objectType =  G_TYPE_OBJECT derived type of this property
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecObject(string name, string nick, string blurb, GType objectType, GParamFlags flags);
	
	/**
	 * Set the contents of a G_TYPE_OBJECT derived GValue to v_object.
	 * g_value_set_object() increases the reference count of v_object
	 * (the GValue holds a reference to v_object). If you do not wish
	 * to increase the reference count of the object (i.e. you wish to
	 * pass your current reference to the GValue because you no longer
	 * need it), use g_value_take_object() instead.
	 * It is important that your GValue holds a reference to v_object (either its
	 * own, or one it has taken) to ensure that the object won't be destroyed while
	 * the GValue still exists).
	 * Params:
	 * vObject =  object value to be set
	 */
	public void setObject(void* vObject);
	
	/**
	 * Sets the contents of a G_TYPE_OBJECT derived GValue to v_object
	 * and takes over the ownership of the callers reference to v_object;
	 * the caller doesn't have to unref it any more (i.e. the reference
	 * count of the object is not increased).
	 * If you want the GValue to hold its own reference to v_object, use
	 * g_value_set_object() instead.
	 * Since 2.4
	 * Params:
	 * vObject =  object value to be set
	 */
	public void takeObject(void* vObject);
	
	/**
	 * Warning
	 * g_value_set_object_take_ownership has been deprecated since version 2.4 and should not be used in newly-written code. Use g_value_take_object() instead.
	 * This is an internal function introduced mainly for C marshallers.
	 * Params:
	 * vObject =  object value to be set
	 */
	public void setObjectTakeOwnership(void* vObject);
	
	/**
	 * Get the contents of a G_TYPE_OBJECT derived GValue.
	 * Returns: object contents of value
	 */
	public void* getObject();
	
	/**
	 * Get the contents of a G_TYPE_OBJECT derived GValue, increasing
	 * its reference count.
	 * Returns: object content of value, should be unreferenced when no longer needed.
	 */
	public void* dupObject();
	
	/**
	 * Creates a new GParamSpecUnichar instance specifying a G_TYPE_UINT
	 * property. GValue structures for this property can be accessed with
	 * g_value_set_uint() and g_value_get_uint().
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * defaultValue =  default value for the property specified
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecUnichar(string name, string nick, string blurb, gunichar defaultValue, GParamFlags flags);
	
	/**
	 * Creates a new GParamSpecValueArray instance specifying a
	 * G_TYPE_VALUE_ARRAY property. G_TYPE_VALUE_ARRAY is a
	 * G_TYPE_BOXED type, as such, GValue structures for this property
	 * can be accessed with g_value_set_boxed() and g_value_get_boxed().
	 * See g_param_spec_internal() for details on property names.
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * elementSpec =  a GParamSpec describing the elements contained in
	 *  arrays of this property, may be NULL
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecValueArray(string name, string nick, string blurb, ParamSpec elementSpec, GParamFlags flags);
	
	/**
	 * Creates a new property of type GParamSpecOverride. This is used
	 * to direct operations to another paramspec, and will not be directly
	 * useful unless you are implementing a new base type similar to GObject.
	 * Since 2.4
	 * Params:
	 * name =  the name of the property.
	 * overridden =  The property that is being overridden
	 * Returns: the newly created GParamSpec
	 */
	public static ParamSpec gParamSpecOverride(string name, ParamSpec overridden);
	
	/**
	 * Creates a new GParamSpecGType instance specifying a
	 * G_TYPE_GTYPE property.
	 * See g_param_spec_internal() for details on property names.
	 * Since 2.10
	 * Params:
	 * name =  canonical name of the property specified
	 * nick =  nick name for the property specified
	 * blurb =  description of the property specified
	 * isAType =  a GType whose subtypes are allowed as values
	 *  of the property (use G_TYPE_NONE for any type)
	 * flags =  flags for the property specified
	 * Returns: a newly created parameter specification
	 */
	public static ParamSpec gParamSpecGtype(string name, string nick, string blurb, GType isAType, GParamFlags flags);
	
	/**
	 * Get the contents of a G_TYPE_GTYPE GValue.
	 * Since 2.12
	 * Returns: the GType stored in value
	 */
	public GType getGtype();
	
	/**
	 * Set the contents of a G_TYPE_GTYPE GValue to v_gtype.
	 * Since 2.12
	 * Params:
	 * vGtype =  GType to be set
	 */
	public void setGtype(GType vGtype);
}
