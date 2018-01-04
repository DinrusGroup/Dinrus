module gtkD.glib.Checksum;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * GLib provides a generic API for computing checksums (or "digests") for a
 * sequence of arbitrary bytes, using various hashing algorithms like MD5,
 * SHA-1 and SHA-256. Checksums are commonly used in various environments and
 * specifications.
 * GLib supports incremental checksums using the GChecksum data structure, by
 * calling g_checksum_update() as long as there's data available and then using
 * g_checksum_get_string() or g_checksum_get_digest() to compute the checksum
 * and return it either as a string in hexadecimal form, or as a raw sequence
 * of bytes. To compute the checksum for binary blobs and NUL-terminated strings
 * in one go, use the convenience functions g_compute_checksum_for_data() and
 * g_compute_checksum_for_string(), respectively.
 * Support for checksums has been added in GLib 2.16
 */
public class Checksum
{
	
	/** the main Gtk struct */
	protected GChecksum* gChecksum;
	
	
	public GChecksum* getChecksumStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GChecksum* gChecksum);
	
	/**
	 */
	
	/**
	 * Gets the length in bytes of digests of type checksum_type
	 * Since 2.16
	 * Params:
	 * checksumType =  a GChecksumType
	 * Returns: the checksum length, or -1 if checksum_type isnot supported.
	 */
	public static int typeGetLength(GChecksumType checksumType);
	
	/**
	 * Creates a new GChecksum, using the checksum algorithm checksum_type.
	 * If the checksum_type is not known, NULL is returned.
	 * A GChecksum can be used to compute the checksum, or digest, of an
	 * arbitrary binary blob, using different hashing algorithms.
	 * A GChecksum works by feeding a binary blob through g_checksum_update()
	 * until there is data to be checked; the digest can then be extracted
	 * using g_checksum_get_string(), which will return the checksum as a
	 * hexadecimal string; or g_checksum_get_digest(), which will return a
	 * vector of raw bytes. Once either g_checksum_get_string() or
	 * g_checksum_get_digest() have been called on a GChecksum, the checksum
	 * will be closed and it won't be possible to call g_checksum_update()
	 * on it anymore.
	 * Since 2.16
	 * Params:
	 * checksumType =  the desired type of checksum
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GChecksumType checksumType);
	
	/**
	 * Copies a GChecksum. If checksum has been closed, by calling
	 * g_checksum_get_string() or g_checksum_get_digest(), the copied
	 * checksum will be closed as well.
	 * Since 2.16
	 * Returns: the copy of the passed GChecksum. Use g_checksum_free() when finished using it.
	 */
	public Checksum copy();
	
	/**
	 * Frees the memory allocated for checksum.
	 * Since 2.16
	 */
	public void free();
	
	/**
	 * Resets the state of the checksum back to its initial state.
	 * Since 2.18
	 */
	public void reset();
	
	/**
	 * Feeds data into an existing GChecksum. The checksum must still be
	 * open, that is g_checksum_get_string() or g_checksum_get_digest() must
	 * not have been called on checksum.
	 * Since 2.16
	 * Params:
	 * data =  buffer used to compute the checksum
	 * length =  size of the buffer, or -1 if it is a null-terminated string.
	 */
	public void update(char* data, int length);
	
	/**
	 * Gets the digest as an hexadecimal string.
	 * Once this function has been called the GChecksum can no longer be
	 * updated with g_checksum_update().
	 * The hexadecimal characters will be lower case.
	 * Since 2.16
	 * Returns: the hexadecimal representation of the checksum. The returned string is owned by the checksum and should not be modified or freed.
	 */
	public string getString();
	
	/**
	 * Gets the digest from checksum as a raw binary vector and places it
	 * into buffer. The size of the digest depends on the type of checksum.
	 * Once this function has been called, the GChecksum is closed and can
	 * no longer be updated with g_checksum_update().
	 * Since 2.16
	 * Params:
	 * buffer =  output buffer
	 * digestLen =  an inout parameter. The caller initializes it to the size of buffer.
	 *  After the call it contains the length of the digest.
	 */
	public void getDigest(ubyte* buffer, uint* digestLen);
	
	/**
	 * Computes the checksum for a binary data of length. This is a
	 * convenience wrapper for g_checksum_new(), g_checksum_get_string()
	 * and g_checksum_free().
	 * The hexadecimal string returned will be in lower case.
	 * Since 2.16
	 * Params:
	 * checksumType =  a GChecksumType
	 * data =  binary blob to compute the digest of
	 * length =  length of data
	 * Returns: the digest of the binary data as a string in hexadecimal. The returned string should be freed with g_free() when done using it.
	 */
	public static string gComputeChecksumForData(GChecksumType checksumType, char* data, uint length);
	
	/**
	 * Computes the checksum of a string.
	 * The hexadecimal string returned will be in lower case.
	 * Since 2.16
	 * Params:
	 * checksumType =  a GChecksumType
	 * str =  the string to compute the checksum of
	 * length =  the length of the string, or -1 if the string is null-terminated.
	 * Returns: the checksum as a hexadecimal string. The returned string should be freed with g_free() when done using it.
	 */
	public static string gComputeChecksumForString(GChecksumType checksumType, string str, int length);
}
