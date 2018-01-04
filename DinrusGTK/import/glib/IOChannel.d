module gtkD.glib.IOChannel;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.StringG;
private import gtkD.glib.Source;
private import gtkD.glib.Str;




/**
 * Description
 * The GIOChannel data type aims to provide a portable method for using file
 * descriptors, pipes, and sockets, and integrating them into the
 * main event loop.
 * Currently full support is available on UNIX platforms, support for
 * Windows is only partially complete.
 * To create a new GIOChannel on UNIX systems use g_io_channel_unix_new().
 * This works for plain file descriptors, pipes and sockets.
 * Alternatively, a channel can be created for a file in a system independent
 * manner using g_io_channel_new_file().
 * Once a GIOChannel has been created, it can be used in a generic manner
 * with the functions g_io_channel_read_chars(), g_io_channel_write_chars(),
 * g_io_channel_seek_position(), and g_io_channel_shutdown().
 * To add a GIOChannel to the
 * main event loop
 * use g_io_add_watch() or g_io_add_watch_full(). Here you specify which events
 * you are interested in on the GIOChannel, and provide a function to be
 * called whenever these events occur.
 * GIOChannel instances are created with an initial reference count of 1.
 * g_io_channel_ref() and g_io_channel_unref() can be used to increment or
 * decrement the reference count respectively. When the reference count falls
 * to 0, the GIOChannel is freed. (Though it isn't closed automatically,
 * unless it was created using g_io_channel_new_from_file().)
 * Using g_io_add_watch() or g_io_add_watch_full() increments a channel's
 * reference count.
 * The new functions g_io_channel_read_chars(), g_io_channel_read_line(),
 * g_io_channel_read_line_string(), g_io_channel_read_to_end(),
 * g_io_channel_write_chars(), g_io_channel_seek_position(),
 * and g_io_channel_flush() should not be mixed with the
 * deprecated functions g_io_channel_read(), g_io_channel_write(),
 * and g_io_channel_seek() on the same channel.
 */
public class IOChannel
{
	
	/** the main Gtk struct */
	protected GIOChannel* gIOChannel;
	
	
	public GIOChannel* getIOChannelStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GIOChannel* gIOChannel);
	
	/**
	 * Reads a line, including the terminating character(s),
	 * from a GIOChannel into a newly-allocated string.
	 * str_return will contain allocated memory if the return
	 * is G_IO_STATUS_NORMAL.
	 * Params:
	 * strReturn =  The line read from the GIOChannel, including the
	 *  line terminator. This data should be freed with g_free()
	 *  when no longer needed. This is a nul-terminated string.
	 *  If a length of zero is returned, this will be NULL instead.
	 * terminatorPos =  location to store position of line terminator, or NULL
	 * Returns: the status of the operation.
	 * Throws: GException on failure.
	 */
	public GIOStatus readLine(out string strReturn, out uint terminatorPos);
	
	/**
	 * Reads all the remaining data from the file.
	 * Params:
	 * strReturn =  Location to store a pointer to a string holding
	 *  the remaining data in the GIOChannel. This data should
	 *  be freed with g_free() when no longer needed. This
	 *  data is terminated by an extra nul character, but there
	 *  may be other nuls in the intervening data.
	 * Returns: G_IO_STATUS_NORMAL on success.  This function never returns G_IO_STATUS_EOF.
	 * Throws: GException on failure.
	 */
	public GIOStatus readToEnd(out string strReturn);
	
	/**
	 */
	
	/**
	 * Creates a new GIOChannel given a file descriptor.
	 * On UNIX systems this works for plain files, pipes, and sockets.
	 * The returned GIOChannel has a reference count of 1.
	 * The default encoding for GIOChannel is UTF-8. If your application
	 * is reading output from a command using via pipe, you may need to
	 * set the encoding to the encoding of the current locale (see
	 * g_get_charset()) with the g_io_channel_set_encoding() function.
	 * If you want to read raw binary data without interpretation, then
	 * call the g_io_channel_set_encoding() function with NULL for the
	 * encoding argument.
	 * This function is available in GLib on Windows, too, but you should
	 * avoid using it on Windows. The domain of file descriptors and sockets
	 * overlap. There is no way for GLib to know which one you mean in case
	 * the argument you pass to this function happens to be both a valid file
	 * descriptor and socket. If that happens a warning is issued, and GLib
	 * assumes that it is the file descriptor you mean.
	 * Params:
	 * fd = a file descriptor.
	 * Returns:a new GIOChannel.
	 */
	public static IOChannel unixNew(int fd);
	
	/**
	 * Returns the file descriptor of the GIOChannel.
	 * On Windows this function returns the file descriptor or socket of the GIOChannel.
	 * Returns:the file descriptor of the GIOChannel.
	 */
	public int unixGetFd();
	
	/**
	 * Creates a new GIOChannel given a file descriptor on Windows.
	 * This works for file descriptors from the C runtime.
	 * This function works for file descriptors as returned by the open(),
	 * creat(), pipe() and fileno() calls in the Microsoft C runtime. In
	 * order to meaningfully use this function your code should use the same
	 * C runtime as GLib uses, which is msvcrt.dll. Note that in current
	 * Microsoft compilers it is near impossible to convince it to build code
	 * that would use msvcrt.dll. The last Microsoft compiler version that
	 * supported using msvcrt.dll as the C runtime was version 6. The GNU
	 * compiler and toolchain for Windows, also known as Mingw, fully
	 * supports msvcrt.dll.
	 * If you have created a GIOChannel for a file descriptor and started
	 * watching (polling) it, you shouldn't call read() on the file
	 * descriptor. This is because adding polling for a file descriptor is
	 * implemented in GLib on Windows by starting a thread that sits blocked
	 * in a read() from the file descriptor most of the time. All reads from
	 * the file descriptor should be done by this internal GLib thread. Your
	 * code should call only g_io_channel_read().
	 * This function is available only in GLib on Windows.
	 * Params:
	 * fd = a C library file descriptor.
	 * Returns:a new GIOChannel.
	 */
	public static IOChannel win32_NewFd(int fd);
	
	/**
	 * Creates a new GIOChannel given a socket on Windows.
	 * This function works for sockets created by Winsock.
	 * It's available only in GLib on Windows.
	 * Polling a GSource created to watch a channel for a socket
	 * puts the socket in non-blocking mode. This is a side-effect
	 * of the implementation and unavoidable.
	 * Params:
	 * socket = a Winsock socket
	 * Returns:a new GIOChannel
	 */
	public static IOChannel win32_NewSocket(int socket);
	
	/**
	 * Creates a new GIOChannel given a window handle on Windows.
	 * This function creates a GIOChannel that can be used to poll for
	 * Windows messages for the window in question.
	 * Params:
	 * hwnd = a window handle.
	 * Returns:a new GIOChannel.
	 */
	public static IOChannel win32_NewMessages(uint hwnd);
	
	/**
	 * Initializes a GIOChannel struct.
	 * This is called by each of the above functions when creating a
	 * GIOChannel, and so is not often needed by the application
	 * programmer (unless you are creating a new type of GIOChannel).
	 */
	public void init();
	
	/**
	 * Open a file filename as a GIOChannel using mode mode. This
	 * channel will be closed when the last reference to it is dropped,
	 * so there is no need to call g_io_channel_close() (though doing
	 * so will not cause problems, as long as no attempt is made to
	 * access the channel after it is closed).
	 * Params:
	 * filename =  A string containing the name of a file
	 * mode =  One of "r", "w", "a", "r+", "w+", "a+". These have
	 *  the same meaning as in fopen()
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string filename, string mode);
	
	/**
	 * Replacement for g_io_channel_read() with the new API.
	 * Params:
	 * buf =  a buffer to read data into
	 * count =  the size of the buffer. Note that the buffer may
	 *  not be complelely filled even if there is data
	 *  in the buffer if the remaining data is not a
	 *  complete character.
	 * bytesRead =  The number of bytes read. This may be zero even on
	 *  success if count < 6 and the channel's encoding is non-NULL.
	 *  This indicates that the next UTF-8 character is too wide for
	 *  the buffer.
	 * Returns: the status of the operation.
	 * Throws: GException on failure.
	 */
	public GIOStatus readChars(string buf, uint count, out uint bytesRead);
	
	/**
	 * Reads a Unicode character from channel.
	 * This function cannot be called on a channel with NULL encoding.
	 * Params:
	 * thechar =  a location to return a character
	 * Returns: a GIOStatus
	 * Throws: GException on failure.
	 */
	public GIOStatus readUnichar(out gunichar thechar);
	
	/**
	 * Reads a line from a GIOChannel, using a GString as a buffer.
	 * Params:
	 * buffer =  a GString into which the line will be written.
	 *  If buffer already contains data, the old data will
	 *  be overwritten.
	 * terminatorPos =  location to store position of line terminator, or NULL
	 * Returns: the status of the operation.
	 * Throws: GException on failure.
	 */
	public GIOStatus readLineString(StringG buffer, out uint terminatorPos);
	
	/**
	 * Replacement for g_io_channel_write() with the new API.
	 * On seekable channels with encodings other than NULL or UTF-8, generic
	 * mixing of reading and writing is not allowed. A call to g_io_channel_write_chars()
	 * may only be made on a channel from which data has been read in the
	 * cases described in the documentation for g_io_channel_set_encoding().
	 * Params:
	 * buf =  a buffer to write data from
	 * count =  the size of the buffer. If -1, the buffer
	 *  is taken to be a nul-terminated string.
	 * bytesWritten =  The number of bytes written. This can be nonzero
	 *  even if the return value is not G_IO_STATUS_NORMAL.
	 *  If the return value is G_IO_STATUS_NORMAL and the
	 *  channel is blocking, this will always be equal
	 *  to count if count >= 0.
	 * Returns: the status of the operation.
	 * Throws: GException on failure.
	 */
	public GIOStatus writeChars(string buf, int count, out uint bytesWritten);
	
	/**
	 * Writes a Unicode character to channel.
	 * This function cannot be called on a channel with NULL encoding.
	 * Params:
	 * thechar =  a character
	 * Returns: a GIOStatus
	 * Throws: GException on failure.
	 */
	public GIOStatus writeUnichar(gunichar thechar);
	
	/**
	 * Flushes the write buffer for the GIOChannel.
	 * Returns: the status of the operation: One of G_IO_STATUS_NORMAL, G_IO_STATUS_AGAIN, or G_IO_STATUS_ERROR.
	 * Throws: GException on failure.
	 */
	public GIOStatus flush();
	
	/**
	 * Replacement for g_io_channel_seek() with the new API.
	 * Params:
	 * offset =  The offset in bytes from the position specified by type
	 * type =  a GSeekType. The type G_SEEK_CUR is only allowed in those
	 *  cases where a call to g_io_channel_set_encoding()
	 *  is allowed. See the documentation for
	 *  g_io_channel_set_encoding() for details.
	 * Returns: the status of the operation.
	 * Throws: GException on failure.
	 */
	public GIOStatus seekPosition(long offset, GSeekType type);
	
	/**
	 * Close an IO channel. Any pending data to be written will be
	 * flushed if flush is TRUE. The channel will not be freed until the
	 * last reference is dropped using g_io_channel_unref().
	 * Params:
	 * flush =  if TRUE, flush pending
	 * Returns: the status of the operation.
	 * Throws: GException on failure.
	 */
	public GIOStatus shutdown(int flush);
	
	/**
	 * Converts an errno error number to a GIOChannelError.
	 * Params:
	 * en =  an errno error number, e.g. EINVAL
	 * Returns: a GIOChannelError error number, e.g.  G_IO_CHANNEL_ERROR_INVAL.
	 */
	public static GIOChannelError errorFromErrno(int en);
	
	/**
	 * Increments the reference count of a GIOChannel.
	 * Returns: the channel that was passed in (since 2.6)
	 */
	public IOChannel doref();
	
	/**
	 * Decrements the reference count of a GIOChannel.
	 */
	public void unref();
	
	/**
	 * Creates a GSource that's dispatched when condition is met for the
	 * given channel. For example, if condition is G_IO_IN, the source will
	 * be dispatched when there's data available for reading.
	 * g_io_add_watch() is a simpler interface to this same functionality, for
	 * the case where you want to add the source to the default main loop context
	 * at the default priority.
	 * On Windows, polling a GSource created to watch a channel for a socket
	 * puts the socket in non-blocking mode. This is a side-effect of the
	 * implementation and unavoidable.
	 * Params:
	 * condition =  conditions to watch for
	 * Returns: a new GSource
	 */
	public Source gIoCreateWatch(GIOCondition condition);
	
	/**
	 * Adds the GIOChannel into the default main loop context
	 * with the default priority.
	 * Params:
	 * condition =  the condition to watch for
	 * func =  the function to call when the condition is satisfied
	 * userData =  user data to pass to func
	 * Returns: the event source id
	 */
	public uint gIoAddWatch(GIOCondition condition, GIOFunc func, void* userData);
	
	/**
	 * Adds the GIOChannel into the default main loop context
	 * with the given priority.
	 * This internally creates a main loop source using g_io_create_watch()
	 * and attaches it to the main loop context with g_source_attach().
	 * You can do these steps manuallt if you need greater control.
	 * Params:
	 * priority =  the priority of the GIOChannel source
	 * condition =  the condition to watch for
	 * func =  the function to call when the condition is satisfied
	 * userData =  user data to pass to func
	 * notify =  the function to call when the source is removed
	 * Returns: the event source id
	 */
	public uint gIoAddWatchFull(int priority, GIOCondition condition, GIOFunc func, void* userData, GDestroyNotify notify);
	
	/**
	 * Gets the buffer size.
	 * Returns: the size of the buffer.
	 */
	public uint getBufferSize();
	
	/**
	 * Sets the buffer size.
	 * Params:
	 * size =  the size of the buffer, or 0 to let GLib pick a good size
	 */
	public void setBufferSize(uint size);
	
	/**
	 * This function returns a GIOCondition depending on whether there
	 * is data to be read/space to write data in the internal buffers in
	 * the GIOChannel. Only the flags G_IO_IN and G_IO_OUT may be set.
	 * Returns: A GIOCondition
	 */
	public GIOCondition getBufferCondition();
	
	/**
	 * Gets the current flags for a GIOChannel, including read-only
	 * flags such as G_IO_FLAG_IS_READABLE.
	 * The values of the flags G_IO_FLAG_IS_READABLE and G_IO_FLAG_IS_WRITEABLE
	 * are cached for internal use by the channel when it is created.
	 * If they should change at some later point (e.g. partial shutdown
	 * of a socket with the UNIX shutdown() function), the user
	 * should immediately call g_io_channel_get_flags() to update
	 * the internal values of these flags.
	 * Returns: the flags which are set on the channel
	 */
	public GIOFlags getFlags();
	
	/**
	 * Sets the (writeable) flags in channel to (flags  G_IO_CHANNEL_SET_MASK).
	 * Params:
	 * flags =  the flags to set on the IO channel
	 * Returns: the status of the operation.
	 * Throws: GException on failure.
	 */
	public GIOStatus setFlags(GIOFlags flags);
	
	/**
	 * This returns the string that GIOChannel uses to determine
	 * where in the file a line break occurs. A value of NULL
	 * indicates autodetection.
	 * Params:
	 * length =  a location to return the length of the line terminator
	 * Returns: The line termination string. This value is owned by GLib and must not be freed.
	 */
	public string getLineTerm(out int length);
	
	/**
	 * This sets the string that GIOChannel uses to determine
	 * where in the file a line break occurs.
	 * Params:
	 * lineTerm =  The line termination string. Use NULL for autodetect.
	 *  Autodetection breaks on "\n", "\r\n", "\r", "\0", and
	 *  the Unicode paragraph separator. Autodetection should
	 *  not be used for anything other than file-based channels.
	 * length =  The length of the termination string. If -1 is passed, the
	 *  string is assumed to be nul-terminated. This option allows
	 *  termination strings with embedded nuls.
	 */
	public void setLineTerm(string lineTerm, int length);
	
	/**
	 * Returns whether channel is buffered.
	 * Returns: TRUE if the channel is buffered.
	 */
	public int getBuffered();
	
	/**
	 * The buffering state can only be set if the channel's encoding
	 * is NULL. For any other encoding, the channel must be buffered.
	 * A buffered channel can only be set unbuffered if the channel's
	 * internal buffers have been flushed. Newly created channels or
	 * channels which have returned G_IO_STATUS_EOF
	 * not require such a flush. For write-only channels, a call to
	 * g_io_channel_flush() is sufficient. For all other channels,
	 * the buffers may be flushed by a call to g_io_channel_seek_position().
	 * This includes the possibility of seeking with seek type G_SEEK_CUR
	 * and an offset of zero. Note that this means that socket-based
	 * channels cannot be set unbuffered once they have had data
	 * read from them.
	 * On unbuffered channels, it is safe to mix read and write
	 * calls from the new and old APIs, if this is necessary for
	 * maintaining old code.
	 * The default state of the channel is buffered.
	 * Params:
	 * buffered =  whether to set the channel buffered or unbuffered
	 */
	public void setBuffered(int buffered);
	
	/**
	 * Gets the encoding for the input/output of the channel.
	 * The internal encoding is always UTF-8. The encoding NULL
	 * makes the channel safe for binary data.
	 * Returns: A string containing the encoding, this string is owned by GLib and must not be freed.
	 */
	public string getEncoding();
	
	/**
	 * Sets the encoding for the input/output of the channel.
	 * The internal encoding is always UTF-8. The default encoding
	 * for the external file is UTF-8.
	 * The encoding NULL is safe to use with binary data.
	 * The encoding can only be set if one of the following conditions
	 * Params:
	 * encoding =  the encoding type
	 * Returns: G_IO_STATUS_NORMAL if the encoding was successfully set.
	 * Throws: GException on failure.
	 */
	public GIOStatus setEncoding(string encoding);
	
	/**
	 * Returns whether the file/socket/whatever associated with channel
	 * will be closed when channel receives its final unref and is
	 * destroyed. The default value of this is TRUE for channels created
	 * by g_io_channel_new_file(), and FALSE for all other channels.
	 * Returns: Whether the channel will be closed on the final unref of the GIOChannel data structure.
	 */
	public int getCloseOnUnref();
	
	/**
	 * Setting this flag to TRUE for a channel you have already closed
	 * can cause problems.
	 * Params:
	 * doClose =  Whether to close the channel on the final unref of
	 *  the GIOChannel data structure. The default value of
	 *  this is TRUE for channels created by g_io_channel_new_file(),
	 *  and FALSE for all other channels.
	 */
	public void setCloseOnUnref(int doClose);
	
	/**
	 * Warning
	 * g_io_channel_read has been deprecated since version 2.2 and should not be used in newly-written code. Use g_io_channel_read_chars() instead.
	 * Reads data from a GIOChannel.
	 * Params:
	 * buf =  a buffer to read the data into (which should be at least
	 *  count bytes long)
	 * count =  the number of bytes to read from the GIOChannel
	 * bytesRead =  returns the number of bytes actually read
	 * Returns: G_IO_ERROR_NONE if the operation was successful.
	 */
	public GIOError read(string buf, uint count, out uint bytesRead);
	
	/**
	 * Warning
	 * g_io_channel_write has been deprecated since version 2.2 and should not be used in newly-written code. Use g_io_channel_write_chars() instead.
	 * Writes data to a GIOChannel.
	 * Params:
	 * buf =  the buffer containing the data to write
	 * count =  the number of bytes to write
	 * bytesWritten =  the number of bytes actually written
	 * Returns: G_IO_ERROR_NONE if the operation was successful.
	 */
	public GIOError write(string buf, uint count, out uint bytesWritten);
	
	/**
	 * Warning
	 * g_io_channel_seek has been deprecated since version 2.2 and should not be used in newly-written code. Use g_io_channel_seek_position() instead.
	 * Sets the current position in the GIOChannel, similar to the standard
	 * library function fseek().
	 * Params:
	 * offset =  an offset, in bytes, which is added to the position specified
	 *  by type
	 * type =  the position in the file, which can be G_SEEK_CUR (the current
	 *  position), G_SEEK_SET (the start of the file), or G_SEEK_END
	 *  (the end of the file)
	 * Returns: G_IO_ERROR_NONE if the operation was successful.
	 */
	public GIOError seek(long offset, GSeekType type);
	
	/**
	 * Warning
	 * g_io_channel_close has been deprecated since version 2.2 and should not be used in newly-written code. Use g_io_channel_shutdown() instead.
	 * Close an IO channel. Any pending data to be written will be
	 * flushed, ignoring errors. The channel will not be freed until the
	 * last reference is dropped using g_io_channel_unref().
	 */
	public void close();
}
