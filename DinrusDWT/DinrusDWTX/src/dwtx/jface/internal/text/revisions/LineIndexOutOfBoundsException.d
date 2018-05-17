/*******************************************************************************
 * Copyright (c) 2005, 2006 IBM Corporation and others.
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
module dwtx.jface.internal.text.revisions.LineIndexOutOfBoundsException;

import dwtx.jface.internal.text.revisions.HunkComputer; // packageimport
import dwtx.jface.internal.text.revisions.Hunk; // packageimport
import dwtx.jface.internal.text.revisions.Colors; // packageimport
import dwtx.jface.internal.text.revisions.ChangeRegion; // packageimport
import dwtx.jface.internal.text.revisions.Range; // packageimport
import dwtx.jface.internal.text.revisions.RevisionPainter; // packageimport
import dwtx.jface.internal.text.revisions.RevisionSelectionProvider; // packageimport


import dwt.dwthelper.utils;

/**
 * Thrown to indicate that an attempt to create or modify a {@link Range} failed because it would
 * have resulted in an illegal range. A range is illegal if its length is &lt;= 0 or if its start
 * line is &lt; 0.
 *
 * @since 3.2
 */
public final class LineIndexOutOfBoundsException : IndexOutOfBoundsException {
    private static const long serialVersionUID= 1L;

    /**
     * Constructs an <code>LineIndexOutOfBoundsException</code> with no detail message.
     */
    public this() {
        super();
    }

    /**
     * Constructs an <code>LineIndexOutOfBoundsException</code> with the specified detail message.
     *
     * @param s the detail message.
     */
    public this(String s) {
        super(s);
    }

    /**
     * Constructs a new <code>LineIndexOutOfBoundsException</code>
     * object with an argument indicating the illegal index.
     *
     * @param index the illegal index.
     */
    public this(int index) {
        super("Line index out of range: " ~ Integer.toString(index)); //$NON-NLS-1$
    }
}
