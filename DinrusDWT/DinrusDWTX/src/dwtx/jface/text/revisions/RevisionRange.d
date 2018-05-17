/*******************************************************************************
 * Copyright (c) 2006, 2008 IBM Corporation and others.
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
module dwtx.jface.text.revisions.RevisionRange;

import dwtx.jface.text.revisions.IRevisionListener; // packageimport
import dwtx.jface.text.revisions.IRevisionRulerColumnExtension; // packageimport
import dwtx.jface.text.revisions.IRevisionRulerColumn; // packageimport
import dwtx.jface.text.revisions.RevisionEvent; // packageimport
import dwtx.jface.text.revisions.RevisionInformation; // packageimport
import dwtx.jface.text.revisions.Revision; // packageimport


import dwt.dwthelper.utils;
import tango.text.convert.Format;

import dwtx.core.runtime.Assert;
import dwtx.jface.text.source.ILineRange;


/**
 * An unmodifiable line range that belongs to a {@link Revision}.
 *
 * @since 3.3
 * @noinstantiate This class is not intended to be instantiated by clients.
 */
public final class RevisionRange : ILineRange {
    private const Revision fRevision;
    private const int fStartLine;
    private const int fNumberOfLines;

    this(Revision revision, ILineRange range) {
        Assert.isLegal(revision !is null);
        fRevision= revision;
        fStartLine= range.getStartLine();
        fNumberOfLines= range.getNumberOfLines();
    }

    /**
     * Returns the revision that this range belongs to.
     *
     * @return the revision that this range belongs to
     */
    public Revision getRevision() {
        return fRevision;
    }

    /*
     * @see dwtx.jface.text.source.ILineRange#getStartLine()
     */
    public int getStartLine() {
        return fStartLine;
    }

    /*
     * @see dwtx.jface.text.source.ILineRange#getNumberOfLines()
     */
    public int getNumberOfLines() {
        return fNumberOfLines;
    }

    /*
     * @see java.lang.Object#toString()
     */
    public override String toString() {
        return Format("RevisionRange [{}, [{}+{})]", fRevision.toString(), getStartLine(), getNumberOfLines()); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$
    }
}
