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
module dwtx.core.runtime.QualifiedName;

import dwtx.core.runtime.Assert;

import dwt.dwthelper.utils;

/**
 * Qualified names are two-part names: qualifier and local name.
 * The qualifier must be in URI form (see RFC2396).
 * Note however that the qualifier may be <code>null</code> if
 * the default name space is being used.  The empty string is not
 * a valid local name.
 * <p>
 * This class can be used without OSGi running.
 * </p><p>
 * This class is not intended to be subclassed by clients.
 * </p>
 * @noextend This class is not intended to be subclassed by clients.
 */
public final class QualifiedName {

    /** Qualifier part (potentially <code>null</code>). */
    /*package*/
    String qualifier = null;

    /** Local name part. */
    /*package*/
    String localName = null;

    /**
     * Creates and returns a new qualified name with the given qualifier
     * and local name.  The local name must not be the empty string.
     * The qualifier may be <code>null</code>.
     * <p>
     * Clients may instantiate.
     * </p>
     * @param qualifier the qualifier string, or <code>null</code>
     * @param localName the local name string
     */
    public this(String qualifier, String localName) {
        Assert.isLegal(localName !is null && localName.length !is 0);
        this.qualifier = qualifier;
        this.localName = localName;
    }

    /**
     * Returns whether this qualified name is equivalent to the given object.
     * <p>
     * Qualified names are equal if and only if they have the same
     * qualified parts and local parts.
     * Qualified names are not equal to objects other than qualified names.
     * </p>
     *
     * @param obj the object to compare to
     * @return <code>true</code> if these are equivalent qualified
     *    names, and <code>false</code> otherwise
     */
    public override int opEquals(Object obj) {
        if (obj is this) {
            return true;
        }
        if (!(cast(QualifiedName)obj )) {
            return false;
        }
        QualifiedName qName = cast(QualifiedName) obj;
        /* There may or may not be a qualifier */
        if (qualifier is null && qName.getQualifier() !is null) {
            return false;
        }
        if (qualifier !is null && !qualifier.equals(qName.getQualifier())) {
            return false;
        }
        return localName.equals(qName.getLocalName());
    }

    /**
     * Returns the local part of this name.
     *
     * @return the local name string
     */
    public String getLocalName() {
        return localName;
    }

    /**
     * Returns the qualifier part for this qualified name, or <code>null</code>
     * if none.
     *
     * @return the qualifier string, or <code>null</code>
     */
    public String getQualifier() {
        return qualifier;
    }

    /* (Intentionally omitted from javadoc)
     * Implements the method <code>Object.hashCode</code>.
     *
     * Returns the hash code for this qualified name.
     */
    public override hash_t toHash() {
        return (qualifier is null ? 0 : .toHash(qualifier)) + .toHash(localName);
    }

    /**
     * Converts this qualified name into a string, suitable for
     * debug purposes only.
     */
    public override String toString() {
        return (getQualifier() is null ? "" : getQualifier() ~ ':') ~ getLocalName(); //$NON-NLS-1$
    }
}
