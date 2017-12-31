module gtkD.gio.FileInfo;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.TimeVal;
private import gtkD.gobject.ObjectG;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gio.FileAttributeMatcher;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Functionality for manipulating basic metadata for files. GFileInfo
 * implements methods for getting information that all files should
 * contain, and allows for manipulation of extended attributes.
 * See GFileAttribute for more
 * information on how GIO handles file attributes.
 * To obtain a GFileInfo for a GFile, use g_file_query_info() (or its
 * async variant). To obtain a GFileInfo for a file input or output
 * stream, use g_file_input_stream_query_info() or
 * g_file_output_stream_query_info() (or their async variants).
 * To change the actual attributes of a file, you should then set the
 * attribute in the GFileInfo and call g_file_set_attributes_from_info()
 * or g_file_set_attributes_async() on a GFile.
 * However, not all attributes can be changed in the file. For instance,
 * the actual size of a file cannot be changed via g_file_info_set_size().
 * You may call g_file_query_settable_attributes() and
 * g_file_query_writable_namespaces() to discover the settable attributes
 * of a particular file at runtime.
 * GFileAttributeMatcher allows for searching through a GFileInfo for
 * attributes.
 */
public class FileInfo : ObjectG
{
	
	/** the main Gtk struct */
	protected GFileInfo* gFileInfo;
	
	
	public GFileInfo* getFileInfoStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFileInfo* gFileInfo);
	
	/**
	 */
	
	/**
	 * Creates a new file info structure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Duplicates a file info structure.
	 * Returns: a duplicate GFileInfo of other.
	 */
	public FileInfo dup();
	
	/**
	 * Copies all of the GFileAttributes from src_info to dest_info.
	 * Params:
	 * destInfo =  destination to copy attributes to.
	 */
	public void copyInto(FileInfo destInfo);
	
	/**
	 * Checks if a file info structure has an attribute named attribute.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: TRUE if Ginfo has an attribute named attribute,  FALSE otherwise.
	 */
	public int hasAttribute(string attribute);
	
	/**
	 * Checks if a file info structure has an attribute in the
	 * specified name_space.
	 * Since 2.22
	 * Params:
	 * nameSpace =  a file attribute namespace.
	 * Returns: TRUE if Ginfo has an attribute in name_space, FALSE otherwise.
	 */
	public int hasNamespace(string nameSpace);
	
	/**
	 * Lists the file info structure's attributes.
	 * Params:
	 * nameSpace =  a file attribute key's namespace.
	 * Returns: a null-terminated array of strings of all of the possible attribute types for the given name_space, or NULL on error.
	 */
	public string[] listAttributes(string nameSpace);
	
	/**
	 * Gets the attribute type for an attribute key.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: a GFileAttributeType for the given attribute, or G_FILE_ATTRIBUTE_TYPE_INVALID if the key is not set.
	 */
	public GFileAttributeType getAttributeType(string attribute);
	
	/**
	 * Removes all cases of attribute from info if it exists.
	 * Params:
	 * attribute =  a file attribute key.
	 */
	public void removeAttribute(string attribute);

	/**
	 * Gets the value of a attribute, formated as a string.
	 * This escapes things as needed to make the string valid
	 * utf8.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: a UTF-8 string associated with the given attribute. When you're done with the string it must be freed with g_free().
	 */
	public string getAttributeAsString(string attribute);
	
	/**
	 * Gets the attribute type, value and status for an attribute key.
	 * Params:
	 * attribute =  a file attribute key
	 * type =  return location for the attribute type, or NULL
	 * valuePp =  return location for the attribute value, or NULL
	 * status =  return location for the attribute status, or NULL
	 * Returns: TRUE if info has an attribute named attribute,  FALSE otherwise.
	 */
	public int getAttributeData(string attribute, out GFileAttributeType type, out void* valuePp, out GFileAttributeStatus status);
	
	/**
	 * Gets the attribute status for an attribute key.
	 * Params:
	 * attribute =  a file attribute key
	 * Returns: a GFileAttributeStatus for the given attribute, or  G_FILE_ATTRIBUTE_STATUS_UNSET if the key is invalid.
	 */
	public GFileAttributeStatus getAttributeStatus(string attribute);
	
	/**
	 * Gets the value of a string attribute. If the attribute does
	 * not contain a string, NULL will be returned.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: the contents of the attribute value as a string, or NULL otherwise.
	 */
	public string getAttributeString(string attribute);
	
	/**
	 * Gets the value of a stringv attribute. If the attribute does
	 * not contain a stringv, NULL will be returned.
	 * Since 2.22
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: the contents of the attribute value as a stringv, orNULL otherwise. Do not free.
	 */
	public string[] getAttributeStringv(string attribute);
	
	/**
	 * Gets the value of a byte string attribute. If the attribute does
	 * not contain a byte string, NULL will be returned.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: the contents of the attribute value as a byte string, or NULL otherwise.
	 */
	public string getAttributeByteString(string attribute);
	
	/**
	 * Gets the value of a boolean attribute. If the attribute does not
	 * contain a boolean value, FALSE will be returned.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: the boolean value contained within the attribute.
	 */
	public int getAttributeBoolean(string attribute);
	
	/**
	 * Gets an unsigned 32-bit integer contained within the attribute. If the
	 * attribute does not contain an unsigned 32-bit integer, or is invalid,
	 * 0 will be returned.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: an unsigned 32-bit integer from the attribute.
	 */
	public uint getAttributeUint32(string attribute);
	
	/**
	 * Gets a signed 32-bit integer contained within the attribute. If the
	 * attribute does not contain a signed 32-bit integer, or is invalid,
	 * 0 will be returned.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: a signed 32-bit integer from the attribute.
	 */
	public int getAttributeInt32(string attribute);
	
	/**
	 * Gets a unsigned 64-bit integer contained within the attribute. If the
	 * attribute does not contain an unsigned 64-bit integer, or is invalid,
	 * 0 will be returned.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: a unsigned 64-bit integer from the attribute.
	 */
	public ulong getAttributeUint64(string attribute);
	
	/**
	 * Gets a signed 64-bit integer contained within the attribute. If the
	 * attribute does not contain an signed 64-bit integer, or is invalid,
	 * 0 will be returned.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: a signed 64-bit integer from the attribute.
	 */
	public long getAttributeInt64(string attribute);
	
	/**
	 * Gets the value of a GObject attribute. If the attribute does
	 * not contain a GObject, NULL will be returned.
	 * Params:
	 * attribute =  a file attribute key.
	 * Returns: a GObject associated with the given attribute, orNULL otherwise.
	 */
	public ObjectG getAttributeObject(string attribute);
	
	/**
	 * Sets the attribute to contain the given value, if possible.
	 * Params:
	 * attribute =  a file attribute key.
	 * type =  a GFileAttributeType
	 * valueP =  pointer to the value
	 */
	public void setAttribute(string attribute, GFileAttributeType type, void* valueP);
	
	/**
	 * Sets the attribute status for an attribute key. This is only
	 * needed by external code that implement g_file_set_attributes_from_info()
	 * or similar functions.
	 * The attribute must exist in info for this to work. Otherwise FALSE
	 * is returned and info is unchanged.
	 * Since 2.22
	 * Params:
	 * attribute =  a file attribute key
	 * status =  a GFileAttributeStatus
	 * Returns: TRUE if the status was changed, FALSE if the key was not set.
	 */
	public int setAttributeStatus(string attribute, GFileAttributeStatus status);
	
	/**
	 * Sets the attribute to contain the given attr_value,
	 * if possible.
	 * Params:
	 * attribute =  a file attribute key.
	 * attrValue =  a string.
	 */
	public void setAttributeString(string attribute, string attrValue);
	
	/**
	 * Sets the attribute to contain the given attr_value,
	 * if possible.
	 * Sinze: 2.22
	 * Params:
	 * attribute =  a file attribute key.
	 * attrValue =  a NULL terminated string array
	 */
	public void setAttributeStringv(string attribute, string[] attrValue);
	
	/**
	 * Sets the attribute to contain the given attr_value,
	 * if possible.
	 * Params:
	 * attribute =  a file attribute key.
	 * attrValue =  a byte string.
	 */
	public void setAttributeByteString(string attribute, string attrValue);
	
	/**
	 * Sets the attribute to contain the given attr_value,
	 * if possible.
	 * Params:
	 * attribute =  a file attribute key.
	 * attrValue =  a boolean value.
	 */
	public void setAttributeBoolean(string attribute, int attrValue);
	
	/**
	 * Sets the attribute to contain the given attr_value,
	 * if possible.
	 * Params:
	 * attribute =  a file attribute key.
	 * attrValue =  an unsigned 32-bit integer.
	 */
	public void setAttributeUint32(string attribute, uint attrValue);
	
	/**
	 * Sets the attribute to contain the given attr_value,
	 * if possible.
	 * Params:
	 * attribute =  a file attribute key.
	 * attrValue =  a signed 32-bit integer
	 */
	public void setAttributeInt32(string attribute, int attrValue);
	
	/**
	 * Sets the attribute to contain the given attr_value,
	 * if possible.
	 * Params:
	 * attribute =  a file attribute key.
	 * attrValue =  an unsigned 64-bit integer.
	 */
	public void setAttributeUint64(string attribute, ulong attrValue);
	
	/**
	 * Sets the attribute to contain the given attr_value,
	 * if possible.
	 * Params:
	 * attribute =  attribute name to set.
	 * attrValue =  int64 value to set attribute to.
	 */
	public void setAttributeInt64(string attribute, long attrValue);
	
	/**
	 * Sets the attribute to contain the given attr_value,
	 * if possible.
	 * Params:
	 * attribute =  a file attribute key.
	 * attrValue =  a GObject.
	 */
	public void setAttributeObject(string attribute, ObjectG attrValue);
	
	/**
	 * Clears the status information from info.
	 */
	public void clearStatus();
	
	/**
	 * Gets a file's type (whether it is a regular file, symlink, etc).
	 * This is different from the file's content type, see g_file_info_get_content_type().
	 * Returns: a GFileType for the given file.
	 */
	public GFileType getFileType();
	
	/**
	 * Checks if a file is hidden.
	 * Returns: TRUE if the file is a hidden file, FALSE otherwise.
	 */
	public int getIsHidden();
	
	/**
	 * Checks if a file is a backup file.
	 * Returns: TRUE if file is a backup file, FALSE otherwise.
	 */
	public int getIsBackup();
	
	/**
	 * Checks if a file is a symlink.
	 * Returns: TRUE if the given info is a symlink.
	 */
	public int getIsSymlink();
	
	/**
	 * Gets the name for a file.
	 * Returns: a string containing the file name.
	 */
	public string getName();
	
	/**
	 * Gets a display name for a file.
	 * Returns: a string containing the display name.
	 */
	public string getDisplayName();
	
	/**
	 * Gets the edit name for a file.
	 * Returns: a string containing the edit name.
	 */
	public string getEditName();
	
	/**
	 * Gets the icon for a file.
	 * Returns: GIcon for the given info.
	 */
	public IconIF getIcon();
	
	/**
	 * Gets the file's content type.
	 * Returns: a string containing the file's content type.
	 */
	public string getContentType();
	
	/**
	 * Gets the file's size.
	 * Returns: a goffset containing the file's size.
	 */
	public long getSize();
	
	/**
	 * Gets the modification time of the current info and sets it
	 * in result.
	 * Params:
	 * result =  a GTimeVal.
	 */
	public void getModificationTime(TimeVal result);
	
	/**
	 * Gets the symlink target for a given GFileInfo.
	 * Returns: a string containing the symlink target.
	 */
	public string getSymlinkTarget();
	
	/**
	 * Gets the entity tag for a given
	 * GFileInfo. See G_FILE_ATTRIBUTE_ETAG_VALUE.
	 * Returns: a string containing the value of the "etag:value" attribute.
	 */
	public string getEtag();
	
	/**
	 * Gets the value of the sort_order attribute from the GFileInfo.
	 * See G_FILE_ATTRIBUTE_STANDARD_SORT_ORDER.
	 * Returns: a gint32 containing the value of the "standard::sort_order" attribute.
	 */
	public int getSortOrder();
	
	/**
	 * Sets mask on info to match specific attribute types.
	 * Params:
	 * mask =  a GFileAttributeMatcher.
	 */
	public void setAttributeMask(FileAttributeMatcher mask);
	
	/**
	 * Unsets a mask set by g_file_info_set_attribute_mask(), if one
	 * is set.
	 */
	public void unsetAttributeMask();
	
	/**
	 * Sets the file type in a GFileInfo to type.
	 * See G_FILE_ATTRIBUTE_STANDARD_TYPE.
	 * Params:
	 * type =  a GFileType.
	 */
	public void setFileType(GFileType type);
	
	/**
	 * Sets the "is_hidden" attribute in a GFileInfo according to is_symlink.
	 * See G_FILE_ATTRIBUTE_STANDARD_IS_HIDDEN.
	 * Params:
	 * isHidden =  a gboolean.
	 */
	public void setIsHidden(int isHidden);
	
	/**
	 * Sets the "is_symlink" attribute in a GFileInfo according to is_symlink.
	 * See G_FILE_ATTRIBUTE_STANDARD_IS_SYMLINK.
	 * Params:
	 * isSymlink =  a gboolean.
	 */
	public void setIsSymlink(int isSymlink);
	
	/**
	 * Sets the name attribute for the current GFileInfo.
	 * See G_FILE_ATTRIBUTE_STANDARD_NAME.
	 * Params:
	 * name =  a string containing a name.
	 */
	public void setName(string name);
	
	/**
	 * Sets the display name for the current GFileInfo.
	 * See G_FILE_ATTRIBUTE_STANDARD_DISPLAY_NAME.
	 * Params:
	 * displayName =  a string containing a display name.
	 */
	public void setDisplayName(string displayName);
	
	/**
	 * Sets the edit name for the current file.
	 * See G_FILE_ATTRIBUTE_STANDARD_EDIT_NAME.
	 * Params:
	 * editName =  a string containing an edit name.
	 */
	public void setEditName(string editName);
	
	/**
	 * Sets the icon for a given GFileInfo.
	 * See G_FILE_ATTRIBUTE_STANDARD_ICON.
	 * Params:
	 * icon =  a GIcon.
	 */
	public void setIcon(IconIF icon);
	
	/**
	 * Sets the content type attribute for a given GFileInfo.
	 * See G_FILE_ATTRIBUTE_STANDARD_CONTENT_TYPE.
	 * Params:
	 * contentType =  a content type. See GContentType.
	 */
	public void setContentType(string contentType);
	
	/**
	 * Sets the G_FILE_ATTRIBUTE_STANDARD_SIZE attribute in the file info
	 * to the given size.
	 * Params:
	 * size =  a goffset containing the file's size.
	 */
	public void setSize(long size);
	
	/**
	 * Sets the G_FILE_ATTRIBUTE_TIME_MODIFIED attribute in the file
	 * info to the given time value.
	 * Params:
	 * mtime =  a GTimeVal.
	 */
	public void setModificationTime(TimeVal mtime);
	
	/**
	 * Sets the G_FILE_ATTRIBUTE_STANDARD_SYMLINK_TARGET attribute in the file info
	 * to the given symlink target.
	 * Params:
	 * symlinkTarget =  a static string containing a path to a symlink target.
	 */
	public void setSymlinkTarget(string symlinkTarget);
	
	/**
	 * Sets the sort order attribute in the file info structure. See
	 * G_FILE_ATTRIBUTE_STANDARD_SORT_ORDER.
	 * Params:
	 * sortOrder =  a sort order integer.
	 */
	public void setSortOrder(int sortOrder);
}
