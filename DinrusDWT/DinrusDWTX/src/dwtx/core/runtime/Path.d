/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module dwtx.core.runtime.Path;

import tango.io.FilePath;
static import tango.io.Path;
import dwtx.core.runtime.IPath;
import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;

import tango.io.model.IFile;


static import tango.text.Text;
alias tango.text.Text.Text!(char) StringBuffer;

/**
 * The standard implementation of the <code>IPath</code> interface.
 * Paths are always maintained in canonicalized form.  That is, parent
 * references (i.e., <code>../../</code>) and duplicate separators are
 * resolved.  For example,
 * <pre>     new Path("/a/b").append("../foo/bar")</pre>
 * will yield the path
 * <pre>     /a/foo/bar</pre>
 * <p>
 * This class can be used without OSGi running.
 * </p><p>
 * This class is not intended to be subclassed by clients but
 * may be instantiated.
 * </p>
 * @see IPath
 * @noextend This class is not intended to be subclassed by clients.
 */
public class Path : IPath, Cloneable {
    /** masks for separator values */
    private static const int HAS_LEADING = 1;
    private static const int IS_UNC = 2;
    private static const int HAS_TRAILING = 4;

    private static const int ALL_SEPARATORS = HAS_LEADING | IS_UNC | HAS_TRAILING;

    /** Constant empty string value. */
    private static const String EMPTY_STRING = ""; //$NON-NLS-1$

    /** Constant value indicating no segments */
    private static const String[] NO_SEGMENTS = null;

    /** Constant value containing the empty path with no device. */
    public static const Path EMPTY;

    /** Mask for all bits that are involved in the hash code */
    private static const int HASH_MASK = ~HAS_TRAILING;

    /** Constant root path string (<code>"/"</code>). */
    private static const String ROOT_STRING = "/"; //$NON-NLS-1$

    /** Constant value containing the root path with no device. */
    public static const Path ROOT;

    /** Constant value indicating if the current platform is Windows */
    version(Windows){
        private static const bool WINDOWS = true;
    }
    else {
        private static const bool WINDOWS = false;
    }

    static this(){
        EMPTY = new Path(EMPTY_STRING);
        ROOT = new Path(ROOT_STRING);
    }

    /** The device id string. May be null if there is no device. */
    private String device = null;

    //Private implementation note: the segments and separators
    //arrays are never modified, so that they can be shared between
    //path instances

    /** The path segments */
    private String[] segments_;

    /** flags indicating separators (has leading, is UNC, has trailing) */
    private int separators;

    /**
     * Constructs a new path from the given string path.
     * The string path must represent a valid file system path
     * on the local file system.
     * The path is canonicalized and double slashes are removed
     * except at the beginning. (to handle UNC paths). All forward
     * slashes ('/') are treated as segment delimiters, and any
     * segment and device delimiters for the local file system are
     * also respected.
     *
     * @param pathString the portable string path
     * @see IPath#toPortableString()
     * @since 3.1
     */
    public static IPath fromOSString(String pathString) {
        return new Path(pathString);
    }

    /**
     * Constructs a new path from the given path string.
     * The path string must have been produced by a previous
     * call to <code>IPath.toPortableString</code>.
     *
     * @param pathString the portable path string
     * @see IPath#toPortableString()
     * @since 3.1
     */
    public static IPath fromPortableString(String pathString) {
        int firstMatch = pathString.indexOf(DEVICE_SEPARATOR) + 1;
        //no extra work required if no device characters
        if (firstMatch <= 0)
            return (new Path()).initialize(null, pathString);
        //if we find a single colon, then the path has a device
        String devicePart = null;
        int pathLength = pathString.length;
        if (firstMatch is pathLength || pathString.charAt(firstMatch) !is DEVICE_SEPARATOR) {
            devicePart = pathString.substring(0, firstMatch);
            pathString = pathString.substring(firstMatch, pathLength);
        }
        //optimize for no colon literals
        if (pathString.indexOf(DEVICE_SEPARATOR) is -1)
            return (new Path()).initialize(devicePart, pathString);
        //contract colon literals
        char[] chars = pathString/+.toCharArray()+/;
        int readOffset = 0, writeOffset = 0, length = chars.length;
        while (readOffset < length) {
            if (chars[readOffset] is DEVICE_SEPARATOR)
                if (++readOffset >= length)
                    break;
            chars[writeOffset++] = chars[readOffset++];
        }
        return (new Path()).initialize(devicePart, chars[ 0 .. writeOffset] );
    }

    /* (Intentionally not included in javadoc)
     * Private constructor.
     */
    private this() {
        // not allowed
    }

    /**
     * Constructs a new path from the given string path.
     * The string path must represent a valid file system path
     * on the local file system.
     * The path is canonicalized and double slashes are removed
     * except at the beginning. (to handle UNC paths). All forward
     * slashes ('/') are treated as segment delimiters, and any
     * segment and device delimiters for the local file system are
     * also respected (such as colon (':') and backslash ('\') on some file systems).
     *
     * @param fullPath the string path
     * @see #isValidPath(String)
     */
    public this(String fullPath) {
        String devicePart = null;
        if (WINDOWS) {
            //convert backslash to forward slash
            fullPath = fullPath.indexOf('\\') is -1 ? fullPath : fullPath.replace('\\', SEPARATOR);
            //extract device
            int i = fullPath.indexOf(DEVICE_SEPARATOR);
            if (i !is -1) {
                //remove leading slash from device part to handle output of URL.getFile()
                int start = fullPath.charAt(0) is SEPARATOR ? 1 : 0;
                devicePart = fullPath.substring(start, i + 1);
                fullPath = fullPath.substring(i + 1, fullPath.length);
            }
        }
        initialize(devicePart, fullPath);
    }

    /**
     * Constructs a new path from the given device id and string path.
     * The given string path must be valid.
     * The path is canonicalized and double slashes are removed except
     * at the beginning (to handle UNC paths). All forward
     * slashes ('/') are treated as segment delimiters, and any
     * segment delimiters for the local file system are
     * also respected (such as backslash ('\') on some file systems).
     *
     * @param device the device id
     * @param path the string path
     * @see #isValidPath(String)
     * @see #setDevice(String)
     */
    public this(String device, String path) {
        if (WINDOWS) {
            //convert backslash to forward slash
            path = path.indexOf('\\') is -1 ? path : path.replace('\\', SEPARATOR);
        }
        initialize(device, path);
    }

    /* (Intentionally not included in javadoc)
     * Private constructor.
     */
    private this(String device, String[] segments_, int _separators) {
        // no segment validations are done for performance reasons
        this.segments_ = segments_;
        this.device = device;
        //hash code is cached in all but the bottom three bits of the separators field
        this.separators = (computeHashCode() << 3) | (_separators & ALL_SEPARATORS);
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#addFileExtension
     */
    public IPath addFileExtension(String extension) {
        if (isRoot() || isEmpty() || hasTrailingSeparator())
            return this;
        int len = segments_.length;
        String[] newSegments = new String[len];
        System.arraycopy(segments_, 0, newSegments, 0, len - 1);
        newSegments[len - 1] = segments_[len - 1] ~ '.' ~ extension;
        return new Path(device, newSegments, separators);
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#addTrailingSeparator
     */
    public IPath addTrailingSeparator() {
        if (hasTrailingSeparator() || isRoot()) {
            return this;
        }
        //XXX workaround, see 1GIGQ9V
        if (isEmpty()) {
            return new Path(device, segments_, HAS_LEADING);
        }
        return new Path(device, segments_, separators | HAS_TRAILING);
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#append(IPath)
     */
    public IPath append(IPath tail) {
        //optimize some easy cases
        if (tail is null || tail.segmentCount() is 0)
            return this;
        //these call chains look expensive, but in most cases they are no-ops
        if (this.isEmpty())
            return tail.setDevice(device).makeRelative().makeUNC(isUNC());
        if (this.isRoot())
            return tail.setDevice(device).makeAbsolute().makeUNC(isUNC());

        //concatenate the two segment arrays
        int myLen = segments_.length;
        int tailLen = tail.segmentCount();
        String[] newSegments = new String[myLen + tailLen];
        System.arraycopy(segments_, 0, newSegments, 0, myLen);
        for (int i = 0; i < tailLen; i++) {
            newSegments[myLen + i] = tail.segment(i);
        }
        //use my leading separators and the tail's trailing separator
        Path result = new Path(device, newSegments, (separators & (HAS_LEADING | IS_UNC)) | (tail.hasTrailingSeparator() ? HAS_TRAILING : 0));
        String tailFirstSegment = newSegments[myLen];
        if (tailFirstSegment.equals("..") || tailFirstSegment.equals(".")) { //$NON-NLS-1$ //$NON-NLS-2$
            result.canonicalize();
        }
        return result;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#append(java.lang.String)
     */
    public IPath append(String tail) {
        //optimize addition of a single segment
        if (tail.indexOf(SEPARATOR) is -1 && tail.indexOf("\\") is -1 && tail.indexOf(DEVICE_SEPARATOR) is -1) { //$NON-NLS-1$
            int tailLength = tail.length;
            if (tailLength < 3) {
                //some special cases
                if (tailLength is 0 || ".".equals(tail)) { //$NON-NLS-1$
                    return this;
                }
                if ("..".equals(tail)) //$NON-NLS-1$
                    return removeLastSegments(1);
            }
            //just add the segment
            int myLen = segments_.length;
            String[] newSegments = new String[myLen + 1];
            System.arraycopy(segments_, 0, newSegments, 0, myLen);
            newSegments[myLen] = tail;
            return new Path(device, newSegments, separators & ~HAS_TRAILING);
        }
        //go with easy implementation
        return append(new Path(tail));
    }

    /**
     * Destructively converts this path to its canonical form.
     * <p>
     * In its canonical form, a path does not have any
     * "." segments, and parent references ("..") are collapsed
     * where possible.
     * </p>
     * @return true if the path was modified, and false otherwise.
     */
    private bool canonicalize() {
        //look for segments that need canonicalizing
        for (int i = 0, max = segments_.length; i < max; i++) {
            String segment = segments_[i];
            if (segment.charAt(0) is '.' && (segment.equals("..") || segment.equals("."))) { //$NON-NLS-1$ //$NON-NLS-2$
                //path needs to be canonicalized
                collapseParentReferences();
                //paths of length 0 have no trailing separator
                if (segments_.length is 0)
                    separators &= (HAS_LEADING | IS_UNC);
                //recompute hash because canonicalize affects hash
                separators = (separators & ALL_SEPARATORS) | (computeHashCode() << 3);
                return true;
            }
        }
        return false;
    }

    /* (Intentionally not included in javadoc)
     * Clones this object.
     */
    public Path clone() {
        return new Path(device, segments_, separators);
    }

    /**
     * Destructively removes all occurrences of ".." segments from this path.
     */
    private void collapseParentReferences() {
        int segmentCount = segments_.length;
        String[] stack = new String[segmentCount];
        int stackPointer = 0;
        for (int i = 0; i < segmentCount; i++) {
            String segment = segments_[i];
            if (segment.equals("..")) { //$NON-NLS-1$
                if (stackPointer is 0) {
                    // if the stack is empty we are going out of our scope
                    // so we need to accumulate segments.  But only if the original
                    // path is relative.  If it is absolute then we can't go any higher than
                    // root so simply toss the .. references.
                    if (!isAbsolute())
                        stack[stackPointer++] = segment; //stack push
                } else {
                    // if the top is '..' then we are accumulating segments so don't pop
                    if ("..".equals(stack[stackPointer - 1])) //$NON-NLS-1$
                        stack[stackPointer++] = ".."; //$NON-NLS-1$
                    else
                        stackPointer--;
                    //stack pop
                }
                //collapse current references
            } else if (!segment.equals(".") || segmentCount is 1) //$NON-NLS-1$
                stack[stackPointer++] = segment; //stack push
        }
        //if the number of segments hasn't changed, then no modification needed
        if (stackPointer is segmentCount)
            return;
        //build the new segment array backwards by popping the stack
        String[] newSegments = new String[stackPointer];
        System.arraycopy(stack, 0, newSegments, 0, stackPointer);
        this.segments_ = newSegments;
    }

    /**
     * Removes duplicate slashes from the given path, with the exception
     * of leading double slash which represents a UNC path.
     */
    private String collapseSlashes(String path) {
        int length = path.length;
        // if the path is only 0, 1 or 2 chars long then it could not possibly have illegal
        // duplicate slashes.
        if (length < 3)
            return path;
        // check for an occurrence of // in the path.  Start at index 1 to ensure we skip leading UNC //
        // If there are no // then there is nothing to collapse so just return.
        if (path.indexOf("//", 1) is -1) //$NON-NLS-1$
            return path;
        // We found an occurrence of // in the path so do the slow collapse.
        char[] result = new char[path.length];
        int count = 0;
        bool hasPrevious = false;
        char[] characters = path/+.toCharArray()+/;
        for (int index = 0; index < characters.length; index++) {
            char c = characters[index];
            if (c is SEPARATOR) {
                if (hasPrevious) {
                    // skip double slashes, except for beginning of UNC.
                    // note that a UNC path can't have a device.
                    if (device is null && index is 1) {
                        result[count] = c;
                        count++;
                    }
                } else {
                    hasPrevious = true;
                    result[count] = c;
                    count++;
                }
            } else {
                hasPrevious = false;
                result[count] = c;
                count++;
            }
        }
        return result[ 0 .. count];
    }

    /* (Intentionally not included in javadoc)
     * Computes the hash code for this object.
     */
    private int computeHashCode() {
        int hash = device.length is 0 ? 17 : dwt.dwthelper.utils.toHash(device);
        int segmentCount = segments_.length;
        for (int i = 0; i < segmentCount; i++) {
            //this function tends to given a fairly even distribution
            hash = hash * 37 + dwt.dwthelper.utils.toHash(segments_[i]);
        }
        return hash;
    }

    /* (Intentionally not included in javadoc)
     * Returns the size of the string that will be created by toString or toOSString.
     */
    private int computeLength() {
        int length = 0;
        if (device !is null)
            length += device.length;
        if ((separators & HAS_LEADING) !is 0)
            length++;
        if ((separators & IS_UNC) !is 0)
            length++;
        //add the segment lengths
        int max = segments_.length;
        if (max > 0) {
            for (int i = 0; i < max; i++) {
                length += segments_[i].length;
            }
            //add the separator lengths
            length += max - 1;
        }
        if ((separators & HAS_TRAILING) !is 0)
            length++;
        return length;
    }

    /* (Intentionally not included in javadoc)
     * Returns the number of segments in the given path
     */
    private int computeSegmentCount(String path) {
        int len = path.length;
        if (len is 0 || (len is 1 && path.charAt(0) is SEPARATOR)) {
            return 0;
        }
        int count = 1;
        int prev = -1;
        int i;
        while ((i = path.indexOf(SEPARATOR, prev + 1)) !is -1) {
            if (i !is prev + 1 && i !is len) {
                ++count;
            }
            prev = i;
        }
        if (path.charAt(len - 1) is SEPARATOR) {
            --count;
        }
        return count;
    }

    /**
     * Computes the segment array for the given canonicalized path.
     */
    private String[] computeSegments(String path) {
        // performance sensitive --- avoid creating garbage
        int segmentCount = computeSegmentCount(path);
        if (segmentCount is 0)
            return NO_SEGMENTS;
        String[] newSegments = new String[segmentCount];
        int len = path.length;
        // check for initial slash
        int firstPosition = (path.charAt(0) is SEPARATOR) ? 1 : 0;
        // check for UNC
        if (firstPosition is 1 && len > 1 && (path.charAt(1) is SEPARATOR))
            firstPosition = 2;
        int lastPosition = (path.charAt(len - 1) !is SEPARATOR) ? len - 1 : len - 2;
        // for non-empty paths, the number of segments is
        // the number of slashes plus 1, ignoring any leading
        // and trailing slashes
        int next = firstPosition;
        for (int i = 0; i < segmentCount; i++) {
            int start = next;
            int end = path.indexOf(SEPARATOR, next);
            if (end is -1) {
                newSegments[i] = path.substring(start, lastPosition + 1);
            } else {
                newSegments[i] = path.substring(start, end);
            }
            next = end + 1;
        }
        return newSegments;
    }

    /**
     * Returns the platform-neutral encoding of the given segment onto
     * the given string buffer. This escapes literal colon characters with double colons.
     */
    private void encodeSegment(String string, StringBuffer buf) {
        int len = string.length;
        for (int i = 0; i < len; i++) {
            char c = string.charAt(i);
            buf.append(c);
            if (c is DEVICE_SEPARATOR)
                buf.append(DEVICE_SEPARATOR);
        }
    }

    /* (Intentionally not included in javadoc)
     * Compares objects for equality.
     */
    public override int opEquals(Object obj) {
        if (this is obj)
            return true;
        if (!(cast(Path)obj))
            return false;
        Path target = cast(Path) obj;
        //check leading separators and hash code
        if ((separators & HASH_MASK) !is (target.separators & HASH_MASK))
            return false;
        String[] targetSegments = target.segments_;
        int i = segments_.length;
        //check segment count
        if (i !is targetSegments.length)
            return false;
        //check segments in reverse order - later segments more likely to differ
        while (--i >= 0)
            if (!segments_[i].equals(targetSegments[i]))
                return false;
        //check device last (least likely to differ)
        return device is target.device || (device !is null && device.equals(target.device));
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#getDevice
     */
    public String getDevice() {
        return device;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#getFileExtension
     */
    public String getFileExtension() {
        if (hasTrailingSeparator()) {
            return null;
        }
        String lastSegment = lastSegment();
        if (lastSegment is null) {
            return null;
        }
        int index = lastSegment.lastIndexOf('.');
        if (index is -1) {
            return null;
        }
        return lastSegment.substring(index + 1);
    }

    /* (Intentionally not included in javadoc)
     * Computes the hash code for this object.
     */
    public override hash_t toHash() {
        return separators & HASH_MASK;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#hasTrailingSeparator2
     */
    public bool hasTrailingSeparator() {
        return (separators & HAS_TRAILING) !is 0;
    }

    /*
     * Initialize the current path with the given string.
     */
    private IPath initialize(String deviceString, String path) {
        //Assert.isNotNull(path); // allow for DWT
        this.device = deviceString;

        path = collapseSlashes(path);
        int len = path.length;

        //compute the separators array
        if (len < 2) {
            if (len is 1 && path.charAt(0) is SEPARATOR) {
                this.separators = HAS_LEADING;
            } else {
                this.separators = 0;
            }
        } else {
            bool hasLeading = path.charAt(0) is SEPARATOR;
            bool isUNC = hasLeading && path.charAt(1) is SEPARATOR;
            //UNC path of length two has no trailing separator
            bool hasTrailing = !(isUNC && len is 2) && path.charAt(len - 1) is SEPARATOR;
            separators = hasLeading ? HAS_LEADING : 0;
            if (isUNC)
                separators |= IS_UNC;
            if (hasTrailing)
                separators |= HAS_TRAILING;
        }
        //compute segments and ensure canonical form
        segments_ = computeSegments(path);
        if (!canonicalize()) {
            //compute hash now because canonicalize didn't need to do it
            separators = (separators & ALL_SEPARATORS) | (computeHashCode() << 3);
        }
        return this;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#isAbsolute
     */
    public bool isAbsolute() {
        //it's absolute if it has a leading separator
        return (separators & HAS_LEADING) !is 0;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#isEmpty
     */
    public bool isEmpty() {
        //true if no segments and no leading prefix
        return segments_.length is 0 && ((separators & ALL_SEPARATORS) !is HAS_LEADING);

    }

    /* (Intentionally not included in javadoc)
     * @see IPath#isPrefixOf
     */
    public bool isPrefixOf(IPath anotherPath) {
        if (device is null) {
            if (anotherPath.getDevice() !is null) {
                return false;
            }
        } else {
            if (!device.equalsIgnoreCase(anotherPath.getDevice())) {
                return false;
            }
        }
        if (isEmpty() || (isRoot() && anotherPath.isAbsolute())) {
            return true;
        }
        int len = segments_.length;
        if (len > anotherPath.segmentCount()) {
            return false;
        }
        for (int i = 0; i < len; i++) {
            if (!segments_[i].equals(anotherPath.segment(i)))
                return false;
        }
        return true;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#isRoot
     */
    public bool isRoot() {
        //must have no segments, a leading separator, and not be a UNC path.
        return this is ROOT || (segments_.length is 0 && ((separators & ALL_SEPARATORS) is HAS_LEADING));
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#isUNC
     */
    public bool isUNC() {
        if (device !is null)
            return false;
        return (separators & IS_UNC) !is 0;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#isValidPath(String)
     */
    public bool isValidPath(String path) {
        Path test = new Path(path);
        for (int i = 0, max = test.segmentCount(); i < max; i++)
            if (!isValidSegment(test.segment(i)))
                return false;
        return true;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#isValidSegment(String)
     */
    public bool isValidSegment(String segment) {
        int size = segment.length;
        if (size is 0)
            return false;
        for (int i = 0; i < size; i++) {
            char c = segment.charAt(i);
            if (c is '/')
                return false;
            if (WINDOWS && (c is '\\' || c is ':'))
                return false;
        }
        return true;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#lastSegment()
     */
    public String lastSegment() {
        int len = segments_.length;
        return len is 0 ? null : segments_[len - 1];
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#makeAbsolute()
     */
    public IPath makeAbsolute() {
        if (isAbsolute()) {
            return this;
        }
        Path result = new Path(device, segments_, separators | HAS_LEADING);
        //may need canonicalizing if it has leading ".." or "." segments
        if (result.segmentCount() > 0) {
            String first = result.segment(0);
            if (first.equals("..") || first.equals(".")) { //$NON-NLS-1$ //$NON-NLS-2$
                result.canonicalize();
            }
        }
        return result;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#makeRelative()
     */
    public IPath makeRelative() {
        if (!isAbsolute()) {
            return this;
        }
        return new Path(device, segments_, separators & HAS_TRAILING);
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#makeUNC(bool)
     */
    public IPath makeUNC(bool toUNC) {
        // if we are already in the right form then just return
        if (!(toUNC ^ isUNC()))
            return this;

        int newSeparators = this.separators;
        if (toUNC) {
            newSeparators |= HAS_LEADING | IS_UNC;
        } else {
            //mask out the UNC bit
            newSeparators &= HAS_LEADING | HAS_TRAILING;
        }
        return new Path(toUNC ? null : device, segments_, newSeparators);
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#matchingFirstSegments(IPath)
     */
    public int matchingFirstSegments(IPath anotherPath) {
        Assert.isNotNull( cast(Object) anotherPath);
        int anotherPathLen = anotherPath.segmentCount();
        int max = Math.min(segments_.length, anotherPathLen);
        int count = 0;
        for (int i = 0; i < max; i++) {
            if (!segments_[i].equals(anotherPath.segment(i))) {
                return count;
            }
            count++;
        }
        return count;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#removeFileExtension()
     */
    public IPath removeFileExtension() {
        String extension = getFileExtension();
        if (extension is null || extension.equals("")) { //$NON-NLS-1$
            return this;
        }
        String lastSegment = lastSegment();
        int index = lastSegment.lastIndexOf(extension) - 1;
        return removeLastSegments(1).append(lastSegment.substring(0, index));
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#removeFirstSegments(int)
     */
    public IPath removeFirstSegments(int count) {
        if (count is 0)
            return this;
        if (count >= segments_.length) {
            return new Path(device, NO_SEGMENTS, 0);
        }
        Assert.isLegal(count > 0);
        int newSize = segments_.length - count;
        String[] newSegments = new String[newSize];
        System.arraycopy(this.segments_, count, newSegments, 0, newSize);

        //result is always a relative path
        return new Path(device, newSegments, separators & HAS_TRAILING);
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#removeLastSegments(int)
     */
    public IPath removeLastSegments(int count) {
        if (count is 0)
            return this;
        if (count >= segments_.length) {
            //result will have no trailing separator
            return new Path(device, NO_SEGMENTS, separators & (HAS_LEADING | IS_UNC));
        }
        Assert.isLegal(count > 0);
        int newSize = segments_.length - count;
        String[] newSegments = new String[newSize];
        System.arraycopy(this.segments_, 0, newSegments, 0, newSize);
        return new Path(device, newSegments, separators);
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#removeTrailingSeparator()
     */
    public IPath removeTrailingSeparator() {
        if (!hasTrailingSeparator()) {
            return this;
        }
        return new Path(device, segments_, separators & (HAS_LEADING | IS_UNC));
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#segment(int)
     */
    public String segment(int index) {
        if (index >= segments_.length)
            return null;
        return segments_[index];
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#segmentCount()
     */
    public int segmentCount() {
        return segments_.length;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#segments()
     */
    public String[] segments() {
        String[] segmentCopy = new String[](segments_.length);
        System.arraycopy(segments_, 0, segmentCopy, 0, segments_.length);
        return segmentCopy;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#setDevice(String)
     */
    public IPath setDevice(String value) {
        if (value !is null) {
            Assert.isTrue(value.indexOf(IPath.DEVICE_SEPARATOR) is (value.length - 1), "Last character should be the device separator"); //$NON-NLS-1$
        }
        //return the receiver if the device is the same
        if (value is device || (value !is null && value.equals(device)))
            return this;

        return new Path(value, segments_, separators);
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#toFile()
     */
    public FilePath toFile() {
        return new FilePath(tango.io.Path.standard(toOSString()));
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#toOSString()
     */
    public String toOSString() {
        //Note that this method is identical to toString except
        //it uses the OS file separator instead of the path separator
        int resultSize = computeLength();
        if (resultSize <= 0)
            return EMPTY_STRING;
        char FILE_SEPARATOR = FileConst.PathSeparatorChar;
        char[] result = new char[resultSize];
        int offset = 0;
        if (device !is null) {
            int size = device.length;
            device.getChars(0, size, result, offset);
            offset += size;
        }
        if ((separators & HAS_LEADING) !is 0)
            result[offset++] = FILE_SEPARATOR;
        if ((separators & IS_UNC) !is 0)
            result[offset++] = FILE_SEPARATOR;
        int len = segments_.length - 1;
        if (len >= 0) {
            //append all but the last segment, with separators
            for (int i = 0; i < len; i++) {
                int size = segments_[i].length;
                segments_[i].getChars(0, size, result, offset);
                offset += size;
                result[offset++] = FILE_SEPARATOR;
            }
            //append the last segment
            int size = segments_[len].length;
            segments_[len].getChars(0, size, result, offset);
            offset += size;
        }
        if ((separators & HAS_TRAILING) !is 0)
            result[offset++] = FILE_SEPARATOR;
        return result;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#toPortableString()
     */
    public String toPortableString() {
        int resultSize = computeLength();
        if (resultSize <= 0)
            return EMPTY_STRING;
        StringBuffer result = new StringBuffer(resultSize);
        if (device !is null)
            result.append(device);
        if ((separators & HAS_LEADING) !is 0)
            result.append(SEPARATOR);
        if ((separators & IS_UNC) !is 0)
            result.append(SEPARATOR);
        int len = segments_.length;
        //append all segments with separators
        for (int i = 0; i < len; i++) {
            if (segments_[i].indexOf(DEVICE_SEPARATOR) >= 0)
                encodeSegment(segments_[i], result);
            else
                result.append(segments_[i]);
            if (i < len - 1 || (separators & HAS_TRAILING) !is 0)
                result.append(SEPARATOR);
        }
        return result.toString();
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#toString()
     */
    public override String toString() {
        int resultSize = computeLength();
        if (resultSize <= 0)
            return EMPTY_STRING;
        char[] result = new char[resultSize];
        int offset = 0;
        if (device !is null) {
            int size = device.length;
            device.getChars(0, size, result, offset);
            offset += size;
        }
        if ((separators & HAS_LEADING) !is 0)
            result[offset++] = SEPARATOR;
        if ((separators & IS_UNC) !is 0)
            result[offset++] = SEPARATOR;
        int len = segments_.length - 1;
        if (len >= 0) {
            //append all but the last segment, with separators
            for (int i = 0; i < len; i++) {
                int size = segments_[i].length;
                segments_[i].getChars(0, size, result, offset);
                offset += size;
                result[offset++] = SEPARATOR;
            }
            //append the last segment
            int size = segments_[len].length;
            segments_[len].getChars(0, size, result, offset);
            offset += size;
        }
        if ((separators & HAS_TRAILING) !is 0)
            result[offset++] = SEPARATOR;
        return result;
    }

    /* (Intentionally not included in javadoc)
     * @see IPath#uptoSegment(int)
     */
    public IPath uptoSegment(int count) {
        if (count is 0)
            return new Path(device, NO_SEGMENTS, separators & (HAS_LEADING | IS_UNC));
        if (count >= segments_.length)
            return this;
        Assert.isTrue(count > 0, "Invalid parameter to Path.uptoSegment"); //$NON-NLS-1$
        String[] newSegments = new String[count];
        System.arraycopy(segments_, 0, newSegments, 0, count);
        return new Path(device, newSegments, separators);
    }
}
