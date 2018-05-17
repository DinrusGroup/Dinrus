/*******************************************************************************
 * Copyright (c) 2000, 2005 IBM Corporation and others.
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
module dwtx.jface.text.projection.ProjectionTextStore;

import dwtx.jface.text.projection.ProjectionMapping; // packageimport
import dwtx.jface.text.projection.ChildDocumentManager; // packageimport
import dwtx.jface.text.projection.SegmentUpdater; // packageimport
import dwtx.jface.text.projection.Segment; // packageimport
import dwtx.jface.text.projection.ProjectionDocument; // packageimport
import dwtx.jface.text.projection.FragmentUpdater; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentEvent; // packageimport
import dwtx.jface.text.projection.ChildDocument; // packageimport
import dwtx.jface.text.projection.IMinimalMapping; // packageimport
import dwtx.jface.text.projection.Fragment; // packageimport
import dwtx.jface.text.projection.ProjectionDocumentManager; // packageimport


import dwt.dwthelper.utils;


import dwtx.jface.text.BadLocationException;
import dwtx.jface.text.IDocument;
import dwtx.jface.text.IRegion;
import dwtx.jface.text.ITextStore;
import dwtx.jface.text.Region;


/**
 * A text store representing the projection defined by the given document
 * information mapping.
 *
 * @since 3.0
 */
class ProjectionTextStore : ITextStore {

    /**
     * Implementation of {@link IRegion} that can be reused
     * by setting the offset and the length.
     */
    private static class ReusableRegion : IRegion {

        private int fOffset;
        private int fLength;

        /*
         * @see dwtx.jface.text.IRegion#getLength()
         */
        public int getLength() {
            return fLength;
        }

        /*
         * @see dwtx.jface.text.IRegion#getOffset()
         */
        public int getOffset() {
            return fOffset;
        }

        /**
         * Updates this region.
         *
         * @param offset the new offset
         * @param length the new length
         */
        public void update(int offset, int length) {
            fOffset= offset;
            fLength= length;
        }
    }

    /** The master document */
    private IDocument fMasterDocument;
    /** The document information mapping */
    private IMinimalMapping fMapping;
    /** Internal region used for querying the mapping. */
    private ReusableRegion fReusableRegion;


    /**
     * Creates a new projection text store for the given master document and
     * the given document information mapping.
     *
     * @param masterDocument the master document
     * @param mapping the document information mapping
     */
    public this(IDocument masterDocument, IMinimalMapping mapping) {
        fReusableRegion= new ReusableRegion();
        fMasterDocument= masterDocument;
        fMapping= mapping;
    }

    private void internalError() {
        throw new IllegalStateException();
    }

    /*
     * @see dwtx.jface.text.ITextStore#set(java.lang.String)
     */
    public void set(String contents) {

        IRegion masterRegion= fMapping.getCoverage();
        if (masterRegion is null)
            internalError();

        try {
            fMasterDocument.replace(masterRegion.getOffset(), masterRegion.getLength(), contents);
        } catch (BadLocationException e) {
            internalError();
        }
    }

    /*
     * @see dwtx.jface.text.ITextStore#replace(int, int, java.lang.String)
     */
    public void replace(int offset, int length, String text) {
        fReusableRegion.update(offset, length);
        try {
            IRegion masterRegion= fMapping.toOriginRegion(fReusableRegion);
            fMasterDocument.replace(masterRegion.getOffset(), masterRegion.getLength(), text);
        } catch (BadLocationException e) {
            internalError();
        }
    }

    /*
     * @see dwtx.jface.text.ITextStore#getLength()
     */
    public int getLength() {
        return fMapping.getImageLength();
    }

    /*
     * @see dwtx.jface.text.ITextStore#get(int)
     */
    public char get(int offset) {
        try {
            int originOffset= fMapping.toOriginOffset(offset);
            return fMasterDocument.getChar(originOffset);
        } catch (BadLocationException e) {
            internalError();
        }

        // unreachable
        return cast(wchar) 0;
    }

    /*
     * @see ITextStore#get(int, int)
     */
    public String get(int offset, int length) {
        try {
            IRegion[] fragments= fMapping.toExactOriginRegions(new Region(offset, length));
            StringBuffer buffer= new StringBuffer();
            for (int i= 0; i < fragments.length; i++) {
                IRegion fragment= fragments[i];
                buffer.append(fMasterDocument.get(fragment.getOffset(), fragment.getLength()));
            }
            return buffer.toString();
        } catch (BadLocationException e) {
            internalError();
        }

        // unreachable
        return null;
    }
}
