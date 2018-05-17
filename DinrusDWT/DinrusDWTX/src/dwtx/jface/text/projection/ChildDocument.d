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
module dwtx.jface.text.projection.ChildDocument;

import dwtx.jface.text.projection.ProjectionMapping; // packageimport
import dwtx.jface.text.projection.ChildDocumentManager; // packageimport
import dwtx.jface.text.projection.SegmentUpdater; // packageimport
import dwtx.jface.text.projection.Segment; // packageimport
import dwtx.jface.text.projection.ProjectionDocument; // packageimport
import dwtx.jface.text.projection.FragmentUpdater; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentEvent; // packageimport
import dwtx.jface.text.projection.IMinimalMapping; // packageimport
import dwtx.jface.text.projection.Fragment; // packageimport
import dwtx.jface.text.projection.ProjectionTextStore; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentManager; // packageimport


import dwt.dwthelper.utils;

import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.Position;

/**
 * Implementation of a child document based on
 * {@link dwtx.jface.text.projection.ProjectionDocument}. This class
 * exists for compatibility reasons.
 * <p>
 * Internal class. This class is not intended to be used by clients.</p>
 *
 * @since 3.0
 * @noinstantiate This class is not intended to be instantiated by clients.
 * @noextend This class is not intended to be subclassed by clients.
 */
public class ChildDocument : ProjectionDocument {

    /**
     * Position reflecting a visible region. The exclusive end offset of the position
     * is considered being overlapping with the visible region.
     */
    static private class VisibleRegion : Position {

        /**
         * Creates a new visible region.
         *
         * @param regionOffset the offset of the region
         * @param regionLength the length of the region
         */
        public this(int regionOffset, int regionLength) {
            super(regionOffset, regionLength);
        }

        /**
         * If <code>regionOffset</code> is the end of the visible region and the <code>regionLength is 0</code>,
         * the <code>regionOffset</code> is considered overlapping with the visible region.
         *
         * @see dwtx.jface.text.Position#overlapsWith(int, int)
         */
        public bool overlapsWith(int regionOffset, int regionLength) {
            bool appending= (regionOffset is offset + length) && regionLength is 0;
            return appending || super.overlapsWith(regionOffset, regionLength);
        }
    }

    /**
     * Creates a new child document.
     *
     * @param masterDocument @inheritDoc
     */
    public this(IDocument masterDocument) {
        super(masterDocument);
    }

    /**
     * Returns the parent document of this child document.
     *
     * @return the parent document of this child document
     * @see ProjectionDocument#getMasterDocument()
     */
    public IDocument getParentDocument() {
        return getMasterDocument();
    }

    /**
     * Sets the parent document range covered by this child document to the
     * given range.
     *
     * @param offset the offset of the range
     * @param length the length of the range
     * @throws BadLocationException if the given range is not valid
     */
    public void setParentDocumentRange(int offset, int length)  {
        replaceMasterDocumentRanges(offset, length);
    }

    /**
     * Returns the parent document range of this child document.
     *
     * @return the parent document range of this child document
     */
    public Position getParentDocumentRange() {
        IRegion coverage= getDocumentInformationMapping().getCoverage();
        return new VisibleRegion(coverage.getOffset(), coverage.getLength());
    }
}
