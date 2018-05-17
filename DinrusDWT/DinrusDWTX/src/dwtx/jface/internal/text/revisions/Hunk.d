/*******************************************************************************
 * Copyright (c) 2006 IBM Corporation and others.
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
module dwtx.jface.internal.text.revisions.Hunk;

import dwtx.jface.internal.text.revisions.HunkComputer; // packageimport
import dwtx.jface.internal.text.revisions.LineIndexOutOfBoundsException; // packageimport
import dwtx.jface.internal.text.revisions.Colors; // packageimport
import dwtx.jface.internal.text.revisions.ChangeRegion; // packageimport
import dwtx.jface.internal.text.revisions.Range; // packageimport
import dwtx.jface.internal.text.revisions.RevisionPainter; // packageimport
import dwtx.jface.internal.text.revisions.RevisionSelectionProvider; // packageimport

import dwt.dwthelper.utils;
import tango.text.convert.Format;

import dwtx.core.runtime.Assert;

/**
 * A hunk describes a contiguous range of changed, added or deleted lines. <code>Hunk</code>s are separated by
 * one or more unchanged lines.
 *
 * @since 3.3
 */
public final class Hunk {
    /**
     * The line at which the hunk starts in the current document. Must be in
     * <code>[0, numberOfLines]</code> &ndash; note the inclusive end; there may be a hunk with
     * <code>line is numberOfLines</code> to describe deleted lines at then end of the document.
     */
    public const int line;
    /**
     * The difference in lines compared to the corresponding line range in the original. Positive
     * for added lines, negative for deleted lines.
     */
    public const int delta;
    /** The number of changed lines in this hunk, must be &gt;= 0. */
    public const int changed;

    /**
     * Creates a new hunk.
     *
     * @param line the line at which the hunk starts, must be &gt;= 0
     * @param delta the difference in lines compared to the original
     * @param changed the number of changed lines in this hunk, must be &gt;= 0
     */
    public this(int line, int delta, int changed) {
        Assert.isLegal(line >= 0);
        Assert.isLegal(changed >= 0);
        this.line= line;
        this.delta= delta;
        this.changed= changed;
    }

    /*
     * @see java.lang.Object#toString()
     */
    public override String toString() {
        return Format("Hunk [{}>{}{}{}]", line, changed, delta < 0 ? "-" : "+", Math.abs(delta) ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
    }

    /*
     * @see java.lang.Object#hashCode()
     */
    public override hash_t toHash() {
        final int prime= 31;
        int result= 1;
        result= prime * result + changed;
        result= prime * result + delta;
        result= prime * result + line;
        return result;
    }

    /*
     * @see java.lang.Object#equals(java.lang.Object)
     */
    public override int opEquals(Object obj) {
        if (obj is this)
            return true;
        if ( Hunk other= cast(Hunk)obj ) {
            return other.line is this.line && other.delta is this.delta && other.changed is this.changed;
        }
        return false;
    }
}
